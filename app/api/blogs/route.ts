import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const category = searchParams.get("category");
  const featured = searchParams.get("featured");
  const limit = Math.min(50, Math.max(1, parseInt(searchParams.get("limit") || "20")));

  try {
    const supabase = await createClient();
    let query = supabase
      .from("blogs")
      .select("id, title, slug, excerpt, cover_image, category, tags, featured, read_time, created_at")
      .eq("published", true)
      .order("created_at", { ascending: false })
      .limit(limit);

    if (category) query = query.eq("category", category);
    if (featured === "true") query = query.eq("featured", true);

    const { data, error } = await query;
    if (error) throw error;

    return NextResponse.json({ data }, { status: 200 });
  } catch {
    return NextResponse.json({ error: "Failed to fetch blogs" }, { status: 500 });
  }
}
