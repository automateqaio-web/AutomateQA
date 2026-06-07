"use client";

import { useEffect } from "react";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

export default function TipViewTracker({ tipId }: { tipId: string }) {
  useEffect(() => {
    supabase.rpc("increment_tip_views", { tip_id_param: tipId }).then(() => {});
  }, [tipId]);

  return null;
}
