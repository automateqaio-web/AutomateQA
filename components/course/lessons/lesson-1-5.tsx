import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Code } from "@/components/course/LessonSections";

export default function Lesson15() {
  return (
    <>
      <TheIdea>
        <p>Have you played Mad Libs? You're given a sentence with blanks and you fill them in: "My name is ___ and I live in ___."</p>
        <p>In the old way to write JavaScript strings, combining text and variables looked messy:</p>
        <CodeBlock language="js" code={`console.log("Hello, " + name + "! You are from " + city + ".");`} />
        <p>Template literals are the modern, readable version — you use <strong className="text-white">backticks</strong> (`) instead of quotes, and drop variables in with <Code>{"${}"}</Code>:</p>
        <CodeBlock language="js" code={'console.log(`Hello, ${name}! You are from ${city}.`);'} />
        <p>Same result. Much cleaner.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Hello, Priya! You are from Hyderabad.
Your test score is: 95 out of 100
Test status: PASSED`} />
        <CodeBlock filename="template-literals.js" language="js" code={'const name = "Priya";\nconst city = "Hyderabad";\nconst score = 95;\nconst passed = true;\n\nconsole.log(`Hello, ${name}! You are from ${city}.`);\nconsole.log(`Your test score is: ${score} out of 100`);\nconsole.log(`Test status: ${passed ? "PASSED" : "FAILED"}`);'} />
        <BashBlock code="node template-literals.js" />
        <p>Notice the last line: you can even put logic inside <Code>{"${}"}</Code>. Anything that produces a value works.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Copy the file above. Change <Code>score</Code> to <Code>45</Code> and run it again. Does the status change to FAILED? It should.</p>
        <p>Then add a new line using a template literal that prints: <strong className="text-white">"Priya completed the test in Hyderabad."</strong> using only the existing variables — no typing the names manually.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Template literals shine whenever you need to build strings from data — reports, log messages, file names. Here's a simple grade report generator:</p>
        <CodeBlock filename="report.js" language="js" code={'const students = [\n  { name: "Priya", score: 92 },\n  { name: "Rahul", score: 65 },\n  { name: "Anita", score: 48 },\n];\n\nfor (const s of students) {\n  const status = s.score >= 60 ? "PASS" : "FAIL";\n  console.log(`${s.name}: ${s.score}/100 — ${status}`);\n}'} />
        <BashBlock code="node report.js" />
        <OutputBlock output={`Priya: 92/100 — PASS
Rahul: 65/100 — PASS
Anita: 48/100 — FAIL`} />
        <p>Without template literals this would be messy string concatenation. With backticks, you can read each line and immediately understand what it prints.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "Template literals use backticks (`) instead of quotes.",
          'Drop variables or expressions in with ${value} — no + signs needed.',
          "They make dynamic strings in Playwright tests (URLs, messages, assertions) far cleaner.",
        ]}
        nextLesson={{ number: "1.6", title: "Comparison operators", slug: "comparison-operators" }}
      />

      <GoDeeper>
        <p>Template literals also support multi-line strings naturally:</p>
        <CodeBlock language="js" code={'const message = `\n  Test started.\n  URL: https://example.com\n  User: Priya\n`;\nconsole.log(message);'} />
        <p>With regular strings you'd need <Code>\n</Code> escape characters everywhere. Backtick strings preserve line breaks as-is. Very useful for log messages in test reports.</p>
      </GoDeeper>
    </>
  );
}
