import type { Metadata } from "next";
import CreatorStatsClient from "@/components/creator-stats/CreatorStatsClient";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export const metadata: Metadata = {
  title: "Creator Stats | AutomateQA",
  description: "Live YouTube and Instagram analytics for AutomateQA — subscribers, views, viral content, and growth trends.",
  keywords: ["AutomateQA stats", "YouTube analytics", "QA automation channel", "creator dashboard", "software testing community growth"],
  alternates: { canonical: `${SITE_URL}/creator-stats` },
  openGraph: {
    type: "website",
    url: `${SITE_URL}/creator-stats`,
    title: "Creator Stats | AutomateQA",
    description: "Live YouTube and Instagram analytics for AutomateQA — subscribers, views, viral content, and growth trends.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA Creator Stats" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Creator Stats | AutomateQA",
    description: "Live YouTube and Instagram analytics for AutomateQA.",
    images: ["/og-image.png"],
  },
};

export default function CreatorStatsPage() {
  return <CreatorStatsClient />;
}
