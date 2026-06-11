"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import Link from "next/link";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { createClient } from "@supabase/supabase-js";
import {
  Search, X, Eye, ChevronDown, Zap, Code2, Users, TrendingUp,
  Filter, Loader2, BookOpen, BrainCircuit, ArrowRight, Sparkles,
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { InterviewQuestion } from "@/types";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

/* ── accent colors per technology ──────────────────────────────────────── */
const TECH_ACCENT: Record<string, string> = {
  "Selenium":              "#f59e0b",
  "Playwright":            "#a78bfa",
  "Cypress":               "#34d399",
  "Core Java":             "#fb923c",
  "Rest Assured":          "#a3e635",
  "API Automation":        "#4ade80",
  "WebdriverIO":           "#f43f5e",
  "Page Object Model":     "#818cf8",
  "Hybrid Framework":      "#6366f1",
  "Data-Driven Framework": "#22d3ee",
  "CI/CD Integration":     "#f472b6",
  "Cucumber":              "#4ade80",
  "TestNG":                "#c084fc",
  "BDD":                   "#2dd4bf",
  "Gherkin":               "#86efac",
  "Jenkins":               "#f87171",
  "GitHub Actions":        "#94a3b8",
  "Azure DevOps":          "#38bdf8",
  "SQL":                   "#60a5fa",
  "Database Testing":      "#3b82f6",
  "Postman":               "#fb923c",
  "Scenario-Based":        "#fbbf24",
  "Managerial":            "#94a3b8",
  "HR":                    "#f9a8d4",
  "General":               "#9ca3af",
  "OOPs":                  "#e879f9",
  "Collections":           "#fdba74",
  "Multithreading":        "#7dd3fc",
  "Streams":               "#86efac",
  "Exception Handling":    "#fca5a5",
  "Keyword-Driven Framework": "#a5f3fc",
};

const DIFF_CONFIG: Record<string, { color: string; glow: string; label: string }> = {
  Beginner:     { color: "#4ade80", glow: "rgba(74,222,128,0.15)",   label: "Beginner" },
  Intermediate: { color: "#fbbf24", glow: "rgba(251,191,36,0.15)",   label: "Intermediate" },
  Advanced:     { color: "#f87171", glow: "rgba(248,113,113,0.15)",  label: "Advanced" },
};

const TECH_CATEGORIES = [
  { name: "Selenium",          icon: "🌐" },
  { name: "Playwright",        icon: "🎭" },
  { name: "Cypress",           icon: "🌲" },
  { name: "Core Java",         icon: "☕" },
  { name: "Rest Assured",      icon: "🔌" },
  { name: "API Automation",    icon: "⚡" },
  { name: "Page Object Model", icon: "📐" },
  { name: "Cucumber",          icon: "🥒" },
  { name: "TestNG",            icon: "🧪" },
  { name: "Jenkins",           icon: "🔧" },
  { name: "GitHub Actions",    icon: "⚙️" },
  { name: "SQL",               icon: "🗄️" },
  { name: "Scenario-Based",    icon: "🎯" },
  { name: "Managerial",        icon: "💼" },
  { name: "HR",                icon: "🤝" },
];

const DIFFICULTIES      = ["Beginner", "Intermediate", "Advanced"];
const EXPERIENCE_LEVELS = ["Fresher", "1-2 Years", "3-5 Years", "5+ Years", "Senior SDET"];
const QUESTION_TYPES    = ["Technical", "Scenario-Based", "Coding", "Managerial", "HR", "Framework Design", "API Testing", "Real-Time Issues", "CI/CD", "Debugging"];
const PAGE_SIZE         = 12;
const SELECT_FIELDS     = "id,question,slug,short_description,answer,technology,question_type,experience_level,difficulty,tags,featured,views,created_at,real_world_example,code_snippet,youtube_url";

interface Props { initialQuestions: InterviewQuestion[] }

export default function InterviewPrepListing({ initialQuestions }: Props) {
  const [searchInput,     setSearchInput]     = useState("");
  const [search,          setSearch]          = useState("");
  const [technology,      setTechnology]      = useState<string | null>(null);
  const [difficulty,      setDifficulty]      = useState<string | null>(null);
  const [experienceLevel, setExperienceLevel] = useState<string | null>(null);
  const [questionType,    setQuestionType]    = useState<string | null>(null);
  const [questions,       setQuestions]       = useState<InterviewQuestion[]>(initialQuestions);
  const [loading,         setLoading]         = useState(false);
  const [loadingMore,     setLoadingMore]     = useState(false);
  const [hasMore,         setHasMore]         = useState(initialQuestions.length === PAGE_SIZE);
  const [offset,          setOffset]          = useState(PAGE_SIZE);
  const [showFilters,     setShowFilters]     = useState(false);
  const [expandedId,      setExpandedId]      = useState<string | null>(null);
  const debounceRef   = useRef<ReturnType<typeof setTimeout> | null>(null);
  const isFirstRender = useRef(true);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setSearch(searchInput), 400);
    return () => { if (debounceRef.current) clearTimeout(debounceRef.current); };
  }, [searchInput]);

  const buildQuery = useCallback(() => {
    let q = supabase.from("interview_questions").select(SELECT_FIELDS).eq("published", true);
    if (technology)      q = q.eq("technology",       technology);
    if (difficulty)      q = q.eq("difficulty",       difficulty);
    if (experienceLevel) q = q.eq("experience_level", experienceLevel);
    if (questionType)    q = q.eq("question_type",    questionType);
    if (search) {
      const safe = search.replace(/[%_\\]/g, "\\$&");
      q = q.or(`question.ilike.%${safe}%,short_description.ilike.%${safe}%`);
    }
    return q.order("featured", { ascending: false }).order("views", { ascending: false }).order("created_at", { ascending: false });
  }, [technology, difficulty, experienceLevel, questionType, search]);

  const fetchQuestions = useCallback(async () => {
    if (isFirstRender.current) { isFirstRender.current = false; return; }
    setLoading(true); setExpandedId(null);
    try {
      const { data } = await buildQuery().range(0, PAGE_SIZE - 1);
      setQuestions((data || []) as InterviewQuestion[]);
      setHasMore((data || []).length === PAGE_SIZE);
      setOffset(PAGE_SIZE);
    } catch { setQuestions([]); }
    setLoading(false);
  }, [buildQuery]);

  useEffect(() => { fetchQuestions(); }, [fetchQuestions]);

  const loadMore = async () => {
    setLoadingMore(true);
    try {
      const { data } = await buildQuery().range(offset, offset + PAGE_SIZE - 1);
      const items = (data || []) as InterviewQuestion[];
      setQuestions(prev => [...prev, ...items]);
      setHasMore(items.length === PAGE_SIZE);
      setOffset(prev => prev + PAGE_SIZE);
    } catch {}
    setLoadingMore(false);
  };

  const clearFilters = () => {
    setTechnology(null); setDifficulty(null); setExperienceLevel(null);
    setQuestionType(null); setSearchInput(""); setSearch("");
  };

  const hasFilters = !!(technology || difficulty || experienceLevel || questionType || search);
  const featuredQs = initialQuestions.filter(q => q.featured).slice(0, 3);

  return (
    <div className="min-h-screen bg-[#070707] pt-16">

      {/* ── Hero ─────────────────────────────────────────────────── */}
      <section className="relative overflow-hidden" style={{ borderBottom: "1px solid rgba(255,255,255,0.04)" }}>
        <div className="absolute inset-0" style={{ background: "linear-gradient(180deg, #0D0D0D 0%, #070707 100%)" }} />
        <div className="absolute inset-0" style={{
          backgroundImage: "radial-gradient(rgba(0,255,136,0.06) 1px, transparent 1px)",
          backgroundSize: "32px 32px",
        }} />
        <div className="absolute top-0 left-1/4 w-[700px] h-[400px] rounded-full blur-[200px] pointer-events-none"
          style={{ background: "radial-gradient(ellipse, rgba(0,255,136,0.07) 0%, transparent 70%)" }} />
        <div className="absolute top-0 right-1/4 w-[500px] h-[300px] rounded-full blur-[180px] pointer-events-none"
          style={{ background: "radial-gradient(ellipse, rgba(139,92,246,0.06) 0%, transparent 70%)" }} />

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 sm:py-28 text-center">
          <motion.div initial={{ opacity: 0, y: 24 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
            <div className="inline-flex items-center gap-2 px-4 py-2 mb-6 rounded-full text-xs font-black uppercase tracking-[0.18em]"
              style={{ border: "1px solid rgba(0,255,136,0.2)", background: "rgba(0,255,136,0.07)", color: "#00FF88" }}>
              <Zap size={10} className="fill-current" /> Interview Prep
            </div>
            <h1 className="text-5xl sm:text-6xl lg:text-[4.5rem] font-black text-white leading-[1.02] tracking-tight mb-5">
              Master <span style={{ color: "#00FF88" }}>QA Automation</span>
              <br className="hidden sm:block" /> Interviews
            </h1>
            <p className="text-[#6B7280] text-lg max-w-2xl mx-auto mb-10 leading-relaxed">
              Real-world questions with structured answers, scenario walkthroughs,
              coding challenges, and framework deep-dives.
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15, duration: 0.5 }}
            className="max-w-2xl mx-auto relative mb-10"
          >
            <Search size={16} className="absolute left-5 top-1/2 -translate-y-1/2 pointer-events-none" style={{ color: "#4B5563" }} />
            <input type="text" value={searchInput} onChange={e => setSearchInput(e.target.value)}
              placeholder="Search Selenium waits, Playwright fixtures, API testing..."
              className="w-full pl-12 pr-12 py-4 text-white text-sm focus:outline-none transition-all"
              style={{
                background: "rgba(255,255,255,0.04)", backdropFilter: "blur(12px)",
                border: "1px solid rgba(255,255,255,0.08)", borderRadius: 16,
                boxShadow: "0 8px 40px rgba(0,0,0,0.4)",
              }}
              onFocus={e => e.currentTarget.style.borderColor = "rgba(0,255,136,0.4)"}
              onBlur={e => e.currentTarget.style.borderColor = "rgba(255,255,255,0.08)"}
            />
            {searchInput && (
              <button onClick={() => setSearchInput("")} className="absolute right-4 top-1/2 -translate-y-1/2 transition-colors"
                style={{ color: "#4B5563" }}>
                <X size={14} />
              </button>
            )}
          </motion.div>

          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.3 }}
            className="flex flex-wrap justify-center gap-6 sm:gap-10">
            {[
              { icon: <Code2 size={13} />,       label: "Coding Questions" },
              { icon: <Users size={13} />,        label: "All Experience Levels" },
              { icon: <TrendingUp size={13} />,   label: "15+ Technologies" },
              { icon: <BrainCircuit size={13} />, label: "Real-World Scenarios" },
            ].map(({ icon, label }) => (
              <div key={label} className="flex items-center gap-2 text-sm" style={{ color: "#4B5563" }}>
                <span style={{ color: "#00FF88" }}>{icon}</span>{label}
              </div>
            ))}
          </motion.div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-14">

        {/* ── Category grid ─────────────────────────────────── */}
        <section>
          <SectionHeading accent="#00FF88">Browse by Topic</SectionHeading>
          <div className="grid grid-cols-3 sm:grid-cols-5 md:grid-cols-6 lg:grid-cols-8 xl:grid-cols-10 gap-2 mt-5">
            {TECH_CATEGORIES.map(cat => {
              const ac = TECH_ACCENT[cat.name] || "#6b7280";
              const isActive = technology === cat.name;
              return (
                <button key={cat.name} onClick={() => setTechnology(isActive ? null : cat.name)}
                  className="flex flex-col items-center gap-1.5 p-3 rounded-xl text-center transition-all duration-200"
                  style={{
                    border:     `1px solid ${isActive ? `${ac}50` : "rgba(255,255,255,0.05)"}`,
                    background: isActive ? `${ac}12` : "rgba(255,255,255,0.015)",
                    boxShadow:  isActive ? `0 0 20px ${ac}15, inset 0 1px 0 ${ac}20` : undefined,
                  }}>
                  <span className="text-xl">{cat.icon}</span>
                  <span className="text-[9px] font-bold leading-tight" style={{ color: isActive ? ac : "#4B5563" }}>
                    {cat.name}
                  </span>
                </button>
              );
            })}
          </div>
        </section>

        {/* ── Featured ──────────────────────────────────────── */}
        {featuredQs.length > 0 && !hasFilters && (
          <section>
            <SectionHeading accent="#fbbf24">★ Featured Questions</SectionHeading>
            <div className="space-y-3 mt-5">
              {featuredQs.map((q, i) => (
                <QuestionCard key={q.id} question={q} index={i} featured
                  expanded={expandedId === q.id}
                  onToggle={() => setExpandedId(expandedId === q.id ? null : q.id)} />
              ))}
            </div>
          </section>
        )}

        {/* ── Filter bar + list ─────────────────────────────── */}
        <section>
          <div className="flex flex-wrap items-center gap-2 mb-4">
            <button onClick={() => setShowFilters(!showFilters)}
              className="flex items-center gap-2 px-4 py-2 rounded-xl border text-sm font-semibold transition-all"
              style={hasFilters
                ? { border: "1px solid rgba(0,255,136,0.35)", background: "rgba(0,255,136,0.08)", color: "#00FF88" }
                : { border: "1px solid rgba(255,255,255,0.07)", background: "rgba(255,255,255,0.03)", color: "#6B7280" }}>
              <Filter size={13} />
              {hasFilters ? "Filters (active)" : "Filters"}
            </button>
            {[
              { val: difficulty,      clear: () => setDifficulty(null) },
              { val: experienceLevel, clear: () => setExperienceLevel(null) },
              { val: questionType,    clear: () => setQuestionType(null) },
            ].map(({ val, clear }) => val ? (
              <button key={val} onClick={clear}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium transition-all"
                style={{ border: "1px solid rgba(255,255,255,0.07)", color: "#9CA3AF", background: "rgba(255,255,255,0.03)" }}>
                {val} <X size={9} />
              </button>
            ) : null)}
            {hasFilters && (
              <button onClick={clearFilters}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium transition-all"
                style={{ border: "1px solid rgba(248,113,113,0.2)", color: "#f87171", background: "rgba(248,113,113,0.05)" }}>
                Clear All <X size={9} />
              </button>
            )}
          </div>

          <AnimatePresence>
            {showFilters && (
              <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }}
                exit={{ height: 0, opacity: 0 }} transition={{ duration: 0.2 }}
                className="overflow-hidden mb-6">
                <div className="p-5 rounded-2xl space-y-4"
                  style={{ border: "1px solid rgba(255,255,255,0.05)", background: "rgba(255,255,255,0.015)" }}>
                  <FilterRow label="Difficulty"    options={DIFFICULTIES}      value={difficulty}      onChange={setDifficulty} />
                  <FilterRow label="Experience"    options={EXPERIENCE_LEVELS} value={experienceLevel} onChange={setExperienceLevel} />
                  <FilterRow label="Question Type" options={QUESTION_TYPES}    value={questionType}    onChange={setQuestionType} />
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          <div className="flex items-center justify-between mb-6">
            <SectionHeading accent="#00FF88">
              {hasFilters ? "Filtered Results" : technology ? `${technology} Questions` : "All Questions"}
            </SectionHeading>
            <span className="text-xs font-mono" style={{ color: "#2A2A2A" }}>
              {loading ? "..." : `${questions.length} Q`}
            </span>
          </div>

          {loading ? (
            <div className="flex justify-center py-24">
              <Loader2 className="animate-spin" size={28} style={{ color: "#00FF88" }} />
            </div>
          ) : questions.length === 0 ? (
            <div className="text-center py-20 rounded-2xl" style={{ border: "1px dashed rgba(255,255,255,0.06)" }}>
              <BookOpen size={40} className="mx-auto mb-4" style={{ color: "#1A1A1A" }} />
              <p className="text-sm" style={{ color: "#4B5563" }}>No questions found.</p>
              <button onClick={clearFilters} className="mt-4 text-sm hover:underline" style={{ color: "#00FF88" }}>Clear filters</button>
            </div>
          ) : (
            <div className="space-y-3">
              {questions.map((q, i) => (
                <motion.div key={q.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: Math.min(i * 0.04, 0.3), duration: 0.3 }}>
                  <QuestionCard question={q} index={i}
                    expanded={expandedId === q.id}
                    onToggle={() => setExpandedId(expandedId === q.id ? null : q.id)} />
                </motion.div>
              ))}
            </div>
          )}

          {hasMore && !loading && (
            <div className="flex justify-center mt-10">
              <button onClick={loadMore} disabled={loadingMore}
                className="flex items-center gap-2 px-8 py-3 rounded-xl text-sm font-semibold transition-all disabled:opacity-40"
                style={{ border: "1px solid rgba(255,255,255,0.08)", background: "rgba(255,255,255,0.03)", color: "#6B7280" }}>
                {loadingMore && <Loader2 size={13} className="animate-spin" />}
                {loadingMore ? "Loading..." : "Load More Questions"}
              </button>
            </div>
          )}
        </section>
      </div>
    </div>
  );
}

