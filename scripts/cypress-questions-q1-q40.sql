-- Cypress Interview Questions Q1–Q40 | Paste into Supabase SQL Editor

-- ══════════════════════════════════════
-- BEGINNER (Q1–Q12)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Cypress and why is it used for test automation?',
  'what-is-cypress-test-automation',
  'Cypress is a JavaScript end-to-end testing framework that runs directly in the browser, offering fast execution, automatic waiting, real-time reloading, and built-in debugging — no Selenium or WebDriver required.',
  $$## What is Cypress?

**Cypress** is a modern, JavaScript-based end-to-end testing framework that runs **directly inside the browser** — unlike Selenium which communicates via WebDriver from outside the browser.

## Key Features

```
┌─────────────────────────────────────────────────────┐
│                   Cypress Architecture               │
│                                                     │
│   Test Code (JS/TS)  ←→  Node.js Process           │
│          ↕                      ↕                   │
│      Browser Engine  ←→  Cypress Runner             │
│   (Chrome/Firefox/Edge)   (same origin)             │
└─────────────────────────────────────────────────────┘
```

- **No WebDriver** — runs directly in the browser (same run loop as your app)
- **Automatic Waiting** — no explicit waits/sleeps needed; Cypress retries until elements are ready
- **Real-time Reloading** — tests reload automatically on save
- **Time Travel** — hover over each step in the Cypress GUI to see exactly what happened
- **Network Control** — intercept and stub API calls with `cy.intercept()`
- **Screenshots & Videos** — automatic on failure
- **Built-in Assertions** — Chai, Sinon, jQuery matchers included

## Installation

```bash
# Install via npm
npm install cypress --save-dev

# Open Cypress Test Runner (GUI)
npx cypress open

# Run headlessly (CI/CD)
npx cypress run
```

## Basic Test Structure

```javascript
// cypress/e2e/login.cy.js

describe('Login Page', () => {

  beforeEach(() => {
    cy.visit('https://automateqa.online/login');
  });

  it('should login with valid credentials', () => {
    cy.get('#email').type('test@example.com');
    cy.get('#password').type('Password123');
    cy.get('[data-testid="login-btn"]').click();
    cy.url().should('include', '/dashboard');
    cy.get('h1').should('contain', 'Welcome');
  });

  it('should show error for invalid credentials', () => {
    cy.get('#email').type('wrong@email.com');
    cy.get('#password').type('wrongpass');
    cy.get('[data-testid="login-btn"]').click();
    cy.get('.error-message').should('be.visible').and('contain', 'Invalid credentials');
  });
});
```

## Cypress vs Selenium — Quick Comparison

| Feature | Cypress | Selenium |
|---------|---------|---------|
| Language | JavaScript/TypeScript only | Java, Python, C#, JS... |
| Architecture | In-browser | WebDriver (external) |
| Auto-wait | Yes | No (explicit waits needed) |
| Speed | Fast | Slower |
| iframes / tabs | Limited | Full support |
| Mobile testing | No | Yes (Appium) |
| API testing | Yes (cy.request) | No |

## Supported Browsers
Chrome, Firefox, Edge, Electron (default), and Webkit (Safari-like via Playwright bridge)$$,
  'Cypress', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Cypress', 'Introduction', 'E2E Testing', 'JavaScript', 'Browser Testing', 'Test Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you select elements in Cypress? Explain cy.get() and cy.contains().',
  'cypress-element-selection-get-contains',
  'cy.get() selects elements by CSS selector, attribute, or data-testid. cy.contains() finds elements by visible text. data-testid attributes are the recommended selector strategy.',
  $$## Element Selection in Cypress

## cy.get() — Select by CSS Selector

```javascript
// By ID
cy.get('#username')

// By class
cy.get('.btn-primary')

// By attribute (recommended)
cy.get('[data-testid="login-btn"]')
cy.get('[data-cy="submit"]')
cy.get('[placeholder="Enter email"]')
cy.get('[type="submit"]')

// By tag
cy.get('button')
cy.get('input')

// Chained (child elements)
cy.get('.form').get('input[type="email"]')
cy.get('table').find('tr').first()

// By index (0-based)
cy.get('li').eq(0)   // first item
cy.get('li').eq(-1)  // last item
cy.get('li').first()
cy.get('li').last()
```

## cy.contains() — Select by Text

```javascript
// Find element containing this text
cy.contains('Login')
cy.contains('Submit')
cy.contains('Welcome back, Alice')

// Scope to a specific element type
cy.contains('button', 'Login')    // button containing "Login"
cy.contains('td', 'Alice')        // table cell containing "Alice"

// With regex
cy.contains(/login/i)  // case-insensitive
cy.contains(/^\d+ results$/)  // "12 results"

// Chained
cy.get('.nav').contains('Home').click()
```

## Recommended: data-testid Attributes

