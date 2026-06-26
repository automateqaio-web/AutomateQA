import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 10;

const DEFAULT_NAV = [
  { key: "home",    label: "Home",          href: "/",               enabled: true, sort_order: 1 },
  { key: "memes",   label: "Memes",         href: "/memes",          enabled: true, sort_order: 2 },
  { key: "videos",  label: "Videos",        href: "/videos",         enabled: true, sort_order: 3 },
  { key: "learn",   label: "Learn",         href: "/learn",          enabled: true, sort_order: 4 },
  { key: "tips",    label: "Tips & Tricks", href: "/automation-tips",enabled: true, sort_order: 5 },
  { key: "blog",    label: "Blog",          href: "/blog",           enabled: true, sort_order: 6 },
  { key: "youtube", label: "YouTube",       href: "/creator-stats",  enabled: true, sort_order: 7 },
  { key: "jobs",    label: "Jobs",          href: "/jobs",           enabled: true, sort_order: 9 },
  { key: "about",   label: "About",         href: "/about",          enabled: true, sort_order: 10 },
];

const DEFAULT_PAGES = [
  { key: "learn",  coming_soon: false, coming_soon_title: "Tutorials Coming Soon",  coming_soon_message: "We are crafting hands-on QA automation tutorials. Stay tuned!" },
  { key: "tips",   coming_soon: false, coming_soon_title: "Tips Coming Soon",        coming_soon_message: "Automation tips and tricks are on their way. Check back soon!" },
  { key: "blog",   coming_soon: false, coming_soon_title: "Blog Coming Soon",        coming_soon_message: "Our QA blog is coming soon with in-depth articles and guides." },
  { key: "memes",  coming_soon: false, coming_soon_title: "Memes Coming Soon",       coming_soon_message: "The meme vault is being filled. Come back for some laughs!" },
  { key: "videos", coming_soon: false, coming_soon_title: "Videos Coming Soon",      coming_soon_message: "Video content is on its way. Subscribe to our YouTube channel!" },
];

const CACHE_HEADERS = {
  "Cache-Control": "public, s-maxage=10, stale-while-revalidate=20",
};

export async function GET() {
  try {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    if (!supabaseUrl || supabaseUrl.includes("placeholder")) {
      return NextResponse.json({ nav: DEFAULT_NAV, pages: DEFAULT_PAGES }, { headers: CACHE_HEADERS });
    }

    const supabase = await createClient();
    const [navRes, pagesRes] = await Promise.all([
      supabase.from("nav_settings").select("*").order("sort_order"),
      supabase.from("page_settings").select("*"),
    ]);

    return NextResponse.json(
      {
        nav: navRes.data?.length ? navRes.data : DEFAULT_NAV,
        pages: pagesRes.data?.length ? pagesRes.data : DEFAULT_PAGES,
      },
      { headers: CACHE_HEADERS }
    );
  } catch {
    return NextResponse.json({ nav: DEFAULT_NAV, pages: DEFAULT_PAGES }, { headers: CACHE_HEADERS });
  }
}
