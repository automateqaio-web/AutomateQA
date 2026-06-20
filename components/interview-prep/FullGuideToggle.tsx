"use client";

import { useState } from "react";
import { ChevronDown, BookOpen } from "lucide-react";
import InterviewAnswerContent from "./InterviewAnswerContent";

interface Props {
  content: string;
  accent: string;
  label?: string;
}

export default function FullGuideToggle({ content, accent, label = "Answer" }: Props) {
  const [open, setOpen] = useState(false);

  return (
    <div className="mb-10">
      {/* Section header */}
      <div className="flex items-center gap-3 mb-5">
        <div
          className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0"
          style={{ background: `${accent}18`, border: `1px solid ${accent}30`, color: accent }}
        >
          <BookOpen size={15} />
        </div>
        <h2 className="text-lg font-black" style={{ color: accent }}>
          {label}
        </h2>
        <div className="flex-1 h-px" style={{ background: `linear-gradient(90deg, ${accent}25, transparent)` }} />
      </div>

      {/* Toggle banner */}
      <button
        onClick={() => setOpen((v) => !v)}
        className="w-full flex items-center justify-between gap-4 px-5 py-4 rounded-2xl border transition-all duration-200 text-left group"
        style={{
          border: `1px solid ${open ? accent + "35" : accent + "18"}`,
          background: open
            ? `linear-gradient(135deg, ${accent}10 0%, #0A0A0A 60%)`
            : `linear-gradient(135deg, ${accent}06 0%, #0A0A0A 60%)`,
        }}
      >
        <div className="flex items-center gap-3">
          <div
            className="w-8 h-8 rounded-xl flex items-center justify-center flex-shrink-0"
            style={{ background: `${accent}15`, border: `1px solid ${accent}25` }}
          >
            <span className="text-sm">📖</span>
          </div>
          <div>
            <p className="text-sm font-black text-white">
              {open ? "Full Guide" : "View Full Guide"}
            </p>
            <p className="text-[11px] mt-0.5" style={{ color: accent + "80" }}>
              {open ? "Detailed explanation with code examples" : "Deep dive — code, examples & best practices"}
            </p>
          </div>
        </div>
        <div
          className="flex-shrink-0 w-7 h-7 rounded-lg flex items-center justify-center transition-all duration-300"
          style={{ background: `${accent}15`, border: `1px solid ${accent}25` }}
        >
          <ChevronDown
            size={14}
            style={{ color: accent }}
            className={`transition-transform duration-300 ${open ? "rotate-180" : ""}`}
          />
        </div>
      </button>

      {/* Full content */}
      {open && (
        <div
          className="mt-3 rounded-2xl overflow-hidden"
          style={{
            border: `1px solid ${accent}18`,
            background: `linear-gradient(160deg, ${accent}06 0%, #0A0A0A 50%)`,
            boxShadow: `0 4px 32px rgba(0,0,0,0.4), inset 0 1px 0 ${accent}12`,
          }}
        >
          <div className="h-px" style={{ background: `linear-gradient(90deg, transparent, ${accent}30, transparent)` }} />
          <div className="px-6 py-6">
            <InterviewAnswerContent content={content} accent={accent} />
          </div>
        </div>
      )}
    </div>
  );
}
