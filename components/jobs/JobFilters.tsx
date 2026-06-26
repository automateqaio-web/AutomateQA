"use client";

import { useState, useMemo, useEffect, useRef } from "react";
import {
  Search, Wifi, Star, X, ChevronLeft, ChevronRight, ChevronDown,
  Building2, MapPin, Briefcase, Zap, Check,
} from "lucide-react";
import { Job } from "@/types";
import JobCard from "./JobCard";

const PAGE_SIZE = 25;

function unique<T>(arr: T[]): T[] {
  return Array.from(new Set(arr));
}

interface Filters {
  query:        string;
  company:      string;
  location:     string;
  experience:   string;
  source:       string;
  remoteOnly:   boolean;
  referralOnly: boolean;
}

const INITIAL: Filters = {
  query: "", company: "", location: "", experience: "",
  source: "", remoteOnly: false, referralOnly: false,
};

// ── Custom styled dropdown ────────────────────────────────────────────────────
interface DropdownProps {
  label:    string;
  value:    string;
  options:  { value: string; label: string }[];
  onChange: (v: string) => void;
  icon:     React.ReactNode;
  accent?:  string;
  searchable?: boolean;
}

function FilterDropdown({ label, value, options, onChange, icon, accent = "#00FF88", searchable = false }: DropdownProps) {
  const [open, setOpen]     = useState(false);
  const [q, setQ]           = useState("");
  const ref                 = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false);
        setQ("");
      }
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  const filtered = useMemo(() =>
    q
      ? options.filter(o => o.label.toLowerCase().includes(q.toLowerCase()))
      : options,
    [options, q]
  );

  const selected = options.find(o => o.value === value);
  const isActive = !!value;

  return (
    <div ref={ref} className="relative">
      <button
        onClick={() => { setOpen(v => !v); setQ(""); }}
        className="flex items-center gap-2 px-3.5 py-2.5 rounded-xl text-sm font-semibold border whitespace-nowrap transition-all min-w-[130px]"
        style={isActive
          ? { background: `${accent}12`, borderColor: `${accent}45`, color: accent }
          : { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.10)", color: "#9CA3AF" }
        }
      >
        <span className="flex-shrink-0" style={isActive ? { color: accent } : { color: "#4B5563" }}>{icon}</span>
        <span className="flex-1 text-left truncate max-w-[110px]">
          {selected && value ? selected.label : label}
        </span>
        <ChevronDown size={13} className={`flex-shrink-0 transition-transform ${open ? "rotate-180" : ""}`} />
      </button>

      {open && (
        <div className="absolute top-full left-0 mt-2 w-64 rounded-2xl border border-white/12 bg-[#141414] shadow-[0_20px_60px_rgba(0,0,0,0.8)] z-50 overflow-hidden">
          {searchable && (
            <div className="p-3 border-b border-white/6">
              <div className="relative">
                <Search size={12} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-[#4B5563]" />
                <input
                  autoFocus
                  type="text"
                  value={q}
                  onChange={e => setQ(e.target.value)}
                  placeholder={`Search ${label.toLowerCase()}…`}
                  className="w-full pl-7 pr-3 py-1.5 rounded-lg bg-white/5 border border-white/8 text-white text-xs placeholder-[#4B5563] focus:outline-none focus:border-white/20"
                />
              </div>
            </div>
          )}
          <div className="max-h-60 overflow-y-auto py-1">
            {filtered.length === 0 ? (
              <p className="text-center text-[#4B5563] text-xs py-4">No results</p>
            ) : (
              filtered.map(opt => {
                const isSel = value === opt.value;
                return (
                  <button
                    key={opt.value}
                    onClick={() => { onChange(opt.value); setOpen(false); setQ(""); }}
                    className="w-full flex items-center justify-between gap-2 px-4 py-2.5 text-sm text-left transition-colors hover:bg-white/5"
                    style={isSel ? { color: accent } : { color: "#C9D1D9" }}
                  >
                    <span className="truncate">{opt.label}</span>
                    {isSel && <Check size={13} style={{ color: accent, flexShrink: 0 }} />}
                  </button>
                );
              })
            )}
          </div>
        </div>
      )}
    </div>
  );
}

