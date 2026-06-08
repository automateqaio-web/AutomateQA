"use client";

import { useState, useRef } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeRaw from "rehype-raw";
import rehypeHighlight from "rehype-highlight";
import "highlight.js/styles/github-dark.css";

const LANG_LABELS: Record<string, string> = {
  typescript: "TypeScript", javascript: "JavaScript", tsx: "TSX", jsx: "JSX",
  python: "Python", bash: "Bash", shell: "Shell", sh: "Shell",
  css: "CSS", html: "HTML", json: "JSON", sql: "SQL", yaml: "YAML",
  java: "Java", go: "Go", rust: "Rust", cpp: "C++", gherkin: "Gherkin",
};

function extractLang(children: React.ReactNode): string {
  const child = Array.isArray(children) ? children[0] : children;
  const cls = (child as any)?.props?.className || "";
  return cls.match(/language-([^\s]+)/)?.[1] || "";
}

function extractText(node: React.ReactNode): string {
  if (typeof node === "string") return node;
  if (Array.isArray(node)) return node.map(extractText).join("");
  if (node && typeof node === "object" && "props" in (node as object))
    return extractText((node as any).props?.children);
  return "";
}

function CodeBlock({ children, accent }: { children: React.ReactNode; accent: string }) {
  const [copied, setCopied] = useState(false);
  const preRef = useRef<HTMLPreElement>(null);
  const lang  = extractLang(children);
  const label = LANG_LABELS[lang] || lang.toUpperCase() || "CODE";

  const handleCopy = async () => {
    const text = preRef.current?.textContent || "";
    try { await navigator.clipboard.writeText(text); setCopied(true); setTimeout(() => setCopied(false), 2000); } catch {}
  };

  return (
    <div className="my-6 rounded-xl overflow-hidden shadow-[0_8px_32px_rgba(0,0,0,0.5)]"
      style={{ border: `1px solid rgba(255,255,255,0.07)` }}>
      <div className="flex items-center justify-between px-4 py-2.5"
        style={{ background: "rgba(0,0,0,0.6)", borderBottom: "1px solid rgba(255,255,255,0.06)" }}>
        <div className="flex items-center gap-2.5">
          <span className="flex gap-1.5">
            {["#FF5F57","#FFBD2E","#28CA42"].map(c => (
              <span key={c} className="w-2.5 h-2.5 rounded-full" style={{ background: c }} />
            ))}
          </span>
          <span className="text-[10px] font-mono tracking-widest ml-1" style={{ color: "#3A3A3A" }}>{label}</span>
        </div>
        <button onClick={handleCopy}
          className="flex items-center gap-1.5 text-xs px-2.5 py-1 rounded-md border transition-all"
          style={copied
            ? { color: accent, borderColor: `${accent}40`, background: `${accent}10` }
            : { color: "#4B5563", borderColor: "rgba(255,255,255,0.08)", background: "transparent" }}>
          {copied ? "✓ Copied" : "Copy"}
        </button>
      </div>
      <pre ref={preRef} className="bg-[#050505] px-5 py-5 overflow-x-auto text-[0.82rem] leading-[1.75] m-0">
        {children}
      </pre>
    </div>
  );
}

function preprocess(raw: string) {
  return raw.replace(
    /\[!youtube:([^\]]+)\]/g,
    (_, id) =>
      `<div class="yt-wrap"><iframe src="https://www.youtube.com/embed/${id.trim()}" title="YouTube" frameborder="0" allowfullscreen></iframe></div>`
  );
}

interface Props { content: string; accent?: string }

