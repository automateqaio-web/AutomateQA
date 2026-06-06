"use client";

import { useEffect } from "react";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

export default function BlogViewTracker({ slug }: { slug: string }) {
  useEffect(() => {
    supabase.rpc("increment_blog_views", { slug_param: slug }).then(() => {});
  }, [slug]);

  return null;
}
