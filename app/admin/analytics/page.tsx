"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { BarChart3, Eye, Play, Laugh, FileText, BookOpen, Lightbulb, Users, TrendingUp, Loader2, RefreshCw } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell } from "recharts";

interface ContentStats {
  memes: number;
  videos: number;
  blogs: number;
  learn: number;
  tips: number;
  subscribers: number;
}

interface TopContent {
  id: string;
  title: string;
  views: number;
  type: string;
  slug?: string;
}

function StatCard({ icon: Icon, label, value, color, loading }: {
  icon: React.ElementType; label: string; value: number | string; color: string; loading: boolean;
}) {
  return (
    <div className="glass-card p-5">
      <div className={`w-9 h-9 rounded-xl flex items-center justify-center mb-3 ${color}`}>
        <Icon size={16} />
      </div>
      <div className="text-2xl font-black text-white mb-0.5">
        {loading ? <div className="skeleton h-7 w-16 rounded" /> : (typeof value === "number" ? value.toLocaleString() : value)}
      </div>
      <div className="text-xs text-[#9CA3AF]">{label}</div>
    </div>
  );
}

export default function AdminAnalyticsPage() {
  const [stats, setStats] = useState<ContentStats | null>(null);
  const [topLearn, setTopLearn] = useState<TopContent[]>([]);
  const [topTips, setTopTips] = useState<TopContent[]>([]);
  const [topBlogs, setTopBlogs] = useState<TopContent[]>([]);
  const [loading, setLoading] = useState(true);
  const supabase = createClient();

  const fetchAll = async () => {
    setLoading(true);
    try {
      const [memesRes, videosRes, blogsRes, learnRes, tipsRes, subsRes] = await Promise.all([
        supabase.from("memes").select("id", { count: "exact" }),
        supabase.from("videos").select("id", { count: "exact" }),
        supabase.from("blogs").select("id", { count: "exact" }),
        supabase.from("learning_content").select("id", { count: "exact" }),
        supabase.from("automation_tips").select("id", { count: "exact" }),
        supabase.from("subscribers").select("id", { count: "exact" }),
      ]);

      setStats({
        memes: memesRes.count || 0,
        videos: videosRes.count || 0,
        blogs: blogsRes.count || 0,
        learn: learnRes.count || 0,
        tips: tipsRes.count || 0,
        subscribers: subsRes.count || 0,
      });

      const [learnTop, tipsTop, blogsTop] = await Promise.all([
        supabase.from("learning_content").select("id,title,views,slug").order("views", { ascending: false }).limit(5),
        supabase.from("automation_tips").select("id,title,views,slug").order("views", { ascending: false }).limit(5),
        supabase.from("blogs").select("id,title,slug").order("created_at", { ascending: false }).limit(5),
      ]);

      setTopLearn((learnTop.data || []).map((i) => ({ ...i, type: "Tutorial" })));
      setTopTips((tipsTop.data || []).map((i) => ({ ...i, type: "Tip" })));
      setTopBlogs((blogsTop.data || []).map((i) => ({ ...i, views: 0, type: "Blog" })));
    } catch { /* silent */ }
    setLoading(false);
  };

  useEffect(() => { fetchAll(); }, []);

  const chartData = stats ? [
    { name: "Memes", count: stats.memes, fill: "#EC4899" },
    { name: "Videos", count: stats.videos, fill: "#EF4444" },
    { name: "Blogs", count: stats.blogs, fill: "#8B5CF6" },
    { name: "Learn", count: stats.learn, fill: "#00FF88" },
    { name: "Tips", count: stats.tips, fill: "#F59E0B" },
  ] : [];

  return (
    <div className="p-6 max-w-6xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2">
            <BarChart3 size={20} className="text-[#00FF88]" /> Analytics Dashboard
          </h1>
          <p className="text-[#9CA3AF] text-sm mt-0.5">Content overview and performance metrics</p>
        </div>
        <button onClick={fetchAll} disabled={loading} className="flex items-center gap-2 px-4 py-2 rounded-xl border border-white/10 text-[#9CA3AF] hover:text-white text-sm transition-all disabled:opacity-50">
          <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
          Refresh
        </button>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4 mb-8">
        <StatCard icon={Laugh} label="Memes" value={stats?.memes || 0} color="text-pink-400 bg-pink-500/10" loading={loading} />
        <StatCard icon={Play} label="Videos" value={stats?.videos || 0} color="text-red-400 bg-red-500/10" loading={loading} />
        <StatCard icon={FileText} label="Blogs" value={stats?.blogs || 0} color="text-purple-400 bg-purple-500/10" loading={loading} />
        <StatCard icon={BookOpen} label="Tutorials" value={stats?.learn || 0} color="text-[#00FF88] bg-[#00FF88]/10" loading={loading} />
        <StatCard icon={Lightbulb} label="Tips" value={stats?.tips || 0} color="text-yellow-400 bg-yellow-500/10" loading={loading} />
        <StatCard icon={Users} label="Subscribers" value={stats?.subscribers || 0} color="text-blue-400 bg-blue-500/10" loading={loading} />
      </div>

      {/* Content Chart */}
      <div className="glass-card p-6 mb-8">
        <h2 className="text-base font-black text-white mb-5 flex items-center gap-2">
          <TrendingUp size={16} className="text-[#00FF88]" />
          Content Distribution
        </h2>
        {loading ? (
          <div className="h-48 flex items-center justify-center"><Loader2 size={20} className="animate-spin text-[#00FF88]" /></div>
        ) : (
          <div className="h-48">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={chartData} barSize={36}>
                <CartesianGrid strokeDasharray="3 3" stroke="#2A2A2A" />
                <XAxis dataKey="name" tick={{ fill: "#9CA3AF", fontSize: 11 }} axisLine={false} />
                <YAxis tick={{ fill: "#9CA3AF", fontSize: 11 }} axisLine={false} />
                <Tooltip
                  contentStyle={{ background: "#111", border: "1px solid #2A2A2A", borderRadius: 8 }}
                  labelStyle={{ color: "#fff" }}
                  itemStyle={{ color: "#9CA3AF" }}
                  formatter={(val) => [val, "Items"]}
                />
                <Bar dataKey="count" radius={[4, 4, 0, 0]}>
                  {chartData.map((entry, i) => (
                    <Cell key={i} fill={entry.fill} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>

      {/* Top Content Tables */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Top Tutorials by Views */}
        <div className="glass-card p-5">
          <h3 className="text-sm font-black text-white mb-4 flex items-center gap-2">
            <BookOpen size={14} className="text-[#00FF88]" /> Top Tutorials
          </h3>
          {loading ? (
            <div className="space-y-3">{Array.from({ length: 3 }).map((_, i) => <div key={i} className="skeleton h-8 rounded" />)}</div>
          ) : topLearn.length === 0 ? (
            <p className="text-[#9CA3AF] text-sm">No tutorials yet</p>
          ) : (
            <div className="space-y-2">
              {topLearn.map((item, i) => (
                <motion.div key={item.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: i * 0.05 }}
                  className="flex items-center gap-3 p-2 rounded-lg hover:bg-white/5 transition-all">
                  <span className="text-xs font-black text-[#9CA3AF] w-4">{i + 1}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-white text-xs font-medium truncate">{item.title}</p>
                    <p className="text-[#9CA3AF] text-[10px]">{item.views.toLocaleString()} views</p>
                  </div>
                  <Eye size={10} className="text-[#9CA3AF] flex-shrink-0" />
                </motion.div>
              ))}
            </div>
          )}
        </div>

        {/* Top Tips by Views */}
        <div className="glass-card p-5">
          <h3 className="text-sm font-black text-white mb-4 flex items-center gap-2">
            <Lightbulb size={14} className="text-yellow-400" /> Top Tips
          </h3>
          {loading ? (
            <div className="space-y-3">{Array.from({ length: 3 }).map((_, i) => <div key={i} className="skeleton h-8 rounded" />)}</div>
          ) : topTips.length === 0 ? (
            <p className="text-[#9CA3AF] text-sm">No tips yet</p>
          ) : (
            <div className="space-y-2">
              {topTips.map((item, i) => (
                <motion.div key={item.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: i * 0.05 }}
                  className="flex items-center gap-3 p-2 rounded-lg hover:bg-white/5 transition-all">
                  <span className="text-xs font-black text-[#9CA3AF] w-4">{i + 1}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-white text-xs font-medium truncate">{item.title}</p>
                    <p className="text-[#9CA3AF] text-[10px]">{item.views.toLocaleString()} views</p>
                  </div>
                  <Eye size={10} className="text-[#9CA3AF] flex-shrink-0" />
                </motion.div>
              ))}
            </div>
          )}
        </div>

        {/* Recent Blogs */}
        <div className="glass-card p-5">
          <h3 className="text-sm font-black text-white mb-4 flex items-center gap-2">
            <FileText size={14} className="text-purple-400" /> Recent Blogs
          </h3>
          {loading ? (
            <div className="space-y-3">{Array.from({ length: 3 }).map((_, i) => <div key={i} className="skeleton h-8 rounded" />)}</div>
          ) : topBlogs.length === 0 ? (
            <p className="text-[#9CA3AF] text-sm">No blogs yet</p>
          ) : (
            <div className="space-y-2">
              {topBlogs.map((item, i) => (
                <motion.div key={item.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: i * 0.05 }}
                  className="flex items-center gap-3 p-2 rounded-lg hover:bg-white/5 transition-all">
                  <span className="text-xs font-black text-[#9CA3AF] w-4">{i + 1}</span>
                  <p className="text-white text-xs font-medium truncate flex-1">{item.title}</p>
                </motion.div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
