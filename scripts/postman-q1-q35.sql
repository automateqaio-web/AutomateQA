-- Postman Interview Questions Q1–Q35 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Postman and why is it used in API testing?',
  'what-is-postman-and-why-used-in-api-testing',
  'Postman is an API platform for building, testing, and documenting APIs with an intuitive GUI for sending HTTP requests.',
  $$## What is Postman?

**Postman** is a popular **API platform** used for building, testing, and documenting APIs. It provides an intuitive GUI (Graphical User Interface) that allows testers and developers to:

- Send HTTP requests (GET, POST, PUT, PATCH, DELETE)
- Inspect responses (status codes, headers, body)
- Write test scripts to automate API validation
- Organize requests into collections
- Share API workflows with teams

## Why is Postman Used in API Testing?

### 1. Easy to Use
No coding knowledge required to send basic requests — just enter the URL, select the method, and click Send.

### 2. Request Builder
- Supports all HTTP methods
- Easy setup of headers, params, body, and auth
- Supports JSON, XML, form-data, raw text

### 3. Response Inspection
- See status code, response time, response size
- Formatted JSON/XML view for easy reading
- Headers tab for response headers

### 4. Test Scripts
Write JavaScript-based tests to automate assertions:
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});
```

### 5. Collections
Group related API requests into reusable collections and share with your team.

### 6. Environment Variables
Switch between dev/staging/production easily using environment variables.

### 7. Newman (CLI)
Run Postman collections from the command line for CI/CD integration.

## Postman vs REST Assured

| Feature | Postman | REST Assured |
|---------|---------|-------------|
| Language | JavaScript (tests) | Java |
| UI | Yes (GUI) | No (code only) |
| Learning curve | Low | Medium |
| CI/CD integration | Via Newman | Direct JUnit/TestNG |
| Collaboration | Built-in sharing | Version control |$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'API Testing', 'Introduction', 'GUI', 'HTTP', 'Basics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you send a GET request in Postman?',
  'how-to-send-get-request-postman',
  'Select GET from the method dropdown, enter the URL, optionally add headers/params, and click Send to execute the request.',
  $$## Sending a GET Request in Postman

### Step-by-Step Guide

1. **Open Postman** and click **New Request**
2. **Select GET** from the HTTP method dropdown (default is usually GET)
3. **Enter the URL** in the request URL field:
   ```
   https://reqres.in/api/users?page=2
   ```
4. **Add Query Parameters** (optional):
   - Click the **Params** tab
   - Add key-value pairs: `page` = `2`
5. **Add Headers** (optional):
   - Click the **Headers** tab
   - Add: `Content-Type: application/json`
6. **Click Send**
7. **Inspect the Response**:
   - **Status code** — e.g., `200 OK`
   - **Body** — JSON response data
   - **Headers** — response headers
   - **Time** — how long the request took

### Example GET Request

```
GET https://reqres.in/api/users/2
```

**Response:**
```json
{
    "data": {
        "id": 2,
        "email": "janet.weaver@reqres.in",
        "first_name": "Janet",
        "last_name": "Weaver"
    }
}
```

### Quick Tips

- Use **Params tab** to add query parameters (Postman appends them to the URL automatically)
- Use **Authorization tab** to add Bearer tokens without manually typing the header
- Save the request to a **Collection** for reuse
- Use **Pre-request Script** to set dynamic values before the request fires$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'GET', 'HTTP Methods', 'API Testing', 'Basics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the different HTTP methods supported by Postman?',
  'http-methods-supported-by-postman',
  'Postman supports all HTTP methods including GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, and more.',
  $$## HTTP Methods in Postman

Postman supports all standard HTTP methods via the **method dropdown** in the request builder:

| Method | Purpose | Common Status on Success |
|--------|---------|--------------------------|
| **GET** | Retrieve data | 200 OK |
| **POST** | Create a new resource | 201 Created |
| **PUT** | Update/replace entire resource | 200 OK |
| **PATCH** | Partial update of a resource | 200 OK |
| **DELETE** | Delete a resource | 200/204 |
| **HEAD** | Same as GET but no body | 200 OK |
| **OPTIONS** | Discover allowed methods | 200 OK |

## Additional Methods Postman Supports
- **COPY** — Copy a resource
- **LINK / UNLINK** — Link/unlink resources
- **PURGE** — Remove cached data
- **LOCK / UNLOCK** — WebDAV methods
- **PROPFIND** — WebDAV property discovery

## How to Select in Postman

1. Click the **method dropdown** (shows "GET" by default)
2. Select the desired method from the list
3. The interface adapts (e.g., Body tab becomes editable for POST/PUT)

## Method-Specific Tips in Postman

- **POST/PUT/PATCH**: Use the **Body** tab to set request payload
- **GET/DELETE**: Usually no body needed (use Params for query parameters)
- **DELETE**: Some APIs require a body — Postman supports body with DELETE too
- **HEAD**: Response shows only headers, no body displayed$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'HTTP Methods', 'GET', 'POST', 'PUT', 'DELETE', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you add query parameters in Postman?',
  'how-to-add-query-parameters-postman',
  'Use the Params tab in Postman to add key-value query parameters, which are automatically appended to the URL.',
  $$## Adding Query Parameters in Postman

### Method 1: Using the Params Tab (Recommended)

1. Enter your base URL: `https://reqres.in/api/users`
2. Click the **Params** tab below the URL bar
3. Add key-value pairs:
   | Key | Value |
   |-----|-------|
   | `page` | `2` |
   | `per_page` | `5` |
4. Postman automatically appends them to the URL:
   ```
   https://reqres.in/api/users?page=2&per_page=5
   ```
5. Click **Send**

### Method 2: Type Directly in URL

You can also type query params directly in the URL:
```
https://reqres.in/api/users?page=2&per_page=5
```
Postman will parse and display them in the Params tab automatically.

### Method 3: Using Environment Variables

```
https://reqres.in/api/users?page={{pageNumber}}
```
Set `pageNumber` as an environment variable with value `2`.

