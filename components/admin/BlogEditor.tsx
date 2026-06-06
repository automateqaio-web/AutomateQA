"use client";

import { useRef, useState, useCallback, useEffect, useMemo } from "react";
import React from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeRaw from "rehype-raw";
import rehypeHighlight from "rehype-highlight";
import { motion, AnimatePresence } from "framer-motion";
import {
  Bold, Italic, Strikethrough, Code, Link2, Image as ImgIcon,
  List, ListOrdered, Quote, Minus, PlaySquare, Table2, FileCode,
  Columns, Eye, PenLine, Loader2, X, LucideIcon,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import "highlight.js/styles/github-dark.css";

/* ──────────────────────────── helpers ──────────────────────────── */

function ytId(url: string): string | null {
  for (const p of [
    /(?:youtu\.be\/)([^?&\s]+)/,
    /(?:[?&]v=)([^&\s]+)/,
    /(?:embed\/)([^?&\s]+)/,
    /^([a-zA-Z0-9_-]{11})$/,
  ]) {
    const m = url.match(p);
    if (m) return m[1];
  }
  return null;
}

function preprocess(raw: string) {
  return raw.replace(
    /\[!youtube:([^\]]+)\]/g,
    (_, id) =>
      `<div class="yt-wrap"><iframe src="https://www.youtube.com/embed/${id.trim()}" title="YouTube video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`
  );
}

/* ──────────────────────────── markdown renderers ──────────────── */

const mdComponents: Record<string, React.ComponentType<any>> = {
  h1: ({ children }) => (
    <h1 className="text-3xl font-black text-white mt-8 mb-4 pb-3 border-b border-[#2A2A2A] tracking-tight">
      {children}
    </h1>
  ),
  h2: ({ children }) => (
    <h2 className="text-2xl font-bold text-white mt-7 mb-3 flex items-center gap-3">
      <span className="w-1 h-6 bg-[#00FF88] rounded-full flex-shrink-0" />
      {children}
    </h2>
  ),
  h3: ({ children }) => (
    <h3 className="text-xl font-bold text-[#E5E7EB] mt-5 mb-2">{children}</h3>
  ),
  h4: ({ children }) => (
    <h4 className="text-lg font-semibold text-[#D1D5DB] mt-4 mb-2">{children}</h4>
  ),
  p: ({ children }) => <p className="text-[#D1D5DB] leading-7 mb-4">{children}</p>,
  strong: ({ children }) => <strong className="text-white font-bold">{children}</strong>,
  em: ({ children }) => <em className="text-[#E5E7EB]">{children}</em>,
  del: ({ children }) => <del className="text-[#6B7280] line-through">{children}</del>,
  code: ({ inline, className, children }: any) =>
    inline ? (
      <code className="bg-[#1A1A1A] text-[#00FF88] px-1.5 py-0.5 rounded font-mono text-[0.82em] border border-[#2A2A2A]">
        {children}
      </code>
    ) : (
      <code className={className}>{children}</code>
    ),
  pre: ({ children }) => (
    <pre className="bg-[#0D0D0D] border border-[#2A2A2A] rounded-xl p-4 overflow-x-auto mb-4 text-sm leading-relaxed">
      {children}
    </pre>
  ),
  blockquote: ({ children }) => (
    <blockquote className="border-l-4 border-[#00FF88] pl-5 my-5 bg-[#00FF88]/5 py-3 pr-4 rounded-r-xl">
      <div className="text-[#9CA3AF] italic [&>p]:mb-0">{children}</div>
    </blockquote>
  ),
  ul: ({ children }) => <ul className="mb-4 space-y-1.5 pl-1">{children}</ul>,
  ol: ({ children }) => (
    <ol className="mb-4 space-y-1.5 pl-1 list-decimal list-inside">{children}</ol>
  ),
  li: ({ children }) => (
    <li className="text-[#D1D5DB] leading-7 flex gap-2 items-baseline">
      <span className="text-[#00FF88] text-[10px] flex-shrink-0">▸</span>
      <span>{children}</span>
    </li>
  ),
  a: ({ href, children }) => (
    <a href={href} target="_blank" rel="noopener noreferrer"
      className="text-[#00FF88] hover:text-[#00FF88]/80 underline underline-offset-2 decoration-[#00FF88]/40 transition-colors">
      {children}
    </a>
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
      <img src={src} alt={alt} className="w-full rounded-xl border border-[#2A2A2A] object-cover" />
      {alt && <figcaption className="text-center text-xs text-[#6B7280] mt-2 italic">{alt}</figcaption>}
    </figure>
  ),
  table: ({ children }) => (
    <div className="overflow-x-auto mb-4 rounded-xl border border-[#2A2A2A]">
      <table className="w-full border-collapse">{children}</table>
    </div>
  ),
  thead: ({ children }) => <thead className="bg-[#1A1A1A]">{children}</thead>,
  tbody: ({ children }) => <tbody className="divide-y divide-[#2A2A2A]">{children}</tbody>,
  tr: ({ children }) => <tr className="hover:bg-white/[0.02] transition-colors">{children}</tr>,
  th: ({ children }) => <th className="text-left px-4 py-3 text-white font-semibold text-sm">{children}</th>,
  td: ({ children }) => <td className="px-4 py-3 text-[#D1D5DB] text-sm">{children}</td>,
  div: ({ className, children, ...rest }: any) =>
    className === "yt-wrap" ? (
      <div className="my-6 rounded-xl overflow-hidden border border-[#2A2A2A] bg-black relative"
        style={{ paddingTop: "56.25%" }}>
        {children}
      </div>
    ) : (
      <div className={className} {...rest}>{children}</div>
    ),
  iframe: ({ src, title, allow }: any) => (
    <iframe src={src} title={title} allow={allow} allowFullScreen
      className="absolute inset-0 w-full h-full" />
  ),
};

