"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { Settings, Navigation, Layout, Save, Loader2, Check, Eye, EyeOff, Rocket, Globe, Mail } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface NavItem {
  key: string;
  label: string;
  href: string;
  enabled: boolean;
  sort_order: number;
}

interface SiteSettings {
  contact_email: string;
  owner_email: string;
}

interface PageSetting {
  key: string;
  label: string;
  coming_soon: boolean;
  coming_soon_title: string;
  coming_soon_message: string;
}

const NAV_DEFAULT: NavItem[] = [
  { key: "home",    label: "Home",          href: "/",                enabled: true, sort_order: 1 },
  { key: "memes",   label: "Memes",         href: "/memes",           enabled: true, sort_order: 2 },
  { key: "videos",  label: "Videos",        href: "/videos",          enabled: true, sort_order: 3 },
  { key: "learn",   label: "Learn",         href: "/learn",           enabled: true, sort_order: 4 },
  { key: "tips",    label: "Tips & Tricks", href: "/automation-tips", enabled: true, sort_order: 5 },
  { key: "blog",    label: "Blog",          href: "/blog",            enabled: true, sort_order: 6 },
  { key: "youtube", label: "YouTube",       href: "/creator-stats",   enabled: true, sort_order: 7 },
  { key: "about",   label: "About",         href: "/about",           enabled: true, sort_order: 8 },
];

function Toggle({ enabled, onChange }: { enabled: boolean; onChange: (v: boolean) => void }) {
  return (
    <button
      type="button"
      onClick={() => onChange(!enabled)}
      className={`relative w-12 h-6 rounded-full transition-all duration-300 focus:outline-none ${
        enabled ? "bg-[#00FF88]" : "bg-[#2A2A2A]"
      }`}
    >
      <span
        className={`absolute top-1 w-4 h-4 rounded-full bg-white shadow-md transition-all duration-300 ${
          enabled ? "left-7" : "left-1"
        }`}
      />
    </button>
  );
}

