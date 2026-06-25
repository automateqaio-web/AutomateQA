import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson110() {
  return (
    <>
      <TheIdea>
        <p>Imagine you need to make a cup of tea. The steps are: boil water → add teabag → pour water → wait → remove teabag → add milk. You'll do this every morning.</p>
        <p>Instead of writing those steps out every time, you write them once and give them a name: <Code>makeTeа()</Code>. Then whenever you want tea, you just call that name.</p>
        <p>That's a function. It's a named, reusable block of code. You define it once, call it whenever you need it.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Test started: Login Flow
Test PASSED
---
Test started: Checkout Flow
Test FAILED
---
Test started: Search Flow
Test PASSED`} />
        <CodeBlock filename="functions.js" language="js" code={`// Define the function once
function runTest(testName, passed) {
  console.log(\`Test started: \${testName}\`);
  if (passed) {
    console.log("Test PASSED");
  } else {
    console.log("Test FAILED");
  }
  console.log("---");
}

// Call it as many times as needed
runTest("Login Flow", true);
runTest("Checkout Flow", false);
runTest("Search Flow", true);`} />
        <BashBlock code="node functions.js" />
        <p>The words inside the parentheses — <Code>testName</Code> and <Code>passed</Code> — are <strong className="text-white">parameters</strong>. They're slots that get filled with real values each time the function is called.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Define a function called <Code>greetTester</Code> that takes a <Code>name</Code> parameter and prints: <Code>Welcome to the team, [name]!</Code></p>
        <p>Call it three times with different names. Then add a second parameter <Code>role</Code> and update the message to: <Code>Welcome, [name] — role: [role]</Code></p>
        <Callout type="tip">If your function has a typo in the name when calling it, JavaScript says "is not a function". That error message always means: check your spelling.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Functions let you write logic once and reuse it everywhere. Here's a tax calculator — one function, called many times with different inputs:</p>
        <CodeBlock filename="tax.js" language="js" code={`function calculateTax(price, taxRate) {
  const tax = price * (taxRate / 100);
  const total = price + tax;
  return { price, tax, total };
}

function printBill(item, price, taxRate) {
  const bill = calculateTax(price, taxRate);
  console.log(\`\${item}: ₹\${bill.price} + ₹\${bill.tax.toFixed(2)} tax = ₹\${bill.total.toFixed(2)}\`);
}

printBill("Laptop",   45000, 18);
printBill("Notebook",   120, 12);
printBill("Pen",         15,  5);`} />
        <BashBlock code="node tax.js" />
        <OutputBlock output={`Laptop: ₹45000 + ₹8100.00 tax = ₹53100.00
Notebook: ₹120 + ₹14.40 tax = ₹134.40
Pen: ₹15 + ₹0.75 tax = ₹15.75`} />
        <p>If the tax formula ever changes, you update one function — all three bills update automatically. This is why functions are the most important concept in programming.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "A function is a named block of reusable code: function name(params) { ... }",
          "Parameters are slots filled with real values each time the function is called.",
          "Functions eliminate repetition — define once, use everywhere.",
        ]}
        nextLesson={{ number: "1.11", title: "Arrow functions", slug: "arrow-functions" }}
      />

      <GoDeeper>
        <p>Functions can also return values — covered properly in Lesson 1.12. But here's a preview:</p>
        <CodeBlock language="js" code={`function add(a, b) {
  return a + b;
}

const result = add(3, 4);
console.log(result);  // 7`} />
        <p>Without <Code>return</Code>, a function does its work but gives nothing back. With <Code>return</Code>, the function produces a value you can store or use. This distinction matters a lot in Playwright, where many functions return page elements or results.</p>
      </GoDeeper>
    </>
  );
}
