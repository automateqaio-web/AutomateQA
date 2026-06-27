"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { ArrowRight } from "lucide-react";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function InlineBanner({ ad, onCtaClick, isPreview }: Props) {
  const bc   = ad.button_color || "#00FF88";
  const tc   = ad.text_color   || "#FFFFFF";
  const anim = getAdAnimationVariants(ad.animation);

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
  };

  return (
    <motion.div {...anim} className="my-4 flex items-center gap-4 rounded-xl px-4 py-3"
      style={{
        background: `${bc}08`,
        border: `1px solid ${bc}20`,
        borderLeft: `3px solid ${bc}`,
      }}
    >
      {ad.logo_url && (
        <Image src={ad.logo_url} alt="logo" width={36} height={36}
          className="w-9 h-9 rounded-lg object-contain flex-shrink-0"
          style={{ border: `1px solid ${bc}20` }} />
      )}
      <div className="flex-1 min-w-0">
        {ad.badge && (
          <span className="text-[10px] font-black uppercase tracking-[0.15em] mr-2" style={{ color: bc }}>
            {ad.badge}
          </span>
        )}
        <span className="text-sm font-bold" style={{ color: tc }}>{ad.title}</span>
        {ad.subtitle && (
          <span className="text-xs ml-2" style={{ color: `${tc}77` }}>{ad.subtitle}</span>
        )}
      </div>
      {ad.cta_text && (
        <motion.button whileHover={{ x: 2 }} whileTap={{ scale: 0.95 }}
          onClick={handleCta}
          className="flex items-center gap-1.5 text-xs font-black px-3 py-1.5 rounded-lg flex-shrink-0"
          style={{ background: bc, color: "#0B0B0B" }}
        >
          {ad.cta_text} <ArrowRight size={11} />
        </motion.button>
      )}
    </motion.div>
  );
}
