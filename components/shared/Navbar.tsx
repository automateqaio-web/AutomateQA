"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { Menu, X } from "lucide-react";
import Image from "next/image";

interface NavItem {
  key: string;
  label: string;
  href: string;
  enabled: boolean;
  sort_order: number;
}

const DEFAULT_NAV: NavItem[] = [
  { key: "home",    label: "Home",          href: "/",               enabled: true, sort_order: 1 },
  { key: "memes",   label: "Memes",         href: "/memes",          enabled: true, sort_order: 2 },
  { key: "videos",  label: "Videos",        href: "/videos",         enabled: true, sort_order: 3 },
  { key: "learn",   label: "Learn",         href: "/learn",          enabled: true, sort_order: 4 },
  { key: "tips",    label: "Tips & Tricks", href: "/automation-tips",enabled: true, sort_order: 5 },
  { key: "blog",    label: "Blog",          href: "/blog",           enabled: true, sort_order: 6 },
  { key: "socials", label: "Socials",        href: "/creator-stats",  enabled: true, sort_order: 7 },
  { key: "about",   label: "About",         href: "/about",          enabled: true, sort_order: 8 },
];

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [navItems, setNavItems] = useState<NavItem[]>(DEFAULT_NAV);
  const pathname = usePathname();

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  useEffect(() => {
    setIsOpen(false);
  }, [pathname]);

  useEffect(() => {
    const CACHE_KEY = "aq_nav_settings";
    const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

    const applyNav = (data: { nav: NavItem[] }) => {
      if (data?.nav?.length) {
        setNavItems(
          [...data.nav]
            .filter((n) => n.enabled)
            .sort((a, b) => a.sort_order - b.sort_order)
        );
      }
    };

    // Try cache first — instant render, no spinner
    try {
      const cached = sessionStorage.getItem(CACHE_KEY);
      if (cached) {
        const { data, ts } = JSON.parse(cached);
        if (Date.now() - ts < CACHE_TTL) {
          applyNav(data);
          return;
        }
      }
    } catch { /* skip */ }

    fetch("/api/settings")
      .then((r) => r.json())
      .then((data) => {
        applyNav(data);
        sessionStorage.setItem(CACHE_KEY, JSON.stringify({ data, ts: Date.now() }));
      })
      .catch(() => {});
  }, []);

  const LABEL_OVERRIDES: Record<string, string> = { youtube: "Socials", socials: "Socials" };
  const visibleLinks = navItems
    .filter((n) => n.enabled)
    .map((n) => ({ ...n, label: LABEL_OVERRIDES[n.key] ?? n.label }));

  return (
    <motion.header
      initial={{ y: -100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.5 }}
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-[#0B0B0B]/90 backdrop-blur-xl border-b border-white/5 shadow-2xl"
          : "bg-transparent"
      }`}
    >
      <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2.5 group">
            <div className="relative w-9 h-9 flex-shrink-0 transition-all duration-300 group-hover:scale-110 group-hover:drop-shadow-[0_0_8px_rgba(0,255,136,0.6)]">
              <Image src="/logo.png" alt="AutomateQA Logo" fill className="object-contain rounded-full" priority />
            </div>
            <span className="font-black text-lg tracking-tight">
              <span className="text-white">Automate</span>
              <span className="text-[#00FF88]">QA</span>
            </span>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden lg:flex items-center gap-0.5">
            {visibleLinks.map((link) => (
              <Link
                key={link.key}
                href={link.href}
                className={`px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200 ${
                  pathname === link.href || (link.href !== "/" && pathname.startsWith(link.href))
                    ? "text-[#00FF88] bg-[#00FF88]/10"
                    : "text-[#9CA3AF] hover:text-white hover:bg-white/5"
                }`}
              >
                {link.label}
              </Link>
            ))}
          </div>

          {/* CTA */}
          <div className="hidden lg:flex items-center gap-3">
            <Link href="/learn" className="btn-primary text-sm py-2 px-4">
              Start Learning
            </Link>
          </div>

          {/* Mobile menu button */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="lg:hidden p-2 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors"
          >
            {isOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>
      </nav>

      {/* Mobile Menu */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.2 }}
            className="lg:hidden bg-[#0B0B0B]/98 backdrop-blur-xl border-b border-white/5 max-h-[80vh] overflow-y-auto"
          >
            <div className="px-4 py-4 space-y-1">
              {visibleLinks.map((link) => (
                <Link
                  key={link.key}
                  href={link.href}
                  className={`block px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 ${
                    pathname === link.href || (link.href !== "/" && pathname.startsWith(link.href))
                      ? "text-[#00FF88] bg-[#00FF88]/10"
                      : "text-[#9CA3AF] hover:text-white hover:bg-white/5"
                  }`}
                >
                  {link.label}
                </Link>
              ))}
              <div className="pt-2">
                <Link href="/learn" className="btn-primary text-sm text-center justify-center w-full">
                  Start Learning
                </Link>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.header>
  );
}
