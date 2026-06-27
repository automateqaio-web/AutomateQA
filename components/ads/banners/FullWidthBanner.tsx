"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { ExternalLink } from "lucide-react";
import { Ad } from "@/types";
import { getAdAnimationVariants } from "../adUtils";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

export default function FullWidthBanner({ ad, onCtaClick, isPreview }: Props) {
  const bc  = ad.button_color || "#00FF88";
  const tc  = ad.text_color   || "#FFFFFF";
  const bg  = ad.gradient
    ? `linear-gradient(135deg, ${ad.gradient})`
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
    <motion.div
      {...anim}
      className="w-full relative overflow-hidden"
      style={{ background: bg, boxShadow: "0 4px 32px rgba(0,0,0,0.5)" }}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-8">
        <div className="flex items-center gap-3 sm:gap-5 py-3 sm:py-4">

          {/* Logo */}
          {ad.logo_url && (
            <div className="relative w-10 h-10 flex-shrink-0">
              <Image
                src={ad.logo_url}
                alt="logo"
                fill
                className="rounded-xl object-contain"
                style={{ border: `1px solid ${bc}30` }}
              />
            </div>
          )}

          {/* Text */}
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-x-2 gap-y-0.5">
              {ad.badge && (
                <span
                  className="text-[10px] font-black uppercase tracking-widest flex-shrink-0"
                  style={{ color: bc }}
                >
                  {ad.badge}
                </span>
              )}
              <span
                className="text-sm sm:text-base font-black leading-tight"
                style={{ color: tc }}
              >
                {ad.title}
              </span>
            </div>
            {ad.subtitle && (
              <p
                className="text-xs mt-0.5 hidden sm:block line-clamp-1"
                style={{ color: `${tc}80` }}
              >
                {ad.subtitle}
              </p>
            )}
          </div>

          {/* Promotional image — visible on sm+ */}
          {ad.desktop_image_url && (
            <div className="relative h-16 w-20 sm:h-20 sm:w-28 flex-shrink-0 hidden sm:block">
              <Image
                src={ad.desktop_image_url}
                alt={ad.title}
                fill
                className="object-contain drop-shadow-lg"
                sizes="(max-width: 640px) 0px, 112px"
              />
            </div>
          )}

          {/* CTA */}
          {ad.cta_text && (
            <motion.button
              whileHover={{ scale: 1.04 }}
              whileTap={{ scale: 0.97 }}
              onClick={handleCta}
              className="flex-shrink-0 flex items-center gap-1.5 px-4 sm:px-6 py-2.5 rounded-xl text-xs sm:text-sm font-black whitespace-nowrap"
              style={{
                background: bc,
                color: "#0B0B0B",
                boxShadow: `0 2px 16px ${bc}50`,
              }}
            >
              {ad.cta_text} <ExternalLink size={12} />
            </motion.button>
          )}
        </div>
      </div>
    </motion.div>
  );
}
