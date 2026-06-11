"use client";
import { useEffect, useRef } from "react";

interface Props {
  section: string;
  contentId?: string;
}

export default function PageViewTracker({ section, contentId }: Props) {
  const fired = useRef(false);
  useEffect(() => {
    if (fired.current) return;
    fired.current = true;
    fetch("/api/track", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ section, content_id: contentId }),
    }).catch(() => {});
  }, [section, contentId]);
  return null;
}
