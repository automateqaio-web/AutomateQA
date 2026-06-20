import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import {
  ArrowLeft, Eye, Tag, Calendar, BookOpen, Code2,
  AlertTriangle, Lightbulb, ChevronRight, ChevronLeft, Star,
} from "lucide-react";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { InterviewQuestion } from "@/types";
import { formatDate } from "@/lib/utils";
import ReadingProgress from "@/components/blog/ReadingProgress";
import QuestionViewTracker from "@/components/interview-prep/QuestionViewTracker";
import QuestionCodeBlock from "@/components/interview-prep/QuestionCodeBlock";
import QuestionShareBar from "@/components/interview-prep/QuestionShareBar";
import InterviewAnswerContent from "@/components/interview-prep/InterviewAnswerContent";
import FullGuideToggle from "@/components/interview-prep/FullGuideToggle";

export const revalidate = 3600;

interface Props { params: Promise<{ slug: string }> }

const SLUG_RE = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;
const SITE    = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

// Cookie-free client — safe to call in static/ISR pages (no dynamic API usage)
function getDb() {
  return createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL || "https://placeholder.supabase.co",
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "placeholder-key"
  );
}

// ── Data helpers ───────────────────────────────────────────────────────────────

async function getQuestion(slug: string): Promise<InterviewQuestion | null> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return null;
  if (!SLUG_RE.test(slug)) return null;
  try {
    const { data } = await getDb()
      .from("interview_questions")
      .select("*")
      .eq("slug", slug)
      .eq("published", true)
      .single();
    return data;
  } catch { return null; }
}

async function getAdjacentQuestions(technology: string, currentId: string, currentCreatedAt: string) {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder"))
    return { prev: null, next: null };
  try {
    const db = getDb();
    const [prevRes, nextRes] = await Promise.all([
      db.from("interview_questions")
        .select("id,question,slug,difficulty")
        .eq("technology", technology)
        .eq("published", true)
        .neq("id", currentId)
        .lt("created_at", currentCreatedAt)
        .order("created_at", { ascending: false })
        .limit(1),
      db.from("interview_questions")
        .select("id,question,slug,difficulty")
        .eq("technology", technology)
        .eq("published", true)
        .neq("id", currentId)
        .gt("created_at", currentCreatedAt)
        .order("created_at", { ascending: true })
        .limit(1),
    ]);
    return {
      prev: (prevRes.data?.[0] as { id: string; question: string; slug: string; difficulty: string } | undefined) ?? null,
      next: (nextRes.data?.[0] as { id: string; question: string; slug: string; difficulty: string } | undefined) ?? null,
    };
  } catch { return { prev: null, next: null }; }
}

async function getRelated(technology: string, excludeId: string) {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return [];
  try {
    const { data } = await getDb()
      .from("interview_questions")
      .select("id,question,slug,difficulty,experience_level,technology")
      .eq("technology", technology)
      .eq("published", true)
      .neq("id", excludeId)
      .order("views", { ascending: false })
      .limit(6);
    return (data || []) as Pick<InterviewQuestion, "id" | "question" | "slug" | "difficulty" | "experience_level" | "technology">[];
  } catch { return []; }
}

// ── Static params (pre-renders all published questions at build time) ──────────

export async function generateStaticParams() {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return [];
  try {
    const { data } = await getDb()
      .from("interview_questions")
      .select("slug")
      .eq("published", true);
    return (data || []).map((q) => ({ slug: q.slug }));
  } catch { return []; }
}

