import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

// ── Adzuna config ─────────────────────────────────────────────────────────────
const ADZUNA_BASE = "https://api.adzuna.com/v1/api/jobs";
const SEARCH_QUERIES = [
  "QA automation",
  "automation tester",
  "SDET",
  "test automation engineer",
];
const RESULTS_PER_PAGE = 50;
const PURGE_DAYS = 45;

function getCountries(): string[] {
  return (process.env.ADZUNA_COUNTRIES || "in,us")
    .split(",")
    .map((c) => c.trim())
    .filter(Boolean);
}

// ── Service-role client (bypasses RLS — safe for server-only cron) ────────────
function adminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) throw new Error("Supabase env vars missing");
  return createClient(url, key, { auth: { persistSession: false } });
}

// ── Adzuna response shape ─────────────────────────────────────────────────────
interface AdzunaCompany { display_name?: string }
interface AdzunaLocation { display_name?: string }
interface AdzunaJob {
  id?: string;
  title?: string;
  company?: AdzunaCompany;
  location?: AdzunaLocation;
  description?: string;
  redirect_url?: string;
  created?: string;
}
interface AdzunaResponse { results?: AdzunaJob[]; count?: number }

// ── Normalize one Adzuna result to our DB shape ───────────────────────────────
function normalize(job: AdzunaJob) {
  const locationStr = job.location?.display_name || "";
  const isRemote =
    /remote/i.test(locationStr) || /remote/i.test(job.title || "");

  return {
    title: (job.title || "Untitled").trim().slice(0, 255),
    company: (job.company?.display_name || "Unknown Company").trim().slice(0, 255),
    location: (locationStr || "Not specified").trim().slice(0, 255),
    // Strip HTML tags, cap at 500 chars
    description: (job.description || "")
      .replace(/<[^>]*>/g, " ")
      .replace(/\s+/g, " ")
      .trim()
      .slice(0, 500),
    apply_url: job.redirect_url || null,
    source: "adzuna" as const,
    job_type: "regular" as const,
    is_remote: isRemote,
    is_active: true,
    posted_at: job.created ? new Date(job.created).toISOString() : new Date().toISOString(),
    fetched_at: new Date().toISOString(),
  };
}

// ── Fetch one page from Adzuna ────────────────────────────────────────────────
async function fetchAdzunaPage(
  country: string,
  query: string
): Promise<AdzunaJob[]> {
  const appId = process.env.ADZUNA_APP_ID;
  const appKey = process.env.ADZUNA_APP_KEY;
  if (!appId || !appKey) {
    console.error("ADZUNA_APP_ID or ADZUNA_APP_KEY not set");
    return [];
  }

  const url = new URL(`${ADZUNA_BASE}/${country}/search/1`);
  url.searchParams.set("app_id", appId);
  url.searchParams.set("app_key", appKey);
  url.searchParams.set("what", query);
  url.searchParams.set("results_per_page", String(RESULTS_PER_PAGE));
  url.searchParams.set("content-type", "application/json");

  try {
    const res = await fetch(url.toString(), {
      cache: "no-store",
      signal: AbortSignal.timeout(15_000),
    });
    if (!res.ok) {
      console.error(
        `Adzuna error ${res.status} for query="${query}" country=${country}`
      );
      return [];
    }
    const data: AdzunaResponse = await res.json();
    return data.results || [];
  } catch (err) {
    console.error(`Adzuna fetch failed for query="${query}" country=${country}:`, err);
    return [];
  }
}

// ── Cron handler ──────────────────────────────────────────────────────────────
export async function GET(request: NextRequest) {
  // Verify CRON_SECRET (Vercel injects it automatically for cron routes)
  const authorization = request.headers.get("authorization");
  const cronSecret = process.env.CRON_SECRET;
  if (!cronSecret || authorization !== `Bearer ${cronSecret}`) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = adminClient();
  let fetched = 0;
  let inserted = 0;
  let skipped = 0;
  const errors: string[] = [];

  try {
    const countries = getCountries();

    // Collect all jobs from Adzuna, deduplicating by apply_url within this batch
    const seen = new Set<string>();
    const allJobs: ReturnType<typeof normalize>[] = [];

    for (const country of countries) {
      for (const query of SEARCH_QUERIES) {
        const results = await fetchAdzunaPage(country, query);
        fetched += results.length;

        for (const job of results) {
          const norm = normalize(job);
          // Skip jobs without an apply_url (can't deduplicate)
          if (!norm.apply_url) { skipped++; continue; }
          if (seen.has(norm.apply_url)) { skipped++; continue; }
          seen.add(norm.apply_url);
          allJobs.push(norm);
        }
      }
    }

    // Fetch existing adzuna apply_urls to deduplicate before inserting
    const allUrls = allJobs.map((j) => j.apply_url).filter(Boolean) as string[];
    const existingUrls = new Set<string>();

    if (allUrls.length > 0) {
      const { data: existing } = await supabase
        .from("jobs")
        .select("apply_url")
        .eq("source", "adzuna")
        .in("apply_url", allUrls);
      (existing || []).forEach((r: { apply_url: string }) => existingUrls.add(r.apply_url));
    }

    const newJobs = allJobs.filter(
      (j) => j.apply_url && !existingUrls.has(j.apply_url)
    );

    // Insert new jobs in chunks of 50
    const CHUNK = 50;
    for (let i = 0; i < newJobs.length; i += CHUNK) {
      const chunk = newJobs.slice(i, i + CHUNK);
      const { error } = await supabase.from("jobs").insert(chunk);
      if (error) {
        console.error("Insert error:", error.message);
        errors.push(error.message);
      } else {
        inserted += chunk.length;
      }
    }
    skipped += allJobs.length - newJobs.length;

    // Purge Adzuna jobs older than PURGE_DAYS days
    const cutoff = new Date(Date.now() - PURGE_DAYS * 24 * 60 * 60 * 1000).toISOString();
    const { error: purgeError } = await supabase
      .from("jobs")
      .delete()
      .eq("source", "adzuna")
      .lt("posted_at", cutoff);

    if (purgeError) {
      console.error("Purge error:", purgeError.message);
      errors.push(`Purge: ${purgeError.message}`);
    }

    return NextResponse.json(
      { fetched, inserted, skipped, errors: errors.length ? errors : undefined },
      { status: 200 }
    );
  } catch (err) {
    const message = err instanceof Error ? err.message : "Unknown error";
    console.error("Cron fetch-jobs fatal error:", message);
    return NextResponse.json(
      { fetched, inserted, skipped, error: message },
      { status: 500 }
    );
  }
}
