"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Search, Play, X, Loader2, Clock } from "lucide-react";
import Link from "next/link";
import { Video, VIDEO_CATEGORIES, CATEGORY_COLORS } from "@/types";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";
import { formatRelativeDate, getYouTubeThumbnail } from "@/lib/utils";

function VideoCard({ video, index }: { video: Video; index: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: (index % 6) * 0.08 }}
    >
      <Link href={`/videos/${video.id}`} className="group block">
        <div className="glass-card-hover overflow-hidden">
          {/* Thumbnail */}
          <div className="relative aspect-video overflow-hidden rounded-t-2xl">
            <img
              src={video.thumbnail || getYouTubeThumbnail(video.youtube_id)}
              alt={video.title}
              className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
              loading="lazy"
            />
            {/* Play overlay */}
            <div className="absolute inset-0 bg-black/50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
              <div className="w-14 h-14 rounded-full bg-[#00FF88] flex items-center justify-center shadow-neon">
                <Play size={22} className="text-black ml-1" />
              </div>
            </div>
            {/* Badge */}
            <div className="absolute top-3 left-3">
              <span className={`category-badge border ${CATEGORY_COLORS[video.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {video.category}
              </span>
            </div>
            {video.featured && (
              <div className="absolute top-3 right-3">
                <span className="category-badge border bg-[#00FF88]/20 text-[#00FF88] border-[#00FF88]/30">
                  Featured
                </span>
              </div>
            )}
          </div>

          {/* Info */}
          <div className="p-4">
            <h3 className="font-semibold text-white text-sm leading-snug line-clamp-2 group-hover:text-[#00FF88] transition-colors mb-2">
              {video.title}
            </h3>
            {video.description && (
              <p className="text-[#9CA3AF] text-xs leading-relaxed line-clamp-2 mb-3">
                {video.description}
              </p>
            )}
            <div className="flex items-center gap-2 text-xs text-[#9CA3AF]">
              <Clock size={11} />
              {formatRelativeDate(video.created_at)}
            </div>
            {video.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1 mt-3">
                {video.tags.slice(0, 3).map((tag) => (
                  <span key={tag} className="tag-chip text-[10px]">{tag}</span>
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
    <div className="glass-card overflow-hidden">
      <div className="aspect-video skeleton rounded-t-2xl" />
      <div className="p-4 space-y-2">
        <div className="skeleton h-4 w-3/4" />
        <div className="skeleton h-3 w-1/2" />
        <div className="flex gap-1 pt-1">
          <div className="skeleton h-4 w-14 rounded-full" />
          <div className="skeleton h-4 w-16 rounded-full" />
        </div>
      </div>
    </div>
  );
}

export default function VideoGrid() {
  const [videos, setVideos] = useState<Video[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");
  const supabase = createClient();

  useEffect(() => {
    const fetchVideos = async () => {
      setLoading(true);

      if (!isSupabaseConfigured()) {
        setLoading(false);
        return;
      }

      const data = await withTimeout(async () => {
        let query = supabase
          .from("videos")
          .select("*")
          .eq("published", true)
          .order("created_at", { ascending: false });

        if (selectedCategory !== "All") query = query.eq("category", selectedCategory);
        if (search) query = query.or(`title.ilike.%${search}%,description.ilike.%${search}%`);

        const { data } = await query;
        return data || [];
      }, [] as Video[], 3000);

      setVideos(data);
      setLoading(false);
    };
    fetchVideos();
  }, [search, selectedCategory]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setSearch(searchInput);
  };

  const featuredVideo = videos.find((v) => v.featured);
  const regularVideos = videos.filter((v) => !v.featured || selectedCategory !== "All" || search);

  return (
    <div>
      {/* Filters */}
      <div className="sticky top-16 z-30 bg-[#0B0B0B]/90 backdrop-blur-xl border-b border-white/5 py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row gap-4">
            <form onSubmit={handleSearch} className="flex-1 relative">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#9CA3AF]" />
              <input
                type="text"
                value={searchInput}
                onChange={(e) => setSearchInput(e.target.value)}
                placeholder="Search videos..."
                className="w-full pl-9 pr-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all"
              />
              {searchInput && (
                <button type="button" onClick={() => { setSearchInput(""); setSearch(""); }} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#9CA3AF] hover:text-white">
                  <X size={14} />
                </button>
              )}
            </form>
            <div className="flex gap-2 overflow-x-auto pb-1">
              <button onClick={() => setSelectedCategory("All")} className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all ${selectedCategory === "All" ? "bg-[#00FF88] text-black" : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"}`}>All</button>
              {VIDEO_CATEGORIES.map((cat) => (
                <button key={cat} onClick={() => setSelectedCategory(cat)} className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all whitespace-nowrap ${selectedCategory === cat ? "bg-[#00FF88] text-black" : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"}`}>{cat}</button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)}
          </div>
        ) : videos.length === 0 ? (
          <div className="text-center py-24">
            <div className="text-6xl mb-4">🎬</div>
            <h3 className="text-xl font-bold text-white mb-2">No videos found</h3>
            <p className="text-[#9CA3AF]">Try different search terms or browse all categories</p>
            {(search || selectedCategory !== "All") && (
              <button onClick={() => { setSearch(""); setSearchInput(""); setSelectedCategory("All"); }} className="btn-outline mt-6 inline-flex">Clear filters</button>
            )}
          </div>
        ) : (
          <AnimatePresence mode="wait">
            {/* Featured video hero */}
            {featuredVideo && !search && selectedCategory === "All" && (
              <motion.div key="featured" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
                <Link href={`/videos/${featuredVideo.id}`} className="group block">
                  <div className="glass-card overflow-hidden hover:border-[#00FF88]/20 transition-all duration-300">
                    <div className="flex flex-col lg:flex-row">
                      <div className="relative lg:w-2/3 aspect-video overflow-hidden">
                        <img
                          src={featuredVideo.thumbnail}
                          alt={featuredVideo.title}
                          className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                        />
                        <div className="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                          <div className="w-20 h-20 rounded-full bg-[#00FF88] flex items-center justify-center shadow-neon-lg">
                            <Play size={32} className="text-black ml-2" />
                          </div>
                        </div>
                        <div className="absolute top-4 left-4">
                          <span className="px-3 py-1.5 rounded-lg bg-[#00FF88]/20 border border-[#00FF88]/30 text-[#00FF88] text-xs font-bold">FEATURED</span>
                        </div>
                      </div>
                      <div className="lg:w-1/3 p-6 flex flex-col justify-center">
                        <span className={`category-badge border w-fit mb-3 ${CATEGORY_COLORS[featuredVideo.category] || ""}`}>{featuredVideo.category}</span>
                        <h2 className="text-xl font-bold text-white mb-3 group-hover:text-[#00FF88] transition-colors line-clamp-3">{featuredVideo.title}</h2>
                        <p className="text-[#9CA3AF] text-sm leading-relaxed line-clamp-3 mb-4">{featuredVideo.description}</p>
                        <div className="flex flex-wrap gap-1">
                          {featuredVideo.tags?.slice(0, 4).map((tag) => <span key={tag} className="tag-chip">{tag}</span>)}
                        </div>
                      </div>
                    </div>
                  </div>
                </Link>
              </motion.div>
            )}

            {/* Video grid */}
            <div key="grid" className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
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
