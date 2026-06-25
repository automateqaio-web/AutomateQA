import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson111() {
  return (
    <>
      <TheIdea>
        <p>In Lesson 1.10 you wrote functions like this:</p>
        <CodeBlock language="js" code={`function greet(name) {
  console.log(\`Hello \${name}\`);
}`} />
        <p>Arrow functions are a shorter way to write the same thing:</p>
        <CodeBlock language="js" code={`const greet = (name) => {
  console.log(\`Hello \${name}\`);
};`} />
        <p>Same behaviour. Different syntax. Arrow functions are extremely common in modern JavaScript and in every Playwright codebase you'll ever read — so you need to recognise them on sight.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Hello Priya
Hello Rahul
Doubled: 10
Status: PASS`} />
        <CodeBlock filename="arrow-functions.js" language="js" code={`// Regular function
function greet(name) {
  console.log(\`Hello \${name}\`);
}

// Arrow function — same thing
const greetArrow = (name) => {
  console.log(\`Hello \${name}\`);
};

greet("Priya");
greetArrow("Rahul");

// One-line arrow function — no braces needed when the body is a single expression
const double = (n) => n * 2;
console.log("Doubled:", double(5));

// One-liner returning a string
const getStatus = (passed) => passed ? "PASS" : "FAIL";
console.log("Status:", getStatus(true));`} />
        <BashBlock code="node arrow-functions.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Convert this regular function to an arrow function:</p>
        <CodeBlock language="js" code={`function formatTestName(name, number) {
  return \`[\${number}] \${name}\`;
}

console.log(formatTestName("Login Test", 1));`} />
        <p>Then shorten it to a one-liner arrow function. Same output, fewer lines.</p>
        <Callout type="tip">Arrow functions are stored in <Code>const</Code> variables, not declared with <Code>function</Code>. This means they must be defined before they're called — unlike regular function declarations which are "hoisted" to the top automatically.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Arrow functions are everywhere in modern JavaScript — especially when working with arrays. Here are three powerful array methods that all take arrow functions:</p>
        <CodeBlock filename="arrays.js" language="js" code={`const scores = [85, 42, 91, 60, 73, 38, 95];

// filter — keep only items that match the condition
const passing = scores.filter(score => score >= 60);

// map — transform each item into something new
const grades = scores.map(score => score >= 60 ? "PASS" : "FAIL");

// find — get the first item that matches
const firstFail = scores.find(score => score < 60);

console.log("All scores:", scores);
console.log("Passing:", passing);
console.log("Grades:", grades);
console.log("First fail:", firstFail);`} />
        <BashBlock code="node arrays.js" />
        <OutputBlock output={`All scores: [85, 42, 91, 60, 73, 38, 95]
Passing: [85, 91, 60, 73, 95]
Grades: ['PASS', 'FAIL', 'PASS', 'PASS', 'PASS', 'FAIL', 'PASS']
First fail: 42`} />
        <p><Code>filter</Code>, <Code>map</Code>, and <Code>find</Code> are three of the most used methods in JavaScript. Arrow functions make them clean and readable.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "Arrow functions: const name = (params) => { body }; — shorter syntax, same result.",
          "One-liner: const fn = (x) => x * 2; — omit braces and return when the body is one expression.",
          "Playwright test blocks and helpers almost always use arrow functions — recognise the shape.",
        ]}
        nextLesson={{ number: "1.12", title: "Parameters and return", slug: "parameters-and-return" }}
      />

      <GoDeeper>
        <p>The one key difference between regular functions and arrow functions (beyond syntax) is how they handle <Code>this</Code>. Regular functions have their own <Code>this</Code> context; arrow functions inherit <Code>this</Code> from the surrounding scope.</p>
        <p className="mt-2">In Playwright automation this rarely matters — most of your code doesn't use <Code>this</Code> at all. But if you're ever in a class-based pattern and notice strange <Code>this</Code> behaviour, that's the reason.</p>
      </GoDeeper>
    </>
  );
}
