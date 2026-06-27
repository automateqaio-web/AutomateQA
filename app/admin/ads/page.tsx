"use client";

import { useState, useEffect, useCallback } from "react";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";
import {
  Plus, Search, X, Trash2, Edit2, Eye, EyeOff, Copy,
  BarChart3, Loader2, Megaphone, TrendingUp, MousePointerClick,
  CheckSquare, Square, Filter, RefreshCw,
} from "lucide-react";
import { Ad, AdDisplayStyle, AD_TYPES, AD_DISPLAY_STYLES } from "@/types";
import PremiumBanner     from "@/components/ads/banners/PremiumBanner";
import GlassmorphismCard from "@/components/ads/banners/GlassmorphismCard";
import FloatingBanner    from "@/components/ads/banners/FloatingBanner";
import HeroBanner        from "@/components/ads/banners/HeroBanner";
import SidebarCard       from "@/components/ads/banners/SidebarCard";
import StickyBanner      from "@/components/ads/banners/StickyBanner";
import InlineBanner      from "@/components/ads/banners/InlineBanner";
import FullWidthBanner   from "@/components/ads/banners/FullWidthBanner";
import SmallCard         from "@/components/ads/banners/SmallCard";
import RibbonBanner      from "@/components/ads/banners/RibbonBanner";

// ── Helpers ───────────────────────────────────────────────────────────────────
const fmtNum = (n: number) => n >= 1000 ? `${(n / 1000).toFixed(1)}k` : String(n);
const ctr    = (ad: Ad) => ad.impressions > 0 ? ((ad.clicks / ad.impressions) * 100).toFixed(1) + "%" : "—";

const TYPE_COLORS: Record<string, string> = {
  promotion: "#00FF88", collaboration: "#a78bfa", sponsor: "#fbbf24",
  course: "#38bdf8", announcement: "#f97316", event: "#f472b6",
  hiring: "#4ade80", affiliate: "#fb923c", custom: "#9ca3af",
};

function BannerPreview({ ad }: { ad: Ad }) {
  const props = { ad, isPreview: true };
  switch (ad.display_style as AdDisplayStyle) {
    case "glassmorphism_card": return <GlassmorphismCard {...props} />;
    case "floating_banner":    return <FloatingBanner    {...props} />;
    case "hero_banner":        return <HeroBanner        {...props} />;
    case "sidebar_card":       return <SidebarCard       {...props} />;
    case "bottom_sticky":      return <StickyBanner      {...props} />;
    case "inline_banner":      return <InlineBanner      {...props} />;
    case "full_width_banner":  return <FullWidthBanner   {...props} />;
    case "small_card":         return <SmallCard         {...props} />;
    case "ribbon":             return <RibbonBanner      {...props} />;
    default:                   return <PremiumBanner     {...props} />;
  }
}

