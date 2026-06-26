"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import Image from "next/image";
import { Laugh, BookOpen, ArrowRight, Briefcase, Zap, Terminal } from "lucide-react";

// ── Typewriter words ───────────────────────────────────────────────────────────
const ROLES = ["QA Engineers", "Automation Testers", "SDETs", "Test Engineers", "QA Teams"];

// ── Floating code chips ────────────────────────────────────────────────────────
const CHIPS = [
  { text: "expect(bug).toBe(fixed)",  pos: { top: "14%", left: "4%" },  delay: 0.2 },
  { text: "playwright test --headed", pos: { top: "8%",  right: "5%" }, delay: 0.5 },
  { text: "git blame @teammate 😅",  pos: { top: "72%", left: "2%" },  delay: 0.9 },
  { text: "it works on my machine",  pos: { top: "78%", right: "4%" }, delay: 0.6 },
  { text: "npm run test -- --watch", pos: { top: "38%", left: "1%" },  delay: 1.1 },
  { text: "LGTM 🚀",                 pos: { top: "50%", right: "2%" }, delay: 0.3 },
];

// ── Tools marquee ──────────────────────────────────────────────────────────────
const TOOLS = [
  "Playwright", "Selenium", "Cypress", "SDET", "TestNG", "JUnit",
  "Rest Assured", "Postman", "Jenkins", "GitHub Actions", "Java",
  "TypeScript", "Appium", "BDD", "Cucumber", "API Testing", "CI/CD",
];

