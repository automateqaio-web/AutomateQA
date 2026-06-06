-- Run this in Supabase SQL Editor

-- Nav Settings Table
CREATE TABLE IF NOT EXISTS nav_settings (
  key TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  href TEXT NOT NULL,
  enabled BOOLEAN DEFAULT true,
  sort_order INT DEFAULT 0
);

ALTER TABLE nav_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can read nav settings" ON nav_settings FOR SELECT USING (true);
CREATE POLICY "Admins can manage nav settings" ON nav_settings FOR ALL USING (auth.role() = 'authenticated');

INSERT INTO nav_settings (key, label, href, enabled, sort_order) VALUES
('home',    'Home',         '/',                 true, 1),
('memes',   'Memes',        '/memes',            true, 2),
('videos',  'Videos',       '/videos',           true, 3),
('learn',   'Learn',        '/learn',            true, 4),
('tips',    'Tips & Tricks','/automation-tips',  true, 5),
('blog',    'Blog',         '/blog',             true, 6),
('youtube', 'YouTube',      '/creator-stats',    true, 7),
('about',   'About',        '/about',            true, 8)
ON CONFLICT DO NOTHING;

-- Page Settings Table
CREATE TABLE IF NOT EXISTS page_settings (
  key TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  coming_soon BOOLEAN DEFAULT false,
  coming_soon_title TEXT DEFAULT 'Coming Soon',
  coming_soon_message TEXT DEFAULT 'We are working on something amazing. Stay tuned!'
);

ALTER TABLE page_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can read page settings" ON page_settings FOR SELECT USING (true);
CREATE POLICY "Admins can manage page settings" ON page_settings FOR ALL USING (auth.role() = 'authenticated');

INSERT INTO page_settings (key, label, coming_soon, coming_soon_title, coming_soon_message) VALUES
('learn',  'Learning Hub',     false, 'Tutorials Coming Soon',  'We are crafting hands-on QA automation tutorials. Stay tuned!'),
('tips',   'Automation Tips',  false, 'Tips Coming Soon',       'Automation tips and tricks are on their way. Check back soon!'),
('blog',   'Blog',             false, 'Blog Coming Soon',       'Our QA blog is coming soon with in-depth articles and guides.'),
('memes',  'QA Memes',         false, 'Memes Coming Soon',      'The meme vault is being filled. Come back for some laughs!'),
('videos', 'Videos',           false, 'Videos Coming Soon',     'Video content is on its way. Subscribe to our YouTube channel!')
ON CONFLICT DO NOTHING;
