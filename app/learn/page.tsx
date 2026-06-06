import type { Metadata } from "next";
import { BookOpen, GraduationCap, Zap, Users } from "lucide-react";
import LearnListing from "@/components/learn/LearnListing";
import ComingSoon from "@/components/shared/ComingSoon";
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
    return (
      <ComingSoon
        title={settings.coming_soon_title}
        message={settings.coming_soon_message}
        pageLabel="the Learning Hub"
      />
    );
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
      <LearnListing />
    </div>
  );
}
