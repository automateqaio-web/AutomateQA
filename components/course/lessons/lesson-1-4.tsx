import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Code } from "@/components/course/LessonSections";

export default function Lesson14() {
  return (
    <>
      <TheIdea>
        <p>Not all information is the same kind of thing. "Priya" is a name. 42 is a count. true/false is a yes/no answer. Nothing is... nothing.</p>
        <p>JavaScript has five basic kinds of data. Think of them as different types of storage containers — you wouldn't store water in a paper bag or a name in a number slot.</p>
        <p>Knowing the type matters because JavaScript behaves differently depending on what kind of data you're working with.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`string: Priya
number: 42
boolean: true
null: null
undefined: undefined`} />
        <CodeBlock filename="data-types.js" language="js" code={`const name = "Priya";          // string  — text, always in quotes
const age = 42;                // number  — any number, no quotes
const isPassed = true;         // boolean — only true or false
const score = null;            // null    — intentionally empty
let address;                   // undefined — declared but not given a value yet

console.log("string:", name);
console.log("number:", age);
console.log("boolean:", isPassed);
console.log("null:", score);
console.log("undefined:", address);`} />
        <BashBlock code="node data-types.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Change <Code>isPassed</Code> from <Code>true</Code> to <Code>false</Code> and run it again. Then try this line at the bottom:</p>
        <CodeBlock language="js" code={`console.log(typeof name);      // "string"
console.log(typeof age);       // "number"
console.log(typeof isPassed);  // "boolean"`} />
        <p><Code>typeof</Code> is JavaScript's way of telling you what type a value is. You'll use it when debugging.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Real programs mix all five types together. Here's a small student record — you'll recognise every type in it:</p>
        <CodeBlock filename="student.js" language="js" code={`const studentName = "Priya";   // string
const score = 87;              // number
const hasPassed = true;        // boolean
const medalAwarded = null;     // null — not awarded yet
let rank;                      // undefined — not calculated yet

console.log(\`Name: \${studentName}\`);
console.log(\`Score: \${score}\`);
console.log(\`Passed: \${hasPassed}\`);
console.log(\`Medal: \${medalAwarded}\`);  // null
console.log(\`Rank: \${rank}\`);           // undefined

// typeof tells you what kind of data something is
console.log(typeof studentName);   // string
console.log(typeof score);         // number
console.log(typeof hasPassed);     // boolean`} />
        <BashBlock code="node student.js" />
        <p>Every program you write — automation or otherwise — uses these exact types. Knowing them by name makes reading error messages and debugging much faster.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "string = text in quotes. number = any number. boolean = true or false.",
          "null means intentionally empty. undefined means declared but never assigned.",
          "Use typeof to check what type a value is — useful when debugging unexpected behaviour.",
        ]}
        nextLesson={{ number: "1.5", title: "Template literals", slug: "template-literals" }}
      />

      <GoDeeper>
        <p>There's a classic JavaScript quirk involving types:</p>
        <CodeBlock language="js" code={`console.log(typeof null);   // "object"  ← this is a known JS bug from 1995`} />
        <p>It should say "null" but says "object" because of a design mistake in the original JavaScript engine. It was never fixed because too much code depended on the broken behaviour. This is why programmers joke about JavaScript — but for Playwright automation you'll rarely encounter this.</p>
        <p className="mt-2">JavaScript also has two more types you'll eventually meet: <strong className="text-white">BigInt</strong> (for very large numbers) and <strong className="text-white">Symbol</strong> (for unique identifiers). You won't need them in this course.</p>
      </GoDeeper>
    </>
  );
}
