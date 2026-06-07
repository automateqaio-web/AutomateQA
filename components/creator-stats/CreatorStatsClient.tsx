"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Image from "next/image";
import {
  Play, Users, Eye, TrendingUp, Heart, MessageCircle,
  ExternalLink, Loader2, RefreshCw, Clock, Flame, Star, Bell, Tv2
} from "lucide-react";

function YoutubeLogo({ size = 16, className = "" }: { size?: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" className={className}>
      <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
    </svg>
  );
}

const channelContent = [
  { emoji: "🎭", title: "QA Memes", desc: "Weekly dose of relatable testing humor" },
  { emoji: "🎬", title: "Playwright Tutorials", desc: "Step-by-step automation with real examples" },
  { emoji: "💡", title: "Selenium & API Tips", desc: "Practical tips for automation engineers" },
];

function YouTubeChannelCard() {
  return (
    <motion.div
      initial={{ opacity: 0, y: 30 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, delay: 0.1 }}
    >
      <div className="relative rounded-3xl border border-red-500/20 overflow-hidden bg-gradient-to-br from-[#111]/95 via-[#0e0e0e] to-[#0a0a0a] shadow-[0_0_60px_rgba(239,68,68,0.08)]">
        {/* Top accent line */}
        <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-red-500/70 to-transparent" />

        {/* Background glow blobs */}
        <div className="absolute -top-16 left-1/4 w-72 h-48 bg-red-500/6 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 right-0 w-48 h-32 bg-red-600/5 rounded-full blur-2xl pointer-events-none" />

        <div className="relative z-10 p-6 sm:p-10">
          {/* Header: avatar + info + CTA */}
          <div className="flex flex-col sm:flex-row sm:items-center gap-6 sm:gap-10 mb-8">
            {/* Avatar block */}
            <div className="flex items-center gap-5">
              <div className="relative flex-shrink-0">
                <div className="w-20 h-20 sm:w-24 sm:h-24 rounded-full overflow-hidden ring-2 ring-red-500/40 shadow-[0_0_32px_rgba(239,68,68,0.35)]">
                  <Image src="/logo.png" alt="AutomateQA YouTube channel" width={96} height={96} className="object-cover" />
                </div>
                {/* YouTube play badge */}
                <div className="absolute -bottom-1 -right-1 w-7 h-7 rounded-full bg-red-600 border-2 border-[#0a0a0a] flex items-center justify-center shadow-lg shadow-red-600/40">
                  <Play size={10} className="text-white fill-white ml-px" />
                </div>
              </div>

              <div>
                <span className="inline-flex items-center gap-1.5 text-[10px] font-black text-red-400 bg-red-500/10 border border-red-500/25 px-2.5 py-1 rounded-full uppercase tracking-widest mb-2">
                  <Tv2 size={9} /> YouTube
                </span>
                <h2 className="text-2xl sm:text-3xl font-black text-white leading-tight tracking-tight">AutomateQA</h2>
                <p className="text-[#6B7280] text-sm font-mono mt-0.5">@automateqa</p>
                <p className="text-[#9CA3AF] text-sm mt-2 leading-relaxed hidden sm:block max-w-xs">
                  QA memes, Playwright tutorials &amp; real corporate chaos — every week.
                </p>
              </div>
            </div>

            {/* CTA buttons */}
            <div className="sm:ml-auto flex items-center gap-3 flex-wrap">
              <a
                href="https://www.youtube.com/@automateqa?sub_confirmation=1"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-red-600 hover:bg-red-500 text-white text-sm font-black transition-all duration-200 hover:shadow-[0_0_28px_rgba(239,68,68,0.5)] active:scale-95"
              >
                <Bell size={14} className="fill-white stroke-none" />
                Subscribe
              </a>
              <a
                href="https://www.youtube.com/@automateqa"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-5 py-3 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 hover:border-white/25 text-[#9CA3AF] hover:text-white text-sm font-semibold transition-all duration-200"
              >
                <ExternalLink size={14} />
                Visit Channel
              </a>
            </div>
          </div>

          {/* Mobile description */}
          <p className="text-[#9CA3AF] text-sm mb-6 sm:hidden leading-relaxed">
            QA memes, Playwright tutorials &amp; real corporate chaos — every week.
          </p>

          {/* Content type cards */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 pt-6 border-t border-white/[0.06]">
            {channelContent.map(({ emoji, title, desc }) => (
              <div key={title} className="flex items-start gap-3.5 p-4 rounded-2xl bg-white/[0.025] border border-white/[0.06] hover:border-red-500/25 hover:bg-red-500/[0.04] transition-all duration-300 group cursor-default">
                <span className="text-xl mt-0.5 flex-shrink-0">{emoji}</span>
                <div>
                  <div className="text-sm font-black text-white group-hover:text-red-300 transition-colors mb-0.5">{title}</div>
                  <div className="text-xs text-[#6B7280] leading-relaxed">{desc}</div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Bottom accent */}
        <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-white/5 to-transparent" />
      </div>
    </motion.div>
  );
}
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer,
} from "recharts";

interface YTStats {
  subscribers: number;
  total_views: number;
  total_videos: number;
  watch_hours: number;
}

interface VideoItem {
  id: string;
  title: string;
  thumbnail: string;
  views: number;
  likes: number;
  comments: number;
  published_at?: string;
  url: string;
}

function AnimatedCounter({ value, duration = 2000 }: { value: number; duration?: number }) {
  const [display, setDisplay] = useState(0);
  useEffect(() => {
    if (!value) return;
    const start = Date.now();
    const step = () => {
      const elapsed = Date.now() - start;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      setDisplay(Math.floor(eased * value));
      if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  }, [value, duration]);
  return <>{display.toLocaleString()}</>;
}

function StatCard({ icon: Icon, label, value, sub, gradient, delay }: {
  icon: React.ElementType; label: string; value: number; sub?: string;
  gradient: string; delay: number;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 30 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay }}
      className="relative overflow-hidden rounded-2xl border border-white/10 p-6 group hover:border-white/20 transition-all duration-300"
      style={{ background: "rgba(255,255,255,0.03)" }}
    >
      {/* Gradient glow */}
      <div className={`absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 ${gradient}`} />
      <div className="relative z-10">
        <div className={`w-11 h-11 rounded-2xl flex items-center justify-center mb-4 ${gradient} opacity-80`}>
          <Icon size={20} className="text-white" />
        </div>
        <div className="text-3xl font-black text-white mb-1 tracking-tight">
          <AnimatedCounter value={value} />
          {sub && <span className="text-lg font-bold text-white/60 ml-1">{sub}</span>}
        </div>
        <div className="text-sm text-[#9CA3AF] font-medium">{label}</div>
      </div>
    </motion.div>
  );
}

function ViralBadge({ rank }: { rank: number }) {
  if (rank === 0) return (
    <div className="absolute top-2 left-2 flex items-center gap-1 px-2 py-1 rounded-lg bg-yellow-500 text-black text-[10px] font-black">
      <Star size={9} fill="currentColor" /> #1
    </div>
  );
  if (rank === 1) return (
    <div className="absolute top-2 left-2 px-2 py-1 rounded-lg bg-gray-400 text-black text-[10px] font-black">#2</div>
  );
  if (rank === 2) return (
    <div className="absolute top-2 left-2 px-2 py-1 rounded-lg bg-amber-700 text-white text-[10px] font-black">#3</div>
  );
  return (
    <div className="absolute top-2 left-2 px-2 py-1 rounded-lg bg-black/60 text-white text-[10px] font-bold">#{rank + 1}</div>
  );
}

function VideoCard({ video, index, showRank = false }: { video: VideoItem; index: number; showRank?: boolean }) {
  return (
    <motion.a
      href={video.url}
      target="_blank"
      rel="noopener noreferrer"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.1 + index * 0.06 }}
      className="group block"
    >
      <div className="rounded-2xl overflow-hidden border border-white/8 hover:border-red-500/40 transition-all duration-300 hover:shadow-[0_0_30px_rgba(239,68,68,0.15)]"
        style={{ background: "rgba(255,255,255,0.03)" }}>
        {/* Thumbnail */}
        <div className="relative aspect-video overflow-hidden">
          <img
            src={video.thumbnail}
            alt={video.title}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            loading="lazy"
          />
          {/* Dark overlay on hover */}
          <div className="absolute inset-0 bg-black/50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
            <div className="w-12 h-12 rounded-full bg-red-500 flex items-center justify-center shadow-lg shadow-red-500/50">
              <Play size={18} className="text-white ml-1" fill="white" />
            </div>
          </div>
          {/* View count pill */}
          <div className="absolute bottom-2 right-2 px-2 py-0.5 rounded-md bg-black/80 text-white text-[10px] font-semibold flex items-center gap-1">
            <Eye size={9} /> {(video.views ?? 0).toLocaleString()}
          </div>
          {showRank && <ViralBadge rank={index} />}
        </div>
        {/* Info */}
        <div className="p-3">
          <h4 className="text-white text-xs font-semibold line-clamp-2 mb-2 group-hover:text-red-400 transition-colors leading-relaxed">
            {video.title}
          </h4>
          <div className="flex items-center gap-3 text-[10px] text-[#9CA3AF]">
            <span className="flex items-center gap-1"><Heart size={9} className="text-red-400" />{(video.likes ?? 0).toLocaleString()}</span>
            <span className="flex items-center gap-1"><MessageCircle size={9} className="text-blue-400" />{(video.comments ?? 0).toLocaleString()}</span>
            <span className="ml-auto flex items-center gap-1 text-[#9CA3AF]"><ExternalLink size={8} />Watch</span>
          </div>
        </div>
      </div>
    </motion.a>
  );
}