// ── Dynamic metadata ───────────────────────────────────────────────────────────

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const q = await getQuestion(slug);
  if (!q) return { title: "Question Not Found | AutomateQA" };

  try {
    const canonicalUrl = `${SITE}/interview-prep/${slug}`;
    const tags: string[] = Array.isArray(q.tags) ? q.tags : [];
    const description =
      q.short_description ||
      `${q.technology} interview question for ${q.experience_level} engineers — ${q.difficulty} level. Detailed answer with real-world example and best practices.`;

    return {
      title: `${q.question} | AutomateQA Interview Prep`,
      description,
      keywords: [
        ...tags,
        q.technology,
        q.question_type,
        q.experience_level,
        "interview question",
        "QA automation interview",
        "SDET interview",
        "automation testing interview",
        `${q.technology} interview questions`,
        `${q.difficulty} ${q.technology} questions`,
      ].filter(Boolean) as string[],
      authors: [{ name: "Nagendra Meesala", url: `${SITE}/about` }],
      category: "Interview Preparation",
      alternates: { canonical: canonicalUrl },
      robots: {
        index: true,
        follow: true,
        googleBot: { index: true, follow: true, "max-image-preview": "large", "max-snippet": -1 },
      },
      openGraph: {
        type: "article",
        url: canonicalUrl,
        siteName: "AutomateQA",
        locale: "en_US",
        title: `${q.question} | AutomateQA`,
        description,
        images: [
          { url: `${SITE}/og-image.png`, width: 1200, height: 630, alt: `AutomateQA — ${q.question}` },
        ],
        publishedTime: q.created_at,
        modifiedTime: q.updated_at ?? undefined,
        authors: [`${SITE}/about`],
        tags: ([...tags, q.technology, q.question_type].filter(Boolean)) as string[],
        section: "Interview Preparation",
      },
      twitter: {
        card: "summary_large_image",
        site: "@automateqa",
        title: `${q.question} | AutomateQA`,
        description,
        images: [`${SITE}/og-image.png`],
      },
    };
  } catch {
    return { title: `${q.question} | AutomateQA Interview Prep` };
  }
}

// ── Schema builder ─────────────────────────────────────────────────────────────

function stripMd(text: string, maxLen = 600) {
  return text.replace(/[#*`[\]>_~]/g, "").replace(/\s+/g, " ").trim().slice(0, maxLen);
}

function buildSchemas(q: InterviewQuestion, canonicalUrl: string) {
  const tags: string[] = Array.isArray(q.tags) ? q.tags : [];

  const breadcrumb = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "Home",           item: SITE },
      { "@type": "ListItem", position: 2, name: "Interview Prep", item: `${SITE}/interview-prep` },
      { "@type": "ListItem", position: 3, name: q.question.slice(0, 80), item: canonicalUrl },
    ],
  };

  const faqPage = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: [
      ...(q.answer
        ? [{
            "@type": "Question",
            name: q.question,
            acceptedAnswer: { "@type": "Answer", text: stripMd(q.answer) },
          }]
        : []),
      ...(q.best_practices
        ? [{
            "@type": "Question",
            name: `What are the best practices for ${q.question.replace(/\?$/, "").toLowerCase()}?`,
            acceptedAnswer: { "@type": "Answer", text: stripMd(q.best_practices) },
          }]
        : []),
      ...(q.common_mistakes
        ? [{
            "@type": "Question",
            name: `What are common mistakes when answering "${q.question.replace(/\?$/, "")}"?`,
            acceptedAnswer: { "@type": "Answer", text: stripMd(q.common_mistakes) },
          }]
        : []),
    ].filter((e) => e.acceptedAnswer.text.length > 10),
  };

  const techArticle = {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    headline: q.question,
    description:
      q.short_description ||
      `${q.technology} interview question for ${q.experience_level} — ${q.difficulty} level.`,
    url: canonicalUrl,
    datePublished: q.created_at,
    dateModified: q.updated_at || q.created_at,
    inLanguage: "en-US",
    image: { "@type": "ImageObject", url: `${SITE}/og-image.png`, width: 1200, height: 630 },
    author: {
      "@type": "Person",
      name: "Nagendra Meesala",
      url: `${SITE}/about`,
      jobTitle: "QA Automation Engineer",
    },
    publisher: {
      "@type": "Organization",
      name: "AutomateQA",
      url: SITE,
      logo: { "@type": "ImageObject", url: `${SITE}/logo.png` },
    },
    about: { "@type": "Thing", name: q.technology },
    articleSection: "Interview Preparation",
    keywords: [...tags, q.technology, q.question_type, q.experience_level, q.difficulty].join(", "),
    audience: { "@type": "Audience", audienceType: "Software Test Engineers" },
    ...(q.code_snippet
      ? { hasPart: { "@type": "SoftwareSourceCode", codeSampleType: "full", programmingLanguage: q.code_language || "Java" } }
      : {}),
  };

  return [breadcrumb, faqPage, techArticle];
}

