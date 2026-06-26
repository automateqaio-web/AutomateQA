-- Playwright Beginner Interview Questions (Q1–Q25)
-- Technology: Playwright | Difficulty: Beginner | Experience: Fresher / 1-2 Years
-- Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Playwright and what are its key features?',
  'what-is-playwright-and-key-features',
  'Playwright is an open-source browser automation framework by Microsoft supporting Chromium, Firefox, and WebKit with built-in auto-waiting, network interception, and cross-browser testing.',
  $$## What is Playwright?

Playwright is an **open-source browser automation framework** developed by **Microsoft**, released in 2020. It was built by engineers who previously developed Puppeteer at Google. Playwright enables reliable end-to-end testing for modern web applications.

## Key Features

### 1. Cross-Browser Support
Playwright tests run on all major browsers with a single unified API:
- **Chromium** (Google Chrome, Microsoft Edge)
- **Firefox**
- **WebKit** (Safari engine)

### 2. Multi-Language Support
- JavaScript / TypeScript
- Python
- Java
- C# (.NET)

### 3. Auto-Waiting
Playwright automatically waits for elements to be actionable before interacting — no `sleep()` or manual wait chains needed.

```typescript
// No explicit wait required — Playwright handles it
await page.click('#submit-button');
await expect(page.locator('.success-msg')).toBeVisible();
```

### 4. Built-in Network Interception
Mock API responses, intercept HTTP calls, and simulate network conditions — all built-in.

### 5. Browser Contexts
Isolated browser sessions per test so cookies, storage, and auth never leak between tests.

### 6. Smart Locators
Role-based, text-based, and test-ID-based locators that are stable and don't rely on fragile CSS paths.

### 7. Powerful Debugging Tools
- **Playwright Inspector** — step-through debugger
- **Trace Viewer** — full timeline replay of test execution
- **UI Mode** — interactive test runner
- **Codegen** — auto-record tests by clicking in the browser

### 8. Parallel Execution & Sharding
Run tests in parallel workers; shard across machines in CI.

### 9. Soft Assertions
Collect multiple assertion failures in one test run — don't stop at first failure.

### 10. Built-in Screenshot & Video
Capture screenshots, full-page captures, and record videos on test failure automatically.

## Quick Example

```typescript
import { test, expect } from '@playwright/test';

test('user can log in', async ({ page }) => {
  await page.goto('https://myapp.com/login');
  await page.fill('#email', 'user@example.com');
  await page.fill('#password', 'secret');
  await page.click('button[type="submit"]');
  await expect(page).toHaveURL('/dashboard');
});
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Introduction', 'Features', 'Getting Started'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Which browsers does Playwright support?',
  'which-browsers-does-playwright-support',
  'Playwright supports Chromium (Chrome/Edge), Firefox, and WebKit (Safari) out of the box with a single API.',
  $$## Playwright Browser Support

Playwright supports **three browser engines** that cover all major browsers:

| Browser Engine | Real Browsers Covered | Notes |
|---------------|----------------------|-------|
| **Chromium** | Google Chrome, Microsoft Edge | Uses latest Chromium build |
| **Firefox** | Mozilla Firefox | Uses latest Firefox release |
| **WebKit** | Apple Safari | Uses Safari's engine (not full Safari) |

## How Playwright Installs Browsers

When you install Playwright, it downloads its own managed browser binaries:
```bash
npx playwright install
# Downloads Chromium, Firefox, and WebKit
```

You can install specific browsers only:
```bash
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit
```

## Running Tests on All Browsers

In `playwright.config.ts`, define projects per browser:

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox',  use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit',   use: { ...devices['Desktop Safari'] } },
  ],
});
```

Run all browser projects:
```bash
npx playwright test --project=chromium
npx playwright test  # runs all configured projects
```

## Key Differences from Selenium Browser Support

- Playwright ships its **own browser binaries** — no need to install ChromeDriver/GeckoDriver separately
- Tests run on the **same browser versions** regardless of what is installed on the machine
- Ensures **reproducible test results** across all environments

## Mobile Browser Emulation

Playwright can also emulate mobile devices:
```typescript
{ name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
{ name: 'Mobile Safari', use: { ...devices['iPhone 12'] } },
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Browsers', 'Cross-Browser', 'Chromium', 'Firefox', 'WebKit'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you install Playwright?',
  'how-to-install-playwright',
  'Install Playwright using npm init playwright@latest which sets up the test runner, config file, and downloads browser binaries automatically.',
  $$## Installing Playwright

### Method 1: Interactive Setup (Recommended for new projects)

```bash
npm init playwright@latest
```

This command:
1. Asks which language (TypeScript or JavaScript)
2. Asks where to put tests (default: `tests/`)
3. Adds a GitHub Actions workflow (optional)
4. Installs `@playwright/test` package
5. Creates `playwright.config.ts`
6. Creates a sample test file
7. Downloads Chromium, Firefox, and WebKit browser binaries

### Method 2: Manual Install into Existing Project

```bash
# Install the package
npm install --save-dev @playwright/test

# Install browser binaries
npx playwright install

# Optional: install only specific browsers
npx playwright install chromium
```

### Method 3: Install with Dependencies (for Linux CI)

```bash
npx playwright install --with-deps chromium
```

Installs the browser AND all OS-level dependencies (fonts, codecs) needed on Ubuntu/Debian.

## What Gets Created

```
my-project/
├── tests/
│   └── example.spec.ts     # Sample test
├── playwright.config.ts     # Configuration file
├── package.json
└── node_modules/
    └── @playwright/test/
```

## Verify Installation

```bash
npx playwright --version
# Shows: Version 1.x.x

npx playwright test
# Runs all tests in the tests/ folder
```

## Running Your First Test

The generated sample test at `tests/example.spec.ts`:

```typescript
import { test, expect } from '@playwright/test';

test('has title', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  await expect(page).toHaveTitle(/Playwright/);
});
```

```bash
npx playwright test                  # Run all tests
npx playwright test --headed         # Run with browser visible
npx playwright show-report           # Open HTML report
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Installation', 'Setup', 'npm', 'Getting Started'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between Playwright and Selenium?',
  'difference-between-playwright-and-selenium',
  'Playwright is faster with built-in auto-waiting and network interception; Selenium uses W3C WebDriver protocol, requires manual waits, and supports more languages and older browser versions.',
  $$## Playwright vs Selenium — Full Comparison

| Feature | Playwright | Selenium |
|---------|-----------|---------|
| **Developer** | Microsoft | Open-source community (Selenium HQ) |
| **Year Created** | 2020 | 2004 |
| **Protocol** | Chrome DevTools Protocol (CDP) + WebSocket | W3C WebDriver Protocol (HTTP) |
| **Speed** | Fast (direct browser connection) | Slower (HTTP round trips) |
| **Auto-Wait** | Built-in — waits for elements to be ready | Manual (implicit/explicit/fluent waits) |
| **Supported Browsers** | Chromium, Firefox, WebKit | Chrome, Firefox, Safari, Edge, IE |
| **Languages** | JS, TS, Python, Java, C# | Java, Python, C#, Ruby, JS, Kotlin |
| **Network Interception** | Built-in (`page.route()`) | Requires BrowserMob Proxy or similar |
| **Browser Context** | Native multi-session isolation | Single WebDriver session |
| **Mobile Emulation** | Built-in device emulation | Via ChromeOptions (limited) |
| **iFrame Handling** | Easy (`frameLocator()`) | Complex (`switchTo().frame()`) |
| **Shadow DOM** | Supported natively | Requires JavaScript workarounds |
| **Setup Complexity** | Simple (`npm init playwright@latest`) | Complex (separate driver downloads) |
| **Test Recorder** | Built-in `codegen` | Selenium IDE (separate tool) |
| **Debugging** | Trace Viewer, UI Mode, Inspector | Browser console, logs |
| **Screenshots/Video** | Built-in | Third-party (Allure, ExtentReports) |
| **Parallel Execution** | Built-in workers + sharding | TestNG parallel (requires setup) |
| **IE Support** | No | Yes (legacy) |
| **Community** | Growing rapidly | Large, well-established |

## Key Advantages of Playwright

**1. Auto-waiting eliminates flakiness**
```typescript
// Playwright — just click, it waits automatically
await page.click('#submit');

// Selenium — you must manage waits
wait.until(ExpectedConditions.elementToBeClickable(By.id("submit")));
driver.findElement(By.id("submit")).click();
```

**2. Network mocking built in**
```typescript
await page.route('/api/user', route =>
  route.fulfill({ json: { name: 'Test User' } })
);
```

**3. Multiple pages in one test**
```typescript
const page2 = await context.newPage();
await page2.goto('https://other-site.com');
```

## When to Choose Selenium
- Legacy enterprise projects already on Selenium
- IE/Edge Legacy browser testing required
- Team expertise already in Selenium + Java
- Project uses languages Playwright doesn't support (Ruby)$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Selenium', 'Comparison', 'Framework Comparison'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between Playwright and Cypress?',
  'difference-between-playwright-and-cypress',
  'Playwright supports multiple browsers and languages with true multi-tab support; Cypress is JavaScript-only with better in-browser debugging but limited to Chromium-based and Firefox browsers.',
  $$## Playwright vs Cypress

