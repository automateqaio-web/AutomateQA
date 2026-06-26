import type { Metadata } from "next";
import { Briefcase } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Job } from "@/types";
import JobFilters from "@/components/jobs/JobFilters";

export const revalidate = 3600; // re-render at most once per hour (ISR)

const SITE = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export const metadata: Metadata = {
  title: "QA Jobs Board — Automation Testing & SDET Jobs | AutomateQA",
  description:
    "Browse the latest QA automation, SDET, and test engineering jobs — automatically updated daily. Filter by remote, referral, experience level and more.",
  keywords: [
    "QA automation jobs",
    "SDET jobs",
    "automation tester jobs",
    "test automation engineer jobs",
    "QA engineer jobs India",
    "software testing jobs remote",
    "QA jobs 2025",
    "automation testing career",
  ],
  alternates: { canonical: `${SITE}/jobs` },
  robots: { index: true, follow: true },
  openGraph: {
    type: "website",
    url: `${SITE}/jobs`,
    title: "QA Jobs Board — Automation Testing & SDET Jobs | AutomateQA",
    description:
      "Browse the latest QA automation, SDET, and test engineering jobs — updated daily.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "QA Jobs Board — AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "QA Jobs Board — Automation Testing & SDET Jobs | AutomateQA",
    description: "Browse the latest QA automation, SDET, and test engineering jobs — updated daily.",
    images: ["/og-image.png"],
  },
};

async function getJobs(): Promise<Job[]> {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return [];
    const supabase = await createClient();
    const { data, error } = await supabase
      .from("jobs")
      .select("*")
      .eq("is_active", true)
      .order("posted_at", { ascending: false, nullsFirst: false })
      .limit(200);
    if (error) { console.error("Jobs fetch error:", error.message); return []; }
    return (data as Job[]) || [];
  } catch {
    return [];
  }
}

export default async function JobsPage() {
  const jobs = await getJobs();

  const schema = {
    "@context": "https://schema.org",
    "@type": "JobPosting",
    name: "QA Jobs Board — AutomateQA",
    description: "Daily updated QA automation, SDET, and test engineering job listings.",
    url: `${SITE}/jobs`,
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
      />

      <div className="min-h-screen pt-16">
        {/* ── Hero ───────────────────────────────────────────────────────── */}
        <div className="relative overflow-hidden py-16 sm:py-24">
          {/* layered backgrounds */}
          <div className="absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_50%_-10%,rgba(0,255,136,0.12)_0%,transparent_70%)]" />
          <div className="absolute inset-0 bg-[radial-gradient(ellipse_40%_40%_at_80%_50%,rgba(0,212,255,0.07)_0%,transparent_60%)]" />
          <div className="absolute inset-0 grid-bg opacity-40" />

          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
            {/* Badge */}
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/25 text-[#00FF88] text-xs font-bold tracking-widest uppercase mb-6">
              <span className="w-1.5 h-1.5 rounded-full bg-[#00FF88] animate-pulse" />
              Updated daily · Adzuna + Community referrals
            </div>

            <h1 className="text-5xl sm:text-6xl lg:text-7xl font-black text-white mb-5 leading-none tracking-tight">
              QA{" "}
              <span
                className="inline-block"
                style={{
                  background: "linear-gradient(135deg,#00FF88 0%,#00D4FF 50%,#A855F7 100%)",
                  WebkitBackgroundClip: "text",
                  WebkitTextFillColor: "transparent",
                  backgroundClip: "text",
                }}
              >
                Jobs
              </span>{" "}
              Board
            </h1>

            <p className="text-[#9CA3AF] text-lg sm:text-xl max-w-2xl mb-8 leading-relaxed">
              Hand-picked QA automation, SDET, and test engineering roles — automatically
              fetched from Adzuna and enriched with community referrals.
            </p>

            {/* Stats pills */}
            {jobs.length > 0 && (() => {
              const remote   = jobs.filter((j) => j.is_remote).length;
              const referral = jobs.filter((j) => j.job_type === "referral").length;
              return (
                <div className="flex flex-wrap gap-3">
                  {[
                    { label: "Active roles",   value: jobs.length,  color: "#00FF88" },
                    { label: "Remote jobs",    value: remote,       color: "#00D4FF" },
                    { label: "Referrals",      value: referral,     color: "#A855F7" },
                  ].map(({ label, value, color }) => (
                    <div
                      key={label}
                      className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white/5 border border-white/10 backdrop-blur-sm"
                    >
                      <span className="text-xl font-black" style={{ color }}>{value}</span>
                      <span className="text-xs text-[#9CA3AF] font-medium">{label}</span>
                    </div>
                  ))}
                </div>
              );
            })()}
          </div>
        </div>

        {/* ── Content ────────────────────────────────────────────────────── */}
        {jobs.length === 0 ? (
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-20">
            <div className="rounded-2xl border border-white/8 bg-[#111]/60 p-16 text-center">
              <div className="text-5xl mb-4">💼</div>
              <h3 className="text-xl font-bold text-white mb-2">No jobs listed yet</h3>
              <p className="text-[#9CA3AF] max-w-md mx-auto">
                Job listings are fetched automatically every day. Check back soon.
              </p>
            </div>
          </div>
        ) : (
          <JobFilters jobs={jobs} />
        )}
      </div>
    </>
  );
}
