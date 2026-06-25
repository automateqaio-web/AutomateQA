"use client";

import { useState } from "react";
import Link from "next/link";
import { ArrowLeft, ArrowRight, Menu, X, ChevronRight } from "lucide-react";
import { LessonMeta, PLAYWRIGHT_LESSONS, COURSE_PARTS } from "@/lib/course/playwright";

interface LessonLayoutProps {
  meta: LessonMeta;
  children: React.ReactNode;
}

function SidebarContent({
  currentSlug,
  onClose,
}: {
  currentSlug: string;
  onClose?: () => void;
}) {
  return (
    <nav className="py-4">
      {/* Course title */}
      <div className="px-4 pb-4 border-b border-white/8">
        <Link
          href="/course/playwright"
          onClick={onClose}
          className="text-xs font-black text-[#00FF88] uppercase tracking-widest hover:underline"
        >
          Zero to Automation Hero
        </Link>
        <p className="text-[10px] text-[#4B5563] mt-0.5">Playwright Course</p>
      </div>

      {/* Lessons grouped by part */}
      {COURSE_PARTS.map((part) => {
        const partLessons = PLAYWRIGHT_LESSONS.filter((l) => l.partId === part.id);
        return (
          <div key={part.id} className="mt-4">
            <p className="px-4 pb-1.5 text-[10px] font-bold text-[#4B5563] uppercase tracking-widest">
              {part.label}
            </p>
            {partLessons.map((lesson) => {
              const isCurrent = lesson.slug === currentSlug;
              return (
                <Link
                  key={lesson.slug}
                  href={`/course/playwright/${lesson.slug}`}
                  onClick={onClose}
                  className={`flex items-center gap-2 px-4 py-2 text-[13px] transition-colors border-l-2 ${
                    isCurrent
                      ? "bg-[#00FF88]/12 text-[#00FF88] font-semibold border-l-[#00FF88]"
                      : "text-[#9CA3AF] hover:text-white hover:bg-white/4 border-l-transparent"
                  }`}
                >
                  <span className="text-[10px] text-[#4B5563] w-6 flex-shrink-0 font-mono">
                    {lesson.lessonNumber}
                  </span>
                  <span className="leading-snug">{lesson.title}</span>
                  {lesson.lessonNumber === "1.18" && (
                    <span className="ml-auto text-[9px] text-yellow-400 flex-shrink-0">★</span>
                  )}
                </Link>
              );
            })}
          </div>
        );
      })}
    </nav>
  );
}

