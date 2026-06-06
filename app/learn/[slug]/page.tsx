import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Clock, Eye, Tag, BookOpen, Share2, Calendar } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { CATEGORY_COLORS, DIFFICULTY_COLORS, Difficulty, LearningContent } from "@/types";
import { formatDate } from "@/lib/utils";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeHighlight from "rehype-highlight";

export const revalidate = 3600;

interface Props { params: Promise<{ slug: string }> }

async function getTutorial(slug: string): Promise<LearningContent | null> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) {
    return null;
  }
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("learning_content")
      .select("*")
      .eq("slug", slug)
      .eq("published", true)
      .single();

    if (data) {
      supabase.from("learning_content").update({ views: (data.views || 0) + 1 }).eq("id", data.id).then(() => {});
    }
    return data;
  } catch {
    return null;
  }
}

async function getRelated(category: string, currentId: string): Promise<LearningContent[]> {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) return [];
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("learning_content")
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
  const tutorial = await getTutorial(slug);
  if (!tutorial) return { title: "Tutorial Not Found | AutomateQA" };
  return {
    title: `${tutorial.title} | AutomateQA Learn`,
    description: tutorial.excerpt,
    openGraph: {
      title: tutorial.title,
      description: tutorial.excerpt,
      images: tutorial.cover_image ? [tutorial.cover_image] : [],
      type: "article",
    },
  };
}

export default async function LearnDetailPage({ params }: Props) {
  const { slug } = await params;
  const tutorial = await getTutorial(slug);
  if (!tutorial) notFound();

  const related = await getRelated(tutorial.category, tutorial.id);
  const youtubeId = tutorial.youtube_url
    ? tutorial.youtube_url.match(/(?:v=|youtu\.be\/|embed\/)([^&?/]+)/)?.[1]
    : null;

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        {/* Back */}
        <Link href="/learn" className="inline-flex items-center gap-2 text-sm text-[#9CA3AF] hover:text-[#00FF88] transition-colors mb-8 group">
          <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
          Back to Learn
        </Link>

        {/* Header */}
        <div className="mb-8">
          <div className="flex flex-wrap gap-2 mb-4">
            <span className={`category-badge border ${CATEGORY_COLORS[tutorial.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
              {tutorial.category}
            </span>
            <span className={`category-badge border ${DIFFICULTY_COLORS[tutorial.difficulty as Difficulty]}`}>
              {tutorial.difficulty}
            </span>
            {tutorial.featured && (
              <span className="category-badge border bg-[#00FF88]/20 text-[#00FF88] border-[#00FF88]/30">
                Featured
              </span>
            )}
          </div>

          <h1 className="text-3xl sm:text-4xl font-black text-white mb-4 leading-tight">
            {tutorial.title}
          </h1>

          {tutorial.excerpt && (
            <p className="text-[#9CA3AF] text-lg leading-relaxed mb-6">{tutorial.excerpt}</p>
          )}

          <div className="flex flex-wrap items-center gap-4 text-sm text-[#9CA3AF] pb-6 border-b border-white/5">
            <span className="flex items-center gap-1.5"><Calendar size={14} />{formatDate(tutorial.created_at)}</span>
            <span className="flex items-center gap-1.5"><Clock size={14} />{tutorial.read_time} min read</span>
            <span className="flex items-center gap-1.5"><Eye size={14} />{tutorial.views.toLocaleString()} views</span>
          </div>
        </div>

        {/* Cover Image */}
        {tutorial.cover_image && (
          <div className="aspect-video rounded-2xl overflow-hidden mb-8">
            <img src={tutorial.cover_image} alt={tutorial.title} className="w-full h-full object-cover" />
          </div>
        )}

        {/* YouTube embed */}
        {youtubeId && (
          <div className="mb-8">
            <div className="aspect-video rounded-2xl overflow-hidden">
              <iframe
                src={`https://www.youtube.com/embed/${youtubeId}`}
                title={tutorial.title}
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
                className="w-full h-full"
              />
            </div>
          </div>
        )}

        {/* Content */}
        <div className="prose prose-invert prose-lg max-w-none
          prose-headings:font-black prose-headings:text-white
          prose-h1:text-3xl prose-h2:text-2xl prose-h3:text-xl
          prose-p:text-[#D1D5DB] prose-p:leading-relaxed
          prose-a:text-[#00FF88] prose-a:no-underline hover:prose-a:underline
          prose-code:text-[#00FF88] prose-code:bg-[#1A1A1A] prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded
          prose-pre:bg-[#0D0D0D] prose-pre:border prose-pre:border-white/10 prose-pre:rounded-xl
          prose-blockquote:border-l-[#00FF88] prose-blockquote:text-[#9CA3AF]
          prose-strong:text-white prose-em:text-[#9CA3AF]
          prose-ul:text-[#D1D5DB] prose-ol:text-[#D1D5DB]
          prose-li:marker:text-[#00FF88]
          prose-hr:border-white/10
          mb-10">
          <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeHighlight]}>
            {tutorial.content}
          </ReactMarkdown>
        </div>

        {/* Tags */}
        {tutorial.tags?.length > 0 && (
          <div className="flex flex-wrap gap-2 mb-10 pt-6 border-t border-white/5">
            <Tag size={14} className="text-[#9CA3AF] mt-0.5" />
            {tutorial.tags.map((tag) => (
              <span key={tag} className="tag-chip">{tag}</span>
            ))}
          </div>
        )}

        {/* Related */}
        {related.length > 0 && (
          <div className="mt-12 pt-8 border-t border-white/5">
            <h2 className="text-xl font-black text-white mb-6 flex items-center gap-2">
              <BookOpen size={18} className="text-[#00FF88]" />
              Related Tutorials
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {related.map((item) => (
                <Link key={item.id} href={`/learn/${item.slug}`} className="group block">
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
