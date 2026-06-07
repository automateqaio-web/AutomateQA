import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { ArrowLeft, Clock, Calendar, Tag, Eye, BookOpen, ArrowRight } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { formatDate } from "@/lib/utils";
import { CATEGORY_COLORS } from "@/types";
import BlogContent from "@/components/blog/BlogContent";
import BlogViewTracker from "@/components/blog/BlogViewTracker";
import BlogInteractions from "@/components/blog/BlogInteractions";
import ReadingProgress from "@/components/blog/ReadingProgress";
import { TableOfContentsMobile, TableOfContentsDesktop } from "@/components/blog/TableOfContents";
import type { Heading } from "@/components/blog/TableOfContents";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

interface Props {
  params: Promise<{ slug: string }>;
}

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

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  try {
    const supabase = await createClient();
    const { data } = await supabase.from("blogs").select("*").eq("slug", slug).single();
    if (!data) return { title: "Article Not Found" };

    const canonicalUrl = `${SITE_URL}/blog/${slug}`;
    const tags: string[] = Array.isArray(data.tags) ? data.tags : [];

    return {
      title: data.title,
      description: data.excerpt,
      keywords: [...tags, data.category, "QA automation", "software testing", "AutomateQA"],
      authors: [{ name: "AutomateQA" }],
      alternates: { canonical: canonicalUrl },
      openGraph: {
        type: "article",
        url: canonicalUrl,
        title: data.title,
        description: data.excerpt,
        images: data.cover_image
          ? [{ url: data.cover_image, width: 1200, height: 630, alt: data.title }]
          : [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
        publishedTime: data.created_at,
        modifiedTime: data.updated_at || data.created_at,
        tags,
        authors: [`${SITE_URL}/blog`],
        section: data.category,
      },
      twitter: {
        card: "summary_large_image",
        title: data.title,
        description: data.excerpt,
        images: data.cover_image ? [data.cover_image] : ["/og-image.png"],
      },
    };
  } catch {
    return { title: "Article" };
  }
}

