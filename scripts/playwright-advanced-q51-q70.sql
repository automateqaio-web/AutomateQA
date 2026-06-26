-- Playwright Advanced Interview Questions (Q51–Q70)
-- Technology: Playwright | Difficulty: Advanced | Experience: 3-5 Years / 5+ Years / Senior SDET
-- Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you implement global setup and teardown in Playwright?',
  'playwright-global-setup-and-teardown',
  'Use globalSetup and globalTeardown in playwright.config.ts to run code once before/after all tests — ideal for seeding databases, starting servers, or creating shared auth state.',
  $$## Global Setup and Teardown in Playwright

Global setup/teardown run **once** before and after the entire test suite — not per test or per file.

## Configuration

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  globalSetup:    './global-setup.ts',
  globalTeardown: './global-teardown.ts',
  // rest of config...
});
```

## global-setup.ts

```typescript
// global-setup.ts
import { chromium, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  console.log('🚀 Running global setup...');

  // 1. Seed test database
  await seedTestDatabase();

  // 2. Start local server (if needed)
  // process.env.SERVER_PID = startServer();

  // 3. Create auth state files — login once for all tests
  const browser = await chromium.launch();

  // Regular user auth
  const userContext = await browser.newContext();
  const userPage    = await userContext.newPage();
  const baseURL     = config.projects[0].use.baseURL || 'http://localhost:3000';

  await userPage.goto(`${baseURL}/login`);
  await userPage.fill('#email',    'user@test.com');
  await userPage.fill('#password', 'password123');
  await userPage.click('#submit');
  await userPage.waitForURL('**/dashboard');
  await userContext.storageState({ path: '.auth/user.json' });

  // Admin user auth
  const adminContext = await browser.newContext();
  const adminPage    = await adminContext.newPage();
  await adminPage.goto(`${baseURL}/admin/login`);
  await adminPage.fill('#email',    'admin@test.com');
  await adminPage.fill('#password', 'admin123');
  await adminPage.click('#submit');
  await adminPage.waitForURL('**/admin');
  await adminContext.storageState({ path: '.auth/admin.json' });

  await browser.close();

  // 4. Set global env variables (accessible in tests via process.env)
  process.env.GLOBAL_SETUP_DONE = 'true';
  process.env.TEST_RUN_ID = `run-${Date.now()}`;

  console.log('✅ Global setup complete');
}

async function seedTestDatabase() {
  // Your DB seeding logic — REST call, direct DB, etc.
  const res = await fetch('http://localhost:3001/test/seed', { method: 'POST' });
  if (!res.ok) throw new Error('Failed to seed test database');
}

export default globalSetup;
```

## global-teardown.ts

```typescript
// global-teardown.ts
async function globalTeardown() {
  console.log('🧹 Running global teardown...');

  // 1. Clean test database
  await fetch('http://localhost:3001/test/cleanup', { method: 'POST' });

  // 2. Stop local server
  // if (process.env.SERVER_PID) stopServer(process.env.SERVER_PID);

  // 3. Remove auth files
  // fs.unlinkSync('.auth/user.json');

  console.log('✅ Global teardown complete');
}

export default globalTeardown;
```

## Accessing Global Setup Data in Tests

```typescript
// Tests can read env vars set in global setup
test('uses global setup data', async ({ page }) => {
  console.log('Test run ID:', process.env.TEST_RUN_ID);
  // ...
});
```

## Global Setup vs beforeAll

| | Global Setup | beforeAll |
|--|-------------|-----------|
| **Runs** | Once per test suite | Once per describe/file |
| **Scope** | Across all workers | Within one worker |
| **Browser access** | Manual setup needed | Via `browser` fixture |
| **Use for** | Auth files, DB seed, server start | Suite-level state |$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Global Setup', 'Global Teardown', 'Configuration', 'Database Seeding', 'Auth'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle Shadow DOM elements in Playwright?',
  'how-to-handle-shadow-dom-playwright',
  'Playwright pierces Shadow DOM automatically — locators like getByRole(), getByText(), and CSS selectors work inside shadow roots without any special syntax.',
  $$## Shadow DOM in Playwright

Playwright **automatically pierces Shadow DOM** — you can locate elements inside Shadow DOM without any special handling, unlike Selenium which requires JavaScript workarounds.

## What is Shadow DOM?

Shadow DOM is a web standard that encapsulates component internals — elements inside a shadow root are isolated from the main document's CSS and JavaScript.

```html
<!-- Host element -->
<my-custom-button>
  #shadow-root (open)
    <button class="internal-btn">Click Me</button>
</my-custom-button>
```

## Playwright Automatically Pierces Shadow DOM

```typescript
// This works — Playwright looks inside shadow roots automatically
await page.getByRole('button', { name: 'Click Me' }).click();
await page.getByText('Click Me').click();

// CSS selector with >>> (explicit shadow piercing — older syntax)
await page.locator('my-custom-button >>> .internal-btn').click();
```

## Standard Locators Work Inside Shadow DOM

```typescript
// Web Components in action
test('interact with shadow DOM elements', async ({ page }) => {
  await page.goto('/component-library');

  // Shadow DOM inside <custom-input>
  const customInput = page.locator('custom-input');
  await customInput.getByRole('textbox').fill('Hello Shadow DOM');

  // Shadow DOM inside <custom-dropdown>
  await page.locator('custom-dropdown').click();
  await page.getByRole('option', { name: 'Option 2' }).click();

  // Shadow DOM inside <my-button>
  await page.locator('my-button').getByText('Submit').click();
});
```

## Nested Shadow DOM

```typescript
// Playwright handles multiple levels of shadow nesting
const innerButton = page.locator('outer-component')
  .locator('inner-component')
  .getByRole('button', { name: 'Action' });

