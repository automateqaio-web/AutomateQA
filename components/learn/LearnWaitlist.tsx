"use client";

import { useState } from "react";
import { BookOpen, GraduationCap, Zap, Users, ArrowRight, CheckCircle2, Loader2 } from "lucide-react";

const stats = [
  { icon: BookOpen, label: "Tutorials", value: "50+", color: "text-[#00FF88]" },
  { icon: GraduationCap, label: "Technologies", value: "15+", color: "text-purple-400" },
  { icon: Zap, label: "Beginner Friendly", value: "100%", color: "text-yellow-400" },
  { icon: Users, label: "Community", value: "Free", color: "text-blue-400" },
];

export default function LearnWaitlist() {
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState("");

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    if (!email.trim()) return;
    setLoading(true);
    try {
      const res = await fetch("/api/subscribe", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: email.trim() }),
      });
      if (res.ok || res.status === 409) {
        setDone(true);
      } else {
        const data = await res.json();
        setError(data.error || "Something went wrong. Try again.");
      }
    } catch {
      setError("Network error. Please try again.");
    }
    setLoading(false);
  }

  return (
    <div className="min-h-screen pt-20 pb-20">
      {/* Background */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(0,255,136,0.05)_0%,transparent_70%)] pointer-events-none" />

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative">
        {/* Badge */}
        <div className="flex justify-center mb-8 pt-8">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold tracking-wider">
            <span className="w-1.5 h-1.5 rounded-full bg-[#00FF88] animate-pulse" />
            COMING SOON
          </div>
        </div>

        {/* Headline */}
        <div className="text-center mb-12">
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-white mb-5 leading-tight">
            Master QA <span className="text-gradient">Automation</span>
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-2xl mx-auto leading-relaxed">
            Hands-on tutorials for Playwright, Selenium, Cypress, API Testing, CI/CD and more — written by engineers who&apos;ve shipped real tests in production.
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 max-w-2xl mx-auto mb-14">
          {stats.map(({ icon: Icon, label, value, color }) => (
            <div key={label} className="glass-card p-4 text-center">
              <Icon size={20} className={`${color} mx-auto mb-2`} />
              <div className={`text-2xl font-black ${color}`}>{value}</div>
              <div className="text-xs text-[#9CA3AF] mt-0.5">{label}</div>
            </div>
          ))}
        </div>

        {/* Email capture */}
        <div className="max-w-md mx-auto">
          <div className="glass-card p-8">
            {done ? (
              <div className="text-center py-4">
                <CheckCircle2 size={40} className="text-[#00FF88] mx-auto mb-3" />
                <h3 className="text-white font-bold text-lg mb-1">You&apos;re on the list!</h3>
                <p className="text-[#9CA3AF] text-sm">We&apos;ll notify you the moment the Learning Hub launches.</p>
              </div>
            ) : (
              <>
                <h2 className="text-white font-bold text-xl mb-2 text-center">Get Early Access</h2>
                <p className="text-[#9CA3AF] text-sm text-center mb-6">
                  Be the first to know when we launch. No spam, ever.
                </p>
                <form onSubmit={handleSubmit} className="space-y-3">
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder="you@company.com"
                    required
                    className="w-full bg-[#111] border border-white/8 rounded-xl px-4 py-3 text-white placeholder-[#374151] text-sm focus:outline-none focus:border-[#00FF88]/40 focus:ring-1 focus:ring-[#00FF88]/10 transition-all"
                  />
                  {error && <p className="text-red-400 text-xs">{error}</p>}
                  <button
                    type="submit"
                    disabled={loading || !email.trim()}
                    className="w-full flex items-center justify-center gap-2 px-6 py-3 bg-[#00FF88] text-black font-bold text-sm rounded-xl hover:bg-[#00E67A] active:scale-95 transition-all disabled:opacity-40 disabled:cursor-not-allowed"
                  >
                    {loading ? (
                      <><Loader2 size={14} className="animate-spin" /> Joining...</>
                    ) : (
                      <>Notify Me <ArrowRight size={14} /></>
                    )}
                  </button>
                </form>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