export default function CreatorStatsClient() {
  const [ytStats, setYtStats] = useState<YTStats | null>(null);
  const [ytVideos, setYtVideos] = useState<VideoItem[]>([]);
  const [ytLatest, setYtLatest] = useState<VideoItem[]>([]);
  const [bannerUrl, setBannerUrl] = useState<string>("");
  const [loading, setLoading] = useState(true);
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null);

  const fetchYT = async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/analytics/youtube");
      const data = await res.json();
      if (data.stats) setYtStats(data.stats);
      if (data.latest?.length) setYtLatest(data.latest);
      if (data.videos?.length) setYtVideos(data.videos);
      if (data.bannerUrl) setBannerUrl(data.bannerUrl);
    } catch { /* silent */ }
    setLoading(false);
    setLastUpdated(new Date());
  };

  useEffect(() => { fetchYT(); }, []);

  // Build growth chart from snapshots (empty until Supabase connected)
  const growthData = [
    { month: "Jan", views: 0, subscribers: 0 },
    { month: "Feb", views: 0, subscribers: 0 },
    { month: "Mar", views: 0, subscribers: 0 },
    { month: "Apr", views: 0, subscribers: 0 },
    { month: "May", views: 0, subscribers: 0 },
    { month: "Jun", views: ytStats?.total_views || 0, subscribers: ytStats?.subscribers || 0 },
  ];

  return (
    <div className="min-h-screen pt-20 bg-[#0B0B0B]">
      {/* Hero Banner */}
      <div className="relative overflow-hidden min-h-[420px] flex items-center">
        {/* Banner image — right-aligned so it peeks behind text */}
        <img
          src={bannerUrl || "/youtube-banner.jpg"}
          alt="Channel banner"
          className="absolute inset-0 w-full h-full object-cover object-center"
          onError={(e) => { (e.currentTarget as HTMLImageElement).style.display = "none"; }}
        />

        {/* Layer 1: heavy dark-left gradient — makes left text crisp */}
        <div className="absolute inset-0 bg-gradient-to-r from-[#0B0B0B] via-[#0B0B0B]/85 to-[#0B0B0B]/10" />
        {/* Layer 2: top + bottom vignette for depth */}
        <div className="absolute inset-0 bg-gradient-to-b from-[#0B0B0B]/60 via-transparent to-[#0B0B0B]" />
        {/* Layer 3: subtle red glow bottom-left for branding */}
        <div className="absolute bottom-0 left-0 w-[500px] h-48 bg-red-600/10 blur-[80px] pointer-events-none" />

        <div className="relative z-10 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          <div className="max-w-xl">
            {/* Live badge */}
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-red-500/40 bg-red-500/10 backdrop-blur-sm text-red-400 text-xs font-bold mb-6 tracking-widest"
            >
              <YoutubeLogo size={12} />
              YOUTUBE ANALYTICS
              <span className="w-1.5 h-1.5 rounded-full bg-red-400 animate-pulse" />
            </motion.div>

            <motion.h1
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              className="text-5xl sm:text-6xl lg:text-7xl font-black text-white mb-4 leading-[1.05] tracking-tight"
            >
              Creator
              <span className="block bg-gradient-to-r from-red-400 via-orange-400 to-yellow-400 bg-clip-text text-transparent">
                Dashboard
              </span>
            </motion.h1>

            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.2 }}
              className="text-[#9CA3AF] text-base mb-8 leading-relaxed"
            >
              Live channel analytics powered by the YouTube Data API v3.
            </motion.p>

            {/* CTA buttons */}
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="flex items-center gap-3 flex-wrap"
            >
              <a
                href="https://youtube.com/channel/UCx9OoBSJyZYdPpg5erlq7Xg"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-red-500 hover:bg-red-600 text-white text-sm font-bold transition-all shadow-lg shadow-red-500/40 hover:shadow-red-500/60 hover:scale-105"
              >
                <YoutubeLogo size={16} className="text-white" />
                Visit Channel
              </a>
              <button
                onClick={fetchYT}
                disabled={loading}
                className="inline-flex items-center gap-2 px-5 py-3 rounded-xl border border-white/15 bg-white/5 backdrop-blur-sm hover:border-white/30 hover:bg-white/10 text-white text-sm font-semibold transition-all disabled:opacity-40"
              >
                <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
                Refresh
              </button>
            </motion.div>

            {lastUpdated && (
              <p className="text-xs text-white/30 mt-5 flex items-center gap-1.5">
                <Clock size={10} />
                Last updated: {lastUpdated.toLocaleTimeString()}
              </p>
            )}
          </div>
        </div>

        {/* Bottom fade into page */}
        <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-[#0B0B0B] to-transparent pointer-events-none" />
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-12">

        {/* YouTube Channel Promo Card */}
        <YouTubeChannelCard />

        {/* Loading state */}
        {loading && !ytStats && (
          <div className="flex flex-col items-center justify-center py-20 gap-4">
            <div className="w-16 h-16 rounded-2xl bg-red-500/10 flex items-center justify-center">
              <Loader2 size={28} className="animate-spin text-red-400" />
            </div>
            <p className="text-[#9CA3AF]">Fetching live YouTube analytics...</p>
          </div>
        )}

        {ytStats && (
          <>
            {/* Stats Grid */}
            <div>
              <motion.h2
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-xs font-bold text-[#9CA3AF] uppercase tracking-widest mb-5 flex items-center gap-2"
              >
                <span className="w-6 h-px bg-red-500" />
                Channel Overview
              </motion.h2>
              <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
                <StatCard icon={Users} label="Subscribers" value={ytStats.subscribers} gradient="bg-gradient-to-br from-red-500/20 to-red-600/10" delay={0.1} />
                <StatCard icon={Eye} label="Total Views" value={ytStats.total_views} gradient="bg-gradient-to-br from-blue-500/20 to-blue-600/10" delay={0.15} />
                <StatCard icon={Play} label="Total Videos" value={ytStats.total_videos} gradient="bg-gradient-to-br from-[#00FF88]/20 to-emerald-600/10" delay={0.2} />
                <StatCard icon={Clock} label="Est. Watch Hours" value={Math.round(ytStats.total_views * 2.5 / 60)} sub="hrs" gradient="bg-gradient-to-br from-purple-500/20 to-purple-600/10" delay={0.25} />
              </div>
            </div>

            {/* Growth Chart */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="rounded-2xl border border-white/8 p-6"
              style={{ background: "rgba(255,255,255,0.02)" }}
            >
              <div className="flex items-center justify-between mb-6">
                <div>
                  <h3 className="text-base font-black text-white flex items-center gap-2">
                    <TrendingUp size={16} className="text-[#00FF88]" />
                    Growth Trends
                  </h3>
                  <p className="text-xs text-[#9CA3AF] mt-1">Accumulated from periodic DB snapshots</p>
                </div>
              </div>
              <div className="h-52">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={growthData} margin={{ top: 5, right: 10, left: -20, bottom: 0 }}>
                    <defs>
                      <linearGradient id="viewsGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#EF4444" stopOpacity={0.4} />
                        <stop offset="95%" stopColor="#EF4444" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" stroke="#ffffff08" />
                    <XAxis dataKey="month" tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
                    <YAxis tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
                    <Tooltip
                      contentStyle={{ background: "#111", border: "1px solid rgba(255,255,255,0.1)", borderRadius: 12, boxShadow: "0 20px 40px rgba(0,0,0,0.5)" }}
                      labelStyle={{ color: "#fff", fontWeight: 700 }}
                      itemStyle={{ color: "#9CA3AF" }}
                    />
                    <Area type="monotone" dataKey="views" stroke="#EF4444" fill="url(#viewsGrad)" strokeWidth={2} name="Views" dot={false} />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </motion.div>

            {/* Latest Uploads */}
            {ytLatest.length > 0 && (
              <div>
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.35 }}
                  className="flex items-center justify-between mb-5"
                >
                  <h2 className="text-base font-black text-white flex items-center gap-2">
                    <Clock size={16} className="text-blue-400" />
                    Latest Uploads
                  </h2>
                </motion.div>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
                  {ytLatest.map((v, i) => (
                    <VideoCard key={v.id} video={v} index={i} />
                  ))}
                </div>
              </div>
            )}

            {/* Most Viral Videos */}
            {ytVideos.length > 0 && (
              <div>
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.4 }}
                  className="flex items-center justify-between mb-5"
                >
                  <h2 className="text-base font-black text-white flex items-center gap-2">
                    <Flame size={16} className="text-orange-400" />
                    Most Viral Videos
                    <span className="text-xs font-normal text-[#9CA3AF]">Sorted by views</span>
                  </h2>
                </motion.div>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
                  {ytVideos.slice(0, 6).map((v, i) => (
                    <VideoCard key={v.id} video={v} index={i} showRank />
                  ))}
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}