await innerButton.click();
```

## When CSS Doesn't Penetrate

If Playwright's auto-piercing doesn't work (very rare), use `>>>`:

```typescript
// CSS with shadow piercing combinator
await page.locator('custom-form >>> input[name="email"]').fill('test@example.com');
```

## Real-World Example — Material Web Components

```typescript
test('fill Material Web form', async ({ page }) => {
  await page.goto('/material-form');

  // mwc-textfield uses Shadow DOM internally
  const emailField = page.locator('mwc-textfield[label="Email"]');
  await emailField.locator('input').fill('user@test.com');

  // mwc-button
  await page.locator('mwc-button[label="Submit"]').click();
});
```

## Testing Shadow DOM via JavaScript (Fallback)

```typescript
// If Playwright's auto-piercing fails for any reason
await page.evaluate(() => {
  const host = document.querySelector('my-button');
  const shadow = host?.shadowRoot;
  const btn = shadow?.querySelector('button') as HTMLButtonElement;
  btn?.click();
});
```

> **Key Advantage Over Selenium:** Selenium cannot locate elements inside closed/open shadow roots with standard `findElement()`. You had to use `executeJavaScript()`. Playwright handles it natively, making Web Component testing effortless.$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Shadow DOM', 'Web Components', 'CSS Shadow Piercing', 'Custom Elements'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you use Playwright for API testing?',
  'how-to-use-playwright-for-api-testing',
  'Use the request fixture or APIRequestContext for HTTP requests without a browser. Playwright supports GET, POST, PUT, DELETE, authentication headers, and response assertions natively.',
  $$## API Testing with Playwright

Playwright includes a built-in HTTP client for API testing — no browser needed.

## Using the request Fixture

```typescript
import { test, expect } from '@playwright/test';

test('GET users list', async ({ request }) => {
  const response = await request.get('/api/users');

  expect(response.ok()).toBeTruthy();
  expect(response.status()).toBe(200);

  const body = await response.json();
  expect(body.users).toHaveLength(10);
  expect(body.users[0]).toHaveProperty('email');
});
```

## POST Request

```typescript
test('create a new user', async ({ request }) => {
  const response = await request.post('/api/users', {
    data: {
      name: 'John Doe',
      email: 'john@test.com',
      role: 'viewer',
    },
    headers: {
      'Authorization': 'Bearer admin-token-123',
      'Content-Type': 'application/json',
    },
  });

  expect(response.status()).toBe(201);
  const user = await response.json();
  expect(user.id).toBeTruthy();
  expect(user.email).toBe('john@test.com');
});
```

## PUT and DELETE

```typescript
test('update user', async ({ request }) => {
  const response = await request.put('/api/users/123', {
    data: { name: 'Jane Doe' },
  });
  expect(response.status()).toBe(200);
});

test('delete user', async ({ request }) => {
  const response = await request.delete('/api/users/123');
  expect(response.status()).toBe(204);
});
```

## API Base URL Configuration

```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    baseURL: 'https://api.myapp.com',
    extraHTTPHeaders: {
      'Accept': 'application/json',
      'X-API-Version': '2',
    },
  },
});
```

## Authenticated API Requests

```typescript
// Create authenticated context
const apiContext = await request.newContext({
  baseURL: 'https://api.myapp.com',
  extraHTTPHeaders: {
    Authorization: `Bearer ${process.env.API_TOKEN}`,
  },
});

const response = await apiContext.get('/api/admin/users');
```

## API + UI Combined Test

```typescript
test('create user via API, verify in UI', async ({ page, request }) => {
  // Create test data via API (fast)
  const apiRes = await request.post('/api/users', {
    data: { name: 'Test User', email: 'testuser@test.com' },
    headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
  });
  const { id } = await apiRes.json();

  // Verify in UI
  await page.goto(`/admin/users/${id}`);
  await expect(page.getByRole('heading')).toHaveText('Test User');

  // Cleanup via API
  await request.delete(`/api/users/${id}`, {
    headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
  });
});
```

## Response Assertions

```typescript
const response = await request.get('/api/products');

// Status
expect(response.status()).toBe(200);
expect(response.ok()).toBe(true);           // status 200-299

// Headers
expect(response.headers()['content-type']).toContain('application/json');

// Body
const data = await response.json();
expect(data).toMatchObject({ status: 'active' });

// Text response
const text = await response.text();
expect(text).toContain('success');
```$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'API Testing', 'request fixture', 'HTTP', 'REST API', 'APIRequestContext'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is visual regression testing in Playwright and how do you implement it?',
  'visual-regression-testing-playwright',
  'Visual regression testing compares screenshots against baseline images using toMatchSnapshot() or toHaveScreenshot(). Mismatches are flagged as failures — ideal for detecting unintended UI changes.',
  $$## Visual Regression Testing in Playwright

Visual regression testing catches **unexpected visual changes** by comparing screenshots to baseline images.

## Basic Screenshot Comparison

```typescript
import { test, expect } from '@playwright/test';

test('homepage looks correct', async ({ page }) => {
  await page.goto('/');

  // Compare full page to baseline
  await expect(page).toHaveScreenshot('homepage.png');
});

test('button styles are correct', async ({ page }) => {
  await page.goto('/design-system');

  // Compare a specific element
  await expect(page.locator('.button-group')).toHaveScreenshot('buttons.png');
});
```

## First Run — Creates Baseline

```bash
# First run generates baseline images in __snapshots__/
npx playwright test
```

## Subsequent Runs — Compare to Baseline

Any pixel difference above threshold fails the test:
```
Error: Screenshot comparison failed:
Expected: homepage.png
Received: homepage-actual.png
Diff: 234 pixels changed (0.3%)
```

## Update Baselines

```bash
# Regenerate all baselines
npx playwright test --update-snapshots
```

## Configuration Options

```typescript
// playwright.config.ts
export default defineConfig({
  expect: {
    toHaveScreenshot: {
      maxDiffPixels: 100,        // Allow up to 100 different pixels
      maxDiffPixelRatio: 0.01,   // Allow up to 1% pixel difference
      threshold: 0.2,            // Color distance threshold (0-1)
      animations: 'disabled',   // Disable CSS animations before screenshot
    },
  },
});
```

## Masking Dynamic Areas

```typescript
// Ignore areas that change (timestamps, ads, etc.)
await expect(page).toHaveScreenshot('dashboard.png', {
  mask: [
    page.locator('.timestamp'),
    page.locator('.live-count'),
    page.locator('#ad-banner'),
  ],
});
```

## Full Visual Test Suite

```typescript
import { test, expect } from '@playwright/test';

const pages = [
  { name: 'home',       path: '/' },
  { name: 'login',      path: '/login' },
  { name: 'dashboard',  path: '/dashboard' },
  { name: 'products',   path: '/products' },
];

for (const { name, path } of pages) {
  test(`${name} page visual regression`, async ({ page }) => {
    await page.goto(path);

    // Wait for animations to settle
    await page.waitForLoadState('networkidle');

    await expect(page).toHaveScreenshot(`${name}.png`, {
      fullPage: true,
      animations: 'disabled',
    });
  });
}
```

## Folder Structure for Snapshots

```
tests/
├── visual/
│   └── homepage.spec.ts
└── __snapshots__/
    └── visual/
        ├── homepage.spec.ts-snapshots/
        │   ├── homepage-chromium-darwin.png    # Platform-specific baselines
        │   ├── homepage-firefox-darwin.png
        │   └── homepage-webkit-darwin.png
