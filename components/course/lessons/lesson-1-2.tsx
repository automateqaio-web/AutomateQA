import {
  TheIdea,
  SeeItRun,
  NowYouTry,
  WhyATesterCares,
  Recap,
  GoDeeper,
  CodeBlock,
  OutputBlock,
  BashBlock,
  Callout,
  Code,
} from "@/components/course/LessonSections";

export default function Lesson12() {
  return (
    <>
      {/* ── 1. The idea ──────────────────────────────────────────────── */}
      <TheIdea>
        <p>
          Imagine you&apos;re learning to cook and you stick a Post-it note on
          the counter that says: <em>&quot;I added the salt here.&quot;</em>
        </p>
        <p>
          That note isn&apos;t part of the recipe. It&apos;s just a message to
          yourself — a little reminder so you can track what happened.
        </p>
        <p>
          <strong className="text-white">console.log is exactly that</strong> —
          a Post-it note your program sticks on the screen while it runs.
          You tell JavaScript what to print, and it prints it in the terminal.
          That&apos;s all it does.
        </p>
        <p>
          And running a <Code>.js</Code> file? That&apos;s just typing one
          short command in the terminal. Node.js reads your file and executes
          it top to bottom.
        </p>
      </TheIdea>

      {/* ── 2. See it run ─────────────────────────────────────────────── */}
      <SeeItRun>
        <p>
          Here is the output you&apos;ll see first — so you know what you&apos;re
          aiming for:
        </p>

        <OutputBlock output={`Hello, World!
I am learning Playwright.`} />

        <p>Here is the code that produces it:</p>

        <CodeBlock
          filename="hello.js"
          language="js"
          code={`console.log("Hello, World!");
console.log("I am learning Playwright.");`}
        />

        <p>And here is the one command to run it:</p>

        <BashBlock code="node hello.js" />

        <Callout type="tip">
          <strong>console.log</strong> — &quot;console&quot; is the terminal
          window, and &quot;log&quot; means print. So{" "}
          <Code>console.log("Hello")</Code> means &quot;print Hello to the
          terminal.&quot; The word &quot;log&quot; comes from keeping a
          ship&apos;s log — writing things down as they happen.
        </Callout>
      </SeeItRun>

      {/* ── 3. Now you try ────────────────────────────────────────────── */}
      <NowYouTry>
        <p>
          Open VS Code, create a new file called <Code>hello.js</Code>, and
          paste this starter code:
        </p>

        <CodeBlock
          filename="hello.js"
          language="js"
          code={`console.log("Hello, World!");
console.log("I am learning Playwright.");`}
        />

        <p>
          Now change <strong className="text-white">one thing</strong>: replace{" "}
          <Code>&quot;Hello, World!&quot;</Code> with your own name.
          For example:
        </p>

        <CodeBlock
          language="js"
          code={`console.log("Hello, Priya!");
console.log("I am learning Playwright.");`}
        />

        <p>Save the file. Then open the terminal in VS Code and run:</p>

        <BashBlock code="node hello.js" />

        <p>
          You should see your name printed in the terminal. That&apos;s your
          first JavaScript program running. Seriously — well done.
        </p>

        <Callout type="win">
          If you see your name in the terminal, you just ran JavaScript on
          your computer. The same engine that powers millions of websites just
          followed your instructions.
        </Callout>
      </NowYouTry>

      {/* ── 4. Why a tester cares ─────────────────────────────────────── */}
      <WhyATesterCares>
        <p>
          <Code>console.log</Code> is the first debugging tool every JavaScript developer learns.
          Here&apos;s how it helps you trace what a program is doing step by step:
        </p>

        <CodeBlock
          filename="debug-trace.js"
          language="js"
          code={`function processOrder(orderId, quantity, price) {
  console.log(\`Processing order: \${orderId}\`);

  const subtotal = quantity * price;
  console.log(\`  Quantity: \${quantity} × Price: \${price} = \${subtotal}\`);

  const discount = subtotal > 1000 ? subtotal * 0.1 : 0;
  console.log(\`  Discount applied: \${discount}\`);

  const total = subtotal - discount;
  console.log(\`  Final total: \${total}\`);

  return total;
}

processOrder("ORD-001", 3, 499);`}
        />

        <BashBlock code="node debug-trace.js" />

        <OutputBlock output={`Processing order: ORD-001
  Quantity: 3 × Price: 499 = 1497
  Discount applied: 149.7
  Final total: 1347.3`} />

        <p>
          Every line of output tells you exactly what happened and in what order.
          When something produces the wrong number, you add <Code>console.log</Code>
          before that step and watch the values — that&apos;s debugging.
        </p>
      </WhyATesterCares>

      {/* ── Recap ─────────────────────────────────────────────────────── */}
      <Recap
        bullets={[
          "console.log prints a message to the terminal — it's your debugging Post-it note.",
          "node hello.js tells Node.js to read and run your file top to bottom.",
          "Add console.log statements at each step to trace what your program is doing — that's debugging.",
        ]}
        nextLesson={{
          number: "1.3",
          title: "let and const",
          slug: "let-and-const",
        }}
      />

      {/* ── Go deeper (optional) ──────────────────────────────────────── */}
      <GoDeeper>
        <p>
          <Code>console.log</Code> is just one of several console methods.
          They all print to the terminal but with different labels:
        </p>

        <CodeBlock
          filename="console-methods.js"
          language="js"
          code={`console.log("This is a normal message");
console.warn("This is a warning — something looks off");
console.error("This is an error — something went wrong");`}
        />

        <p>
          In Node.js, all three print to the terminal. In a browser DevTools
          console, they appear with different colours — log is white, warn is
          yellow, error is red.
        </p>
        <p>
          Playwright uses <Code>console.error</Code> internally to log test
          failures. You&apos;ll see it when tests break, and now you&apos;ll
          recognise exactly what it means.
        </p>
        <p>
          You can also log multiple things in one call:
        </p>
        <CodeBlock
          language="js"
          code={`const name = "Priya";
const city = "Hyderabad";
console.log("Name:", name, "| City:", city);
// Output: Name: Priya | City: Hyderabad`}
        />
      </GoDeeper>
    </>
  );
}
