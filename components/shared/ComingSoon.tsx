import Link from "next/link";
import { Rocket, Bell, ArrowRight } from "lucide-react";

interface ComingSoonProps {
  title?: string;
  message?: string;
  pageLabel?: string;
}

export default function ComingSoon({
  title = "Coming Soon",
  message = "We are working on something amazing. Stay tuned!",
  pageLabel = "this page",
}: ComingSoonProps) {
  return (
    <div className="min-h-screen pt-24 pb-20 flex items-center justify-center relative overflow-hidden">
      {/* Background */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(0,255,136,0.06)_0%,transparent_70%)]" />
      <div className="absolute inset-0 grid-bg opacity-30" />

      {/* Floating orbs */}
      <div className="absolute top-1/3 left-1/4 w-64 h-64 bg-[#00FF88]/5 rounded-full blur-3xl animate-pulse" />
      <div className="absolute bottom-1/3 right-1/4 w-96 h-96 bg-purple-500/5 rounded-full blur-3xl animate-pulse" style={{ animationDelay: "1s" }} />

      <div className="relative z-10 max-w-lg mx-auto px-4 text-center">
        {/* Icon */}
        <div className="relative inline-flex items-center justify-center mb-8">
          <div className="absolute w-32 h-32 rounded-full bg-[#00FF88]/10 animate-ping opacity-30" />
          <div className="absolute w-24 h-24 rounded-full bg-[#00FF88]/10 animate-pulse" />
          <div className="relative w-20 h-20 rounded-2xl bg-gradient-to-br from-[#00FF88]/20 to-[#00D4FF]/20 border border-[#00FF88]/30 backdrop-blur-sm flex items-center justify-center shadow-[0_0_40px_rgba(0,255,136,0.2)]">
            <Rocket size={32} className="text-[#00FF88]" />
          </div>
        </div>

        {/* Badge */}
        <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold mb-6 tracking-wider uppercase">
          <span className="w-1.5 h-1.5 rounded-full bg-[#00FF88] animate-pulse" />
          Under Construction
        </div>

        <h1 className="text-4xl sm:text-5xl font-black text-white mb-4 leading-tight">
          {title}
        </h1>
        <p className="text-[#9CA3AF] text-lg leading-relaxed mb-10">
          {message}
        </p>

        {/* Progress bar */}
        <div className="glass-card p-5 mb-8 text-left">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-medium text-white">Build Progress</span>
            <span className="text-sm font-bold text-[#00FF88]">Coming Soon</span>
          </div>
          <div className="h-2 bg-[#1A1A1A] rounded-full overflow-hidden">
            <div className="h-full w-3/4 bg-gradient-to-r from-[#00FF88] to-[#00D4FF] rounded-full relative animate-pulse">
              <div className="absolute right-0 top-1/2 -translate-y-1/2 w-3 h-3 rounded-full bg-white shadow-neon" />
            </div>
          </div>
          <p className="text-xs text-[#9CA3AF] mt-2">Almost there — we are putting the finishing touches on {pageLabel}.</p>
        </div>

        {/* Feature teasers */}
        <div className="grid grid-cols-3 gap-3 mb-10">
          {["Premium Content", "Expert Writers", "Free Access"].map((item, i) => (
            <div key={item} className="glass-card p-3 text-center">
              <div className="w-2 h-2 rounded-full bg-[#00FF88] mx-auto mb-2 animate-pulse" style={{ animationDelay: `${i * 0.3}s` }} />
              <p className="text-xs text-[#9CA3AF] font-medium">{item}</p>
            </div>
          ))}
        </div>

        {/* CTA */}
        <div className="flex flex-col sm:flex-row gap-3 justify-center">
          <Link href="/" className="btn-primary inline-flex justify-center">
            <ArrowRight size={16} />
            Back to Home
          </Link>
          <Link href="/contact" className="btn-outline inline-flex justify-center">
            <Bell size={16} />
            Get Notified
          </Link>
        </div>
      </div>
    </div>
  );
}
