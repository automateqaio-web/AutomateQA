import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { PLAYWRIGHT_LESSONS } from "@/lib/course/playwright";
import { LESSON_COMPONENTS } from "@/lib/course/playwright/lessonComponents";
import LessonLayout from "@/components/course/LessonLayout";
import { ArrowRight } from "lucide-react";
import Link from "next/link";

interface Props {
  params: Promise<{ slug: string }>;
}

export function generateStaticParams() {
  return PLAYWRIGHT_LESSONS.map((l) => ({ slug: l.slug }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const meta = PLAYWRIGHT_LESSONS.find((l) => l.slug === slug);
  if (!meta) return { title: "Lesson Not Found | AutomateQA" };
  const url = `https://automateqa.online/course/playwright/${slug}`;
  return {
    title: `${meta.title} — Lesson ${meta.lessonNumber}`,
    description: meta.summary,
    alternates: { canonical: url },
    openGraph: {
      type: "article",
      url,
      title: `${meta.title} — Zero to Automation Hero`,
      description: meta.summary,
      images: [{ url: "/og-image.png", width: 1200, height: 630, alt: meta.title }],
    },
  };
}

export default async function LessonPage({ params }: Props) {
  const { slug } = await params;
  const meta = PLAYWRIGHT_LESSONS.find((l) => l.slug === slug);
  if (!meta) notFound();

  const LessonContent = LESSON_COMPONENTS[slug];

  return (
    <LessonLayout meta={meta}>
      {LessonContent ? (
        <LessonContent />
      ) : (
        // Placeholder for lessons not yet written
        <div className="glass-card p-10 text-center">
          <div className="text-4xl mb-4">🚧</div>
          <h2 className="text-xl font-black text-white mb-2">Coming soon</h2>
          <p className="text-[#9CA3AF] text-sm mb-6 max-w-sm mx-auto">
            Lesson {meta.lessonNumber} is being written. We publish new lessons every week.
          </p>
          <Link href="/course/playwright" className="btn-outline inline-flex text-sm">
            Back to course outline
            <ArrowRight size={14} />
          </Link>
        </div>
      )}
    </LessonLayout>
  );
}
