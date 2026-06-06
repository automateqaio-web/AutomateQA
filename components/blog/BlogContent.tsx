"use client";

import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";

interface BlogContentProps {
  content: string;
}

export default function BlogContent({ content }: BlogContentProps) {
  return (
    <div className="prose-custom max-w-none">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          h1: ({ children }) => <h1 className="text-3xl font-black text-white mt-10 mb-4">{children}</h1>,
          h2: ({ children }) => <h2 className="text-2xl font-black text-white mt-8 mb-3 pb-2 border-b border-white/5">{children}</h2>,
          h3: ({ children }) => <h3 className="text-xl font-bold text-white mt-6 mb-2">{children}</h3>,
          h4: ({ children }) => <h4 className="text-lg font-semibold text-white mt-4 mb-2">{children}</h4>,
          p: ({ children }) => <p className="text-[#D1D5DB] leading-[1.85] mb-5 text-[1.05rem]">{children}</p>,
          ul: ({ children }) => <ul className="text-[#D1D5DB] space-y-1 mb-5 pl-5 list-disc">{children}</ul>,
          ol: ({ children }) => <ol className="text-[#D1D5DB] space-y-1 mb-5 pl-5 list-decimal">{children}</ol>,
          li: ({ children }) => <li className="leading-relaxed">{children}</li>,
          a: ({ href, children }) => (
            <a href={href} target={href?.startsWith("http") ? "_blank" : undefined} rel="noopener noreferrer" className="text-[#00FF88] hover:underline font-medium">
              {children}
            </a>
          ),
          blockquote: ({ children }) => (
            <blockquote className="border-l-4 border-[#00FF88] pl-4 italic text-[#9CA3AF] my-6 bg-[#111] rounded-r-lg py-3 pr-4">
              {children}
            </blockquote>
          ),
          code: ({ className, children, ...props }) => {
            const isBlock = className?.includes("language-");
            if (isBlock) {
              const language = className?.replace("language-", "") || "";
              return (
                <div className="my-6">
                  {language && (
                    <div className="flex items-center justify-between px-4 py-2 bg-[#0D0D0D] border border-[#2A2A2A] rounded-t-xl text-xs text-[#9CA3AF] font-mono">
                      <span>{language}</span>
                      <span className="flex gap-1.5">
                        {["#FF5F57", "#FFBD2E", "#28CA42"].map((c) => (
                          <span key={c} className="w-3 h-3 rounded-full" style={{ background: c }} />
                        ))}
                      </span>
                    </div>
                  )}
                  <pre className={`bg-[#0D0D0D] border border-t-0 border-[#2A2A2A] ${language ? "rounded-b-xl" : "rounded-xl"} p-5 overflow-x-auto`}>
                    <code className="text-[#E2E8F0] font-mono text-sm leading-relaxed">{children}</code>
                  </pre>
                </div>
              );
            }
            return (
              <code className="bg-[#1A1A1A] text-[#00FF88] px-1.5 py-0.5 rounded font-mono text-[0.85em]" {...props}>
                {children}
              </code>
            );
          },
          table: ({ children }) => (
            <div className="overflow-x-auto my-6">
              <table className="w-full border-collapse border border-[#2A2A2A] rounded-xl overflow-hidden">{children}</table>
            </div>
          ),
          th: ({ children }) => <th className="bg-[#1A1A1A] text-white font-semibold p-3 text-left border-b border-[#2A2A2A] text-sm">{children}</th>,
          td: ({ children }) => <td className="text-[#D1D5DB] p-3 border-b border-[#1A1A1A] text-sm">{children}</td>,
          hr: () => <hr className="border-[#2A2A2A] my-8" />,
          img: ({ src, alt }) => (
            <span className="block my-6">
              <img src={src} alt={alt} className="rounded-xl w-full object-cover border border-[#2A2A2A]" loading="lazy" />
              {alt && <span className="block text-center text-xs text-[#9CA3AF] mt-2 italic">{alt}</span>}
            </span>
          ),
          strong: ({ children }) => <strong className="text-white font-bold">{children}</strong>,
          em: ({ children }) => <em className="text-[#9CA3AF] italic">{children}</em>,
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}
