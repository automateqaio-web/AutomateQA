export default function OfflinePage() {
  return (
    <div className="min-h-screen bg-[#0B0B0B] flex items-center justify-center px-4">
      <div className="text-center max-w-md">
        <div className="text-7xl mb-6">📡</div>
        <h1 className="text-3xl font-black text-white mb-3">You&apos;re Offline</h1>
        <p className="text-[#9CA3AF] text-base mb-8 leading-relaxed">
          Looks like you lost your connection. Check your network and try again — the QA memes will be waiting.
        </p>
        <button
          onClick={() => window.location.reload()}
          className="px-6 py-3 rounded-xl bg-[#00FF88] text-black font-bold text-sm hover:bg-[#00DD77] transition-all"
        >
          Try Again
        </button>
      </div>
    </div>
  );
}
