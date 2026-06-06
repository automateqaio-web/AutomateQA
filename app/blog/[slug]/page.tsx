import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Clock, Calendar, Tag, Eye } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { formatDate } from "@/lib/utils";
import { CATEGORY_COLORS } from "@/types";
import BlogContent from "@/components/blog/BlogContent";
import BlogViewTracker from "@/components/blog/BlogViewTracker";
import BlogInteractions from "@/components/blog/BlogInteractions";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

interface Props {
  params: Promise<{ slug: string }>;
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

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: blog.title,
    description: blog.excerpt,
    image: blog.cover_image || `${SITE_URL}/og-image.png`,
    url: canonicalUrl,
    datePublished: blog.created_at,
    dateModified: blog.updated_at || blog.created_at,
    author: {
      "@type": "Organization",
      name: "AutomateQA",
      url: SITE_URL,
    },
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
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      {/* Hero */}
      {blog.cover_image && (
        <div className="relative w-full h-[320px] sm:h-[400px] overflow-hidden">
          <img src={blog.cover_image} alt={blog.title} className="w-full h-full object-cover object-top" />
          <div className="absolute inset-0 bg-gradient-to-b from-black/20 via-black/10 to-[#0B0B0B]" />
        </div>
      )}

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
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
              <Calendar size={14} />
              {formatDate(blog.created_at)}
            </span>
            <span className="flex items-center gap-1.5">
              <Clock size={14} />
              {blog.read_time} min read
            </span>
            <span className="flex items-center gap-1.5">
              <Eye size={14} />
              {(blog.views || 0).toLocaleString()} {blog.views === 1 ? "view" : "views"}
            </span>
          </div>
        </header>
        <BlogViewTracker slug={slug} />

        {/* Blog content */}
        <BlogContent content={blog.content} />

        {/* Interactions: like, share, rating, comments */}
        <BlogInteractions slug={slug} initialLikes={blog.likes_count || 0} />

        {/* Tags */}
        {tags.length > 0 && (
          <div className="flex flex-wrap gap-2 mt-10 pt-6 border-t border-white/5">
            <Tag size={14} className="text-[#9CA3AF]" />
            {tags.map((tag: string) => (
              <span key={tag} className="tag-chip">{tag}</span>
            ))}
          </div>
        )}

        {/* Related articles */}
        {relatedBlogs && relatedBlogs.length > 0 && (
          <section className="mt-16 pt-8 border-t border-white/5">
            <h2 className="text-2xl font-black text-white mb-6">Related Articles</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {relatedBlogs.map((related) => (
                <Link key={related.id} href={`/blog/${related.slug}`} className="group block">
                  <div className="glass-card-hover p-4">
                    {related.cover_image && (
                      <div className="aspect-video rounded-xl overflow-hidden mb-3">
                        <img
                          src={related.cover_image}
                          alt={related.title}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                        />
                      </div>
                    )}
                    <span className={`category-badge border mb-2 inline-flex ${CATEGORY_COLORS[related.category] || ""}`}>
                      {related.category}
                    </span>
                    <h3 className="font-semibold text-white text-sm line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-2">
                      {related.title}
                    </h3>
                    <span className="text-xs text-[#9CA3AF] flex items-center gap-1">
                      <Clock size={10} /> {related.read_time} min
                    </span>
                  </div>
                </Link>
              ))}
            </div>
          </section>
        )}
      </div>
    </div>
  );
}