| Feature | Playwright | Cypress |
|---------|-----------|---------|
| **Browser Support** | Chromium, Firefox, WebKit (Safari) | Chrome, Edge, Firefox (no Safari) |
| **Language Support** | JS, TS, Python, Java, C# | JavaScript / TypeScript only |
| **Architecture** | Out-of-process (controls browser externally) | In-process (runs inside browser) |
| **Multi-Tab Support** | Yes — native | No — cannot open new tabs |
| **iFrame Support** | Yes — `frameLocator()` | Limited |
| **Network Stubbing** | `page.route()` — intercepts all requests | `cy.intercept()` — similar |
| **Speed** | Fast | Fast (but can be slower on CI) |
| **Mobile Testing** | Device emulation, limited real device | Limited emulation |
| **Component Testing** | Yes (experimental) | Yes (mature) |
| **API Testing** | Yes — `request` fixture | Yes — `cy.request()` |
| **Parallelism** | Workers + sharding (built-in) | Requires Cypress Cloud (paid) |
| **Debugging** | Trace Viewer, UI Mode, Inspector | Time-travel debugging in browser |
| **Community** | Growing fast | Large, established |
| **Pricing** | Free (open source) | Free (open) + Cypress Cloud (paid) |
| **Cross-Origin** | No restriction | Same-origin restrictions apply |

## Architecture Difference

**Cypress** runs JavaScript **inside** the browser — it has direct DOM access but cannot control multiple tabs or cross-origin requests without workarounds.

**Playwright** runs **outside** the browser and controls it via protocol — giving full control over network, multiple pages, downloads, and browser contexts.

## Code Style Comparison

**Playwright:**
```typescript
// Async/await — standard JavaScript
test('login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('#email', 'user@test.com');
  await page.click('#submit');
  await expect(page).toHaveURL('/dashboard');
});
```

**Cypress:**
```javascript
// Command chaining — Cypress-specific syntax
it('login', () => {
  cy.visit('/login');
  cy.get('#email').type('user@test.com');
  cy.get('#submit').click();
  cy.url().should('include', '/dashboard');
});
```

## When to Choose Playwright
- Safari/WebKit testing is required
- Multi-tab/multi-window testing needed
- Non-JavaScript team (Python/Java)
- Cross-origin scenarios
- Large test suites needing free parallelism

## When to Choose Cypress
- JavaScript-only team with browser-debugging focus
- Component testing focus
- Heavy use of Cypress plugins/ecosystem$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Cypress', 'Comparison', 'Framework Comparison'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are locators in Playwright and what types are available?',
  'what-are-locators-in-playwright',
  'Locators in Playwright are smart element selectors that auto-wait and auto-retry. They include role, text, label, placeholder, test-id, CSS, and XPath locators.',
  $$## What are Locators in Playwright?

Locators are **strict, auto-retrying element selectors** in Playwright. Unlike `page.$()` which returns a static element handle, locators represent a way to find elements and **retry automatically** when the element is not yet available.

## Types of Locators

### 1. Role Locator (Most Recommended)
Uses ARIA roles — the most accessible and resilient locator.
```typescript
page.getByRole('button', { name: 'Submit' })
page.getByRole('textbox', { name: 'Email' })
page.getByRole('link', { name: 'Sign in' })
page.getByRole('checkbox', { name: 'Remember me' })
page.getByRole('heading', { name: 'Dashboard' })
```

### 2. Text Locator
Locate by visible text content.
```typescript
page.getByText('Welcome back')
page.getByText('Terms and Conditions', { exact: true })
```

### 3. Label Locator
Locate form fields by their associated label text.
```typescript
page.getByLabel('Email address')
page.getByLabel('Password')
```

### 4. Placeholder Locator
Locate inputs by placeholder text.
```typescript
page.getByPlaceholder('Enter your email')
page.getByPlaceholder('Search...')
```

### 5. Alt Text Locator
Locate images by alt attribute.
```typescript
page.getByAltText('Company logo')
```

### 6. Title Locator
Locate by title attribute (tooltips).
```typescript
page.getByTitle('Close dialog')
```

### 7. Test ID Locator (Best for Teams)
Locate by `data-testid` attribute — decoupled from UI implementation.
```typescript
page.getByTestId('login-button')
page.getByTestId('user-email-input')
```
HTML: `<button data-testid="login-button">Login</button>`

### 8. CSS Selector
Traditional CSS selectors.
```typescript
page.locator('#username')
page.locator('.btn-primary')
page.locator('input[type="email"]')
```

### 9. XPath
XPath expressions.
```typescript
page.locator('//button[text()="Submit"]')
page.locator('xpath=//div[@class="container"]')
```

## Locator Best Practice Priority

```
getByRole()    → Best (accessible, resilient)
getByLabel()   → Great for form fields
getByText()    → Good for visible text
getByTestId()  → Best for teams (requires dev cooperation)
CSS Selector   → Acceptable
XPath          → Last resort
```

## Key Locator Methods

```typescript
await locator.click()
await locator.fill('text')
await locator.check()
await locator.selectOption('value')
await locator.waitFor()
await expect(locator).toBeVisible()
const count = await locator.count()
const text = await locator.textContent()
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Locators', 'getByRole', 'getByText', 'getByLabel', 'CSS', 'XPath'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you navigate to a URL in Playwright?',
  'how-to-navigate-to-url-in-playwright',
  'Use page.goto(url) to navigate to a URL. Playwright waits for the page to load and returns a Response object.',
  $$## Navigating to a URL in Playwright

### Basic Navigation

```typescript
await page.goto('https://example.com');
```

Playwright **automatically waits** for the page to reach a network-idle or load state before continuing.

### Navigation with Wait Strategy

```typescript
// Wait until 'load' event fires (default)
await page.goto('https://example.com', { waitUntil: 'load' });

// Wait until DOMContentLoaded
await page.goto('https://example.com', { waitUntil: 'domcontentloaded' });

// Wait until no network activity for 500ms (great for SPAs)
await page.goto('https://example.com', { waitUntil: 'networkidle' });

// Wait until page commits navigation (fastest — no wait for loading)
await page.goto('https://example.com', { waitUntil: 'commit' });
```

### With Custom Timeout

```typescript
await page.goto('https://slow-site.com', { timeout: 60000 }); // 60s timeout
```

### Get the Response

```typescript
const response = await page.goto('https://api.example.com');
console.log(response?.status()); // 200
```

### Other Navigation Methods

```typescript
// Go back to previous page
await page.goBack();

// Go forward
await page.goForward();

// Reload the page
await page.reload();

// Wait for a specific URL after navigation (useful after form submit)
await page.waitForURL('**/dashboard');
await page.waitForURL(/dashboard/);
```

### Full Example in a Test

```typescript
import { test, expect } from '@playwright/test';

test('navigate and verify page title', async ({ page }) => {
  await page.goto('https://playwright.dev');

  await expect(page).toHaveTitle(/Playwright/);
  await expect(page).toHaveURL('https://playwright.dev/');
});
```

### Relative URLs (Using baseURL)

Set `baseURL` in `playwright.config.ts` and use relative paths:

```typescript
// playwright.config.ts
export default defineConfig({
  use: { baseURL: 'https://myapp.com' },
});

// In test
await page.goto('/login');   // Resolves to https://myapp.com/login
await page.goto('/dashboard');
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Navigation', 'page.goto', 'URL', 'waitUntil'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you click an element in Playwright?',
  'how-to-click-element-in-playwright',
  'Use locator.click() to click an element. Playwright auto-waits for the element to be visible, enabled, and stable before clicking.',
  $$## Clicking Elements in Playwright

### Basic Click

```typescript
// Using role locator
await page.getByRole('button', { name: 'Submit' }).click();

// Using text locator
await page.getByText('Login').click();

// Using CSS locator
await page.locator('#submit-btn').click();

// Using label-associated form button
await page.getByLabel('Search').click();
```

### What Happens During click()

Playwright automatically:
1. Waits for the element to be **visible** in the DOM
2. Waits for it to be **enabled** (not disabled)
3. Waits for it to be **stable** (not animating)
4. **Scrolls** it into view if needed
5. **Moves the mouse** to the center of the element
6. Fires `mousedown`, `mouseup`, `click` events

### Click Options

```typescript
// Click with a modifier key
await page.locator('#item').click({ modifiers: ['Shift'] });   // Shift+Click
await page.locator('#item').click({ modifiers: ['Control'] }); // Ctrl+Click

// Click at a specific position within the element
await page.locator('#canvas').click({ position: { x: 100, y: 50 } });

// Click with a delay (simulate slow user)
await page.locator('#btn').click({ delay: 100 });

// Force click (bypass actionability checks — use carefully)
await page.locator('#hidden-btn').click({ force: true });

// Click with custom timeout
await page.locator('#btn').click({ timeout: 10000 });
```

### Double Click

```typescript
await page.locator('#cell').dblclick();
```

