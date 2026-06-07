"use client";
import { useEffect } from "react";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

export default function QuestionViewTracker({ questionId }: { questionId: string }) {
  useEffect(() => {
    supabase.rpc("increment_interview_views", { question_id_param: questionId }).then(() => {});
  }, [questionId]);
  return null;
}
