-- Playwright Intermediate Interview Questions (Q26–Q50)
-- Technology: Playwright | Difficulty: Intermediate | Experience: 1-2 Years / 3-5 Years
-- Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is BrowserContext in Playwright and how is it different from a Browser?',
  'what-is-browser-context-in-playwright',
  'BrowserContext is an isolated browser session within one Browser instance — separate cookies, localStorage, auth state. Multiple contexts can run in one browser for parallel isolation.',
  $$## BrowserContext in Playwright

## The Three-Level Hierarchy

```
Browser
└── BrowserContext (isolated session)
    └── Page (a tab/window)
```

**Browser** — the browser process (Chromium, Firefox, WebKit)
**BrowserContext** — an isolated session, like a private/incognito window
**Page** — a single tab within a context

## What BrowserContext Isolates

Each context has its own:
- Cookies
- localStorage / sessionStorage
- Cache
- Authentication state
- Permissions
- Network settings

Changes in one context do NOT affect another — even running in the same browser process.

## Default Context in Tests

When you use `{ page }` in a Playwright test fixture, it automatically gets a fresh BrowserContext per test:

```typescript
test('isolated test', async ({ page }) => {
  // page lives in its own BrowserContext
  // No cookie/auth leakage from other tests
  await page.goto('/dashboard');
});
```

## Creating Contexts Manually

```typescript
import { chromium } from '@playwright/test';

const browser = await chromium.launch();

// Two isolated contexts = two separate sessions
const userContext  = await browser.newContext();
const adminContext = await browser.newContext();

const userPage  = await userContext.newPage();
const adminPage = await adminContext.newPage();

// User logs in as regular user
await userPage.goto('/login');
await userPage.fill('#email', 'user@test.com');

// Admin logs in simultaneously
await adminPage.goto('/admin/login');
await adminPage.fill('#email', 'admin@test.com');

await browser.close();
```

## Context with Custom Options

```typescript
const context = await browser.newContext({
  // Use saved auth state
  storageState: 'auth.json',

  // Emulate mobile
  viewport: { width: 375, height: 667 },
  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0...',
  isMobile: true,

  // Geolocation
  geolocation: { latitude: 40.7128, longitude: -74.0060 },
  permissions: ['geolocation'],

  // HTTP auth
  httpCredentials: { username: 'user', password: 'pass' },

  // Ignore HTTPS errors
  ignoreHTTPSErrors: true,

  // Record video
  recordVideo: { dir: 'videos/' },
});
```

## Use Case — Test Concurrent Users

```typescript
test('admin and user interact simultaneously', async ({ browser }) => {
  // Create two isolated sessions
  const adminCtx = await browser.newContext({ storageState: 'admin-auth.json' });
  const userCtx  = await browser.newContext({ storageState: 'user-auth.json' });

  const adminPage = await adminCtx.newPage();
  const userPage  = await userCtx.newPage();

  await adminPage.goto('/admin/inventory');
  await userPage.goto('/shop');

  // Admin updates stock
  await adminPage.getByTestId('item-1-stock').fill('0');
  await adminPage.getByRole('button', { name: 'Save' }).click();

  // User should see out-of-stock
  await userPage.reload();
  await expect(userPage.getByTestId('item-1-stock-badge')).toHaveText('Out of Stock');

  await adminCtx.close();
  await userCtx.close();
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'BrowserContext', 'Browser', 'Isolation', 'Parallel Tests', 'Sessions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle file uploads in Playwright?',
  'how-to-handle-file-uploads-in-playwright',
  'Use locator.setInputFiles() to upload files. It accepts a file path, array of paths, or buffer. For custom upload buttons, combine click interception with setInputFiles().',
  $$## File Uploads in Playwright

## Basic File Upload (Native Input)

```typescript
// Upload a single file
await page.getByLabel('Upload File').setInputFiles('tests/fixtures/resume.pdf');

// Upload multiple files
await page.getByLabel('Upload Photos').setInputFiles([
  'tests/fixtures/photo1.jpg',
  'tests/fixtures/photo2.jpg',
]);
```

## Upload with CSS Locator

```typescript
await page.locator('input[type="file"]').setInputFiles('tests/fixtures/document.pdf');
```

## Remove Files (Clear Upload)

```typescript
await page.locator('input[type="file"]').setInputFiles([]);
```

## Upload with File Buffer (Dynamic Files)

```typescript
// Create file content in memory
await page.locator('input[type="file"]').setInputFiles({
  name: 'test-file.txt',
  mimeType: 'text/plain',
  buffer: Buffer.from('Hello, World! This is test content.'),
});

// Upload a dynamically created JSON file
await page.locator('input[type="file"]').setInputFiles({
  name: 'config.json',
  mimeType: 'application/json',
  buffer: Buffer.from(JSON.stringify({ env: 'test', version: '1.0' })),
});
```

## Hidden File Input (Custom Upload Button)

When the `<input type="file">` is hidden and triggered by a custom button:

```typescript
// Method 1: Directly set files on the hidden input
await page.locator('input[type="file"]').setInputFiles('resume.pdf');

// Method 2: Wait for file chooser dialog
const [fileChooser] = await Promise.all([
  page.waitForEvent('filechooser'),
  page.getByRole('button', { name: 'Choose File' }).click(),
]);
await fileChooser.setFiles('tests/fixtures/resume.pdf');
```

## Drag and Drop File Upload

```typescript
// Simulate file being dragged onto a drop zone
const dropZone = page.locator('.drop-zone');
await dropZone.dispatchEvent('drop', {
  dataTransfer: await page.evaluateHandle(() => {
    const dt = new DataTransfer();
    // Note: Full file drag-drop requires additional setup
    return dt;
  }),
});
```

## Verify Upload Success

```typescript
import { test, expect } from '@playwright/test';
import path from 'path';

test('upload profile picture', async ({ page }) => {
  await page.goto('/profile/edit');

  const filePath = path.join(__dirname, 'fixtures', 'profile.jpg');
  await page.locator('input[type="file"]').setInputFiles(filePath);

  // Verify preview appears
  await expect(page.locator('.image-preview img')).toBeVisible();

  await page.getByRole('button', { name: 'Save' }).click();
  await expect(page.locator('.success-toast')).toContainText('Profile updated');
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'File Upload', 'setInputFiles', 'fileChooser', 'Form Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle file downloads in Playwright?',
  'how-to-handle-file-downloads-in-playwright',
  'Use page.waitForEvent("download") before clicking the download trigger to capture a Download object, then save or verify it using download.path() and download.saveAs().',
  $$## File Downloads in Playwright

## Basic Download

```typescript
import { test, expect } from '@playwright/test';
import path from 'path';
import fs from 'fs';

test('download invoice PDF', async ({ page }) => {
  await page.goto('/invoices');

  // Start waiting for download BEFORE the action that triggers it
  const downloadPromise = page.waitForEvent('download');

  // Click the download button
  await page.getByRole('button', { name: 'Download Invoice' }).click();

  // Wait for download to complete
  const download = await downloadPromise;

  // Get the filename
  console.log(download.suggestedFilename()); // "invoice-2024-01.pdf"

  // Save to a custom path
  const savePath = path.join('test-downloads', download.suggestedFilename());
  await download.saveAs(savePath);

  // Verify the file exists
  expect(fs.existsSync(savePath)).toBeTruthy();
});
```

## Download from Link Click

```typescript
test('download CSV report', async ({ page }) => {
  await page.goto('/reports');

  const [download] = await Promise.all([
    page.waitForEvent('download'),
    page.getByRole('link', { name: 'Export as CSV' }).click(),
  ]);

  await download.saveAs(`downloads/${download.suggestedFilename()}`);

  // Verify file size is non-zero
  const stats = fs.statSync(`downloads/${download.suggestedFilename()}`);
  expect(stats.size).toBeGreaterThan(0);
});
```

## Read Downloaded File Content

```typescript
test('verify CSV content', async ({ page }) => {
  await page.goto('/data-export');

  const downloadPromise = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Export' }).click();
  const download = await downloadPromise;

  // Get the downloaded file path (temp path)
  const filePath = await download.path();

  // Read and verify content
  const content = fs.readFileSync(filePath!, 'utf-8');
  expect(content).toContain('Name,Email,Phone');
  expect(content).toContain('John Doe');
});
```

## Configure Download Directory

```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    acceptDownloads: true, // Must be true (default)
  },
});
```

## Download Failure Check

```typescript
test('handle download failure', async ({ page }) => {
  const downloadPromise = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Download' }).click();
  const download = await downloadPromise;

  // Check for failure
  const failure = await download.failure();
  if (failure) {
    console.error('Download failed:', failure);
  } else {
    console.log('Download succeeded:', download.suggestedFilename());
  }
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'File Download', 'waitForEvent', 'download', 'CSV', 'PDF'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you intercept and modify network requests in Playwright?',
  'how-to-intercept-network-requests-playwright',
  'Use page.route() with a URL pattern or glob to intercept requests. Inside the handler call route.fulfill() to mock responses, route.abort() to cancel, or route.continue() to pass through.',
  $$## Network Interception with page.route()

`page.route()` intercepts HTTP/HTTPS requests matching a URL pattern and lets you mock, abort, or modify them.

## Mock an API Response (Fulfill)

```typescript
test('show product list with mocked API', async ({ page }) => {
  // Intercept GET /api/products
  await page.route('/api/products', async route => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify([
        { id: 1, name: 'Laptop', price: 999 },
        { id: 2, name: 'Mouse',  price: 29 },
      ]),
    });
  });

  await page.goto('/products');
  await expect(page.locator('.product-card')).toHaveCount(2);
  await expect(page.locator('.product-card').first()).toContainText('Laptop');
});
```

## Block a Request (Abort)

```typescript
// Block all image requests to speed up tests
await page.route('**/*.{png,jpg,jpeg,gif,svg}', route => route.abort());

