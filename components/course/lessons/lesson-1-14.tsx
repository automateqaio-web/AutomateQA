import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson114() {
  return (
    <>
      <TheIdea>
        <p>In Lesson 1.13 we learned that the web is asynchronous — things take time. But how does JavaScript actually handle that?</p>
        <p>The answer is a <strong className="text-white">Promise</strong>: an object that represents a task that hasn't finished yet.</p>
        <p>Think of ordering food at a restaurant. When you order, the waiter doesn't bring you the food instantly. They give you a <em>ticket</em> — a promise that the food is coming. That ticket is in one of three states:</p>
        <ul className="space-y-2 mt-3 text-sm">
          <li className="flex gap-2"><span className="text-yellow-400 font-bold w-20 flex-shrink-0">pending</span><span className="text-[#D1D5DB]">— kitchen is working on it, not done yet</span></li>
          <li className="flex gap-2"><span className="text-[#00FF88] font-bold w-20 flex-shrink-0">fulfilled</span><span className="text-[#D1D5DB]">— food arrived successfully</span></li>
          <li className="flex gap-2"><span className="text-red-400 font-bold w-20 flex-shrink-0">rejected</span><span className="text-[#D1D5DB]">— something went wrong (they're out of that dish)</span></li>
        </ul>
        <p className="mt-3">A JavaScript Promise works exactly the same way.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Ordering food...
[2 seconds pass]
Food arrived: Pizza Margherita
Payment processed: 12.50`} />
        <CodeBlock filename="promises.js" language="js" code={`// A function that returns a Promise
function orderFood(item) {
  return new Promise((resolve, reject) => {
    console.log(\`Ordering \${item}...\`);

    // Simulate a 2-second wait (like a network request)
    setTimeout(() => {
      if (item !== "poison") {
        resolve(\`Food arrived: \${item}\`);   // success
      } else {
        reject("Kitchen refused to make that");  // failure
      }
    }, 2000);
  });
}

// Handle the promise with .then() and .catch()
orderFood("Pizza Margherita")
  .then(result => console.log(result))
  .catch(error => console.log("Error:", error));

// You can chain promises
orderFood("Pizza Margherita")
  .then(result => {
    console.log(result);
    return processPayment(12.50);    // another async step
  })
  .then(payment => console.log(payment))
  .catch(error => console.log("Error:", error));

function processPayment(amount) {
  return Promise.resolve(\`Payment processed: \${amount}\`);
}`} />
        <BashBlock code="node promises.js" />
        <Callout type="info">Don't worry about memorising <Code>new Promise()</Code> syntax — you'll rarely write it from scratch. What matters is being able to <em>read</em> a Promise and understand what it's doing.</Callout>
      </SeeItRun>

      <NowYouTry>
        <p>Run the file above. Then change <Code>"Pizza Margherita"</Code> to <Code>"poison"</Code>. The <Code>.catch()</Code> block should trigger and print the error message.</p>
        <p>This demonstrates the rejected state. In Playwright, the "rejection" happens when an element isn't found, a timeout expires, or an assertion fails.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Promises are the standard way to handle anything that takes time in JavaScript — file reads, network requests, timers. Here's a real pattern: loading user data, then using it:</p>
        <CodeBlock filename="load-user.js" language="js" code={`// Simulating a database lookup that takes some time
function fetchUser(id) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id > 0) {
        resolve({ id, name: "Priya", email: "priya@example.com" });
      } else {
        reject(new Error("User ID must be positive"));
      }
    }, 500);
  });
}

// Use .then() to work with the result when it arrives
fetchUser(42)
  .then(user => console.log(\`Loaded: \${user.name} (\${user.email})\`))
  .catch(err  => console.log(\`Error: \${err.message}\`));

fetchUser(-1)
  .then(user => console.log(\`Loaded: \${user.name}\`))
  .catch(err  => console.log(\`Error: \${err.message}\`));`} />
        <BashBlock code="node load-user.js" />
        <OutputBlock output={`Loaded: Priya (priya@example.com)
Error: User ID must be positive`} />
        <p>This pattern — "try to get data, handle success with <Code>.then()</Code>, handle failure with <Code>.catch()</Code>" — is what every network call in JavaScript looks like under the hood.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "A Promise is an object representing an async task — pending, fulfilled, or rejected.",
          ".then() runs when the Promise resolves. .catch() runs when it rejects.",
          "All Playwright methods return Promises — that's why you always use await with them.",
        ]}
        nextLesson={{ number: "1.15", title: "async / await", slug: "async-await" }}
      />

      <GoDeeper>
        <p><Code>Promise.all()</Code> runs multiple Promises in parallel and waits for ALL of them to finish:</p>
        <CodeBlock language="js" code={`// These run simultaneously, not one after another
const [titleText, buttonVisible, urlMatch] = await Promise.all([
  page.title(),
  page.locator('#submit').isVisible(),
  page.url(),
]);

console.log(titleText, buttonVisible, urlMatch);`} />
        <p>This is useful when you need to check several things on a page at once. It's faster than doing them sequentially because they all happen in parallel.</p>
      </GoDeeper>
    </>
  );
}
