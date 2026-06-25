"use client";

import { useState, useMemo } from "react";
import Link from "next/link";
import {
  Lightbulb, Play, Target, FlaskConical,
  ChevronDown, ChevronRight, Terminal, Copy, Check,
  BookOpen, Zap,
} from "lucide-react";
import hljs from "highlight.js/lib/core";
import javascript from "highlight.js/lib/languages/javascript";
import typescript from "highlight.js/lib/languages/typescript";
import bash from "highlight.js/lib/languages/bash";

hljs.registerLanguage("javascript", javascript);
hljs.registerLanguage("js", javascript);
hljs.registerLanguage("typescript", typescript);
hljs.registerLanguage("ts", typescript);
hljs.registerLanguage("bash", bash);
hljs.registerLanguage("shell", bash);

// ─── Code display primitives ────────────────────────────────────────────────

interface CodeBlockProps {
  code: string;
  language?: string;
  filename?: string;
}

export function CodeBlock({ code, language = "js", filename }: CodeBlockProps) {
  const [copied, setCopied] = useState(false);

  const highlighted = useMemo(() => {
    const lang = ["js", "ts", "javascript", "typescript"].includes(language) ? language : "js";
    try {
      return hljs.highlight(code, { language: lang, ignoreIllegals: true }).value;
    } catch {
      return code;
    }
  }, [code, language]);

  function handleCopy() {
    navigator.clipboard.writeText(code).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  }

  return (
    <div className="rounded-xl border border-white/10 overflow-hidden my-4 font-mono text-sm shadow-lg shadow-black/40">
      <div className="flex items-center gap-3 px-4 py-2.5 bg-[#161616] border-b border-white/8">
        <div className="flex gap-1.5 flex-shrink-0">
          <span className="w-3 h-3 rounded-full bg-[#FF5F57]" />
          <span className="w-3 h-3 rounded-full bg-[#FEBC2E]" />
          <span className="w-3 h-3 rounded-full bg-[#28C840]" />
        </div>
        {filename ? (
          <div className="flex items-center gap-2 flex-1 min-w-0">
            <Terminal size={11} className="text-[#4B5563] flex-shrink-0" />
            <span className="text-xs text-[#9CA3AF] truncate">{filename}</span>
          </div>
        ) : (
          <span className="text-[10px] text-[#4B5563] uppercase tracking-widest flex-1">{language}</span>
        )}
        <button
          onClick={handleCopy}
          className="flex items-center gap-1.5 px-2 py-1 rounded text-[10px] text-[#6B7280] hover:text-[#00FF88] hover:bg-[#00FF88]/8 transition-all flex-shrink-0"
        >
          {copied ? <Check size={11} className="text-[#00FF88]" /> : <Copy size={11} />}
          <span className="font-mono">{copied ? "Copied!" : "Copy"}</span>
        </button>
      </div>
      <pre className="bg-[#0C0C0C] p-5 overflow-x-auto leading-relaxed">
        <code
          className="hljs"
          dangerouslySetInnerHTML={{ __html: highlighted }}
        />
      </pre>
    </div>
  );
}

export function OutputBlock({ output }: { output: string }) {
  return (
    <div className="rounded-xl border border-[#00FF88]/25 overflow-hidden my-4 font-mono text-sm shadow-lg shadow-[#00FF88]/5">
      <div className="flex items-center gap-2 px-4 py-2.5 bg-[#00FF88]/8 border-b border-[#00FF88]/20">
        <div className="flex gap-1.5">
          <span className="w-2.5 h-2.5 rounded-full bg-[#00FF88]/30" />
          <span className="w-2.5 h-2.5 rounded-full bg-[#00FF88]/20" />
          <span className="w-2.5 h-2.5 rounded-full bg-[#00FF88]/10" />
        </div>
        <span className="text-[10px] font-bold text-[#00FF88]/70 tracking-widest uppercase ml-1">Output</span>
      </div>
      <pre className="bg-[#050F08] p-5 overflow-x-auto leading-relaxed">
        <code className="text-[#00FF88]">{output}</code>
      </pre>
    </div>
  );
}

