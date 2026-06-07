"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import Link from "next/link";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { createClient } from "@supabase/supabase-js";
import {
  Search, X, Eye, ChevronDown, Zap, Code2, Users, TrendingUp,
  Filter, Loader2, BookOpen, BrainCircuit, ExternalLink,
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { InterviewQuestion, CATEGORY_COLORS, DIFFICULTY_COLORS, Difficulty } from "@/types";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

const TECH_CATEGORIES = [
  { name: "Selenium",          icon: "🌐", border: "border-yellow-500/25",  bg: "bg-yellow-500/8",  active: "border-yellow-500/50 bg-yellow-500/15", text: "text-yellow-400" },
  { name: "Playwright",        icon: "🎭", border: "border-purple-500/25",  bg: "bg-purple-500/8",  active: "border-purple-500/50 bg-purple-500/15", text: "text-purple-400" },
  { name: "Cypress",           icon: "🌲", border: "border-emerald-500/25", bg: "bg-emerald-500/8", active: "border-emerald-500/50 bg-emerald-500/15", text: "text-emerald-400" },
  { name: "Core Java",         icon: "☕", border: "border-orange-500/25",  bg: "bg-orange-500/8",  active: "border-orange-500/50 bg-orange-500/15", text: "text-orange-400" },
  { name: "Rest Assured",      icon: "🔌", border: "border-lime-500/25",    bg: "bg-lime-500/8",    active: "border-lime-500/50 bg-lime-500/15",     text: "text-lime-400" },
  { name: "API Automation",    icon: "⚡", border: "border-green-500/25",   bg: "bg-green-500/8",   active: "border-green-500/50 bg-green-500/15",   text: "text-green-400" },
  { name: "Page Object Model", icon: "📐", border: "border-violet-500/25",  bg: "bg-violet-500/8",  active: "border-violet-500/50 bg-violet-500/15", text: "text-violet-400" },
  { name: "Cucumber",          icon: "🥒", border: "border-green-600/25",   bg: "bg-green-600/8",   active: "border-green-600/50 bg-green-600/15",   text: "text-green-400" },
  { name: "TestNG",            icon: "🧪", border: "border-violet-600/25",  bg: "bg-violet-600/8",  active: "border-violet-600/50 bg-violet-600/15", text: "text-violet-400" },
  { name: "Jenkins",           icon: "🔧", border: "border-red-600/25",     bg: "bg-red-600/8",     active: "border-red-600/50 bg-red-600/15",       text: "text-red-400" },
  { name: "GitHub Actions",    icon: "⚙️", border: "border-gray-500/25",    bg: "bg-gray-500/8",    active: "border-gray-500/50 bg-gray-500/15",     text: "text-gray-300" },
  { name: "SQL",               icon: "🗄️", border: "border-blue-600/25",    bg: "bg-blue-600/8",    active: "border-blue-600/50 bg-blue-600/15",     text: "text-blue-400" },
  { name: "Scenario-Based",    icon: "🎯", border: "border-amber-500/25",   bg: "bg-amber-500/8",   active: "border-amber-500/50 bg-amber-500/15",   text: "text-amber-400" },
  { name: "Managerial",        icon: "💼", border: "border-slate-500/25",   bg: "bg-slate-500/8",   active: "border-slate-500/50 bg-slate-500/15",   text: "text-slate-300" },
  { name: "HR",                icon: "🤝", border: "border-pink-500/25",    bg: "bg-pink-500/8",    active: "border-pink-500/50 bg-pink-500/15",     text: "text-pink-400" },
];

const DIFFICULTIES      = ["Beginner", "Intermediate", "Advanced"];
const EXPERIENCE_LEVELS = ["Fresher", "1-2 Years", "3-5 Years", "5+ Years", "Senior SDET"];
const QUESTION_TYPES    = ["Technical", "Scenario-Based", "Coding", "Managerial", "HR", "Framework Design", "API Testing", "Real-Time Issues", "CI/CD", "Debugging"];
const PAGE_SIZE = 12;

const SELECT_FIELDS = "id,question,slug,short_description,answer,technology,question_type,experience_level,difficulty,tags,featured,views,created_at";

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

  // Debounce search
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setSearch(searchInput), 400);
    return () => { if (debounceRef.current) clearTimeout(debounceRef.current); };
  }, [searchInput]);

  const buildQuery = useCallback(() => {
    let q = supabase
      .from("interview_questions")
      .select(SELECT_FIELDS)
      .eq("published", true);
    if (technology)      q = q.eq("technology",      technology);
    if (difficulty)      q = q.eq("difficulty",      difficulty);
    if (experienceLevel) q = q.eq("experience_level", experienceLevel);
    if (questionType)    q = q.eq("question_type",   questionType);
    if (search)          q = q.or(`question.ilike.%${search}%,short_description.ilike.%${search}%`);
    return q
      .order("featured",    { ascending: false })
      .order("views",       { ascending: false })
      .order("created_at",  { ascending: false });
  }, [technology, difficulty, experienceLevel, questionType, search]);

  const fetchQuestions = useCallback(async () => {
    if (isFirstRender.current) { isFirstRender.current = false; return; }
    setLoading(true);
    setExpandedId(null);
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

  const hasFilters  = !!(technology || difficulty || experienceLevel || questionType || search);
  const featuredQs  = initialQuestions.filter(q => q.featured).slice(0, 3);

  return (
    <div className="min-h-screen bg-[#0B0B0B] pt-16">

      {/* ── Hero ── */}
      <section className="relative overflow-hidden border-b border-white/[0.06]">
        <div className="absolute inset-0 bg-gradient-to-b from-[#0D0D0D] to-[#0B0B0B]" />
        <div className="absolute inset-0" style={{
          backgroundImage: "linear-gradient(rgba(0,255,136,0.025) 1px,transparent 1px),linear-gradient(90deg,rgba(0,255,136,0.025) 1px,transparent 1px)",
          backgroundSize: "52px 52px",
        }} />
        <div className="absolute top-0 left-1/3 w-[480px] h-[480px] bg-[#00FF88]/5 rounded-full blur-[140px] pointer-events-none" />
        <div className="absolute bottom-0 right-1/4 w-64 h-64 bg-purple-500/5 rounded-full blur-[100px] pointer-events-none" />

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 sm:py-28 text-center">
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5 }}>
            <div className="inline-flex items-center gap-2 px-4 py-2 mb-6 rounded-full border border-[#00FF88]/20 bg-[#00FF88]/8 text-[#00FF88] text-xs font-bold uppercase tracking-widest">
              <Zap size={11} /> Interview Prep
            </div>
            <h1 className="text-5xl sm:text-6xl lg:text-[4.5rem] font-black text-white leading-[1.02] tracking-tight mb-5">
              Master <span className="text-[#00FF88]">QA Automation</span>
              <br className="hidden sm:block" /> Interviews
            </h1>
            <p className="text-[#6B7280] text-lg max-w-2xl mx-auto mb-10 leading-relaxed">
              Real-world interview questions, scenario-based answers, framework discussions,
              coding challenges, and automation engineering concepts.
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15, duration: 0.5 }}
            className="max-w-2xl mx-auto relative mb-10"
          >
            <Search size={17} className="absolute left-5 top-1/2 -translate-y-1/2 text-[#6B7280] pointer-events-none" />
            <input
              type="text"
              value={searchInput}
              onChange={e => setSearchInput(e.target.value)}
              placeholder="Search — Selenium waits, Playwright hooks, API testing scenarios..."
              className="w-full pl-12 pr-12 py-4 bg-[#111]/90 border border-white/10 rounded-2xl text-white text-sm placeholder-[#4B5563] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all backdrop-blur-sm shadow-[0_8px_32px_rgba(0,0,0,0.4)]"
            />
            {searchInput && (
              <button onClick={() => setSearchInput("")} className="absolute right-4 top-1/2 -translate-y-1/2 text-[#6B7280] hover:text-white transition-colors">
                <X size={15} />
              </button>
            )}
          </motion.div>

          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.25, duration: 0.5 }}
            className="flex flex-wrap justify-center gap-6 sm:gap-10"
          >
            {[
              { icon: <Code2 size={14} />,       label: "Coding Questions" },
              { icon: <Users size={14} />,        label: "All Experience Levels" },
              { icon: <TrendingUp size={14} />,   label: "15+ Technologies" },
              { icon: <BrainCircuit size={14} />, label: "Real-World Scenarios" },
            ].map(({ icon, label }) => (
              <div key={label} className="flex items-center gap-2 text-[#6B7280] text-sm">
                <span className="text-[#00FF88]">{icon}</span>{label}
              </div>
            ))}
          </motion.div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-16">

        {/* ── Category Grid ── */}
        <section>
          <h2 className="text-base font-bold text-white mb-5 flex items-center gap-2.5">
            <span className="w-1 h-4 bg-[#00FF88] rounded-full" />
            Browse by Topic
          </h2>
          <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-7 xl:grid-cols-8 gap-2.5">
            {TECH_CATEGORIES.map(cat => {
              const isActive = technology === cat.name;
              return (
                <button
                  key={cat.name}
                  onClick={() => setTechnology(isActive ? null : cat.name)}
                  className={`group flex flex-col items-center gap-2 p-3.5 rounded-xl border text-center transition-all duration-200 ${
                    isActive
                      ? `${cat.active} shadow-[0_0_16px_rgba(0,255,136,0.08)]`
                      : `${cat.border} ${cat.bg} hover:border-opacity-50`
                  }`}
                >
                  <span className="text-2xl leading-none">{cat.icon}</span>
                  <span className={`text-[10px] font-bold leading-tight ${isActive ? cat.text : "text-[#9CA3AF]"}`}>
                    {cat.name}
                  </span>
                </button>
              );
            })}
          </div>
        </section>

        {/* ── Featured Questions ── */}
        {featuredQs.length > 0 && !hasFilters && (
          <section>
            <h2 className="text-base font-bold text-white mb-5 flex items-center gap-2.5">
              <span className="w-1 h-4 bg-yellow-400 rounded-full" />
              Featured Questions
            </h2>
            <div className="space-y-3">
              {featuredQs.map(q => (
                <AccordionCard
                  key={q.id}
                  question={q}
                  expanded={expandedId === q.id}
                  onToggle={() => setExpandedId(expandedId === q.id ? null : q.id)}
                  featured
                />
              ))}
            </div>
          </section>
        )}

        {/* ── Filter Bar ── */}
        <section>
          <div className="flex flex-wrap items-center gap-2 mb-4">
            <button
              onClick={() => setShowFilters(!showFilters)}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl border text-sm font-medium transition-all ${
                hasFilters
                  ? "border-[#00FF88]/40 bg-[#00FF88]/10 text-[#00FF88]"
                  : "border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:border-white/20 hover:text-white"
              }`}
            >
              <Filter size={13} />
              Filters {hasFilters ? "(active)" : ""}
            </button>
            {[
              { val: difficulty,      clear: () => setDifficulty(null) },
              { val: experienceLevel, clear: () => setExperienceLevel(null) },
              { val: questionType,    clear: () => setQuestionType(null) },
            ].map(({ val, clear }) => val ? (
              <button key={val} onClick={clear} className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-white/10 bg-white/[0.04] text-[#9CA3AF] text-xs hover:border-red-500/30 hover:text-red-400 transition-all">
                {val} <X size={10} />
              </button>
            ) : null)}
            {hasFilters && (
              <button onClick={clearFilters} className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-red-500/20 bg-red-500/5 text-red-400 text-xs hover:bg-red-500/10 transition-all">
                Clear All <X size={10} />
              </button>
            )}
          </div>

          <AnimatePresence>
            {showFilters && (
              <motion.div
                initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }}
                exit={{ height: 0, opacity: 0 }} transition={{ duration: 0.2 }}
                className="overflow-hidden mb-6"
              >
                <div className="p-5 rounded-2xl border border-white/8 bg-white/[0.02] space-y-4">
                  <FilterRow label="Difficulty"    options={DIFFICULTIES}      value={difficulty}      onChange={setDifficulty} />
                  <FilterRow label="Experience"    options={EXPERIENCE_LEVELS} value={experienceLevel} onChange={setExperienceLevel} />
                  <FilterRow label="Question Type" options={QUESTION_TYPES}    value={questionType}    onChange={setQuestionType} />
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* ── Questions List ── */}
          <div className="flex items-center justify-between mb-5">
            <h2 className="text-base font-bold text-white flex items-center gap-2.5">
              <span className="w-1 h-4 bg-[#00FF88] rounded-full" />
              {hasFilters ? "Filtered Results" : technology ? `${technology} Questions` : "All Questions"}
            </h2>
            <span className="text-xs text-[#4B5563]">
              {loading ? "Loading..." : `${questions.length} question${questions.length !== 1 ? "s" : ""}`}
            </span>
          </div>

          {loading ? (
            <div className="flex justify-center py-24">
              <Loader2 className="animate-spin text-[#00FF88]" size={28} />
            </div>
          ) : questions.length === 0 ? (
            <div className="text-center py-20 border border-dashed border-white/8 rounded-2xl">
              <BookOpen size={40} className="mx-auto mb-4 text-[#2A2A2A]" />
              <p className="text-[#4B5563] text-sm">No questions found.</p>
              <button onClick={clearFilters} className="mt-4 text-[#00FF88] text-sm hover:underline">Clear filters</button>
            </div>
          ) : (
            <div className="space-y-3">
              {questions.map((q, i) => (
                <motion.div
                  key={q.id}
                  initial={{ opacity: 0, y: 12 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: Math.min(i * 0.03, 0.25), duration: 0.3 }}
                >
                  <AccordionCard
                    question={q}
                    expanded={expandedId === q.id}
                    onToggle={() => setExpandedId(expandedId === q.id ? null : q.id)}
                  />
                </motion.div>
              ))}
            </div>
          )}

          {hasMore && !loading && (
            <div className="flex justify-center mt-10">
              <button
                onClick={loadMore}
                disabled={loadingMore}
                className="flex items-center gap-2 px-8 py-3 rounded-xl border border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:border-[#00FF88]/30 hover:text-[#00FF88] hover:bg-[#00FF88]/5 text-sm font-medium transition-all disabled:opacity-50"
              >
                {loadingMore && <Loader2 size={14} className="animate-spin" />}
                {loadingMore ? "Loading..." : "Load More Questions"}
              </button>
            </div>
          )}
        </section>
      </div>
    </div>
  );
}

// ── Accordion Card ─────────────────────────────────────────────────────────────

function AccordionCard({ question: q, expanded, onToggle, featured = false }: {
  question: InterviewQuestion;
  expanded: boolean;
  onToggle: () => void;
  featured?: boolean;
}) {
  const techColor = CATEGORY_COLORS[q.technology] || "bg-gray-500/20 text-gray-400 border-gray-500/30";
  const diffColor = DIFFICULTY_COLORS[q.difficulty as Difficulty] || "bg-gray-500/20 text-gray-400 border-gray-500/30";

  return (
    <div className={`rounded-2xl border transition-all duration-300 overflow-hidden ${
      expanded
        ? "border-[#00FF88]/25 shadow-[0_0_32px_rgba(0,255,136,0.07)]"
        : featured
          ? "border-yellow-500/20 bg-[#0F0F00]/40 hover:border-yellow-400/30"
          : "border-white/8 bg-[#0E0E0E] hover:border-white/15"
    }`}>
      {/* ── Header (always visible, clickable) ── */}
      <button
        onClick={onToggle}
        className="w-full flex items-start gap-4 px-5 py-4 text-left group"
      >
        {/* Number / expand indicator */}
        <div className={`flex-shrink-0 w-7 h-7 rounded-lg flex items-center justify-center mt-0.5 transition-all duration-200 ${
          expanded ? "bg-[#00FF88]/15 border border-[#00FF88]/30" : "bg-white/[0.04] border border-white/8"
        }`}>
          <ChevronDown
            size={14}
            className={`transition-transform duration-300 ${expanded ? "rotate-180 text-[#00FF88]" : "text-[#6B7280]"}`}
          />
        </div>

        <div className="flex-1 min-w-0">
          {/* Badges row */}
          <div className="flex flex-wrap items-center gap-1.5 mb-2">
            {featured && (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold border bg-yellow-500/10 text-yellow-400 border-yellow-500/20">
                ★ Featured
              </span>
            )}
            <span className={`category-badge border text-[10px] ${techColor}`}>{q.technology}</span>
            <span className={`category-badge border text-[10px] ${diffColor}`}>{q.difficulty}</span>
            <span className="category-badge border text-[10px] border-white/8 bg-white/[0.03] text-[#6B7280]">{q.experience_level}</span>
          </div>

          {/* Question text */}
          <p className={`text-sm font-bold leading-snug transition-colors ${expanded ? "text-[#00FF88]" : "text-white group-hover:text-[#00FF88]"}`}>
            {q.question}
          </p>

          {/* Short description — shown when collapsed */}
          {!expanded && q.short_description && (
            <p className="text-[#6B7280] text-xs leading-relaxed mt-1.5 line-clamp-1">{q.short_description}</p>
          )}
        </div>

        {/* Right meta */}
        <div className="flex-shrink-0 flex items-center gap-3 text-[#4B5563] text-xs">
          {q.views > 0 && (
            <span className="hidden sm:flex items-center gap-1">
              <Eye size={10} />{q.views.toLocaleString()}
            </span>
          )}
        </div>
      </button>

      {/* ── Expanded Answer ── */}
      <AnimatePresence>
        {expanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.25, ease: "easeInOut" }}
            className="overflow-hidden"
          >
            <div className="px-5 pb-5 pt-1 border-t border-white/[0.06]">
              {q.answer ? (
                <div className="prose-answer pt-4">
                  <ReactMarkdown
                    remarkPlugins={[remarkGfm]}
                    components={{
                      p:      ({ children }) => <p className="text-[#C9D1D9] text-sm leading-relaxed mb-3">{children}</p>,
                      strong: ({ children }) => <strong className="text-white font-bold">{children}</strong>,
                      em:     ({ children }) => <em className="text-[#9CA3AF]">{children}</em>,
                      ul:     ({ children }) => <ul className="list-none space-y-1.5 mb-3">{children}</ul>,
                      ol:     ({ children }) => <ol className="list-decimal list-inside space-y-1.5 mb-3 text-[#C9D1D9] text-sm">{children}</ol>,
                      li:     ({ children }) => (
                        <li className="flex items-start gap-2 text-sm text-[#C9D1D9]">
                          <span className="flex-shrink-0 w-1.5 h-1.5 rounded-full bg-[#00FF88]/60 mt-2" />
                          <span>{children}</span>
                        </li>
                      ),
                      code:   ({ children, className }) => {
                        const isBlock = className?.includes("language-");
                        return isBlock ? (
                          <pre className="bg-[#060606] border border-white/8 rounded-xl p-4 overflow-x-auto mb-3">
                            <code className="text-xs font-mono text-[#C9D1D9] leading-relaxed">{children}</code>
                          </pre>
                        ) : (
                          <code className="px-1.5 py-0.5 rounded bg-[#1A1A1A] text-[#00FF88] text-xs font-mono">{children}</code>
                        );
                      },
                      h2: ({ children }) => <h2 className="text-white font-black text-base mt-5 mb-2">{children}</h2>,
                      h3: ({ children }) => <h3 className="text-white font-bold text-sm mt-4 mb-2">{children}</h3>,
                      blockquote: ({ children }) => (
                        <blockquote className="border-l-2 border-[#00FF88]/40 pl-4 my-3 text-[#9CA3AF] text-sm italic">{children}</blockquote>
                      ),
                    }}
                  >
                    {q.answer}
                  </ReactMarkdown>
                </div>
              ) : (
                <p className="text-[#4B5563] text-sm py-4">No answer added yet.</p>
              )}

              {/* View full details link */}
              <div className="mt-4 pt-4 border-t border-white/[0.06] flex items-center justify-between">
                <div className="flex flex-wrap gap-1.5">
                  {Array.isArray(q.tags) && q.tags.slice(0, 4).map(tag => (
                    <span key={tag} className="px-2 py-1 text-[10px] rounded-md border border-white/8 bg-white/[0.03] text-[#6B7280]">{tag}</span>
                  ))}
                </div>
                <Link
                  href={`/interview-prep/${q.slug}`}
                  className="flex items-center gap-1.5 text-xs font-semibold text-[#00FF88] hover:underline"
                  onClick={e => e.stopPropagation()}
                >
                  Full Details <ExternalLink size={11} />
                </Link>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

// ── Filter Row ─────────────────────────────────────────────────────────────────

function FilterRow({ label, options, value, onChange }: {
  label: string; options: string[]; value: string | null; onChange: (v: string | null) => void;
}) {
  return (
    <div className="flex flex-wrap items-start gap-2">
      <span className="text-[10px] font-bold text-[#6B7280] uppercase tracking-widest w-24 pt-1.5 shrink-0">{label}</span>
      <div className="flex flex-wrap gap-1.5">
        {options.map(opt => (
          <button
            key={opt}
            onClick={() => onChange(value === opt ? null : opt)}
            className={`px-3 py-1.5 text-xs rounded-lg border transition-all ${
              value === opt
                ? "border-[#00FF88]/40 bg-[#00FF88]/10 text-[#00FF88]"
                : "border-white/8 text-[#6B7280] hover:border-white/20 hover:text-[#9CA3AF]"
            }`}
          >
            {opt}
          </button>
        ))}
      </div>
    </div>
  );
}

// Keep named export for compatibility
export { AccordionCard as QuestionCard };
