-- ─────────────────────────────────────────────────────────────────────────────
-- AutomateQA — Advertisement & Promotion Management System
-- Run this in your Supabase SQL Editor
-- ─────────────────────────────────────────────────────────────────────────────

-- ── ads (main table) ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ads (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name              TEXT        NOT NULL,
  type              TEXT        NOT NULL DEFAULT 'promotion',
  title             TEXT        NOT NULL,
  subtitle          TEXT,
  description       TEXT,
  cta_text          TEXT,
  cta_link          TEXT,
  cta_open          TEXT        NOT NULL DEFAULT 'new_tab',
  desktop_image_url TEXT,
  mobile_image_url  TEXT,
  logo_url          TEXT,
  bg_color          TEXT        DEFAULT '#0D0D0D',
  gradient          TEXT,
  text_color        TEXT        DEFAULT '#FFFFFF',
  button_color      TEXT        DEFAULT '#00FF88',
  badge             TEXT,
  display_style     TEXT        NOT NULL DEFAULT 'premium_banner',
  animation         TEXT        NOT NULL DEFAULT 'fade',
  priority          INTEGER     NOT NULL DEFAULT 50 CHECK (priority BETWEEN 1 AND 100),
  is_active         BOOLEAN     NOT NULL DEFAULT true,
  impressions       BIGINT      NOT NULL DEFAULT 0,
  clicks            BIGINT      NOT NULL DEFAULT 0,
  last_viewed_at    TIMESTAMPTZ,
  last_clicked_at   TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── ad_locations ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ad_locations (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id        UUID        NOT NULL REFERENCES public.ads(id) ON DELETE CASCADE,
  location     TEXT        NOT NULL,
  css_selector TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(ad_id, location)
);

-- ── ad_schedules ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ad_schedules (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id      UUID        NOT NULL REFERENCES public.ads(id) ON DELETE CASCADE UNIQUE,
  start_date TIMESTAMPTZ,
  end_date   TIMESTAMPTZ,
  timezone   TEXT        NOT NULL DEFAULT 'Asia/Kolkata',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── ad_targeting ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ad_targeting (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id             UUID        NOT NULL REFERENCES public.ads(id) ON DELETE CASCADE UNIQUE,
  show_to_logged_in BOOLEAN     NOT NULL DEFAULT true,
  show_to_guests    BOOLEAN     NOT NULL DEFAULT true,
  devices           TEXT[]      NOT NULL DEFAULT ARRAY['desktop','mobile','tablet'],
  countries         TEXT[],
  user_type         TEXT        NOT NULL DEFAULT 'all',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── ad_analytics ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ad_analytics (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id      UUID        NOT NULL REFERENCES public.ads(id) ON DELETE CASCADE,
  event_type TEXT        NOT NULL CHECK (event_type IN ('impression','click')),
  location   TEXT,
  device     TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_ads_is_active     ON public.ads(is_active);
CREATE INDEX IF NOT EXISTS idx_ads_priority      ON public.ads(priority DESC);
CREATE INDEX IF NOT EXISTS idx_ad_locs_ad_id     ON public.ad_locations(ad_id);
CREATE INDEX IF NOT EXISTS idx_ad_locs_location  ON public.ad_locations(location);
CREATE INDEX IF NOT EXISTS idx_ad_analytics_adid ON public.ad_analytics(ad_id);
CREATE INDEX IF NOT EXISTS idx_ad_analytics_ts   ON public.ad_analytics(created_at DESC);

-- ── updated_at trigger ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.set_ads_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$;

DROP TRIGGER IF EXISTS trg_ads_updated_at ON public.ads;
CREATE TRIGGER trg_ads_updated_at
  BEFORE UPDATE ON public.ads
  FOR EACH ROW EXECUTE FUNCTION public.set_ads_updated_at();

-- ── Helper RPCs (atomic counters) ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.increment_ad_impression(ad_id_param UUID, location_param TEXT DEFAULT NULL, device_param TEXT DEFAULT NULL)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  UPDATE public.ads
     SET impressions    = impressions + 1,
         last_viewed_at = NOW()
   WHERE id = ad_id_param;

  INSERT INTO public.ad_analytics(ad_id, event_type, location, device)
  VALUES (ad_id_param, 'impression', location_param, device_param);
$$;

CREATE OR REPLACE FUNCTION public.increment_ad_click(ad_id_param UUID, location_param TEXT DEFAULT NULL, device_param TEXT DEFAULT NULL)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  UPDATE public.ads
     SET clicks          = clicks + 1,
         last_clicked_at = NOW()
   WHERE id = ad_id_param;

  INSERT INTO public.ad_analytics(ad_id, event_type, location, device)
  VALUES (ad_id_param, 'click', location_param, device_param);
$$;

-- ── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE public.ads          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ad_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ad_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ad_targeting ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ad_analytics ENABLE ROW LEVEL SECURITY;

-- Public can read active ads (for frontend rendering)
CREATE POLICY "public_read_active_ads"
  ON public.ads FOR SELECT USING (is_active = true);

-- Authenticated admin can read ALL ads (including inactive)
CREATE POLICY "auth_read_all_ads"
  ON public.ads FOR SELECT USING (auth.uid() IS NOT NULL);

-- Authenticated admin can insert / update / delete
CREATE POLICY "auth_write_ads"
  ON public.ads FOR ALL USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

-- ad_locations: public read, auth write
CREATE POLICY "public_read_ad_locations"
  ON public.ad_locations FOR SELECT USING (true);
CREATE POLICY "auth_write_ad_locations"
  ON public.ad_locations FOR ALL USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

-- ad_schedules: public read, auth write
CREATE POLICY "public_read_ad_schedules"
  ON public.ad_schedules FOR SELECT USING (true);
CREATE POLICY "auth_write_ad_schedules"
  ON public.ad_schedules FOR ALL USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

-- ad_targeting: public read, auth write
CREATE POLICY "public_read_ad_targeting"
  ON public.ad_targeting FOR SELECT USING (true);
CREATE POLICY "auth_write_ad_targeting"
  ON public.ad_targeting FOR ALL USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

-- ad_analytics: anyone can insert (tracking), auth can read
CREATE POLICY "public_insert_ad_analytics"
  ON public.ad_analytics FOR INSERT WITH CHECK (true);
CREATE POLICY "auth_read_ad_analytics"
  ON public.ad_analytics FOR SELECT USING (auth.uid() IS NOT NULL);

-- ── Supabase Storage bucket for ad images ─────────────────────────────────────
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'ads', 'ads', true,
  5242880,  -- 5 MB limit
  ARRAY['image/jpeg','image/png','image/webp','image/gif','image/svg+xml']
)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "public_read_ad_images"
  ON storage.objects FOR SELECT USING (bucket_id = 'ads');

CREATE POLICY "auth_upload_ad_images"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'ads' AND auth.role() = 'authenticated');

CREATE POLICY "auth_delete_ad_images"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'ads' AND auth.role() = 'authenticated');
