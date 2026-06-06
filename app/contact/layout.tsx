import type { Metadata } from "next";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export const metadata: Metadata = {
  title: "Contact | AutomateQA",
  description: "Get in touch with AutomateQA for sponsorships, collaborations, content requests, or just to say hi to the QA community.",
  keywords: ["contact AutomateQA", "QA automation sponsorship", "collaboration", "software testing community", "automation testing"],
  alternates: { canonical: `${SITE_URL}/contact` },
  openGraph: {
    type: "website",
    url: `${SITE_URL}/contact`,
    title: "Contact | AutomateQA",
    description: "Get in touch with AutomateQA for sponsorships, collaborations, or content requests.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Contact | AutomateQA",
    description: "Get in touch with AutomateQA for sponsorships, collaborations, or content requests.",
    images: ["/og-image.png"],
  },
};

export default function ContactLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
