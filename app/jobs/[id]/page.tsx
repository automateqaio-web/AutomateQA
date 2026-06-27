import type { Metadata } from "next";
import type { ElementType } from "react";
import { notFound } from "next/navigation";
import Link from "next/link";
import {
  ArrowLeft, MapPin, Clock, Wifi, DollarSign, ExternalLink,
  Mail, Link2, Briefcase, Building2, Star, Calendar, Globe,
  CheckCircle2, Users, Zap, BrainCircuit, BookOpen, ChevronRight,
} from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Job } from "@/types";
import { formatRelativeDate, formatExactDateTime } from "@/lib/utils";
import ShareButtons from "@/components/jobs/ShareButtons";
import JobDetailLogo from "@/components/jobs/JobDetailLogo";

const SITE = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

// ── Gradient helpers ──────────────────────────────────────────────────────────
const GRADIENTS: [string, string][] = [
  ["#00FF88", "#00D4FF"], ["#A855F7", "#EC4899"], ["#F97316", "#EF4444"],
  ["#3B82F6", "#06B6D4"], ["#EAB308", "#F97316"], ["#EC4899", "#8B5CF6"],
  ["#10B981", "#14B8A6"], ["#6366F1", "#3B82F6"],
];
function avatarColors(name: string): [string, string] {
  let h = 0;
  for (let i = 0; i < name.length; i++) h = name.charCodeAt(i) + ((h << 5) - h);
  return GRADIENTS[Math.abs(h) % GRADIENTS.length];
}

async function getJob(id: string): Promise<Job | null> {
  try {
    const supabase = await createClient();
    const { data, error } = await supabase
      .from("jobs").select("*").eq("id", id).eq("is_active", true).single();
    if (error || !data) return null;
    return data as Job;
  } catch { return null; }
}

export async function generateMetadata(
  { params }: { params: Promise<{ id: string }> }
): Promise<Metadata> {
  const { id } = await params;
  const job = await getJob(id);
  if (!job) return { title: "Job Not Found — AutomateQA" };
  const title = `${job.title} at ${job.company} — AutomateQA Jobs`;
  const description = job.description.slice(0, 160).replace(/\s+/g, " ").trim();
  return {
    title, description,
    alternates: { canonical: `${SITE}/jobs/${id}` },
    openGraph: { type: "website", url: `${SITE}/jobs/${id}`, title, description, images: [{ url: "/og-image.png", width: 1200, height: 630 }] },
    twitter: { card: "summary_large_image", title, description, images: ["/og-image.png"] },
  };
}

function getReferralHref(contact: string) {
  if (/^https?:\/\/(www\.)?linkedin\.com/i.test(contact)) return { href: contact, isEmail: false };
  return { href: `mailto:${contact}?subject=QA%20Referral%20Request`, isEmail: true };
}

