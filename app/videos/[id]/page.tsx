import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Clock, Tag, ExternalLink, Play } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { formatDate } from "@/lib/utils";
import { CATEGORY_COLORS, Video } from "@/types";
import { getYouTubeThumbnail } from "@/lib/utils";
import VideoInteractions from "@/components/videos/VideoInteractions";

interface Props {
  params: Promise<{ id: string }>;
}

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  try {
    const supabase = await createClient();
    const { data } = await supabase.from("videos").select("*").eq("id", id).single();
    if (!data) return { title: "Video Not Found" };
    const canonicalUrl = `${SITE_URL}/videos/${id}`;
    const tags: string[] = Array.isArray(data.tags) ? data.tags : [];
    return {
      title: `${data.title} | AutomateQA Videos`,
      description: data.description,
      keywords: [...tags, data.category, "QA automation video", "software testing tutorial", "AutomateQA"],
      alternates: { canonical: canonicalUrl },
      openGraph: {
        type: "video.other",
        url: canonicalUrl,
        title: data.title,
        description: data.description,
        images: data.thumbnail
          ? [{ url: data.thumbnail, width: 1280, height: 720, alt: data.title }]
          : [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
      },
      twitter: {
        card: "summary_large_image",
        title: data.title,
        description: data.description,
        images: data.thumbnail ? [data.thumbnail] : ["/og-image.png"],
      },
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

  let relatedVideos: Video[] = [];
  const { data: sameCat } = await supabase
    .from("videos").select("*").eq("published", true).eq("category", video.category).neq("id", id).limit(4);
  if (sameCat && sameCat.length > 0) {
    relatedVideos = sameCat;
  } else {
    const { data: any } = await supabase
      .from("videos").select("*").eq("published", true).neq("id", id).order("created_at", { ascending: false }).limit(4);
    relatedVideos = any ?? [];
  }

  const canonicalUrl = `${SITE_URL}/videos/${id}`;
  const tags: string[] = Array.isArray(video.tags) ? video.tags : [];
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "VideoObject",
    name: video.title,
    description: video.description,
    thumbnailUrl: video.thumbnail || `${SITE_URL}/og-image.png`,
    uploadDate: video.created_at,
    embedUrl: `https://www.youtube.com/embed/${video.youtube_id}`,
    url: canonicalUrl,
    keywords: tags.join(", "),
    publisher: { "@type": "Organization", name: "AutomateQA", url: SITE_URL },
  };

  return (
    <div className="min-h-screen pt-20 pb-16 bg-[#0B0B0B]">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Back */}
        <div className="mb-8">
          <Link
            href="/videos"
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 text-sm font-medium transition-all group"
          >
            <ArrowLeft size={14} className="group-hover:-translate-x-0.5 transition-transform" />
            Back to Videos
          </Link>
        </div>

        <div className="flex flex-col lg:flex-row gap-8">
          {/* ── Main column ── */}
          <div className="flex-1 min-w-0">

            {/* YouTube embed — premium frame */}
            <div className="relative rounded-2xl overflow-hidden bg-black shadow-[0_8px_48px_rgba(0,0,0,0.8)] ring-1 ring-white/[0.07] mb-6">
              {/* Glow border effect */}
              <div className="absolute inset-0 rounded-2xl ring-1 ring-inset ring-white/5 pointer-events-none z-10" />
              <div className="aspect-video">
                <iframe
                  src={`https://www.youtube.com/embed/${video.youtube_id}?rel=0&modestbranding=1&color=white`}
                  title={video.title}
                  className="w-full h-full"
                  frameBorder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                  allowFullScreen
                />
              </div>
            </div>

            {/* Video info card */}
            <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] p-6 sm:p-8">
              {/* Category + watch on YT */}
              <div className="flex flex-wrap items-center justify-between gap-4 mb-5">
                <span className={`category-badge border ${CATEGORY_COLORS[video.category] || ""}`}>
                  {video.category}
                </span>
                {video.youtube_url && (
                  <a
                    href={video.youtube_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-red-500/20 bg-red-500/[0.06] text-red-400 hover:bg-red-500/10 hover:border-red-500/30 text-xs font-semibold transition-all"
                  >
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                    </svg>
                    Watch on YouTube
                  </a>
                )}
              </div>

              {/* Title */}
              <h1 className="text-2xl sm:text-3xl font-black text-white leading-tight mb-4 tracking-tight">
                {video.title}
              </h1>

              {/* Date */}
              <div className="flex items-center gap-2 text-[#6B7280] text-sm mb-5">
                <Clock size={13} className="text-[#4B5563]" />
                {formatDate(video.created_at)}
              </div>

              {/* Description */}
              {video.description && (
                <p className="text-[#9CA3AF] leading-relaxed mb-6 text-[0.95rem]">
                  {video.description}
                </p>
              )}

              {/* Tags */}
              {tags.length > 0 && (
                <div className="flex flex-wrap items-center gap-2 pt-5 border-t border-white/[0.07]">
                  <Tag size={13} className="text-[#4B5563]" />
                  {tags.map((tag) => (
                    <span key={tag} className="px-3 py-1 text-xs rounded-lg border border-white/8 bg-white/[0.03] text-[#9CA3AF] font-medium">
                      {tag}
                    </span>
                  ))}
                </div>
              )}

              {/* Likes + Share + Comments */}
              <VideoInteractions
                videoId={video.id}
                initialLikes={video.likes_count || 0}
                title={video.title}
              />
            </div>
          </div>

          {/* ── Related sidebar ── */}
          <div className="w-full lg:w-80 xl:w-96 flex-shrink-0">
            <div className="lg:sticky lg:top-24">
              <div className="flex items-center gap-3 mb-4">
                <p className="text-xs text-[#4B5563] font-bold uppercase tracking-widest">Up Next</p>
                <div className="flex-1 h-px bg-white/[0.06]" />
              </div>

              {relatedVideos.length === 0 ? (
                <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] p-6 text-center">
                  <p className="text-[#4B5563] text-sm">No related videos yet</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {relatedVideos.map((v) => {
                    const thumb = v.thumbnail || getYouTubeThumbnail(v.youtube_id);
                    return (
                      <Link key={v.id} href={`/videos/${v.id}`} className="group block">
                        <div className="flex gap-3 rounded-xl border border-white/8 bg-[#0E0E0E] p-3 hover:border-[#00FF88]/20 hover:bg-[#00FF88]/[0.02] hover:shadow-[0_0_20px_rgba(0,255,136,0.05)] transition-all duration-200">
                          {/* Thumbnail */}
                          <div className="relative w-28 aspect-video rounded-lg overflow-hidden flex-shrink-0">
                            <img
                              src={thumb}
                              alt={v.title}
                              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                            />
                            <div className="absolute inset-0 bg-black/30 flex items-center justify-center">
                              <div className="w-7 h-7 rounded-full bg-black/60 border border-white/20 flex items-center justify-center group-hover:bg-[#00FF88] group-hover:border-[#00FF88] transition-all duration-200">
                                <Play size={11} className="text-white group-hover:text-black ml-0.5 transition-colors" fill="currentColor" />
                              </div>
                            </div>
                          </div>
                          {/* Info */}
                          <div className="flex-1 min-w-0 py-0.5">
                            <p className="text-sm font-semibold text-white leading-snug line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-1.5">
                              {v.title}
                            </p>
                            <span className={`category-badge border text-[10px] ${CATEGORY_COLORS[v.category] || ""}`}>
                              {v.category}
                            </span>
                          </div>
                        </div>
                      </Link>
                    );
                  })}
                </div>
              )}

              {/* CTA */}
              <div className="mt-5 p-5 rounded-2xl border border-[#00FF88]/15 bg-gradient-to-br from-[#00FF88]/6 to-transparent">
                <p className="text-white font-bold text-sm mb-1">Want more tutorials?</p>
                <p className="text-[#6B7280] text-xs mb-4 leading-relaxed">Subscribe to our YouTube channel for weekly QA automation content.</p>
                <Link
                  href="/videos"
                  className="inline-flex items-center gap-2 text-xs text-[#00FF88] font-semibold hover:text-white transition-colors"
                >
                  Browse all videos →
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
