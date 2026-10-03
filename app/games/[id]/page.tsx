import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, Radio, Eye } from "lucide-react";
import { formatDate } from "@/lib/utils";
import { computeTotals, completedRounds, winnerIds } from "@/lib/games";
import { getPublicGame, seatedPlayers } from "@/lib/games-public";
import GameResults from "@/components/games/GameResults";
import GameScoreboard from "@/components/games/GameScoreboard";
import LiveRefresh from "@/components/games/LiveRefresh";

export const dynamic = "force-dynamic";

type Props = { params: Promise<{ id: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const game = await getPublicGame((await params).id);
  return {
    title: game ? `Game #${game.game_number}` : "Game not found",
    robots: { index: false, follow: false },
  };
}

export default async function PublicGamePage({ params }: Props) {
  const game = await getPublicGame((await params).id);
  if (!game) notFound();

  const players = seatedPlayers(game);
  const ids = players.map((p) => p.id);
  const totals = computeTotals(ids, game.round_scores);
  const done = completedRounds(ids, game.round_scores);
  const isLive = game.status === "in_progress";
  const leaders = done > 0 ? winnerIds(totals) : [];

  return (
    <div className="min-h-screen pt-24 pb-16 px-4">
      {isLive && <LiveRefresh />}
      <div className="max-w-4xl mx-auto">
        <Link href="/games" className="inline-flex items-center gap-1.5 text-sm text-[#9CA3AF] hover:text-white mb-6">
          <ArrowLeft size={15} /> Game History
        </Link>

        <div className="flex items-start justify-between gap-4 mb-6 flex-wrap">
          <div>
            <h1 className="text-3xl font-black text-white">Game #{game.game_number}</h1>
            <p className="text-sm text-[#9CA3AF] mt-1">
              {formatDate(game.created_at)} · {game.rounds} rounds · Lowest total score wins
            </p>
          </div>
          <div className="flex items-center gap-2 flex-wrap">
            {isLive && (
              <span className="text-xs font-semibold px-3 py-1.5 rounded-full bg-red-500/15 text-red-400 inline-flex items-center gap-1.5">
                <Radio size={12} className="animate-pulse" /> LIVE · Round {Math.min(done + 1, game.rounds)} of {game.rounds}
              </span>
            )}
            <span className="text-xs font-semibold px-3 py-1.5 rounded-full bg-white/5 text-[#9CA3AF] inline-flex items-center gap-1.5">
              <Eye size={12} /> Read-only
            </span>
          </div>
        </div>

        {!isLive && <GameResults players={players} totals={totals} winners={leaders} />}

        <GameScoreboard players={players} rounds={game.rounds} scores={game.round_scores} totals={totals}
          leaders={leaders} currentRound={isLive ? done + 1 : null} />

        {isLive && <p className="text-xs text-[#5A5A5A] text-center mt-3">Scores update automatically</p>}
      </div>
    </div>
  );
}
