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
      const text = m![2]
        .replace(/\*\*/g, "")
        .replace(/`/g, "")
        .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
        .trim();
      const id =
        "h-" +
        text
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, "-")
          .replace(/^-+|-+$/g, "");
      return { id, text, level };
    })
    .filter((h) => h.level <= 3) as Heading[];
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

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: blog.title,
    description: blog.excerpt,
    image: blog.cover_image || `${SITE_URL}/og-image.png`,
    url: canonicalUrl,
    datePublished: blog.created_at,
    dateModified: blog.updated_at || blog.created_at,
    author: { "@type": "Organization", name: "AutomateQA", url: SITE_URL },
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
  };

  return (
    <div className="min-h-screen pt-16">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      {/* Reading progress bar */}
      <ReadingProgress />

      {/* Hero */}
      {blog.cover_image && (
        <div className="relative w-full h-[300px] sm:h-[380px] overflow-hidden">
          <img src={blog.cover_image} alt={blog.title} className="w-full h-full object-cover object-top" />
          <div className="absolute inset-0 bg-gradient-to-b from-black/20 via-black/10 to-[#0B0B0B]" />
        </div>
      )}

      {/* Page layout: article + desktop TOC */}
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex gap-12 xl:gap-16">

          {/* ── Article ── */}
          <article className="flex-1 min-w-0">

            {/* Back */}
            <Link
              href="/blog"
              className="inline-flex items-center gap-2 text-[#9CA3AF] hover:text-[#00FF88] text-sm font-medium mb-8 transition-colors group"
            >
              <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
              Back to Blog
            </Link>

            {/* Article header */}
            <header className="mb-10">
              <span className={`category-badge border mb-4 inline-flex ${CATEGORY_COLORS[blog.category] || ""}`}>
                {blog.category}
              </span>
              <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black text-white leading-tight mb-6">
                {blog.title}
              </h1>
              {blog.excerpt && (
                <p className="text-xl text-[#9CA3AF] leading-relaxed mb-6">{blog.excerpt}</p>
              )}
              <div className="flex flex-wrap items-center gap-4 text-sm text-[#9CA3AF] pb-6 border-b border-white/5">
                <span className="flex items-center gap-1.5">
                  <Calendar size={14} /> {formatDate(blog.created_at)}
                </span>
                <span className="flex items-center gap-1.5">
                  <Clock size={14} /> {blog.read_time} min read
                </span>
                <span className="flex items-center gap-1.5">
                  <Eye size={14} /> {(blog.views || 0).toLocaleString()} {blog.views === 1 ? "view" : "views"}
                </span>
              </div>
            </header>

            <BlogViewTracker slug={slug} />

            {/* Mobile TOC */}
            <TableOfContentsMobile headings={headings} />

            {/* Blog content */}
            <BlogContent content={blog.content} />

            {/* ── CTA ── */}
            <div className="mt-14 p-8 rounded-2xl border border-[#00FF88]/20 bg-gradient-to-br from-[#00FF88]/6 via-[#00FF88]/3 to-transparent relative overflow-hidden">
              <div className="absolute top-0 right-0 w-40 h-40 bg-[#00FF88]/5 rounded-full -translate-y-20 translate-x-20 pointer-events-none" />
              <div className="relative">
                <div className="flex items-center gap-2 mb-3">
                  <BookOpen size={16} className="text-[#00FF88]" />
                  <span className="text-[#00FF88] text-xs font-bold uppercase tracking-widest">Keep Learning</span>
                </div>
                <h3 className="text-xl sm:text-2xl font-black text-white mb-2 leading-tight">
                  Ready to Master QA Automation?
                </h3>
                <p className="text-[#9CA3AF] text-sm leading-relaxed mb-6 max-w-lg">
                  Join thousands of developers and QA engineers learning Playwright, Cypress, and modern
                  automation — one practical lesson at a time.
                </p>
                <div className="flex flex-wrap gap-3">
                  <Link
                    href="/learn"
                    className="inline-flex items-center gap-2 px-5 py-2.5 bg-[#00FF88] text-black font-bold text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all"
                  >
                    Start Day 1 of Playwright →
                  </Link>
                  <Link
                    href="/blog"
                    className="inline-flex items-center gap-2 px-5 py-2.5 border border-white/10 text-[#C9D1D9] text-sm font-medium rounded-xl hover:border-white/20 hover:text-white transition-all"
                  >
                    Browse All Articles
                    <ArrowRight size={13} />
                  </Link>
                </div>
              </div>
            </div>

            {/* ── Author ── */}
            <div className="flex items-center gap-4 mt-8 p-5 rounded-2xl border border-white/8 bg-white/[0.02]">
              <div className="relative w-14 h-14 flex-shrink-0">
                <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
              </div>
              <div>
                <p className="text-[10px] font-semibold text-[#6B7280] uppercase tracking-widest mb-0.5">
                  Written by
                </p>
                <p className="text-white font-bold text-base">AutomateQA</p>
                <p className="text-[#9CA3AF] text-sm mt-0.5 leading-snug">
                  QA automation tutorials, memes, and tips — helping developers and testers ship faster, better software.
                </p>
              </div>
            </div>

            {/* ── Tags ── */}
            {tags.length > 0 && (
              <div className="flex flex-wrap gap-2 mt-8 pt-6 border-t border-white/5">
                <Tag size={14} className="text-[#9CA3AF] mt-0.5" />
                {tags.map((tag: string) => (
                  <span key={tag} className="tag-chip">{tag}</span>
                ))}
              </div>
            )}

            {/* ── Like, Share, Rating, Comments ── */}
            <BlogInteractions slug={slug} initialLikes={blog.likes_count || 0} />

            {/* ── Related articles ── */}
            {relatedBlogs && relatedBlogs.length > 0 && (
              <section className="mt-16 pt-8 border-t border-white/5">
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-xl font-black text-white">Read Next</h2>
                  <Link href="/blog" className="text-sm text-[#00FF88] hover:text-white transition-colors flex items-center gap-1">
                    All articles <ArrowRight size={13} />
                  </Link>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  {relatedBlogs.map((related) => (
                    <Link key={related.id} href={`/blog/${related.slug}`} className="group block">
                      <div className="glass-card-hover h-full p-0 overflow-hidden">
                        {related.cover_image && (
                          <div className="h-36 overflow-hidden">
                            <img
                              src={related.cover_image}
                              alt={related.title}
                              className="w-full h-full object-cover object-top group-hover:scale-105 transition-transform duration-500"
                            />
                          </div>
                        )}
                        <div className="p-4">
                          <span className={`category-badge border mb-2 inline-flex text-[10px] ${CATEGORY_COLORS[related.category] || ""}`}>
                            {related.category}
                          </span>
                          <h3 className="font-bold text-white text-sm line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-2 leading-snug">
                            {related.title}
                          </h3>
                          <p className="text-[#6B7280] text-xs line-clamp-2 mb-3 leading-relaxed">
                            {related.excerpt}
                          </p>
                          <span className="text-xs text-[#4B5563] flex items-center gap-1">
                            <Clock size={10} /> {related.read_time} min read
                          </span>
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              </section>
            )}
          </article>

          {/* ── Desktop TOC sidebar ── */}
          <aside className="hidden lg:block w-52 xl:w-56 flex-shrink-0 pt-[5.5rem]">
            <TableOfContentsDesktop headings={headings} />
          </aside>

        </div>
      </div>
    </div>
  );
}