```javascript
// Best practice — use data-testid in your HTML
// <button data-testid="submit-btn">Submit</button>

cy.get('[data-testid="submit-btn"]').click()

// Avoid fragile selectors like:
cy.get('.btn.btn-primary.large')   // breaks if CSS class changes
cy.get('div > div:nth-child(3)')   // breaks if DOM order changes
```

## cy.find() — Search Within a Scoped Element

```javascript
// Find within a parent
cy.get('.user-card').find('[data-testid="name"]')
cy.get('form').find('input').first()
cy.get('table tbody').find('tr').should('have.length', 10)
```

## Real-World Examples

```javascript
describe('Shopping Cart', () => {
  it('should add product to cart', () => {
    cy.visit('/products');

    // Select first product card's "Add to Cart" button
    cy.get('[data-testid="product-card"]')
      .first()
      .find('[data-testid="add-to-cart"]')
      .click();

    // Verify cart count updated
    cy.get('[data-testid="cart-count"]').should('contain', '1');
  });

  it('should find product by name', () => {
    cy.visit('/products');
    cy.contains('[data-testid="product-name"]', 'Laptop').click();
    cy.url().should('include', '/products/laptop');
  });
});
```$$,
  'Cypress', 'Technical', 'Fresher', 'Beginner',
  ARRAY['cy.get', 'cy.contains', 'Selectors', 'Cypress', 'data-testid', 'Element Selection'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Cypress assertions? Explain .should() and .expect().',
  'cypress-assertions-should-expect',
  'Cypress uses Chai assertions. .should() is chained directly on Cypress commands for implicit retry. .expect() is used in callbacks for explicit assertions. .and() chains multiple assertions.',
  $$## Cypress Assertions

Cypress bundles **Chai**, **Sinon-Chai**, and **Chai-jQuery** for assertions.

## .should() — Implicit Assertion (Retries Until True)

```javascript
// Visibility
cy.get('.alert').should('be.visible')
cy.get('.modal').should('not.exist')
cy.get('#spinner').should('not.be.visible')

// Text content
cy.get('h1').should('have.text', 'Welcome')
cy.get('.title').should('contain', 'Dashboard')
cy.get('[data-testid="msg"]').should('include.text', 'success')

// Value (inputs)
cy.get('#email').should('have.value', 'test@example.com')
cy.get('select').should('have.value', 'option1')

// CSS class / attribute
cy.get('.btn').should('have.class', 'active')
cy.get('input').should('have.attr', 'placeholder', 'Enter email')
cy.get('a').should('have.attr', 'href').and('include', '/dashboard')

// Element state
cy.get('button').should('be.disabled')
cy.get('input[type="checkbox"]').should('be.checked')
cy.get('input').should('be.enabled')

// Length
cy.get('li').should('have.length', 5)
cy.get('tr').should('have.length.greaterThan', 0)
cy.get('[data-testid="item"]').should('have.length.at.least', 3)

// URL
cy.url().should('include', '/dashboard')
cy.url().should('eq', 'https://example.com/home')
```

## .and() — Chain Multiple Assertions

```javascript
// Chain multiple should() / and() on same element
cy.get('input#email')
  .should('be.visible')
  .and('not.be.disabled')
  .and('have.attr', 'type', 'email')

cy.get('.notification')
  .should('be.visible')
  .and('have.class', 'success')
  .and('contain', 'Saved successfully')
```

## .expect() — Explicit Assertion (Inside Callbacks)

```javascript
// Used inside .then() callbacks
cy.get('[data-testid="price"]').then(($el) => {
  const price = parseFloat($el.text().replace('$', ''));
  expect(price).to.be.greaterThan(0);
  expect(price).to.be.lessThan(1000);
});

cy.get('tbody tr').then(($rows) => {
  expect($rows).to.have.length.greaterThan(0);
  expect($rows.length).to.equal(5);
});
```

## Negative Assertions

```javascript
cy.get('.error-msg').should('not.exist')
cy.get('#spinner').should('not.be.visible')
cy.get('button').should('not.be.disabled')
cy.get('.modal').should('not.have.class', 'open')
```

## Common Assertion Examples

```javascript
it('should validate login form', () => {
  cy.visit('/login');

  // Initially disabled
  cy.get('[data-testid="login-btn"]').should('be.disabled');

  // Fill form
  cy.get('#email').type('user@example.com');
  cy.get('#password').type('Password123');

  // Now enabled
  cy.get('[data-testid="login-btn"]').should('be.enabled');

  // Submit and verify
  cy.get('[data-testid="login-btn"]').click();
  cy.url().should('include', '/dashboard');
  cy.get('h1').should('have.text', 'Dashboard');
  cy.get('.user-name').should('contain', 'user@example.com');
});
```$$,
  'Cypress', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Assertions', 'should()', 'expect()', 'Chai', 'Cypress', 'and()'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is automatic waiting in Cypress? How is it different from Selenium''s explicit waits?',
  'cypress-automatic-waiting-vs-selenium-waits',
  'Cypress automatically retries commands and assertions until they pass or timeout (default 4s). Unlike Selenium, you rarely need Thread.sleep() or explicit wait conditions.',
  $$## Automatic Waiting in Cypress

Cypress **automatically waits** for elements to appear, become visible, be enabled, and for the DOM to settle — before executing each command. This is called **retry-ability**.

## How It Works

```javascript
// Cypress will automatically retry cy.get() until:
// 1. Element exists in DOM
// 2. Element is visible (not hidden)
// 3. Element is interactable (not disabled)
// 4. Timeout reached (default: 4000ms)

cy.get('[data-testid="submit"]').click()
// If button isn't there yet → Cypress retries until 4s timeout
```

## Default Timeouts

```javascript
// cypress.config.js
module.exports = {
  defaultCommandTimeout: 4000,   // cy.get(), .should()
  requestTimeout:        5000,   // cy.request()
  responseTimeout:      30000,   // cy.request() response
  pageLoadTimeout:      60000,   // cy.visit()
  execTimeout:          60000,   // cy.exec()
};
```

## Override Timeout Per Command

```javascript
// Wait up to 10 seconds for this specific element
cy.get('[data-testid="results"]', { timeout: 10000 })
  .should('be.visible')

// Wait up to 20s for slow API response to render
cy.get('[data-testid="data-table"]', { timeout: 20000 })
  .find('tr')
  .should('have.length.greaterThan', 0)
```

## What Cypress Waits For Automatically

```javascript
// 1. Element to exist in DOM
cy.get('#modal').should('exist')      // waits for modal to appear

// 2. Animation to finish
cy.get('.btn').should('not.have.class', 'loading').click()

// 3. XHR/fetch to complete (with cy.intercept alias)
cy.intercept('GET', '/api/users').as('getUsers')
cy.visit('/users')
cy.wait('@getUsers')   // explicitly wait for network request
cy.get('[data-testid="user-list"]').should('be.visible')

// 4. Page load
cy.visit('/dashboard')   // waits for page to fully load
```

## Comparison: Cypress vs Selenium

```java
// SELENIUM — Manual waits required
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

// Wait for element to be clickable
WebElement btn = wait.until(ExpectedConditions.elementToBeClickable(By.id("submit")));
btn.click();

// Wait for visibility
wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".result")));

// Explicit sleep (bad practice)
Thread.sleep(3000);  // fragile!
```

```javascript
// CYPRESS — Automatic, no explicit waits needed
cy.get('#submit').click()          // auto-waits for clickable
cy.get('.result').should('be.visible')  // auto-retries
// No Thread.sleep() equivalents needed!
```

## When You DO Need cy.wait()

```javascript
// Only use cy.wait() for:

// 1. Network requests (most common)
cy.intercept('POST', '/api/login').as('loginCall')
cy.get('#login-btn').click()
cy.wait('@loginCall').its('response.statusCode').should('eq', 200)

// 2. Fixed time (use sparingly — bad practice)
cy.wait(2000)  // only when truly needed, e.g., animation that can't be detected
```$$,
  'Cypress', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Automatic Waiting', 'Retry-ability', 'cy.wait', 'Timeout', 'Cypress', 'Selenium vs Cypress'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Cypress fixtures? How do you use test data in Cypress?',
  'cypress-fixtures-test-data',
  'Fixtures are static JSON files in cypress/fixtures/ used to load test data. Use cy.fixture() to read them. They help separate test data from test logic for maintainability.',
  $$## Cypress Fixtures

**Fixtures** are static test data files (JSON, CSV, images) stored in `cypress/fixtures/`. They decouple test data from test logic.

## Fixture File Structure

```
cypress/
├── fixtures/
│   ├── users.json          ← test user data
│   ├── products.json       ← product test data
│   ├── login-valid.json    ← valid login creds
│   └── login-invalid.json  ← invalid login creds
├── e2e/
│   └── login.cy.js
```

## Creating a Fixture File

```json
// cypress/fixtures/users.json
{
  "validUser": {
    "email": "test@automateqa.com",
    "password": "Test@123",
    "name": "QA Tester"
  },
  "adminUser": {
    "email": "admin@automateqa.com",
    "password": "Admin@123",
    "role": "admin"
  },
  "invalidUser": {
    "email": "wrong@email.com",
    "password": "wrongpass"
  }
}
```

## Using cy.fixture() — Method 1: Then Callback

```javascript
describe('Login Tests', () => {
  it('should login with valid user', () => {
    cy.fixture('users').then((users) => {
      cy.visit('/login');
      cy.get('#email').type(users.validUser.email);
      cy.get('#password').type(users.validUser.password);
      cy.get('[data-testid="login-btn"]').click();
      cy.get('.user-greeting').should('contain', users.validUser.name);
    });
  });
});
```

## Using cy.fixture() — Method 2: this Alias (Cleaner)

```javascript
describe('Login Tests', () => {
  beforeEach(function() {
    // Load fixture into this.users — available in all tests
    cy.fixture('users').as('users');
  });

  it('should login with valid credentials', function() {
    const { email, password } = this.users.validUser;
    cy.visit('/login');
    cy.get('#email').type(email);
    cy.get('#password').type(password);
    cy.get('[data-testid="login-btn"]').click();
    cy.url().should('include', '/dashboard');
  });

  it('should reject invalid credentials', function() {
    const { email, password } = this.users.invalidUser;
    cy.visit('/login');
    cy.get('#email').type(email);
    cy.get('#password').type(password);
    cy.get('[data-testid="login-btn"]').click();
    cy.get('.error').should('be.visible');
  });
});
```

## Data-Driven Testing with Fixtures

```javascript
// cypress/fixtures/search-terms.json
// ["Selenium", "Cypress", "Playwright", "TestNG"]

describe('Search Tests', () => {
  it('should search for multiple terms', () => {
    cy.fixture('search-terms').then((terms) => {
      terms.forEach((term) => {
        cy.visit('/');
        cy.get('[data-testid="search"]').clear().type(term);
        cy.get('[data-testid="search-btn"]').click();
        cy.get('[data-testid="result-count"]')
          .should('be.visible')
          .and('not.contain', '0 results');
      });
    });
  });
});
```

## Intercepting API with Fixture Response (Mocking)

```javascript
// cypress/fixtures/api-users.json
// [{"id":1,"name":"Alice","role":"QA"},{"id":2,"name":"Bob","role":"Dev"}]

it('should display users from API', () => {
  cy.intercept('GET', '/api/users', { fixture: 'api-users' }).as('getUsers');
  cy.visit('/users');
  cy.wait('@getUsers');
  cy.get('[data-testid="user-row"]').should('have.length', 2);
  cy.contains('Alice').should('be.visible');
});
```$$,
  'Cypress', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Fixtures', 'Test Data', 'cy.fixture', 'Data-Driven', 'Cypress', 'JSON'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Cypress Custom Commands? How do you create and use them?',
  'cypress-custom-commands',
  'Custom commands extend Cypress with reusable actions defined in cypress/support/commands.js using Cypress.Commands.add(). Use them to avoid repeating login, navigation, or form-fill code.',
  $$## Cypress Custom Commands

Custom commands let you **encapsulate reusable test actions** as named commands, similar to utility methods in Selenium Page Object Model.

## Creating Custom Commands

```javascript
// cypress/support/commands.js

// ── Login command ──
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/login');
  cy.get('#email').type(email);
  cy.get('#password').type(password);
  cy.get('[data-testid="login-btn"]').click();
  cy.url().should('include', '/dashboard');
});

// ── Login via API (faster — bypasses UI) ──
Cypress.Commands.add('loginViaApi', (email, password) => {
  cy.request({
    method: 'POST',
    url: '/api/auth/login',
    body: { email, password },
  }).then((response) => {
    // Store token in localStorage
    window.localStorage.setItem('authToken', response.body.token);
  });
  cy.visit('/dashboard');
});

// ── Select dropdown by visible text ──
Cypress.Commands.add('selectByText', (selector, text) => {
  cy.get(selector).select(text);
});

// ── Fill a form ──
Cypress.Commands.add('fillContactForm', (name, email, message) => {
  cy.get('[data-testid="name"]').type(name);
  cy.get('[data-testid="email"]').type(email);
  cy.get('[data-testid="message"]').type(message);
});

// ── Drag and drop ──
Cypress.Commands.add('dragTo', { prevSubject: 'element' }, (subject, target) => {
  cy.wrap(subject).trigger('mousedown', { which: 1 });
  cy.get(target).trigger('mousemove').trigger('mouseup');
});
```

## TypeScript Declarations (cypress/support/index.d.ts)

```typescript
declare namespace Cypress {
  interface Chainable {
    login(email: string, password: string): void;
    loginViaApi(email: string, password: string): void;
    selectByText(selector: string, text: string): void;
    fillContactForm(name: string, email: string, message: string): void;
  }
}
```

## Using Custom Commands in Tests

```javascript
// cypress/e2e/dashboard.cy.js
describe('Dashboard Tests', () => {
  beforeEach(() => {
    // Use custom command — one line instead of 5
    cy.login('test@automateqa.com', 'Test@123');
  });

  it('should show correct user name', () => {
    cy.get('[data-testid="user-name"]').should('contain', 'QA Tester');
  });

  it('should load dashboard widgets', () => {
    cy.get('[data-testid="widget"]').should('have.length.greaterThan', 2);
  });
});
```

## Overwriting Existing Commands

```javascript
// Add a screenshot on every cy.visit()
Cypress.Commands.overwrite('visit', (originalFn, url, options) => {
  originalFn(url, options);
  cy.screenshot(`visit-${url.replace(/\//g, '-')}`);
});
```

## File Location

```
cypress/
├── support/
│   ├── commands.js     ← define custom commands here
│   └── e2e.js          ← imports commands.js (auto-loaded before every test)
```$$,
  'Cypress', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Custom Commands', 'Cypress.Commands.add', 'Reusability', 'Cypress', 'commands.js'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How does cy.intercept() work in Cypress? How do you mock API calls?',
  'cypress-intercept-mock-api-calls',
  'cy.intercept() intercepts HTTP requests made by the browser, lets you stub responses, spy on requests, or modify them. Use .as() to create an alias then cy.wait() to wait for the call.',
  $$## cy.intercept() — Intercept and Mock API Calls

`cy.intercept()` watches, stubs, or modifies any HTTP request the browser makes — XHR and fetch alike.

## Basic Syntax

```javascript
cy.intercept(method, url, response)
```

## Spy on a Request (No Mock — Just Watch)

```javascript
// Just alias the real request — don''t mock it
cy.intercept('GET', '/api/users').as('getUsers')

cy.visit('/users')
cy.wait('@getUsers')   // wait for the real API call to complete

// Then assert on the response
cy.wait('@getUsers').then((interception) => {
  expect(interception.response.statusCode).to.equal(200)
  expect(interception.response.body).to.have.length.greaterThan(0)
})
```

## Stub a Response (Mock the API)

```javascript
// Return fake data instead of hitting real API
cy.intercept('GET', '/api/users', {
  statusCode: 200,
  body: [
    { id: 1, name: 'Alice', role: 'QA' },
    { id: 2, name: 'Bob',   role: 'Dev' },
  ],
}).as('getUsers')

cy.visit('/users')
cy.wait('@getUsers')
cy.get('[data-testid="user-row"]').should('have.length', 2)
cy.contains('Alice').should('be.visible')
```

## Stub with a Fixture File

```javascript
// Use a JSON fixture file as the response
cy.intercept('GET', '/api/products', { fixture: 'products.json' }).as('getProducts')

cy.visit('/products')
cy.wait('@getProducts')
cy.get('[data-testid="product-card"]').should('have.length.greaterThan', 0)
```

## Stub an Error Response

```javascript
// Test how your app handles 500 errors
cy.intercept('GET', '/api/users', {
  statusCode: 500,
  body: { message: 'Internal Server Error' },
}).as('failedRequest')

cy.visit('/users')
cy.wait('@failedRequest')
cy.get('[data-testid="error-banner"]').should('be.visible')
cy.get('[data-testid="error-banner"]').should('contain', 'Something went wrong')
```

## Intercept by URL Pattern (Wildcards)

```javascript
// Match any URL containing /api/users
cy.intercept('GET', '**/api/users**').as('getUsers')

// Match with glob pattern
cy.intercept('GET', '/api/users/*').as('getUserById')

// Match with regex
cy.intercept('GET', /\/api\/users\/\d+/).as('getUserById')
```

## Modify Request Before It Goes Out

```javascript
cy.intercept('POST', '/api/login', (req) => {
  // Add a custom header
  req.headers['x-custom-header'] = 'cypress-test'
  // You can also modify body
  req.body.extra = 'injected'
}).as('login')
```

## Real Scenario: Login Flow with Intercept

```javascript
it('should redirect to dashboard after successful login', () => {
  cy.intercept('POST', '/api/auth/login', {
    statusCode: 200,
    body: { token: 'fake-jwt-token', user: { name: 'Alice' } },
  }).as('loginRequest')

  cy.visit('/login')
  cy.get('#email').type('alice@test.com')
  cy.get('#password').type('Password123')
  cy.get('[data-testid="login-btn"]').click()

  // Wait and verify the POST was made
  cy.wait('@loginRequest').its('request.body').should('deep.equal', {
    email: 'alice@test.com',
    password: 'Password123',
  })

  cy.url().should('include', '/dashboard')
})
```$$,
  'Cypress', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['cy.intercept', 'API Mocking', 'Network Stubbing', 'Cypress', 'XHR', 'cy.wait'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you implement Page Object Model (POM) in Cypress?',
  'page-object-model-cypress',
  'In Cypress POM, create JS/TS classes per page with methods encapsulating element interactions. Import them in tests. Alternatively use Custom Commands for a simpler approach.',
  $$## Page Object Model in Cypress

Cypress doesn't enforce any structure, but POM keeps tests maintainable by separating **selectors and actions** from **test logic**.

## Project Structure

```
cypress/
├── e2e/
│   ├── login.cy.js
│   └── dashboard.cy.js
├── pages/
│   ├── LoginPage.js
│   ├── DashboardPage.js
│   └── BasePage.js
├── support/
│   └── commands.js
└── fixtures/
    └── users.json
```

## Base Page

```javascript
// cypress/pages/BasePage.js
class BasePage {
  visit(path) {
    cy.visit(path);
    return this;
  }

  getElement(selector) {
    return cy.get(selector);
  }

  clickElement(selector) {
    cy.get(selector).click();
    return this;
  }

  typeInField(selector, text) {
    cy.get(selector).clear().type(text);
    return this;
  }
}

export default BasePage;
```

## Login Page Object

```javascript
// cypress/pages/LoginPage.js
import BasePage from './BasePage';

class LoginPage extends BasePage {
  // Selectors
  elements = {
    emailInput:    () => cy.get('[data-testid="email"]'),
    passwordInput: () => cy.get('[data-testid="password"]'),
    loginBtn:      () => cy.get('[data-testid="login-btn"]'),
    errorMsg:      () => cy.get('[data-testid="error-message"]'),
  };

  // Actions
  visit() {
    return super.visit('/login');
  }

  enterEmail(email) {
    this.elements.emailInput().type(email);
    return this;
  }

  enterPassword(password) {
    this.elements.passwordInput().type(password);
    return this;
  }

  clickLogin() {
    this.elements.loginBtn().click();
    return this;
  }

  login(email, password) {
    return this.visit()
               .enterEmail(email)
               .enterPassword(password)
               .clickLogin();
  }

  // Assertions
  verifyErrorMessage(msg) {
    this.elements.errorMsg().should('be.visible').and('contain', msg);
    return this;
  }
}

export default new LoginPage();
```

## Dashboard Page Object

```javascript
// cypress/pages/DashboardPage.js
import BasePage from './BasePage';

class DashboardPage extends BasePage {
  elements = {
    heading:   () => cy.get('h1'),
    userName:  () => cy.get('[data-testid="user-name"]'),
    logoutBtn: () => cy.get('[data-testid="logout"]'),
  };

  verifyUserLoggedIn(name) {
    this.elements.heading().should('contain', 'Dashboard');
    this.elements.userName().should('contain', name);
    return this;
  }

  logout() {
    this.elements.logoutBtn().click();
    return this;
  }
}

export default new DashboardPage();
```

## Test Using Page Objects

```javascript
// cypress/e2e/login.cy.js
import LoginPage from '../pages/LoginPage';
import DashboardPage from '../pages/DashboardPage';

describe('Login Tests', () => {
  it('should login successfully', () => {
    LoginPage
      .login('test@automateqa.com', 'Test@123');

    DashboardPage
      .verifyUserLoggedIn('QA Tester');
  });

  it('should show error for wrong password', () => {
    LoginPage
      .visit()
      .enterEmail('test@automateqa.com')
      .enterPassword('WrongPass')
      .clickLogin()
      .verifyErrorMessage('Invalid credentials');
  });
});
```$$,
  'Cypress', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Page Object Model', 'POM', 'Cypress', 'Design Pattern', 'Test Architecture', 'ES6 Classes'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you run Cypress tests in CI/CD pipelines like GitHub Actions?',
  'cypress-cicd-github-actions',
  'Use the official Cypress GitHub Action (cypress-io/github-action) to run tests headlessly. Configure environment variables via secrets and upload screenshots/videos as artifacts on failure.',
  $$## Cypress in CI/CD — GitHub Actions

## Basic GitHub Actions Workflow

```yaml
# .github/workflows/cypress.yml
name: Cypress E2E Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  cypress-tests:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run Cypress Tests
        uses: cypress-io/github-action@v6
        with:
          start: npm start        # start your app
          wait-on: 'http://localhost:3000'  # wait for app to be ready
          wait-on-timeout: 60
          browser: chrome
          headless: true
        env:
          CYPRESS_BASE_URL: ${{ secrets.CYPRESS_BASE_URL }}
          CYPRESS_USERNAME:  ${{ secrets.TEST_USERNAME }}
          CYPRESS_PASSWORD:  ${{ secrets.TEST_PASSWORD }}

      - name: Upload Screenshots on Failure
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: cypress-screenshots
          path: cypress/screenshots

      - name: Upload Videos
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: cypress-videos
          path: cypress/videos
```

## Parallel Execution (Cypress Cloud)

```yaml
# Run tests in parallel across 4 machines
jobs:
  cypress-parallel:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        containers: [1, 2, 3, 4]  # 4 parallel runners

    steps:
      - uses: actions/checkout@v4
      - uses: cypress-io/github-action@v6
        with:
          start: npm start
          wait-on: 'http://localhost:3000'
          record: true
          parallel: true
          group: 'E2E Tests'
        env:
          CYPRESS_RECORD_KEY: ${{ secrets.CYPRESS_RECORD_KEY }}
```

## cypress.config.js — Environment Variables

```javascript
// cypress.config.js
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: process.env.CYPRESS_BASE_URL || 'http://localhost:3000',
    viewportWidth:  1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true,
    defaultCommandTimeout: 8000,
  },
  env: {
    username: process.env.CYPRESS_USERNAME,
    password: process.env.CYPRESS_PASSWORD,
    apiUrl:   process.env.CYPRESS_API_URL,
  },
});
```

## Access env vars in tests

```javascript
cy.get('#email').type(Cypress.env('username'))
cy.get('#password').type(Cypress.env('password'))
```

## Run Specific Tests / Tags

```bash
# Run only specific spec files
npx cypress run --spec "cypress/e2e/login.cy.js"

