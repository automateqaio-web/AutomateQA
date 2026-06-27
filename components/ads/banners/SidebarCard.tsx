"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function SidebarCard({ ad, onCtaClick, isPreview }: Props) {
  const bc   = ad.button_color || "#00FF88";
  const tc   = ad.text_color   || "#FFFFFF";
  const bg   = ad.gradient
    ? `linear-gradient(160deg, ${ad.gradient})`
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
    <motion.div {...anim} className="relative overflow-hidden rounded-2xl"
      style={{ background: bg, border: `1px solid ${bc}20`, boxShadow: `0 4px 24px ${bc}10` }}
    >
      {/* image */}
      {ad.desktop_image_url && (
        <div className="relative w-full h-32">
          <Image src={ad.desktop_image_url} alt={ad.title} fill className="object-cover" />
          <div className="absolute inset-0" style={{ background: "linear-gradient(to bottom, transparent 40%, rgba(0,0,0,0.8))" }} />
        </div>
      )}

      <div className="p-4">
        {/* logo + badge */}
        <div className="flex items-center gap-2 mb-3">
          {ad.logo_url && (
            <Image src={ad.logo_url} alt="logo" width={28} height={28}
              className="w-7 h-7 rounded-lg object-contain flex-shrink-0"
              style={{ border: `1px solid ${bc}20` }} />
          )}
          {ad.badge && (
            <span className="text-[10px] font-black uppercase tracking-[0.15em] px-2 py-0.5 rounded-full"
              style={{ background: `${bc}18`, color: bc, border: `1px solid ${bc}30` }}>
              {ad.badge}
            </span>
          )}
        </div>

        <h3 className="text-sm font-black leading-tight mb-1" style={{ color: tc }}>{ad.title}</h3>
        {ad.subtitle && <p className="text-xs mb-2" style={{ color: `${tc}AA` }}>{ad.subtitle}</p>}
        {ad.description && (
          <p className="text-[11px] leading-relaxed mb-3" style={{ color: `${tc}66` }}>
            {ad.description.slice(0, 100)}{ad.description.length > 100 ? "…" : ""}
          </p>
        )}

        {ad.cta_text && (
          <motion.button whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
            onClick={handleCta}
            className="w-full py-2 rounded-xl text-xs font-black transition-all"
            style={{ background: bc, color: "#0B0B0B", boxShadow: `0 2px 12px ${bc}40` }}
          >
            {ad.cta_text}
          </motion.button>
        )}
      </div>
    </motion.div>
  );
}
