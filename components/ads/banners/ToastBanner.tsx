"use client";

import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { motion, AnimatePresence } from "framer-motion";
import { X } from "lucide-react";
import { Ad } from "@/types";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

function ToastContent({ ad, onCtaClick, isPreview, onClose }: Props & { onClose: () => void }) {
  const bc = ad.button_color || "#00FF88";
  const tc = ad.text_color   || "#FFFFFF";

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
    onClose();
  };

  const positionClass = isPreview
    ? "absolute top-3 right-3 w-64"
    : "fixed top-20 right-4 z-50 w-72";

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0, x: 80, scale: 0.9 }}
        animate={{ opacity: 1, x: 0,  scale: 1   }}
        exit={{    opacity: 0, x: 80, scale: 0.95 }}
        transition={{ type: "spring", bounce: 0.3, duration: 0.4 }}
        className={`${positionClass} rounded-2xl overflow-hidden`}
        style={{
          background: "rgba(17,17,17,0.95)",
          backdropFilter: "blur(16px)",
          border: `1px solid ${bc}30`,
          boxShadow: `0 8px 40px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.04)`,
        }}
      >
        {/* top accent */}
        <div className="h-0.5" style={{ background: `linear-gradient(90deg, ${bc}, transparent)` }} />

        <div className="p-3 pr-8 relative">
          <button onClick={onClose}
            className="absolute top-3 right-3 p-0.5 rounded-md hover:bg-white/10 transition-all"
            style={{ color: `${tc}55` }}>
            <X size={12} />
          </button>

          {ad.badge && (
            <span className="text-[9px] font-black uppercase tracking-widest block mb-1" style={{ color: bc }}>
              {ad.badge}
            </span>
          )}
          <p className="text-xs font-black mb-0.5" style={{ color: tc }}>{ad.title}</p>
          {ad.subtitle && <p className="text-[11px] mb-2" style={{ color: `${tc}88` }}>{ad.subtitle}</p>}
          {ad.cta_text && (
            <button onClick={handleCta}
              className="text-xs font-black transition-all hover:opacity-80" style={{ color: bc }}>
              {ad.cta_text} →
            </button>
          )}
        </div>
      </motion.div>
    </AnimatePresence>
  );
}

export default function ToastBanner({ ad, onCtaClick, isPreview }: Props) {
  const [show, setShow] = useState(false);

  useEffect(() => {
    const t = setTimeout(() => setShow(true), isPreview ? 300 : 3000);
    return () => clearTimeout(t);
  }, [isPreview]);

  if (!show) return null;

  const content = <ToastContent ad={ad} onCtaClick={onCtaClick} isPreview={isPreview} onClose={() => setShow(false)} />;
  if (isPreview) return <div className="relative h-full">{content}</div>;
  if (typeof document === "undefined") return null;
  return createPortal(content, document.body);
}
