import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson113() {
  return (
    <>
      <TheIdea>
        <p>This lesson has no code. It's the most important concept lesson in the entire course.</p>
        <p>Every beginner who gets confused by Playwright — every error that says "element not found", every test that passes locally but fails in CI — almost always comes back to one misunderstood idea:</p>
        <p className="text-lg font-bold text-white mt-3 mb-1">The web does not wait for you.</p>
        <p>To understand why, imagine ordering at a restaurant. The moment you order, you don't freeze and stare at the kitchen until your food arrives. The waiter writes down your order, goes to the next table, comes back, takes another order. The kitchen is working on your food in the background.</p>
        <p>That's asynchronous. Multiple things happening at once, without waiting for each other to finish.</p>
      </TheIdea>

      <SeeItRun>
        <p>No code to run — but here's what's actually happening when a browser loads a page:</p>
        <div className="space-y-3 my-4">
          {[
            { step: "1", label: "Browser sends request", desc: "Your browser asks a server for the page. This takes time — maybe 200ms, maybe 2 seconds on a slow connection.", color: "text-blue-400" },
            { step: "2", label: "Server processes", desc: "The server runs code, queries a database, builds the HTML. The browser waits.", color: "text-yellow-400" },
            { step: "3", label: "Response arrives", desc: "HTML arrives. The browser starts rendering — but images, fonts, and JavaScript files are separate requests. They load in parallel.", color: "text-[#00FF88]" },
            { step: "4", label: "JavaScript runs", desc: "Scripts execute — they may load more data, show/hide elements, run timers. None of this is instant.", color: "text-purple-400" },
          ].map(({ step, label, desc, color }) => (
            <div key={step} className="flex gap-4 rounded-xl border border-white/8 bg-[#0F0F0F] p-4">
              <div className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-black flex-shrink-0 mt-0.5 bg-white/5 ${color}`}>{step}</div>
              <div>
                <p className={`text-sm font-bold mb-1 ${color}`}>{label}</p>
                <p className="text-sm text-[#9CA3AF] leading-relaxed">{desc}</p>
              </div>
            </div>
          ))}
        </div>
        <p>All of this happens in fractions of a second — but it still takes <em>some</em> time. And a Playwright script that doesn't account for that time will try to click a button that hasn't appeared yet.</p>
      </SeeItRun>

      <NowYouTry>
        <p>No code to write. Do this instead:</p>
        <p className="mt-3">Open your browser's developer tools (F12 → Network tab). Visit any website. Watch the waterfall of requests loading in order, some in parallel, some waiting for others.</p>
        <p className="mt-2">That waterfall is why asynchronous matters. Your test is running while that waterfall is still loading.</p>
        <Callout type="info">This is the hardest concept in the course for beginners — not because it's complicated, but because it's invisible. You don't see it happening. The next three lessons (Promises, async/await, try/catch) give you the tools to work with it.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Asynchronous code is everywhere in real JavaScript programs — not just in Playwright. The most common example you'll encounter: fetching data from an API.</p>
        <div className="rounded-xl border border-red-500/20 bg-red-500/5 p-5 my-4">
          <p className="text-sm font-bold text-red-400 mb-2">The broken mental model:</p>
          <p className="text-sm text-[#D1D5DB]">"I asked for the data. So the next line can use it — it's there now."</p>
        </div>
        <div className="rounded-xl border border-[#00FF88]/20 bg-[#00FF88]/5 p-5 my-4">
          <p className="text-sm font-bold text-[#00FF88] mb-2">The correct mental model:</p>
          <p className="text-sm text-[#D1D5DB]">"Asking takes time. The data travels over a network. I must <strong className="text-white">wait</strong> for it to arrive before I can use it."</p>
        </div>
        <p>In the next three lessons you'll learn the JavaScript tools for handling this: <strong className="text-white">Promises</strong>, <strong className="text-white">async/await</strong>, and <strong className="text-white">try/catch</strong>. These are core JavaScript skills — not specific to any framework.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "The web is asynchronous — browser requests take time, and things don't happen instantly.",
          "A test script runs faster than the page loads — you must explicitly wait.",
          "await tells JavaScript to pause and wait for an asynchronous operation to finish before continuing.",
        ]}
        nextLesson={{ number: "1.14", title: "Promises", slug: "promises" }}
      />

      <GoDeeper>
        <p>JavaScript was designed to be single-threaded — it can only do one thing at a time. But it uses an "event loop" to handle waiting without blocking. When something takes time (a network request, a file read, a timer), JavaScript kicks it to a queue and continues processing other things. When the slow thing finishes, it goes back to the queue to be processed.</p>
        <p className="mt-2">This is why your browser doesn't freeze when a website is slow to respond. And it's why your test code needs <Code>await</Code> — without it, the event loop moves on to the next line before the slow thing has finished.</p>
      </GoDeeper>
    </>
  );
}
