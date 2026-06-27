"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X } from "lucide-react";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function RibbonBanner({ ad, onCtaClick, isPreview }: Props) {
  const [dismissed, setDismissed] = useState(false);
  const bc   = ad.button_color || "#00FF88";
  const tc   = ad.text_color   || "#FFFFFF";
  const bg   = ad.gradient
    ? `linear-gradient(90deg, ${ad.gradient})`
    : ad.bg_color || "#111111";
  const anim = getAdAnimationVariants(ad.animation);

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
  };

  return (
    <AnimatePresence>
      {!dismissed && (
        <motion.div {...anim}
          className="w-full flex items-center justify-center gap-3 px-4 py-2 relative"
          style={{ background: bg, borderBottom: `1px solid ${bc}20`, minHeight: 40 }}
        >
          {ad.badge && (
            <span className="text-[10px] font-black uppercase tracking-[0.18em] px-2 py-0.5 rounded-full flex-shrink-0"
              style={{ background: `${bc}22`, color: bc, border: `1px solid ${bc}40` }}>
              {ad.badge}
            </span>
          )}
          <p className="text-xs font-semibold text-center" style={{ color: tc }}>
            {ad.title}
            {ad.subtitle && <span className="ml-1 opacity-70">{ad.subtitle}</span>}
          </p>
          {ad.cta_text && (
            <button onClick={handleCta}
              className="text-xs font-black underline decoration-dotted flex-shrink-0 transition-all hover:opacity-80"
              style={{ color: bc }}>
              {ad.cta_text}
            </button>
          )}
          <button onClick={() => setDismissed(true)}
            className="absolute right-3 p-1 rounded-md hover:bg-white/10 transition-all flex-shrink-0"
            style={{ color: `${tc}66` }}>
            <X size={12} />
          </button>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
