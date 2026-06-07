import { notFound } from "next/navigation";
import type { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Tag, ArrowRight, Clock } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { CATEGORY_COLORS } from "@/types";
import MemeInteractions from "@/components/memes/MemeInteractions";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://automateqa.online";

interface Props {
  params: Promise<{ id: string }>;
}

async function getMeme(id: string) {
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("memes")
      .select("*")
      .eq("id", id)
      .eq("published", true)
      .single();
    return data;
  } catch {
    return null;
  }
}

async function getRelated(category: string, excludeId: string) {
  try {
    const supabase = await createClient();
    // Try same category first
    const { data: sameCat } = await supabase
      .from("memes")
      .select("id, title, caption, image_url, category")
      .eq("published", true)
      .eq("category", category)
      .neq("id", excludeId)
      .limit(4);
    if (sameCat && sameCat.length >= 1) return sameCat;
    // Fall back to any recent memes
    const { data: any } = await supabase
      .from("memes")
      .select("id, title, caption, image_url, category")
      .eq("published", true)
      .neq("id", excludeId)
      .order("created_at", { ascending: false })
      .limit(4);
    return any ?? [];
  } catch {
    return [];
  }
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const meme = await getMeme(id);
  if (!meme) return { title: "Meme Not Found" };
  const canonicalUrl = `${SITE_URL}/memes/${id}`;
  const tags: string[] = Array.isArray(meme.tags) ? meme.tags : [];
  return {
    title: `${meme.title} | AutomateQA Memes`,
    description: meme.caption || meme.title,
    keywords: [...tags, meme.category, "QA meme", "software testing humor", "automation meme", "AutomateQA"],
    alternates: { canonical: canonicalUrl },
    openGraph: {
      type: "article",
      url: canonicalUrl,
      title: meme.title,
      description: meme.caption || meme.title,
      images: meme.image_url
        ? [{ url: meme.image_url, width: 1200, height: 630, alt: meme.title }]
        : [{ url: "/og-image.png", width: 1200, height: 630, alt: "AutomateQA" }],
    },
    twitter: {
      card: "summary_large_image",
      title: meme.title,
      description: meme.caption || meme.title,
      images: meme.image_url ? [meme.image_url] : ["/og-image.png"],
    },
  };
}

