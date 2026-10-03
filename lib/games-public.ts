import { createClient } from "@/lib/supabase/server";
import type { Game, RoundScore } from "@/types";

export type PublicGame = Game & {
  game_players: { seat: number; player: { id: string; name: string } }[];
  round_scores: RoundScore[];
};

const SELECT = "*, game_players(seat, player:players(id, name)), round_scores(*)";

function configured() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  return !!url && !url.includes("placeholder");
}

export async function getPublicGames(): Promise<PublicGame[]> {
  if (!configured()) return [];
  const supabase = await createClient();
  const { data, error } = await supabase.from("games").select(SELECT).order("created_at", { ascending: false }).limit(200);
  if (error) { console.error("Games fetch error:", error.message); return []; }
  return (data as PublicGame[]) || [];
}

export async function getPublicGame(id: string): Promise<PublicGame | null> {
  if (!configured() || !/^[0-9a-f-]{36}$/i.test(id)) return null;
  const supabase = await createClient();
  const { data } = await supabase.from("games").select(SELECT).eq("id", id).maybeSingle();
  return (data as PublicGame | null) ?? null;
}

export function seatedPlayers(game: PublicGame) {
  return [...game.game_players].sort((a, b) => a.seat - b.seat).map((gp) => gp.player);
}
