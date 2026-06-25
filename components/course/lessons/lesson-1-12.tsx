import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson112() {
  return (
    <>
      <TheIdea>
        <p>Functions have two sides: what goes in (<strong className="text-white">parameters</strong>) and what comes out (<strong className="text-white">return value</strong>).</p>
        <p>Think of a vending machine. You put in money and a selection (parameters). Out comes a snack (return value). The machine does the work in between.</p>
        <p>You've already used parameters. Now let's make functions that actually produce a value — not just print one.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Full name: Priya Sharma
Test URL: https://staging.myapp.com/tests/42
Score: 85 — Grade: B
Formatted: [#001] Login Test`} />
        <CodeBlock filename="params-return.js" language="js" code={`// Function that returns a value
function fullName(first, last) {
  return first + " " + last;
}

const name = fullName("Priya", "Sharma");
console.log("Full name:", name);

// Building a URL from parts
const buildUrl = (env, id) => \`https://\${env}.myapp.com/tests/\${id}\`;
console.log("Test URL:", buildUrl("staging", 42));

// Multiple return paths
function getGrade(score) {
  if (score >= 90) return "A";
  if (score >= 80) return "B";
  if (score >= 70) return "C";
  return "F";
}

const score = 85;
console.log(\`Score: \${score} — Grade: \${getGrade(score)}\`);

// Default parameter — used if caller doesn't provide one
function formatTestName(name, number = 1) {
  return \`[#\${String(number).padStart(3, "0")}] \${name}\`;
}
console.log("Formatted:", formatTestName("Login Test"));`} />
        <BashBlock code="node params-return.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Write a function called <Code>isValidEmail</Code> that:</p>
        <ul className="list-disc list-inside space-y-1 text-sm text-[#D1D5DB] mt-2">
          <li>Takes a string as a parameter</li>
          <li>Returns <Code>true</Code> if the string contains an <Code>@</Code> symbol, <Code>false</Code> otherwise</li>
          <li>Hint: <Code>string.includes("@")</Code> returns true if <Code>@</Code> is found</li>
        </ul>
        <CodeBlock language="js" code={`console.log(isValidEmail("priya@gmail.com"));  // true
console.log(isValidEmail("not-an-email"));      // false`} />
        <Callout type="tip">When a function returns something, you can use it directly inside other expressions: <Code>{"console.log(isValid ? \"OK\" : \"BAD\")"}</Code> — no need to store it in a variable first.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Functions that return values let you build reusable tools. Here's a small data analysis library — three functions, each returning something useful:</p>
        <CodeBlock filename="stats.js" language="js" code={`function average(numbers) {
  const total = numbers.reduce((sum, n) => sum + n, 0);
  return total / numbers.length;
}

function highest(numbers) {
  return Math.max(...numbers);
}

function summary(label, numbers) {
  return {
    label,
    avg: average(numbers).toFixed(1),
    best: highest(numbers),
    passed: numbers.filter(n => n >= 60).length,
    total: numbers.length,
  };
}

const mathScores    = [82, 91, 67, 54, 78];
const scienceScores = [74, 88, 95, 60, 70];

console.log(summary("Maths",   mathScores));
console.log(summary("Science", scienceScores));`} />
        <BashBlock code="node stats.js" />
        <p>Each function has a clear input (parameters) and a clear output (return value). That's what makes them composable — you can use <Code>average()</Code> inside <Code>summary()</Code> without rewriting the logic.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "return sends a value out of the function — the caller can store or use it.",
          "A function with no return statement produces undefined — not an error, just nothing.",
          "Default parameters (param = defaultValue) are used when the caller doesn't provide that argument.",
        ]}
        nextLesson={{ number: "1.13", title: "Why the web is asynchronous", slug: "why-async" }}
      />

      <GoDeeper>
        <p>A function returns only one thing. But that one thing can be an object containing many values:</p>
        <CodeBlock language="js" code={`function getTestConfig() {
  return {
    browser: "chromium",
    headless: true,
    timeout: 30000,
    baseUrl: "https://staging.myapp.com",
  };
}

const config = getTestConfig();
console.log(config.browser);   // chromium
console.log(config.timeout);   // 30000`} />
        <p>This is the foundation of test configuration files — one function returning an object of settings. You'll see this pattern in <Code>playwright.config.ts</Code> in Lesson 1.18.</p>
      </GoDeeper>
    </>
  );
}