export function BashBlock({ code }: { code: string }) {
  const [copied, setCopied] = useState(false);

  function handleCopy() {
    navigator.clipboard.writeText(code).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  }

  return (
    <div className="rounded-xl border border-white/10 overflow-hidden my-4 font-mono text-sm shadow-lg shadow-black/40">
      <div className="flex items-center gap-3 px-4 py-2.5 bg-[#0F0F0F] border-b border-white/8">
        <div className="flex gap-1.5 flex-shrink-0">
          <span className="w-3 h-3 rounded-full bg-[#FF5F57]" />
          <span className="w-3 h-3 rounded-full bg-[#FEBC2E]" />
          <span className="w-3 h-3 rounded-full bg-[#28C840]" />
        </div>
        <span className="text-[10px] font-bold text-[#6B7280] tracking-widest uppercase flex-1">Terminal</span>
        <button
          onClick={handleCopy}
          className="flex items-center gap-1.5 px-2 py-1 rounded text-[10px] text-[#6B7280] hover:text-[#00FF88] hover:bg-[#00FF88]/8 transition-all"
        >
          {copied ? <Check size={11} className="text-[#00FF88]" /> : <Copy size={11} />}
          <span>{copied ? "Copied!" : "Copy"}</span>
        </button>
      </div>
      <pre className="bg-[#080808] p-5 overflow-x-auto leading-relaxed">
        <code className="text-white">
          <span className="text-[#00FF88] select-none">$ </span>
          {code}
        </code>
      </pre>
    </div>
  );
}

export function Code({ children }: { children: React.ReactNode }) {
  return (
    <code className="bg-[#1C1C2E] text-[#00FF88] px-1.5 py-0.5 rounded-md text-[0.83em] font-mono border border-[#00FF88]/15">
      {children}
    </code>
  );
}

// ─── 4-Beat section wrappers ─────────────────────────────────────────────────

export function TheIdea({ children }: { children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <div className="rounded-2xl border border-yellow-500/20 bg-gradient-to-br from-yellow-500/5 via-[#0F0F0F] to-[#0F0F0F] overflow-hidden shadow-lg shadow-yellow-500/5">
        <div className="flex items-center gap-3 px-6 py-4 border-b border-yellow-500/15 bg-yellow-500/5">
          <div className="w-9 h-9 rounded-xl bg-yellow-500/15 border border-yellow-500/30 flex items-center justify-center flex-shrink-0 shadow-lg shadow-yellow-500/10">
            <Lightbulb size={16} className="text-yellow-400" />
          </div>
          <div>
            <p className="text-[9px] font-bold text-yellow-500/50 uppercase tracking-[0.15em] mb-0.5">Step 1</p>
            <h2 className="text-base font-black text-white leading-none">The idea</h2>
          </div>
          <div className="ml-auto w-8 h-8 rounded-full bg-yellow-500/8 border border-yellow-500/15 flex items-center justify-center">
            <span className="text-[11px] font-black text-yellow-500/40 font-mono">01</span>
          </div>
        </div>
        <div className="px-6 py-5 text-[#CBD5E1] leading-relaxed space-y-3 text-[0.95rem]">
          {children}
        </div>
      </div>
    </section>
  );
}

export function SeeItRun({ children }: { children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <div className="rounded-2xl border border-[#00FF88]/20 bg-gradient-to-br from-[#00FF88]/5 via-[#0F0F0F] to-[#0F0F0F] overflow-hidden shadow-lg shadow-[#00FF88]/5">
        <div className="flex items-center gap-3 px-6 py-4 border-b border-[#00FF88]/15 bg-[#00FF88]/5">
          <div className="w-9 h-9 rounded-xl bg-[#00FF88]/15 border border-[#00FF88]/30 flex items-center justify-center flex-shrink-0 shadow-lg shadow-[#00FF88]/10">
            <Play size={15} className="text-[#00FF88]" />
          </div>
          <div>
            <p className="text-[9px] font-bold text-[#00FF88]/50 uppercase tracking-[0.15em] mb-0.5">Step 2</p>
            <h2 className="text-base font-black text-white leading-none">See it run</h2>
          </div>
          <div className="ml-auto w-8 h-8 rounded-full bg-[#00FF88]/8 border border-[#00FF88]/15 flex items-center justify-center">
            <span className="text-[11px] font-black text-[#00FF88]/40 font-mono">02</span>
          </div>
        </div>
        <div className="px-6 py-5 text-[#CBD5E1] leading-relaxed space-y-3 text-[0.95rem]">
          {children}
        </div>
      </div>
    </section>
  );
}

