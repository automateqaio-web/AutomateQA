import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ── GET /api/ads  — admin: list all ads with relations ────────────────────────
export async function GET() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data, error } = await supabase
    .from("ads")
    .select("*, ad_locations(*), ad_schedules(*), ad_targeting(*)")
    .order("priority", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const ads = (data || []).map(ad => ({
    ...ad,
    locations: ad.ad_locations ?? [],
    schedule:  ad.ad_schedules?.[0]  ?? null,
    targeting: ad.ad_targeting?.[0]  ?? null,
  }));

  return NextResponse.json({ data: ads });
}

// ── POST /api/ads  — admin: create ad + relations ─────────────────────────────
export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  let body: Record<string, unknown>;
  try { body = await req.json(); } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const {
    name, type = "promotion", title,
    subtitle, description, cta_text, cta_link, cta_open = "new_tab",
    desktop_image_url, mobile_image_url, logo_url,
    bg_color, gradient, text_color, button_color, badge,
    display_style = "premium_banner", animation = "fade",
    priority = 50, is_active = true,
    locations = [], schedule = null, targeting = null,
  } = body as Record<string, unknown>;

  if (!name || !title) {
    return NextResponse.json({ error: "name and title are required" }, { status: 400 });
  }

  // 1. Insert main ad
  const { data: ad, error: adErr } = await supabase
    .from("ads")
    .insert({
      name, type, title, subtitle, description,
      cta_text, cta_link, cta_open,
      desktop_image_url, mobile_image_url, logo_url,
      bg_color, gradient, text_color, button_color, badge,
      display_style, animation, priority, is_active,
    })
    .select()
    .single();

  if (adErr) return NextResponse.json({ error: adErr.message }, { status: 500 });

  const adId = ad.id;
  const errors: string[] = [];

  // 2. Insert locations
  const locs = locations as Array<{ location: string; css_selector?: string }>;
  if (locs.length > 0) {
    const { error: locErr } = await supabase.from("ad_locations").insert(
      locs.map(l => ({ ad_id: adId, location: l.location, css_selector: l.css_selector ?? null }))
    );
    if (locErr) errors.push(`locations: ${locErr.message}`);
  }

  // 3. Upsert schedule
  if (schedule) {
    const s = schedule as Record<string, unknown>;
    const { error: schErr } = await supabase.from("ad_schedules").insert({
      ad_id: adId, start_date: s.start_date ?? null,
      end_date: s.end_date ?? null, timezone: s.timezone ?? "Asia/Kolkata",
    });
    if (schErr) errors.push(`schedule: ${schErr.message}`);
  }

  // 4. Upsert targeting
  if (targeting) {
    const t = targeting as Record<string, unknown>;
    const { error: tgtErr } = await supabase.from("ad_targeting").insert({
      ad_id: adId,
      show_to_logged_in: t.show_to_logged_in ?? true,
      show_to_guests:    t.show_to_guests    ?? true,
      devices:           t.devices           ?? ["desktop","mobile","tablet"],
      countries:         t.countries         ?? null,
      user_type:         t.user_type         ?? "all",
    });
    if (tgtErr) errors.push(`targeting: ${tgtErr.message}`);
  }

  return NextResponse.json({ data: ad, errors }, { status: 201 });
}