# Run by grep (needs @cypress/grep plugin)
npx cypress run --env grep="@smoke"

# Run headlessly
npx cypress run --browser chrome --headless
```$$,
  'Cypress', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['CI/CD', 'GitHub Actions', 'Cypress', 'Headless', 'Pipeline', 'Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Cypress component testing? How is it different from E2E testing?',
  'cypress-component-testing-vs-e2e',
  'Component testing in Cypress mounts individual React/Vue/Angular components in isolation without a browser URL. E2E testing visits a real URL and tests full user flows.',
  $$## Cypress Component Testing vs E2E Testing

## Key Difference

| | E2E Testing | Component Testing |
|-|------------|------------------|
| What it tests | Full user flows in real browser | Individual UI components in isolation |
| Requires | Running server + URL | No server needed |
| Speed | Slower (full app) | Fast (one component) |
| Use case | Login flow, checkout, navigation | Button, form, modal, card |
| `cy.visit()` | Yes | No — use `cy.mount()` |

## E2E Test (Full App)

```javascript
// cypress/e2e/login.cy.js
it('should login and reach dashboard', () => {
  cy.visit('/login')                           // real server
  cy.get('#email').type('user@test.com')
  cy.get('#password').type('pass123')
  cy.get('[data-testid="login-btn"]').click()
  cy.url().should('include', '/dashboard')     // real navigation
})
```

## Component Test (Isolated Component)

```javascript
// cypress/component/LoginForm.cy.jsx
import LoginForm from '../../src/components/LoginForm'