export default function InterviewAnswerContent({ content, accent = "#00FF88" }: Props) {
  return (
    <div className="interview-prose">
      <style>{`
        .interview-prose { color: #C9D1D9; }
        .interview-prose .hljs { background: #050505 !important; padding: 0 !important; }
      `}</style>
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeRaw, rehypeHighlight]}
        components={{
          /* Smart paragraph — detects short lines as list items */
          p: ({ children }) => {
            const text = extractText(children as React.ReactNode);
            const trimmed = text.trim();
            const isItem =
              trimmed.length > 0 &&
              trimmed.length < 90 &&
              !trimmed.endsWith(".") &&
              !trimmed.endsWith(":") &&
              !trimmed.endsWith("?") &&
              !trimmed.endsWith("!") &&
              !trimmed.includes("\n");
            if (isItem) {
              return (
                <div className="flex items-start gap-3 py-1.5">
                  <span
                    className="flex-shrink-0 w-5 h-5 rounded-full flex items-center justify-center mt-0.5 text-[9px] font-black"
                    style={{ background: `${accent}18`, color: accent, border: `1px solid ${accent}35` }}
                  >▸</span>
                  <span className="text-[15px] leading-relaxed" style={{ color: "#C9D1D9" }}>{children}</span>
                </div>
              );
            }
            return (
              <p className="leading-[1.9] mb-5 text-[15px]" style={{ color: "#B0B8C4" }}>{children}</p>
            );
          },

          strong: ({ children }) => <strong className="font-bold" style={{ color: "#F3F4F6" }}>{children}</strong>,
          em:     ({ children }) => <em className="italic" style={{ color: "#9CA3AF" }}>{children}</em>,
          del:    ({ children }) => <del className="line-through" style={{ color: "#6B7280" }}>{children}</del>,

          ul: ({ children }) => <ul className="my-4 space-y-2 pl-1">{children}</ul>,
          ol: ({ children }) => <ol className="my-4 space-y-2 pl-1">{children}</ol>,
          li: ({ children, ordered, index }: any) => (
            <li className="flex items-start gap-3 text-[15px] leading-relaxed" style={{ color: "#C9D1D9" }}>
              {ordered ? (
                <span className="flex-shrink-0 w-5 h-5 rounded-full text-[10px] font-black flex items-center justify-center mt-0.5"
                  style={{ background: `${accent}15`, color: accent, border: `1px solid ${accent}30` }}>
                  {(index ?? 0) + 1}
                </span>
              ) : (
                <span className="flex-shrink-0 w-5 h-5 rounded-full text-[9px] font-black flex items-center justify-center mt-0.5"
                  style={{ background: `${accent}18`, color: accent, border: `1px solid ${accent}35` }}>
                  ✓
                </span>
              )}
              <span className="flex-1">{children}</span>
            </li>
          ),

          h2: ({ children }) => (
            <div className="flex items-center gap-3 mt-8 mb-4 pb-2"
              style={{ borderBottom: `1px solid ${accent}20` }}>
              <span className="w-1 h-6 rounded-full flex-shrink-0" style={{ background: accent }} />
              <h2 className="text-[1.2rem] font-black" style={{ color: "#F3F4F6" }}>{children}</h2>
            </div>
          ),
          h3: ({ children }) => (
            <h3 className="text-[1.05rem] font-bold mt-6 mb-3 flex items-center gap-2" style={{ color: "#E5E7EB" }}>
              <span className="w-2 h-2 rounded-full" style={{ background: accent }} />
              {children}
            </h3>
          ),
          h4: ({ children }) => (
            <h4 className="text-sm font-semibold mt-4 mb-2 uppercase tracking-wider" style={{ color: "#9CA3AF" }}>
              {children}
            </h4>
          ),

          a: ({ href, children }) => (
            <a href={href} target={href?.startsWith("http") ? "_blank" : undefined} rel="noopener noreferrer"
              className="underline underline-offset-2 font-medium transition-colors"
              style={{ color: accent, textDecorationColor: `${accent}50` }}>
              {children}
            </a>
          ),

          blockquote: ({ children }) => (
            <blockquote className="relative my-6 pl-5 py-3 rounded-r-xl italic text-[15px]"
              style={{ borderLeft: `3px solid ${accent}60`, background: `${accent}07`, color: "#9CA3AF" }}>
              {children}
            </blockquote>
          ),

          pre: ({ children }: any) => <CodeBlock accent={accent}>{children}</CodeBlock>,
          code: ({ className, children }: any) => {
            const isBlock = !!className?.includes("language-");
            if (!isBlock) {
              return (
                <code className="px-1.5 py-0.5 rounded text-[0.85em] font-mono align-baseline"
                  style={{ background: `${accent}14`, color: accent, border: `1px solid ${accent}25` }}>
                  {children}
                </code>
              );
            }
            return <code className={className}>{children}</code>;
          },

          table: ({ children }) => (
            <div className="overflow-x-auto my-6 rounded-xl" style={{ border: "1px solid rgba(255,255,255,0.07)" }}>
              <table className="w-full border-collapse">{children}</table>
            </div>
          ),
          thead: ({ children }) => (
            <thead style={{ background: `${accent}10`, borderBottom: `1px solid ${accent}25` }}>{children}</thead>
          ),
          tbody: ({ children }) => <tbody className="divide-y" style={{ borderColor: "rgba(255,255,255,0.05)" }}>{children}</tbody>,
          tr:    ({ children }) => <tr className="transition-colors hover:bg-white/[0.02]">{children}</tr>,
          th:    ({ children }) => (
            <th className="text-left px-4 py-3 text-xs font-bold uppercase tracking-widest" style={{ color: accent }}>{children}</th>
          ),
          td: ({ children }) => (
            <td className="px-4 py-3 text-[14px]" style={{ color: "#9CA3AF" }}>{children}</td>
          ),

          hr: () => (
            <div className="flex items-center gap-4 my-8">
              <div className="flex-1 h-px" style={{ background: `linear-gradient(90deg, transparent, ${accent}30, transparent)` }} />
              <span className="text-sm" style={{ color: `${accent}50` }}>✦</span>
              <div className="flex-1 h-px" style={{ background: `linear-gradient(90deg, transparent, ${accent}30, transparent)` }} />
            </div>
          ),

          img: ({ src, alt }) => (
            <figure className="my-8">
              <img src={src} alt={alt} className="rounded-xl w-full object-cover" loading="lazy"
                style={{ border: "1px solid rgba(255,255,255,0.07)", boxShadow: "0 8px 32px rgba(0,0,0,0.4)" }} />
              {alt && <figcaption className="text-center text-xs mt-3 italic" style={{ color: "#4B5563" }}>{alt}</figcaption>}
            </figure>
          ),

          div: ({ className, children }: any) =>
            className === "yt-wrap" ? (
              <div className="my-8 rounded-xl overflow-hidden relative"
                style={{ paddingTop: "56.25%", border: "1px solid rgba(255,255,255,0.07)", background: "#000" }}>
                {children}
              </div>
            ) : (
              <div className={className}>{children}</div>
            ),
          iframe: ({ src, title, allow }: any) => {
            const isYT = typeof src === "string" && /youtube\.com\/embed\//.test(src);
            if (!isYT) return null;
            return <iframe src={src} title={title} allow={allow} allowFullScreen className="absolute inset-0 w-full h-full" />;
          },
        }}
      >
        {preprocess(content)}
      </ReactMarkdown>
    </div>
  );
}
