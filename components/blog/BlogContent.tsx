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
  java: "Java", go: "Go", rust: "Rust", cpp: "C++", c: "C",
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

function headingId(children: React.ReactNode) {
  return (
    "h-" +
    extractText(children)
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "")
  );
}

function CodeBlock({ children }: { children: React.ReactNode }) {
  const [copied, setCopied] = useState(false);
  const preRef = useRef<HTMLPreElement>(null);
  const lang = extractLang(children);
  const label = LANG_LABELS[lang] || lang.toUpperCase() || "";

  const handleCopy = async () => {
    const text = preRef.current?.textContent || "";
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  };

  return (
    <div className="code-block my-7 rounded-xl overflow-hidden border border-[#2A2A2A] shadow-[0_4px_24px_rgba(0,0,0,0.4)]">
      <div className="flex items-center justify-between px-4 py-2.5 bg-[#161616] border-b border-[#2A2A2A]">
        <div className="flex items-center gap-2.5">
          <span className="flex gap-1.5">
            {["#FF5F57", "#FFBD2E", "#28CA42"].map((c) => (
              <span key={c} className="w-3 h-3 rounded-full" style={{ background: c }} />
            ))}
          </span>
          {label && (
            <span className="text-xs text-[#6B7280] font-mono tracking-widest ml-2">
              {label}
            </span>
          )}
        </div>
        <button
          onClick={handleCopy}
          className="flex items-center gap-1.5 text-xs px-2.5 py-1 rounded-md border transition-all duration-200 select-none"
          style={copied
            ? { color: "#00FF88", borderColor: "rgba(0,255,136,0.3)", background: "rgba(0,255,136,0.08)" }
            : { color: "#6B7280", borderColor: "rgba(255,255,255,0.08)", background: "transparent" }
          }
        >
          {copied ? (
            <>
              <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              Copied!
            </>
          ) : (
            <>
              <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
              Copy
            </>
          )}
        </button>
      </div>
      <pre ref={preRef} className="bg-[#0D0D0D] px-5 py-5 overflow-x-auto text-[0.85rem] leading-[1.7] m-0">
        {children}
      </pre>
    </div>
  );
}

function preprocess(raw: string) {
  return raw.replace(
    /\[!youtube:([^\]]+)\]/g,
    (_, id) =>
      `<div class="yt-wrap"><iframe src="https://www.youtube.com/embed/${id.trim()}" title="YouTube video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`
  );
}

