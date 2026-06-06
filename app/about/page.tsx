"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import { Code2, Users, Target, Heart, Rocket, Shield, Laugh, Loader2, Image as ImageIcon, Play, BookOpen } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";

const values = [
  { icon: Code2, title: "Code First", desc: "Real automation code, real examples, no fluff. We write tests that actually run in CI." },
  { icon: Laugh, title: "Meme Culture", desc: "QA pain is universal. We turn the frustration into fuel with relatable humor." },
  { icon: Users, title: "Community", desc: "Testers supporting testers. Share your wins and roast each other's flaky tests." },
  { icon: Shield, title: "Quality Obsessed", desc: "We practice what we preach. Good content, good code, good vibes." },
  { icon: Target, title: "Career Focused", desc: "Real skills, real interviews, real job advice for automation engineers." },
  { icon: Rocket, title: "Always Shipping", desc: "New memes, new tutorials, new chaos every week. Never a dull standup." },
];

interface LiveStats {
  subscribers: number | null;
  memes: number | null;
  videos: number | null;
  tutorials: number | null;
}

function AnimatedCounter({ value }: { value: number }) {
  const [display, setDisplay] = useState(0);
  useEffect(() => {
    if (!value) return;
    const start = Date.now();
    const duration = 1800;
    const step = () => {
      const elapsed = Date.now() - start;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      setDisplay(Math.floor(eased * value));
      if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  }, [value]);
  return <>{display.toLocaleString()}</>;
}

function StatCard({
  icon: Icon, label, value, suffix = "", loading, color,
}: {
  icon: React.ElementType; label: string; value: number | null; suffix?: string;
  loading: boolean; color: string;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="glass-card p-6 text-center group hover:border-white/10 transition-all"
    >
      <div className={`w-10 h-10 rounded-xl flex items-center justify-center mx-auto mb-3 ${color}`}>
        <Icon size={18} />
      </div>
      <div className="text-3xl font-black text-gradient mb-1 min-h-[2.25rem] flex items-center justify-center">
        {loading ? (
          <Loader2 size={20} className="animate-spin text-[#00FF88]" />
        ) : value === null ? (
          <span className="text-[#9CA3AF] text-base">—</span>
        ) : (
          <><AnimatedCounter value={value} />{suffix}</>
        )}
      </div>
      <div className="text-sm text-[#9CA3AF]">{label}</div>
    </motion.div>
  );
}

export default function AboutPage() {
  const [stats, setStats] = useState<LiveStats>({ subscribers: null, memes: null, videos: null, tutorials: null });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      setLoading(true);

      // Fetch YouTube subscribers
      let subscribers: number | null = null;
      try {
        const res = await fetch("/api/analytics/youtube");
        const data = await res.json();
        if (data.stats?.subscribers) subscribers = data.stats.subscribers;
      } catch { /* silent */ }

      // Fetch Supabase counts
      let memes: number | null = null;
      let videos: number | null = null;
      let tutorials: number | null = null;

      if (isSupabaseConfigured()) {
        const supabase = createClient();
        const results = await withTimeout(async () => {
          const [memesRes, videosRes, learnRes] = await Promise.all([
            supabase.from("memes").select("id", { count: "exact", head: true }).eq("published", true),
            supabase.from("videos").select("id", { count: "exact", head: true }).eq("published", true),
            supabase.from("learning_content").select("id", { count: "exact", head: true }).eq("published", true),
          ]);
          return {
            memes: memesRes.count ?? null,
            videos: videosRes.count ?? null,
            tutorials: learnRes.count ?? null,
          };
        }, { memes: null, videos: null, tutorials: null }, 5000);

        memes = results.memes;
        videos = results.videos;
        tutorials = results.tutorials;
      }

      setStats({ subscribers, memes, videos, tutorials });
      setLoading(false);
    };

    fetchStats();
  }, []);

  return (
    <div className="min-h-screen pt-24 pb-20">
      {/* Hero */}
      <div className="relative overflow-hidden py-16 sm:py-24">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(0,255,136,0.06)_0%,transparent_70%)]" />
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative">
          <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.7 }}>
            <h1 className="text-4xl sm:text-6xl font-black text-white mb-6">
              We Are <span className="text-gradient">AutomateQA</span>
            </h1>
            <p className="text-xl text-[#9CA3AF] leading-relaxed max-w-2xl mx-auto">
              Born from the frustration of watching devs say &quot;it works on my machine&quot; one too many times.
              AutomateQA is where QA engineers come to learn, laugh, and survive corporate chaos together.
            </p>
          </motion.div>
        </div>
      </div>

      {/* Live Stats */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 mb-20">
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <StatCard icon={Users}     label="YouTube Subscribers" value={stats.subscribers} loading={loading} color="text-red-400 bg-red-500/10" />
          <StatCard icon={ImageIcon} label="QA Memes"            value={stats.memes}       loading={loading} color="text-pink-400 bg-pink-500/10" />
          <StatCard icon={Play}      label="Videos"              value={stats.videos}      loading={loading} color="text-blue-400 bg-blue-500/10" />
          <StatCard icon={BookOpen}  label="Tutorials"           value={stats.tutorials}   loading={loading} color="text-[#00FF88] bg-[#00FF88]/10" />
        </div>
      </div>

      {/* Story */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 mb-20">
        <div className="glass-card p-8 sm:p-12">
          <h2 className="text-3xl font-black text-white mb-6">The Story</h2>
          <div className="space-y-4 text-[#D1D5DB] leading-relaxed">
            <p>
              AutomateQA started as a personal outlet for QA frustrations. After years of writing Selenium tests,
              attending stand-ups where &quot;it works on staging&quot; means nothing, and watching production deploy on
              a Friday afternoon — we decided to do something about it.
            </p>
            <p>
              We built this platform for every QA engineer who has ever felt like the lone voice of reason in a room
              full of developers. Every tester who has found a critical bug 10 minutes before release. Every automation
              engineer who has fought with flaky tests at 2 AM.
            </p>
            <p>
              Our mission is simple:{" "}
              <span className="text-white font-semibold">
                Make QA engineers better at their craft while laughing at the absurdity of it all.
              </span>
            </p>
            <p>
              Whether you&apos;re learning Playwright from scratch, trying to survive your next sprint planning,
              or just need validation that yes, you&apos;re right and the bug is real — AutomateQA is your home.
            </p>
          </div>
        </div>
      </div>

      {/* Values */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-20">
        <h2 className="text-3xl font-black text-white text-center mb-12">What We Stand For</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {values.map(({ icon: Icon, title, desc }, i) => (
            <motion.div
              key={title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.1 }}
              className="glass-card-hover p-6"
            >
              <div className="w-10 h-10 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center mb-4">
                <Icon size={20} className="text-[#00FF88]" />
              </div>
              <h3 className="font-bold text-white mb-2">{title}</h3>
              <p className="text-[#9CA3AF] text-sm leading-relaxed">{desc}</p>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Vision */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 mb-20">
        <div className="glass-card p-8 sm:p-12 text-center border border-[#00FF88]/10">
          <Heart size={32} className="text-[#00FF88] mx-auto mb-4" />
          <h2 className="text-3xl font-black text-white mb-4">Platform Vision</h2>
          <p className="text-[#9CA3AF] leading-relaxed max-w-2xl mx-auto mb-8">
            We&apos;re building the ultimate QA community platform — a place where automation testing content,
            career resources, and genuine human connection intersect. Think YouTube meets Dev.to meets
            a really good meme account, but specifically for the QA world.
          </p>
          <div className="flex flex-wrap gap-4 justify-center">
            <Link href="/memes" className="btn-primary">Browse Memes</Link>
            <Link href="/videos" className="btn-outline">Watch Videos</Link>
            <Link href="/contact" className="btn-outline">Join the Mission</Link>
          </div>
        </div>
      </div>
    </div>
  );
}
