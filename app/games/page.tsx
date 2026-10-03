import type { Metadata } from "next";
import Link from "next/link";
import { Dices, Trophy, ChevronRight, Radio } from "lucide-react";
import { formatDate } from "@/lib/utils";
import { computeTotals, completedRounds, winnerIds } from "@/lib/games";
import { getPublicGames, seatedPlayers } from "@/lib/games-public";
import LiveRefresh from "@/components/games/LiveRefresh";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "Game History",
  description: "Scores and winners from every game. Lowest total score wins.",
  robots: { index: false, follow: false },
};

export default async function GamesHistoryPage() {
  const games = await getPublicGames();
  const hasLive = games.some((g) => g.status === "in_progress");
  const completedCount = games.length - games.filter((g) => g.status === "in_progress").length;

  return (
    <div className="min-h-screen pt-24 pb-16 px-4">
      {hasLive && <LiveRefresh />}
      <div className="max-w-3xl mx-auto">
        <div className="mb-8">
          <h1 className="text-3xl font-black text-white flex items-center gap-3">
            <Dices size={26} className="text-[#00FF88]" /> Game History
          </h1>
          <p className="text-[#9CA3AF] text-sm mt-2">
            {completedCount} game{completedCount !== 1 ? "s" : ""} played · Lowest total score wins
          </p>
        </div>

        {games.length === 0 ? (
          <div className="glass-card p-12 text-center">
            <Dices size={32} className="text-[#3A3A3A] mx-auto mb-3" />
            <p className="text-white font-semibold">No games yet</p>
            <p className="text-[#9CA3AF] text-sm mt-1">Results will appear here once a game is played.</p>
          </div>
        ) : (
          <div className="space-y-3">
            {games.map((g) => {
              const players = seatedPlayers(g);
              const ids = players.map((p) => p.id);
              const totals = computeTotals(ids, g.round_scores);
              const done = completedRounds(ids, g.round_scores);
              const isLive = g.status === "in_progress";
              const top = done > 0 ? winnerIds(totals) : [];
              const topNames = players.filter((p) => top.includes(p.id)).map((p) => p.name).join(" & ");

              return (
                <Link key={g.id} href={`/games/${g.id}`} className="glass-card-hover flex items-center gap-4 p-4 sm:p-5">
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="text-white font-bold">Game #{g.game_number}</span>
                      {isLive ? (
                        <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-red-500/15 text-red-400 inline-flex items-center gap-1">
                          <Radio size={10} className="animate-pulse" /> LIVE · Round {Math.min(done + 1, g.rounds)} of {g.rounds}
                        </span>
                      ) : (
                        <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-white/5 text-[#9CA3AF]">
                          {g.rounds} rounds
                        </span>
                      )}
                      <span className="text-xs text-[#5A5A5A]">{formatDate(g.created_at)}</span>
                    </div>
                    <p className="text-sm text-[#9CA3AF] truncate mt-1">{players.map((p) => p.name).join(", ")}</p>
                    {top.length > 0 && (isLive ? (
                      <p className="text-xs text-[#00FF88] mt-1.5">Leading: {topNames} · {totals[top[0]]} pts</p>
                    ) : (
                      <p className="text-sm text-yellow-400 font-semibold mt-1.5 flex items-center gap-1.5">
                        <Trophy size={14} /> Winner: {topNames} · {totals[top[0]]} pts
                      </p>
                    ))}
                  </div>
                  <ChevronRight size={16} className="text-[#5A5A5A] flex-shrink-0" />
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