```

> **Important:** Visual baselines are OS and browser-specific. CI and local machines often differ — create and update baselines in CI to avoid false failures.$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Visual Regression Testing', 'toHaveScreenshot', 'Snapshot Testing', 'UI Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you implement retry logic in Playwright?',
  'how-to-implement-retry-logic-playwright',
  'Configure retries in playwright.config.ts with the retries option. Playwright auto-retries failed tests and provides testInfo.retry to detect which attempt is running.',
  $$## Retry Logic in Playwright

## Global Retry Configuration

```typescript
// playwright.config.ts
export default defineConfig({
  retries: 2,                              // Retry all tests up to 2 times

  // Or conditionally — more retries in CI
  retries: process.env.CI ? 2 : 0,
});
```

With `retries: 2`, a failing test gets 3 attempts total (1 original + 2 retries).

## CLI Override

```bash
npx playwright test --retries=3
```

## Detect Retry Attempt in Test

```typescript
import { test, expect } from '@playwright/test';

test('potentially flaky test', async ({ page }, testInfo) => {
  console.log(`Attempt ${testInfo.retry + 1} of ${testInfo.retries + 1}`);

  if (testInfo.retry > 0) {
    // On retry — take a fresh screenshot for debugging
    await page.screenshot({ path: `retry-${testInfo.retry}-start.png` });
  }

  await page.goto('/products');
  await expect(page.locator('.product-list')).toBeVisible();
});
```

## Skip Retries for Specific Tests

```typescript
// This test should never be retried (e.g., destructive operations)
test('delete all records', async ({ page }) => {
  test.fixme(!!testInfo.retry, 'Do not retry destructive tests');
  // ...
});
```

## Retry Only on Network Failures

```typescript
test.beforeEach(async ({ page }, testInfo) => {
  if (testInfo.retry) {
    // Clear state before retry
    await page.context().clearCookies();
  }
});
```

## Per-Test Retry

```typescript
test('flaky API test', {
  retries: 3, // Override global setting for this test
}, async ({ page }) => {
  // ...
});
```

## onRetry Hook (Custom Reporting)

```typescript
// playwright.config.ts
export default defineConfig({
  reporter: [
    ['html'],
    ['./custom-reporter.ts'],
  ],
  retries: 2,
});

// custom-reporter.ts
class CustomReporter {
  onTestEnd(test: TestCase, result: TestResult) {
    if (result.status === 'passed' && result.retry > 0) {
      console.log(`⚠️ Test passed on retry ${result.retry}: ${test.title}`);
    }
  }
}
```

## Difference Between Retries and Flaky Tests

- **Retries** help with real intermittent failures (network timeout, race conditions)
- Retries should NOT be used to hide test logic bugs
- Tests that consistently need retries indicate a flaky test — investigate root cause

## Retry + Trace for Debugging

```typescript
// playwright.config.ts
export default defineConfig({
  retries: 2,
  use: {
    trace: 'on-first-retry', // Capture trace only on first retry
  },
});
```

This captures a full trace on the retry attempt but not on the original run — minimizing overhead while ensuring debugging data is available when failures occur.$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Retry Logic', 'Flaky Tests', 'Retries', 'testInfo.retry', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is test sharding in Playwright and how does it work?',
  'what-is-test-sharding-playwright',
  'Sharding splits the test suite across multiple machines, each running a subset of tests, dramatically reducing total CI execution time when combined with parallel workers.',
  $$## Test Sharding in Playwright

Sharding distributes tests across **multiple machines (CI agents)** that run concurrently. Each shard handles a portion of the total test suite.

## How Sharding Works

```
Total: 400 tests

Shard 1/4 → runs tests 1-100
Shard 2/4 → runs tests 101-200
Shard 3/4 → runs tests 201-300
Shard 4/4 → runs tests 301-400

All shards run simultaneously → 4x speedup!
```

## Basic Sharding Command

```bash
# Machine 1 of 4
npx playwright test --shard=1/4

# Machine 2 of 4
npx playwright test --shard=2/4

# Machine 3 of 4
npx playwright test --shard=3/4

# Machine 4 of 4
npx playwright test --shard=4/4
```

## GitHub Actions — Matrix Sharding

```yaml
# .github/workflows/playwright.yml
name: Playwright Tests

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest

    strategy:
      fail-fast: false
      matrix:
        shardIndex: [1, 2, 3, 4]
        shardTotal: [4]

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps

      - name: Run tests (shard ${{ matrix.shardIndex }}/${{ matrix.shardTotal }})
        run: npx playwright test --shard=${{ matrix.shardIndex }}/${{ matrix.shardTotal }}

      # Upload each shard's results for merging
      - name: Upload shard report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report-${{ matrix.shardIndex }}
          path: playwright-report/
          retention-days: 30
```

## Merging Shard Reports

To get one combined HTML report from all shards:

```yaml
  merge-reports:
    needs: test
    if: always()
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci

      - name: Download all shard reports
        uses: actions/download-artifact@v4
        with:
          path: all-blob-reports
          pattern: playwright-report-*

      - name: Merge reports
        run: npx playwright merge-reports --reporter html ./all-blob-reports

      - name: Upload combined report
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report-combined
          path: playwright-report/
```

## Shard + Workers (Maximum Speed)

Each shard also runs its tests in parallel via workers:

```typescript
// playwright.config.ts
export default defineConfig({
  workers: 4,           // 4 parallel workers per shard
  fullyParallel: true,
});
```

With 4 shards × 4 workers = 16 tests running simultaneously!

## When to Use Sharding

- Test suite takes > 10 minutes on a single machine
- CI pipeline needs to stay under a time limit
- Running cross-browser tests (each browser can be a shard)$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Sharding', 'Parallel Testing', 'CI/CD', 'GitHub Actions', 'Performance', 'Scale'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you create a custom reporter in Playwright?',
  'how-to-create-custom-reporter-playwright',
  'Implement the Reporter interface with lifecycle hooks (onBegin, onTestEnd, onEnd, etc.) and register it in playwright.config.ts. Custom reporters can send results to Slack, JIRA, or custom dashboards.',
  $$## Custom Reporter in Playwright

Playwright's `Reporter` interface has lifecycle hooks you implement to capture test events.

## Built-in Reporters (Reference)

```typescript
reporter: [
  ['html'],           // HTML report
  ['json'],           // JSON output
  ['list'],           // Console list
  ['dot'],            // Dots in CI
  ['junit'],          // JUnit XML
  ['github'],         // GitHub Annotations
]
```

## Create a Custom Reporter

```typescript
// reporters/custom-reporter.ts
import type {
  Reporter, Suite, TestCase, TestResult,
  FullResult, TestStep
} from '@playwright/test/reporter';

