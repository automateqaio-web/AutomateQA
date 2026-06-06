import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Clock, Tag, ExternalLink } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { formatDate } from "@/lib/utils";
import { CATEGORY_COLORS, Video } from "@/types";
import RelatedVideos from "@/components/videos/RelatedVideos";

interface Props {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  try {
    const supabase = await createClient();
    const { data } = await supabase.from("videos").select("*").eq("id", id).single();
    if (!data) return { title: "Video Not Found" };
    return {
      title: data.title,
      description: data.description,
      openGraph: { title: data.title, description: data.description, images: [data.thumbnail] },
    };
  } catch {
    return { title: "Video" };
  }
}

export default async function VideoDetailPage({ params }: Props) {
  const { id } = await params;
  const supabase = await createClient();

  const { data: video } = await supabase.from("videos").select("*").eq("id", id).eq("published", true).single();
  if (!video) notFound();

  const { data: relatedVideos } = await supabase
    .from("videos")
    .select("*")
    .eq("published", true)
    .eq("category", video.category)
    .neq("id", id)
    .limit(4);

  return (
    <div className="min-h-screen pt-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Back link */}
        <Link href="/videos" className="inline-flex items-center gap-2 text-[#9CA3AF] hover:text-[#00FF88] text-sm font-medium mb-8 transition-colors group">
          <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
          Back to Videos
        </Link>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main content */}
          <div className="lg:col-span-2">
            {/* YouTube embed */}
            <div className="relative aspect-video rounded-2xl overflow-hidden bg-[#111] mb-6 shadow-2xl">
              <iframe
                src={`https://www.youtube.com/embed/${video.youtube_id}?rel=0&modestbranding=1`}
                title={video.title}
                className="w-full h-full"
                frameBorder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              />
            </div>

            {/* Video info */}
            <div className="glass-card p-6">
              <div className="flex flex-wrap items-start justify-between gap-4 mb-4">
                <div className="flex-1">
                  <span className={`category-badge border mb-3 inline-flex ${CATEGORY_COLORS[video.category] || ""}`}>{video.category}</span>
                  <h1 className="text-2xl sm:text-3xl font-black text-white leading-tight">{video.title}</h1>
                </div>
                <a
                  href={video.youtube_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn-outline text-sm py-2 flex-shrink-0"
                >
                  <ExternalLink size={14} />
                  Watch on YouTube
                </a>
              </div>

              <div className="flex items-center gap-4 text-sm text-[#9CA3AF] mb-4">
                <span className="flex items-center gap-1.5">
                  <Clock size={13} />
                  {formatDate(video.created_at)}
                </span>
              </div>

              {video.description && (
                <p className="text-[#D1D5DB] leading-relaxed mb-4">{video.description}</p>
              )}

              {video.tags?.length > 0 && (
                <div className="flex flex-wrap gap-2 pt-4 border-t border-white/5">
                  <Tag size={13} className="text-[#9CA3AF] mt-0.5" />
                  {video.tags.map((tag: string) => (
                    <span key={tag} className="tag-chip">{tag}</span>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Sidebar - Related videos */}
          <div>
            <h2 className="text-lg font-bold text-white mb-4">Related Videos</h2>
            <RelatedVideos videos={relatedVideos || []} />
          </div>
        </div>
      </div>
    </div>
  );
}
