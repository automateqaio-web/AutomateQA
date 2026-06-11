import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import SiteChrome from "@/components/shared/SiteChrome";
import PWAInstallPrompt from "@/components/shared/PWAInstallPrompt";
import SiteViewTracker from "@/components/analytics/SiteViewTracker";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const viewport: Viewport = {
  themeColor: "#00FF88",
  width: "device-width",
  initialScale: 1,
  maximumScale: 5,
  userScalable: true,
};

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online"),
  title: {
    default: "AutomateQA — Automation Testing Meets Corporate Chaos",
    template: "%s | AutomateQA",
  },
  description: "QA memes, Playwright tutorials, Selenium tips, and real corporate pain. The home for QA engineers and automation testers.",
  keywords: ["QA automation", "Playwright", "Selenium", "QA memes", "software testing", "automation testing", "corporate humor"],
  authors: [{ name: "AutomateQA" }],
  creator: "AutomateQA",
  manifest: "/manifest.webmanifest",
  appleWebApp: {
    capable: true,
    statusBarStyle: "black-translucent",
    title: "AutomateQA",
    startupImage: ["/icons/icon-512.png"],
  },
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://automateqa.online",
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
  icons: {
    icon: [
      { url: "/logo.png", type: "image/png" },
      { url: "/icons/icon-192.png", sizes: "192x192", type: "image/png" },
      { url: "/icons/icon-512.png", sizes: "512x512", type: "image/png" },
    ],
    apple: [
      { url: "/icons/apple-touch-icon.png", sizes: "180x180", type: "image/png" },
    ],
    shortcut: "/logo.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={`${inter.variable} dark`} suppressHydrationWarning>
      <head>
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
        <meta name="apple-mobile-web-app-title" content="AutomateQA" />
        <meta name="application-name" content="AutomateQA" />
        <meta name="msapplication-TileColor" content="#00FF88" />
        <meta name="msapplication-tap-highlight" content="no" />
        <link rel="apple-touch-icon" href="/icons/apple-touch-icon.png" />
      </head>
      <body className="min-h-screen bg-[#0B0B0B] text-white font-sans antialiased">
        <SiteViewTracker />
        <SiteChrome>{children}</SiteChrome>
        <PWAInstallPrompt />
      </body>
    </html>
  );
}
