import { Crown } from "lucide-react";
import type { RoundScore } from "@/types";

interface Props {
  players: { id: string; name: string }[];
  rounds: number;
  scores: RoundScore[];
  totals: Record<string, number>;
  leaders: string[];
  /** Round being played, highlighted in the header; null when the game is over. */
  currentRound: number | null;
}

export default function GameScoreboard({ players, rounds, scores, totals, leaders, currentRound }: Props) {
  const roundCols = Array.from({ length: rounds }, (_, i) => i + 1);
  const scoreAt = (pid: string, round: number) => scores.find((s) => s.player_id === pid && s.round === round)?.score;

  return (
    <div className="glass-card overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-white/5 text-[#9CA3AF] text-xs">
            <th className="text-left font-semibold px-4 py-3 sticky left-0 bg-[#0D0D0D]">Player</th>
            {roundCols.map((r) => (
              <th key={r} className={`font-semibold px-3 py-3 text-center ${r === currentRound ? "text-[#00FF88]" : ""}`}>
                R{r}
              </th>
            ))}
            <th className="font-semibold px-4 py-3 text-right">Total</th>
          </tr>
        </thead>
        <tbody>
          {players.map((p) => (
            <tr key={p.id} className="border-b border-white/5 last:border-0">
              <td className="px-4 py-3 text-white font-semibold whitespace-nowrap sticky left-0 bg-[#0D0D0D]">
                <span className="inline-flex items-center gap-1.5">
                  {leaders.includes(p.id) && <Crown size={13} className="text-yellow-400" />}
                  {p.name}
                </span>
              </td>
              {roundCols.map((r) => (
                <td key={r} className="px-3 py-3 text-center text-[#D1D5DB] tabular-nums">
                  {scoreAt(p.id, r) ?? <span className="text-[#3A3A3A]">–</span>}
                </td>
              ))}
              <td className={`px-4 py-3 text-right font-black tabular-nums ${leaders.includes(p.id) ? "text-[#00FF88]" : "text-white"}`}>
                {totals[p.id]}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
