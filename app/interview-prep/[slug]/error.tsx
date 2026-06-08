"use client";

import Link from "next/link";

export default function InterviewPrepError() {
  return (
    <div className="min-h-screen bg-[#0B0B0B] flex items-center justify-center px-4">
      <div className="text-center max-w-md">
        <p className="text-[#00FF88] text-sm font-bold uppercase tracking-widest mb-3">Something went wrong</p>
        <h1 className="text-2xl font-black text-white mb-4">Could not load this question</h1>
        <p className="text-[#6B7280] text-sm mb-8">
          This question may have been moved or is temporarily unavailable.
        </p>
        <Link
          href="/interview-prep"
          className="inline-flex items-center gap-2 px-5 py-2.5 bg-[#00FF88] text-black text-sm font-black rounded-lg hover:bg-[#00E67A] transition-colors"
        >
          Back to Interview Prep
        </Link>
      </div>
    </div>
  );
}
