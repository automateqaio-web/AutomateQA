"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function SmallCard({ ad, onCtaClick, isPreview }: Props) {
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
    <motion.div {...anim}
      className="flex items-center gap-3 px-3 py-2.5 rounded-xl cursor-pointer group"
      style={{
        background: `${bc}07`,
        border: `1px solid ${bc}18`,
        boxShadow: `0 2px 12px rgba(0,0,0,0.2)`,
      }}
      onClick={handleCta}
      whileHover={{ scale: 1.02, borderColor: `${bc}35` }}
      whileTap={{ scale: 0.98 }}
    >
      {ad.logo_url && (
        <Image src={ad.logo_url} alt="logo" width={28} height={28}
          className="w-7 h-7 rounded-lg object-contain flex-shrink-0" />
      )}
      <div className="flex-1 min-w-0">
        {ad.badge && (
          <span className="text-[9px] font-black uppercase tracking-[0.15em] block" style={{ color: bc }}>
            {ad.badge}
          </span>
        )}
        <p className="text-xs font-bold truncate" style={{ color: tc }}>{ad.title}</p>
      </div>
      {ad.cta_text && (
        <span className="text-[10px] font-black flex-shrink-0 group-hover:translate-x-0.5 transition-transform"
          style={{ color: bc }}>
          →
        </span>
      )}
    </motion.div>
  );
}
