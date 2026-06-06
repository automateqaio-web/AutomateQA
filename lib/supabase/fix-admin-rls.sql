-- Run this in Supabase SQL Editor to lock admin access to your email only.
-- Replace the email below if it ever changes.

-- ============================================================
-- STEP 1: Drop the overly-broad "any authenticated user" policies
-- ============================================================
DROP POLICY IF EXISTS "Admins can manage memes"            ON memes;
DROP POLICY IF EXISTS "Admins can manage videos"           ON videos;
DROP POLICY IF EXISTS "Admins can manage blogs"            ON blogs;
DROP POLICY IF EXISTS "Admins can view subscribers"        ON subscribers;
DROP POLICY IF EXISTS "Admins can manage site settings"    ON site_settings;
DROP POLICY IF EXISTS "Admins can manage learning content" ON learning_content;
DROP POLICY IF EXISTS "Admins can manage automation tips"  ON automation_tips;
DROP POLICY IF EXISTS "Admins can manage youtube stats"    ON youtube_stats;
DROP POLICY IF EXISTS "Admins can manage instagram stats"  ON instagram_stats;
DROP POLICY IF EXISTS "Admins can manage viral content"    ON viral_content;
DROP POLICY IF EXISTS "Admins can manage nav settings"     ON nav_settings;
DROP POLICY IF EXISTS "Admins can manage page settings"    ON page_settings;

DROP POLICY IF EXISTS "Admin upload memes"  ON storage.objects;
DROP POLICY IF EXISTS "Admin delete memes"  ON storage.objects;
DROP POLICY IF EXISTS "Admin upload blogs"  ON storage.objects;

-- ============================================================
-- STEP 2: Create a helper function — returns true only for YOUR email
-- ============================================================
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
  SELECT auth.email() = 'automate.qa.io@gmail.com';
$$ LANGUAGE sql SECURITY DEFINER;

-- ============================================================
-- STEP 3: Re-create policies using is_admin()
-- ============================================================
CREATE POLICY "Admins can manage memes"            ON memes            FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage videos"           ON videos           FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage blogs"            ON blogs            FOR ALL USING (is_admin());
CREATE POLICY "Admins can view subscribers"        ON subscribers      FOR SELECT USING (is_admin());
CREATE POLICY "Admins can manage site settings"    ON site_settings    FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage learning content" ON learning_content FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage automation tips"  ON automation_tips  FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage youtube stats"    ON youtube_stats    FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage instagram stats"  ON instagram_stats  FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage viral content"    ON viral_content    FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage nav settings"     ON nav_settings     FOR ALL USING (is_admin());
CREATE POLICY "Admins can manage page settings"    ON page_settings    FOR ALL USING (is_admin());

CREATE POLICY "Admin upload memes" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'memes' AND is_admin());
CREATE POLICY "Admin delete memes" ON storage.objects
  FOR DELETE USING (bucket_id = 'memes' AND is_admin());
CREATE POLICY "Admin upload blogs" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'blogs' AND is_admin());

-- ============================================================
-- STEP 4: Disable public signup so nobody can self-register
-- (Do this in Supabase Dashboard → Authentication → Settings →
--  toggle OFF "Enable email signup")
-- ============================================================