### Enabling/Disabling Parameters

Each param has a **checkbox** — uncheck it to temporarily disable without deleting:
```
☑ page      2
☐ per_page  5    ← disabled, not sent
```

### Example Test After Adding Params

```javascript
pm.test("Page number is 2", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.page).to.eql(2);
});
```

### Tips
- Use **Bulk Edit** mode to paste many params at once
- Query params with special characters are automatically URL-encoded by Postman
- Params can be linked to collection or environment variables for dynamic testing$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'Query Parameters', 'Params Tab', 'API Testing', 'URL'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between Params and Body in Postman?',
  'difference-between-params-and-body-postman',
  'Params adds data to the URL as query strings for GET requests; Body sends data in the request payload for POST/PUT/PATCH.',
  $$## Params vs Body in Postman

### Params Tab

The **Params** tab adds **query parameters to the URL**. These appear after `?` in the URL.

```
URL: https://api.example.com/users?page=2&limit=10
```

**When to use:**
- GET requests to filter, sort, or paginate results
- Any method where data is passed via URL
- Search parameters

**Example:**
```
Key     | Value
page    | 2
limit   | 10
```

Result: `GET /api/users?page=2&limit=10`

---

### Body Tab

The **Body** tab sends data in the **HTTP request body**. Used for POST, PUT, PATCH requests to create or update resources.

**Body Types in Postman:**

| Type | Use Case |
|------|---------|
| **none** | No body (GET/DELETE) |
| **form-data** | File uploads, mixed data |
| **x-www-form-urlencoded** | HTML form submission |
| **raw** | JSON, XML, plain text |
| **binary** | Upload files directly |
| **GraphQL** | GraphQL queries |

**Raw JSON Example:**
```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "job": "QA Engineer"
}
```

---

### Quick Comparison

| Feature | Params | Body |
|---------|--------|------|
| Location | URL (?key=value) | Request body |
| Methods | GET (mainly) | POST, PUT, PATCH |
| Visibility | Visible in URL | Not in URL |
| Data type | Simple key-value | Complex JSON/XML/Form |
| Used for | Filtering/searching | Creating/updating data |

### Rule of Thumb
- **Params** = What you WANT (filter criteria)
- **Body** = What you SEND (resource data)$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'Params', 'Body', 'Query Parameters', 'Request Body', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are Collections in Postman and what is their purpose?',
  'postman-collections-purpose',
  'Postman Collections group related API requests into organized folders that can be shared, run, and versioned as a team.',
  $$## Postman Collections

A **Collection** in Postman is a **group of saved API requests** organized into folders. Think of it as a project folder for your API tests.

## Purpose of Collections

### 1. Organization
Group related API requests logically:
```
📁 User API Collection
  📁 Auth
    → POST /login
    → POST /logout
  📁 Users
    → GET /users
    → POST /users
    → GET /users/{id}
    → PUT /users/{id}
    → DELETE /users/{id}
```

### 2. Collaboration
- Export and share collections as JSON files
- Publish collections to your **Postman workspace** for team access
- Version-control collections in Git

### 3. Automated Testing with Collection Runner
Run all requests in a collection in sequence:
- Set number of iterations
- Use CSV/JSON data files for data-driven testing
- View pass/fail results for each test

### 4. Newman Integration (CI/CD)
Run collections from the command line:
```bash
newman run my-collection.json -e production.json --reporters cli,html
```

### 5. Documentation
Postman auto-generates API documentation from your collection with descriptions, examples, and response samples.

## Creating a Collection

1. Click **Collections** in the sidebar
2. Click **+** or **New Collection**
3. Name it (e.g., "User API Tests")
4. Add requests by clicking the **...** menu → **Add Request**
5. Save each request to the collection

## Collection Variables

Collections can have their own variables:
```
{{base_url}} = https://api.example.com
{{api_version}} = v1
```

Use in requests: `{{base_url}}/{{api_version}}/users`$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'Collections', 'Organization', 'Team Collaboration', 'Newman', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you send a POST request with a JSON payload in Postman?',
  'send-post-request-json-payload-postman',
  'Select POST, enter URL, go to Body tab, select raw + JSON, enter the JSON payload, and click Send.',
  $$## Sending a POST Request with JSON in Postman

### Step-by-Step

1. **Select POST** from the method dropdown
2. **Enter the URL**: `https://reqres.in/api/users`
3. **Click the Body tab**
4. **Select "raw"** radio button
5. **Select "JSON"** from the format dropdown (changes Content-Type to application/json automatically)
6. **Enter the JSON body:**
   ```json
   {
       "name": "John Doe",
       "job": "QA Engineer"
   }
   ```
7. **Click Send**

### Expected Response: 201 Created
```json
{
    "name": "John Doe",
    "job": "QA Engineer",
    "id": "123",
    "createdAt": "2026-06-20T10:00:00.000Z"
}
```

### Add a Test Script (Tests Tab)

```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Response has id", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.id).to.be.a('string');
});

pm.test("Name matches", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.name).to.eql("John Doe");
});
```

### Tips

- Always set **Content-Type: application/json** header (Postman does this automatically when you select JSON in Body > raw)
- Use **environment variables** for dynamic data: `"name": "{{userName}}"`
- Use **Pre-request Scripts** to generate dynamic values before sending:
  ```javascript
  pm.environment.set("userName", "User_" + Date.now());
  ```$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'POST', 'JSON', 'Request Body', 'API Testing', 'Test Scripts'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are Environments in Postman and how do you use them?',
  'postman-environments-how-to-use',
  'Environments are sets of key-value variables in Postman that let you switch between dev/staging/production configurations easily.',
  $$## Environments in Postman

An **Environment** in Postman is a set of **key-value variables** that let you quickly switch between different configurations (dev, staging, production) without changing your requests.

## Creating an Environment

1. Click **Environments** in the left sidebar
2. Click **+** to create a new environment
3. Name it (e.g., "Production", "Staging", "Local")
4. Add variables:

| Variable | Initial Value | Current Value |
|----------|--------------|---------------|
| `base_url` | `https://api.production.com` | `https://api.production.com` |
| `api_key` | `prod-key-123` | `prod-key-123` |

## Using Environment Variables in Requests

Reference variables with `{{variable_name}}`:

```
URL: {{base_url}}/api/users
Header: Authorization: Bearer {{api_key}}
Body: { "env": "{{environment_name}}" }
```

## Switching Environments

1. Click the **environment dropdown** (top-right, next to the eye icon)
2. Select "Staging" — all `{{base_url}}` references now point to staging URL
3. Run your requests — same collection, different config

## Types of Variables (Scope)

| Scope | Overrides | Visibility |
|-------|----------|------------|
| **Global** | Nothing | All environments |
| **Environment** | Collection | Current environment only |
| **Collection** | Environment | Current collection only |
| **Local** | All | Current request only |

Variable priority (highest → lowest): **Local > Data > Environment > Collection > Global**

## Practical Example

```javascript
// In Tests tab — save token from login response to environment
pm.test("Save auth token", function () {
    const jsonData = pm.response.json();
    pm.environment.set("auth_token", jsonData.token);
});

// In next request
// Authorization: Bearer {{auth_token}}
```

## Environment Secret Variables

- Mark sensitive values (passwords, tokens) as **Secret** in Postman
- Secrets are not synced to Postman cloud for security$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'Environments', 'Variables', 'API Testing', 'Configuration', 'Dev/Staging/Prod'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are Global, Environment, and Collection variables in Postman?',
  'global-environment-collection-variables-postman',
  'Postman has 5 variable scopes: global, collection, environment, data, and local — each with different visibility and priority.',
  $$## Variable Scopes in Postman

Postman has **5 variable scopes** listed from highest to lowest priority:

```
Local > Data > Environment > Collection > Global
```

When variables share the same name, the **higher-priority** scope wins.

---

### 1. Global Variables
- Available **across all workspaces, collections, and environments**
- Useful for values shared across everything
- Set in: **Environments → Globals**

```javascript
// Set global variable in script
pm.globals.set("global_token", "abc123");

// Get global variable
const token = pm.globals.get("global_token");
```

---

### 2. Environment Variables
- Available within the **selected environment only**
- Ideal for: base URLs, API keys, user credentials per environment
- Change by switching the active environment

```javascript
pm.environment.set("base_url", "https://api.staging.com");
const url = pm.environment.get("base_url");
```

---

### 3. Collection Variables
- Scoped to a **specific collection**
- Good for variables shared across all requests in a collection

```javascript
pm.collectionVariables.set("user_id", "123");
const id = pm.collectionVariables.get("user_id");
```

---

### 4. Data Variables
- Come from **external CSV or JSON files** used in Collection Runner
- Only available during a collection run
- Example CSV row: `username,password`

---

### 5. Local Variables
- Only available in the **current script execution** (Pre-request or Test)
- Highest priority but temporary

```javascript
pm.variables.set("temp_value", "xyz");
const val = pm.variables.get("temp_value");
```

---

## When to Use Which

| Scope | Use For |
|-------|---------|
| Global | Tokens shared across all collections |
| Environment | Base URLs, API keys per environment |
| Collection | Values specific to one API project |
| Data | Data-driven testing with CSV/JSON |
| Local | Temporary calculations within a script |$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Variables', 'Global', 'Environment', 'Collection', 'Data-Driven', 'Scope'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you use test scripts in Postman?',
  'how-to-use-test-scripts-postman',
  'Postman test scripts use JavaScript in the Tests tab to assert status codes, response body values, headers, and response time.',
  $$## Test Scripts in Postman

Test scripts run **after a response is received**. They are written in **JavaScript** and use Postman''s `pm` API to validate API responses.

## Location

**Tests tab** → bottom panel of any request

## Common Test Assertions

### Status Code Checks

```javascript
// Check status code is 200
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Check status code is in range 2xx
pm.test("Success status", function () {
    pm.expect(pm.response.code).to.be.oneOf([200, 201, 204]);
});
```

### Response Body Assertions

```javascript
// Parse JSON body
const jsonData = pm.response.json();

pm.test("User name is correct", function () {
    pm.expect(jsonData.data.first_name).to.eql("Janet");
});

pm.test("ID exists", function () {
    pm.expect(jsonData.data.id).to.be.a("number");
});

pm.test("Email format", function () {
    pm.expect(jsonData.data.email).to.include("@");
});
```

### Response Time Check

```javascript
pm.test("Response time is under 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});
```

### Header Validation

```javascript
pm.test("Content-Type is JSON", function () {
    pm.expect(pm.response.headers.get("Content-Type")).to.include("application/json");
});
```

### Save Values for Chaining

```javascript
pm.test("Save user ID", function () {
    const jsonData = pm.response.json();
    pm.environment.set("user_id", jsonData.data.id);
});
```

## Quick Snippets

Postman provides **code snippets** in the right panel of the Tests tab:
- "Status code: Code is 200"
- "Response body: JSON value check"
- "Response time is less than 200ms"
- "Response headers: Content-Type header check"

Click any snippet to insert it automatically!$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'Test Scripts', 'JavaScript', 'Assertions', 'pm API', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between Pre-request Scripts and Tests in Postman?',
  'pre-request-scripts-vs-tests-postman',
  'Pre-request Scripts run before a request is sent (setup/preparation), while Tests run after the response is received (validation).',
  $$## Pre-request Scripts vs Tests in Postman

Both are JavaScript tabs in Postman, but they run at **different times** and serve different purposes.

---

## Pre-request Scripts

**Run BEFORE the request is sent.** Used for setup and preparation.

### Use Cases
- Generate dynamic values (timestamps, random data)
- Set authentication tokens
- Calculate checksums or signatures
- Chain requests by using data from a previous response

### Examples

