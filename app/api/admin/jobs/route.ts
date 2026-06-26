import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ── GET  /api/admin/jobs  — list all jobs (admin only) ────────────────────────
export async function GET() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data, error } = await supabase
    .from("jobs")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(500);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ data });
}

// ── POST  /api/admin/jobs  — create a new manual/referral job ─────────────────
export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const {
    title, company, location, description,
    apply_url, job_type, is_remote,
    experience_level, salary, posted_at,
    referral_contact, referral_note,
  } = body as Record<string, string | boolean | null | undefined>;

  if (!title || !company || !location || !description) {
    return NextResponse.json({ error: "title, company, location, and description are required" }, { status: 400 });
  }
  if (job_type === "regular" && !apply_url) {
    return NextResponse.json({ error: "apply_url is required for regular jobs" }, { status: 400 });
  }
  if (job_type === "referral" && !referral_contact) {
    return NextResponse.json({ error: "referral_contact is required for referral jobs" }, { status: 400 });
  }

  const source = job_type === "referral" ? "referral" : "manual";

  const { data, error } = await supabase
    .from("jobs")
    .insert({
      title,
      company,
      location,
      description,
      apply_url: apply_url || null,
      source,
      job_type: job_type || "regular",
      is_remote: Boolean(is_remote),
      experience_level: experience_level || null,
      salary: salary || null,
      posted_at: posted_at || new Date().toISOString(),
      fetched_at: null,
      referral_contact: referral_contact || null,
      referral_note: referral_note || null,
      is_active: true,
      updated_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ data }, { status: 201 });
}