export default async function MemePage({ params }: Props) {
  const { id } = await params;
  const meme = await getMeme(id);
  if (!meme) notFound();

  const related = await getRelated(meme.category, meme.id);
  const nextMeme = related[0] ?? null;
  const moreMemes = related.slice(1);
  const tags: string[] = Array.isArray(meme.tags) ? meme.tags : [];

  return (
    <div className="min-h-screen pt-20 pb-20 bg-[#0B0B0B]">
      <div className="max-w-2xl mx-auto px-4 sm:px-6">

        {/* Back button */}
        <div className="mb-8">
          <Link
            href="/memes"
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-white/10 bg-white/[0.04] text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/30 hover:bg-[#00FF88]/5 text-sm font-medium transition-all group"
          >
            <ArrowLeft size={14} className="group-hover:-translate-x-0.5 transition-transform" />
            Back to Memes
          </Link>
        </div>

        {/* ── Main meme card ── */}
        <div className="rounded-2xl border border-white/8 bg-[#0E0E0E] overflow-hidden shadow-[0_8px_48px_rgba(0,0,0,0.6)] mb-8">

          {/* Image */}
          {meme.image_url && (
            <div className="relative w-full bg-[#080808]">
              <img
                src={meme.image_url}
                alt={meme.title}
                className="w-full object-contain max-h-[600px]"
              />
            </div>
          )}

          {/* Content */}
          <div className="p-6 sm:p-8">
            {/* Category badge */}
            <div className="mb-4">
              <span className={`category-badge border ${CATEGORY_COLORS[meme.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {meme.category}
              </span>
            </div>

            {/* Title */}
            <h1 className="text-2xl sm:text-3xl font-black text-white leading-tight mb-3 tracking-tight">
              {meme.title}
            </h1>

            {/* Caption */}
            {meme.caption && (
              <p className="text-[#6B7280] leading-relaxed text-base mb-6">
                {meme.caption}
              </p>
            )}

            {/* Tags */}
            {tags.length > 0 && (
              <div className="flex flex-wrap items-center gap-2 mb-8">
                <Tag size={13} className="text-[#4B5563]" />
                {tags.map((tag: string) => (
                  <span
                    key={tag}
                    className="px-3 py-1 text-xs rounded-lg border border-white/8 bg-white/[0.03] text-[#9CA3AF] font-medium"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}

            {/* Likes + share + comments */}
            <MemeInteractions
              memeId={meme.id}
              initialLikes={meme.likes_count || 0}
              title={meme.title}
            />

            {/* ── Next Meme (inside card, below comments) ── */}
            {nextMeme && (
              <div className="mt-8 pt-8 border-t border-white/[0.07]">
                <div className="flex items-center gap-3 mb-4">
                  <span className="text-[10px] text-[#4B5563] font-bold uppercase tracking-widest">Up Next</span>
                  <div className="flex-1 h-px bg-white/[0.06]" />
                </div>
                <Link href={`/memes/${nextMeme.id}`} className="group block">
                  <div className="flex gap-4 rounded-xl border border-white/8 bg-white/[0.02] overflow-hidden hover:border-[#00FF88]/25 hover:bg-[#00FF88]/[0.03] hover:shadow-[0_0_24px_rgba(0,255,136,0.06)] transition-all duration-300">
                    {nextMeme.image_url && (
                      <div className="w-28 sm:w-36 flex-shrink-0 overflow-hidden">
                        <img
                          src={nextMeme.image_url}
                          alt={nextMeme.title}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                          style={{ minHeight: "110px" }}
                        />
                      </div>
                    )}
                    <div className="flex-1 py-4 pr-4 flex flex-col justify-between min-w-0">
                      <div>
                        <span className={`category-badge border mb-2 inline-flex text-[10px] ${CATEGORY_COLORS[nextMeme.category] || ""}`}>
                          {nextMeme.category}
                        </span>
                        <h3 className="font-black text-white text-sm leading-snug group-hover:text-[#00FF88] transition-colors line-clamp-2 mb-1">
                          {nextMeme.title}
                        </h3>
                        {nextMeme.caption && (
                          <p className="text-[#4B5563] text-xs line-clamp-2 leading-relaxed">{nextMeme.caption}</p>
                        )}
                      </div>
                      <span className="flex items-center gap-1 text-xs text-[#00FF88]/50 group-hover:text-[#00FF88] transition-colors mt-2 font-semibold">
                        View meme <ArrowRight size={11} />
                      </span>
                    </div>
                  </div>
                </Link>
              </div>
            )}

            {/* ── More memes grid ── */}
            {moreMemes.length > 0 && (
              <div className="mt-8 pt-8 border-t border-white/[0.07]">
                <div className="flex items-center justify-between mb-4">
                  <span className="text-[10px] text-[#4B5563] font-bold uppercase tracking-widest">More Memes</span>
                  <Link href="/memes" className="text-xs text-[#6B7280] hover:text-[#00FF88] transition-colors flex items-center gap-1">
                    View all <ArrowRight size={11} />
                  </Link>
                </div>
                <div className="grid grid-cols-3 gap-3">
                  {moreMemes.map((r) => (
                    <Link key={r.id} href={`/memes/${r.id}`} className="group block">
                      <div className="rounded-xl border border-white/8 bg-[#0E0E0E] overflow-hidden hover:border-[#00FF88]/20 hover:shadow-[0_0_16px_rgba(0,255,136,0.05)] transition-all duration-300">
                        {r.image_url && (
                          <div className="aspect-square overflow-hidden">
                            <img
                              src={r.image_url}
                              alt={r.title}
                              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                            />
                          </div>
                        )}
                        <div className="p-2.5">
                          <p className="text-xs text-[#9CA3AF] line-clamp-2 leading-snug group-hover:text-white transition-colors">
                            {r.title}
                          </p>
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  );
}
