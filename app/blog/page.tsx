import type { Metadata } from "next";
import { BookOpen } from "lucide-react";
import BlogListing from "@/components/blog/BlogListing";
import ComingSoon from "@/components/shared/ComingSoon";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "Blog — Automation Testing Tutorials & QA Stories",
  description: "In-depth tutorials on Playwright, Selenium, API testing, QA career tips, and corporate QA stories from the trenches.",
  keywords: ["QA blog", "automation testing tutorials", "Playwright guide", "Selenium guide", "software testing articles", "QA career tips", "test automation blog"],
  alternates: { canonical: "https://automateqa.online/blog" },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/blog",
    title: "Blog — Automation Testing Tutorials & QA Stories | AutomateQA",
    description: "In-depth tutorials on Playwright, Selenium, API testing, QA career tips, and corporate QA stories from the trenches.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA Blog" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Blog — Automation Testing Tutorials & QA Stories | AutomateQA",
    description: "In-depth tutorials on Playwright, Selenium, API testing, QA career tips, and corporate QA stories from the trenches.",
    images: ["/og-image.png"],
  },
};

async function getPageSettings() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return null;
    const supabase = await createClient();
    const { data } = await supabase
      .from("page_settings")
      .select("*")
      .eq("key", "blog")
      .single();
    return data;
  } catch {
    return null;
  }
}

export default async function BlogPage() {
  const settings = await getPageSettings();

  if (settings?.coming_soon) {
    return (
      <ComingSoon
        title={settings.coming_soon_title}
        message={settings.coming_soon_message}
        pageLabel="the Blog"
      />
    );
  }
  return (
    <div className="min-h-screen pt-16">
      <div className="relative overflow-hidden py-16 sm:py-20">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,rgba(0,100,255,0.05)_0%,transparent_60%)]" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-blue-500/10 border border-blue-500/20 flex items-center justify-center">
              <BookOpen size={20} className="text-blue-400" />
            </div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold">
              QA KNOWLEDGE BASE
            </div>
          </div>
          <h1 className="text-4xl sm:text-5xl font-black text-white mb-4">
            The QA <span className="text-gradient">Engineer&apos;s</span> Desk
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-xl">
            Deep-dive tutorials, career advice, and survival guides for automation engineers navigating corporate chaos.
          </p>
        </div>
      </div>
      <BlogListing />
    </div>
  );
}
