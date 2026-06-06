import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import Navbar from "@/components/shared/Navbar";
import Footer from "@/components/shared/Footer";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.dev"),
  title: {
    default: "AutomateQA — Automation Testing Meets Corporate Chaos",
    template: "%s | AutomateQA",
  },
  description: "QA memes, Playwright tutorials, Selenium tips, and real corporate pain. The home for QA engineers and automation testers.",
  keywords: ["QA automation", "Playwright", "Selenium", "QA memes", "software testing", "automation testing", "corporate humor"],
  authors: [{ name: "AutomateQA" }],
  creator: "AutomateQA",
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://automateqa.dev",
    siteName: "AutomateQA",
    title: "AutomateQA — Automation Testing Meets Corporate Chaos",
    description: "QA memes, Playwright tutorials, Selenium tips, and real corporate pain.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "AutomateQA",
    description: "QA memes, Playwright tutorials, Selenium tips, and real corporate pain.",
    images: ["/og-image.png"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true, "max-image-preview": "large" },
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={`${inter.variable} dark`} suppressHydrationWarning>
      <body className="min-h-screen bg-[#0B0B0B] text-white font-sans antialiased">
        <Navbar />
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
