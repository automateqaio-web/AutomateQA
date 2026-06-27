"use client";

import { useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import {
  Save, X, ChevronRight, Upload, Plus, Trash2, Eye,
  Info, Palette, MapPin, Clock, Target, Loader2,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import {
  Ad, AdType, AdDisplayStyle, AdAnimation,
  AD_TYPES, AD_DISPLAY_STYLES, AD_ANIMATIONS,
  AD_LOCATIONS, AD_BADGE_PRESETS,
} from "@/types";

// ── Live preview (renders the actual banner) ──────────────────────────────────
import PremiumBanner    from "@/components/ads/banners/PremiumBanner";
import GlassmorphismCard from "@/components/ads/banners/GlassmorphismCard";
import FloatingBanner   from "@/components/ads/banners/FloatingBanner";
import HeroBanner       from "@/components/ads/banners/HeroBanner";
import SidebarCard      from "@/components/ads/banners/SidebarCard";
import StickyBanner     from "@/components/ads/banners/StickyBanner";
import InlineBanner     from "@/components/ads/banners/InlineBanner";
import PopupBanner      from "@/components/ads/banners/PopupBanner";
import ToastBanner      from "@/components/ads/banners/ToastBanner";
import RibbonBanner     from "@/components/ads/banners/RibbonBanner";
import SmallCard        from "@/components/ads/banners/SmallCard";
import FullWidthBanner  from "@/components/ads/banners/FullWidthBanner";

// ── Constants ─────────────────────────────────────────────────────────────────
const INPUT  = "w-full px-4 py-2.5 rounded-xl bg-[#141414] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 placeholder-[#3A3A3A] transition-all";
const LABEL  = "block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-1.5";
const SELECT = `${INPUT} appearance-none cursor-pointer`;

const TABS = [
  { id: "general",    label: "General",    icon: Info    },
  { id: "appearance", label: "Appearance", icon: Palette },
  { id: "locations",  label: "Locations",  icon: MapPin  },
  { id: "schedule",   label: "Schedule",   icon: Clock   },
  { id: "targeting",  label: "Targeting",  icon: Target  },
] as const;
type TabId = typeof TABS[number]["id"];

const TIMEZONES = [
  "Asia/Kolkata", "UTC", "America/New_York", "America/Los_Angeles",
  "Europe/London", "Europe/Paris", "Asia/Singapore", "Australia/Sydney",
];

const DEVICES = ["desktop", "mobile", "tablet"];

// ── Form state shape ──────────────────────────────────────────────────────────
interface FormState {
  name: string; type: AdType; title: string; subtitle: string;
  description: string; cta_text: string; cta_link: string;
  cta_open: "same_tab" | "new_tab"; badge: string;
  desktop_image_url: string; mobile_image_url: string; logo_url: string;
  bg_color: string; gradient: string; text_color: string; button_color: string;
  display_style: AdDisplayStyle; animation: AdAnimation; priority: number; is_active: boolean;
  // relations
  locations: Array<{ location: string; css_selector: string }>;
  schedule: { start_date: string; end_date: string; timezone: string } | null;
  targeting: {
    show_to_logged_in: boolean; show_to_guests: boolean;
    devices: string[]; user_type: "all" | "new" | "returning";
  };
}

const EMPTY: FormState = {
  name: "", type: "promotion", title: "", subtitle: "", description: "",
  cta_text: "", cta_link: "", cta_open: "new_tab", badge: "",
  desktop_image_url: "", mobile_image_url: "", logo_url: "",
  bg_color: "#0D0D0D", gradient: "", text_color: "#FFFFFF", button_color: "#00FF88",
  display_style: "premium_banner", animation: "fade", priority: 50, is_active: true,
  locations: [],
  schedule: null,
  targeting: { show_to_logged_in: true, show_to_guests: true, devices: ["desktop","mobile","tablet"], user_type: "all" },
};

function adToForm(ad: Ad): FormState {
  return {
    name:               ad.name,
    type:               ad.type,
    title:              ad.title,
    subtitle:           ad.subtitle           ?? "",
    description:        ad.description        ?? "",
    cta_text:           ad.cta_text           ?? "",
    cta_link:           ad.cta_link           ?? "",
    cta_open:           ad.cta_open,
    badge:              ad.badge              ?? "",
    desktop_image_url:  ad.desktop_image_url  ?? "",
    mobile_image_url:   ad.mobile_image_url   ?? "",
    logo_url:           ad.logo_url           ?? "",
    bg_color:           ad.bg_color           ?? "#0D0D0D",
    gradient:           ad.gradient           ?? "",
    text_color:         ad.text_color         ?? "#FFFFFF",
    button_color:       ad.button_color       ?? "#00FF88",
    display_style:      ad.display_style,
    animation:          ad.animation,
    priority:           ad.priority,
    is_active:          ad.is_active,
    locations: (ad.locations ?? []).map(l => ({ location: l.location, css_selector: l.css_selector ?? "" })),
    schedule: ad.schedule
      ? { start_date: ad.schedule.start_date ?? "", end_date: ad.schedule.end_date ?? "", timezone: ad.schedule.timezone }
      : null,
    targeting: ad.targeting
      ? { show_to_logged_in: ad.targeting.show_to_logged_in, show_to_guests: ad.targeting.show_to_guests, devices: ad.targeting.devices, user_type: ad.targeting.user_type }
      : EMPTY.targeting,
  };
}

// ── Image upload helper ───────────────────────────────────────────────────────
function useImageUpload() {
  const [uploading, setUploading] = useState(false);
  const supabase = createClient();

  const upload = useCallback(async (file: File): Promise<string | null> => {
    setUploading(true);
    try {
      const ext  = file.name.split(".").pop();
      const path = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
      const { data, error } = await supabase.storage.from("ads").upload(path, file, { cacheControl: "31536000", upsert: false });
      if (error) { alert(`Upload failed: ${error.message}`); return null; }
      return supabase.storage.from("ads").getPublicUrl(data.path).data.publicUrl;
    } finally {
      setUploading(false);
    }
  }, [supabase]);

  return { upload, uploading };
}

// ── Preview renderer ──────────────────────────────────────────────────────────
function LivePreview({ form }: { form: FormState }) {
  const previewAd: Ad = {
    id: "preview", name: form.name, type: form.type,
    title:            form.title            || "Your Ad Title",
    subtitle:         form.subtitle         || null,
    description:      form.description      || null,
    cta_text:         form.cta_text         || null,
    cta_link:         form.cta_link         || null,
    cta_open:         form.cta_open,
    badge:            form.badge            || null,
    desktop_image_url: form.desktop_image_url || null,
    mobile_image_url:  form.mobile_image_url  || null,
    logo_url:          form.logo_url          || null,
    bg_color:          form.bg_color,
    gradient:          form.gradient          || null,
    text_color:        form.text_color,
    button_color:      form.button_color,
    display_style:     form.display_style,
    animation:         form.animation,
    priority:          form.priority,
    is_active:         true,
    impressions: 0, clicks: 0,
    last_viewed_at: null, last_clicked_at: null,
    created_at: "", updated_at: "",
  };

  const props = { ad: previewAd, isPreview: true };

  return (
    <div className="relative overflow-hidden rounded-2xl"
      style={{ background: "#0A0A0A", border: "1px solid rgba(255,255,255,0.06)", minHeight: 200 }}>
      <div className="p-2 border-b border-white/5 flex items-center gap-2">
        <span className="w-2.5 h-2.5 rounded-full bg-red-500/60" />
        <span className="w-2.5 h-2.5 rounded-full bg-yellow-500/60" />
        <span className="w-2.5 h-2.5 rounded-full bg-green-500/60" />
        <span className="text-[10px] text-[#555] ml-2">Live Preview</span>
      </div>
      <div className="p-4">
        {form.display_style === "premium_banner"     && <PremiumBanner     {...props} />}
        {form.display_style === "glassmorphism_card" && <GlassmorphismCard {...props} />}
        {form.display_style === "floating_banner"    && <FloatingBanner    {...props} />}
        {form.display_style === "hero_banner"        && <HeroBanner        {...props} />}
        {form.display_style === "sidebar_card"       && <SidebarCard       {...props} />}
        {form.display_style === "bottom_sticky"      && <StickyBanner      {...props} />}
        {form.display_style === "inline_banner"      && <InlineBanner      {...props} />}
        {form.display_style === "popup"              && <PopupBanner        {...props} />}
        {form.display_style === "toast"              && <ToastBanner        {...props} />}
        {form.display_style === "ribbon"             && <RibbonBanner       {...props} />}
        {form.display_style === "small_card"         && <SmallCard          {...props} />}
        {form.display_style === "full_width_banner"  && <FullWidthBanner    {...props} />}
      </div>
    </div>
  );
}

// ── Image field ───────────────────────────────────────────────────────────────
function ImageField({
  label, value, onChange, uploading, onUpload,
}: {
  label: string; value: string; onChange: (v: string) => void;
  uploading: boolean; onUpload: (f: File) => void;
}) {
  return (
    <div>
      <label className={LABEL}>{label}</label>
      <div className="flex gap-2">
        <input className={`${INPUT} flex-1`} value={value} onChange={e => onChange(e.target.value)}
          placeholder="https://... or upload →" />
        <label className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-[#2A2A2A] bg-[#141414] text-xs text-[#9CA3AF] cursor-pointer hover:border-[#00FF88]/30 transition-all whitespace-nowrap flex-shrink-0">
          {uploading ? <Loader2 size={12} className="animate-spin" /> : <Upload size={12} />}
          Upload
          <input type="file" className="hidden" accept="image/*"
            onChange={e => { const f = e.target.files?.[0]; if (f) onUpload(f); }} />
        </label>
      </div>
      {value && (
        <div className="mt-2 relative w-full h-20 rounded-lg overflow-hidden border border-white/10">
          <Image src={value} alt="preview" fill className="object-contain" />
        </div>
      )}
    </div>
  );
}

// ── Main form ─────────────────────────────────────────────────────────────────
interface Props {
  existing?: Ad;
}

export default function AdForm({ existing }: Props) {
  const router = useRouter();
  const [tab, setTab]     = useState<TabId>("general");
  const [form, setForm]   = useState<FormState>(existing ? adToForm(existing) : EMPTY);
  const [saving, setSaving] = useState(false);
  const [error, setError]   = useState("");
  const [showPreview, setShowPreview] = useState(true);
  const { upload, uploading } = useImageUpload();

  const set = (patch: Partial<FormState>) => setForm(f => ({ ...f, ...patch }));

  const handleUpload = async (field: "desktop_image_url" | "mobile_image_url" | "logo_url", file: File) => {
    const url = await upload(file);
    if (url) set({ [field]: url });
  };

  // ── Locations helpers ──────────────────────────────────────────────────────
  const addLocation = () => set({ locations: [...form.locations, { location: "", css_selector: "" }] });
  const removeLocation = (i: number) => set({ locations: form.locations.filter((_, idx) => idx !== i) });
  const updateLocation = (i: number, key: "location" | "css_selector", val: string) => {
    const locs = [...form.locations];
    locs[i] = { ...locs[i], [key]: val };
    set({ locations: locs });
  };
  const toggleDevice = (d: string) => {
    const devs = form.targeting.devices.includes(d)
      ? form.targeting.devices.filter(x => x !== d)
      : [...form.targeting.devices, d];
    set({ targeting: { ...form.targeting, devices: devs } });
  };

  // ── Save ──────────────────────────────────────────────────────────────────
  const handleSave = async () => {
    if (!form.name.trim() || !form.title.trim()) {
      setError("Name and Title are required."); return;
    }
    setSaving(true); setError("");
    try {
      const payload = {
        name: form.name, type: form.type, title: form.title,
        subtitle:          form.subtitle          || null,
        description:       form.description       || null,
        cta_text:          form.cta_text          || null,
        cta_link:          form.cta_link          || null,
        cta_open:          form.cta_open,
        badge:             form.badge             || null,
        desktop_image_url: form.desktop_image_url || null,
        mobile_image_url:  form.mobile_image_url  || null,
        logo_url:          form.logo_url          || null,
        bg_color:          form.bg_color,
        gradient:          form.gradient          || null,
        text_color:        form.text_color,
        button_color:      form.button_color,
        display_style:     form.display_style,
        animation:         form.animation,
        priority:          form.priority,
        is_active:         form.is_active,
        locations: form.locations.filter(l => l.location),
        schedule: form.schedule?.start_date || form.schedule?.end_date ? form.schedule : null,
        targeting: form.targeting,
      };

      const url    = existing ? `/api/ads/${existing.id}` : "/api/ads";
      const method = existing ? "PUT" : "POST";

      const res = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      if (!res.ok) {
        const j = await res.json();
        setError(j.error || "Save failed"); return;
      }
      router.push("/admin/ads");
      router.refresh();
    } catch (e) {
      setError(String(e));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="flex flex-col xl:flex-row gap-6">
      {/* ── Form panel ─────────────────────────────────────────────────── */}
      <div className="flex-1 min-w-0">
        {/* tabs */}
        <div className="flex gap-1 mb-6 p-1 rounded-2xl overflow-x-auto"
          style={{ background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)" }}>
          {TABS.map(t => {
            const Icon = t.icon;
            const active = tab === t.id;
            return (
              <button key={t.id} onClick={() => setTab(t.id)}
                className="flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-semibold transition-all whitespace-nowrap flex-shrink-0"
                style={active
                  ? { background: "#00FF88", color: "#0B0B0B" }
                  : { color: "#9CA3AF" }}>
                <Icon size={12} /> {t.label}
              </button>
            );
          })}
        </div>

        {/* ── GENERAL ──────────────────────────────────────────────────── */}
        {tab === "general" && (
          <div className="space-y-5">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className={LABEL}>Ad Name *</label>
                <input className={INPUT} value={form.name} onChange={e => set({ name: e.target.value })} placeholder="e.g., Playwright Course Banner" />
              </div>
              <div>
                <label className={LABEL}>Type</label>
                <select className={SELECT} value={form.type} onChange={e => set({ type: e.target.value as AdType })}>
                  {AD_TYPES.map(t => <option key={t.value} value={t.value}>{t.label}</option>)}
                </select>
              </div>
            </div>

            <div>
              <label className={LABEL}>Badge</label>
              <input className={INPUT} value={form.badge} onChange={e => set({ badge: e.target.value })} placeholder="e.g., 🚀 Promotion" />
              <div className="flex flex-wrap gap-1.5 mt-2">
                {AD_BADGE_PRESETS.map(b => (
                  <button key={b} onClick={() => set({ badge: b })}
                    className="text-[10px] px-2 py-1 rounded-lg transition-all"
                    style={form.badge === b
                      ? { background: "#00FF88", color: "#0B0B0B" }
                      : { background: "rgba(255,255,255,0.05)", color: "#9CA3AF", border: "1px solid rgba(255,255,255,0.08)" }}>
                    {b}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className={LABEL}>Title *</label>
              <input className={INPUT} value={form.title} onChange={e => set({ title: e.target.value })} placeholder="Master Playwright in 30 Days" />
            </div>
            <div>
              <label className={LABEL}>Subtitle</label>
              <input className={INPUT} value={form.subtitle} onChange={e => set({ subtitle: e.target.value })} placeholder="Become job-ready with real interview questions." />
            </div>
            <div>
              <label className={LABEL}>Description</label>
              <textarea className={`${INPUT} resize-none`} rows={3} value={form.description}
                onChange={e => set({ description: e.target.value })}
                placeholder="More details about this ad…" />
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className={LABEL}>CTA Button Text</label>
                <input className={INPUT} value={form.cta_text} onChange={e => set({ cta_text: e.target.value })} placeholder="Start Learning" />
              </div>
              <div>
                <label className={LABEL}>CTA Link</label>
                <input className={INPUT} value={form.cta_link} onChange={e => set({ cta_link: e.target.value })} placeholder="https://automateqa.online/learn" />
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <div>
                <label className={LABEL}>Open In</label>
                <select className={SELECT} value={form.cta_open} onChange={e => set({ cta_open: e.target.value as "same_tab" | "new_tab" })}>
                  <option value="new_tab">New Tab</option>
                  <option value="same_tab">Same Tab</option>
                </select>
              </div>
              <div>
                <label className={LABEL}>Priority (1–100)</label>
                <input type="number" min={1} max={100} className={INPUT} value={form.priority}
                  onChange={e => set({ priority: Math.min(100, Math.max(1, Number(e.target.value))) })} />
              </div>
              <div className="flex flex-col justify-end">
                <label className="flex items-center gap-3 cursor-pointer">
                  <span className={LABEL} style={{ marginBottom: 0 }}>Active</span>
                  <div className={`relative w-10 h-5 rounded-full transition-all ${form.is_active ? "bg-[#00FF88]" : "bg-[#2A2A2A]"}`}
                    onClick={() => set({ is_active: !form.is_active })}>
                    <div className={`absolute top-0.5 w-4 h-4 bg-white rounded-full transition-all ${form.is_active ? "left-5" : "left-0.5"}`} />
                  </div>
                </label>
              </div>
            </div>
          </div>
        )}

        {/* ── APPEARANCE ───────────────────────────────────────────────── */}
        {tab === "appearance" && (
          <div className="space-y-5">
            <div>
              <label className={LABEL}>Display Style</label>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                {AD_DISPLAY_STYLES.map(s => (
                  <button key={s.value} onClick={() => set({ display_style: s.value as AdDisplayStyle })}
                    className="text-left px-3 py-2.5 rounded-xl border transition-all"
                    style={form.display_style === s.value
                      ? { border: "1px solid #00FF88", background: "rgba(0,255,136,0.08)", color: "#00FF88" }
                      : { border: "1px solid rgba(255,255,255,0.07)", color: "#9CA3AF", background: "rgba(255,255,255,0.02)" }}>
                    <p className="text-xs font-bold">{s.label}</p>
                    <p className="text-[10px] mt-0.5 opacity-60">{s.desc}</p>
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className={LABEL}>Animation</label>
              <div className="flex flex-wrap gap-2">
                {AD_ANIMATIONS.map(a => (
                  <button key={a.value} onClick={() => set({ animation: a.value as AdAnimation })}
                    className="px-3 py-1.5 rounded-xl text-xs font-semibold transition-all"
                    style={form.animation === a.value
                      ? { background: "#00FF88", color: "#0B0B0B" }
                      : { background: "rgba(255,255,255,0.05)", color: "#9CA3AF", border: "1px solid rgba(255,255,255,0.08)" }}>
                    {a.label}
                  </button>
                ))}
              </div>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              <div>
                <label className={LABEL}>Background</label>
                <div className="flex gap-2">
                  <input type="color" value={form.bg_color} onChange={e => set({ bg_color: e.target.value })}
                    className="w-10 h-10 rounded-lg border border-[#2A2A2A] cursor-pointer bg-transparent" />
                  <input className={`${INPUT} flex-1`} value={form.bg_color} onChange={e => set({ bg_color: e.target.value })} />
                </div>
              </div>
              <div>
                <label className={LABEL}>Text Color</label>
                <div className="flex gap-2">
                  <input type="color" value={form.text_color} onChange={e => set({ text_color: e.target.value })}
                    className="w-10 h-10 rounded-lg border border-[#2A2A2A] cursor-pointer bg-transparent" />
                  <input className={`${INPUT} flex-1`} value={form.text_color} onChange={e => set({ text_color: e.target.value })} />
                </div>
              </div>
              <div>
                <label className={LABEL}>Button Color</label>
                <div className="flex gap-2">
                  <input type="color" value={form.button_color} onChange={e => set({ button_color: e.target.value })}
                    className="w-10 h-10 rounded-lg border border-[#2A2A2A] cursor-pointer bg-transparent" />
                  <input className={`${INPUT} flex-1`} value={form.button_color} onChange={e => set({ button_color: e.target.value })} />
                </div>
              </div>
              <div>
                <label className={LABEL}>Gradient (CSS)</label>
                <input className={INPUT} value={form.gradient} onChange={e => set({ gradient: e.target.value })}
                  placeholder="#0D0D0D, #1a1a2e" />
                <p className="text-[10px] text-[#555] mt-1">Comma-separated stops for linear-gradient</p>
              </div>
            </div>

            <ImageField label="Desktop Banner" value={form.desktop_image_url} uploading={uploading}
              onChange={v => set({ desktop_image_url: v })}
              onUpload={f => handleUpload("desktop_image_url", f)} />

            <ImageField label="Mobile Banner" value={form.mobile_image_url} uploading={uploading}
              onChange={v => set({ mobile_image_url: v })}
              onUpload={f => handleUpload("mobile_image_url", f)} />

            <ImageField label="Logo / Icon" value={form.logo_url} uploading={uploading}
              onChange={v => set({ logo_url: v })}
              onUpload={f => handleUpload("logo_url", f)} />
          </div>
        )}

        {/* ── LOCATIONS ────────────────────────────────────────────────── */}
        {tab === "locations" && (
          <div className="space-y-4">
            <p className="text-xs text-[#6B7280]">
              Choose where this ad appears. Add multiple locations. For custom placements use a CSS selector.
            </p>

            {form.locations.map((loc, i) => (
              <div key={i} className="flex flex-col sm:flex-row gap-2 p-3 rounded-xl"
                style={{ background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)" }}>
                <select className={`${SELECT} flex-1`} value={loc.location}
                  onChange={e => updateLocation(i, "location", e.target.value)}>
                  <option value="">— select location —</option>
                  {Object.entries(
                    AD_LOCATIONS.reduce<Record<string, typeof AD_LOCATIONS>>((acc, l) => {
                      acc[l.group] = [...(acc[l.group] || []), l]; return acc;
                    }, {})
                  ).map(([group, items]) => (
                    <optgroup key={group} label={group}>
                      {items.map(l => <option key={l.value} value={l.value}>{l.label}</option>)}
                    </optgroup>
                  ))}
                </select>

                {loc.location === "custom" && (
                  <input className={`${INPUT} flex-1`} value={loc.css_selector}
                    onChange={e => updateLocation(i, "css_selector", e.target.value)}
                    placeholder=".blog-sidebar, #hero-top" />
                )}

                <button onClick={() => removeLocation(i)}
                  className="p-2 rounded-xl transition-all hover:bg-red-500/10 text-[#555] hover:text-red-400">
                  <Trash2 size={14} />
                </button>
              </div>
            ))}

            <button onClick={addLocation}
              className="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold transition-all"
              style={{ border: "1px solid rgba(0,255,136,0.2)", color: "#00FF88", background: "rgba(0,255,136,0.06)" }}>
              <Plus size={13} /> Add Location
            </button>
          </div>
        )}

        {/* ── SCHEDULE ─────────────────────────────────────────────────── */}
        {tab === "schedule" && (
          <div className="space-y-5">
            <p className="text-xs text-[#6B7280]">
              Leave blank to show indefinitely. Schedule uses UTC internally.
            </p>

            <label className="flex items-center gap-3 cursor-pointer">
              <div className={`relative w-10 h-5 rounded-full transition-all ${form.schedule !== null ? "bg-[#00FF88]" : "bg-[#2A2A2A]"}`}
                onClick={() => set({ schedule: form.schedule ? null : { start_date: "", end_date: "", timezone: "Asia/Kolkata" } })}>
                <div className={`absolute top-0.5 w-4 h-4 bg-white rounded-full transition-all ${form.schedule ? "left-5" : "left-0.5"}`} />
              </div>
              <span className="text-sm font-semibold text-white">Enable scheduling</span>
            </label>

            {form.schedule && (
              <div className="space-y-4">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className={LABEL}>Start Date & Time</label>
                    <input type="datetime-local" className={INPUT}
                      value={form.schedule.start_date}
                      onChange={e => set({ schedule: { ...form.schedule!, start_date: e.target.value } })} />
                  </div>
                  <div>
                    <label className={LABEL}>End Date & Time</label>
                    <input type="datetime-local" className={INPUT}
                      value={form.schedule.end_date}
                      onChange={e => set({ schedule: { ...form.schedule!, end_date: e.target.value } })} />
                  </div>
                </div>
                <div>
                  <label className={LABEL}>Timezone</label>
                  <select className={SELECT} value={form.schedule.timezone}
                    onChange={e => set({ schedule: { ...form.schedule!, timezone: e.target.value } })}>
                    {TIMEZONES.map(tz => <option key={tz} value={tz}>{tz}</option>)}
                  </select>
                </div>
              </div>
            )}
          </div>
        )}

        {/* ── TARGETING ────────────────────────────────────────────────── */}
        {tab === "targeting" && (
          <div className="space-y-5">
            <div>
              <label className={LABEL}>Show to</label>
              <div className="flex flex-wrap gap-3">
                {[
                  { key: "show_to_logged_in", label: "Logged-in users" },
                  { key: "show_to_guests",    label: "Guest users"      },
                ].map(({ key, label }) => (
                  <label key={key} className="flex items-center gap-2 cursor-pointer">
                    <div className={`w-4 h-4 rounded border transition-all flex items-center justify-center ${
                        form.targeting[key as "show_to_logged_in" | "show_to_guests"]
                          ? "bg-[#00FF88] border-[#00FF88]"
                          : "border-[#3A3A3A]"
                      }`}
                      onClick={() => set({ targeting: { ...form.targeting, [key]: !form.targeting[key as "show_to_logged_in" | "show_to_guests"] } })}>
                      {form.targeting[key as "show_to_logged_in" | "show_to_guests"] && (
                        <svg className="w-2.5 h-2.5 text-black" fill="none" viewBox="0 0 10 10">
                          <path d="M1 5l3 3L9 2" stroke="currentColor" strokeWidth={1.5} strokeLinecap="round" strokeLinejoin="round" />
                        </svg>
                      )}
                    </div>
                    <span className="text-sm text-[#D1D5DB]">{label}</span>
                  </label>
                ))}
              </div>
            </div>

            <div>
              <label className={LABEL}>Devices</label>
              <div className="flex gap-3">
                {DEVICES.map(d => (
                  <label key={d} className="flex items-center gap-2 cursor-pointer">
                    <div className={`w-4 h-4 rounded border transition-all flex items-center justify-center ${
                        form.targeting.devices.includes(d) ? "bg-[#00FF88] border-[#00FF88]" : "border-[#3A3A3A]"
                      }`}
                      onClick={() => toggleDevice(d)}>
                      {form.targeting.devices.includes(d) && (
                        <svg className="w-2.5 h-2.5 text-black" fill="none" viewBox="0 0 10 10">
                          <path d="M1 5l3 3L9 2" stroke="currentColor" strokeWidth={1.5} strokeLinecap="round" strokeLinejoin="round" />
                        </svg>
                      )}
                    </div>
                    <span className="text-sm capitalize text-[#D1D5DB]">{d}</span>
                  </label>
                ))}
              </div>
            </div>

            <div>
              <label className={LABEL}>User Type</label>
              <div className="flex gap-2">
                {[["all", "All Users"], ["new", "New Users"], ["returning", "Returning Users"]].map(([v, l]) => (
                  <button key={v} onClick={() => set({ targeting: { ...form.targeting, user_type: v as "all" | "new" | "returning" } })}
                    className="px-3 py-1.5 rounded-xl text-xs font-semibold transition-all"
                    style={form.targeting.user_type === v
                      ? { background: "#00FF88", color: "#0B0B0B" }
                      : { background: "rgba(255,255,255,0.05)", color: "#9CA3AF", border: "1px solid rgba(255,255,255,0.08)" }}>
                    {l}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* ── Error + actions ───────────────────────────────────────────── */}
        {error && (
          <div className="mt-4 px-4 py-3 rounded-xl text-sm text-red-400 flex items-start gap-2"
            style={{ background: "rgba(248,113,113,0.08)", border: "1px solid rgba(248,113,113,0.2)" }}>
            <X size={14} className="mt-0.5 flex-shrink-0" /> {error}
          </div>
        )}

        <div className="flex items-center gap-3 mt-6 pt-6 border-t border-white/5">
          <button onClick={handleSave} disabled={saving}
            className="flex items-center gap-2 px-6 py-2.5 rounded-xl text-sm font-black transition-all disabled:opacity-50"
            style={{ background: "#00FF88", color: "#0B0B0B", boxShadow: "0 4px 20px rgba(0,255,136,0.3)" }}>
            {saving ? <Loader2 size={14} className="animate-spin" /> : <Save size={14} />}
            {existing ? "Save Changes" : "Create Ad"}
          </button>
          <button onClick={() => router.push("/admin/ads")}
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-sm font-semibold text-[#9CA3AF] hover:text-white transition-all"
            style={{ border: "1px solid rgba(255,255,255,0.07)" }}>
            <ChevronRight size={14} className="rotate-180" /> Cancel
          </button>
          <button onClick={() => setShowPreview(p => !p)}
            className="ml-auto flex items-center gap-1.5 text-xs font-semibold text-[#9CA3AF] hover:text-white transition-all xl:hidden">
            <Eye size={13} /> {showPreview ? "Hide" : "Show"} Preview
          </button>
        </div>
      </div>

      {/* ── Preview panel ──────────────────────────────────────────────── */}
      <div className={`xl:w-[420px] flex-shrink-0 space-y-3 ${showPreview ? "block" : "hidden xl:block"}`}>
        <p className="text-xs font-bold uppercase tracking-widest text-[#6B7280]">Live Preview</p>
        <LivePreview form={form} />
        <div className="rounded-xl p-3 space-y-1"
          style={{ background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.05)" }}>
          <p className="text-[10px] font-semibold text-[#555] uppercase tracking-wider">Info</p>
          <p className="text-[11px] text-[#6B7280]">Style: <span className="text-white">{AD_DISPLAY_STYLES.find(s => s.value === form.display_style)?.label}</span></p>
          <p className="text-[11px] text-[#6B7280]">Animation: <span className="text-white capitalize">{form.animation}</span></p>
          <p className="text-[11px] text-[#6B7280]">Priority: <span className="text-white">{form.priority}</span></p>
          <p className="text-[11px] text-[#6B7280]">Locations: <span className="text-white">{form.locations.filter(l => l.location).length}</span></p>
        </div>
      </div>
    </div>
  );
}