export default function LessonLayout({ meta, children }: LessonLayoutProps) {
  const [drawerOpen, setDrawerOpen] = useState(false);

  const currentIndex = PLAYWRIGHT_LESSONS.findIndex((l) => l.slug === meta.slug);
  const prevLesson = currentIndex > 0 ? PLAYWRIGHT_LESSONS[currentIndex - 1] : null;
  const nextLesson =
    currentIndex < PLAYWRIGHT_LESSONS.length - 1
      ? PLAYWRIGHT_LESSONS[currentIndex + 1]
      : null;

  return (
    <div className="min-h-screen pt-16">
      {/* ── Centered page shell ──────────────────────────────────────────── */}
      <div className="max-w-[1440px] mx-auto flex min-h-[calc(100vh-4rem)]">

        {/* ── Sticky desktop sidebar ──────────────────────────────────── */}
        <aside className="hidden lg:flex flex-col w-60 xl:w-72 flex-shrink-0 border-r border-white/8 bg-[#0D0D0D]">
          <div className="sticky top-16 h-[calc(100vh-4rem)] overflow-y-auto scrollbar-thin">
            <SidebarContent currentSlug={meta.slug} />
          </div>
        </aside>

        {/* ── Mobile drawer ─────────────────────────────────────────────── */}
        {drawerOpen && (
          <div className="fixed inset-0 z-50 lg:hidden">
            <div
              className="absolute inset-0 bg-black/80"
              onClick={() => setDrawerOpen(false)}
            />
            <div className="absolute left-0 top-0 h-full w-64 bg-[#0D0D0D] border-r border-white/8 overflow-y-auto">
              <div className="flex items-center justify-between px-4 py-4 border-b border-white/8">
                <span className="text-sm font-black text-white">Course outline</span>
                <button
                  onClick={() => setDrawerOpen(false)}
                  className="p-1 rounded text-[#9CA3AF] hover:text-white"
                >
                  <X size={16} />
                </button>
              </div>
              <SidebarContent
                currentSlug={meta.slug}
                onClose={() => setDrawerOpen(false)}
              />
            </div>
          </div>
        )}

        {/* ── Main content ──────────────────────────────────────────────── */}
        <main className="flex-1 min-w-0">
          {/* Top bar: mobile menu + breadcrumb */}
          <div className="flex items-center gap-3 px-6 py-3 border-b border-white/8 bg-[#0B0B0B] sticky top-16 z-10">
            <button
              onClick={() => setDrawerOpen(true)}
              className="lg:hidden p-1.5 rounded text-[#9CA3AF] hover:text-white hover:bg-white/8 transition-colors"
            >
              <Menu size={18} />
            </button>
            <div className="flex items-center gap-1.5 text-[11px] text-[#4B5563] overflow-x-auto whitespace-nowrap">
              <Link href="/course/playwright" className="hover:text-[#00FF88] transition-colors">
                Course
              </Link>
              <ChevronRight size={10} />
              <span>{meta.part}</span>
              <ChevronRight size={10} />
              <span className="text-[#9CA3AF]">Lesson {meta.lessonNumber}</span>
            </div>
          </div>

          {/* Content wrapper */}
          <div className="px-8 sm:px-12 lg:px-16 py-8 max-w-5xl mx-auto">
            {/* Lesson title */}
            <div className="mb-8">
              <div className="flex items-center gap-2 mb-3">
                <span className="text-[10px] font-black uppercase tracking-[0.2em] text-[#00FF88]/60 px-2.5 py-1 rounded-full border border-[#00FF88]/20 bg-[#00FF88]/5">
                  Lesson {meta.lessonNumber}
                </span>
                <span className="text-[10px] text-[#4B5563]">{meta.part}</span>
              </div>
              <h1 className="text-3xl sm:text-4xl font-black leading-tight mb-3 bg-gradient-to-r from-white via-white to-[#9CA3AF] bg-clip-text text-transparent">
                {meta.title}
              </h1>
              <p className="text-[#9CA3AF] text-base leading-relaxed max-w-2xl">
                {meta.summary}
              </p>
            </div>

            {/* Top prev/next */}
            <div className="flex items-center justify-between gap-3 mb-10 pb-6 border-b border-white/8">
              {prevLesson ? (
                <Link
                  href={`/course/playwright/${prevLesson.slug}`}
                  className="flex items-center gap-2 px-4 py-2 rounded-lg bg-[#1A1A1A] border border-white/8 hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 text-sm text-[#9CA3AF] hover:text-white transition-all group"
                >
                  <ArrowLeft size={14} className="group-hover:text-[#00FF88] transition-colors" />
                  <span className="hidden sm:inline">Previous</span>
                </Link>
              ) : (
                <Link
                  href="/course/playwright"
                  className="flex items-center gap-2 px-4 py-2 rounded-lg bg-[#1A1A1A] border border-white/8 hover:border-[#00FF88]/30 text-sm text-[#9CA3AF] hover:text-white transition-all group"
                >
                  <ArrowLeft size={14} className="group-hover:text-[#00FF88] transition-colors" />
                  <span className="hidden sm:inline">Home</span>
                </Link>
              )}

              <div className="flex items-center gap-2 text-xs">
                <span className="px-2 py-1 rounded bg-[#00FF88]/10 text-[#00FF88] font-bold border border-[#00FF88]/20">
                  Lesson {meta.lessonNumber}
                </span>
                <span className="text-[#4B5563]">of {PLAYWRIGHT_LESSONS.length}</span>
              </div>

              {nextLesson ? (
                <Link
                  href={`/course/playwright/${nextLesson.slug}`}
                  className="flex items-center gap-2 px-4 py-2 rounded-lg bg-[#00FF88] hover:bg-[#00e67a] text-black text-sm font-bold transition-all group"
                >
                  <span>Next</span>
                  <ArrowRight size={14} />
                </Link>
              ) : (
                <div className="px-4 py-2 rounded-lg bg-[#1A1A1A] border border-white/8 text-sm text-[#4B5563]">
                  Finished!
                </div>
              )}
            </div>

            {/* Lesson body */}
            {children}

            {/* Bottom prev/next */}
            <div className="flex items-center justify-between gap-4 mt-14 pt-8 border-t border-white/8">
              {prevLesson ? (
                <Link
                  href={`/course/playwright/${prevLesson.slug}`}
                  className="flex items-center gap-3 px-5 py-3 rounded-xl bg-[#1A1A1A] border border-white/8 hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 transition-all group max-w-[48%]"
                >
                  <ArrowLeft
                    size={15}
                    className="text-[#6B7280] group-hover:text-[#00FF88] transition-colors flex-shrink-0"
                  />
                  <div className="text-left min-w-0">
                    <div className="text-[10px] text-[#4B5563] uppercase tracking-wider mb-0.5">
                      Previous
                    </div>
                    <div className="text-sm font-semibold text-[#9CA3AF] group-hover:text-white transition-colors line-clamp-1">
                      {prevLesson.title}
                    </div>
                  </div>
                </Link>
              ) : (
                <div />
              )}

              {nextLesson ? (
                <Link
                  href={`/course/playwright/${nextLesson.slug}`}
                  className="flex items-center gap-3 px-5 py-3 rounded-xl bg-[#00FF88] hover:bg-[#00e67a] transition-all group max-w-[48%] ml-auto"
                >
                  <div className="text-right min-w-0">
                    <div className="text-[10px] text-black/60 uppercase tracking-wider mb-0.5">
                      Next
                    </div>
                    <div className="text-sm font-bold text-black line-clamp-1">
                      {nextLesson.title}
                    </div>
                  </div>
                  <ArrowRight size={15} className="text-black flex-shrink-0" />
                </Link>
              ) : (
                <div />
              )}
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
