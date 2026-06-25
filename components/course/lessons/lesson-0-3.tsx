import { TheIdea, SeeItRun, NowYouTry, WhyATesterCares, Recap, GoDeeper, Callout, CodeBlock } from "@/components/course/LessonSections";

export default function Lesson03() {
  return (
    <>
      <TheIdea>
        <p>Think of a restaurant. There are two worlds:</p>
        <p><strong className="text-white">Front of house</strong> — the dining room, the menu, the waiter, the plates. This is what the customer sees and touches.</p>
        <p><strong className="text-white">Back of house (the kitchen)</strong> — the chefs, the ovens, the ingredients, the orders. The customer never sees this, but everything depends on it.</p>
        <p>A website works exactly the same way. The front is what you see. The back is what runs when you click something.</p>
      </TheIdea>

      <SeeItRun>
        <p>Let's walk through exactly what happens when you click <strong className="text-white">"Add to Cart"</strong> on Amazon:</p>
        <div className="space-y-3 my-4">
          {[
            ["1. You click the button", "Your browser sends a message to Amazon's servers: 'User 48291 wants to add item B09XYZ to cart.'"],
            ["2. The server receives the request", "Amazon's backend code runs. It checks if the item is in stock, if you're logged in, and calculates the price."],
            ["3. The database is updated", "Your cart record in Amazon's database is updated to include the new item."],
            ["4. The server sends a response", "Amazon's server sends back a message: 'Done. Cart now has 3 items.'"],
            ["5. Your browser updates the page", "The cart icon in the corner changes from 2 to 3. You see the confirmation."],
          ].map(([step, desc]) => (
            <div key={step} className="flex gap-3 rounded-xl bg-[#0F0F0F] border border-white/5 p-4">
              <span className="text-[#00FF88] font-bold text-sm flex-shrink-0 mt-0.5">{step}</span>
              <p className="text-sm text-[#D1D5DB] leading-relaxed">{desc}</p>
            </div>
          ))}
        </div>
        <p>All of that happens in under a second. And every single step is something a tester might need to check.</p>
      </SeeItRun>

      <NowYouTry>
        <p>Open any website — this one, Google, YouTube, anything. Then right-click on the page and click <strong className="text-white">"Inspect"</strong> (or press <strong className="text-white">F12</strong>).</p>
        <div className="rounded-xl border border-blue-500/20 bg-blue-500/5 p-5 my-4">
          <p className="text-sm font-semibold text-white mb-2">What you'll see:</p>
          <ul className="text-sm text-[#D1D5DB] space-y-1.5">
            <li>• A panel with lots of colourful code — that's the HTML (the structure of the page)</li>
            <li>• Hover over any HTML line — it highlights part of the page</li>
            <li>• That's the exact element Playwright will click, fill, or read in a test</li>
          </ul>
        </div>
        <Callout type="tip">You just opened DevTools — a browser built-in tool that every web developer and QA engineer uses daily. You're already using professional tools.</Callout>
      </NowYouTry>

      <WhyATesterCares>
        <p>Playwright controls the <strong className="text-white">front of house</strong> — the part users see. It opens a browser, finds elements in the HTML, and interacts with them exactly like a user would.</p>
        <CodeBlock filename="add-to-cart.spec.js" language="js" code={`// Find the "Add to Cart" button on the page
await page.getByRole('button', { name: 'Add to Cart' }).click();

// Check that the cart count updated
await expect(page.getByLabel('Cart items')).toContainText('3');`} />
        <p>Understanding what a website is made of helps you understand <em>why</em> Playwright works the way it does. It's finding and clicking real HTML elements — the same ones the user sees.</p>
      </WhyATesterCares>

      <Recap
        bullets={[
          "Websites have a front (HTML/CSS/JS the user sees) and a back (servers/databases the user doesn't see).",
          "When you click something, a chain of events fires — request → server → database → response → UI update.",
          "Playwright tests the front — it controls a real browser and interacts with real HTML elements.",
        ]}
        nextLesson={{ number: "0.4", title: "Install everything", slug: "install-everything" }}
      />

      <GoDeeper>
        <p>The three languages every website's front is built with:</p>
        <ul className="space-y-2 mt-2 text-sm">
          {[
            ["HTML", "The structure. Like the skeleton. Defines what elements exist (buttons, text, images)."],
            ["CSS", "The style. Like clothes. Defines how elements look (colour, size, position)."],
            ["JavaScript", "The behaviour. Like muscles. Makes elements do things when clicked, typed in, or hovered."],
          ].map(([lang, desc]) => (
            <li key={lang} className="flex gap-2"><span className="text-[#00FF88] font-bold flex-shrink-0">{lang}</span><span className="text-[#D1D5DB]">{desc}</span></li>
          ))}
        </ul>
        <p className="mt-3">Playwright is written in JavaScript and controls a browser — so it speaks the same language as the websites it tests. That's not a coincidence.</p>
      </GoDeeper>
    </>
  );
}
