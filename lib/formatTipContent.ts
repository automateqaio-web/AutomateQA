const CODE_STARTERS = /^(await\s|const\s|let\s|var\s|function\s|async\s|return\s|import\s|export\s|class\s|new\s|if\s*\(|for\s*\(|while\s*\(|switch\s*\(|try\s*\{|throw\s|yield\s)/;
const METHOD_CALLS = /^(page\.|browser\.|context\.|expect\(|test\(|describe\(|it\(|beforeAll|afterAll|beforeEach|afterEach)/;
const COMMENT = /^\/\//;
const BRACE_ONLY = /^[{}]$/;
const ENDS_SEMI = /;(\s*(\/\/.*)?)?$/;

const EMOJI_BULLET = /^[\u{1F300}-\u{1F9FF}\u{2600}-\u{27BF}\u{2700}-\u{27BF}\u{1F000}-\u{1F02F}\u{1F0A0}-\u{1F0FF}\u{1F100}-\u{1F1FF}\u{1F200}-\u{1F2FF}\u{1F004}\u{1F0CF}✅❌⚠️✓✗•→▸►🔴🟢🟡🔵⭐💡📌🚀🎯]/u;

function isCodeLine(raw: string): boolean {
  const t = raw.trim();
  if (!t) return false;
  if (CODE_STARTERS.test(t)) return true;
  if (METHOD_CALLS.test(t)) return true;
  if (COMMENT.test(t)) return true;
  if (BRACE_ONLY.test(t)) return true;
  if (ENDS_SEMI.test(t) && !/^[A-Z][^;]*[a-z]\.\s*$/.test(t) && t.length < 300) return true;
  if (/\s=>\s/.test(t) && t.length < 250) return true;
  return false;
}

function isEmojiListLine(raw: string): boolean {
  const t = raw.trim();
  if (!t) return false;
  // Skip lines that are already proper markdown constructs
  if (/^(-|\*|>|#{1,6}\s|\d+\.)/.test(t)) return false;
  return EMOJI_BULLET.test(t);
}

/**
 * Inserts blank lines between consecutive emoji-bullet lines so markdown
 * renders each on its own line instead of merging them into one paragraph.
 * Code-fence-aware: never modifies content inside ``` blocks.
 * Safe to call on any markdown content.
 */
export function fixEmojiBullets(raw: string): string {
  const lines = raw.split("\n");
  const out: string[] = [];
  let inCode = false;
  let lastWasEmoji = false;

  for (const line of lines) {
    const trimmed = line.trim();

    if (trimmed.startsWith("```")) {
      inCode = !inCode;
      lastWasEmoji = false;
      out.push(line);
      continue;
    }

    if (inCode) {
      out.push(line);
      continue;
    }

    if (!trimmed) {
      lastWasEmoji = false;
      out.push(line);
      continue;
    }

    const isEmoji = isEmojiListLine(trimmed);
    if (isEmoji && lastWasEmoji) out.push("");
    out.push(line);
    lastWasEmoji = isEmoji;
  }

  return out.join("\n");
}

export function formatTipContent(raw: string): string {
  // Always apply emoji-bullet fix first (safe on all content)
  const base = fixEmojiBullets(raw);

  // If content already has code fences, trust the author's formatting
  if (raw.includes("```")) return base;

  // Auto-detect plain-text code lines and wrap them in ``` blocks
  const lines = base.split("\n");
  const out: string[] = [];
  let codeBuf: string[] = [];

  function flushCode() {
    while (codeBuf.length && !codeBuf[codeBuf.length - 1].trim()) codeBuf.pop();
    if (codeBuf.length === 0) return;
    out.push("");
    out.push("```javascript");
    codeBuf.forEach((l) => out.push(l));
    out.push("```");
    out.push("");
    codeBuf = [];
  }

  for (const line of lines) {
    const trimmed = line.trim();

    if (!trimmed) {
      if (codeBuf.length) codeBuf.push("");
      else out.push("");
      continue;
    }

    if (isCodeLine(trimmed)) {
      while (codeBuf.length && !codeBuf[codeBuf.length - 1].trim()) codeBuf.pop();
      codeBuf.push(trimmed);
    } else {
      while (codeBuf.length && !codeBuf[codeBuf.length - 1].trim()) codeBuf.pop();
      flushCode();
      out.push(line);
    }
  }

  while (codeBuf.length && !codeBuf[codeBuf.length - 1].trim()) codeBuf.pop();
  flushCode();

  return out.join("\n");
}
