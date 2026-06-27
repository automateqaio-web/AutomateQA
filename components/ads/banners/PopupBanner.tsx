"use client";

import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { motion, AnimatePresence } from "framer-motion";
import Image from "next/image";
import { X } from "lucide-react";
import { Ad } from "@/types";

interface Props { ad: Ad; onCtaClick?: () => void; isPreview?: boolean }

function PopupContent({ ad, onCtaClick, onClose, isPreview }: Props & { onClose: () => void }) {
  const bc = ad.button_color || "#00FF88";
  const tc = ad.text_color   || "#FFFFFF";
  const bg = ad.gradient
    ? `linear-gradient(160deg, ${ad.gradient})`
    : ad.bg_color || "#111111";

  const handleCta = () => {
    onCtaClick?.();
    if (!isPreview && ad.cta_link) {
      if (ad.cta_open === "same_tab") window.location.href = ad.cta_link;
      else window.open(ad.cta_link, "_blank", "noopener,noreferrer");
    }
    onClose();
  };

  const overlay = (
    <AnimatePresence>
      <motion.div
        key="popup-overlay"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className={isPreview ? "absolute inset-0 flex items-center justify-center p-4 rounded-xl" : "fixed inset-0 z-[200] flex items-center justify-center p-4"}
        style={{ background: isPreview ? "rgba(0,0,0,0.6)" : "rgba(0,0,0,0.75)", backdropFilter: "blur(6px)" }}
        onClick={onClose}
      >
        <motion.div
          key="popup-card"
          initial={{ opacity: 0, scale: 0.9, y: 20 }}
          animate={{ opacity: 1, scale: 1,   y: 0  }}
          exit={{    opacity: 0, scale: 0.95, y: 10 }}
          transition={{ type: "spring", bounce: 0.3, duration: 0.45 }}
          className="relative w-full max-w-md rounded-2xl overflow-hidden"
          style={{ background: bg, boxShadow: `0 24px 80px rgba(0,0,0,0.7), 0 0 0 1px ${bc}20` }}
          onClick={e => e.stopPropagation()}
        >
          {/* close */}
          <button onClick={onClose}
            className="absolute top-4 right-4 z-10 p-1.5 rounded-lg transition-all hover:bg-white/10"
            style={{ color: `${tc}88` }}>
            <X size={16} />
          </button>

          {/* header image */}
          {ad.desktop_image_url && (
            <div className="relative w-full h-40">
              <Image src={ad.desktop_image_url} alt={ad.title} fill className="object-cover" />
              <div className="absolute inset-0" style={{ background: "linear-gradient(to bottom, transparent 30%, rgba(0,0,0,0.7))" }} />
            </div>
          )}

          <div className="p-6">
            {/* logo */}
            {ad.logo_url && (
              <Image src={ad.logo_url} alt="logo" width={48} height={48}
                className="w-12 h-12 rounded-xl object-contain mb-3"
                style={{ border: `1px solid ${bc}25`, background: "rgba(255,255,255,0.05)" }} />
            )}

            {ad.badge && (
              <span className="inline-block text-[10px] font-black uppercase tracking-[0.18em] px-3 py-1 rounded-full mb-3"
                style={{ background: `${bc}20`, color: bc, border: `1px solid ${bc}35` }}>
                {ad.badge}
              </span>
            )}

            <h2 className="text-2xl font-black mb-2 leading-tight" style={{ color: tc }}>{ad.title}</h2>
            {ad.subtitle && <p className="text-sm font-semibold mb-2" style={{ color: `${tc}CC` }}>{ad.subtitle}</p>}
            {ad.description && (
              <p className="text-sm leading-relaxed mb-5" style={{ color: `${tc}88` }}>{ad.description}</p>
            )}

            {ad.cta_text && (
              <motion.button whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
                onClick={handleCta}
                className="w-full py-3 rounded-xl text-sm font-black"
                style={{ background: bc, color: "#0B0B0B", boxShadow: `0 4px 20px ${bc}40` }}
              >
                {ad.cta_text}
              </motion.button>
            )}
          </div>
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );

  if (isPreview) return <div className="relative h-full">{overlay}</div>;
  if (typeof document === "undefined") return null;
  return createPortal(overlay, document.body);
}

export default function PopupBanner({ ad, onCtaClick, isPreview }: Props) {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setOpen(true), isPreview ? 300 : 2000);
    return () => clearTimeout(timer);
  }, [isPreview]);

  if (!open) return null;
  return <PopupContent ad={ad} onCtaClick={onCtaClick} isPreview={isPreview} onClose={() => setOpen(false)} />;
}
