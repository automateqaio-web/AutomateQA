-- Fix: Set technology = 'Scenario-Based' for all scenario questions
-- Run in a FRESH new tab in Supabase SQL Editor

UPDATE interview_questions
SET technology = 'Scenario-Based'
WHERE slug LIKE 'selenium-scenario-%'
  AND published = true;

-- Verify
SELECT slug, technology, question_type
FROM interview_questions
WHERE technology = 'Scenario-Based'
ORDER BY slug;
