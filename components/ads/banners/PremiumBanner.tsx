"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { ExternalLink, ArrowRight } from "lucide-react";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function PremiumBanner({ ad, onCtaClick, isPreview }: Props) {
  const bg   = ad.gradient
    ? `linear-gradient(135deg, ${ad.gradient})`
    : ad.bg_color || "#0D0D0D";
  const tc   = ad.text_color   || "#FFFFFF";
  const bc   = ad.button_color || "#00FF88";
  const anim = getAdAnimationVariants(ad.animation);

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
  };

  return (
    <motion.div
      {...anim}
      className="relative w-full overflow-hidden rounded-2xl"
      style={{ background: bg, boxShadow: `0 8px 40px ${bc}20` }}
    >
      {/* shimmer overlay */}
      {ad.animation === "shimmer" && (
        <div className="absolute inset-0 pointer-events-none"
          style={{ background: "linear-gradient(90deg,transparent 0%,rgba(255,255,255,0.06) 50%,transparent 100%)", backgroundSize: "200% 100%", animation: "shimmer 2.5s infinite" }} />
      )}

      {/* optional desktop image background */}
      {ad.desktop_image_url && (
        <div className="absolute inset-0">
          <Image src={ad.desktop_image_url} alt="" fill className="object-cover opacity-20" />
        </div>
      )}

      <div className="relative flex flex-col sm:flex-row items-start sm:items-center gap-5 p-6 sm:p-8">
        {/* logo */}
        {ad.logo_url && (
          <div className="flex-shrink-0 w-14 h-14 rounded-2xl overflow-hidden border border-white/10"
            style={{ background: "rgba(255,255,255,0.06)" }}>
            <Image src={ad.logo_url} alt="logo" width={56} height={56} className="w-full h-full object-contain p-2" />
          </div>
        )}

        {/* text */}
        <div className="flex-1 min-w-0">
          {ad.badge && (
            <span className="inline-block text-[10px] font-black uppercase tracking-[0.18em] px-3 py-1 rounded-full mb-3"
              style={{ background: `${bc}22`, color: bc, border: `1px solid ${bc}44` }}>
              {ad.badge}
            </span>
          )}
          <h3 className="text-xl sm:text-2xl font-black leading-tight mb-1" style={{ color: tc }}>
            {ad.title}
          </h3>
          {ad.subtitle && (
            <p className="text-sm font-semibold mb-1" style={{ color: `${tc}CC` }}>{ad.subtitle}</p>
          )}
          {ad.description && (
            <p className="text-sm leading-relaxed" style={{ color: `${tc}88` }}>{ad.description}</p>
          )}
        </div>

        {/* CTA */}
        {ad.cta_text && (
          <div className="flex-shrink-0 self-center sm:self-auto">
            <motion.button
              whileHover={{ scale: 1.04 }}
              whileTap={{ scale: 0.97 }}
              onClick={handleCta}
              className="flex items-center gap-2 px-6 py-3 rounded-xl text-sm font-black transition-all"
              style={{
                background: `linear-gradient(135deg, ${bc}, ${bc}CC)`,
                color: "#0B0B0B",
                boxShadow: `0 4px 20px ${bc}40`,
              }}
            >
              {ad.cta_text}
              {ad.cta_link ? <ExternalLink size={13} /> : <ArrowRight size={13} />}
            </motion.button>
          </div>
        )}
      </div>
    </motion.div>
  );
}