```javascript
// Generate a random email
const randomEmail = `user_${Date.now()}@test.com`;
pm.environment.set("random_email", randomEmail);

// Get current timestamp
pm.environment.set("timestamp", new Date().toISOString());

// Fetch a token before the actual request (via pm.sendRequest)
pm.sendRequest({
    url: pm.environment.get("base_url") + "/auth/login",
    method: "POST",
    header: { "Content-Type": "application/json" },
    body: {
        mode: "raw",
        raw: JSON.stringify({ username: "admin", password: "secret" })
    }
}, function (err, res) {
    pm.environment.set("auth_token", res.json().token);
});
```

---

## Tests (Post-response Scripts)

**Run AFTER the response is received.** Used for validation.

### Use Cases
- Assert status codes
- Validate response body fields
- Check response headers
- Save values from response for next request
- Log debugging info

### Examples

```javascript
pm.test("Status is 201", function () {
    pm.response.to.have.status(201);
});

const json = pm.response.json();
pm.test("Name matches", function () {
    pm.expect(json.name).to.eql(pm.environment.get("random_name"));
});

// Save for next request
pm.environment.set("created_id", json.id);
```

---

## Summary

| Feature | Pre-request Script | Tests (Post-response) |
|---------|-------------------|-----------------------|
| Runs | Before request | After response |
| Purpose | Setup / Preparation | Validation / Assertions |
| Access to response | No | Yes |
| Common use | Token generation, dynamic data | Status code checks, body validation |$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Pre-request Scripts', 'Tests', 'JavaScript', 'API Testing', 'Scripting'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the Collection Runner in Postman and how do you use it?',
  'postman-collection-runner-how-to-use',
  'The Collection Runner executes all requests in a Postman collection in sequence with test reporting, iterations, and data file support.',
  $$## Postman Collection Runner

The **Collection Runner** allows you to run all requests in a collection sequentially, view test results, and optionally use data files for data-driven testing.

## How to Open Collection Runner

1. Click on a **Collection** in the sidebar
2. Click the **Run** button (▶) at the top right
3. Or: click the **...** menu → **Run collection**

## Collection Runner Options

| Option | Description |
|--------|------------|
| **Iterations** | How many times to run the collection (e.g., 3) |
| **Delay** | Wait time between requests (ms) |
| **Data file** | CSV or JSON file for data-driven testing |
| **Save responses** | Stores response data for review after run |
| **Run order** | Drag requests to reorder them |

## Data-Driven Testing with CSV

**users.csv:**
```csv
username,password,expected_status
admin,admin123,200
user1,password1,200
invalid,wrongpass,401
```

In your test script:
```javascript
pm.test("Status matches expected", function () {
    pm.response.to.have.status(parseInt(pm.iterationData.get("expected_status")));
});
```

In Collection Runner:
- Set **Iterations** to 3 (number of CSV rows)
- Select **users.csv** as the data file
- Click **Run**

## Reading Results

The runner shows:
- ✅ Passed / ❌ Failed for each test in each request
- Total pass rate
- Response times per request
- Export results as HTML report

## Running via Newman (CLI)

```bash
# Run collection
newman run my-collection.json

# With environment
newman run my-collection.json -e staging.json

# With data file
newman run my-collection.json -d users.csv

# With HTML report
newman run my-collection.json --reporters html --reporter-html-export report.html
```

## Use Case Example
Run a full login → create user → get user → update → delete flow, verifying each step with test assertions.$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Collection Runner', 'Data-Driven Testing', 'Newman', 'API Testing', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What authentication methods are supported by Postman?',
  'authentication-methods-supported-postman',
  'Postman supports Basic Auth, Bearer Token, OAuth 1.0/2.0, API Key, Digest Auth, AWS Signature, and NTLM authentication.',
  $$## Authentication Methods in Postman

Postman supports all major authentication types via the **Authorization tab** in any request.

## Available Auth Types

### 1. No Auth
No authentication. Used for public APIs.

### 2. API Key
Pass an API key as a header or query parameter:
```
Header: X-API-Key: your-api-key-here
```
or
```
Query: ?api_key=your-key
```

### 3. Bearer Token (Most Common)
Used for JWT and OAuth 2.0 token-based auth:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

### 4. Basic Auth
Username and password encoded in Base64:
```
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

### 5. Digest Auth
Sends a hashed version of credentials. More secure than Basic Auth.

### 6. OAuth 1.0
Legacy OAuth using consumer key, consumer secret, access token, and token secret.

### 7. OAuth 2.0
Modern OAuth flow supporting:
- **Authorization Code** — server-side apps
- **Client Credentials** — machine-to-machine
- **Implicit** — deprecated browser flows
- **Password** — direct credentials

```javascript
// Postman fetches token automatically
// Click "Get New Access Token" in the Authorization tab
```

### 8. AWS Signature
For AWS API Gateway requests — automatically signs with Access Key, Secret Key, and Region.

### 9. NTLM Authentication
Windows NT LAN Manager auth for corporate/intranet APIs.

### 10. Hawk Authentication
HMAC-based auth with time-limited credentials.

## How to Set Auth in Postman

1. Open a request
2. Go to **Authorization** tab
3. Select type from **Type** dropdown
4. Fill in credentials
5. Postman automatically adds the correct header/param

## Inheritance
Set auth at the **Collection level** and all requests inherit it. Override per-request as needed.$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Authentication', 'Bearer Token', 'OAuth', 'Basic Auth', 'API Key', 'API Security'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle OAuth 2.0 authentication in Postman?',
  'oauth2-authentication-postman',
  'Use the Authorization tab, select OAuth 2.0, configure the grant type and token URL, then click Get New Access Token.',
  $$## OAuth 2.0 in Postman

OAuth 2.0 is the modern standard for API authorization. Postman has a built-in OAuth 2.0 flow manager.

## Setup Steps

1. Go to the **Authorization** tab of your request or collection
2. Select **Type: OAuth 2.0**
3. Click **Get New Access Token**
4. Configure the token request:

| Field | Value |
|-------|-------|
| Token Name | My API Token |
| Grant Type | Authorization Code / Client Credentials |
| Callback URL | `https://oauth.pstmn.io/v1/callback` |
| Auth URL | `https://auth.example.com/oauth/authorize` |
| Access Token URL | `https://auth.example.com/oauth/token` |
| Client ID | `your-client-id` |
| Client Secret | `your-client-secret` |
| Scope | `read:users write:users` |

