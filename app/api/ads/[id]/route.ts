import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type Params = { params: Promise<{ id: string }> };

// ── GET /api/ads/[id] ─────────────────────────────────────────────────────────
export async function GET(_req: NextRequest, { params }: Params) {
  const { id } = await params;
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data, error } = await supabase
    .from("ads")
    .select("*, ad_locations(*), ad_schedules(*), ad_targeting(*)")
    .eq("id", id)
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 404 });

  return NextResponse.json({
    data: {
      ...data,
      locations: data.ad_locations ?? [],
      schedule:  data.ad_schedules?.[0]  ?? null,
      targeting: data.ad_targeting?.[0]  ?? null,
    },
  });
}

// ── PUT /api/ads/[id] ─────────────────────────────────────────────────────────
export async function PUT(req: NextRequest, { params }: Params) {
  const { id } = await params;
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  let body: Record<string, unknown>;
  try { body = await req.json(); } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const {
    name, type, title, subtitle, description,
    cta_text, cta_link, cta_open,
    desktop_image_url, mobile_image_url, logo_url,
    bg_color, gradient, text_color, button_color, badge,
    display_style, animation, priority, is_active,
    locations, schedule, targeting,
  } = body as Record<string, unknown>;

  // 1. Update main ad
  const { error: adErr } = await supabase
    .from("ads")
    .update({
      name, type, title, subtitle, description,
      cta_text, cta_link, cta_open,
      desktop_image_url, mobile_image_url, logo_url,
      bg_color, gradient, text_color, button_color, badge,
      display_style, animation, priority, is_active,
      updated_at: new Date().toISOString(),
    })
    .eq("id", id);

  if (adErr) return NextResponse.json({ error: adErr.message }, { status: 500 });

  const errors: string[] = [];

  // 2. Replace locations (delete all + re-insert)
  if (Array.isArray(locations)) {
    await supabase.from("ad_locations").delete().eq("ad_id", id);
    if (locations.length > 0) {
      const { error: locErr } = await supabase.from("ad_locations").insert(
        (locations as Array<{ location: string; css_selector?: string }>).map(l => ({
          ad_id: id, location: l.location, css_selector: l.css_selector ?? null,
        }))
      );
      if (locErr) errors.push(`locations: ${locErr.message}`);
    }
  }

  // 3. Upsert schedule
  if (schedule !== undefined) {
    if (schedule === null) {
      await supabase.from("ad_schedules").delete().eq("ad_id", id);
    } else {
      const s = schedule as Record<string, unknown>;
      const { error: schErr } = await supabase.from("ad_schedules").upsert(
        { ad_id: id, start_date: s.start_date ?? null, end_date: s.end_date ?? null, timezone: s.timezone ?? "Asia/Kolkata" },
        { onConflict: "ad_id" }
      );
      if (schErr) errors.push(`schedule: ${schErr.message}`);
    }
  }

  // 4. Upsert targeting
  if (targeting !== undefined) {
    if (targeting === null) {
      await supabase.from("ad_targeting").delete().eq("ad_id", id);
    } else {
      const t = targeting as Record<string, unknown>;
      const { error: tgtErr } = await supabase.from("ad_targeting").upsert(
        {
          ad_id: id,
          show_to_logged_in: t.show_to_logged_in ?? true,
          show_to_guests:    t.show_to_guests    ?? true,
          devices:           t.devices           ?? ["desktop","mobile","tablet"],
          countries:         t.countries         ?? null,
          user_type:         t.user_type         ?? "all",
        },
        { onConflict: "ad_id" }
      );
      if (tgtErr) errors.push(`targeting: ${tgtErr.message}`);
    }
  }

  return NextResponse.json({ success: true, errors });
}

// ── DELETE /api/ads/[id] ──────────────────────────────────────────────────────
export async function DELETE(_req: NextRequest, { params }: Params) {
  const { id } = await params;
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { error } = await supabase.from("ads").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ success: true });
}
