"use client";

import { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { ArrowLeft, Loader2, RotateCcw, Undo2, Check, ExternalLink } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Game, Player, RoundScore } from "@/types";
import { computeTotals, completedRounds, winnerIds } from "@/lib/games";
import GameResults from "@/components/games/GameResults";
import GameScoreboard from "@/components/games/GameScoreboard";

type GameData = Game & {
  game_players: { seat: number; player: Player }[];
  round_scores: RoundScore[];
};

export default function GamePlayPage() {
  const { id } = useParams<{ id: string }>();
  const [supabase] = useState(createClient);

  const [game, setGame] = useState<GameData | null>(null);
  const [loading, setLoading] = useState(true);
  const [entry, setEntry] = useState<Record<string, string>>({});
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const firstInput = useRef<HTMLInputElement>(null);

  useEffect(() => {
    (async () => {
      const { data, error: err } = await supabase
        .from("games")
        .select("*, game_players!game_players_game_id_fkey(seat, player:players(*)), round_scores!round_scores_game_id_fkey(*)")
        .eq("id", id)
        .single();
      if (err) setError("Game not found.");
      setGame(data as GameData | null);
      setLoading(false);
    })();
  }, [supabase, id]);

  if (loading) {
    return <div className="flex justify-center py-20"><Loader2 className="animate-spin text-[#00FF88]" /></div>;
  }
  if (!game) {
    return (
      <div className="text-center py-20">
        <p className="text-[#9CA3AF] mb-4">{error || "Game not found."}</p>
        <Link href="/admin/games" className="btn-outline">Back to Games</Link>
      </div>
    );
  }

  const players = [...game.game_players].sort((a, b) => a.seat - b.seat).map((gp) => gp.player);
  const ids = players.map((p) => p.id);
  const scores = game.round_scores;
  const done = completedRounds(ids, scores);
  const totals = computeTotals(ids, scores);
  const leaders = done > 0 ? winnerIds(totals) : [];
  const isComplete = game.status === "completed";
  const currentRound = done + 1;
  const scoreAt = (pid: string, round: number) => scores.find((s) => s.player_id === pid && s.round === round)?.score;
  const entryValid = ids.every((pid) => /^-?\d+$/.test((entry[pid] ?? "").trim()));

  const saveRound = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!entryValid || isComplete) return;
    setSaving(true);
    setError("");
    const rows = ids.map((pid) => ({ game_id: game.id, player_id: pid, round: currentRound, score: parseInt(entry[pid], 10) }));
    const { error: err } = await supabase.from("round_scores").upsert(rows);
    if (err) { setError("Failed to save round. Please try again."); setSaving(false); return; }

    const finished = currentRound >= game.rounds;
    if (finished) {
      await supabase.from("games").update({ status: "completed", completed_at: new Date().toISOString() }).eq("id", game.id);
    }
    setGame({
      ...game,
      round_scores: [...scores.filter((s) => s.round !== currentRound), ...rows],
      ...(finished && { status: "completed" as const, completed_at: new Date().toISOString() }),
    });
    setEntry({});
    setSaving(false);
    firstInput.current?.focus();
  };

  const undoLastRound = async () => {
    if (done === 0 || !confirm(`Undo round ${done}? Its scores will be removed.`)) return;
    setError("");
    const { error: err } = await supabase.from("round_scores").delete().eq("game_id", game.id).eq("round", done);
    if (err) { setError("Failed to undo round."); return; }
    if (isComplete) {
      await supabase.from("games").update({ status: "in_progress", completed_at: null }).eq("id", game.id);
    }
    setEntry(Object.fromEntries(ids.map((pid) => [pid, String(scoreAt(pid, done) ?? "")])));
    setGame({
      ...game,
      status: "in_progress",
      completed_at: null,
      round_scores: scores.filter((s) => s.round !== done),
    });
  };

  return (
    <div className="max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link href="/admin/games" aria-label="Back to games"
          className="p-2 rounded-xl text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-all">
          <ArrowLeft size={18} />
        </Link>
        <div className="flex-1">
          <h1 className="text-xl font-black text-white">Game #{game.game_number}</h1>
          <p className="text-xs text-[#9CA3AF]">
            {isComplete ? `Completed · ${game.rounds} rounds` : `Round ${currentRound} of ${game.rounds}`} · Lowest total score wins
          </p>
        </div>
        {done > 0 && (
          <button onClick={undoLastRound}
            className="text-xs font-semibold px-3 py-2 rounded-lg bg-white/5 text-[#9CA3AF] hover:text-white hover:bg-white/10 transition-all flex items-center gap-1.5">
            <Undo2 size={13} /> Undo Round {done}
          </button>
        )}
      </div>

      {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

      {isComplete ? (
        /* ═════ RESULTS ═════ */
        <GameResults players={players} totals={totals} winners={leaders}>
          <Link href={`/admin/games/new?replay=${game.id}`} className="btn-primary justify-center">
            <RotateCcw size={16} /> Play Again
          </Link>
          <Link href={`/games/${game.id}`} target="_blank" className="btn-outline justify-center">
            <ExternalLink size={15} /> Public View
          </Link>
          <Link href="/admin/games" className="btn-outline justify-center">All Games</Link>
        </GameResults>
      ) : (
        /* ═════ SCORE ENTRY ═════ */
        <form onSubmit={saveRound} className="glass-card p-5 mb-6">
          <h2 className="text-xs font-semibold text-[#00FF88] uppercase tracking-widest mb-4">
            Round {currentRound} Scores
          </h2>
          <div className="grid sm:grid-cols-2 gap-3">
            {players.map((p, i) => (
              <label key={p.id} className="flex items-center gap-3 p-3 rounded-xl bg-[#111] border border-white/8 focus-within:border-[#00FF88]/50">
                <span className="flex-1 min-w-0">
                  <span className="block text-white font-semibold truncate">{p.name}</span>
                  <span className="block text-xs text-[#9CA3AF]">Total: {totals[p.id]}</span>
                </span>
                <input
                  ref={i === 0 ? firstInput : undefined}
                  type="text" inputMode="numeric" autoFocus={i === 0} placeholder="0"
                  value={entry[p.id] ?? ""}
                  onChange={(e) => setEntry((prev) => ({ ...prev, [p.id]: e.target.value.replace(/[^\d-]/g, "") }))}
                  aria-label={`${p.name} round ${currentRound} score`}
                  className="w-24 px-3 py-2 rounded-lg bg-[#1A1A1A] border border-[#2A2A2A] text-white text-right text-lg font-bold tabular-nums placeholder-[#3A3A3A] focus:outline-none focus:border-[#00FF88]/40"
                />
              </label>
            ))}
          </div>
          <button type="submit" disabled={!entryValid || saving}
            className="btn-primary w-full justify-center mt-4 disabled:opacity-40 disabled:pointer-events-none">
            {saving ? <Loader2 size={16} className="animate-spin" /> : <Check size={16} />}
            {currentRound >= game.rounds ? "Save Final Round" : `Save Round ${currentRound}`}
          </button>
        </form>
      )}

      {/* ═════ SCOREBOARD ═════ */}
      <GameScoreboard players={players} rounds={game.rounds} scores={scores} totals={totals}
        leaders={leaders} currentRound={isComplete ? null : currentRound} />
    </div>
  );
}