### Right Click (Context Menu)

```typescript
await page.locator('#item').click({ button: 'right' });
```

### Middle Click

```typescript
await page.locator('#link').click({ button: 'middle' });
```

### Click Inside a Specific Parent

```typescript
// Click a button within a specific modal
const modal = page.locator('.modal');
await modal.getByRole('button', { name: 'Confirm' }).click();
```

### Full Example

```typescript
import { test, expect } from '@playwright/test';

test('form submit', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Click', 'Actions', 'Locators', 'Auto-wait'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between page.fill() and page.type() in Playwright?',
  'difference-between-page-fill-and-page-type-in-playwright',
  'page.fill() clears the field and sets the value instantly; page.type() simulates real keyboard key presses character by character with optional delay.',
  $$## page.fill() vs page.type() in Playwright

### page.fill() — Set Value Instantly

```typescript
await page.fill('#email', 'user@example.com');
// OR
await page.getByLabel('Email').fill('user@example.com');
```

**Behavior:**
- **Clears** any existing content first
- **Sets** the value in one atomic operation
- Does NOT fire individual keypress events
- Very **fast** — doesn't simulate typing
- Works with `<input>`, `<textarea>`, `[contenteditable]`

**Best for:** Login forms, data entry, any input where you just want to set a value quickly.

---

### page.type() / locator.pressSequentially() — Simulate Real Typing

```typescript
// Older method
await page.type('#search', 'playwright automation');

// Modern equivalent (Playwright v1.29+)
await page.getByRole('searchbox').pressSequentially('playwright automation', { delay: 50 });
```

**Behavior:**
- Types character **by character**
- Fires `keydown`, `keypress`, `keyup` events for each character
- Triggers auto-suggest/autocomplete widgets
- Optional `delay` between keystrokes (in milliseconds)
- Does NOT clear existing content first (appends to current value)

**Best for:** Autocomplete dropdowns, search-as-you-type, Google Suggest style inputs.

---

## Comparison Table

| | `fill()` | `type()` / `pressSequentially()` |
|--|---------|------|
| **Clears field first** | Yes | No |
| **Speed** | Instant | Character by character |
| **Triggers key events** | No | Yes (`keydown`, `keyup`, etc.) |
| **Fires input events** | Yes | Yes |
| **Autocomplete support** | No | Yes |
| **Use case** | Most inputs | Autocomplete, search boxes |

## Which to Use?

```typescript
// Standard form field — use fill()
await page.getByLabel('Username').fill('john_doe');

// Search with autocomplete — use pressSequentially
await page.getByRole('searchbox').pressSequentially('New Y', { delay: 100 });
await page.getByText('New York').click(); // select from dropdown

// Clear and re-type
await page.locator('#field').clear();
await page.locator('#field').fill('new value');
```

> **Best Practice:** Use `fill()` for almost all cases. Use `pressSequentially()` only when your app depends on key events (e.g., autocomplete, character counters, real-time validation).$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'fill', 'type', 'Input', 'Keyboard', 'pressSequentially'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is auto-waiting in Playwright?',
  'what-is-auto-waiting-in-playwright',
  'Auto-waiting means Playwright automatically waits for elements to be visible, enabled, and stable before performing actions — eliminating the need for manual sleep() or explicit waits.',
  $$## What is Auto-Waiting in Playwright?

Auto-waiting is one of Playwright's most powerful features. Before every **action** (click, fill, check, etc.), Playwright automatically waits for the target element to be in an **actionable state** — without you writing any wait code.

## What Playwright Checks Before Each Action

When you call `locator.click()`, Playwright waits for ALL of these:

| Check | Description |
|-------|-------------|
| **Attached** | Element exists in the DOM |
| **Visible** | Element is visible (not `display:none`, not `opacity:0`, not zero size) |
| **Stable** | Element is not animating or moving |
| **Enabled** | Element is not `disabled` |
| **Editable** | For fill/type — element is not `readonly` |
| **Receives Events** | No overlay is blocking the element |

## Before Auto-waiting (Selenium-style)

```java
// Selenium — you had to write this manually
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.elementToBeClickable(By.id("submit")));
driver.findElement(By.id("submit")).click();
```

## With Playwright Auto-waiting

```typescript
// Playwright — just click. It waits automatically.
await page.getByRole('button', { name: 'Submit' }).click();
```

## Auto-waiting in Assertions

`expect()` also retries automatically — it re-checks until the assertion passes or times out:

```typescript
// Playwright retries this assertion until it's true (up to timeout)
await expect(page.locator('.success-banner')).toBeVisible();
await expect(page.locator('#count')).toHaveText('10');
```

No need for `sleep(2000)` before checking!

## Default Timeouts

| Context | Default Timeout |
|---------|----------------|
| Action timeout (`click`, `fill`, etc.) | 30 seconds |
| `expect()` assertion | 5 seconds |
| `page.goto()` navigation | 30 seconds |

Override globally in config:
```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    actionTimeout: 10_000,    // 10s per action
    navigationTimeout: 30_000, // 30s for navigation
  },
  expect: { timeout: 10_000 }, // 10s for assertions
});
```

Override per action:
```typescript
await page.locator('#slow-element').click({ timeout: 60000 });
```

## Why This Eliminates Flakiness

Most test flakiness comes from timing issues — an element isn't ready yet when the test tries to interact with it. Auto-waiting directly solves this by making every interaction inherently wait for the right state.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Auto-waiting', 'Waits', 'Actionability', 'Timeouts', 'Flakiness'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you take a screenshot in Playwright?',
  'how-to-take-screenshot-in-playwright',
  'Use page.screenshot() for full page or viewport screenshots, or locator.screenshot() to capture a specific element.',
  $$## Taking Screenshots in Playwright

### Full Page Screenshot

```typescript
// Capture the visible viewport
await page.screenshot({ path: 'screenshot.png' });

// Capture the FULL scrollable page (not just viewport)
await page.screenshot({ path: 'full-page.png', fullPage: true });
```

### Element Screenshot

```typescript
// Capture only a specific element
await page.locator('.chart-container').screenshot({ path: 'chart.png' });
await page.getByRole('dialog').screenshot({ path: 'modal.png' });
```

### Screenshot in Different Formats

```typescript
// PNG (default, lossless)
await page.screenshot({ path: 'screenshot.png' });

// JPEG (smaller file size)
await page.screenshot({ path: 'screenshot.jpg', type: 'jpeg', quality: 80 });
```

### Screenshot as Buffer (without saving to file)

```typescript
const buffer = await page.screenshot();
// Useful for attaching to reports or sending to APIs
```

### Auto-screenshot on Test Failure

In `playwright.config.ts`:
```typescript
export default defineConfig({
  use: {
    screenshot: 'only-on-failure', // 'off' | 'on' | 'only-on-failure'
  },
});
```

Screenshots saved to `test-results/` folder automatically.

### Screenshot with Clip Region

```typescript
// Capture only a rectangular region of the page
await page.screenshot({
  path: 'header.png',
  clip: { x: 0, y: 0, width: 1280, height: 100 },
});
```

### Screenshot Inside a Test

```typescript
import { test, expect } from '@playwright/test';

test('capture checkout page', async ({ page }) => {
  await page.goto('/checkout');

  // Fill cart
  await page.getByRole('button', { name: 'Add to cart' }).click();

  // Take screenshot before asserting
  await page.screenshot({ path: 'test-results/checkout.png', fullPage: true });

  await expect(page.locator('.cart-total')).toBeVisible();
});
```

### Visual Comparison (Snapshot Testing)

```typescript
// Compare to a baseline screenshot
await expect(page).toMatchSnapshot('homepage.png');
await expect(page.locator('.hero-section')).toMatchSnapshot('hero.png');
```

First run creates the baseline. Subsequent runs compare and fail if different.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Screenshot', 'Visual Testing', 'Debugging', 'Full Page'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the expect() function in Playwright and how do you use assertions?',
  'what-is-expect-function-in-playwright-assertions',
  'expect() in Playwright provides async assertions that automatically retry until the condition passes or times out — preventing flaky tests.',
  $$## Playwright Assertions with expect()

Playwright uses `expect()` from `@playwright/test` for **web-first assertions** — they automatically retry until the condition is true (up to the assertion timeout).

## Common Assertions

### Page Assertions

```typescript
// URL checks
await expect(page).toHaveURL('https://example.com/dashboard');
await expect(page).toHaveURL(/dashboard/);

