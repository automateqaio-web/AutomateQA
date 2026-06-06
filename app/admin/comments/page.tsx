"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { createClient } from "@/lib/supabase/client";
import { MessageCircle, Trash2, Search, RefreshCw, ExternalLink, FileText, Calendar, User } from "lucide-react";
import Link from "next/link";

interface Comment {
  id: string;
  blog_slug: string;
  name: string;
  comment: string;
  created_at: string;
  blog_title?: string;
}

function formatDate(date: string) {
  return new Date(date).toLocaleDateString("en-US", {
    month: "short", day: "numeric", year: "numeric",
    hour: "2-digit", minute: "2-digit",
  });
}

export default function AdminCommentsPage() {
  const [comments, setComments] = useState<Comment[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [deleting, setDeleting] = useState<string | null>(null);
  const [confirmId, setConfirmId] = useState<string | null>(null);
  const [error, setError] = useState("");
  const supabase = useRef(createClient()).current;

  const fetchComments = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      // Fetch comments
      const { data: commentsData, error: commentsErr } = await supabase
        .from("blog_comments")
        .select("*")
        .order("created_at", { ascending: false })
        .limit(500);
      if (commentsErr) throw commentsErr;

      // Fetch blog titles to display alongside
      const { data: blogsData } = await supabase
        .from("blogs")
        .select("slug, title");

      const blogMap = new Map((blogsData || []).map((b: any) => [b.slug, b.title]));

      setComments(
        (commentsData || []).map((c: any) => ({
          ...c,
          blog_title: blogMap.get(c.blog_slug) || c.blog_slug,
        }))
      );
    } catch {
      setError("Failed to load comments. Make sure the blog_comments table exists in Supabase.");
    }
    setLoading(false);
  }, [supabase]);

  useEffect(() => { fetchComments(); }, [fetchComments]);

  async function handleDelete(id: string) {
    setDeleting(id);
    setConfirmId(null);
    try {
      const { error: err } = await supabase.from("blog_comments").delete().eq("id", id);
      if (err) throw err;
      setComments((prev) => prev.filter((c) => c.id !== id));
    } catch {
      setError("Failed to delete. Make sure you have added the delete RLS policy in Supabase.");
    }
    setDeleting(null);
  }

  const filtered = comments.filter((c) => {
    const q = search.toLowerCase();
    return (
      c.name.toLowerCase().includes(q) ||
      c.comment.toLowerCase().includes(q) ||
      (c.blog_title || "").toLowerCase().includes(q)
    );
  });

  // Group by blog for summary
  const blogCounts: Record<string, number> = {};
  comments.forEach((c) => {
    blogCounts[c.blog_title || c.blog_slug] = (blogCounts[c.blog_title || c.blog_slug] || 0) + 1;
  });
  const topBlogs = Object.entries(blogCounts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 4);

  return (
    <div className="max-w-5xl mx-auto space-y-6">

      {/* Header */}
      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2.5">
            <MessageCircle size={22} className="text-[#00FF88]" />
            Comments
          </h1>
          <p className="text-[#9CA3AF] text-sm mt-1">
            Manage all reader comments across your blog articles
          </p>
        </div>
        <button
          onClick={fetchComments}
          disabled={loading}
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl border border-white/10 text-[#9CA3AF] hover:text-white hover:border-white/20 text-sm transition-all disabled:opacity-50 flex-shrink-0"
        >
          <RefreshCw size={13} className={loading ? "animate-spin" : ""} />
          Refresh
        </button>
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <div className="bg-[#111] border border-white/8 rounded-2xl p-4">
          <p className="text-[#9CA3AF] text-xs font-medium uppercase tracking-wide mb-1">Total</p>
          <p className="text-2xl font-black text-white">{comments.length}</p>
          <p className="text-[#6B7280] text-xs mt-0.5">comments</p>
        </div>
        <div className="bg-[#111] border border-white/8 rounded-2xl p-4">
          <p className="text-[#9CA3AF] text-xs font-medium uppercase tracking-wide mb-1">Articles</p>
          <p className="text-2xl font-black text-white">{Object.keys(blogCounts).length}</p>
          <p className="text-[#6B7280] text-xs mt-0.5">with comments</p>
        </div>
        {topBlogs.slice(0, 2).map(([title, count]) => (
          <div key={title} className="bg-[#111] border border-white/8 rounded-2xl p-4 col-span-1 overflow-hidden">
            <p className="text-[#9CA3AF] text-xs font-medium uppercase tracking-wide mb-1">Top Article</p>
            <p className="text-2xl font-black text-[#00FF88]">{count}</p>
            <p className="text-[#6B7280] text-xs mt-0.5 truncate">{title}</p>
          </div>
        ))}
      </div>

      {/* Error */}
      {error && (
        <div className="px-4 py-3 rounded-xl border border-red-500/20 bg-red-500/5 text-red-400 text-sm">
          {error}
        </div>
      )}

      {/* Search + count */}
      <div className="flex items-center gap-3">
        <div className="relative flex-1">
          <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#4B5563]" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by name, comment text, or article title..."
            className="w-full bg-[#111] border border-white/8 rounded-xl pl-9 pr-4 py-3 text-white text-sm placeholder-[#4B5563] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
          />
        </div>
        {search && (
          <span className="text-[#9CA3AF] text-sm whitespace-nowrap">
            {filtered.length} result{filtered.length !== 1 ? "s" : ""}
          </span>
        )}
      </div>

      {/* Comment list */}
      {loading ? (
        <div className="flex items-center justify-center py-24 text-[#9CA3AF]">
          <RefreshCw size={20} className="animate-spin mr-3" />
          Loading comments...
        </div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-20 border border-dashed border-white/8 rounded-2xl">
          <MessageCircle size={40} className="mx-auto mb-3 text-[#2A2A2A]" />
          <p className="text-[#6B7280] text-sm font-medium">
            {search ? "No comments match your search." : "No comments yet."}
          </p>
          <p className="text-[#374151] text-xs mt-1">
            {!search && "Comments posted by readers will appear here."}
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map((c) => (
            <div
              key={c.id}
              className={`bg-[#111] border rounded-2xl transition-all duration-200 ${
                confirmId === c.id
                  ? "border-red-500/30 shadow-[0_0_20px_rgba(239,68,68,0.08)]"
                  : "border-white/8 hover:border-white/14"
              }`}
            >
              {/* Article label */}
              <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-white/5">
                <Link
                  href={`/blog/${c.blog_slug}`}
                  target="_blank"
                  className="flex items-center gap-2 text-[#6B7280] hover:text-[#00FF88] text-xs font-medium transition-colors group/link"
                >
                  <FileText size={11} />
                  <span className="truncate max-w-[300px] sm:max-w-[500px]">
                    {c.blog_title || c.blog_slug}
                  </span>
                  <ExternalLink size={10} className="flex-shrink-0 opacity-0 group-hover/link:opacity-100 transition-opacity" />
                </Link>
                <span className="text-[#374151] text-xs flex items-center gap-1.5 flex-shrink-0">
                  <Calendar size={10} />
                  {formatDate(c.created_at)}
                </span>
              </div>

              {/* Comment body */}
              <div className="flex items-start gap-4 px-5 py-4">
                {/* Avatar */}
                <div className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-br from-[#00FF88]/15 to-transparent border border-[#00FF88]/20 flex items-center justify-center text-[#00FF88] font-bold text-sm">
                  {c.name.charAt(0).toUpperCase()}
                </div>

                {/* Text */}
                <div className="flex-1 min-w-0">
                  <p className="text-white font-semibold text-sm flex items-center gap-2 mb-1.5">
                    <User size={11} className="text-[#6B7280]" />
                    {c.name}
                  </p>
                  <p className="text-[#C9D1D9] text-sm leading-relaxed">{c.comment}</p>
                </div>

                {/* Delete control */}
                <div className="flex-shrink-0 flex items-center gap-2">
                  {confirmId === c.id ? (
                    <>
                      <span className="text-red-400 text-xs font-medium hidden sm:block">Delete?</span>
                      <button
                        onClick={() => handleDelete(c.id)}
                        disabled={deleting === c.id}
                        className="px-3 py-1.5 rounded-lg bg-red-500 hover:bg-red-600 text-white text-xs font-bold transition-colors disabled:opacity-60 flex items-center gap-1.5"
                      >
                        {deleting === c.id ? (
                          <RefreshCw size={11} className="animate-spin" />
                        ) : (
                          <Trash2 size={11} />
                        )}
                        Yes, Delete
                      </button>
                      <button
                        onClick={() => setConfirmId(null)}
                        className="px-3 py-1.5 rounded-lg border border-white/10 text-[#9CA3AF] hover:text-white text-xs font-medium transition-colors"
                      >
                        Cancel
                      </button>
                    </>
                  ) : (
                    <button
                      onClick={() => setConfirmId(c.id)}
                      className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-red-500/20 text-red-400 hover:bg-red-500/10 text-xs font-medium transition-all"
                    >
                      <Trash2 size={12} />
                      Delete
                    </button>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