5. Click **Request Token** → Postman opens the login/consent page
6. Log in and authorize
7. Postman stores the token — click **Use Token**

## Client Credentials Grant (Machine-to-Machine)

For server-to-server auth (no user login):
- Grant Type: **Client Credentials**
- Only needs: Access Token URL, Client ID, Client Secret

```javascript
// Or get token manually via script
pm.sendRequest({
    url: "https://auth.example.com/oauth/token",
    method: "POST",
    header: { "Content-Type": "application/x-www-form-urlencoded" },
    body: {
        mode: "urlencoded",
        urlencoded: [
            { key: "grant_type", value: "client_credentials" },
            { key: "client_id", value: pm.environment.get("client_id") },
            { key: "client_secret", value: pm.environment.get("client_secret") }
        ]
    }
}, function(err, res) {
    pm.environment.set("access_token", res.json().access_token);
});
```

## Auto-Refresh Tokens

Enable **Auto-refresh token** in Postman to automatically fetch a new token before it expires.

## Best Practices
- Store `client_id` and `client_secret` in environment variables
- Use **Secret** variable type for sensitive values
- Set token expiry time to auto-refresh$$,
  'Postman', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Postman', 'OAuth 2.0', 'Authentication', 'Bearer Token', 'Client Credentials', 'Authorization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Newman and how do you use it for Postman CI/CD?',
  'what-is-newman-postman-cicd',
  'Newman is Postman''s command-line runner that lets you execute collections in CI/CD pipelines with HTML/JUnit reporting.',
  $$## What is Newman?

**Newman** is the **command-line collection runner** for Postman. It allows you to run Postman collections directly from the terminal, making it perfect for **CI/CD integration**.

## Installation

```bash
npm install -g newman

# With HTML reporter
npm install -g newman-reporter-html
```

## Basic Usage

```bash
# Run a collection
newman run MyCollection.json

# Run with environment
newman run MyCollection.json -e staging-environment.json

# Run with data file
newman run MyCollection.json -d testdata.csv

# Run with HTML report
newman run MyCollection.json --reporters html --reporter-html-export results/report.html

# Run with JUnit XML (for CI systems)
newman run MyCollection.json --reporters junit --reporter-junit-export results/junit.xml
```

## Exporting from Postman

1. Open your **Collection**
2. Click **...** → **Export**
3. Choose **Collection v2.1**
4. Save the JSON file
5. Run with Newman

## CI/CD Integration Examples

### GitHub Actions
```yaml
- name: Run API Tests
  run: |
    npm install -g newman newman-reporter-html
    newman run collection.json -e production.json --reporters cli,html \
      --reporter-html-export report.html
```

### Jenkins
```bash
newman run ${WORKSPACE}/collection.json \
  -e ${WORKSPACE}/env.json \
  --reporters junit \
  --reporter-junit-export ${WORKSPACE}/results/newman-report.xml
```

## Newman Options

| Flag | Description |
|------|------------|
| `-e, --environment` | Environment file |
| `-d, --iteration-data` | Data file (CSV/JSON) |
| `-n, --iteration-count` | Number of iterations |
| `--delay-request` | Delay between requests (ms) |
| `--timeout-request` | Request timeout (ms) |
| `--reporters` | Output reporters (cli, html, junit) |
| `--bail` | Stop on first test failure |

## Advantages of Newman

- No Postman UI needed — headless execution
- Integrate with **any CI/CD tool** (Jenkins, GitHub Actions, GitLab CI, Azure DevOps)
- Generate **test reports** automatically
- Run collections programmatically in Node.js$$,
  'Postman', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Newman', 'Postman', 'CI/CD', 'CLI', 'GitHub Actions', 'Jenkins', 'API Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you validate JSON responses in Postman test scripts?',
  'validate-json-responses-postman-test-scripts',
  'Use pm.response.json() to parse the response and Chai assertion methods like eql, include, have.property to validate JSON fields.',
  $$## Validating JSON Responses in Postman

Use `pm.response.json()` to parse the response body as a JavaScript object and then apply assertions using Chai.js (built into Postman).

## Basic JSON Validation

```javascript
const jsonData = pm.response.json();

// Check a field equals specific value
pm.test("User ID is 2", function () {
    pm.expect(jsonData.data.id).to.eql(2);
});

// Check field type
pm.test("Email is a string", function () {
    pm.expect(jsonData.data.email).to.be.a("string");
});

// Check field exists
pm.test("First name exists", function () {
    pm.expect(jsonData.data).to.have.property("first_name");
});

// Check string contains value
pm.test("Email contains @", function () {
    pm.expect(jsonData.data.email).to.include("@");
});
```

## Array Validation

```javascript
const jsonData = pm.response.json();

// Check array length
pm.test("Data has 6 users", function () {
    pm.expect(jsonData.data).to.have.lengthOf(6);
});

// Check first element
pm.test("First user ID is 1", function () {
    pm.expect(jsonData.data[0].id).to.eql(1);
});

// Check all emails are strings
pm.test("All emails are valid", function () {
    jsonData.data.forEach(user => {
        pm.expect(user.email).to.be.a("string");
        pm.expect(user.email).to.include("@");
    });
});
```

## Nested Object Validation

```javascript
pm.test("Support URL exists", function () {
    pm.expect(jsonData.support.url).to.be.a("string");
    pm.expect(jsonData.support.url).to.match(/^https/);
});
```

## Common Chai Assertions

