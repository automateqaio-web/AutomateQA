import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const IG_TOKEN = process.env.INSTAGRAM_ACCESS_TOKEN;
const IG_ACCOUNT_ID = process.env.INSTAGRAM_ACCOUNT_ID;

export async function GET() {
  if (!IG_TOKEN || !IG_ACCOUNT_ID) {
    return fetchCachedStats();
  }

  try {
    // Fetch account info + follower count
    const accountRes = await fetch(
      `https://graph.instagram.com/v21.0/${IG_ACCOUNT_ID}?fields=followers_count,media_count,name,username&access_token=${IG_TOKEN}`,
      { next: { revalidate: 3600 } }
    );
    const accountData = await accountRes.json();

    if (accountData.error) return fetchCachedStats();

    // Fetch media (reels, posts)
    const mediaRes = await fetch(
      `https://graph.instagram.com/v21.0/${IG_ACCOUNT_ID}/media?fields=id,caption,media_type,thumbnail_url,timestamp,like_count,comments_count,permalink,insights.metric(reach,impressions,plays)&limit=20&access_token=${IG_TOKEN}`,
      { next: { revalidate: 3600 } }
    );
    const mediaData = await mediaRes.json();

    const reels = (mediaData.data || [])
      .filter((m: IGMediaItem) => m.media_type === "REELS" || m.media_type === "VIDEO")
      .map((m: IGMediaItem) => ({
        id: m.id,
        thumbnail: m.thumbnail_url || "",
        caption: m.caption || "",
        likes: m.like_count || 0,
        comments: m.comments_count || 0,
        views: m.insights?.data?.find((d: IGInsightItem) => d.name === "plays")?.values?.[0]?.value || 0,
        reach: m.insights?.data?.find((d: IGInsightItem) => d.name === "reach")?.values?.[0]?.value || 0,
        url: m.permalink,
        timestamp: m.timestamp,
      }));

    const totalReelViews = reels.reduce((sum: number, r: { views: number }) => sum + r.views, 0);
    const totalLikes = reels.reduce((sum: number, r: { likes: number }) => sum + r.likes, 0);
    const engagementRate = accountData.followers_count > 0
      ? ((totalLikes / reels.length || 0) / accountData.followers_count) * 100
      : 0;

    const stats = {
      followers: accountData.followers_count || 0,
      total_reel_views: totalReelViews,
      engagement_rate: Math.round(engagementRate * 100) / 100,
      reach: 0,
      impressions: 0,
      total_posts: accountData.media_count || 0,
    };

    // Cache to DB
    try {
      const supabase = await createClient();
      await supabase.from("instagram_stats").insert(stats);
    } catch { /* non-critical */ }

    const latest = reels.slice(0, 6);
    const viral = [...reels].sort((a, b) => b.views - a.views).slice(0, 6);

    return NextResponse.json({ stats, latest, viral });
  } catch {
    return fetchCachedStats();
  }
}

interface IGMediaItem {
  id: string;
  caption?: string;
  media_type: string;
  thumbnail_url?: string;
  timestamp: string;
  like_count?: number;
  comments_count?: number;
  permalink: string;
  insights?: { data: IGInsightItem[] };
}

interface IGInsightItem {
  name: string;
  values: { value: number }[];
}

async function fetchCachedStats() {
  try {
    if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) {
      return NextResponse.json({ stats: null, latest: [], viral: [] });
    }
    const supabase = await createClient();
    const { data } = await supabase
      .from("instagram_stats")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(1)
      .single();
    return NextResponse.json({ stats: data || null, latest: [], viral: [] });
  } catch {
    return NextResponse.json({ stats: null, latest: [], viral: [] });
  }
}