/* ──────────────────────────── toolbar types ────────────────────── */

type TBIcon = { kind: "icon"; Icon: LucideIcon; tip: string; fn: () => void; red?: boolean; spin?: boolean };
type TBLabel = { kind: "label"; label: string; tip: string; fn: () => void };
type TBItem = TBIcon | TBLabel;

function TBBtn({ item }: { item: TBItem }) {
  const base = "flex items-center justify-center min-w-[30px] h-7 px-1.5 rounded-md text-[11px] font-bold transition-all select-none";
  const color = item.kind === "icon" && item.red
    ? "text-red-400 hover:bg-red-500/10 hover:text-red-300"
    : "text-[#5A5A5A] hover:text-[#E5E7EB] hover:bg-white/5";

  return (
    <button type="button" title={item.tip} onClick={item.fn} className={`${base} ${color}`}>
      {item.kind === "icon"
        ? <item.Icon size={14} className={item.spin ? "animate-spin" : ""} />
        : <span className="font-mono tracking-tight">{item.label}</span>
      }
    </button>
  );
}

/* ──────────────────────────── main component ───────────────────── */

interface Props { value: string; onChange: (v: string) => void }
type Mode = "write" | "preview" | "split";

export default function BlogEditor({ value, onChange }: Props) {
  const [mode, setMode] = useState<Mode>("write");
  const [showYT, setShowYT] = useState(false);
  const [ytUrl, setYtUrl] = useState("");
  const [uploading, setUploading] = useState(false);
  const taRef = useRef<HTMLTextAreaElement>(null);
  const imgRef = useRef<HTMLInputElement>(null);
  const mounted = useRef(false);
  const supabase = useMemo(() => createClient(), []);

  useEffect(() => {
    mounted.current = true;
    return () => { mounted.current = false; };
  }, []);

  const insertAt = useCallback((before: string, after = "", placeholder = "") => {
    const ta = taRef.current;
    if (!ta) return;
    const s = ta.selectionStart, e = ta.selectionEnd;
    const sel = value.substring(s, e) || placeholder;
    onChange(value.substring(0, s) + before + sel + after + value.substring(e));
    requestAnimationFrame(() => {
      if (!taRef.current) return;
      taRef.current.focus();
      taRef.current.setSelectionRange(s + before.length, s + before.length + sel.length);
    });
  }, [value, onChange]);

  const insertBlock = useCallback((text: string) => {
    const ta = taRef.current;
    if (!ta) return;
    const pos = ta.selectionStart;
    const pre = value.substring(0, pos);
    const nl = pre.length > 0 && !pre.endsWith("\n") ? "\n" : "";
    onChange(pre + nl + text + "\n" + value.substring(pos));
    requestAnimationFrame(() => { taRef.current?.focus(); });
  }, [value, onChange]);

  const insertYT = useCallback(() => {
    const id = ytId(ytUrl.trim());
    if (!id) return;
    insertBlock(`[!youtube:${id}]`);
    setShowYT(false); setYtUrl("");
  }, [ytUrl, insertBlock]);

  const uploadImg = useCallback(async (file: File) => {
    if (!mounted.current) return;
    setUploading(true);
    try {
      const ext = file.name.split(".").pop();
      const path = `content/${Date.now()}.${ext}`;
      const { error } = await supabase.storage.from("blogs").upload(path, file, { upsert: true });
      if (error) throw error;
      const { data: { publicUrl } } = supabase.storage.from("blogs").getPublicUrl(path);
      const alt = file.name.replace(/\.[^/.]+$/, "").replace(/[-_]/g, " ");
      if (mounted.current) insertAt(`![${alt}](${publicUrl})`);
    } catch (err) {
      console.error("Upload failed:", err);
    } finally {
      if (mounted.current) setUploading(false);
    }
  }, [supabase, insertAt]);

  const groups: TBItem[][] = [
    [
      { kind: "label", label: "H1", tip: "Heading 1",  fn: () => insertBlock("# Heading 1") },
      { kind: "label", label: "H2", tip: "Heading 2",  fn: () => insertBlock("## Heading 2") },
      { kind: "label", label: "H3", tip: "Heading 3",  fn: () => insertBlock("### Heading 3") },
    ],
    [
      { kind: "icon", Icon: Bold,          tip: "Bold (Ctrl+B)",      fn: () => insertAt("**", "**", "bold text") },
      { kind: "icon", Icon: Italic,        tip: "Italic (Ctrl+I)",    fn: () => insertAt("_", "_", "italic text") },
      { kind: "icon", Icon: Strikethrough, tip: "Strikethrough",      fn: () => insertAt("~~", "~~", "text") },
    ],
    [
      { kind: "icon", Icon: Code,     tip: "Inline Code (Ctrl+`)", fn: () => insertAt("`", "`", "code") },
      { kind: "icon", Icon: FileCode, tip: "Code Block",           fn: () => insertBlock("```typescript\n// your code here\n```") },
    ],
    [
      { kind: "icon", Icon: Quote,       tip: "Blockquote",     fn: () => insertAt("> ", "", "quote") },
      { kind: "icon", Icon: List,        tip: "Bullet List",    fn: () => insertBlock("- Item 1\n- Item 2\n- Item 3") },
      { kind: "icon", Icon: ListOrdered, tip: "Ordered List",   fn: () => insertBlock("1. Item 1\n2. Item 2\n3. Item 3") },
      { kind: "icon", Icon: Minus,       tip: "Divider",        fn: () => insertBlock("---") },
    ],
    [
      { kind: "icon", Icon: Link2,                    tip: "Insert Link (Ctrl+K)",  fn: () => insertAt("[", "](https://)", "link text") },
      { kind: "icon", Icon: uploading ? Loader2 : ImgIcon, tip: "Upload Image",   fn: () => imgRef.current?.click(), spin: uploading },
      { kind: "icon", Icon: PlaySquare,                  tip: "Embed YouTube",         fn: () => setShowYT(true), red: true },
      { kind: "icon", Icon: Table2,                   tip: "Insert Table",          fn: () => insertBlock("| Col 1 | Col 2 | Col 3 |\n|-------|-------|-------|\n| A     | B     | C     |") },
    ],
  ];

  const onKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    const ctrl = e.ctrlKey || e.metaKey;
    if (ctrl) {
      if (e.key === "b") { e.preventDefault(); insertAt("**", "**", "bold text"); }
      if (e.key === "i") { e.preventDefault(); insertAt("_", "_", "italic text"); }
      if (e.key === "k") { e.preventDefault(); insertAt("[", "](https://)", "link text"); }
      if (e.key === "`") { e.preventDefault(); insertAt("`", "`", "code"); }
    }
    if (e.key === "Tab") { e.preventDefault(); insertAt("  "); }
  };

  const previewId = ytId(ytUrl.trim());

  return (
    <div className="relative border border-[#2A2A2A] rounded-2xl overflow-hidden bg-[#0B0B0B] flex flex-col">

      {/* Toolbar */}
      <div className="flex items-center gap-0.5 px-3 py-2 border-b border-[#1E1E1E] bg-[#0F0F0F] flex-wrap gap-y-1.5">
        {groups.map((group, gi) => (
          <div key={gi} className="flex items-center gap-0.5">
            {gi > 0 && <div className="w-px h-4 bg-[#2A2A2A] mx-1.5 flex-shrink-0" />}
            {group.map((item, i) => <TBBtn key={i} item={item} />)}
          </div>
        ))}

        {/* Mode switcher */}
        <div className="ml-auto flex items-center gap-0.5 bg-[#1A1A1A] rounded-lg p-0.5 flex-shrink-0">
          {([
            { m: "write"   as Mode, Icon: PenLine, label: "Write"   },
            { m: "preview" as Mode, Icon: Eye,     label: "Preview" },
            { m: "split"   as Mode, Icon: Columns, label: "Split"   },
          ]).map(({ m, Icon, label }) => (
            <button key={m} type="button" onClick={() => setMode(m)}
              className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-md text-[11px] font-semibold transition-all
                ${mode === m ? "bg-[#00FF88] text-black" : "text-[#5A5A5A] hover:text-white"}`}>
              <Icon size={11} />
              <span className="hidden sm:inline">{label}</span>
            </button>
          ))}
        </div>
      </div>

      {/* Editor/Preview area */}
      <div className={`flex flex-1 ${mode === "split" ? "divide-x divide-[#1E1E1E]" : ""}`}>

        {(mode === "write" || mode === "split") && (
          <textarea
            ref={taRef}
            value={value}
            onChange={(e) => onChange(e.target.value)}
            onKeyDown={onKeyDown}
            spellCheck
            placeholder={`# Your Blog Post Title\n\nStart writing...\n\nShortcuts: Ctrl+B Bold · Ctrl+I Italic · Ctrl+K Link · Ctrl+\` Code\nTab = 2 spaces · Use toolbar for headings, lists, images & YouTube embeds`}
            className={`${mode === "split" ? "w-1/2" : "w-full"} p-5 bg-transparent text-[#C9D1D9] text-[13px] leading-7 resize-none focus:outline-none font-mono placeholder-[#252525]`}
            style={{ minHeight: 480 }}
          />
        )}

        {(mode === "preview" || mode === "split") && (
          <div className={`${mode === "split" ? "w-1/2" : "w-full"} p-5 overflow-y-auto`} style={{ minHeight: 480 }}>
            {value.trim() ? (
              <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeRaw, rehypeHighlight]} components={mdComponents}>
                {preprocess(value)}
              </ReactMarkdown>
            ) : (
              <div className="flex flex-col items-center justify-center h-60 text-center">
                <span className="text-5xl mb-3 opacity-30">✍️</span>
                <p className="text-[#3A3A3A] text-sm">Nothing to preview yet</p>
              </div>
            )}
          </div>
        )}
      </div>

      {/* Hidden image input */}
      <input ref={imgRef} type="file" accept="image/*" className="hidden"
        onChange={(e) => { const f = e.target.files?.[0]; if (f) uploadImg(f); e.target.value = ""; }} />

      {/* YouTube modal */}
      <AnimatePresence>
        {showYT && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/75 backdrop-blur-sm flex items-center justify-center z-50 rounded-2xl p-4"
            onClick={(e) => { if (e.target === e.currentTarget) { setShowYT(false); setYtUrl(""); } }}>
            <motion.div
              initial={{ scale: 0.93, opacity: 0, y: 8 }} animate={{ scale: 1, opacity: 1, y: 0 }} exit={{ scale: 0.93, opacity: 0, y: 8 }}
              transition={{ type: "spring", stiffness: 400, damping: 30 }}
              className="bg-[#141414] border border-[#2A2A2A] rounded-2xl p-6 w-full max-w-sm shadow-2xl">

              <div className="flex items-center gap-3 mb-5">
                <div className="w-10 h-10 rounded-xl bg-red-600/10 border border-red-600/20 flex items-center justify-center flex-shrink-0">
                  <PlaySquare size={20} className="text-red-500" />
                </div>
                <div>
                  <h3 className="text-white font-bold">Embed YouTube Video</h3>
                  <p className="text-[#6B7280] text-xs mt-0.5">Paste a URL or video ID</p>
                </div>
                <button type="button" onClick={() => { setShowYT(false); setYtUrl(""); }}
                  className="ml-auto text-[#5A5A5A] hover:text-white transition-colors">
                  <X size={16} />
                </button>
              </div>

              <div className="space-y-3">
                <input autoFocus value={ytUrl} onChange={(e) => setYtUrl(e.target.value)}
                  placeholder="https://youtu.be/dQw4w9WgXcQ"
                  className="w-full px-3 py-2.5 rounded-xl bg-[#0D0D0D] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-red-500/40 placeholder-[#3A3A3A]"
                  onKeyDown={(e) => e.key === "Enter" && insertYT()} />

                {previewId && (
                  <div className="rounded-xl overflow-hidden border border-[#2A2A2A] bg-black relative" style={{ paddingTop: "42%" }}>
                    <iframe src={`https://www.youtube.com/embed/${previewId}`} title="Preview"
                      className="absolute inset-0 w-full h-full" allowFullScreen />
                  </div>
                )}

                <button type="button" onClick={insertYT} disabled={!previewId}
                  className="w-full py-2.5 bg-red-600 hover:bg-red-500 disabled:opacity-40 disabled:cursor-not-allowed text-white text-sm font-semibold rounded-xl transition-colors flex items-center justify-center gap-2">
                  <PlaySquare size={14} /> Insert Video
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
