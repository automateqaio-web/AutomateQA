"use client";

import { useState, useEffect } from "react";
import { createClient } from "@supabase/supabase-js";
import { Heart, MessageCircle, Link2, ChevronDown } from "lucide-react";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

function timeAgo(date: string) {
  const s = Math.floor((Date.now() - new Date(date).getTime()) / 1000);
  if (s < 60) return "just now";
  if (s < 3600) return `${Math.floor(s / 60)}m ago`;
  if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
  return new Date(date).toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

interface Comment {
  id: string;
  name: string;
  comment: string;
  created_at: string;
}

export default function MemeInteractions({
  memeId,
  initialLikes = 0,
  title,
}: {
  memeId: string;
  initialLikes?: number;
  title: string;
}) {
  const [liked, setLiked] = useState(false);
  const [likesCount, setLikesCount] = useState(initialLikes);
  const [liking, setLiking] = useState(false);
  const [copied, setCopied] = useState(false);
  const [pageUrl, setPageUrl] = useState("");
  const [commentsOpen, setCommentsOpen] = useState(false);
  const [comments, setComments] = useState<Comment[]>([]);
  const [name, setName] = useState("");
  const [commentText, setCommentText] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [commentError, setCommentError] = useState("");

  useEffect(() => {
    setPageUrl(window.location.href);
    if (localStorage.getItem(`meme_liked_${memeId}`)) {
      setLiked(true);
      setLikesCount((c) => Math.max(c, 1));
    }
    fetchComments();
  }, [memeId]);

  async function fetchComments() {
    try {
      const { data } = await supabase
        .from("meme_comments")
        .select("id, name, comment, created_at")
        .eq("meme_id", memeId)
        .order("created_at", { ascending: false });
      if (data) setComments(data);
    } catch {}
  }

  async function handleLike() {
    if (liked || liking) return;
    setLiking(true);
    setLiked(true);
    setLikesCount((c) => c + 1);
    localStorage.setItem(`meme_liked_${memeId}`, "1");
    try {
      const { data } = await supabase.rpc("increment_meme_likes", { meme_id_param: memeId });
      if (data != null) setLikesCount(data);
    } catch {}
    setLiking(false);
  }

  async function handleComment(e: React.FormEvent) {
    e.preventDefault();
    setCommentError("");
    if (!name.trim() || !commentText.trim() || submitting) return;
    setSubmitting(true);
    try {
      const { error } = await supabase.from("meme_comments").insert({
        meme_id: memeId,
        name: name.trim().slice(0, 100),
        comment: commentText.trim().slice(0, 2000),
      });
      if (error) throw error;
      setSubmitted(true);
      setName("");
      setCommentText("");
      await fetchComments();
      setTimeout(() => setSubmitted(false), 3000);
    } catch {
      setCommentError("Failed to post. Make sure the meme_comments table exists in Supabase.");
    }
    setSubmitting(false);
  }

  async function handleCopy() {
    try {
      await navigator.clipboard.writeText(pageUrl);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  }

  const encodedUrl = encodeURIComponent(pageUrl);
  const encodedTitle = encodeURIComponent(title);

  return (
    <div className="space-y-10">

      {/* Like + Share row */}
      <div className="flex flex-wrap items-center gap-3 py-5 border-t border-b border-white/[0.07]">
        {/* Like */}
        <button
          onClick={handleLike}
          disabled={liked}
          className={`flex items-center gap-2.5 px-5 py-2.5 rounded-full border text-sm font-semibold transition-all duration-300 ${
            liked
              ? "bg-red-500/10 border-red-500/30 text-red-400 cursor-default"
              : "bg-white/[0.04] border-white/10 text-[#9CA3AF] hover:border-red-500/30 hover:text-red-400 hover:bg-red-500/5"
          }`}
        >
          <Heart size={15} className={`transition-all ${liked ? "fill-red-400 text-red-400 scale-110" : ""}`} />
          <span>{likesCount}</span>
          <span className="text-xs opacity-75">{liked ? "Liked!" : "Like"}</span>
        </button>

        {/* Share buttons — only render once page URL is available */}
        {pageUrl && <div className="ml-auto flex items-center gap-2">
          <span className="text-xs text-[#4B5563] hidden sm:block mr-1">Share</span>
          {/* X */}
          <a
            href={`https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedTitle}`}
            target="_blank" rel="noopener noreferrer"
            className="p-2.5 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-sky-500/30 hover:text-sky-400 hover:bg-sky-500/5 transition-all"
            title="Share on X"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-4.714-6.231-5.401 6.231H2.748l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
            </svg>
          </a>
          {/* LinkedIn */}
          <a
            href={`https://www.linkedin.com/sharing/share-offsite/?url=${encodedUrl}`}
            target="_blank" rel="noopener noreferrer"
            className="p-2.5 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-blue-500/30 hover:text-blue-400 hover:bg-blue-500/5 transition-all"
            title="Share on LinkedIn"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z" />
              <rect x="2" y="9" width="4" height="12" /><circle cx="4" cy="4" r="2" />
            </svg>
          </a>
          {/* WhatsApp */}
          <a
            href={`https://wa.me/?text=${encodedTitle}%20${encodedUrl}`}
            target="_blank" rel="noopener noreferrer"
            className="p-2.5 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-green-500/30 hover:text-green-400 hover:bg-green-500/5 transition-all"
            title="Share on WhatsApp"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z" />
            </svg>
          </a>
          {/* Copy link */}
          <button
            onClick={handleCopy}
            className={`p-2.5 rounded-xl border transition-all ${
              copied
                ? "border-[#00FF88]/30 text-[#00FF88] bg-[#00FF88]/5"
                : "border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-white/20 hover:text-white"
            }`}
            title="Copy link"
          >
            <Link2 size={14} />
          </button>
        </div>}
      </div>

      {/* Comments — collapsible */}
      <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden">
        {/* Toggle header */}
        <button
          onClick={() => setCommentsOpen((o) => !o)}
          className="w-full flex items-center justify-between px-6 py-4 text-left group"
        >
          <span className="flex items-center gap-2.5 text-white font-bold text-base">
            <MessageCircle size={18} className="text-[#00FF88]" />
            Comments
            {comments.length > 0 && (
              <span className="text-xs font-normal text-[#6B7280] bg-white/5 border border-white/8 px-2 py-0.5 rounded-full">
                {comments.length}
              </span>
            )}
          </span>
          <ChevronDown
            size={16}
            className={`text-[#4B5563] transition-transform duration-200 ${commentsOpen ? "rotate-180 text-[#00FF88]" : "group-hover:text-white"}`}
          />
        </button>

        {/* Expanded body */}
        {commentsOpen && (
          <div className="border-t border-white/5 px-6 pb-6 pt-5 space-y-6">
            {/* Form */}
            <form onSubmit={handleComment} className="space-y-4">
              <div>
                <label className="block text-xs text-[#6B7280] mb-2 font-semibold uppercase tracking-widest">Your Name *</label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="John Doe"
                  maxLength={100}
                  required
                  className="w-full sm:w-1/2 bg-[#111] border border-white/8 rounded-xl px-4 py-3 text-white text-sm placeholder-[#374151] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
                />
              </div>
              <div>
                <label className="block text-xs text-[#6B7280] mb-2 font-semibold uppercase tracking-widest">Comment *</label>
                <textarea
                  value={commentText}
                  onChange={(e) => setCommentText(e.target.value)}
                  placeholder="What do you think about this meme? 😄"
                  maxLength={2000}
                  rows={3}
                  required
                  className="w-full bg-[#111] border border-white/8 rounded-xl px-4 py-3 text-white text-sm placeholder-[#374151] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all resize-none"
                />
                <div className="flex justify-between items-center mt-1.5">
                  {commentError && <p className="text-red-400 text-xs">{commentError}</p>}
                  <span className="text-[#374151] text-xs ml-auto">{commentText.length}/2000</span>
                </div>
              </div>
              <button
                type="submit"
                disabled={submitting || !name.trim() || !commentText.trim()}
                className="px-6 py-2.5 bg-[#00FF88] text-black font-bold text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all disabled:opacity-40 disabled:cursor-not-allowed"
              >
                {submitting ? "Posting..." : submitted ? "✓ Posted!" : "Post Comment →"}
              </button>
            </form>

            {/* Comment list */}
            {comments.length === 0 ? (
              <div className="text-center py-10 border border-dashed border-white/8 rounded-xl">
                <MessageCircle size={28} className="mx-auto mb-2 text-[#2A2A2A]" />
                <p className="text-[#4B5563] text-sm">No comments yet. Be the first!</p>
              </div>
            ) : (
              <div className="space-y-3">
                {comments.map((c) => (
                  <div key={c.id} className="rounded-xl border border-white/6 bg-white/[0.02] p-4">
                    <div className="flex items-start gap-3">
                      <div className="flex-shrink-0 w-9 h-9 rounded-full bg-gradient-to-br from-[#00FF88]/15 to-transparent border border-[#00FF88]/20 flex items-center justify-center text-[#00FF88] font-bold text-sm">
                        {c.name.charAt(0).toUpperCase()}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2 mb-1">
                          <span className="text-white font-semibold text-sm">{c.name}</span>
                          <span className="text-[#4B5563] text-xs">·</span>
                          <span className="text-[#4B5563] text-xs">{timeAgo(c.created_at)}</span>
                        </div>
                        <p className="text-[#C9D1D9] text-sm leading-relaxed">{c.comment}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
