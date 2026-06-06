"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import { Play, Laugh, BookOpen, ArrowRight, Terminal } from "lucide-react";
import Image from "next/image";

const floatingElements = [
  { text: "npm test", x: "10%", y: "20%", delay: 0 },
  { text: "expect(bug).toBe(fixed)", x: "75%", y: "15%", delay: 0.5 },
  { text: "git blame", x: "85%", y: "60%", delay: 1 },
  { text: "it works on my machine", x: "5%", y: "70%", delay: 1.5 },
  { text: "LGTM 🚀", x: "65%", y: "80%", delay: 0.8 },
];

function AnimatedNumber({ value, suffix = "" }: { value: number | null; suffix?: string }) {
  const [display, setDisplay] = useState(0);

  useEffect(() => {
    if (!value) return;
    const duration = 1600;
    const start = Date.now();
    const step = () => {
      const elapsed = Date.now() - start;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      setDisplay(Math.floor(eased * value));
      if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  }, [value]);

  if (value === null) return <span className="text-[#9CA3AF]">—</span>;
  return <>{display.toLocaleString()}{suffix}</>;
}

export default function HeroSection() {
  const [stats, setStats] = useState<{
    subscribers: number | null;
    memes: number | null;
    videos: number | null;
    tutorials: number | null;
  }>({ subscribers: null, memes: null, videos: null, tutorials: null });

  useEffect(() => {
    const CACHE_KEY = "aq_home_stats";
    const CACHE_TTL = 10 * 60 * 1000; // 10 minutes

    const cached = sessionStorage.getItem(CACHE_KEY);
    if (cached) {
      try {
        const { data, ts } = JSON.parse(cached);
        if (Date.now() - ts < CACHE_TTL) {
          setStats(data);
          return;
        }
      } catch { /* stale */ }
    }

    fetch("/api/home-stats")
      .then((r) => r.json())
      .then((data) => {
        setStats(data);
        sessionStorage.setItem(CACHE_KEY, JSON.stringify({ data, ts: Date.now() }));
      })
      .catch(() => {});
  }, []);

  const statItems = [
    { key: "subscribers", value: stats.subscribers, label: "Subscribers", suffix: "" },
    { key: "memes",       value: stats.memes,       label: "QA Memes",    suffix: "" },
    { key: "videos",      value: stats.videos,      label: "Videos",      suffix: "" },
    { key: "tutorials",   value: stats.tutorials,   label: "Tutorials",   suffix: "" },
  ];

  return (
    <section className="relative flex items-center justify-center overflow-hidden">
      {/* Animated grid background */}
      <div className="absolute inset-0 grid-bg opacity-50" />

      {/* Gradient overlay */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,rgba(0,255,136,0.08)_0%,transparent_60%),radial-gradient(ellipse_at_bottom_right,rgba(0,212,255,0.05)_0%,transparent_60%)]" />

      {/* Floating terminal snippets */}
      {floatingElements.map((el, i) => (
        <motion.div
          key={i}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: el.delay + 1, duration: 0.8 }}
          className="absolute hidden lg:block"
          style={{ left: el.x, top: el.y }}
        >
          <motion.div
            animate={{ y: [0, -10, 0] }}
            transition={{ duration: 4 + i, repeat: Infinity, ease: "easeInOut" }}
            className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-[#111]/80 border border-[#00FF88]/20 backdrop-blur-sm"
          >
            <Terminal size={10} className="text-[#00FF88]" />
            <code className="text-[10px] text-[#00FF88]/80 font-mono">{el.text}</code>
          </motion.div>
        </motion.div>
      ))}

      {/* Glowing orbs */}
      <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-[#00FF88]/5 rounded-full blur-3xl animate-pulse" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-[#00D4FF]/3 rounded-full blur-3xl animate-pulse" style={{ animationDelay: "1s" }} />

      {/* Content */}
      <div className="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 text-center pt-24 pb-10">
        {/* Logo */}
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.6 }}
          className="flex justify-center mb-6"
        >
          <div className="relative w-24 h-24 drop-shadow-[0_0_30px_rgba(0,255,136,0.4)]">
            <Image src="/logo.png" alt="AutomateQA Logo" fill className="object-contain rounded-full" priority />
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.1 }}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-sm font-medium mb-8"
        >
          <span className="w-2 h-2 rounded-full bg-[#00FF88] animate-pulse" />
          QA Memes + Automation Tutorials + Corporate Chaos
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.1 }}
          className="text-4xl sm:text-6xl lg:text-7xl font-black leading-tight tracking-tight mb-6"
        >
          Automation Testing
          <br />
          <span className="text-gradient">Meets Corporate</span>
          <br />
          <span className="text-white">Chaos</span>
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.2 }}
          className="text-lg sm:text-xl text-[#9CA3AF] max-w-2xl mx-auto mb-10 leading-relaxed"
        >
          QA memes, Playwright tutorials, Selenium tips, and real corporate pain.
          Because{" "}
          <span className="text-white font-medium">finding bugs</span> is an art,
          and{" "}
          <span className="text-[#00FF88] font-medium">laughing about them</span> is therapy.
        </motion.p>

        {/* CTA Buttons */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.3 }}
          className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-16"
        >
          <Link href="/videos" className="btn-primary group w-full sm:w-auto justify-center">
            <Play size={16} /> Watch Videos
            <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
          </Link>
          <Link href="/memes" className="btn-outline group w-full sm:w-auto justify-center">
            <Laugh size={16} /> Explore Memes
          </Link>
          <Link href="/learn" className="px-6 py-3 rounded-xl text-sm font-semibold text-[#9CA3AF] hover:text-white border border-white/10 hover:border-white/20 transition-all duration-200 flex items-center gap-2 group w-full sm:w-auto justify-center">
            <BookOpen size={16} /> Learn Automation
          </Link>
        </motion.div>

        {/* Live Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.4 }}
          className="flex flex-wrap gap-8 justify-center"
        >
          {statItems.map(({ key, value, label, suffix }) => (
            <div key={key} className="text-center min-w-[80px]">
              <div className="text-2xl sm:text-3xl font-black text-gradient">
                <AnimatedNumber value={value} suffix={suffix} />
              </div>
              <div className="text-xs text-[#9CA3AF] font-medium mt-1">{label}</div>
            </div>
          ))}
        </motion.div>
      </div>

      {/* Bottom gradient fade */}
      <div className="absolute bottom-0 left-0 right-0 h-32 bg-gradient-to-t from-[#0B0B0B] to-transparent" />
    </section>
  );
}
