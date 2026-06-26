-- Playwright Scenario-Based Interview Questions (Q71–Q90 / S1–S20)
-- Technology: Playwright | Difficulty: Mixed | Experience: 3-5 Years / 5+ Years
-- Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Your Playwright test is intermittently failing (flaky). Walk me through how you would debug and fix it.',
  'playwright-scenario-debug-flaky-test',
  'Enable traces on first retry, use UI mode to replay the failure, identify root cause (race conditions, shared state, unstable locators), and apply targeted fixes.',
  $$## Scenario: Debugging a Flaky Playwright Test

This is one of the most common real-world QA challenges. Here is a systematic approach.

## Step 1 — Enable Trace on First Retry

```typescript
// playwright.config.ts
export default defineConfig({
  retries: 2,
  use: {
    trace: 'on-first-retry',       // Capture trace when flakiness occurs
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
});
```

Now when the test fails and retries, you get a full trace.

## Step 2 — Reproduce Locally

```bash
# Run the test 10 times to reproduce the flakiness
for i in {1..10}; do npx playwright test flaky.spec.ts; done

# OR use UI mode to watch it fail
npx playwright test flaky.spec.ts --ui
```

## Step 3 — Analyze the Trace

```bash
npx playwright show-report
# Click on the failed test → open Trace
```

Look at:
- **Which step failed** (the red step in the timeline)
- **DOM at that moment** (did the element exist? Was it visible?)
- **Network tab** (was an API call slow or failing?)
- **Console tab** (JavaScript errors?)
- **Timing** (was there an animation or transition?)

## Step 4 — Common Causes and Fixes

### Cause A — Hard-coded Timeout

```typescript
// BAD
await page.waitForTimeout(2000);
await page.click('#submit');

// GOOD — wait for actual state
await page.locator('#submit').waitFor({ state: 'visible' });
await page.locator('#submit').click();
```

### Cause B — Strict Mode: Multiple Elements Match

```typescript
// BAD — fails if page has more than one '.btn'
await page.locator('.btn').click();
// Error: "strict mode violation: locator('.btn') resolved to 3 elements"

// GOOD — be specific
await page.locator('.modal .btn.primary').click();
await page.getByRole('button', { name: 'Submit' }).click();
```

### Cause C — Race Condition (No Wait for Network)

```typescript
// BAD — clicks before dynamic content loads
await page.goto('/products');
await page.locator('.product-card').first().click();
// Cards may not have loaded yet!

// GOOD — wait for dynamic content
await page.goto('/products');
await page.locator('.product-card').first().waitFor();
await page.locator('.product-card').first().click();
```

### Cause D — Shared Test Data (Tests Not Isolated)

```typescript
// BAD — test B assumes test A created this user
// If tests run in different order, it fails

// GOOD — each test creates its own independent data
test('edit user', async ({ request, page }) => {
  const res = await request.post('/api/users', {
    data: { email: `user-${Date.now()}@test.com` }
  });
  const { id } = await res.json();

  await page.goto(`/users/${id}/edit`);
  // Now test is fully self-contained
});
```

### Cause E — Animation Interference

```typescript
// Button slides in with CSS animation — not immediately clickable
await page.locator('.animated-cta').waitFor({ state: 'visible' });
// Still fails because it's mid-animation

// Fix: disable animations globally or wait for stable
await page.addStyleTag({ content: '* { animation: none !important; transition: none !important; }' });
```

## Step 5 — Verify the Fix

```bash
# Run 20 times to confirm it's no longer flaky
for i in {1..20}; do npx playwright test fixed.spec.ts --retries=0; done
```

