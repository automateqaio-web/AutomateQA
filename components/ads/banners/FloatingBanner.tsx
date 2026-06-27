"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import Image from "next/image";
import { X, ArrowRight } from "lucide-react";
import { Ad } from "@/types";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function FloatingBanner({ ad, onCtaClick, isPreview }: Props) {
  const [dismissed, setDismissed] = useState(false);
  const bc = ad.button_color || "#00FF88";
  const tc = ad.text_color   || "#FFFFFF";
  const bg = ad.gradient
    ? `linear-gradient(135deg, ${ad.gradient})`
    : ad.bg_color || "#111111";

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
  };

  const positionClass = isPreview
    ? "absolute bottom-4 right-4"
    : "fixed bottom-6 right-6 z-40";

  return (
    <AnimatePresence>
      {!dismissed && (
        <motion.div
          initial={{ opacity: 0, x: 60, y: 10 }}
          animate={{ opacity: 1, x: 0,  y: 0  }}
          exit={{    opacity: 0, x: 60         }}
          transition={{ type: "spring", bounce: 0.25, duration: 0.5, delay: 0.8 }}
          className={`${positionClass} w-72 rounded-2xl overflow-hidden`}
          style={{
            background: bg,
            border: `1px solid ${bc}30`,
            boxShadow: `0 16px 60px rgba(0,0,0,0.6), 0 0 0 1px ${bc}15`,
          }}
        >
          {/* gradient top bar */}
          <div className="h-0.5" style={{ background: `linear-gradient(90deg, ${bc}, transparent)` }} />

          {/* dismiss */}
          <button onClick={() => setDismissed(true)}
            className="absolute top-3 right-3 p-1 rounded-lg transition-all hover:bg-white/10"
            style={{ color: `${tc}66` }}>
            <X size={13} />
          </button>

          <div className="p-4">
            {/* logo + badge */}
            <div className="flex items-center gap-2 mb-3 pr-6">
              {ad.logo_url && (
                <Image src={ad.logo_url} alt="logo" width={28} height={28}
                  className="w-7 h-7 rounded-lg object-contain flex-shrink-0" />
              )}
              {ad.badge && (
                <span className="text-[10px] font-black uppercase tracking-[0.15em]" style={{ color: bc }}>
                  {ad.badge}
                </span>
              )}
            </div>

            <h3 className="text-sm font-black leading-tight mb-1" style={{ color: tc }}>{ad.title}</h3>
            {ad.subtitle && <p className="text-xs mb-3" style={{ color: `${tc}AA` }}>{ad.subtitle}</p>}

            {ad.cta_text && (
              <motion.button whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
                onClick={handleCta}
                className="w-full flex items-center justify-center gap-1.5 py-2 rounded-xl text-xs font-black"
                style={{ background: bc, color: "#0B0B0B" }}
              >
                {ad.cta_text} <ArrowRight size={11} />
              </motion.button>
            )}
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
