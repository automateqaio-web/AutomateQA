"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, ArrowRight } from "lucide-react";
import { Ad } from "@/types";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function StickyBanner({ ad, onCtaClick, isPreview }: Props) {
  const [dismissed, setDismissed] = useState(false);
  const bc = ad.button_color || "#00FF88";
  const tc = ad.text_color   || "#FFFFFF";
  const bg = ad.gradient
    ? `linear-gradient(90deg, ${ad.gradient})`
    : ad.bg_color || "#111111";

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
  };

  const wrapperClass = isPreview
    ? "relative rounded-xl overflow-hidden"
    : "fixed bottom-0 left-0 right-0 z-50";

  return (
    <AnimatePresence>
      {!dismissed && (
        <motion.div
          initial={{ y: 100, opacity: 0 }}
          animate={{ y: 0,   opacity: 1 }}
          exit={{    y: 100, opacity: 0 }}
          transition={{ type: "spring", bounce: 0.2, duration: 0.4 }}
          className={wrapperClass}
          style={!isPreview ? { boxShadow: "0 -4px 24px rgba(0,0,0,0.5)" } : {}}
        >
          <div className="flex items-center gap-3 px-4 py-3" style={{ background: bg }}>
            {/* badge */}
            {ad.badge && (
              <span className="hidden sm:block text-[10px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full flex-shrink-0"
                style={{ background: `${bc}22`, color: bc, border: `1px solid ${bc}40` }}>
                {ad.badge}
              </span>
            )}

            {/* text */}
            <div className="flex-1 min-w-0">
              <span className="text-sm font-black mr-2" style={{ color: tc }}>{ad.title}</span>
              {ad.subtitle && (
                <span className="text-xs hidden sm:inline" style={{ color: `${tc}88` }}>{ad.subtitle}</span>
              )}
            </div>

            {/* CTA */}
            {ad.cta_text && (
              <motion.button whileHover={{ scale: 1.04 }} whileTap={{ scale: 0.96 }}
                onClick={handleCta}
                className="flex items-center gap-1.5 text-xs font-black px-4 py-2 rounded-xl flex-shrink-0"
                style={{ background: bc, color: "#0B0B0B", boxShadow: `0 2px 12px ${bc}40` }}
              >
                {ad.cta_text} <ArrowRight size={11} />
              </motion.button>
            )}

            {/* dismiss */}
            <button onClick={() => setDismissed(true)}
              className="p-1.5 rounded-lg flex-shrink-0 transition-all hover:bg-white/10"
              style={{ color: `${tc}66` }}>
              <X size={14} />
            </button>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
