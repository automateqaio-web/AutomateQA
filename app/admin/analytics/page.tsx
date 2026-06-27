"use client";

import { useState, useEffect, useMemo, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  BarChart3, Eye, Play, Laugh, FileText, BookOpen, Lightbulb,
  Users, TrendingUp, Loader2, RefreshCw, BrainCircuit, Calendar,
  Database, ExternalLink, ChevronDown, ArrowUpRight, Zap,
  ArrowUp, ArrowDown, Clock, Activity, Minus, Hash, Briefcase,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import {
  AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Cell, LineChart, Line, Legend,
} from "recharts";

// ── Types ──────────────────────────────────────────────────────────────────────

interface ContentItem {
  id: string;
  title: string;
  section: string;
  sectionLabel: string;
  views: number;
  created_at: string;
  slug?: string;
  extra?: string;
  color: string;
}

interface DailyPoint { date: string; label: string; [key: string]: number | string }

// ── Constants ──────────────────────────────────────────────────────────────────

const DATE_RANGES = [
  { label: "Today",   days: 1  },
  { label: "7 Days",  days: 7  },
  { label: "30 Days", days: 30 },
  { label: "90 Days", days: 90 },
];

const SECTION_TABS = [
  { key: "all",              label: "All",           color: "#00FF88" },
  { key: "home",             label: "Homepage",      color: "#00FF88" },
  { key: "interview-prep",   label: "Interview Prep",color: "#F59E0B" },
  { key: "videos",           label: "Videos",        color: "#EF4444" },
  { key: "learn",            label: "Tutorials",     color: "#00FF88" },
  { key: "blog",             label: "Blog",          color: "#8B5CF6" },
  { key: "automation-tips",  label: "Tips",          color: "#06B6D4" },
  { key: "memes",            label: "Memes",         color: "#EC4899" },
  { key: "jobs",             label: "Jobs",          color: "#F97316" },
];

const SECTION_META: Record<string, { label: string; color: string; bg: string; icon: React.ElementType }> = {
  "home":            { label: "Homepage",       color: "#00FF88", bg: "rgba(0,255,136,0.12)",   icon: Zap },
  "interview-prep":  { label: "Interview Prep", color: "#F59E0B", bg: "rgba(245,158,11,0.12)",  icon: BrainCircuit },
  "videos":          { label: "Videos",         color: "#EF4444", bg: "rgba(239,68,68,0.12)",   icon: Play },
  "learn":           { label: "Tutorials",      color: "#00FF88", bg: "rgba(0,255,136,0.12)",   icon: BookOpen },
  "blog":            { label: "Blog",           color: "#8B5CF6", bg: "rgba(139,92,246,0.12)",  icon: FileText },
  "automation-tips": { label: "Tips",           color: "#06B6D4", bg: "rgba(6,182,212,0.12)",   icon: Lightbulb },
  "memes":           { label: "Memes",          color: "#EC4899", bg: "rgba(236,72,153,0.12)",  icon: Laugh },
  "jobs":            { label: "Jobs Board",      color: "#F97316", bg: "rgba(249,115,22,0.12)",  icon: Briefcase },
  "about":           { label: "About",          color: "#94a3b8", bg: "rgba(148,163,184,0.12)", icon: Users },
  "other":           { label: "Other",          color: "#374151", bg: "rgba(55,65,81,0.12)",    icon: ExternalLink },
};

const SQL_SETUP = `-- Run this once in your Supabase SQL editor
create table if not exists page_events (
  id bigserial primary key,
  section text not null,
  content_id text,
  created_at timestamptz default now()
);
create index if not exists idx_pe_date    on page_events (created_at);
create index if not exists idx_pe_section on page_events (section);
alter table page_events enable row level security;
create policy "anon_insert" on page_events for insert to anon with check (true);
create policy "auth_select" on page_events for select using (true);`;

// ── Helpers ────────────────────────────────────────────────────────────────────

function getDateRange(days: number): { start: string; dates: string[] } {
  const dates: string[] = [];
  for (let i = days - 1; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    dates.push(d.toISOString().split("T")[0]);
  }
  return { start: dates[0], dates };
}

function fmtLabel(dateStr: string, days: number) {
  const d = new Date(dateStr + "T12:00:00");
  if (days <= 7) return d.toLocaleDateString("en-US", { weekday: "short" });
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

function num(n: number) {
  if (n >= 1000000) return `${(n / 1000000).toFixed(1)}M`;
  if (n >= 1000)    return `${(n / 1000).toFixed(1)}K`;
  return n.toLocaleString();
}

function deltaColor(d: number | null) {
  if (d === null) return "#4B5563";
  return d > 0 ? "#00FF88" : d < 0 ? "#EF4444" : "#6B7280";
}

function DeltaBadge({ current, previous }: { current: number; previous: number }) {
  if (previous === 0 && current === 0) return <span className="text-[10px] text-[#4B5563]">no data</span>;
  if (previous === 0) return <span className="text-[10px] text-[#00FF88]">new</span>;
  const pct = Math.round(((current - previous) / previous) * 100);
  const color = deltaColor(pct);
  const Icon = pct > 0 ? ArrowUp : pct < 0 ? ArrowDown : Minus;
  return (
    <span className="flex items-center gap-0.5 text-[10px] font-bold" style={{ color }}>
      <Icon size={10} />
      {Math.abs(pct)}%
    </span>
  );
}

// ── Sub-components ─────────────────────────────────────────────────────────────

function MetricCard({
  label, value, sub, color, bg, icon: Icon, loading, current, previous,
}: {
  label: string; value: number | string; sub?: string;
  color: string; bg: string; icon: React.ElementType; loading: boolean;
  current?: number; previous?: number;
}) {
  return (
    <div className="relative overflow-hidden rounded-2xl p-5"
      style={{ background: "linear-gradient(135deg, #111 0%, #0a0a0a 100%)", border: `1px solid ${color}20` }}>
      <div className="absolute inset-0 pointer-events-none"
        style={{ background: `radial-gradient(ellipse at top right, ${color}10, transparent 70%)` }} />
      <div className="relative">
        <div className="flex items-center justify-between mb-3">
          <div className="w-9 h-9 rounded-xl flex items-center justify-center" style={{ background: bg }}>
            <Icon size={16} style={{ color }} />
          </div>
          {current !== undefined && previous !== undefined && !loading && (
            <DeltaBadge current={current} previous={previous} />
          )}
        </div>
        {loading ? (
          <div className="h-8 w-20 rounded-lg animate-pulse" style={{ background: "#1a1a1a" }} />
        ) : (
          <div className="text-2xl font-black text-white leading-none mb-1">
            {typeof value === "number" ? num(value) : value}
          </div>
        )}
        <div className="text-[11px] font-semibold text-[#6B7280]">{label}</div>
        {sub && <div className="text-[10px] text-[#374151] mt-0.5">{sub}</div>}
      </div>
    </div>
  );
}

const CustomTooltip = ({ active, payload, label }: any) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="rounded-xl px-4 py-3 shadow-2xl"
      style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.08)" }}>
      <p className="text-[11px] font-semibold text-[#9CA3AF] mb-2">{label}</p>
      {payload.map((p: any) => (
        <div key={p.dataKey} className="flex items-center gap-2 text-[12px]">
          <span className="w-2 h-2 rounded-full" style={{ background: p.color || p.stroke }} />
          <span className="text-white font-bold">{p.value?.toLocaleString()}</span>
          <span className="text-[#6B7280]">{p.name || "visits"}</span>
        </div>
      ))}
    </div>
  );
};

