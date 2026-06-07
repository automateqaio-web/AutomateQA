"use client";

import { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Search, Play, X, Clock } from "lucide-react";
import Link from "next/link";
import { Video, VIDEO_CATEGORIES, CATEGORY_COLORS } from "@/types";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";
import { formatRelativeDate, getYouTubeThumbnail } from "@/lib/utils";

function VideoCard({ video, index }: { video: Video; index: number }) {
  const thumb = video.thumbnail || getYouTubeThumbnail(video.youtube_id);
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: (index % 6) * 0.07 }}
    >
      <Link href={`/videos/${video.id}`} className="group block h-full">
        <div className="h-full rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden hover:border-[#00FF88]/20 hover:shadow-[0_0_32px_rgba(0,255,136,0.07)] transition-all duration-300">
          {/* Thumbnail */}
          <div className="relative aspect-video overflow-hidden">
            <img
              src={thumb}
              alt={video.title}
              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
              loading="lazy"
            />
            {/* Dark overlay + play button */}
            <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors duration-300" />
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="w-12 h-12 rounded-full bg-black/60 border border-white/20 flex items-center justify-center group-hover:bg-[#00FF88] group-hover:border-[#00FF88] group-hover:shadow-[0_0_20px_rgba(0,255,136,0.4)] transition-all duration-300">
                <Play size={18} className="text-white group-hover:text-black ml-0.5 transition-colors duration-300" fill="currentColor" />
              </div>
            </div>
            {/* Category badge */}
            <div className="absolute top-3 left-3">
              <span className={`category-badge border text-[10px] ${CATEGORY_COLORS[video.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {video.category}
              </span>
            </div>
            {video.featured && (
              <div className="absolute top-3 right-3">
                <span className="px-2 py-1 rounded-md bg-[#00FF88]/20 border border-[#00FF88]/30 text-[#00FF88] text-[10px] font-bold tracking-wide">
                  FEATURED
                </span>
              </div>
            )}
          </div>

          {/* Info */}
          <div className="p-4">
            <h3 className="font-bold text-white text-sm leading-snug line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-2">
              {video.title}
            </h3>
            {video.description && (
              <p className="text-[#6B7280] text-xs leading-relaxed line-clamp-2 mb-3">
                {video.description}
              </p>
            )}
            <div className="flex items-center justify-between text-xs text-[#4B5563]">
              <span className="flex items-center gap-1.5">
                <Clock size={10} />
                {formatRelativeDate(video.created_at)}
              </span>
              <span className="text-[#00FF88]/50 group-hover:text-[#00FF88] transition-colors font-semibold">
                Watch →
              </span>
            </div>
            {video.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1.5 mt-3 pt-3 border-t border-white/5">
                {video.tags.slice(0, 3).map((tag) => (
                  <span key={tag} className="px-2 py-0.5 text-[10px] rounded-md border border-white/8 bg-white/[0.03] text-[#6B7280]">
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
        </div>
      </Link>
    </motion.div>
  );
}

function SkeletonCard() {
  return (
    <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden">
      <div className="aspect-video skeleton" />
      <div className="p-4 space-y-2.5">
        <div className="skeleton h-4 w-3/4 rounded" />
        <div className="skeleton h-3 w-full rounded" />
        <div className="skeleton h-3 w-1/2 rounded" />
      </div>
    </div>
  );
}

export default function VideoGrid({ initialVideos = [] }: { initialVideos?: Video[] }) {
  const [videos, setVideos] = useState<Video[]>(initialVideos);
  const [loading, setLoading] = useState(initialVideos.length === 0);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");
  const supabase = createClient();
  const skipFirstFetch = useRef(initialVideos.length > 0);

  useEffect(() => {
    const fetchVideos = async () => {
      setLoading(true);
      if (!isSupabaseConfigured()) { setLoading(false); return; }
      const data = await withTimeout(async () => {
        let query = supabase.from("videos").select("*").eq("published", true).order("created_at", { ascending: false });
        if (selectedCategory !== "All") query = query.eq("category", selectedCategory);
        if (search) query = query.or(`title.ilike.%${search}%,description.ilike.%${search}%`);
        const { data } = await query;
        return data || [];
      }, [] as Video[], 3000);
      setVideos(data);
      setLoading(false);
    };

    if (skipFirstFetch.current) {
      skipFirstFetch.current = false;
      return;
    }
    fetchVideos();
  }, [search, selectedCategory]);

  const handleSearch = (e: React.FormEvent) => { e.preventDefault(); setSearch(searchInput); };
  const featuredVideo = !search && selectedCategory === "All" ? videos.find((v) => v.featured) : null;
  const regularVideos = featuredVideo ? videos.filter((v) => v.id !== featuredVideo.id) : videos;

  return (
    <div>
      {/* ── Filter bar ── */}
      <div className="sticky top-16 z-30 bg-[#0B0B0B]/90 backdrop-blur-xl border-b border-white/[0.06] py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row gap-3">
            <form onSubmit={handleSearch} className="flex-1 relative max-w-sm">
              <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#4B5563]" />
              <input
                type="text"
                value={searchInput}
                onChange={(e) => setSearchInput(e.target.value)}
                placeholder="Search videos..."
                className="w-full pl-9 pr-9 py-2.5 rounded-xl bg-[#111] border border-white/8 text-white placeholder-[#374151] text-sm focus:outline-none focus:border-[#00FF88]/30 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
              />
              {searchInput && (
                <button type="button" onClick={() => { setSearchInput(""); setSearch(""); }} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#4B5563] hover:text-white transition-colors">
                  <X size={13} />
                </button>
              )}
            </form>
            <div className="flex gap-2 overflow-x-auto pb-0.5 scrollbar-hide">
              <button
                onClick={() => setSelectedCategory("All")}
                className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all ${selectedCategory === "All" ? "bg-[#00FF88] text-black shadow-[0_0_16px_rgba(0,255,136,0.3)]" : "bg-[#111] text-[#6B7280] hover:text-white border border-white/8"}`}
              >
                All
              </button>
              {VIDEO_CATEGORIES.map((cat) => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all whitespace-nowrap ${selectedCategory === cat ? "bg-[#00FF88] text-black shadow-[0_0_16px_rgba(0,255,136,0.3)]" : "bg-[#111] text-[#6B7280] hover:text-white border border-white/8"}`}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)}
          </div>
        ) : videos.length === 0 ? (
          <div className="text-center py-24">
            <div className="text-5xl mb-4">🎬</div>
            <h3 className="text-xl font-bold text-white mb-2">No videos found</h3>
            <p className="text-[#6B7280] text-sm">Try different search terms or browse all categories</p>
            {(search || selectedCategory !== "All") && (
              <button onClick={() => { setSearch(""); setSearchInput(""); setSelectedCategory("All"); }} className="mt-6 px-5 py-2.5 rounded-xl border border-white/10 text-[#9CA3AF] hover:text-white hover:border-white/20 text-sm transition-all inline-flex">
                Clear filters
              </button>
            )}
          </div>
        ) : (
          <AnimatePresence mode="wait">
            {/* Featured hero */}
            {featuredVideo && (
              <motion.div key="featured" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
                <Link href={`/videos/${featuredVideo.id}`} className="group block">
                  <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden hover:border-[#00FF88]/20 hover:shadow-[0_0_48px_rgba(0,255,136,0.08)] transition-all duration-300">
                    <div className="flex flex-col lg:flex-row">
                      {/* Thumbnail */}
                      <div className="relative lg:w-3/5 aspect-video overflow-hidden lg:rounded-l-2xl">
                        <img
                          src={featuredVideo.thumbnail || getYouTubeThumbnail(featuredVideo.youtube_id)}
                          alt={featuredVideo.title}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                        />
                        <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
                        <div className="absolute inset-0 flex items-center justify-center">
                          <div className="w-16 h-16 rounded-full bg-black/60 border-2 border-white/20 flex items-center justify-center group-hover:bg-[#00FF88] group-hover:border-[#00FF88] group-hover:shadow-[0_0_32px_rgba(0,255,136,0.5)] transition-all duration-300">
                            <Play size={26} className="text-white group-hover:text-black ml-1 transition-colors" fill="currentColor" />
                          </div>
                        </div>
                        <div className="absolute top-4 left-4 flex gap-2">
                          <span className="px-3 py-1.5 rounded-lg bg-[#00FF88]/20 border border-[#00FF88]/30 text-[#00FF88] text-xs font-bold tracking-wide">FEATURED</span>
                          <span className={`category-badge border ${CATEGORY_COLORS[featuredVideo.category] || ""}`}>{featuredVideo.category}</span>
                        </div>
                      </div>
                      {/* Info */}
                      <div className="lg:w-2/5 p-7 flex flex-col justify-center">
                        <h2 className="text-xl sm:text-2xl font-black text-white mb-3 group-hover:text-[#00FF88] transition-colors leading-snug line-clamp-3">
                          {featuredVideo.title}
                        </h2>
                        <p className="text-[#6B7280] text-sm leading-relaxed line-clamp-3 mb-5">
                          {featuredVideo.description}
                        </p>
                        <div className="flex flex-wrap gap-1.5">
                          {featuredVideo.tags?.slice(0, 4).map((tag) => (
                            <span key={tag} className="px-2.5 py-1 text-xs rounded-lg border border-white/8 bg-white/[0.03] text-[#6B7280]">{tag}</span>
                          ))}
                        </div>
                      </div>
                    </div>
                  </div>
                </Link>
              </motion.div>
            )}

            {/* Grid */}
            <div key="grid" className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {regularVideos.map((video, i) => (
                <VideoCard key={video.id} video={video} index={i} />
              ))}
            </div>
          </AnimatePresence>
        )}
      </div>
    </div>
  );
}
