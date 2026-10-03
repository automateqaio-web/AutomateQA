"use client";

import { motion } from "framer-motion";
import { Trophy, Crown } from "lucide-react";

interface Props {
  players: { id: string; name: string }[];
  totals: Record<string, number>;
  winners: string[];
  children?: React.ReactNode;
}

/** Winner announcement + final standings. Lowest total wins; tied totals share a rank. */
export default function GameResults({ players, totals, winners, children }: Props) {
  const standings = [...players].sort((a, b) => totals[a.id] - totals[b.id]);
  const rankOf = (id: string) => standings.findIndex((p) => totals[p.id] === totals[id]) + 1;
  const winnerNames = players.filter((p) => winners.includes(p.id)).map((p) => p.name);

  return (
    <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
      className="glass-card p-6 sm:p-8 mb-6 text-center overflow-hidden relative">
      <div className="absolute inset-x-0 top-0 h-32 bg-gradient-to-b from-yellow-400/10 to-transparent pointer-events-none" />
      <motion.div initial={{ scale: 0, rotate: -20 }} animate={{ scale: 1, rotate: 0 }}
        transition={{ type: "spring", stiffness: 260, damping: 14, delay: 0.1 }}
        className="relative w-20 h-20 rounded-full bg-yellow-400/10 border border-yellow-400/30 flex items-center justify-center mx-auto mb-4 shadow-[0_0_40px_rgba(250,204,21,0.25)]">
        <Trophy size={38} className="text-yellow-400" />
      </motion.div>
      <p className="relative text-xs font-semibold text-yellow-400 uppercase tracking-widest">
        {winners.length > 1 ? "It's a tie!" : "Winner"}
      </p>
      <motion.p initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.3 }}
        className="relative text-3xl sm:text-4xl font-black text-white mt-1">
        {winnerNames.join(" & ")} {winners.length > 1 ? "win" : "wins"}! 🎉
      </motion.p>
      {winners.length > 0 && (
        <p className="relative text-[#00FF88] font-bold mt-1">Lowest total · {totals[winners[0]]} points</p>
      )}

      <ol className="relative mt-6 space-y-2 max-w-sm mx-auto text-left">
        {standings.map((p) => {
          const isWinner = winners.includes(p.id);
          return (
            <li key={p.id} className={`flex items-center gap-3 px-4 py-2.5 rounded-xl ${
              isWinner ? "bg-yellow-400/10 border border-yellow-400/30" : "bg-[#111]"
            }`}>
              <span className="w-5 text-sm font-bold text-[#9CA3AF]">
                {isWinner ? <Crown size={14} className="text-yellow-400" /> : rankOf(p.id)}
              </span>
              <span className="flex-1 text-white font-semibold">{p.name}</span>
              <span className="text-white font-black tabular-nums">{totals[p.id]}</span>
            </li>
          );
        })}
      </ol>

      {children && <div className="relative flex flex-col sm:flex-row gap-3 justify-center mt-8">{children}</div>}
    </motion.div>
  );
}