// Block analytics tracking
await page.route('**/google-analytics.com/**', route => route.abort());
await page.route('**/hotjar.com/**', route => route.abort());
```

## Modify Request and Pass Through

```typescript
// Add auth header to every API call
await page.route('/api/**', async route => {
  const headers = {
    ...route.request().headers(),
    Authorization: 'Bearer test-token-123',
  };
  await route.continue({ headers });
});
```

## Mock Error Responses

```typescript
// Test how your app handles a 500 error
await page.route('/api/orders', route =>
  route.fulfill({
    status: 500,
    body: JSON.stringify({ error: 'Internal Server Error' }),
  })
);

await page.goto('/orders');
await expect(page.locator('.error-message')).toContainText('Something went wrong');
```

## Mock Network Failure

```typescript
// Simulate no network / timeout
await page.route('/api/data', route => route.abort('failed'));
```

## Intercept Once

```typescript
// Intercept only the FIRST matching request
await page.routeOnce('/api/user', route =>
  route.fulfill({ json: { name: 'Test User', role: 'admin' } })
);
```

## URL Pattern Matching

```typescript
// Exact URL
await page.route('https://api.example.com/users', handler);

// Glob pattern
await page.route('**/api/**', handler);
await page.route('/api/products*', handler);  // matches /api/products, /api/products?page=2

// Regex
await page.route(/\/api\/users\/\d+/, handler);
```

## Inspect Request Details

```typescript
await page.route('/api/**', async route => {
  const request = route.request();
  console.log('Method:', request.method());       // GET, POST, etc.
  console.log('URL:', request.url());
  console.log('Headers:', request.headers());
  console.log('Body:', request.postData());        // POST body

  await route.continue(); // Pass through unmodified
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Network Interception', 'page.route', 'Mock API', 'route.fulfill', 'route.abort'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are fixtures in Playwright and how do you create custom fixtures?',
  'what-are-fixtures-in-playwright-custom-fixtures',
  'Fixtures are reusable test setup functions injected via destructuring in the test function signature. Custom fixtures extend the base test object to share page objects, auth state, and utilities.',
  $$## Playwright Fixtures

Fixtures are **reusable setup/teardown functions** that Playwright injects into tests. Built-in fixtures include `page`, `browser`, `context`, `request`, and `browserName`.

## Built-in Fixtures

```typescript
test('uses built-in fixtures', async ({
  page,       // A new Page in a new BrowserContext
  browser,    // The Browser instance
  context,    // The BrowserContext
  request,    // API request context
  browserName // 'chromium' | 'firefox' | 'webkit'
}) => {
  await page.goto('/');
});
```

## Creating Custom Fixtures

Extend `test` with `test.extend()` to add your own fixtures:

```typescript
// fixtures.ts
import { test as base, expect } from '@playwright/test';
import { LoginPage } from './pages/LoginPage';
import { DashboardPage } from './pages/DashboardPage';
import { ProductPage } from './pages/ProductPage';

// Define the fixture types
type MyFixtures = {
  loginPage: LoginPage;
  dashboardPage: DashboardPage;
  productPage: ProductPage;
  authenticatedPage: LoginPage;
};

// Extend the base test
export const test = base.extend<MyFixtures>({
  // Simple page object fixture
  loginPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page);
    await use(loginPage); // 'use' provides the fixture to the test
    // Teardown happens after 'use' returns
  },

  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page));
  },

  productPage: async ({ page }, use) => {
    await use(new ProductPage(page));
  },

  // Fixture that logs in before the test
  authenticatedPage: async ({ page }, use) => {
    await page.goto('/login');
    await page.getByLabel('Email').fill('user@test.com');
    await page.getByLabel('Password').fill('pass123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.waitForURL('/dashboard');

    await use(new LoginPage(page));  // Test runs here

    // Optional: logout after test
    await page.getByRole('button', { name: 'Logout' }).click();
  },
});

export { expect } from '@playwright/test';
```

## Using Custom Fixtures in Tests

```typescript
// tests/dashboard.spec.ts
import { test, expect } from '../fixtures';

test('dashboard loads with auth fixture', async ({ dashboardPage, authenticatedPage }) => {
  // Already logged in — authenticatedPage fixture handled it
  await expect(dashboardPage.welcomeHeading).toBeVisible();
});

test('login page has correct title', async ({ loginPage }) => {
  await loginPage.navigate();
  await expect(loginPage.heading).toHaveText('Sign In');
});
```

## Fixture Scope — Worker-Level Fixtures

By default, fixtures run per test. Use `scope: 'worker'` for shared setup:

```typescript
type WorkerFixtures = {
  workerStorageState: string;
};

export const test = base.extend<{}, WorkerFixtures>({
  workerStorageState: [async ({ browser }, use) => {
    // Runs ONCE per worker — shared across tests in that worker
    const page = await browser.newPage();
    await page.goto('/login');
    await page.fill('#email', 'admin@test.com');
    await page.fill('#password', 'admin');
    await page.click('#submit');
    await page.context().storageState({ path: 'admin-auth.json' });
    await page.close();
    await use('admin-auth.json');
  }, { scope: 'worker' }],
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Fixtures', 'Custom Fixtures', 'test.extend', 'Page Object', 'Reusability'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is storageState in Playwright and how do you use it for authentication?',
  'what-is-storagestate-playwright-authentication',
  'storageState saves browser cookies, localStorage, and sessionStorage to a JSON file. Reloading it in subsequent tests skips the login flow, making tests faster and more reliable.',
  $$## storageState in Playwright

`storageState` lets you save and restore the complete browser session state — cookies, localStorage, and sessionStorage — to a JSON file. This is the primary mechanism for **login-once, reuse across all tests**.

## Step 1: Create a Setup File (Login Once)

```typescript
// tests/auth.setup.ts
import { test as setup, expect } from '@playwright/test';
import path from 'path';

const authFile = path.join(__dirname, '../.auth/user.json');

setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Sign in' }).click();

  // Wait for the auth cookie to be set
  await expect(page).toHaveURL('/dashboard');

  // Save the auth state (cookies + localStorage)
  await page.context().storageState({ path: authFile });
});
```

## Step 2: Configure playwright.config.ts

```typescript
import { defineConfig } from '@playwright/test';
import path from 'path';

