import type { Metadata } from "next";
import HeroSection from "@/components/home/HeroSection";
import JobsBoardBanner from "@/components/home/JobsBoardBanner";
import HomeFeatureCards from "@/components/home/HomeFeatureCards";
import FeaturedVideos from "@/components/home/FeaturedVideos";
import TrendingMemes from "@/components/home/TrendingMemes";
import LatestBlogs from "@/components/home/LatestBlogs";
import FeaturedTips from "@/components/home/FeaturedTips";
import { createClient } from "@/lib/supabase/server";

export const metadata: Metadata = {
  title: "AutomateQA — Automation Testing Meets Corporate Chaos",
  description: "QA memes, Playwright tutorials, Selenium tips, and real corporate pain. The home for QA engineers and automation testers.",
  alternates: { canonical: "https://automateqa.online" },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true, "max-image-preview": "large", "max-snippet": -1 },
  },
};

export const revalidate = 60;

const EMPTY = { memes: [], videos: [], blogs: [], tips: [] };

async function getHomeData() {
  // Skip fetch entirely if Supabase isn't configured yet
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")
  ) {
    return EMPTY;
  }

  try {
    const timeout = new Promise<typeof EMPTY>((resolve) =>
      setTimeout(() => resolve(EMPTY), 3000)
    );

    const fetch = async () => {
      const supabase = await createClient();
      const [memesRes, videosRes, blogsRes, tipsRes] = await Promise.all([
        supabase
          .from("memes")
          .select("*")
          .eq("published", true)
          .order("created_at", { ascending: false })
          .limit(8),
        supabase
          .from("videos")
          .select("*")
          .eq("published", true)
          .order("created_at", { ascending: false })
          .limit(6),
        supabase
          .from("blogs")
          .select("*")
          .eq("published", true)
          .order("created_at", { ascending: false })
          .limit(3),
        supabase
          .from("automation_tips")
          .select("*")
          .eq("published", true)
          .order("featured", { ascending: false })
          .order("created_at", { ascending: false })
          .limit(3),
      ]);
      return {
        memes: memesRes.data || [],
        videos: videosRes.data || [],
        blogs: blogsRes.data || [],
        tips: tipsRes.data || [],
      };
    };

    return await Promise.race([fetch(), timeout]);
  } catch {
    return EMPTY;
  }
}

export default async function HomePage() {
  const { memes, videos, blogs, tips } = await getHomeData();

  return (
    <>
      <HeroSection />
      <JobsBoardBanner />
      <HomeFeatureCards />
      <FeaturedVideos videos={videos} />
      <TrendingMemes memes={memes} />
      <FeaturedTips tips={tips} />
      <LatestBlogs blogs={blogs} />
    </>
  );
}