Zero failures = flakiness resolved.$$,
  'Playwright', 'Scenario-Based', '3-5 Years', 'Intermediate',
  ARRAY['Playwright', 'Flaky Tests', 'Debugging', 'Scenario', 'Trace Viewer', 'Race Conditions', 'Real-world'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you handle a login flow that requires OTP or 2FA verification in Playwright?',
  'playwright-scenario-otp-2fa-login',
  'Mock the OTP endpoint to return a predictable code, pre-seed the OTP in the test database, or use a TOTP library to generate a real time-based code — depending on how 2FA is implemented.',
  $$## Scenario: Testing Login with OTP / 2FA

## Approach 1 — Mock the OTP API (Most Common for E2E)

```typescript
import { test, expect } from '@playwright/test';

test('login with OTP via API mock', async ({ page }) => {
  // Intercept the OTP generation endpoint and return a fixed code
  await page.route('/api/auth/send-otp', route =>
    route.fulfill({
      status: 200,
      json: { message: 'OTP sent', expiresIn: 300 },
    })
  );

  // Intercept OTP verification
  await page.route('/api/auth/verify-otp', async route => {
    const body = JSON.parse(route.request().postData()!);
    if (body.otp === '123456') {
      await route.fulfill({ status: 200, json: { token: 'test-jwt-token' } });
    } else {
      await route.fulfill({ status: 400, json: { error: 'Invalid OTP' } });
    }
  });

  // Perform login
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign in' }).click();

  // OTP screen appears
  await expect(page.getByText('Enter the 6-digit code')).toBeVisible();

  // Enter the mocked OTP
  await page.getByLabel('OTP Code').fill('123456');
  await page.getByRole('button', { name: 'Verify' }).click();

  await expect(page).toHaveURL('/dashboard');
});
```

## Approach 2 — Read OTP from Test Database (Integration Test)

```typescript
test('login with real OTP from database', async ({ page, request }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign in' }).click();

  // Wait for OTP to be generated in database
  await page.waitForURL('**/verify-otp');

  // Fetch the OTP from test API (only available in test/staging env)
  const otpResponse = await request.get('/test-utils/latest-otp?email=user@test.com');
  const { otp } = await otpResponse.json();

  await page.getByLabel('OTP Code').fill(otp);
  await page.getByRole('button', { name: 'Verify' }).click();

  await expect(page).toHaveURL('/dashboard');
});
```

## Approach 3 — TOTP (Time-Based OTP like Google Authenticator)

```bash
npm install otpauth
```

```typescript
import { test, expect } from '@playwright/test';
import * as OTPAuth from 'otpauth';

test('login with TOTP', async ({ page }) => {
  // Create TOTP generator matching the test account's secret
  const totp = new OTPAuth.TOTP({
    secret: process.env.TEST_TOTP_SECRET!, // stored in CI secrets
    algorithm: 'SHA1',
    digits: 6,
    period: 30,
  });

  await page.goto('/login');
  await page.getByLabel('Email').fill('user@test.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign in' }).click();

  await page.waitForURL('**/2fa');

  // Generate the current TOTP code
  const code = totp.generate();
  await page.getByLabel('Authenticator Code').fill(code);
  await page.getByRole('button', { name: 'Verify' }).click();

  await expect(page).toHaveURL('/dashboard');
});
```

## Approach 4 — Bypass 2FA Entirely (Preferred for Unit/Regression Tests)

```typescript
// Use storageState with a pre-authenticated session that has 2FA already satisfied
setup('create 2fa session', async ({ page }) => {
  // Programmatically create a session token that has 2FA verified
  // (via backend API endpoint only available in test environment)
  const res = await fetch('/test-utils/create-session', {
    method: 'POST',
    body: JSON.stringify({ email: 'user@test.com', skip2fa: true }),
  });
  const { sessionCookie } = await res.json();

  const context = page.context();
  await context.addCookies([{ name: 'session', value: sessionCookie, domain: 'localhost', path: '/' }]);
  await page.context().storageState({ path: '.auth/user-2fa.json' });
});
```$$,
  'Playwright', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Playwright', '2FA', 'OTP', 'Authentication', 'Mock API', 'TOTP', 'Scenario', 'Real-world'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you test a multi-step checkout flow in Playwright ensuring each step is validated?',
  'playwright-scenario-multi-step-checkout-flow',
  'Structure the test using test.step() for each checkout stage, use POM for each step page, validate state at each transition, and use API setup for test data to avoid UI-heavy setup.',
  $$## Scenario: Multi-Step Checkout Flow Testing

## Test Plan for Checkout Flow

1. Select product and add to cart
2. Proceed to cart and verify items
3. Enter shipping details
4. Enter payment details
5. Place order and verify confirmation

## Implementation with test.step() and POM

```typescript
import { test, expect } from '@playwright/test';
import { ProductPage }  from '../pages/ProductPage';
import { CartPage }     from '../pages/CartPage';
import { CheckoutPage } from '../pages/CheckoutPage';

test('complete checkout flow', async ({ page, request }) => {
  const productPage  = new ProductPage(page);
  const cartPage     = new CartPage(page);
  const checkoutPage = new CheckoutPage(page);

  // Step 1: API Setup — create test product inventory
  const productId = await test.step('Setup: Create test product via API', async () => {
    const res = await request.post('/api/products', {
      data: { name: 'Test Laptop', price: 999, stock: 10 },
      headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
    });
    return (await res.json()).id;
  });

  // Step 2: Add to Cart
  await test.step('Add product to cart', async () => {
    await productPage.navigate(productId);
    await expect(productPage.title).toHaveText('Test Laptop');
    await expect(productPage.price).toHaveText('$999.00');
    await productPage.addToCart(1);
    await expect(page.locator('.cart-count')).toHaveText('1');
  });

  // Step 3: Review Cart
  await test.step('Review cart and verify items', async () => {
    await cartPage.navigate();
    await expect(cartPage.items).toHaveCount(1);
    await expect(cartPage.itemName.first()).toHaveText('Test Laptop');
    await expect(cartPage.subtotal).toHaveText('$999.00');
  });

  // Step 4: Shipping Details
  await test.step('Fill shipping details', async () => {
    await cartPage.proceedToCheckout();
    await expect(page).toHaveURL('/checkout/shipping');

    await checkoutPage.fillShipping({
      fullName: 'John Doe',
      address:  '123 Main Street',
      city:     'New York',
      state:    'NY',
      zip:      '10001',
      country:  'US',
    });

    // Validate address fields before proceeding
    await expect(page.getByLabel('Full Name')).toHaveValue('John Doe');
    await checkoutPage.continueToPayment();
    await expect(page).toHaveURL('/checkout/payment');
  });

  // Step 5: Payment Details
  await test.step('Enter payment details', async () => {
    const cardFrame = page.frameLocator('iframe[src*="stripe"]');
    await cardFrame.getByPlaceholder('Card number').fill('4242424242424242');
    await cardFrame.getByPlaceholder('MM / YY').fill('12/25');
    await cardFrame.getByPlaceholder('CVC').fill('123');

    await expect(page.locator('.order-summary .total')).toHaveText('$999.00');
  });

  // Step 6: Place Order
  const orderId = await test.step('Place order and confirm', async () => {
    await page.getByRole('button', { name: 'Place Order' }).click();
    await expect(page).toHaveURL(/\/order-confirmed/);

    await expect(page.getByRole('heading')).toContainText('Order Confirmed!');
    await expect(page.locator('.order-number')).toBeVisible();

    return await page.locator('.order-number').textContent();
  });

  // Step 7: Verify via API
  await test.step('Verify order in backend', async () => {
    const orderRes = await request.get(`/api/orders?number=${orderId}`, {
      headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
    });
    const order = await orderRes.json();
    expect(order.status).toBe('confirmed');
    expect(order.total).toBe(999);
    expect(order.items[0].productId).toBe(productId);
  });
});
```

## Checkout POM Example

```typescript
// pages/CheckoutPage.ts
export class CheckoutPage {
  constructor(private page: Page) {}

  async fillShipping(details: {
    fullName: string; address: string; city: string;
    state: string; zip: string; country: string;
  }) {
    await this.page.getByLabel('Full Name').fill(details.fullName);
    await this.page.getByLabel('Address').fill(details.address);
    await this.page.getByLabel('City').fill(details.city);
    await this.page.getByLabel('State').selectOption(details.state);
    await this.page.getByLabel('ZIP').fill(details.zip);
  }

  async continueToPayment() {
    await this.page.getByRole('button', { name: 'Continue to Payment' }).click();
  }
}
```$$,
  'Playwright', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Checkout Flow', 'E2E Testing', 'test.step', 'POM', 'Multi-step', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'A custom React dropdown is built with divs, not a native <select>. How do you handle it in Playwright?',
  'playwright-scenario-custom-react-dropdown',
  'Click the dropdown trigger to open it, wait for the options list to appear, then click the desired option using getByRole("option") or getByText(). Use locator chaining to scope within the dropdown container.',
  $$## Scenario: Handling a Custom React Dropdown

Modern React apps use custom dropdown components built with `<div>`, `<ul>`, `<li>` elements — not native `<select>`. These need a different approach.

## Inspect the HTML Structure First

```html
<!-- Typical custom dropdown HTML -->
<div class="dropdown" aria-expanded="false">
  <button class="dropdown-trigger" aria-haspopup="listbox">
    Select Country
  </button>
  <ul class="dropdown-list" role="listbox" hidden>
    <li role="option" data-value="US">United States</li>
    <li role="option" data-value="UK">United Kingdom</li>
    <li role="option" data-value="IN">India</li>
  </ul>
</div>
```

## Strategy 1 — Click Trigger, Then Click Option (Most Common)

```typescript
test('select from custom dropdown', async ({ page }) => {
  await page.goto('/register');

  // Step 1: Click the dropdown trigger to open it
  await page.getByRole('combobox', { name: 'Select Country' }).click();
  // OR
  await page.locator('.dropdown-trigger').click();

  // Step 2: Wait for options to appear
  await expect(page.getByRole('listbox')).toBeVisible();

  // Step 3: Click the desired option
  await page.getByRole('option', { name: 'United States' }).click();

  // Step 4: Verify selection
  await expect(page.getByRole('combobox')).toHaveText('United States');
});
```

## Strategy 2 — Scope to the Dropdown Container

```typescript
test('scoped dropdown selection', async ({ page }) => {
  // Get the specific dropdown container (important if multiple dropdowns on page)
  const countryDropdown = page.locator('[data-testid="country-select"]');

  // Open it
  await countryDropdown.click();

  // Select within the dropdown context
  await countryDropdown.getByText('India').click();

  await expect(countryDropdown).toContainText('India');
});
```

## Strategy 3 — Material UI / Ant Design / React Select

```typescript
// React Select (most popular)
test('React Select dropdown', async ({ page }) => {
  // The input inside React Select
  const selectInput = page.locator('.react-select__control');
  await selectInput.click();

  // Type to filter options
  await page.locator('.react-select__input input').fill('India');

  // Click the filtered option
  await page.locator('.react-select__option').filter({ hasText: 'India' }).click();

  // Verify
  await expect(page.locator('.react-select__single-value')).toHaveText('India');
});

// Ant Design Select
test('Ant Design Select', async ({ page }) => {
  await page.locator('.ant-select-selector').click();
  await page.locator('.ant-select-item-option').filter({ hasText: 'India' }).click();
  await expect(page.locator('.ant-select-selection-item')).toHaveText('India');
});

// MUI Select
test('Material UI Select', async ({ page }) => {
  await page.locator('#country-select').click();
  await page.getByRole('option', { name: 'India' }).click();
  await expect(page.locator('#country-select')).toHaveText('India');
});
```

## Strategy 4 — Search/Autocomplete Dropdowns

```typescript
test('autocomplete dropdown', async ({ page }) => {
  const input = page.getByPlaceholder('Search city...');

  // Type to trigger suggestions
  await input.fill('New Y');

  // Wait for suggestions to appear
  await expect(page.locator('.suggestions-dropdown')).toBeVisible();

  // Click desired suggestion
  await page.locator('.suggestion-item').filter({ hasText: 'New York' }).click();

  // Verify input shows selected value
  await expect(input).toHaveValue('New York');
});
```

## Tips for Handling Custom Dropdowns

1. **Always check ARIA attributes** — `role="listbox"`, `role="option"`, `aria-expanded`
2. **Use `getByRole('option')`** for semantically correct selections
3. **Scope locators** to the dropdown container when multiple exist
4. **Wait for options** to appear before clicking
5. **Check `data-testid` attributes** — often the most stable selector$$,
  'Playwright', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Custom Dropdown', 'React Select', 'MUI', 'Ant Design', 'Scenario', 'Real-world'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'You have 500+ Playwright tests taking 45 minutes. How do you optimize to under 10 minutes?',
  'playwright-scenario-optimize-slow-test-suite',
  'Combine sharding (8 CI machines), parallel workers (4 per machine), storageState for auth reuse, API setup instead of UI flows, and blocking unnecessary network requests.',
  $$## Scenario: Optimizing 500 Tests from 45 Minutes to Under 10 Minutes

## Current State Analysis

```
500 tests × 5.4 seconds avg = 45 minutes
Running sequentially (1 worker, no sharding)
Login UI for every test: 500 × 5s = 41 minutes wasted
Images/analytics loaded: adds 1-2s per navigation
```

## Optimization Plan — Targeting <10 Minutes

### Step 1: Enable Parallel Workers (Free 4x Speedup)

```typescript
// playwright.config.ts
export default defineConfig({
  fullyParallel: true,
  workers: 8,  // 8 parallel browsers
});
```

```
500 tests / 8 workers = 62.5 tests per worker
62.5 × 5.4s = ~5.6 minutes
```

### Step 2: storageState Auth Reuse (Eliminate Login Cost)

```typescript
// Login ONCE per test run — not 500 times
projects: [
  { name: 'setup', testMatch: '*.setup.ts' },
  {
    name: 'e2e',
    use: {
      storageState: '.auth/user.json',   // Already logged in
    },
    dependencies: ['setup'],
  },
],
```

```
Before: 500 tests × 5s login = 41 minutes just on logins
After:  1 login = 5 seconds total
Savings: 40+ minutes
```

### Step 3: Shard Across 8 CI Machines

```yaml
# GitHub Actions matrix
strategy:
  matrix:
    shardIndex: [1, 2, 3, 4, 5, 6, 7, 8]
    shardTotal: [8]

steps:
  - run: npx playwright test --shard=${{ matrix.shardIndex }}/${{ matrix.shardTotal }}
```

```
8 machines × 8 workers = 64 tests simultaneously
500 / 64 = ~8 tests per worker batch
8 × avg_duration ≈ target
```

### Step 4: API Setup Instead of UI Flows

```typescript
// BAD — UI-based test data setup: 5-8 seconds
test.beforeEach(async ({ page }) => {
  await page.goto('/products/new');
  await page.fill('#name', 'Test Product');
  await page.click('#save'); // 8s total
});

// GOOD — API setup: 200ms
test.beforeEach(async ({ request }) => {
  await request.post('/api/products', {
    data: { name: `Product-${Date.now()}` },
    headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
  }); // 200ms total
});
```

### Step 5: Block Unnecessary Assets

```typescript
// playwright.config.ts
use: {
  launchOptions: {
    args: ['--disable-extensions', '--no-sandbox'],
  },
},

// In fixture or beforeEach
await page.route('**/*.{png,jpg,jpeg,gif,svg,woff,woff2}', r => r.abort());
await page.route('**/google-analytics.com/**', r => r.abort());
await page.route('**/hotjar.com/**', r => r.abort());
```

Reduces each page load from 3s → 1.5s for asset-heavy pages.

### Step 6: Use domcontentloaded Instead of networkidle

```typescript
// BAD — waits for all network activity
await page.goto('/products', { waitUntil: 'networkidle' }); // 3-5s

// GOOD — wait for DOM ready, then for specific element
await page.goto('/products', { waitUntil: 'domcontentloaded' });
await page.locator('.product-list').waitFor(); // Specific wait
```

## Results After All Optimizations

| Optimization | Time Saved |
|-------------|-----------|
| 8 workers (parallel) | 45m → 6m |
| 8-way sharding | 6m → 45s |
| storageState auth | 41m saved total |
| API setup | 2-4s per test |
| Block assets | 20-40% per navigation |

**Combined result: 500 tests in ~6-8 minutes on CI**$$,
  'Playwright', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Performance Optimization', 'Sharding', 'Parallel Testing', 'storageState', 'CI/CD', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you mock a failed API response to test error handling in your application?',
  'playwright-scenario-mock-failed-api-response',
  'Use page.route() to intercept the API call and return a 500, 404, or network failure response. Verify the UI correctly shows error messages, retry buttons, and fallback states.',
  $$## Scenario: Testing Error Handling via Mocked API Failures

One of the most valuable uses of Playwright's network interception is testing how your app handles API errors — without needing a broken backend.

## Mock a 500 Internal Server Error

```typescript
import { test, expect } from '@playwright/test';

test('shows error toast when product API fails', async ({ page }) => {
  // Return 500 error for the products endpoint
  await page.route('/api/products', route =>
    route.fulfill({
      status: 500,
      contentType: 'application/json',
      body: JSON.stringify({
        error: 'Internal Server Error',
        message: 'Database connection failed',
      }),
    })
  );

  await page.goto('/products');

  // Verify error state in UI
  await expect(page.locator('.error-toast')).toBeVisible();
  await expect(page.locator('.error-toast')).toContainText('Something went wrong');
  await expect(page.locator('.product-list')).not.toBeVisible();
  await expect(page.getByRole('button', { name: 'Retry' })).toBeVisible();
});
```

## Mock a 404 Not Found

```typescript
test('shows not found page for invalid product', async ({ page }) => {
  await page.route('/api/products/99999', route =>
    route.fulfill({
      status: 404,
      json: { error: 'Product not found' },
    })
  );

  await page.goto('/products/99999');
  await expect(page.getByRole('heading')).toContainText('Product Not Found');
  await expect(page.getByRole('link', { name: 'Back to Products' })).toBeVisible();
});
```

## Mock a 401 Unauthorized

```typescript
test('redirects to login on 401 response', async ({ page }) => {
  // Simulate expired session
  await page.route('/api/user/profile', route =>
    route.fulfill({
      status: 401,
      json: { error: 'Session expired. Please log in again.' },
    })
  );

  await page.goto('/profile');

  // App should redirect to login
  await expect(page).toHaveURL('/login');
  await expect(page.locator('.session-message')).toContainText('Session expired');
});
```

## Mock Network Failure (No Connection)

```typescript
test('shows offline message when network fails', async ({ page }) => {
  // Simulate complete network failure
  await page.route('/api/**', route => route.abort('failed'));

  await page.goto('/dashboard');
  await expect(page.locator('.offline-banner')).toBeVisible();
  await expect(page.locator('.offline-banner')).toContainText('Check your connection');
});
```

## Mock Slow Response (Loading State)

```typescript
test('shows loading skeleton during slow API', async ({ page }) => {
  let resolveDelay: () => void;

  await page.route('/api/products', route =>
    new Promise(resolve => {
      resolveDelay = resolve;
      // Keep the route "pending" for 3 seconds
      setTimeout(() => {
        resolve(undefined);
        route.fulfill({ json: { products: [] } });
      }, 3000);
    })
  );

  await page.goto('/products');

  // Verify loading skeleton shows during the delay
  await expect(page.locator('.skeleton-loader')).toBeVisible();
  await expect(page.locator('.product-list')).not.toBeVisible();

  // After 3s, data loads
  await expect(page.locator('.product-list')).toBeVisible({ timeout: 5000 });
  await expect(page.locator('.skeleton-loader')).not.toBeVisible();
});
```

## Test Retry Mechanism

```typescript
test('retry button fetches data again after error', async ({ page }) => {
  let callCount = 0;

  await page.route('/api/products', async route => {
    callCount++;
    if (callCount === 1) {
      // First call fails
      await route.fulfill({ status: 500, json: { error: 'Error' } });
    } else {
      // Second call succeeds (after user clicks retry)
      await route.fulfill({ status: 200, json: [{ id: 1, name: 'Laptop' }] });
    }
  });

  await page.goto('/products');
  await expect(page.locator('.error-message')).toBeVisible();

  // Click retry
  await page.getByRole('button', { name: 'Retry' }).click();

  // Data loads successfully on second attempt
  await expect(page.locator('.product-card')).toBeVisible();
  expect(callCount).toBe(2);
});
```$$,
  'Playwright', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Mock API', 'Error Handling', 'page.route', '500 Error', 'Network Failure', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you structure a Playwright test framework for a team of 10 developers?',
  'playwright-scenario-framework-structure-team',
  'Use a layered architecture: custom fixtures for shared setup, Page Object Model for all pages, centralized test data management, shared utilities, and CI/CD with parallel sharding and reporting.',
  $$## Scenario: Enterprise Playwright Framework Design for a Team

## Project Structure

```
playwright-framework/
├── pages/                    # Page Object Model
│   ├── BasePage.ts
│   ├── auth/
│   │   ├── LoginPage.ts
│   │   └── RegisterPage.ts
│   ├── products/
│   │   ├── ProductListPage.ts
│   │   └── ProductDetailPage.ts
│   └── checkout/
│       ├── CartPage.ts
│       ├── ShippingPage.ts
│       └── PaymentPage.ts
│
├── fixtures/                 # Custom test fixtures
│   ├── index.ts              # Re-exports all fixtures
│   ├── page-fixtures.ts      # Page objects as fixtures
│   └── auth-fixtures.ts      # Auth state fixtures
│
├── helpers/                  # Shared utilities
│   ├── api.helper.ts         # API setup/teardown
│   ├── database.helper.ts    # Direct DB operations
│   ├── date.helper.ts
│   └── random.helper.ts      # Test data generators
│
├── test-data/               # Test data management
│   ├── users.ts             # User constants/factories
│   ├── products.ts          # Product test data
│   └── factories/           # Data factories
│       └── user.factory.ts
│
├── tests/                   # Test files by feature
│   ├── auth/
│   │   ├── login.spec.ts
│   │   └── register.spec.ts
│   ├── products/
│   │   └── product-listing.spec.ts
│   ├── checkout/
│   │   └── checkout.spec.ts
│   └── smoke/
│       └── smoke.spec.ts
│
├── .auth/                   # Auth state files (gitignored)
│   ├── user.json
│   └── admin.json
│
├── global-setup.ts
├── global-teardown.ts
├── playwright.config.ts
└── .env.example
```

## playwright.config.ts (Team-Standard Config)

```typescript
import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';
dotenv.config({ path: `.env.${process.env.TEST_ENV || 'staging'}` });

export default defineConfig({
  testDir:      './tests',
  fullyParallel: true,
  workers:      process.env.CI ? 4 : 2,
  retries:      process.env.CI ? 2 : 0,
  globalSetup:  './global-setup.ts',
  globalTeardown: './global-teardown.ts',

  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'results/results.json' }],
    process.env.CI ? ['github'] : ['list'],
  ],

  use: {
    baseURL:    process.env.BASE_URL || 'http://localhost:3000',
    headless:   true,
    trace:      'retain-on-failure',
    screenshot: 'only-on-failure',
    video:      'retain-on-failure',
    actionTimeout:     15_000,
    navigationTimeout: 30_000,
  },

  projects: [
    { name: 'setup', testMatch: '**/*.setup.ts' },
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'], storageState: '.auth/user.json' },
      dependencies: ['setup'],
    },
  ],
});
```

## Data Factory Pattern

```typescript
// helpers/factories/user.factory.ts
export function createUser(overrides: Partial<User> = {}): User {
  return {
    email:    `user-${Date.now()}-${Math.random().toString(36).slice(2)}@test.com`,
    password: 'TestPass123!',
    name:     'Test User',
    role:     'viewer',
    ...overrides,
  };
}

// Usage in test
const adminUser = createUser({ role: 'admin', email: 'admin@test.com' });
```

## Team Guidelines

1. **One POM class per page** — pages should have no test logic
2. **Use fixtures** for all shared setup — no copy-paste across tests
3. **API setup for test data** — never create data via UI in beforeEach
4. **Tag all tests** — `@smoke`, `@regression`, `@api`, `@auth`
5. **No hard-coded waits** — use `waitFor()` or assertions
6. **Descriptive test names** — `'user with expired session is redirected to login'`
7. **Teardown via API** — clean up test data after tests that create records
8. **Store secrets in CI** — never in code or `.env` files committed to git$$,
  'Playwright', 'Framework Design', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Framework Design', 'Team', 'Architecture', 'POM', 'Fixtures', 'Enterprise', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you test infinite scroll pagination in Playwright?',
  'playwright-scenario-test-infinite-scroll',
  'Scroll to the bottom of the page using page.evaluate() or keyboard.press("End"), wait for new content to load, and assert the updated count or new items.',
  $$## Scenario: Testing Infinite Scroll Pagination

Infinite scroll loads more content as the user scrolls down, rather than using traditional pagination buttons.

## Strategy 1 — Scroll to Bottom, Verify More Items Load

```typescript
import { test, expect } from '@playwright/test';

test('infinite scroll loads more products', async ({ page }) => {
  await page.goto('/products');

  // Get initial count
  const initialCount = await page.locator('.product-card').count();
  expect(initialCount).toBe(20); // First page of 20

  // Scroll to the bottom of the page
  await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));

  // Wait for new items to load
  await page.locator('.product-card').nth(20).waitFor({ state: 'visible' });

  // Verify more items loaded
  const afterScrollCount = await page.locator('.product-card').count();
  expect(afterScrollCount).toBeGreaterThan(initialCount);
  expect(afterScrollCount).toBe(40); // Second batch of 20 loaded
});
```

## Strategy 2 — Scroll Element Container (Not Full Page)

```typescript
test('scroll within a product list container', async ({ page }) => {
  await page.goto('/feed');

  const feed = page.locator('.infinite-feed');
  const initialItems = await page.locator('.feed-item').count();

  // Scroll to bottom of the container
  await feed.evaluate(el => el.scrollTo(0, el.scrollHeight));

  // Wait for new items
  await page.locator('.feed-item').nth(initialItems).waitFor();

  const newCount = await page.locator('.feed-item').count();
  expect(newCount).toBeGreaterThan(initialItems);
});
```

## Strategy 3 — Scroll Multiple Times Until Target

```typescript
test('load 100 products via infinite scroll', async ({ page }) => {
  await page.goto('/products');

  let previousCount = 0;
  let currentCount = await page.locator('.product-card').count();

  // Keep scrolling until we have 100 products or no more load
  while (currentCount < 100) {
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));

    // Wait for network activity to settle
    await page.waitForLoadState('networkidle');

    previousCount = currentCount;
    currentCount = await page.locator('.product-card').count();

    // Break if no new items loaded (end of list)
    if (currentCount === previousCount) break;
  }

  expect(currentCount).toBeGreaterThanOrEqual(100);
});
```

## Strategy 4 — Keyboard-Based Scrolling

```typescript
test('scroll using keyboard', async ({ page }) => {
  await page.goto('/news-feed');

  // Click on the page first to give it focus
  await page.locator('body').click();

  const before = await page.locator('.news-card').count();

  // Press End key to jump to page bottom
  await page.keyboard.press('End');

  // Wait for more content
  await page.locator('.news-card').nth(before).waitFor({ timeout: 5000 });

  const after = await page.locator('.news-card').count();
  expect(after).toBeGreaterThan(before);
});
```

## Strategy 5 — Intercept API to Verify Pagination Parameters

```typescript
test('infinite scroll sends correct pagination params', async ({ page }) => {
  const apiCalls: string[] = [];

  await page.route('/api/products*', async route => {
    apiCalls.push(route.request().url());
    await route.continue();
  });

  await page.goto('/products');

  // Scroll once
  await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
  await page.waitForLoadState('networkidle');

  // Verify second API call has page=2 or cursor parameter
  expect(apiCalls.length).toBeGreaterThan(1);
  expect(apiCalls[1]).toContain('page=2');
  // OR check cursor: expect(apiCalls[1]).toMatch(/cursor=\w+/);
});
```

## Verify End of List

```typescript
test('shows end-of-list message after loading all products', async ({ page }) => {
  await page.goto('/products');

  // Keep scrolling until end message appears
  let attempts = 0;
  while (attempts < 20) {
    if (await page.locator('.end-of-list').isVisible()) break;
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(500); // Allow brief load time
    attempts++;
  }

  await expect(page.locator('.end-of-list')).toBeVisible();
  await expect(page.locator('.end-of-list')).toContainText('You have reached the end');
});
```$$,
  'Playwright', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Infinite Scroll', 'Pagination', 'scroll', 'Dynamic Content', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you set up Playwright to run tests on mobile, tablet, and desktop in a single CI run?',
  'playwright-scenario-mobile-tablet-desktop-testing',
  'Configure Playwright projects with device descriptors for each viewport — Desktop Chrome, iPad, Pixel 5. Run all projects in parallel. Use responsive-specific assertions to validate each viewport.',
  $$## Scenario: Multi-Device Testing (Mobile, Tablet, Desktop)

## Configure Projects for Each Device

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  workers: 6, // 6 devices running simultaneously

  projects: [
    // ── Desktop ─────────────────────────────────────
    {
      name: 'Desktop Chrome',
      use: { ...devices['Desktop Chrome'] },
      // viewport: 1280x720
    },
    {
      name: 'Desktop Firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'Desktop Safari',
      use: { ...devices['Desktop Safari'] },
    },

    // ── Tablet ──────────────────────────────────────
    {
      name: 'iPad Pro',
      use: { ...devices['iPad Pro'] },
      // viewport: 1024x1366
    },
    {
      name: 'iPad Mini',
      use: { ...devices['iPad Mini'] },
      // viewport: 768x1024
    },

    // ── Mobile ──────────────────────────────────────
    {
      name: 'Pixel 5 (Android)',
      use: { ...devices['Pixel 5'] },
      // viewport: 393x851
    },
    {
      name: 'iPhone 12',
      use: { ...devices['iPhone 12'] },
      // viewport: 390x844
    },
    {
      name: 'Galaxy S21',
      use: { ...devices['Galaxy S21'] },
    },
  ],
});
```

## Tests That Run on All Devices

```typescript
// tests/responsive/navigation.spec.ts
import { test, expect } from '@playwright/test';

