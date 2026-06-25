import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson13() {
  return (
    <>
      <TheIdea>
        <p>Imagine two kinds of notepads:</p>
        <p><strong className="text-white">A whiteboard</strong> — you write something, then erase it and write something else. The value can change.</p>
        <p><strong className="text-white">Permanent marker on a wall</strong> — once written, it stays. You can read it any time, but you can't change it.</p>
        <p>In JavaScript, <Code>let</Code> is the whiteboard and <Code>const</Code> is the permanent marker. Both store information. The difference is whether the value can change later.</p>
        <p>We skip <Code>var</Code> entirely — it's the old way from 1995 and has confusing behaviour. Nobody writes new code with it.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Priya
Hyderabad
Beginner`} />
        <CodeBlock filename="variables.js" language="js" code={`const name = "Priya";      // won't change — use const
let city = "Hyderabad";    // might change — use let
let level = "Beginner";    // might change as they learn

console.log(name);
console.log(city);
console.log(level);

// Later in the program, city can change:
city = "Mumbai";
console.log(city);         // Mumbai`} />
        <BashBlock code="node variables.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Copy the file above. Then try to change the <Code>const</Code> value:</p>
        <CodeBlock language="js" code={`const name = "Priya";
name = "Rahul";             // ← try adding this line`} />
        <p>Run it. You'll see:</p>
        <OutputBlock output={`TypeError: Assignment to constant variable.`} />
        <p>That error is JavaScript protecting you — you declared something as permanent and then tried to change it. Now delete that line and run again. No error.</p>
        <Callout type="tip">The error message itself is the lesson. JavaScript tells you exactly what went wrong.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>In any real program, you use <Code>const</Code> for things that are fixed and <Code>let</Code> for things that update. Here's a retry counter — a common pattern in automation scripts:</p>
        <CodeBlock filename="retry.js" language="js" code={`const MAX_RETRIES = 3;   // const — this limit never changes
let attempts = 0;         // let — this increases each time
let success = false;      // let — flips to true when done

while (attempts < MAX_RETRIES && !success) {
  attempts++;
  console.log(\`Attempt \${attempts}...\`);
  if (attempts === 2) {
    success = true;  // simulating a successful attempt
  }
}

console.log(\`Finished after \${attempts} attempt(s). Success: \${success}\`);`} />
        <BashBlock code="node retry.js" />
        <p>Notice how <Code>MAX_RETRIES</Code> is a great use of <Code>const</Code> — you set it once and it never changes. <Code>attempts</Code> and <Code>success</Code> are <Code>let</Code> because they change as the program runs.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "const = permanent marker. Declare once, never reassign. Use it for most things.",
          "let = whiteboard. Can be reassigned later. Use it when the value needs to change.",
          "Never use var — it has confusing scoping rules that cause real bugs.",
        ]}
        nextLesson={{ number: "1.4", title: "Data types", slug: "data-types" }}
      />

      <GoDeeper>
        <p>There's a subtle difference between reassigning and mutating. With <Code>const</Code>, you can't reassign the variable — but you CAN mutate an object or array it points to:</p>
        <CodeBlock language="js" code={`const user = { name: "Priya" };
user.name = "Rahul";          // ✓ works — mutating the object's property
user = { name: "Rahul" };     // ✗ error — reassigning the variable itself`} />
        <p>This trips up everyone at first. The rule: <Code>const</Code> locks the <em>binding</em> (the variable name pointing to a value), not the value itself.</p>
      </GoDeeper>
    </>
  );
}
