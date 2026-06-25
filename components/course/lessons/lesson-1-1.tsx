import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson11() {
  return (
    <>
      <TheIdea>
        <p>Think of a website as a puppet show. There are three people involved:</p>
        <ul className="space-y-2 mt-3 text-sm">
          <li className="flex gap-2"><span className="text-[#00FF88] font-bold w-16 flex-shrink-0">HTML</span><span className="text-[#D1D5DB]">builds the puppet — the structure (head, arms, body).</span></li>
          <li className="flex gap-2"><span className="text-yellow-400 font-bold w-16 flex-shrink-0">CSS</span><span className="text-[#D1D5DB]">dresses the puppet — colours, size, costume.</span></li>
          <li className="flex gap-2"><span className="text-blue-400 font-bold w-16 flex-shrink-0">JavaScript</span><span className="text-[#D1D5DB]">is the puppeteer — makes it move, react, and do things when the audience interacts.</span></li>
        </ul>
        <p className="mt-3"><strong className="text-white">JavaScript (JS)</strong> is the programming language of the web. It runs inside browsers — but with <strong className="text-white">Node.js</strong>, it also runs on your computer directly, outside any browser. That's how Playwright works: Node.js runs your test scripts on your machine.</p>
      </TheIdea>

      <SeeItRun>
        <p>Here's the output first:</p>
        <OutputBlock output="JavaScript is running on my computer!" />
        <p>And the file that produces it:</p>
        <CodeBlock filename="intro.js" language="js" code={`console.log("JavaScript is running on my computer!");`} />
        <p>Run it with:</p>
        <BashBlock code="node intro.js" />
        <p>That's Node.js reading your file and executing it. No browser needed.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Create a file called <Code>intro.js</Code> in your <Code>playwright-course</Code> folder, paste the code above, and run it.</p>
        <p>Then change the message inside the quotes to anything you like and run it again.</p>
        <Callout type="win">If you see your message in the terminal — Node.js is working and you just ran your first JavaScript file.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Node.js lets JavaScript do things beyond the browser — read files, make network requests, run scripts automatically. Here's a simple example: printing a personalised message using Node.js on your computer.</p>
        <CodeBlock filename="greet.js" language="js" code={`const name = "Priya";
const tool = "Node.js";

console.log(\`Hello \${name}! You're running JavaScript with \${tool}.\`);
console.log("No browser needed — just the terminal.");`} />
        <BashBlock code="node greet.js" />
        <p>This is exactly the kind of script automation engineers write — not web pages, but programs that run and do things. Playwright is just a much more powerful version of this idea.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "JavaScript is the language that makes web pages interactive — and Playwright tests are written in it.",
          "Node.js lets JavaScript run on your computer (not just in a browser).",
          "Every Playwright test is a .js (or .ts) file that Node.js executes.",
        ]}
        nextLesson={{ number: "1.2", title: "Running a .js file", slug: "running-a-js-file" }}
      />

      <GoDeeper>
        <p>JavaScript was created in 1995 by Brendan Eich in just 10 days. It was originally called Mocha, then LiveScript, then JavaScript — the name was a marketing decision to piggyback on Java's popularity. They are completely unrelated languages.</p>
        <p className="mt-2">Node.js was created in 2009 by Ryan Dahl. Before Node.js, JavaScript could only run inside a browser. Node.js changed that, enabling server-side JavaScript and tools like npm — which is how you'll install Playwright.</p>
        <p className="mt-2"><strong className="text-white">TypeScript</strong> is JavaScript with types added. Playwright supports both JS and TS. This course uses JS first (simpler), and we'll introduce TS in Phase 3.</p>
      </GoDeeper>
    </>
  );
}
