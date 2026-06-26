-- ============================================
-- JOBS TABLE MIGRATION
-- Run in Supabase SQL editor
-- ============================================

-- Ensure pgcrypto is available for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS jobs (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title             TEXT        NOT NULL,
  company           TEXT        NOT NULL,
  location          TEXT        NOT NULL,
  description       TEXT        NOT NULL,
  apply_url         TEXT,
  source            TEXT        NOT NULL DEFAULT 'manual',   -- 'adzuna' | 'manual' | 'referral'
  job_type          TEXT        NOT NULL DEFAULT 'regular',  -- 'regular' | 'referral'
  is_remote         BOOLEAN     NOT NULL DEFAULT false,
  experience_level  TEXT,
  salary            TEXT,
  referral_contact  TEXT,
  referral_note     TEXT,
  is_active         BOOLEAN     NOT NULL DEFAULT true,
  posted_at         TIMESTAMPTZ,
  fetched_at        TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for sorting by posting date (newest first)
CREATE INDEX IF NOT EXISTS idx_jobs_posted_at
  ON jobs (posted_at DESC NULLS LAST);

-- Partial unique index: deduplicate Adzuna jobs by apply_url only
-- Manual/referral rows (often no unique URL) are intentionally excluded
CREATE UNIQUE INDEX IF NOT EXISTS idx_jobs_apply_url_adzuna
  ON jobs (apply_url)
  WHERE source = 'adzuna' AND apply_url IS NOT NULL;

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

-- Public visitors can browse active jobs (no auth required)
CREATE POLICY "Public can read active jobs" ON jobs
  FOR SELECT USING (is_active = true);

-- Authenticated admins can insert, update, delete all rows
CREATE POLICY "Admins can manage jobs" ON jobs
  FOR ALL USING (auth.role() = 'authenticated');

-- ============================================
-- OPTIONAL: Add Jobs to nav_settings
-- Run after your nav_settings table exists
-- Adjust sort_order to control position in the nav
-- ============================================

INSERT INTO nav_settings (key, label, href, enabled, sort_order)
VALUES ('jobs', 'Jobs', '/jobs', true, 9)
ON CONFLICT (key) DO NOTHING;