describe('LoginForm Component', () => {
  it('should render and submit form', () => {
    const onSubmit = cy.stub().as('submitFn')

    // Mount the component directly — no server
    cy.mount(<LoginForm onSubmit={onSubmit} />)

    cy.get('[data-testid="email"]').type('user@test.com')
    cy.get('[data-testid="password"]').type('pass123')
    cy.get('[data-testid="login-btn"]').click()

    // Verify stub was called
    cy.get('@submitFn').should('have.been.calledWith', {
      email:    'user@test.com',
      password: 'pass123',
    })
  })

  it('should disable button when fields empty', () => {
    cy.mount(<LoginForm onSubmit={cy.stub()} />)
    cy.get('[data-testid="login-btn"]').should('be.disabled')
  })
})
```

## Setup for Component Testing

```javascript
// cypress.config.js
const { defineConfig } = require('cypress')
const { devServer } = require('@cypress/vite-dev-server') // or webpack

module.exports = defineConfig({
  component: {
    devServer: {
      framework: 'react',   // or 'vue', 'angular', 'svelte'
      bundler:   'vite',    // or 'webpack'
    },
    specPattern: 'cypress/component/**/*.cy.{js,jsx,ts,tsx}',
  },
})
```

## When to Use Which

- **Component tests**: Test a single component in isolation (button states, form validation, error messages)
- **E2E tests**: Test full user workflows (registration flow, checkout, authentication)
- **Best practice**: Use BOTH — component tests for component logic, E2E for critical user paths$$,
  'Cypress', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Component Testing', 'cy.mount', 'E2E', 'Cypress', 'React', 'Unit Testing'], true, 0
);

-- ══════════════════════════════════════
-- SCENARIO-BASED
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you handle login in Cypress without going through the UI every time?',
  'cypress-login-bypass-ui',
  'Bypass the UI for login using cy.request() to hit the login API directly and set the auth token in localStorage/cookies. Use this in beforeEach to speed up tests significantly.',
  $$## Bypass UI Login in Cypress

Going through the UI for login on every test is slow. The best approach is to **hit the login API directly** and set the token.

## Method 1: cy.request() + localStorage

```javascript
// cypress/support/commands.js
Cypress.Commands.add('loginViaApi', (email, password) => {
  cy.request({
    method:  'POST',
    url:     `${Cypress.env('apiUrl')}/auth/login`,
    body:    { email, password },
    failOnStatusCode: false,
  }).then((response) => {
    expect(response.status).to.equal(200)
    // Store token so the app recognizes the session
    window.localStorage.setItem('authToken', response.body.token)
    window.localStorage.setItem('user', JSON.stringify(response.body.user))
  })
})

