"use client";

import { useState, useEffect } from "react";
import { X, Download, Smartphone } from "lucide-react";
import Image from "next/image";

interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>;
  userChoice: Promise<{ outcome: "accepted" | "dismissed" }>;
}

export default function PWAInstallPrompt() {
  const [deferredPrompt, setDeferredPrompt] = useState<BeforeInstallPromptEvent | null>(null);
  const [show, setShow] = useState(false);
  const [isIOS, setIsIOS] = useState(false);
  const [showIOSGuide, setShowIOSGuide] = useState(false);

  useEffect(() => {
    // Don't show if already installed (standalone mode)
    if (window.matchMedia("(display-mode: standalone)").matches) return;
    // Only show on mobile devices
    const isMobile = /android|iphone|ipad|ipod|mobile|tablet/i.test(navigator.userAgent)
      || (navigator.maxTouchPoints > 0 && window.innerWidth < 768);
    if (!isMobile) return;
    // Don't show if dismissed recently
    const dismissed = localStorage.getItem("pwa_prompt_dismissed");
    if (dismissed && Date.now() - parseInt(dismissed) < 7 * 24 * 60 * 60 * 1000) return;

    const ios = /iphone|ipad|ipod/i.test(navigator.userAgent) && !(window.navigator as Navigator & { standalone?: boolean }).standalone;
    if (ios) {
      setIsIOS(true);
      // Show iOS guide after 3s
      setTimeout(() => setShow(true), 3000);
      return;
    }

    const handler = (e: Event) => {
      e.preventDefault();
      setDeferredPrompt(e as BeforeInstallPromptEvent);
      setTimeout(() => setShow(true), 3000);
    };
    window.addEventListener("beforeinstallprompt", handler);
    return () => window.removeEventListener("beforeinstallprompt", handler);
  }, []);

  const handleInstall = async () => {
    if (isIOS) {
      setShowIOSGuide(true);
      return;
    }
    if (!deferredPrompt) return;
    await deferredPrompt.prompt();
    const { outcome } = await deferredPrompt.userChoice;
    if (outcome === "accepted") setShow(false);
    setDeferredPrompt(null);
  };

  const handleDismiss = () => {
    setShow(false);
    localStorage.setItem("pwa_prompt_dismissed", Date.now().toString());
  };

  if (!show) return null;

  return (
    <>
      {/* Install Banner */}
      <div className="fixed bottom-4 left-4 right-4 z-50 sm:left-auto sm:right-4 sm:w-80 animate-in slide-in-from-bottom-4 duration-300">
        <div className="bg-[#111] border border-[#00FF88]/20 rounded-2xl p-4 shadow-2xl shadow-black/50">
          <button
            onClick={handleDismiss}
            className="absolute top-3 right-3 w-6 h-6 rounded-full bg-white/5 flex items-center justify-center text-[#9CA3AF] hover:text-white transition-colors"
          >
            <X size={12} />
          </button>

          <div className="flex items-center gap-3 mb-3">
            <div className="relative w-10 h-10 flex-shrink-0">
              <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-xl" />
            </div>
            <div>
              <p className="text-sm font-bold text-white">Install AutomateQA</p>
              <p className="text-xs text-[#9CA3AF]">Add to your home screen</p>
            </div>
          </div>

          <p className="text-xs text-[#9CA3AF] mb-3 leading-relaxed">
            Get instant access to QA memes, tutorials and videos — works offline too!
          </p>

          <div className="flex gap-2">
            <button
              onClick={handleInstall}
              className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-[#00FF88] text-black text-xs font-bold hover:bg-[#00DD77] transition-all"
            >
              {isIOS ? <Smartphone size={13} /> : <Download size={13} />}
              {isIOS ? "How to Install" : "Install App"}
            </button>
            <button
              onClick={handleDismiss}
              className="px-3 py-2 rounded-xl border border-white/10 text-[#9CA3AF] text-xs hover:text-white transition-colors"
            >
              Not now
            </button>
          </div>
        </div>
      </div>

      {/* iOS Guide Modal */}
      {showIOSGuide && (
        <div className="fixed inset-0 z-[60] bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-4">
          <div className="bg-[#111] border border-white/10 rounded-2xl p-6 w-full max-w-sm">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-white font-bold">Add to Home Screen</h3>
              <button onClick={() => setShowIOSGuide(false)} className="text-[#9CA3AF] hover:text-white">
                <X size={18} />
              </button>
            </div>
            <ol className="space-y-3 text-sm text-[#9CA3AF]">
              <li className="flex gap-3">
                <span className="w-6 h-6 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs flex items-center justify-center flex-shrink-0 font-bold">1</span>
                Tap the <strong className="text-white">Share</strong> button at the bottom of Safari
              </li>
              <li className="flex gap-3">
                <span className="w-6 h-6 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs flex items-center justify-center flex-shrink-0 font-bold">2</span>
                Scroll down and tap <strong className="text-white">&quot;Add to Home Screen&quot;</strong>
              </li>
              <li className="flex gap-3">
                <span className="w-6 h-6 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs flex items-center justify-center flex-shrink-0 font-bold">3</span>
                Tap <strong className="text-white">&quot;Add&quot;</strong> in the top right corner
              </li>
            </ol>
            <button
              onClick={() => { setShowIOSGuide(false); setShow(false); }}
              className="w-full mt-5 py-2.5 rounded-xl bg-[#00FF88] text-black font-bold text-sm"
            >
              Got it!
            </button>
          </div>
        </div>
      )}
    </>
  );
}