// Page title
await expect(page).toHaveTitle('My App - Dashboard');
await expect(page).toHaveTitle(/Dashboard/);
```

### Element Visibility

```typescript
await expect(page.locator('.success-msg')).toBeVisible();
await expect(page.locator('.loading-spinner')).toBeHidden();
await expect(page.locator('#submit-btn')).toBeEnabled();
await expect(page.locator('#submit-btn')).toBeDisabled();
```

### Element Text

```typescript
await expect(page.locator('h1')).toHaveText('Welcome');
await expect(page.locator('.error')).toContainText('required');
await expect(page.locator('.badge')).toHaveText(/\d+ items/);
```

### Element Count

```typescript
await expect(page.locator('li.product')).toHaveCount(5);
```

### Input Value

```typescript
await expect(page.getByLabel('Email')).toHaveValue('user@test.com');
```

### Checkbox State

```typescript
await expect(page.getByLabel('Remember me')).toBeChecked();
await expect(page.getByLabel('Newsletter')).not.toBeChecked();
```

### CSS Classes and Attributes

```typescript
await expect(page.locator('#menu')).toHaveClass(/active/);
await expect(page.locator('img')).toHaveAttribute('alt', 'Profile photo');
```

## Negation with .not

```typescript
await expect(page.locator('.error-banner')).not.toBeVisible();
await expect(page.locator('.spinner')).not.toBeVisible();
```

## Soft Assertions (non-stopping)

```typescript
// Test continues even if this assertion fails
await expect.soft(page.locator('.price')).toHaveText('$99');
await expect.soft(page.locator('.discount')).toBeVisible();
// All failures reported at end of test
```

## Custom Timeout

```typescript
await expect(page.locator('.chart')).toBeVisible({ timeout: 15000 });
```

## Full Test Example

```typescript
import { test, expect } from '@playwright/test';

test('login and verify dashboard', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('pass123');
  await page.getByRole('button', { name: 'Sign in' }).click();

  await expect(page).toHaveURL('/dashboard');
  await expect(page.getByRole('heading')).toHaveText('Welcome back');
  await expect(page.locator('.avatar')).toBeVisible();
});
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Assertions', 'expect', 'toBeVisible', 'toHaveText', 'Soft Assertions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you select a value from a dropdown in Playwright?',
  'how-to-select-dropdown-value-in-playwright',
  'Use locator.selectOption() for native <select> elements. For custom dropdowns, click to open and then click the desired option.',
  $$## Selecting Dropdown Values in Playwright

### Native HTML <select> Dropdown

Use `locator.selectOption()` for standard `<select>` elements:

```typescript
// Select by value attribute
await page.getByLabel('Country').selectOption('US');

// Select by visible text
await page.getByLabel('Country').selectOption({ label: 'United States' });

// Select by index (0-based)
await page.getByLabel('Country').selectOption({ index: 2 });

// Select multiple options (for <select multiple>)
await page.locator('#skills').selectOption(['javascript', 'typescript', 'python']);
```

HTML example this works on:
```html
<select id="country">
  <option value="US">United States</option>
  <option value="UK">United Kingdom</option>
  <option value="IN">India</option>
</select>
```

### Verify Selected Value

```typescript
await expect(page.getByLabel('Country')).toHaveValue('US');
```

---

### Custom Dropdown (Not a <select>)

For React/Angular/Material UI dropdowns that are built with `<div>` or `<ul>`:

```typescript
// Step 1: Click to open the dropdown
await page.getByRole('combobox', { name: 'Country' }).click();

// Step 2: Wait for options to appear and click the desired one
await page.getByRole('option', { name: 'United States' }).click();

// Or using text locator
await page.locator('.dropdown-menu').getByText('United States').click();
```

### Material UI / Ant Design / Select2 Pattern

```typescript
// Click the dropdown trigger
await page.locator('[data-testid="country-select"]').click();

// Wait for dropdown list to be visible
await page.locator('.select-dropdown').waitFor({ state: 'visible' });

// Click the option
await page.locator('.select-option').filter({ hasText: 'India' }).click();
```

### Full Example

```typescript
import { test, expect } from '@playwright/test';

test('submit registration form', async ({ page }) => {
  await page.goto('/register');

  await page.getByLabel('First Name').fill('John');

  // Native select
  await page.getByLabel('Country').selectOption('US');

  // Custom dropdown
  await page.getByTestId('role-select').click();
  await page.getByRole('option', { name: 'QA Engineer' }).click();

  await page.getByRole('button', { name: 'Register' }).click();
  await expect(page).toHaveURL('/welcome');
});
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Dropdown', 'selectOption', 'Custom Dropdown', 'Select Element'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle checkboxes and radio buttons in Playwright?',
  'how-to-handle-checkboxes-radio-buttons-in-playwright',
  'Use locator.check(), locator.uncheck(), and locator.setChecked() for checkboxes. Use locator.check() for radio buttons. Verify state with toBeChecked().',
  $$## Handling Checkboxes in Playwright

### Check a Checkbox

```typescript
// By label (most readable)
await page.getByLabel('I agree to Terms').check();

// By test ID
await page.getByTestId('terms-checkbox').check();

// By role
await page.getByRole('checkbox', { name: 'Remember me' }).check();
```

### Uncheck a Checkbox

```typescript
await page.getByLabel('Subscribe to newsletter').uncheck();
```

### Toggle Based on Desired State

```typescript
// Check if not already checked; uncheck if already checked
await page.getByLabel('Dark mode').setChecked(true);   // Always check
await page.getByLabel('Dark mode').setChecked(false);  // Always uncheck
```

### Verify Checkbox State

```typescript
await expect(page.getByLabel('Terms')).toBeChecked();
await expect(page.getByLabel('Newsletter')).not.toBeChecked();
```

### Get Checkbox State

```typescript
const isChecked = await page.getByLabel('Terms').isChecked();
console.log(isChecked); // true or false
```

---

## Handling Radio Buttons

Radio buttons work similarly — use `check()` to select one:

```typescript
// Select a radio option by label
await page.getByLabel('Male').check();
await page.getByLabel('Female').check();
await page.getByLabel('Other').check();

// By value attribute
await page.locator('input[name="gender"][value="male"]').check();
```

### Verify Radio Button Selection

```typescript
await expect(page.getByLabel('Male')).toBeChecked();
await expect(page.getByLabel('Female')).not.toBeChecked();
```

---

## Full Form Example

```typescript
import { test, expect } from '@playwright/test';

test('registration form with checkboxes', async ({ page }) => {
  await page.goto('/register');

  await page.getByLabel('Full Name').fill('Jane Doe');

  // Radio button
  await page.getByLabel('Female').check();

  // Checkboxes
  await page.getByLabel('I agree to Terms and Conditions').check();
  await page.getByLabel('Subscribe to newsletter').setChecked(true);

  // Verify
  await expect(page.getByLabel('Female')).toBeChecked();
  await expect(page.getByLabel('I agree to Terms and Conditions')).toBeChecked();

  await page.getByRole('button', { name: 'Register' }).click();
  await expect(page).toHaveURL('/success');
});
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Checkbox', 'Radio Button', 'check', 'setChecked', 'toBeChecked'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle browser dialogs (alert, confirm, prompt) in Playwright?',
  'how-to-handle-browser-dialogs-in-playwright',
  'Use page.on("dialog", handler) to intercept alert, confirm, and prompt dialogs. Call dialog.accept() or dialog.dismiss() inside the handler.',
  $$## Handling Browser Dialogs in Playwright

Browser dialogs — `alert()`, `confirm()`, and `prompt()` — are handled using the `dialog` event.

**Important:** You must register the handler **before** the action that triggers the dialog.

## Alert Dialog

```typescript
// Register handler BEFORE the action that triggers the alert
page.on('dialog', async dialog => {
  console.log(dialog.type());    // 'alert'
  console.log(dialog.message()); // 'Are you sure?'
  await dialog.accept();          // Click OK
});

// This action triggers the alert
await page.getByRole('button', { name: 'Delete' }).click();
```

## Confirm Dialog

```typescript
// Accept the confirm dialog (click OK)
page.on('dialog', async dialog => {
  await dialog.accept();
});

// Dismiss the confirm dialog (click Cancel)
page.on('dialog', async dialog => {
  await dialog.dismiss();
});
```

## Prompt Dialog (with input)

```typescript
page.on('dialog', async dialog => {
  console.log(dialog.type());           // 'prompt'
  console.log(dialog.defaultValue());   // Default value in prompt
  await dialog.accept('My typed value'); // Type a value and click OK
});
```

## One-time Handler (Better Practice)

```typescript
import { test, expect } from '@playwright/test';

test('handle confirm dialog', async ({ page }) => {
  await page.goto('/users');

  // Register handler before triggering the dialog
  page.once('dialog', dialog => dialog.accept());

  // Click delete button which triggers confirm()
  await page.getByRole('button', { name: 'Delete User' }).click();

  // Verify user was deleted
  await expect(page.locator('.user-list')).not.toContainText('John Doe');
});
```

## Dialog Types

| Dialog Type | `dialog.type()` | Methods Available |
|-------------|----------------|-------------------|
| `alert(msg)` | `'alert'` | `accept()` only |
| `confirm(msg)` | `'confirm'` | `accept()` / `dismiss()` |
| `prompt(msg)` | `'prompt'` | `accept(text)` / `dismiss()` |
| `beforeunload` | `'beforeunload'` | `accept()` / `dismiss()` |

## Auto-dismiss All Dialogs

