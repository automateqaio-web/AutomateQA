"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import { ArrowRight, CheckCircle2, Circle, Zap, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { isSupabaseConfigured, withTimeout } from "@/lib/supabase/safeFetch";

const GOAL = 100;
const PREVIEW_COUNT = 12;

const categoryColors: Record<string, string> = {
  Playwright:       "bg-green-500/20 text-green-400",
  Selenium:         "bg-blue-500/20 text-blue-400",
  Cypress:          "bg-yellow-500/20 text-yellow-400",
  Puppeteer:        "bg-pink-500/20 text-pink-400",
  Jest:             "bg-orange-500/20 text-orange-400",
  "Testing Library":"bg-purple-500/20 text-purple-400",
  "CI/CD":          "bg-cyan-500/20 text-cyan-400",
  "API Testing":    "bg-emerald-500/20 text-emerald-400",
  Performance:      "bg-red-500/20 text-red-400",
  Security:         "bg-violet-500/20 text-violet-400",
  General:          "bg-gray-500/20 text-gray-400",
};

interface DayItem {
  day: number;
  title: string;
  slug: string;
  category: string;
  published: boolean;
}

export default function PlaywrightDays() {
  const [days, setDays] = useState<DayItem[]>([]);
  const [totalPublished, setTotalPublished] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      if (!isSupabaseConfigured()) {
        setLoading(false);
        return;
      }

      const supabase = createClient();

      const [items, publishedCount] = await Promise.all([
        withTimeout(async () => {
          const { data } = await supabase
            .from("learning_content")
            .select("title, slug, category, published")
            .order("created_at", { ascending: true })
            .limit(PREVIEW_COUNT);
          return data ?? [];
        }, [], 3000),
        withTimeout(async () => {
          const { count } = await supabase
            .from("learning_content")
            .select("id", { count: "exact", head: true })
            .eq("published", true);
          return count ?? 0;
        }, 0, 3000),
      ]);

      setDays(
        (items as { title: string; slug: string; category: string; published: boolean }[]).map((item, i) => ({
          day: i + 1,
          title: item.title,
          slug: item.slug,
          category: item.category,
          published: item.published,
        }))
      );
      setTotalPublished(publishedCount);
      setLoading(false);
    };

    load();
  }, []);

  const progress = Math.min((totalPublished / GOAL) * 100, 100);
  const remaining = GOAL - days.length;

  return (
    <section className="py-20 relative" id="playwright">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center mb-12"
        >
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/20 text-purple-400 text-xs font-semibold mb-4">
            <Zap size={10} />
            100 DAYS OF PLAYWRIGHT
          </div>
          <h2 className="text-3xl sm:text-4xl font-black text-white mb-3">
            Master Playwright in 100 Days
          </h2>
          <p className="text-[#9CA3AF] max-w-xl mx-auto">
            Daily lessons covering everything from setup to advanced patterns.
            Follow along and level up your automation skills.
          </p>
        </motion.div>

        {/* Progress bar */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="glass-card p-6 mb-8"
        >
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-medium text-white">
              {loading ? "Loading..." : `Day ${totalPublished} of ${GOAL}`}
            </span>
            <span className="text-sm text-[#00FF88] font-bold">
              {loading ? "—" : `${Math.round(progress)}% Complete`}
            </span>
          </div>
          <div className="h-2 bg-[#1A1A1A] rounded-full overflow-hidden">
            <motion.div
              initial={{ width: 0 }}
              whileInView={{ width: `${progress}%` }}
              viewport={{ once: true }}
              transition={{ duration: 1.5, ease: "easeOut" }}
              className="h-full bg-gradient-to-r from-[#00FF88] to-[#00D4FF] rounded-full relative"
            >
              {progress > 0 && (
                <div className="absolute right-0 top-1/2 -translate-y-1/2 w-3 h-3 rounded-full bg-white shadow-neon" />
              )}
            </motion.div>
          </div>
          <div className="flex justify-between mt-2 text-xs text-[#9CA3AF]">
            <span>Started</span>
            <span>Day 100 🎯</span>
          </div>
        </motion.div>

        {/* Days grid */}
        {loading ? (
          <div className="flex items-center justify-center py-16 gap-3 text-[#9CA3AF]">
            <Loader2 size={20} className="animate-spin text-[#00FF88]" />
            <span className="text-sm">Loading tutorials...</span>
          </div>
        ) : days.length === 0 ? (
          <div className="glass-card p-12 text-center text-[#9CA3AF] mb-8">
            <Zap size={32} className="mx-auto mb-3 text-[#00FF88]/40" />
            <p className="text-sm">Tutorials coming soon — check back!</p>
          </div>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3 mb-8">
            {days.map((day, index) => (
              <motion.div
                key={day.slug}
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ duration: 0.3, delay: index * 0.04 }}
              >
                <Link href={`/learn/${day.slug}`} className="group block h-full">
                  <div className={`glass-card p-3 h-full transition-all duration-300 ${
                    day.published
                      ? "border-[#00FF88]/20 hover:border-[#00FF88]/40 hover:shadow-[0_0_15px_rgba(0,255,136,0.1)]"
                      : "opacity-50 pointer-events-none"
                  }`}>
                    <div className="flex items-start justify-between mb-2">
                      <span className="text-xs font-bold text-[#9CA3AF]">Day {day.day}</span>
                      {day.published ? (
                        <CheckCircle2 size={12} className="text-[#00FF88] flex-shrink-0" />
                      ) : (
                        <Circle size={12} className="text-[#2A2A2A] flex-shrink-0" />
                      )}
                    </div>
                    <p className="text-xs font-medium text-white leading-snug line-clamp-2 mb-2">
                      {day.title}
                    </p>
                    <span className={`text-[10px] font-semibold px-1.5 py-0.5 rounded ${categoryColors[day.category] ?? "bg-gray-500/20 text-gray-400"}`}>
                      {day.category}
                    </span>
                  </div>
                </Link>
              </motion.div>
            ))}

            {/* Remaining count card */}
            {remaining > 0 && (
              <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ duration: 0.3, delay: days.length * 0.04 }}
                className="col-span-2"
              >
                <div className="glass-card p-3 h-full flex items-center justify-center border-dashed border-[#2A2A2A] text-center">
                  <div>
                    <div className="text-2xl font-black text-gradient mb-1">+{remaining}</div>
                    <p className="text-xs text-[#9CA3AF]">More days coming...</p>
                  </div>
                </div>
              </motion.div>
            )}
          </div>
        )}

        {/* CTA */}
        <div className="text-center">
          <Link href="/learn" className="btn-outline inline-flex">
            View All Tutorials
            <ArrowRight size={14} />
          </Link>
        </div>
      </div>
    </section>
  );
}
