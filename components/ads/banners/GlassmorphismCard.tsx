"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { Sparkles } from "lucide-react";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function GlassmorphismCard({ ad, onCtaClick, isPreview }: Props) {
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
    <motion.div {...anim} className="relative overflow-hidden rounded-2xl"
      style={{
        background: "rgba(255,255,255,0.04)",
        backdropFilter: "blur(20px)",
        border: `1px solid ${bc}30`,
        boxShadow: `0 8px 40px rgba(0,0,0,0.4), inset 0 1px 0 ${bc}20`,
      }}
    >
      {/* gradient top bar */}
      <div className="h-1 w-full rounded-t-2xl"
        style={{ background: `linear-gradient(90deg, ${bc}, ${bc}88)` }} />

      <div className="p-6">
        {/* header row */}
        <div className="flex items-center gap-3 mb-4">
          {ad.logo_url ? (
            <div className="w-10 h-10 rounded-xl overflow-hidden flex-shrink-0"
              style={{ background: "rgba(255,255,255,0.06)", border: `1px solid ${bc}20` }}>
              <Image src={ad.logo_url} alt="logo" width={40} height={40} className="w-full h-full object-contain p-1.5" />
            </div>
          ) : (
            <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0"
              style={{ background: `${bc}15`, border: `1px solid ${bc}25` }}>
              <Sparkles size={18} style={{ color: bc }} />
            </div>
          )}
          <div>
            {ad.badge && (
              <span className="text-[10px] font-black uppercase tracking-[0.15em]" style={{ color: bc }}>
                {ad.badge}
              </span>
            )}
            <p className="text-[11px] font-semibold" style={{ color: `${tc}55` }}>Advertisement</p>
          </div>
        </div>

        {/* content */}
        <h3 className="text-lg font-black mb-1 leading-tight" style={{ color: tc }}>{ad.title}</h3>
        {ad.subtitle && <p className="text-sm font-semibold mb-2" style={{ color: `${tc}BB` }}>{ad.subtitle}</p>}
        {ad.description && (
          <p className="text-xs leading-relaxed mb-4" style={{ color: `${tc}77` }}>{ad.description}</p>
        )}

        {/* CTA */}
        {ad.cta_text && (
          <motion.button whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
            onClick={handleCta}
            className="w-full py-2.5 rounded-xl text-sm font-black transition-all"
            style={{
              background: `linear-gradient(135deg, ${bc}22, ${bc}11)`,
              border: `1px solid ${bc}40`,
              color: bc,
              boxShadow: `0 0 20px ${bc}15`,
            }}
          >
            {ad.cta_text} →
          </motion.button>
        )}
      </div>
    </motion.div>
  );
}