```typescript
// Dismiss all dialogs automatically
page.on('dialog', dialog => dialog.dismiss());

// Accept all dialogs automatically
page.on('dialog', dialog => dialog.accept());
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Dialog', 'Alert', 'Confirm', 'Prompt', 'dialog.accept'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you work with iframes in Playwright?',
  'how-to-work-with-iframes-in-playwright',
  'Use page.frameLocator() to access elements inside iframes. It returns a FrameLocator that lets you use all the same locator methods inside the iframe.',
  $$## Handling iframes in Playwright

Playwright uses `frameLocator()` to interact with elements inside an `<iframe>`. This is much simpler than Selenium's `switchTo().frame()` approach.

## Basic iframe Access

```typescript
// Access an iframe by CSS selector
const iframe = page.frameLocator('iframe#payment-frame');

// Now use normal locators inside the iframe
await iframe.getByLabel('Card Number').fill('4111111111111111');
await iframe.getByLabel('Expiry').fill('12/26');
await iframe.getByRole('button', { name: 'Pay' }).click();
```

## Access by iframe Name or Title

```typescript
// By name attribute: <iframe name="checkout">
const iframe = page.frameLocator('[name="checkout"]');

// By src URL pattern
const iframe = page.frameLocator('iframe[src*="stripe.com"]');
```

## Nested iframes

```typescript
// Outer iframe
const outerFrame = page.frameLocator('#outer-iframe');

// Inner iframe inside the outer one
const innerFrame = outerFrame.frameLocator('#inner-iframe');

await innerFrame.getByRole('button', { name: 'Submit' }).click();
```

## Using locator().contentFrame() (Playwright v1.43+)

```typescript
const frameLocator = page.locator('iframe').contentFrame();
await frameLocator.getByLabel('Email').fill('test@example.com');
```

## Wait for iframe to Load

```typescript
// Wait for the iframe itself to appear
await page.locator('iframe#payment-frame').waitFor();

// Then access it
const iframe = page.frameLocator('iframe#payment-frame');
await iframe.getByLabel('Card number').fill('4111111111111111');
```

## Full Example — Stripe Payment iframe

```typescript
import { test, expect } from '@playwright/test';

test('complete payment with iframe', async ({ page }) => {
  await page.goto('/checkout');

  await page.getByRole('button', { name: 'Proceed to Payment' }).click();

  // Wait for Stripe iframe to appear
  await page.locator('iframe[src*="stripe.com"]').waitFor();

  const stripe = page.frameLocator('iframe[src*="stripe.com"]');
  await stripe.getByPlaceholder('Card number').fill('4242424242424242');
  await stripe.getByPlaceholder('MM / YY').fill('12/25');
  await stripe.getByPlaceholder('CVC').fill('123');

  await page.getByRole('button', { name: 'Pay Now' }).click();
  await expect(page).toHaveURL('/order-confirmed');
});
```

> **Key Difference from Selenium:** No `switchTo().frame()` / `switchTo().defaultContent()` juggling. Playwright's `frameLocator()` returns scoped locators that automatically interact inside the frame.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'iframe', 'frameLocator', 'Frame', 'Embedded Content'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is headless mode in Playwright and how do you enable or disable it?',
  'what-is-headless-mode-in-playwright',
  'Headless mode runs the browser without a visible UI window. Playwright runs headless by default; use --headed flag or headless:false in config to see the browser.',
  $$## Headless Mode in Playwright

**Headless mode** means the browser runs **without a visible window/GUI** — all browser operations happen in memory. This is the default in Playwright and ideal for CI/CD environments.

## Default Behavior

```bash
# Playwright runs headless by default
npx playwright test

# To see the browser UI:
npx playwright test --headed
```

## Configuration in playwright.config.ts

```typescript
import { defineConfig } from '@playwright/test';

export default defineConfig({
  use: {
    headless: false,  // Show browser window
    // headless: true, // Hide browser (default)
  },
});
```

## Per-Launch Override in Tests

```typescript
import { chromium } from '@playwright/test';

const browser = await chromium.launch({ headless: false });
const page = await browser.newPage();
await page.goto('https://example.com');
```

## Slow Motion (for debugging)

Combine headless:false with slowMo to watch each action:

```typescript
export default defineConfig({
  use: {
    headless: false,
    slowMo: 500, // 500ms delay between each action
  },
});
```

Or via CLI:
```bash
npx playwright test --headed --slow-mo=500
```

## When to Use Each Mode

| Mode | When to Use |
|------|------------|
| **Headless (default)** | CI/CD pipelines, fast local runs |
| **Headed** | Debugging, recording traces, demo |
| **Headless + slowMo** | Debugging without visual window clutter |

## Headed vs Headless Performance

- Headless is ~10-20% faster due to no rendering overhead
- Headless cannot access some browser features (e.g., certain video codecs)
- Some anti-bot systems detect headless browsers — for those use headed or stealth mode

## Environment Variable Override

```bash
# Force headed via env var
HEADED=1 npx playwright test

# In playwright.config.ts
use: {
  headless: !process.env.HEADED,
}
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Headless', 'Browser Mode', 'CI/CD', 'Debugging', '--headed'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the playwright.config.ts file and what does it configure?',
  'what-is-playwright-config-ts-file',
  'playwright.config.ts is the central configuration file that defines test directory, timeout, base URL, browser projects, reporters, parallel settings, and global test options.',
  $$## playwright.config.ts — The Configuration File

`playwright.config.ts` (or `.js`) is the **central configuration file** for Playwright Test. It sits at the project root and controls every aspect of how tests run.

## Complete Config Example

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  // ── Test Location ─────────────────────────────────
  testDir: './tests',
  testMatch: '**/*.spec.ts',     // Test file pattern

  // ── Execution ─────────────────────────────────────
  fullyParallel: true,            // All tests run in parallel
  workers: process.env.CI ? 2 : 4, // Worker count
  retries: process.env.CI ? 2 : 0, // Retry failed tests on CI

  // ── Timeouts ──────────────────────────────────────
  timeout: 30_000,               // Per-test timeout (30s)
  expect: { timeout: 5_000 },   // Assertion timeout (5s)

  // ── Global Setup ──────────────────────────────────
  globalSetup: './global-setup.ts',
  globalTeardown: './global-teardown.ts',

  // ── Reporters ─────────────────────────────────────
  reporter: [
    ['html'],                     // HTML report
    ['list'],                     // Console output
    ['json', { outputFile: 'results.json' }],
  ],

  // ── Shared Options for All Tests ──────────────────
  use: {
    baseURL: 'https://myapp.com',
    headless: true,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
    actionTimeout: 10_000,
    navigationTimeout: 30_000,
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
    locale: 'en-US',
    timezoneId: 'America/New_York',
  },

  // ── Browser Projects ──────────────────────────────
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    // Mobile emulation
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    // Setup project (runs before tests)
    {
      name: 'setup',
      testMatch: /.*\.setup\.ts/,
    },
  ],
});
```

## Key Configuration Options

| Option | Description |
|--------|-------------|
| `testDir` | Directory where tests live |
| `fullyParallel` | Run all tests in parallel |
| `workers` | Number of parallel workers |
| `retries` | Retry count for failing tests |
| `timeout` | Max time per test |
| `baseURL` | Base URL for `page.goto('/')` |
| `screenshot` | When to capture screenshots |
| `video` | When to record video |
| `trace` | When to capture trace |
| `reporter` | Output format (html, json, list) |
| `projects` | Browser configurations |$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Configuration', 'playwright.config.ts', 'Projects', 'Setup'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you run Playwright tests from the command line?',
  'how-to-run-playwright-tests-command-line',
  'Use npx playwright test with various flags to run all, specific, or filtered tests, with options for headed mode, browser, worker count, and HTML reports.',
  $$## Running Playwright Tests from the CLI

### Run All Tests

```bash
npx playwright test
```

### Run a Specific File

```bash
npx playwright test tests/login.spec.ts
npx playwright test login
```

### Run a Specific Test by Name

```bash
npx playwright test -g "user can log in"
npx playwright test --grep "checkout"
```

### Run with Browser Visible (Headed)

```bash
npx playwright test --headed
```

### Run on Specific Browser

```bash
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

### Run on Multiple Browsers

```bash
npx playwright test --project=chromium --project=firefox
```

### Control Parallel Workers

```bash
npx playwright test --workers=4
npx playwright test --workers=1   # Sequential (no parallel)
```

### Show Test List (Dry Run)

```bash
npx playwright test --list
```

### Run and Open HTML Report

```bash
npx playwright test
npx playwright show-report
```

### Debug Mode (Opens Inspector)

```bash
npx playwright test --debug
npx playwright test login.spec.ts --debug
```

### Run with Trace

```bash
npx playwright test --trace on
```

### Retry Failed Tests

```bash
npx playwright test --retries=3
```

### Run in UI Mode (Interactive)

```bash
npx playwright test --ui
```

### Sharding (for CI parallel machines)

```bash
# Machine 1 of 3
npx playwright test --shard=1/3

# Machine 2 of 3
npx playwright test --shard=2/3
```

### Full Command Reference

