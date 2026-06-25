import type { Metadata } from "next";
import Link from "next/link";
import { ArrowRight, BookOpen, Clock, Star, Zap, CheckCircle } from "lucide-react";

import { PLAYWRIGHT_LESSONS, COURSE_PARTS } from "@/lib/course/playwright";

export const metadata: Metadata = {
  title: "Zero to Automation Hero — Free Playwright Course",
  description:
    "Learn Playwright from scratch. No coding background needed. Free course for freshers, career switchers, and manual testers who want to break into automation.",
  keywords: [
    "Playwright course free",
    "learn Playwright from scratch",
    "automation testing for beginners",
    "QA automation course",
    "Playwright tutorial",
    "zero to automation",
  ],
  alternates: { canonical: "https://automateqa.online/course/playwright" },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/course/playwright",
    title: "Zero to Automation Hero — Free Playwright Course",
    description:
      "Learn Playwright from scratch. No coding background needed. Free for everyone.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "Zero to Automation Hero" }],
  },
};

export default function PlaywrightCoursePage() {
  const totalLessons = PLAYWRIGHT_LESSONS.length;
  const totalMinutes = PLAYWRIGHT_LESSONS.reduce((acc, l) => acc + l.readTime, 0);
  const firstLesson = PLAYWRIGHT_LESSONS[0];

  return (
    <div className="min-h-screen pt-20">
      {/* Hero */}
      <div className="relative overflow-hidden border-b border-white/5">
        <div className="absolute inset-0 bg-gradient-to-br from-[#00FF88]/5 via-transparent to-purple-500/5" />
        <div className="absolute inset-0 bg-[image:var(--bg-grid-pattern)] opacity-30" />
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-16 sm:py-20 relative">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-bold mb-5 uppercase tracking-wide">
            <Zap size={10} />
            Free Course · Phase 1
          </div>

          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-white mb-4 leading-[1.1]">
            Zero to{" "}
            <span className="text-gradient">Automation Hero</span>
          </h1>

          <p className="text-[#9CA3AF] text-lg sm:text-xl max-w-2xl mb-8 leading-relaxed">
            No coding background needed. We start from what software testing even
            is, teach you just enough JavaScript, then write real Playwright
            automation together — step by step.
          </p>

          {/* Stats */}
          <div className="flex flex-wrap gap-5 mb-10 text-sm">
            <span className="flex items-center gap-2 text-[#D1D5DB]">
              <BookOpen size={15} className="text-[#00FF88]" />
              {totalLessons} lessons
            </span>
            <span className="flex items-center gap-2 text-[#D1D5DB]">
              <Clock size={15} className="text-[#00FF88]" />
              ~{Math.round(totalMinutes / 60)}h of content
            </span>
            <span className="flex items-center gap-2 text-[#D1D5DB]">
              <CheckCircle size={15} className="text-[#00FF88]" />
              100% free · Phase 1
            </span>
            <span className="flex items-center gap-2 text-[#D1D5DB]">
              <Star size={15} className="text-yellow-400" />
              Beginner friendly
            </span>
          </div>

          <Link
            href={`/course/playwright/${firstLesson.slug}`}
            className="btn-primary inline-flex"
          >
            Start Lesson 0.1 — It&apos;s free
            <ArrowRight size={16} />
          </Link>
        </div>
      </div>

      {/* Lesson list by part */}
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {COURSE_PARTS.map((part) => {
          const partLessons = PLAYWRIGHT_LESSONS.filter(
            (l) => l.partId === part.id
          );
          const partMinutes = partLessons.reduce((a, l) => a + l.readTime, 0);

          return (
            <div key={part.id} className="mb-14">
              <div className="flex items-end justify-between mb-1">
                <h2 className="text-2xl font-black text-white">{part.label}</h2>
              </div>
              <p className="text-xs text-[#6B7280] mb-6 uppercase tracking-wider">
                {partLessons.length} lessons · {partMinutes} min
              </p>

              <div className="space-y-2">
                {partLessons.map((lesson) => (
                  <Link
                    key={lesson.slug}
                    href={`/course/playwright/${lesson.slug}`}
                    className="group flex items-center gap-4 p-4 rounded-xl bg-[#0F0F0F] border border-white/5 hover:border-[#00FF88]/20 hover:bg-[#00FF88]/4 transition-all"
                  >
                    {/* Lesson number bubble */}
                    <div className="w-9 h-9 rounded-lg bg-[#1A1A1A] border border-white/8 flex items-center justify-center flex-shrink-0 text-[11px] font-black text-[#6B7280] group-hover:border-[#00FF88]/30 group-hover:text-[#00FF88] transition-all">
                      {lesson.lessonNumber}
                    </div>

                    {/* Title + summary */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap mb-0.5">
                        <span className="text-sm font-semibold text-white group-hover:text-[#00FF88] transition-colors">
                          {lesson.title}
                        </span>
                        {lesson.lessonNumber === "1.18" && (
                          <span className="text-[10px] text-yellow-400 font-bold">★ MINI WIN</span>
                        )}
                        <span className="text-[10px] text-[#00FF88] border border-[#00FF88]/30 rounded px-1.5 py-0.5 font-semibold">
                          FREE
                        </span>
                      </div>
                      <p className="text-xs text-[#6B7280] line-clamp-1">
                        {lesson.summary}
                      </p>
                    </div>

                    {/* Read time + arrow */}
                    <div className="flex items-center gap-3 flex-shrink-0">
                      <span className="text-xs text-[#4B5563] hidden sm:block">
                        {lesson.readTime} min
                      </span>
                      <ArrowRight
                        size={14}
                        className="text-[#2A2A2A] group-hover:text-[#00FF88] transition-colors"
                      />
                    </div>
                  </Link>
                ))}
              </div>
            </div>
          );
        })}

        {/* CTA at bottom */}
        <div className="glass-card p-8 text-center mt-8">
          <div className="text-3xl mb-3">🚀</div>
          <h3 className="text-xl font-black text-white mb-2">
            Ready to start?
          </h3>
          <p className="text-[#9CA3AF] text-sm mb-6 max-w-md mx-auto">
            Lesson 0.1 takes 6 minutes. By Lesson 1.18 you&apos;ll have written
            real automation code.
          </p>
          <Link
            href={`/course/playwright/${firstLesson.slug}`}
            className="btn-primary inline-flex"
          >
            Start for free
            <ArrowRight size={16} />
          </Link>
        </div>
      </div>
    </div>
  );
}
