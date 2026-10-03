import { formatDistanceToNow } from "date-fns";
import type { RoundScore } from "@/types";

/** Total score per player id. */
export function computeTotals(playerIds: string[], scores: RoundScore[]): Record<string, number> {
  const totals: Record<string, number> = Object.fromEntries(playerIds.map((id) => [id, 0]));
  for (const s of scores) if (s.player_id in totals) totals[s.player_id] += s.score;
  return totals;
}

/** Number of rounds where every player has a score. */
export function completedRounds(playerIds: string[], scores: RoundScore[]): number {
  const perRound = new Map<number, number>();
  for (const s of scores) perRound.set(s.round, (perRound.get(s.round) ?? 0) + 1);
  let n = 0;
  while (perRound.get(n + 1) === playerIds.length) n++;
  return n;
}

/** Lowest total wins — ties share the win. */
export function winnerIds(totals: Record<string, number>): string[] {
  const values = Object.values(totals);
  if (!values.length) return [];
  const min = Math.min(...values);
  return Object.keys(totals).filter((id) => totals[id] === min);
}

export function timeAgo(iso: string): string {
  return formatDistanceToNow(new Date(iso), { addSuffix: true });
}
