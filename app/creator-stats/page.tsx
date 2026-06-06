import type { Metadata } from "next";
import CreatorStatsClient from "@/components/creator-stats/CreatorStatsClient";

export const metadata: Metadata = {
  title: "Creator Stats | AutomateQA",
  description: "Live YouTube and Instagram analytics for AutomateQA — subscribers, views, viral content, and growth trends.",
  openGraph: {
    title: "Creator Stats | AutomateQA",
    description: "Real-time creator analytics dashboard.",
    type: "website",
  },
};

export default function CreatorStatsPage() {
  return <CreatorStatsClient />;
}