| Assertion | Example |
|-----------|---------|
| Equal | `.to.eql("value")` |
| Include | `.to.include("text")` |
| Type check | `.to.be.a("string")` |
| Property exists | `.to.have.property("id")` |
| Number comparison | `.to.be.above(0)` |
| Array length | `.to.have.lengthOf(5)` |
| Not null | `.to.not.be.null` |
| Match regex | `.to.match(/pattern/)` |$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'JSON Validation', 'Test Scripts', 'Chai', 'Assertions', 'pm.response.json'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you chain requests in Postman using variables?',
  'chain-requests-postman-variables',
  'Extract data from a response into environment variables using pm.environment.set, then reference those variables in subsequent requests.',
  $$## Chaining Requests in Postman

API chaining in Postman works by **extracting values from a response** and storing them in variables, then using those variables in subsequent requests.

## Example: Login → Use Token → Create User → Delete User

### Request 1: Login
**POST** `{{base_url}}/auth/login`

**Tests tab:**
```javascript
// Extract token from login response and save it
pm.test("Login successful", function () {
    pm.response.to.have.status(200);
});

const jsonData = pm.response.json();
pm.environment.set("auth_token", jsonData.token);
pm.environment.set("user_id", jsonData.user.id);
```

---

### Request 2: Get User Details (uses saved token)
**GET** `{{base_url}}/users/{{user_id}}`

**Authorization tab:**
- Type: Bearer Token
- Token: `{{auth_token}}`

**Tests tab:**
```javascript
pm.test("User retrieved successfully", function () {
    pm.response.to.have.status(200);
});

const jsonData = pm.response.json();
pm.environment.set("user_email", jsonData.email);
```

---

### Request 3: Update User
**PUT** `{{base_url}}/users/{{user_id}}`

**Body (raw JSON):**
```json
{
    "email": "{{user_email}}",
    "name": "Updated Name"
}
```

---

## Chaining with Pre-request Scripts

If you need to execute a request **before** the current one:

```javascript
// In Pre-request Script — fetch token before main request
pm.sendRequest({
    url: pm.environment.get("base_url") + "/auth/login",
    method: "POST",
    header: { "Content-Type": "application/json" },
    body: {
        mode: "raw",
        raw: JSON.stringify({
            username: pm.environment.get("username"),
            password: pm.environment.get("password")
        })
    }
}, function(err, response) {
    const token = response.json().token;
    pm.environment.set("auth_token", token);
});
```

## Tips for Effective Chaining

- Always validate each step with `pm.test()` before extracting values
- Use **environment variables** for values needed across requests
- Use **collection variables** for values shared across collection runs
- Order matters — use Collection Runner to run in sequence$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Request Chaining', 'Variables', 'pm.environment.set', 'API Testing', 'Workflow'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a Mock Server in Postman and how do you use it?',
  'postman-mock-server-how-to-use',
  'A Postman Mock Server simulates API endpoints by returning predefined example responses, enabling frontend development without a real backend.',
  $$## Postman Mock Server

A **Mock Server** in Postman simulates API endpoints by returning **predefined example responses**. This allows frontend developers to work without a real backend, and testers to test without a live API.

## Why Use Mock Servers?

- Frontend development can proceed before backend APIs are ready
- Test edge cases (slow responses, errors) without changing real API
- Reduce dependency on backend teams
- Test 3rd party API integrations without actually calling them

## Creating a Mock Server

### Method 1: From a Collection

1. Select your **Collection**
2. Click **...** → **Mock Collection**
3. Give it a name (e.g., "User API Mock")
4. Choose environment (optional)
5. Click **Create Mock Server**
6. Postman generates a URL like: `https://abc123.mock.pstmn.io`

### Method 2: From Scratch

1. Click **Mock Servers** in the sidebar
2. Click **+** → Create Mock Server
3. Add API paths and HTTP methods
4. Define example responses

## Adding Examples to Requests

1. Open a saved request (e.g., `GET /users`)
2. Send the real request to get a response
3. Click **Save Response** → **Save as example**
4. The example is now returned by the mock server

## Example Response Definition

For `GET /api/users`:
```json
{
  "data": [
    { "id": 1, "name": "John", "email": "john@test.com" },
    { "id": 2, "name": "Jane", "email": "jane@test.com" }
  ],
  "total": 2
}
```

## Using the Mock Server

Update your environment variable:
```
base_url = https://abc123.mock.pstmn.io
```

Send requests as normal — Postman returns mock responses.

## Dynamic Mock Responses

Postman matches mock responses based on:
1. URL path
2. HTTP method
3. Query parameters
4. Request headers

Create multiple examples with different query params to return different mock data.$$,
  'Postman', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Postman', 'Mock Server', 'API Mocking', 'Testing', 'Frontend Development', 'Simulation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you integrate Postman collections with CI/CD pipelines?',
  'postman-collections-cicd-integration',
  'Use Newman to run Postman collections in CI/CD pipelines like GitHub Actions, Jenkins, or GitLab CI with JUnit/HTML reporting.',
  $$## Postman CI/CD Integration

The primary way to integrate Postman collections with CI/CD pipelines is via **Newman** — Postman''s CLI runner.

## General Workflow

```
1. Write API tests in Postman
2. Export collection + environment files
3. Commit JSON files to Git repository
4. CI/CD pipeline runs Newman
5. Newman generates test reports (JUnit XML, HTML)
6. CI reads test results and marks build pass/fail
```

## GitHub Actions Integration

```yaml
# .github/workflows/api-tests.yml
name: API Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  api-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install Newman
        run: |
          npm install -g newman
          npm install -g newman-reporter-html

      - name: Run API Tests
        run: |
          newman run postman/collection.json \
            -e postman/staging.json \
            --reporters cli,junit,html \
            --reporter-junit-export results/junit.xml \
            --reporter-html-export results/report.html

      - name: Upload Test Report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: api-test-reports
          path: results/
```

## Jenkins Integration

