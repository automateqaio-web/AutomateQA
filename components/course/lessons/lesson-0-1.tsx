import {
  TheIdea,
  SeeItRun,
  NowYouTry,
  WhyATesterCares,
  Recap,
  GoDeeper,
  Callout,
  CodeBlock,
} from "@/components/course/LessonSections";

export default function Lesson01() {
  return (
    <>
      {/* ── 1. The idea ──────────────────────────────────────────────── */}
      <TheIdea>
        <p>
          Imagine a garment factory. Hundreds of shirts roll off the production
          line every hour. Before a shirt gets boxed and shipped to a customer,
          a quality inspector picks it up, checks the stitching, looks for
          holes, and makes sure every button is in the right place.
        </p>
        <p>
          If the inspector finds a defect, the shirt goes back for repair —
          <strong className="text-white"> before</strong> the customer ever sees it.
        </p>
        <p>
          <strong className="text-white">Software testing is exactly that job</strong> —
          but for code instead of shirts. A tester checks whether the software
          does what it&apos;s supposed to do, before real users get hurt by a
          bug.
        </p>
        <p>
          The technical term for this is <strong className="text-white">software quality assurance</strong> —
          making sure the thing you ship actually works.
        </p>
      </TheIdea>

      {/* ── 2. See it run ─────────────────────────────────────────────── */}
      <SeeItRun>
        <p>
          No code today — instead, here&apos;s a real story. It&apos;s one of
          the most expensive software bugs in history.
        </p>

        <div className="rounded-xl border border-white/10 bg-[#0F0F0F] overflow-hidden my-4">
          <div className="px-5 py-3 border-b border-white/8 bg-[#161616]">
            <p className="text-xs font-bold text-[#9CA3AF] uppercase tracking-widest">
              📰 Real case study — Knight Capital Group, August 2012
            </p>
          </div>
          <div className="p-5 space-y-3 text-sm text-[#D1D5DB] leading-relaxed">
            <p>
              Knight Capital was one of the largest stock trading companies on
              Wall Street, handling billions of dollars of trades every day.
            </p>
            <p>
              On the morning of 1 August 2012, a developer deployed new trading
              software to production. The deployment accidentally left an old,
              broken piece of code active on <strong className="text-white">seven of their eight servers</strong>.
            </p>
            <p>
              Nobody tested it. Nobody caught it.
            </p>
            <p>
              At 9:30 AM, the New York Stock Exchange opened.
            </p>
            <p>
              The broken code began firing off millions of accidental stock
              orders — buying and selling shares at the wrong price, in the
              wrong direction, at incredible speed.
            </p>
            <p className="text-[#00FF88] font-semibold">
              In 45 minutes, Knight Capital lost $440 million.
            </p>
            <p>
              The company was nearly bankrupt by lunchtime and was eventually
              sold to save it from collapse. Four thousand employees&apos; jobs
              were at risk — because of one missed test.
            </p>
          </div>
        </div>

        <p>
          That bug didn&apos;t fail because programmers are bad people. It
          failed because there was no quality inspector checking the shirt
          before it shipped. That inspector is a software tester.
        </p>

        <Callout type="info">
          Knight Capital isn&apos;t a rare horror story — it&apos;s a pattern.
          NASA&apos;s Mars Climate Orbiter ($125M) was lost because of a unit
          mismatch no one tested. A UK hospital system error sent incorrect
          cancer screening results to thousands of patients. Bugs cost money,
          time, and sometimes lives. Testers exist to stop them.
        </Callout>
      </SeeItRun>

      {/* ── 3. Now you try ────────────────────────────────────────────── */}
      <NowYouTry>
        <p>
          No terminal needed for this one. Just take 2 minutes and think.
        </p>
        <div className="rounded-xl border border-blue-500/20 bg-blue-500/5 p-5 my-4">
          <p className="text-sm font-semibold text-white mb-3">Your turn — reflection exercise</p>
          <p className="text-sm text-[#D1D5DB] mb-3">
            Pick any app you use every day — WhatsApp, Swiggy, Google Pay,
            YouTube, anything.
          </p>
          <p className="text-sm text-[#D1D5DB] mb-3">
            Write down <strong className="text-white">3 things you would check</strong> before
            releasing the next version of that app to 100 million users.
          </p>
          <p className="text-xs text-[#9CA3AF] italic">
            Example: for a food delivery app — &quot;Does the checkout page show
            the correct total?&quot; &quot;Does the OTP login work?&quot;
            &quot;Does the map update when the rider moves?&quot;
          </p>
        </div>
        <p>
          Those 3 things you just wrote down? Those are <strong className="text-white">test cases</strong>.
          Congratulations — you already think like a tester.
        </p>
      </NowYouTry>

      {/* ── 4. Why a tester cares ─────────────────────────────────────── */}
      <WhyATesterCares>
        <p>
          The reason you&apos;re on this course is to automate the checking
          process so a computer does it faster than any human can. Here is a
          real Playwright test — you&apos;ll understand every word of it by
          Lesson 1.18:
        </p>
        <CodeBlock filename="google-search.spec.ts" language="ts" code={`import { test, expect } from '@playwright/test';

test('Google search works', async ({ page }) => {
  await page.goto('https://www.google.com');
  await page.getByRole('combobox').fill('Playwright');
  await page.keyboard.press('Enter');
  await expect(page.locator('h3').first()).toBeVisible();
});`} />
        <p>
          That test is your quality inspector. It opens a browser, types a
          search, presses Enter, and checks that a result appeared — all in
          about 3 seconds, automatically, every single time.
        </p>
        <p>
          Knight Capital needed hundreds of tests like this. They didn&apos;t
          have them. You&apos;re going to learn how to write them.
        </p>
      </WhyATesterCares>

      {/* ── Recap ─────────────────────────────────────────────────────── */}
      <Recap
        bullets={[
          "Software testing is checking that code works correctly before real users are affected.",
          "A missing test at Knight Capital caused a $440M loss in 45 minutes — bugs have real consequences.",
          "A test case is simply: 'I expected X to happen. Did it?'",
        ]}
        nextLesson={{
          number: "0.2",
          title: "Manual vs automated testing",
          slug: "manual-vs-automated-testing",
        }}
      />

      {/* ── Go deeper (optional) ──────────────────────────────────────── */}
      <GoDeeper>
        <p>
          There are different <strong>types</strong> of software testing, and
          professionals specialise in them:
        </p>
        <ul className="list-none space-y-2 mt-3">
          {[
            ["Functional testing", "Does the feature do what it's supposed to?"],
            ["Regression testing", "Did the new change break something old?"],
            ["Performance testing", "Does it still work when 10 million users hit it at once?"],
            ["Security testing", "Can an attacker break in or steal data?"],
            ["Accessibility testing", "Does a screen reader user get the same experience?"],
          ].map(([name, desc]) => (
            <li key={name} className="flex gap-2">
              <span className="text-[#00FF88] font-bold flex-shrink-0">•</span>
              <span>
                <strong className="text-white">{name}</strong> — {desc}
              </span>
            </li>
          ))}
        </ul>
        <p className="mt-3">
          This course focuses on <strong className="text-white">functional automation testing</strong> using
          Playwright — the most in-demand skill for QA engineers right now.
        </p>
        <p>
          The role that writes automated tests is called an{" "}
          <strong className="text-white">SDET</strong> (Software Development Engineer in Test)
          or <strong className="text-white">QA Automation Engineer</strong>. Salaries for this
          role in India range from ₹6–25 LPA depending on experience.
        </p>
      </GoDeeper>
    </>
  );
}
