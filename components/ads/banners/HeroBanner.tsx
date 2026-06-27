"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { ArrowRight } from "lucide-react";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function HeroBanner({ ad, onCtaClick, isPreview }: Props) {
  const bc   = ad.button_color || "#00FF88";
  const tc   = ad.text_color   || "#FFFFFF";
  const bg   = ad.gradient
    ? `linear-gradient(135deg, ${ad.gradient})`
    : ad.bg_color || "#070707";
  const anim = getAdAnimationVariants(ad.animation);

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
  };

  return (
    <motion.div {...anim} className="relative w-full overflow-hidden rounded-3xl"
      style={{ background: bg, minHeight: "280px" }}
    >
      {/* background image */}
      {ad.desktop_image_url && (
        <div className="absolute inset-0">
          <Image src={ad.desktop_image_url} alt="" fill className="object-cover" />
          <div className="absolute inset-0" style={{ background: "linear-gradient(135deg, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0.4) 100%)" }} />
        </div>
      )}

      {/* grid dot pattern */}
      <div className="absolute inset-0 pointer-events-none"
        style={{ backgroundImage: "radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px)", backgroundSize: "28px 28px" }} />

      <div className="relative flex flex-col items-center justify-center text-center px-6 sm:px-12 py-16 sm:py-20">
        {ad.logo_url && (
          <Image src={ad.logo_url} alt="logo" width={64} height={64}
            className="w-16 h-16 rounded-2xl object-contain mb-4"
            style={{ border: `1px solid ${bc}30`, background: "rgba(255,255,255,0.06)" }} />
        )}

        {ad.badge && (
          <span className="inline-block text-[11px] font-black uppercase tracking-[0.2em] px-4 py-1.5 rounded-full mb-5"
            style={{ background: `${bc}18`, color: bc, border: `1px solid ${bc}35` }}>
            {ad.badge}
          </span>
        )}

        <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black leading-tight mb-3"
          style={{ color: tc, textShadow: "0 2px 20px rgba(0,0,0,0.5)" }}>
          {ad.title}
        </h2>
        {ad.subtitle && <p className="text-lg font-semibold mb-2" style={{ color: `${tc}CC` }}>{ad.subtitle}</p>}
        {ad.description && (
          <p className="text-base leading-relaxed max-w-xl mx-auto mb-8" style={{ color: `${tc}88` }}>{ad.description}</p>
        )}

        {ad.cta_text && (
          <motion.button whileHover={{ scale: 1.05, boxShadow: `0 8px 30px ${bc}50` }}
            whileTap={{ scale: 0.97 }}
            onClick={handleCta}
            className="flex items-center gap-2 px-8 py-4 rounded-2xl text-base font-black"
            style={{ background: bc, color: "#0B0B0B", boxShadow: `0 4px 24px ${bc}40` }}
          >
            {ad.cta_text} <ArrowRight size={16} />
          </motion.button>
        )}
      </div>
    </motion.div>
  );
}