// ── Animated counter ──────────────────────────────────────────────────────────
function Counter({ value, suffix = "" }: { value: number | null; suffix?: string }) {
  const [n, setN] = useState(0);
  useEffect(() => {
    if (!value) return;
    const start = Date.now();
    const dur = 1800;
    const tick = () => {
      const p = Math.min((Date.now() - start) / dur, 1);
      setN(Math.floor((1 - Math.pow(1 - p, 4)) * value));
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  }, [value]);
  if (value === null) return null;
  return <>{n.toLocaleString()}{suffix}</>;
}

// ── Typewriter ────────────────────────────────────────────────────────────────
function Typewriter() {
  const [idx, setIdx]   = useState(0);
  const [text, setText] = useState("");
  const [del, setDel]   = useState(false);

  useEffect(() => {
    const word = ROLES[idx];
    let timer: ReturnType<typeof setTimeout>;
    if (!del && text.length < word.length) {
      timer = setTimeout(() => setText(word.slice(0, text.length + 1)), 80);
    } else if (!del && text.length === word.length) {
      timer = setTimeout(() => setDel(true), 1800);
    } else if (del && text.length > 0) {
      timer = setTimeout(() => setText(word.slice(0, text.length - 1)), 45);
    } else {
      setDel(false);
      setIdx((i) => (i + 1) % ROLES.length);
    }
    return () => clearTimeout(timer);
  }, [text, del, idx]);

  return (
    <span
      className="font-black"
      style={{
        background: "linear-gradient(135deg,#00FF88,#00D4FF)",
        WebkitBackgroundClip: "text",
        WebkitTextFillColor: "transparent",
        backgroundClip: "text",
      }}
    >
      {text}
      <span className="animate-pulse" style={{ WebkitTextFillColor: "#00FF88" }}>|</span>
    </span>
  );
}

// ─────────────────────────────────────────────────────────────────────────────
export default function HeroSection() {
  const [stats, setStats] = useState<{
    subscribers: number | null; memes: number | null;
    videos: number | null; tutorials: number | null;
  }>({ subscribers: null, memes: null, videos: null, tutorials: null });

  useEffect(() => {
    const KEY = "aq_home_stats", TTL = 10 * 60 * 1000;
    try {
      const c = sessionStorage.getItem(KEY);
      if (c) { const { data, ts } = JSON.parse(c); if (Date.now() - ts < TTL) { setStats(data); return; } }
    } catch { /* skip */ }
    fetch("/api/home-stats").then(r => r.json()).then(d => {
      setStats(d);
      sessionStorage.setItem(KEY, JSON.stringify({ data: d, ts: Date.now() }));
    }).catch(() => {});
  }, []);

  const statItems = [
    { key: "subscribers", value: stats.subscribers, label: "Subscribers", suffix: "",  color: "#00FF88" },
    { key: "memes",       value: stats.memes,       label: "QA Memes",    suffix: "+", color: "#00D4FF" },
    { key: "videos",      value: stats.videos,      label: "Videos",      suffix: "",  color: "#A855F7" },
    { key: "tutorials",   value: stats.tutorials,   label: "Tutorials",   suffix: "",  color: "#F97316" },
  ].filter(s => s.value !== null && s.value > 0);

  return (
    <>
      {/* ══════════════════════════════════════════════════════════
          HERO
      ══════════════════════════════════════════════════════════ */}
      <section className="relative flex flex-col items-center justify-center overflow-hidden min-h-screen">

        {/* Background layers */}
        <div className="absolute inset-0 bg-[#0B0B0B]" />
        <div className="absolute inset-0 grid-bg opacity-30" />

        <motion.div
          animate={{ scale: [1, 1.15, 1], opacity: [0.07, 0.13, 0.07] }}
          transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
          className="absolute top-[-15%] left-[-10%] w-[700px] h-[700px] rounded-full"
          style={{ background: "radial-gradient(circle,#00FF88,transparent 70%)" }}
        />
        <motion.div
          animate={{ scale: [1, 1.2, 1], opacity: [0.05, 0.10, 0.05] }}
          transition={{ duration: 10, repeat: Infinity, ease: "easeInOut", delay: 2 }}
          className="absolute bottom-[-20%] right-[-10%] w-[800px] h-[800px] rounded-full"
          style={{ background: "radial-gradient(circle,#A855F7,transparent 70%)" }}
        />
        <motion.div
          animate={{ scale: [1, 1.1, 1], opacity: [0.04, 0.09, 0.04] }}
          transition={{ duration: 12, repeat: Infinity, ease: "easeInOut", delay: 4 }}
          className="absolute top-[30%] right-[20%] w-[500px] h-[500px] rounded-full"
          style={{ background: "radial-gradient(circle,#00D4FF,transparent 70%)" }}
        />

        {/* Floating code chips (desktop only) */}
        {CHIPS.map((chip, i) => (
          <motion.div
            key={i}
            className="absolute hidden xl:flex items-center gap-2 px-3 py-1.5 rounded-lg backdrop-blur-sm z-10"
            style={{
              ...chip.pos,
              background: "rgba(17,17,17,0.85)",
              border: "1px solid rgba(0,255,136,0.15)",
            }}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: chip.delay + 1.2, duration: 0.7 }}
          >
            <motion.div
              animate={{ y: [0, -6, 0] }}
              transition={{ duration: 3 + i * 0.7, repeat: Infinity, ease: "easeInOut" }}
              className="flex items-center gap-2"
            >
              <Terminal size={10} className="text-[#00FF88]" />
              <code className="text-[10px] text-[#00FF88]/80 font-mono whitespace-nowrap">{chip.text}</code>
            </motion.div>
          </motion.div>
        ))}

        {/* Main content */}
        <div className="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 text-center pt-28 pb-8">

          {/* Logo */}
          <motion.div
            initial={{ opacity: 0, scale: 0.6 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.7, type: "spring", stiffness: 200 }}
            className="flex justify-center mb-7"
          >
            <div className="relative">
              <motion.div
                animate={{ rotate: 360 }}
                transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
                className="absolute inset-[-8px] rounded-full"
                style={{
                  background: "conic-gradient(from 0deg,#00FF88,#00D4FF,#A855F7,#F97316,#00FF88)",
                  opacity: 0.6,
                  filter: "blur(4px)",
                }}
              />
              <div className="relative w-24 h-24 rounded-full ring-2 ring-black z-10 overflow-hidden">
                <Image src="/logo.png" alt="AutomateQA" fill className="object-contain" priority />
              </div>
            </div>
          </motion.div>

          {/* Badge */}
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full mb-8 text-xs font-bold tracking-widest uppercase"
            style={{
              background: "linear-gradient(135deg,rgba(0,255,136,0.12),rgba(0,212,255,0.08))",
              border: "1px solid rgba(0,255,136,0.25)",
              color: "#00FF88",
            }}
          >
            <span className="w-2 h-2 rounded-full bg-[#00FF88] animate-pulse" />
            India&apos;s QA Community · Jobs · Tutorials · Memes
          </motion.div>

          {/* Headline */}
          <motion.h1
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="text-5xl sm:text-6xl lg:text-[5.5rem] font-black leading-[1.05] tracking-tight mb-4"
          >
            <span className="text-white">Built for</span>
            <br />
            <Typewriter />
            <br />
            <span
              className="inline-block"
              style={{
                background: "linear-gradient(135deg,#ffffff 0%,#9CA3AF 100%)",
                WebkitBackgroundClip: "text",
                WebkitTextFillColor: "transparent",
                backgroundClip: "text",
              }}
            >
              Who Love Quality
            </span>
          </motion.h1>

          {/* Subtitle */}
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.35 }}
            className="text-lg sm:text-xl text-[#9CA3AF] max-w-2xl mx-auto mb-10 leading-relaxed"
          >
            QA memes, Playwright tutorials, SDET interview prep,{" "}
            <span className="text-white font-semibold">400+ daily-updated jobs</span>,
            and real corporate chaos — all in one place.
          </motion.p>

          {/* CTA row */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.45 }}
            className="flex flex-col sm:flex-row gap-3 justify-center items-center mb-14"
          >
            <Link
              href="/jobs"
              className="group relative flex items-center gap-2 px-7 py-3.5 rounded-2xl font-bold text-sm text-[#0B0B0B] overflow-hidden w-full sm:w-auto justify-center"
              style={{ background: "linear-gradient(135deg,#00FF88,#00D4FF)" }}
            >
              <motion.div
                className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity"
                style={{ background: "linear-gradient(135deg,#00e67a,#00bfdf)" }}
              />
              <span className="relative flex items-center gap-2">
                <Briefcase size={16} /> Browse Jobs
                <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
              </span>
            </Link>

            <Link
              href="/learn"
              className="group flex items-center gap-2 px-7 py-3.5 rounded-2xl font-bold text-sm text-white border border-white/15 hover:border-white/30 bg-white/5 hover:bg-white/10 transition-all w-full sm:w-auto justify-center"
            >
              <BookOpen size={16} /> Start Learning
            </Link>

            <Link
              href="/memes"
              className="group flex items-center gap-2 px-7 py-3.5 rounded-2xl font-bold text-sm transition-all w-full sm:w-auto justify-center"
              style={{ color: "#9CA3AF", border: "1px solid rgba(255,255,255,0.08)" }}
            >
              <Laugh size={16} /> Explore Memes
            </Link>
          </motion.div>

          {/* Stats */}
          {statItems.length > 0 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.6 }}
              className="flex flex-wrap justify-center gap-8 sm:gap-12"
            >
              {statItems.map(({ key, value, label, suffix, color }) => (
                <div key={key} className="text-center">
                  <div className="text-3xl sm:text-4xl font-black" style={{ color }}>
                    <Counter value={value} suffix={suffix} />
                  </div>
                  <div className="text-xs text-[#6B7280] font-semibold uppercase tracking-wider mt-1">{label}</div>
                </div>
              ))}
            </motion.div>
          )}
        </div>

        {/* Bottom fade */}
        <div className="absolute bottom-0 left-0 right-0 h-40 bg-gradient-to-t from-[#0B0B0B] to-transparent pointer-events-none" />
      </section>

      {/* ══════════════════════════════════════════════════════════
          MARQUEE — Tools strip
      ══════════════════════════════════════════════════════════ */}
      <div className="relative overflow-hidden border-y border-white/5 bg-[#0D0D0D] py-3">
        <motion.div
          animate={{ x: ["0%", "-50%"] }}
          transition={{ duration: 30, repeat: Infinity, ease: "linear" }}
          className="flex gap-10 whitespace-nowrap w-max"
        >
          {[...TOOLS, ...TOOLS].map((tool, i) => (
            <span key={i} className="flex items-center gap-2 text-xs font-semibold text-[#4B5563] uppercase tracking-widest">
              <Zap size={10} className="text-[#00FF88]" />
              {tool}
            </span>
          ))}
        </motion.div>
      </div>
    </>
  );
}
