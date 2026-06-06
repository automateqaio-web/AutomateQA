import { notFound } from "next/navigation";
import type { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Tag } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { CATEGORY_COLORS } from "@/types";
import ShareButton from "./ShareButton";

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
    const { data } = await supabase
      .from("memes")
      .select("id, title, caption, image_url, category")
      .eq("published", true)
      .eq("category", category)
      .neq("id", excludeId)
      .limit(3);
    return data ?? [];
  } catch {
    return [];
  }
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const meme = await getMeme(id);
  if (!meme) return { title: "Meme Not Found" };
  return {
    title: `${meme.title} | AutomateQA Memes`,
    description: meme.caption || meme.title,
    openGraph: {
      title: meme.title,
      description: meme.caption || "",
      images: meme.image_url ? [{ url: meme.image_url }] : [],
    },
  };
}

export default async function MemePage({ params }: Props) {
  const { id } = await params;
  const meme = await getMeme(id);

  if (!meme) notFound();

  const related = await getRelated(meme.category, meme.id);

  return (
    <div className="min-h-screen pt-24 pb-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Back */}
        <Link
          href="/memes"
          className="inline-flex items-center gap-2 text-sm text-[#9CA3AF] hover:text-[#00FF88] transition-colors mb-8 group"
        >
          <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
          Back to Memes
        </Link>

        {/* Card */}
        <div className="glass-card overflow-hidden mb-8">
          {/* Image */}
          {meme.image_url && (
            <div className="relative w-full aspect-[4/3] overflow-hidden bg-[#111]">
              <img
                src={meme.image_url}
                alt={meme.title}
                className="w-full h-full object-contain"
              />
            </div>
          )}

          {/* Details */}
          <div className="p-6 sm:p-8">
            {/* Category + share */}
            <div className="flex items-center justify-between mb-4">
              <span className={`category-badge border text-sm ${CATEGORY_COLORS[meme.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {meme.category}
              </span>
              <ShareButton id={meme.id} title={meme.title} caption={meme.caption} />
            </div>

            <h1 className="text-2xl sm:text-3xl font-black text-white mb-3 leading-tight">
              {meme.title}
            </h1>

            {meme.caption && (
              <p className="text-[#D1D5DB] leading-relaxed text-base mb-6">
                {meme.caption}
              </p>
            )}

            {/* Tags */}
            {meme.tags?.length > 0 && (
              <div className="flex flex-wrap gap-2 items-center">
                <Tag size={14} className="text-[#9CA3AF]" />
                {meme.tags.map((tag: string) => (
                  <span key={tag} className="tag-chip">{tag}</span>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Related memes */}
        {related.length > 0 && (
          <div>
            <h2 className="text-lg font-bold text-white mb-4">More {meme.category} Memes</h2>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {related.map((r) => (
                <Link key={r.id} href={`/memes/${r.id}`} className="group block">
                  <div className="glass-card overflow-hidden hover:border-[#00FF88]/20 transition-all">
                    {r.image_url && (
                      <div className="aspect-[4/3] overflow-hidden">
                        <img
                          src={r.image_url}
                          alt={r.title}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                      </div>
                    )}
                    <div className="p-3">
                      <p className="text-xs text-[#D1D5DB] line-clamp-2">{r.caption || r.title}</p>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

