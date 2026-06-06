"use client";

import { useState, useEffect } from "react";
import { List, ChevronDown, ArrowUp } from "lucide-react";

export interface Heading {
  id: string;
  text: string;
  level: number;
}

function scrollToId(id: string) {
  const el = document.getElementById(id);
  if (!el) return;
  const top = el.getBoundingClientRect().top + window.scrollY - 96;
  window.scrollTo({ top, behavior: "smooth" });
}

function useActiveHeading(headings: Heading[]) {
  const [activeId, setActiveId] = useState("");
  useEffect(() => {
    if (headings.length === 0) return;
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting);
        if (visible.length > 0) setActiveId(visible[0].target.id);
      },
      { rootMargin: "-80px 0px -60% 0px", threshold: 0 }
    );
    headings.forEach((h) => {
      const el = document.getElementById(h.id);
      if (el) observer.observe(el);
    });
    return () => observer.disconnect();
  }, [headings]);
  return activeId;
}

/* ─── Mobile: collapsible accordion ─── */
export function TableOfContentsMobile({ headings }: { headings: Heading[] }) {
  const [open, setOpen] = useState(false);
  const activeId = useActiveHeading(headings);

  if (headings.length < 2) return null;

  return (
    <div className="lg:hidden mb-8 rounded-2xl border border-white/10 bg-[#0E0E0E] overflow-hidden shadow-[0_2px_16px_rgba(0,0,0,0.4)]">
      <button
        onClick={() => setOpen((o) => !o)}
        className="flex items-center justify-between w-full px-5 py-4 text-left group"
      >
        <span className="flex items-center gap-2.5 text-white font-semibold text-sm">
          <span className="w-5 h-5 rounded-md bg-[#00FF88]/15 flex items-center justify-center">
            <List size={11} className="text-[#00FF88]" />
          </span>
          Table of Contents
        </span>
        <ChevronDown
          size={16}
          className={`text-[#6B7280] transition-transform duration-200 ${open ? "rotate-180" : ""}`}
        />
      </button>
      {open && (
        <div className="border-t border-white/5 px-3 pb-3 pt-2">
          {headings.map((h) => (
            <button
              key={h.id}
              onClick={() => { scrollToId(h.id); setOpen(false); }}
              className={`flex items-center gap-2 w-full text-left px-3 py-2 rounded-lg text-[0.8rem] transition-all duration-150 ${
                h.level === 3 ? "ml-3" : ""
              } ${
                activeId === h.id
                  ? "bg-[#00FF88]/8 text-[#00FF88] font-medium"
                  : "text-[#9CA3AF] hover:text-white hover:bg-white/[0.04]"
              }`}
            >
              {activeId === h.id && (
                <span className="w-1 h-1 rounded-full bg-[#00FF88] flex-shrink-0" />
              )}
              {h.level === 3 && activeId !== h.id && (
                <span className="w-1 h-1 rounded-full bg-[#374151] flex-shrink-0" />
              )}
              {h.text}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

/* ─── Desktop: sticky sidebar ─── */
export function TableOfContentsDesktop({ headings }: { headings: Heading[] }) {
  const activeId = useActiveHeading(headings);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const update = () => {
      const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
      const total = scrollHeight - clientHeight;
      setProgress(total > 0 ? Math.min((scrollTop / total) * 100, 100) : 0);
    };
    window.addEventListener("scroll", update, { passive: true });
    update();
    return () => window.removeEventListener("scroll", update);
  }, []);

  if (headings.length < 2) return null;

  return (
    <div className="sticky top-24">
      {/* Card */}
      <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden shadow-[0_4px_24px_rgba(0,0,0,0.4)]">
        {/* Header */}
        <div className="flex items-center gap-2.5 px-4 py-3.5 border-b border-white/5">
          <span className="w-5 h-5 rounded-md bg-[#00FF88]/15 flex items-center justify-center flex-shrink-0">
            <List size={10} className="text-[#00FF88]" />
          </span>
          <span className="text-[11px] font-bold text-[#9CA3AF] uppercase tracking-[0.12em]">
            On This Page
          </span>
        </div>

        {/* Progress bar */}
        <div className="h-[2px] bg-white/5">
          <div
            className="h-full bg-gradient-to-r from-[#00FF88] to-[#00CC6A] transition-[width] duration-150"
            style={{ width: `${progress}%` }}
          />
        </div>

        {/* Links */}
        <nav className="p-3 space-y-0.5">
          {headings.map((h) => {
            const isActive = activeId === h.id;
            return (
              <button
                key={h.id}
                onClick={() => scrollToId(h.id)}
                className={`relative flex items-start gap-2.5 w-full text-left px-3 py-2 rounded-lg text-[0.75rem] leading-snug transition-all duration-200 group ${
                  h.level === 3 ? "ml-3 mr-1" : ""
                } ${
                  isActive
                    ? "bg-[#00FF88]/8 text-[#00FF88] font-semibold shadow-[inset_0_0_0_1px_rgba(0,255,136,0.12)]"
                    : "text-[#6B7280] hover:text-[#C9D1D9] hover:bg-white/[0.04]"
                }`}
              >
                {/* Active indicator bar */}
                {isActive && (
                  <span className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-4 rounded-r-full bg-[#00FF88] shadow-[0_0_6px_#00FF88]" />
                )}
                {/* Dot for h3 */}
                {h.level === 3 && (
                  <span
                    className={`flex-shrink-0 w-[5px] h-[5px] rounded-full mt-[4px] transition-colors ${
                      isActive ? "bg-[#00FF88]" : "bg-[#2A2A2A] group-hover:bg-[#4B5563]"
                    }`}
                  />
                )}
                <span className="flex-1">{h.text}</span>
              </button>
            );
          })}
        </nav>

        {/* Back to top */}
        <div className="px-3 pb-3">
          <button
            onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}
            className="flex items-center gap-2 w-full px-3 py-2 rounded-lg text-[0.72rem] text-[#4B5563] hover:text-[#9CA3AF] hover:bg-white/[0.03] transition-all border border-transparent hover:border-white/8"
          >
            <ArrowUp size={11} />
            Back to top
          </button>
        </div>
      </div>
    </div>
  );
}
