"use client";

import { useState, useEffect } from "react";
import { createClient } from "@supabase/supabase-js";
import { Heart, Star, MessageCircle, Link2 } from "lucide-react";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

function timeAgo(date: string) {
  const s = Math.floor((Date.now() - new Date(date).getTime()) / 1000);
  if (s < 60) return "just now";
  if (s < 3600) return `${Math.floor(s / 60)}m ago`;
  if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
  if (s < 604800) return `${Math.floor(s / 86400)}d ago`;
  return new Date(date).toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

function formatCount(n: number) {
  if (n >= 1000) return `${(n / 1000).toFixed(1)}k`;
  return n.toString();
}

interface Comment {
  id: string;
  name: string;
  comment: string;
  created_at: string;
}

export default function BlogInteractions({
  slug,
  initialLikes = 0,
}: {
  slug: string;
  initialLikes?: number;
}) {
  // Like
  const [liked, setLiked] = useState(false);
  const [likesCount, setLikesCount] = useState(initialLikes);
  const [liking, setLiking] = useState(false);

  // Rating
  const [hoverRating, setHoverRating] = useState(0);
  const [userRating, setUserRating] = useState(0);
  const [hasRated, setHasRated] = useState(false);
  const [avgRating, setAvgRating] = useState(0);
  const [ratingCount, setRatingCount] = useState(0);

  // Comments
  const [comments, setComments] = useState<Comment[]>([]);
  const [name, setName] = useState("");
  const [commentText, setCommentText] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [commentError, setCommentError] = useState("");

  // Share
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    const likedKey = `liked_${slug}`;
    const ratedKey = `rated_${slug}`;
    if (localStorage.getItem(likedKey)) setLiked(true);
    const saved = localStorage.getItem(ratedKey);
    if (saved) { setHasRated(true); setUserRating(Number(saved)); }

    fetchRatings();
    fetchComments();
  }, [slug]);

  async function fetchRatings() {
    try {
      const { data } = await supabase
        .from("blog_ratings")
        .select("rating")
        .eq("blog_slug", slug);
      if (data && data.length > 0) {
        setAvgRating(data.reduce((s, r) => s + r.rating, 0) / data.length);
        setRatingCount(data.length);
      }
    } catch {}
  }

  async function fetchComments() {
    try {
      const { data } = await supabase
        .from("blog_comments")
        .select("id, name, comment, created_at")
        .eq("blog_slug", slug)
        .order("created_at", { ascending: false });
      if (data) setComments(data);
    } catch {}
  }

  async function handleLike() {
    if (liked || liking) return;
    setLiking(true);
    setLiked(true);
    setLikesCount((c) => c + 1);
    localStorage.setItem(`liked_${slug}`, "1");
    try {
      const { data } = await supabase.rpc("increment_blog_likes", { slug_param: slug });
      if (data != null) setLikesCount(data);
    } catch {}
    setLiking(false);
  }

  async function handleRate(rating: number) {
    if (hasRated) return;
    setHasRated(true);
    setUserRating(rating);
    localStorage.setItem(`rated_${slug}`, rating.toString());
    try {
      await supabase.from("blog_ratings").insert({ blog_slug: slug, rating });
      await fetchRatings();
    } catch {}
  }

  async function handleComment(e: React.FormEvent) {
    e.preventDefault();
    setCommentError("");
    if (!name.trim() || !commentText.trim() || submitting) return;
    setSubmitting(true);
    try {
      const { error } = await supabase.from("blog_comments").insert({
        blog_slug: slug,
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
      setCommentError("Failed to post comment. Please try again.");
    }
    setSubmitting(false);
  }

  const pageUrl = typeof window !== "undefined" ? window.location.href : "";

  async function handleCopy() {
    try {
      await navigator.clipboard.writeText(pageUrl);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  }

  const displayStars = hoverRating || userRating || Math.round(avgRating);

  return (
    <div className="mt-16 space-y-10 border-t border-white/5 pt-10">

      {/* Like + Share row */}
      <div className="flex flex-wrap items-center gap-3">
        {/* Like */}
        <button
          onClick={handleLike}
          disabled={liked}
          className={`flex items-center gap-2 px-5 py-2.5 rounded-full border text-sm font-semibold transition-all duration-300 ${
            liked
              ? "bg-red-500/10 border-red-500/30 text-red-400 cursor-default"
              : "bg-white/[0.04] border-white/10 text-[#9CA3AF] hover:border-red-500/30 hover:text-red-400 hover:bg-red-500/5"
          }`}
        >
          <Heart size={15} className={`transition-all ${liked ? "fill-red-400 text-red-400 scale-110" : ""}`} />
          <span>{formatCount(likesCount)}</span>
          <span className="text-xs opacity-75">{liked ? "Liked!" : "Like"}</span>
        </button>

        {/* Rating pill */}
        {ratingCount > 0 && (
          <div className="flex items-center gap-1.5 px-4 py-2.5 rounded-full border border-white/8 bg-white/[0.03] text-sm">
            <div className="flex">
              {[1,2,3,4,5].map((s) => (
                <Star key={s} size={11} className={s <= Math.round(avgRating) ? "fill-amber-400 text-amber-400" : "text-[#374151]"} />
              ))}
            </div>
            <span className="text-white font-semibold ml-1">{avgRating.toFixed(1)}</span>
            <span className="text-[#6B7280]">· {ratingCount}</span>
          </div>
        )}

        {/* Share buttons */}
        <div className="ml-auto flex items-center gap-2">
          <span className="text-xs text-[#6B7280] hidden sm:block">Share:</span>
          <a
            href={`https://twitter.com/intent/tweet?url=${encodeURIComponent(pageUrl)}&text=Check this out on AutomateQA`}
            target="_blank"
            rel="noopener noreferrer"
            title="Share on X"
            className="p-2.5 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-sky-500/30 hover:text-sky-400 hover:bg-sky-500/5 transition-all"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-4.714-6.231-5.401 6.231H2.748l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
            </svg>
          </a>
          <a
            href={`https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(pageUrl)}`}
            target="_blank"
            rel="noopener noreferrer"
            title="Share on LinkedIn"
            className="p-2.5 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-blue-500/30 hover:text-blue-400 hover:bg-blue-500/5 transition-all"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z" />
              <rect x="2" y="9" width="4" height="12" />
              <circle cx="4" cy="4" r="2" />
            </svg>
          </a>
          <a
            href={`https://wa.me/?text=${encodeURIComponent(pageUrl)}`}
            target="_blank"
            rel="noopener noreferrer"
            title="Share on WhatsApp"
            className="p-2.5 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-green-500/30 hover:text-green-400 hover:bg-green-500/5 transition-all"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
              <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z" />
            </svg>
          </a>
          <button
            onClick={handleCopy}
            title="Copy link"
            className={`p-2.5 rounded-xl border transition-all ${
              copied
                ? "border-[#00FF88]/30 text-[#00FF88] bg-[#00FF88]/5"
                : "border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-white/20 hover:text-white"
            }`}
          >
            <Link2 size={14} />
          </button>
        </div>
      </div>

      {/* Rate This Article */}
      <div className="glass-card p-6">
        <div className="flex flex-wrap items-start justify-between gap-4 mb-5">
          <div>
            <h3 className="text-white font-bold text-lg">Rate This Article</h3>
            <p className="text-[#9CA3AF] text-sm mt-1">
              {hasRated
                ? `You rated this ${userRating} out of 5 — thank you!`
                : "Was this article helpful? Tap a star to rate it."}
            </p>
          </div>
          {ratingCount > 0 && (
            <div className="text-right">
              <div className="text-2xl font-black text-white">{avgRating.toFixed(1)}<span className="text-[#6B7280] text-base font-normal">/5</span></div>
              <div className="text-xs text-[#6B7280]">{ratingCount} rating{ratingCount !== 1 ? "s" : ""}</div>
            </div>
          )}
        </div>
        <div className="flex items-center gap-1.5">
          {[1,2,3,4,5].map((s) => (
            <button
              key={s}
              onClick={() => handleRate(s)}
              onMouseEnter={() => !hasRated && setHoverRating(s)}
              onMouseLeave={() => !hasRated && setHoverRating(0)}
              disabled={hasRated}
              className="transition-all duration-100 hover:scale-110 disabled:cursor-default active:scale-95"
            >
              <Star
                size={36}
                className={`transition-colors duration-100 ${
                  s <= displayStars
                    ? "fill-amber-400 text-amber-400"
                    : "text-[#2A2A2A] hover:text-amber-400/40"
                }`}
              />
            </button>
          ))}
          {hasRated && (
            <span className="ml-3 text-[#00FF88] text-sm flex items-center gap-1.5">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="20 6 9 17 4 12" />
              </svg>
              Saved
            </span>
          )}
        </div>
      </div>

      {/* Comments */}
      <div>
        <h3 className="text-white font-bold text-xl mb-6 flex items-center gap-2.5">
          <MessageCircle size={20} className="text-[#00FF88]" />
          Comments
          {comments.length > 0 && (
            <span className="text-sm font-normal text-[#6B7280] bg-white/5 border border-white/8 px-2.5 py-0.5 rounded-full">
              {comments.length}
            </span>
          )}
        </h3>

        {/* Comment form */}
        <form onSubmit={handleComment} className="glass-card p-6 mb-8">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="block text-xs text-[#9CA3AF] mb-2 font-semibold uppercase tracking-wide">
                Your Name *
              </label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="John Doe"
                maxLength={100}
                required
                className="w-full bg-[#0D0D0D] border border-white/8 rounded-xl px-4 py-3 text-white text-sm placeholder-[#374151] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
              />
            </div>
          </div>
          <div className="mb-5">
            <label className="block text-xs text-[#9CA3AF] mb-2 font-semibold uppercase tracking-wide">
              Comment *
            </label>
            <textarea
              value={commentText}
              onChange={(e) => setCommentText(e.target.value)}
              placeholder="Share your thoughts, questions, or feedback about this article..."
              maxLength={2000}
              rows={4}
              required
              className="w-full bg-[#0D0D0D] border border-white/8 rounded-xl px-4 py-3 text-white text-sm placeholder-[#374151] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all resize-none"
            />
            <div className="flex justify-between items-center mt-1.5">
              {commentError && <p className="text-red-400 text-xs">{commentError}</p>}
              <span className="text-[#374151] text-xs ml-auto">{commentText.length}/2000</span>
            </div>
          </div>
          <button
            type="submit"
            disabled={submitting || !name.trim() || !commentText.trim()}
            className="px-6 py-2.5 bg-[#00FF88] text-black font-bold text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all disabled:opacity-40 disabled:cursor-not-allowed flex items-center gap-2"
          >
            {submitting ? (
              <>
                <svg className="animate-spin" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <circle cx="12" cy="12" r="10" strokeOpacity="0.25" />
                  <path d="M12 2a10 10 0 0 1 10 10" strokeLinecap="round" />
                </svg>
                Posting...
              </>
            ) : submitted ? (
              <>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="20 6 9 17 4 12" />
                </svg>
                Posted!
              </>
            ) : (
              "Post Comment →"
            )}
          </button>
        </form>

        {/* Comment list */}
        {comments.length === 0 ? (
          <div className="text-center py-14 border border-dashed border-white/8 rounded-2xl">
            <MessageCircle size={36} className="mx-auto mb-3 text-[#2A2A2A]" />
            <p className="text-[#4B5563] text-sm">No comments yet.</p>
            <p className="text-[#374151] text-xs mt-1">Be the first to share your thoughts!</p>
          </div>
        ) : (
          <div className="space-y-4">
            {comments.map((c) => (
              <div key={c.id} className="glass-card p-5 group">
                <div className="flex items-start gap-3 mb-3">
                  <div className="flex-shrink-0 w-9 h-9 rounded-full bg-gradient-to-br from-[#00FF88]/15 to-[#00FF88]/5 border border-[#00FF88]/20 flex items-center justify-center text-[#00FF88] font-bold text-sm">
                    {c.name.charAt(0).toUpperCase()}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="text-white font-semibold text-sm">{c.name}</span>
                      <span className="text-[#4B5563] text-xs">·</span>
                      <span className="text-[#4B5563] text-xs">{timeAgo(c.created_at)}</span>
                    </div>
                    <p className="text-[#C9D1D9] text-sm leading-relaxed mt-2">{c.comment}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
