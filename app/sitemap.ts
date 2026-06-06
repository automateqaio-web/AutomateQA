import { MetadataRoute } from "next";
import { createClient } from "@/lib/supabase/server";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const baseUrl = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.dev";

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: baseUrl, lastModified: new Date(), changeFrequency: "daily", priority: 1 },
    { url: `${baseUrl}/memes`, lastModified: new Date(), changeFrequency: "daily", priority: 0.9 },
    { url: `${baseUrl}/videos`, lastModified: new Date(), changeFrequency: "daily", priority: 0.9 },
    { url: `${baseUrl}/learn`, lastModified: new Date(), changeFrequency: "daily", priority: 0.9 },
    { url: `${baseUrl}/automation-tips`, lastModified: new Date(), changeFrequency: "daily", priority: 0.9 },
    { url: `${baseUrl}/blog`, lastModified: new Date(), changeFrequency: "daily", priority: 0.8 },
    { url: `${baseUrl}/creator-stats`, lastModified: new Date(), changeFrequency: "hourly", priority: 0.7 },
    { url: `${baseUrl}/about`, lastModified: new Date(), changeFrequency: "monthly", priority: 0.6 },
    { url: `${baseUrl}/contact`, lastModified: new Date(), changeFrequency: "monthly", priority: 0.5 },
  ];

  try {
    if (
      !process.env.NEXT_PUBLIC_SUPABASE_URL ||
      process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")
    ) {
      return staticRoutes;
    }

    const supabase = await createClient();
    const [blogsRes, learnRes, tipsRes] = await Promise.all([
      supabase.from("blogs").select("slug, updated_at, created_at").eq("published", true),
      supabase.from("learning_content").select("slug, updated_at, created_at").eq("published", true),
      supabase.from("automation_tips").select("slug, updated_at, created_at").eq("published", true),
    ]);

    const blogRoutes: MetadataRoute.Sitemap = (blogsRes.data || []).map((b) => ({
      url: `${baseUrl}/blog/${b.slug}`,
      lastModified: new Date(b.updated_at || b.created_at),
      changeFrequency: "weekly" as const,
      priority: 0.8,
    }));

    const learnRoutes: MetadataRoute.Sitemap = (learnRes.data || []).map((l) => ({
      url: `${baseUrl}/learn/${l.slug}`,
      lastModified: new Date(l.updated_at || l.created_at),
      changeFrequency: "weekly" as const,
      priority: 0.8,
    }));

    const tipRoutes: MetadataRoute.Sitemap = (tipsRes.data || []).map((t) => ({
      url: `${baseUrl}/automation-tips/${t.slug}`,
      lastModified: new Date(t.updated_at || t.created_at),
      changeFrequency: "weekly" as const,
      priority: 0.8,
    }));

    return [...staticRoutes, ...blogRoutes, ...learnRoutes, ...tipRoutes];
  } catch {
    return staticRoutes;
  }
}
