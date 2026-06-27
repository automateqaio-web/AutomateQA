"use client";

import { useEffect, useState, useRef } from "react";
import { Ad } from "@/types";
import { getDeviceType } from "./adUtils";
import PremiumBanner    from "./banners/PremiumBanner";
import GlassmorphismCard from "./banners/GlassmorphismCard";
import FloatingBanner   from "./banners/FloatingBanner";
import HeroBanner       from "./banners/HeroBanner";
import SidebarCard      from "./banners/SidebarCard";
import StickyBanner     from "./banners/StickyBanner";
import InlineBanner     from "./banners/InlineBanner";
import PopupBanner      from "./banners/PopupBanner";
import ToastBanner      from "./banners/ToastBanner";
import RibbonBanner     from "./banners/RibbonBanner";
import SmallCard        from "./banners/SmallCard";
import FullWidthBanner  from "./banners/FullWidthBanner";

// ── Short dedup cache — prevents double-fetch in React StrictMode ─────────────
const cache = new Map<string, { data: Ad[]; ts: number }>();
const CACHE_TTL = 3_000; // 3 seconds only — admin edits reflect quickly

async function fetchAds(location: string): Promise<Ad[]> {
  const hit = cache.get(location);
  if (hit && Date.now() - hit.ts < CACHE_TTL) return hit.data;
  try {
    const res = await fetch(`/api/ads/location/${encodeURIComponent(location)}`, {
      cache: "no-store", // always fetch fresh — no browser HTTP cache
    });
    const { data } = await res.json();
    const ads = (data as Ad[]) || [];
    cache.set(location, { data: ads, ts: Date.now() });
    return ads;
  } catch {
    return [];
  }
}

// ── Banner switch ─────────────────────────────────────────────────────────────
function BannerSwitch({ ad, location, isPreview }: { ad: Ad; location: string; isPreview?: boolean }) {
  const trackedRef = useRef(false);
  const device = getDeviceType();

  useEffect(() => {
    if (trackedRef.current) return;
    trackedRef.current = true;
    fetch("/api/ads/impression", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ad_id: ad.id, location, device }),
    }).catch(() => {});
  }, [ad.id, location, device]);

  const handleCtaClick = () => {
    fetch("/api/ads/click", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ad_id: ad.id, location, device }),
    }).catch(() => {});
  };

  const props = { ad, onCtaClick: handleCtaClick, isPreview };

  switch (ad.display_style) {
    case "premium_banner":     return <PremiumBanner     {...props} />;
    case "glassmorphism_card": return <GlassmorphismCard {...props} />;
    case "floating_banner":    return <FloatingBanner    {...props} />;
    case "hero_banner":        return <HeroBanner        {...props} />;
    case "sidebar_card":       return <SidebarCard       {...props} />;
    case "bottom_sticky":      return <StickyBanner      {...props} />;
    case "inline_banner":      return <InlineBanner      {...props} />;
    case "popup":              return <PopupBanner        {...props} />;
    case "toast":              return <ToastBanner        {...props} />;
    case "ribbon":             return <RibbonBanner       {...props} />;
    case "small_card":         return <SmallCard          {...props} />;
    case "full_width_banner":  return <FullWidthBanner    {...props} />;
    default:                   return <PremiumBanner      {...props} />;
  }
}

// ── Main export — drop this anywhere on any page ──────────────────────────────
interface Props {
  location: string;
  className?: string;
  maxAds?: number;
}

export default function AdRenderer({ location, className, maxAds = 3 }: Props) {
  const [ads, setAds]     = useState<Ad[]>([]);
  const [ready, setReady] = useState(false);

  useEffect(() => {
    let mounted = true;
    fetchAds(location).then(data => {
      if (!mounted) return;
      // Filter by device targeting
      const device = getDeviceType();
      const filtered = data.filter(ad => {
        if (!ad.targeting) return true;
        return ad.targeting.devices.includes(device);
      });
      setAds(filtered.slice(0, maxAds));
      setReady(true);
    });
    return () => { mounted = false; };
  }, [location, maxAds]);

  if (!ready || ads.length === 0) return null;

  // These styles need to fill the viewport width — don't constrain them with the
  // page's max-w / padding wrapper. Fixed-position ones (sticky/floating/popup/toast)
  // don't care about the wrapper but we skip it anyway for cleanliness.
  const FULL_BLEED = new Set([
    "full_width_banner", "hero_banner",
    "bottom_sticky", "floating_banner", "popup", "toast", "ribbon",
  ]);

  return (
    <>
      {ads.map(ad => (
        <div key={ad.id} className={FULL_BLEED.has(ad.display_style) ? undefined : className}>
          <BannerSwitch ad={ad} location={location} />
        </div>
      ))}
    </>
  );
}
