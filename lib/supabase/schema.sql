-- AutomateQA Database Schema
-- Run this in the Supabase SQL editor
--
-- Required .env.local keys:
--   NEXT_PUBLIC_SUPABASE_URL=
--   NEXT_PUBLIC_SUPABASE_ANON_KEY=
--   SUPABASE_SERVICE_ROLE_KEY=
--   NEXT_PUBLIC_SITE_URL=https://automateqa.dev
--   YOUTUBE_API_KEY=           (Google Cloud Console > YouTube Data API v3)
--   YOUTUBE_CHANNEL_ID=        (Your YouTube channel ID)
--   INSTAGRAM_ACCESS_TOKEN=    (Meta for Developers > Instagram Graph API)
--   INSTAGRAM_ACCOUNT_ID=      (Your Instagram Professional account ID)

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- MEMES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS memes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  caption TEXT DEFAULT '',
  image_url TEXT,
  video_url TEXT,
  category TEXT NOT NULL DEFAULT 'Corporate',
  tags TEXT[] DEFAULT '{}',
  featured BOOLEAN DEFAULT false,
  published BOOLEAN DEFAULT true,
  seo_title TEXT,
  seo_description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- VIDEOS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS videos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  youtube_url TEXT NOT NULL,
  youtube_id TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  thumbnail TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'QA Memes',
  tags TEXT[] DEFAULT '{}',
  featured BOOLEAN DEFAULT false,
  published BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- BLOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS blogs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  excerpt TEXT DEFAULT '',
  content TEXT DEFAULT '',
  cover_image TEXT,
  category TEXT NOT NULL DEFAULT 'Automation Testing',
  tags TEXT[] DEFAULT '{}',
  featured BOOLEAN DEFAULT false,
  published BOOLEAN DEFAULT false,
  read_time INT DEFAULT 5,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- SUBSCRIBERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS subscribers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- SITE SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS site_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hero_headline TEXT DEFAULT 'Automation Testing Meets Corporate Chaos',
  hero_subtitle TEXT DEFAULT 'QA memes, Playwright tutorials, Selenium tips, and real corporate pain.',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default settings
INSERT INTO site_settings (hero_headline, hero_subtitle)
VALUES ('Automation Testing Meets Corporate Chaos', 'QA memes, Playwright tutorials, Selenium tips, and real corporate pain.')
ON CONFLICT DO NOTHING;

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

-- Enable RLS on all tables
ALTER TABLE memes ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE blogs ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Public read policies (only published content)
CREATE POLICY "Public can read published memes" ON memes
  FOR SELECT USING (published = true);

CREATE POLICY "Public can read published videos" ON videos
  FOR SELECT USING (published = true);

CREATE POLICY "Public can read published blogs" ON blogs
  FOR SELECT USING (published = true);

CREATE POLICY "Public can read site settings" ON site_settings
  FOR SELECT USING (true);

-- Newsletter subscription (public insert)
CREATE POLICY "Anyone can subscribe" ON subscribers
  FOR INSERT WITH CHECK (true);

-- Admin full access (authenticated users)
CREATE POLICY "Admins can manage memes" ON memes
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage videos" ON videos
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage blogs" ON blogs
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can view subscribers" ON subscribers
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage site settings" ON site_settings
  FOR ALL USING (auth.role() = 'authenticated');

-- ============================================
-- STORAGE BUCKETS
-- ============================================

-- Create memes storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('memes', 'memes', true)
ON CONFLICT DO NOTHING;

-- Create blogs storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('blogs', 'blogs', true)
ON CONFLICT DO NOTHING;

-- Storage policies
CREATE POLICY "Public read memes storage" ON storage.objects
  FOR SELECT USING (bucket_id = 'memes');

CREATE POLICY "Admin upload memes" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'memes' AND auth.role() = 'authenticated');

CREATE POLICY "Admin delete memes" ON storage.objects
  FOR DELETE USING (bucket_id = 'memes' AND auth.role() = 'authenticated');

CREATE POLICY "Public read blogs storage" ON storage.objects
  FOR SELECT USING (bucket_id = 'blogs');

CREATE POLICY "Admin upload blogs" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'blogs' AND auth.role() = 'authenticated');

-- ============================================
-- SAMPLE DATA (Optional - for development)
-- ============================================

-- Sample videos
INSERT INTO videos (youtube_url, youtube_id, title, description, thumbnail, category, tags, featured, published) VALUES
('https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'dQw4w9WgXcQ', 'Playwright vs Selenium: Which Should You Use in 2024?', 'A deep dive comparison of the two most popular browser automation frameworks.', 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg', 'Playwright Tutorials', ARRAY['playwright', 'selenium', 'comparison', 'automation'], true, true),
('https://www.youtube.com/watch?v=jNQXAC9IVRw', 'jNQXAC9IVRw', 'When the QA Team Finds a Bug on Day 1 of Production', 'Corporate QA meme compilation for testers who feel the pain.', 'https://img.youtube.com/vi/jNQXAC9IVRw/hqdefault.jpg', 'QA Memes', ARRAY['memes', 'qa', 'production', 'bugs'], false, true)
ON CONFLICT DO NOTHING;