test('navigation is accessible on all devices', async ({ page, isMobile }) => {
  await page.goto('/');

  if (isMobile) {
    // Mobile shows hamburger menu
    await expect(page.getByRole('button', { name: 'Menu' })).toBeVisible();
    await expect(page.getByRole('navigation').locator('a')).not.toBeVisible();

    // Open mobile menu
    await page.getByRole('button', { name: 'Menu' }).click();
    await expect(page.getByRole('navigation').locator('a')).toBeVisible();
  } else {
    // Desktop shows full navigation
    await expect(page.getByRole('navigation').locator('a')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Menu' })).not.toBeVisible();
  }
});
```

## Device-Specific Tests

```typescript
// tests/responsive/product-layout.spec.ts
import { test, expect } from '@playwright/test';

test('product grid layout', async ({ page, viewport }) => {
  await page.goto('/products');
  await expect(page.locator('.product-card')).toBeVisible();

  // Determine expected columns based on viewport width
  const width = viewport?.width || 1280;

  if (width < 640) {
    // Mobile: 1 column
    await expect(page.locator('.product-grid')).toHaveClass(/grid-cols-1/);
  } else if (width < 1024) {
    // Tablet: 2 columns
    await expect(page.locator('.product-grid')).toHaveClass(/grid-cols-2/);
  } else {
    // Desktop: 3 or 4 columns
    await expect(page.locator('.product-grid')).toHaveClass(/grid-cols-[34]/);
  }
});
```

## Run Specific Device Profiles

```bash
# Run only mobile tests
npx playwright test --project="Pixel 5 (Android)"
npx playwright test --project="iPhone 12"

# Run only desktop
npx playwright test --project="Desktop Chrome"

# Run all devices
npx playwright test

# Skip specific device
npx playwright test --ignore-snapshots --project="Desktop Chrome" --project="iPhone 12"
```

## Visual Regression Per Device

```typescript
test('hero section renders correctly', async ({ page }) => {
  await page.goto('/');

  // Each device gets its own baseline snapshot
  await expect(page.locator('.hero')).toHaveScreenshot('hero.png');
  // Automatically creates: hero-Desktop-Chrome-darwin.png, hero-iPhone-12-darwin.png, etc.
});
```

## GitHub Actions with All Devices

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        project: ['Desktop Chrome', 'Pixel 5 (Android)', 'iPad Pro']
    steps:
      - run: npx playwright test --project="${{ matrix.project }}"
```$$,
  'Playwright', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Playwright', 'Mobile Testing', 'Responsive', 'Devices', 'Cross-Browser', 'Viewport', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you verify that a file was downloaded and contains specific content in Playwright?',
  'playwright-scenario-verify-file-download-content',
  'Use page.waitForEvent("download") to capture the Download object, save it with download.saveAs(), then read it using Node.js fs module and assert the content.',
  $$## Scenario: Verify Downloaded File Content

## Test: Download and Verify CSV Report

```typescript
import { test, expect } from '@playwright/test';
import path from 'path';
import fs from 'fs';

test('download CSV and verify content', async ({ page }) => {
  await page.goto('/reports');

  // Select report options
  await page.getByLabel('Report Type').selectOption('sales');
  await page.getByLabel('Date Range').selectOption('last-30-days');

  // Trigger download and capture it
  const downloadPromise = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Export CSV' }).click();
  const download = await downloadPromise;

  // Verify download metadata
  expect(download.suggestedFilename()).toMatch(/sales-report.*\.csv/);

  // Save to a known path
  const downloadPath = path.join('test-downloads', download.suggestedFilename());
  await download.saveAs(downloadPath);

  // Verify file exists
  expect(fs.existsSync(downloadPath)).toBe(true);

  // Verify file size (non-empty)
  const stats = fs.statSync(downloadPath);
  expect(stats.size).toBeGreaterThan(0);

  // Read and verify CSV content
  const content = fs.readFileSync(downloadPath, 'utf-8');
  const lines = content.trim().split('\n');

  // Check headers
  expect(lines[0]).toContain('Date');
  expect(lines[0]).toContain('Product');
  expect(lines[0]).toContain('Amount');

  // Check data rows exist
  expect(lines.length).toBeGreaterThan(1);

  // Verify specific data
  const dataRows = lines.slice(1);
  const total = dataRows
    .map(row => parseFloat(row.split(',')[2] || '0'))
    .reduce((sum, val) => sum + val, 0);

  expect(total).toBeGreaterThan(0);

  // Cleanup
  fs.unlinkSync(downloadPath);
});
```

## Test: Download and Verify PDF (Binary Check)

```typescript
test('verify PDF download', async ({ page }) => {
  await page.goto('/invoices/123');

  const downloadPromise = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Download PDF' }).click();
  const download = await downloadPromise;

  // Verify it's a PDF by reading the magic bytes
  const filePath = await download.path();
  expect(filePath).toBeTruthy();

  const buffer = fs.readFileSync(filePath!);

  // PDF files start with "%PDF"
  const magic = buffer.slice(0, 4).toString('ascii');
  expect(magic).toBe('%PDF');

  // Optionally check file size is reasonable
  expect(buffer.length).toBeGreaterThan(1000); // At least 1KB

  // For text content verification, use a PDF parser
  // npm install pdf-parse
  // const pdf = await pdfParse(buffer);
  // expect(pdf.text).toContain('Invoice #123');
  // expect(pdf.text).toContain('Total: $999.00');
});
```

## Test: Verify Excel File

```typescript
import * as XLSX from 'xlsx'; // npm install xlsx

test('verify Excel report download', async ({ page }) => {
  await page.goto('/reports/export');

  const [download] = await Promise.all([
    page.waitForEvent('download'),
    page.getByRole('button', { name: 'Export Excel' }).click(),
  ]);

  const savePath = `test-downloads/${download.suggestedFilename()}`;
  await download.saveAs(savePath);

  // Parse Excel
  const workbook = XLSX.readFile(savePath);
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  const data = XLSX.utils.sheet_to_json(sheet);

  expect(data.length).toBeGreaterThan(0);
  expect(data[0]).toHaveProperty('Name');
  expect(data[0]).toHaveProperty('Email');
});
```

## Setup Test Downloads Directory

```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    acceptDownloads: true, // Default: true
  },
});
```

```typescript
// In test beforeAll
test.beforeAll(() => {
  if (!fs.existsSync('test-downloads')) {
    fs.mkdirSync('test-downloads', { recursive: true });
  }
});

test.afterAll(() => {
  // Clean up downloads directory
  fs.rmSync('test-downloads', { recursive: true, force: true });
});
```$$,
  'Playwright', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'File Download', 'CSV', 'PDF', 'Verification', 'Node.js', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you test a real-time notification feature using WebSockets in Playwright?',
  'playwright-scenario-test-websocket-notifications',
  'Use page.waitForEvent("websocket") to capture WebSocket connections, then send frames via ws.send() or intercept incoming frames with ws.on("framereceived") to trigger and verify real-time events.',
  $$## Scenario: Testing Real-Time WebSocket Notifications

## Strategy 1 — Wait for WebSocket Frame and Verify UI Update

```typescript
import { test, expect } from '@playwright/test';

test('receive real-time notification via WebSocket', async ({ page }) => {
  await page.goto('/dashboard');

  // Wait for WebSocket connection to be established
  const ws = await page.waitForEvent('websocket');
  console.log('WebSocket URL:', ws.url());

  // Wait for the server to send a notification frame
  const frameSentPromise = ws.waitForEvent('framesent');

  // Or wait for incoming frames
  const frameReceivedPromise = ws.waitForEvent('framereceived');

  // Trigger the action that causes a notification (via another tab, API, etc.)
  const frame = await frameReceivedPromise;
  const data = JSON.parse(frame.payload as string);

  console.log('Received:', data);
  expect(data.type).toBe('notification');
  expect(data.message).toBeTruthy();

  // Verify the notification appears in the UI
  await expect(page.locator('.notification-badge')).toBeVisible();
  await expect(page.locator('.notification-item').first()).toContainText(data.message);
});
```

## Strategy 2 — Trigger Notification via Second Browser Tab

```typescript
test('admin action triggers user notification', async ({ browser }) => {
  // Create two contexts: user and admin
  const userContext  = await browser.newContext({ storageState: '.auth/user.json' });
  const adminContext = await browser.newContext({ storageState: '.auth/admin.json' });

  const userPage  = await userContext.newPage();
  const adminPage = await adminContext.newPage();

  // User opens their notifications page
  await userPage.goto('/dashboard');
  await expect(userPage.locator('.notification-count')).toHaveText('0');

  // Wait for WebSocket connection on user's page
  const ws = await userPage.waitForEvent('websocket');
  const notificationPromise = userPage.locator('.notification-popup').waitFor({ state: 'visible' });

  // Admin triggers an action that sends a notification
  await adminPage.goto('/admin/users');
  await adminPage.locator(`[data-user-email="user@test.com"]`).getByRole('button', { name: 'Send Alert' }).click();
  await adminPage.getByRole('button', { name: 'Confirm' }).click();

  // User's page should show the notification via WebSocket
  await notificationPromise;

  await expect(userPage.locator('.notification-popup')).toContainText('New alert from admin');
  await expect(userPage.locator('.notification-count')).toHaveText('1');

  await userContext.close();
  await adminContext.close();
});
```

## Strategy 3 — Mock WebSocket Server (Pure Frontend Test)

```typescript
test('UI updates when WebSocket message arrives', async ({ page }) => {
  await page.goto('/live-feed');

  // Intercept the WebSocket and inject a fake message
  await page.evaluate(() => {
    // Override WebSocket to send a test message immediately
    const OrigWS = WebSocket;
    (window as any).WebSocket = class extends OrigWS {
      constructor(url: string) {
        super(url);
        setTimeout(() => {
          const event = new MessageEvent('message', {
            data: JSON.stringify({
              type: 'order-update',
              orderId: 'ORD-123',
              status: 'shipped',
              message: 'Your order has been shipped!',
            }),
          });
          this.dispatchEvent(event);
        }, 1000);
      }
    };
  });

  // Wait for notification to appear in UI
  await expect(page.locator('.live-notification')).toBeVisible({ timeout: 5000 });
  await expect(page.locator('.live-notification')).toContainText('Your order has been shipped!');
});
```

## Strategy 4 — Trigger via API and Verify WebSocket Delivery

```typescript
test('order status WebSocket notification flow', async ({ page, request }) => {
  await page.goto('/orders/ORD-123');

  // Assert initial status
  await expect(page.locator('.order-status')).toHaveText('Processing');

  // Trigger status change via API (simulates backend update)
  await request.patch('/api/orders/ORD-123', {
    data: { status: 'shipped' },
    headers: { Authorization: `Bearer ${process.env.ADMIN_TOKEN}` },
  });

  // WebSocket pushes update — verify UI updates without page reload
  await expect(page.locator('.order-status')).toHaveText('Shipped', { timeout: 10000 });
  await expect(page.locator('.status-badge')).toHaveClass(/badge-shipped/);
});
```$$,
  'Playwright', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'WebSocket', 'Real-time', 'Notifications', 'WebSocket Testing', 'Scenario', 'Live Updates'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you handle a test scenario where you need to verify a dynamic table with sorting and filtering?',
  'playwright-scenario-dynamic-table-sort-filter',
  'Click column headers to sort and verify row order changes, apply filters and check count/content updates. Use API intercept to verify the correct parameters are sent with sort/filter requests.',
  $$## Scenario: Testing Dynamic Tables with Sort and Filter

## Test Sorting

```typescript
import { test, expect } from '@playwright/test';

test('sort products table by price ascending', async ({ page }) => {
  await page.goto('/admin/products');

  // Get initial order
  const prices = await page.locator('td.price').allTextContents();
  const initialPrices = prices.map(p => parseFloat(p.replace('$', '')));

  // Click Price column header to sort
  await page.getByRole('columnheader', { name: 'Price' }).click();

  // Verify sort indicator appears
  await expect(page.getByRole('columnheader', { name: 'Price' })).toHaveAttribute('aria-sort', 'ascending');

  // Wait for table to update
  await page.waitForLoadState('networkidle');

  // Verify prices are in ascending order
  const sortedPrices = await page.locator('td.price').allTextContents();
  const sorted = sortedPrices.map(p => parseFloat(p.replace('$', '')));

  for (let i = 0; i < sorted.length - 1; i++) {
    expect(sorted[i]).toBeLessThanOrEqual(sorted[i + 1]);
  }
});

test('sort by clicking column header twice (desc)', async ({ page }) => {
  await page.goto('/products');

  const nameHeader = page.getByRole('columnheader', { name: 'Name' });
  await nameHeader.click(); // Ascending
  await nameHeader.click(); // Descending

  await expect(nameHeader).toHaveAttribute('aria-sort', 'descending');

  const names = await page.locator('td.product-name').allTextContents();
  const sortedDesc = [...names].sort((a, b) => b.localeCompare(a));
  expect(names).toEqual(sortedDesc);
});
```

## Test Filtering

```typescript
test('filter products by category', async ({ page }) => {
  await page.goto('/products');

  const initialCount = await page.locator('tr.product-row').count();
  expect(initialCount).toBeGreaterThan(10);

  // Apply category filter
  await page.getByLabel('Category').selectOption('Electronics');

  // Wait for filtered results
  await page.waitForLoadState('networkidle');

  // Verify all visible rows belong to Electronics
  const categories = await page.locator('td.category').allTextContents();
  categories.forEach(cat => expect(cat).toBe('Electronics'));

  // Verify count reduced
  const filteredCount = await page.locator('tr.product-row').count();
  expect(filteredCount).toBeLessThan(initialCount);
  expect(filteredCount).toBeGreaterThan(0);
});
```

## Test Search/Filter Combined

```typescript
test('search and sort products', async ({ page }) => {
  await page.goto('/products');

  // Apply search
  await page.getByPlaceholder('Search products...').fill('laptop');
  await page.waitForLoadState('networkidle');

  // Verify search results
  const names = await page.locator('td.product-name').allTextContents();
  names.forEach(name => expect(name.toLowerCase()).toContain('laptop'));

  // Now sort the results
  await page.getByRole('columnheader', { name: 'Price' }).click();

  const prices = await page.locator('td.price').allTextContents();
  const numPrices = prices.map(p => parseFloat(p.replace(/[$,]/g, '')));

  for (let i = 0; i < numPrices.length - 1; i++) {
    expect(numPrices[i]).toBeLessThanOrEqual(numPrices[i + 1]);
  }
});
```

## Verify API Params with Sorting

```typescript
test('table sort sends correct API parameters', async ({ page }) => {
  const apiCalls: URL[] = [];

  await page.route('/api/products*', async route => {
    apiCalls.push(new URL(route.request().url()));
    await route.continue();
  });

  await page.goto('/products');

  // Click to sort by price descending
  await page.getByRole('columnheader', { name: 'Price' }).click(); // asc
  await page.getByRole('columnheader', { name: 'Price' }).click(); // desc

  // Verify the API call includes sort parameters
  const sortCall = apiCalls.find(url => url.searchParams.has('sortBy'));
  expect(sortCall?.searchParams.get('sortBy')).toBe('price');
  expect(sortCall?.searchParams.get('sortDir')).toBe('desc');
});
```

## Test Pagination After Filter

```typescript
test('pagination resets after applying filter', async ({ page }) => {
  await page.goto('/products?page=3');
  await expect(page.locator('.pagination .current')).toHaveText('3');

  // Apply filter
  await page.getByLabel('In Stock Only').check();

  // Pagination should reset to page 1
  await expect(page.locator('.pagination .current')).toHaveText('1');
});
```$$,
  'Playwright', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Table Testing', 'Sorting', 'Filtering', 'Dynamic Content', 'Scenario', 'Data Table'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you test a Single Page Application (SPA) with client-side routing in Playwright?',
  'playwright-scenario-test-spa-client-side-routing',
  'Use page.waitForURL() or waitForLoadState("networkidle") after route changes, since SPA navigation does not trigger full page reloads. Assert URL and content changes explicitly.',
  $$## Scenario: Testing SPAs with Client-Side Routing

SPAs (React, Vue, Angular) update the URL without a full page reload, requiring different testing strategies than traditional multi-page apps.

## Key Challenge: No Full Page Reload

```typescript
// BAD — waits for a reload that never happens in SPA
await page.goto('/products');
await page.getByRole('link', { name: 'About' }).click();
await page.waitForLoadState('load'); // May timeout — no reload happens

// GOOD — wait for URL change instead
await page.getByRole('link', { name: 'About' }).click();
await page.waitForURL('/about');
await expect(page.getByRole('heading')).toHaveText('About Us');
```

## Navigate Between SPA Routes

```typescript
import { test, expect } from '@playwright/test';

test('SPA navigation between routes', async ({ page }) => {
  await page.goto('/');

  // Click navigation link — React Router updates URL without reload
  await page.getByRole('link', { name: 'Products' }).click();

  // Wait for the URL to update
  await page.waitForURL('/products');

  // Verify new content loaded by React
  await expect(page.getByRole('heading', { name: 'Products' })).toBeVisible();
  await expect(page.locator('.product-card')).toHaveCount.greaterThan(0);
});
```

## Handle Lazy-Loaded Routes (Code Splitting)

```typescript
test('lazy-loaded route loads correctly', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('link', { name: 'Admin Dashboard' }).click();

  // Lazy route may trigger a network request to load the JS chunk
  await page.waitForURL('/admin');
  await page.waitForLoadState('networkidle'); // Wait for chunk to download

  await expect(page.getByRole('heading')).toHaveText('Admin Dashboard');
});
```

## Test Back Button in SPA

```typescript
test('browser back button works in SPA', async ({ page }) => {
  await page.goto('/products');
  await page.getByRole('link', { name: 'Laptop Pro' }).click();
  await page.waitForURL('/products/laptop-pro');
  await expect(page.getByRole('heading')).toHaveText('Laptop Pro');

  // Go back
  await page.goBack();
  await page.waitForURL('/products');
  await expect(page.getByRole('heading')).toHaveText('Products');
});
```

## Test Deep Link (Direct URL Access)

```typescript
test('direct URL access to SPA route', async ({ page }) => {
  // Navigate directly to a deep URL (not via links)
  await page.goto('/products/category/electronics');

  // SPA router should handle this and render the correct component
  await expect(page).toHaveURL('/products/category/electronics');
  await expect(page.getByRole('heading')).toHaveText('Electronics');
  await expect(page.locator('.product-card')).toBeVisible();
});
```

## Handle Route Guards (Auth)

```typescript
test('protected route redirects to login', async ({ page }) => {
  // Try to access protected route without auth
  await page.goto('/admin/dashboard');

  // React Router guard should redirect to login
  await page.waitForURL('/login');
  await expect(page.getByText('Please log in to continue')).toBeVisible();
});

test('protected route accessible when logged in', async ({ page }) => {
  // Login via storageState (already set up)
  await page.goto('/admin/dashboard');

  // No redirect — authorized user
  await expect(page).toHaveURL('/admin/dashboard');
  await expect(page.getByRole('heading')).toHaveText('Admin Dashboard');
});
```

## Test Query Params and Filters in SPA URL

```typescript
test('URL reflects applied filters in SPA', async ({ page }) => {
  await page.goto('/products');

  await page.getByLabel('Category').selectOption('Electronics');
  await page.getByLabel('Price Range').selectOption('under-100');

  // Verify URL updated with filter params (React Router updates history)
  await page.waitForURL('**/products*category*Electronics*');
  expect(page.url()).toContain('category=Electronics');
  expect(page.url()).toContain('price=under-100');

  // Verify results match filters
  const categories = await page.locator('td.category').allTextContents();
  categories.forEach(c => expect(c).toBe('Electronics'));
});
```$$,
  'Playwright', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'SPA', 'Client-side Routing', 'React Router', 'waitForURL', 'Single Page Application', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you approach testing a payment gateway that redirects to a third-party site?',
  'playwright-scenario-test-payment-gateway-redirect',
  'Mock the payment gateway redirect for unit/regression tests, or test the happy path in a sandbox environment using the gateway provider test cards. Handle the redirect with context.waitForEvent("page").',
  $$## Scenario: Testing Third-Party Payment Gateway Redirects

## The Challenge

Payment gateways like Stripe, PayPal, Razorpay redirect users to a third-party domain. Your test needs to handle:
1. The redirect away from your app
2. Filling payment details on the external page
3. The redirect back to your confirmation page

## Approach 1 — Mock the Payment Gateway (Recommended for CI)

```typescript
import { test, expect } from '@playwright/test';

test('checkout completes with mocked payment', async ({ page }) => {
  // Intercept the payment initiation API
  await page.route('/api/checkout/initiate', route =>
    route.fulfill({
      status: 200,
      json: {
        paymentId: 'test-payment-123',
        redirectUrl: 'http://localhost:3000/payment-mock',
      },
    })
  );

  // Intercept payment verification
  await page.route('/api/checkout/verify', route =>
    route.fulfill({
      status: 200,
      json: { status: 'success', orderId: 'ORD-2024-001' },
    })
  );

  await page.goto('/checkout');
  await page.getByRole('button', { name: 'Pay $99.99' }).click();

  // Simulate redirect back after payment
  await page.goto('http://localhost:3000/payment-success?payment_id=test-payment-123&status=success');

  await expect(page).toHaveURL(/order-confirmed/);
  await expect(page.getByRole('heading')).toContainText('Order Confirmed');
});
```

## Approach 2 — Stripe Sandbox with Test Cards

```typescript
test('Stripe payment with test card', async ({ page }) => {
  await page.goto('/checkout');
  await page.getByRole('button', { name: 'Proceed to Payment' }).click();

  // Handle Stripe redirect (opens Stripe-hosted checkout)
  const [stripePage] = await Promise.all([
    page.context().waitForEvent('page'),
    page.getByRole('link', { name: 'Pay with Stripe' }).click(),
  ]);

  await stripePage.waitForLoadState('domcontentloaded');

  // Fill Stripe test card details
  const cardFrame = stripePage.frameLocator('[name="card-number-element"]');
  await cardFrame.locator('input').fill('4242424242424242');

  const expiryFrame = stripePage.frameLocator('[name="card-expiry-element"]');
  await expiryFrame.locator('input').fill('1226');

  const cvcFrame = stripePage.frameLocator('[name="card-cvc-element"]');
  await cvcFrame.locator('input').fill('123');

  await stripePage.getByRole('button', { name: 'Pay' }).click();

  // Wait for redirect back to your app
  await page.waitForURL('**/order-confirmed');
  await expect(page.getByRole('heading')).toContainText('Order Confirmed');
});
```

## Approach 3 — Verify Payment Initiation (Without Gateway)

```typescript
test('checkout initiates payment with correct data', async ({ page }) => {
  // Capture the payment initiation request
  const [request] = await Promise.all([
    page.waitForRequest(req =>
      req.url().includes('/api/checkout/initiate') && req.method() === 'POST'
    ),
    page.getByRole('button', { name: 'Pay $99.99' }).click(),
  ]);

  // Verify correct amount sent to gateway
  const body = JSON.parse(request.postData()!);
  expect(body.amount).toBe(9999);       // In cents
  expect(body.currency).toBe('USD');
  expect(body.orderId).toBeTruthy();
});
```

## Approach 4 — Block Gateway and Test Callback URL

```typescript
test('payment failure handling', async ({ page }) => {
  // Block gateway and directly test the callback
  await page.route('**/payment-gateway.com/**', route => route.abort());

  await page.goto('/checkout');
  await page.getByRole('button', { name: 'Pay' }).click();

  // Simulate a failed payment callback
  await page.goto('/payment-failed?error=card_declined&order_id=ORD-001');

  await expect(page.getByRole('heading')).toContainText('Payment Failed');
  await expect(page.getByText('Card was declined')).toBeVisible();
  await expect(page.getByRole('button', { name: 'Try Again' })).toBeVisible();
});
```

## Best Practice for Payment Testing

1. **Use provider test modes** — Stripe/PayPal/Razorpay all have sandbox environments
2. **Mock for unit/regression** — fast, reliable, no network dependency
3. **Sandbox E2E** — test the full flow in staging with sandbox credentials
4. **Never test with real cards** — even in staging
5. **Store gateway keys in CI secrets** — never in code$$,
  'Playwright', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Playwright', 'Payment Gateway', 'Stripe', 'Third-party', 'Redirect', 'Mock API', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you handle a Playwright test that needs to verify clipboard copy functionality?',
  'playwright-scenario-clipboard-copy-verification',
  'Grant clipboard permissions via context, then use page.evaluate() to read the clipboard after the copy action, and assert the expected value was copied.',
  $$## Scenario: Testing Clipboard Copy Functionality

Many modern apps have "Copy to Clipboard" buttons. Testing clipboard access requires browser permissions.

## Method 1 — Grant Clipboard Permission and Read

```typescript
import { test, expect } from '@playwright/test';

test('copy to clipboard button copies the correct text', async ({ page, context }) => {
  // Grant clipboard-read permission
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);

  await page.goto('/share');

  // Get the text that should be copied
  const expectedUrl = await page.locator('.share-url').textContent();

  // Click the copy button
  await page.getByRole('button', { name: 'Copy Link' }).click();

  // Verify visual feedback (most apps show this)
  await expect(page.getByRole('button', { name: 'Copied!' })).toBeVisible();

  // Read from clipboard to verify what was actually copied
  const clipboardText = await page.evaluate(() => navigator.clipboard.readText());
  expect(clipboardText).toBe(expectedUrl?.trim());
});
```

## Method 2 — Mock the Clipboard API

```typescript
test('copy button uses clipboard API', async ({ page }) => {
  // Mock clipboard.writeText to capture what was written
  await page.addInitScript(() => {
    let copiedText = '';
    Object.defineProperty(navigator, 'clipboard', {
      value: {
        writeText: (text: string) => {
          copiedText = text;
          (window as any).__copiedText = text;
          return Promise.resolve();
        },
        readText: () => Promise.resolve(copiedText),
      },
      writable: true,
    });
  });

  await page.goto('/api-docs');
  await page.getByRole('button', { name: 'Copy API Key' }).click();

  // Read what the mock captured
  const copiedText = await page.evaluate(() => (window as any).__copiedText);
  expect(copiedText).toMatch(/^[A-Za-z0-9]{32}$/); // API key format
});
```

## Method 3 — Intercept the Paste (Write then Read)

```typescript
test('copy and paste workflow', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);

  await page.goto('/code-editor');

  // Select code snippet
  const codeBlock = page.locator('.code-snippet').first();
  await codeBlock.getByRole('button', { name: 'Copy' }).click();

  // Navigate to another input and paste
  const pasteTarget = page.locator('#code-input');
  await pasteTarget.focus();
  await page.keyboard.press('Control+V'); // Or Meta+V on Mac

  // Verify pasted content
  const pastedValue = await pasteTarget.inputValue();
  expect(pastedValue).toContain('npm install playwright');
});
```

## Method 4 — Test Keyboard Shortcut Copy

```typescript
test('Ctrl+C copies selected text', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);
  await page.goto('/docs');

  const paragraph = page.locator('p').first();

  // Select all text in the paragraph
  await paragraph.click({ clickCount: 3 }); // Triple-click to select all

  // Copy with keyboard
  await page.keyboard.press('Control+C');

  // Read clipboard
  const copied = await page.evaluate(() => navigator.clipboard.readText());
  const expected = await paragraph.textContent();

  expect(copied.trim()).toBe(expected?.trim());
});
```

## Common Clipboard Test Patterns

```typescript
// Verify the "Copied!" tooltip appears briefly
test('copy feedback tooltip', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);
  await page.goto('/profile');

  await page.getByRole('button', { name: 'Copy ID' }).click();

  // Verify tooltip appears
  await expect(page.getByRole('tooltip')).toHaveText('Copied!');

  // Verify tooltip disappears after 2 seconds
  await expect(page.getByRole('tooltip')).not.toBeVisible({ timeout: 3000 });
});
```

> **Note:** Playwright requires explicit `grantPermissions(['clipboard-read', 'clipboard-write'])` since clipboard access is a browser security permission. Without it, `navigator.clipboard.readText()` will throw.$$,
  'Playwright', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Playwright', 'Clipboard', 'Copy to Clipboard', 'grantPermissions', 'page.evaluate', 'Scenario'], true, 0
);
