"use client";

import { useState, type ReactNode } from "react";
import Link from "next/link";
import { MapPin, Clock, Wifi, DollarSign, ExternalLink, Mail, Link2, Briefcase, Building2, ChevronDown, ChevronUp, Share2, Check } from "lucide-react";
import { Job } from "@/types";
import { formatExactDateTime } from "@/lib/utils";

// ── Deterministic gradient per company name ───────────────────────────────────
const GRADIENTS: [string, string][] = [
  ["#00FF88", "#00D4FF"],
  ["#A855F7", "#EC4899"],
  ["#F97316", "#EF4444"],
  ["#3B82F6", "#06B6D4"],
  ["#EAB308", "#F97316"],
  ["#EC4899", "#8B5CF6"],
  ["#10B981", "#14B8A6"],
  ["#6366F1", "#3B82F6"],
];

function avatarColors(name: string): [string, string] {
  let h = 0;
  for (let i = 0; i < name.length; i++) h = name.charCodeAt(i) + ((h << 5) - h);
  return GRADIENTS[Math.abs(h) % GRADIENTS.length];
}

function accentColor(name: string): string {
  return avatarColors(name)[0];
}

// ── Manual overrides for common companies ────────────────────────────────────
const DOMAIN_OVERRIDES: Record<string, string> = {
  "tata consultancy services": "tcs.com",
  "tcs": "tcs.com",
  "wipro": "wipro.com",
  "infosys": "infosys.com",
  "hcl technologies": "hcltech.com",
  "tech mahindra": "techmahindra.com",
  "ltimindtree": "ltimindtree.com",
  "lti mindtree": "ltimindtree.com",
  "cognizant": "cognizant.com",
  "capgemini": "capgemini.com",
  "accenture": "accenture.com",
  "ibm": "ibm.com",
  "google": "google.com",
  "microsoft": "microsoft.com",
  "amazon": "amazon.com",
  "meta": "meta.com",
  "netflix": "netflix.com",
  "flipkart": "flipkart.com",
  "atlassian": "atlassian.com",
  "zensar": "zensar.com",
  "luxoft": "luxoft.com",
  "epam": "epam.com",
  "epam systems": "epam.com",
  "randstad": "randstad.com",
  "randstad digital": "randstad.com",
  "apex systems": "apexsystems.com",
};

// ── Derive domain from company name ──────────────────────────────────────────
function companyDomain(name: string): string {
  const key = name.toLowerCase().replace(/[^a-z0-9\s]/g, " ").trim().replace(/\s+/g, " ");
  for (const [k, v] of Object.entries(DOMAIN_OVERRIDES)) {
    if (key.includes(k)) return v;
  }
  // embedded TLD e.g. "BigBear.AI"
  const tld = name.match(/\b(\w+)\.(ai|io|co|app|tech|dev|com|net|org)\b/i);
  if (tld) return `${tld[1]}.${tld[2]}`.toLowerCase();

  const cleaned = name
    .replace(/\b(inc|llc|ltd|pvt|private|limited|corp|corporation|technologies|technology|tech|services|solutions|consulting|consultancy|staffing|group|india|us|usa|uk|digital|systems|software|global|international|infotech|infosolutions|worldwide)\b\.?/gi, " ")
    .replace(/[^a-zA-Z0-9\s]/g, " ")
    .trim()
    .replace(/\s+/g, "")
    .toLowerCase();
  return cleaned ? `${cleaned}.com` : "";
}

// ── Logo sources to try in order ──────────────────────────────────────────────
function logoSources(domain: string): string[] {
  return [
    `https://logo.clearbit.com/${domain}`,
    `https://www.google.com/s2/favicons?domain=${domain}&sz=128`,
  ];
}