export default function AdminSettingsPage() {
  const [navItems, setNavItems] = useState<NavItem[]>(NAV_DEFAULT);
  const [pageSettings, setPageSettings] = useState<PageSetting[]>([]);
  const [siteSettings, setSiteSettings] = useState<SiteSettings>({ contact_email: "", owner_email: "" });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState<string | null>(null);
  const [saved, setSaved] = useState<string | null>(null);
  const supabase = createClient();

  useEffect(() => {
    const load = async () => {
      const [navRes, pagesRes, siteRes] = await Promise.all([
        supabase.from("nav_settings").select("*").order("sort_order"),
        supabase.from("page_settings").select("*"),
        supabase.from("site_settings").select("contact_email,owner_email").limit(1).single(),
      ]);
      if (navRes.data?.length) setNavItems(navRes.data);
      if (pagesRes.data?.length) setPageSettings(pagesRes.data);
      if (siteRes.data) setSiteSettings(siteRes.data);
      setLoading(false);
    };
    load();
  }, []);

  const saveNav = async (key: string, enabled: boolean) => {
    setSaving(`nav-${key}`);
    await supabase.from("nav_settings").update({ enabled }).eq("key", key);
    setNavItems((prev) => prev.map((n) => n.key === key ? { ...n, enabled } : n));
    setSaving(null);
    setSaved(`nav-${key}`);
    setTimeout(() => setSaved(null), 2000);
  };

  const savePageSetting = async (key: string, field: keyof PageSetting, value: string | boolean) => {
    const id = `page-${key}-${String(field)}`;
    setSaving(id);
    await supabase.from("page_settings").update({ [field]: value }).eq("key", key);
    setPageSettings((prev) =>
      prev.map((p) => p.key === key ? { ...p, [field]: value } : p)
    );
    setSaving(null);
    setSaved(id);
    setTimeout(() => setSaved(null), 2000);
  };

  const updatePageLocal = (key: string, field: keyof PageSetting, value: string | boolean) => {
    setPageSettings((prev) =>
      prev.map((p) => p.key === key ? { ...p, [field]: value } : p)
    );
  };

  const saveSiteSetting = async (field: keyof SiteSettings) => {
    const id = `site-${field}`;
    setSaving(id);
    await supabase
      .from("site_settings")
      .update({ [field]: siteSettings[field] })
      .eq("id", (await supabase.from("site_settings").select("id").limit(1).single()).data?.id);
    setSaving(null);
    setSaved(id);
    setTimeout(() => setSaved(null), 2000);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <Loader2 size={28} className="animate-spin text-[#00FF88]" />
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-8">
      {/* Header */}
      <div>
        <div className="flex items-center gap-3 mb-1">
          <div className="w-9 h-9 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
            <Settings size={18} className="text-[#00FF88]" />
          </div>
          <h1 className="text-2xl font-black text-white">Site Settings</h1>
        </div>
        <p className="text-[#9CA3AF] text-sm ml-12">Control navigation visibility and page states</p>
      </div>

      {/* Nav Settings */}
      <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} className="glass-card p-6">
        <div className="flex items-center gap-3 mb-6">
          <Navigation size={18} className="text-purple-400" />
          <div>
            <h2 className="text-lg font-bold text-white">Navigation Items</h2>
            <p className="text-xs text-[#9CA3AF]">Toggle which pages appear in the navigation bar</p>
          </div>
        </div>

        <div className="space-y-2">
          {navItems.map((item) => {
            const sid = `nav-${item.key}`;
            return (
              <div
                key={item.key}
                className={`flex items-center justify-between p-4 rounded-xl border transition-all ${
                  item.enabled
                    ? "bg-[#0F1F0F] border-[#00FF88]/20"
                    : "bg-[#111] border-[#2A2A2A] opacity-70"
                }`}
              >
                <div className="flex items-center gap-3">
                  <Globe size={15} className={item.enabled ? "text-[#00FF88]" : "text-[#9CA3AF]"} />
                  <div>
                    <p className="text-sm font-semibold text-white">{item.label}</p>
                    <p className="text-xs text-[#9CA3AF]">{item.href}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  {saving === sid && <Loader2 size={14} className="animate-spin text-[#00FF88]" />}
                  {saved === sid && <Check size={14} className="text-[#00FF88]" />}
                  <div className="flex items-center gap-2">
                    {item.enabled
                      ? <Eye size={13} className="text-[#00FF88]" />
                      : <EyeOff size={13} className="text-[#9CA3AF]" />
                    }
                    <Toggle enabled={item.enabled} onChange={(v) => saveNav(item.key, v)} />
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        <p className="text-xs text-[#9CA3AF] mt-4 flex items-center gap-1.5">
          <span className="w-1.5 h-1.5 rounded-full bg-[#00FF88]" />
          Changes apply instantly to the navbar for all visitors
        </p>
      </motion.div>

      {/* Page Settings */}
      <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="glass-card p-6">
        <div className="flex items-center gap-3 mb-6">
          <Layout size={18} className="text-yellow-400" />
          <div>
            <h2 className="text-lg font-bold text-white">Page Visibility</h2>
            <p className="text-xs text-[#9CA3AF]">Set pages to &quot;Coming Soon&quot; mode with custom messages</p>
          </div>
        </div>

        <div className="space-y-4">
          {pageSettings.map((page) => (
            <div
              key={page.key}
              className={`rounded-xl border overflow-hidden transition-all ${
                page.coming_soon
                  ? "border-yellow-500/30 bg-yellow-500/5"
                  : "border-[#2A2A2A] bg-[#111]"
              }`}
            >
              {/* Page header row */}
              <div className="flex items-center justify-between p-4">
                <div className="flex items-center gap-3">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${page.coming_soon ? "bg-yellow-500/20" : "bg-[#1A1A1A]"}`}>
                    <Rocket size={15} className={page.coming_soon ? "text-yellow-400" : "text-[#9CA3AF]"} />
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-white">{page.label}</p>
                    <p className="text-xs text-[#9CA3AF]">
                      {page.coming_soon ? "🚧 Showing Coming Soon" : "✅ Showing live content"}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  {saving?.startsWith(`page-${page.key}-coming_soon`) && (
                    <Loader2 size={14} className="animate-spin text-yellow-400" />
                  )}
                  {saved?.startsWith(`page-${page.key}-coming_soon`) && (
                    <Check size={14} className="text-[#00FF88]" />
                  )}
                  <Toggle
                    enabled={page.coming_soon}
                    onChange={(v) => savePageSetting(page.key, "coming_soon", v)}
                  />
                </div>
              </div>

              {/* Expanded fields when coming soon is ON */}
              {page.coming_soon && (
                <div className="px-4 pb-4 space-y-3 border-t border-yellow-500/10 pt-4">
                  <div>
                    <label className="block text-xs font-medium text-[#9CA3AF] mb-1.5">Coming Soon Title</label>
                    <div className="flex gap-2">
                      <input
                        value={page.coming_soon_title}
                        onChange={(e) => updatePageLocal(page.key, "coming_soon_title", e.target.value)}
                        className="flex-1 px-3 py-2 rounded-lg bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all"
                      />
                      <button
                        onClick={() => savePageSetting(page.key, "coming_soon_title", page.coming_soon_title)}
                        disabled={saving === `page-${page.key}-coming_soon_title`}
                        className="px-3 py-2 rounded-lg bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold hover:bg-[#00FF88]/20 transition-all flex items-center gap-1.5"
                      >
                        {saving === `page-${page.key}-coming_soon_title`
                          ? <Loader2 size={12} className="animate-spin" />
                          : saved === `page-${page.key}-coming_soon_title`
                          ? <Check size={12} />
                          : <Save size={12} />
                        }
                        Save
                      </button>
                    </div>
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-[#9CA3AF] mb-1.5">Coming Soon Message</label>
                    <div className="flex gap-2">
                      <textarea
                        value={page.coming_soon_message}
                        onChange={(e) => updatePageLocal(page.key, "coming_soon_message", e.target.value)}
                        rows={2}
                        className="flex-1 px-3 py-2 rounded-lg bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all resize-none"
                      />
                      <button
                        onClick={() => savePageSetting(page.key, "coming_soon_message", page.coming_soon_message)}
                        disabled={saving === `page-${page.key}-coming_soon_message`}
                        className="px-3 py-2 rounded-lg bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold hover:bg-[#00FF88]/20 transition-all flex items-center gap-1.5 self-start"
                      >
                        {saving === `page-${page.key}-coming_soon_message`
                          ? <Loader2 size={12} className="animate-spin" />
                          : saved === `page-${page.key}-coming_soon_message`
                          ? <Check size={12} />
                          : <Save size={12} />
                        }
                        Save
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>

        <p className="text-xs text-[#9CA3AF] mt-4 flex items-center gap-1.5">
          <span className="w-1.5 h-1.5 rounded-full bg-yellow-400" />
          Coming Soon pages show a branded landing page to visitors instead of content
        </p>
      </motion.div>

      {/* Contact Settings */}
      <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="glass-card p-6">
        <div className="flex items-center gap-3 mb-6">
          <Mail size={18} className="text-blue-400" />
          <div>
            <h2 className="text-lg font-bold text-white">Contact Settings</h2>
            <p className="text-xs text-[#9CA3AF]">Configure the public contact email and where form submissions are sent</p>
          </div>
        </div>

        <div className="space-y-5">
          {/* Public contact email */}
          <div>
            <label className="block text-sm font-semibold text-white mb-1">
              Public Contact Email
            </label>
            <p className="text-xs text-[#9CA3AF] mb-2">Shown in the footer and contact page for visitors to see</p>
            <div className="flex gap-2">
              <input
                type="email"
                value={siteSettings.contact_email}
                onChange={(e) => setSiteSettings((s) => ({ ...s, contact_email: e.target.value }))}
                placeholder="automate.qa.io@gmail.com"
                className="flex-1 px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-blue-500/50 transition-all"
              />
              <button
                onClick={() => saveSiteSetting("contact_email")}
                disabled={saving === "site-contact_email"}
                className="px-4 py-2.5 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold hover:bg-blue-500/20 transition-all flex items-center gap-1.5 whitespace-nowrap"
              >
                {saving === "site-contact_email"
                  ? <Loader2 size={12} className="animate-spin" />
                  : saved === "site-contact_email"
                  ? <Check size={12} />
                  : <Save size={12} />
                }
                Save
              </button>
            </div>
          </div>

          {/* Owner/receive email */}
          <div>
            <label className="block text-sm font-semibold text-white mb-1">
              Receive Emails At
            </label>
            <p className="text-xs text-[#9CA3AF] mb-2">Contact form submissions will be sent to this address (private)</p>
            <div className="flex gap-2">
              <input
                type="email"
                value={siteSettings.owner_email}
                onChange={(e) => setSiteSettings((s) => ({ ...s, owner_email: e.target.value }))}
                placeholder="nagendra.meesala.puri@gmail.com"
                className="flex-1 px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-blue-500/50 transition-all"
              />
              <button
                onClick={() => saveSiteSetting("owner_email")}
                disabled={saving === "site-owner_email"}
                className="px-4 py-2.5 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold hover:bg-blue-500/20 transition-all flex items-center gap-1.5 whitespace-nowrap"
              >
                {saving === "site-owner_email"
                  ? <Loader2 size={12} className="animate-spin" />
                  : saved === "site-owner_email"
                  ? <Check size={12} />
                  : <Save size={12} />
                }
                Save
              </button>
            </div>
          </div>
        </div>

        <p className="text-xs text-[#9CA3AF] mt-5 flex items-center gap-1.5">
          <span className="w-1.5 h-1.5 rounded-full bg-blue-400" />
          Changes apply immediately — no restart required
        </p>
      </motion.div>
    </div>
  );
}