// In test
beforeEach(() => {
  cy.loginViaApi('test@automateqa.com', 'Test@123')
  cy.visit('/dashboard')
})
```

## Method 2: cy.session() — Cache Session Across Tests (Cypress 9+)

```javascript
// cypress/support/commands.js
Cypress.Commands.add('login', (email, password) => {
  cy.session(
    [email, password],          // cache key
    () => {
      // This block only runs once per session key
      cy.visit('/login')
      cy.get('#email').type(email)
      cy.get('#password').type(password)
      cy.get('[data-testid="login-btn"]').click()
      cy.url().should('include', '/dashboard')
    },
    {
      validate: () => {
        // Confirm session is still valid before reusing it
        cy.getCookie('session_id').should('exist')
      },
    }
  )
})

// In test file
describe('Dashboard Tests', () => {
  beforeEach(() => {
    cy.login('test@automateqa.com', 'Test@123')  // uses cached session
    cy.visit('/dashboard')
  })

  it('should show user profile', () => {
    cy.get('[data-testid="user-name"]').should('contain', 'QA Tester')
  })
})
```

## Method 3: Set Cookie Directly

```javascript
Cypress.Commands.add('loginWithCookie', () => {
  cy.request('POST', '/api/auth/login', {
    email:    Cypress.env('username'),
    password: Cypress.env('password'),
  }).then((response) => {
    // Set auth cookie Cypress received
    cy.setCookie('auth_token', response.body.token)
  })
})
```

## cypress.config.js — Credentials via env

```javascript
module.exports = defineConfig({
  env: {
    username: 'test@automateqa.com',
    password: 'Test@123',
    apiUrl:   'https://api.automateqa.online',
  },
})
```

## Benefits

- 80–90% faster than UI login on every test
- Tests are independent — each starts with a clean authenticated session
- No flakiness from login page rendering$$,
  'Cypress', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Login Bypass', 'cy.session', 'cy.request', 'Authentication', 'Cypress', 'Performance'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you handle dropdowns, checkboxes, and file uploads in Cypress?',
  'cypress-dropdown-checkbox-file-upload',
  'Use cy.select() for dropdowns, .check()/.uncheck() for checkboxes, and cy.get(input).selectFile() for file uploads. For custom dropdowns, click the trigger then click the option.',
  $$## Handling Dropdowns, Checkboxes, and File Uploads

## Native HTML Dropdown — cy.select()

```javascript
// Select by visible text
cy.get('select#country').select('India')

