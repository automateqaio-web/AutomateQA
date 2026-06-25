import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson19() {
  return (
    <>
      <TheIdea>
        <p>Imagine you have 5 test cases and you need to run them all. You could write:</p>
        <CodeBlock language="js" code={`runTest("login");
runTest("checkout");
runTest("search");
runTest("logout");
runTest("profile");`} />
        <p>But what if you had 100? A loop does repetitive work automatically — you write the instruction once and JavaScript repeats it as many times as needed.</p>
        <p>Two loops cover almost every case you'll encounter: <Code>for</Code> (when you know the count) and <Code>for...of</Code> (when you have a list).</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Test 1 of 5
Test 2 of 5
Test 3 of 5
Test 4 of 5
Test 5 of 5
---
Running: login
Running: checkout
Running: search
Running: logout
Running: profile`} />
        <CodeBlock filename="loops.js" language="js" code={`// for loop — when you know the count
for (let i = 1; i <= 5; i++) {
  console.log(\`Test \${i} of 5\`);
}

console.log("---");

// for...of loop — when you have a list (array)
const testCases = ["login", "checkout", "search", "logout", "profile"];

for (const testCase of testCases) {
  console.log(\`Running: \${testCase}\`);
}`} />
        <BashBlock code="node loops.js" />
        <p>The <Code>for</Code> loop has three parts: <em>start</em> (<Code>let i = 1</Code>), <em>condition</em> (<Code>i &lt;= 5</Code>), <em>increment</em> (<Code>i++</Code>). The loop runs while the condition is true.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Copy the loops file. Add a new array called <Code>urls</Code> with three website URLs, then use a <Code>for...of</Code> loop to print: <Code>Checking: https://example.com</Code> for each one.</p>
        <Callout type="tip">In Playwright, you'll loop through a list of URLs to visit them all or a list of items to verify each one. The pattern is identical to what you just wrote.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Loops let you process any amount of data with the same few lines of code. Here's a simple marks processor — the kind of thing a school system might run nightly:</p>
        <CodeBlock filename="marks.js" language="js" code={`const students = [
  { name: "Priya",  marks: [85, 90, 78, 92] },
  { name: "Rahul",  marks: [60, 55, 70, 65] },
  { name: "Anita",  marks: [95, 98, 92, 97] },
];

for (const student of students) {
  let total = 0;
  for (const mark of student.marks) {
    total += mark;
  }
  const average = total / student.marks.length;
  const status = average >= 70 ? "PASS" : "FAIL";
  console.log(\`\${student.name}: avg \${average.toFixed(1)} — \${status}\`);
}`} />
        <BashBlock code="node marks.js" />
        <OutputBlock output={`Priya: avg 86.3 — PASS
Rahul: avg 62.5 — PASS
Anita: avg 95.5 — PASS`} />
        <p>Two nested loops, pure JavaScript, zero repetition. Add 100 more students to the array and the exact same code handles them all.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "for (let i = 0; i < n; i++) — use when you need a counter or know the number of times.",
          "for (const item of array) — use when you have a list and want each item in turn.",
          "Both loops are essential for data-driven testing in Playwright.",
        ]}
        nextLesson={{ number: "1.10", title: "Function declarations", slug: "function-declarations" }}
      />

      <GoDeeper>
        <p>Arrays have a method called <Code>.forEach()</Code> that's an alternative to <Code>for...of</Code>:</p>
        <CodeBlock language="js" code={`const urls = ["https://a.com", "https://b.com"];

// for...of
for (const url of urls) {
  console.log(url);
}

// .forEach — same result, slightly different style
urls.forEach(url => {
  console.log(url);
});`} />
        <p>You'll see both in codebases. <Code>for...of</Code> is easier to read for beginners and works with <Code>await</Code> inside loops (which matters in Playwright). <Code>.forEach()</Code> does <strong className="text-white">not</strong> work properly with <Code>await</Code> — a common beginner bug.</p>
      </GoDeeper>
    </>
  );
}
