"use client";

import { useEffect, useState, useRef } from "react";
import { useRouter, usePathname } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Loader2, Lock, AlertTriangle } from "lucide-react";
import Image from "next/image";

const MAX_ATTEMPTS = 5;
const LOCKOUT_MS = 5 * 60 * 1000; // 5 minutes

export default function AdminGuard({ children }: { children: React.ReactNode }) {
  const [loading, setLoading] = useState(true);
  const [authenticated, setAuthenticated] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [signing, setSigning] = useState(false);
  const [attempts, setAttempts] = useState(0);
  const [lockedUntil, setLockedUntil] = useState<number | null>(null);
  const [countdown, setCountdown] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const pathname = usePathname();
  const router = useRouter();
  const supabase = createClient();

  // Restore lockout from localStorage
  useEffect(() => {
    const stored = localStorage.getItem("admin_lockout");
    if (stored) {
      const until = parseInt(stored);
      if (until > Date.now()) {
        setLockedUntil(until);
      } else {
        localStorage.removeItem("admin_lockout");
      }
    }
    const storedAttempts = localStorage.getItem("admin_attempts");
    if (storedAttempts) setAttempts(parseInt(storedAttempts));
  }, []);

  // Countdown timer when locked out
  useEffect(() => {
    if (!lockedUntil) return;
    const tick = () => {
      const remaining = Math.ceil((lockedUntil - Date.now()) / 1000);
      if (remaining <= 0) {
        setLockedUntil(null);
        setAttempts(0);
        localStorage.removeItem("admin_lockout");
        localStorage.removeItem("admin_attempts");
        if (timerRef.current) clearInterval(timerRef.current);
      } else {
        setCountdown(remaining);
      }
    };
    tick();
    timerRef.current = setInterval(tick, 1000);
    return () => { if (timerRef.current) clearInterval(timerRef.current); };
  }, [lockedUntil]);

  useEffect(() => {
    const checkAuth = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      setAuthenticated(!!user);
      setLoading(false);
    };
    checkAuth();

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_, session) => {
      setAuthenticated(!!session?.user);
    });
    return () => subscription.unsubscribe();
  }, []);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (lockedUntil) return;

    setSigning(true);
    setError("");

    const { error } = await supabase.auth.signInWithPassword({ email, password });

    if (error) {
      const newAttempts = attempts + 1;
      setAttempts(newAttempts);
      localStorage.setItem("admin_attempts", String(newAttempts));

      if (newAttempts >= MAX_ATTEMPTS) {
        const until = Date.now() + LOCKOUT_MS;
        setLockedUntil(until);
        localStorage.setItem("admin_lockout", String(until));
        setError("");
      } else {
        setError(`Invalid credentials. ${MAX_ATTEMPTS - newAttempts} attempt${MAX_ATTEMPTS - newAttempts === 1 ? "" : "s"} remaining.`);
      }
    } else {
      setAttempts(0);
      localStorage.removeItem("admin_attempts");
      localStorage.removeItem("admin_lockout");
      setAuthenticated(true);
    }
    setSigning(false);
  };

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    setAuthenticated(false);
    router.push("/");
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#0B0B0B] flex items-center justify-center">
        <Loader2 size={32} className="text-[#00FF88] animate-spin" />
      </div>
    );
  }

  if (!authenticated) {
    return (
      <div className="min-h-screen bg-[#0B0B0B] flex items-center justify-center p-4">
        <div className="w-full max-w-sm">
          {/* Logo */}
          <div className="text-center mb-8">
            <div className="relative w-20 h-20 mx-auto mb-4 drop-shadow-[0_0_16px_rgba(0,255,136,0.4)]">
              <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" priority />
            </div>
            <h1 className="text-2xl font-black text-white">
              Automate<span className="text-[#00FF88]">QA</span>
            </h1>
            <p className="text-[#9CA3AF] text-sm mt-1">Admin Control Panel</p>
          </div>

          <div className="glass-card p-6">
            {lockedUntil ? (
              <div className="text-center py-4">
                <div className="w-12 h-12 rounded-xl bg-red-500/10 border border-red-500/20 flex items-center justify-center mx-auto mb-3">
                  <Lock size={20} className="text-red-400" />
                </div>
                <p className="text-white font-bold mb-1">Account Locked</p>
                <p className="text-[#9CA3AF] text-sm mb-3">Too many failed attempts.</p>
                <div className="text-3xl font-black text-red-400 mb-1">
                  {Math.floor(countdown / 60)}:{String(countdown % 60).padStart(2, "0")}
                </div>
                <p className="text-[#9CA3AF] text-xs">Try again after the timer expires</p>
              </div>
            ) : (
              <form onSubmit={handleLogin} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Email</label>
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    autoComplete="username"
                    placeholder="admin@automateqa.dev"
                    className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Password</label>
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    autoComplete="current-password"
                    placeholder="••••••••"
                    className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all"
                  />
                </div>
                {error && (
                  <div className="flex items-center gap-2 text-red-400 text-sm bg-red-500/10 border border-red-500/20 rounded-lg px-3 py-2">
                    <AlertTriangle size={14} />
                    {error}
                  </div>
                )}
                {attempts > 0 && !error && (
                  <div className="w-full bg-[#1A1A1A] rounded-full h-1">
                    <div
                      className="h-1 rounded-full bg-red-500 transition-all"
                      style={{ width: `${(attempts / MAX_ATTEMPTS) * 100}%` }}
                    />
                  </div>
                )}
                <button
                  type="submit"
                  disabled={signing}
                  className="btn-primary w-full justify-center py-3"
                >
                  {signing ? <Loader2 size={16} className="animate-spin" /> : "Sign In"}
                </button>
              </form>
            )}
          </div>

          <p className="text-center text-[#4b5563] text-xs mt-6">
            Access restricted. Unauthorized entry is logged.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="contents">
      {/* Hidden sign-out available via keyboard: not linked publicly */}
      <div className="hidden" data-admin-signout onClick={handleSignOut} />
      {children}
    </div>
  );
}
