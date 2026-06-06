import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Clock, Eye, Tag, Lightbulb, Calendar } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { CATEGORY_COLORS, DIFFICULTY_COLORS, Difficulty, AutomationTip } from "@/types";
import { formatDate } from "@/lib/utils";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeHighlight from "rehype-highlight";

export const revalidate = 3600;

interface Props { params: Promise<{ slug: string }> }

async function getTip(slug: string): Promise<AutomationTip | null> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) {
    return null;
  }
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("automation_tips")
      .select("*")
      .eq("slug", slug)
      .eq("published", true)
      .single();

    if (data) {
      supabase.from("automation_tips").update({ views: (data.views || 0) + 1 }).eq("id", data.id).then(() => {});
    }
    return data;
  } catch {
    return null;
  }
}

async function getRelated(category: string, currentId: string): Promise<AutomationTip[]> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return [];
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("automation_tips")
      .select("id,title,slug,category,difficulty,cover_image,read_time,views,created_at,excerpt,content,tags,featured,published,youtube_url,updated_at")
      .eq("category", category)
      .eq("published", true)
      .neq("id", currentId)
      .limit(3);
    return data || [];
  } catch {
    return [];
  }
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const tip = await getTip(slug);
  if (!tip) return { title: "Tip Not Found | AutomateQA" };
  const canonicalUrl = `https://automateqa.online/automation-tips/${slug}`;
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

  const related = await getRelated(tip.category, tip.id);
  const youtubeId = tip.youtube_url
    ? tip.youtube_url.match(/(?:v=|youtu\.be\/|embed\/)([^&?/]+)/)?.[1]
    : null;

  const canonicalUrl = `https://automateqa.online/automation-tips/${slug}`;
  const tags: string[] = Array.isArray(tip.tags) ? tip.tags : [];
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    headline: tip.title,
    description: tip.excerpt,
    image: tip.cover_image || "https://automateqa.online/og-image.png",
    url: canonicalUrl,
    datePublished: tip.created_at,
    dateModified: tip.updated_at || tip.created_at,
    author: { "@type": "Organization", name: "AutomateQA", url: "https://automateqa.online" },
    publisher: {
      "@type": "Organization",
      name: "AutomateQA",
      url: "https://automateqa.online",
      logo: { "@type": "ImageObject", url: "https://automateqa.online/logo.png" },
    },
    mainEntityOfPage: { "@type": "WebPage", "@id": canonicalUrl },
    keywords: tags.join(", "),
    articleSection: tip.category,
    timeRequired: `PT${tip.read_time}M`,
    inLanguage: "en-US",
  };

  return (
    <div className="min-h-screen pt-20">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <Link href="/automation-tips" className="inline-flex items-center gap-2 text-sm text-[#9CA3AF] hover:text-[#00FF88] transition-colors mb-8 group">
          <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
          Back to Tips & Tricks
        </Link>

        <div className="mb-8">
          <div className="flex flex-wrap gap-2 mb-4">
            <span className={`category-badge border ${CATEGORY_COLORS[tip.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
              {tip.category}
            </span>
            <span className={`category-badge border ${DIFFICULTY_COLORS[tip.difficulty as Difficulty]}`}>
              {tip.difficulty}
            </span>
            {tip.featured && (
              <span className="category-badge border bg-yellow-500/20 text-yellow-400 border-yellow-500/30">
                Trending
              </span>
            )}
          </div>

          <h1 className="text-3xl sm:text-4xl font-black text-white mb-4 leading-tight">
            {tip.title}
          </h1>

          {tip.excerpt && (
            <p className="text-[#9CA3AF] text-lg leading-relaxed mb-6">{tip.excerpt}</p>
          )}

          <div className="flex flex-wrap items-center gap-4 text-sm text-[#9CA3AF] pb-6 border-b border-white/5">
            <span className="flex items-center gap-1.5"><Calendar size={14} />{formatDate(tip.created_at)}</span>
            <span className="flex items-center gap-1.5"><Clock size={14} />{tip.read_time} min read</span>
            <span className="flex items-center gap-1.5"><Eye size={14} />{tip.views.toLocaleString()} views</span>
          </div>
        </div>

        {tip.cover_image && (
          <div className="aspect-video rounded-2xl overflow-hidden mb-8">
            <img src={tip.cover_image} alt={tip.title} className="w-full h-full object-cover" />
          </div>
        )}

        {youtubeId && (
          <div className="mb-8">
            <div className="aspect-video rounded-2xl overflow-hidden">
              <iframe
                src={`https://www.youtube.com/embed/${youtubeId}`}
                title={tip.title}
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
                className="w-full h-full"
              />
            </div>
          </div>
        )}

        <div className="prose prose-invert prose-lg max-w-none
          prose-headings:font-black prose-headings:text-white
          prose-h1:text-3xl prose-h2:text-2xl prose-h3:text-xl
          prose-p:text-[#D1D5DB] prose-p:leading-relaxed
          prose-a:text-[#00FF88] prose-a:no-underline hover:prose-a:underline
          prose-code:text-[#00FF88] prose-code:bg-[#1A1A1A] prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded
          prose-pre:bg-[#0D0D0D] prose-pre:border prose-pre:border-white/10 prose-pre:rounded-xl
          prose-blockquote:border-l-[#00FF88] prose-blockquote:text-[#9CA3AF]
          prose-strong:text-white
          prose-ul:text-[#D1D5DB] prose-ol:text-[#D1D5DB]
          prose-li:marker:text-[#00FF88]
          prose-hr:border-white/10
          mb-10">
          <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeHighlight]}>
            {tip.content}
          </ReactMarkdown>
        </div>

        {tip.tags?.length > 0 && (
          <div className="flex flex-wrap gap-2 mb-10 pt-6 border-t border-white/5">
            <Tag size={14} className="text-[#9CA3AF] mt-0.5" />
            {tip.tags.map((tag) => (
              <span key={tag} className="tag-chip">{tag}</span>
            ))}
          </div>
        )}

        {related.length > 0 && (
          <div className="mt-12 pt-8 border-t border-white/5">
            <h2 className="text-xl font-black text-white mb-6 flex items-center gap-2">
              <Lightbulb size={18} className="text-yellow-400" />
              Related Tips
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {related.map((item) => (
                <Link key={item.id} href={`/automation-tips/${item.slug}`} className="group block">
                  <div className="glass-card p-4 hover:border-[#00FF88]/20 transition-all">
                    <span className={`category-badge border text-xs ${CATEGORY_COLORS[item.category] || ""}`}>{item.category}</span>
                    <h3 className="text-white text-sm font-semibold mt-2 mb-1 line-clamp-2 group-hover:text-[#00FF88] transition-colors">
                      {item.title}
                    </h3>
                    <span className="text-[#9CA3AF] text-xs flex items-center gap-1">
                      <Clock size={10} />{item.read_time} min
                    </span>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
