"use client";

import { useState, useEffect, useRef, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import Link from "next/link";
import { Search, Clock, Calendar, X } from "lucide-react";
import { Blog, BLOG_CATEGORIES, CATEGORY_COLORS } from "@/types";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";
import { formatDate } from "@/lib/utils";

function BlogCard({ blog, index }: { blog: Blog; index: number }) {
  return (
    <motion.article
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: (index % 6) * 0.08 }}
    >
      <Link href={`/blog/${blog.slug}`} className="group block h-full">
        <div className="glass-card-hover h-full flex flex-col overflow-hidden">
          {blog.cover_image && (
            <div className="relative aspect-[16/9] overflow-hidden rounded-t-2xl">
              <img
                src={blog.cover_image}
                alt={blog.title}
                className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                loading="lazy"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />
              <div className="absolute bottom-3 left-3">
                <span className={`category-badge border ${CATEGORY_COLORS[blog.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                  {blog.category}
                </span>
              </div>
            </div>
          )}
          <div className="p-5 flex flex-col flex-1">
            {!blog.cover_image && (
              <span className={`category-badge border w-fit mb-3 ${CATEGORY_COLORS[blog.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {blog.category}
              </span>
            )}
            <h2 className="font-bold text-white text-lg leading-snug line-clamp-2 mb-2 group-hover:text-[#00FF88] transition-colors">
              {blog.title}
            </h2>
            {blog.excerpt && (
              <p className="text-[#9CA3AF] text-sm leading-relaxed line-clamp-3 flex-1 mb-4">
                {blog.excerpt}
              </p>
            )}
            <div className="flex items-center justify-between text-xs text-[#9CA3AF] pt-4 border-t border-white/5 mt-auto">
              <span className="flex items-center gap-1.5">
                <Calendar size={11} />
                {formatDate(blog.created_at)}
              </span>
              <span className="flex items-center gap-1.5">
                <Clock size={11} />
                {blog.read_time} min read
              </span>
            </div>
          </div>
        </div>
      </Link>
    </motion.article>
  );
}

function SkeletonCard() {
  return (
    <div className="glass-card overflow-hidden">
      <div className="aspect-[16/9] skeleton rounded-t-2xl" />
      <div className="p-5 space-y-3">
        <div className="skeleton h-5 w-3/4" />
        <div className="skeleton h-4 w-full" />
        <div className="skeleton h-4 w-2/3" />
      </div>
    </div>
  );
}

function BlogListingInner({ initialBlogs = [] }: { initialBlogs?: Blog[] }) {
  const searchParams = useSearchParams();
  const initialTag = searchParams.get("tag") || "";

  const [blogs, setBlogs] = useState<Blog[]>(initialBlogs);
  const [loading, setLoading] = useState(initialBlogs.length === 0);
  const [search, setSearch] = useState(initialTag);
  const [searchInput, setSearchInput] = useState(initialTag);
  const [selectedCategory, setSelectedCategory] = useState("All");
  const supabase = createClient();
  // Skip the first fetch if server provided data and no tag filter is active
  const skipFirstFetch = useRef(initialBlogs.length > 0 && !initialTag);

  useEffect(() => {
    if (skipFirstFetch.current) {
      skipFirstFetch.current = false;
      return;
    }
    const fetchBlogs = async () => {
      setLoading(true);

      if (!isSupabaseConfigured()) {
        setLoading(false);
        return;
      }

      const data = await withTimeout(async () => {
        let query = supabase
          .from("blogs")
          .select("*")
          .eq("published", true)
          .order("created_at", { ascending: false });
        if (selectedCategory !== "All") query = query.eq("category", selectedCategory);
        if (search) query = query.or(`title.ilike.%${search}%,excerpt.ilike.%${search}%`);
        const { data } = await query;
        return data || [];
      }, [] as Blog[], 3000);

      setBlogs(data);
      setLoading(false);
    };
    fetchBlogs();
  }, [search, selectedCategory]);

  const handleSearch = (e: React.FormEvent) => { e.preventDefault(); setSearch(searchInput); };
  const featuredBlog = blogs.find((b) => b.featured);
  const regularBlogs = featuredBlog && !search && selectedCategory === "All"
    ? blogs.filter((b) => b.id !== featuredBlog.id)
    : blogs;

  return (
    <div>
      {/* Filters */}
      <div className="sticky top-16 z-30 bg-[#0B0B0B]/90 backdrop-blur-xl border-b border-white/5 py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row gap-4">
            <form onSubmit={handleSearch} className="flex-1 relative">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#9CA3AF]" />
              <input type="text" value={searchInput} onChange={(e) => setSearchInput(e.target.value)} placeholder="Search articles..." className="w-full pl-9 pr-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all" />
              {searchInput && <button type="button" onClick={() => { setSearchInput(""); setSearch(""); }} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#9CA3AF] hover:text-white"><X size={14} /></button>}
            </form>
            <div className="flex gap-2 overflow-x-auto pb-1">
              <button onClick={() => setSelectedCategory("All")} className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all ${selectedCategory === "All" ? "bg-[#00FF88] text-black" : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"}`}>All</button>
              {BLOG_CATEGORIES.map((cat) => (
                <button key={cat} onClick={() => setSelectedCategory(cat)} className={`flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all whitespace-nowrap ${selectedCategory === cat ? "bg-[#00FF88] text-black" : "bg-[#1A1A1A] text-[#9CA3AF] hover:text-white border border-[#2A2A2A]"}`}>{cat}</button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)}
          </div>
        ) : blogs.length === 0 ? (
          <div className="text-center py-24">
            <div className="text-6xl mb-4">📝</div>
            <h3 className="text-xl font-bold text-white mb-2">No articles found</h3>
            <p className="text-[#9CA3AF]">Try different search terms or browse all categories</p>
            {(search || selectedCategory !== "All") && <button onClick={() => { setSearch(""); setSearchInput(""); setSelectedCategory("All"); }} className="btn-outline mt-6 inline-flex">Clear filters</button>}
          </div>
        ) : (
          <AnimatePresence mode="wait">
            {/* Featured blog hero */}
            {featuredBlog && !search && selectedCategory === "All" && (
              <motion.div key="featured" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
                <Link href={`/blog/${featuredBlog.slug}`} className="group block">
                  <div className="glass-card overflow-hidden hover:border-[#00FF88]/20 transition-all duration-300">
                    <div className="flex flex-col lg:flex-row">
                      {featuredBlog.cover_image && (
                        <div className="relative lg:w-2/5 h-48 sm:h-56 lg:h-auto overflow-hidden rounded-t-2xl lg:rounded-l-2xl lg:rounded-tr-none">
                          <img src={featuredBlog.cover_image} alt={featuredBlog.title} className="w-full h-full object-cover object-top transform group-hover:scale-105 transition-transform duration-500" />
                          <div className="absolute inset-0 bg-gradient-to-r from-transparent to-black/20" />
                          <div className="absolute top-4 left-4">
                            <span className="px-3 py-1.5 rounded-lg bg-[#00FF88]/20 border border-[#00FF88]/30 text-[#00FF88] text-xs font-bold">FEATURED</span>
                          </div>
                        </div>
                      )}
                      <div className="lg:w-3/5 p-8 flex flex-col justify-center">
                        <span className={`category-badge border w-fit mb-3 ${CATEGORY_COLORS[featuredBlog.category] || ""}`}>{featuredBlog.category}</span>
                        <h2 className="text-2xl font-black text-white mb-3 group-hover:text-[#00FF88] transition-colors line-clamp-2">{featuredBlog.title}</h2>
                        <p className="text-[#9CA3AF] leading-relaxed line-clamp-3 mb-4">{featuredBlog.excerpt}</p>
                        <div className="flex items-center gap-4 text-sm text-[#9CA3AF]">
                          <span className="flex items-center gap-1.5"><Calendar size={12} />{formatDate(featuredBlog.created_at)}</span>
                          <span className="flex items-center gap-1.5"><Clock size={12} />{featuredBlog.read_time} min read</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </Link>
              </motion.div>
            )}
            <div key="grid" className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {regularBlogs.map((blog, i) => <BlogCard key={blog.id} blog={blog} index={i} />)}
            </div>
          </AnimatePresence>
        )}
      </div>
    </div>
  );
}

export default function BlogListing({ initialBlogs = [] }: { initialBlogs?: Blog[] }) {
  return (
    <Suspense>
      <BlogListingInner initialBlogs={initialBlogs} />
    </Suspense>
  );
}
