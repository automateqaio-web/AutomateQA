"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { createClient } from "@/lib/supabase/client";
import { MessageCircle, Trash2, Search, RefreshCw, ExternalLink } from "lucide-react";
import Link from "next/link";

interface Comment {
  id: string;
  blog_slug: string;
  name: string;
  comment: string;
  created_at: string;
}

function timeAgo(date: string) {
  const s = Math.floor((Date.now() - new Date(date).getTime()) / 1000);
  if (s < 60) return "just now";
  if (s < 3600) return `${Math.floor(s / 60)}m ago`;
  if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
  if (s < 604800) return `${Math.floor(s / 86400)}d ago`;
  return new Date(date).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

export default function AdminCommentsPage() {
  const [comments, setComments] = useState<Comment[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [deleting, setDeleting] = useState<string | null>(null);
  const [error, setError] = useState("");
  const supabase = useRef(createClient()).current;

  const fetchComments = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const { data, error: err } = await supabase
        .from("blog_comments")
        .select("*")
        .order("created_at", { ascending: false })
        .limit(500);
      if (err) throw err;
      setComments(data || []);
    } catch {
      setError("Failed to load comments. Make sure the blog_comments table exists in Supabase.");
    }
    setLoading(false);
  }, [supabase]);

  useEffect(() => { fetchComments(); }, [fetchComments]);

  async function handleDelete(id: string) {
    if (!confirm("Delete this comment? This cannot be undone.")) return;
    setDeleting(id);
    try {
      const { error: err } = await supabase.from("blog_comments").delete().eq("id", id);
      if (err) throw err;
      setComments((prev) => prev.filter((c) => c.id !== id));
    } catch {
      setError("Failed to delete comment. Check RLS policies.");
    }
    setDeleting(null);
  }

  const filtered = comments.filter(
    (c) =>
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.comment.toLowerCase().includes(search.toLowerCase()) ||
      c.blog_slug.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="max-w-5xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2.5">
            <MessageCircle size={22} className="text-[#00FF88]" />
            Comments
          </h1>
          <p className="text-[#9CA3AF] text-sm mt-1">
            {comments.length} total comment{comments.length !== 1 ? "s" : ""}
          </p>
        </div>
        <button
          onClick={fetchComments}
          disabled={loading}
          className="flex items-center gap-2 px-4 py-2 rounded-xl border border-white/10 text-[#9CA3AF] hover:text-white hover:border-white/20 text-sm transition-all disabled:opacity-50"
        >
          <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
          Refresh
        </button>
      </div>

      {/* Search */}
      <div className="relative mb-6">
        <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#4B5563]" />
        <input
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search by name, comment, or article slug..."
          className="w-full bg-[#111] border border-white/8 rounded-xl pl-9 pr-4 py-3 text-white text-sm placeholder-[#4B5563] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
        />
      </div>

      {/* Error */}
      {error && (
        <div className="mb-4 px-4 py-3 rounded-xl border border-red-500/20 bg-red-500/5 text-red-400 text-sm">
          {error}
        </div>
      )}

      {/* Content */}
      {loading ? (
        <div className="flex items-center justify-center py-20 text-[#9CA3AF]">
          <RefreshCw size={20} className="animate-spin mr-3" />
          Loading comments...
        </div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-20 border border-dashed border-white/8 rounded-2xl">
          <MessageCircle size={36} className="mx-auto mb-3 text-[#2A2A2A]" />
          <p className="text-[#4B5563]">{search ? "No comments match your search." : "No comments yet."}</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map((c) => (
            <div
              key={c.id}
              className="bg-[#111] border border-white/8 rounded-2xl p-5 hover:border-white/12 transition-all group"
            >
              <div className="flex items-start justify-between gap-4">
                <div className="flex items-start gap-3 flex-1 min-w-0">
                  {/* Avatar */}
                  <div className="flex-shrink-0 w-9 h-9 rounded-full bg-gradient-to-br from-[#00FF88]/15 to-[#00FF88]/5 border border-[#00FF88]/20 flex items-center justify-center text-[#00FF88] font-bold text-sm">
                    {c.name.charAt(0).toUpperCase()}
                  </div>
                  {/* Content */}
                  <div className="flex-1 min-w-0">
                    <div className="flex flex-wrap items-center gap-2 mb-1">
                      <span className="text-white font-semibold text-sm">{c.name}</span>
                      <span className="text-[#4B5563] text-xs">·</span>
                      <span className="text-[#4B5563] text-xs">{timeAgo(c.created_at)}</span>
                      <span className="text-[#4B5563] text-xs">·</span>
                      <Link
                        href={`/blog/${c.blog_slug}`}
                        target="_blank"
                        className="text-[#6B7280] hover:text-[#00FF88] text-xs flex items-center gap-1 transition-colors"
                      >
                        {c.blog_slug}
                        <ExternalLink size={10} />
                      </Link>
                    </div>
                    <p className="text-[#C9D1D9] text-sm leading-relaxed">{c.comment}</p>
                  </div>
                </div>
                {/* Delete */}
                <button
                  onClick={() => handleDelete(c.id)}
                  disabled={deleting === c.id}
                  className="flex-shrink-0 p-2 rounded-lg text-[#4B5563] hover:text-red-400 hover:bg-red-500/10 border border-transparent hover:border-red-500/20 transition-all opacity-0 group-hover:opacity-100 disabled:opacity-50"
                  title="Delete comment"
                >
                  {deleting === c.id ? (
                    <RefreshCw size={14} className="animate-spin" />
                  ) : (
                    <Trash2 size={14} />
                  )}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