export default defineConfig({
  projects: [
    // Setup project — runs first
    {
      name: 'setup',
      testMatch: /.*\.setup\.ts/,
    },

    // Tests that need auth — run after setup
    {
      name: 'chromium',
      use: {
        storageState: '.auth/user.json', // Load saved auth state
      },
      dependencies: ['setup'], // Must run after setup
    },
  ],
});
```

## Step 3: Tests Start Already Logged In

```typescript
// tests/dashboard.spec.ts
import { test, expect } from '@playwright/test';

// No login needed — storageState already loaded
test('user can see dashboard', async ({ page }) => {
  await page.goto('/dashboard');
  await expect(page.getByRole('heading')).toHaveText('Dashboard');
});

test('user can edit profile', async ({ page }) => {
  await page.goto('/profile');
  await expect(page.getByLabel('Email')).toHaveValue('user@test.com');
});
```

## Multiple User Roles

```typescript
// playwright.config.ts
projects: [
  { name: 'setup-user',  testMatch: /user\.setup\.ts/ },
  { name: 'setup-admin', testMatch: /admin\.setup\.ts/ },

  {
    name: 'user-tests',
    use: { storageState: '.auth/user.json' },
    dependencies: ['setup-user'],
  },
  {
    name: 'admin-tests',
    use: { storageState: '.auth/admin.json' },
    dependencies: ['setup-admin'],
  },
],
```

## What the .auth/user.json Contains

```json
{
  "cookies": [
    {
      "name": "session_id",
      "value": "abc123xyz",
      "domain": "myapp.com",
      "path": "/",
      "httpOnly": true,
      "secure": true
    }
  ],
  "origins": [
    {
      "origin": "https://myapp.com",
      "localStorage": [
        { "name": "auth_token", "value": "eyJhbGc..." }
      ]
    }
  ]
}
```

## Benefits

- Tests run **3-5x faster** (no login on every test)
- Login logic centralized in one place
- Works with any auth mechanism (cookies, JWT, session)$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'storageState', 'Authentication', 'Login', 'Cookies', 'Session', 'Auth Setup'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you run Playwright tests in parallel?',
  'how-to-run-playwright-tests-in-parallel',
  'Playwright runs tests in parallel by default using workers. Set fullyParallel:true for file-level parallelism, control workers with the workers option, and use test.describe.parallel() for within-file parallelism.',
  $$## Parallel Test Execution in Playwright

Playwright supports parallel execution natively — no extra plugins or test runners needed.

## How Playwright Parallelism Works

- Each test runs in a **separate worker process**
- Each worker gets its own browser, context, and page
- Workers are isolated — no shared state between tests
- By default: 1/2 of your CPU cores are used

## Configuration

```typescript
// playwright.config.ts
export default defineConfig({
  // Run ALL tests in all files in parallel
  fullyParallel: true,

  // Number of workers
  workers: 4,                              // Fixed number
  workers: process.env.CI ? 2 : undefined, // 2 on CI, auto locally
});
```

## Default Behavior (Without fullyParallel)

By default, Playwright runs **test files in parallel** but tests within one file run **sequentially**:

```
File A (worker 1): test1 → test2 → test3
File B (worker 2): testA → testB → testC
```

## fullyParallel — Tests Within a File Also Run in Parallel

```typescript
export default defineConfig({
  fullyParallel: true,  // test1, test2, test3 from same file run in parallel
});
```

## Parallelize Within a Describe Block

```typescript
test.describe.parallel('Product Tests', () => {
  test('test product 1', async ({ page }) => { /* ... */ });
  test('test product 2', async ({ page }) => { /* ... */ });
  test('test product 3', async ({ page }) => { /* ... */ });
  // All 3 run simultaneously
});
```

## Sequential Tests (Disable Parallelism for a Group)

```typescript
test.describe.serial('Checkout Flow', () => {
  // These run one after another, in order
  test('add item to cart', async ({ page }) => { /* ... */ });
  test('proceed to checkout', async ({ page }) => { /* ... */ });
  test('complete payment', async ({ page }) => { /* ... */ });
});
```

## Sharding Across Multiple Machines (CI)

```bash
# CI Pipeline: 4 machines running simultaneously

# Machine 1 — runs 25% of tests
npx playwright test --shard=1/4

# Machine 2
npx playwright test --shard=2/4

# Machine 3
npx playwright test --shard=3/4

# Machine 4
npx playwright test --shard=4/4
```

## Worker Configuration in CI

```typescript
// playwright.config.ts
export default defineConfig({
  workers: process.env.CI ? 4 : undefined,
  retries: process.env.CI ? 2 : 0,
  fullyParallel: true,
});
```

## Avoid Shared State in Parallel Tests

```typescript
// BAD — tests share global state
let userId: string;
test.beforeAll(() => { userId = createUser(); });