class CustomReporter implements Reporter {
  private startTime = Date.now();
  private passed = 0;
  private failed = 0;
  private skipped = 0;
  private failures: { title: string; error: string }[] = [];

  onBegin(config: any, suite: Suite): void {
    const total = suite.allTests().length;
    console.log(`\n🎭 Starting ${total} Playwright tests...\n`);
  }

  onTestBegin(test: TestCase): void {
    console.log(`  ▶ ${test.title}`);
  }

  onTestEnd(test: TestCase, result: TestResult): void {
    if (result.status === 'passed') {
      this.passed++;
      console.log(`  ✅ ${test.title} (${result.duration}ms)`);
    } else if (result.status === 'failed') {
      this.failed++;
      const error = result.errors[0]?.message || 'Unknown error';
      this.failures.push({ title: test.title, error });
      console.log(`  ❌ ${test.title}`);
      console.log(`     Error: ${error.slice(0, 200)}`);
    } else if (result.status === 'skipped') {
      this.skipped++;
      console.log(`  ⏭ ${test.title} (skipped)`);
    }
  }

  async onEnd(result: FullResult): Promise<void> {
    const duration = Date.now() - this.startTime;

    console.log(`\n${'─'.repeat(50)}`);
    console.log(`✅ Passed:  ${this.passed}`);
    console.log(`❌ Failed:  ${this.failed}`);
    console.log(`⏭ Skipped: ${this.skipped}`);
    console.log(`⏱ Duration: ${(duration / 1000).toFixed(1)}s`);
    console.log(`${'─'.repeat(50)}\n`);

    if (this.failures.length > 0) {
      console.log('Failed tests:');
      this.failures.forEach(f => console.log(`  - ${f.title}`));
    }

    // Send results to Slack / webhook
    if (this.failed > 0) {
      await this.sendSlackNotification();
    }
  }

  private async sendSlackNotification() {
    const webhookUrl = process.env.SLACK_WEBHOOK_URL;
    if (!webhookUrl) return;

    await fetch(webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        text: `🚨 Playwright: ${this.failed} tests failed!`,
        attachments: this.failures.slice(0, 5).map(f => ({
          color: 'danger',
          title: f.title,
          text: f.error.slice(0, 300),
        })),
      }),
    });
  }
}

export default CustomReporter;
```

## Register the Custom Reporter

```typescript
// playwright.config.ts
export default defineConfig({
  reporter: [
    ['html'],                                       // Keep HTML report
    ['./reporters/custom-reporter.ts'],             // Add custom
    ['json', { outputFile: 'results/report.json' }], // JSON output
  ],
});
```

## Reporter with Test Attachments

```typescript
onTestEnd(test: TestCase, result: TestResult): void {
  for (const attachment of result.attachments) {
    if (attachment.name === 'screenshot') {
      // Process screenshot attachment
      console.log(`Screenshot: ${attachment.path}`);
    }
  }
}
```$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Custom Reporter', 'Reporter Interface', 'Slack', 'Test Results', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How does Playwright handle test isolation with Workers?',
  'playwright-test-isolation-workers',
  'Each Playwright worker is a separate Node.js process with its own browser instance. Tests in different workers have completely isolated state — no shared memory, cookies, or page state.',
  $$## Test Isolation with Workers in Playwright

## The Worker Model

```
CI Machine
├── Worker Process 1 (Node.js process)
│   ├── Browser 1 (Chromium)
│   │   ├── Context A → test-file-1.spec.ts
│   │   └── Context B → test-file-2.spec.ts
├── Worker Process 2 (Node.js process)
│   └── Browser 2 (Chromium)
│       └── Context C → test-file-3.spec.ts
└── Worker Process 3 (Node.js process)
    └── Browser 3 (Chromium)
        └── Context D → test-file-4.spec.ts
```

## How Isolation Works

- Each test gets a **fresh BrowserContext** with:
  - New cookies (empty)
  - Clean localStorage (empty)
  - No auth state
  - No shared state from other tests
- Tests in the same file run in the same worker (by default) but each test still gets a new context
- Tests across files can run in different workers simultaneously

## Isolation at the Test Level

```typescript
// Each test gets fresh isolation automatically
test('test A — sets cookie "foo"', async ({ page, context }) => {
  await context.addCookies([{ name: 'foo', value: 'bar', domain: 'localhost', path: '/' }]);
  // This cookie ONLY exists for this test
});

test('test B — cannot see test A cookies', async ({ page, context }) => {
  const cookies = await context.cookies();
  // cookies is EMPTY — test A's cookies are gone
  expect(cookies).toHaveLength(0);
});
```

## Worker-Level Fixtures (Shared Within Worker)

```typescript
// Fixtures with scope:'worker' are shared across tests in the same worker
export const test = base.extend({
  sharedAuth: [async ({ browser }, use) => {
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto('/login');
    await page.fill('#email', 'user@test.com');
    await page.click('#submit');
    await context.storageState({ path: 'worker-auth.json' });
    await page.close();
    await use('worker-auth.json');
    await context.close();
  }, { scope: 'worker' }],
});
```

## Checking Worker Index

```typescript
import { test } from '@playwright/test';

test('which worker am I?', async ({}, testInfo) => {
  console.log(`Worker index: ${testInfo.workerIndex}`);   // 0, 1, 2, ...
  console.log(`Parallel index: ${testInfo.parallelIndex}`);
});
```

## Avoid Shared State Between Tests

```typescript
// BAD — global variable shared between tests
let userId = '';

test.beforeAll(async ({ request }) => {
  const res = await request.post('/api/users', { data: { name: 'Test' } });
  userId = (await res.json()).id; // DANGEROUS in parallel
});

