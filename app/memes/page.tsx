import type { Metadata } from "next";
import { Laugh } from "lucide-react";
import MemeFeed from "@/components/memes/MemeFeed";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "QA Memes — Laugh Through the Pain",
  description: "Browse hundreds of QA memes covering Playwright, Selenium, Agile, Jira, production bugs, and corporate madness.",
  keywords: ["QA memes", "software testing memes", "Playwright memes", "Selenium humor", "Agile memes", "developer memes", "automation testing humor", "QA engineer"],
  alternates: { canonical: "https://automateqa.online/memes" },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/memes",
    title: "QA Memes — Laugh Through the Pain | AutomateQA",
    description: "Browse hundreds of QA memes covering Playwright, Selenium, Agile, Jira, production bugs, and corporate madness.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "QA Memes — AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "QA Memes — Laugh Through the Pain | AutomateQA",
    description: "Browse hundreds of QA memes covering Playwright, Selenium, Agile, Jira, production bugs, and corporate madness.",
    images: ["/og-image.png"],
  },
};

async function getInitialMemes() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return [];
    const supabase = await createClient();
    const { data } = await supabase
      .from("memes")
      .select("*")
      .eq("published", true)
      .order("created_at", { ascending: false })
      .limit(12);
    return data || [];
  } catch {
    return [];
  }
}

export default async function MemesPage() {
  const initialMemes = await getInitialMemes();
  return (
    <div className="min-h-screen pt-16">
      {/* Page header */}
      <div className="relative overflow-hidden py-16 sm:py-20">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,rgba(0,255,136,0.06)_0%,transparent_60%)]" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
              <Laugh size={20} className="text-[#00FF88]" />
            </div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold">
              QA MEME VAULT
            </div>
          </div>
          <h1 className="text-4xl sm:text-5xl font-black text-white mb-4">
            Laugh Through the{" "}
            <span className="text-gradient">QA Pain</span>
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-xl">
            Memes for testers, by testers. When the bug ticket says &quot;works as expected&quot; but nothing works.
          </p>
        </div>
      </div>

      <MemeFeed initialMemes={initialMemes} />
    </div>
  );
}
