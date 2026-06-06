"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { Play, ArrowRight, Clock, Eye } from "lucide-react";
import { Video } from "@/types";
import { formatRelativeDate, getYouTubeThumbnail } from "@/lib/utils";
import { CATEGORY_COLORS } from "@/types";

interface FeaturedVideosProps {
  videos: Video[];
}

function VideoCard({ video, index }: { video: Video; index: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5, delay: index * 0.1 }}
    >
      <Link href={`/videos/${video.id}`} className="group block">
        <div className="glass-card-hover overflow-hidden">
          {/* Thumbnail */}
          <div className="relative aspect-video overflow-hidden rounded-t-2xl">
            <img
              src={video.thumbnail || getYouTubeThumbnail(video.youtube_id)}
              alt={video.title}
              className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
            />
            {/* Play overlay */}
            <div className="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
              <div className="w-14 h-14 rounded-full bg-[#00FF88] flex items-center justify-center shadow-neon transform scale-75 group-hover:scale-100 transition-transform duration-300">
                <Play size={24} className="text-black ml-1" />
              </div>
            </div>
            {/* Category badge */}
            <div className="absolute top-3 left-3">
              <span className={`category-badge border ${CATEGORY_COLORS[video.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {video.category}
              </span>
            </div>
          </div>

          {/* Content */}
          <div className="p-4">
            <h3 className="font-semibold text-white text-sm leading-snug line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-3">
              {video.title}
            </h3>
            <div className="flex items-center gap-3 text-xs text-[#9CA3AF]">
              <span className="flex items-center gap-1">
                <Clock size={11} />
                {formatRelativeDate(video.created_at)}
              </span>
            </div>
            {video.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1.5 mt-3">
                {video.tags.slice(0, 3).map((tag) => (
                  <span key={tag} className="tag-chip">{tag}</span>
                ))}
              </div>
            )}
          </div>
        </div>
      </Link>
    </motion.div>
  );
}

// Skeleton loader
function VideoCardSkeleton() {
  return (
    <div className="glass-card overflow-hidden">
      <div className="aspect-video skeleton rounded-t-2xl" />
      <div className="p-4 space-y-3">
        <div className="skeleton h-4 w-3/4" />
        <div className="skeleton h-4 w-1/2" />
        <div className="flex gap-2">
          <div className="skeleton h-5 w-16 rounded-full" />
          <div className="skeleton h-5 w-20 rounded-full" />
        </div>
      </div>
    </div>
  );
}

export default function FeaturedVideos({ videos }: FeaturedVideosProps) {
  if (!videos || videos.length === 0) {
    return null;
  }

  return (
    <section className="py-20 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-12"
        >
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-500/10 border border-red-500/20 text-red-400 text-xs font-semibold mb-3">
              <Play size={10} />
              LATEST VIDEOS
            </div>
            <h2 className="text-3xl sm:text-4xl font-black text-white">
              Watch & Learn
            </h2>
            <p className="text-[#9CA3AF] mt-2">QA tutorials, meme compilations, and automation deep-dives</p>
          </div>
          <Link
            href="/videos"
            className="flex items-center gap-2 text-[#00FF88] text-sm font-semibold hover:gap-3 transition-all group"
          >
            View all videos
            <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </motion.div>

        {/* Video grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {videos.map((video, i) => (
            <VideoCard key={video.id} video={video} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}

export { VideoCardSkeleton };