// GOOD — create test-specific data per test
test('each test creates its own user', async ({ request }) => {
  const res = await request.post('/api/users', {
    data: { name: `user-${Date.now()}-${Math.random()}` },
  });
  const { id } = await res.json();
  // Use id in THIS test only
});
```

## Worker Count & Resource Impact

```typescript
// playwright.config.ts
export default defineConfig({
  workers: 4,           // 4 browser instances running simultaneously
  fullyParallel: true,  // All tests across all files run in parallel
});
```

`workers: 4` = 4 browser processes = 4x CPU/memory. Balance with available CI resources.$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Workers', 'Test Isolation', 'Parallel Testing', 'BrowserContext', 'State Management'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you integrate Playwright with GitHub Actions CI/CD?',
  'playwright-integration-github-actions',
  'Use the official Playwright GitHub Actions setup with actions/checkout, node setup, npm ci, npx playwright install --with-deps, and upload the HTML report as an artifact.',
  $$## Playwright + GitHub Actions

## Basic Workflow

```yaml
# .github/workflows/playwright.yml
name: Playwright Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  playwright:
    timeout-minutes: 60
    runs-on: ubuntu-latest

    steps:
      # 1. Checkout code
      - uses: actions/checkout@v4

      # 2. Set up Node.js
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      # 3. Install npm dependencies
      - name: Install dependencies
        run: npm ci

      # 4. Install Playwright browsers + OS dependencies
      - name: Install Playwright browsers
        run: npx playwright install --with-deps

      # 5. Run tests
      - name: Run Playwright tests
        run: npx playwright test
        env:
          BASE_URL: ${{ secrets.STAGING_URL }}
          TEST_EMAIL: ${{ secrets.TEST_EMAIL }}
          TEST_PASSWORD: ${{ secrets.TEST_PASSWORD }}

      # 6. Upload HTML report (always, even on failure)
      - name: Upload Playwright report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

## Sharded Matrix Workflow (4 Parallel Machines)

```yaml
name: Playwright Tests (Sharded)

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 30

    strategy:
      fail-fast: false
      matrix:
        shardIndex: [1, 2, 3, 4]
        shardTotal: [4]

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: 'npm' }
      - run: npm ci
      - run: npx playwright install --with-deps

      - name: Run shard
        run: npx playwright test --shard=${{ matrix.shardIndex }}/${{ matrix.shardTotal }}
        env:
          BASE_URL: ${{ secrets.BASE_URL }}

      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: blob-report-${{ matrix.shardIndex }}
          path: blob-report/

  merge-reports:
    needs: test
    if: always()
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: 'npm' }
      - run: npm ci
      - uses: actions/download-artifact@v4
        with: { path: all-reports, pattern: blob-report-* }
      - run: npx playwright merge-reports --reporter html ./all-reports
      - uses: actions/upload-artifact@v4
        with: { name: playwright-report, path: playwright-report/ }
```

## playwright.config.ts for CI

```typescript
export default defineConfig({
  workers:    process.env.CI ? 2 : undefined,
  retries:    process.env.CI ? 2 : 0,
  reporter:   process.env.CI ? [['github'], ['html']] : [['html']],
  use: {
    baseURL:    process.env.BASE_URL || 'http://localhost:3000',
    trace:      'retain-on-failure',
    screenshot: 'only-on-failure',
    video:      'retain-on-failure',
  },
});
```

## Caching Browser Binaries

```yaml
- name: Cache Playwright browsers
  uses: actions/cache@v4
  id: playwright-cache
  with:
    path: ~/.cache/ms-playwright
    key: ${{ runner.os }}-playwright-${{ hashFiles('package-lock.json') }}

- name: Install browsers (only if not cached)
  if: steps.playwright-cache.outputs.cache-hit != 'true'
  run: npx playwright install --with-deps
```$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'GitHub Actions', 'CI/CD', 'Sharding', 'Artifacts', 'Workflow', 'Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle flaky tests in Playwright?',
  'how-to-handle-flaky-tests-playwright',
  'Identify flaky tests with trace viewer and retry tracking, then fix root causes: replace time-based waits with actionability checks, ensure test data isolation, and use stable locators.',
  $$## Handling Flaky Tests in Playwright

A flaky test is one that passes and fails inconsistently without any code change. Playwright has excellent tools to identify and fix them.

## Step 1 — Identify Flaky Tests

```typescript
// playwright.config.ts
export default defineConfig({
  retries: 2,
  use: {
    trace: 'on-first-retry', // Capture trace when test needs to retry
  },
  reporter: [
    ['html'],
    ['json', { outputFile: 'results.json' }],
  ],
});
```

After a run, tests that "passed on retry" are flaky. Check the HTML report for these.

## Common Causes and Fixes

### Cause 1 — Hard-coded Sleep

```typescript
// BAD — fixed wait doesn't adapt
await page.waitForTimeout(3000);
await page.click('#submit');

// GOOD — wait for actionable state
await page.getByRole('button', { name: 'Submit' }).click();
// Playwright auto-waits for visible, enabled, stable
```

### Cause 2 — Race Condition with Animation

```typescript
// BAD — clicking during animation
await page.locator('.animated-btn').click();

// GOOD — wait for animation to finish
await page.locator('.animated-btn').waitFor({ state: 'stable' });
await page.locator('.animated-btn').click();

// OR disable animations in config
use: {
  launchOptions: {
    args: ['--disable-animations']
  }
}
```

### Cause 3 — Data Dependency Between Tests

```typescript
// BAD — test B depends on test A's data
test('A: create user', async ({ page }) => { /* creates user with id=1 */ });
test('B: check user 1', async ({ page }) => { /* assumes user 1 exists */ });

// GOOD — each test creates its own data
test('check user', async ({ page, request }) => {
  // Create data needed for THIS test
  const user = await request.post('/api/users', {
    data: { email: `test-${Date.now()}@test.com` }
  });
  const { id } = await user.json();
  await page.goto(`/users/${id}`);
});
```

### Cause 4 — Shared State Between Tests

```typescript
// BAD — localStorage persists between tests (if not using fresh context)
// GOOD — each test gets a fresh BrowserContext automatically

// Or explicitly clear state
test.beforeEach(async ({ context }) => {
  await context.clearCookies();
  await page.evaluate(() => localStorage.clear());
});
```

### Cause 5 — Strict Mode Violation (Multiple Elements)

```typescript
// BAD — fails if more than one element matches
await page.locator('.btn').click(); // Error if multiple .btn found

// GOOD — be specific
await page.locator('.btn').first().click();
await page.locator('.modal .btn').click(); // Scope to parent
```

### Cause 6 — Network Timing Issues

```typescript
// BAD — navigate before API response arrives
await page.click('#load-data');
await expect(page.locator('.data-table')).toBeVisible();

// GOOD — wait for the network response
const [response] = await Promise.all([
  page.waitForResponse('**/api/data'),
  page.click('#load-data'),
]);
await expect(page.locator('.data-table')).toBeVisible();
```

