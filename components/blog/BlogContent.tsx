"use client";

import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeRaw from "rehype-raw";
import rehypeHighlight from "rehype-highlight";
import "highlight.js/styles/github-dark.css";

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
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeRaw, rehypeHighlight]}
        components={{
          h1: ({ children }) => (
            <h1 className="text-3xl font-black text-white mt-10 mb-4 pb-3 border-b border-white/5 tracking-tight">
              {children}
            </h1>
          ),
          h2: ({ children }) => (
            <h2 className="text-2xl font-bold text-white mt-8 mb-3 flex items-center gap-3">
              <span className="w-1 h-6 bg-[#00FF88] rounded-full flex-shrink-0" />
              {children}
            </h2>
          ),
          h3: ({ children }) => (
            <h3 className="text-xl font-bold text-[#E5E7EB] mt-6 mb-2">{children}</h3>
          ),
          h4: ({ children }) => (
            <h4 className="text-lg font-semibold text-[#D1D5DB] mt-4 mb-2">{children}</h4>
          ),
          p: ({ children }) => (
            <p className="text-[#D1D5DB] leading-[1.85] mb-5 text-[1.05rem]">{children}</p>
          ),
          strong: ({ children }) => <strong className="text-white font-bold">{children}</strong>,
          em: ({ children }) => <em className="text-[#9CA3AF] italic">{children}</em>,
          del: ({ children }) => <del className="text-[#6B7280] line-through">{children}</del>,
          ul: ({ children }) => <ul className="mb-5 space-y-1.5 pl-1">{children}</ul>,
          ol: ({ children }) => <ol className="mb-5 space-y-1.5 pl-5 list-decimal">{children}</ol>,
          li: ({ children }) => (
            <li className="text-[#D1D5DB] leading-7 flex gap-2 items-baseline">
              <span className="text-[#00FF88] text-[10px] flex-shrink-0">▸</span>
              <span>{children}</span>
            </li>
          ),
          a: ({ href, children }) => (
            <a
              href={href}
              target={href?.startsWith("http") ? "_blank" : undefined}
              rel="noopener noreferrer"
              className="text-[#00FF88] hover:text-[#00FF88]/80 underline underline-offset-2 decoration-[#00FF88]/40 font-medium transition-colors"
            >
              {children}
            </a>
          ),
          blockquote: ({ children }) => (
            <blockquote className="border-l-4 border-[#00FF88] pl-5 my-6 bg-[#00FF88]/5 py-3 pr-4 rounded-r-xl">
              <div className="italic text-[#9CA3AF] [&>p]:mb-0">{children}</div>
            </blockquote>
          ),
          code: ({ inline, className, children }: any) => {
            if (inline) {
              return (
                <code className="bg-[#1A1A1A] text-[#00FF88] px-1.5 py-0.5 rounded font-mono text-[0.83em] border border-[#2A2A2A]">
                  {children}
                </code>
              );
            }
            const lang = className?.replace("language-", "") || "";
            return (
              <div className="my-6 rounded-xl overflow-hidden border border-[#2A2A2A]">
                {lang && (
                  <div className="flex items-center justify-between px-4 py-2 bg-[#0D0D0D] border-b border-[#2A2A2A]">
                    <span className="text-xs text-[#9CA3AF] font-mono">{lang}</span>
                    <span className="flex gap-1.5">
                      {["#FF5F57", "#FFBD2E", "#28CA42"].map((c) => (
                        <span key={c} className="w-3 h-3 rounded-full" style={{ background: c }} />
                      ))}
                    </span>
                  </div>
                )}
                <code className={className}>{children}</code>
              </div>
            );
          },
          pre: ({ children }) => (
            <pre className="bg-[#0D0D0D] p-5 overflow-x-auto text-sm leading-relaxed">
              {children}
            </pre>
          ),
          table: ({ children }) => (
            <div className="overflow-x-auto my-6 rounded-xl border border-[#2A2A2A]">
              <table className="w-full border-collapse">{children}</table>
            </div>
          ),
          thead: ({ children }) => <thead className="bg-[#1A1A1A]">{children}</thead>,
          tbody: ({ children }) => <tbody className="divide-y divide-[#2A2A2A]">{children}</tbody>,
          tr: ({ children }) => <tr className="hover:bg-white/[0.02] transition-colors">{children}</tr>,
          th: ({ children }) => (
            <th className="text-left px-4 py-3 text-white font-semibold text-sm">{children}</th>
          ),
          td: ({ children }) => (
            <td className="px-4 py-3 text-[#D1D5DB] text-sm">{children}</td>
          ),
          hr: () => (
            <div className="flex items-center gap-4 my-8">
              <div className="flex-1 h-px bg-[#2A2A2A]" />
              <span className="text-[#374151] text-xs">✦</span>
              <div className="flex-1 h-px bg-[#2A2A2A]" />
            </div>
          ),
          img: ({ src, alt }) => (
            <figure className="my-6">
              <img src={src} alt={alt} className="rounded-xl w-full object-cover border border-[#2A2A2A]" loading="lazy" />
              {alt && <figcaption className="text-center text-xs text-[#6B7280] mt-2 italic">{alt}</figcaption>}
            </figure>
          ),
          div: ({ className, children, ...rest }: any) =>
            className === "yt-wrap" ? (
              <div className="my-6 rounded-xl overflow-hidden border border-[#2A2A2A] bg-black relative"
                style={{ paddingTop: "56.25%" }}>
                {children}
              </div>
            ) : (
              <div className={className} {...rest}>{children}</div>
            ),
          iframe: ({ src, title, allow }: any) => {
            const isYouTube = typeof src === "string" && /^https:\/\/(www\.)?youtube\.com\/embed\//.test(src);
            if (!isYouTube) return null;
            return (
              <iframe src={src} title={title} allow={allow} allowFullScreen
                className="absolute inset-0 w-full h-full" />
            );
          },
        }}
      >
        {preprocess(content)}
      </ReactMarkdown>
    </div>
  );
}
