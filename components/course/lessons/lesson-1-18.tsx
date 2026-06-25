import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson118() {
  return (
    <>
      <TheIdea>
        <p>You've covered 17 lessons of JavaScript fundamentals. Variables, functions, loops, async/await, try/catch, destructuring — all of it.</p>
        <p>Now you use all of it at once.</p>
        <p>In this lesson you'll install Playwright, write your first real automation test, and watch a browser open automatically, go to Google, search for something, and verify the results — all in about 10 lines of code.</p>
        <p className="text-lg font-bold text-[#00FF88] mt-3">This is the moment everything clicks.</p>
      </TheIdea>

      <SeeItRun>
        <p>Here's what you're building. Run through all three steps in order.</p>

        <p className="text-sm font-bold text-white mt-6 mb-2">Step 1 — Create a project folder</p>
        <BashBlock code={`mkdir playwright-first-test
cd playwright-first-test`} />

        <p className="text-sm font-bold text-white mt-6 mb-2">Step 2 — Install Playwright</p>
        <BashBlock code="npm init playwright@latest" />
        <p className="text-sm text-[#9CA3AF] mt-2">When prompted:</p>
        <OutputBlock output={`Where to put your end-to-end tests? › tests
Add a GitHub Actions workflow? › false
Install Playwright browsers (can be done manually via 'npx playwright install')? › true`} />
        <p className="text-sm text-[#9CA3AF]">This installs Playwright and downloads the browsers. It takes 1–2 minutes. Let it finish.</p>

        <p className="text-sm font-bold text-white mt-6 mb-2">Step 3 — Write your test</p>
        <p className="text-sm text-[#9CA3AF] mb-2">Delete everything in <Code>tests/example.spec.ts</Code> and replace it with this:</p>
        <CodeBlock filename="tests/google-search.spec.ts" language="ts" code={`import { test, expect } from '@playwright/test';

test('Google search returns results', async ({ page }) => {
  // Navigate to Google
  await page.goto('https://www.google.com');

  // Find the search box and type
  await page.getByRole('combobox').fill('Playwright automation');

  // Press Enter to search
  await page.keyboard.press('Enter');

  // Wait for results and assert at least one heading is visible
  await expect(page.locator('h3').first()).toBeVisible();

  console.log('Search returned results ✓');
});`} />

        <p className="text-sm font-bold text-white mt-6 mb-2">Step 4 — Run it</p>
        <BashBlock code="npx playwright test" />
        <OutputBlock output={`Running 1 test using 1 worker

  ✓  1 [chromium] › tests/google-search.spec.ts:3 › Google search returns results (2.1s)

  1 passed (4.2s)`} />

        <p className="mt-4">Want to <em>see</em> the browser as it runs? Add <Code>--headed</Code>:</p>
        <BashBlock code="npx playwright test --headed" />

        <p className="mt-4">View a beautiful HTML report of the results:</p>
        <BashBlock code="npx playwright show-report" />
      </SeeItRun>

      <NowYouTry>
        <p>Once the Google test passes, add a second test in the same file:</p>
        <CodeBlock filename="tests/google-search.spec.ts" language="ts" code={`test('page title contains Google', async ({ page }) => {
  await page.goto('https://www.google.com');
  await expect(page).toHaveTitle(/Google/);
});`} />
        <p>Run <Code>npx playwright test</Code> again. Both tests should pass.</p>
        <Callout type="win">If you see 2 passed — congratulations. You are no longer a beginner. You've written and run real end-to-end automation that opened a real browser and verified real behaviour. That's the job of a QA automation engineer.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Let's read your test line by line with what you now know:</p>
        <div className="space-y-3 my-4">
          {[
            { line: "import { test, expect } from '@playwright/test';", explain: "Destructuring import (Lesson 1.17) — pull out just test and expect from the Playwright package." },
            { line: "test('...', async ({ page }) => {", explain: "Arrow function (1.11) + async (1.15) + destructuring { page } (1.17) — the full pattern." },
            { line: "await page.goto('...');", explain: "await (1.15) + a method that returns a Promise (1.14). Waits for navigation to complete." },
            { line: "await page.getByRole('combobox').fill('...');", explain: "Finds the search box by its ARIA role (accessibility), then fills it. await ensures it's done before moving on." },
            { line: "await page.keyboard.press('Enter');", explain: "Simulates a keyboard press. await waits for the navigation triggered by Enter to complete." },
            { line: "await expect(page.locator('h3').first()).toBeVisible();", explain: "Comparison (1.6) — asserts a result heading is visible. If it's not, this line throws and the test FAILS." },
          ].map(({ line, explain }) => (
            <div key={line} className="rounded-xl border border-white/8 bg-[#0F0F0F] p-4">
              <code className="text-xs text-[#00FF88] font-mono block mb-2 break-all">{line}</code>
              <p className="text-xs text-[#9CA3AF] leading-relaxed">{explain}</p>
            </div>
          ))}
        </div>
        <p>Every line maps to something you learned. None of it is magic.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "npm init playwright@latest installs Playwright and its browsers in one command.",
          "npx playwright test runs all .spec.ts files. --headed shows the browser window.",
          "Every concept from Part 1 is in your test: imports, async/await, destructuring, assertions.",
        ]}
        nextLesson={undefined}
      />

      <GoDeeper>
        <p className="text-base font-bold text-white mb-3">Where to go from here</p>
        <p>You've completed Phase 1. Here's what Phase 2 (coming soon) covers:</p>
        <div className="space-y-2 my-4">
          {[
            ["Locators deep-dive", "getByRole, getByLabel, getByTestId — finding elements reliably"],
            ["Page Object Model", "Organising tests so they don't become a maintenance nightmare"],
            ["Fixtures and hooks", "beforeEach, afterAll — setting up and tearing down state"],
            ["Test data management", "Factories, fixtures, environment variables"],
            ["CI/CD integration", "Running Playwright in GitHub Actions on every pull request"],
          ].map(([title, desc]) => (
            <div key={title} className="flex gap-3 rounded-lg border border-white/8 bg-[#0F0F0F] px-4 py-3">
              <span className="text-[#00FF88] font-bold text-sm flex-shrink-0">→</span>
              <div>
                <span className="text-sm font-bold text-white">{title}</span>
                <span className="text-sm text-[#9CA3AF] ml-2">— {desc}</span>
              </div>
            </div>
          ))}
        </div>
        <p className="text-sm text-[#9CA3AF]">In the meantime: practice. Change the search term. Test a different website. Add a third test. Break something and fix it. That's how automation engineers learn.</p>
        <div className="mt-6 rounded-xl border border-[#00FF88]/30 bg-[#00FF88]/5 p-6">
          <p className="text-base font-black text-[#00FF88] mb-1">You did it.</p>
          <p className="text-sm text-[#D1D5DB]">Zero to automation. One lesson at a time. Now you have a real, working Playwright test suite — and the JavaScript foundation to expand it however you want.</p>
        </div>
      </GoDeeper>
    </>
  );
}
