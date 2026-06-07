"use client";

import { useState, useEffect } from "react";
import { Link2 } from "lucide-react";

export default function TipShareButtons({ title }: { title: string }) {
  const [url, setUrl] = useState("");
  const [copied, setCopied] = useState(false);

  useEffect(() => { setUrl(window.location.href); }, []);

  const enc = (s: string) => encodeURIComponent(s);

  async function copy() {
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  }

  return (
    <div className="flex items-center gap-2">
      <span className="text-xs text-[#6B7280] mr-1 hidden sm:block">Share:</span>
      <a
        href={`https://twitter.com/intent/tweet?url=${enc(url)}&text=${enc(title)}`}
        target="_blank" rel="noopener noreferrer"
        title="Share on X"
        className="p-2 rounded-lg border border-white/10 bg-white/[0.03] text-[#9CA3AF] hover:text-sky-400 hover:border-sky-500/30 transition-all"
      >
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
          <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-4.714-6.231-5.401 6.231H2.748l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
        </svg>
      </a>
      <a
        href={`https://www.linkedin.com/sharing/share-offsite/?url=${enc(url)}`}
        target="_blank" rel="noopener noreferrer"
        title="Share on LinkedIn"
        className="p-2 rounded-lg border border-white/10 bg-white/[0.03] text-[#9CA3AF] hover:text-blue-400 hover:border-blue-500/30 transition-all"
      >
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
          <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z" />
          <rect x="2" y="9" width="4" height="12" /><circle cx="4" cy="4" r="2" />
        </svg>
      </a>
      <a
        href={`https://www.facebook.com/sharer/sharer.php?u=${enc(url)}`}
        target="_blank" rel="noopener noreferrer"
        title="Share on Facebook"
        className="p-2 rounded-lg border border-white/10 bg-white/[0.03] text-[#9CA3AF] hover:text-blue-500 hover:border-blue-600/30 transition-all"
      >
        <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
          <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z" />
        </svg>
      </a>
      <button
        onClick={copy}
        title="Copy link"
        className={`p-2 rounded-lg border transition-all ${
          copied
            ? "border-[#00FF88]/30 text-[#00FF88] bg-[#00FF88]/5"
            : "border-white/10 bg-white/[0.03] text-[#9CA3AF] hover:text-white hover:border-white/20"
        }`}
      >
        <Link2 size={13} />
      </button>
    </div>
  );
}
