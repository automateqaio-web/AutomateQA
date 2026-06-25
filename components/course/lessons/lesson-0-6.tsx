import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, Callout, CodeBlock } from "@/components/course/LessonSections";
import Link from "next/link";

export default function Lesson06() {
  const roadmap = [
    { part: "Part 0", done: true, title: "The On-Ramp", desc: "What testing is, how the web works, tools installed. You're here — nearly done.", lessons: "0.1–0.6" },
    { part: "Part 1", done: false, title: "JavaScript for Playwright", desc: "Just enough JS to write real tests: variables, functions, async/await, destructuring.", lessons: "1.1–1.17" },
    { part: "1.18 ★", done: false, title: "Mini Playwright Win", desc: "Your first real automation. Google search in 10 lines. The moment everything clicks.", lessons: "1.18" },
  ];

  return (
    <>
      <TheIdea>
        <p>Every long journey feels less scary when you can see the whole map before you start.</p>
        <p>You're at the end of Part 0. You know what testing is, why automation matters, how websites work, and your tools are installed. That's the foundation.</p>
        <p>Now here's exactly where we're going — and how far it actually is.</p>
      </TheIdea>

      <SeeItRun>
        <p>Here is the complete roadmap for Phase 1 of this course:</p>
        <div className="space-y-3 my-4">
          {roadmap.map(({ part, done, title, desc, lessons }) => (
            <div key={part} className={`rounded-xl border p-5 ${done ? "border-[#00FF88]/30 bg-[#00FF88]/5" : "border-white/8 bg-[#0F0F0F]"}`}>
              <div className="flex items-start gap-3">
                <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-xs font-black flex-shrink-0 mt-0.5 ${done ? "bg-[#00FF88]/20 text-[#00FF88]" : "bg-[#1A1A1A] text-[#9CA3AF]"}`}>
                  {done ? "✓" : "→"}
                </div>
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-xs font-bold text-[#9CA3AF] uppercase tracking-wider">{part}</span>
                    <span className="text-xs text-[#4B5563]">({lessons})</span>
                  </div>
                  <p className="text-base font-black text-white mb-1">{title}</p>
                  <p className="text-sm text-[#9CA3AF] leading-relaxed">{desc}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
        <p>Part 1 has 17 lessons. Most take 5–7 minutes to read. The whole thing can be done in a weekend — or one lesson a day for three weeks.</p>
      </SeeItRun>

      <NowYouTry>
        <p>No code yet. Do one thing right now:</p>
        <div className="rounded-xl border border-blue-500/20 bg-blue-500/5 p-5 my-4">
          <p className="text-sm font-semibold text-white mb-3">Make a commitment</p>
          <p className="text-sm text-[#D1D5DB] mb-4">Decide on your learning pace. Pick one:</p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            {[
              ["🐢 1 lesson/day", "Done in ~3 weeks"],
              ["🚶 3 lessons/day", "Done in ~1 week"],
              ["🏃 All at once", "Weekend warrior"],
            ].map(([pace, outcome]) => (
              <div key={pace} className="glass-card p-3 text-center">
                <p className="text-sm font-bold text-white">{pace}</p>
                <p className="text-xs text-[#9CA3AF] mt-0.5">{outcome}</p>
              </div>
            ))}
          </div>
        </div>
        <Callout type="tip">Consistency beats speed. One lesson a day is better than five lessons then a two-week gap. The terminal and the code only become familiar through repetition.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Here's exactly what you'll be able to write by Lesson 1.18. Save this. Come back and look at it after you've finished.</p>
        <CodeBlock filename="tests/google-search.spec.ts — your Lesson 1.18 goal" language="ts" code={`import { test, expect } from '@playwright/test';

test('Google search works', async ({ page }) => {
  await page.goto('https://www.google.com');
  await page.getByRole('combobox').fill('Playwright');
  await page.keyboard.press('Enter');
  await expect(page.locator('h3').first()).toBeVisible();
});`} />
        <p>Every word in that file will make sense by the time you get there. Every keyword, every symbol, every line — covered in Part 1.</p>
        <div className="mt-4">
          <Link href="/course/playwright/what-is-javascript" className="btn-primary inline-flex text-sm">
            Start Part 1 — Lesson 1.1 →
          </Link>
        </div>
      </WhyATesterCares>

      <Recap
        bullets={[
          "Part 0 is done. You understand what testing is and your tools are ready.",
          "Part 1 covers exactly the JavaScript you need — nothing more, nothing less.",
          "Lesson 1.18 is the finish line: a real automation script running in a real browser.",
        ]}
        nextLesson={{ number: "1.1", title: "What is JavaScript?", slug: "what-is-javascript" }}
      />
    </>
  );
}
