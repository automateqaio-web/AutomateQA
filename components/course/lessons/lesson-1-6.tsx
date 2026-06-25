import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson16() {
  return (
    <>
      <TheIdea>
        <p>A comparison operator asks a question and always gets one of two answers: <Code>true</Code> or <Code>false</Code>.</p>
        <p>Think of it like a referee at a game — they look at two things and make a call: "equal or not?", "bigger or smaller?"</p>
        <p>There are six comparison operators in JavaScript, and you'll use them constantly in <Code>if</Code> statements and Playwright assertions.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`true
false
true
true
false
true`} />
        <CodeBlock filename="comparisons.js" language="js" code={`const score = 80;
const passing = 75;

console.log(score > passing);     // true  — is 80 greater than 75?
console.log(score < passing);     // false — is 80 less than 75?
console.log(score >= 80);         // true  — is 80 greater than OR equal to 80?
console.log(score !== 50);        // true  — is 80 NOT equal to 50?
console.log(score === 100);       // false — is 80 strictly equal to 100?
console.log(score === 80);        // true  — is 80 strictly equal to 80?`} />
        <BashBlock code="node comparisons.js" />
        <Callout type="warning">Always use <Code>===</Code> (triple equals), never <Code>==</Code> (double equals). Triple equals checks both value AND type. Double equals does type coercion and produces surprising results.</Callout>
      </SeeItRun>

      <NowYouTry>
        <p>Predict the output before running:</p>
        <CodeBlock language="js" code={`console.log(10 == "10");    // == double equals
console.log(10 === "10");   // === triple equals`} />
        <p>Write your guess, then run it. The results will surprise you — and explain exactly why we always use triple equals.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Comparisons are the foundation of any pass/fail logic. Here's a simple grading system built entirely with comparison operators:</p>
        <CodeBlock filename="grading.js" language="js" code={`function getGrade(score) {
  if (score >= 90) return "A";
  if (score >= 80) return "B";
  if (score >= 70) return "C";
  if (score >= 60) return "D";
  return "F";
}

const scores = [95, 83, 71, 58, 100];

for (const score of scores) {
  const passed = score >= 60;
  const grade = getGrade(score);
  console.log(\`Score: \${score} | Grade: \${grade} | Passed: \${passed}\`);
}`} />
        <BashBlock code="node grading.js" />
        <OutputBlock output={`Score: 95 | Grade: A | Passed: true
Score: 83 | Grade: B | Passed: true
Score: 71 | Grade: C | Passed: true
Score: 58 | Grade: F | Passed: false
Score: 100 | Grade: A | Passed: true`} />
        <p>Every pass/fail decision in any program — grading systems, access control, form validation — uses these exact same operators.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "=== means strictly equal (same value AND same type) — always use this.",
          "!== means not equal. > < >= <= work as you'd expect from maths.",
          "Comparison operators return true or false — they're the engine behind if statements and test assertions.",
        ]}
        nextLesson={{ number: "1.7", title: "Logical operators", slug: "logical-operators" }}
      />

      <GoDeeper>
        <p>The double-equals trap explained:</p>
        <CodeBlock language="js" code={`console.log(10 == "10");   // true  ← JS converts "10" to 10 first
console.log(10 === "10");  // false ← different types, no conversion`} />
        <p>Double equals tries to be "helpful" by converting types before comparing. This is called type coercion and it's a famous source of JavaScript bugs. Triple equals is predictable. Use it exclusively.</p>
      </GoDeeper>
    </>
  );
}