-- Sample memes
INSERT INTO memes (title, caption, image_url, category, tags, featured, published) VALUES
('When Dev Says "It Works On My Machine"', 'QA after finding the same bug in staging for the 5th time this week 😤', 'https://picsum.photos/seed/meme1/600/400', 'QA vs Dev', ARRAY['qa', 'dev', 'bugs', 'staging'], true, true),
('Sprint Planning Meeting Survival Guide', 'Me attending another 3-hour sprint planning when the backlog has 200 tickets', 'https://picsum.photos/seed/meme2/600/500', 'Agile', ARRAY['agile', 'sprint', 'scrum', 'meetings'], false, true),
('The Jira Ticket Life Cycle', 'Created → In Progress → In Review → Done → Reopened → In Progress again', 'https://picsum.photos/seed/meme3/600/450', 'Jira', ARRAY['jira', 'tickets', 'workflow'], true, true)
ON CONFLICT DO NOTHING;

-- ============================================
-- LEARNING CONTENT TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS learning_content (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  excerpt TEXT DEFAULT '',
  content TEXT DEFAULT '',
  cover_image TEXT,
  youtube_url TEXT,
  category TEXT NOT NULL DEFAULT 'Playwright',
  difficulty TEXT NOT NULL DEFAULT 'Beginner',
  tags TEXT[] DEFAULT '{}',
  featured BOOLEAN DEFAULT false,
  published BOOLEAN DEFAULT false,
  views INT DEFAULT 0,
  read_time INT DEFAULT 5,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- AUTOMATION TIPS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS automation_tips (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  excerpt TEXT DEFAULT '',
  content TEXT DEFAULT '',
  cover_image TEXT,
  youtube_url TEXT,
  category TEXT NOT NULL DEFAULT 'Playwright',
  difficulty TEXT NOT NULL DEFAULT 'Beginner',
  tags TEXT[] DEFAULT '{}',
  featured BOOLEAN DEFAULT false,
  published BOOLEAN DEFAULT false,
  views INT DEFAULT 0,
  read_time INT DEFAULT 3,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- YOUTUBE STATS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS youtube_stats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscribers BIGINT DEFAULT 0,
  total_views BIGINT DEFAULT 0,
  total_videos INT DEFAULT 0,
  watch_hours BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INSTAGRAM STATS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS instagram_stats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  followers BIGINT DEFAULT 0,
  total_reel_views BIGINT DEFAULT 0,
  engagement_rate NUMERIC(5,2) DEFAULT 0,
  reach BIGINT DEFAULT 0,
  impressions BIGINT DEFAULT 0,
  total_posts INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- VIRAL CONTENT TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS viral_content (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  platform TEXT NOT NULL CHECK (platform IN ('youtube', 'instagram')),
  title TEXT NOT NULL,
  thumbnail TEXT NOT NULL,
  views BIGINT DEFAULT 0,
  likes BIGINT DEFAULT 0,
  comments BIGINT DEFAULT 0,
  shares BIGINT DEFAULT 0,
  content_url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS for new tables
ALTER TABLE learning_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE automation_tips ENABLE ROW LEVEL SECURITY;
ALTER TABLE youtube_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE instagram_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE viral_content ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can read published learning content" ON learning_content
  FOR SELECT USING (published = true);
CREATE POLICY "Public can read published automation tips" ON automation_tips
  FOR SELECT USING (published = true);
CREATE POLICY "Public can read youtube stats" ON youtube_stats
  FOR SELECT USING (true);
CREATE POLICY "Public can read instagram stats" ON instagram_stats
  FOR SELECT USING (true);
CREATE POLICY "Public can read viral content" ON viral_content
  FOR SELECT USING (true);

CREATE POLICY "Admins can manage learning content" ON learning_content
  FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage automation tips" ON automation_tips
  FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage youtube stats" ON youtube_stats
  FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage instagram stats" ON instagram_stats
  FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage viral content" ON viral_content
  FOR ALL USING (auth.role() = 'authenticated');

-- ============================================
-- Sample blogs
INSERT INTO blogs (title, slug, excerpt, content, category, tags, featured, published, read_time) VALUES
('Getting Started with Playwright in 2024', 'getting-started-playwright-2024', 'Everything you need to know to start browser automation with Playwright. From installation to your first test.', '# Getting Started with Playwright in 2024

Playwright has become the go-to framework for modern browser automation. In this guide, we will cover everything you need to get started.

## Installation

```bash
npm init playwright@latest
```

## Your First Test

```typescript
import { test, expect } from "@playwright/test";

test("homepage has title", async ({ page }) => {
  await page.goto("https://example.com");
  await expect(page).toHaveTitle(/Example/);
});
```

## Running Tests

```bash
npx playwright test
```

Happy testing! 🚀', 'Playwright', ARRAY['playwright', 'automation', 'testing', 'tutorial'], true, true, 8)
ON CONFLICT DO NOTHING;
