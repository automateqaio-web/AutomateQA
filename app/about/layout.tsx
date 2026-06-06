import type { Metadata } from "next";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export const metadata: Metadata = {
  title: "About | AutomateQA",
  description: "AutomateQA is the go-to community for QA automation engineers — quality memes, Playwright tutorials, Selenium tips, and real career advice.",
  keywords: ["about AutomateQA", "QA automation community", "software testing blog", "Playwright tutorials", "automation engineers", "QA memes"],
  alternates: { canonical: `${SITE_URL}/about` },
  openGraph: {
    type: "website",
    url: `${SITE_URL}/about`,
    title: "About | AutomateQA",
    description: "AutomateQA — the go-to community for QA automation engineers with memes, tutorials, and real career advice.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "About | AutomateQA",
    description: "AutomateQA — the go-to community for QA automation engineers.",
    images: ["/og-image.png"],
  },
};

export default function AboutLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
