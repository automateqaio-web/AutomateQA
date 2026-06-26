import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type Params = { params: Promise<{ id: string }> };

// ── PATCH  /api/admin/jobs/[id]/toggle  — flip is_active ─────────────────────
export async function PATCH(_request: NextRequest, { params }: Params) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  // Fetch current value first
  const { data: existing, error: fetchError } = await supabase
    .from("jobs")
    .select("is_active")
    .eq("id", id)
    .single();

  if (fetchError || !existing) {
    return NextResponse.json({ error: "Job not found" }, { status: 404 });
  }

  const { data, error } = await supabase
    .from("jobs")
    .update({
      is_active: !existing.is_active,
      updated_at: new Date().toISOString(),
    })
    .eq("id", id)
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ data });
}
