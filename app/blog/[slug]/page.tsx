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

            {/* ── Follow AutomateQA ── */}
            <div className="mt-10 pt-8 border-t border-white/[0.07]">
              <p className="text-xs font-bold text-[#4B5563] uppercase tracking-widest mb-4">Follow AutomateQA</p>
              <div className="flex flex-wrap gap-3">
                <a href="https://www.youtube.com/@automateqa?sub_confirmation=1" target="_blank" rel="noopener noreferrer"
                  className="group inline-flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-red-500/8 border border-red-500/20 hover:bg-red-500/15 hover:border-red-500/40 transition-all duration-200">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor" className="text-red-400 flex-shrink-0">
                    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                  </svg>
                  <span className="text-sm font-semibold text-red-400 group-hover:text-red-300 transition-colors">YouTube</span>
                  <span className="text-xs text-[#4B5563]">@automateqa</span>
                </a>
                <a href="https://www.instagram.com/automateqa.online" target="_blank" rel="noopener noreferrer"
                  className="group inline-flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-pink-500/8 border border-pink-500/20 hover:bg-pink-500/15 hover:border-pink-500/40 transition-all duration-200">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor" className="text-pink-400 flex-shrink-0">
                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                  </svg>
                  <span className="text-sm font-semibold text-pink-400 group-hover:text-pink-300 transition-colors">Instagram</span>
                  <span className="text-xs text-[#4B5563]">@automateqa.online</span>
                </a>
                <a href="https://www.facebook.com/people/Automate-QA/61590680690708/?mibextid=wwXIfr&rdid=g6rV6XD2Nx4Q1vHf&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1D9b4HsLFm%2F%3Fmibextid%3DwwXIfr" target="_blank" rel="noopener noreferrer"
                  className="group inline-flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-blue-500/8 border border-blue-500/20 hover:bg-blue-500/15 hover:border-blue-500/40 transition-all duration-200">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor" className="text-blue-400 flex-shrink-0">
                    <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                  </svg>
                  <span className="text-sm font-semibold text-blue-400 group-hover:text-blue-300 transition-colors">Facebook</span>
                  <span className="text-xs text-[#4B5563]">Automate QA</span>
                </a>
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
          <aside className="hidden lg:block w-64 shrink-0 self-start sticky top-24 space-y-4">
            <TableOfContentsDesktop headings={headings} />

            {/* Keep Learning CTA */}
            <div className="relative rounded-2xl overflow-hidden border border-[#00FF88]/15">
              <div className="absolute inset-0 bg-gradient-to-br from-[#00FF88]/10 via-[#00FF88]/4 to-[#0B0B0B]" />
              <div className="absolute -top-10 -right-10 w-32 h-32 bg-[#00FF88]/8 rounded-full blur-2xl pointer-events-none" />
              <div className="relative p-5">
                <div className="flex items-center gap-2 mb-3">
                  <span className="flex items-center justify-center w-6 h-6 rounded-lg bg-[#00FF88]/15 border border-[#00FF88]/20">
                    <BookOpen size={12} className="text-[#00FF88]" />
                  </span>
                  <span className="text-[#00FF88] text-[10px] font-bold uppercase tracking-[0.15em]">Keep Learning</span>
                </div>
                <h4 className="text-sm font-black text-white mb-2 leading-snug">
                  Master QA Automation
                </h4>
                <p className="text-[#6B7280] text-xs leading-relaxed mb-4">
                  Playwright, Cypress &amp; modern automation — one practical lesson at a time.
                </p>
                <Link
                  href="/learn"
                  className="flex items-center justify-center gap-1.5 w-full px-4 py-2.5 bg-[#00FF88] text-black font-bold text-xs rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all shadow-[0_0_16px_rgba(0,255,136,0.2)]"
                >
                  Start Day 1 of Playwright →
                </Link>
                <Link
                  href="/blog"
                  className="flex items-center justify-center gap-1.5 w-full mt-2 px-4 py-2 border border-white/10 bg-white/[0.03] text-[#9CA3AF] text-xs font-medium rounded-xl hover:border-white/20 hover:text-white transition-all"
                >
                  Browse All Articles
                </Link>
              </div>
            </div>
          </aside>

        </div>
      </div>
    </div>
  );
}