// ── Full description renderer ─────────────────────────────────────────────────
function FullDescription({ text, accent }: { text: string; accent: string }) {
  type Row =
    | { kind: "label";  label: string; value: string }
    | { kind: "bullet"; content: string }
    | { kind: "text";   content: string };

  const LINE_LABEL_RE = /^([A-Za-z][a-zA-Z]*(?:[\s][A-Za-z][a-zA-Z]*){0,3}):\s*(.*)$/;

  // ── Inline-blob parser (no newlines) ─────────────────────────────────────
  // Matches ONLY single title-case words (≥3 chars, e.g. "Title:", "Required:",
  // "Timings:") to avoid greedy false positives like "Assurance Engineer
  // Availability Required:" being treated as a 4-word label. The preceding word
  // (e.g. "Availability" before "Required:") will appear as plain text, which
  // is acceptable for legacy blob data. New jobs stored via the fixed cron job
  // will have proper newlines and use the newline parser instead.
  function buildRowsInline(raw: string): Row[] {
    // [A-Z][a-zA-Z]{2,} = uppercase first letter + 2+ more letters (≥3 chars total)
    // Preceded by start-of-string or whitespace/punctuation to avoid mid-word matches
    const INLINE_LABEL = /(?:^|(?<=[\s.,;()\-]))\b([A-Z][a-zA-Z]{2,}):\s+/g;
    const hits: Array<{ index: number; label: string; end: number }> = [];
    let m: RegExpExecArray | null;
    while ((m = INLINE_LABEL.exec(raw)) !== null) {
      hits.push({ index: m.index + m[0].indexOf(m[1]), label: m[1], end: m.index + m[0].length });
    }

    // Fallback if lookbehind not supported: simple scan
    if (hits.length === 0) {
      const SIMPLE = /([A-Z][a-zA-Z]{2,}):\s+/g;
      while ((m = SIMPLE.exec(raw)) !== null) {
        const before = m.index > 0 ? raw[m.index - 1] : " ";
        if (/[\s.,;()\-]/.test(before) || m.index === 0) {
          hits.push({ index: m.index, label: m[1], end: m.index + m[0].length });
        }
      }
    }

    if (hits.length === 0) return [{ kind: "text", content: raw }];

    const rows: Row[] = [];
    let last = 0;
    for (let i = 0; i < hits.length; i++) {
      const { index, label, end } = hits[i];
      const nextIdx = i + 1 < hits.length ? hits[i + 1].index : raw.length;
      if (index > last) {
        const before = raw.slice(last, index).trim();
        if (before) rows.push({ kind: "text", content: before });
      }
      rows.push({ kind: "label", label, value: raw.slice(end, nextIdx).trim() });
      last = nextIdx;
    }
    if (last < raw.length) {
      const rest = raw.slice(last).trim();
      if (rest) rows.push({ kind: "text", content: rest });
    }
    return rows;
  }

  // ── Newline-separated parser ───────────────────────────────────────────
  function buildRowsNewline(raw: string): Row[] {
    const rawLines = raw.split(/\r?\n/).map(l => l.trim());

    // Merge orphan plain words (≤3 words, no colon) with the following label line
    // e.g. "Job\nTitle: x" → "Job Title: x"
    const lines: string[] = [];
    let j = 0;
    while (j < rawLines.length) {
      const line = rawLines[j];
      if (!line) { j++; continue; }
      const isShortPlain =
        !line.includes(":") &&
        line.split(/\s+/).length <= 3 &&
        /^[A-Za-z]/.test(line) &&
        !/^[•·●\-*]\s/.test(line);
      if (isShortPlain && j + 1 < rawLines.length && rawLines[j + 1].match(LINE_LABEL_RE)) {
        lines.push(line + " " + rawLines[j + 1]);
        j += 2;
      } else {
        lines.push(line); j++;
      }
    }

    const rows: Row[] = [];
    let i = 0;
    while (i < lines.length) {
      const line = lines[i].trim();
      if (!line) { i++; continue; }
      if (/^[•·●\-*]\s/.test(line)) {
        rows.push({ kind: "bullet", content: line.replace(/^[•·●\-*]\s*/, "").trim() });
        i++; continue;
      }
      const mm = line.match(LINE_LABEL_RE);
      if (mm && mm[1].trim().split(/\s+/).length <= 4) {
        let value = mm[2].trim();
        if (!value && i + 1 < lines.length) {
          const next = lines[i + 1].trim();
          if (next && !next.match(LINE_LABEL_RE)) { value = next; i++; }
        }
        rows.push({ kind: "label", label: mm[1], value });
        i++; continue;
      }
      rows.push({ kind: "text", content: line });
      i++;
    }
    return rows;
  }

  const rows = text.includes("\n") ? buildRowsNewline(text) : buildRowsInline(text);

  return (
    <div className="divide-y divide-white/5">
      {rows.map((row, idx) => {
        if (row.kind === "label") {
          return (
            <div key={idx} className="flex hover:bg-white/[0.02] transition-colors">
              <div className="w-0.5 flex-shrink-0 self-stretch" style={{ background: `${accent}80` }} />
              <div className="flex-1 px-5 py-3 flex flex-col sm:flex-row sm:items-start gap-1 sm:gap-5">
                <span
                  className="flex-shrink-0 font-bold text-[12px] uppercase tracking-wider sm:w-44 mt-0.5"
                  style={{ color: accent }}
                >
                  {row.label}
                </span>
                <span className="text-[#D1D5DB] text-[13px] leading-relaxed flex-1">
                  {row.value || <span className="text-[#4B5563] italic text-xs">—</span>}
                </span>
              </div>
            </div>
          );
        }
        if (row.kind === "bullet") {
          return (
            <div key={idx} className="flex gap-3 px-6 py-2.5 hover:bg-white/[0.02] transition-colors">
              <span className="flex-shrink-0 w-1.5 h-1.5 rounded-full mt-[7px]" style={{ background: accent }} />
              <span className="text-[#C9D1D9] text-[13px] leading-relaxed">{row.content}</span>
            </div>
          );
        }
        return (
          <p key={idx} className="px-6 py-3 text-[#C9D1D9] text-[13px] leading-relaxed">
            {row.content}
          </p>
        );
      })}
    </div>
  );
}

