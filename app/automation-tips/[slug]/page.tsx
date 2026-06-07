import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { ArrowLeft, Clock, Eye, Tag, Lightbulb, Calendar, ArrowRight, BookOpen } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { CATEGORY_COLORS, DIFFICULTY_COLORS, Difficulty, AutomationTip } from "@/types";
import { formatDate } from "@/lib/utils";
import BlogContent from "@/components/blog/BlogContent";
import TipShareButtons from "@/components/tips/TipShareButtons";
import TipInteractions from "@/components/tips/TipInteractions";
import ReadingProgress from "@/components/blog/ReadingProgress";
import { TableOfContentsMobile, TableOfContentsDesktop } from "@/components/blog/TableOfContents";
import type { Heading } from "@/components/blog/TableOfContents";
import { formatTipContent } from "@/lib/formatTipContent";

export const revalidate = 3600;

interface Props { params: Promise<{ slug: string }> }

const SLUG_RE = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

function extractHeadings(content: string): Heading[] {
  return content
    .split("\n")
    .map((line) => line.match(/^(#{1,3})\s+(.+)/))
    .filter(Boolean)
    .map((m) => {
      const level = m![1].length;
      const rawText = m![2]
        .replace(/\*\*/g, "")
        .replace(/`/g, "")
        .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
        .trim();
      const id =
        "h-" +
        rawText
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, "-")
          .replace(/^-+|-+$/g, "");
      const text = rawText.replace(/^\d+\.\s+/, "");
      return { id, text, level };
    })
    .filter((h) => h.level === 2) as Heading[];
}

async function getTip(slug: string): Promise<AutomationTip | null> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return null;
  if (!SLUG_RE.test(slug)) return null;
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("automation_tips")
      .select("*")
      .eq("slug", slug)
      .eq("published", true)
      .single();
    if (data) {
      void supabase.from("automation_tips").update({ views: (data.views || 0) + 1 }).eq("id", data.id);
    }
    return data;
  } catch { return null; }
}

interface TipLink { id: string; title: string; slug: string; cover_image: string | null; }

async function getPopularTips(excludeId: string): Promise<TipLink[]> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return [];
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("automation_tips")
      .select("id,title,slug,cover_image")
      .eq("published", true)
      .neq("id", excludeId)
      .order("views", { ascending: false })
      .limit(5);
    return (data || []) as TipLink[];
  } catch { return []; }
}

async function getPrevNext(createdAt: string): Promise<{ prev: { title: string; slug: string } | null; next: { title: string; slug: string } | null }> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return { prev: null, next: null };
  try {
    const supabase = await createClient();
    const [prevRes, nextRes] = await Promise.all([
      supabase.from("automation_tips").select("title,slug").eq("published", true).lt("created_at", createdAt).order("created_at", { ascending: false }).limit(1),
      supabase.from("automation_tips").select("title,slug").eq("published", true).gt("created_at", createdAt).order("created_at", { ascending: true }).limit(1),
    ]);
    return {
      prev: (prevRes.data?.[0] as { title: string; slug: string }) || null,
      next: (nextRes.data?.[0] as { title: string; slug: string }) || null,
    };
  } catch { return { prev: null, next: null }; }
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const tip = await getTip(slug);
  if (!tip) return { title: "Tip Not Found | AutomateQA" };
  const canonicalUrl = `${process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online"}/automation-tips/${slug}`;
  const tags: string[] = Array.isArray(tip.tags) ? tip.tags : [];
  return {
    title: `${tip.title} | AutomateQA Tips`,
    description: tip.excerpt,
    keywords: [...tags, tip.category, "QA automation", "automation tip", "software testing", "AutomateQA"],
    alternates: { canonical: canonicalUrl },
    openGraph: {
      type: "article",
      url: canonicalUrl,
      title: tip.title,
      description: tip.excerpt,
      images: tip.cover_image
        ? [{ url: tip.cover_image, width: 1200, height: 630, alt: tip.title }]
        : [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
      publishedTime: tip.created_at,
      modifiedTime: tip.updated_at || tip.created_at,
      tags,
      section: tip.category,
    },
    twitter: {
      card: "summary_large_image",
      title: tip.title,
      description: tip.excerpt,
      images: tip.cover_image ? [tip.cover_image] : ["/og-image.png"],
    },
  };
}

export default async function TipDetailPage({ params }: Props) {
  const { slug } = await params;
  const tip = await getTip(slug);
  if (!tip) notFound();

  const [popularTips, { prev, next }] = await Promise.all([
    getPopularTips(tip.id),
    getPrevNext(tip.created_at),
  ]);

  const youtubeId = tip.youtube_url
    ? tip.youtube_url.match(/(?:v=|youtu\.be\/|embed\/)([^&?/]+)/)?.[1]
    : null;

  const canonicalUrl = `${process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online"}/automation-tips/${slug}`;
  const tags: string[] = Array.isArray(tip.tags) ? tip.tags : [];
  const formattedContent = formatTipContent(tip.content || "");
  const headings = extractHeadings(formattedContent);

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    headline: tip.title,
    description: tip.excerpt,
    image: tip.cover_image || `${process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online"}/og-image.png`,
    url: canonicalUrl,
    datePublished: tip.created_at,
    dateModified: tip.updated_at || tip.created_at,
    author: { "@type": "Organization", name: "AutomateQA", url: process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online" },
    publisher: {
      "@type": "Organization",
      name: "AutomateQA",
      url: process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online",
      logo: { "@type": "ImageObject", url: `${process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online"}/logo.png` },
    },
    mainEntityOfPage: { "@type": "WebPage", "@id": canonicalUrl },
    keywords: tags.join(", "),
    articleSection: tip.category,
    timeRequired: `PT${tip.read_time}M`,
    inLanguage: "en-US",
  };

  return (
    <div className="min-h-screen pt-16 bg-[#0B0B0B]">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />
      <ReadingProgress />

      <div className="h-8" />

      {/* ── Two-column layout ── */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
        <div className="flex gap-10">

          {/* ── Article ── */}
          <article className="flex-1 min-w-0 min-h-0">

            {/* Back button */}
            <div className="pt-8 mb-8">
              <Link
                href="/automation-tips"
                className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 text-sm font-medium transition-all group backdrop-blur-sm"
              >
                <ArrowLeft size={14} className="group-hover:-translate-x-0.5 transition-transform" />
                Back to Tips & Tricks
              </Link>
            </div>

            {/* ── Article header ── */}
            <header className="mb-10">
              {/* Badges row */}
              <div className="flex flex-wrap items-center gap-2.5 mb-6">
                <span className={`category-badge border ${CATEGORY_COLORS[tip.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                  {tip.category}
                </span>
                <span className={`category-badge border ${DIFFICULTY_COLORS[tip.difficulty as Difficulty]}`}>
                  {tip.difficulty}
                </span>
                {tip.featured && (
                  <span className="category-badge border bg-yellow-500/10 text-yellow-400 border-yellow-500/25">
                    Trending
                  </span>
                )}
                <span className="flex items-center gap-1.5 text-xs text-[#6B7280] bg-white/[0.04] border border-white/8 px-3 py-1.5 rounded-full">
                  <Clock size={11} className="text-[#4B5563]" />
                  {tip.read_time} min read
                </span>
              </div>

              {/* Title */}
              <h1 className="text-4xl sm:text-5xl lg:text-[3.2rem] font-black text-white leading-[1.08] tracking-tight mb-6">
                {tip.title}
              </h1>

              {/* Excerpt */}
              {tip.excerpt && (
                <p className="text-lg text-[#6B7280] leading-relaxed mb-8 max-w-2xl font-light">
                  {tip.excerpt}
                </p>
              )}

              {/* Author + meta + share */}
              <div className="flex flex-wrap items-center justify-between gap-4 py-5 border-t border-b border-white/[0.07]">
                <div className="flex flex-wrap items-center gap-x-5 gap-y-3">
                  {/* Author */}
                  <div className="flex items-center gap-3">
                    <div className="relative w-9 h-9 flex-shrink-0 ring-[1.5px] ring-[#00FF88]/30 ring-offset-1 ring-offset-[#0B0B0B] rounded-full">
                      <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
                    </div>
                    <div className="leading-none">
                      <p className="text-sm font-semibold text-white">Nagendra Meesala</p>
                      <p className="text-xs text-[#4B5563] mt-0.5">QA Automation Engineer</p>
                    </div>
                  </div>

                  <span className="hidden sm:block w-px h-7 bg-white/8" />

                  <div className="flex items-center gap-1.5 text-[#6B7280] text-sm">
                    <Calendar size={13} className="text-[#4B5563]" />
                    {formatDate(tip.created_at)}
                  </div>

                  {tip.views >= 5 && (
                    <div className="flex items-center gap-1.5 text-[#6B7280] text-sm">
                      <Eye size={13} className="text-[#4B5563]" />
                      {tip.views.toLocaleString()} views
                    </div>
                  )}
                </div>
                <TipShareButtons title={tip.title} />
              </div>
            </header>

            {/* Cover image — inline in article */}
            {tip.cover_image && (
              <div className="mb-8 rounded-2xl overflow-hidden shadow-[0_4px_32px_rgba(0,0,0,0.6)] ring-1 ring-white/[0.06]">
                <img src={tip.cover_image} alt={tip.title} className="w-full object-cover" />
              </div>
            )}

            {/* Mobile TOC */}
            <TableOfContentsMobile headings={headings} />

            {/* YouTube embed (if no cover image hero) */}
            {youtubeId && (
              <div className="mb-8 rounded-2xl overflow-hidden shadow-[0_8px_40px_rgba(0,0,0,0.7)] ring-1 ring-white/[0.06]">
                <div className="aspect-video">
                  <iframe
                    src={`https://www.youtube.com/embed/${youtubeId}?rel=0&modestbranding=1`}
                    title={tip.title}
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowFullScreen
                    className="w-full h-full"
                    frameBorder="0"
                  />
                </div>
              </div>
            )}

            {/* ── Content ── */}
            <BlogContent content={formattedContent} />

            {/* ── CTA ── */}
            <div className="mt-14 relative rounded-2xl overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-br from-[#00FF88]/10 via-[#00FF88]/4 to-[#0B0B0B]" />
              <div className="absolute inset-0 border border-[#00FF88]/15 rounded-2xl" />
              <div className="absolute -top-24 -right-24 w-64 h-64 bg-[#00FF88]/8 rounded-full blur-3xl pointer-events-none" />
              <div className="relative p-8 sm:p-10">
                <div className="flex items-center gap-2 mb-4">
                  <span className="flex items-center justify-center w-7 h-7 rounded-lg bg-[#00FF88]/15 border border-[#00FF88]/20">
                    <BookOpen size={14} className="text-[#00FF88]" />
                  </span>
                  <span className="text-[#00FF88] text-xs font-bold uppercase tracking-[0.15em]">Keep Learning</span>
                </div>
                <h3 className="text-2xl sm:text-3xl font-black text-white mb-3 leading-tight">
                  Enjoyed This Tip?
                </h3>
                <p className="text-[#6B7280] leading-relaxed mb-8 max-w-lg">
                  Explore hundreds more practical tips for QA engineers — Playwright, Selenium, API testing, CI/CD, and real debugging patterns.
                </p>
                <div className="flex flex-wrap gap-3">
                  <Link
                    href="/automation-tips"
                    className="inline-flex items-center gap-2 px-6 py-3 bg-[#00FF88] text-black font-bold text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all shadow-[0_0_24px_rgba(0,255,136,0.25)]"
                  >
                    Browse All Tips →
                  </Link>
                  <Link
                    href="/learn"
                    className="inline-flex items-center gap-2 px-6 py-3 border border-white/10 bg-white/[0.04] text-[#C9D1D9] text-sm font-medium rounded-xl hover:border-white/20 hover:text-white hover:bg-white/[0.07] transition-all"
                  >
                    Full Tutorials
                    <ArrowRight size={13} />
                  </Link>
                </div>
              </div>
            </div>

            {/* ── Tags ── */}
            {tags.length > 0 && (
              <div className="flex flex-wrap items-center gap-2 mt-10 pt-8 border-t border-white/[0.07]">
                <span className="flex items-center gap-1.5 text-xs text-[#4B5563] font-semibold uppercase tracking-widest mr-1">
                  <Tag size={12} /> Tags
                </span>
                {tags.map((tag) => (
                  <span
                    key={tag}
                    className="px-3 py-1.5 text-xs rounded-lg border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-[#00FF88]/30 hover:text-[#00FF88] hover:bg-[#00FF88]/5 transition-all font-medium cursor-default"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}

            {/* ── Likes, Share & Comments ── */}
            <TipInteractions tipId={tip.id} initialLikes={tip.likes || 0} title={tip.title} />

            {/* ── Prev / Next navigation ── */}
            {(prev || next) && (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-10 pt-8 border-t border-white/[0.07]">
                {prev ? (
                  <Link href={`/automation-tips/${prev.slug}`} className="group block">
                    <div className="h-full rounded-2xl border border-white/8 bg-[#0E0E0E] p-5 hover:border-[#00FF88]/20 hover:bg-[#00FF88]/[0.02] hover:shadow-[0_0_24px_rgba(0,255,136,0.05)] transition-all duration-300">
                      <div className="flex items-center gap-2 text-xs text-[#6B7280] mb-2">
                        <ArrowLeft size={12} className="group-hover:-translate-x-0.5 transition-transform" />
                        Previous Tip
                      </div>
                      <p className="text-white text-sm font-bold leading-snug group-hover:text-[#00FF88] transition-colors line-clamp-2">
                        {prev.title}
                      </p>
                    </div>
                  </Link>
                ) : <div />}
                {next && (
                  <Link href={`/automation-tips/${next.slug}`} className="group block sm:text-right">
                    <div className="h-full rounded-2xl border border-white/8 bg-[#0E0E0E] p-5 hover:border-[#00FF88]/20 hover:bg-[#00FF88]/[0.02] hover:shadow-[0_0_24px_rgba(0,255,136,0.05)] transition-all duration-300">
                      <div className="flex items-center justify-end gap-2 text-xs text-[#6B7280] mb-2">
                        Next Tip
                        <ArrowRight size={12} className="group-hover:translate-x-0.5 transition-transform" />
                      </div>
                      <p className="text-white text-sm font-bold leading-snug group-hover:text-[#00FF88] transition-colors line-clamp-2">
                        {next.title}
                      </p>
                    </div>
                  </Link>
                )}
              </div>
            )}

          </article>

          {/* ── Desktop sidebar (TOC + Popular Tips + CTA) ── */}
          <aside className="hidden lg:block w-64 shrink-0 self-start sticky top-24 space-y-5">

            {/* Table of Contents */}
            <TableOfContentsDesktop headings={headings} />

            {/* Popular Tips */}
            {popularTips.length > 0 && (
              <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden shadow-[0_4px_24px_rgba(0,0,0,0.4)]">
                <div className="flex items-center gap-2.5 px-4 py-3.5 border-b border-white/5">
                  <span className="w-5 h-5 rounded-md bg-yellow-500/15 flex items-center justify-center flex-shrink-0">
                    <Lightbulb size={10} className="text-yellow-400" />
                  </span>
                  <span className="text-[11px] font-bold text-[#9CA3AF] uppercase tracking-[0.12em]">
                    Popular Tips
                  </span>
                </div>
                <nav className="p-3 space-y-1">
                  {popularTips.map((t) => (
                    <Link
                      key={t.id}
                      href={`/automation-tips/${t.slug}`}
                      className="group flex items-start gap-2.5 px-3 py-2 rounded-lg hover:bg-white/[0.04] transition-all"
                    >
                      <span className="flex-shrink-0 w-[5px] h-[5px] rounded-full bg-[#374151] group-hover:bg-[#00FF88] transition-colors mt-[7px]" />
                      <span className="text-[0.74rem] leading-snug text-[#6B7280] group-hover:text-[#C9D1D9] transition-colors line-clamp-2 flex-1">
                        {t.title}
                      </span>
                    </Link>
                  ))}
                </nav>
              </div>
            )}

            {/* Master Playwright CTA */}
            <div className="rounded-2xl border border-[#00FF88]/20 bg-gradient-to-br from-[#00FF88]/8 via-[#0E0E0E] to-[#0E0E0E] p-5 overflow-hidden relative shadow-[0_4px_24px_rgba(0,0,0,0.4)]">
              <div className="absolute -top-4 -right-4 w-20 h-20 bg-[#00FF88]/8 rounded-full blur-2xl pointer-events-none" />
              <div className="relative z-10">
                <p className="text-[#00FF88] font-black text-sm mb-0.5">Master Playwright</p>
                <p className="text-white/50 text-[10px] mb-2 font-medium uppercase tracking-wider">From Basics to Advanced</p>
                <p className="text-[#6B7280] text-[0.72rem] leading-relaxed mb-4">
                  Level up with in-depth tutorials and real automation patterns.
                </p>
                <Link
                  href="/learn"
                  className="inline-flex items-center gap-1.5 px-4 py-2 bg-[#00FF88] text-black text-[0.72rem] font-black rounded-lg hover:bg-[#00E67A] hover:shadow-[0_0_12px_rgba(0,255,136,0.3)] active:scale-95 transition-all"
                >
                  Explore Tutorials →
                </Link>
              </div>
            </div>

          </aside>

        </div>
      </div>
    </div>
  );
}
