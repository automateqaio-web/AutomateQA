"use client";

import { useRef } from "react";
import { motion, useMotionValue, useTransform, useSpring } from "framer-motion";
import Link from "next/link";
import {
  ArrowRight, Briefcase, BrainCircuit, Code2, FileText, Laugh, CheckCircle2,
} from "lucide-react";

const FEATURES = [
  {
    icon: Briefcase,
    label: "Jobs Board",
    desc: "400+ QA roles, updated daily",
    href: "/jobs",
    gradient: ["#00FF88", "#00D4FF"],
    bg: "from-[#00FF88]/10 to-[#00D4FF]/5",
    border: "border-[#00FF88]/20",
  },
  {
    icon: BrainCircuit,
    label: "Interview Prep",
    desc: "500+ curated QA questions",
    href: "/interview-prep",
    gradient: ["#A855F7", "#EC4899"],
    bg: "from-purple-500/10 to-pink-500/5",
    border: "border-purple-500/20",
  },
  {
    icon: Code2,
    label: "Learn Automation",
    desc: "Playwright, Selenium & more",
    href: "/learn",
    gradient: ["#3B82F6", "#06B6D4"],
    bg: "from-blue-500/10 to-cyan-500/5",
    border: "border-blue-500/20",
  },
  {
    icon: FileText,
    label: "QA Articles",
    desc: "Deep-dive tutorials & guides",
    href: "/blog",
    gradient: ["#F97316", "#EF4444"],
    bg: "from-orange-500/10 to-red-500/5",
    border: "border-orange-500/20",
  },
  {
    icon: Laugh,
    label: "QA Memes",
    desc: "Because bugs deserve humour",
    href: "/memes",
    gradient: ["#EAB308", "#F97316"],
    bg: "from-yellow-500/10 to-orange-500/5",
    border: "border-yellow-500/20",
  },
];

function TiltCard({ children, className }: { children: React.ReactNode; className?: string }) {
  const ref = useRef<HTMLDivElement>(null);
  const x = useMotionValue(0);
  const y = useMotionValue(0);
  const rx = useSpring(useTransform(y, [-0.5, 0.5], [8, -8]), { stiffness: 300, damping: 30 });
  const ry = useSpring(useTransform(x, [-0.5, 0.5], [-8, 8]), { stiffness: 300, damping: 30 });

  const onMove = (e: React.MouseEvent) => {
    if (!ref.current) return;
    const r = ref.current.getBoundingClientRect();
    x.set((e.clientX - r.left) / r.width - 0.5);
    y.set((e.clientY - r.top) / r.height - 0.5);
  };
  const onLeave = () => { x.set(0); y.set(0); };

  return (
    <motion.div
      ref={ref}
      onMouseMove={onMove}
      onMouseLeave={onLeave}
      style={{ rotateX: rx, rotateY: ry, transformPerspective: 800 }}
      className={className}
    >
      {children}
    </motion.div>
  );
}

export default function HomeFeatureCards() {
  return (
    <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="text-center mb-12"
      >
        <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-white/5 border border-white/10 text-[#9CA3AF] text-xs font-semibold uppercase tracking-widest mb-4">
          <CheckCircle2 size={12} className="text-[#00FF88]" /> Everything you need
        </div>
        <h2 className="text-3xl sm:text-4xl font-black text-white">
          One platform, <span className="text-gradient">zero excuses</span>
        </h2>
        <p className="text-[#9CA3AF] mt-3 max-w-lg mx-auto">
          From landing your next QA role to mastering Playwright — we&apos;ve got the community, content, and career tools.
        </p>
      </motion.div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        {FEATURES.map((f, i) => (
          <motion.div
            key={f.href}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: i * 0.08 }}
          >
            <TiltCard>
              <Link
                href={f.href}
                className={`group flex flex-col gap-3 p-5 rounded-2xl border bg-gradient-to-br ${f.bg} ${f.border} hover:scale-[1.02] transition-all duration-300 h-full`}
              >
                <div
                  className="w-11 h-11 rounded-xl flex items-center justify-center shadow-lg"
                  style={{ background: `linear-gradient(135deg,${f.gradient[0]},${f.gradient[1]})` }}
                >
                  <f.icon size={20} className="text-white" />
                </div>
                <div>
                  <p className="text-white font-bold text-sm mb-0.5">{f.label}</p>
                  <p className="text-[#6B7280] text-xs leading-relaxed">{f.desc}</p>
                </div>
                <div className="mt-auto flex items-center gap-1 text-xs font-semibold" style={{ color: f.gradient[0] }}>
                  Explore <ArrowRight size={11} className="group-hover:translate-x-1 transition-transform" />
                </div>
              </Link>
            </TiltCard>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
