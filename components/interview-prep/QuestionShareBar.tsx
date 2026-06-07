"use client";
import { useState, useEffect } from "react";
import { Link2, Check } from "lucide-react";

export default function QuestionShareBar({ question }: { question: string }) {
  const [copied, setCopied] = useState(false);
  const [pageUrl, setPageUrl] = useState("");

  useEffect(() => { setPageUrl(window.location.href); }, []);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(pageUrl);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  };

  if (!pageUrl) return null;

  const encoded = encodeURIComponent(pageUrl);
  const encodedText = encodeURIComponent(`Check out this QA interview question: ${question}`);

  return (
    <div className="mt-10 pt-8 border-t border-white/[0.07]">
      <p className="text-xs font-bold text-[#4B5563] uppercase tracking-widest mb-4">Share this question</p>
      <div className="flex flex-wrap gap-2">
        <a
          href={`https://twitter.com/intent/tweet?url=${encoded}&text=${encodedText}`}
          target="_blank" rel="noopener noreferrer"
          className="flex items-center gap-2 px-4 py-2 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-sky-500/30 hover:text-sky-400 hover:bg-sky-500/5 text-xs font-medium transition-all"
        >
          <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-4.714-6.231-5.401 6.231H2.748l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
          </svg>
          Share on X
        </a>
        <a
          href={`https://www.linkedin.com/sharing/share-offsite/?url=${encoded}`}
          target="_blank" rel="noopener noreferrer"
          className="flex items-center gap-2 px-4 py-2 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-blue-500/30 hover:text-blue-400 hover:bg-blue-500/5 text-xs font-medium transition-all"
        >
          <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
            <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z" />
            <rect x="2" y="9" width="4" height="12" /><circle cx="4" cy="4" r="2" />
          </svg>
          LinkedIn
        </a>
        <a
          href={`https://wa.me/?text=${encodedText}%20${encoded}`}
          target="_blank" rel="noopener noreferrer"
          className="flex items-center gap-2 px-4 py-2 rounded-xl border border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-green-500/30 hover:text-green-400 hover:bg-green-500/5 text-xs font-medium transition-all"
        >
          <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
            <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z" />
          </svg>
          WhatsApp
        </a>
        <button
          onClick={handleCopy}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl border text-xs font-medium transition-all ${
            copied
              ? "border-[#00FF88]/30 text-[#00FF88] bg-[#00FF88]/5"
              : "border-white/8 bg-white/[0.03] text-[#9CA3AF] hover:border-white/20 hover:text-white"
          }`}
        >
          {copied ? <Check size={12} /> : <Link2 size={12} />}
          {copied ? "Copied!" : "Copy Link"}
        </button>
      </div>
    </div>
  );
}
