import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Cached at the CDN/server for 10 minutes
export const revalidate = 600;

export async function GET() {
  const headers = {
    "Cache-Control": "public, s-maxage=600, stale-while-revalidate=60",
  };

  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const ytKey = process.env.YOUTUBE_API_KEY;
    const ytChannel = process.env.YOUTUBE_CHANNEL_ID;

    let subscribers: number | null = null;
    let memes: number | null = null;
    let videos: number | null = null;
    let tutorials: number | null = null;

    // Run YouTube + Supabase counts in parallel with a 4s hard timeout
    const timeout = <T>(p: Promise<T>, fallback: T): Promise<T> =>
      Promise.race([p, new Promise<T>((r) => setTimeout(() => r(fallback), 4000))]);

    const [ytData, dbData] = await Promise.all([
      // YouTube subscribers
      ytKey && ytChannel
        ? timeout(
            fetch(
              `https://www.googleapis.com/youtube/v3/channels?part=statistics&id=${ytChannel}&key=${ytKey}`,
              { next: { revalidate: 3600 } }
            )
              .then((r) => r.json())
              .then((d) => parseInt(d.items?.[0]?.statistics?.subscriberCount || "0"))
              .catch(() => null),
            null
          )
        : Promise.resolve(null),

      // Supabase counts
      supabaseUrl && !supabaseUrl.includes("placeholder")
        ? timeout(
            (async () => {
              const supabase = await createClient();
              const [m, v, t] = await Promise.all([
                supabase.from("memes").select("id", { count: "exact", head: true }).eq("published", true),
                supabase.from("videos").select("id", { count: "exact", head: true }).eq("published", true),
                supabase.from("learning_content").select("id", { count: "exact", head: true }).eq("published", true),
              ]);
              return { memes: m.count, videos: v.count, tutorials: t.count };
            })(),
            { memes: null, videos: null, tutorials: null }
          )
        : Promise.resolve({ memes: null, videos: null, tutorials: null }),
    ]);

    subscribers = typeof ytData === "number" ? ytData : null;
    memes = dbData.memes;
    videos = dbData.videos;
    tutorials = dbData.tutorials;

    return NextResponse.json(
      { subscribers, memes, videos, tutorials },
      { headers }
    );
  } catch {
    return NextResponse.json(
      { subscribers: null, memes: null, videos: null, tutorials: null },
      { headers }
    );
  }
}