## Tools to Debug Flaky Tests

```bash
# Run a test many times to reproduce flakiness
for i in {1..20}; do npx playwright test login.spec.ts; done

# Run with trace for debugging
npx playwright test --trace on

# UI Mode — watch test run interactively
npx playwright test --ui
```$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Flaky Tests', 'Debugging', 'Race Conditions', 'Test Stability', 'Best Practices'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you integrate Playwright with Cucumber BDD?',
  'playwright-integration-cucumber-bdd',
  'Use the @cucumber/cucumber package with playwright-cucumber or cucumber-playwright libraries. Write Gherkin feature files and map steps to Playwright actions using Given/When/Then.',
  $$## Playwright + Cucumber BDD Integration

## Installation

```bash
npm install --save-dev @cucumber/cucumber @playwright/test
npm install --save-dev playwright-cucumber-js
# OR use the community package:
npm install --save-dev @badeball/cypress-cucumber-preprocessor  # (for Cypress)
npm install --save-dev @cucumber/cucumber
```

Popular setup with `@cucumber/cucumber` + `@playwright/test` directly:

```bash
npm install --save-dev @cucumber/cucumber @playwright/test playwright
```

## Feature File

```gherkin
# features/login.feature
Feature: User Authentication
  As a registered user
  I want to log in to the application
  So that I can access my account

  Scenario: Successful login with valid credentials
    Given I am on the login page
    When I enter email "user@test.com" and password "password123"
    And I click the Sign In button
    Then I should be redirected to the dashboard
    And I should see the welcome message "Welcome back"

  Scenario Outline: Failed login with invalid credentials
    Given I am on the login page
    When I enter email "<email>" and password "<password>"
    And I click the Sign In button
    Then I should see error "<error>"

    Examples:
      | email              | password    | error                    |
      | wrong@test.com     | password123 | Invalid email or password |
      | user@test.com      | wrongpass   | Invalid email or password |
      | notanemail         | password123 | Please enter a valid email |
```

## Step Definitions

```typescript
// features/steps/login.steps.ts
import { Given, When, Then } from '@cucumber/cucumber';
import { chromium, Browser, BrowserContext, Page } from '@playwright/test';
import { expect } from '@playwright/test';

let browser: Browser;
let context: BrowserContext;
let page: Page;

Given('I am on the login page', async () => {
  browser = await chromium.launch({ headless: true });
  context = await browser.newContext();
  page    = await context.newPage();
  await page.goto(process.env.BASE_URL + '/login');
});

When('I enter email {string} and password {string}', async (email: string, password: string) => {
  await page.getByLabel('Email').fill(email);
  await page.getByLabel('Password').fill(password);
});

When('I click the Sign In button', async () => {
  await page.getByRole('button', { name: 'Sign in' }).click();
});

Then('I should be redirected to the dashboard', async () => {
  await expect(page).toHaveURL(/dashboard/);
});

Then('I should see the welcome message {string}', async (message: string) => {
  await expect(page.getByRole('heading')).toContainText(message);
});

Then('I should see error {string}', async (errorText: string) => {
  await expect(page.locator('.error-message')).toContainText(errorText);
});

// Teardown
After(async () => {
  await context?.close();
  await browser?.close();
});
```

## Cucumber Config

```typescript
// cucumber.config.ts
export default {
  default: {
    paths: ['features/**/*.feature'],
    require: ['features/steps/**/*.ts'],
    requireModule: ['ts-node/register'],
    format: ['progress', 'html:reports/cucumber-report.html'],
    parallel: 2,
    retry: 1,
  },
};
```

## Run Cucumber Tests

```bash
npx cucumber-js --config cucumber.config.ts
```

## World Context (Share Page Between Steps)

```typescript
// support/world.ts
import { setWorldConstructor, World } from '@cucumber/cucumber';
import { Browser, BrowserContext, Page, chromium } from '@playwright/test';

class PlaywrightWorld extends World {
  browser!: Browser;
  context!: BrowserContext;
  page!: Page;

  async init() {
    this.browser = await chromium.launch();
    this.context = await this.browser.newContext();
    this.page    = await this.context.newPage();
  }
}

setWorldConstructor(PlaywrightWorld);
```$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Cucumber', 'BDD', 'Gherkin', 'Feature Files', 'Given When Then'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Playwright Accessibility Testing and how do you use it?',
  'playwright-accessibility-testing',
  'Playwright has a built-in accessibility API (page.accessibility.snapshot()) and integrates with @axe-core/playwright for WCAG compliance testing. Use getByRole() locators to inherently test accessible HTML.',
  $$## Accessibility Testing in Playwright

## Built-in Accessibility Snapshot

Playwright can scan the page's accessibility tree:

```typescript
import { test, expect } from '@playwright/test';

test('check accessibility tree', async ({ page }) => {
  await page.goto('/login');

  // Get the full accessibility snapshot
  const snapshot = await page.accessibility.snapshot();
  console.log(JSON.stringify(snapshot, null, 2));
  // Shows: role, name, children for every accessible element
});
```

## Integration with axe-core (WCAG Compliance)

```bash
npm install --save-dev @axe-core/playwright
```

```typescript
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test('homepage has no accessibility violations', async ({ page }) => {
  await page.goto('/');

  const results = await new AxeBuilder({ page }).analyze();

  expect(results.violations).toHaveLength(0);
});

test('login page is accessible (WCAG 2.1 AA)', async ({ page }) => {
  await page.goto('/login');

  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa', 'wcag21aa'])
    .analyze();

  if (results.violations.length > 0) {
    console.log('Violations found:');
    results.violations.forEach(v => {
      console.log(`  [${v.impact}] ${v.id}: ${v.description}`);
      v.nodes.forEach(n => console.log(`    - ${n.html}`));
    });
  }

  expect(results.violations).toHaveLength(0);
});
```

## Exclude Elements from Scan

```typescript
const results = await new AxeBuilder({ page })
  .withTags(['wcag2a'])
  .exclude('.third-party-widget')  // Exclude third-party widgets
  .exclude('#cookie-banner')
  .analyze();
```

## Run on Specific Element

```typescript
const results = await new AxeBuilder({ page })
  .include('#main-form')   // Only scan the form
  .withTags(['wcag2aa'])
  .analyze();
```

## Role-Based Locators as Accessibility Tests

Using `getByRole()` inherently validates accessible HTML structure:

