import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type Params = { params: Promise<{ id: string }> };

// ── PATCH  /api/admin/jobs/[id]  — update a job ───────────────────────────────
export async function PATCH(request: NextRequest, { params }: Params) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const {
    title, company, location, description,
    apply_url, job_type, is_remote,
    experience_level, salary, posted_at,
    referral_contact, referral_note, is_active,
  } = body as Record<string, string | boolean | null | undefined>;

  if (!title || !company || !location || !description) {
    return NextResponse.json({ error: "title, company, location, and description are required" }, { status: 400 });
  }

  const source = job_type === "referral" ? "referral" : "manual";

  const { data, error } = await supabase
    .from("jobs")
    .update({
      title,
      company,
      location,
      description,
      apply_url: apply_url || null,
      source,
      job_type: job_type || "regular",
      is_remote: Boolean(is_remote),
      experience_level: experience_level || null,
      salary: salary || null,
      posted_at: posted_at || null,
      referral_contact: referral_contact || null,
      referral_note: referral_note || null,
      is_active: is_active !== undefined ? Boolean(is_active) : true,
      updated_at: new Date().toISOString(),
    })
    .eq("id", id)
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  if (!data) return NextResponse.json({ error: "Job not found" }, { status: 404 });
  return NextResponse.json({ data });
}

// ── DELETE  /api/admin/jobs/[id]  — permanently delete a job ──────────────────
export async function DELETE(_request: NextRequest, { params }: Params) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  const { error } = await supabase
    .from("jobs")
    .delete()
    .eq("id", id);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ success: true });
}
