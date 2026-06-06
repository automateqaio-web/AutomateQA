"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { Bell, ExternalLink, Play, Tv2 } from "lucide-react";

const content = [
  { emoji: "🎭", title: "QA Memes", desc: "Weekly dose of relatable testing humor" },
  { emoji: "🎬", title: "Playwright Tutorials", desc: "Step-by-step automation with real examples" },
  { emoji: "💡", title: "Selenium & API Tips", desc: "Practical tips for automation engineers" },
];

export default function YouTubeChannelPromo() {
  return (
    <section className="relative pt-4 pb-12 sm:pb-16 overflow-hidden">
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(239,68,68,0.04)_0%,transparent_70%)]" />

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          {/* Main card */}
          <div className="relative rounded-3xl border border-white/5 bg-gradient-to-br from-[#111]/90 to-[#0a0a0a] overflow-hidden">
            {/* Top accent */}
            <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-red-500/60 to-transparent" />

            {/* Glow */}
            <div className="absolute -top-20 left-1/2 -translate-x-1/2 w-80 h-40 bg-red-500/5 rounded-full blur-3xl pointer-events-none" />

            <div className="p-6 sm:p-10">
              {/* Header row */}
              <div className="flex flex-col sm:flex-row sm:items-center gap-6 sm:gap-8 mb-8">
                {/* Left — avatar + info */}
                <div className="flex items-center gap-4 sm:gap-5">
                  {/* Avatar */}
                  <div className="relative flex-shrink-0">
                    <div className="w-[72px] h-[72px] sm:w-20 sm:h-20 rounded-full overflow-hidden ring-2 ring-red-500/30 shadow-[0_0_24px_rgba(239,68,68,0.25)]">
                      <Image src="/logo.png" alt="AutomateQA YouTube channel" width={80} height={80} className="object-cover" />
                    </div>
                    {/* Play badge */}
                    <div className="absolute -bottom-1 -right-1 w-5 h-5 rounded-full bg-red-600 border-2 border-[#0a0a0a] flex items-center justify-center">
                      <Play size={7} className="text-white fill-white ml-px" />
                    </div>
                  </div>

                  {/* Channel text */}
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <span className="inline-flex items-center gap-1 text-[10px] font-bold text-red-400 bg-red-500/10 border border-red-500/20 px-2 py-0.5 rounded-full uppercase tracking-wider">
                        <Tv2 size={9} /> YouTube
                      </span>
                    </div>
                    <h2 className="text-xl sm:text-2xl font-black text-white leading-tight">AutomateQA</h2>
                    <p className="text-[#6B7280] text-xs sm:text-sm font-mono">@automateqa</p>
                    <p className="text-[#9CA3AF] text-xs sm:text-sm mt-1.5 max-w-xs leading-relaxed hidden sm:block">
                      QA memes, Playwright tutorials &amp; real corporate chaos — every week.
                    </p>
                  </div>
                </div>

                {/* Right — CTA buttons */}
                <div className="sm:ml-auto flex items-center gap-3">
                  <a
                    href="https://www.youtube.com/@automateqa?sub_confirmation=1"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-red-600 hover:bg-red-500 text-white text-sm font-bold transition-all duration-200 hover:shadow-[0_0_24px_rgba(239,68,68,0.45)] active:scale-95"
                  >
                    <Bell size={14} className="fill-white stroke-none" />
                    Subscribe
                  </a>
                  <a
                    href="https://www.youtube.com/@automateqa"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 hover:border-white/20 text-[#9CA3AF] hover:text-white text-sm font-semibold transition-all duration-200"
                  >
                    <ExternalLink size={14} />
                    <span className="hidden sm:inline">Visit Channel</span>
                    <span className="sm:hidden">Visit</span>
                  </a>
                </div>
              </div>

              {/* Mobile description */}
              <p className="text-[#9CA3AF] text-sm mb-6 sm:hidden leading-relaxed">
                QA memes, Playwright tutorials &amp; real corporate chaos — every week.
              </p>

              {/* Content types */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 pt-6 border-t border-white/5">
                {content.map(({ emoji, title, desc }) => (
                  <div key={title} className="flex items-start gap-3 p-3.5 rounded-2xl bg-white/[0.03] border border-white/5 hover:border-red-500/20 hover:bg-red-500/5 transition-all duration-200 group">
                    <span className="text-lg mt-0.5 flex-shrink-0">{emoji}</span>
                    <div>
                      <div className="text-sm font-bold text-white group-hover:text-red-300 transition-colors">{title}</div>
                      <div className="text-xs text-[#6B7280] mt-0.5 leading-relaxed">{desc}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Bottom accent */}
            <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-white/5 to-transparent" />
          </div>
        </motion.div>
      </div>
    </section>
  );
}
