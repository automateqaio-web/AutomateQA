import type { Metadata } from "next";
import { BookOpen, GraduationCap, Zap, Users, ArrowRight } from "lucide-react";
import Link from "next/link";
import LearnListing from "@/components/learn/LearnListing";
import LearnWaitlist from "@/components/learn/LearnWaitlist";
import AdRenderer from "@/components/ads/AdRenderer";
import { createClient } from "@/lib/supabase/server";


export const revalidate = 60;

export const metadata: Metadata = {
  title: "Learn QA Automation | AutomateQA",
  description: "Free automation testing tutorials covering Playwright, Selenium, Cypress, API Testing, CI/CD, and more.",
  keywords: ["learn QA automation", "Playwright tutorial free", "Selenium course", "Cypress tutorial", "API testing course", "CI/CD for testers", "automation testing for beginners", "QA engineer training"],
  alternates: { canonical: "https://automateqa.online/learn" },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/learn",
    title: "Learn QA Automation — Free Tutorials | AutomateQA",
    description: "Free automation testing tutorials covering Playwright, Selenium, Cypress, API Testing, CI/CD, and more.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "Learn QA Automation — AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Learn QA Automation — Free Tutorials | AutomateQA",
    description: "Free automation testing tutorials covering Playwright, Selenium, Cypress, API Testing, CI/CD, and more.",
    images: ["/og-image.png"],
  },
};

const stats = [
  { icon: BookOpen, label: "Tutorials", value: "50+", color: "text-[#00FF88]" },
  { icon: GraduationCap, label: "Technologies", value: "15+", color: "text-purple-400" },
  { icon: Zap, label: "Beginner Friendly", value: "100%", color: "text-yellow-400" },
  { icon: Users, label: "Community", value: "Free", color: "text-blue-400" },
];

async function getPageSettings() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return null;
    const supabase = await createClient();
    const { data } = await supabase
      .from("page_settings")
      .select("*")
      .eq("key", "learn")
      .single();
    return data;
  } catch {
    return null;
  }
}

export default async function LearnPage() {
  const settings = await getPageSettings();

  if (settings?.coming_soon) {
    return <LearnWaitlist />;
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="relative overflow-hidden border-b border-white/5">
        <div className="absolute inset-0 bg-gradient-to-br from-[#00FF88]/5 via-transparent to-purple-500/5" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 relative">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold mb-5">
            <BookOpen size={10} />
            LEARNING HUB
          </div>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-white mb-4 leading-tight">
            Master QA <span className="text-gradient">Automation</span>
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-2xl mb-10">
            Hands-on tutorials for Playwright, Selenium, Cypress, API Testing, CI/CD and more — written by engineers who&apos;ve shipped real tests in production.
          </p>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 max-w-2xl">
            {stats.map(({ icon: Icon, label, value, color }) => (
              <div key={label} className="glass-card p-4 text-center">
                <Icon size={20} className={`${color} mx-auto mb-2`} />
                <div className={`text-2xl font-black ${color}`}>{value}</div>
                <div className="text-xs text-[#9CA3AF] mt-0.5">{label}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
      {/* ── Playwright Course spotlight ─────────────────────────────── */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-8">
        <p className="text-xs font-bold text-[#9CA3AF] uppercase tracking-widest mb-4 flex items-center gap-2">
          <Zap size={12} className="text-[#00FF88]" /> Featured Course
        </p>
        <Link
          href="/course/playwright/what-is-software-testing"
          className="group flex flex-col sm:flex-row items-start sm:items-center gap-5 p-5 rounded-2xl border border-[#00FF88]/20 bg-[#00FF88]/5 hover:bg-[#00FF88]/10 hover:border-[#00FF88]/40 transition-all mb-2"
        >
          <div className="w-12 h-12 rounded-xl bg-[#00FF88]/15 border border-[#00FF88]/30 flex items-center justify-center flex-shrink-0 text-2xl">
            🎭
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2 mb-1">
              <span className="text-base font-black text-white group-hover:text-[#00FF88] transition-colors">
                Zero to Automation Hero — Playwright Course
              </span>
              <span className="text-[10px] font-bold text-[#00FF88] border border-[#00FF88]/30 rounded px-1.5 py-0.5">FREE</span>
              <span className="text-[10px] font-bold text-yellow-400">★ NEW</span>
            </div>
            <p className="text-sm text-[#9CA3AF]">
              24 lessons · No coding background needed · From zero to your first working automation
            </p>
          </div>
          <div className="flex items-center gap-2 text-sm font-semibold text-[#00FF88] flex-shrink-0">
            Start learning <ArrowRight size={15} className="group-hover:translate-x-1 transition-transform" />
          </div>
        </Link>
      </div>

      <AdRenderer location="learn_listing" className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-4" />
      <LearnListing />
    </div>
  );
}
