import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import { InterviewQuestion } from "@/types";
import InterviewPrepListing from "@/components/interview-prep/InterviewPrepListing";

export const revalidate = 60;

const SITE = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export const metadata: Metadata = {
  title: "QA Automation Interview Questions & Answers | AutomateQA Interview Prep",
  description:
    "Master QA automation interviews with 100+ real-world questions, structured answers, scenario-based challenges, coding problems, and framework discussions for Selenium, Playwright, Cypress, Core Java, API Testing, TestNG, Cucumber and more.",
  keywords: [
    "QA automation interview questions",
    "SDET interview questions and answers",
    "Selenium interview questions",
    "Playwright interview questions",
    "Cypress interview preparation",
    "QA engineer interview prep",
    "Core Java interview for QA",
    "API testing interview questions",
    "TestNG interview questions",
    "Cucumber BDD interview",
    "Page Object Model interview",
    "automation framework design interview",
    "software testing interview",
    "CI/CD interview questions",
    "Jenkins interview for QA",
    "interview questions for automation testers",
  ],
  authors: [{ name: "AutomateQA", url: SITE }],
  category: "Education",
  alternates: { canonical: `${SITE}/interview-prep` },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true, "max-image-preview": "large", "max-snippet": -1 },
  },
  openGraph: {
    title: "QA Automation Interview Questions & Answers | AutomateQA",
    description:
      "100+ real-world QA interview questions with structured answers for Selenium, Playwright, Java, API Testing, CI/CD and more. Ace your next SDET interview.",
    url: `${SITE}/interview-prep`,
    siteName: "AutomateQA",
    type: "website",
    locale: "en_US",
    images: [
      {
        url: `${SITE}/og-image.png`,
        width: 1200,
        height: 630,
        alt: "AutomateQA Interview Prep — QA Automation Interview Questions",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    site: "@automateqa",
    title: "QA Automation Interview Questions & Answers | AutomateQA",
    description:
      "Master QA automation interviews — Selenium, Playwright, Java, API Testing, CI/CD and more.",
    images: [`${SITE}/og-image.png`],
  },
};

const SELECT_FIELDS =
  "id,question,slug,short_description,answer,technology,question_type,experience_level,difficulty,tags,featured,views,created_at,updated_at";

async function getInitialQuestions(): Promise<InterviewQuestion[]> {
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")
  )
    return [];
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("interview_questions")
      .select(SELECT_FIELDS)
      .eq("published", true)
      .order("featured", { ascending: false })
      .order("views", { ascending: false })
      .order("created_at", { ascending: false })
      .limit(12);
    return (data || []) as InterviewQuestion[];
  } catch {
    return [];
  }
}

function buildSchemas(questions: InterviewQuestion[]) {
  const breadcrumb = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "Home", item: SITE },
      { "@type": "ListItem", position: 2, name: "Interview Prep", item: `${SITE}/interview-prep` },
    ],
  };

  const itemList = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    name: "QA Automation Interview Questions & Answers",
    description:
      "Comprehensive collection of QA automation interview questions with detailed answers covering Selenium, Playwright, Java, API Testing, CI/CD pipelines, and framework design.",
    url: `${SITE}/interview-prep`,
    publisher: {
      "@type": "Organization",
      name: "AutomateQA",
      url: SITE,
      logo: { "@type": "ImageObject", url: `${SITE}/logo.png` },
    },
    mainEntity: {
      "@type": "ItemList",
      name: "QA Automation Interview Questions",
      numberOfItems: questions.length,
      itemListElement: questions.slice(0, 10).map((q, i) => ({
        "@type": "ListItem",
        position: i + 1,
        item: {
          "@type": "Question",
          name: q.question,
          url: `${SITE}/interview-prep/${q.slug}`,
          ...(q.answer || q.short_description
            ? {
                acceptedAnswer: {
                  "@type": "Answer",
                  text: (q.answer || q.short_description || "")
                    .replace(/[#*`[\]>_~]/g, "")
                    .slice(0, 300),
                },
              }
            : {}),
        },
      })),
    },
  };

  const faqPage = questions.length > 0
    ? {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        mainEntity: questions
          .filter((q) => q.answer || q.short_description)
          .slice(0, 5)
          .map((q) => ({
            "@type": "Question",
            name: q.question,
            acceptedAnswer: {
              "@type": "Answer",
              text: (q.answer || q.short_description || "")
                .replace(/[#*`[\]>_~]/g, "")
                .slice(0, 500),
            },
          })),
      }
    : null;

  return [breadcrumb, itemList, ...(faqPage ? [faqPage] : [])];
}

export default async function InterviewPrepPage() {
  const initialQuestions = await getInitialQuestions();
  const schemas = buildSchemas(initialQuestions);

  return (
    <>
      {schemas.map((schema, i) => (
        <script
          key={i}
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
        />
      ))}
      <InterviewPrepListing initialQuestions={initialQuestions} />
    </>
  );
}