export default async function JobDetailPage(
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const job = await getJob(id);
  if (!job) notFound();

  const [c1, c2] = avatarColors(job.company);
  const postedDate = job.posted_at || job.created_at;
  const isReferral = job.job_type === "referral";

  const schema = {
    "@context": "https://schema.org",
    "@type": "JobPosting",
    title: job.title,
    description: job.description,
    hiringOrganization: { "@type": "Organization", name: job.company },
    jobLocation: { "@type": "Place", address: { "@type": "PostalAddress", addressLocality: job.location } },
    datePosted: job.posted_at || job.created_at,
    employmentType: "FULL_TIME",
    ...(job.salary ? { baseSalary: { "@type": "MonetaryAmount", value: job.salary } } : {}),
    url: `${SITE}/jobs/${id}`,
  };

  // Key info rows for the info grid
  const infoItems = [
    { icon: Building2, label: "Company",     value: job.company,          color: c1 },
    { icon: MapPin,    label: "Location",    value: job.location,         color: "#00D4FF" },
    { icon: Globe,     label: "Work Mode",   value: job.is_remote ? "Remote / Hybrid" : "On-site", color: job.is_remote ? "#3B82F6" : "#9CA3AF" },
    { icon: Briefcase, label: "Job Type",    value: isReferral ? "Referral" : "Regular", color: isReferral ? "#00FF88" : "#9CA3AF" },
    ...(job.experience_level ? [{ icon: Users, label: "Experience", value: job.experience_level, color: "#A855F7" }] : []),
    ...(job.salary ? [{ icon: DollarSign, label: "Salary", value: job.salary, color: "#00FF88" }] : []),
    { icon: Calendar,  label: "Posted",      value: formatExactDateTime(postedDate), color: "#F97316" },
    { icon: Zap,       label: "Source",      value: job.source === "adzuna" ? "Adzuna (Auto-fetched)" : "Community Post", color: "#EAB308" },
  ] as { icon: ElementType; label: string; value: string; color: string }[];

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }} />

      <div className="min-h-screen bg-[#0B0B0B] pt-20 pb-28">

        {/* ══════ HERO HEADER ══════ */}
        <div className="relative overflow-hidden">
          {/* Background gradient matching company color */}
          <div className="absolute inset-0"
            style={{ background: `radial-gradient(ellipse 80% 100% at 20% 0%,${c1}15,transparent 60%),radial-gradient(ellipse 60% 80% at 80% 0%,${c2}10,transparent 55%)` }}
          />
          <div className="absolute inset-0 grid-bg opacity-20" />
          {/* Top bar */}
          <div className="absolute top-0 left-0 right-0 h-1" style={{ background: `linear-gradient(90deg,${c1},${c2},${c1})` }} />

          <div className="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-8 pb-10">

            {/* Back link */}
            <Link href="/jobs" className="inline-flex items-center gap-2 text-sm text-[#9CA3AF] hover:text-white transition-colors mb-8">
              <ArrowLeft size={15} /> Back to Jobs Board
            </Link>

            <div className="flex flex-col sm:flex-row items-start gap-6">
              {/* Company logo */}
              <JobDetailLogo company={job.company} colors={[c1, c2]} />

              <div className="flex-1 min-w-0">
                {/* Company */}
                <div className="flex items-center gap-2 mb-2">
                  <Building2 size={14} style={{ color: c1 }} />
                  <span className="font-bold text-base uppercase tracking-widest" style={{ color: c1 }}>{job.company}</span>
                  {job.source === "adzuna" && (
                    <span className="px-2 py-0.5 rounded-full bg-white/5 border border-white/10 text-[10px] text-[#6B7280] font-semibold">via Adzuna</span>
                  )}
                </div>

                {/* Title */}
                <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black text-white leading-tight mb-4 tracking-tight">
                  {job.title}
                </h1>

                {/* Badge row */}
                <div className="flex flex-wrap gap-2 mb-4">
                  <span className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-white/6 border border-white/10 text-sm text-[#D1D5DB]">
                    <MapPin size={13} style={{ color: c1 }} /> {job.location}
                  </span>
                  {job.is_remote && (
                    <span className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-blue-500/12 border border-blue-500/25 text-sm text-blue-300 font-semibold">
                      <Wifi size={13} /> Remote
                    </span>
                  )}
                  {job.salary && (
                    <span className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/25 text-sm font-bold text-[#00FF88]">
                      <DollarSign size={13} /> {job.salary}
                    </span>
                  )}
                  {job.experience_level && (
                    <span className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-purple-500/12 border border-purple-500/25 text-sm text-purple-300 font-semibold">
                      <Users size={13} /> {job.experience_level}
                    </span>
                  )}
                  {isReferral && (
                    <span className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-[#00FF88]/12 border border-[#00FF88]/30 text-sm font-bold text-[#00FF88]">
                      <Star size={13} /> Referral Opportunity
                    </span>
                  )}
                </div>

                <p className="text-[#6B7280] text-sm flex items-center gap-1.5">
                  <Clock size={12} /> Posted {formatExactDateTime(postedDate)}
                </p>
              </div>

              {/* Quick apply (desktop hero CTA) */}
              <div className="hidden lg:flex flex-col gap-3 flex-shrink-0 w-52">
                {isReferral && job.referral_contact ? (
                  <a
                    href={getReferralHref(job.referral_contact).href}
                    target={getReferralHref(job.referral_contact).isEmail ? undefined : "_blank"}
                    rel="noopener noreferrer"
                    className="flex items-center justify-center gap-2 w-full py-3.5 rounded-2xl font-bold text-sm border border-[#00FF88]/35 text-[#00FF88] bg-[#00FF88]/10 hover:bg-[#00FF88]/18 hover:shadow-[0_0_24px_rgba(0,255,136,0.2)] transition-all"
                  >
                    <Star size={15} /> Get Referred
                  </a>
                ) : job.apply_url ? (
                  <a
                    href={job.apply_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center justify-center gap-2 w-full py-3.5 rounded-2xl font-bold text-sm text-[#0B0B0B] hover:scale-[1.02] hover:shadow-[0_0_28px_rgba(0,255,136,0.4)] transition-all"
                    style={{ background: `linear-gradient(135deg,${c1},${c2})` }}
                  >
                    <Briefcase size={15} /> Apply Now
                    <ExternalLink size={12} />
                  </a>
                ) : null}
              </div>
            </div>
          </div>
        </div>

        {/* ══════ BODY ══════ */}
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 mt-8">
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

            {/* ──── LEFT: Description (2/3) ──── */}
            <div className="lg:col-span-2 flex flex-col gap-6">

              {/* Job Info Grid */}
              <div className="rounded-2xl border border-white/8 overflow-hidden" style={{ background: "#111" }}>
                <div className="px-6 py-4 border-b border-white/6 flex items-center gap-2">
                  <CheckCircle2 size={16} style={{ color: c1 }} />
                  <h2 className="font-bold text-white text-base">Job Details</h2>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 divide-y divide-white/4 sm:divide-y-0">
                  {infoItems.map(({ icon: Icon, label, value, color }) => (
                    <div key={label} className="flex items-start gap-3 px-6 py-4 border-b border-white/4 last:border-0">
                      <div className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5"
                        style={{ background: `${color}15`, border: `1px solid ${color}30` }}>
                        <Icon size={14} style={{ color }} />
                      </div>
                      <div>
                        <p className="text-[10px] font-bold text-[#4B5563] uppercase tracking-widest mb-0.5">{label}</p>
                        <p className="text-sm font-semibold text-white">{value}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Full Description */}
              <div className="rounded-2xl border border-white/8 overflow-hidden" style={{ background: "#111" }}>
                <div className="px-6 py-4 border-b border-white/6 flex items-center gap-2">
                  <Zap size={16} style={{ color: c1 }} />
                  <h2 className="font-bold text-white text-base">Full Job Description</h2>
                </div>
                <FullDescription text={job.description} accent={c1} />
                {job.source === "adzuna" && job.apply_url && (
                  <div className="mx-4 mb-4 mt-2 rounded-xl border flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 px-4 py-3"
                    style={{ borderColor: `${c1}33`, background: `linear-gradient(135deg,${c1}0D,${c2}08)` }}>
                    <p className="text-[#9CA3AF] text-xs leading-relaxed">
                      <span className="font-semibold" style={{ color: c1 }}>Preview only.</span>{" "}
                      The full description — roles, responsibilities &amp; requirements — is on the employer&apos;s site.
                    </p>
                    <a href={job.apply_url} target="_blank" rel="noopener noreferrer"
                      className="flex-shrink-0 flex items-center gap-1.5 px-4 py-2 rounded-lg text-xs font-bold text-[#0B0B0B] hover:scale-[1.02] hover:shadow-lg transition-all whitespace-nowrap"
                      style={{ background: `linear-gradient(135deg,${c1},${c2})` }}>
                      View Full Job <ExternalLink size={11} />
                    </a>
                  </div>
                )}
              </div>

              {/* Referral note block (if any) */}
              {isReferral && job.referral_note && (
                <div className="rounded-2xl border border-[#00FF88]/25 overflow-hidden"
                  style={{ background: "linear-gradient(135deg,rgba(0,255,136,0.06),rgba(0,212,255,0.03))" }}>
                  <div className="px-6 py-4 border-b border-[#00FF88]/15 flex items-center gap-2">
                    <Star size={16} className="text-[#00FF88]" />
                    <h2 className="font-bold text-[#00FF88] text-base">How to Get Referred</h2>
                  </div>
                  <div className="px-6 py-5">
                    <p className="text-[#C9D1D9] text-sm leading-relaxed">{job.referral_note}</p>
                  </div>
                </div>
              )}
            </div>

            {/* ──── RIGHT: Sidebar (1/3) ──── */}
            <div className="flex flex-col gap-4">

              {/* Apply card */}
              <div className="rounded-2xl border border-white/8 overflow-hidden sticky top-24" style={{ background: "#111" }}>
                <div className="px-5 py-4 border-b border-white/6">
                  <h3 className="font-bold text-white text-sm">{isReferral ? "Get Referred" : "Apply for this Role"}</h3>
                </div>
                <div className="p-5 flex flex-col gap-3">
                  {isReferral && job.referral_note && (
                    <div className="rounded-xl bg-[#00FF88]/8 border border-[#00FF88]/20 p-3">
                      <p className="text-[10px] font-bold text-[#00FF88] uppercase tracking-wider mb-1">Referral Note</p>
                      <p className="text-xs text-[#C9D1D9] leading-relaxed">{job.referral_note}</p>
                    </div>
                  )}

                  {isReferral && job.referral_contact ? (
                    (() => {
                      const { href, isEmail } = getReferralHref(job.referral_contact);
                      return (
                        <a href={href} target={isEmail ? undefined : "_blank"} rel="noopener noreferrer"
                          className="flex items-center justify-center gap-2 w-full py-3.5 rounded-xl font-bold text-sm text-[#00FF88] border border-[#00FF88]/30 bg-[#00FF88]/10 hover:bg-[#00FF88]/18 hover:shadow-[0_0_20px_rgba(0,255,136,0.2)] transition-all">
                          {isEmail ? <Mail size={14} /> : <Link2 size={14} />}
                          Contact Referrer
                        </a>
                      );
                    })()
                  ) : job.apply_url ? (
                    <a href={job.apply_url} target="_blank" rel="noopener noreferrer"
                      className="flex items-center justify-center gap-2 w-full py-3.5 rounded-xl font-bold text-sm text-[#0B0B0B] hover:scale-[1.02] hover:shadow-[0_0_24px_rgba(0,255,136,0.35)] transition-all"
                      style={{ background: `linear-gradient(135deg,${c1},${c2})` }}>
                      <Briefcase size={14} /> Apply for this Role <ExternalLink size={12} />
                    </a>
                  ) : null}

                  <p className="text-[10px] text-[#4B5563] text-center">You'll be redirected to the employer's site</p>
                </div>

                {/* Divider + Share */}
                <div className="border-t border-white/6 px-5 py-4">
                  <p className="text-xs font-bold text-[#6B7280] uppercase tracking-wider mb-3">Share this job</p>
                  <ShareButtons jobId={id} title={job.title} company={job.company} location={job.location} />
                </div>

                {/* Back */}
                <div className="border-t border-white/6 px-5 py-4">
                  <Link href="/jobs"
                    className="flex items-center justify-center gap-2 w-full py-2.5 rounded-xl font-semibold text-sm text-[#9CA3AF] border border-white/8 bg-white/3 hover:bg-white/6 hover:text-white transition-all">
                    <ArrowLeft size={14} /> Browse All Jobs
                  </Link>
                </div>
              </div>

              {/* ── Promo: Interview Prep ── */}
              <div className="rounded-2xl overflow-hidden border border-[#F59E0B]/20 relative"
                style={{ background: "linear-gradient(135deg,#0f0a00,#111)" }}>
                <div className="absolute inset-0 pointer-events-none"
                  style={{ background: "radial-gradient(ellipse at top right,rgba(245,158,11,0.10),transparent 65%)" }} />
                <div className="relative p-5">
                  <div className="flex items-center gap-2 mb-3">
                    <div className="w-8 h-8 rounded-xl flex items-center justify-center flex-shrink-0"
                      style={{ background: "rgba(245,158,11,0.15)", border: "1px solid rgba(245,158,11,0.3)" }}>
                      <BrainCircuit size={15} className="text-[#F59E0B]" />
                    </div>
                    <span className="text-[10px] font-bold uppercase tracking-widest text-[#F59E0B]">AutomateQA</span>
                  </div>
                  <h3 className="text-white font-black text-base leading-snug mb-1">
                    Ace Your Next QA Interview
                  </h3>
                  <p className="text-[#9CA3AF] text-xs leading-relaxed mb-3">
                    Practice 200+ real interview questions on Selenium, Playwright, API Testing &amp; more. Land the role you&apos;re applying for.
                  </p>
                  <ul className="space-y-1.5 mb-4">
                    {["Categorized by tool & topic", "Detailed answers included", "Free — no sign-up needed"].map(pt => (
                      <li key={pt} className="flex items-center gap-2 text-[11px] text-[#C9D1D9]">
                        <CheckCircle2 size={11} className="text-[#F59E0B] flex-shrink-0" />
                        {pt}
                      </li>
                    ))}
                  </ul>
                  <Link href="/interview-prep"
                    className="flex items-center justify-center gap-1.5 w-full py-2.5 rounded-xl text-xs font-bold text-[#0B0B0B] hover:scale-[1.02] hover:shadow-[0_0_20px_rgba(245,158,11,0.35)] transition-all"
                    style={{ background: "linear-gradient(135deg,#F59E0B,#F97316)" }}>
                    Start Practicing <ChevronRight size={13} />
                  </Link>
                </div>
              </div>

              {/* ── Promo: Learn / Tutorials ── */}
              <div className="rounded-2xl overflow-hidden border border-[#00D4FF]/20 relative"
                style={{ background: "linear-gradient(135deg,#00050f,#111)" }}>
                <div className="absolute inset-0 pointer-events-none"
                  style={{ background: "radial-gradient(ellipse at top right,rgba(0,212,255,0.09),transparent 65%)" }} />
                <div className="relative p-5">
                  <div className="flex items-center gap-2 mb-3">
                    <div className="w-8 h-8 rounded-xl flex items-center justify-center flex-shrink-0"
                      style={{ background: "rgba(0,212,255,0.12)", border: "1px solid rgba(0,212,255,0.25)" }}>
                      <BookOpen size={15} className="text-[#00D4FF]" />
                    </div>
                    <span className="text-[10px] font-bold uppercase tracking-widest text-[#00D4FF]">AutomateQA</span>
                  </div>
                  <h3 className="text-white font-black text-base leading-snug mb-1">
                    Learn Automation From Scratch
                  </h3>
                  <p className="text-[#9CA3AF] text-xs leading-relaxed mb-3">
                    Free tutorials on Playwright, Selenium, Cypress &amp; CI/CD pipelines. Build the skills companies are hiring for right now.
                  </p>
                  <ul className="space-y-1.5 mb-4">
                    {["Beginner to advanced tracks", "Hands-on code examples", "Updated for 2026"].map(pt => (
                      <li key={pt} className="flex items-center gap-2 text-[11px] text-[#C9D1D9]">
                        <CheckCircle2 size={11} className="text-[#00D4FF] flex-shrink-0" />
                        {pt}
                      </li>
                    ))}
                  </ul>
                  <Link href="/learn"
                    className="flex items-center justify-center gap-1.5 w-full py-2.5 rounded-xl text-xs font-bold text-[#0B0B0B] hover:scale-[1.02] hover:shadow-[0_0_20px_rgba(0,212,255,0.30)] transition-all"
                    style={{ background: "linear-gradient(135deg,#00D4FF,#00FF88)" }}>
                    Start Learning <ChevronRight size={13} />
                  </Link>
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
    </>
  );
}