// ── Page ───────────────────────────────────────────────────────────────────────

export default async function QuestionDetailPage({ params }: Props) {
  const { slug } = await params;
  const q = await getQuestion(slug);
  if (!q) notFound();

  const [related, { prev, next }] = await Promise.all([
    getRelated(q.technology, q.id),
    getAdjacentQuestions(q.technology, q.id, q.created_at),
  ]);
  const tags: string[] = Array.isArray(q.tags) ? q.tags : [];
  const canonicalUrl = `${SITE}/interview-prep/${slug}`;
  let schemas: ReturnType<typeof buildSchemas> = [];
  try { schemas = buildSchemas(q, canonicalUrl); } catch {}

  const youtubeId = q.youtube_url
    ? q.youtube_url.match(/(?:v=|youtu\.be\/|embed\/)([^&?/]+)/)?.[1]
    : null;

  const TECH_ACCENT: Record<string, string> = {
    "Selenium":"#f59e0b","Playwright":"#a78bfa","Cypress":"#34d399","Core Java":"#fb923c",
    "Rest Assured":"#a3e635","API Automation":"#4ade80","Page Object Model":"#818cf8",
    "Cucumber":"#4ade80","TestNG":"#c084fc","Jenkins":"#f87171","GitHub Actions":"#94a3b8",
    "Azure DevOps":"#38bdf8","SQL":"#60a5fa","Database Testing":"#3b82f6","Postman":"#fb923c",
    "Scenario-Based":"#fbbf24","Managerial":"#94a3b8","HR":"#f9a8d4","General":"#9ca3af",
    "OOPs":"#e879f9","Collections":"#fdba74","Multithreading":"#7dd3fc","Streams":"#86efac",
    "Exception Handling":"#fca5a5","BDD":"#2dd4bf","Gherkin":"#86efac","CI/CD Integration":"#f472b6",
    "Hybrid Framework":"#6366f1","Data-Driven Framework":"#22d3ee","WebdriverIO":"#f43f5e",
  };
  const DIFF_STYLE: Record<string, { color: string; bg: string }> = {
    Beginner:     { color: "#4ade80", bg: "rgba(74,222,128,0.12)" },
    Intermediate: { color: "#fbbf24", bg: "rgba(251,191,36,0.12)" },
    Advanced:     { color: "#f87171", bg: "rgba(248,113,113,0.12)" },
  };
  const techAccent = TECH_ACCENT[q.technology] || "#00FF88";
  const diffStyle  = DIFF_STYLE[q.difficulty] || { color: "#6b7280", bg: "rgba(107,114,128,0.12)" };

  return (
    <div className="min-h-screen pt-16 bg-[#0B0B0B]">
      {schemas.map((s, i) => (
        <script key={i} type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(s) }} />
      ))}
      <ReadingProgress />
      <QuestionViewTracker questionId={q.id} />

      <div className="h-8" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
        <div className="flex gap-10">

          {/* ── Article ── */}
          <article className="flex-1 min-w-0" itemScope itemType="https://schema.org/TechArticle">
            <meta itemProp="headline"       content={q.question} />
            <meta itemProp="datePublished"  content={q.created_at} />
            <meta itemProp="dateModified"   content={q.updated_at || q.created_at} />
            <meta itemProp="author"         content="AutomateQA Team" />
            <meta itemProp="publisher"      content="AutomateQA" />
            <meta itemProp="inLanguage"     content="en-US" />
            <meta itemProp="url"            content={canonicalUrl} />

            {/* Back */}
            <div className="pt-8 mb-8">
              <Link
                href="/interview-prep"
                className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 text-sm font-medium transition-all group backdrop-blur-sm"
              >
                <ArrowLeft size={14} className="group-hover:-translate-x-0.5 transition-transform" />
                Back to Interview Prep
              </Link>
            </div>

            {/* Header */}
            <header className="mb-10">

              {/* ── Premium metadata strip ── */}
              <div className="mb-7 rounded-2xl overflow-hidden"
                style={{ border: `1px solid ${techAccent}18`, background: `linear-gradient(135deg, ${techAccent}06 0%, #0a0a0a 60%)` }}>

                {/* Top row — technology + difficulty + type */}
                <div className="flex flex-wrap items-center gap-0"
                  style={{ borderBottom: `1px solid ${techAccent}12` }}>

                  {/* Technology pill — most prominent */}
                  <div className="flex items-center gap-2.5 px-5 py-3.5 flex-1 min-w-0">
                    <div className="w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0"
                      style={{ background: `${techAccent}18`, border: `1px solid ${techAccent}30` }}>
                      <span className="text-[10px] font-black" style={{ color: techAccent }}>{"</>"}</span>
                    </div>
                    <div>
                      <p className="text-[9px] font-bold uppercase tracking-widest text-[#374151]">Technology</p>
                      <p className="text-sm font-black" style={{ color: techAccent }}>{q.technology}</p>
                    </div>
                  </div>

                  <div className="w-px self-stretch" style={{ background: `${techAccent}12` }} />

                  {/* Difficulty */}
                  <div className="flex items-center gap-2.5 px-5 py-3.5">
                    <div className="w-2.5 h-2.5 rounded-full flex-shrink-0" style={{ background: diffStyle.color, boxShadow: `0 0 6px ${diffStyle.color}60` }} />
                    <div>
                      <p className="text-[9px] font-bold uppercase tracking-widest text-[#374151]">Difficulty</p>
                      <p className="text-sm font-black" style={{ color: diffStyle.color }}>{q.difficulty}</p>
                    </div>
                  </div>

                  <div className="w-px self-stretch" style={{ background: `${techAccent}12` }} />

                  {/* Experience */}
                  <div className="hidden sm:flex items-center gap-2.5 px-5 py-3.5">
                    <div>
                      <p className="text-[9px] font-bold uppercase tracking-widest text-[#374151]">Experience</p>
                      <p className="text-sm font-semibold text-[#9CA3AF]">{q.experience_level}</p>
                    </div>
                  </div>

                  <div className="hidden sm:block w-px self-stretch" style={{ background: `${techAccent}12` }} />

                  {/* Type */}
                  <div className="hidden md:flex items-center gap-2.5 px-5 py-3.5">
                    <div>
                      <p className="text-[9px] font-bold uppercase tracking-widest text-[#374151]">Type</p>
                      <p className="text-sm font-semibold text-[#9CA3AF]">{q.question_type}</p>
                    </div>
                  </div>

                  {q.featured && (
                    <>
                      <div className="w-px self-stretch" style={{ background: `${techAccent}12` }} />
                      <div className="flex items-center gap-1.5 px-5 py-3.5">
                        <span className="text-sm">★</span>
                        <p className="text-sm font-black text-[#fbbf24]">Featured</p>
                      </div>
                    </>
                  )}
                </div>

                {/* Bottom row — author + date + views */}
                <div className="flex flex-wrap items-center gap-x-5 gap-y-2 px-5 py-3"
                  style={{ background: "rgba(0,0,0,0.2)" }}>
                  <div className="flex items-center gap-2.5" itemScope itemType="https://schema.org/Person" itemProp="author">
                    <div className="relative w-7 h-7 flex-shrink-0 rounded-full"
                      style={{ outline: `1.5px solid ${techAccent}40` }}>
                      <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
                    </div>
                    <div className="leading-none">
                      <p className="text-xs font-semibold text-white" itemProp="name">AutomateQA Team</p>
                      <p className="text-[10px] text-[#4B5563] mt-0.5" itemProp="jobTitle">QA Automation Engineers</p>
                    </div>
                  </div>
                  <span className="w-px h-5 bg-white/[0.06]" />
                  <time dateTime={q.created_at} itemProp="datePublished"
                    className="flex items-center gap-1.5 text-[#4B5563] text-xs">
                    <Calendar size={11} />
                    {formatDate(q.created_at)}
                  </time>
                  {q.views >= 5 && (
                    <>
                      <span className="w-px h-5 bg-white/[0.06]" />
                      <div className="flex items-center gap-1.5 text-[#4B5563] text-xs">
                        <Eye size={11} />
                        {q.views.toLocaleString()} views
                      </div>
                    </>
                  )}
                </div>
              </div>
            </header>

            {/* ── Question Box ── */}
            <div className="mb-8 p-6 sm:p-8 rounded-2xl border border-[#00FF88]/15 bg-[#00FF88]/[0.03] relative overflow-hidden">
              <div className="absolute top-0 right-0 w-48 h-48 bg-[#00FF88]/5 rounded-full blur-3xl pointer-events-none" />
              <p className="text-[10px] font-bold text-[#00FF88] uppercase tracking-[0.15em] mb-3">Interview Question</p>
              <h1 className="text-2xl sm:text-3xl font-black text-white leading-tight" itemProp="headline">
                {q.question}
              </h1>
            </div>

            {/* ── Quick Answer (what to say in the interview) ── */}
            {q.short_description && (
              <div className="mb-8 rounded-2xl overflow-hidden"
                style={{
                  border: `1px solid ${techAccent}28`,
                  background: `linear-gradient(135deg, ${techAccent}08 0%, #0A0A0A 70%)`,
                  boxShadow: `0 0 40px ${techAccent}08`,
                }}>
                {/* shimmer */}
                <div className="h-px" style={{ background: `linear-gradient(90deg, transparent, ${techAccent}40, transparent)` }} />
                <div className="px-6 py-5">
                  <div className="flex items-center gap-2.5 mb-3">
                    <span className="text-base">🎯</span>
                    <p className="text-[10px] font-black uppercase tracking-[0.18em]" style={{ color: techAccent }}>
                      Quick Answer — What to Say in the Interview
                    </p>
                  </div>
                  <p className="text-[#E5E7EB] text-base leading-relaxed font-medium" itemProp="description">
                    {q.short_description}
                  </p>
                </div>
              </div>
            )}

            {/* ── Full Guide (collapsible) ── */}
            {q.answer && (
              <div itemProp="articleBody">
                <FullGuideToggle content={q.answer} accent={techAccent} />
              </div>
            )}

            {/* ── Real-World Example ── */}
            {q.real_world_example && (
              <ContentSection label="Real-World Example" accent="#fbbf24" icon={<Star size={15} />}>
                <InterviewAnswerContent content={q.real_world_example} accent="#fbbf24" />
              </ContentSection>
            )}

            {/* ── Code Example ── */}
            {q.code_snippet && (
              <ContentSection label="Code Example" accent="#38bdf8" icon={<Code2 size={15} />}>
                <QuestionCodeBlock code={q.code_snippet} language={q.code_language || "java"} />
              </ContentSection>
            )}

            {/* ── Best Practices ── */}
            {q.best_practices && (
              <ContentSection label="Best Practices" accent="#4ade80" icon={<Lightbulb size={15} />}>
                <InterviewAnswerContent content={q.best_practices} accent="#4ade80" />
              </ContentSection>
            )}

            {/* ── Common Mistakes ── */}
            {q.common_mistakes && (
              <ContentSection label="Common Mistakes" accent="#f87171" icon={<AlertTriangle size={15} />}>
                <InterviewAnswerContent content={q.common_mistakes} accent="#f87171" />
              </ContentSection>
            )}

            {/* ── YouTube ── */}
            {youtubeId && (
              <ContentSection
                icon={
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor" className="text-red-400">
                    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                  </svg>
                }
                label="Video Explanation"
                accent="#ef4444"
              >
                <div className="rounded-2xl overflow-hidden shadow-[0_8px_40px_rgba(0,0,0,0.7)] ring-1 ring-white/[0.06]">
                  <div className="aspect-video">
                    <iframe
                      src={`https://www.youtube.com/embed/${youtubeId}?rel=0&modestbranding=1`}
                      title={`${q.question} — Video Explanation`}
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                      allowFullScreen className="w-full h-full" frameBorder="0"
                    />
                  </div>
                </div>
              </ContentSection>
            )}

            {/* ── Prev / Next navigation ── */}
            {(prev || next) && (
              <div className="mt-10 pt-8 border-t border-white/[0.07]">
                <p className="text-[10px] font-bold uppercase tracking-widest mb-4"
                  style={{ color: techAccent + "80" }}>
                  More {q.technology} Questions
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">

                  {/* Previous */}
                  {prev ? (
                    <Link href={`/interview-prep/${prev.slug}`}
                      className="group flex items-start gap-3 p-4 rounded-2xl transition-all duration-200 hover:brightness-125"
                      style={{
                        border: `1px solid ${techAccent}20`,
                        background: `${techAccent}06`,
                      }}>
                      <div className="flex-shrink-0 w-8 h-8 rounded-xl flex items-center justify-center mt-0.5 transition-all"
                        style={{ background: `${techAccent}15`, border: `1px solid ${techAccent}30` }}>
                        <ChevronLeft size={14} style={{ color: techAccent }} />
                      </div>
                      <div className="min-w-0">
                        <p className="text-[9px] font-black uppercase tracking-widest mb-1" style={{ color: techAccent + "70" }}>
                          ← Previous
                        </p>
                        <p className="text-[13px] font-semibold leading-snug line-clamp-2 text-[#C9D1D9] group-hover:text-white transition-colors">
                          {prev.question}
                        </p>
                        <span className="inline-flex items-center gap-1 mt-1.5 text-[10px] font-bold px-1.5 py-0.5 rounded"
                          style={{
                            color: prev.difficulty === "Beginner" ? "#4ade80" : prev.difficulty === "Intermediate" ? "#fbbf24" : "#f87171",
                            background: prev.difficulty === "Beginner" ? "rgba(74,222,128,0.1)" : prev.difficulty === "Intermediate" ? "rgba(251,191,36,0.1)" : "rgba(248,113,113,0.1)",
                          }}>
                          {prev.difficulty}
                        </span>
                      </div>
                    </Link>
                  ) : <div />}

                  {/* Next */}
                  {next ? (
                    <Link href={`/interview-prep/${next.slug}`}
                      className="group flex items-start gap-3 p-4 rounded-2xl transition-all duration-200 sm:flex-row-reverse sm:text-right hover:brightness-125"
                      style={{
                        border: `1px solid ${techAccent}20`,
                        background: `${techAccent}06`,
                      }}>
                      <div className="flex-shrink-0 w-8 h-8 rounded-xl flex items-center justify-center mt-0.5 transition-all"
                        style={{ background: `${techAccent}15`, border: `1px solid ${techAccent}30` }}>
                        <ChevronRight size={14} style={{ color: techAccent }} />
                      </div>
                      <div className="min-w-0 flex-1">
                        <p className="text-[9px] font-black uppercase tracking-widest mb-1" style={{ color: techAccent + "70" }}>
                          Next →
                        </p>
                        <p className="text-[13px] font-semibold leading-snug line-clamp-2 text-[#C9D1D9] group-hover:text-white transition-colors">
                          {next.question}
                        </p>
                        <span className="inline-flex items-center gap-1 mt-1.5 text-[10px] font-bold px-1.5 py-0.5 rounded"
                          style={{
                            color: next.difficulty === "Beginner" ? "#4ade80" : next.difficulty === "Intermediate" ? "#fbbf24" : "#f87171",
                            background: next.difficulty === "Beginner" ? "rgba(74,222,128,0.1)" : next.difficulty === "Intermediate" ? "rgba(251,191,36,0.1)" : "rgba(248,113,113,0.1)",
                          }}>
                          {next.difficulty}
                        </span>
                      </div>
                    </Link>
                  ) : <div />}

                </div>
              </div>
            )}

            {/* ── Follow CTA ── */}
            <div className="mt-10 pt-8 border-t border-white/[0.07]">
              <p className="text-xs font-bold text-[#4B5563] uppercase tracking-widest mb-4">Follow AutomateQA</p>
              <div className="flex flex-wrap gap-3">
                <a href="https://www.youtube.com/@automateqa?sub_confirmation=1" target="_blank" rel="noopener noreferrer"
                  className="group inline-flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-red-500/8 border border-red-500/20 hover:bg-red-500/15 hover:border-red-500/40 transition-all duration-200">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" className="text-red-400 flex-shrink-0">
                    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                  </svg>
                  <span className="text-sm font-semibold text-red-400 group-hover:text-red-300 transition-colors">YouTube</span>
                </a>
                <a href="https://www.instagram.com/automateqa.memes" target="_blank" rel="noopener noreferrer"
                  className="group inline-flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-pink-500/8 border border-pink-500/20 hover:bg-pink-500/15 hover:border-pink-500/40 transition-all duration-200">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" className="text-pink-400 flex-shrink-0">
                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                  </svg>
                  <span className="text-sm font-semibold text-pink-400 group-hover:text-pink-300 transition-colors">Instagram</span>
                </a>
              </div>
            </div>

            {/* ── Tags ── */}
            {tags.length > 0 && (
              <div className="mt-8 pt-8 border-t border-white/[0.07]">
                <style dangerouslySetInnerHTML={{ __html: `.tag-pill:hover { filter: brightness(1.6); opacity: 1; }` }} />
                <p className="flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest text-[#374151] mb-3">
                  <Tag size={10} /> Related Topics
                </p>
                <div className="flex flex-wrap gap-2">
                  {tags.map((tag) => (
                    <Link
                      key={tag}
                      href={`/interview-prep?search=${encodeURIComponent(tag)}`}
                      rel="tag"
                      className="tag-pill px-3 py-1.5 text-[11px] rounded-lg font-semibold transition-all"
                      style={{
                        background: `${techAccent}08`, color: `${techAccent}80`,
                        border: `1px solid ${techAccent}20`,
                      }}
                    >
                      # {tag}
                    </Link>
                  ))}
                </div>
              </div>
            )}

            {/* ── Share ── */}
            <QuestionShareBar question={q.question} />

          </article>

          {/* ── Sidebar ── */}
          <aside className="hidden lg:block w-64 shrink-0 self-start sticky top-24 space-y-5" aria-label="Related questions">

            {/* Quick Info */}
            <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] p-4">
              <p className="text-[10px] font-bold text-[#9CA3AF] uppercase tracking-[0.12em] mb-3">Quick Info</p>
              <div className="space-y-2.5">
                {[
                  { label: "Technology", value: q.technology },
                  { label: "Difficulty", value: q.difficulty },
                  { label: "Experience", value: q.experience_level },
                  { label: "Type",       value: q.question_type },
                ].map(({ label, value }) => (
                  <div key={label} className="flex justify-between text-xs">
                    <span className="text-[#6B7280]">{label}</span>
                    <span className="text-[#9CA3AF] font-semibold">{value}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Related Questions */}
            {related.length > 0 && (
              <nav className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden" aria-label={`More ${q.technology} questions`}>
                <div className="flex items-center gap-2.5 px-4 py-3.5 border-b border-white/5">
                  <span className="w-5 h-5 rounded-md bg-[#00FF88]/15 flex items-center justify-center flex-shrink-0">
                    <BookOpen size={10} className="text-[#00FF88]" />
                  </span>
                  <span className="text-[11px] font-bold text-[#9CA3AF] uppercase tracking-[0.12em]">
                    More {q.technology} Questions
                  </span>
                </div>
                <div className="p-3 space-y-0.5">
                  {related.map((r) => (
                    <Link
                      key={r.id}
                      href={`/interview-prep/${r.slug}`}
                      className="group flex items-start gap-2.5 px-3 py-2 rounded-lg hover:bg-white/[0.04] transition-all"
                    >
                      <ChevronRight size={11} className="flex-shrink-0 text-[#374151] group-hover:text-[#00FF88] transition-colors mt-[3px]" />
                      <span className="text-[0.72rem] leading-snug text-[#6B7280] group-hover:text-[#C9D1D9] transition-colors line-clamp-3 flex-1">
                        {r.question}
                      </span>
                    </Link>
                  ))}
                </div>
                <div className="px-4 pb-4">
                  <Link
                    href={`/interview-prep?technology=${encodeURIComponent(q.technology)}`}
                    className="block text-center text-[10px] font-bold text-[#00FF88] hover:underline uppercase tracking-wider"
                  >
                    View All {q.technology} →
                  </Link>
                </div>
              </nav>
            )}

            {/* CTA */}
            <div className="rounded-2xl border border-[#00FF88]/20 bg-gradient-to-br from-[#00FF88]/8 via-[#0E0E0E] to-[#0E0E0E] p-5 overflow-hidden relative">
              <div className="absolute -top-4 -right-4 w-20 h-20 bg-[#00FF88]/8 rounded-full blur-2xl pointer-events-none" />
              <div className="relative z-10">
                <p className="text-[#00FF88] font-black text-sm mb-0.5">Ace Your Interview</p>
                <p className="text-white/50 text-[10px] mb-2 font-medium uppercase tracking-wider">Practice More Questions</p>
                <p className="text-[#6B7280] text-[0.72rem] leading-relaxed mb-4">
                  Browse hundreds of QA interview questions across all technologies and experience levels.
                </p>
                <Link
                  href="/interview-prep"
                  className="inline-flex items-center gap-1.5 px-4 py-2 bg-[#00FF88] text-black text-[0.72rem] font-black rounded-lg hover:bg-[#00E67A] hover:shadow-[0_0_12px_rgba(0,255,136,0.3)] active:scale-95 transition-all"
                >
                  Browse All Questions →
                </Link>
              </div>
            </div>

          </aside>
        </div>
      </div>
    </div>
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function ContentSection({
  icon, label, accent, children,
}: { icon: React.ReactNode; label: string; accent: string; children: React.ReactNode }) {
  const sectionId = `section-${label.toLowerCase().replace(/\s+/g, "-")}`;
  return (
    <section className="mb-10" aria-labelledby={sectionId}>
      {/* Section header */}
      <div className="flex items-center gap-3 mb-5">
        <div className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0"
          style={{ background: `${accent}18`, border: `1px solid ${accent}30`, color: accent }}>
          {icon}
        </div>
        <h2 id={sectionId} className="text-lg font-black" style={{ color: accent }}>
          {label}
        </h2>
        <div className="flex-1 h-px" style={{ background: `linear-gradient(90deg, ${accent}25, transparent)` }} />
      </div>

      {/* Content card */}
      <div className="rounded-2xl overflow-hidden"
        style={{
          border: `1px solid ${accent}18`,
          background: `linear-gradient(160deg, ${accent}06 0%, #0A0A0A 50%)`,
          boxShadow: `0 4px 32px rgba(0,0,0,0.4), inset 0 1px 0 ${accent}12`,
        }}>
        {/* top shimmer */}
        <div className="h-px" style={{ background: `linear-gradient(90deg, transparent, ${accent}30, transparent)` }} />
        <div className="px-6 py-6">
          {children}
        </div>
      </div>
    </section>
  );
}
