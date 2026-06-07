"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import Link from "next/link";
import { Search, Filter, Share2, X, Loader2, ImageOff } from "lucide-react";
import { Meme, MEME_CATEGORIES, CATEGORY_COLORS } from "@/types";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";

const PAGE_SIZE = 12;

function MemeCard({ meme, index }: { meme: Meme; index: number }) {
  const [shared, setShared] = useState(false);

  const handleShare = async (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    const url = `${window.location.origin}/memes/${meme.id}`;
    if (navigator.share) {
      await navigator.share({ title: meme.title, text: meme.caption, url });
    } else {
      await navigator.clipboard.writeText(url);
      setShared(true);
      setTimeout(() => setShared(false), 2000);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0 }}
      transition={{ delay: index * 0.04 }}
    >
      <Link href={`/memes/${meme.id}`} className="group block h-full">
        <div className="glass-card overflow-hidden hover:border-[#00FF88]/20 hover:shadow-[0_0_20px_rgba(0,255,136,0.08)] transition-all duration-300 cursor-pointer flex flex-col h-full">
          {/* Fixed aspect ratio image */}
          <div className="relative aspect-[4/3] overflow-hidden flex-shrink-0">
            {meme.image_url ? (
              <>
                <img
                  src={meme.image_url}
                  alt={meme.title}
                  className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                  loading="lazy"
                />
                {/* Hover overlay */}
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                  <button
                    onClick={handleShare}
                    className="absolute top-3 right-3 w-8 h-8 rounded-lg bg-black/60 backdrop-blur-sm flex items-center justify-center text-white hover:text-[#00FF88] transition-colors"
                  >
                    {shared ? "✓" : <Share2 size={13} />}
                  </button>
                </div>
              </>
            ) : (
              <div className="w-full h-full bg-[#1A1A1A] flex items-center justify-center">
                <ImageOff size={32} className="text-[#2A2A2A]" />
              </div>
            )}
            {/* Category badge */}
            <div className="absolute bottom-3 left-3">
              <span className={`category-badge border ${CATEGORY_COLORS[meme.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {meme.category}
              </span>
            </div>
          </div>

          {/* Caption + Tags — fixed height footer */}
          <div className="p-3 flex flex-col gap-2 flex-1">
            {meme.caption && (
              <p className="text-sm text-[#D1D5DB] leading-relaxed line-clamp-2 flex-1">
                {meme.caption}
              </p>
            )}
            {meme.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1">
                {meme.tags.slice(0, 3).map((tag) => (
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
      <div className="aspect-[4/3] skeleton" />
      <div className="p-3 space-y-2">
        <div className="skeleton h-4 w-3/4 rounded" />
        <div className="flex gap-1">
          <div className="skeleton h-4 w-14 rounded-full" />
          <div className="skeleton h-4 w-18 rounded-full" />
        </div>
      </div>
    </div>
  );
}

export default function MemeFeed({ initialMemes = [] }: { initialMemes?: Meme[] }) {
  const [memes, setMemes] = useState<Meme[]>(initialMemes);
  const [loading, setLoading] = useState(initialMemes.length === 0);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(initialMemes.length === PAGE_SIZE);
  const [page, setPage] = useState(initialMemes.length === PAGE_SIZE ? 1 : 0);
  const [search, setSearch] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("All");
  const [searchInput, setSearchInput] = useState("");
  const loaderRef = useRef<HTMLDivElement>(null);
  const supabase = createClient();
  const skipFirstFetch = useRef(initialMemes.length > 0);

  const fetchMemes = useCallback(async (reset = false) => {
    const currentPage = reset ? 0 : page;
    if (!reset && loadingMore) return;

    if (reset) setLoading(true);
    else setLoadingMore(true);

    // Skip entirely if Supabase isn't configured
    if (!isSupabaseConfigured()) {
      setLoading(false);
      setLoadingMore(false);
      return;
    }

    const newMemes = await withTimeout(async () => {
      let query = supabase
        .from("memes")
        .select("*")
        .eq("published", true)
        .order("created_at", { ascending: false })
        .range(currentPage * PAGE_SIZE, (currentPage + 1) * PAGE_SIZE - 1);

      if (selectedCategory !== "All") query = query.eq("category", selectedCategory);
      if (search) query = query.or(`title.ilike.%${search}%,caption.ilike.%${search}%`);

      const { data, error } = await query;
      if (error) throw error;
      return data || [];
    }, [] as Meme[], 3000);

    if (reset) {
      setMemes(newMemes);
      setPage(1);
    } else {
      setMemes((prev) => [...prev, ...newMemes]);
      setPage((p) => p + 1);
    }
    setHasMore(newMemes.length === PAGE_SIZE);
    setLoading(false);
    setLoadingMore(false);
  }, [page, search, selectedCategory, loadingMore]);

  useEffect(() => {
    if (skipFirstFetch.current) {
      skipFirstFetch.current = false;
      return;
    }
    fetchMemes(true);
  }, [search, selectedCategory]);

  // Infinite scroll observer
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasMore && !loadingMore && !loading) {
          fetchMemes();
        }
      },
      { threshold: 0.1 }
    );
    if (loaderRef.current) observer.observe(loaderRef.current);
    return () => observer.disconnect();
  }, [hasMore, loadingMore, loading, fetchMemes]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setSearch(searchInput);
  };

  return (
    <div>
      {/* Filters bar */}
      <div className="sticky top-16 z-30 bg-[#0B0B0B]/90 backdrop-blur-xl border-b border-white/5 py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row gap-4">
            {/* Search */}
            <form onSubmit={handleSearch} className="flex-1 relative">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#9CA3AF]" />
              <input
                type="text"
                value={searchInput}
                onChange={(e) => setSearchInput(e.target.value)}
                placeholder="Search memes..."
                className="w-full pl-9 pr-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all"
              />
              {searchInput && (
                <button
                  type="button"
                  onClick={() => { setSearchInput(""); setSearch(""); }}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-[#9CA3AF] hover:text-white"
                >
                  <X size={14} />
                </button>
              )}
            </form>

            {/* Category filter - horizontal scroll */}
            <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-none">
              <button
                onClick={() => setSelectedCategory("All")}
                className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all ${
                  selectedCategory === "All"
                    ? "bg-[#00FF88] text-black"
                    : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"
                }`}
              >
                All
              </button>
              {MEME_CATEGORIES.map((cat) => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all whitespace-nowrap ${
                    selectedCategory === cat
                      ? "bg-[#00FF88] text-black"
                      : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"
                  }`}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {Array.from({ length: 9 }).map((_, i) => (
              <SkeletonCard key={i} />
            ))}
          </div>
        ) : memes.length === 0 ? (
          <div className="text-center py-24">
            <div className="text-6xl mb-4">🤔</div>
            <h3 className="text-xl font-bold text-white mb-2">No memes found</h3>
            <p className="text-[#9CA3AF]">
              {search || selectedCategory !== "All"
                ? "Try different search terms or categories"
                : "Be the first to add some QA chaos here!"}
            </p>
            {(search || selectedCategory !== "All") && (
              <button
                onClick={() => { setSearch(""); setSearchInput(""); setSelectedCategory("All"); }}
                className="btn-outline mt-6 inline-flex"
              >
                Clear filters
              </button>
            )}
          </div>
        ) : (
          <AnimatePresence mode="wait">
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {memes.map((meme, i) => (
                <MemeCard key={meme.id} meme={meme} index={i} />
              ))}
            </div>
          </AnimatePresence>
        )}

        {/* Infinite scroll loader — only render when there are memes to paginate */}
        {memes.length > 0 && (
          <div ref={loaderRef} className="py-8 flex justify-center">
            {loadingMore && (
              <div className="flex items-center gap-2 text-[#9CA3AF]">
                <Loader2 size={16} className="animate-spin" />
                <span className="text-sm">Loading more memes...</span>
              </div>
            )}
            {!hasMore && !loadingMore && (
              <p className="text-[#9CA3AF] text-sm">You&apos;ve seen all the memes! 🎉</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
