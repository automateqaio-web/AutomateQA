import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Megaphone } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Ad } from "@/types";
import AdForm from "@/components/admin/ads/AdForm";

export const metadata: Metadata = { title: "Edit Advertisement" };

type Props = { params: Promise<{ id: string }> };

export default async function EditAdPage({ params }: Props) {
  const { id } = await params;
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("ads")
    .select("*, ad_locations(*), ad_schedules(*), ad_targeting(*)")
    .eq("id", id)
    .single();

  if (error || !data) notFound();

  const ad: Ad = {
    ...data,
    locations: data.ad_locations ?? [],
    schedule:  data.ad_schedules?.[0]  ?? null,
    targeting: data.ad_targeting?.[0]  ?? null,
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Link href="/admin/ads"
          className="p-2 rounded-xl border border-white/10 text-[#9CA3AF] hover:text-white hover:border-white/20 transition-all">
          <ArrowLeft size={16} />
        </Link>
        <div>
          <div className="flex items-center gap-2 mb-0.5">
            <Megaphone size={16} className="text-[#00FF88]" />
            <h1 className="text-xl font-black text-white">Edit: {ad.name}</h1>
          </div>
          <div className="flex items-center gap-3">
            <span className="text-xs px-2 py-0.5 rounded-lg"
              style={{ background: "rgba(255,255,255,0.05)", color: "#9CA3AF" }}>
              {ad.type}
            </span>
            <span className="text-xs" style={{ color: ad.is_active ? "#00FF88" : "#555" }}>
              {ad.is_active ? "● Live" : "● Inactive"}
            </span>
          </div>
        </div>
      </div>

      {/* Form */}
      <div className="rounded-2xl p-6" style={{ background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.06)" }}>
        <AdForm existing={ad} />
      </div>
    </div>
  );
}
