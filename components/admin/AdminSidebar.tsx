"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { usePathname, useRouter } from "next/navigation";
import {
  LayoutDashboard, Laugh, Play, FileText, LogOut, Home,
  BookOpen, Lightbulb, BarChart3, Settings, Menu, X, MessageCircle, BrainCircuit, Briefcase, Megaphone,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";

const navGroups = [
  {
    label: "Content",
    items: [
      { href: "/admin",         icon: LayoutDashboard, label: "Dashboard",   exact: true },
      { href: "/admin/memes",   icon: Laugh,           label: "Memes" },
      { href: "/admin/videos",  icon: Play,            label: "Videos" },
      { href: "/admin/blogs",   icon: FileText,        label: "Blogs" },
      { href: "/admin/learn",   icon: BookOpen,        label: "Learn" },
      { href: "/admin/tips",           icon: Lightbulb,       label: "Tips & Tricks" },
      { href: "/admin/interview-prep", icon: BrainCircuit,    label: "Interview Prep" },
      { href: "/admin/comments",       icon: MessageCircle,   label: "Comments" },
      { href: "/admin/jobs",           icon: Briefcase,       label: "Jobs Board" },
    ],
  },
  {
    label: "Marketing",
    items: [
      { href: "/admin/ads", icon: Megaphone, label: "Advertisements" },
    ],
  },
  {
    label: "Analytics",
    items: [
      { href: "/admin/analytics", icon: BarChart3, label: "Analytics" },
    ],
  },
  {
    label: "Other",
    items: [
      { href: "/admin/settings", icon: Settings, label: "Settings" },
      { href: "/",               icon: Home,     label: "View Site" },
    ],
  },
];

export default function AdminSidebar() {
  const [open, setOpen] = useState(false);
  const pathname = usePathname();
  const router = useRouter();
  const supabase = createClient();

  // Close drawer on route change
  useEffect(() => { setOpen(false); }, [pathname]);

  // Lock body scroll when drawer is open on mobile
  useEffect(() => {
    if (open) document.body.style.overflow = "hidden";
    else document.body.style.overflow = "";
    return () => { document.body.style.overflow = ""; };
  }, [open]);

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/");
  };

  const isActive = (href: string, exact = false) =>
    exact ? pathname === href : pathname.startsWith(href);

  const SidebarContent = () => (
    <>
      {/* Logo */}
      <div className="p-5 border-b border-white/5 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-3 group">
          <div className="relative w-10 h-10 flex-shrink-0 transition-all duration-300 group-hover:scale-105 group-hover:drop-shadow-[0_0_8px_rgba(0,255,136,0.5)]">
            <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
          </div>
          <div>
            <span className="font-black text-sm text-white tracking-tight">
              Automate<span className="text-[#00FF88]">QA</span>
            </span>
            <span className="block text-[10px] text-[#9CA3AF]">Admin Panel</span>
          </div>
        </Link>
        {/* Close button — mobile only */}
        <button
          onClick={() => setOpen(false)}
          className="md:hidden p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-all"
        >
          <X size={18} />
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-5 overflow-y-auto">
        {navGroups.map((group) => (
          <div key={group.label}>
            <p className="text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest px-3 mb-2">
              {group.label}
            </p>
            <div className="space-y-0.5">
              {group.items.map(({ href, icon: Icon, label, exact }) => (
                <Link
                  key={href}
                  href={href}
                  className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 ${
                    isActive(href, exact)
                      ? "bg-[#00FF88]/10 text-[#00FF88] border border-[#00FF88]/20"
                      : "text-[#9CA3AF] hover:text-white hover:bg-white/5"
                  }`}
                >
                  <Icon size={16} />
                  {label}
                </Link>
              ))}
            </div>
          </div>
        ))}
      </nav>

      {/* Logout */}
      <div className="p-4 border-t border-white/5">
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium text-[#9CA3AF] hover:text-red-400 hover:bg-red-500/10 transition-all w-full"
        >
          <LogOut size={16} />
          Sign Out
        </button>
      </div>
    </>
  );

  return (
    <>
      {/* ── Mobile top bar ── */}
      <header className="md:hidden fixed top-0 left-0 right-0 z-40 bg-[#080808] border-b border-white/5 flex items-center gap-3 px-4 h-14">
        <button
          onClick={() => setOpen(true)}
          className="w-9 h-9 rounded-xl bg-[#111] border border-white/10 flex items-center justify-center text-white hover:bg-white/10 transition-all flex-shrink-0"
          aria-label="Open menu"
        >
          <Menu size={18} />
        </button>
        <Link href="/admin" className="flex items-center gap-2">
          <div className="relative w-7 h-7 flex-shrink-0">
            <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
          </div>
          <span className="font-black text-sm text-white tracking-tight">
            Automate<span className="text-[#00FF88]">QA</span>
          </span>
        </Link>
        <span className="ml-auto text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest">Admin</span>
      </header>

      {/* ── Mobile overlay backdrop ── */}
      <div
        onClick={() => setOpen(false)}
        className={`md:hidden fixed inset-0 bg-black/70 backdrop-blur-sm z-40 transition-opacity duration-300 ${
          open ? "opacity-100 pointer-events-auto" : "opacity-0 pointer-events-none"
        }`}
      />

      {/* ── Sidebar (desktop: always visible | mobile: slide-in drawer) ── */}
      <aside
        className={`fixed left-0 top-0 bottom-0 w-64 bg-[#080808] border-r border-white/5 flex flex-col z-50
          transition-transform duration-300 ease-in-out
          md:translate-x-0
          ${open ? "translate-x-0" : "-translate-x-full md:translate-x-0"}`}
      >
        <SidebarContent />
      </aside>
    </>
  );
}
