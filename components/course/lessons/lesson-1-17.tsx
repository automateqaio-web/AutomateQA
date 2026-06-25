import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Code } from "@/components/course/LessonSections";

export default function Lesson117() {
  return (
    <>
      <TheIdea>
        <p>When a function returns an object, you often only need one or two properties from it. Without destructuring, you'd write:</p>
        <CodeBlock language="js" code={`const user = getUser();
const name = user.name;
const email = user.email;`} />
        <p>Destructuring does the same thing in one line:</p>
        <CodeBlock language="js" code={`const { name, email } = getUser();`} />
        <p>You're telling JavaScript: "open this object and pull out these specific properties." Cleaner, shorter, same result.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Name: Priya Sharma
Email: priya@example.com
Browser: chromium
Timeout: 30000
First URL: https://example.com
Second URL: https://playwright.dev`} />
        <CodeBlock filename="destructuring.js" language="js" code={`// Object destructuring
const user = {
  name: "Priya Sharma",
  email: "priya@example.com",
  role: "admin",
  age: 28,
};

const { name, email } = user;
console.log("Name:", name);
console.log("Email:", email);

// Rename while destructuring (: newName)
const config = { browser: "chromium", headless: true, timeout: 30000 };
const { browser, timeout: maxWait } = config;
console.log("Browser:", browser);
console.log("Timeout:", maxWait);

// Array destructuring — same idea but with position, not keys
const urls = ["https://example.com", "https://playwright.dev", "https://google.com"];
const [firstUrl, secondUrl] = urls;
console.log("First URL:", firstUrl);
console.log("Second URL:", secondUrl);`} />
        <BashBlock code="node destructuring.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Destructure this object to get <Code>title</Code> and <Code>price</Code> in one line, then print them:</p>
        <CodeBlock language="js" code={`const product = {
  id: 101,
  title: "Wireless Mouse",
  price: 24.99,
  inStock: true,
  category: "Electronics",
};

// Write: const { ?, ? } = product;
// Then console.log both`} />
        <p>Bonus: rename <Code>price</Code> to <Code>cost</Code> during destructuring and log <Code>cost</Code>.</p>
      </NowYouTry>

      <WhyATesterCares>
        <p>Destructuring makes working with API responses and complex objects much cleaner. Here's a real-world example — processing an order response:</p>
        <CodeBlock filename="order.js" language="js" code={`const orderResponse = {
  orderId: "ORD-9821",
  status: "confirmed",
  customer: { name: "Priya Sharma", email: "priya@example.com" },
  items: [
    { product: "Wireless Mouse", qty: 1, price: 599 },
    { product: "USB Hub",        qty: 2, price: 349 },
  ],
  shipping: { method: "express", estimatedDays: 2 },
};

// Without destructuring — repetitive
// console.log(orderResponse.orderId);
// console.log(orderResponse.customer.name);

// With destructuring — clean and readable
const { orderId, status, customer: { name, email }, items, shipping: { estimatedDays } } = orderResponse;

console.log(\`Order \${orderId} is \${status}\`);
console.log(\`Customer: \${name} (\${email})\`);
console.log(\`Estimated delivery: \${estimatedDays} days\`);
console.log(\`Items ordered: \${items.length}\`);

// Array destructuring on items
const [firstItem, secondItem] = items;
console.log(\`First item: \${firstItem.product}\`);`} />
        <BashBlock code="node order.js" />
        <p>Real API responses look exactly like this — deeply nested objects with many fields. Destructuring lets you pull out exactly what you need in one line.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "const { a, b } = obj — pull out named properties from an object in one line.",
          "const { a: renamed } = obj — destructure and rename at the same time.",
          "const [first, second] = array — destructure an array by position.",
        ]}
        nextLesson={{ number: "1.18 ★", title: "Mini Playwright Win", slug: "mini-playwright-win" }}
      />

      <GoDeeper>
        <p>You can also destructure with defaults — if the property doesn't exist, use this value instead:</p>
        <CodeBlock language="js" code={`const config = { browser: "chromium" };

const { browser, timeout = 30000, headless = true } = config;
// timeout and headless aren't in config — they fall back to defaults

console.log(browser);   // chromium
console.log(timeout);   // 30000 (default)
console.log(headless);  // true (default)`} />
        <p>This is exactly how Playwright's configuration system works — you provide the options you care about, and the rest use sensible defaults. Understanding destructuring with defaults makes <Code>playwright.config.ts</Code> readable at a glance.</p>
      </GoDeeper>
    </>
  );
}
