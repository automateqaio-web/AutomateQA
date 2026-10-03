-- ============================================================
-- Game Scorekeeper — run in Supabase SQL Editor
-- Requires is_admin() from fix-admin-rls.sql
-- ============================================================

-- Global, reusable player records (one per real person)
CREATE TABLE IF NOT EXISTS players (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name           TEXT NOT NULL CHECK (char_length(trim(name)) BETWEEN 1 AND 40),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_played_at TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS players_name_unique ON players (lower(trim(name)));

CREATE TABLE IF NOT EXISTS games (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_number  BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1001),
  rounds       INT NOT NULL CHECK (rounds BETWEEN 1 AND 50),
  status       TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS games_created_at_idx ON games (created_at DESC);

-- Game <-> player participation
CREATE TABLE IF NOT EXISTS game_players (
  game_id   UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE RESTRICT,
  seat      INT NOT NULL,
  PRIMARY KEY (game_id, player_id)
);
CREATE INDEX IF NOT EXISTS game_players_player_idx ON game_players (player_id);

CREATE TABLE IF NOT EXISTS round_scores (
  game_id   UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  player_id UUID NOT NULL,
  round     INT NOT NULL CHECK (round >= 1),
  score     INT NOT NULL,
  PRIMARY KEY (game_id, player_id, round),
  FOREIGN KEY (game_id, player_id) REFERENCES game_players(game_id, player_id) ON DELETE CASCADE
);

-- Player list with participation counts (no win rate / ranking by design)
CREATE OR REPLACE VIEW player_stats WITH (security_invoker = true) AS
SELECT p.id, p.name, p.created_at, p.last_played_at,
       COUNT(gp.game_id)::INT AS games_played
FROM players p
LEFT JOIN game_players gp ON gp.player_id = p.id
GROUP BY p.id;

ALTER TABLE players      ENABLE ROW LEVEL SECURITY;
ALTER TABLE games        ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE round_scores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can manage players"      ON players;
DROP POLICY IF EXISTS "Admins can manage games"        ON games;
DROP POLICY IF EXISTS "Admins can manage game players" ON game_players;
DROP POLICY IF EXISTS "Admins can manage round scores" ON round_scores;

CREATE POLICY "Admins can manage players"      ON players      FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins can manage games"        ON games        FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins can manage game players" ON game_players FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins can manage round scores" ON round_scores FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ============================================================
-- Public read-only access for automateqa.online/games
-- Visitors can SELECT; only is_admin() can insert/update/delete.
-- Safe to run on its own if the tables above already exist.
-- ============================================================
DROP POLICY IF EXISTS "Public can read players"      ON players;
DROP POLICY IF EXISTS "Public can read games"        ON games;
DROP POLICY IF EXISTS "Public can read game players" ON game_players;
DROP POLICY IF EXISTS "Public can read round scores" ON round_scores;

CREATE POLICY "Public can read players"      ON players      FOR SELECT USING (true);
CREATE POLICY "Public can read games"        ON games        FOR SELECT USING (true);
CREATE POLICY "Public can read game players" ON game_players FOR SELECT USING (true);
CREATE POLICY "Public can read round scores" ON round_scores FOR SELECT USING (true);
