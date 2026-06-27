import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ── GET /api/ads/location/[location]  — public: active ads for a slot ─────────
export async function GET(_req: NextRequest, { params }: { params: Promise<{ location: string }> }) {
  const { location } = await params;
  const supabase = await createClient();

  // 1. Find ad_ids that target this location
  const { data: locs, error: locErr } = await supabase
    .from("ad_locations")
    .select("ad_id")
    .eq("location", location);

  if (locErr || !locs?.length) return NextResponse.json({ data: [] });

  const adIds = locs.map(l => l.ad_id);

  // 2. Fetch active ads with their relations
  const { data: ads, error: adsErr } = await supabase
    .from("ads")
    .select("*, ad_locations(*), ad_schedules(*), ad_targeting(*)")
    .in("id", adIds)
    .eq("is_active", true)
    .order("priority", { ascending: false });

  if (adsErr) return NextResponse.json({ data: [] });

  // 3. Filter by schedule (server-side, using current UTC time)
  const now = new Date();
  const active = (ads || []).filter(ad => {
    const schedule = ad.ad_schedules?.[0];
    if (!schedule) return true;
    const start = schedule.start_date ? new Date(schedule.start_date) : null;
    const end   = schedule.end_date   ? new Date(schedule.end_date)   : null;
    if (start && now < start) return false;
    if (end   && now > end)   return false;
    return true;
  });

  const result = active.map(ad => ({
    ...ad,
    locations: ad.ad_locations ?? [],
    schedule:  ad.ad_schedules?.[0] ?? null,
    targeting: ad.ad_targeting?.[0] ?? null,
  }));

  return NextResponse.json({ data: result }, {
    headers: { "Cache-Control": "no-store" },
  });
}