export function NowYouTry({ children }: { children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <div className="rounded-2xl border border-blue-500/20 bg-gradient-to-br from-blue-500/5 via-[#0F0F0F] to-[#0F0F0F] overflow-hidden shadow-lg shadow-blue-500/5">
        <div className="flex items-center gap-3 px-6 py-4 border-b border-blue-500/15 bg-blue-500/5">
          <div className="w-9 h-9 rounded-xl bg-blue-500/15 border border-blue-500/30 flex items-center justify-center flex-shrink-0 shadow-lg shadow-blue-500/10">
            <Target size={16} className="text-blue-400" />
          </div>
          <div>
            <p className="text-[9px] font-bold text-blue-500/50 uppercase tracking-[0.15em] mb-0.5">Step 3</p>
            <h2 className="text-base font-black text-white leading-none">Now you try</h2>
          </div>
          <div className="ml-auto w-8 h-8 rounded-full bg-blue-500/8 border border-blue-500/15 flex items-center justify-center">
            <span className="text-[11px] font-black text-blue-500/40 font-mono">03</span>
          </div>
        </div>
        <div className="px-6 py-5 text-[#CBD5E1] leading-relaxed space-y-3 text-[0.95rem]">
          {children}
        </div>
      </div>
    </section>
  );
}

export function WhyATesterCares({ children }: { children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <div className="rounded-2xl border border-purple-500/20 bg-gradient-to-br from-purple-500/5 via-[#0F0F0F] to-[#0F0F0F] overflow-hidden shadow-lg shadow-purple-500/5">
        <div className="flex items-center gap-3 px-6 py-4 border-b border-purple-500/15 bg-purple-500/5">
          <div className="w-9 h-9 rounded-xl bg-purple-500/15 border border-purple-500/30 flex items-center justify-center flex-shrink-0 shadow-lg shadow-purple-500/10">
            <FlaskConical size={16} className="text-purple-400" />
          </div>
          <div>
            <p className="text-[9px] font-bold text-purple-500/50 uppercase tracking-[0.15em] mb-0.5">Step 4</p>
            <h2 className="text-base font-black text-white leading-none">Why a tester cares</h2>
          </div>
          <div className="ml-auto w-8 h-8 rounded-full bg-purple-500/8 border border-purple-500/15 flex items-center justify-center">
            <span className="text-[11px] font-black text-purple-500/40 font-mono">04</span>
          </div>
        </div>
        <div className="px-6 py-5 text-[#CBD5E1] leading-relaxed space-y-3 text-[0.95rem]">
          {children}
        </div>
      </div>
    </section>
  );
}

// ─── Recap ───────────────────────────────────────────────────────────────────

interface RecapProps {
  bullets: string[];
  nextLesson?: { number: string; title: string; slug: string };
}

export function Recap({ bullets, nextLesson }: RecapProps) {
  return (
    <section className="mb-8">
      <div className="rounded-2xl border border-[#00FF88]/25 bg-gradient-to-br from-[#00FF88]/8 via-[#0A0F0A] to-[#0A0F0A] overflow-hidden shadow-xl shadow-[#00FF88]/10">
        <div className="flex items-center gap-3 px-6 py-4 border-b border-[#00FF88]/15">
          <div className="w-9 h-9 rounded-xl bg-[#00FF88]/20 border border-[#00FF88]/35 flex items-center justify-center flex-shrink-0">
            <BookOpen size={16} className="text-[#00FF88]" />
          </div>
          <h2 className="text-base font-black text-white">Recap</h2>
          <div className="ml-auto">
            <span className="text-[10px] px-2 py-0.5 rounded-full bg-[#00FF88]/15 text-[#00FF88] font-bold border border-[#00FF88]/25">
              {bullets.length} key points
            </span>
          </div>
        </div>
        <div className="px-6 py-5">
          <ul className="space-y-3 mb-0">
            {bullets.map((b, i) => (
              <li key={i} className="flex items-start gap-3 text-[#D1D5DB] text-sm leading-relaxed">
                <span className="w-5 h-5 rounded-full bg-[#00FF88]/15 border border-[#00FF88]/25 flex items-center justify-center text-[10px] font-black text-[#00FF88] flex-shrink-0 mt-0.5">
                  {i + 1}
                </span>
                <span>{b}</span>
              </li>
            ))}
          </ul>
          {nextLesson && (
            <div className="mt-5 pt-4 border-t border-[#00FF88]/15">
              <div className="flex items-center justify-between">
                <p className="text-xs text-[#6B7280]">Up next</p>
                <Link
                  href={`/course/playwright/${nextLesson.slug}`}
                  className="flex items-center gap-2 px-4 py-2 rounded-xl bg-[#00FF88] hover:bg-[#00e67a] text-black text-sm font-black transition-all shadow-lg shadow-[#00FF88]/20 hover:shadow-[#00FF88]/40"
                >
                  <Zap size={13} />
                  Lesson {nextLesson.number} — {nextLesson.title}
                </Link>
              </div>
            </div>
          )}
        </div>
      </div>
    </section>
  );
}

