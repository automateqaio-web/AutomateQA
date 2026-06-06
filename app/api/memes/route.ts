import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const category = searchParams.get("category");
  const search = searchParams.get("search");
  const featured = searchParams.get("featured");
  const page = parseInt(searchParams.get("page") || "0");
  const limit = parseInt(searchParams.get("limit") || "12");

  try {
    const supabase = await createClient();
    let query = supabase
      .from("memes")
      .select("*")
      .eq("published", true)
      .order("created_at", { ascending: false })
      .range(page * limit, (page + 1) * limit - 1);

    if (category) query = query.eq("category", category);
    if (featured === "true") query = query.eq("featured", true);
    if (search) query = query.or(`title.ilike.%${search}%,caption.ilike.%${search}%`);

    const { data, error } = await query;
    if (error) throw error;

    return NextResponse.json({ data }, { status: 200 });
  } catch {
    return NextResponse.json({ error: "Failed to fetch memes" }, { status: 500 });
  }
}
