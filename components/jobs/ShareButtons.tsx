"use client";

import { useState } from "react";
import { Share2, Copy, Check } from "lucide-react";

interface Props {
  jobId: string;
  title: string;
  company: string;
  location: string;
}

export default function ShareButtons({ jobId, title, company, location }: Props) {
  const [copied, setCopied] = useState(false);

  const siteBase = typeof window !== "undefined"
    ? window.location.origin
    : (process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online");
  const url      = `${siteBase}/jobs/${jobId}`;
  const shareText = `🚀 ${title} at ${company} (${location})\n\nApply via AutomateQA 👇`;

  const nativeShare = async () => {
    const data = { title: `${title} at ${company} — AutomateQA`, text: shareText, url };
    try {
      if (navigator.share && navigator.canShare?.(data)) {
        await navigator.share(data);
        return;
      }
    } catch { /* cancelled */ }
    // fallback to clipboard
    copyLink();
  };

  const copyLink = async () => {
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch { /* unavailable */ }
  };

  const waLink  = `https://wa.me/?text=${encodeURIComponent(`${shareText}\n${url}`)}`;
  const twLink  = `https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText)}&url=${encodeURIComponent(url)}`;
  const liLink  = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`;

  return (
    <div className="flex flex-col gap-2">
      {/* Native / copy row */}
      <div className="flex gap-2">
        <button
          onClick={nativeShare}
          className="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-xs font-bold border transition-all"
          style={{
            background: "linear-gradient(135deg,rgba(0,255,136,0.10),rgba(0,212,255,0.06))",
            borderColor: "rgba(0,255,136,0.25)",
            color: "#00FF88",
          }}
        >
          <Share2 size={13} /> Share
        </button>

        <button
          onClick={copyLink}
          className="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-xs font-bold border transition-all"
          style={copied
            ? { background: "rgba(0,255,136,0.12)", borderColor: "rgba(0,255,136,0.35)", color: "#00FF88" }
            : { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.10)", color: "#9CA3AF" }
          }
        >
          {copied ? <Check size={13} /> : <Copy size={13} />}
          {copied ? "Copied!" : "Copy Link"}
        </button>
      </div>

      {/* Platform quick-share */}
      <div className="flex gap-2">
        <a
          href={waLink}
          target="_blank"
          rel="noopener noreferrer"
          className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl text-xs font-semibold border border-white/8 bg-white/3 text-[#9CA3AF] hover:bg-[#25D366]/10 hover:border-[#25D366]/30 hover:text-[#25D366] transition-all"
        >
          WhatsApp
        </a>
        <a
          href={twLink}
          target="_blank"
          rel="noopener noreferrer"
          className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl text-xs font-semibold border border-white/8 bg-white/3 text-[#9CA3AF] hover:bg-[#1DA1F2]/10 hover:border-[#1DA1F2]/30 hover:text-[#1DA1F2] transition-all"
        >
          Twitter / X
        </a>
        <a
          href={liLink}
          target="_blank"
          rel="noopener noreferrer"
          className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl text-xs font-semibold border border-white/8 bg-white/3 text-[#9CA3AF] hover:bg-[#0A66C2]/10 hover:border-[#0A66C2]/30 hover:text-[#0A66C2] transition-all"
        >
          LinkedIn
        </a>
      </div>
    </div>
  );
}