// ─── Go deeper (collapsible) ─────────────────────────────────────────────────

export function GoDeeper({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useState(false);
  return (
    <section className="mb-8">
      <button
        onClick={() => setOpen((o) => !o)}
        className={`w-full flex items-center gap-3 px-5 py-4 rounded-2xl border transition-all text-left group ${
          open
            ? "bg-[#0E0E1A] border-indigo-500/30 shadow-lg shadow-indigo-500/10"
            : "bg-[#111] border-white/8 hover:border-indigo-500/25 hover:bg-[#0E0E18]"
        }`}
      >
        <div className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 transition-all ${
          open ? "bg-indigo-500/20 border border-indigo-500/30" : "bg-white/5 border border-white/10 group-hover:border-indigo-500/25"
        }`}>
          {open
            ? <ChevronDown size={14} className="text-indigo-400" />
            : <ChevronRight size={14} className="text-[#6B7280] group-hover:text-indigo-400 transition-colors" />
          }
        </div>
        <div>
          <p className={`text-[9px] font-bold uppercase tracking-[0.15em] mb-0.5 ${open ? "text-indigo-500/60" : "text-[#4B5563] group-hover:text-indigo-500/50"}`}>
            Optional
          </p>
          <p className={`text-sm font-bold transition-colors ${open ? "text-white" : "text-[#6B7280] group-hover:text-[#9CA3AF]"}`}>
            Go deeper
          </p>
        </div>
        <div className="ml-auto">
          <span className={`text-[10px] px-2 py-0.5 rounded-full border font-mono transition-all ${
            open ? "bg-indigo-500/15 border-indigo-500/25 text-indigo-400" : "bg-white/5 border-white/10 text-[#4B5563]"
          }`}>
            {open ? "collapse" : "expand"}
          </span>
        </div>
      </button>
      {open && (
        <div className="mt-3 rounded-2xl border border-indigo-500/20 bg-[#0A0A14] overflow-hidden">
          <div className="p-6 text-[#CBD5E1] text-sm leading-relaxed space-y-3 border-l-4 border-indigo-500/40">
            {children}
          </div>
        </div>
      )}
    </section>
  );
}

// ─── Callout boxes ────────────────────────────────────────────────────────────

type CalloutType = "info" | "warning" | "tip" | "win";

const CALLOUT_CONFIG: Record<CalloutType, { border: string; bg: string; icon: string; label: string; labelColor: string; iconBg: string }> = {
  info:    { border: "border-blue-500/30",     bg: "bg-blue-500/5",      icon: "ℹ️",  label: "Note",    labelColor: "text-blue-400",     iconBg: "bg-blue-500/10" },
  warning: { border: "border-yellow-500/30",   bg: "bg-yellow-500/5",    icon: "⚠️",  label: "Warning", labelColor: "text-yellow-400",   iconBg: "bg-yellow-500/10" },
  tip:     { border: "border-[#00FF88]/30",    bg: "bg-[#00FF88]/5",     icon: "💡",  label: "Tip",     labelColor: "text-[#00FF88]",    iconBg: "bg-[#00FF88]/10" },
  win:     { border: "border-[#00FF88]/40",    bg: "bg-[#00FF88]/8",     icon: "🎉",  label: "Win!",    labelColor: "text-[#00FF88]",    iconBg: "bg-[#00FF88]/15" },
};

export function Callout({ type = "tip", children }: { type?: CalloutType; children: React.ReactNode }) {
  const c = CALLOUT_CONFIG[type];
  return (
    <div className={`rounded-xl border ${c.border} ${c.bg} overflow-hidden my-4`}>
      <div className={`flex items-center gap-2 px-4 py-2 border-b ${c.border} ${c.iconBg}`}>
        <span className="text-sm leading-none">{c.icon}</span>
        <span className={`text-[10px] font-black uppercase tracking-widest ${c.labelColor}`}>{c.label}</span>
      </div>
      <div className="px-4 py-3 text-sm leading-relaxed text-[#CBD5E1]">{children}</div>
    </div>
  );
}

// ─── Screenshot placeholder ───────────────────────────────────────────────────

export function Screenshot({ description }: { description: string }) {
  return (
    <div className="rounded-xl border border-dashed border-white/20 bg-[#111] p-8 my-4 text-center">
      <div className="text-3xl mb-3">📸</div>
      <p className="text-sm text-[#9CA3AF] font-mono">[SCREENSHOT: {description}]</p>
    </div>
  );
}
