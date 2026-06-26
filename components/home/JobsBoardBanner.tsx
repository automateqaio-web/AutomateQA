"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { ArrowRight, Briefcase, MapPin, Wifi, Zap, Star, Clock } from "lucide-react";

// ── Fake preview job cards (purely decorative) ────────────────────────────────
const PREVIEW_JOBS = [
  { title: "Senior SDET",          company: "Google",      loc: "Remote",     badge: "Referral", color: "#00FF88" },
  { title: "QA Automation Lead",   company: "Flipkart",    loc: "Bengaluru",  badge: "New",      color: "#00D4FF" },
  { title: "Playwright Engineer",  company: "Microsoft",   loc: "Hyderabad",  badge: "Remote",   color: "#A855F7" },
  { title: "Test Architect",       company: "Atlassian",   loc: "Remote",     badge: "Referral", color: "#F97316" },
  { title: "QA Engineer II",       company: "Amazon",      loc: "Pune",       badge: "New",      color: "#EC4899" },
];

// ── Stat pills ─────────────────────────────────────────────────────────────────
const STATS = [
  { value: "400+",   label: "Active Roles",   color: "#00FF88", icon: Briefcase },
  { value: "Daily",  label: "Auto-Updated",   color: "#00D4FF", icon: Zap       },
  { value: "Free",   label: "Always Free",    color: "#A855F7", icon: Star      },
  { value: "7 AM",   label: "Fresh Every Day",color: "#F97316", icon: Clock     },
];

