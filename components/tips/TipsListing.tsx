"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import Link from "next/link";
import { Search, X, Loader2, Lightbulb, Clock, Eye, Star } from "lucide-react";
import { AutomationTip, TIP_CATEGORIES, DIFFICULTIES, CATEGORY_COLORS, DIFFICULTY_COLORS, Difficulty } from "@/types";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";
import { formatRelativeDate } from "@/lib/utils";

const PAGE_SIZE = 12;

function TipCard({ item, index }: { item: AutomationTip; index: number }) {
  return (
    <motion.article
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: (index % 6) * 0.07 }}
    >
      <Link href={`/automation-tips/${item.slug}`} className="group block h-full">
        <div className="glass-card-hover h-full flex flex-col overflow-hidden">
          {item.cover_image ? (
            <div className="relative aspect-video overflow-hidden rounded-t-2xl">
              <img
                src={item.cover_image}
                alt={item.title}
                className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                loading="lazy"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
              <div className="absolute bottom-3 left-3 flex gap-2">
                <span className={`category-badge border ${CATEGORY_COLORS[item.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                  {item.category}
                </span>
                <span className={`category-badge border ${DIFFICULTY_COLORS[item.difficulty as Difficulty]}`}>
                  {item.difficulty}
                </span>
              </div>
              {item.featured && (
                <div className="absolute top-3 right-3">
                  <span className="category-badge border bg-yellow-500/20 text-yellow-400 border-yellow-500/30 flex items-center gap-1">
                    <Star size={9} fill="currentColor" /> Trending
                  </span>
                </div>
              )}
            </div>
          ) : (
            <div className="aspect-video bg-gradient-to-br from-[#1A1A1A] to-[#111] rounded-t-2xl flex items-center justify-center relative">
              <Lightbulb size={40} className="text-yellow-500/30" />
              <div className="absolute bottom-3 left-3 flex gap-2">
                <span className={`category-badge border ${CATEGORY_COLORS[item.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                  {item.category}
                </span>
                <span className={`category-badge border ${DIFFICULTY_COLORS[item.difficulty as Difficulty]}`}>
                  {item.difficulty}
                </span>
              </div>
            </div>
          )}

          <div className="p-5 flex flex-col flex-1">
            <h3 className="font-bold text-white text-base leading-snug line-clamp-2 mb-2 group-hover:text-[#00FF88] transition-colors">
              {item.title}
            </h3>
            {item.excerpt && (
              <p className="text-[#9CA3AF] text-sm leading-relaxed line-clamp-2 flex-1 mb-3">
                {item.excerpt}
              </p>
            )}
            <div className="flex items-center justify-between text-xs text-[#9CA3AF] pt-3 border-t border-white/5 mt-auto">
              <span className="flex items-center gap-1.5"><Clock size={11} />{item.read_time} min</span>
              <span className="flex items-center gap-1.5"><Eye size={11} />{item.views.toLocaleString()}</span>
              <span>{formatRelativeDate(item.created_at)}</span>
            </div>
            {item.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1 mt-2">
                {item.tags.slice(0, 3).map((tag) => (
                  <span key={tag} className="tag-chip text-[10px]">{tag}</span>
                ))}
              </div>
            )}
          </div>
        </div>
      </Link>
    </motion.article>
  );
}

function SkeletonCard() {
  return (
    <div className="glass-card overflow-hidden">
      <div className="aspect-video skeleton rounded-t-2xl" />
      <div className="p-5 space-y-3">
        <div className="skeleton h-5 w-3/4" />
        <div className="skeleton h-4 w-full" />
        <div className="skeleton h-4 w-2/3" />
      </div>
    </div>
  );
}

