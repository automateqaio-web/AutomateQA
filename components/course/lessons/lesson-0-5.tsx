import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, BashBlock, OutputBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson05() {
  return (
    <>
      <TheIdea>
        <p>Most of the time you talk to your computer by clicking — icons, menus, buttons. That's the graphical interface, designed so you don't need to know how the computer works underneath.</p>
        <p>The terminal is a different way to talk to your computer — by <strong className="text-white">typing commands</strong> in plain text. It's more direct, more powerful, and the way every developer and tester works.</p>
        <p>Think of it like this: clicking through a restaurant menu takes time. Knowing the chef personally and saying "the usual" gets you there faster. The terminal is "the usual."</p>
        <p>It looks scary. It isn't. You only need about 6 commands to get through this entire course.</p>
      </TheIdea>

      <SeeItRun>
        <p>Here are the 6 commands you'll actually use. That's the whole list.</p>
        <div className="space-y-3 my-4">
          {[
            ["node hello.js", "Run a JavaScript file"],
            ["npm install", "Download the packages a project needs"],
            ["npm init playwright@latest", "Set up Playwright in your project"],
            ["npx playwright test", "Run your Playwright tests"],
            ["cd playwright-course", "Move into a folder (change directory)"],
            ["ls  or  dir", "List files in the current folder (ls on Mac, dir on Windows)"],
          ].map(([cmd, desc]) => (
            <div key={cmd} className="flex items-center gap-4 rounded-lg bg-[#0F0F0F] border border-white/5 px-4 py-3">
              <code className="text-[#00FF88] font-mono text-sm flex-shrink-0 w-52">{cmd}</code>
              <span className="text-sm text-[#9CA3AF]">{desc}</span>
            </div>
          ))}
        </div>
        <p>Every command in this course is one of these six. Bookmark this page.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Open your terminal right now and try these three commands one at a time. Watch what happens.</p>

        <p className="text-sm font-bold text-white mt-4 mb-2">🪟 Windows — open the terminal inside VS Code:</p>
        <ol className="text-sm text-[#D1D5DB] space-y-1 pl-4 list-decimal mb-4">
          <li>Open VS Code with your <Code>playwright-course</Code> folder</li>
          <li>Press <kbd className="bg-[#1A1A1A] border border-white/20 px-1.5 py-0.5 rounded text-xs text-white">Ctrl + `</kbd> (backtick — bottom-left of keyboard)</li>
          <li>A terminal panel opens at the bottom</li>
        </ol>

        <p className="text-sm font-bold text-white mb-2">🍎 macOS/Linux — open the terminal inside VS Code:</p>
        <ol className="text-sm text-[#D1D5DB] space-y-1 pl-4 list-decimal mb-4">
          <li>Same: open VS Code, press <kbd className="bg-[#1A1A1A] border border-white/20 px-1.5 py-0.5 rounded text-xs text-white">Ctrl + `</kbd></li>
        </ol>

        <p className="text-sm font-bold text-white mt-5 mb-2">Now type these three commands (press Enter after each):</p>

        <BashBlock code="node --version" />
        <OutputBlock output="v22.x.x" />

        <BashBlock code="npm --version" />
        <OutputBlock output="10.x.x" />

        <BashBlock code="ls" />
        <OutputBlock output="(empty — your project folder has nothing in it yet, which is correct)" />

        <Callout type="win">If you saw version numbers, your setup is perfect. You're now talking directly to your computer like a developer does.</Callout>
        <Callout type="tip">If a command isn't found — close VS Code completely and reopen it. Node.js sometimes needs a restart to be recognised.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Every Playwright command you'll ever run starts in the terminal. Here's what the end of this course looks like:</p>
        <BashBlock code="npx playwright test" />
        <OutputBlock output={`Running 5 tests using 3 workers

  ✓  tests/google-search.spec.ts:4:3 › Google search works (2.1s)
  ✓  tests/login.spec.ts:4:3 › User can log in (1.8s)
  ✓  tests/checkout.spec.ts:4:3 › Checkout completes (3.2s)

  3 passed (7.1s)`} />
        <p>That green output means your tests passed. The terminal is where you'll see it. Getting comfortable here now means that moment feels earned, not intimidating.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "The terminal lets you talk to your computer by typing — faster and more powerful than clicking.",
          "You only need 6 commands for this entire course: node, npm, npx, cd, ls/dir, and npm init.",
          "Open the terminal in VS Code with Ctrl + ` (backtick).",
        ]}
        nextLesson={{ number: "0.6", title: "Your roadmap", slug: "your-roadmap" }}
      />

      <GoDeeper>
        <p>The terminal on Windows is called <strong className="text-white">Command Prompt</strong> (cmd) or <strong className="text-white">PowerShell</strong>. On macOS/Linux it's called <strong className="text-white">Terminal</strong> or <strong className="text-white">bash/zsh</strong>.</p>
        <p className="mt-2">VS Code's built-in terminal (the one you opened with Ctrl+`) is the best option for this course — it automatically opens in your project folder, so <Code>cd</Code> is rarely needed.</p>
        <p className="mt-2">If you want to explore more commands later, search for "bash cheat sheet" — there are hundreds of useful ones. But for Playwright, the 6 above are genuinely all you need.</p>
      </GoDeeper>
    </>
  );
}
