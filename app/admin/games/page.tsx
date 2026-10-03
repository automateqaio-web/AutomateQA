"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Plus, Trash2, Loader2, Dices, Trophy, ChevronRight, ExternalLink } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Game, RoundScore } from "@/types";
import { formatDate } from "@/lib/utils";
import { computeTotals, completedRounds, winnerIds } from "@/lib/games";

type GameRow = Game & {
  game_players: { seat: number; player: { id: string; name: string } }[];
  round_scores: RoundScore[];
};

export default function AdminGamesPage() {
  const [games, setGames] = useState<GameRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [supabase] = useState(createClient);

  useEffect(() => {
    (async () => {
      const { data, error: err } = await supabase
        .from("games")
        .select("*, game_players!game_players_game_id_fkey(seat, player:players(id, name)), round_scores!round_scores_game_id_fkey(*)")
        .order("created_at", { ascending: false })
        .limit(100);
      if (err) setError("Failed to load games. Has games-migration.sql been run?");
      setGames((data as GameRow[]) || []);
      setLoading(false);
    })();
  }, [supabase]);

  const handleDelete = async (id: string) => {
    if (!confirm("Delete this game and all its scores?")) return;
    await supabase.from("games").delete().eq("id", id);
    setGames((prev) => prev.filter((g) => g.id !== id));
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-8 gap-4">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2">
            <Dices size={20} className="text-[#00FF88]" /> Games
          </h1>
          <p className="text-[#9CA3AF] text-sm mt-1">Lowest total score wins</p>
        </div>
        <div className="flex items-center gap-2">
          <Link href="/games" target="_blank" className="btn-outline hidden sm:inline-flex">
            <ExternalLink size={15} /> Public History
          </Link>
          <Link href="/admin/games/new" className="btn-primary">
            <Plus size={16} /> New Game
          </Link>
        </div>
      </div>

      {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

      {loading ? (
        <div className="flex justify-center py-20"><Loader2 className="animate-spin text-[#00FF88]" /></div>
      ) : games.length === 0 ? (
        <div className="glass-card p-12 text-center">
          <Dices size={32} className="text-[#3A3A3A] mx-auto mb-3" />
          <p className="text-white font-semibold">No games yet</p>
          <p className="text-[#9CA3AF] text-sm mt-1">Start your first game to begin tracking scores.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {games.map((g) => {
            const players = [...g.game_players].sort((a, b) => a.seat - b.seat).map((gp) => gp.player);
            const ids = players.map((p) => p.id);
            const done = completedRounds(ids, g.round_scores);
            const winners = g.status === "completed" ? winnerIds(computeTotals(ids, g.round_scores)) : [];
            return (
              <div key={g.id} className="glass-card-hover flex items-center gap-4 p-4">
                <Link href={`/admin/games/${g.id}`} className="flex-1 min-w-0 flex items-center gap-4">
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="text-white font-bold">Game #{g.game_number}</span>
                      {g.status === "completed" ? (
                        <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-white/5 text-[#9CA3AF]">Completed</span>
                      ) : (
                        <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-[#00FF88]/10 text-[#00FF88]">
                          Round {Math.min(done + 1, g.rounds)} of {g.rounds}
                        </span>
                      )}
                      <span className="text-xs text-[#5A5A5A]">{formatDate(g.created_at)}</span>
                    </div>
                    <p className="text-sm text-[#9CA3AF] truncate mt-1">{players.map((p) => p.name).join(", ")}</p>
                    {winners.length > 0 && (
                      <p className="text-xs text-yellow-400 mt-1 flex items-center gap-1">
                        <Trophy size={12} /> {players.filter((p) => winners.includes(p.id)).map((p) => p.name).join(" & ")}
                      </p>
                    )}
                  </div>
                  <ChevronRight size={16} className="text-[#5A5A5A] flex-shrink-0" />
                </Link>
                <button onClick={() => handleDelete(g.id)} aria-label="Delete game"
                  className="p-2 rounded-xl text-[#5A5A5A] hover:text-red-400 hover:bg-red-500/10 transition-all flex-shrink-0">
                  <Trash2 size={15} />
                </button>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
