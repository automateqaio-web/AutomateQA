import { MetadataRoute } from "next";
import { createClient } from "@supabase/supabase-js";

export const revalidate = 3600;

const SITE = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base: MetadataRoute.Sitemap = [
    {
      url: `${SITE}/interview-prep`,
      lastModified: new Date(),
      changeFrequency: "daily",
      priority: 1.0,
    },
  ];

  try {
    if (
      !process.env.NEXT_PUBLIC_SUPABASE_URL ||
      process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")
    ) {
      return base;
    }

    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL || "https://placeholder.supabase.co",
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "placeholder-key"
    );
    const { data } = await supabase
      .from("interview_questions")
      .select("slug, technology, difficulty, updated_at, created_at")
      .eq("published", true)
      .order("views", { ascending: false });

    const questionRoutes: MetadataRoute.Sitemap = (data || []).map((q) => ({
      url: `${SITE}/interview-prep/${q.slug}`,
      lastModified: new Date(q.updated_at || q.created_at),
      changeFrequency: "weekly" as const,
      priority: 0.9,
    }));

    return [...base, ...questionRoutes];
  } catch {
    return base;
  }
}