```bash
npx playwright test                   # Run all tests
npx playwright test --headed          # Show browser
npx playwright test --debug           # Debug mode
npx playwright test --ui              # UI mode
npx playwright test -g "login"        # Filter by name
npx playwright test --project=chrome  # Specific browser
npx playwright test --workers=4       # Parallelism
npx playwright test --retries=2       # Retry on fail
npx playwright test --reporter=html   # HTML report
npx playwright show-report            # Open last report
npx playwright codegen https://url    # Record new test
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'CLI', 'npx playwright test', 'Commands', 'Test Runner'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you use beforeEach, afterEach, beforeAll, and afterAll hooks in Playwright?',
  'how-to-use-beforeeach-aftereach-beforeall-afterall-hooks-in-playwright',
  'Use test.beforeEach() and test.afterEach() for per-test setup/teardown, and test.beforeAll() and test.afterAll() for suite-level setup shared across all tests in a describe block.',
  $$## Playwright Test Hooks

Playwright provides four lifecycle hooks for setting up and tearing down test state.

## beforeEach — Runs Before Every Test

```typescript
import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  // Runs before each test in this file
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await expect(page).toHaveURL('/dashboard');
});

test('can see dashboard', async ({ page }) => {
  await expect(page.getByRole('heading')).toHaveText('Dashboard');
});

test('can view profile', async ({ page }) => {
  await page.getByRole('link', { name: 'Profile' }).click();
  await expect(page).toHaveURL('/profile');
});
```

## afterEach — Runs After Every Test

```typescript
test.afterEach(async ({ page }, testInfo) => {
  if (testInfo.status !== testInfo.expectedStatus) {
    // Take screenshot on failure
    const screenshot = await page.screenshot();
    await testInfo.attach('screenshot', { body: screenshot, contentType: 'image/png' });
  }
});
```

## beforeAll — Runs Once Before All Tests in the Suite

```typescript
import { test, expect, Browser } from '@playwright/test';

test.describe('Admin Suite', () => {
  let adminPage: any;

  test.beforeAll(async ({ browser }) => {
    // Create an admin session once for all tests
    const context = await browser.newContext();
    adminPage = await context.newPage();
    await adminPage.goto('/admin/login');
    await adminPage.getByLabel('Email').fill('admin@test.com');
    await adminPage.getByLabel('Password').fill('admin123');
    await adminPage.getByRole('button', { name: 'Sign in' }).click();
  });

  test.afterAll(async () => {
    await adminPage.close();
  });

  test('admin can create user', async () => {
    await adminPage.getByRole('link', { name: 'Users' }).click();
    // ...
  });
});
```

## afterAll — Runs Once After All Tests

```typescript
test.afterAll(async () => {
  // Cleanup: delete test data, close DB connections, etc.
  console.log('All tests done — cleaning up');
});
```

## Hook Execution Order

```
beforeAll
  └── beforeEach → test 1 → afterEach
  └── beforeEach → test 2 → afterEach
  └── beforeEach → test 3 → afterEach
afterAll
```

## Hooks Inside describe Blocks

```typescript
test.describe('Shopping Cart', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/cart');
  });

  test('shows empty cart message', async ({ page }) => {
    await expect(page.getByText('Your cart is empty')).toBeVisible();
  });
});
```

> **Note:** `beforeAll` in Playwright runs in the **worker scope** — avoid sharing mutable page state across tests, as tests may run in different workers. Use `beforeEach` for page-level setup.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'beforeEach', 'afterEach', 'beforeAll', 'afterAll', 'Hooks', 'Lifecycle'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you get text content of an element in Playwright?',
  'how-to-get-text-content-element-playwright',
  'Use locator.textContent() for raw DOM text, locator.innerText() for visible rendered text, or locator.inputValue() for input field values.',
  $$## Getting Text Content in Playwright

### locator.textContent()

Returns the raw text content from the DOM — includes hidden text and whitespace.

```typescript
const rawText = await page.locator('h1').textContent();
console.log(rawText); // "  Welcome Home  "
```

### locator.innerText()

Returns the **rendered, visible** text — respects CSS `display:none` and `visibility:hidden`. Trims whitespace.

```typescript
const visibleText = await page.locator('h1').innerText();
console.log(visibleText); // "Welcome Home"
```

### locator.inputValue()

Gets the current value of an `<input>`, `<textarea>`, or `<select>` field.

```typescript
const email = await page.getByLabel('Email').inputValue();
console.log(email); // "user@example.com"

const selectedOption = await page.getByLabel('Country').inputValue();
console.log(selectedOption); // "US"
```

### locator.getAttribute()

Gets the value of a specific attribute.

```typescript
const href = await page.getByRole('link', { name: 'About' }).getAttribute('href');
console.log(href); // "/about"

const placeholder = await page.getByLabel('Search').getAttribute('placeholder');
```

## Comparison Table

| Method | What it Returns | Use Case |
|--------|----------------|----------|
| `textContent()` | Raw DOM text (includes hidden) | Checking exact DOM text |
| `innerText()` | Visible rendered text | Verifying user-visible text |
| `inputValue()` | Input field value | Reading form field values |
| `getAttribute('x')` | Attribute value | Href, src, data-* attrs |

## Getting Text from Multiple Elements

```typescript
// Get text from all list items
const items = await page.locator('li.product-name').allTextContents();
console.log(items); // ['Item 1', 'Item 2', 'Item 3']

// Get all inner texts
const texts = await page.locator('td.price').allInnerTexts();
console.log(texts); // ['$10.99', '$24.99', '$5.49']
```

## Use in Assertions (Preferred Pattern)

Rather than reading text and asserting manually, use built-in matchers:

```typescript
// Preferred — auto-retries until the text appears
await expect(page.locator('h1')).toHaveText('Welcome Home');
await expect(page.locator('h1')).toContainText('Welcome');

// Manual read (no auto-retry)
const text = await page.locator('h1').innerText();
expect(text).toBe('Welcome Home');  // No retry!
```

> **Best Practice:** Use `expect(locator).toHaveText()` for assertions (auto-retrying). Use `textContent()` / `innerText()` only when you need the value for logic, not assertions.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'textContent', 'innerText', 'inputValue', 'getText', 'getAttribute'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the Playwright codegen tool and how do you use it?',
  'what-is-playwright-codegen-tool',
  'Playwright codegen opens a browser and records your actions, automatically generating test code in your chosen language as you interact with the page.',
  $$## Playwright Codegen — Auto Test Generation

Codegen is a **built-in test recorder** that opens a browser window and records your interactions — generating test code automatically in real time.

## Basic Usage

```bash
npx playwright codegen https://example.com
```

This opens:
1. A **browser window** — you interact with the site normally
2. A **Playwright Inspector window** — shows generated code in real time

## Codegen Output Example

If you visit a login page, type credentials, and click Login, codegen generates:

```typescript
import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://myapp.com/login');
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await expect(page).toHaveURL('https://myapp.com/dashboard');
});
```

## Codegen Options

```bash
# Record in TypeScript (default)
npx playwright codegen --lang=ts https://myapp.com

# Record in JavaScript
npx playwright codegen --lang=js https://myapp.com

# Record in Python
npx playwright codegen --lang=python https://myapp.com

# Record in Java
npx playwright codegen --lang=java https://myapp.com

# Save generated code to a file
npx playwright codegen --output tests/recorded.spec.ts https://myapp.com

# Emulate a specific device
npx playwright codegen --device "iPhone 12" https://myapp.com

# Emulate viewport
npx playwright codegen --viewport-size=1280,720 https://myapp.com

# Set browser
npx playwright codegen --browser firefox https://myapp.com
```

## How Codegen Picks Locators

Codegen prioritizes in this order:
1. `getByRole()` — ARIA role
2. `getByText()` — visible text
3. `getByLabel()` — form labels
4. `getByTestId()` — data-testid
5. CSS selector — fallback

## Tips for Using Codegen

- **Start from codegen, don't ship it** — use codegen output as a starting point, then refine locators
- **Add assertions** — codegen records actions but doesn't auto-add `expect()` checks
- **Cleanup generated code** — remove unnecessary clicks/navigations from the recording
- **Use for exploration** — great for quickly finding locators on an unfamiliar page$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'codegen', 'Test Recorder', 'Code Generation', 'Getting Started'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the Playwright Trace Viewer?',
  'what-is-playwright-trace-viewer',
  'Trace Viewer is a Playwright debugging tool that records a full timeline of test execution — DOM snapshots, network requests, screenshots, and console logs — viewable as a step-by-step replay.',
  $$## Playwright Trace Viewer

The Trace Viewer is a **powerful debugging tool** that records a complete timeline of your test execution and lets you replay it step by step in the browser.

## What a Trace Captures

- **DOM snapshot** for every action (before and after)
- **Screenshots** at each step
- **Network requests** and responses
- **Console logs** and errors
- **Action timing** (how long each step took)
- **Source code** for each step

## How to Capture a Trace

### Option 1: On Failure Only (Recommended for CI)

```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    trace: 'retain-on-failure', // Only keep trace if test fails
  },
});
```

### Option 2: Always

```typescript
use: { trace: 'on' }
```

### Option 3: Via CLI

```bash
npx playwright test --trace on
```

### Option 4: Manually in a Test

```typescript
test('debug this test', async ({ page, context }) => {
  await context.tracing.start({ screenshots: true, snapshots: true });

  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');

  await context.tracing.stop({ path: 'trace.zip' });
});
```

## Viewing the Trace

### After Test Run

```bash
npx playwright show-report
```

Open the HTML report, click on a failed test → "Trace" tab shows the trace viewer.

### Open a Trace File Directly

```bash
npx playwright show-trace trace.zip
```

### Online Viewer

Upload `trace.zip` to: `https://trace.playwright.dev`

