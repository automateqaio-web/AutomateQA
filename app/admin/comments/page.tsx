"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { createClient } from "@/lib/supabase/client";
import {
  MessageCircle, Trash2, Search, RefreshCw, ExternalLink,
  ChevronDown, FileText, User, Calendar, Lightbulb, Play, Smile,
} from "lucide-react";
import Link from "next/link";

/* ─── Types ─────────────────────────────────────────────────────── */

type Source = "all" | "blog" | "meme" | "video" | "tip";

interface RawComment {
  id: string;
  name: string;
  comment: string;
  created_at: string;
  contentId: string;
  source: Exclude<Source, "all">;
}

interface ContentGroup {
  key: string;
  source: Exclude<Source, "all">;
  contentId: string;
  title: string;
  url: string;
  comments: RawComment[];
}

/* ─── Source config ──────────────────────────────────────────────── */

const SOURCE_CONFIG: Record<Exclude<Source, "all">, {
  label: string;
  icon: React.ComponentType<{ size?: number; className?: string }>;
  bg: string; text: string; border: string; activeBg: string;
}> = {
  blog:  { label: "Blog",   icon: FileText,  bg: "bg-blue-500/10",     text: "text-blue-400",     border: "border-blue-500/20",    activeBg: "bg-blue-500/10 text-blue-400 border-blue-500/25" },
  meme:  { label: "Meme",   icon: Smile,     bg: "bg-amber-500/10",    text: "text-amber-400",    border: "border-amber-500/20",   activeBg: "bg-amber-500/10 text-amber-400 border-amber-500/25" },
  video: { label: "Video",  icon: Play,      bg: "bg-red-500/10",      text: "text-red-400",      border: "border-red-500/20",     activeBg: "bg-red-500/10 text-red-400 border-red-500/25" },
  tip:   { label: "Tip",    icon: Lightbulb, bg: "bg-[#00FF88]/10",    text: "text-[#00FF88]",    border: "border-[#00FF88]/20",   activeBg: "bg-[#00FF88]/10 text-[#00FF88] border-[#00FF88]/25" },
};

/* ─── Helpers ────────────────────────────────────────────────────── */

