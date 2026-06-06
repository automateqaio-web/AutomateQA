"use client";

import { useState } from "react";
import { Share2, Check } from "lucide-react";

export default function ShareButton({ id, title, caption }: { id: string; title: string; caption: string }) {
  const [copied, setCopied] = useState(false);

  const handleShare = async () => {
    const url = `${window.location.origin}/memes/${id}`;
    if (navigator.share) {
      await navigator.share({ title, text: caption, url });
    } else {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  return (
    <button
      onClick={handleShare}
      className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-[#1A1A1A] border border-[#2A2A2A] text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/30 transition-all text-sm"
    >
      {copied ? <Check size={13} className="text-[#00FF88]" /> : <Share2 size={13} />}
      {copied ? "Copied!" : "Share"}
    </button>
  );
}