// ── Row ───────────────────────────────────────────────────────────────────────
function AdRow({
  ad, selected, onSelect, onToggle, onDelete, onDuplicate, onPreview,
}: {
  ad: Ad; selected: boolean;
  onSelect: () => void; onToggle: () => void;
  onDelete: () => void; onDuplicate: () => void; onPreview: () => void;
}) {
  const bc = ad.button_color || "#00FF88";

  return (
    <motion.tr
      initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
      className="group border-b border-white/5 hover:bg-white/[0.02] transition-all"
    >
      {/* select */}
      <td className="px-4 py-3 w-8">
        <button onClick={onSelect} className="text-[#555] hover:text-[#00FF88] transition-colors">
          {selected ? <CheckSquare size={15} className="text-[#00FF88]" /> : <Square size={15} />}
        </button>
      </td>

      {/* name + type */}
      <td className="px-4 py-3">
        <div className="flex items-center gap-2.5">
          <div className="w-2 h-2 rounded-full flex-shrink-0"
            style={{ background: bc, boxShadow: `0 0 6px ${bc}60` }} />
          <div>
            <p className="text-sm font-bold text-white">{ad.name}</p>
            <span className="text-[10px] font-semibold uppercase tracking-wider px-1.5 py-0.5 rounded"
              style={{ background: `${TYPE_COLORS[ad.type] || "#9ca3af"}18`, color: TYPE_COLORS[ad.type] || "#9ca3af" }}>
              {ad.type}
            </span>
          </div>
        </div>
      </td>

      {/* title */}
      <td className="px-4 py-3 hidden md:table-cell">
        <p className="text-sm text-[#D1D5DB] max-w-[200px] truncate">{ad.title}</p>
        {ad.subtitle && <p className="text-xs text-[#6B7280] truncate">{ad.subtitle}</p>}
      </td>

      {/* style */}
      <td className="px-4 py-3 hidden lg:table-cell">
        <span className="text-xs px-2 py-0.5 rounded-lg"
          style={{ background: "rgba(255,255,255,0.05)", color: "#9CA3AF", border: "1px solid rgba(255,255,255,0.07)" }}>
          {AD_DISPLAY_STYLES.find(s => s.value === ad.display_style)?.label ?? ad.display_style}
        </span>
      </td>

      {/* locations */}
      <td className="px-4 py-3 hidden xl:table-cell">
        <div className="flex flex-wrap gap-1 max-w-[180px]">
          {(ad.locations ?? []).slice(0, 2).map(l => (
            <span key={l.id} className="text-[10px] px-1.5 py-0.5 rounded"
              style={{ background: "rgba(255,255,255,0.04)", color: "#6B7280" }}>
              {l.location.replace(/_/g, " ")}
            </span>
          ))}
          {(ad.locations ?? []).length > 2 && (
            <span className="text-[10px] text-[#555]">+{(ad.locations ?? []).length - 2}</span>
          )}
          {(ad.locations ?? []).length === 0 && <span className="text-[10px] text-[#444]">no locations</span>}
        </div>
      </td>

      {/* priority */}
      <td className="px-4 py-3 text-center hidden sm:table-cell">
        <span className="text-xs font-bold" style={{ color: ad.priority >= 70 ? "#f87171" : ad.priority >= 40 ? "#fbbf24" : "#9CA3AF" }}>
          {ad.priority}
        </span>
      </td>

      {/* stats */}
      <td className="px-4 py-3 hidden lg:table-cell">
        <div className="flex items-center gap-3 text-xs">
          <span className="flex items-center gap-1 text-[#9CA3AF]">
            <TrendingUp size={10} /> {fmtNum(ad.impressions)}
          </span>
          <span className="flex items-center gap-1 text-[#9CA3AF]">
            <MousePointerClick size={10} /> {fmtNum(ad.clicks)}
          </span>
          <span style={{ color: "#00FF88" }}>{ctr(ad)}</span>
        </div>
      </td>

      {/* status */}
      <td className="px-4 py-3">
        <button onClick={onToggle}
          className="flex items-center gap-1.5 text-xs font-semibold px-2.5 py-1 rounded-lg transition-all"
          style={ad.is_active
            ? { background: "rgba(0,255,136,0.08)", color: "#00FF88", border: "1px solid rgba(0,255,136,0.2)" }
            : { background: "rgba(255,255,255,0.04)", color: "#555", border: "1px solid rgba(255,255,255,0.07)" }}>
          {ad.is_active ? <Eye size={10} /> : <EyeOff size={10} />}
          {ad.is_active ? "Live" : "Off"}
        </button>
      </td>

      {/* actions */}
      <td className="px-4 py-3">
        <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <button onClick={onPreview}
            className="p-1.5 rounded-lg text-[#555] hover:text-[#00FF88] hover:bg-[#00FF88]/10 transition-all"
            title="Preview">
            <Eye size={13} />
          </button>
          <Link href={`/admin/ads/${ad.id}/edit`}
            className="p-1.5 rounded-lg text-[#555] hover:text-blue-400 hover:bg-blue-400/10 transition-all"
            title="Edit">
            <Edit2 size={13} />
          </Link>
          <button onClick={onDuplicate}
            className="p-1.5 rounded-lg text-[#555] hover:text-amber-400 hover:bg-amber-400/10 transition-all"
            title="Duplicate">
            <Copy size={13} />
          </button>
          <button onClick={onDelete}
            className="p-1.5 rounded-lg text-[#555] hover:text-red-400 hover:bg-red-400/10 transition-all"
            title="Delete">
            <Trash2 size={13} />
          </button>
        </div>
      </td>
    </motion.tr>
  );
}

