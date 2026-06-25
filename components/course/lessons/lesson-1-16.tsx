import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, CodeBlock, OutputBlock, BashBlock, Callout, Code } from "@/components/course/LessonSections";

export default function Lesson116() {
  return (
    <>
      <TheIdea>
        <p>When an asynchronous operation fails — network error, element not found, timeout — it throws an error. If nothing catches that error, your entire test crashes with an ugly stack trace.</p>
        <p><Code>try/catch</Code> lets you handle errors gracefully: "try to do this — if it fails, catch the error and do something useful instead."</p>
        <p>Think of it like a safety net under a trapeze act. The performer tries the move. If they fall, the net catches them — they don't hit the floor.</p>
      </TheIdea>

      <SeeItRun>
        <OutputBlock output={`Attempting to load page...
Page loaded successfully
---
Attempting to load page...
Failed to load: Network timeout after 5000ms
Retrying with a backup URL...
Backup loaded successfully`} />
        <CodeBlock filename="try-catch.js" language="js" code={`// Simulated async functions
function loadPage(url) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (url.includes("bad")) {
        reject(new Error("Network timeout after 5000ms"));
      } else {
        resolve(\`Page loaded: \${url}\`);
      }
    }, 100);
  });
}

// Without try/catch — an error here crashes the whole script
// await loadPage("bad-url");  // ← would crash

// WITH try/catch — errors are handled gracefully
async function runTest(url) {
  console.log("Attempting to load page...");

  try {
    const result = await loadPage(url);
    console.log("Page loaded successfully");
  } catch (error) {
    console.log("Failed to load:", error.message);
    console.log("Retrying with a backup URL...");
    const backup = await loadPage("https://backup.example.com");
    console.log("Backup loaded successfully");
  }
}

runTest("https://good-url.com");

setTimeout(() => {
  console.log("---");
  runTest("https://bad-url.com");
}, 200);`} />
        <BashBlock code="node try-catch.js" />
      </SeeItRun>

      <NowYouTry>
        <p>Add a <Code>finally</Code> block to the example above:</p>
        <CodeBlock language="js" code={`try {
  // your code
} catch (error) {
  // handle error
} finally {
  console.log("Test run complete — regardless of success or failure");
}`} />
        <p><Code>finally</Code> always runs — whether try succeeded or catch ran. It's perfect for cleanup: closing browsers, resetting state, writing logs.</p>
        <Callout type="info">In Playwright, you rarely need manual try/catch because Playwright already throws helpful errors when things fail. But understanding it lets you read error-handling code and write robust test utilities.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>try/catch is used whenever you're reading user input or external data that might not be in the right format. Here's a JSON parser with proper error handling:</p>
        <CodeBlock filename="parse-input.js" language="js" code={`async function loadConfig(jsonString) {
  try {
    const config = JSON.parse(jsonString);

    // Validate required fields exist
    if (!config.apiUrl) throw new Error("Missing required field: apiUrl");
    if (!config.timeout) throw new Error("Missing required field: timeout");

    console.log("Config loaded successfully");
    console.log(\`  API: \${config.apiUrl}\`);
    console.log(\`  Timeout: \${config.timeout}ms\`);
    return config;

  } catch (error) {
    console.error(\`Config error: \${error.message}\`);
    return null;  // return null instead of crashing
  } finally {
    console.log("--- load attempt complete ---");
  }
}

// Test with valid JSON
await loadConfig('{"apiUrl":"https://api.example.com","timeout":5000}');

// Test with invalid JSON
await loadConfig('this is not json');

// Test with missing field
await loadConfig('{"apiUrl":"https://api.example.com"}');`} />
        <BashBlock code="node parse-input.js" />
        <p>The <Code>finally</Code> block always runs — perfect for cleanup or logging. The function never crashes: it either returns the config or returns <Code>null</Code>. That's graceful error handling.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "try { } contains code that might fail. catch (error) { } handles the failure.",
          "finally { } always runs — useful for cleanup regardless of outcome.",
          "Re-throw the error (throw error) if you want to handle it AND still mark the test as failed.",
        ]}
        nextLesson={{ number: "1.17", title: "Object destructuring", slug: "object-destructuring" }}
      />

      <GoDeeper>
        <p>The <Code>error</Code> object in a <Code>catch</Code> block has two useful properties:</p>
        <CodeBlock language="js" code={`try {
  throw new Error("Something went wrong");
} catch (error) {
  console.log(error.message);  // "Something went wrong" — the human-readable message
  console.log(error.name);     // "Error" — the type of error
  console.log(error.stack);    // full stack trace with file names and line numbers
}`} />
        <p><Code>error.stack</Code> is what you see when a test crashes and shows you that wall of text. Now you know what it is — and you can log just the <Code>.message</Code> for cleaner output.</p>
      </GoDeeper>
    </>
  );
}