// Select by value attribute
cy.get('select#role').select('admin')

// Select by index (0-based)
cy.get('select').select(2)

// Multi-select
cy.get('select[multiple]').select(['Alice', 'Bob', 'Charlie'])

// Verify selection
cy.get('select#country').should('have.value', 'IN')
cy.get('select').find(':selected').should('have.text', 'India')
```

## Custom Dropdown (Not Native Select)

```javascript
// Click trigger to open dropdown
cy.get('[data-testid="dropdown-trigger"]').click()

// Then click the option
cy.get('[data-testid="dropdown-menu"]')
  .contains('India')
  .click()

// Verify
cy.get('[data-testid="selected-value"]').should('contain', 'India')

// Close if needed
cy.get('body').click()  // click outside to close
```

## Checkboxes

```javascript
// Check a checkbox
cy.get('#terms-checkbox').check()
cy.get('[data-testid="remember-me"]').check()

// Uncheck
cy.get('#newsletter').uncheck()

// Check by value
cy.get('input[type="checkbox"]').check('option1')

// Check multiple
cy.get('input[type="checkbox"]').check(['cypress', 'selenium', 'playwright'])

// Verify state
cy.get('#terms-checkbox').should('be.checked')
cy.get('#newsletter').should('not.be.checked')
```

## Radio Buttons

```javascript
cy.get('input[type="radio"][value="male"]').check()
cy.get('[name="gender"]').check('female')