// ── Toggle chip ───────────────────────────────────────────────────────────────
function Toggle({ active, onClick, children, color = "#00FF88" }: {
  active: boolean; onClick: () => void; children: React.ReactNode; color?: string;
}) {
  return (
    <button
      onClick={onClick}
      className="flex items-center gap-2 px-3.5 py-2.5 rounded-xl text-sm font-semibold border whitespace-nowrap transition-all"
      style={active
        ? { background: `${color}12`, borderColor: `${color}45`, color }
        : { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.10)", color: "#9CA3AF" }
      }
    >
      {children}
    </button>
  );
}

export default function JobFilters({ jobs }: { jobs: Job[] }) {
  const [f, setF]       = useState<Filters>(INITIAL);
  const [page, setPage] = useState(1);

  useEffect(() => { setPage(1); }, [f]);

  const set = <K extends keyof Filters>(k: K, v: Filters[K]) =>
    setF(prev => ({ ...prev, [k]: v }));

  const clearAll = () => setF(INITIAL);

  // ── Build dropdown options from real job data ─────────────────────────────
  const companyOptions = useMemo(() => {
    const counts: Record<string, number> = {};
    jobs.forEach(j => { counts[j.company] = (counts[j.company] || 0) + 1; });
    return [
      { value: "", label: "All Companies" },
      ...unique(jobs.map(j => j.company))
        .sort((a, b) => counts[b] - counts[a])   // most common first
        .map(c => ({ value: c, label: c })),
    ];
  }, [jobs]);

  const locationOptions = useMemo(() => {
    const locs = unique(jobs.map(j => j.location).filter(Boolean)).sort();
    return [
      { value: "", label: "All Locations" },
      ...locs.map(l => ({ value: l, label: l })),
    ];
  }, [jobs]);

  const expOptions = useMemo(() => {
    const levels = unique(jobs.map(j => j.experience_level ?? "").filter(Boolean)).sort();
    return [
      { value: "", label: "Any Experience" },
      ...(levels.length > 0
        ? levels.map(e => ({ value: e, label: e }))
        : ["Junior", "Mid-Level", "Senior", "Lead"].map(e => ({ value: e, label: e }))
      ),
    ];
  }, [jobs]);

  const sourceOptions = [
    { value: "",       label: "All Sources" },
    { value: "adzuna", label: "Adzuna" },
    { value: "manual", label: "Community" },
  ];

  // ── Filter jobs ───────────────────────────────────────────────────────────
  const filtered = useMemo(() => {
    const q   = f.query.toLowerCase().trim();
    return jobs.filter(job => {
      if (f.remoteOnly   && !job.is_remote)               return false;
      if (f.referralOnly && job.job_type !== "referral")  return false;
      if (f.company      && job.company  !== f.company)   return false;
      if (f.location     && job.location !== f.location)  return false;
      if (f.experience   && job.experience_level !== f.experience) return false;
      if (f.source       && job.source   !== f.source)    return false;
      if (q && !`${job.title} ${job.company} ${job.location}`.toLowerCase().includes(q)) return false;
      return true;
    });
  }, [jobs, f]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
  const safePage   = Math.min(page, totalPages);
  const pageJobs   = filtered.slice((safePage - 1) * PAGE_SIZE, safePage * PAGE_SIZE);

  const activeCount = [
    f.company, f.location, f.experience, f.source,
    f.remoteOnly, f.referralOnly,
  ].filter(Boolean).length;

  const scrollTop = () =>
    document.getElementById("jobs-section")?.scrollIntoView({ behavior: "smooth", block: "start" });

  const goTo = (p: number) => { setPage(p); scrollTop(); };

  const pageNumbers = useMemo(() => {
    if (totalPages <= 5) return Array.from({ length: totalPages }, (_, i) => i + 1);
    const start = Math.max(1, Math.min(safePage - 2, totalPages - 4));
    return Array.from({ length: Math.min(5, totalPages) }, (_, i) => start + i);
  }, [totalPages, safePage]);

  return (
    <div id="jobs-section" className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-24 scroll-mt-20">

      {/* ════════════ FILTER BAR ════════════ */}
      <div className="flex flex-col gap-3 mb-6">

        {/* Row 1: search */}
        <div className="relative">
          <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#4B5563] pointer-events-none" />
          <input
            type="search"
            value={f.query}
            onChange={e => set("query", e.target.value)}
            placeholder="Search by title, company or keyword…"
            className="w-full pl-10 pr-9 py-3 rounded-xl bg-[#111] border border-white/10 text-white text-sm placeholder-[#4B5563] focus:outline-none focus:border-[#00FF88]/40 focus:shadow-[0_0_0_3px_rgba(0,255,136,0.08)] transition-all"
          />
          {f.query && (
            <button onClick={() => set("query", "")} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#4B5563] hover:text-white transition-colors">
              <X size={14} />
            </button>
          )}
        </div>

        {/* Row 2: dropdowns + toggles */}
        <div className="flex flex-wrap gap-2">
          <FilterDropdown
            label="Company"
            value={f.company}
            options={companyOptions}
            onChange={v => set("company", v)}
            icon={<Building2 size={14} />}
            accent="#A855F7"
            searchable
          />
          <FilterDropdown
            label="Location"
            value={f.location}
            options={locationOptions}
            onChange={v => set("location", v)}
            icon={<MapPin size={14} />}
            accent="#00D4FF"
            searchable
          />
          <FilterDropdown
            label="Experience"
            value={f.experience}
            options={expOptions}
            onChange={v => set("experience", v)}
            icon={<Briefcase size={14} />}
            accent="#F97316"
          />
          <FilterDropdown
            label="Source"
            value={f.source}
            options={sourceOptions}
            onChange={v => set("source", v)}
            icon={<Zap size={14} />}
            accent="#EAB308"
          />

          {/* Divider */}
          <div className="w-px bg-white/8 self-stretch mx-1 hidden sm:block" />

          <Toggle active={f.remoteOnly} onClick={() => set("remoteOnly", !f.remoteOnly)} color="#3B82F6">
            <Wifi size={14} /> Remote only
          </Toggle>
          <Toggle active={f.referralOnly} onClick={() => set("referralOnly", !f.referralOnly)} color="#00FF88">
            <Star size={14} /> Referrals only
          </Toggle>

          {(activeCount > 0 || f.query) && (
            <button
              onClick={clearAll}
              className="flex items-center gap-1.5 px-3.5 py-2.5 rounded-xl text-sm font-semibold border border-red-500/25 bg-red-500/8 text-red-400 hover:bg-red-500/15 transition-all whitespace-nowrap"
            >
              <X size={13} /> Clear all
            </button>
          )}
        </div>

        {/* Row 3: result count + active tag pills */}
        <div className="flex items-center gap-2 flex-wrap min-h-[24px]">
          <p className="text-sm text-[#9CA3AF]">
            Showing{" "}
            <span className="text-white font-semibold">
              {filtered.length === 0 ? 0 : (safePage - 1) * PAGE_SIZE + 1}–{Math.min(safePage * PAGE_SIZE, filtered.length)}
            </span>{" "}
            of <span className="text-white font-bold">{filtered.length}</span> jobs
          </p>

          {f.company && (
            <ActiveTag color="#A855F7" onRemove={() => set("company", "")}>
              <Building2 size={10} /> {f.company}
            </ActiveTag>
          )}
          {f.location && (
            <ActiveTag color="#00D4FF" onRemove={() => set("location", "")}>
              <MapPin size={10} /> {f.location}
            </ActiveTag>
          )}
          {f.experience && (
            <ActiveTag color="#F97316" onRemove={() => set("experience", "")}>
              <Briefcase size={10} /> {f.experience}
            </ActiveTag>
          )}
          {f.source && (
            <ActiveTag color="#EAB308" onRemove={() => set("source", "")}>
              <Zap size={10} /> {f.source === "adzuna" ? "Adzuna" : "Community"}
            </ActiveTag>
          )}
          {f.remoteOnly && (
            <ActiveTag color="#3B82F6" onRemove={() => set("remoteOnly", false)}>
              <Wifi size={10} /> Remote
            </ActiveTag>
          )}
          {f.referralOnly && (
            <ActiveTag color="#00FF88" onRemove={() => set("referralOnly", false)}>
              <Star size={10} /> Referral
            </ActiveTag>
          )}
        </div>
      </div>

      {/* ════════════ JOB GRID ════════════ */}
      {filtered.length === 0 ? (
        <div className="rounded-2xl border border-white/8 bg-[#111]/60 p-16 text-center">
          <div className="text-5xl mb-4">🔍</div>
          <h3 className="text-lg font-bold text-white mb-2">No jobs match your filters</h3>
          <p className="text-[#9CA3AF] text-sm mb-4">Try adjusting your search or clearing some filters.</p>
          <button onClick={clearAll} className="text-sm font-semibold text-[#00FF88] underline underline-offset-2">
            Clear all filters
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {pageJobs.map(job => <JobCard key={job.id} job={job} />)}
        </div>
      )}

      {/* ════════════ PAGINATION ════════════ */}
      {totalPages > 1 && (
        <div className="mt-10 flex items-center justify-center gap-2">
          <button
            onClick={() => goTo(safePage - 1)}
            disabled={safePage === 1}
            className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm font-semibold border transition-all disabled:opacity-30 disabled:cursor-not-allowed bg-[#111] text-[#9CA3AF] border-white/10 hover:text-white hover:border-white/20"
          >
            <ChevronLeft size={16} /> Prev
          </button>

          {pageNumbers[0] > 1 && (
            <>
              <button onClick={() => goTo(1)} className="w-10 h-10 rounded-xl text-sm font-semibold border border-white/10 bg-[#111] text-[#9CA3AF] hover:text-white hover:border-white/20 transition-all">1</button>
              {pageNumbers[0] > 2 && <span className="text-[#4B5563] text-sm px-1">…</span>}
            </>
          )}

          {pageNumbers.map(p => (
            <button
              key={p}
              onClick={() => goTo(p)}
              className="w-10 h-10 rounded-xl text-sm font-bold border transition-all"
              style={p === safePage
                ? { background: "#00FF88", color: "#0B0B0B", borderColor: "#00FF88", boxShadow: "0 0 16px rgba(0,255,136,0.35)" }
                : { background: "#111", color: "#9CA3AF", borderColor: "rgba(255,255,255,0.10)" }
              }
            >
              {p}
            </button>
          ))}

          {pageNumbers[pageNumbers.length - 1] < totalPages && (
            <>
              {pageNumbers[pageNumbers.length - 1] < totalPages - 1 && <span className="text-[#4B5563] text-sm px-1">…</span>}
              <button onClick={() => goTo(totalPages)} className="w-10 h-10 rounded-xl text-sm font-semibold border border-white/10 bg-[#111] text-[#9CA3AF] hover:text-white hover:border-white/20 transition-all">{totalPages}</button>
            </>
          )}

          <button
            onClick={() => goTo(safePage + 1)}
            disabled={safePage === totalPages}
            className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm font-semibold border transition-all disabled:opacity-30 disabled:cursor-not-allowed bg-[#111] text-[#9CA3AF] border-white/10 hover:text-white hover:border-white/20"
          >
            Next <ChevronRight size={16} />
          </button>
        </div>
      )}
    </div>
  );
}

// ── Active tag pill ───────────────────────────────────────────────────────────
function ActiveTag({ color, onRemove, children }: { color: string; onRemove: () => void; children: React.ReactNode }) {
  return (
    <span
      className="inline-flex items-center gap-1.5 pl-2.5 pr-1.5 py-1 rounded-full text-[11px] font-semibold border"
      style={{ background: `${color}12`, borderColor: `${color}35`, color }}
    >
      {children}
      <button
        onClick={onRemove}
        className="flex items-center justify-center w-3.5 h-3.5 rounded-full hover:bg-white/15 transition-colors"
      >
        <X size={9} />
      </button>
    </span>
  );
}
