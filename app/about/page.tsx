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

      {/* Social Links */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 mb-20">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center mb-10"
        >
          <h2 className="text-3xl font-black text-white mb-3">Find Us On</h2>
          <p className="text-[#9CA3AF] text-sm">Follow along for memes, tutorials, and QA chaos every week.</p>
        </motion.div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
          {/* YouTube */}
          <motion.a
            href="https://www.youtube.com/@automateqa?sub_confirmation=1"
            target="_blank"
            rel="noopener noreferrer"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.05 }}
            className="group relative overflow-hidden rounded-2xl border border-red-500/20 bg-gradient-to-br from-white/[0.03] to-transparent p-6 hover:border-red-500/50 hover:shadow-[0_0_30px_rgba(239,68,68,0.12)] transition-all duration-300"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-red-500/0 to-red-500/0 group-hover:from-red-500/5 group-hover:to-transparent transition-all duration-300 pointer-events-none" />
            <div className="relative z-10 flex flex-col items-center text-center gap-4">
              <div className="w-14 h-14 rounded-2xl bg-red-500/10 border border-red-500/20 flex items-center justify-center group-hover:bg-red-500/20 group-hover:scale-110 transition-all duration-300">
                <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor" className="text-red-400">
                  <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                </svg>
              </div>
              <div>
                <div className="text-white font-black text-lg mb-0.5">YouTube</div>
                <div className="text-[#6B7280] text-xs font-mono mb-3">@automateqa</div>
                <div className="text-[#9CA3AF] text-xs leading-relaxed">Playwright tutorials, QA memes &amp; corporate chaos — every week.</div>
              </div>
              <span className="inline-flex items-center gap-1.5 text-xs font-bold text-red-400 bg-red-500/10 border border-red-500/20 px-3 py-1.5 rounded-full group-hover:bg-red-500/20 transition-colors">
                Subscribe →
              </span>
            </div>
          </motion.a>

          {/* Instagram */}
          <motion.a
            href="https://www.instagram.com/automateqa.memes"
            target="_blank"
            rel="noopener noreferrer"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.1 }}
            className="group relative overflow-hidden rounded-2xl border border-pink-500/20 bg-gradient-to-br from-white/[0.03] to-transparent p-6 hover:border-pink-500/50 hover:shadow-[0_0_30px_rgba(236,72,153,0.12)] transition-all duration-300"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-pink-500/0 to-purple-500/0 group-hover:from-pink-500/5 group-hover:to-purple-500/5 transition-all duration-300 pointer-events-none" />
            <div className="relative z-10 flex flex-col items-center text-center gap-4">
              <div className="w-14 h-14 rounded-2xl bg-pink-500/10 border border-pink-500/20 flex items-center justify-center group-hover:bg-pink-500/20 group-hover:scale-110 transition-all duration-300">
                <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor" className="text-pink-400">
                  <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                </svg>
              </div>
              <div>
                <div className="text-white font-black text-lg mb-0.5">Instagram</div>
                <div className="text-[#6B7280] text-xs font-mono mb-3">@automateqa.online</div>
                <div className="text-[#9CA3AF] text-xs leading-relaxed">QA Reels, meme drops &amp; behind-the-tests content daily.</div>
              </div>
              <span className="inline-flex items-center gap-1.5 text-xs font-bold text-pink-400 bg-pink-500/10 border border-pink-500/20 px-3 py-1.5 rounded-full group-hover:bg-pink-500/20 transition-colors">
                Follow →
              </span>
            </div>
          </motion.a>

          {/* Facebook */}
          <motion.a
            href="https://www.facebook.com/people/Automate-QA/61590680690708/?mibextid=wwXIfr&rdid=g6rV6XD2Nx4Q1vHf&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1D9b4HsLFm%2F%3Fmibextid%3DwwXIfr"
            target="_blank"
            rel="noopener noreferrer"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.15 }}
            className="group relative overflow-hidden rounded-2xl border border-blue-500/20 bg-gradient-to-br from-white/[0.03] to-transparent p-6 hover:border-blue-500/50 hover:shadow-[0_0_30px_rgba(59,130,246,0.12)] transition-all duration-300"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-blue-500/0 to-blue-500/0 group-hover:from-blue-500/5 group-hover:to-transparent transition-all duration-300 pointer-events-none" />
            <div className="relative z-10 flex flex-col items-center text-center gap-4">
              <div className="w-14 h-14 rounded-2xl bg-blue-500/10 border border-blue-500/20 flex items-center justify-center group-hover:bg-blue-500/20 group-hover:scale-110 transition-all duration-300">
                <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor" className="text-blue-400">
                  <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                </svg>
              </div>
              <div>
                <div className="text-white font-black text-lg mb-0.5">Facebook</div>
                <div className="text-[#6B7280] text-xs font-mono mb-3">Automate QA</div>
                <div className="text-[#9CA3AF] text-xs leading-relaxed">Community discussions, announcements &amp; full-length tutorial shares.</div>
              </div>
              <span className="inline-flex items-center gap-1.5 text-xs font-bold text-blue-400 bg-blue-500/10 border border-blue-500/20 px-3 py-1.5 rounded-full group-hover:bg-blue-500/20 transition-colors">
                Like Page →
              </span>
            </div>
          </motion.a>
        </div>
      </div>
    </div>
  );
}