// Verify
cy.get('input[type="radio"][value="male"]').should('be.checked')
```

## File Upload — cy.selectFile()

```javascript
// Upload a file from cypress/fixtures/
cy.get('input[type="file"]').selectFile('cypress/fixtures/sample.pdf')

// Upload from file system path
cy.get('input[type="file"]').selectFile('path/to/file.csv')

// Drag and drop file
cy.get('[data-testid="drop-zone"]').selectFile('cypress/fixtures/sample.pdf', {
  action: 'drag-drop',
})

// Upload multiple files
cy.get('input[type="file"][multiple]').selectFile([
  'cypress/fixtures/file1.pdf',
  'cypress/fixtures/file2.pdf',
])

// Verify file was uploaded
cy.get('[data-testid="file-name"]').should('contain', 'sample.pdf')
cy.get('[data-testid="upload-success"]').should('be.visible')
```

## Complete Form Test

```javascript
it('should fill registration form', () => {
  cy.visit('/register')

  // Text inputs
  cy.get('#name').type('Alice QA')
  cy.get('#email').type('alice@test.com')

  // Native dropdown
  cy.get('#country').select('India')

  // Custom dropdown
  cy.get('[data-testid="role-dropdown"]').click()
  cy.get('[data-testid="role-option-sdet"]').click()

  // Checkbox
  cy.get('#terms').check()
  cy.get('#newsletter').check()

  // Radio
  cy.get('[value="female"]').check()

  // File upload
  cy.get('input[type="file"]').selectFile('cypress/fixtures/resume.pdf')

  // Submit
  cy.get('[data-testid="register-btn"]').click()
  cy.get('[data-testid="success-msg"]').should('contain', 'Registration successful')
})
```$$,
  'Cypress', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Dropdown', 'Checkbox', 'File Upload', 'cy.select', 'selectFile', 'Cypress', 'Forms'], true, 0
);