export default function TipsListing() {
  const [items, setItems] = useState<AutomationTip[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(false);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [selectedDifficulty, setSelectedDifficulty] = useState("All");
  const loaderRef = useRef<HTMLDivElement>(null);
  const supabase = createClient();

  const fetchItems = useCallback(async (reset = false) => {
    const currentPage = reset ? 0 : page;
    if (!reset && loadingMore) return;
    if (reset) setLoading(true);
    else setLoadingMore(true);

    if (!isSupabaseConfigured()) {
      setLoading(false);
      setLoadingMore(false);
      return;
    }

    const newItems = await withTimeout(async () => {
      let query = supabase
        .from("automation_tips")
        .select("*")
        .eq("published", true)
        .order("featured", { ascending: false })
        .order("created_at", { ascending: false })
        .range(currentPage * PAGE_SIZE, (currentPage + 1) * PAGE_SIZE - 1);

      if (selectedCategory !== "All") query = query.eq("category", selectedCategory);
      if (selectedDifficulty !== "All") query = query.eq("difficulty", selectedDifficulty);
      if (search) query = query.or(`title.ilike.%${search}%,excerpt.ilike.%${search}%`);

      const { data, error } = await query;
      if (error) throw error;
      return data || [];
    }, [] as AutomationTip[], 3000);

    if (reset) {
      setItems(newItems);
      setPage(1);
    } else {
      setItems((prev) => [...prev, ...newItems]);
      setPage((p) => p + 1);
    }
    setHasMore(newItems.length === PAGE_SIZE);
    setLoading(false);
    setLoadingMore(false);
  }, [page, search, selectedCategory, selectedDifficulty, loadingMore]);

  useEffect(() => { fetchItems(true); }, [search, selectedCategory, selectedDifficulty]);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasMore && !loadingMore && !loading) fetchItems();
      },
      { threshold: 0.1 }
    );
    if (loaderRef.current) observer.observe(loaderRef.current);
    return () => observer.disconnect();
  }, [hasMore, loadingMore, loading, fetchItems]);

  const handleSearch = (e: React.FormEvent) => { e.preventDefault(); setSearch(searchInput); };

  return (
    <div>
      {/* Filters */}
      <div className="sticky top-16 z-30 bg-[#0B0B0B]/90 backdrop-blur-xl border-b border-white/5 py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-3">
          <div className="flex flex-col sm:flex-row gap-3">
            <form onSubmit={handleSearch} className="flex-1 relative">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#9CA3AF]" />
              <input
                type="text"
                value={searchInput}
                onChange={(e) => setSearchInput(e.target.value)}
                placeholder="Search tips & tricks..."
                className="w-full pl-9 pr-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all"
              />
              {searchInput && (
                <button type="button" onClick={() => { setSearchInput(""); setSearch(""); }} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#9CA3AF] hover:text-white">
                  <X size={14} />
                </button>
              )}
            </form>
            <div className="flex gap-2">
              {(["All", ...DIFFICULTIES] as string[]).map((d) => (
                <button
                  key={d}
                  onClick={() => setSelectedDifficulty(d)}
                  className={`flex-shrink-0 px-3 py-2 rounded-xl text-xs font-semibold transition-all ${
                    selectedDifficulty === d
                      ? "bg-[#00FF88] text-black"
                      : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"
                  }`}
                >
                  {d}
                </button>
              ))}
            </div>
          </div>
          <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-none">
            <button
              onClick={() => setSelectedCategory("All")}
              className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all ${selectedCategory === "All" ? "bg-[#00FF88] text-black" : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"}`}
            >All</button>
            {TIP_CATEGORIES.map((cat) => (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all whitespace-nowrap ${selectedCategory === cat ? "bg-[#00FF88] text-black" : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"}`}
              >{cat}</button>
            ))}
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)}
          </div>
        ) : items.length === 0 ? (
          <div className="text-center py-24">
            <div className="text-6xl mb-4">💡</div>
            <h3 className="text-xl font-bold text-white mb-2">No tips found</h3>
            <p className="text-[#9CA3AF]">
              {search || selectedCategory !== "All" || selectedDifficulty !== "All"
                ? "Try different filters or search terms"
                : "Tips coming soon!"}
            </p>
            {(search || selectedCategory !== "All" || selectedDifficulty !== "All") && (
              <button
                onClick={() => { setSearch(""); setSearchInput(""); setSelectedCategory("All"); setSelectedDifficulty("All"); }}
                className="btn-outline mt-6 inline-flex"
              >
                Clear all filters
              </button>
            )}
          </div>
        ) : (
          <AnimatePresence mode="wait">
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
              {items.map((item, i) => <TipCard key={item.id} item={item} index={i} />)}
            </div>
          </AnimatePresence>
        )}

        {items.length > 0 && (
          <div ref={loaderRef} className="py-8 flex justify-center">
            {loadingMore && (
              <div className="flex items-center gap-2 text-[#9CA3AF]">
                <Loader2 size={16} className="animate-spin" />
                <span className="text-sm">Loading more tips...</span>
              </div>
            )}
            {!hasMore && !loadingMore && (
              <p className="text-[#9CA3AF] text-sm">All tips loaded ⚡</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