export default function BlogContent({ content }: { content: string }) {
  return (
    <div className="blog-prose">
      <style>{`
        .blog-prose { font-size: 1.08rem; color: #D1D5DB; }
        .blog-prose .hljs { background: #0D0D0D !important; padding: 0 !important; }
        .blog-prose .code-block pre { margin: 0; }
      `}</style>
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeRaw, rehypeHighlight]}
        components={{
          h1: ({ children }) => (
            <h1 className="text-[2rem] font-black text-white mt-12 mb-5 pb-3 border-b border-white/10 tracking-tight leading-tight">
              {children}
            </h1>
          ),
          h2: ({ children }) => (
            <h2 id={headingId(children)} className="text-[1.55rem] font-bold text-white mt-10 mb-4 flex items-center gap-3 leading-snug scroll-mt-24">
              <span className="w-1 h-7 bg-[#00FF88] rounded-full flex-shrink-0 shadow-[0_0_8px_#00FF88]" />
              {children}
            </h2>
          ),
          h3: ({ children }) => (
            <h3 id={headingId(children)} className="text-[1.25rem] font-bold text-[#E5E7EB] mt-8 mb-3 leading-snug scroll-mt-24 pl-3 border-l-2 border-[#00FF88]/35">
              {children}
            </h3>
          ),
          h4: ({ children }) => (
            <h4 className="text-[1.05rem] font-semibold text-[#D1D5DB] mt-6 mb-2 uppercase tracking-widest text-xs">{children}</h4>
          ),
          p: ({ children }) => (
            <p className="text-[#C9D1D9] leading-[1.9] mb-6 text-justify hyphens-auto text-[1.05rem]">
              {children}
            </p>
          ),
          strong: ({ children }) => (
            <strong className="text-white font-bold">{children}</strong>
          ),
          em: ({ children }) => (
            <em className="text-[#9CA3AF] italic">{children}</em>
          ),
          del: ({ children }) => (
            <del className="text-[#6B7280] line-through">{children}</del>
          ),
          ul: ({ children }) => (
            <ul className="mb-6 space-y-2 pl-2">{children}</ul>
          ),
          ol: ({ children }) => (
            <ol className="mb-6 space-y-2 pl-2 list-none counter-reset-[item]">{children}</ol>
          ),
          li: ({ children, ordered, index }: any) => (
            <li className="text-[#C9D1D9] leading-7 flex gap-3 items-start">
              {ordered ? (
                <span className="flex-shrink-0 mt-[3px] w-5 h-5 rounded-full bg-[#1E1E1E] text-[#9CA3AF] text-[10px] font-semibold flex items-center justify-center border border-white/10">
                  {(index ?? 0) + 1}
                </span>
              ) : (
                <span className="flex-shrink-0 w-[5px] h-[5px] rounded-full bg-[#4B5563] mt-[11px]" />
              )}
              <span className="flex-1">{children}</span>
            </li>
          ),
          a: ({ href, children }) => (
            <a
              href={href}
              target={href?.startsWith("http") ? "_blank" : undefined}
              rel="noopener noreferrer"
              className="text-[#00FF88] hover:text-white underline underline-offset-[3px] decoration-[#00FF88]/40 hover:decoration-white/40 font-medium transition-colors"
            >
              {children}
            </a>
          ),
          blockquote: ({ children }) => (
            <blockquote className="relative border-l-[3px] border-[#00FF88] pl-6 my-8 py-1">
              <div className="absolute left-4 top-0 text-[3rem] leading-none text-[#00FF88]/20 font-serif select-none">&ldquo;</div>
              <div className="text-[1.05rem] italic text-[#9CA3AF] leading-[1.9] [&>p]:mb-0 [&>p]:text-justify">
                {children}
              </div>
            </blockquote>
          ),
          pre: ({ children }: any) => <CodeBlock>{children}</CodeBlock>,
          code: ({ inline, className, children }: any) => {
            if (inline) {
              return (
                <code className="bg-[#1A1A1A] text-[#00FF88] px-1.5 py-[2px] rounded-md font-mono text-[0.82em] border border-[#2A2A2A] align-baseline">
                  {children}
                </code>
              );
            }
            return <code className={className}>{children}</code>;
          },
          table: ({ children }) => (
            <div className="overflow-x-auto my-8 rounded-xl border border-[#2A2A2A] shadow-[0_2px_12px_rgba(0,0,0,0.3)]">
              <table className="w-full border-collapse">{children}</table>
            </div>
          ),
          thead: ({ children }) => (
            <thead className="bg-[#161616] border-b border-[#2A2A2A]">{children}</thead>
          ),
          tbody: ({ children }) => (
            <tbody className="divide-y divide-[#1F1F1F]">{children}</tbody>
          ),
          tr: ({ children }) => (
            <tr className="hover:bg-white/[0.02] transition-colors">{children}</tr>
          ),
          th: ({ children }) => (
            <th className="text-left px-5 py-3 text-white font-semibold text-sm tracking-wide">
              {children}
            </th>
          ),
          td: ({ children }) => (
            <td className="px-5 py-3 text-[#C9D1D9] text-sm">{children}</td>
          ),
          hr: () => (
            <div className="flex items-center gap-4 my-10">
              <div className="flex-1 h-px bg-gradient-to-r from-transparent via-[#2A2A2A] to-transparent" />
              <span className="text-[#374151] text-sm">✦</span>
              <div className="flex-1 h-px bg-gradient-to-r from-transparent via-[#2A2A2A] to-transparent" />
            </div>
          ),
          img: ({ src, alt }) => (
            <figure className="my-8">
              <img
                src={src}
                alt={alt}
                className="rounded-xl w-full object-cover border border-[#2A2A2A] shadow-[0_4px_24px_rgba(0,0,0,0.4)]"
                loading="lazy"
              />
              {alt && (
                <figcaption className="text-center text-xs text-[#6B7280] mt-3 italic">
                  {alt}
                </figcaption>
              )}
            </figure>
          ),
          div: ({ className, children, ...rest }: any) =>
            className === "yt-wrap" ? (
              <div
                className="my-8 rounded-xl overflow-hidden border border-[#2A2A2A] bg-black relative shadow-[0_4px_24px_rgba(0,0,0,0.5)]"
                style={{ paddingTop: "56.25%" }}
              >
                {children}
              </div>
            ) : (
              <div className={className} {...rest}>{children}</div>
            ),
          iframe: ({ src, title, allow }: any) => {
            const isYouTube =
              typeof src === "string" &&
              /^https:\/\/(www\.)?youtube\.com\/embed\//.test(src);
            if (!isYouTube) return null;
            return (
              <iframe
                src={src}
                title={title}
                allow={allow}
                allowFullScreen
                className="absolute inset-0 w-full h-full"
              />
            );
          },
        }}
      >
        {preprocess(content)}
      </ReactMarkdown>
    </div>
  );
}
