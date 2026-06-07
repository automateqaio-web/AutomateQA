"use client";
import { useState } from "react";
import { Check, Copy } from "lucide-react";

export default function QuestionCodeBlock({ code, language }: { code: string; language: string }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(code);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  };

  return (
    <div className="rounded-xl border border-white/8 overflow-hidden shadow-[0_4px_24px_rgba(0,0,0,0.4)]">
      <div className="flex items-center justify-between px-4 py-2.5 bg-[#0D0D0D] border-b border-white/5">
        <div className="flex items-center gap-2">
          <div className="flex gap-1.5">
            <span className="w-3 h-3 rounded-full bg-red-500/60" />
            <span className="w-3 h-3 rounded-full bg-yellow-500/60" />
            <span className="w-3 h-3 rounded-full bg-green-500/60" />
          </div>
          <span className="text-xs font-mono text-[#6B7280] ml-2">{language}</span>
        </div>
        <button
          onClick={handleCopy}
          className={`flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-medium transition-all ${
            copied
              ? "border border-[#00FF88]/30 text-[#00FF88] bg-[#00FF88]/5"
              : "border border-white/8 text-[#6B7280] hover:text-[#9CA3AF] hover:border-white/15"
          }`}
        >
          {copied ? <Check size={11} /> : <Copy size={11} />}
          {copied ? "Copied!" : "Copy"}
        </button>
      </div>
      <pre className="p-5 overflow-x-auto bg-[#060606] m-0">
        <code className="text-xs font-mono text-[#C9D1D9] leading-relaxed whitespace-pre">{code}</code>
      </pre>
    </div>
  );
}