```typescript
test('navigation is accessible', async ({ page }) => {
  await page.goto('/');

  // If these work, the HTML has correct ARIA roles
  await expect(page.getByRole('navigation')).toBeVisible();
  await expect(page.getByRole('main')).toBeVisible();
  await expect(page.getByRole('banner')).toBeVisible();

  // Verify interactive elements are correctly labeled
  await expect(page.getByRole('button', { name: 'Close' })).toBeVisible();
  await expect(page.getByRole('link', { name: 'Skip to main content' })).toBeVisible();
});
```

## Keyboard Navigation Test

```typescript
test('form is keyboard navigable', async ({ page }) => {
  await page.goto('/contact');

  // Tab through form fields
  await page.keyboard.press('Tab');
  await expect(page.getByLabel('Name')).toBeFocused();

  await page.keyboard.press('Tab');
  await expect(page.getByLabel('Email')).toBeFocused();

  await page.keyboard.press('Tab');
  await expect(page.getByLabel('Message')).toBeFocused();

  // Submit via keyboard
  await page.keyboard.press('Tab');
  await page.keyboard.press('Enter');
  await expect(page.getByText('Message sent')).toBeVisible();
});
```

## Color Contrast Test

```typescript
// axe-core checks color contrast automatically with wcag2aa tag
const results = await new AxeBuilder({ page })
  .withTags(['wcag2aa'])
  .analyze();

const contrastViolations = results.violations.filter(v => v.id === 'color-contrast');
expect(contrastViolations).toHaveLength(0);
```$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Accessibility', 'axe-core', 'WCAG', 'A11y Testing', 'ARIA', 'Keyboard Navigation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are performance optimization techniques for large Playwright test suites?',
  'playwright-performance-optimization-techniques',
  'Optimize Playwright performance using parallel workers, storageState for auth reuse, API setup instead of UI flows, request blocking for assets, and strategic test organization with sharding.',
  $$## Playwright Performance Optimization

## 1. Maximize Parallel Execution

```typescript
// playwright.config.ts
export default defineConfig({
  fullyParallel: true,     // All tests parallel
  workers: process.env.CI
    ? 4
    : Math.floor(require('os').cpus().length / 2), // Half CPU count locally
});
```

## 2. Reuse Authentication State (Biggest Win)

Without optimization: 500 tests × login (5s) = **41 minutes just on logins**

```typescript
// Login ONCE, reuse for all tests
projects: [
  { name: 'setup', testMatch: '*.setup.ts' },
  {
    name: 'e2e',
    use: { storageState: '.auth/user.json' },
    dependencies: ['setup'],
  },
],
```

With storageState: login cost = **5 seconds total** (not 5s × 500 tests)

## 3. Use API for Test Data Setup (Not UI)

```typescript
// BAD — UI-based setup is slow
test.beforeEach(async ({ page }) => {
  await page.goto('/products/new');
  await page.fill('#name', 'Test Product');
  await page.fill('#price', '99.99');
  await page.click('#save');
  // 3-5 seconds per test
});

// GOOD — API setup is fast
test.beforeEach(async ({ request }) => {
  await request.post('/api/products', {
    data: { name: 'Test Product', price: 99.99 },
    headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
  });
  // 200ms per test
});
```

## 4. Block Unnecessary Network Requests

```typescript
// Block analytics, ads, and images to speed up page load
await page.route('**/*.{png,jpg,jpeg,gif,webp,svg}', r => r.abort());
await page.route('**/google-analytics.com/**', r => r.abort());
await page.route('**/hotjar.com/**', r => r.abort());
await page.route('**/facebook.com/**', r => r.abort());
```

## 5. Use networkidle Sparingly

```typescript
// BAD — networkidle waits for ALL network activity (500ms of silence)
await page.goto('/products', { waitUntil: 'networkidle' }); // Slow

// GOOD — wait for specific element instead
await page.goto('/products');
await page.locator('.product-card').first().waitFor();
```

## 6. Avoid page.waitForTimeout()

```typescript
// BAD — arbitrary sleep
await page.waitForTimeout(3000);

// GOOD — wait for the actual thing you need
await page.locator('.modal').waitFor({ state: 'hidden' });
await expect(page.locator('.data-loaded')).toBeVisible();
```

## 7. Efficient Test Data Strategy

```typescript
// Use unique data per test to avoid cleanup conflicts
const uniqueEmail = `user-${Date.now()}-${Math.random().toString(36).slice(2)}@test.com`;

// Use a test-specific database schema/namespace
process.env.DB_SCHEMA = `test_${testInfo.workerIndex}`;
```

## 8. Shard in CI

```yaml
strategy:
  matrix:
    shardIndex: [1, 2, 3, 4, 5, 6, 7, 8]
    shardTotal: [8]
```

8 shards × 4 workers = 32 tests running simultaneously.

## Performance Checklist

| Optimization | Expected Speedup |
|-------------|-----------------|
| `fullyParallel: true` | 2-4x |
| `storageState` auth reuse | 3-5x |
| API setup vs UI setup | 5-10x per test |
| Block unnecessary assets | 20-40% page load |
| Sharding (8 machines) | 8x |
| Minimize `networkidle` | 10-30% per navigation |$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Performance', 'Optimization', 'Parallel', 'storageState', 'Sharding', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you test a JWT-authenticated application in Playwright?',
  'how-to-test-jwt-authenticated-application-playwright',
  'Set JWT tokens via localStorage, cookies, or HTTP headers before navigating. Use storageState to persist tokens across tests, or inject tokens via page.addInitScript() before page load.',
  $$## Testing JWT-Authenticated Applications in Playwright

## Method 1 — Set JWT in localStorage Before Navigation

```typescript
test('access protected page with JWT', async ({ page }) => {
  const jwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  // Set token BEFORE navigating — otherwise the page loads without auth
  await page.addInitScript(token => {
    localStorage.setItem('access_token', token);
    localStorage.setItem('user', JSON.stringify({ id: 1, role: 'admin' }));
  }, jwtToken);

  await page.goto('/dashboard');
  await expect(page).toHaveURL('/dashboard');
  await expect(page.getByRole('heading')).toContainText('Dashboard');
});
```

## Method 2 — Set JWT as Cookie

```typescript
test('authenticate via JWT cookie', async ({ context, page }) => {
  await context.addCookies([{
    name: 'jwt_token',
    value: 'eyJhbGciOiJIUzI1NiJ9...',
    domain: 'localhost',
    path: '/',
    httpOnly: true,
    secure: false, // true for HTTPS
    sameSite: 'Lax',
  }]);

  await page.goto('/dashboard');
  await expect(page.getByRole('heading')).toHaveText('Dashboard');
});
```

