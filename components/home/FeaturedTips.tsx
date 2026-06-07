"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { ArrowRight, Clock, Zap, Eye } from "lucide-react";
import { AutomationTip, CATEGORY_COLORS, DIFFICULTY_COLORS, Difficulty } from "@/types";

interface FeaturedTipsProps {
  tips: AutomationTip[];
}

function TipCard({ tip, index }: { tip: AutomationTip; index: number }) {
  const difficultyStyle = DIFFICULTY_COLORS[tip.difficulty as Difficulty] || "bg-gray-500/20 text-gray-400 border-gray-500/30";
  const categoryStyle = CATEGORY_COLORS[tip.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30";

  return (
    <motion.article
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5, delay: index * 0.08 }}
    >
      <Link href={`/automation-tips/${tip.slug}`} className="group block h-full">
        <div className="glass-card-hover h-full flex flex-col overflow-hidden">
          {/* Cover image */}
          {tip.cover_image && (
            <div className="relative aspect-[16/9] overflow-hidden rounded-t-2xl">
              <img
                src={tip.cover_image}
                alt={tip.title}
                className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                loading="lazy"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />
              <div className="absolute bottom-3 left-3 flex items-center gap-2">
                <span className={`category-badge border ${categoryStyle}`}>{tip.category}</span>
                <span className={`category-badge border ${difficultyStyle}`}>{tip.difficulty}</span>
              </div>
            </div>
          )}

          <div className="p-5 flex flex-col flex-1">
            {!tip.cover_image && (
              <div className="flex items-center gap-2 mb-3">
                <span className={`category-badge border ${categoryStyle}`}>{tip.category}</span>
                <span className={`category-badge border ${difficultyStyle}`}>{tip.difficulty}</span>
              </div>
            )}

            <h3 className="font-bold text-white text-base leading-snug line-clamp-2 mb-2 group-hover:text-[#00FF88] transition-colors">
              {tip.title}
            </h3>

            {tip.excerpt && (
              <p className="text-[#9CA3AF] text-sm leading-relaxed line-clamp-2 flex-1 mb-4">
                {tip.excerpt}
              </p>
            )}

            {tip.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1 mb-3">
                {tip.tags.slice(0, 3).map((tag) => (
                  <span key={tag} className="tag-chip">{tag}</span>
                ))}
              </div>
            )}

            <div className="flex items-center justify-between text-xs text-[#9CA3AF] mt-auto pt-3 border-t border-white/5">
              <span className="flex items-center gap-1.5">
                <Clock size={11} />
                {tip.read_time} min read
              </span>
              {tip.views > 0 && (
                <span className="flex items-center gap-1.5">
                  <Eye size={11} />
                  {tip.views.toLocaleString()}
                </span>
              )}
            </div>
          </div>
        </div>
      </Link>
    </motion.article>
  );
}

export default function FeaturedTips({ tips }: FeaturedTipsProps) {
  if (!tips || tips.length === 0) return null;

  return (
    <section className="py-20 relative">
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_bottom_left,rgba(0,255,136,0.04)_0%,transparent_70%)]" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-12"
        >
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 text-xs font-semibold mb-3">
              <Zap size={10} />
              TIPS &amp; TRICKS
            </div>
            <h2 className="text-3xl sm:text-4xl font-black text-white">
              Level Up Your Automation
            </h2>
            <p className="text-[#9CA3AF] mt-2">Practical tips and tricks for Playwright, Selenium &amp; more</p>
          </div>
          <Link
            href="/automation-tips"
            className="flex items-center gap-2 text-[#00FF88] text-sm font-semibold hover:gap-3 transition-all group"
          >
            Browse all tips
            <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {tips.map((tip, i) => (
            <TipCard key={tip.id} tip={tip} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
