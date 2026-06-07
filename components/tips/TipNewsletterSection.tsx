"use client";

import { useState } from "react";
import { Mail } from "lucide-react";

export default function TipNewsletterSection() {
  const [email, setEmail] = useState("");
  const [submitted, setSubmitted] = useState(false);

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!email.trim()) return;
    setSubmitted(true);
  }

  return (
    <div className="mt-16 rounded-3xl border border-[#00FF88]/15 bg-gradient-to-br from-[#00FF88]/[0.04] to-transparent p-8 sm:p-12">
      <div className="flex flex-col sm:flex-row items-center gap-6 sm:gap-10">
        <div className="flex-shrink-0 w-14 h-14 rounded-2xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center shadow-[0_0_24px_rgba(0,255,136,0.15)]">
          <Mail size={24} className="text-[#00FF88]" />
        </div>
        <div className="flex-1 text-center sm:text-left">
          <h3 className="text-white text-xl font-black mb-1">Get Weekly Automation Tips</h3>
          <p className="text-[#9CA3AF] text-sm leading-relaxed">Subscribe and get the best automation tips straight to your inbox.</p>
        </div>
        {submitted ? (
          <div className="flex items-center gap-2 text-[#00FF88] font-bold text-sm">
            <span className="w-5 h-5 rounded-full bg-[#00FF88]/20 flex items-center justify-center text-xs">✓</span>
            Subscribed!
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="flex gap-2 w-full sm:w-auto">
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Enter your email"
              required
              className="flex-1 sm:w-60 bg-[#111] border border-white/10 rounded-xl px-4 py-3 text-white text-sm placeholder-[#374151] focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
            />
            <button
              type="submit"
              className="px-5 py-3 bg-[#00FF88] text-black font-black text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all whitespace-nowrap"
            >
              Subscribe
            </button>
          </form>
        )}
      </div>
    </div>
  );
}
