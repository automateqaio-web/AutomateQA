-- Fix: Set technology = 'TestNG' for TestNG-specific questions
-- Run this in a FRESH new tab in Supabase SQL Editor
-- This makes the TestNG filter button work immediately on the live site

UPDATE interview_questions
SET technology = 'TestNG'
WHERE technology = 'Selenium'
  AND published = true
  AND (
    slug LIKE '%testng%'
    OR slug = 'selenium-q101-run-test-multiple-times-loop'
  );

-- Verify the update:
SELECT slug, technology
FROM interview_questions
WHERE technology = 'TestNG'
ORDER BY slug;