// GOOD — each test creates its own data
test('create user', async ({ page, request }) => {
  const user = await request.post('/api/users', {
    data: { email: `user-${Date.now()}@test.com` },
  });
  // Use unique user per test
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Parallel Testing', 'Workers', 'fullyParallel', 'Sharding', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you implement Page Object Model (POM) in Playwright with TypeScript?',
  'page-object-model-playwright-typescript',
  'Create classes for each page with Locator properties and action methods. Import and instantiate them in tests. TypeScript types provide compile-time safety and IDE autocomplete.',
  $$## Page Object Model in Playwright with TypeScript

The Page Object Model pattern separates **element locators and actions** from **test logic**, making tests readable and maintainable.

## Base Page Class (Optional but Recommended)

```typescript
// pages/BasePage.ts
import { Page } from '@playwright/test';

export abstract class BasePage {
  constructor(protected page: Page) {}

  async navigate(path: string): Promise<void> {
    await this.page.goto(path);
  }

  async waitForPageLoad(): Promise<void> {
    await this.page.waitForLoadState('domcontentloaded');
  }
}
```

## Login Page Object

```typescript
// pages/LoginPage.ts
import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class LoginPage extends BasePage {
  // Locators as properties
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly signInButton: Locator;
  readonly errorMessage: Locator;
  readonly forgotPasswordLink: Locator;

  constructor(page: Page) {
    super(page);
    this.emailInput        = page.getByLabel('Email');
    this.passwordInput     = page.getByLabel('Password');
    this.signInButton      = page.getByRole('button', { name: 'Sign in' });
    this.errorMessage      = page.getByTestId('error-message');
    this.forgotPasswordLink = page.getByRole('link', { name: 'Forgot Password?' });
  }

  async goto(): Promise<void> {
    await this.page.goto('/login');
  }

  async login(email: string, password: string): Promise<void> {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.signInButton.click();
  }

  async expectError(message: string): Promise<void> {
    await expect(this.errorMessage).toBeVisible();
    await expect(this.errorMessage).toContainText(message);
  }
}
```

## Dashboard Page Object

```typescript
// pages/DashboardPage.ts
import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class DashboardPage extends BasePage {
  readonly welcomeHeading: Locator;
  readonly userAvatar: Locator;
  readonly logoutButton: Locator;
  readonly navItems: Locator;

  constructor(page: Page) {
    super(page);
    this.welcomeHeading = page.getByRole('heading', { name: /Welcome/ });
    this.userAvatar     = page.getByTestId('user-avatar');
    this.logoutButton   = page.getByRole('button', { name: 'Logout' });
    this.navItems       = page.locator('nav a');
  }

  async goto(): Promise<void> {
    await this.page.goto('/dashboard');
  }

  async logout(): Promise<void> {
    await this.logoutButton.click();
    await expect(this.page).toHaveURL('/login');
  }

  async expectUserLoggedIn(name: string): Promise<void> {
    await expect(this.welcomeHeading).toContainText(name);
    await expect(this.userAvatar).toBeVisible();
  }
}
```

## Test Using Page Objects

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import { DashboardPage } from '../pages/DashboardPage';

test.describe('Login Flow', () => {
  let loginPage: LoginPage;
  let dashboardPage: DashboardPage;

  test.beforeEach(async ({ page }) => {
    loginPage    = new LoginPage(page);
    dashboardPage = new DashboardPage(page);
    await loginPage.goto();
  });

  test('valid login navigates to dashboard', async () => {
    await loginPage.login('user@test.com', 'pass123');
    await expect(loginPage.page).toHaveURL('/dashboard');
    await dashboardPage.expectUserLoggedIn('Jane');
  });

  test('invalid credentials shows error', async () => {
    await loginPage.login('wrong@test.com', 'wrongpass');
    await loginPage.expectError('Invalid credentials');
  });

  test('user can logout', async () => {
    await loginPage.login('user@test.com', 'pass123');
    await dashboardPage.logout();
    await expect(loginPage.page).toHaveURL('/login');
  });
});
```

## Project Structure

```
playwright-project/
├── pages/
│   ├── BasePage.ts
│   ├── LoginPage.ts
│   ├── DashboardPage.ts
│   └── ProductPage.ts
├── tests/
│   ├── login.spec.ts
│   └── products.spec.ts
├── fixtures.ts
└── playwright.config.ts
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Page Object Model', 'POM', 'TypeScript', 'Design Pattern', 'Maintainability'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you perform hover, double-click, and right-click actions in Playwright?',
  'hover-double-click-right-click-playwright',
  'Use locator.hover() for hover, locator.dblclick() for double-click, and locator.click({ button: "right" }) for right-click. Playwright also supports keyboard modifiers for these actions.',
  $$## Mouse Actions in Playwright

## Hover

```typescript
// Hover over an element (triggers CSS :hover state and tooltips)
await page.locator('.menu-item').hover();
await page.getByRole('button', { name: 'Options' }).hover();

// After hover, interact with revealed elements
await page.locator('#user-avatar').hover();
await page.getByRole('menuitem', { name: 'Profile' }).click();
```

## Double Click

```typescript
// Double-click to select text, open editor, etc.
await page.locator('.editable-cell').dblclick();
await page.getByRole('gridcell', { name: 'Click to edit' }).dblclick();

// Double-click at a specific position
await page.locator('#canvas').dblclick({ position: { x: 100, y: 50 } });
```

## Right Click (Context Menu)

```typescript
// Open context menu
await page.locator('.file-item').click({ button: 'right' });

// Verify context menu appeared
await expect(page.getByRole('menu')).toBeVisible();

// Click a menu option
await page.getByRole('menuitem', { name: 'Delete' }).click();
```

## Full Example — Hover Menu Navigation

```typescript
import { test, expect } from '@playwright/test';

test('navigate via hover dropdown menu', async ({ page }) => {
  await page.goto('/');

  // Hover over the "Products" nav item to reveal submenu
  await page.getByRole('link', { name: 'Products' }).hover();

  // Wait for submenu to appear
  await expect(page.getByRole('menu')).toBeVisible();

  // Click a submenu item
  await page.getByRole('menuitem', { name: 'Laptops' }).click();

  await expect(page).toHaveURL('/products/laptops');
});
```

## Full Example — Double-Click to Edit

```typescript
test('edit table cell with double-click', async ({ page }) => {
  await page.goto('/data-table');

  // Double-click the cell to enter edit mode
  const cell = page.locator('td').filter({ hasText: 'John Doe' }).first();
  await cell.dblclick();

  // Verify edit input appeared
  const editInput = cell.locator('input');
  await expect(editInput).toBeVisible();
  await editInput.fill('Jane Doe');
  await editInput.press('Enter');

  await expect(cell).toHaveText('Jane Doe');
});
```

## Full Example — Right-Click Context Menu

```typescript
test('delete file via context menu', async ({ page }) => {
  await page.goto('/file-manager');

  const file = page.locator('.file').filter({ hasText: 'report.pdf' });

  // Right-click to open context menu
  await file.click({ button: 'right' });
  await expect(page.getByRole('menu')).toBeVisible();

  // Click Delete in context menu
  await page.getByRole('menuitem', { name: 'Delete' }).click();

  // Handle confirmation
  page.once('dialog', d => d.accept());

  await expect(file).not.toBeAttached();
});
```

## Modifier Key Combinations

```typescript
// Ctrl+Click (multi-select)
await page.locator('.item-1').click({ modifiers: ['Control'] });
await page.locator('.item-3').click({ modifiers: ['Control'] });

// Shift+Click (range select)
await page.locator('.item-1').click();
await page.locator('.item-5').click({ modifiers: ['Shift'] });

// Alt+Click
await page.locator('#element').click({ modifiers: ['Alt'] });
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Hover', 'Double Click', 'Right Click', 'Mouse Actions', 'Context Menu'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is page.evaluate() in Playwright and when do you use it?',
  'what-is-page-evaluate-playwright',
  'page.evaluate() executes JavaScript inside the browser context and returns the serialized result to Node.js. Use it to access the DOM, read variables, or trigger browser-only APIs.',
  $$## page.evaluate() in Playwright

`page.evaluate()` runs a JavaScript function **inside the browser** and returns the result back to your Node.js test code.

## Basic Usage

```typescript
// Execute JS and get the return value
const title = await page.evaluate(() => document.title);
console.log(title); // "My App"

// Get page URL
const url = await page.evaluate(() => window.location.href);

// Get a computed style
const color = await page.evaluate(() => {
  const el = document.querySelector('.header');
  return window.getComputedStyle(el!).color;
});
```

## Passing Arguments to evaluate()

```typescript
// Pass values from Node.js into the browser function
const selector = '.product-card';
const count = await page.evaluate((sel) => {
  return document.querySelectorAll(sel).length;
}, selector);

// Pass multiple values using an object
const result = await page.evaluate(({ name, age }) => {
  return `${name} is ${age}`;
}, { name: 'John', age: 30 });
```

## Common Use Cases

### Read localStorage / sessionStorage

```typescript
const token = await page.evaluate(() => localStorage.getItem('auth_token'));
const session = await page.evaluate(() => sessionStorage.getItem('user_id'));
```

### Set localStorage (Setup for tests)

```typescript
await page.evaluate(token => {
  localStorage.setItem('auth_token', token);
}, 'my-test-token-123');
```

### Scroll to Element or Position

```typescript
await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));

await page.evaluate(selector => {
  document.querySelector(selector)?.scrollIntoView();
}, '#footer');
```

### Read Cookie (not httpOnly ones)

```typescript
const cookie = await page.evaluate(() => document.cookie);
```

### Trigger Custom Events

```typescript
await page.evaluate(() => {
  window.dispatchEvent(new Event('storage'));
});
```

### Force Hide Element

```typescript
await page.evaluate(selector => {
  const el = document.querySelector(selector) as HTMLElement;
  if (el) el.style.display = 'none';
}, '.cookie-banner');
```

## page.evaluate() vs page.evaluateHandle()

| | `evaluate()` | `evaluateHandle()` |
|--|-------------|-------------------|
| Returns | Serialized JS value (JSON) | A handle to a JS object |
| Use when | Need a primitive/plain object | Need to keep a DOM element reference |

```typescript
// evaluateHandle — returns a JSHandle to a DOM element
const element = await page.evaluateHandle(() => document.querySelector('h1'));
await element.asElement()?.click();
```

## Limitations

- Only JSON-serializable values can be returned by `evaluate()`
- Cannot return DOM elements directly (use `evaluateHandle()` for that)
- Runs in the browser context — no access to Node.js `fs`, `path`, etc.$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'page.evaluate', 'JavaScript Execution', 'localStorage', 'DOM Manipulation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you manage cookies in Playwright?',
  'how-to-manage-cookies-playwright',
  'Use context.cookies() to read, context.addCookies() to set, and context.clearCookies() to delete cookies. Cookies are managed at the BrowserContext level in Playwright.',
  $$## Cookie Management in Playwright

Cookies in Playwright are managed at the **BrowserContext** level, not at the page level.

## Read Cookies

```typescript
// Get all cookies for the current context
const cookies = await context.cookies();
console.log(cookies);
// [{ name: 'session', value: 'abc123', domain: 'myapp.com', ... }]

// Get cookies for a specific URL
const cookies = await context.cookies(['https://myapp.com']);