export default function JobsBoardBanner() {
  return (
    <section className="relative py-16 sm:py-20 overflow-hidden">

      {/* ── Outer glow blobs ── */}
      <div
        className="absolute top-[-20%] left-[-5%] w-[600px] h-[600px] rounded-full pointer-events-none"
        style={{ background: "radial-gradient(circle,rgba(0,255,136,0.07),transparent 70%)" }}
      />
      <div
        className="absolute bottom-[-20%] right-[-5%] w-[500px] h-[500px] rounded-full pointer-events-none"
        style={{ background: "radial-gradient(circle,rgba(168,85,247,0.07),transparent 70%)" }}
      />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

        {/* ── Main card ── */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.65 }}
          className="relative rounded-3xl overflow-hidden border border-white/8"
          style={{
            background: "linear-gradient(135deg,#0E0E0E 0%,#111 50%,#0E0E0E 100%)",
          }}
        >
          {/* top gradient bar */}
          <div
            className="absolute top-0 left-0 right-0 h-[2px]"
            style={{ background: "linear-gradient(90deg,#00FF88,#00D4FF,#A855F7,#F97316)" }}
          />

          {/* subtle inner glow */}
          <div
            className="absolute inset-0 pointer-events-none"
            style={{
              background:
                "radial-gradient(ellipse 60% 55% at 15% 50%,rgba(0,255,136,0.06),transparent 70%)," +
                "radial-gradient(ellipse 40% 40% at 85% 30%,rgba(168,85,247,0.05),transparent 65%)",
            }}
          />
          <div className="absolute inset-0 grid-bg opacity-20 pointer-events-none" />

          <div className="relative grid lg:grid-cols-2 gap-10 lg:gap-0 p-8 sm:p-10 lg:p-14">

            {/* ════════ LEFT — Copy ════════ */}
            <div className="flex flex-col justify-center">

              {/* Badge */}
              <motion.div
                initial={{ opacity: 0, x: -16 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.1 }}
                className="inline-flex items-center gap-2 self-start px-3.5 py-1.5 rounded-full mb-6 text-xs font-bold uppercase tracking-widest"
                style={{
                  background: "linear-gradient(135deg,rgba(0,255,136,0.12),rgba(0,212,255,0.08))",
                  border: "1px solid rgba(0,255,136,0.25)",
                  color: "#00FF88",
                }}
              >
                <span className="w-2 h-2 rounded-full bg-[#00FF88] animate-pulse" />
                Jobs Board — Updated Daily
              </motion.div>

              {/* Headline */}
              <motion.h2
                initial={{ opacity: 0, y: 16 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.15 }}
                className="text-4xl sm:text-5xl font-black leading-[1.08] tracking-tight text-white mb-4"
              >
                Land Your Next{" "}
                <span
                  style={{
                    background: "linear-gradient(135deg,#00FF88 0%,#00D4FF 60%,#A855F7 100%)",
                    WebkitBackgroundClip: "text",
                    WebkitTextFillColor: "transparent",
                    backgroundClip: "text",
                  }}
                >
                  QA Role
                </span>
                <br />
                Faster Than Ever
              </motion.h2>

              {/* Sub */}
              <motion.p
                initial={{ opacity: 0, y: 12 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.2 }}
                className="text-[#9CA3AF] text-base sm:text-lg leading-relaxed mb-8 max-w-md"
              >
                Automation, SDET, and QA engineering roles fetched from Adzuna every morning —
                plus exclusive <span className="text-white font-semibold">community referrals</span> straight
                from engineers inside top companies.
              </motion.p>

              {/* Stat pills */}
              <motion.div
                initial={{ opacity: 0, y: 12 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.25 }}
                className="flex flex-wrap gap-3 mb-8"
              >
                {STATS.map(({ value, label, color, icon: Icon }) => (
                  <div
                    key={label}
                    className="flex items-center gap-2.5 px-4 py-2.5 rounded-2xl border"
                    style={{
                      background: `${color}0D`,
                      borderColor: `${color}30`,
                    }}
                  >
                    <Icon size={13} style={{ color }} />
                    <span className="text-lg font-black" style={{ color }}>{value}</span>
                    <span className="text-xs text-[#6B7280] font-medium">{label}</span>
                  </div>
                ))}
              </motion.div>

              {/* CTAs */}
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.3 }}
                className="flex flex-wrap gap-3"
              >
                <Link
                  href="/jobs"
                  className="group relative inline-flex items-center gap-2 px-7 py-3.5 rounded-2xl font-bold text-sm text-[#0B0B0B] overflow-hidden"
                  style={{ background: "linear-gradient(135deg,#00FF88,#00D4FF)" }}
                >
                  <motion.div
                    className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                    style={{ background: "linear-gradient(135deg,#00e67a,#00bfdf)" }}
                  />
                  <span className="relative flex items-center gap-2">
                    <Briefcase size={15} />
                    Browse All Jobs
                    <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
                  </span>
                </Link>

                <Link
                  href="/jobs?referral=true"
                  className="group inline-flex items-center gap-2 px-7 py-3.5 rounded-2xl font-bold text-sm border transition-all"
                  style={{
                    background: "rgba(168,85,247,0.08)",
                    borderColor: "rgba(168,85,247,0.30)",
                    color: "#C084FC",
                  }}
                >
                  <Star size={14} />
                  View Referrals
                </Link>
              </motion.div>
            </div>

            {/* ════════ RIGHT — Decorative job cards ════════ */}
            <div className="relative hidden lg:flex items-center justify-end pl-10">

              {/* Stacked cards */}
              <div className="relative w-full max-w-[380px]">
                {PREVIEW_JOBS.map((job, i) => (
                  <motion.div
                    key={job.title}
                    initial={{ opacity: 0, x: 40 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    viewport={{ once: true }}
                    transition={{ delay: 0.12 + i * 0.09, duration: 0.5, type: "spring", stiffness: 110, damping: 18 }}
                    style={{ zIndex: PREVIEW_JOBS.length - i }}
                    className="relative rounded-2xl border border-white/8 bg-[#131313] p-4 mb-3 last:mb-0"
                  >
                    {/* top color strip */}
                    <div
                      className="absolute top-0 left-0 right-0 h-[2px] rounded-t-2xl"
                      style={{ background: `linear-gradient(90deg,${job.color},transparent)` }}
                    />

                    <div className="flex items-center justify-between gap-3">
                      {/* Avatar */}
                      <div
                        className="w-9 h-9 rounded-xl flex-shrink-0 flex items-center justify-center text-[#0B0B0B] font-black text-sm"
                        style={{ background: `linear-gradient(135deg,${job.color},${job.color}88)` }}
                      >
                        {job.company[0]}
                      </div>

                      {/* Info */}
                      <div className="flex-1 min-w-0">
                        <p className="text-white text-xs font-bold truncate">{job.title}</p>
                        <p className="text-[#6B7280] text-[11px] truncate">{job.company}</p>
                      </div>

                      {/* Right badges */}
                      <div className="flex flex-col items-end gap-1 flex-shrink-0">
                        <span
                          className="text-[10px] font-bold px-2 py-0.5 rounded-full"
                          style={{
                            background: `${job.color}18`,
                            color: job.color,
                            border: `1px solid ${job.color}35`,
                          }}
                        >
                          {job.badge}
                        </span>
                        <span className="flex items-center gap-1 text-[10px] text-[#4B5563]">
                          {job.badge === "Remote" || job.loc === "Remote"
                            ? <><Wifi size={9} />{job.loc}</>
                            : <><MapPin size={9} />{job.loc}</>
                          }
                        </span>
                      </div>
                    </div>
                  </motion.div>
                ))}

                {/* Blurred "more" indicator */}
                <div
                  className="absolute bottom-[-18px] left-0 right-0 h-14 rounded-2xl"
                  style={{
                    background: "linear-gradient(to bottom,transparent,#0E0E0E)",
                  }}
                />
                <p className="text-center text-xs text-[#4B5563] mt-4">
                  +400 more roles waiting →
                </p>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
