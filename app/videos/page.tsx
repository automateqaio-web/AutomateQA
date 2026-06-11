import type { Metadata } from "next";
import { Play } from "lucide-react";
import VideoGrid from "@/components/videos/VideoGrid";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "Videos — QA Tutorials & Meme Compilations",
  description: "Watch Playwright tutorials, Selenium guides, API testing videos, and QA meme compilations. Learn automation while laughing.",
  keywords: ["QA automation videos", "Playwright tutorial", "Selenium tutorial", "API testing video", "software testing YouTube", "automation testing course", "QA engineer videos"],
  alternates: { canonical: "https://automateqa.online/videos" },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/videos",
    title: "Videos — QA Tutorials & Meme Compilations | AutomateQA",
    description: "Watch Playwright tutorials, Selenium guides, API testing videos, and QA meme compilations. Learn automation while laughing.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA Videos" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Videos — QA Tutorials & Meme Compilations | AutomateQA",
    description: "Watch Playwright tutorials, Selenium guides, API testing videos, and QA meme compilations.",
    images: ["/og-image.png"],
  },
};

async function getInitialVideos() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return [];
    const supabase = await createClient();
    const { data } = await supabase
      .from("videos")
      .select("*")
      .eq("published", true)
      .order("created_at", { ascending: false })
      .limit(12);
    return data || [];
  } catch {
    return [];
  }
}

export default async function VideosPage() {
  const initialVideos = await getInitialVideos();
  return (
    <div className="min-h-screen pt-16">
      <div className="relative overflow-hidden py-16 sm:py-20">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,100,0,0.05)_0%,transparent_60%)]" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-red-500/10 border border-red-500/20 flex items-center justify-center">
              <Play size={20} className="text-red-400" />
            </div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-500/10 border border-red-500/20 text-red-400 text-xs font-semibold">
              VIDEO LIBRARY
            </div>
          </div>
          <h1 className="text-4xl sm:text-5xl font-black text-white mb-4">
            Watch &amp; <span className="text-gradient">Learn</span>
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-xl">
            Playwright tutorials, Selenium deep-dives, API testing, and QA meme compilations that hit differently.
          </p>
        </div>
      </div>
      <VideoGrid initialVideos={initialVideos} />
    </div>
  );
}
