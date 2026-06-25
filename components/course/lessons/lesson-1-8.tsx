import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson18() {
  return (
    <>
      <TheIdea>
        <p>Every decision in code is an if/else. Literally every one.</p>
        <p>"If the button is visible, click it. Otherwise, log an error." That's an if/else. "If the user is logged in, show the dashboard. Otherwise, redirect to login." Same structure.</p>
        <p>The syntax in JavaScript mirrors how you think in English — once you see it, you can't unsee it.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Score: 82
Grade: B
Result: PASS
Quick result: PASS`} />
        <CodeBlock filename="if-else.js" language="js" code={`const score = 82;

// Basic if/else
if (score >= 90) {
  console.log("Grade: A");
} else if (score >= 80) {
  console.log("Grade: B");
} else if (score >= 70) {
  console.log("Grade: C");
} else {
  console.log("Grade: F");
}

// You can also store the result in a variable
let result;
if (score >= 60) {
  result = "PASS";
} else {
  result = "FAIL";
}
console.log("Result:", result);

// Ternary — a one-line shortcut for simple if/else
const quickResult = score >= 60 ? "PASS" : "FAIL";
console.log("Quick result:", quickResult);`} />
        <BashBlock code="node if-else.js" />
        <p>The ternary reads as: <em>condition</em> <Code>?</Code> <em>value-if-true</em> <Code>:</Code> <em>value-if-false</em></p>
      </SeeItRun>

      <NowYouTry>
        <p>Change <Code>score</Code> to <Code>55</Code> and predict the output before running. Then try <Code>92</Code>.</p>
        <p>Bonus: write a ternary that checks if a username has more than 3 characters and returns <Code>"valid"</Code> or <Code>"too short"</Code>:</p>
        <CodeBlock language="js" code={`const username = "QA";
// write your ternary here`} />
        <Callout type="tip">Ternaries are great for one-liner decisions. For anything with more than 2 branches, use full if/else — it's easier to read.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>if/else decisions appear in every real program. Here's a simple shipping cost calculator — the kind of logic that's inside every e-commerce site:</p>
        <CodeBlock filename="shipping.js" language="js" code={`function getShippingCost(orderTotal, isMember) {
  if (isMember && orderTotal >= 500) {
    return 0;                  // free shipping for members with big orders
  } else if (isMember) {
    return 49;                 // discounted shipping for members
  } else if (orderTotal >= 1000) {
    return 0;                  // free shipping for large non-member orders
  } else {
    return 99;                 // standard shipping
  }
}

console.log(getShippingCost(600, true));   // 0
console.log(getShippingCost(200, true));   // 49
console.log(getShippingCost(1200, false)); // 0
console.log(getShippingCost(300, false));  // 99`} />
        <BashBlock code="node shipping.js" />
        <p>Notice how each <Code>if</Code> / <Code>else if</Code> / <Code>else</Code> branch handles one specific case. That clear structure is what makes code readable and maintainable.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "if/else runs different code depending on whether a condition is true or false.",
          "else if lets you chain multiple conditions — JS picks the first matching branch.",
          "Ternary (condition ? a : b) is a one-line shortcut — use it for simple true/false swaps.",
        ]}
        nextLesson={{ number: "1.9", title: "for loops", slug: "for-loops" }}
      />

      <GoDeeper>
        <p>A common pattern you'll see in real Playwright test suites is a "guard clause" — an early return that avoids deep nesting:</p>
        <CodeBlock language="js" code={`// Nested (harder to read)
if (isLoggedIn) {
  if (hasPermission) {
    runTest();
  }
}

// Guard clause (cleaner — same logic, reversed)
if (!isLoggedIn) return;
if (!hasPermission) return;
runTest();`} />
        <p>Guard clauses are considered best practice in professional test code. You'll start noticing this pattern everywhere once you know to look for it.</p>
      </GoDeeper>
    </>
  );
}
