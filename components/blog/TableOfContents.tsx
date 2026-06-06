"use client";

import { useState, useEffect } from "react";
import { List, ChevronDown } from "lucide-react";

export interface Heading {
  id: string;
  text: string;
  level: number;
}

function scrollTo(id: string) {
  const el = document.getElementById(id);
  if (!el) return;
  const top = el.getBoundingClientRect().top + window.scrollY - 96;
  window.scrollTo({ top, behavior: "smooth" });
}

function TOCList({
  headings,
  activeId,
  onSelect,
}: {
  headings: Heading[];
  activeId: string;
  onSelect?: () => void;
}) {
  return (
    <nav className="space-y-0.5">
      {headings.map((h) => (
        <button
          key={h.id}
          onClick={() => { scrollTo(h.id); onSelect?.(); }}
          className={`block text-left w-full py-1.5 text-[0.78rem] leading-snug transition-all duration-150 rounded ${
            h.level === 3 ? "pl-3.5" : "pl-0"
          } ${
            activeId === h.id
              ? "text-[#00FF88] font-semibold"
              : "text-[#6B7280] hover:text-[#C9D1D9]"
          }`}
        >
          {activeId === h.id && (
            <span className="inline-block w-1.5 h-1.5 rounded-full bg-[#00FF88] mr-1.5 mb-[1px] align-middle" />
          )}
          {h.text}
        </button>
      ))}
    </nav>
  );
}

export function TableOfContentsMobile({ headings }: { headings: Heading[] }) {
  const [open, setOpen] = useState(false);
  const [activeId, setActiveId] = useState("");

  useEffect(() => {
    if (headings.length === 0) return;
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting);
        if (visible.length > 0) setActiveId(visible[0].target.id);
      },
      { rootMargin: "-80px 0px -65% 0px", threshold: 0 }
    );
    headings.forEach((h) => { const el = document.getElementById(h.id); if (el) observer.observe(el); });
    return () => observer.disconnect();
  }, [headings]);

  if (headings.length < 2) return null;

  return (
    <div className="lg:hidden mb-8 rounded-2xl border border-white/8 bg-[#111] overflow-hidden">
      <button
        onClick={() => setOpen((o) => !o)}
        className="flex items-center justify-between w-full px-4 py-3.5 text-left"
      >
        <span className="flex items-center gap-2 text-white font-semibold text-sm">
          <List size={14} className="text-[#00FF88]" />
          Table of Contents
        </span>
        <ChevronDown
          size={16}
          className={`text-[#9CA3AF] transition-transform duration-200 ${open ? "rotate-180" : ""}`}
        />
      </button>
      {open && (
        <div className="px-4 pb-4 border-t border-white/5 pt-3">
          <TOCList headings={headings} activeId={activeId} onSelect={() => setOpen(false)} />
        </div>
      )}
    </div>
  );
}

export function TableOfContentsDesktop({ headings }: { headings: Heading[] }) {
  const [activeId, setActiveId] = useState("");

  useEffect(() => {
    if (headings.length === 0) return;
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting);
        if (visible.length > 0) setActiveId(visible[0].target.id);
      },
      { rootMargin: "-80px 0px -65% 0px", threshold: 0 }
    );
    headings.forEach((h) => { const el = document.getElementById(h.id); if (el) observer.observe(el); });
    return () => observer.disconnect();
  }, [headings]);

  if (headings.length < 2) return null;

  return (
    <div className="sticky top-24">
      <p className="text-[10px] font-bold text-[#4B5563] uppercase tracking-widest mb-3 px-0.5">
        On This Page
      </p>
      <TOCList headings={headings} activeId={activeId} />
      <div className="mt-4 pt-4 border-t border-white/5">
        <button
          onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}
          className="text-[0.7rem] text-[#4B5563] hover:text-[#9CA3AF] transition-colors flex items-center gap-1.5"
        >
          ↑ Back to top
        </button>
      </div>
    </div>
  );
}