// ── Company logo with cascading fallbacks → letter avatar ─────────────────────
function CompanyLogo({ name, colors }: { name: string; colors: [string, string] }) {
  const [srcIdx, setSrcIdx] = useState(0);
  const [loaded, setLoaded] = useState(false);
  const [allFailed, setAllFailed] = useState(false);
  const [c1, c2] = colors;
  const initial = (name[0] || "?").toUpperCase();
  const domain  = companyDomain(name);
  const sources = domain ? logoSources(domain) : [];

  const tryNext = () => {
    if (srcIdx + 1 < sources.length) {
      setSrcIdx(s => s + 1);
    } else {
      setAllFailed(true);
    }
  };

  if (!domain || allFailed || sources.length === 0) {
    return (
      <div
        className="w-12 h-12 rounded-xl flex-shrink-0 flex items-center justify-center text-white font-black text-lg shadow-lg ring-1 ring-white/10"
        style={{ background: `linear-gradient(135deg,${c1},${c2})` }}
      >
        {initial}
      </div>
    );
  }

  return (
    <div className="relative w-12 h-12 rounded-xl flex-shrink-0 shadow-lg ring-1 ring-white/10 overflow-hidden">
      {/* Letter avatar shown until logo loads */}
      {!loaded && (
        <div
          className="absolute inset-0 flex items-center justify-center text-white font-black text-lg"
          style={{ background: `linear-gradient(135deg,${c1},${c2})` }}
        >
          {initial}
        </div>
      )}
      <div className={`absolute inset-0 bg-white flex items-center justify-center p-1.5 transition-opacity duration-300 ${loaded ? "opacity-100" : "opacity-0"}`}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          key={srcIdx}
          src={sources[srcIdx]}
          alt={name}
          className="w-full h-full object-contain"
          onLoad={() => setLoaded(true)}
          onError={tryNext}
        />
      </div>
    </div>
  );
}

function getReferralHref(contact: string) {
  if (/^https?:\/\/(www\.)?linkedin\.com/i.test(contact))
    return { href: contact, isEmail: false, isLinkedIn: true };
  if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(contact))
    return { href: `mailto:${contact}?subject=QA%20Referral%20Request`, isEmail: true, isLinkedIn: false };
  return { href: `mailto:${contact}`, isEmail: true, isLinkedIn: false };
}

// ── Parse description for card preview ───────────────────────────────────────
function renderDescription(text: string) {
  const LINE_LABEL_RE = /^([A-Za-z][a-zA-Z]*(?:\s[A-Za-z][a-zA-Z]*){0,3}):\s*(.*)$/;

  // Single-blob (no newlines): match only single title-case words ≥3 chars.
  // Avoids greedy false positives like "Assurance Engineer Availability Required:"
  if (!text.includes("\n")) {
    const hits: Array<{ index: number; label: string; end: number }> = [];
    const SIMPLE = /([A-Z][a-zA-Z]{2,}):\s+/g;
    let m: RegExpExecArray | null;
    while ((m = SIMPLE.exec(text)) !== null) {
      const before = m.index > 0 ? text[m.index - 1] : " ";
      if (/[\s.,;()\-]/.test(before) || m.index === 0) {
        hits.push({ index: m.index, label: m[1], end: m.index + m[0].length });
      }
    }
    if (hits.length === 0) return <span>{text}</span>;

    const parts: ReactNode[] = [];
    let last = 0;
    hits.forEach(({ index, label, end }, i) => {
      const nextIdx = i + 1 < hits.length ? hits[i + 1].index : text.length;
      if (index > last) {
        const before = text.slice(last, index).trim();
        const wordCount = before.split(/\s+/).filter(Boolean).length;
        // Skip ≤2-word orphans before the first label (Adzuna prefixes like "Job")
        if (before && (i > 0 || wordCount > 2)) {
          parts.push(<span key={`t${i}`}>{before} </span>);
        }
      }
      parts.push(
        <span key={`l${i}`}>
          {parts.length > 0 && <br />}
          <strong className="text-white font-semibold">{label}:</strong>{" "}
          {text.slice(end, nextIdx).trim()}
        </span>
      );
      last = nextIdx;
    });
    return <>{parts}</>;
  }

  // Newline-separated: merge orphan words then detect per-line labels.
  const raw = text.split(/\r?\n/).map(l => l.trim()).filter(Boolean);
  const lines: string[] = [];
  let i = 0;
  while (i < raw.length) {
    const line = raw[i];
    const isShortPlain =
      !line.includes(":") &&
      line.split(/\s+/).length <= 3 &&
      /^[A-Za-z]/.test(line) &&
      !/^[•·●\-*]\s/.test(line);
    if (isShortPlain && i + 1 < raw.length && raw[i + 1].match(LINE_LABEL_RE)) {
      lines.push(line + " " + raw[i + 1]); i += 2;
    } else {
      lines.push(line); i++;
    }
  }

  return (
    <>
      {lines.map((line, idx) => {
        const mm = line.match(LINE_LABEL_RE);
        if (mm && mm[1].split(" ").length <= 4) {
          return (
            <span key={idx}>
              {idx > 0 && <br />}
              <strong className="text-white font-semibold">{mm[1]}:</strong>{" "}
              {mm[2] || ""}
            </span>
          );
        }
        return <span key={idx}>{idx > 0 && <br />}{line}</span>;
      })}
    </>
  );
}

