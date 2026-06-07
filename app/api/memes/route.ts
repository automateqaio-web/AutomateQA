import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Strip characters that could manipulate PostgREST filter syntax
function sanitizeSearch(raw: string): string {
  return raw.trim().replace(/[%_*()[\]{}"'\\;,]/g, "").slice(0, 100);
}

const ALLOWED_CATEGORIES = ["Playwright", "Selenium", "Cypress", "API Testing", "CI/CD", "Career", "General", "Meme"];
const MAX_LIMIT = 50;

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const categoryRaw = searchParams.get("category");
  const category = categoryRaw && ALLOWED_CATEGORIES.includes(categoryRaw) ? categoryRaw : null;
  const searchRaw = searchParams.get("search") || "";
  const search = searchRaw ? sanitizeSearch(searchRaw) : "";
  const featured = searchParams.get("featured");
  const page = Math.max(0, parseInt(searchParams.get("page") || "0"));
  const limit = Math.min(MAX_LIMIT, Math.max(1, parseInt(searchParams.get("limit") || "12")));

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