// ── Main Page ──────────────────────────────────────────────────────────────────

export default function AdminAnalyticsPage() {
  const [dateRange, setDateRange]       = useState(30);
  const [sectionTab, setSectionTab]     = useState("all");
  const [loading, setLoading]           = useState(true);
  const [hasTracking, setHasTracking]   = useState<boolean | null>(null);
  const [showSQL, setShowSQL]           = useState(false);
  const [copiedSQL, setCopiedSQL]       = useState(false);
  const [sortBy, setSortBy]             = useState<"views" | "date">("views");
  const [filterSection, setFilterSection] = useState("all");
  const [lastRefresh, setLastRefresh]   = useState<Date>(new Date());

  // Raw data — always fetch double the range for period comparison
  const [events,  setEvents]  = useState<{ section: string; created_at: string }[]>([]);
  const [content, setContent] = useState<ContentItem[]>([]);
  const [totals,  setTotals]  = useState({
    iq: 0, videos: 0, learn: 0, tips: 0, blogs: 0, memes: 0, subscribers: 0, jobs: 0,
  });

  const supabase = useMemo(() => createClient(), []);

  const fetchData = useCallback(async () => {
    setLoading(true);
    // Fetch double the date range so we can compare current vs previous period
    const fetchDays = Math.max(dateRange * 2, 2);
    const { start: fetchStart } = getDateRange(fetchDays);

    const eventsRes = await supabase
      .from("page_events")
      .select("section, created_at")
      .gte("created_at", `${fetchStart}T00:00:00.000Z`)
      .order("created_at", { ascending: true });

    if (eventsRes.error?.message?.includes("does not exist")) {
      setHasTracking(false);
    } else {
      setHasTracking(true);
      setEvents(eventsRes.data || []);
    }

    const [iqRes, videosRes, learnRes, tipsRes, blogsRes, memesRes, subsRes, jobsRes] = await Promise.all([
      supabase.from("interview_questions").select("id,question,slug,views,technology,created_at").eq("published", true).order("views", { ascending: false }).limit(30),
      supabase.from("videos").select("id,title,views,created_at").order("views", { ascending: false }).limit(30),
      supabase.from("learning_content").select("id,title,slug,views,created_at").eq("published", true).order("views", { ascending: false }).limit(30),
      supabase.from("automation_tips").select("id,title,slug,views,created_at").eq("published", true).order("views", { ascending: false }).limit(30),
      supabase.from("blogs").select("id,title,slug,created_at").eq("published", true).order("created_at", { ascending: false }).limit(30),
      supabase.from("memes").select("id,title,created_at").order("created_at", { ascending: false }).limit(30),
      supabase.from("subscribers").select("id", { count: "exact" }).limit(1),
      supabase.from("jobs").select("id,title,company,location,created_at,posted_at").eq("is_active", true).order("posted_at", { ascending: false }).limit(50),
    ]);

    const items: ContentItem[] = [
      ...(iqRes.data || []).map(r => ({
        id: r.id, title: r.question, section: "interview-prep",
        sectionLabel: "Interview Prep", views: r.views || 0, created_at: r.created_at,
        slug: r.slug, extra: r.technology, color: "#F59E0B",
      })),
      ...(videosRes.data || []).map(r => ({
        id: r.id, title: r.title, section: "videos",
        sectionLabel: "Videos", views: r.views || 0, created_at: r.created_at, color: "#EF4444",
      })),
      ...(learnRes.data || []).map(r => ({
        id: r.id, title: r.title, section: "learn",
        sectionLabel: "Tutorials", views: r.views || 0, created_at: r.created_at,
        slug: r.slug, color: "#00FF88",
      })),
      ...(tipsRes.data || []).map(r => ({
        id: r.id, title: r.title, section: "automation-tips",
        sectionLabel: "Tips", views: r.views || 0, created_at: r.created_at,
        slug: r.slug, color: "#06B6D4",
      })),
      ...(blogsRes.data || []).map(r => ({
        id: r.id, title: r.title, section: "blog",
        sectionLabel: "Blog", views: 0, created_at: r.created_at,
        slug: r.slug, color: "#8B5CF6",
      })),
      ...(memesRes.data || []).map(r => ({
        id: r.id, title: r.title || "Meme", section: "memes",
        sectionLabel: "Memes", views: 0, created_at: r.created_at, color: "#EC4899",
      })),
      ...(jobsRes.data || []).map(r => ({
        id: r.id, title: r.title, section: "jobs",
        sectionLabel: "Jobs Board", views: 0, created_at: r.posted_at || r.created_at,
        extra: r.company, color: "#F97316",
      })),
    ];

    setContent(items);

    const sumViews = (arr: any[]) => (arr || []).reduce((s, r) => s + (r.views || 0), 0);
    setTotals({
      iq:          sumViews(iqRes.data || []),
      videos:      sumViews(videosRes.data || []),
      learn:       sumViews(learnRes.data || []),
      tips:        sumViews(tipsRes.data || []),
      blogs:       (blogsRes.data || []).length,
      memes:       (memesRes.data || []).length,
      subscribers: subsRes.count || 0,
      jobs:        (jobsRes.data || []).length,
    });

    setLastRefresh(new Date());
    setLoading(false);
  }, [supabase, dateRange]);

  useEffect(() => { fetchData(); }, [fetchData]);

  // ── Date strings ────────────────────────────────────────────────────────────
  const todayStr     = new Date().toISOString().split("T")[0];
  const yesterdayStr = new Date(Date.now() - 86400000).toISOString().split("T")[0];
  const { start: currentStart, dates } = useMemo(() => getDateRange(dateRange), [dateRange]);

  // ── Split events into current vs previous period ────────────────────────────
  const currentEvents = useMemo(
    () => events.filter(e => e.created_at >= `${currentStart}T00:00:00`),
    [events, currentStart]
  );
  const previousEvents = useMemo(
    () => events.filter(e => e.created_at < `${currentStart}T00:00:00`),
    [events, currentStart]
  );

  // ── Today vs Yesterday ──────────────────────────────────────────────────────
  const todayEvents     = useMemo(() => events.filter(e => e.created_at.startsWith(todayStr)), [events, todayStr]);
  const yesterdayEvents = useMemo(() => events.filter(e => e.created_at.startsWith(yesterdayStr)), [events, yesterdayStr]);

  const todayVisitors     = todayEvents.length;
  const yesterdayVisitors = yesterdayEvents.length;
  const totalVisitors     = currentEvents.length;
  const prevTotalVisitors = previousEvents.length;

  // ── Hourly chart (for Today view) ──────────────────────────────────────────
  const hourlyData = useMemo(() => {
    return Array.from({ length: 24 }, (_, h) => {
      const hourLabel = `${h.toString().padStart(2, "0")}:00`;
      return {
        hour: hourLabel,
        Today:     todayEvents.filter(e => new Date(e.created_at).getHours() === h).length,
        Yesterday: yesterdayEvents.filter(e => new Date(e.created_at).getHours() === h).length,
      };
    });
  }, [todayEvents, yesterdayEvents]);

  // Peak hour
  const peakHour = useMemo(() => {
    const max = hourlyData.reduce((a, b) => (b.Today > a.Today ? b : a), hourlyData[0]);
    return max.Today > 0 ? max.hour : null;
  }, [hourlyData]);

  // ── Per-section today vs yesterday ─────────────────────────────────────────
  const COMPARISON_SECTIONS = ["home","interview-prep","videos","learn","blog","automation-tips","jobs"];
  const sectionComparison = useMemo(() => {
    return COMPARISON_SECTIONS.map(key => ({
      key, ...SECTION_META[key],
      today:     todayEvents.filter(e => e.section === key).length,
      yesterday: yesterdayEvents.filter(e => e.section === key).length,
    }));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [todayEvents, yesterdayEvents]);

  // ── Daily chart data ────────────────────────────────────────────────────────
  const activeSectionColor = SECTION_TABS.find(s => s.key === sectionTab)?.color || "#00FF88";
  const activeDataKey = sectionTab === "all" ? "total" : sectionTab;

  const dailyChartData = useMemo((): DailyPoint[] => {
    return dates.map(date => {
      const dayEvents = events.filter(e => e.created_at.startsWith(date));
      const point: DailyPoint = { date, label: fmtLabel(date, dateRange) };
      SECTION_TABS.slice(1).forEach(s => {
        point[s.key] = dayEvents.filter(e => e.section === s.key).length;
      });
      point.total = dayEvents.length;
      return point;
    });
  }, [events, dates, dateRange]);

  // ── Last 14 days table ──────────────────────────────────────────────────────
  const recentDailyTable = useMemo(() => {
    const days = Math.min(14, dateRange === 1 ? 14 : dateRange);
    const { dates: recentDates } = getDateRange(days);
    return recentDates.reverse().map(date => {
      const count = events.filter(e => e.created_at.startsWith(date)).length;
      const d = new Date(date + "T12:00:00");
      return {
        date,
        label: d.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric" }),
        count,
        isToday:     date === todayStr,
        isYesterday: date === yesterdayStr,
      };
    });
  }, [events, dateRange, todayStr, yesterdayStr]);

  const maxDayCount = Math.max(...recentDailyTable.map(d => d.count), 1);

  // ── Streak (consecutive days with >= 1 visitor) ────────────────────────────
  const streak = useMemo(() => {
    let count = 0;
    const checkDates = [...recentDailyTable].reverse(); // oldest first
    for (const d of checkDates) {
      if (d.count > 0) count++;
      else count = 0;
    }
    return count;
  }, [recentDailyTable]);

  // ── Section breakdown ───────────────────────────────────────────────────────
  const sectionBreakdown = useMemo(() => {
    return Object.entries(SECTION_META).map(([key, meta]) => ({
      key, ...meta,
      visits:     currentEvents.filter(e => e.section === key).length,
      totalViews: content.filter(c => c.section === key).reduce((s, c) => s + c.views, 0),
      count:      content.filter(c => c.section === key).length,
    }));
  }, [currentEvents, content]);

  const filteredContent = useMemo(() => {
    let list = filterSection === "all" ? content : content.filter(c => c.section === filterSection);
    return list.sort((a, b) => sortBy === "views"
      ? b.views - a.views
      : new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    ).slice(0, 25);
  }, [content, filterSection, sortBy]);

  // ── Render ──────────────────────────────────────────────────────────────────

  return (
    <div className="max-w-[1400px] mx-auto space-y-6 pb-10">

      {/* ── Header ── */}
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-[#00FF88]/15 flex items-center justify-center">
              <BarChart3 size={16} className="text-[#00FF88]" />
            </div>
            Analytics
          </h1>
          <p className="text-[#6B7280] text-sm mt-0.5 flex items-center gap-2">
            Daily visitors · content views · section performance
            {!loading && (
              <span className="text-[10px] text-[#374151]">
                Updated {lastRefresh.toLocaleTimeString("en-US", { hour: "2-digit", minute: "2-digit" })}
              </span>
            )}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <div className="flex items-center gap-1 p-1 rounded-xl" style={{ background: "#111", border: "1px solid rgba(255,255,255,0.07)" }}>
            {DATE_RANGES.map(r => (
              <button key={r.days} onClick={() => setDateRange(r.days)}
                className="px-3 py-1.5 rounded-lg text-xs font-semibold transition-all"
                style={dateRange === r.days
                  ? { background: "#00FF88", color: "#000" }
                  : { color: "#6B7280" }}>
                {r.label}
              </button>
            ))}
          </div>
          <button onClick={fetchData} disabled={loading}
            className="p-2 rounded-xl border border-white/8 text-[#6B7280] hover:text-white transition-all disabled:opacity-40">
            <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
          </button>
        </div>
      </div>

      {/* ── Tracking setup banner ── */}
      {hasTracking === false && (
        <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}
          className="rounded-2xl p-5"
          style={{ background: "rgba(245,158,11,0.06)", border: "1px solid rgba(245,158,11,0.2)" }}>
          <div className="flex flex-wrap items-start gap-4">
            <div className="flex items-center gap-3 flex-1">
              <div className="w-9 h-9 rounded-xl bg-amber-500/15 flex items-center justify-center flex-shrink-0">
                <Database size={16} className="text-amber-400" />
              </div>
              <div>
                <p className="text-sm font-bold text-amber-300">Visitor tracking not set up yet</p>
                <p className="text-xs text-[#9CA3AF] mt-0.5">Run the SQL below in your Supabase SQL editor to enable daily visitor charts.</p>
              </div>
            </div>
            <button onClick={() => setShowSQL(v => !v)}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold text-amber-300 border border-amber-500/30 hover:bg-amber-500/10 transition-all">
              {showSQL ? "Hide" : "Show"} SQL <ChevronDown size={12} className={showSQL ? "rotate-180" : ""} style={{ transition: "transform 0.2s" }} />
            </button>
          </div>
          <AnimatePresence>
            {showSQL && (
              <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden mt-4">
                <div className="relative rounded-xl overflow-hidden" style={{ background: "#060606", border: "1px solid rgba(255,255,255,0.06)" }}>
                  <div className="flex items-center justify-between px-4 py-2" style={{ borderBottom: "1px solid rgba(255,255,255,0.05)" }}>
                    <span className="text-[10px] font-mono text-[#4B5563]">SQL</span>
                    <button onClick={async () => { await navigator.clipboard.writeText(SQL_SETUP); setCopiedSQL(true); setTimeout(() => setCopiedSQL(false), 2000); }}
                      className="text-[10px] font-semibold text-amber-400 hover:text-amber-300 transition-colors">
                      {copiedSQL ? "Copied!" : "Copy"}
                    </button>
                  </div>
                  <pre className="p-4 text-[11px] font-mono text-[#9CA3AF] overflow-x-auto">{SQL_SETUP}</pre>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>
      )}

      {/* ── TODAY vs YESTERDAY comparison ── */}
      {hasTracking && (
        <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
          className="rounded-2xl overflow-hidden"
          style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.08)" }}>
          <div className="px-6 py-4 flex items-center justify-between"
            style={{ borderBottom: "1px solid rgba(255,255,255,0.05)" }}>
            <h2 className="text-sm font-black text-white flex items-center gap-2">
              <Calendar size={14} className="text-[#00FF88]" />
              Today vs Yesterday
            </h2>
            {peakHour && (
              <span className="flex items-center gap-1.5 text-[10px] text-[#6B7280]">
                <Clock size={11} className="text-[#F59E0B]" />
                Peak today: <span className="text-[#F59E0B] font-bold">{peakHour}</span>
              </span>
            )}
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-8 divide-x divide-white/5">
            {/* Total */}
            <div className="px-5 py-4">
              <div className="text-[10px] font-bold text-[#6B7280] uppercase tracking-widest mb-2">Total</div>
              <div className="flex items-end gap-3">
                <div>
                  <div className="text-2xl font-black text-white">{num(todayVisitors)}</div>
                  <div className="text-[10px] text-[#4B5563]">Today</div>
                </div>
                <div className="mb-1">
                  <div className="text-base font-bold text-[#4B5563]">{num(yesterdayVisitors)}</div>
                  <div className="text-[9px] text-[#374151]">Yesterday</div>
                </div>
              </div>
              <div className="mt-2">
                <DeltaBadge current={todayVisitors} previous={yesterdayVisitors} />
              </div>
            </div>
            {/* Per section */}
            {sectionComparison.map(s => {
              const Icon = s.icon;
              return (
                <div key={s.key} className="px-5 py-4">
                  <div className="flex items-center gap-1.5 mb-2">
                    <Icon size={11} style={{ color: s.color }} />
                    <div className="text-[10px] font-bold text-[#6B7280] uppercase tracking-widest">{s.label}</div>
                  </div>
                  <div className="flex items-end gap-2">
                    <div>
                      <div className="text-xl font-black text-white">{num(s.today)}</div>
                      <div className="text-[10px] text-[#4B5563]">Today</div>
                    </div>
                    <div className="mb-0.5">
                      <div className="text-sm font-bold text-[#4B5563]">{num(s.yesterday)}</div>
                      <div className="text-[9px] text-[#374151]">Yest.</div>
                    </div>
                  </div>
                  <div className="mt-1.5">
                    <DeltaBadge current={s.today} previous={s.yesterday} />
                  </div>
                </div>
              );
            })}
          </div>
        </motion.div>
      )}

      {/* ── Hero total visitors banner ── */}
      <div className="rounded-2xl p-6 relative overflow-hidden"
        style={{ background: "linear-gradient(135deg, #0a1a0f 0%, #080808 60%)", border: "1px solid rgba(0,255,136,0.2)" }}>
        <div className="absolute inset-0 pointer-events-none"
          style={{ background: "radial-gradient(ellipse at top left, rgba(0,255,136,0.08), transparent 60%)" }} />
        <div className="relative flex flex-wrap items-center justify-between gap-6">
          <div>
            <p className="text-[11px] font-bold uppercase tracking-widest text-[#00FF88]/60 mb-1">
              Total Website Visitors · {DATE_RANGES.find(r => r.days === dateRange)?.label}
            </p>
            {loading ? (
              <div className="h-14 w-40 rounded-xl animate-pulse" style={{ background: "#1a1a1a" }} />
            ) : hasTracking ? (
              <div className="flex items-end gap-4">
                <span className="text-5xl font-black text-white leading-none">{num(totalVisitors)}</span>
                {!loading && (
                  <div className="mb-2 flex flex-col gap-0.5">
                    <DeltaBadge current={totalVisitors} previous={prevTotalVisitors} />
                    <span className="text-[10px] text-[#4B5563]">vs prev period</span>
                  </div>
                )}
              </div>
            ) : (
              <div className="text-2xl font-black text-[#4B5563]">Set up tracking to see visitors</div>
            )}
            {hasTracking && (
              <div className="flex items-center gap-4 mt-2">
                <p className="text-sm text-[#6B7280]">
                  <span className="text-white font-bold">{num(todayVisitors)}</span> today
                </p>
                <p className="text-sm text-[#6B7280]">
                  <span className="text-white font-bold">{num(yesterdayVisitors)}</span> yesterday
                </p>
                {streak > 1 && (
                  <p className="text-sm text-[#6B7280] flex items-center gap-1">
                    <Activity size={12} className="text-[#00FF88]" />
                    <span className="text-[#00FF88] font-bold">{streak}</span> day streak
                  </p>
                )}
              </div>
            )}
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
            {(["home","interview-prep","videos","learn","jobs"] as const).map(key => {
              const meta = SECTION_META[key];
              const Icon = meta.icon;
              const cur  = currentEvents.filter(e => e.section === key).length;
              const prev = previousEvents.filter(e => e.section === key).length;
              return (
                <div key={key} className="text-center px-4 py-3 rounded-xl"
                  style={{ background: `${meta.color}08`, border: `1px solid ${meta.color}15` }}>
                  <Icon size={14} style={{ color: meta.color }} className="mx-auto mb-1" />
                  <div className="text-lg font-black text-white">{hasTracking ? num(cur) : "—"}</div>
                  <div className="text-[9px] text-[#4B5563] font-semibold">{meta.label}</div>
                  {hasTracking && cur + prev > 0 && (
                    <div className="flex justify-center mt-1">
                      <DeltaBadge current={cur} previous={prev} />
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* ── Metric Cards ── */}
      <div className="grid grid-cols-2 sm:grid-cols-4 xl:grid-cols-7 gap-4">
        <MetricCard icon={Zap}         label="Today's Visitors"   value={hasTracking ? todayVisitors : "—"}
          current={todayVisitors} previous={yesterdayVisitors}
          color="#00FF88" bg="rgba(0,255,136,0.12)"  loading={loading} />
        <MetricCard icon={TrendingUp}  label={`${DATE_RANGES.find(r=>r.days===dateRange)?.label} Visitors`}
          value={hasTracking ? totalVisitors : "—"}
          current={totalVisitors} previous={prevTotalVisitors}
          color="#38bdf8" bg="rgba(56,189,248,0.12)" loading={loading} />
        <MetricCard icon={BrainCircuit}label="Interview Prep Views" value={totals.iq}
          color="#F59E0B" bg="rgba(245,158,11,0.12)"  loading={loading} />
        <MetricCard icon={Play}        label="Video Views"         value={totals.videos}
          color="#EF4444" bg="rgba(239,68,68,0.12)"   loading={loading} />
        <MetricCard icon={BookOpen}    label="Tutorial Views"      value={totals.learn}
          color="#00FF88" bg="rgba(0,255,136,0.12)"   loading={loading} />
        <MetricCard icon={Briefcase}   label="Active Jobs"         value={totals.jobs}
          color="#F97316" bg="rgba(249,115,22,0.12)"  loading={loading} />
        <MetricCard icon={Users}       label="Subscribers"         value={totals.subscribers}
          color="#8B5CF6" bg="rgba(139,92,246,0.12)" loading={loading} />
      </div>

      {/* ── Hourly Chart: Today vs Yesterday ── */}
      {hasTracking && (
        <div className="rounded-2xl p-6" style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.07)" }}>
          <div className="flex flex-wrap items-center justify-between gap-4 mb-5">
            <div>
              <h2 className="text-base font-black text-white flex items-center gap-2">
                <Clock size={15} className="text-[#F59E0B]" />
                Hourly Breakdown — Today vs Yesterday
              </h2>
              <p className="text-[10px] text-[#4B5563] mt-0.5">Visitor count per hour (your local timezone)</p>
            </div>
            <div className="flex items-center gap-4 text-[11px]">
              <span className="flex items-center gap-1.5"><span className="w-3 h-0.5 rounded bg-[#00FF88] inline-block" />Today</span>
              <span className="flex items-center gap-1.5"><span className="w-3 h-0.5 rounded bg-[#374151] inline-block border-dashed border-t border-[#6B7280]" />Yesterday</span>
            </div>
          </div>
          {loading ? (
            <div className="h-48 flex items-center justify-center"><Loader2 size={18} className="animate-spin text-[#00FF88]" /></div>
          ) : (
            <div className="h-48">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={hourlyData} margin={{ top: 4, right: 4, left: -20, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.04)" />
                  <XAxis dataKey="hour" tick={{ fill: "#4B5563", fontSize: 9 }} axisLine={false} tickLine={false}
                    interval={2} />
                  <YAxis tick={{ fill: "#4B5563", fontSize: 10 }} axisLine={false} tickLine={false} allowDecimals={false} />
                  <Tooltip content={<CustomTooltip />} />
                  <Line type="monotone" dataKey="Today" stroke="#00FF88" strokeWidth={2}
                    dot={false} activeDot={{ r: 4, fill: "#00FF88", strokeWidth: 0 }} />
                  <Line type="monotone" dataKey="Yesterday" stroke="#374151" strokeWidth={1.5}
                    strokeDasharray="4 3" dot={false} activeDot={{ r: 3, fill: "#6B7280", strokeWidth: 0 }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>
      )}

      {/* ── Daily Visitors Chart + Daily Table ── */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">

        {/* Area chart */}
        <div className="xl:col-span-2 rounded-2xl p-6" style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.07)" }}>
          <div className="flex flex-wrap items-center justify-between gap-4 mb-5">
            <div>
              <h2 className="text-base font-black text-white flex items-center gap-2">
                <TrendingUp size={15} className="text-[#00FF88]" />
                Daily Visitors
              </h2>
              {!hasTracking && <p className="text-[10px] text-[#4B5563] mt-0.5">Run the SQL above to see real visitor data</p>}
            </div>
            <div className="flex flex-wrap gap-1">
              {SECTION_TABS.map(s => (
                <button key={s.key} onClick={() => setSectionTab(s.key)}
                  className="px-2.5 py-1 rounded-lg text-[10px] font-semibold transition-all"
                  style={sectionTab === s.key
                    ? { background: `${s.color}20`, color: s.color, border: `1px solid ${s.color}40` }
                    : { color: "#6B7280", border: "1px solid transparent" }}>
                  {s.label}
                </button>
              ))}
            </div>
          </div>
          {loading ? (
            <div className="h-52 flex items-center justify-center"><Loader2 size={20} className="animate-spin text-[#00FF88]" /></div>
          ) : (
            <div className="h-52">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={dailyChartData} margin={{ top: 4, right: 4, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%"  stopColor={activeSectionColor} stopOpacity={0.25} />
                      <stop offset="95%" stopColor={activeSectionColor} stopOpacity={0}    />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.04)" />
                  <XAxis dataKey="label" tick={{ fill: "#4B5563", fontSize: 10 }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fill: "#4B5563", fontSize: 10 }} axisLine={false} tickLine={false} allowDecimals={false} />
                  <Tooltip content={<CustomTooltip />} />
                  <Area type="monotone" dataKey={activeDataKey}
                    stroke={activeSectionColor} strokeWidth={2}
                    fill="url(#areaGrad)"
                    dot={false} activeDot={{ r: 4, fill: activeSectionColor, strokeWidth: 0 }}
                    name={SECTION_TABS.find(s => s.key === sectionTab)?.label}
                  />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>

        {/* Daily breakdown table */}
        <div className="rounded-2xl overflow-hidden" style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.07)" }}>
          <div className="px-5 py-4 flex items-center gap-2" style={{ borderBottom: "1px solid rgba(255,255,255,0.05)" }}>
            <Hash size={14} className="text-[#00FF88]" />
            <h2 className="text-sm font-black text-white">Daily Visitor Count</h2>
          </div>
          <div className="divide-y divide-white/[0.04] overflow-y-auto max-h-[260px]">
            {loading ? (
              <div className="p-6 flex items-center justify-center">
                <Loader2 size={16} className="animate-spin text-[#00FF88]" />
              </div>
            ) : !hasTracking ? (
              <div className="p-6 text-center text-[11px] text-[#4B5563]">No tracking data</div>
            ) : recentDailyTable.map(day => (
              <div key={day.date} className={`flex items-center gap-3 px-5 py-2.5 transition-colors ${
                day.isToday ? "bg-[#00FF88]/5" : "hover:bg-white/[0.02]"
              }`}>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <span className="text-[11px] text-[#9CA3AF] font-medium">{day.label}</span>
                    {day.isToday && (
                      <span className="text-[9px] font-bold px-1.5 py-0.5 rounded-full"
                        style={{ background: "rgba(0,255,136,0.15)", color: "#00FF88" }}>TODAY</span>
                    )}
                    {day.isYesterday && (
                      <span className="text-[9px] font-bold text-[#4B5563]">YEST</span>
                    )}
                  </div>
                  <div className="mt-1 h-1.5 rounded-full overflow-hidden" style={{ background: "rgba(255,255,255,0.05)" }}>
                    <div className="h-full rounded-full transition-all"
                      style={{
                        width: `${(day.count / maxDayCount) * 100}%`,
                        background: day.isToday ? "#00FF88" : day.count > 0 ? "#374151" : "transparent",
                      }} />
                  </div>
                </div>
                <div className="text-right flex-shrink-0">
                  <span className={`text-sm font-black ${day.isToday ? "text-[#00FF88]" : day.count > 0 ? "text-white" : "text-[#374151]"}`}>
                    {day.count}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* ── Section Breakdown ── */}
      <div className="grid grid-cols-1 xl:grid-cols-5 gap-6">
        <div className="xl:col-span-2 rounded-2xl p-6" style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.07)" }}>
          <h2 className="text-base font-black text-white mb-5 flex items-center gap-2">
            <BarChart3 size={15} className="text-[#00FF88]" />
            Content Views by Section
          </h2>
          {loading ? (
            <div className="h-52 flex items-center justify-center"><Loader2 size={18} className="animate-spin text-[#00FF88]" /></div>
          ) : (
            <div className="h-52">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart
                  data={sectionBreakdown.filter(s => s.totalViews > 0 || s.visits > 0)}
                  layout="vertical" margin={{ top: 0, right: 8, left: 0, bottom: 0 }} barSize={10}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.04)" horizontal={false} />
                  <XAxis type="number" tick={{ fill: "#4B5563", fontSize: 9 }} axisLine={false} tickLine={false} />
                  <YAxis type="category" dataKey="label" tick={{ fill: "#6B7280", fontSize: 10 }} axisLine={false} tickLine={false} width={72} />
                  <Tooltip content={<CustomTooltip />} />
                  <Bar dataKey="totalViews" radius={[0, 4, 4, 0]} name="Views">
                    {sectionBreakdown.map(s => <Cell key={s.key} fill={s.color} />)}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>

        <div className="xl:col-span-3 grid grid-cols-2 sm:grid-cols-3 gap-3">
          {Object.entries(SECTION_META).map(([key, meta]) => {
            const s  = sectionBreakdown.find(b => b.key === key);
            const sc = sectionComparison.find(b => b.key === key);
            const Icon = meta.icon;
            return (
              <motion.div key={key} whileHover={{ scale: 1.02 }} transition={{ duration: 0.15 }}
                className="rounded-2xl p-4 relative overflow-hidden"
                style={{ background: "#0d0d0d", border: `1px solid ${meta.color}18` }}>
                <div className="absolute top-0 right-0 w-16 h-16 rounded-full pointer-events-none"
                  style={{ background: `radial-gradient(circle, ${meta.color}12, transparent)`, transform: "translate(4px, -4px)" }} />
                <div className="flex items-start justify-between mb-3">
                  <div className="w-8 h-8 rounded-xl flex items-center justify-center" style={{ background: meta.bg }}>
                    <Icon size={14} style={{ color: meta.color }} />
                  </div>
                  {sc && hasTracking && (
                    <DeltaBadge current={sc.today} previous={sc.yesterday} />
                  )}
                </div>
                <div className="text-lg font-black text-white leading-none mb-0.5">
                  {loading ? "—" : num(s?.totalViews || 0)}
                </div>
                <div className="text-[10px] font-semibold text-[#6B7280]">{meta.label} views</div>
                {hasTracking && (
                  <div className="text-[9px] text-[#374151] mt-1">{s?.visits || 0} visits tracked</div>
                )}
              </motion.div>
            );
          })}
        </div>
      </div>

      {/* ── Top Content Table ── */}
      <div className="rounded-2xl overflow-hidden" style={{ background: "#0d0d0d", border: "1px solid rgba(255,255,255,0.07)" }}>
        <div className="flex flex-wrap items-center justify-between gap-3 px-6 py-4"
          style={{ borderBottom: "1px solid rgba(255,255,255,0.06)" }}>
          <h2 className="text-base font-black text-white flex items-center gap-2">
            <Eye size={15} className="text-[#00FF88]" />
            Top Content
          </h2>
          <div className="flex items-center gap-2">
            <div className="relative">
              <select value={filterSection} onChange={e => setFilterSection(e.target.value)}
                className="appearance-none pl-3 pr-8 py-1.5 rounded-lg text-xs font-semibold text-[#9CA3AF] outline-none cursor-pointer"
                style={{ background: "#161616", border: "1px solid rgba(255,255,255,0.08)" }}>
                <option value="all">All Sections</option>
                {Object.entries(SECTION_META).map(([k, m]) => (
                  <option key={k} value={k}>{m.label}</option>
                ))}
              </select>
              <ChevronDown size={11} className="absolute right-2 top-1/2 -translate-y-1/2 text-[#4B5563] pointer-events-none" />
            </div>
            <div className="flex items-center gap-1 p-0.5 rounded-lg" style={{ background: "#161616", border: "1px solid rgba(255,255,255,0.07)" }}>
              {(["views", "date"] as const).map(s => (
                <button key={s} onClick={() => setSortBy(s)}
                  className="px-2.5 py-1 rounded-md text-[10px] font-semibold transition-all capitalize"
                  style={sortBy === s ? { background: "#00FF88", color: "#000" } : { color: "#6B7280" }}>
                  {s === "views" ? "Top Views" : "Newest"}
                </button>
              ))}
            </div>
          </div>
        </div>

        {loading ? (
          <div className="p-8 flex items-center justify-center">
            <Loader2 size={20} className="animate-spin text-[#00FF88]" />
          </div>
        ) : filteredContent.length === 0 ? (
          <div className="p-8 text-center text-[#4B5563] text-sm">No content found</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr style={{ borderBottom: "1px solid rgba(255,255,255,0.05)" }}>
                  {["#", "Title", "Section", "Views", "Published"].map(h => (
                    <th key={h} className="px-5 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-[#4B5563]">{h}</th>
                  ))}
                  <th className="px-5 py-3" />
                </tr>
              </thead>
              <tbody>
                {filteredContent.map((item, i) => {
                  const meta = SECTION_META[item.section];
                  const href = item.section === "interview-prep" ? `/interview-prep/${item.slug}`
                    : item.section === "learn"           ? `/learn/${item.slug}`
                    : item.section === "blog"            ? `/blog/${item.slug}`
                    : item.section === "automation-tips" ? `/automation-tips/${item.slug}`
                    : item.section === "videos"          ? `/videos/${item.id}`
                    : item.section === "jobs"            ? `/jobs/${item.id}`
                    : null;
                  return (
                    <motion.tr key={item.id}
                      initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: i * 0.02 }}
                      className="group transition-colors"
                      style={{ borderBottom: "1px solid rgba(255,255,255,0.03)" }}
                      onMouseEnter={e => (e.currentTarget.style.background = "rgba(255,255,255,0.02)")}
                      onMouseLeave={e => (e.currentTarget.style.background = "transparent")}>
                      <td className="px-5 py-3 text-[11px] font-black text-[#374151] w-8">{i + 1}</td>
                      <td className="px-5 py-3 max-w-xs">
                        <div className="flex flex-col">
                          <span className="text-sm text-white font-medium line-clamp-1">{item.title}</span>
                          {item.extra && <span className="text-[10px] text-[#4B5563]">{item.extra}</span>}
                        </div>
                      </td>
                      <td className="px-5 py-3">
                        <span className="px-2 py-0.5 rounded-md text-[10px] font-semibold"
                          style={{ background: `${item.color}12`, color: item.color, border: `1px solid ${item.color}25` }}>
                          {meta?.label || item.sectionLabel}
                        </span>
                      </td>
                      <td className="px-5 py-3">
                        <div className="flex items-center gap-2">
                          <span className="text-sm font-bold text-white">{num(item.views)}</span>
                          <div className="flex-1 h-1 rounded-full max-w-[60px]"
                            style={{ background: "rgba(255,255,255,0.04)" }}>
                            <div className="h-full rounded-full"
                              style={{
                                background: item.color,
                                width: `${Math.min(100, (item.views / Math.max(...filteredContent.map(c => c.views), 1)) * 100)}%`,
                              }} />
                          </div>
                        </div>
                      </td>
                      <td className="px-5 py-3 text-[11px] text-[#4B5563]">
                        {new Date(item.created_at).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })}
                      </td>
                      <td className="px-5 py-3">
                        {href && (
                          <a href={href} target="_blank" rel="noopener noreferrer"
                            className="opacity-0 group-hover:opacity-100 transition-opacity p-1.5 rounded-lg hover:bg-white/8"
                            title="View page">
                            <ExternalLink size={12} className="text-[#6B7280]" />
                          </a>
                        )}
                      </td>
                    </motion.tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