function timeAgo(date: string) {
  const s = Math.floor((Date.now() - new Date(date).getTime()) / 1000);
  if (s < 60) return "just now";
  if (s < 3600) return `${Math.floor(s / 60)}m ago`;
  if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
  return new Date(date).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

/* ─── Component ──────────────────────────────────────────────────── */

export default function AdminCommentsPage() {
  const [groups, setGroups] = useState<ContentGroup[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [activeSource, setActiveSource] = useState<Source>("all");
  const [expanded, setExpanded] = useState<string | null>(null);
  const [deleting, setDeleting] = useState<string | null>(null);
  const [confirmId, setConfirmId] = useState<string | null>(null);
  const [error, setError] = useState("");
  const supabase = useRef(createClient()).current;

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      // Fetch all comment tables + content tables in parallel
      const [
        blogCommentsRes, memeCommentsRes, videoCommentsRes, tipCommentsRes,
        blogsRes, memesRes, videosRes, tipsRes,
      ] = await Promise.all([
        supabase.from("blog_comments").select("id,blog_slug,name,comment,created_at").order("created_at", { ascending: false }).limit(500),
        supabase.from("meme_comments").select("id,meme_id,name,comment,created_at").order("created_at", { ascending: false }).limit(500),
        supabase.from("video_comments").select("id,video_id,name,comment,created_at").order("created_at", { ascending: false }).limit(500),
        supabase.from("tip_comments").select("id,tip_id,name,comment,created_at").order("created_at", { ascending: false }).limit(500),
        supabase.from("blogs").select("slug,title"),
        supabase.from("memes").select("id,title"),
        supabase.from("videos").select("id,title"),
        supabase.from("automation_tips").select("id,slug,title"),
      ]);

      // Build lookup maps
      const blogMap  = new Map((blogsRes.data  || []).map((b: any) => [b.slug, b.title]));
      const memeMap  = new Map((memesRes.data  || []).map((m: any) => [m.id,   m.title]));
      const videoMap = new Map((videosRes.data || []).map((v: any) => [v.id,   v.title]));
      const tipMap   = new Map((tipsRes.data   || []).map((t: any) => [t.id,   { title: t.title, slug: t.slug }]));

      // Normalise all comments into one shape, sorted newest first
      const allRaw: RawComment[] = [
        ...(blogCommentsRes.data  || []).map((c: any) => ({ id: c.id, name: c.name, comment: c.comment, created_at: c.created_at, contentId: c.blog_slug, source: "blog"  as const })),
        ...(memeCommentsRes.data  || []).map((c: any) => ({ id: c.id, name: c.name, comment: c.comment, created_at: c.created_at, contentId: c.meme_id,   source: "meme"  as const })),
        ...(videoCommentsRes.data || []).map((c: any) => ({ id: c.id, name: c.name, comment: c.comment, created_at: c.created_at, contentId: c.video_id,  source: "video" as const })),
        ...(tipCommentsRes.data   || []).map((c: any) => ({ id: c.id, name: c.name, comment: c.comment, created_at: c.created_at, contentId: c.tip_id,    source: "tip"   as const })),
      ].sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

      // Group by content item
      const groupMap = new Map<string, ContentGroup>();
      allRaw.forEach((c) => {
        const key = `${c.source}:${c.contentId}`;
        if (!groupMap.has(key)) {
          let title = c.contentId;
          let url   = "#";
          if (c.source === "blog") {
            title = blogMap.get(c.contentId) || c.contentId;
            url   = `/blog/${c.contentId}`;
          } else if (c.source === "meme") {
            title = memeMap.get(c.contentId) || "Meme";
            url   = `/memes/${c.contentId}`;
          } else if (c.source === "video") {
            title = videoMap.get(c.contentId) || "Video";
            url   = `/videos/${c.contentId}`;
          } else if (c.source === "tip") {
            const t = tipMap.get(c.contentId) as { title: string; slug: string } | undefined;
            title = t?.title || "Tip";
            url   = t ? `/automation-tips/${t.slug}` : "#";
          }
          groupMap.set(key, { key, source: c.source, contentId: c.contentId, title, url, comments: [] });
        }
        groupMap.get(key)!.comments.push(c);
      });

      setGroups(Array.from(groupMap.values()));
    } catch {
      setError("Failed to load comments. Check your Supabase tables.");
    }
    setLoading(false);
  }, [supabase]);

  useEffect(() => { fetchData(); }, [fetchData]);

  async function handleDelete(id: string, source: Exclude<Source, "all">, groupKey: string) {
    setDeleting(id);
    setConfirmId(null);
    const table =
      source === "blog"  ? "blog_comments"  :
      source === "meme"  ? "meme_comments"  :
      source === "video" ? "video_comments" : "tip_comments";
    try {
      const { error: err } = await supabase.from(table).delete().eq("id", id);
      if (err) throw err;
      setGroups((prev) =>
        prev.map((g) =>
          g.key === groupKey ? { ...g, comments: g.comments.filter((c) => c.id !== id) } : g
        ).filter((g) => g.comments.length > 0)
      );
    } catch {
      setError("Delete failed. Ensure your Supabase RLS allows authenticated deletes.");
    }
    setDeleting(null);
  }

  /* ── Counts ── */
  const counts: Record<Source, number> = {
    all:   groups.reduce((s, g) => s + g.comments.length, 0),
    blog:  groups.filter((g) => g.source === "blog").reduce((s, g)  => s + g.comments.length, 0),
    meme:  groups.filter((g) => g.source === "meme").reduce((s, g)  => s + g.comments.length, 0),
    video: groups.filter((g) => g.source === "video").reduce((s, g) => s + g.comments.length, 0),
    tip:   groups.filter((g) => g.source === "tip").reduce((s, g)   => s + g.comments.length, 0),
  };

  /* ── Filtered groups ── */
  const filteredGroups = groups
    .filter((g) => activeSource === "all" || g.source === activeSource)
    .map((g) => ({
      ...g,
      comments: g.comments.filter((c) => {
        const q = search.toLowerCase();
        return !q || c.name.toLowerCase().includes(q) || c.comment.toLowerCase().includes(q) || g.title.toLowerCase().includes(q);
      }),
    }))
    .filter((g) => g.comments.length > 0);

  const totalFiltered = filteredGroups.reduce((s, g) => s + g.comments.length, 0);

  /* ── Tabs ── */
  const TABS: { id: Source; label: string }[] = [
    { id: "all",   label: "All" },
    { id: "blog",  label: "Blogs" },
    { id: "meme",  label: "Memes" },
    { id: "video", label: "Videos" },
    { id: "tip",   label: "Tips" },
  ];

  return (
    <div className="max-w-4xl mx-auto space-y-6">

      {/* ── Header ── */}
      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2.5">
            <MessageCircle size={22} className="text-[#00FF88]" /> Comments
          </h1>
          <p className="text-[#6B7280] text-sm mt-1">
            {counts.all} comment{counts.all !== 1 ? "s" : ""} across {groups.length} item{groups.length !== 1 ? "s" : ""}
          </p>
        </div>
        <button
          onClick={fetchData} disabled={loading}
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl border border-white/8 text-[#9CA3AF] hover:text-white hover:border-white/20 text-sm transition-all disabled:opacity-50 flex-shrink-0"
        >
          <RefreshCw size={13} className={loading ? "animate-spin" : ""} /> Refresh
        </button>
      </div>

      {/* ── Source stats cards ── */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {(["blog", "meme", "video", "tip"] as const).map((src) => {
          const cfg = SOURCE_CONFIG[src];
          const Icon = cfg.icon;
          return (
            <button
              key={src}
              onClick={() => setActiveSource(activeSource === src ? "all" : src)}
              className={`rounded-2xl border p-4 text-left transition-all duration-200 ${
                activeSource === src
                  ? `${cfg.bg} ${cfg.border} shadow-[0_0_20px_rgba(0,0,0,0.4)]`
                  : "bg-[#111] border-white/8 hover:border-white/16"
              }`}
            >
              <div className="flex items-center gap-2 mb-2">
                <Icon size={13} className={activeSource === src ? cfg.text : "text-[#6B7280]"} />
                <span className={`text-xs font-bold uppercase tracking-wider ${activeSource === src ? cfg.text : "text-[#6B7280]"}`}>
                  {cfg.label}s
                </span>
              </div>
              <p className={`text-3xl font-black ${activeSource === src ? cfg.text : "text-white"}`}>
                {counts[src]}
              </p>
            </button>
          );
        })}
      </div>

      {/* ── Source filter tabs ── */}
      <div className="flex items-center gap-1 p-1 bg-[#111] border border-white/8 rounded-2xl flex-wrap">
        {TABS.map(({ id, label }) => {
          const isActive = activeSource === id;
          const cfg = id !== "all" ? SOURCE_CONFIG[id as Exclude<Source, "all">] : null;
          return (
            <button
              key={id}
              onClick={() => setActiveSource(id)}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-semibold transition-all flex-1 justify-center min-w-0 ${
                isActive
                  ? id === "all"
                    ? "bg-white text-black"
                    : `${cfg!.bg} ${cfg!.text} border ${cfg!.border}`
                  : "text-[#6B7280] hover:text-white hover:bg-white/5"
              }`}
            >
              {id !== "all" && cfg && <cfg.icon size={13} />}
              <span className="truncate">{label}</span>
              <span className={`text-xs px-1.5 py-0.5 rounded-md font-bold flex-shrink-0 ${
                isActive
                  ? id === "all" ? "bg-black/10 text-black" : "bg-black/20"
                  : "bg-white/8 text-[#6B7280]"
              }`}>
                {counts[id]}
              </span>
            </button>
          );
        })}
      </div>

      {/* ── Error ── */}
      {error && (
        <div className="px-4 py-3 rounded-xl border border-red-500/20 bg-red-500/5 text-red-400 text-xs leading-relaxed">
          {error}
        </div>
      )}

      {/* ── Search ── */}
      <div className="relative">
        <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#4B5563]" />
        <input
          type="text" value={search} onChange={(e) => setSearch(e.target.value)}
          placeholder="Search by commenter, text, or title..."
          className="w-full bg-[#111] border border-white/8 rounded-xl pl-9 pr-4 py-3 text-white text-sm placeholder-[#374151] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
        />
      </div>

      {/* ── Content ── */}
      {loading ? (
        <div className="flex items-center justify-center py-24 text-[#6B7280]">
          <RefreshCw size={20} className="animate-spin mr-3" /> Loading comments…
        </div>
      ) : filteredGroups.length === 0 ? (
        <div className="text-center py-20 border border-dashed border-white/8 rounded-2xl">
          <MessageCircle size={40} className="mx-auto mb-3 text-[#1E1E1E]" />
          <p className="text-[#4B5563] text-sm">
            {search ? "No comments match your search." : `No ${activeSource === "all" ? "" : activeSource + " "}comments yet.`}
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {/* Result summary */}
          <p className="text-xs text-[#4B5563] px-1">
            Showing {totalFiltered} comment{totalFiltered !== 1 ? "s" : ""} across {filteredGroups.length} item{filteredGroups.length !== 1 ? "s" : ""}
          </p>

          {filteredGroups.map((group) => {
            const isOpen = expanded === group.key;
            const cfg = SOURCE_CONFIG[group.source];
            const Icon = cfg.icon;

            return (
              <div
                key={group.key}
                className={`rounded-2xl border transition-all duration-200 overflow-hidden ${
                  isOpen ? `${cfg.border} shadow-[0_0_24px_rgba(0,0,0,0.4)]` : "border-white/8 hover:border-white/14"
                } bg-[#0E0E0E]`}
              >
                {/* Group header row */}
                <button
                  onClick={() => setExpanded(isOpen ? null : group.key)}
                  className="w-full flex items-center gap-4 px-5 py-4 text-left group"
                >
                  {/* Source icon */}
                  <div className={`flex-shrink-0 w-9 h-9 rounded-xl flex items-center justify-center transition-colors border ${
                    isOpen ? `${cfg.bg} ${cfg.text} ${cfg.border}` : "bg-white/[0.04] text-[#6B7280] border-white/8 group-hover:text-white"
                  }`}>
                    <Icon size={15} />
                  </div>

                  {/* Title + source badge */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap mb-0.5">
                      <p className={`font-bold text-sm truncate transition-colors ${isOpen ? cfg.text : "text-white group-hover:text-white/80"}`}>
                        {group.title}
                      </p>
                      <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold border flex-shrink-0 ${cfg.bg} ${cfg.text} ${cfg.border}`}>
                        <Icon size={9} /> {cfg.label}
                      </span>
                    </div>
                    <p className="text-[#4B5563] text-xs font-mono truncate">{group.contentId}</p>
                  </div>

                  {/* Comment count */}
                  <div className={`flex-shrink-0 flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border transition-colors ${
                    isOpen ? `${cfg.bg} ${cfg.text} ${cfg.border}` : "bg-white/[0.06] text-[#9CA3AF] border-white/8"
                  }`}>
                    <MessageCircle size={11} />
                    {group.comments.length}
                  </div>

                  {/* View link */}
                  <Link
                    href={group.url} target="_blank"
                    onClick={(e) => e.stopPropagation()}
                    className={`flex-shrink-0 p-2 rounded-lg transition-all text-[#4B5563] ${isOpen ? `hover:${cfg.text} hover:${cfg.bg}` : "hover:text-white hover:bg-white/8"}`}
                    title="View content"
                  >
                    <ExternalLink size={13} />
                  </Link>

                  <ChevronDown
                    size={16}
                    className={`flex-shrink-0 transition-transform duration-200 ${isOpen ? `rotate-180 ${cfg.text}` : "text-[#4B5563]"}`}
                  />
                </button>

                {/* Expanded comments */}
                {isOpen && (
                  <div className="border-t border-white/5">
                    <div className={`h-[2px] bg-gradient-to-r from-current to-transparent opacity-40 ${cfg.text}`} />
                    <div className="p-4 space-y-3">
                      {group.comments.map((c) => (
                        <div
                          key={c.id}
                          className={`rounded-xl border p-4 transition-all duration-200 ${
                            confirmId === c.id
                              ? "border-red-500/30 bg-red-500/[0.03]"
                              : "border-white/6 bg-white/[0.02] hover:border-white/10"
                          }`}
                        >
                          <div className="flex items-start gap-3">
                            {/* Avatar */}
                            <div className={`flex-shrink-0 w-9 h-9 rounded-full border flex items-center justify-center font-bold text-sm ${cfg.bg} ${cfg.text} ${cfg.border}`}>
                              {c.name.charAt(0).toUpperCase()}
                            </div>

                            {/* Content */}
                            <div className="flex-1 min-w-0">
                              <div className="flex flex-wrap items-center gap-x-2 gap-y-0.5 mb-2">
                                <span className="text-white font-semibold text-sm flex items-center gap-1.5">
                                  <User size={10} className="text-[#6B7280]" />
                                  {c.name}
                                </span>
                                <span className="text-[#374151] text-xs">·</span>
                                <span className="text-[#4B5563] text-xs flex items-center gap-1">
                                  <Calendar size={9} /> {timeAgo(c.created_at)}
                                </span>
                              </div>
                              <p className="text-[#C9D1D9] text-sm leading-relaxed">{c.comment}</p>
                            </div>

                            {/* Delete */}
                            <div className="flex-shrink-0 flex items-center gap-2 ml-2">
                              {confirmId === c.id ? (
                                <>
                                  <button
                                    onClick={() => handleDelete(c.id, group.source, group.key)}
                                    disabled={deleting === c.id}
                                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-red-500 hover:bg-red-600 text-white text-xs font-bold transition-colors disabled:opacity-60"
                                  >
                                    {deleting === c.id ? <RefreshCw size={11} className="animate-spin" /> : <Trash2 size={11} />}
                                    Delete
                                  </button>
                                  <button
                                    onClick={() => setConfirmId(null)}
                                    className="px-3 py-1.5 rounded-lg border border-white/10 text-[#9CA3AF] hover:text-white text-xs transition-colors"
                                  >
                                    Cancel
                                  </button>
                                </>
                              ) : (
                                <button
                                  onClick={() => setConfirmId(c.id)}
                                  className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-red-500/15 text-[#6B7280] hover:text-red-400 hover:bg-red-500/8 hover:border-red-500/25 text-xs transition-all"
                                >
                                  <Trash2 size={11} /> Delete
                                </button>
                              )}
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
