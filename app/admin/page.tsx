"use client";

import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import { Laugh, Play, FileText, Users, TrendingUp, ArrowUpRight, Clock, Eye } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { formatRelativeDate } from "@/lib/utils";

interface Stats {
  memes: number;
  videos: number;
  blogs: number;
  subscribers: number;
}

interface RecentItem {
  id: string;
  title: string;
  type: "meme" | "video" | "blog";
  created_at: string;
}

function StatCard({ icon: Icon, label, value, href, color }: { icon: any; label: string; value: number; href: string; color: string }) {
  return (
    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
      <Link href={href} className="group block">
        <div className="glass-card p-6 hover:border-white/10 transition-all duration-300 group-hover:shadow-lg">
          <div className="flex items-start justify-between mb-4">
            <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${color}`}>
              <Icon size={20} />
            </div>
            <ArrowUpRight size={16} className="text-[#9CA3AF] group-hover:text-[#00FF88] transition-colors" />
          </div>
          <div className="text-3xl font-black text-white mb-1">{value.toLocaleString()}</div>
          <div className="text-sm text-[#9CA3AF]">{label}</div>
        </div>
      </Link>
    </motion.div>
  );
}

export default function AdminDashboard() {
  const [stats, setStats] = useState<Stats>({ memes: 0, videos: 0, blogs: 0, subscribers: 0 });
  const [recent, setRecent] = useState<RecentItem[]>([]);
  const [loading, setLoading] = useState(true);
  const supabase = createClient();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [memesCount, videosCount, blogsCount, subsCount, recentMemes, recentVideos, recentBlogs] = await Promise.all([
          supabase.from("memes").select("id", { count: "exact", head: true }),
          supabase.from("videos").select("id", { count: "exact", head: true }),
          supabase.from("blogs").select("id", { count: "exact", head: true }),
          supabase.from("subscribers").select("id", { count: "exact", head: true }),
          supabase.from("memes").select("id, title, created_at").order("created_at", { ascending: false }).limit(3),
          supabase.from("videos").select("id, title, created_at").order("created_at", { ascending: false }).limit(3),
          supabase.from("blogs").select("id, title, created_at").order("created_at", { ascending: false }).limit(3),
        ]);

        setStats({
          memes: memesCount.count || 0,
          videos: videosCount.count || 0,
          blogs: blogsCount.count || 0,
          subscribers: subsCount.count || 0,
        });

        const recentItems: RecentItem[] = [
          ...(recentMemes.data || []).map((m) => ({ ...m, type: "meme" as const })),
          ...(recentVideos.data || []).map((v) => ({ ...v, type: "video" as const })),
          ...(recentBlogs.data || []).map((b) => ({ ...b, type: "blog" as const })),
        ].sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime()).slice(0, 6);

        setRecent(recentItems);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const typeConfig = {
    meme: { label: "Meme", icon: Laugh, color: "text-[#00FF88] bg-[#00FF88]/10", href: "/admin/memes" },
    video: { label: "Video", icon: Play, color: "text-red-400 bg-red-500/10", href: "/admin/videos" },
    blog: { label: "Blog", icon: FileText, color: "text-blue-400 bg-blue-500/10", href: "/admin/blogs" },
  };

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-black text-white">Dashboard</h1>
        <p className="text-[#9CA3AF] mt-1">Welcome back. Here&apos;s what&apos;s happening.</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <StatCard icon={Laugh} label="Total Memes" value={stats.memes} href="/admin/memes" color="text-[#00FF88] bg-[#00FF88]/10 border border-[#00FF88]/20" />
        <StatCard icon={Play} label="Total Videos" value={stats.videos} href="/admin/videos" color="text-red-400 bg-red-500/10 border border-red-500/20" />
        <StatCard icon={FileText} label="Total Blogs" value={stats.blogs} href="/admin/blogs" color="text-blue-400 bg-blue-500/10 border border-blue-500/20" />
        <StatCard icon={Users} label="Subscribers" value={stats.subscribers} href="/admin" color="text-purple-400 bg-purple-500/10 border border-purple-500/20" />
      </div>

      {/* Quick actions */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        {[
          { href: "/admin/memes", icon: Laugh, label: "Upload Meme", color: "bg-[#00FF88] text-black" },
          { href: "/admin/videos", icon: Play, label: "Add Video", color: "bg-red-500 text-white" },
          { href: "/admin/blogs", icon: FileText, label: "Write Blog", color: "bg-blue-500 text-white" },
        ].map(({ href, icon: Icon, label, color }) => (
          <Link key={href} href={href}>
            <div className={`flex items-center justify-center gap-2 p-4 rounded-xl font-semibold text-sm transition-all hover:opacity-90 cursor-pointer ${color}`}>
              <Icon size={16} />
              {label}
            </div>
          </Link>
        ))}
      </div>

      {/* Recent activity */}
      <div className="glass-card">
        <div className="flex items-center justify-between p-6 border-b border-white/5">
          <h2 className="font-bold text-white flex items-center gap-2">
            <Clock size={16} className="text-[#9CA3AF]" />
            Recent Uploads
          </h2>
        </div>
        {loading ? (
          <div className="p-6 space-y-3">
            {Array.from({ length: 4 }).map((_, i) => <div key={i} className="skeleton h-12 rounded-xl" />)}
          </div>
        ) : recent.length === 0 ? (
          <div className="p-12 text-center text-[#9CA3AF]">No content yet. Start uploading!</div>
        ) : (
          <div className="divide-y divide-white/5">
            {recent.map((item) => {
              const config = typeConfig[item.type];
              const Icon = config.icon;
              return (
                <Link key={`${item.type}-${item.id}`} href={config.href} className="flex items-center gap-4 p-4 hover:bg-white/2 transition-colors">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${config.color}`}>
                    <Icon size={14} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-white truncate">{item.title}</p>
                    <p className="text-xs text-[#9CA3AF]">{config.label}</p>
                  </div>
                  <span className="text-xs text-[#9CA3AF] flex-shrink-0">{formatRelativeDate(item.created_at)}</span>
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
