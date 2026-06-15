import type { Metadata } from "next";
import { Lightbulb, Zap, Code2, Shield } from "lucide-react";
import TipsListing from "@/components/tips/TipsListing";
import ComingSoon from "@/components/shared/ComingSoon";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "QA Automation Tips & Tricks 2025 — Selenium, Playwright, CI/CD, API Testing | AutomateQA",
  description: "Practical QA automation tips and tricks for engineers — Selenium WebDriver, Playwright, Rest Assured API testing, Jenkins CI/CD pipelines, GitHub Actions, and debugging. Real solutions from real projects.",
  keywords: [
    "QA automation tips 2025",
    "Selenium WebDriver tips and tricks",
    "Playwright automation tips",
    "Rest Assured API testing tips",
    "Jenkins CI/CD automation tips",
    "GitHub Actions QA tips",
    "test automation best practices",
    "QA engineer tips",
    "automation testing tricks",
    "software testing tips",
    "Cypress tips and tricks",
    "Java automation tips",
  ],
  alternates: { canonical: "https://automateqa.online/automation-tips" },
  robots: { index: true, follow: true, googleBot: { index: true, follow: true, "max-snippet": -1 } },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/automation-tips",
    title: "QA Automation Tips & Tricks 2025 — Selenium, Playwright, CI/CD | AutomateQA",
    description: "Practical QA automation tips for engineers — Selenium, Playwright, API testing, Jenkins, CI/CD, and debugging patterns from real projects.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "QA Automation Tips & Tricks — AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "QA Automation Tips & Tricks 2025 — Selenium, Playwright, CI/CD | AutomateQA",
    description: "Practical QA automation tips for engineers — Selenium, Playwright, API testing, Jenkins, CI/CD, and debugging patterns from real projects.",
    images: ["/og-image.png"],
  },
};

const highlights = [
  { icon: Zap, label: "Quick Wins", desc: "Bite-sized tips you can apply today", color: "text-yellow-400 bg-yellow-500/10 border-yellow-500/20" },
  { icon: Code2, label: "Code Snippets", desc: "Copy-paste ready code examples", color: "text-[#00FF88] bg-[#00FF88]/10 border-[#00FF88]/20" },
  { icon: Shield, label: "Battle-Tested", desc: "Tips from real production experience", color: "text-blue-400 bg-blue-500/10 border-blue-500/20" },
  { icon: Lightbulb, label: "12+ Categories", desc: "Covering all major QA tools", color: "text-purple-400 bg-purple-500/10 border-purple-500/20" },
];

async function getPageSettings() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return null;
    const supabase = await createClient();
    const { data } = await supabase
      .from("page_settings")
      .select("*")
      .eq("key", "tips")
      .single();
    return data;
  } catch {
    return null;
  }
}

async function getInitialTips() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return [];
    const supabase = await createClient();
    const { data } = await supabase
      .from("automation_tips")
      .select("*")
      .eq("published", true)
      .order("featured", { ascending: false })
      .order("created_at", { ascending: false })
      .limit(12);
    return data || [];
  } catch {
    return [];
  }
}

export default async function AutomationTipsPage() {
  const [settings, initialItems] = await Promise.all([getPageSettings(), getInitialTips()]);

  if (settings?.coming_soon) {
    return (
      <ComingSoon
        title={settings.coming_soon_title}
        message={settings.coming_soon_message}
        pageLabel="Automation Tips"
      />
    );
  }

  const SITE = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";
  const schema = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    name: "QA Automation Tips & Tricks",
    description: "Practical QA automation tips for Selenium, Playwright, API testing, CI/CD and more.",
    url: `${SITE}/automation-tips`,
    publisher: { "@type": "Organization", name: "AutomateQA", url: SITE, logo: { "@type": "ImageObject", url: `${SITE}/logo.png` } },
    mainEntity: {
      "@type": "ItemList",
      numberOfItems: initialItems.length,
      itemListElement: initialItems.slice(0, 10).map((t: { title: string; slug: string; excerpt?: string }, i: number) => ({
        "@type": "ListItem",
        position: i + 1,
        item: { "@type": "TechArticle", name: t.title, description: t.excerpt || "", url: `${SITE}/automation-tips/${t.slug}` },
      })),
    },
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }} />
    <div className="min-h-screen pt-20">
      {/* Hero */}
      <div className="relative overflow-hidden border-b border-white/5">
        <div className="absolute inset-0 bg-gradient-to-br from-yellow-500/5 via-transparent to-[#00FF88]/5" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 relative">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 text-xs font-semibold mb-5">
            <Lightbulb size={10} />
            TIPS & TRICKS
          </div>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-white mb-4 leading-tight">
            Automation <span className="text-gradient">Tips & Tricks</span>
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-2xl mb-10">
            Short, actionable tips for QA automation engineers. From Selenium quirks to CI/CD pipelines — real solutions for real problems.
          </p>

          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 max-w-3xl">
            {highlights.map(({ icon: Icon, label, desc, color }) => (
              <div key={label} className={`glass-card p-4 border ${color.split(" ")[2]}`}>
                <div className={`w-8 h-8 rounded-lg border flex items-center justify-center mb-2 ${color}`}>
                  <Icon size={16} />
                </div>
                <div className="text-sm font-bold text-white">{label}</div>
                <div className="text-[10px] text-[#9CA3AF] mt-0.5 leading-relaxed">{desc}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <TipsListing initialItems={initialItems} />
    </div>
    </>
  );
}