## Method 3 — Intercept Requests and Add Auth Header

```typescript
test('add JWT to all API calls', async ({ page }) => {
  const token = process.env.TEST_JWT_TOKEN!;

  await page.route('/api/**', async route => {
    const headers = {
      ...route.request().headers(),
      'Authorization': `Bearer ${token}`,
    };
    await route.continue({ headers });
  });

  await page.goto('/products');
  await expect(page.locator('.product-list')).toBeVisible();
});
```

## Method 4 — Login via API to Get Real JWT

```typescript
import { test, expect } from '@playwright/test';

test.beforeAll(async ({ request }) => {
  // Login via API to get a real JWT
  const response = await request.post('/api/auth/login', {
    data: {
      email: 'test@example.com',
      password: 'password123',
    },
  });

  const { accessToken, refreshToken } = await response.json();
  process.env.ACCESS_TOKEN  = accessToken;
  process.env.REFRESH_TOKEN = refreshToken;
});

test('uses real JWT from API login', async ({ page }) => {
  await page.addInitScript(token => {
    localStorage.setItem('access_token', token);
  }, process.env.ACCESS_TOKEN);

  await page.goto('/profile');
  await expect(page.locator('.user-name')).toBeVisible();
});
```

## Method 5 — storageState for JWT Persistence

```typescript
// auth.setup.ts — save JWT in storageState
import { test as setup } from '@playwright/test';

setup('save auth state', async ({ page }) => {
  // Login normally via UI
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('/dashboard');

  // JWT is now in localStorage — save it
  await page.context().storageState({ path: '.auth/user.json' });
});
```

```typescript
// playwright.config.ts — all tests start with JWT in localStorage
projects: [
  { name: 'setup', testMatch: '*.setup.ts' },
  {
    name: 'e2e',
    use: { storageState: '.auth/user.json' }, // JWT already in storage
    dependencies: ['setup'],
  },
],
```

## Verify JWT in Test

```typescript
test('check token is set', async ({ page }) => {
  const token = await page.evaluate(() => localStorage.getItem('access_token'));
  expect(token).toBeTruthy();
  expect(token).toMatch(/^eyJ/); // JWT always starts with eyJ
});
```$$,
  'Playwright', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'JWT', 'Authentication', 'localStorage', 'storageState', 'Token', 'Security'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you extend and compose Playwright fixtures?',
  'how-to-extend-compose-playwright-fixtures',
  'Use test.extend() to build layered fixtures. Fixtures can depend on other fixtures, enabling composition. Worker-scoped fixtures share state across tests in the same worker process.',
  $$## Extending and Composing Playwright Fixtures

Fixtures are the recommended way to share setup code in Playwright. They compose cleanly — a fixture can depend on other fixtures.

## Basic Extension Pattern

```typescript
// fixtures/pages.ts
import { test as base } from '@playwright/test';
import { LoginPage }    from '../pages/LoginPage';
import { DashboardPage } from '../pages/DashboardPage';
import { ProductPage }  from '../pages/ProductPage';
import { CartPage }     from '../pages/CartPage';

// Declare fixture types
type PageFixtures = {
  loginPage:     LoginPage;
  dashboardPage: DashboardPage;
  productPage:   ProductPage;
  cartPage:      CartPage;
};

// Extend base test
export const test = base.extend<PageFixtures>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page));
  },
  productPage: async ({ page }, use) => {
    await use(new ProductPage(page));
  },
  cartPage: async ({ page }, use) => {
    await use(new CartPage(page));
  },
});

export { expect } from '@playwright/test';
```

## Fixture Depending on Another Fixture

```typescript
type AuthFixtures = {
  loggedInPage: DashboardPage; // Already authenticated
  adminPage:    DashboardPage; // Authenticated as admin
};

export const test = base.extend<AuthFixtures>({
  // This fixture depends on the loginPage fixture
  loggedInPage: async ({ page }, use) => {
    // Perform login directly
    await page.goto('/login');
    await page.getByLabel('Email').fill(process.env.TEST_EMAIL!);
    await page.getByLabel('Password').fill(process.env.TEST_PASS!);
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.waitForURL('/dashboard');

    await use(new DashboardPage(page));

    // Teardown — logout after test
    await page.getByRole('button', { name: 'Logout' }).click();
  },
});
```

## Layered Fixture Composition

```typescript
// Layer 1: Core fixtures
const testWithPages = base.extend<PageFixtures>({
  loginPage: async ({ page }, use) => await use(new LoginPage(page)),
});

// Layer 2: Auth on top of pages
const testWithAuth = testWithPages.extend<AuthFixtures>({
  loggedInPage: async ({ loginPage, page }, use) => {
    await loginPage.navigate();
    await loginPage.login('user@test.com', 'pass');
    await use(new DashboardPage(page));
  },
});

// Layer 3: Feature-specific on top of auth
export const test = testWithAuth.extend<FeatureFixtures>({
  productPage: async ({ page }, use) => await use(new ProductPage(page)),
});
```

## Worker-Scoped Fixtures (Shared Across Tests)

```typescript
type WorkerFixtures = {
  adminToken: string;  // Fetched once per worker
};

export const test = base.extend<{}, WorkerFixtures>({
  adminToken: [async ({}, use) => {
    // Login via API once per worker — NOT per test
    const res = await fetch('/api/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email: 'admin@test.com', password: 'admin' }),
      headers: { 'Content-Type': 'application/json' },
    });
    const { token } = await res.json();

    await use(token); // Token shared with all tests in this worker

    // Teardown: invalidate token
    await fetch('/api/auth/logout', {
      headers: { Authorization: `Bearer ${token}` },
    });
  }, { scope: 'worker' }],
});
```

## Using Composed Fixtures in Tests

```typescript
// tests/checkout.spec.ts
import { test, expect } from '../fixtures/pages';

test('checkout flow', async ({ loggedInPage, productPage, cartPage }) => {
  // Already logged in via loggedInPage fixture
  await productPage.navigateTo('laptop');
  await productPage.addToCart();

  await cartPage.navigate();
  await expect(cartPage.itemCount).toHaveText('1');
  await cartPage.checkout();
});
```$$,
  'Playwright', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Fixtures', 'test.extend', 'Composition', 'Worker Scope', 'Design Pattern'], true, 0
);
