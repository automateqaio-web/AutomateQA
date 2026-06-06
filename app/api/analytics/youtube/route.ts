import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const YT_API_KEY = process.env.YOUTUBE_API_KEY;
const YT_CHANNEL_ID = process.env.YOUTUBE_CHANNEL_ID;

export const revalidate = 3600;

interface ViralVideoItem {
  id: string;
  title: string;
  thumbnail: string;
  views: number;
  likes: number;
  comments: number;
  published_at: string;
  url: string;
}

interface YouTubeAPIItem {
  id: string;
  snippet: {
    title: string;
    publishedAt: string;
    thumbnails: { maxres?: { url: string }; high?: { url: string }; default?: { url: string } };
  };
  statistics: {
    viewCount?: string;
    likeCount?: string;
    commentCount?: string;
  };
}

interface PlaylistItem {
  snippet: {
    resourceId: { videoId: string };
  };
}

export async function GET() {
  if (!YT_API_KEY || !YT_CHANNEL_ID) {
    return fetchCachedStats();
  }

  try {
    // 1. Fetch channel stats + branding (banner image)
    const channelRes = await fetch(
      `https://www.googleapis.com/youtube/v3/channels?part=statistics,brandingSettings&id=${YT_CHANNEL_ID}&key=${YT_API_KEY}`,
      { next: { revalidate: 3600 } }
    );
    const channelData = await channelRes.json();
    const channel = channelData.items?.[0];
    if (!channel) return fetchCachedStats();

    const totalViews = parseInt(channel.statistics.viewCount || "0");
    const stats = {
      subscribers: parseInt(channel.statistics.subscriberCount || "0"),
      total_views: totalViews,
      total_videos: parseInt(channel.statistics.videoCount || "0"),
      watch_hours: Math.round((totalViews * 2.5) / 60),
    };
    // YouTube provides several banner sizes; bannerExternalUrl is the highest res
    const bannerUrl: string =
      channel.brandingSettings?.image?.bannerExternalUrl || "";

    // 2. Fetch all video IDs from uploads playlist
    // Every channel's uploads playlist = channel ID with "UC" replaced by "UU"
    const uploadsPlaylistId = YT_CHANNEL_ID.replace(/^UC/, "UU");
    const playlistRes = await fetch(
      `https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=${uploadsPlaylistId}&maxResults=50&key=${YT_API_KEY}`,
      { next: { revalidate: 3600 } }
    );
    const playlistData = await playlistRes.json();
    const allVideoIds: string[] = (playlistData.items || [])
      .map((item: PlaylistItem) => item.snippet?.resourceId?.videoId)
      .filter(Boolean);

    if (!allVideoIds.length) return fetchCachedStats();

    // 3. Fetch full statistics + snippet for all videos in one call
    const statsRes = await fetch(
      `https://www.googleapis.com/youtube/v3/videos?part=statistics,snippet&id=${allVideoIds.join(",")}&key=${YT_API_KEY}`,
      { next: { revalidate: 3600 } }
    );
    const statsData = await statsRes.json();

    const allVideos: ViralVideoItem[] = (statsData.items || []).map((v: YouTubeAPIItem) => ({
      id: v.id,
      title: v.snippet?.title || "",
      thumbnail:
        v.snippet?.thumbnails?.maxres?.url ||
        v.snippet?.thumbnails?.high?.url ||
        v.snippet?.thumbnails?.default?.url ||
        "",
      views: parseInt(v.statistics?.viewCount || "0"),
      likes: parseInt(v.statistics?.likeCount || "0"),
      comments: parseInt(v.statistics?.commentCount || "0"),
      published_at: v.snippet?.publishedAt || "",
      url: `https://youtube.com/watch?v=${v.id}`,
    }));

    // Latest = playlist order (newest first from playlistItems), take 6
    const latest = allVideos.slice(0, 6);

    // Most viral = sort ALL by views descending, take top 6
    const videos = [...allVideos]
      .sort((a, b) => b.views - a.views)
      .slice(0, 6);

    // Cache stats in DB (non-critical)
    try {
      const supabase = await createClient();
      await supabase.from("youtube_stats").insert(stats);
    } catch { /* non-critical */ }

    return NextResponse.json({ stats, videos, latest, bannerUrl }, {
      headers: { "Cache-Control": "public, s-maxage=3600, stale-while-revalidate=300" },
    });
  } catch {
    return fetchCachedStats();
  }
}

async function fetchCachedStats() {
  try {
    if (!process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes("placeholder")) {
      return NextResponse.json({ stats: null, videos: [], latest: [] });
    }
    const supabase = await createClient();
    const { data } = await supabase
      .from("youtube_stats")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(1)
      .single();
    return NextResponse.json({ stats: data || null, videos: [], latest: [] });
  } catch {
    return NextResponse.json({ stats: null, videos: [], latest: [] });
  }
}