## Trace Viewer UI

The trace viewer shows:
- **Timeline bar** — each action as a segment
- **DOM panel** — rendered HTML snapshot at the selected step
- **Source panel** — test code with the current line highlighted
- **Network panel** — all HTTP requests made
- **Console panel** — browser console output
- **Action list** — all recorded actions with timing

## When to Use Traces

| Situation | Trace Setting |
|-----------|--------------|
| CI (production) | `retain-on-failure` |
| Local debugging | `on` |
| Initial development | `on-first-retry` |
| Performance testing | `off` |

> **Pro Tip:** When a test passes locally but fails in CI, enable traces in CI (`retain-on-failure`) and download the `trace.zip` artifact to debug exactly what happened.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Trace Viewer', 'Debugging', 'CI/CD', 'Test Reports'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you check if an element is visible, enabled, or present in Playwright?',
  'how-to-check-element-visibility-enabled-presence-playwright',
  'Use toBeVisible(), toBeEnabled(), toBeAttached() for assertions, or isVisible(), isEnabled(), isHidden() methods when you need the boolean value in conditional logic.',
  $$## Checking Element State in Playwright

## Assertion Methods (Recommended — auto-retry)

These use `expect()` and automatically retry until the condition is true or the timeout is reached.

```typescript
// Element is visible in the DOM and on screen
await expect(page.locator('.success-banner')).toBeVisible();
await expect(page.locator('.loading-spinner')).toBeHidden();

// Element exists in DOM (even if hidden)
await expect(page.locator('#hidden-field')).toBeAttached();

// Element is not in the DOM at all
await expect(page.locator('.deleted-item')).not.toBeAttached();

// Form field is enabled/disabled
await expect(page.getByRole('button', { name: 'Submit' })).toBeEnabled();
await expect(page.getByLabel('Email')).toBeDisabled();

// Checkbox state
await expect(page.getByLabel('Terms')).toBeChecked();
await expect(page.getByLabel('Newsletter')).not.toBeChecked();

// Input value
await expect(page.getByLabel('Email')).toHaveValue('user@test.com');
await expect(page.getByLabel('Email')).toBeEmpty();
```

## Boolean Methods (For Conditional Logic — No Retry)

Use these when you need to make a decision based on element state.

```typescript
// Returns true/false — no waiting
const isVisible = await page.locator('.notification').isVisible();
const isHidden   = await page.locator('.loading').isHidden();
const isEnabled  = await page.getByRole('button', { name: 'Next' }).isEnabled();
const isDisabled = await page.getByRole('button', { name: 'Submit' }).isDisabled();
const isChecked  = await page.getByLabel('Terms').isChecked();
const isEditable = await page.getByLabel('Name').isEditable();
```

### Use in Conditional Logic

```typescript
test('handle optional cookie banner', async ({ page }) => {
  await page.goto('/');

  // Check if cookie banner exists before trying to dismiss
  if (await page.locator('#cookie-banner').isVisible()) {
    await page.getByRole('button', { name: 'Accept' }).click();
  }

  await page.getByRole('link', { name: 'Shop' }).click();
});
```

## Count Elements

```typescript
// How many elements match?
const count = await page.locator('li.item').count();
console.log(count); // 5

await expect(page.locator('li.item')).toHaveCount(5);
```

## Summary Table

| Method | Type | Retries? | Returns |
|--------|------|---------|---------|
| `expect(loc).toBeVisible()` | Assertion | Yes | void (throws) |
| `expect(loc).toBeHidden()` | Assertion | Yes | void (throws) |
| `expect(loc).toBeEnabled()` | Assertion | Yes | void (throws) |
| `locator.isVisible()` | Boolean | No | `Promise<boolean>` |
| `locator.isHidden()` | Boolean | No | `Promise<boolean>` |
| `locator.isEnabled()` | Boolean | No | `Promise<boolean>` |
| `locator.isDisabled()` | Boolean | No | `Promise<boolean>` |
| `locator.isChecked()` | Boolean | No | `Promise<boolean>` |

> **Best Practice:** Use `expect()` assertions for test verification. Use boolean methods only for conditional logic that drives test flow.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'isVisible', 'toBeVisible', 'isEnabled', 'Element State', 'Assertions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you write a Playwright test in JavaScript?',
  'how-to-write-playwright-test-in-javascript',
  'Playwright tests in JavaScript use the same @playwright/test package, with async/await syntax, no TypeScript types required, and a .spec.js file extension.',
  $$## Writing Playwright Tests in JavaScript

Playwright supports both JavaScript and TypeScript. With JavaScript, you skip type annotations but use the same API.

## Project Setup for JavaScript

```bash
# Create project with JavaScript
npm init playwright@latest
# Choose "JavaScript" when prompted
```

Or manually:
```bash
npm install --save-dev @playwright/test
npx playwright install
```

Create `playwright.config.js`:
```javascript
// playwright.config.js
const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  use: {
    baseURL: 'https://myapp.com',
    headless: true,
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox',  use: { ...devices['Desktop Firefox'] } },
  ],
});
```

## Basic JavaScript Test

```javascript
// tests/login.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Login Flow', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
  });

  test('successful login with valid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('user@test.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();

    await expect(page).toHaveURL('/dashboard');
    await expect(page.getByRole('heading')).toHaveText('Welcome');
  });

  test('shows error with invalid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('wrong@test.com');
    await page.getByLabel('Password').fill('wrongpass');
    await page.getByRole('button', { name: 'Sign in' }).click();

    await expect(page.locator('.error-message')).toBeVisible();
    await expect(page.locator('.error-message')).toContainText('Invalid credentials');
  });
});
```

## Page Object in JavaScript

```javascript
// pages/LoginPage.js
class LoginPage {
  constructor(page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.loginButton = page.getByRole('button', { name: 'Sign in' });
    this.errorMessage = page.locator('.error-message');
  }

  async navigate() {
    await this.page.goto('/login');
  }

  async login(email, password) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }
}

module.exports = { LoginPage };
```

```javascript
// tests/login.spec.js
const { test, expect } = require('@playwright/test');
const { LoginPage } = require('../pages/LoginPage');

test('login with POM', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.navigate();
  await loginPage.login('user@test.com', 'password123');
  await expect(page).toHaveURL('/dashboard');
});
```

## Run JavaScript Tests

```bash
npx playwright test
npx playwright test --project=chromium
npx playwright test tests/login.spec.js
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'JavaScript', 'JS', 'Test Writing', 'CommonJS', 'ES Modules'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you write a Playwright test in TypeScript?',
  'how-to-write-playwright-test-in-typescript',
  'Playwright has first-class TypeScript support with auto-types, no compilation step needed. Use .spec.ts files with import syntax and TypeScript interfaces for strong typing.',
  $$## Writing Playwright Tests in TypeScript

TypeScript is the **recommended** and default language for Playwright. It provides full type safety, autocomplete, and catches errors at development time.

## Project Setup

```bash
npm init playwright@latest
# Choose "TypeScript" (default)
```

Playwright runs TypeScript tests **directly** without a separate compilation step — it uses its own transpiler internally.

## Basic TypeScript Test

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login Flow', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
  });

  test('successful login', async ({ page }) => {
    await page.getByLabel('Email').fill('user@test.com');
    await page.getByLabel('Password').fill('pass123');
    await page.getByRole('button', { name: 'Sign in' }).click();

    await expect(page).toHaveURL('/dashboard');
    await expect(page.getByRole('heading', { name: 'Welcome' })).toBeVisible();
  });
});
```

## TypeScript Page Object Model

```typescript
// pages/LoginPage.ts
import { Page, Locator } from '@playwright/test';

export class LoginPage {
  private readonly emailInput: Locator;
  private readonly passwordInput: Locator;
  private readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(private page: Page) {
    this.emailInput    = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.submitButton  = page.getByRole('button', { name: 'Sign in' });
    this.errorMessage  = page.locator('[data-testid="error-message"]');
  }

  async navigate(): Promise<void> {
    await this.page.goto('/login');
  }

  async login(email: string, password: string): Promise<void> {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }
}
```

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';

test('login with typed POM', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.navigate();
  await loginPage.login('user@test.com', 'pass123');

  await expect(page).toHaveURL('/dashboard');
});
```

## TypeScript Custom Fixtures

```typescript
// fixtures.ts
import { test as base } from '@playwright/test';
import { LoginPage } from './pages/LoginPage';
import { DashboardPage } from './pages/DashboardPage';

type Fixtures = {
  loginPage: LoginPage;
  dashboardPage: DashboardPage;
};

