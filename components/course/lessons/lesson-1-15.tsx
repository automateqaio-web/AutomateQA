import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson115() {
  return (
    <>
      <TheIdea>
        <p>Promises work — but chaining <Code>.then().then().catch()</Code> gets messy fast. <Code>async/await</Code> is cleaner syntax for the exact same thing.</p>
        <p>Two keywords, one rule:</p>
        <ul className="space-y-2 mt-3 text-sm">
          <li className="flex gap-2"><span className="w-16 flex-shrink-0 text-[#00FF88] font-mono text-sm bg-white/5 rounded px-1 py-0.5">async</span><span className="text-[#D1D5DB]">— put this in front of a function to mark it as "this function contains asynchronous code"</span></li>
          <li className="flex gap-2"><span className="w-16 flex-shrink-0 text-[#00FF88] font-mono text-sm bg-white/5 rounded px-1 py-0.5">await</span><span className="text-[#D1D5DB]">— put this in front of a Promise to say "wait here until this Promise resolves"</span></li>
        </ul>
        <p className="mt-3">You can only use <Code>await</Code> inside an <Code>async</Code> function. That's the only rule.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Running login test...
Navigated to login page
Filled username
Filled password
Clicked Login button
Logged in as: priya@example.com
Test complete`} />
        <CodeBlock filename="async-await.js" language="js" code={`// Simulated Playwright-style actions
function navigateTo(url) {
  return new Promise(resolve =>
    setTimeout(() => { console.log(\`Navigated to \${url}\`); resolve(); }, 200)
  );
}
function fill(field, value) {
  return new Promise(resolve =>
    setTimeout(() => { console.log(\`Filled \${field}\`); resolve(value); }, 100)
  );
}
function click(button) {
  return new Promise(resolve =>
    setTimeout(() => { console.log(\`Clicked \${button}\`); resolve(); }, 100)
  );
}

// Without async/await (messy .then chains)
// navigateTo("/login").then(() => fill("username", "...")).then(() => click("Login")).then(...)

// WITH async/await — reads top to bottom, like synchronous code
async function loginTest() {
  console.log("Running login test...");

  await navigateTo("/login");
  const user = await fill("username", "priya@example.com");
  await fill("password", "secret");
  await click("Login button");

  console.log(\`Logged in as: \${user}\`);
  console.log("Test complete");
}

// Call the async function
loginTest();`} />
        <BashBlock code="node async-await.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Copy the file above. Write a new <Code>async</Code> function called <Code>searchTest</Code> that:</p>
        <ol className="list-decimal list-inside space-y-1 text-sm text-[#D1D5DB] mt-2">
          <li>Calls <Code>navigateTo("/search")</Code></li>
          <li>Calls <Code>fill("search box", "Playwright")</Code></li>
          <li>Calls <Code>click("Search button")</Code></li>
          <li>Prints "Search test complete"</li>
        </ol>
        <p className="mt-3">Call <Code>searchTest()</Code> at the bottom. Make sure all steps use <Code>await</Code>.</p>
        <Callout type="warning">Forgetting <Code>await</Code> is the #1 beginner Playwright bug. If you skip it, the next line runs before the action finishes. Always <Code>await</Code> every Playwright method call.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Here's the same user-loading example from Lesson 1.14, rewritten with <Code>async/await</Code>. Compare how much cleaner it reads:</p>
        <CodeBlock filename="load-user-async.js" language="js" code={`function fetchUser(id) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id > 0) resolve({ id, name: "Priya", email: "priya@example.com" });
      else reject(new Error("User ID must be positive"));
    }, 300);
  });
}

// With .then() — works but hard to read when chained
// fetchUser(42).then(u => loadProfile(u)).then(p => render(p))...

// With async/await — reads top to bottom, like normal code
async function showUserProfile(id) {
  const user = await fetchUser(id);
  console.log(\`User: \${user.name}\`);
  console.log(\`Email: \${user.email}\`);
  console.log("Profile loaded successfully.");
}

showUserProfile(42);`} />
        <BashBlock code="node load-user-async.js" />
        <OutputBlock output={`User: Priya
Email: priya@example.com
Profile loaded successfully.`} />
        <p>Same Promise underneath — but now it reads like a plain list of steps. <Code>async/await</Code> doesn't change how JavaScript handles timing; it just makes the code readable.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "async marks a function as asynchronous — it always returns a Promise implicitly.",
          "await pauses execution inside an async function until the Promise resolves.",
          "You can only use await inside an async function — it's a syntax error otherwise.",
        ]}
        nextLesson={{ number: "1.16", title: "try / catch", slug: "try-catch" }}
      />

      <GoDeeper>
        <p>An <Code>async</Code> function always returns a Promise, even if you return a plain value:</p>
        <CodeBlock language="js" code={`async function getValue() {
  return 42;
}

// getValue() returns a Promise<42>, not 42 directly
getValue().then(v => console.log(v));  // 42

// Or with await:
const v = await getValue();
console.log(v);  // 42`} />
        <p>This is why you can't call an async function and use its return value directly without <Code>await</Code>. If you forget, you'll get <Code>[object Promise]</Code> printed instead of the value — a tell-tale sign of a missing <Code>await</Code>.</p>
      </GoDeeper>
    </>
  );
}