```groovy
// Jenkinsfile
pipeline {
    agent any
    stages {
        stage('API Tests') {
            steps {
                sh '''
                    npm install -g newman newman-reporter-html
                    newman run collection.json \
                      -e staging.json \
                      --reporters junit \
                      --reporter-junit-export results/newman.xml
                '''
            }
        }
    }
    post {
        always {
            junit 'results/newman.xml'
        }
    }
}
```

## GitLab CI Integration

```yaml
api-tests:
  image: node:18
  script:
    - npm install -g newman
    - newman run collection.json -e environment.json --reporters cli,junit --reporter-junit-export results.xml
  artifacts:
    reports:
      junit: results.xml
```

## Best Practices

- Store collection and environment JSON in **version control**
- Never hardcode secrets — use **CI/CD secrets/environment variables**
- Use `--bail` flag to stop on first failure in critical pipelines
- Generate **HTML reports** as build artifacts for visibility$$,
  'Postman', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Postman', 'CI/CD', 'Newman', 'GitHub Actions', 'Jenkins', 'GitLab', 'API Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are Postman Monitors and how do they work?',
  'postman-monitors-how-they-work',
  'Postman Monitors are scheduled collection runs that check API health at set intervals and send email alerts on failures.',
  $$## Postman Monitors

**Postman Monitors** are **scheduled, automated collection runs** that check the health and performance of your APIs at regular intervals.

## How They Work

1. You define a collection with test scripts
2. A Monitor is attached to that collection
3. Postman runs the collection on a **schedule** (every 5 mins, hourly, daily, etc.)
4. If any tests fail, Postman sends **email alerts**
5. You can view history, response times, and trends in the Monitors dashboard

## Setting Up a Monitor

1. Click **Monitors** in the Postman sidebar
2. Click **+** → **Create a Monitor**
3. Configure:
   - **Collection** to run
   - **Environment** to use
   - **Frequency**: 5 minutes / hourly / daily / weekly
   - **Region**: Select server location for testing
   - **Email notifications**: Get alerts on failure
4. Click **Create Monitor**

## Monitor Dashboard

View per-run results:
- ✅ Pass rate per collection run
- ⏱ Response times over time (trend graph)
- 📧 Failure notification history
- 🌍 Performance by region

## Use Cases

### API Health Monitoring
```javascript
// Test that critical endpoints are UP
pm.test("API is healthy", function () {
    pm.response.to.have.status(200);
    pm.expect(pm.response.responseTime).to.be.below(2000);
});
```

### SLA Monitoring
```javascript
pm.test("Response time under SLA (1 second)", function () {
    pm.expect(pm.response.responseTime).to.be.below(1000);
});
```

### Business Workflow Monitoring
Run a full login → search → checkout flow every 15 minutes to detect regressions.

## Monitor Limits (Free Plan)
- 1,000 monitoring calls/month
- 5-minute minimum frequency

## Pro Plan Benefits
- More monitoring calls
- Shorter intervals (every 1 minute)
- Custom regions
- Slack/PagerDuty integrations$$,
  'Postman', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Postman', 'Monitors', 'API Health', 'Scheduled Tests', 'Alerting', 'SLA Monitoring'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle dynamic values in API testing with Postman?',
  'handle-dynamic-values-api-testing-postman',
  'Use Postman built-in dynamic variables like {{$randomEmail}}, pre-request scripts, or environment variables to generate and store dynamic values.',
  $$## Handling Dynamic Values in Postman

## Method 1: Built-in Dynamic Variables

Postman provides **built-in dynamic variables** that generate values at runtime:

```
{{$randomFirstName}}     → John
{{$randomLastName}}      → Doe
{{$randomEmail}}         → john.doe@example.com
{{$randomInt}}           → 472
{{$randomUUID}}          → a3d5-4c8b-9f1e-...
{{$timestamp}}           → 1718871234
{{$isoTimestamp}}        → 2026-06-20T10:00:00Z
{{$randomPhoneNumber}}   → +1-800-555-0101
```

**Usage in Body:**
```json
{
    "name": "{{$randomFirstName}} {{$randomLastName}}",
    "email": "{{$randomEmail}}",
    "phone": "{{$randomPhoneNumber}}"
}
```

## Method 2: Pre-request Script for Custom Dynamic Data

```javascript
// Generate unique username
const username = "user_" + Date.now();
pm.environment.set("dynamic_username", username);

// Generate unique email
const email = `test_${Math.floor(Math.random() * 10000)}@example.com`;
pm.environment.set("dynamic_email", email);

// Generate future date
const futureDate = new Date();
futureDate.setDate(futureDate.getDate() + 30);
pm.environment.set("expiry_date", futureDate.toISOString().split("T")[0]);
```

**Body uses:** `"email": "{{dynamic_email}}"`

## Method 3: Extract and Chain

```javascript
// After POST /users — save created user ID
const jsonData = pm.response.json();
pm.environment.set("created_user_id", jsonData.id);

// Next request: GET /users/{{created_user_id}}
```

## Method 4: Data Files (for Bulk Dynamic Testing)

**users.json:**
```json
[
    { "name": "Alice", "email": "alice@test.com" },
    { "name": "Bob",   "email": "bob@test.com" }
]
```

In Collection Runner, load the file — each row drives one iteration.

## Best Practices

- Use `{{$randomUUID}}` for unique identifiers to avoid conflicts
- Always store dynamic values in environment variables for chaining
- Clean up created test data (run DELETE at end of collection)$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Dynamic Variables', 'Pre-request Scripts', 'Data-Driven', 'API Testing', 'Randomization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you generate API documentation in Postman?',
  'generate-api-documentation-postman',
  'Postman auto-generates interactive API documentation from collections that can be published publicly or shared with teams.',
  $$## API Documentation in Postman

Postman can **automatically generate interactive documentation** from your collection — no extra tools needed.

## How to Generate Documentation

### Step 1: Add Descriptions to Requests

1. Open any request in your collection
2. Click the **description icon** (pencil) or the description field below the request name
3. Write a description using **Markdown**:

```markdown
## Get User by ID

Retrieves a single user''s details by their unique ID.

### Path Parameters
- `id` (required) — The user''s unique identifier

### Response
Returns a user object with `id`, `email`, `first_name`, `last_name` fields.
```

### Step 2: Add Examples

1. Send the request
2. Click **Save Response** → **Save as example**
3. Name the example (e.g., "Successful Response", "User Not Found")

### Step 3: Publish Documentation

1. Click on your **Collection** → **...** → **View Documentation**
2. Postman shows a live preview of your documentation
3. Click **Publish** to make it public
4. Share the URL with your team or customers

## What the Documentation Includes

- **API endpoint URLs and methods**
- **Request parameters** (path, query, headers, body)
- **Example requests and responses**
- **Authentication requirements**
- **Test scripts** (optional)
- **Description markdown content**

## Auto-generated from Requests

Postman reads your saved requests and builds:
- URL patterns
- Parameter tables
- Request/response examples
- Code snippets (curl, Python, Java, JavaScript, etc.)

## Postman API Network

Publish your API to the **Postman API Network** so it''s discoverable by other developers. Major companies (Stripe, Twilio, GitHub) publish their official APIs on this network.

## Keep Docs Updated
Every time you update a request, the documentation updates automatically!$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Documentation', 'API Docs', 'Collection', 'Markdown', 'API Network'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle error responses in Postman tests?',
  'handle-error-responses-postman-tests',
  'Write test scripts to verify error status codes, error messages in response body, and validate the error response structure.',
  $$## Handling Error Responses in Postman Tests

Testing error responses is just as important as testing success scenarios. Here''s how to validate them properly.

## Testing 4xx Client Errors

### 400 Bad Request

```javascript
// Send request without required fields
pm.test("Returns 400 for missing fields", function () {
    pm.response.to.have.status(400);
});

pm.test("Error message is correct", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.error).to.include("required");
});
```

### 401 Unauthorized

```javascript
// Send request without auth token
pm.test("Returns 401 when no token", function () {
    pm.response.to.have.status(401);
});

pm.test("Error message mentions authorization", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.message).to.be.oneOf([
        "Unauthorized",
        "Invalid credentials",
        "Token is missing"
    ]);
});
```

### 404 Not Found

```javascript
pm.test("Returns 404 for non-existent resource", function () {
    pm.response.to.have.status(404);
});

pm.test("Error body is correct", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("error");
    pm.expect(jsonData.error).to.include("not found");
});
```

## Testing 5xx Server Errors

```javascript
pm.test("Handle 500 gracefully", function () {
    // If server error, log it but don''t fail the whole suite
    if (pm.response.code === 500) {
        console.log("Server error:", pm.response.text());
        pm.expect.fail("Server returned 500 - investigate");
    }
});
```

## Conditional Validation Based on Status

```javascript
const statusCode = pm.response.code;

if (statusCode === 200) {
    pm.test("Success response has data", function () {
        const jsonData = pm.response.json();
        pm.expect(jsonData.data).to.exist;
    });
} else if (statusCode === 404) {
    pm.test("Not found has error message", function () {
        const jsonData = pm.response.json();
        pm.expect(jsonData.error).to.exist;
    });
} else {
    pm.test("Unexpected status code: " + statusCode, function () {
        pm.expect.fail("Unexpected status code");
    });
}
```

## Error Response Schema Validation

```javascript
pm.test("Error response has correct structure", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData).to.have.all.keys("error", "code", "message");
    pm.expect(jsonData.code).to.be.a("number");
    pm.expect(jsonData.message).to.be.a("string");
});
```$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Error Handling', '4xx', '5xx', 'Negative Testing', 'Test Scripts', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you debug API requests in Postman?',
  'debug-api-requests-postman',
  'Use Postman Console (Ctrl+Alt+C), console.log in scripts, Postman Interceptor, and the test output panel to debug API issues.',
  $$## Debugging API Requests in Postman

## Method 1: Postman Console

The **Postman Console** shows all network traffic, logs, and script output.

**Open:** `View → Show Postman Console` (or `Ctrl + Alt + C` / `Cmd + Option + C`)

What it shows:
- Full request URL (with query params)
- Request headers sent
- Response headers received
- Script `console.log` output
- Errors and warnings

## Method 2: Console.log in Scripts

```javascript
// In Pre-request Script or Tests
console.log("Base URL:", pm.environment.get("base_url"));
console.log("Request body:", pm.request.body);
console.log("Response status:", pm.response.code);
console.log("Response body:", pm.response.json());
```

All output appears in the Postman Console.

## Method 3: Inspect Request Details

Before sending, click the **Preview** button in the Request Builder to see the exact URL being constructed:
```
GET https://api.example.com/users?page=2&limit=10
Headers: Content-Type: application/json
```

## Method 4: Response Inspection

After sending:
- **Body tab** → Formatted JSON/XML or Raw text
- **Headers tab** → All response headers
- **Cookies tab** → Response cookies
- **Test Results tab** → Which tests passed/failed
- **Response time** → Duration in ms
- **Response size** → Payload size

## Method 5: pm.test Output for Debugging

```javascript
// Use test assertions to surface debugging info
pm.test("Debug: Check response structure", function () {
    const json = pm.response.json();
    console.log("Full response:", JSON.stringify(json, null, 2));
    pm.expect(json).to.be.an("object"); // always passes, just for logging
});
```

## Method 6: Postman Interceptor

Postman Interceptor (browser extension) captures requests from your browser and sends them to Postman for inspection and replay.

## Common Debugging Scenarios

| Issue | How to Debug |
|-------|-------------|
| 401 Unauthorized | Check if token is set correctly in env variable |
| 400 Bad Request | Console.log the request body before sending |
| Empty response | Check Content-Type header, inspect raw response |
| Wrong URL | Open Console to see the exact URL constructed |
| Script error | Check Console for JavaScript error line numbers |$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Debugging', 'Console', 'console.log', 'Troubleshooting', 'API Testing'], true, 0
);