/* ── Premium Question Card ──────────────────────────────────────────────── */

function QuestionCard({ question: q, index, expanded, onToggle, featured = false }: {
  question: InterviewQuestion;
  index: number;
  expanded: boolean;
  onToggle: () => void;
  featured?: boolean;
}) {
  const ac   = TECH_ACCENT[q.technology] || "#6b7280";
  const diff = DIFF_CONFIG[q.difficulty] || { color: "#6b7280", glow: "rgba(107,114,128,0.12)", label: q.difficulty };
  const tags: string[] = Array.isArray(q.tags) ? q.tags : [];
  const num  = String(index + 1).padStart(2, "0");

  return (
    <div
      className="relative rounded-2xl overflow-hidden transition-all duration-300"
      style={{
        border:     `1px solid ${expanded ? `${ac}30` : "rgba(255,255,255,0.06)"}`,
        background: expanded
          ? `linear-gradient(145deg, ${ac}08 0%, #0A0A0A 55%)`
          : "#0C0C0C",
        boxShadow: expanded
          ? `0 0 0 1px ${ac}18, 0 16px 60px rgba(0,0,0,0.7), 0 4px 20px ${ac}10`
          : "0 1px 0 rgba(255,255,255,0.03)",
      }}
    >
      {/* Glowing left bar */}
      <div className="absolute left-0 top-0 bottom-0 w-[3px] rounded-l-2xl"
        style={{ background: expanded ? `linear-gradient(180deg, ${ac}, ${ac}60)` : `${ac}30`,
          boxShadow: expanded ? `2px 0 12px ${ac}40` : undefined }} />

      {/* Top shimmer line when expanded */}
      {expanded && (
        <div className="absolute top-0 left-[3px] right-0 h-px"
          style={{ background: `linear-gradient(90deg, ${ac}50, ${ac}15, transparent)` }} />
      )}

      {/* ── Question header ── */}
      <button onClick={onToggle} className="w-full flex items-start gap-4 pl-6 pr-5 py-5 text-left group">
        {/* Number badge */}
        <div className="flex-shrink-0 mt-0.5 w-10 h-10 rounded-xl flex items-center justify-center transition-all duration-200"
          style={{
            background:  expanded ? `${ac}20` : "rgba(255,255,255,0.03)",
            border:      `1px solid ${expanded ? `${ac}45` : "rgba(255,255,255,0.06)"}`,
            boxShadow:   expanded ? `0 0 12px ${ac}25` : undefined,
          }}>
          <span className="text-[11px] font-black font-mono transition-colors"
            style={{ color: expanded ? ac : "#3A3A3A" }}>
            {num}
          </span>
        </div>

        <div className="flex-1 min-w-0">
          {/* Question text */}
          <p className="font-bold text-[17px] leading-snug transition-colors duration-200"
            style={{ color: expanded ? ac : "#E5E7EB" }}>
            {q.question}
          </p>

          {/* Short desc when collapsed */}
          {!expanded && q.short_description && (
            <p className="text-xs leading-relaxed mt-1.5 line-clamp-1" style={{ color: "#3A3A3A" }}>
              {q.short_description}
            </p>
          )}
        </div>

        {/* Right meta */}
        <div className="flex-shrink-0 flex items-center gap-2.5 mt-1">
          {q.views > 0 && (
            <span className="hidden sm:flex items-center gap-1 font-mono text-[10px]" style={{ color: "#2A2A2A" }}>
              <Eye size={9} />{q.views}
            </span>
          )}
          <div className="w-7 h-7 rounded-lg flex items-center justify-center transition-all duration-200"
            style={{
              background:  expanded ? `${ac}20` : "rgba(255,255,255,0.03)",
              border:      `1px solid ${expanded ? `${ac}40` : "rgba(255,255,255,0.06)"}`,
              boxShadow:   expanded ? `0 0 8px ${ac}20` : undefined,
            }}>
            <ChevronDown size={12}
              className={`transition-transform duration-300 ${expanded ? "rotate-180" : ""}`}
              style={{ color: expanded ? ac : "#3A3A3A" }} />
          </div>
        </div>
      </button>

      {/* ── Expanded Answer ── */}
      <AnimatePresence>
        {expanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.3, ease: [0.4, 0, 0.2, 1] }}
            className="overflow-hidden"
          >
            {/* Answer card */}
            <div className="mx-4 mb-4 rounded-xl overflow-hidden"
              style={{ border: `1px solid ${ac}18`, background: "rgba(0,0,0,0.4)" }}>

              {/* Answer card header */}
              <div className="flex items-center gap-3 px-5 py-3"
                style={{
                  background: `linear-gradient(90deg, ${ac}12, rgba(0,0,0,0))`,
                  borderBottom: `1px solid ${ac}15`,
                }}>
                <Sparkles size={12} style={{ color: ac }} />
                <span className="text-[10px] font-black uppercase tracking-[0.25em]" style={{ color: ac }}>
                  Model Answer
                </span>
                <div className="flex-1 h-px" style={{ background: `linear-gradient(90deg, ${ac}30, transparent)` }} />
                <span className="text-[9px] font-mono px-2 py-0.5 rounded"
                  style={{ background: `${ac}15`, color: `${ac}90`, border: `1px solid ${ac}20` }}>
                  {q.difficulty}
                </span>
              </div>

              {/* Answer body */}
              <div className="px-5 py-5">
                {q.answer ? (
                  <AnswerContent content={q.answer} accent={ac} />
                ) : (
                  <p className="text-sm italic" style={{ color: "#2A2A2A" }}>No answer added yet.</p>
                )}
              </div>

              {/* "What's inside the full guide" strip — only when extras exist */}
              {(q.real_world_example || q.code_snippet || q.youtube_url) && (
                <div className="mx-5 mb-4 px-4 py-3 rounded-xl flex flex-wrap items-center gap-x-3 gap-y-2"
                  style={{ background: `${ac}08`, border: `1px dashed ${ac}25` }}>
                  <span className="text-[10px] font-bold uppercase tracking-widest flex-shrink-0"
                    style={{ color: `${ac}80` }}>
                    Full guide also includes:
                  </span>
                  <div className="flex flex-wrap items-center gap-1.5">
                    {q.real_world_example && (
                      <span className="flex items-center gap-1 text-[10px] font-semibold px-2 py-1 rounded-md"
                        style={{ color: "#fbbf24", background: "rgba(251,191,36,0.1)", border: "1px solid rgba(251,191,36,0.2)" }}>
                        ★ Real-World Example
                      </span>
                    )}
                    {q.code_snippet && (
                      <span className="flex items-center gap-1 text-[10px] font-semibold px-2 py-1 rounded-md"
                        style={{ color: "#38bdf8", background: "rgba(56,189,248,0.1)", border: "1px solid rgba(56,189,248,0.2)" }}>
                        {"</>"} Code Snippet
                      </span>
                    )}
                    {q.youtube_url && (
                      <span className="flex items-center gap-1 text-[10px] font-semibold px-2 py-1 rounded-md"
                        style={{ color: "#f87171", background: "rgba(248,113,113,0.1)", border: "1px solid rgba(248,113,113,0.2)" }}>
                        ▶ Video Explanation
                      </span>
                    )}
                  </div>
                </div>
              )}

              {/* Footer */}
              <div className="flex items-center justify-end px-5 py-3.5"
                style={{ borderTop: `1px solid ${ac}12`, background: `${ac}05` }}>
                <Link href={`/interview-prep/${q.slug}`} onClick={e => e.stopPropagation()}
                  className="flex items-center gap-1.5 text-xs font-bold px-4 py-2 rounded-lg transition-all"
                  style={{ color: ac, border: `1px solid ${ac}30`, background: `${ac}10` }}>
                  View Full Guide <ArrowRight size={11} />
                </Link>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

/* ── Answer content renderer ──────────────────────────────────────────── */

function AnswerContent({ content, accent: ac }: { content: string; accent: string }) {
  return (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
      components={{
        p: ({ children }) => {
          // Detect short list-item-like lines (no terminal punctuation, short length)
          const text = typeof children === "string" ? children
            : Array.isArray(children) ? children.map(c => typeof c === "string" ? c : "").join("") : "";
          const isItem = text.trim().length > 0 && text.trim().length < 80
            && !text.trim().endsWith(".") && !text.trim().endsWith(":")
            && !text.trim().endsWith("?") && !text.trim().includes("\n");
          if (isItem) {
            return (
              <div className="flex items-start gap-3 py-1.5">
                <span className="flex-shrink-0 w-5 h-5 rounded-full flex items-center justify-center mt-0.5 text-[9px] font-black"
                  style={{ background: `${ac}18`, color: ac, border: `1px solid ${ac}30` }}>
                  ▸
                </span>
                <span className="text-[14px] leading-relaxed" style={{ color: "#C9D1D9" }}>{children}</span>
              </div>
            );
          }
          return <p className="text-[14px] leading-[1.85] mb-3 last:mb-0" style={{ color: "#9CA3AF" }}>{children}</p>;
        },
        strong: ({ children }) => (
          <strong className="font-bold" style={{ color: "#E5E7EB" }}>{children}</strong>
        ),
        em: ({ children }) => (
          <em style={{ color: "#9CA3AF", fontStyle: "italic" }}>{children}</em>
        ),
        ul: ({ children }) => <ul className="space-y-1.5 my-3 ml-1">{children}</ul>,
        ol: ({ children }) => <ol className="space-y-1.5 my-3 ml-1">{children}</ol>,
        li: ({ children }) => (
          <li className="flex items-start gap-3 text-[14px] leading-relaxed" style={{ color: "#C9D1D9" }}>
            <span className="flex-shrink-0 w-5 h-5 rounded-full flex items-center justify-center mt-0.5 text-[9px] font-black"
              style={{ background: `${ac}18`, color: ac, border: `1px solid ${ac}30` }}>
              ✓
            </span>
            <span className="flex-1">{children}</span>
          </li>
        ),
        h2: ({ children }) => (
          <div className="flex items-center gap-2.5 mt-6 mb-3 pb-2"
            style={{ borderBottom: `1px solid ${ac}20` }}>
            <span className="w-1 h-5 rounded-full flex-shrink-0" style={{ background: ac }} />
            <h2 className="text-[15px] font-black" style={{ color: "#F3F4F6" }}>{children}</h2>
          </div>
        ),
        h3: ({ children }) => (
          <h3 className="text-[13px] font-bold mt-4 mb-2 flex items-center gap-2" style={{ color: "#D1D5DB" }}>
            <span className="w-1.5 h-1.5 rounded-full" style={{ background: ac }} />
            {children}
          </h3>
        ),
        code: ({ children, className }) => {
          const isBlock = className?.includes("language-");
          const lang = (className || "").replace("language-", "") || "code";
          return isBlock ? (
            <div className="my-4 rounded-xl overflow-hidden" style={{ border: "1px solid rgba(255,255,255,0.07)" }}>
              <div className="flex items-center gap-2 px-4 py-2" style={{ background: "rgba(0,0,0,0.6)", borderBottom: "1px solid rgba(255,255,255,0.05)" }}>
                <span className="w-2.5 h-2.5 rounded-full bg-red-500/50" />
                <span className="w-2.5 h-2.5 rounded-full bg-yellow-500/50" />
                <span className="w-2.5 h-2.5 rounded-full bg-green-500/50" />
                <span className="text-[10px] font-mono ml-2" style={{ color: "#3A3A3A" }}>{lang}</span>
              </div>
              <pre style={{ background: "#050505", padding: "16px", overflowX: "auto", margin: 0 }}>
                <code className="text-[12px] font-mono leading-relaxed" style={{ color: "#C9D1D9" }}>{children}</code>
              </pre>
            </div>
          ) : (
            <code className="px-1.5 py-0.5 rounded text-[12px] font-mono"
              style={{ background: `${ac}14`, color: ac, border: `1px solid ${ac}25` }}>
              {children}
            </code>
          );
        },
        blockquote: ({ children }) => (
          <blockquote className="my-4 pl-4 py-2 rounded-r-lg italic text-[13px]"
            style={{ borderLeft: `3px solid ${ac}50`, background: `${ac}07`, color: "#9CA3AF" }}>
            {children}
          </blockquote>
        ),
        hr: () => (
          <div className="my-4 h-px" style={{ background: `linear-gradient(90deg, ${ac}25, transparent)` }} />
        ),
        table: ({ children }) => (
          <div className="overflow-x-auto my-4 rounded-xl" style={{ border: "1px solid rgba(255,255,255,0.07)" }}>
            <table className="w-full text-[13px]">{children}</table>
          </div>
        ),
        th: ({ children }) => (
          <th className="text-left px-4 py-2.5 font-bold text-xs uppercase tracking-wider"
            style={{ background: `${ac}12`, color: ac, borderBottom: `1px solid ${ac}20` }}>{children}</th>
        ),
        td: ({ children }) => (
          <td className="px-4 py-2.5 border-b" style={{ color: "#9CA3AF", borderColor: "rgba(255,255,255,0.04)" }}>{children}</td>
        ),
      }}
    >
      {content}
    </ReactMarkdown>
  );
}

/* ── Helpers ───────────────────────────────────────────────────────────── */

function SectionHeading({ accent, children }: { accent: string; children: React.ReactNode }) {
  return (
    <h2 className="text-sm font-black text-white flex items-center gap-2.5 uppercase tracking-widest">
      <span className="w-[3px] h-4 rounded-full" style={{ background: accent }} />
      {children}
    </h2>
  );
}

function FilterRow({ label, options, value, onChange }: {
  label: string; options: string[]; value: string | null; onChange: (v: string | null) => void;
}) {
  return (
    <div className="flex flex-wrap items-start gap-2">
      <span className="text-[9px] font-black uppercase tracking-[0.15em] w-24 pt-1.5 shrink-0" style={{ color: "#3A3A3A" }}>
        {label}
      </span>
      <div className="flex flex-wrap gap-1.5">
        {options.map(opt => (
          <button key={opt} onClick={() => onChange(value === opt ? null : opt)}
            className="px-3 py-1.5 text-xs rounded-lg font-medium transition-all"
            style={value === opt
              ? { border: "1px solid rgba(0,255,136,0.35)", background: "rgba(0,255,136,0.08)", color: "#00FF88" }
              : { border: "1px solid rgba(255,255,255,0.06)", color: "#4B5563", background: "transparent" }}>
            {opt}
          </button>
        ))}
      </div>
    </div>
  );
}

export { QuestionCard };
