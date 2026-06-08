"use client";
import { useState, useMemo } from "react";
import { Check, Copy } from "lucide-react";
import hljs from "highlight.js/lib/common";

/* Scoped atom-one-dark-style theme — uses .qcb wrapper to avoid
   conflicting with github-dark used inside markdown prose. */
const THEME = `
  .qcb { position:relative; }
  .qcb code[class*="language-"],
  .qcb .hljs { background: transparent; color: #abb2bf; }
  .qcb .hljs-keyword  { color: #c792ea; font-weight:600; }
  .qcb .hljs-operator { color: #89ddff; }
  .qcb .hljs-string, .qcb .hljs-regexp { color: #c3e88d; }
  .qcb .hljs-number   { color: #f78c6c; }
  .qcb .hljs-comment  { color: #637777; font-style: italic; }
  .qcb .hljs-class .hljs-title,
  .qcb .hljs-title    { color: #ffcb6b; }
  .qcb .hljs-built_in { color: #82aaff; }
  .qcb .hljs-type     { color: #ffcb6b; }
  .qcb .hljs-attr, .qcb .hljs-attribute { color: #f07178; }
  .qcb .hljs-variable,.qcb .hljs-params { color: #f07178; }
  .qcb .hljs-function,.qcb .hljs-title.function_ { color: #82aaff; }
  .qcb .hljs-literal  { color: #ff5370; }
  .qcb .hljs-meta     { color: #f07178; }
  .qcb .hljs-tag      { color: #f07178; }
  .qcb .hljs-name     { color: #ef5350; }
  .qcb .hljs-selector-class,
  .qcb .hljs-selector-id { color: #ffcb6b; }
  .qcb .hljs-symbol   { color: #89ddff; }
  .qcb .hljs-addition { color: #c3e88d; }
  .qcb .hljs-deletion { color: #ff5370; }
  .qcb .hljs-link     { color: #c3e88d; text-decoration:underline; }
  .qcb .hljs-emphasis { font-style:italic; }
  .qcb .hljs-strong   { font-weight:700; }
`;

const LANG_LABEL: Record<string, string> = {
  java: "Java", javascript: "JavaScript", typescript: "TypeScript",
  python: "Python", kotlin: "Kotlin", scala: "Scala",
  groovy: "Groovy", csharp: "C#", cpp: "C++", go: "Go",
  rust: "Rust", bash: "Bash", shell: "Shell", sh: "Shell",
  sql: "SQL", xml: "XML", html: "HTML", css: "CSS",
  json: "JSON", yaml: "YAML", gherkin: "Gherkin",
};

export default function QuestionCodeBlock({ code, language }: { code: string; language: string }) {
  const [copied, setCopied] = useState(false);

  const highlighted = useMemo(() => {
    try {
      const lang = language?.toLowerCase() || "plaintext";
      if (hljs.getLanguage(lang)) {
        return hljs.highlight(code, { language: lang }).value;
      }
      return hljs.highlightAuto(code).value;
    } catch {
      return code.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }
  }, [code, language]);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(code);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {}
  };

  const label = LANG_LABEL[language?.toLowerCase()] || language?.toUpperCase() || "CODE";

  return (
    <div className="rounded-xl overflow-hidden shadow-[0_8px_32px_rgba(0,0,0,0.5)]"
      style={{ border: "1px solid rgba(255,255,255,0.07)" }}>
      <style>{THEME}</style>

      {/* Title bar */}
      <div className="flex items-center justify-between px-4 py-2.5"
        style={{ background: "rgba(0,0,0,0.55)", borderBottom: "1px solid rgba(255,255,255,0.06)" }}>
        <div className="flex items-center gap-2.5">
          <span className="flex gap-1.5">
            {["#FF5F57", "#FFBD2E", "#28CA42"].map(c => (
              <span key={c} className="w-2.5 h-2.5 rounded-full" style={{ background: c }} />
            ))}
          </span>
          <span className="text-[11px] font-semibold ml-1" style={{ color: "#6B7280" }}>{label}</span>
        </div>
        <button
          onClick={handleCopy}
          className="flex items-center gap-1.5 text-xs px-2.5 py-1 rounded-md border transition-all"
          style={copied
            ? { color: "#00FF88", borderColor: "rgba(0,255,136,0.3)", background: "rgba(0,255,136,0.08)" }
            : { color: "#4B5563", borderColor: "rgba(255,255,255,0.08)", background: "transparent" }}>
          {copied ? <Check size={11} /> : <Copy size={11} />}
          {copied ? "Copied!" : "Copy"}
        </button>
      </div>

      {/* Code */}
      <pre className="qcb m-0 overflow-x-auto"
        style={{ background: "#0d1117", padding: "20px 24px" }}>
        <code
          className={`hljs language-${language?.toLowerCase()} text-[0.78rem] leading-[1.8] font-mono`}
          dangerouslySetInnerHTML={{ __html: highlighted }}
        />
      </pre>
    </div>
  );
}
