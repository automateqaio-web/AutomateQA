"use client";

import { useState, useEffect, useMemo } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import {
  ArrowLeft, Check, Search, Plus, Star, Clock, User, Loader2, Trophy, X, Play, UserPlus,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { PlayerStats, GAME_MIN_PLAYERS, GAME_MAX_PLAYERS, GAME_MAX_ROUNDS } from "@/types";
import { timeAgo } from "@/lib/games";

const ROUND_PRESETS = [3, 5, 7, 10];
const RECENT_LIMIT = 6;
const FREQUENT_LIMIT = 3;
const FREQUENT_MIN_GAMES = 3;

type Step = 1 | 2 | 3;

export default function NewGameWizard() {
  const router = useRouter();
  const replayId = useSearchParams().get("replay");
  const [supabase] = useState(createClient);

  const [step, setStep] = useState<Step>(1);
  const [rounds, setRounds] = useState<number | null>(null);
  const [customOpen, setCustomOpen] = useState(false);
  const [customRounds, setCustomRounds] = useState("");

  const [players, setPlayers] = useState<PlayerStats[]>([]);
  const [selected, setSelected] = useState<string[]>([]);
  const [replayGameNumber, setReplayGameNumber] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [addOpen, setAddOpen] = useState(false);
  const [newName, setNewName] = useState("");
  const [adding, setAdding] = useState(false);
  const [starting, setStarting] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  useEffect(() => {
    (async () => {
      const { data, error: err } = await supabase.from("player_stats").select("*").order("name");
      if (err) setError("Failed to load players. Has games-migration.sql been run?");
      setPlayers((data as PlayerStats[]) || []);

      if (replayId) {
        const { data: prev } = await supabase
          .from("games")
          .select("game_number, rounds, game_players(player_id, seat)")
          .eq("id", replayId)
          .single();
        if (prev) {
          setReplayGameNumber(prev.game_number);
          setRounds(prev.rounds);
          setSelected(
            [...prev.game_players].sort((a, b) => a.seat - b.seat).map((gp) => gp.player_id).slice(0, GAME_MAX_PLAYERS)
          );
        }
      }
      setLoading(false);
    })();
  }, [supabase, replayId]);

  const byId = useMemo(() => new Map(players.map((p) => [p.id, p])), [players]);
  const selectedPlayers = selected.map((id) => byId.get(id)).filter((p): p is PlayerStats => !!p);

  const recent = useMemo(
    () => players.filter((p) => p.last_played_at)
      .sort((a, b) => b.last_played_at!.localeCompare(a.last_played_at!))
      .slice(0, RECENT_LIMIT),
    [players]
  );
  const frequent = useMemo(
    () => players.filter((p) => p.games_played >= FREQUENT_MIN_GAMES)
      .sort((a, b) => b.games_played - a.games_played)
      .slice(0, FREQUENT_LIMIT),
    [players]
  );
  const frequentIds = new Set(frequent.map((p) => p.id));

  const listed = useMemo(() => {
    const q = search.trim().toLowerCase();
    return players
      .filter((p) => !q || p.name.toLowerCase().includes(q))
      .sort((a, b) => b.games_played - a.games_played || a.name.localeCompare(b.name));
  }, [players, search]);

  const atMax = selected.length >= GAME_MAX_PLAYERS;

  // ── Step 1 ──
  const chooseRounds = (n: number) => {
    setRounds(n);
    setCustomOpen(false);
    // Play Again: players are already chosen, go straight to the summary
    setStep(replayGameNumber !== null && selected.length >= GAME_MIN_PLAYERS ? 3 : 2);
  };

  const submitCustom = (e: React.FormEvent) => {
    e.preventDefault();
    const n = parseInt(customRounds, 10);
    if (!Number.isInteger(n) || n < 1 || n > GAME_MAX_ROUNDS) {
      setError(`Enter a number between 1 and ${GAME_MAX_ROUNDS}`);
      return;
    }
    setError("");
    chooseRounds(n);
  };

  // ── Step 2 ──
  const toggle = (id: string) => {
    if (selected.includes(id)) {
      setSelected(selected.filter((x) => x !== id));
      setNotice("");
    } else if (selected.length >= GAME_MAX_PLAYERS) {
      setNotice(`Maximum ${GAME_MAX_PLAYERS} players per game`);
    } else {
      setSelected([...selected, id]);
      setNotice("");
    }
  };

  const selectAll = () => {
    const ids = [...selected, ...listed.map((p) => p.id).filter((id) => !selected.includes(id))];
    setSelected(ids.slice(0, GAME_MAX_PLAYERS));
    setNotice(ids.length > GAME_MAX_PLAYERS ? `Only the first ${GAME_MAX_PLAYERS} players were selected` : "");
  };

  const addPlayer = async (e: React.FormEvent) => {
    e.preventDefault();
    const name = newName.trim().replace(/\s+/g, " ");
    if (!name) return;
    if (name.length > 40) { setError("Name must be 40 characters or fewer"); return; }
    setError("");

    const existing = players.find((p) => p.name.toLowerCase() === name.toLowerCase());
    if (existing) {
      if (!selected.includes(existing.id)) toggle(existing.id);
      setNotice(`${existing.name} already exists — selected`);
      setNewName("");
      return;
    }

    setAdding(true);
    const { data, error: err } = await supabase.from("players").insert({ name }).select().single();
    setAdding(false);
    if (err || !data) { setError("Failed to add player. Please try again."); return; }

    setPlayers((prev) => [...prev, { ...data, games_played: 0 }]);
    if (selected.length < GAME_MAX_PLAYERS) setSelected((prev) => [...prev, data.id]);
    else setNotice(`${data.name} saved, but the game already has ${GAME_MAX_PLAYERS} players`);
    setNewName("");
    setSearch("");
  };

  // ── Step 3 ──
  const startGame = async () => {
    if (!rounds || selected.length < GAME_MIN_PLAYERS || selected.length > GAME_MAX_PLAYERS) return;
    setStarting(true);
    setError("");
    try {
      const { data: game, error: gErr } = await supabase.from("games").insert({ rounds }).select("id").single();
      if (gErr || !game) throw gErr;

      const { error: gpErr } = await supabase
        .from("game_players")
        .insert(selected.map((player_id, seat) => ({ game_id: game.id, player_id, seat })));
      if (gpErr) {
        await supabase.from("games").delete().eq("id", game.id);
        throw gpErr;
      }

      await supabase.from("players").update({ last_played_at: new Date().toISOString() }).in("id", selected);
      router.push(`/admin/games/${game.id}`);
    } catch {
      setError("Failed to start the game. Please try again.");
      setStarting(false);
    }
  };

  if (loading) {
    return <div className="flex justify-center py-20"><Loader2 className="animate-spin text-[#00FF88]" /></div>;
  }

  const countLabel = `${selected.length} Player${selected.length !== 1 ? "s" : ""} Selected`;

  return (
    <div className="max-w-2xl mx-auto pb-28">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        {step === 1 ? (
          <Link href="/admin/games" aria-label="Back to games"
            className="p-2 rounded-xl text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-all">
            <ArrowLeft size={18} />
          </Link>
        ) : (
          <button onClick={() => { setError(""); setStep((step - 1) as Step); }} aria-label="Back"
            className="p-2 rounded-xl text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-all">
            <ArrowLeft size={18} />
          </button>
        )}
        <div className="flex-1">
          <h1 className="text-xl font-black text-white">New Game</h1>
          <p className="text-xs text-[#9CA3AF]">Step {step} of 3</p>
        </div>
        <div className="flex gap-1.5">
          {[1, 2, 3].map((s) => (
            <span key={s} className={`h-1.5 w-6 rounded-full ${s <= step ? "bg-[#00FF88]" : "bg-white/10"}`} />
          ))}
        </div>
      </div>

      {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

      <AnimatePresence mode="wait">
        <motion.div key={step}
          initial={{ opacity: 0, x: 16 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -16 }}
          transition={{ duration: 0.15 }}>

          {/* ═════ STEP 1 — ROUNDS ═════ */}
          {step === 1 && (
            <div>
              <h2 className="text-lg font-bold text-white mb-1">How many rounds do you want to play?</h2>
              {replayGameNumber !== null && selectedPlayers.length > 0 && (
                <p className="text-sm text-[#9CA3AF] mb-1">
                  Playing again with {selectedPlayers.map((p) => p.name).join(", ")}
                </p>
              )}
              <div className="grid grid-cols-2 sm:grid-cols-5 gap-3 mt-5">
                {ROUND_PRESETS.map((n) => (
                  <button key={n} onClick={() => chooseRounds(n)}
                    className={`py-5 rounded-2xl border text-center transition-all ${
                      rounds === n && !customOpen
                        ? "bg-[#00FF88]/10 border-[#00FF88] text-[#00FF88]"
                        : "bg-[#111] border-white/10 text-white hover:border-[#00FF88]/40"
                    }`}>
                    <span className="block text-2xl font-black">{n}</span>
                    <span className="block text-xs text-[#9CA3AF] mt-0.5">Rounds</span>
                  </button>
                ))}
                <button onClick={() => setCustomOpen(true)}
                  className={`py-5 rounded-2xl border text-center transition-all col-span-2 sm:col-span-1 ${
                    customOpen || (rounds !== null && !ROUND_PRESETS.includes(rounds))
                      ? "bg-[#00FF88]/10 border-[#00FF88] text-[#00FF88]"
                      : "bg-[#111] border-white/10 text-white hover:border-[#00FF88]/40"
                  }`}>
                  <span className="block text-lg font-black">Custom</span>
                  {rounds !== null && !ROUND_PRESETS.includes(rounds) && !customOpen && (
                    <span className="block text-xs text-[#9CA3AF] mt-0.5">{rounds} Rounds</span>
                  )}
                </button>
              </div>

              {customOpen && (
                <form onSubmit={submitCustom} className="flex gap-3 mt-4">
                  <input type="number" min={1} max={GAME_MAX_ROUNDS} autoFocus inputMode="numeric"
                    value={customRounds} onChange={(e) => setCustomRounds(e.target.value)}
                    placeholder={`Rounds (1–${GAME_MAX_ROUNDS})`}
                    className="flex-1 px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#5A5A5A] text-sm focus:outline-none focus:border-[#00FF88]/40" />
                  <button type="submit" className="btn-primary">Continue</button>
                </form>
              )}
            </div>
          )}

          {/* ═════ STEP 2 — PLAYERS ═════ */}
          {step === 2 && (
            <div>
              <div className="flex items-baseline justify-between gap-3 mb-1">
                <h2 className="text-lg font-bold text-white">
                  {players.length ? "Select Players" : "Add Players"}
                </h2>
                <span className="text-xs text-[#9CA3AF]">{rounds} Rounds</span>
              </div>

              {players.length === 0 ? (
                <div className="glass-card p-8 text-center mt-4">
                  <User size={28} className="text-[#3A3A3A] mx-auto mb-2" />
                  <p className="text-[#9CA3AF] text-sm mb-5">No players have been added yet.</p>
                  {!addOpen && (
                    <button onClick={() => setAddOpen(true)} className="btn-primary mx-auto">
                      <Plus size={16} /> Add Player
                    </button>
                  )}
                </div>
              ) : (
                <p className="text-sm text-[#9CA3AF] mb-4">Choose players for this game</p>
              )}

              {/* Recent players */}
              {!search && recent.length > 0 && (
                <section className="mb-5">
                  <h3 className="text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest mb-2 flex items-center gap-1.5">
                    <Clock size={11} /> Recent Players
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {recent.map((p) => <Chip key={p.id} name={p.name} active={selected.includes(p.id)} onClick={() => toggle(p.id)} />)}
                  </div>
                </section>
              )}

              {/* Frequent players */}
              {!search && frequent.length > 0 && (
                <section className="mb-5">
                  <h3 className="text-[10px] font-semibold text-[#9CA3AF] uppercase tracking-widest mb-2 flex items-center gap-1.5">
                    <Star size={11} /> Frequent Players
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {frequent.map((p) => (
                      <Chip key={p.id} name={p.name} star active={selected.includes(p.id)} onClick={() => toggle(p.id)} />
                    ))}
                  </div>
                </section>
              )}

              {players.length > 0 && (
                <>
                  {/* Search + bulk actions */}
                  <div className="relative mb-3">
                    <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#5A5A5A]" />
                    <input type="text" value={search} onChange={(e) => setSearch(e.target.value)}
                      placeholder="Search players…"
                      className="w-full pl-10 pr-10 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#5A5A5A] text-sm focus:outline-none focus:border-[#00FF88]/40" />
                    {search && (
                      <button onClick={() => setSearch("")} aria-label="Clear search"
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-[#5A5A5A] hover:text-white">
                        <X size={15} />
                      </button>
                    )}
                  </div>
                  <div className="flex items-center justify-between mb-3">
                    <span className={`text-sm font-semibold ${selected.length >= GAME_MIN_PLAYERS ? "text-[#00FF88]" : "text-[#9CA3AF]"}`}>
                      {countLabel}
                    </span>
                    <div className="flex gap-2">
                      <button onClick={selectAll}
                        className="text-xs font-semibold px-3 py-1.5 rounded-lg bg-white/5 text-white hover:bg-white/10 transition-all">
                        Select All
                      </button>
                      <button onClick={() => { setSelected([]); setNotice(""); }} disabled={!selected.length}
                        className="text-xs font-semibold px-3 py-1.5 rounded-lg bg-white/5 text-white hover:bg-white/10 transition-all disabled:opacity-40">
                        Clear All
                      </button>
                    </div>
                  </div>
                  {notice && <p className="text-xs text-yellow-400 mb-3">{notice}</p>}

                  {/* Player cards */}
                  <div className="grid sm:grid-cols-2 gap-2">
                    {listed.map((p) => {
                      const active = selected.includes(p.id);
                      const disabled = !active && atMax;
                      return (
                        <button key={p.id} onClick={() => toggle(p.id)} aria-pressed={active}
                          className={`flex items-center gap-3 p-3.5 rounded-xl border text-left transition-all ${
                            active
                              ? "bg-[#00FF88]/10 border-[#00FF88]/60"
                              : "bg-[#111] border-white/8 hover:border-white/20"
                          } ${disabled ? "opacity-40" : ""}`}>
                          <span className={`w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 border ${
                            active ? "bg-[#00FF88] border-[#00FF88] text-[#0B0B0B]" : "border-white/20"
                          }`}>
                            {active && <Check size={14} strokeWidth={3} />}
                          </span>
                          <span className="min-w-0">
                            <span className={`flex items-center gap-1 font-semibold truncate ${active ? "text-white" : "text-[#D1D5DB]"}`}>
                              {p.name}
                              {frequentIds.has(p.id) && <Star size={12} className="text-yellow-400 fill-yellow-400 flex-shrink-0" />}
                            </span>
                            <span className="block text-xs text-[#9CA3AF] truncate">
                              Played {p.games_played} game{p.games_played !== 1 ? "s" : ""}
                              {p.last_played_at && <> · {timeAgo(p.last_played_at)}</>}
                            </span>
                          </span>
                        </button>
                      );
                    })}
                  </div>
                  {listed.length === 0 && (
                    <p className="text-sm text-[#9CA3AF] text-center py-6">
                      No players match “{search}”.{" "}
                      <button onClick={() => { setNewName(search.trim()); setAddOpen(true); }} className="text-[#00FF88] hover:underline">
                        Add “{search.trim()}” as a new player
                      </button>
                    </p>
                  )}
                </>
              )}

              {/* Add new player */}
              <div className="mt-4">
                {addOpen ? (
                  <form onSubmit={addPlayer} className="glass-card p-4">
                    <label htmlFor="new-player" className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">
                      Player Name
                    </label>
                    <div className="flex gap-2">
                      <input id="new-player" type="text" autoFocus maxLength={40} value={newName}
                        onChange={(e) => setNewName(e.target.value)} placeholder="e.g. Prakash"
                        className="flex-1 min-w-0 px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#5A5A5A] text-sm focus:outline-none focus:border-[#00FF88]/40" />
                      <button type="submit" disabled={adding || !newName.trim()} className="btn-primary disabled:opacity-50">
                        {adding ? <Loader2 size={16} className="animate-spin" /> : <UserPlus size={16} />} Add Player
                      </button>
                    </div>
                    <button type="button" onClick={() => { setAddOpen(false); setNewName(""); }}
                      className="text-xs text-[#9CA3AF] hover:text-white mt-2">
                      Done adding
                    </button>
                  </form>
                ) : players.length > 0 && (
                  <button onClick={() => setAddOpen(true)}
                    className="w-full py-3 rounded-xl border border-dashed border-white/15 text-sm font-semibold text-[#9CA3AF] hover:text-[#00FF88] hover:border-[#00FF88]/40 transition-all flex items-center justify-center gap-2">
                    <Plus size={15} /> Add New Player
                  </button>
                )}
              </div>
            </div>
          )}

          {/* ═════ STEP 3 — SUMMARY ═════ */}
          {step === 3 && (
            <div className="glass-card p-6">
              <h2 className="text-xs font-semibold text-[#00FF88] uppercase tracking-widest mb-5">Game Ready</h2>
              <div className="grid grid-cols-2 gap-4 mb-6">
                <button onClick={() => setStep(1)} className="text-left p-4 rounded-xl bg-[#111] border border-white/8 hover:border-white/20 transition-all">
                  <span className="block text-xs text-[#9CA3AF]">Rounds</span>
                  <span className="block text-3xl font-black text-white">{rounds}</span>
                </button>
                <button onClick={() => setStep(2)} className="text-left p-4 rounded-xl bg-[#111] border border-white/8 hover:border-white/20 transition-all">
                  <span className="block text-xs text-[#9CA3AF]">Players</span>
                  <span className="block text-3xl font-black text-white">{selectedPlayers.length}</span>
                </button>
              </div>
              <ul className="space-y-2 mb-6">
                {selectedPlayers.map((p) => (
                  <li key={p.id} className="flex items-center gap-2 text-white">
                    <User size={15} className="text-[#9CA3AF]" /> {p.name}
                  </li>
                ))}
              </ul>
              <p className="flex items-center gap-2 text-sm text-yellow-400 font-semibold">
                <Trophy size={15} /> Lowest total score wins
              </p>
            </div>
          )}
        </motion.div>
      </AnimatePresence>

      {/* Sticky footer action */}
      {step > 1 && (
        <div className="fixed bottom-0 left-0 right-0 md:left-64 bg-[#080808]/95 backdrop-blur border-t border-white/5 p-4">
          <div className="max-w-2xl mx-auto flex items-center gap-3">
            <button onClick={() => setStep((step - 1) as Step)} className="btn-outline">
              <ArrowLeft size={15} /> Back
            </button>
            {step === 2 ? (
              <button onClick={() => setStep(3)} disabled={selected.length < GAME_MIN_PLAYERS}
                className="btn-primary flex-1 justify-center disabled:opacity-40 disabled:pointer-events-none">
                {selected.length < GAME_MIN_PLAYERS
                  ? `Select at least ${GAME_MIN_PLAYERS} players`
                  : `Continue · ${countLabel}`}
              </button>
            ) : (
              <button onClick={startGame} disabled={starting}
                className="btn-primary flex-1 justify-center disabled:opacity-50">
                {starting ? <Loader2 size={16} className="animate-spin" /> : <Play size={16} />} Start Game
              </button>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

function Chip({ name, active, star, onClick }: { name: string; active: boolean; star?: boolean; onClick: () => void }) {
  return (
    <button onClick={onClick} aria-pressed={active}
      className={`inline-flex items-center gap-1.5 px-3.5 py-2 rounded-full text-sm font-semibold border transition-all ${
        active
          ? "bg-[#00FF88] border-[#00FF88] text-[#0B0B0B]"
          : "bg-[#111] border-white/10 text-white hover:border-[#00FF88]/40"
      }`}>
      {active ? <Check size={13} strokeWidth={3} /> : star && <Star size={12} className="text-yellow-400 fill-yellow-400" />}
      {name}
    </button>
  );
}