// Find a specific cookie
const sessionCookie = cookies.find(c => c.name === 'session_id');
console.log(sessionCookie?.value);
```

## Set Cookies

```typescript
await context.addCookies([
  {
    name: 'auth_token',
    value: 'test-jwt-token-123',
    domain: 'myapp.com',
    path: '/',
    httpOnly: true,
    secure: true,
    sameSite: 'Lax',
  },
  {
    name: 'user_preference',
    value: 'dark_mode',
    domain: 'myapp.com',
    path: '/',
  }
]);
```

## Clear Cookies

```typescript
// Clear all cookies
await context.clearCookies();

// Clear cookies for a specific domain (Playwright v1.43+)
await context.clearCookies({ domain: 'ads.example.com' });
```

## In Test Fixtures

```typescript
import { test, expect } from '@playwright/test';

test('set auth cookie before test', async ({ page, context }) => {
  // Set auth cookie before navigating (bypasses login UI)
  await context.addCookies([{
    name: 'session_id',
    value: 'valid-session-token',
    domain: 'localhost',
    path: '/',
  }]);

  // Navigate directly to authenticated page
  await page.goto('/dashboard');
  await expect(page.getByRole('heading')).toHaveText('Dashboard');
});
```

## Cookie-based Authentication Test

```typescript
test('authenticated via cookie', async ({ context, page }) => {
  // Set the session cookie
  await context.addCookies([{
    name: 'connect.sid',
    value: 'valid_session_value',
    domain: 'localhost',
    path: '/',
    httpOnly: true,
  }]);

  await page.goto('/protected-page');
  // Should access the page without being redirected to login
  await expect(page).not.toHaveURL('/login');
  await expect(page.locator('.user-profile')).toBeVisible();
});
```

## Verify Cookie is Set After Action

```typescript
test('login sets session cookie', async ({ page, context }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await expect(page).toHaveURL('/dashboard');

  // Verify the session cookie was set
  const cookies = await context.cookies();
  const sessionCookie = cookies.find(c => c.name === 'session_id');
  expect(sessionCookie).toBeTruthy();
  expect(sessionCookie!.httpOnly).toBe(true);
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Cookies', 'context.addCookies', 'context.cookies', 'Authentication', 'Session'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you access localStorage and sessionStorage in Playwright?',
  'how-to-access-localstorage-sessionstorage-playwright',
  'Use page.evaluate() to read, write, and clear localStorage/sessionStorage since these are browser APIs. Playwright can also set them via page.addInitScript() before page load.',
  $$## localStorage and sessionStorage in Playwright

localStorage and sessionStorage are browser-only APIs, so Playwright accesses them via `page.evaluate()`.

## Read localStorage

```typescript
// Get a specific item
const token = await page.evaluate(() => localStorage.getItem('auth_token'));
console.log(token); // "eyJhbGciOiJIUzI1NiJ9..."

// Get all localStorage items
const allItems = await page.evaluate(() => {
  const result: Record<string, string> = {};
  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i)!;
    result[key] = localStorage.getItem(key)!;
  }
  return result;
});
```

## Write to localStorage

```typescript
// Set an item
await page.evaluate(() => {
  localStorage.setItem('auth_token', 'test-jwt-token-123');
  localStorage.setItem('user_id', '42');
  localStorage.setItem('theme', 'dark');
});
```

## Clear localStorage

```typescript
// Remove a specific item
await page.evaluate(() => localStorage.removeItem('auth_token'));

// Clear all localStorage
await page.evaluate(() => localStorage.clear());
```

## Set localStorage Before Page Loads (addInitScript)

```typescript
// This runs BEFORE any page scripts — useful for setting initial state
await page.addInitScript(() => {
  localStorage.setItem('auth_token', 'pre-set-token');
  localStorage.setItem('onboarding_complete', 'true');
});

await page.goto('/app'); // localStorage is already set when app code runs
```

## sessionStorage

```typescript
// Same API, just use sessionStorage instead
const sessionId = await page.evaluate(() => sessionStorage.getItem('session_id'));

await page.evaluate(() => {
  sessionStorage.setItem('cart_id', 'cart-abc-123');
});

await page.evaluate(() => sessionStorage.clear());
```

## Practical Use Case — Bypass Onboarding

```typescript
test('skip onboarding wizard', async ({ page }) => {
  // Simulate user who has already completed onboarding
  await page.addInitScript(() => {
    localStorage.setItem('onboarding_complete', 'true');
    localStorage.setItem('user_preferences', JSON.stringify({ theme: 'dark' }));
  });

  await page.goto('/app');

  // Should skip onboarding and go straight to dashboard
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('.onboarding-wizard')).not.toBeVisible();
});
```

## Verify localStorage After Action

```typescript
test('preferences saved to localStorage', async ({ page }) => {
  await page.goto('/settings');
  await page.getByLabel('Theme').selectOption('dark');
  await page.getByRole('button', { name: 'Save Preferences' }).click();

  // Verify saved
  const theme = await page.evaluate(() => localStorage.getItem('theme'));
  expect(theme).toBe('dark');
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'localStorage', 'sessionStorage', 'page.evaluate', 'addInitScript', 'Browser Storage'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are Playwright projects and how do you configure them for multiple browsers?',
  'playwright-projects-multiple-browsers-configuration',
  'Projects in playwright.config.ts define named test runs with different browser, device, or environment configurations. Each project can have its own use options, test directories, and dependencies.',
  $$## Playwright Projects

**Projects** let you define multiple named test configurations that run with different browsers, devices, environments, or settings — all in one command.

## Basic Multi-Browser Project Setup

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',

  projects: [
    // Desktop browsers
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
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },

    // Tablet
    {
      name: 'iPad',
      use: { ...devices['iPad Pro'] },
    },
  ],
});
```

## Projects with Different Environments

```typescript
projects: [
  // Staging tests
  {
    name: 'staging-chrome',
    use: {
      ...devices['Desktop Chrome'],
      baseURL: 'https://staging.myapp.com',
    },
    testDir: './tests',
  },

  // Production smoke tests
  {
    name: 'prod-smoke',
    use: {
      ...devices['Desktop Chrome'],
      baseURL: 'https://myapp.com',
    },
    testDir: './tests/smoke',
  },
],
```

## Projects with Auth Dependencies

```typescript
projects: [
  // Setup project — runs first, logs in
  {
    name: 'setup',
    testMatch: '**/*.setup.ts',
  },

  // Main tests — depend on setup
  {
    name: 'e2e',
    use: {
      ...devices['Desktop Chrome'],
      storageState: '.auth/user.json', // Login state from setup
    },
    dependencies: ['setup'],
  },

  // Admin tests with admin auth
  {
    name: 'admin',
    use: {
      ...devices['Desktop Chrome'],
      storageState: '.auth/admin.json',
    },
    dependencies: ['setup-admin'],
  },
],
```

## Run Specific Projects

```bash
# Run only chromium
npx playwright test --project=chromium

# Run chromium and firefox
npx playwright test --project=chromium --project=firefox

# Run all projects
npx playwright test
```

## Shared vs Per-Project Settings

```typescript
export default defineConfig({
  // Shared by all projects
  use: {
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        // Override just for chromium
        viewport: { width: 1920, height: 1080 },
      },
    },
    {
      name: 'mobile',
      use: {
        ...devices['Pixel 5'],
        // Mobile-specific overrides
      },
    },
  ],
});
```

## Available Device Descriptors

```bash
# List all available devices
npx playwright show-devices
# iPhone 12, iPad Pro, Pixel 5, Galaxy S9+, etc.
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Projects', 'Multiple Browsers', 'Cross-Browser', 'Configuration', 'Devices'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is test.step() in Playwright and why should you use it?',
  'what-is-test-step-playwright',
  'test.step() groups related actions under a named step in test reports and traces, making it easier to understand exactly where a failure occurred in complex tests.',
  $$## test.step() in Playwright

`test.step()` is a way to **group related actions** under a named step, which improves:
- Test report readability
- Trace viewer navigation
- Error messages that pinpoint where exactly the test failed

## Basic Usage

```typescript
import { test, expect } from '@playwright/test';

test('complete checkout flow', async ({ page }) => {

  await test.step('Navigate to product page', async () => {
    await page.goto('/products/laptop');
    await expect(page.getByRole('heading', { name: 'Laptop Pro' })).toBeVisible();
  });

  await test.step('Add product to cart', async () => {
    await page.getByRole('button', { name: 'Add to Cart' }).click();
    await expect(page.locator('.cart-count')).toHaveText('1');
  });

  await test.step('Proceed to checkout', async () => {
    await page.getByRole('link', { name: 'View Cart' }).click();
    await page.getByRole('button', { name: 'Checkout' }).click();
    await expect(page).toHaveURL('/checkout');
  });

  await test.step('Fill shipping details', async () => {
    await page.getByLabel('Full Name').fill('John Doe');
    await page.getByLabel('Address').fill('123 Main St');
    await page.getByLabel('City').fill('New York');
    await page.getByLabel('Zip Code').fill('10001');
  });

  await test.step('Complete payment', async () => {
    await page.getByRole('button', { name: 'Place Order' }).click();
    await expect(page).toHaveURL('/order-confirmed');
    await expect(page.getByRole('heading')).toContainText('Order Confirmed');
  });
});
```

## Steps in Reports

When this test runs, the HTML report and Trace Viewer show:
```
✓ complete checkout flow (4.2s)
  ✓ Navigate to product page (0.8s)
  ✓ Add product to cart (0.5s)
  ✓ Proceed to checkout (0.9s)
  ✓ Fill shipping details (1.2s)
  ✗ Complete payment (0.8s) ← Failure shows exactly here
```

## test.step() Returns a Value

```typescript
const orderId = await test.step('Place order and get ID', async () => {
  await page.getByRole('button', { name: 'Place Order' }).click();
  const confirmText = await page.locator('.order-id').textContent();
  return confirmText; // Return values work!
});

console.log('Order ID:', orderId);
```

## Steps in Page Objects

```typescript
// pages/CheckoutPage.ts
import { test } from '@playwright/test';

export class CheckoutPage {
  async fillShippingDetails(name: string, address: string) {
    return test.step('Fill shipping details', async () => {
      await this.nameInput.fill(name);
      await this.addressInput.fill(address);
    });
  }
}
```

## Benefits

- **Trace Viewer** shows step boundaries — click to see the exact DOM state at each step
- **HTML report** shows step-level timing and failure location
- **Error messages** include step names — "Step: Add product to cart" failed
- Makes long tests self-documenting$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'test.step', 'Test Reports', 'Debugging', 'Trace Viewer', 'Readability'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are soft assertions in Playwright?',
  'what-are-soft-assertions-playwright',
  'Soft assertions (expect.soft()) continue test execution even after a failure, collecting all assertion failures and reporting them at the end. Regular assertions stop the test immediately.',
  $$## Soft Assertions in Playwright

## The Problem Soft Assertions Solve

With **regular assertions**, the test stops immediately on the first failure:

```typescript
test('verify dashboard widgets', async ({ page }) => {
  await page.goto('/dashboard');

  await expect(page.locator('.widget-revenue')).toBeVisible();   // FAILS — stops here
  await expect(page.locator('.widget-users')).toBeVisible();     // Never runs
  await expect(page.locator('.widget-orders')).toBeVisible();    // Never runs
  await expect(page.locator('.widget-conversion')).toBeVisible(); // Never runs
});
// Only 1 failure reported — you don't know about the other 3
```

## Soft Assertions — Continue on Failure

```typescript
test('verify all dashboard widgets', async ({ page }) => {
  await page.goto('/dashboard');

  // All of these run even if earlier ones fail
  await expect.soft(page.locator('.widget-revenue')).toBeVisible();
  await expect.soft(page.locator('.widget-users')).toBeVisible();
  await expect.soft(page.locator('.widget-orders')).toBeVisible();
  await expect.soft(page.locator('.widget-conversion')).toBeVisible();
  await expect.soft(page.locator('.widget-traffic')).toBeVisible();

  // All failures collected and reported at end of test
});
// Reports: 3 soft assertions failed — widget-users, widget-orders, widget-traffic missing
```

## Mixing Soft and Hard Assertions

```typescript
test('product page verification', async ({ page }) => {
  await page.goto('/products/123');

  // Hard — test won't continue if product page doesn't load
  await expect(page).toHaveURL('/products/123');

  // Soft — collect all UI failures
  await expect.soft(page.locator('.product-title')).toBeVisible();
  await expect.soft(page.locator('.product-price')).toContainText('$');
  await expect.soft(page.locator('.product-image img')).toBeVisible();
  await expect.soft(page.locator('.add-to-cart-btn')).toBeEnabled();
  await expect.soft(page.locator('.product-reviews')).toBeVisible();

  // Hard check at the end — ensure no soft failures before continuing
  expect(test.info().errors).toHaveLength(0); // Fails if any soft assertion failed
});
```

## Use testInfo.errors to Check Soft Failures

```typescript
test('form field validation', async ({ page }, testInfo) => {
  await page.goto('/register');
  await page.getByRole('button', { name: 'Submit' }).click();

  await expect.soft(page.getByText('Email is required')).toBeVisible();
  await expect.soft(page.getByText('Password is required')).toBeVisible();
  await expect.soft(page.getByText('Name is required')).toBeVisible();

  // After collecting all failures
  if (testInfo.errors.length > 0) {
    console.log(`${testInfo.errors.length} validation messages missing`);
  }
});
```

## When to Use Soft vs Hard

| Situation | Use |
|-----------|-----|
| Critical pre-condition (must pass to continue) | Hard `expect()` |
| Checking multiple UI elements on a page | Soft `expect.soft()` |
| Smoke test across many page elements | Soft `expect.soft()` |
| Business flow (login → checkout → confirm) | Hard `expect()` |
| Visual verification of multiple items | Soft `expect.soft()` |$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Soft Assertions', 'expect.soft', 'Assertions', 'Test Reporting', 'Validation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the Playwright Inspector and Playwright UI Mode?',
  'playwright-inspector-and-ui-mode',
  'Playwright Inspector is a step-through debugger that lets you pause and step through tests. UI Mode is an interactive test runner with a GUI showing test results, traces, and source code side by side.',
  $$## Playwright Inspector

The **Playwright Inspector** is a step-through GUI debugger for Playwright tests.

### Launch Inspector

```bash
# Debug all tests
npx playwright test --debug

# Debug a specific file
npx playwright test login.spec.ts --debug

# Debug a specific test
npx playwright test -g "login with valid credentials" --debug
```

### Add a Pause in Your Test

```typescript
test('debug this', async ({ page }) => {
  await page.goto('/login');

  // Execution pauses here — Inspector opens
  await page.pause();

  await page.getByLabel('Email').fill('user@test.com');
  // ... continue debugging
});
```

### Inspector Features

- **Step Over** — execute next line
- **Continue** — run until next pause/breakpoint
- **Pick Locator** — click any element to generate its locator
- **Action Log** — list of all actions and their timing
- **Live CSS Selector input** — test locators in real time
- **Source code panel** — current line highlighted

---

## Playwright UI Mode

**UI Mode** is a fully interactive test runner with a graphical interface — great for developing and debugging tests.

### Launch UI Mode

```bash
npx playwright test --ui
```

### UI Mode Features

1. **Test tree sidebar** — all tests organized by file and describe block
2. **Run/filter controls** — run all, run selected, filter by status
3. **Live trace viewer** — DOM snapshots at each step as you watch the test
4. **Watch mode** — re-runs tests when files change
5. **Time travel** — click any action to see the DOM at that exact moment
6. **Network tab** — all HTTP requests per test
7. **Console tab** — browser console output

### Use UI Mode for Development

```bash
# Run in watch mode — tests re-run on file save
npx playwright test --ui

# From UI Mode you can:
# - Filter tests by tag: @smoke, @regression
# - Re-run failed tests only
# - Pin tests to always show at top
# - View video, screenshots, and traces inline
```

## When to Use Each

| Tool | When to Use |
|------|------------|
| **Inspector** | Step-through debugging a specific failing test |
| **UI Mode** | Developing new tests, exploring what's happening |
| **Trace Viewer** | Analyzing CI failures post-run |
| **--headed** | Quick visual check of test execution |$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Inspector', 'UI Mode', 'Debugging', 'page.pause', '--debug', '--ui'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you tag and filter tests in Playwright?',
  'how-to-tag-and-filter-tests-playwright',
  'Use @ prefix in test names or test.describe names as tags, then filter with --grep on the CLI. Playwright v1.42+ supports official test.tag() metadata for more structured tagging.',
  $$## Tagging and Filtering Tests in Playwright

## Method 1 — Tags in Test Names (Grep-friendly)

```typescript
// Add tags as @ prefix in the test name
test('user can login @smoke @critical', async ({ page }) => { /* ... */ });
test('checkout flow @regression', async ({ page }) => { /* ... */ });
test('email notification @slow @e2e', async ({ page }) => { /* ... */ });

// Tag at describe level
test.describe('@smoke User Authentication', () => {
  test('login with valid credentials', async ({ page }) => { /* ... */ });
  test('login with SSO', async ({ page }) => { /* ... */ });
});
```

Run by tag with `--grep`:

```bash
# Run only smoke tests
npx playwright test --grep @smoke

# Run smoke AND critical tests
npx playwright test --grep "@smoke|@critical"

# Run regression but NOT slow tests
npx playwright test --grep @regression --grep-invert @slow

# Run tests matching a string
npx playwright test --grep "login"
```

## Method 2 — Official Tags (Playwright v1.42+)

```typescript
import { test } from '@playwright/test';

test('login test', {
  tag: ['@smoke', '@critical'],
}, async ({ page }) => {
  await page.goto('/login');
  // ...
});

test.describe('Checkout', {
  tag: ['@e2e', '@regression'],
}, () => {
  test('complete purchase', async ({ page }) => { /* ... */ });
});
```

```bash
# Run by official tags
npx playwright test --grep @smoke
```

## Method 3 — Annotations

```typescript
test('payment test', async ({ page }) => {
  test.info().annotations.push({ type: 'category', description: 'payment' });
  // ...
});
```

## Combining Tags with Projects

```bash
# Run smoke tests on Chrome only
npx playwright test --project=chromium --grep @smoke

# Run regression on all browsers
npx playwright test --grep @regression
```

## Skip Tests by Tag

```typescript
// Skip if tag matches
test.skip(({ browserName }) => browserName === 'webkit', 'Safari not supported');

// Skip specific test
test('safari-only feature @skip-chrome', async ({ page, browserName }) => {
  test.skip(browserName !== 'webkit', 'Only runs on Safari');
});
```

## Practical Test Suite Organization

```typescript
// login.spec.ts
test('homepage loads @smoke', async ({ page }) => { /* ... */ });
test('login works @smoke @auth', async ({ page }) => { /* ... */ });
test('token refresh @regression @auth', async ({ page }) => { /* ... */ });
test('session timeout @regression @e2e @slow', async ({ page }) => { /* ... */ });
```

```bash
# CI — fast smoke suite
npx playwright test --grep @smoke --workers=8

# Nightly — full regression
npx playwright test --grep @regression
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Tags', 'grep', 'Filter Tests', 'Smoke Tests', 'Regression', 'Test Organization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you implement data-driven testing in Playwright?',
  'how-to-implement-data-driven-testing-playwright',
  'Use a loop with test() inside, or pass a parameterized array to test.each(). For external data, read from CSV or JSON files and generate test cases dynamically.',
  $$## Data-Driven Testing in Playwright

## Method 1 — test.each() (Parameterized Tests)

```typescript
import { test, expect } from '@playwright/test';

// Array of test cases
const loginCases = [
  { email: 'user@test.com',  password: 'pass123',   expected: '/dashboard', desc: 'valid user' },
  { email: 'admin@test.com', password: 'admin123',  expected: '/admin',     desc: 'admin user' },
  { email: 'wrong@test.com', password: 'wrongpass', expected: '/login',     desc: 'invalid user' },
];

for (const { email, password, expected, desc } of loginCases) {
  test(`login: ${desc}`, async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel('Email').fill(email);
    await page.getByLabel('Password').fill(password);
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page).toHaveURL(expected);
  });
}
```

## Method 2 — Dynamic Test from JSON File

```typescript
// test-data/users.json
// [{"role":"admin","email":"admin@t.com","password":"admin123"},...]

import userData from '../test-data/users.json';

for (const user of userData) {
  test(`login as ${user.role}`, async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel('Email').fill(user.email);
    await page.getByLabel('Password').fill(user.password);
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page).toHaveURL(`/${user.role}`);
  });
}
```

## Method 3 — CSV Data

```typescript
import * as fs from 'fs';
import * as path from 'path';

function readCSV(filePath: string): Record<string, string>[] {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.trim().split('\n');
  const headers = lines[0].split(',');
  return lines.slice(1).map(line => {
    const values = line.split(',');
    return Object.fromEntries(headers.map((h, i) => [h.trim(), values[i]?.trim()]));
  });
}

const testData = readCSV(path.join(__dirname, '../test-data/products.csv'));

for (const row of testData) {
  test(`search for ${row.productName}`, async ({ page }) => {
    await page.goto('/');
    await page.getByRole('searchbox').fill(row.productName);
    await page.getByRole('button', { name: 'Search' }).click();
    await expect(page.locator('.result-count')).toContainText(`${row.expectedCount} results`);
  });
}
```

## Method 4 — Form Validation Data-Driven

```typescript
const formErrors = [
  { field: 'email',    value: '',              error: 'Email is required' },
  { field: 'email',    value: 'not-an-email',  error: 'Invalid email format' },
  { field: 'password', value: '123',           error: 'Password too short' },
  { field: 'phone',    value: 'abc',           error: 'Invalid phone number' },
];

for (const { field, value, error } of formErrors) {
  test(`form validation: ${field} - ${error}`, async ({ page }) => {
    await page.goto('/register');
    await page.getByLabel(field).fill(value);
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText(error)).toBeVisible();
  });
}
```

## Using Environment-Specific Data

```typescript
// test-data/credentials.ts
export const credentials = {
  staging: { email: 'test@staging.com', password: 'staging123' },
  prod:    { email: 'test@prod.com',    password: 'prod456' },
};

// In test
const env = process.env.TEST_ENV || 'staging';
const creds = credentials[env as 'staging' | 'prod'];
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Data-Driven Testing', 'test.each', 'Parameterized', 'JSON', 'CSV', 'DDT'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between page.waitForResponse() and page.waitForRequest() in Playwright?',
  'difference-between-waitforresponse-waitforrequest-playwright',
  'waitForRequest() intercepts an outgoing HTTP request; waitForResponse() waits for a response to arrive. Both return a Promise that resolves when a matching network event occurs.',
  $$## waitForRequest() vs waitForResponse()

Both methods let you capture and verify network activity that happens during a test.

## page.waitForRequest()

Waits for an **outgoing** HTTP request matching a URL pattern.

```typescript
// Wait for a specific API call to be made
const requestPromise = page.waitForRequest('/api/login');

// Trigger the action
await page.getByRole('button', { name: 'Sign in' }).click();

// Get the request when it fires
const request = await requestPromise;

console.log(request.method());    // 'POST'
console.log(request.url());       // 'https://myapp.com/api/login'
console.log(request.postData());  // '{"email":"user@test.com","password":"..."}'
const body = JSON.parse(request.postData()!);
expect(body.email).toBe('user@test.com');
```

## page.waitForResponse()

Waits for an **incoming** HTTP response matching a URL pattern.

```typescript
// Wait for the API response to return
const responsePromise = page.waitForResponse('/api/products');

await page.goto('/products');

// Get the response when it arrives
const response = await responsePromise;

console.log(response.status()); // 200
console.log(response.url());    // 'https://myapp.com/api/products'
const data = await response.json(); // Parse response body
expect(data.length).toBeGreaterThan(0);
```

## Using Promise.all() Pattern (Correct Usage)

```typescript
// IMPORTANT: Register the wait BEFORE the triggering action

// Correct — wait and action happen concurrently
const [response] = await Promise.all([
  page.waitForResponse('/api/checkout'),
  page.getByRole('button', { name: 'Place Order' }).click(),
]);

console.log(response.status()); // 200
const order = await response.json();
expect(order.orderId).toBeTruthy();
```

## URL Pattern Matching

```typescript
// Exact URL
page.waitForResponse('https://api.example.com/users');

// Glob pattern
page.waitForResponse('**/api/users**');

// Regex
page.waitForResponse(/\/api\/users\/\d+/);

// Custom predicate
page.waitForResponse(response =>
  response.url().includes('/api/') && response.status() === 200
);
```

## Practical Use Cases

```typescript
// Verify API is called with correct payload
test('checkout sends correct data', async ({ page }) => {
  await page.goto('/cart');

  const [request] = await Promise.all([
    page.waitForRequest(req =>
      req.url().includes('/api/checkout') && req.method() === 'POST'
    ),
    page.getByRole('button', { name: 'Checkout' }).click(),
  ]);

  const body = JSON.parse(request.postData()!);
  expect(body.cartItems).toHaveLength(2);
  expect(body.total).toBeGreaterThan(0);
});

// Verify response data matches UI
test('products API matches displayed count', async ({ page }) => {
  const [response] = await Promise.all([
    page.waitForResponse('**/api/products'),
    page.goto('/products'),
  ]);

  const products = await response.json();
  await expect(page.locator('.product-card')).toHaveCount(products.length);
});
```

## Summary

| | `waitForRequest()` | `waitForResponse()` |
|--|-------------------|---------------------|
| Captures | Outgoing request | Incoming response |
| Access | Method, URL, body | Status, URL, body |
| Use for | Verifying request payload | Verifying API response data |$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'waitForResponse', 'waitForRequest', 'Network', 'API Verification', 'HTTP'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle drag and drop in Playwright?',
  'how-to-handle-drag-and-drop-playwright',
  'Use locator.dragTo() for simple drag-and-drop between elements. For complex dragging with precise positions, use mouse event sequence with page.mouse.move() and page.mouse.down/up().',
  $$## Drag and Drop in Playwright

## Method 1 — locator.dragTo() (Simplest)

```typescript
// Drag source element onto target element
await page.locator('#draggable-item').dragTo(page.locator('#drop-zone'));

// Drag a card to a different column (Kanban board)
await page.locator('.card[data-id="task-1"]').dragTo(
  page.locator('.column[data-status="done"]')
);
```

## Method 2 — dragTo with Options

```typescript
await page.locator('#source').dragTo(page.locator('#target'), {
  sourcePosition: { x: 10, y: 10 }, // Start from this offset within source
  targetPosition: { x: 50, y: 20 }, // Drop at this offset within target
  force: true, // Bypass actionability checks
});
```

## Method 3 — Manual Mouse Events (For Complex UI)

```typescript
// More control over the drag path
const source = page.locator('#item-to-drag');
const target = page.locator('#drop-target');

// Get bounding boxes
const sourceBox = await source.boundingBox();
const targetBox = await target.boundingBox();

if (sourceBox && targetBox) {
  // Move to source center
  await page.mouse.move(
    sourceBox.x + sourceBox.width / 2,
    sourceBox.y + sourceBox.height / 2
  );
  await page.mouse.down();

  // Slowly drag to target (important for smooth DnD libraries)
  await page.mouse.move(
    targetBox.x + targetBox.width / 2,
    targetBox.y + targetBox.height / 2,
    { steps: 10 } // Move in 10 steps for smooth animation
  );

  await page.mouse.up();
}
```

## Method 4 — DataTransfer via evaluate() (HTML5 DnD)

```typescript
// For HTML5 drag events
await page.locator('#source').dispatchEvent('dragstart');
await page.locator('#target').dispatchEvent('drop');
await page.locator('#source').dispatchEvent('dragend');
```

## Full Example — Kanban Board

```typescript
import { test, expect } from '@playwright/test';

test('drag task from Todo to Done', async ({ page }) => {
  await page.goto('/kanban');

  const task = page.locator('.task-card').filter({ hasText: 'Write tests' });
  const doneColumn = page.locator('.kanban-column[data-status="done"]');

  // Verify initial state
  await expect(task).toBeVisible();

  // Drag the task to Done column
  await task.dragTo(doneColumn);

  // Verify task moved to Done column
  await expect(doneColumn.locator('.task-card').filter({ hasText: 'Write tests' }))
    .toBeVisible();
});
```

## Sortable List Example

```typescript
test('reorder list items via drag', async ({ page }) => {
  await page.goto('/sortable-list');

  const firstItem  = page.locator('.sortable-item').nth(0);
  const thirdItem  = page.locator('.sortable-item').nth(2);

  // Move first item to third position
  await firstItem.dragTo(thirdItem);

  // Verify new order
  await expect(page.locator('.sortable-item').nth(0)).toHaveText('Item 2');
});
```$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Drag and Drop', 'dragTo', 'Mouse Events', 'DnD', 'Kanban'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you use environment variables in Playwright tests?',
  'how-to-use-environment-variables-playwright',
  'Set env vars in .env files, read with process.env in playwright.config.ts or tests, and use dotenv or the env option in the config to load them.',
  $$## Environment Variables in Playwright

## Method 1 — .env File with dotenv

```bash
# .env.local (for local development)
BASE_URL=https://staging.myapp.com
TEST_USERNAME=testuser@myapp.com
TEST_PASSWORD=StrongPassword123
API_KEY=test-api-key-abc
```

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';
import dotenv from 'dotenv';
import path from 'path';

// Load environment variables
dotenv.config({ path: path.join(__dirname, '.env.local') });

export default defineConfig({
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
  },
});
```

## Method 2 — Using Playwright's env Option

```typescript
// playwright.config.ts
export default defineConfig({
  // Playwright reads .env automatically in v1.20+
  use: {
    baseURL: process.env.BASE_URL,
  },
});
```

## Method 3 — Multiple Environment Files

```typescript
// playwright.config.ts
const ENV = process.env.TEST_ENV || 'staging';
dotenv.config({ path: `.env.${ENV}` });

// .env.staging
// BASE_URL=https://staging.myapp.com

// .env.production
// BASE_URL=https://myapp.com
```

Run for different environments:
```bash
TEST_ENV=staging npx playwright test
TEST_ENV=production npx playwright test --grep @smoke
```

## Using Env Vars in Tests

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';

test('login with env credentials', async ({ page }) => {
  await page.goto('/login');

  await page.getByLabel('Email').fill(process.env.TEST_USERNAME!);
  await page.getByLabel('Password').fill(process.env.TEST_PASSWORD!);
  await page.getByRole('button', { name: 'Sign in' }).click();

  await expect(page).toHaveURL('/dashboard');
});
```

## Centralized Config Helper

```typescript
// helpers/config.ts
export const config = {
  baseUrl:      process.env.BASE_URL      || 'http://localhost:3000',
  testEmail:    process.env.TEST_EMAIL    || 'test@example.com',
  testPassword: process.env.TEST_PASSWORD || 'password',
  apiKey:       process.env.API_KEY       || '',
  adminEmail:   process.env.ADMIN_EMAIL   || 'admin@example.com',
};

// Usage in test
import { config } from '../helpers/config';
await page.getByLabel('Email').fill(config.testEmail);
```

## CI/CD Environment Variables

```yaml
# .github/workflows/playwright.yml
env:
  BASE_URL: ${{ secrets.STAGING_URL }}
  TEST_USERNAME: ${{ secrets.TEST_USER }}
  TEST_PASSWORD: ${{ secrets.TEST_PASS }}
```

> **Security Note:** Never hardcode credentials in test files. Always use environment variables for sensitive data. Add `.env.local` to `.gitignore`.$$,
  'Playwright', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Environment Variables', 'dotenv', '.env', 'CI/CD', 'Configuration', 'Security'], true, 0
);
