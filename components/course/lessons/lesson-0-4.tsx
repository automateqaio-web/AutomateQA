import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, Screenshot, Callout } from "@/components/course/LessonSections";

export default function Lesson04() {
  return (
    <>
      <TheIdea>
        <p>Before a chef can cook, they need a kitchen — an oven, a knife, a chopping board. Before you can write automation, you need three things on your computer:</p>
        <ul className="space-y-2 mt-2">
          {[
            ["Node.js", "The engine that runs JavaScript on your computer (outside of a browser)."],
            ["VS Code", "The editor where you write your code — like Microsoft Word, but for code."],
            ["A project folder", "The place where all your files live together."],
          ].map(([name, desc]) => (
            <li key={name} className="flex gap-2 text-sm"><span className="text-[#00FF88] font-bold flex-shrink-0 w-20">{name}</span><span className="text-[#D1D5DB]">{desc}</span></li>
          ))}
        </ul>
        <p className="mt-3">This lesson installs all three. Take your time — you only do this once.</p>
      </TheIdea>

      <SeeItRun>
        <p>By the end of this lesson, you'll type this command and see a version number — proof that Node.js is installed and ready:</p>
        <div className="rounded-xl border border-[#00FF88]/25 overflow-hidden my-4 font-mono text-sm">
          <div className="px-4 py-2 bg-[#00FF88]/10 border-b border-[#00FF88]/20"><span className="text-[10px] font-bold text-[#00FF88] tracking-widest uppercase">Terminal — your target</span></div>
          <pre className="bg-[#0A1A0F] p-4"><code className="text-[#00FF88]">{`$ node --version
v22.x.x        ← you'll see something like this`}</code></pre>
        </div>
        <p>That output means your computer can now run JavaScript. Everything else follows from this.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Follow every step below for your operating system. Each step has a screenshot placeholder — those images will guide you exactly where to click.</p>

        {/* Windows */}
        <div className="mt-6 mb-8">
          <h3 className="text-base font-black text-white mb-4 flex items-center gap-2">
            <span className="text-lg">🪟</span> Windows
          </h3>

          <div className="space-y-6">
            <div>
              <p className="text-sm font-bold text-white mb-2">Step 1 — Download Node.js</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Open your browser and go to <span className="text-[#00FF88] font-mono">nodejs.org</span></li>
                <li>Click the big green <strong className="text-white">LTS</strong> button (Long Term Support — the stable version)</li>
                <li>A <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">.msi</code> file will download</li>
              </ol>
              <Screenshot description="nodejs.org homepage with the LTS download button highlighted" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 2 — Install Node.js</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Double-click the downloaded <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">.msi</code> file</li>
                <li>Click <strong className="text-white">Next</strong> on every screen — the defaults are fine</li>
                <li>Click <strong className="text-white">Install</strong>, then <strong className="text-white">Finish</strong></li>
              </ol>
              <Screenshot description="Node.js Windows installer showing the Next button" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 3 — Verify Node.js</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Press <kbd className="bg-[#1A1A1A] border border-white/20 px-1.5 py-0.5 rounded text-xs text-white">Win + R</kbd>, type <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">cmd</code>, press Enter</li>
                <li>In the black window that opens, type: <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">node --version</code></li>
                <li>Press Enter — you should see <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">v22.x.x</code></li>
              </ol>
              <Screenshot description="Windows Command Prompt showing node --version output" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 4 — Download VS Code</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Go to <span className="text-[#00FF88] font-mono">code.visualstudio.com</span></li>
                <li>Click <strong className="text-white">Download for Windows</strong></li>
                <li>Run the installer — click Next/Install/Finish as before</li>
              </ol>
              <Screenshot description="VS Code download page for Windows" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 5 — Create your project folder</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Open VS Code</li>
                <li>Click <strong className="text-white">File → Open Folder</strong></li>
                <li>Navigate to Desktop (or Documents), click <strong className="text-white">New Folder</strong>, name it <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">playwright-course</code></li>
                <li>Click <strong className="text-white">Select Folder</strong></li>
              </ol>
              <Screenshot description="VS Code with the playwright-course folder open in the sidebar" />
            </div>
          </div>
        </div>

        {/* macOS / Linux */}
        <div className="mt-6">
          <h3 className="text-base font-black text-white mb-4 flex items-center gap-2">
            <span className="text-lg">🍎</span> macOS / Linux
          </h3>

          <div className="space-y-6">
            <div>
              <p className="text-sm font-bold text-white mb-2">Step 1 — Install Node.js via the official installer</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Go to <span className="text-[#00FF88] font-mono">nodejs.org</span> and download the <strong className="text-white">LTS</strong> <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">.pkg</code> for macOS</li>
                <li>Open the downloaded file and follow the installer steps</li>
                <li><strong className="text-white">Linux:</strong> run <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs font-mono">sudo apt install nodejs npm</code> in the terminal</li>
              </ol>
              <Screenshot description="nodejs.org LTS download button for macOS" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 2 — Verify Node.js</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Open <strong className="text-white">Terminal</strong> (search Spotlight with Cmd+Space, type Terminal)</li>
                <li>Type <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs font-mono">node --version</code> and press Enter</li>
                <li>You should see <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">v22.x.x</code></li>
              </ol>
              <Screenshot description="macOS Terminal showing node --version output" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 3 — Install VS Code</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Go to <span className="text-[#00FF88] font-mono">code.visualstudio.com</span> and download for macOS</li>
                <li>Open the <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">.dmg</code>, drag VS Code to Applications</li>
              </ol>
              <Screenshot description="macOS VS Code installation — drag to Applications" />
            </div>

            <div>
              <p className="text-sm font-bold text-white mb-2">Step 4 — Create your project folder</p>
              <ol className="text-sm text-[#D1D5DB] space-y-1.5 pl-4 list-decimal">
                <li>Open VS Code → <strong className="text-white">File → Open Folder</strong></li>
                <li>Create a new folder called <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">playwright-course</code> on your Desktop</li>
                <li>Select it</li>
              </ol>
              <Screenshot description="VS Code on macOS with playwright-course folder open" />
            </div>
          </div>
        </div>

        <Callout type="win">If you see a version number after running <code className="bg-[#00FF88]/20 text-[#00FF88] px-1 rounded text-xs font-mono">node --version</code> and VS Code opens with your folder — you're done! Your kitchen is ready.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Everything in this course runs through Node.js and VS Code. When you reach Lesson 1.18 and install Playwright, you'll type:</p>
        <div className="rounded-xl border border-white/10 bg-[#0D0D0D] overflow-hidden my-4 font-mono text-sm">
          <div className="px-4 py-2 bg-[#161616] border-b border-white/10"><span className="text-xs text-[#9CA3AF]">Terminal — inside VS Code</span></div>
          <pre className="p-4 text-white"><code><span className="text-[#00FF88] select-none">$ </span>npm init playwright@latest</code></pre>
        </div>
        <p>That command only works because Node.js (and its package manager <code className="bg-[#1A1A1A] text-[#00FF88] px-1 rounded text-xs">npm</code>) is installed. Without this setup, nothing else in the course works.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "Node.js lets your computer run JavaScript files outside of a browser.",
          "VS Code is the editor where you'll write every file in this course.",
          "Your playwright-course folder is your workspace — everything lives here.",
        ]}
        nextLesson={{ number: "0.5", title: "The terminal, demystified", slug: "the-terminal-demystified" }}
      />
    </>
  );
}
