import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL || "https://placeholder.supabase.co",
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "placeholder-key"
);

export async function POST(req: NextRequest) {
  try {
    const { section, content_id } = await req.json();
    if (!section || typeof section !== "string") {
      return NextResponse.json({ ok: false }, { status: 400 });
    }
    const { error } = await supabase
      .from("page_events")
      .insert({ section, content_id: content_id || null });
    if (error) return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
    return NextResponse.json({ ok: true });
  } catch {
    return NextResponse.json({ ok: false }, { status: 500 });
  }
}