export const test = base.extend<Fixtures>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page));
  },
});

export { expect } from '@playwright/test';
```

```typescript
// tests/dashboard.spec.ts
import { test, expect } from '../fixtures';

test('dashboard loads correctly', async ({ loginPage, dashboardPage }) => {
  await loginPage.navigate();
  await loginPage.login('admin@test.com', 'admin123');

  await expect(dashboardPage.title).toBeVisible();
});
```

## TypeScript tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "outDir": "./dist"
  },
  "include": ["tests/**/*", "pages/**/*", "fixtures.ts"]
}
```

> **Key Advantage:** TypeScript catches type mismatches in Page Objects at compile time — you get autocomplete for all Playwright APIs and your own page object methods.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'TypeScript', 'TS', 'Page Object Model', 'Strong Typing', 'Fixtures'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between locator.textContent() and locator.innerText() in Playwright?',
  'difference-between-textcontent-and-innertext-in-playwright',
  'textContent() returns raw DOM text including hidden elements; innerText() returns only visible rendered text and respects CSS visibility, similar to what users actually see.',
  $$## textContent() vs innerText() in Playwright

Both methods return the text of an element but differ in what they include.

## locator.textContent()

Returns the **raw text content** from the DOM — exactly what the browser stores in the text nodes, including:
- Text from **hidden elements** (`display:none`)
- Script/style tag content (if directly targeted)
- All whitespace exactly as in the HTML

```typescript
const text = await page.locator('#my-element').textContent();
// May return: "  Hello World  " (with extra spaces)
// Returns text from hidden children too
```

## locator.innerText()

Returns the **rendered, visible text** — what the user actually sees on screen:
- Ignores elements with `display:none` or `visibility:hidden`
- Trims leading/trailing whitespace
- Respects CSS `text-transform` (uppercase/lowercase)
- Processes `<br>` as newlines

```typescript
const text = await page.locator('#my-element').innerText();
// Returns: "Hello World" (trimmed, no hidden text)
```

## Example Comparison

HTML:
```html
<div id="product">
  <span>Available</span>
  <span style="display:none">Out of Stock</span>
</div>
```

```typescript
const rawText     = await page.locator('#product').textContent();
// "Available Out of Stock" ← includes hidden span

const visibleText = await page.locator('#product').innerText();
// "Available" ← only visible text
```

## Summary Table

| | `textContent()` | `innerText()` |
|--|----------------|--------------|
| **Includes hidden** | Yes | No |
| **Whitespace** | Raw | Normalized |
| **Performance** | Faster (no reflow) | Slower (requires reflow) |
| **CSS text-transform** | Ignored | Applied |
| **Newlines from br** | No | Yes |

## When to Use Each

```typescript
// Use textContent() when you need raw DOM text
// including potentially hidden content
const raw = await page.locator('.data-value').textContent();

// Use innerText() when you want what the user sees
const visible = await page.locator('.status-text').innerText();

// For assertions, use toHaveText() — it works like innerText()
await expect(page.locator('.status')).toHaveText('Available');
```

> **For most tests**, use `expect(locator).toHaveText()` — it uses visible text (like `innerText()`) and auto-retries. Use `textContent()` / `innerText()` only when you need the raw string value.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'textContent', 'innerText', 'DOM', 'Text Extraction', 'Hidden Elements'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle multiple windows or tabs in Playwright?',
  'how-to-handle-multiple-windows-tabs-playwright',
  'Use context.waitForEvent("page") to capture a new page/tab that opens. Playwright supports multiple pages within a BrowserContext natively.',
  $$## Handling Multiple Windows and Tabs in Playwright

Playwright has **native support** for multiple browser pages (tabs/windows) within a `BrowserContext`. This is a key advantage over Selenium which requires complex window handle switching.

## Scenario 1 — Click Opens a New Tab

```typescript
import { test, expect } from '@playwright/test';

test('link opens in new tab', async ({ page, context }) => {
  await page.goto('https://example.com');

  // Wait for new page BEFORE clicking the link that opens it
  const [newPage] = await Promise.all([
    context.waitForEvent('page'),
    page.getByRole('link', { name: 'Open in new tab' }).click(),
  ]);

  // Wait for the new tab to finish loading
  await newPage.waitForLoadState('domcontentloaded');

  await expect(newPage).toHaveURL('https://partner.com');
  await expect(newPage.getByRole('heading')).toHaveText('Welcome');
});
```

## Scenario 2 — window.open() Opens New Window

```typescript
test('popup window', async ({ page, context }) => {
  await page.goto('/dashboard');

  const [popup] = await Promise.all([
    context.waitForEvent('page'),
    page.getByRole('button', { name: 'Open Report' }).click(),
  ]);

  await popup.waitForLoadState();
  console.log(await popup.title()); // "Monthly Report"

  // Close popup when done
  await popup.close();
});
```

## Scenario 3 — Manually Open a New Tab

```typescript
test('work with multiple tabs', async ({ context }) => {
  const page1 = await context.newPage();
  const page2 = await context.newPage();

  await page1.goto('https://myapp.com/products');
  await page2.goto('https://myapp.com/cart');

  // Get product name from page1
  const productName = await page1.locator('.product-name').first().innerText();

  // Verify cart on page2
  await page2.getByRole('button', { name: 'Add' }).click();
  await expect(page2.locator('.cart-item')).toContainText(productName);
});
```

## Scenario 4 — Get All Open Pages

```typescript
test('list all pages', async ({ context }) => {
  await context.newPage(); // page 1
  await context.newPage(); // page 2

  const pages = context.pages();
  console.log(pages.length); // 2

  // Switch to specific page by index
  const secondPage = pages[1];
  await secondPage.bringToFront();
});
```

## Key Difference from Selenium

**Selenium:**
```java
Set<String> handles = driver.getWindowHandles();
for (String handle : handles) {
  driver.switchTo().window(handle);
}
```

**Playwright:**
```typescript
// No switching needed — each page is its own object
const [newPage] = await Promise.all([
  context.waitForEvent('page'),
  page.click('#open-tab'),
]);
// Work with newPage directly
```$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'Multiple Tabs', 'New Window', 'popup', 'context', 'waitForEvent'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is waitForSelector and waitForLoadState in Playwright?',
  'what-is-waitforselector-waitforloadstate-playwright',
  'waitForSelector() waits for a CSS selector to appear in the DOM; waitForLoadState() waits for the page to reach load, domcontentloaded, or networkidle state.',
  $$## waitForSelector and waitForLoadState in Playwright

## page.waitForSelector()

Waits for an element matching a CSS selector to appear in the DOM and be in a specific state.

```typescript
// Wait for element to appear (default: 'visible')
await page.waitForSelector('.product-list');

// Wait for element to be visible
await page.waitForSelector('.success-banner', { state: 'visible' });

// Wait for element to be hidden/gone
await page.waitForSelector('.loading-spinner', { state: 'hidden' });

// Wait for element to be present in DOM (even if hidden)
await page.waitForSelector('#modal', { state: 'attached' });

// Wait for element to be removed from DOM
await page.waitForSelector('.temp-banner', { state: 'detached' });

// Custom timeout
await page.waitForSelector('.chart', { timeout: 15000 });
```

**States:**
| State | Meaning |
|-------|---------|
| `'visible'` (default) | Element exists AND is visible |
| `'hidden'` | Element is invisible or removed |
| `'attached'` | Element exists in DOM (even hidden) |
| `'detached'` | Element removed from DOM |

## Modern Alternative — locator.waitFor()

```typescript
// Preferred over page.waitForSelector()
await page.locator('.product-list').waitFor({ state: 'visible' });
await page.locator('.spinner').waitFor({ state: 'hidden' });
```

## page.waitForLoadState()

Waits for the page to reach a specific load state after navigation.

```typescript
// After navigation, wait for full load
await page.goto('/products');
await page.waitForLoadState('load'); // default

// Wait for DOMContentLoaded only (faster)
await page.waitForLoadState('domcontentloaded');

// Wait for no network activity (great for SPAs)
await page.waitForLoadState('networkidle');
```

**Load States:**
| State | Description |
|-------|-------------|
| `'load'` | All resources loaded (images, scripts, etc.) |
| `'domcontentloaded'` | DOM parsed and ready |
| `'networkidle'` | No network requests for 500ms |

## When to Use Each

```typescript
// Use waitForLoadState after goto()
await page.goto('/dashboard');
await page.waitForLoadState('networkidle'); // SPA hydrated

// Use waitForSelector for dynamic content
await page.getByRole('button', { name: 'Load More' }).click();
await page.waitForSelector('.new-items');  // Wait for new items

// Modern approach — prefer locator.waitFor()
const newItems = page.locator('.product-card');
await newItems.waitFor();
await expect(newItems).toHaveCount(20);
```

> **Note:** In most cases, Playwright's auto-waiting makes `waitForSelector` unnecessary. Use it only when you need to wait for something before reading a value or making a conditional check.$$,
  'Playwright', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Playwright', 'waitForSelector', 'waitForLoadState', 'Waits', 'networkidle', 'DOM'], true, 0
);
