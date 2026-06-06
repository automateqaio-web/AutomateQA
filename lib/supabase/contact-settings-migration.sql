-- Run this in Supabase SQL Editor
-- Adds contact_email and owner_email to site_settings table

ALTER TABLE site_settings
  ADD COLUMN IF NOT EXISTS contact_email TEXT DEFAULT 'automate.qa.io@gmail.com',
  ADD COLUMN IF NOT EXISTS owner_email   TEXT DEFAULT 'automate.qa.io@gmail.com';

-- Update the existing row (there should be one)
UPDATE site_settings
SET contact_email = 'automate.qa.io@gmail.com',
    owner_email   = 'nagendra.meesala.puri@gmail.com'
WHERE id = (SELECT id FROM site_settings LIMIT 1);