const CLAMP_LINES = 4; // lines visible before "Show more"

export default function JobCard({ job }: { job: Job }) {
  const [expanded, setExpanded] = useState(false);
  const [shared, setShared]     = useState(false);
  const isReferral = job.job_type === "referral";

  const handleShare = async () => {
    const siteBase  = typeof window !== "undefined"
      ? window.location.origin
      : (process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online");
    const shareUrl  = `${siteBase}/jobs/${job.id}`;
    const shareData = {
      title: `${job.title} at ${job.company} — AutomateQA`,
      text:  `🚀 ${job.title} at ${job.company} (${job.location})\n\nApply via AutomateQA 👇`,
      url:   shareUrl,
    };
    try {
      if (navigator.share && navigator.canShare?.(shareData)) {
        await navigator.share(shareData);
      } else {
        await navigator.clipboard.writeText(shareUrl);
        setShared(true);
        setTimeout(() => setShared(false), 2000);
      }
    } catch {
      // user cancelled — silently ignore
    }
  };
  const postedDate = job.posted_at || job.created_at;
  const [c1, c2] = avatarColors(job.company);
  const accent = accentColor(job.company);

  // Rough heuristic: if description is long enough to be truncated, show toggle
  const isLong = job.description.length > 180;

  return (
    <div
      className={`
        group relative flex flex-col rounded-2xl border overflow-hidden
        transition-all duration-300 hover:-translate-y-1
        bg-gradient-to-b from-[#161616] to-[#111]
        ${isReferral
          ? "border-[#00FF88]/25 hover:border-[#00FF88]/50 hover:shadow-[0_8px_32px_rgba(0,255,136,0.12)]"
          : "border-white/8 hover:border-white/16 hover:shadow-[0_8px_32px_rgba(0,0,0,0.5)]"
        }
      `}
    >
      {/* Colored top accent strip */}
      <div
        className="h-0.5 w-full flex-shrink-0"
        style={{ background: `linear-gradient(90deg, ${c1}, ${c2})` }}
      />

      <div className="p-5 flex flex-col gap-4 flex-1">

        {/* ── Header ── */}
        <div className="flex items-center gap-3">
          <CompanyLogo name={job.company} colors={[c1, c2]} />
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-1.5 mb-1">
              <Building2 size={11} style={{ color: accent }} className="flex-shrink-0" />
              <span
                className="text-xs font-bold uppercase tracking-wider truncate"
                style={{ color: accent }}
              >
                {job.company}
              </span>
            </div>
            <Link href={`/jobs/${job.id}`}>
              <h3 className="text-white font-bold text-sm leading-snug hover:text-[#00FF88] transition-colors">
                {job.title}
              </h3>
            </Link>
          </div>
        </div>

        {/* ── Location + salary ── */}
        <div className="flex flex-wrap gap-2">
          <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-white/5 border border-white/8 text-xs font-medium text-[#D1D5DB]">
            <MapPin size={11} style={{ color: accent }} />
            {job.location}
          </span>
          {job.salary && (
            <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-[#00FF88]/8 border border-[#00FF88]/20 text-xs font-bold text-[#00FF88]">
              <DollarSign size={11} />
              {job.salary}
            </span>
          )}
        </div>

        {/* ── Badges ── */}
        <div className="flex flex-wrap gap-1.5">
          {isReferral && (
            <span className="inline-flex items-center gap-1 text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-[#00FF88]/12 text-[#00FF88] border border-[#00FF88]/25">
              ✦ Referral
            </span>
          )}
          {job.is_remote && (
            <span className="inline-flex items-center gap-1 text-[10px] font-semibold px-2 py-0.5 rounded-full bg-blue-500/12 text-blue-300 border border-blue-500/25">
              <Wifi size={9} /> Remote
            </span>
          )}
          {job.experience_level && (
            <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-purple-500/12 text-purple-300 border border-purple-500/25">
              {job.experience_level}
            </span>
          )}
        </div>

        {/* ── Description with bold labels + expand toggle ── */}
        <div>
          <p
            className="text-[#C9D1D9] text-[13px] leading-relaxed transition-all"
            style={expanded ? undefined : {
              display: "-webkit-box",
              WebkitLineClamp: CLAMP_LINES,
              WebkitBoxOrient: "vertical",
              overflow: "hidden",
            }}
          >
            {renderDescription(job.description)}
          </p>

          {isLong && (
            <button
              onClick={() => setExpanded((v) => !v)}
              className="mt-1.5 flex items-center gap-1 text-[11px] font-semibold transition-colors"
              style={{ color: accent }}
            >
              {expanded ? (
                <><ChevronUp size={13} /> Show less</>
              ) : (
                <><ChevronDown size={13} /> Show more</>
              )}
            </button>
          )}
        </div>

        {/* ── Referral note ── */}
        {isReferral && job.referral_note && (
          <div className="rounded-xl bg-gradient-to-br from-[#00FF88]/8 to-[#00D4FF]/5 border border-[#00FF88]/20 px-3 py-2.5">
            <p className="text-[10px] font-bold text-[#00FF88] uppercase tracking-wider mb-1">How to get referred</p>
            <p className="text-xs text-[#C9D1D9] leading-relaxed">{job.referral_note}</p>
          </div>
        )}
      </div>

      {/* ── Footer ── */}
      <div className="px-5 pb-5 flex items-center justify-between gap-3 pt-3 border-t border-white/5">
        {/* Left: date + share */}
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 text-[11px] text-[#4B5563]">
            <Clock size={11} />
            <span>{formatExactDateTime(postedDate)}</span>
          </div>

          <button
            onClick={handleShare}
            title="Share this job"
            className="relative flex items-center gap-1.5 text-[11px] font-semibold px-2.5 py-1 rounded-lg border transition-all duration-200"
            style={shared
              ? { background: "rgba(0,255,136,0.12)", borderColor: "rgba(0,255,136,0.35)", color: "#00FF88" }
              : { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.08)", color: "#6B7280" }
            }
          >
            {shared ? <Check size={11} /> : <Share2 size={11} />}
            <span>{shared ? "Copied!" : "Share"}</span>
          </button>
        </div>

        {isReferral && job.referral_contact ? (
          (() => {
            const { href, isEmail, isLinkedIn } = getReferralHref(job.referral_contact);
            return (
              <a
                href={href}
                target={isEmail ? undefined : "_blank"}
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1.5 text-xs font-bold px-4 py-2 rounded-xl
                  bg-gradient-to-r from-[#00FF88]/15 to-[#00D4FF]/15
                  text-[#00FF88] border border-[#00FF88]/30
                  hover:from-[#00FF88]/25 hover:to-[#00D4FF]/25
                  hover:shadow-[0_0_16px_rgba(0,255,136,0.2)]
                  transition-all duration-200"
              >
                {isLinkedIn ? <Link2 size={12} /> : isEmail ? <Mail size={12} /> : <Briefcase size={12} />}
                Get Referred
              </a>
            );
          })()
        ) : job.apply_url ? (
          <a
            href={job.apply_url}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1.5 text-xs font-bold px-4 py-2 rounded-xl
              text-[#0B0B0B]
              hover:shadow-[0_0_20px_rgba(0,255,136,0.35)]
              hover:scale-[1.03]
              transition-all duration-200"
            style={{ background: `linear-gradient(135deg, ${c1}, ${c2})` }}
          >
            Apply <ExternalLink size={11} />
          </a>
        ) : null}
      </div>
    </div>
  );
}
