import type { Metadata } from "next";
import HeroSection from "@/components/home/HeroSection";
import FeaturedVideos from "@/components/home/FeaturedVideos";
import TrendingMemes from "@/components/home/TrendingMemes";
import PlaywrightDays from "@/components/home/PlaywrightDays";
import LatestBlogs from "@/components/home/LatestBlogs";
import { createClient } from "@/lib/supabase/server";

export const metadata: Metadata = {
  title: "AutomateQA — Automation Testing Meets Corporate Chaos",
  description: "QA memes, Playwright tutorials, Selenium tips, and real corporate pain. The home for QA engineers and automation testers.",
};

export const revalidate = 60;

const EMPTY = { memes: [], videos: [], blogs: [] };

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
      const [memesRes, videosRes, blogsRes] = await Promise.all([
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
      ]);
      return {
        memes: memesRes.data || [],
        videos: videosRes.data || [],
        blogs: blogsRes.data || [],
      };
    };

    return await Promise.race([fetch(), timeout]);
  } catch {
    return EMPTY;
  }
}

export default async function HomePage() {
  const { memes, videos, blogs } = await getHomeData();

  return (
    <>
      <HeroSection />
      <FeaturedVideos videos={videos} />
      <TrendingMemes memes={memes} />
      <PlaywrightDays />
      <LatestBlogs blogs={blogs} />
    </>
  );
}