// ── Main page ─────────────────────────────────────────────────────────────────
export default function AdminAdsPage() {
  const [ads,       setAds]       = useState<Ad[]>([]);
  const [loading,   setLoading]   = useState(true);
  const [search,    setSearch]    = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState<"" | "active" | "inactive">("");
  const [selected,  setSelected]  = useState<Set<string>>(new Set());
  const [preview,   setPreview]   = useState<Ad | null>(null);
  const [deleting,  setDeleting]  = useState<string | null>(null);

  const fetchAds = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/ads");
      const { data } = await res.json();
      setAds(data || []);
    } catch { setAds([]); } finally { setLoading(false); }
  }, []);

  useEffect(() => { fetchAds(); }, [fetchAds]);

  // ── Filtered list ──────────────────────────────────────────────────────────
  const filtered = ads.filter(ad => {
    if (search && !ad.name.toLowerCase().includes(search.toLowerCase())
               && !ad.title.toLowerCase().includes(search.toLowerCase())) return false;
    if (typeFilter && ad.type !== typeFilter) return false;
    if (statusFilter === "active"   && !ad.is_active) return false;
    if (statusFilter === "inactive" &&  ad.is_active) return false;
    return true;
  });

  // ── Stats ──────────────────────────────────────────────────────────────────
  const totalImpressions = ads.reduce((s, a) => s + a.impressions, 0);
  const totalClicks      = ads.reduce((s, a) => s + a.clicks, 0);
  const activeCount      = ads.filter(a => a.is_active).length;

  // ── Actions ───────────────────────────────────────────────────────────────
  const toggleStatus = async (ad: Ad) => {
    await fetch(`/api/ads/${ad.id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ is_active: !ad.is_active }),
    });
    setAds(prev => prev.map(a => a.id === ad.id ? { ...a, is_active: !a.is_active } : a));
  };

  const deleteAd = async (id: string) => {
    if (!confirm("Delete this ad? This cannot be undone.")) return;
    setDeleting(id);
    await fetch(`/api/ads/${id}`, { method: "DELETE" });
    setAds(prev => prev.filter(a => a.id !== id));
    setSelected(prev => { const s = new Set(prev); s.delete(id); return s; });
    setDeleting(null);
  };

  const duplicateAd = async (ad: Ad) => {
    const payload = {
      name: `${ad.name} (copy)`, type: ad.type, title: ad.title,
      subtitle: ad.subtitle, description: ad.description,
      cta_text: ad.cta_text, cta_link: ad.cta_link, cta_open: ad.cta_open,
      desktop_image_url: ad.desktop_image_url, mobile_image_url: ad.mobile_image_url,
      logo_url: ad.logo_url, bg_color: ad.bg_color, gradient: ad.gradient,
      text_color: ad.text_color, button_color: ad.button_color, badge: ad.badge,
      display_style: ad.display_style, animation: ad.animation,
      priority: ad.priority, is_active: false,
      locations: (ad.locations ?? []).map(l => ({ location: l.location, css_selector: l.css_selector })),
      schedule: null, targeting: null,
    };
    const res = await fetch("/api/ads", {
      method: "POST", headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    const { data } = await res.json();
    if (data) setAds(prev => [data, ...prev]);
  };

  // ── Bulk actions ──────────────────────────────────────────────────────────
  const bulkToggle = async (active: boolean) => {
    await Promise.all([...selected].map(id =>
      fetch(`/api/ads/${id}`, { method: "PUT", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ is_active: active }) })
    ));
    setAds(prev => prev.map(a => selected.has(a.id) ? { ...a, is_active: active } : a));
    setSelected(new Set());
  };

  const bulkDelete = async () => {
    if (!confirm(`Delete ${selected.size} ad(s)?`)) return;
    await Promise.all([...selected].map(id => fetch(`/api/ads/${id}`, { method: "DELETE" })));
    setAds(prev => prev.filter(a => !selected.has(a.id)));
    setSelected(new Set());
  };

  const toggleSelect = (id: string) => setSelected(prev => {
    const s = new Set(prev);
    s.has(id) ? s.delete(id) : s.add(id);
    return s;
  });

  const selectAll = () => {
    if (selected.size === filtered.length) setSelected(new Set());
    else setSelected(new Set(filtered.map(a => a.id)));
  };

  return (
    <div className="space-y-6">
      {/* ── Header ────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <Megaphone size={18} className="text-[#00FF88]" />
            <h1 className="text-xl font-black text-white">Advertisements</h1>
          </div>
          <p className="text-sm text-[#6B7280]">Create and manage promotional banners across the site</p>
        </div>
        <Link href="/admin/ads/new"
          className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-sm font-black transition-all"
          style={{ background: "#00FF88", color: "#0B0B0B", boxShadow: "0 4px 20px rgba(0,255,136,0.3)" }}>
          <Plus size={15} /> New Ad
        </Link>
      </div>

      {/* ── Stats ─────────────────────────────────────────────────────── */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {[
          { label: "Total Ads",    value: ads.length,         icon: Megaphone,          color: "#00FF88" },
          { label: "Active",       value: activeCount,        icon: Eye,                color: "#4ade80" },
          { label: "Impressions",  value: fmtNum(totalImpressions), icon: TrendingUp,   color: "#38bdf8" },
          { label: "Clicks",       value: fmtNum(totalClicks), icon: MousePointerClick, color: "#f472b6" },
        ].map(({ label, value, icon: Icon, color }) => (
          <div key={label} className="p-4 rounded-2xl"
            style={{ background: "rgba(255,255,255,0.02)", border: "1px solid rgba(255,255,255,0.06)" }}>
            <div className="flex items-center gap-2 mb-2">
              <Icon size={14} style={{ color }} />
              <span className="text-xs text-[#6B7280]">{label}</span>
            </div>
            <p className="text-2xl font-black text-white">{value}</p>
          </div>
        ))}
      </div>

      {/* ── Filters ───────────────────────────────────────────────────── */}
      <div className="flex flex-wrap gap-2">
        <div className="relative flex-1 min-w-48">
          <Search size={13} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#555]" />
          <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search ads…"
            className="w-full pl-9 pr-4 py-2 rounded-xl bg-[#111] border border-[#2A2A2A] text-sm text-white placeholder-[#444] focus:outline-none focus:border-[#00FF88]/30 transition-all" />
          {search && <button onClick={() => setSearch("")} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#555] hover:text-white"><X size={12} /></button>}
        </div>

        <select value={typeFilter} onChange={e => setTypeFilter(e.target.value)}
          className="px-3 py-2 rounded-xl bg-[#111] border border-[#2A2A2A] text-sm text-white focus:outline-none appearance-none cursor-pointer">
          <option value="">All Types</option>
          {AD_TYPES.map(t => <option key={t.value} value={t.value}>{t.label}</option>)}
        </select>

        <select value={statusFilter} onChange={e => setStatusFilter(e.target.value as "" | "active" | "inactive")}
          className="px-3 py-2 rounded-xl bg-[#111] border border-[#2A2A2A] text-sm text-white focus:outline-none appearance-none cursor-pointer">
          <option value="">All Status</option>
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
        </select>

        <button onClick={fetchAds}
          className="p-2 rounded-xl border border-[#2A2A2A] text-[#555] hover:text-white hover:border-white/20 transition-all">
          <RefreshCw size={14} />
        </button>
      </div>

      {/* ── Bulk actions ─────────────────────────────────────────────── */}
      <AnimatePresence>
        {selected.size > 0 && (
          <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -8 }}
            className="flex items-center gap-3 px-4 py-2.5 rounded-xl"
            style={{ background: "rgba(0,255,136,0.06)", border: "1px solid rgba(0,255,136,0.2)" }}>
            <span className="text-sm font-semibold text-[#00FF88]">{selected.size} selected</span>
            <div className="flex gap-2 ml-auto">
              <button onClick={() => bulkToggle(true)}
                className="text-xs px-3 py-1.5 rounded-lg font-semibold transition-all"
                style={{ background: "rgba(74,222,128,0.1)", color: "#4ade80", border: "1px solid rgba(74,222,128,0.2)" }}>
                Enable All
              </button>
              <button onClick={() => bulkToggle(false)}
                className="text-xs px-3 py-1.5 rounded-lg font-semibold transition-all"
                style={{ background: "rgba(255,255,255,0.05)", color: "#9CA3AF", border: "1px solid rgba(255,255,255,0.08)" }}>
                Disable All
              </button>
              <button onClick={bulkDelete}
                className="text-xs px-3 py-1.5 rounded-lg font-semibold transition-all"
                style={{ background: "rgba(248,113,113,0.08)", color: "#f87171", border: "1px solid rgba(248,113,113,0.2)" }}>
                Delete All
              </button>
              <button onClick={() => setSelected(new Set())} className="text-[#555] hover:text-white transition-all">
                <X size={13} />
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* ── Table ─────────────────────────────────────────────────────── */}
      <div className="rounded-2xl overflow-hidden" style={{ border: "1px solid rgba(255,255,255,0.06)" }}>
        {loading ? (
          <div className="flex items-center justify-center py-20">
            <Loader2 size={24} className="animate-spin text-[#00FF88]" />
          </div>
        ) : filtered.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 text-center">
            <Megaphone size={32} className="text-[#333] mb-3" />
            <p className="text-[#555] font-semibold">No ads found</p>
            <p className="text-[#444] text-sm mt-1">
              {ads.length === 0 ? "Create your first ad to get started" : "Try adjusting your filters"}
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5" style={{ background: "rgba(255,255,255,0.02)" }}>
                  <th className="px-4 py-3 text-left w-8">
                    <button onClick={selectAll} className="text-[#555] hover:text-[#00FF88] transition-colors">
                      {selected.size === filtered.length && filtered.length > 0
                        ? <CheckSquare size={15} className="text-[#00FF88]" />
                        : <Square size={15} />}
                    </button>
                  </th>
                  {["Name / Type", "Title", "Style", "Locations", "Priority", "Stats", "Status", "Actions"].map(h => (
                    <th key={h} className="px-4 py-3 text-left text-[10px] font-semibold text-[#6B7280] uppercase tracking-wider whitespace-nowrap
                      hidden-sm">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {filtered.map(ad => (
                  <AdRow
                    key={ad.id} ad={ad}
                    selected={selected.has(ad.id)}
                    onSelect={() => toggleSelect(ad.id)}
                    onToggle={() => toggleStatus(ad)}
                    onDelete={() => deleteAd(ad.id)}
                    onDuplicate={() => duplicateAd(ad)}
                    onPreview={() => setPreview(ad)}
                  />
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <p className="text-xs text-[#555] text-right">{filtered.length} of {ads.length} ads</p>

      {/* ── Preview modal ─────────────────────────────────────────────── */}
      <AnimatePresence>
        {preview && (
          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 flex items-center justify-center p-4"
            style={{ background: "rgba(0,0,0,0.8)", backdropFilter: "blur(8px)" }}
            onClick={() => setPreview(null)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.95, opacity: 0 }}
              className="w-full max-w-2xl rounded-2xl overflow-hidden"
              style={{ background: "#0D0D0D", border: "1px solid rgba(255,255,255,0.1)" }}
              onClick={e => e.stopPropagation()}
            >
              <div className="flex items-center justify-between px-5 py-4 border-b border-white/5">
                <div>
                  <p className="font-black text-white">{preview.name}</p>
                  <p className="text-xs text-[#6B7280]">{AD_DISPLAY_STYLES.find(s => s.value === preview.display_style)?.label}</p>
                </div>
                <div className="flex items-center gap-3">
                  <Link href={`/admin/ads/${preview.id}/edit`}
                    className="text-xs px-3 py-1.5 rounded-lg font-semibold transition-all"
                    style={{ background: "rgba(0,255,136,0.1)", color: "#00FF88", border: "1px solid rgba(0,255,136,0.2)" }}>
                    Edit
                  </Link>
                  <button onClick={() => setPreview(null)} className="text-[#555] hover:text-white transition-all p-1">
                    <X size={16} />
                  </button>
                </div>
              </div>
              <div className="p-6">
                <BannerPreview ad={preview} />
                {/* stats */}
                <div className="flex gap-4 mt-4 pt-4 border-t border-white/5">
                  <div className="text-center">
                    <p className="text-lg font-black text-white">{fmtNum(preview.impressions)}</p>
                    <p className="text-[10px] text-[#6B7280] uppercase tracking-wider">Impressions</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-black text-white">{fmtNum(preview.clicks)}</p>
                    <p className="text-[10px] text-[#6B7280] uppercase tracking-wider">Clicks</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-black" style={{ color: "#00FF88" }}>{ctr(preview)}</p>
                    <p className="text-[10px] text-[#6B7280] uppercase tracking-wider">CTR</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-black text-white">{preview.priority}</p>
                    <p className="text-[10px] text-[#6B7280] uppercase tracking-wider">Priority</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-black" style={{ color: preview.is_active ? "#00FF88" : "#555" }}>
                      {preview.is_active ? "Live" : "Off"}
                    </p>
                    <p className="text-[10px] text-[#6B7280] uppercase tracking-wider">Status</p>
                  </div>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
