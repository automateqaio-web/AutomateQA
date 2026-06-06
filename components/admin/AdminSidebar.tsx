"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname, useRouter } from "next/navigation";
import { LayoutDashboard, Laugh, Play, FileText, LogOut, Home, BookOpen, Lightbulb, BarChart3, Settings } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

const contentItems = [
  { href: "/admin", icon: LayoutDashboard, label: "Dashboard", exact: true },
  { href: "/admin/memes", icon: Laugh, label: "Memes" },
  { href: "/admin/videos", icon: Play, label: "Videos" },
  { href: "/admin/blogs", icon: FileText, label: "Blogs" },
  { href: "/admin/learn", icon: BookOpen, label: "Learn" },
  { href: "/admin/tips", icon: Lightbulb, label: "Tips & Tricks" },
];

const analyticsItems = [
  { href: "/admin/analytics", icon: BarChart3, label: "Analytics" },
];

export default function AdminSidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const supabase = createClient();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/");
  };

  const isActive = (href: string, exact = false) => {
    if (exact) return pathname === href;
    return pathname.startsWith(href);
  };

  return (
    <aside className="fixed left-0 top-0 bottom-0 w-64 bg-[#080808] border-r border-white/5 flex flex-col z-40">
      {/* Logo */}
      <div className="p-5 border-b border-white/5">
        <Link href="/" className="flex items-center gap-3 group">
          <div className="relative w-10 h-10 flex-shrink-0 transition-all duration-300 group-hover:scale-105 group-hover:drop-shadow-[0_0_8px_rgba(0,255,136,0.5)]">
            <Image
              src="/logo.png"
              alt="AutomateQA Logo"
              fill
              className="object-contain rounded-full"
            />
          </div>
          <div>
            <span className="font-black text-sm text-white tracking-tight">
              <span className="text-white">Automate</span>
              <span className="text-[#00FF88]">QA</span>
            </span>
            <span className="block text-[10px] text-[#9CA3AF]">Admin Panel</span>
          </div>
        </Link>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-1 overflow-y-auto">
        <p className="text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest px-3 mb-3">Content</p>
        {contentItems.map(({ href, icon: Icon, label, exact }) => (
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

        <div className="pt-4">
          <p className="text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest px-3 mb-3">Analytics</p>
          {analyticsItems.map(({ href, icon: Icon, label }) => (
            <Link
              key={href}
              href={href}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 ${
                isActive(href)
                  ? "bg-[#00FF88]/10 text-[#00FF88] border border-[#00FF88]/20"
                  : "text-[#9CA3AF] hover:text-white hover:bg-white/5"
              }`}
            >
              <Icon size={16} />
              {label}
            </Link>
          ))}
        </div>

        <div className="pt-4">
          <p className="text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest px-3 mb-3">Other</p>
          <Link
            href="/admin/settings"
            className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 ${
              isActive("/admin/settings")
                ? "bg-[#00FF88]/10 text-[#00FF88] border border-[#00FF88]/20"
                : "text-[#9CA3AF] hover:text-white hover:bg-white/5"
            }`}
          >
            <Settings size={16} />
            Settings
          </Link>
          <Link href="/" className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-all">
            <Home size={16} />
            View Site
          </Link>
        </div>
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
    </aside>
  );
}
