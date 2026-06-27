import type { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Megaphone } from "lucide-react";
import AdForm from "@/components/admin/ads/AdForm";

export const metadata: Metadata = { title: "New Advertisement" };

export default function NewAdPage() {
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
            <h1 className="text-xl font-black text-white">Create Advertisement</h1>
          </div>
          <p className="text-sm text-[#6B7280]">Fill in the details, choose locations, and go live instantly</p>
        </div>
      </div>

      {/* Form */}
      <div className="rounded-2xl p-6" style={{ background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.06)" }}>
        <AdForm />
      </div>
    </div>
  );
}