export default async function BlogPostPage({ params }: Props) {
  const { slug } = await params;
  const supabase = await createClient();

  const { data: blog } = await supabase
    .from("blogs")
    .select("*")
    .eq("slug", slug)
    .eq("published", true)
    .single();
  if (!blog) notFound();

  const { data: relatedBlogs } = await supabase
    .from("blogs")
    .select("id, title, slug, excerpt, category, cover_image, read_time, created_at")
    .eq("published", true)
    .eq("category", blog.category)
    .neq("id", blog.id)
    .limit(3);

  const canonicalUrl = `${SITE_URL}/blog/${slug}`;
  const tags: string[] = Array.isArray(blog.tags) ? blog.tags : [];
  const headings = extractHeadings(blog.content || "");

  const schemas = [
    {
      "@context": "https://schema.org",
      "@type": "BlogPosting",
      headline: blog.title,
      description: blog.excerpt,
      image: blog.cover_image || `${SITE_URL}/og-image.png`,
      url: canonicalUrl,
      datePublished: blog.created_at,
      dateModified: blog.updated_at || blog.created_at,
      author: { "@type": "Person", name: "AutomateQA", url: SITE_URL },
      publisher: {
        "@type": "Organization",
        name: "AutomateQA",
        url: SITE_URL,
        logo: { "@type": "ImageObject", url: `${SITE_URL}/logo.png` },
      },
      mainEntityOfPage: { "@type": "WebPage", "@id": canonicalUrl },
      keywords: tags.join(", "),
      articleSection: blog.category,
      timeRequired: `PT${blog.read_time}M`,
      inLanguage: "en-US",
    },
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      itemListElement: [
        { "@type": "ListItem", position: 1, name: "Home", item: SITE_URL },
        { "@type": "ListItem", position: 2, name: "Blog", item: `${SITE_URL}/blog` },
        { "@type": "ListItem", position: 3, name: blog.title, item: canonicalUrl },
      ],
    },
  ];

  return (
    <div className="min-h-screen pt-16 bg-[#0B0B0B]">
      {schemas.map((s, i) => (
        <script key={i} type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(s) }} />
      ))}
      <ReadingProgress />

      {/* ── Hero ── */}
      {blog.cover_image ? (
        <div className="relative w-full h-[420px] sm:h-[500px] overflow-hidden">
          <img
            src={blog.cover_image}
            alt={blog.title}
            className="w-full h-full object-cover object-top scale-[1.03]"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-[#0B0B0B] via-[#0B0B0B]/50 to-transparent" />
          <div className="absolute inset-0 bg-gradient-to-r from-[#0B0B0B]/20 to-transparent" />
          {/* Glow at bottom */}
          <div className="absolute bottom-0 left-0 right-0 h-32 bg-gradient-to-t from-[#0B0B0B] to-transparent" />
        </div>
      ) : (
        <div className="h-16" />
      )}

      {/* ── Page layout ── */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
        <div className="flex gap-10">

          {/* ── Article ── */}
          <article className="flex-1 min-w-0 min-h-0">

            {/* Back button */}
            <div className={blog.cover_image ? "-mt-6 mb-8" : "pt-8 mb-8"}>
              <Link
                href="/blog"
                className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 text-sm font-medium transition-all group backdrop-blur-sm"
              >
                <ArrowLeft size={14} className="group-hover:-translate-x-0.5 transition-transform" />
                Back to Blog
              </Link>
            </div>

            {/* ── Article header ── */}
            <header className="mb-12">
              {/* Badges row */}
              <div className="flex flex-wrap items-center gap-2.5 mb-6">
                <span className={`category-badge border ${CATEGORY_COLORS[blog.category] || ""}`}>
                  {blog.category}
                </span>
                <span className="flex items-center gap-1.5 text-xs text-[#6B7280] bg-white/[0.04] border border-white/8 px-3 py-1.5 rounded-full">
                  <Clock size={11} className="text-[#4B5563]" />
                  {blog.read_time} min read
                </span>
              </div>

              {/* Title */}
              <h1 className="text-4xl sm:text-5xl lg:text-[3.4rem] font-black text-white leading-[1.08] tracking-tight mb-6">
                {blog.title}
              </h1>

              {/* Excerpt */}
              {blog.excerpt && (
                <p className="text-lg text-[#6B7280] leading-relaxed mb-8 max-w-2xl font-light">
                  {blog.excerpt}
                </p>
              )}

              {/* Author + meta bar */}
              <div className="flex flex-wrap items-center gap-x-6 gap-y-3 py-5 border-t border-b border-white/[0.07]">
                {/* Author */}
                <div className="flex items-center gap-3">
                  <div className="relative w-9 h-9 flex-shrink-0 ring-[1.5px] ring-[#00FF88]/30 ring-offset-1 ring-offset-[#0B0B0B] rounded-full">
                    <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
                  </div>
                  <div className="leading-none">
                    <p className="text-sm font-semibold text-white">AutomateQA</p>
                    <p className="text-xs text-[#4B5563] mt-0.5">Author</p>
                  </div>
                </div>

                <span className="hidden sm:block w-px h-7 bg-white/8" />

                {/* Date */}
                <div className="flex items-center gap-1.5 text-[#6B7280] text-sm">
                  <Calendar size={13} className="text-[#4B5563]" />
                  {formatDate(blog.created_at)}
                </div>

                {/* Views */}
                <div className="flex items-center gap-1.5 text-[#6B7280] text-sm">
                  <Eye size={13} className="text-[#4B5563]" />
                  {(blog.views || 0).toLocaleString()} views
                </div>
              </div>
            </header>

            <BlogViewTracker slug={slug} />

            {/* Mobile TOC */}
            <TableOfContentsMobile headings={headings} />

            {/* Blog content */}
            <BlogContent content={blog.content} />

            {/* ── CTA ── */}
            <div className="mt-16 relative rounded-2xl overflow-hidden">
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
                  Ready to Master QA Automation?
                </h3>
                <p className="text-[#6B7280] leading-relaxed mb-8 max-w-lg">
                  Join thousands of developers and QA engineers learning Playwright, Cypress, and modern
                  automation — one practical lesson at a time.
                </p>
                <div className="flex flex-wrap gap-3">
                  <Link
                    href="/learn"
                    className="inline-flex items-center gap-2 px-6 py-3 bg-[#00FF88] text-black font-bold text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all shadow-[0_0_24px_rgba(0,255,136,0.25)]"
                  >
                    Start Day 1 of Playwright →
                  </Link>
                  <Link
                    href="/blog"
                    className="inline-flex items-center gap-2 px-6 py-3 border border-white/10 bg-white/[0.04] text-[#C9D1D9] text-sm font-medium rounded-xl hover:border-white/20 hover:text-white hover:bg-white/[0.07] transition-all"
                  >
                    Browse All Articles
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
                {tags.map((tag: string) => (
                  <Link
                    key={tag}
                    href={`/blog?tag=${encodeURIComponent(tag)}`}
                    className="px-3 py-1.5 text-xs rounded-lg border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-[#00FF88]/30 hover:text-[#00FF88] hover:bg-[#00FF88]/5 transition-all font-medium"
                  >
                    {tag}
                  </Link>
                ))}
              </div>
            )}

            {/* ── Like, Share & Comments ── */}
            <BlogInteractions slug={slug} initialLikes={blog.likes_count || 0} />

            {/* ── Related articles ── */}
            {relatedBlogs && relatedBlogs.length > 0 && (
              <section className="mt-16 pt-10 border-t border-white/[0.07]">
                <div className="flex items-center justify-between mb-8">
                  <div>
                    <p className="text-xs text-[#4B5563] font-bold uppercase tracking-widest mb-1">Continue Reading</p>
                    <h2 className="text-2xl font-black text-white">More Articles</h2>
                  </div>
                  <Link
                    href="/blog"
                    className="hidden sm:inline-flex items-center gap-1.5 text-sm text-[#6B7280] hover:text-[#00FF88] transition-colors"
                  >
                    View all <ArrowRight size={13} />
                  </Link>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                  {relatedBlogs.map((related) => (
                    <Link key={related.id} href={`/blog/${related.slug}`} className="group block">
                      <div className="h-full rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden hover:border-[#00FF88]/20 hover:shadow-[0_0_32px_rgba(0,255,136,0.06)] transition-all duration-300">
                        {related.cover_image && (
                          <div className="h-40 overflow-hidden">
                            <img
                              src={related.cover_image}
                              alt={related.title}
                              className="w-full h-full object-cover object-top group-hover:scale-105 transition-transform duration-700"
                            />
                          </div>
                        )}
                        <div className="p-5">
                          <span className={`category-badge border mb-3 inline-flex text-[10px] ${CATEGORY_COLORS[related.category] || ""}`}>
                            {related.category}
                          </span>
                          <h3 className="font-bold text-white text-sm line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-2 leading-snug">
                            {related.title}
                          </h3>
                          <p className="text-[#4B5563] text-xs line-clamp-2 mb-4 leading-relaxed">
                            {related.excerpt}
                          </p>
                          <div className="flex items-center justify-between text-xs text-[#374151]">
                            <span className="flex items-center gap-1">
                              <Clock size={10} /> {related.read_time} min read
                            </span>
                            <span className="text-[#00FF88]/60 group-hover:text-[#00FF88] transition-colors font-medium">
                              Read →
                            </span>
                          </div>
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              </section>
            )}
          </article>

          {/* ── Desktop TOC sidebar ── */}
          <aside className="hidden lg:block w-64 shrink-0 self-start sticky top-24">
            <TableOfContentsDesktop headings={headings} />
          </aside>

        </div>
      </div>
    </div>
  );
}
