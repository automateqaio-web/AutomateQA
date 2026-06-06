"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { ArrowRight, Share2, Tag, Laugh } from "lucide-react";
import { Meme } from "@/types";
import { CATEGORY_COLORS } from "@/types";

interface TrendingMemesProps {
  memes: Meme[];
}

function MemeCard({ meme, index }: { meme: Meme; index: number }) {
  const handleShare = async (e: React.MouseEvent) => {
    e.preventDefault();
    if (navigator.share) {
      await navigator.share({ title: meme.title, text: meme.caption, url: `/memes/${meme.id}` });
    } else {
      navigator.clipboard.writeText(`${window.location.origin}/memes/${meme.id}`);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      whileInView={{ opacity: 1, scale: 1 }}
      viewport={{ once: true }}
      transition={{ duration: 0.4, delay: (index % 4) * 0.1 }}
      className="h-full"
    >
      <Link href={`/memes/${meme.id}`} className="group block h-full">
        <div className="glass-card overflow-hidden hover:border-[#00FF88]/20 hover:shadow-[0_0_20px_rgba(0,255,136,0.1)] transition-all duration-300 flex flex-col h-full">
          {/* Fixed aspect ratio image */}
          <div className="relative aspect-[4/3] overflow-hidden flex-shrink-0">
            {meme.image_url ? (
              <>
                <img
                  src={meme.image_url}
                  alt={meme.title}
                  className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                  loading="lazy"
                />
                <button
                  onClick={handleShare}
                  className="absolute top-3 right-3 w-8 h-8 rounded-lg bg-black/60 backdrop-blur-sm flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity text-white hover:text-[#00FF88]"
                >
                  <Share2 size={13} />
                </button>
                <div className="absolute bottom-3 left-3">
                  <span className={`category-badge border ${CATEGORY_COLORS[meme.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                    {meme.category}
                  </span>
                </div>
              </>
            ) : (
              <div className="w-full h-full bg-[#1A1A1A]" />
            )}
          </div>

          {/* Caption */}
          <div className="p-3 flex flex-col gap-2 flex-1">
            {meme.caption && (
              <p className="text-sm text-[#D1D5DB] leading-relaxed line-clamp-2 flex-1">
                {meme.caption}
              </p>
            )}
            {meme.tags?.length > 0 && (
              <div className="flex flex-wrap gap-1.5">
                {meme.tags.slice(0, 3).map((tag) => (
                  <span key={tag} className="tag-chip">{tag}</span>
                ))}
              </div>
            )}
          </div>
        </div>
      </Link>
    </motion.div>
  );
}

export default function TrendingMemes({ memes }: TrendingMemesProps) {
  if (!memes || memes.length === 0) return null;

  return (
    <section className="py-20 relative">
      {/* Background accent */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(0,255,136,0.03)_0%,transparent_70%)]" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
        {/* Section header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-12"
        >
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold mb-3">
              <Laugh size={10} />
              TRENDING MEMES
            </div>
            <h2 className="text-3xl sm:text-4xl font-black text-white">
              This Week&apos;s QA Pain
            </h2>
            <p className="text-[#9CA3AF] mt-2">Fresh memes from the QA trenches. You&apos;ll laugh, then cry.</p>
          </div>
          <Link
            href="/memes"
            className="flex items-center gap-2 text-[#00FF88] text-sm font-semibold hover:gap-3 transition-all group"
          >
            Browse all memes
            <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </motion.div>

        {/* Uniform grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {memes.map((meme, i) => (
            <MemeCard key={meme.id} meme={meme} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
