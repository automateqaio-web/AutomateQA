import type { Metadata } from "next";
import { BookOpen } from "lucide-react";
import BlogListing from "@/components/blog/BlogListing";
import ComingSoon from "@/components/shared/ComingSoon";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "QA Articles — Automation Testing Tutorials, Guides & Career Tips | AutomateQA",
  description: "In-depth QA automation articles — Playwright tutorials, Selenium guides, Rest Assured API testing, QA career advice, SDET interview preparation, and real-world automation engineering insights.",
  keywords: [
    "QA automation articles",
    "automation testing tutorials 2025",
    "Playwright tutorial for beginners",
    "Selenium WebDriver guide",
    "Rest Assured API testing tutorial",
    "QA career tips for engineers",
    "SDET career guide",
    "software testing articles",
    "test automation guides",
    "QA engineer blog",
    "automation framework tutorials",
    "CI/CD for testers",
  ],
  alternates: { canonical: "https://automateqa.online/blog" },
  robots: { index: true, follow: true, googleBot: { index: true, follow: true, "max-snippet": -1 } },
  openGraph: {
    type: "website",
    url: "https://automateqa.online/blog",
    title: "QA Articles — Automation Testing Tutorials & Career Tips | AutomateQA",
    description: "In-depth QA automation articles — Playwright, Selenium, API testing, SDET career tips, and real automation engineering insights.",
    images: [{ url: "/og-image.png", width: 1200, height: 630, alt: "QA Articles — AutomateQA" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "QA Articles — Automation Testing Tutorials & Career Tips | AutomateQA",
    description: "In-depth QA automation articles — Playwright, Selenium, API testing, SDET career tips, and real automation engineering insights.",
    images: ["/og-image.png"],
  },
};

async function getPageSettings() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return null;
    const supabase = await createClient();
    const { data } = await supabase
      .from("page_settings")
      .select("*")
      .eq("key", "blog")
      .single();
    return data;
  } catch {
    return null;
  }
}

async function getInitialBlogs() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) return [];
    const supabase = await createClient();
    const { data } = await supabase
      .from("blogs")
      .select("*")
      .eq("published", true)
      .order("created_at", { ascending: false })
      .limit(12);
    return data || [];
  } catch {
    return [];
  }
}

export default async function BlogPage() {
  const [settings, initialBlogs] = await Promise.all([getPageSettings(), getInitialBlogs()]);

  if (settings?.coming_soon) {
    return (
      <ComingSoon
        title={settings.coming_soon_title}
        message={settings.coming_soon_message}
        pageLabel="the Blog"
      />
    );
  }
  const SITE = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";
  const schema = {
    "@context": "https://schema.org",
    "@type": "Blog",
    name: "QA Articles — AutomateQA",
    description: "In-depth QA automation articles, tutorials, and career guides for software testers and SDET engineers.",
    url: `${SITE}/blog`,
    publisher: { "@type": "Organization", name: "AutomateQA", url: SITE, logo: { "@type": "ImageObject", url: `${SITE}/logo.png` } },
    blogPost: initialBlogs.slice(0, 10).map((b: { title: string; slug: string; excerpt?: string; created_at: string }) => ({
      "@type": "BlogPosting",
      headline: b.title,
      description: b.excerpt || "",
      url: `${SITE}/blog/${b.slug}`,
      datePublished: b.created_at,
      author: { "@type": "Person", name: "AutomateQA" },
    })),
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }} />
    <div className="min-h-screen pt-16">
      <div className="relative overflow-hidden py-16 sm:py-20">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,rgba(0,100,255,0.05)_0%,transparent_60%)]" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-blue-500/10 border border-blue-500/20 flex items-center justify-center">
              <BookOpen size={20} className="text-blue-400" />
            </div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold">
              QA ARTICLES
            </div>
          </div>
          <h1 className="text-4xl sm:text-5xl font-black text-white mb-4">
            QA <span className="text-gradient">Articles</span> & Guides
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-xl">
            Deep-dive tutorials, career advice, and real automation engineering guides — Playwright, Selenium, API testing, CI/CD and more.
          </p>
        </div>
      </div>
      <BlogListing initialBlogs={initialBlogs} />
    </div>
    </>
  );
}
