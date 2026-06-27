import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ── POST /api/ads/impression  — public: track impression ──────────────────────
export async function POST(req: NextRequest) {
  let body: { ad_id?: string; location?: string; device?: string };
  try { body = await req.json(); } catch { return NextResponse.json({ ok: false }); }

  const { ad_id, location, device } = body;
  if (!ad_id) return NextResponse.json({ ok: false });

  const supabase = await createClient();
  await supabase.rpc("increment_ad_impression", {
    ad_id_param:    ad_id,
    location_param: location ?? null,
    device_param:   device   ?? null,
  });

  return NextResponse.json({ ok: true });
}
