import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Code } from "@/components/course/LessonSections";

export default function Lesson17() {
  return (
    <>
      <TheIdea>
        <p>Comparison operators answer one question at a time. Logical operators let you combine questions.</p>
        <p>Imagine a bouncer at a club. The rule is: you must be over 18 <strong className="text-white">AND</strong> have a valid ID. One condition isn't enough — both must be true.</p>
        <p>Or a discount: you get a deal if you're a student <strong className="text-white">OR</strong> a senior. Either one is enough.</p>
        <p>JavaScript has three logical operators: <Code>&&</Code> (AND), <Code>||</Code> (OR), and <Code>!</Code> (NOT).</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`true
false
true
false
true`} />
        <CodeBlock filename="logical.js" language="js" code={`const age = 22;
const hasId = true;
const isStudent = false;
const isSenior = true;

// AND — both must be true
console.log(age >= 18 && hasId);         // true  — both conditions met

// OR — at least one must be true
console.log(isStudent || isSenior);      // true  — senior is true

// AND — both must be true
console.log(isStudent && isSenior);      // false — student is false

// NOT — flips true to false and false to true
console.log(!hasId);                     // false — hasId is true, !true = false
console.log(!isStudent);                 // true  — isStudent is false, !false = true`} />
        <BashBlock code="node logical.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Write a check that answers: "Is this test eligible to run automatically?" — use these rules:</p>
        <CodeBlock language="js" code={`const testIsReady = true;
const environmentIsStaging = true;
const isBlocked = false;

// Write one console.log that uses && and ! to check:
// testIsReady AND environmentIsStaging AND NOT isBlocked`} />
        <p>Expected output: <Code>true</Code>. Then set <Code>isBlocked = true</Code> and run again — should become <Code>false</Code>.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Logical operators are the engine behind every access control system. Here's a simple role-based permission check in pure JavaScript:</p>
        <CodeBlock filename="permissions.js" language="js" code={`const user = { name: "Priya", role: "editor", isActive: true };

// AND — all conditions must be true
const canPublish = user.isActive && user.role === "admin";

// OR — any condition is enough
const canEdit = user.role === "admin" || user.role === "editor";

// NOT — reverse the condition
const isGuest = !(user.role === "admin" || user.role === "editor");

console.log(\`\${user.name} can publish: \${canPublish}\`);  // false
console.log(\`\${user.name} can edit: \${canEdit}\`);        // true
console.log(\`\${user.name} is a guest: \${isGuest}\`);      // false`} />
        <BashBlock code="node permissions.js" />
        <p>This same pattern — combining boolean flags with <Code>&&</Code>, <Code>||</Code>, <Code>!</Code> — appears in login systems, dashboards, and form validation everywhere. Master these three operators and you can read almost any conditional logic.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "&& (AND) — both sides must be true. One false makes the whole thing false.",
          "|| (OR) — at least one side must be true. One true is enough.",
          "! (NOT) — flips the boolean: !true = false, !false = true.",
        ]}
        nextLesson={{ number: "1.8", title: "if / else and ternary", slug: "if-else-and-ternary" }}
      />

      <GoDeeper>
        <p>Logical operators also do something called "short-circuit evaluation" — they stop as early as possible:</p>
        <CodeBlock language="js" code={`// With &&: if the first part is false, JS never evaluates the second
false && console.log("never runs");

// With ||: if the first part is true, JS never evaluates the second
true || console.log("never runs");`} />
        <p>This is why you'll see patterns like <Code>user && user.name</Code> in React code — if <Code>user</Code> is null, JavaScript short-circuits and never tries to access <Code>user.name</Code> (which would crash).</p>
      </GoDeeper>
    </>
  );
}
