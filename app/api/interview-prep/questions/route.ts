import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

function sanitizeSearch(raw: string): string {
  return raw.trim().replace(/[%_*()[\]{}"'\\;,]/g, "").slice(0, 100);
}

const MAX_LIMIT = 50;

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const technology    = searchParams.get("technology");
  const difficulty    = searchParams.get("difficulty");
  const experienceLevel = searchParams.get("experience_level");
  const questionType  = searchParams.get("question_type");
  const featured      = searchParams.get("featured");
  const rawSearch     = searchParams.get("search") || "";
  const limit  = Math.min(MAX_LIMIT, Math.max(1, parseInt(searchParams.get("limit")  || "12")));
  const offset = Math.max(0, parseInt(searchParams.get("offset") || "0"));

  try {
    const supabase = await createClient();
    let query = supabase
      .from("interview_questions")
      .select("id,question,slug,short_description,technology,question_type,experience_level,difficulty,tags,featured,views,created_at")
      .eq("published", true);

    if (technology)     query = query.eq("technology", technology);
    if (difficulty)     query = query.eq("difficulty", difficulty);
    if (experienceLevel) query = query.eq("experience_level", experienceLevel);
    if (questionType)   query = query.eq("question_type", questionType);
    if (featured === "true") query = query.eq("featured", true);

    const safeSearch = sanitizeSearch(rawSearch);
    if (safeSearch) {
      query = query.or(`question.ilike.%${safeSearch}%,short_description.ilike.%${safeSearch}%,tags.cs.{${safeSearch}}`);
    }

    query = query
      .order("featured",    { ascending: false })
      .order("views",       { ascending: false })
      .order("created_at",  { ascending: false })
      .range(offset, offset + limit - 1);

    const { data, error } = await query;
    if (error) throw error;
    return NextResponse.json({ data: data || [] });
  } catch (err) {
    console.error("Interview questions API error:", err);
    return NextResponse.json({ error: "Failed to fetch questions" }, { status: 500 });
  }
}
