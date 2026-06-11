"use client";
import { useEffect, useRef } from "react";
import { usePathname } from "next/navigation";

function sectionFromPath(path: string): string {
  if (path === "/")                        return "home";
  if (path.startsWith("/interview-prep"))  return "interview-prep";
  if (path.startsWith("/videos"))          return "videos";
  if (path.startsWith("/learn"))           return "learn";
  if (path.startsWith("/blog"))            return "blog";
  if (path.startsWith("/automation-tips")) return "automation-tips";
  if (path.startsWith("/memes"))           return "memes";
  if (path.startsWith("/about"))           return "about";
  if (path.startsWith("/admin"))           return null as any; // don't track admin
  return "other";
}

export default function SiteViewTracker() {
  const pathname = usePathname();
  const lastTracked = useRef<string>("");

  useEffect(() => {
    if (pathname === lastTracked.current) return;
    lastTracked.current = pathname;

    const section = sectionFromPath(pathname);
    if (!section) return; // skip admin pages

    fetch("/api/track", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ section, content_id: pathname }),
    }).catch(() => {});
  }, [pathname]);

  return null;
}
