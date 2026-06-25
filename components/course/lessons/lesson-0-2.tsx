import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, Callout } from "@/components/course/LessonSections";

export default function Lesson02() {
  return (
    <>
      <TheIdea>
        <p>Imagine a factory that makes biscuits. Every biscuit needs to be checked — right shape, right colour, no burnt edges.</p>
        <p>Option A: hire a person to pick up each biscuit, look at it, and approve or reject it. This is <strong className="text-white">manual testing</strong>.</p>
        <p>Option B: install a camera and sensor system that scans every biscuit automatically at 500 per minute, 24 hours a day, without getting tired or distracted. This is <strong className="text-white">automated testing</strong>.</p>
        <p>Both do the same job. But one scales, and one doesn't.</p>
      </TheIdea>

      <SeeItRun>
        <p>Here is a real number that shows why automation exists:</p>
        <div className="rounded-xl border border-white/10 bg-[#0F0F0F] p-5 my-4 space-y-4 text-sm text-[#D1D5DB] leading-relaxed">
          <div className="flex gap-4 items-start">
            <span className="text-2xl flex-shrink-0">🏢</span>
            <div>
              <p className="font-bold text-white mb-1">Netflix — 1,000+ automated tests per code change</p>
              <p>Every time a Netflix engineer pushes code, over a thousand automated tests run automatically. They check login, video playback, recommendations, billing, and more. The entire suite finishes in minutes.</p>
              <p className="mt-2">If a manual tester had to run those same checks — clicking through the app, logging in and out, testing on different devices — it would take <strong className="text-white">weeks</strong>. Netflix releases code hundreds of times per day. Manual testing would make that impossible.</p>
            </div>
          </div>
        </div>
        <p>Automation doesn't replace testers — it multiplies them. One automated test runs forever. A manual tester can only work so many hours.</p>
      </SeeItRun>

      <NowYouTry>
        <p>No terminal needed. Think about the last app or website you used today — Google, Instagram, Zomato, anything.</p>
        <div className="rounded-xl border border-blue-500/20 bg-blue-500/5 p-5 my-4">
          <p className="text-sm font-semibold text-white mb-3">Reflection exercise</p>
          <p className="text-sm text-[#D1D5DB] mb-3">Write down <strong className="text-white">3 checks</strong> that would be:</p>
          <ul className="text-sm text-[#D1D5DB] space-y-1.5 pl-4">
            <li>• Painful to do manually every single day</li>
            <li>• Easy to automate once and forget</li>
          </ul>
          <p className="text-xs text-[#9CA3AF] italic mt-3">Example: "Does the login page load?" — boring to check manually every deploy, trivial to automate.</p>
        </div>
        <p>Those 3 checks? They're your first automation backlog. In a real job, this is how QA engineers prioritise what to automate first.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Here is why automation is a <strong className="text-white">career</strong>, not just a skill:</p>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 my-4">
          {[
            ["Manual QA Engineer", "Runs tests by hand. Limited by hours. Hard to scale. Often first to be cut."],
            ["Automation Engineer (SDET)", "Writes tests once. They run forever. Scales with the team. High demand, high salary."],
          ].map(([title, desc]) => (
            <div key={title} className="glass-card p-4">
              <p className="text-sm font-bold text-white mb-1">{title}</p>
              <p className="text-xs text-[#9CA3AF] leading-relaxed">{desc}</p>
            </div>
          ))}
        </div>
        <p>The Playwright test you'll write by Lesson 1.18 is a piece of automation. Run it once — or run it ten thousand times. Same effort from you. That's the career you're stepping into.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "Manual testing = a human checks everything. Slow, doesn't scale, gets tired.",
          "Automated testing = code checks everything. Fast, runs forever, never misses.",
          "Automation engineers are in high demand because companies ship code faster than humans can test it manually.",
        ]}
        nextLesson={{ number: "0.3", title: "What a website is made of", slug: "what-a-website-is-made-of" }}
      />

      <GoDeeper>
        <p>Not everything should be automated. A useful rule of thumb is the <strong className="text-white">Automation Pyramid</strong>:</p>
        <ul className="space-y-2 mt-2 text-sm">
          {[
            ["Unit tests (bottom, most)", "Test individual functions in isolation. Fast, cheap, hundreds of them."],
            ["Integration tests (middle)", "Test how components work together. Moderate speed."],
            ["E2E tests (top, fewest)", "Test the whole app like a real user — this is Playwright's home. Slower, more fragile, but highest confidence."],
          ].map(([name, desc]) => (
            <li key={name} className="flex gap-2"><span className="text-[#00FF88] flex-shrink-0">•</span><span><strong className="text-white">{name}</strong> — {desc}</span></li>
          ))}
        </ul>
        <p className="mt-3">Playwright writes E2E tests. They're the most visible and most satisfying — you watch a real browser click through your app.</p>
      </GoDeeper>
    </>
  );
}
