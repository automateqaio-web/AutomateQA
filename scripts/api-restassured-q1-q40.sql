-- API / REST Assured Q1–Q40 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is an API and how does it work?',
  'what-is-an-api-and-how-does-it-work',
  'An API is a messenger that takes your request to a system and returns the response back to you.',
  $$## What is an API?

**API** stands for **Application Programming Interface**. It acts as a messenger — like a waiter in a restaurant — that takes your request, communicates it to the system (kitchen), and delivers the response back to you (food).

## Real-Life Example

When you search for flights on an airline website, you interact with the airline's database through their API. If you use an online travel service like Kayak or Expedia, that service calls the airline's API to aggregate information from multiple databases.

## How APIs Work

1. **Client** sends a request (e.g., "Get all users")
2. **API** receives the request and routes it to the server
3. **Server** processes the request and queries the database
4. **API** returns the response (data, status code) to the client

## Key Benefits

- **Separation of concerns** — frontend and backend are decoupled
- **Reusability** — one API can serve web, mobile, and third-party apps
- **Security** — only exposes what's needed, hides internal logic
- **Standardization** — REST, SOAP, GraphQL are common standards

## API vs Web Service

| Feature | API | Web Service |
|---------|-----|-------------|
| Network required | Not always | Always |
| Communication | Various formats | SOAP, REST, XML-RPC |
| Scope | Broader | Subset of API |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['API', 'REST', 'Introduction', 'HTTP', 'Basics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Explain the major components of a REST API',
  'explain-major-components-of-rest-api',
  'A REST API has 4 core components: API client, API request, API server, and API response.',
  $$## 4 Components of a REST API

### 1. API Client
The software or application that **initiates requests** to the API server to retrieve or manipulate data.

- Acts as intermediary between the end-user and the API server
- Responsible for sending properly formatted requests and handling responses

**Example:** A mobile app that displays weather information. The app sends a request to the weather API server to fetch current weather data.

---

### 2. API Request
A **message sent by the client** to the API server, indicating the action it wants to perform.

Contains:
- **Endpoint (URL)** — specific API resource path
- **HTTP Method** — GET, POST, PUT, DELETE, etc.
- **Headers** — metadata like Content-Type, Authorization
- **Body** — data payload (for POST/PUT requests)

**Example:** `GET https://api.weather.com/current-weather` — fetches weather data for a location.

---

### 3. API Server
A software application that **receives requests, processes them**, interacts with the database or other services, and generates a response.

- Acts as the gateway to the backend system
- Provides access to the requested resources

**Example:** The weather API server receives the GET request, queries its database, and generates a response with temperature, humidity, and weather conditions.

---

### 4. API Response
The **message sent by the server** back to the client in reply to the API request.

Contains:
- **Data** requested by the client (JSON/XML)
- **Status codes** — 200, 201, 404, 500, etc.
- **Headers** — Content-Type, Cache-Control, etc.

**Example:** After processing the GET request, the weather server sends back `{ "temperature": 25, "humidity": 65, "condition": "Sunny" }`.$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['API', 'REST', 'Components', 'Client', 'Server', 'Request', 'Response'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the HTTP methods used in REST API testing?',
  'http-methods-used-in-rest-api-testing',
  'REST APIs use GET, POST, PUT, PATCH, DELETE, HEAD, and OPTIONS methods with different testing priorities.',
  $$## HTTP Methods in REST API Testing

REST APIs use the following HTTP methods:

| Method | Purpose | Idempotent |
|--------|---------|-----------|
| **GET** | Retrieve a resource | Yes |
| **POST** | Create a new resource | No |
| **PUT** | Update/replace a resource completely | Yes |
| **PATCH** | Partially update a resource | No |
| **DELETE** | Delete a resource | Yes |
| **HEAD** | Same as GET but without response body | Yes |
| **OPTIONS** | Returns supported HTTP methods for the URL | Yes |

## Testing Priority

- **P1 (Critical):** GET, POST, DELETE — core CRUD operations
- **P2 (High):** PUT — full update
- **P3 (Medium):** PATCH — partial update

## Key Distinctions

### PUT vs POST
- Use **PUT** for UPDATE operations
- Use **POST** for CREATE operations
- PUT is **idempotent** (same result no matter how many times called)
- POST is **NOT idempotent** (each call creates a new resource)

```
GET    /users          → Get all users
POST   /users          → Create a new user
GET    /users/{id}     → Get user by ID
PUT    /users/{id}     → Update user by ID
PATCH  /users/{id}     → Partially update user
DELETE /users/{id}     → Delete user by ID
```$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['HTTP Methods', 'GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'REST', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the types of HTTP status codes in API testing?',
  'types-of-http-status-codes-api-testing',
  'HTTP status codes are grouped into 5 categories: 1xx informational, 2xx success, 3xx redirection, 4xx client errors, 5xx server errors.',
  $$## HTTP Status Code Categories

| Range | Category | Meaning |
|-------|----------|---------|
| **1xx** | Informational | Request was received, continuing process |
| **2xx** | Successful | Request was successfully received, understood, and accepted |
| **3xx** | Redirection | Further action needs to be taken to complete the request |
| **4xx** | Client Error | Request contains bad syntax or cannot be fulfilled |
| **5xx** | Server Error | Server failed to fulfil an apparently valid request |

## Most Common Status Codes in API Projects

| Code | Name | When You See It |
|------|------|----------------|
| **200** | OK | Successful GET or PUT request |
| **201** | Created | Successful POST — resource created |
| **204** | No Content | Successful DELETE — nothing to return |
| **302** | Redirect | Resource temporarily moved |
| **400** | Bad Request | Missing/invalid request parameters |
| **401** | Unauthorized | Missing or invalid authentication token |
| **403** | Forbidden | Authenticated but lacks permission |
| **404** | Not Found | Resource does not exist |
| **405** | Method Not Allowed | HTTP method not supported for that endpoint |
| **417** | Expectation Failed | Server cannot meet the Expect header requirement |
| **422** | Unprocessable Entity | Validation failed on request body |
| **500** | Internal Server Error | Server crashed or encountered an unexpected error |

## Tips for Testers
- Always verify the **correct** status code, not just 200
- Test both **happy path** (2xx) and **error paths** (4xx, 5xx)
- Use `assertEquals(response.getStatusCode(), 200)` in Rest Assured$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Status Codes', 'HTTP', '200', '201', '404', '500', 'API Testing', 'REST'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the HEAD HTTP method and when do you use it?',
  'what-is-head-http-method',
  'HEAD is identical to GET but returns only headers without a response body, useful for checking resource metadata.',
  $$## HEAD Method

The **HEAD** method asks for a response identical to a GET request, but **without the response body**.

## Use Cases

- **Check if a resource exists** without downloading it
- **Get metadata** (Content-Type, Content-Length, Last-Modified) without the actual content
- **Performance optimization** — verify headers before making full GET
- **Link validation** — check URLs are alive without fetching full pages

## Example

```
HEAD /api/files/large-document.pdf HTTP/1.1
Host: api.example.com

Response:
HTTP/1.1 200 OK
Content-Type: application/pdf
Content-Length: 2097152
Last-Modified: Thu, 19 Jun 2026 10:00:00 GMT
```

No body is returned — just the headers.

## In Rest Assured

```java
Response response = given()
    .when()
    .head("https://api.example.com/users/1");

assertEquals(response.getStatusCode(), 200);
// response.getBody() will be empty
```

## HEAD vs GET

| Feature | HEAD | GET |
|---------|------|-----|
| Returns headers | Yes | Yes |
| Returns body | **No** | Yes |
| Use for metadata | Yes | Possible but inefficient |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['HEAD', 'HTTP Methods', 'API Testing', 'REST Assured'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the OPTIONS HTTP method and what purpose does it serve for RESTful web services?',
  'what-is-options-http-method-restful-services',
  'OPTIONS returns all HTTP methods supported by a server for a specific URL, useful for CORS preflight and endpoint discovery.',
  $$## OPTIONS Method

The **OPTIONS** method returns the **HTTP methods that the server supports** for the specified URL. It creates read-only requests to the server.

## Primary Uses

### 1. Discover Allowed Methods
```
OPTIONS /api/users HTTP/1.1
Host: api.example.com

Response:
Allow: GET, POST, OPTIONS
```

### 2. CORS Preflight Requests
Browsers automatically send OPTIONS before cross-origin requests to check if the server allows the actual request method:

```
OPTIONS /api/data HTTP/1.1
Origin: https://myfrontend.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type

Response:
Access-Control-Allow-Origin: https://myfrontend.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type
```

## Tip for API Testers

> Always use **OPTIONS** to cross-check what methods are allowed before testing endpoints. This helps avoid 405 Method Not Allowed errors.

## In Rest Assured

```java
Response response = given()
    .when()
    .options("https://api.example.com/users");

System.out.println(response.getHeader("Allow"));
// Output: GET, POST, OPTIONS
```$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['OPTIONS', 'HTTP Methods', 'CORS', 'REST Assured', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is HTTP vs HTTPS and what are the key differences?',
  'http-vs-https-key-differences',
  'HTTPS is a secure version of HTTP that uses SSL/TLS encryption, port 443, and requires SSL certificates.',
  $$## HTTP vs HTTPS

| Feature | HTTP | HTTPS |
|---------|------|-------|
| Full form | HyperText Transfer Protocol | HyperText Transfer Protocol **Secure** |
| URL prefix | `http://` | `https://` |
| Port | **80** | **443** |
| Security | Unsecured | **Secured** |
| Layer | Application Layer | Transport Layer (SSL/TLS) |
| Encryption | Absent | Present (SSL/TLS) |
| Certificates | Not required | Requires **SSL Certificate** |
| Data integrity | Can be tampered | Protected from tampering |

## Why HTTPS Matters in API Testing

- Ensures data transmitted between client and server is **encrypted**
- Prevents **man-in-the-middle attacks**
- Required for APIs handling sensitive data (auth tokens, passwords, PII)
- Modern APIs should **always** use HTTPS

## Practical Implication in Rest Assured

```java
// HTTPS API call — Rest Assured handles SSL by default
Response response = given()
    .relaxedHTTPSValidation() // bypass SSL cert verification in test env
    .when()
    .get("https://api.example.com/users");
```

## In Interviews

- APIs in production should always use HTTPS
- If testing against a self-signed cert environment, use `relaxedHTTPSValidation()`
- HTTP is only acceptable in local development$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['HTTP', 'HTTPS', 'SSL', 'Security', 'API Testing', 'Encryption'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is REST and what are its key principles?',
  'what-is-rest-and-key-principles',
  'REST is an architectural style for web services that uses HTTP methods and stateless communication to access resources.',
  $$## What is REST?

**REST** stands for **Representational State Transfer**. It is an architectural style for developing web services that:

- Exploits the ubiquity of the **HTTP protocol**
- Uses HTTP methods to define actions
- Revolves around **resources** — every component is a resource that can be accessed through a shared interface

## REST Architecture

- **REST Server** provides access to resources
- **REST Client** accesses and modifies those resources
- Each resource is identified by **URIs (Uniform Resource Identifiers)** or global IDs
- Resources can be represented in **text, JSON, or XML**

## 6 REST Constraints (Principles)

| Principle | Description |
|-----------|-------------|
| **Stateless** | Each request contains all info needed; server stores no session state |
| **Client-Server** | Client and server are independent and separated |
| **Cacheable** | Responses must be labeled cacheable or non-cacheable |
| **Uniform Interface** | Consistent way to interact with resources |
| **Layered System** | Client can't tell if connected directly to server or middleware |
| **Code on Demand** | (Optional) Server can send executable code to client |

## Statelessness Explained

The client and server **don't store information** about each other's state. Since the server stores no information, it treats each request as a **new request**.

- The client request must contain **all information required** for the server to process it
- Client application is responsible for storing **session state**$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['REST', 'API', 'Architecture', 'Stateless', 'HTTP', 'REST Principles'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is idempotency in API and how does it apply to HTTP methods?',
  'what-is-idempotency-in-api',
  'Idempotency means calling an API operation multiple times produces the same result as calling it once.',
  $$## Idempotency in API

**Idempotency** refers to the property of an operation where applying the operation **multiple times has the same effect as applying it once**.

In API testing, idempotent methods ensure that performing the same request multiple times will **not produce different outcomes** beyond the initial request''s effect.

## Idempotency by HTTP Method

| Method | Idempotent | Example |
|--------|-----------|---------|
| **GET** | Yes | Retrieving user info — same result every time |
| **POST** | **No** | Creating a user — creates a new record each time |
| **PUT** | Yes | Updating user info — same final state regardless |
| **PATCH** | **No** | Partial update — result may vary based on current state |
| **DELETE** | Yes | Deleting a user — resource deleted, subsequent calls have no effect |

## Examples

### GET — Idempotent: Yes
```
GET /api/users/123
```
Returns the same user data regardless of how many times called.

### POST — Idempotent: No
```
POST /api/users
{ "name": "John" }
```
Each call creates a NEW user profile with a different ID.

### PUT — Idempotent: Yes
```
PUT /api/users/123
{ "name": "Updated John" }
```
Repeating this always results in the same final state.

### DELETE — Idempotent: Yes
```
DELETE /api/users/123
```
First call deletes the user. Subsequent calls return 404 — no additional effect.

## Why This Matters

In case of **network failures** during API requests, idempotent methods ensure that retrying the request does **not** lead to unintended consequences such as duplicate resource creation or data corruption.$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Idempotency', 'HTTP Methods', 'REST', 'API Testing', 'GET', 'POST', 'PUT', 'DELETE'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the disadvantages of REST API?',
  'disadvantages-of-rest-api',
  'REST API drawbacks include no enforced security, synchronous limitations, statelessness challenges, and lack of standardization.',
  $$## Disadvantages of REST API

### 1. Doesn''t Enforce Security Practices
REST has no built-in security standard. Security must be implemented separately:
- No native encryption (must use HTTPS)
- No built-in authentication (must add OAuth, JWT, API keys manually)
- No message-level security (unlike SOAP which has WS-Security)

### 2. HTTP Method Limits You to Synchronous Requests
- REST is synchronous by nature — client waits for the server response
- Not ideal for long-running operations
- For async needs, you must implement polling, webhooks, or use WebSockets separately

### 3. Statelessness Can Be a Challenge
- Due to statelessness, you might be unable to maintain state (e.g., in sessions)
- Each request must carry full authentication info
- More data transmitted per request (no server-side session caching)

### 4. Over-fetching and Under-fetching
- **Over-fetching:** REST returns all fields even when only a few are needed
- **Under-fetching:** May require multiple API calls to get related data (GraphQL solves this)

### 5. Lack of Strict Standardization
- Unlike SOAP (which has strict WSDL contracts), REST has no enforced contract
- Different teams may implement REST differently, leading to inconsistency

### 6. File Transfer Limitations
- REST is not ideal for streaming large files or binary data
- Better alternatives exist for high-volume file transfers$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['REST', 'API', 'Disadvantages', 'Security', 'Stateless', 'SOAP vs REST'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the major drawback of using SOAP?',
  'major-drawback-of-using-soap',
  'SOAP''s biggest obstacle is the firewall security mechanism that blocks specific ports, and it mixes transport spec with message structure spec.',
  $$## Major Drawback of SOAP

When using SOAP, the **firewall security mechanism** is the biggest obstacle.

## Key Issues

### 1. Firewall Port Blocking
SOAP works over HTTP port 80 and uses its own port. Firewalls often block all ports leaving only a few like HTTP port 80 open.

The HTTP port used by SOAP can **bypass the firewall** — this is a security concern that many organizations block by restricting SOAP traffic.

### 2. Mixed Concerns
The technical complaint against SOAP is that it **mixes the specification for message transport with the specification for message structure**. This tight coupling makes the protocol more complex.

### 3. Other SOAP Disadvantages

| Issue | Detail |
|-------|--------|
| **Verbose** | XML-based, much larger payload than REST JSON |
| **Slow** | XML parsing is computationally expensive |
| **Complex** | Requires WSDL, strict schema, envelope structure |
| **Limited browser support** | REST is native to browsers; SOAP is not |
| **Less flexible** | REST supports JSON, XML, HTML; SOAP is XML-only |

## SOAP vs REST Summary

| Feature | SOAP | REST |
|---------|------|------|
| Format | XML only | JSON, XML, HTML, plain text |
| Speed | Slower | Faster |
| Standards | Strict (WSDL) | Flexible |
| Security built-in | WS-Security | Relies on HTTPS/OAuth |
| Browser-friendly | No | Yes |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['SOAP', 'REST', 'Comparison', 'Firewall', 'XML', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Explain path parameter vs query parameter vs form parameter in REST API',
  'path-parameter-vs-query-parameter-vs-form-parameter',
  'Path params identify a specific resource in the URL, query params filter/sort data, and form params send form data in the request body.',
  $$## Types of API Parameters

### 1. Path Parameter
Used to **identify a specific resource** in the URL path. Specified in the URL and preceded by a colon `:`.

**Example:**
```
GET /users/:id    →   GET /users/123
```

**Rest Assured Code:**
```java
int userId = 123;
given()
    .pathParam("id", userId)
    .when()
    .get("/users/{id}")
    .then()
    .statusCode(200);
```

---

### 2. Query Parameter
Used to **filter or sort data**. Specified in the URL query string, separated by `&`.

**Example:**
```
GET /users?gender=female
GET /products?category=electronics&price=500
```

**Rest Assured Code:**
```java
given()
    .queryParam("gender", "female")
    .when()
    .get("https://api.example.com/users")
    .then()
    .statusCode(200);
```

---

### 3. Form Parameter
Used to **send form data** in the request body (like HTML form submissions). Content-Type is typically `application/x-www-form-urlencoded`.

**Example:**
```
POST /login
Content-Type: application/x-www-form-urlencoded
username=john&password=secret
```

**Rest Assured Code:**
```java
given()
    .contentType("application/x-www-form-urlencoded")
    .formParam("username", "john")
    .formParam("password", "secret")
    .when()
    .post("/login")
    .then()
    .statusCode(200);
```

## Quick Comparison

| Type | Location | Use Case |
|------|----------|---------|
| **Path Param** | URL path `/users/{id}` | Identify specific resource |
| **Query Param** | URL query `?key=value` | Filter, sort, paginate |
| **Form Param** | Request body (form-encoded) | Submit form data |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Path Parameter', 'Query Parameter', 'Form Parameter', 'REST Assured', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you validate query parameters in API testing?',
  'how-to-validate-query-parameters-api-testing',
  'Validate query parameters by checking presence, type, range/format, and that invalid values return proper error messages.',
  $$## Validating Query Parameters in API Testing

Query parameters are **key-value pairs** appended to a URL after `?`, separated by `&` for multiple parameters.

**Example URL:**
```
https://api.example.com/products?category=electronics&price=500
```

Here `category` and `price` are query parameters.

## Validation Checklist

### 1. Presence Check
Ensure mandatory parameters are present in the request.

```java
// Test missing required query param
given()
    .when()
    .get("/products")  // missing 'category'
    .then()
    .statusCode(400)
    .body("error", equalTo("category is required"));
```

### 2. Type Check
Ensure the parameter''s type matches expectations (e.g., `price` must be a number).

```java
given()
    .queryParam("price", "not-a-number")
    .when()
    .get("/products")
    .then()
    .statusCode(400);
```

### 3. Range or Format Check
Check if value fits within an acceptable range or format.

```java
given()
    .queryParam("price", -100)  // negative price
    .when()
    .get("/products")
    .then()
    .statusCode(400)
    .body("error", equalTo("Price must be a positive number"));
```

### 4. Special Characters and Edge Cases
Test with empty values, spaces, and special characters.

```java
given()
    .queryParam("category", "")
    .when()
    .get("/products")
    .then()
    .statusCode(400);
```

## Important Note
If any parameter fails validation, the API should respond with a clear error message. For example, if `price` is negative: **"Price must be a positive number."**$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Query Parameters', 'Validation', 'API Testing', 'REST Assured', 'Test Cases'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to automate GET method and validate status code using Rest Assured?',
  'automate-get-method-validate-status-code-rest-assured',
  'Use given().when().get(url) and then assertEquals(response.getStatusCode(), 200) to validate GET request status.',
  $$## Automate GET Method in Rest Assured

### Basic GET and Status Code Validation

```java
import io.restassured.RestAssured;
import io.restassured.response.Response;
import static io.restassured.RestAssured.*;
import static org.testng.Assert.*;

public class ApiTest {

    @Test(description = "Verify status code for GET method")
    public static void verifyStatusCodeGET() {

        Response resp = given()
                            .when()
                            .get("https://reqres.in/api/users/2");

        assertEquals(resp.getStatusCode(), 200);
    }
}
```

### Fluent Style (BDD Syntax)

```java
@Test
public void verifyGetStatusCode() {
    given()
        .when()
        .get("https://reqres.in/api/users/2")
        .then()
        .statusCode(200);
}
```

### With Base URI Setup

```java
@BeforeClass
public void setup() {
    RestAssured.baseURI = "https://reqres.in";
}

@Test
public void getUser() {
    given()
        .when()
        .get("/api/users/2")
        .then()
        .statusCode(200)
        .log().all();
}
```

## Key Methods

| Method | Purpose |
|--------|---------|
| `given()` | Sets up request specification |
| `when()` | Triggers the HTTP action |
| `get(url)` | Sends GET request |
| `getStatusCode()` | Returns the HTTP status code |
| `.then().statusCode(200)` | BDD-style status assertion |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['GET', 'Rest Assured', 'Status Code', 'Automation', 'TestNG', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to automate GET method and fetch/validate response body using Rest Assured?',
  'automate-get-method-fetch-validate-response-body-rest-assured',
  'Use resp.getBody().asString() to fetch the response body and resp.path("fieldName") to extract and validate specific values.',
  $$## Fetch and Validate Response Body in Rest Assured

### Fetch Entire Response Body

```java
@Test(description = "Automate GET method and fetch response body")
public static void verifyResponseBody() {

    Response resp = given()
                        .when()
                        .get("https://reqres.in/api/users/2");

    assertEquals(resp.getBody().asString(), 200); // Note: getBody() returns body as String
    System.out.println(resp.getBody().asString());
}
```

### Validate Specific Field Value from Response Body

```java
@Test(description = "Verify value from response body - validate total pages = 12")
public static void verifyValueFromResponseBody() {

    Response resp = given()
                        .when()
                        .get("https://reqres.in/api/users");

    System.out.println(resp.path("total").toString());

    assertEquals(resp.getStatusCode(), 200);
    assertEquals(resp.path("total").toString(), "12");
}
```

### Using JsonPath to Extract Values

```java
@Test
public void extractNestedValue() {
    Response resp = given()
                        .when()
                        .get("https://reqres.in/api/users/2");

    // Extract nested field: data.first_name
    String firstName = resp.jsonPath().getString("data.first_name");
    System.out.println("First Name: " + firstName);
    assertEquals(firstName, "Janet");
}
```

### BDD Style with Body Assertions

```java
given()
    .when()
    .get("https://reqres.in/api/users")
    .then()
    .statusCode(200)
    .body("total", equalTo(12))
    .body("page", equalTo(1))
    .body("data[0].email", containsString("@reqres.in"));
```

## Key Methods for Response Body

| Method | Use Case |
|--------|---------|
| `resp.getBody().asString()` | Entire body as String |
| `resp.path("key")` | Extract top-level JSON field |
| `resp.jsonPath().getString("nested.key")` | Extract nested field |
| `.body("key", equalTo(value))` | BDD assertion on field |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['GET', 'Rest Assured', 'Response Body', 'JsonPath', 'Assertions', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to pass a query parameter with GET method in Rest Assured?',
  'pass-query-parameter-get-method-rest-assured',
  'Use .queryParam("key", "value") in Rest Assured to pass query parameters with GET requests.',
  $$## Passing Query Parameters in Rest Assured

Query parameters are key-value pairs appended to a URL (`?key=value`). They are optional URL extensions used to filter or paginate data.

### Method 1: Using queryParam()

```java
@Test
public void validateQueryParamInGiven() {

    Response resp = given()
                        .queryParam("page", "2")
                        .when()
                        .get("https://reqres.in/api/users");

    assertEquals(resp.getStatusCode(), 200);
    System.out.println(resp.getBody().asString());
}
```

### Method 2: Multiple Query Params

```java
@Test
public void multipleQueryParams() {

    Response resp = given()
                        .queryParam("page", "1")
                        .queryParam("per_page", "5")
                        .when()
                        .get("https://reqres.in/api/users");

    assertEquals(resp.getStatusCode(), 200);
    assertEquals(resp.path("per_page").toString(), "5");
}
```

### Method 3: Using params() Map

```java
@Test
public void queryParamsWithMap() {

    Map<String, Object> params = new HashMap<>();
    params.put("page", 2);
    params.put("per_page", 10);

    Response resp = given()
                        .params(params)
                        .when()
                        .get("https://reqres.in/api/users");

    assertEquals(resp.getStatusCode(), 200);
}
```

### BDD Style

```java
given()
    .queryParam("gender", "female")
    .when()
    .get("https://api.example.com/users")
    .then()
    .statusCode(200)
    .body("data.size()", greaterThan(0));
```

## Notes

- `queryParam()` automatically encodes special characters
- Multiple params can be chained: `.queryParam("a", 1).queryParam("b", 2)`
- Resulting URL: `https://reqres.in/api/users?page=2&per_page=10`$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Query Parameters', 'GET', 'Rest Assured', 'queryParam', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to pass headers in a GET request using Rest Assured?',
  'pass-headers-get-request-rest-assured',
  'Use .header("key", "value") or .headers() in Rest Assured to pass HTTP headers with any request.',
  $$## Passing Headers in Rest Assured

HTTP headers carry metadata about the request — Content-Type, Authorization, Accept, custom headers, etc.

### Single Header

```java
@Test
public void validateGivenHeader() {

    Response resp = given()
                        .header("Content-Type", "application/json")
                        .when()
                        .get("https://gorest.co.in/public-api/users");

    assertEquals(resp.getStatusCode(), 200);
    System.out.println(resp.getBody().asString());
}
```

### Multiple Headers

```java
@Test
public void multipleHeaders() {

    Response resp = given()
                        .header("Content-Type", "application/json")
                        .header("Accept", "application/json")
                        .header("Authorization", "Bearer your-token-here")
                        .when()
                        .get("https://api.example.com/users");

    assertEquals(resp.getStatusCode(), 200);
}
```

### Using Headers Object

```java
@Test
public void headersObject() {

    Headers headers = new Headers(
        new Header("Content-Type", "application/json"),
        new Header("Authorization", "Bearer token123")
    );

    given()
        .headers(headers)
        .when()
        .get("https://api.example.com/users")
        .then()
        .statusCode(200);
}
```

### Validate Response Headers

```java
@Test
public void validateResponseHeaders() {

    Response response = RestAssured.get("/endpoint");
    Headers headers = response.getHeaders();

    Header contentType = headers.get("Content-Type");
    if (contentType != null) {
        assert contentType.getValue().equals("application/json")
            : "Content-Type is not application/json";
    } else {
        throw new AssertionError("Content-Type header is missing");
    }
}
```

## Common Headers

| Header | Purpose |
|--------|---------|
| `Content-Type` | Format of the request body |
| `Accept` | Expected response format |
| `Authorization` | Bearer token / API key |
| `X-API-Key` | Custom API key |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Headers', 'GET', 'Rest Assured', 'Content-Type', 'Authorization', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to automate the POST method in Rest Assured?',
  'automate-post-method-rest-assured',
  'Use given().header().body().when().post(url) to send POST requests and validate status 201 in Rest Assured.',
  $$## Automating POST Method in Rest Assured

POST requests are used to **send data to the API server to create or update a resource**. The data sent is stored in the request body of the HTTP request.

### Method 1: POST with JSON Body from File

```java
@Test(description = "Automate POST method and validate response")
public void methodValidationPOST() throws IOException, ParseException {

    FileInputStream file = new FileInputStream(
        new File(System.getProperty("user.dir") + "\\TestData\\post.json")
    );

    Response resp = given()
                        .header("Content-Type", "application/json")
                        .body(IOUtils.toString(file, "UTF-8"))
                        .when()
                        .post("https://reqres.in/api/users");

    assertEquals(resp.getStatusCode(), 201);
    assertEquals(resp.path("job"), "tester");
}
```

### Method 2: POST with Inline JSON String

```java
@Test
public void postWithInlineBody() {

    String requestBody = "{ \"name\": \"John\", \"job\": \"QA Engineer\" }";

    given()
        .contentType(ContentType.JSON)
        .body(requestBody)
        .when()
        .post("https://reqres.in/api/users")
        .then()
        .statusCode(201)
        .body("name", equalTo("John"))
        .body("job", equalTo("QA Engineer"));
}
```

### Method 3: POST with POJO (Object Serialization)

```java
// POJO class
public class User {
    private String name;
    private String job;
    // getters/setters
}

@Test
public void postWithPOJO() {
    User user = new User();
    user.setName("Jane");
    user.setJob("SDET");

    given()
        .contentType(ContentType.JSON)
        .body(user)  // serialized to JSON automatically
        .when()
        .post("https://reqres.in/api/users")
        .then()
        .statusCode(201);
}
```

## POST vs GET

| Feature | POST | GET |
|---------|------|-----|
| Purpose | Create resource | Retrieve resource |
| Body | Has request body | No body |
| Status on success | 201 Created | 200 OK |
| Idempotent | No | Yes |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['POST', 'Rest Assured', 'API Automation', 'Request Body', 'JSON', 'TestNG'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to automate the PUT method in Rest Assured?',
  'automate-put-method-rest-assured',
  'Use given().header().body().when().put(url) to send PUT requests and validate status 200 in Rest Assured.',
  $$## Automating PUT Method in Rest Assured

A **PUT** method puts or places a file or resource precisely at a specific URI. In case a file or resource already exists at that URI, PUT replaces it. If there is no file or resource, PUT creates a new one.

### PUT with JSON Body from File

```java
@Test(description = "Automate PUT method and validate response")
public void methodValidationPUT() throws IOException, ParseException {

    FileInputStream file = new FileInputStream(
        new File(System.getProperty("user.dir") + "\\TestData\\put.json")
    );

    Response resp = given()
                        .header("Content-Type", "application/json")
                        .body(IOUtils.toString(file, "UTF-8"))
                        .when()
                        .put("https://reqres.in/api/users/2");

    assertEquals(resp.getStatusCode(), 200);
    assertEquals(resp.path("job"), "tester");
}
```

### PUT with Inline JSON

```java
@Test
public void updateUserPUT() {

    String requestBody = "{ \"name\": \"Updated John\", \"job\": \"Senior QA\" }";

    given()
        .contentType(ContentType.JSON)
        .body(requestBody)
        .when()
        .put("https://reqres.in/api/users/2")
        .then()
        .statusCode(200)
        .body("name", equalTo("Updated John"))
        .body("job", equalTo("Senior QA"));
}
```

### PUT with Path Parameter

```java
@Test
public void putWithPathParam() {
    int userId = 2;
    String body = "{ \"name\": \"Jane\", \"job\": \"SDET\" }";

    given()
        .contentType(ContentType.JSON)
        .pathParam("id", userId)
        .body(body)
        .when()
        .put("/api/users/{id}")
        .then()
        .statusCode(200);
}
```

## PUT vs PATCH

| Feature | PUT | PATCH |
|---------|-----|-------|
| Updates | **Entire resource** | Partial fields only |
| Idempotent | Yes | No |
| Missing fields | Set to null/default | Left unchanged |
| Status on success | 200 OK | 200 OK |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['PUT', 'Rest Assured', 'API Automation', 'Update', 'Idempotent', 'TestNG'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to automate the PATCH method in Rest Assured?',
  'automate-patch-method-rest-assured',
  'Use given().header().body().when().patch(url) to send PATCH requests for partial resource updates.',
  $$## Automating PATCH Method in Rest Assured

The **HTTP PATCH** method is used when a resource needs to be **partially updated**. This method is especially useful if a resource is large and the changes being made are small.

### PATCH with JSON Body from File

```java
@Test(description = "Automate PATCH method and validate response")
public void methodValidationPATCH() throws IOException, ParseException {

    FileInputStream file = new FileInputStream(
        new File(System.getProperty("user.dir") + "\\TestData\\put.json")
    );

    Response resp = given()
                        .header("Content-Type", "application/json")
                        .body(IOUtils.toString(file, "UTF-8"))
                        .when()
                        .patch("https://reqres.in/api/users/2");

    assertEquals(resp.getStatusCode(), 200);
    assertEquals(resp.path("job"), "tester");
}
```

### PATCH with Inline JSON (Partial Update)

```java
@Test
public void partialUpdateWithPATCH() {

    // Only updating the job field, not the name
    String partialBody = "{ \"job\": \"Lead SDET\" }";

    given()
        .contentType(ContentType.JSON)
        .body(partialBody)
        .when()
        .patch("https://reqres.in/api/users/2")
        .then()
        .statusCode(200)
        .body("job", equalTo("Lead SDET"));
}
```

### BDD Style PATCH

```java
given()
    .contentType(ContentType.JSON)
    .body("{ \"status\": \"active\" }")
    .when()
    .patch("/api/users/5")
    .then()
    .statusCode(200)
    .body("status", equalTo("active"))
    .body("updatedAt", notNullValue());
```

## PATCH vs PUT

| Feature | PATCH | PUT |
|---------|-------|-----|
| Updates | **Partial fields** | Entire resource |
| Idempotent | No | Yes |
| Payload size | Small (only changed fields) | Full resource |
| Missing fields | Unchanged | Set to null/default |

## When to Use PATCH
- Updating a user''s profile picture only
- Changing an order status only
- Toggling a feature flag$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['PATCH', 'Rest Assured', 'API Automation', 'Partial Update', 'HTTP Methods'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle authentication types in Rest Assured — Basic, Preemptive, Digest, OAuth?',
  'authentication-types-rest-assured-basic-preemptive-digest-oauth',
  'Rest Assured supports basic, preemptive, digest, OAuth, and OAuth2 authentication via the .auth() chain.',
  $$## Authentication in Rest Assured

Rest Assured supports multiple authentication types through the `.auth()` method chain.

### 1. Basic Authentication

```java
Response resp = given()
                    .auth()
                    .basic("username", "password")
                    .when()
                    .get("https://reqres.in/api/users/2");

assertEquals(resp.getStatusCode(), 200);
```

### 2. Pre-emptive Authentication
Sends credentials with the FIRST request (without waiting for 401 challenge):

```java
Response resp1 = given()
                     .auth()
                     .preemptive()
                     .basic("username", "password")
                     .when()
                     .get("https://reqres.in/api/users/2");
```

### 3. Digest Authentication
Digest auth hashes credentials before sending:

```java
Response resp2 = given()
                     .auth()
                     .digest("username", "password")
                     .when()
                     .get("https://reqres.in/api/users/2");
```

### 4. OAuth Authentication

```java
Response resp3 = given()
                     .auth()
                     .oauth("consumerKey", "consumerSecret",
                            "accessToken", "secretToken")
                     .when()
                     .get("https://reqres.in/api/users/2");
```

### 5. OAuth2 Authentication

```java
Response resp4 = given()
                     .auth()
                     .oauth2("your-access-token")
                     .when()
                     .get("https://reqres.in/api/users/2");
```

### 6. Header-Based Authorization (OAuth2)

```java
Response resp5 = given()
                     .header("Authorization", "Bearer your-access-token")
                     .when()
                     .get("https://reqres.in/api/users/2");
```

## Summary

| Auth Type | Method | When to Use |
|-----------|--------|-------------|
| Basic | `.auth().basic(u, p)` | Simple username/password |
| Preemptive | `.auth().preemptive().basic(u, p)` | Avoid round-trip 401 challenge |
| Digest | `.auth().digest(u, p)` | Hashed credentials |
| OAuth 1.0 | `.auth().oauth(...)` | Legacy OAuth |
| OAuth 2.0 | `.auth().oauth2(token)` | Modern APIs with Bearer tokens |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Authentication', 'Basic Auth', 'OAuth', 'OAuth2', 'Digest', 'Rest Assured', 'API Security'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is serialization and deserialization in API test automation?',
  'serialization-deserialization-api-test-automation',
  'Serialization converts Java objects to JSON for sending; deserialization converts JSON responses back to Java objects.',
  $$## Serialization and Deserialization in API Testing

In the context of API testing, these terms refer to **converting Java objects into JSON (or XML) format and vice versa**. This is essential when sending and receiving data to and from APIs, as most APIs use JSON or XML as their data format.

## Serialization
Converting a **Java object → JSON string** (for sending in the request body)

## Deserialization
Converting a **JSON string → Java object** (for reading and asserting the response)

## Example Scenario

Consider an API with these endpoints:
- `POST /api/person` — create a new person
- `GET /api/person/{id}` — retrieve a person''s details

### Step 1: Create POJO Class

```java
public class Person {
    private String name;
    private int age;

    public Person() { }

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Getters and Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}
```

### Step 2: POST Request with Serialization

```java
public class ApiTest {

    @BeforeClass
    public void setup() {
        RestAssured.baseURI = "http://example.com/api";
    }

    @Test
    public void testCreatePerson() {
        Person person = new Person("John Doe", 30);

        Response response = given()
                                .contentType(ContentType.JSON)
                                .body(person)  // ← Serialization happens here
                                .when()
                                .post("/person");

        assertEquals(response.getStatusCode(), 201);
    }
}
```

In `testCreatePerson`, the `Person` object is converted into a JSON string using the **Jackson library** (handled internally by REST Assured) when passed to `.body()`.

### Step 3: GET Request with Deserialization

```java
    @Test
    public void testGetPerson() {
        Response response = given()
                                .when()
                                .get("/person/1");

        assertEquals(response.getStatusCode(), 200);

        Person person = response.as(Person.class);  // ← Deserialization happens here

        assertEquals(person.getName(), "John Doe");
        assertEquals(person.getAge(), 30);
    }
```

In `testGetPerson`, the JSON response is converted back into a `Person` object using `.as(Person.class)`.

## Jackson Library Requirement

Add to `pom.xml`:
```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.15.0</version>
</dependency>
```$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Serialization', 'Deserialization', 'POJO', 'Jackson', 'Rest Assured', 'API Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is API chaining and how do you implement it with Rest Assured?',
  'api-chaining-rest-assured-implementation',
  'API chaining makes multiple API requests in sequence where each response''s data is used as input for the next request.',
  $$## API Chaining in Rest Assured

**API chaining** is a technique to make multiple API requests in a sequence, where **each request''s response becomes the basis for the next request**. This is often used to test scenarios that involve multiple API endpoints or dependent operations.

## Example Scenario

Let''s chain these operations:
1. Create a user (POST)
2. Retrieve the created user''s details (GET)
3. Update the user''s information (PUT)
4. Verify the updated details (GET)

```java
import io.restassured.RestAssured;
import io.restassured.response.Response;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class ApiChainingExample {

    private static String baseURL = "https://reqres.in/api";

    @Test
    public void testApiChaining() {

        // Step 1: Create a user — extract the response JSON to get the user ID
        String createUserResponse = given()
                .contentType(ContentType.JSON)
                .body("{ \"name\": \"John\", \"email\": \"john@example.com\" }")
                .when()
                .post(baseURL + "/users")
                .then()
                .statusCode(201)
                .extract()
                .response()
                .asString();

        System.out.println("Create Response: " + createUserResponse);

        // Step 2: Extract the user ID from the creation response
        String userId = RestAssured
                .given()
                .when()
                .get(baseURL + "/users/{userId}", createUserResponse)
                .then()
                .statusCode(200)
                .extract()
                .path("id");

        System.out.println("User ID: " + userId);

        // Step 3: Update the user''s information using the extracted ID
        RestAssured.given()
                .contentType(ContentType.JSON)
                .body("{ \"name\": \"Updated John\", \"email\": \"updated_john@example.com\" }")
                .when()
                .put(baseURL + "/users/{userId}", userId)
                .then()
                .statusCode(200);

        // Step 4: Verify the updated user details
        RestAssured.given()
                .when()
                .get(baseURL + "/users/{userId}", userId)
                .then()
                .statusCode(200)
                .assertThat()
                .body("name", equalTo("Updated John"))
                .body("email", equalTo("updated_john@example.com"));
    }
}
```

## Key Points

- Use `.extract().path("fieldName")` to extract a specific value from the response
- Use `.extract().response().asString()` to get the full response body
- Chain requests by passing extracted values as path parameters or body fields
- Real-world examples: login → get token → use token for subsequent requests$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['API Chaining', 'Rest Assured', 'Extract', 'Test Design', 'API Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to validate headers in API response using Rest Assured?',
  'validate-response-headers-rest-assured',
  'Use response.getHeaders() or .header("key") to extract and validate API response headers in Rest Assured.',
  $$## Validate Response Headers in Rest Assured

### Method 1: Extract and Validate Programmatically

```java
import io.restassured.RestAssured;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.response.Response;

public class HeaderValidationTest {

    public static void main(String[] args) {

        // Set the base URI
        RestAssured.baseURI = "https://api.example.com";

        // Send a GET request to the endpoint
        Response response = RestAssured.get("/endpoint");

        // Extract headers from the response
        Headers headers = response.getHeaders();

        // Validate Content-Type Header
        Header contentType = headers.get("Content-Type");
        if (contentType != null) {
            assert contentType.getValue().equals("application/json")
                : "Content-Type is not application/json";
        } else {
            throw new AssertionError("Content-Type header is missing");
        }

        // Validate Custom Header
        Header customHeader = headers.get("X-Custom-Header");
        if (customHeader != null) {
            assert customHeader.getValue().equals("ExpectedValue")
                : "X-Custom-Header does not have the expected value";
        } else {
            throw new AssertionError("X-Custom-Header is missing");
        }

        System.out.println("All headers are valid");
    }
}
```

### Method 2: BDD Style Header Assertions

```java
given()
    .when()
    .get("https://api.example.com/users")
    .then()
    .statusCode(200)
    .header("Content-Type", containsString("application/json"))
    .header("X-Rate-Limit", notNullValue())
    .header("Cache-Control", equalTo("no-cache"));
```

### Method 3: Print All Response Headers

```java
Response response = given().when().get("/api/users");

// Print all headers
response.getHeaders().forEach(header -> {
    System.out.println(header.getName() + ": " + header.getValue());
});
```

## Header Validation Steps

1. **Extract** response headers with `response.getHeaders()`
2. **Get specific header** with `headers.get("Header-Name")`
3. **Check presence** — if `null`, throw assertion error
4. **Validate value** — compare with expected using `getValue().equals(...)`

## Common Response Headers to Validate

| Header | Expected Value |
|--------|---------------|
| `Content-Type` | `application/json` |
| `Cache-Control` | `no-cache` or `max-age=3600` |
| `Authorization` | Token present |
| `X-Rate-Limit-Remaining` | Number > 0 |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Headers', 'Response Validation', 'Rest Assured', 'Content-Type', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are 4xx status codes and how do you test them in API projects?',
  '4xx-status-codes-testing-api-projects',
  '4xx errors are client-side errors. Test 400 (bad request), 401 (unauthorized), 403 (forbidden), 404 (not found), and 405 (method not allowed).',
  $$## Testing 4xx Status Codes in API Projects

In API testing, it''s not sufficient to only test success scenarios. We also need to test **client-side errors (4xx)** effectively.

## 400 Bad Request
**When:** Request is malformed or missing required fields.

```
POST /api/orders
Content-Type: application/json
{ "product": "12345" }   // Missing: customer, quantity

Response: 400 Bad Request
{ "error": "Missing required fields: ''customer'', ''quantity''" }
```

```java
given()
    .body("{ \"product\": \"12345\" }")
    .contentType(ContentType.JSON)
    .when()
    .post("/api/orders")
    .then()
    .statusCode(400)
    .body("error", containsString("Missing required fields"));
```

## 401 Unauthorized
**When:** Missing or invalid authentication token.

```
GET /api/profile
// No Authorization header

Response: 401 Unauthorized
{ "error": "Invalid credentials" }
```

```java
given()
    .when()
    .get("/api/profile")  // no auth header
    .then()
    .statusCode(401);
```

## 403 Forbidden
**When:** Authenticated but lacks permission for the resource.

```
DELETE /api/users/123
Authorization: Bearer <normal-user-token>

Response: 403 Forbidden
{ "error": "Insufficient permissions to delete user" }
```

```java
given()
    .header("Authorization", "Bearer normal-user-token")
    .when()
    .delete("/api/users/123")
    .then()
    .statusCode(403)
    .body("error", containsString("Insufficient permissions"));
```

## 404 Not Found
**When:** Requested resource does not exist.

```
GET /api/users/999    // user 999 doesn't exist

Response: 404 Not Found
{ "error": "User not found" }
```

## 405 Method Not Allowed
**When:** Endpoint does not support the HTTP method used.

```
PUT /api/customers/123   // endpoint only allows GET and POST

Response: 405 Method Not Allowed
{ "error": "PUT method is not allowed for this endpoint" }
```

**Tip:** Always use OPTIONS to cross-check what methods are allowed before testing!

## 422 Unprocessable Entity
**When:** Request body is syntactically correct but semantically invalid (e.g., invalid email format, future birth date).

```java
given()
    .body("{ \"email\": \"not-an-email\" }")
    .contentType(ContentType.JSON)
    .when()
    .post("/api/users")
    .then()
    .statusCode(422)
    .body("error", containsString("Invalid email format"));
```$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['4xx', 'Status Codes', '400', '401', '403', '404', '405', 'API Testing', 'Negative Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to send a nested JSON object as payload in Rest Assured?',
  'nested-json-object-payload-rest-assured',
  'Use nested HashMap objects or nested POJO classes to construct and send complex nested JSON payloads in Rest Assured.',
  $$## Sending Nested JSON Payload in Rest Assured

### Method 1: Using HashMap (Most Common)

**Target JSON:**
```json
{
  "space": {
    "name": "myspace",
    "id": "bishnu"
  }
}
```

**Java Code:**
```java
import java.util.HashMap;

@Test
public void sendNestedJsonPayload() {

    HashMap<String, Object> mainObj = new HashMap<String, Object>();
    HashMap<String, String> subObj = new HashMap<String, String>();

    subObj.put("name", "QA");
    subObj.put("id", "bishnu");
    mainObj.put("space", subObj);

    Response resp = given()
                        .contentType(ContentType.JSON)
                        .body(mainObj)
                        .when()
                        .post("https://api.example.com/spaces");

    assertEquals(resp.getStatusCode(), 201);
}
```

### Method 2: Using POJO with Nested Class

```java
// Inner POJO
public class Space {
    private String name;
    private String id;
    // getters/setters
}

// Outer POJO
public class SpaceRequest {
    private Space space;
    // getters/setters
}

@Test
public void sendNestedWithPOJO() {
    Space space = new Space();
    space.setName("myspace");
    space.setId("bishnu");

    SpaceRequest request = new SpaceRequest();
    request.setSpace(space);

    given()
        .contentType(ContentType.JSON)
        .body(request)
        .when()
        .post("/api/spaces")
        .then()
        .statusCode(201);
}
```

### Method 3: Using JSONObject

```java
import org.json.JSONObject;

@Test
public void sendNestedWithJSONObject() {
    JSONObject subObj = new JSONObject();
    subObj.put("name", "myspace");
    subObj.put("id", "bishnu");

    JSONObject mainObj = new JSONObject();
    mainObj.put("space", subObj);

    given()
        .contentType(ContentType.JSON)
        .body(mainObj.toString())
        .when()
        .post("/api/spaces")
        .then()
        .statusCode(201);
}
```

### Method 4: Inline String

```java
String body = """
    {
        "space": {
            "name": "myspace",
            "id": "bishnu"
        }
    }
    """;

given().body(body).contentType(ContentType.JSON).when().post("/api/spaces").then().statusCode(201);
```$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['JSON Payload', 'Nested JSON', 'HashMap', 'POJO', 'Rest Assured', 'POST'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is JSON Schema and how do you validate it with Rest Assured?',
  'json-schema-validation-rest-assured',
  'JSON Schema defines the structure of JSON data. Use matchesJsonSchema() in Rest Assured to validate API responses against a schema.',
  $$## JSON Schema Validation with Rest Assured

## What is Schema?

A **Schema** is a JSON file that contains **only datatype information and expected keys** of the JSON. There are no values present in the schema.

JSON Schema is a JSON media type for **defining the structure of JSON data**. It provides a contract for:
- What JSON data is required for a given application
- How to interact with it
- Defines validation, documentation, and hyperlink navigation

## Why JSON Schema Validation?

JSON Schema Validation is required to **monitor API responses and ensure that the format** we are getting is the same as the expected one. It catches structural issues like:
- Missing required fields
- Wrong data types (e.g., integer returned instead of string)
- Extra unexpected fields

## How to Automate Schema Validation

### Step 1: Add Dependencies to pom.xml

```xml
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>json-schema-validator</artifactId>
    <version>5.3.0</version>
</dependency>
<dependency>
    <groupId>org.hamcrest</groupId>
    <artifactId>hamcrest-all</artifactId>
    <version>1.3</version>
</dependency>
```

### Step 2: Create the JSON Schema File

Create `src/test/resources/JsonSchema.json`:
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "data": {
      "type": "object",
      "properties": {
        "id": { "type": "integer" },
        "email": { "type": "string" },
        "first_name": { "type": "string" },
        "last_name": { "type": "string" }
      },
      "required": ["id", "email", "first_name", "last_name"]
    }
  },
  "required": ["data"]
}
```

### Step 3: Validate Using matchesJsonSchema

```java
import static io.restassured.module.jsv.JsonSchemaValidator.*;

@Test
public void givenUrl_validateSchema() throws FileNotFoundException, IOException {

    File schema = new File(System.getProperty("user.dir") + "/JsonSchema.json");

    RestAssured.given()
               .get("https://reqres.in/api/users/2")
               .then()
               .body(matchesJsonSchema(schema));
}
```

## Common Schema Validation Errors

| Error | What It Means |
|-------|--------------|
| `object has missing required properties` | API response is missing a field defined as required in schema |
| `instance type (integer) does not match any allowed primitive type (allowed: ["string"])` | Wrong data type returned |

## Manual Schema Comparison

To compare schemas manually, use **jsonschema2pojo** or paste both JSONs into: `http://www.jsondiff.com/`$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['JSON Schema', 'Schema Validation', 'matchesJsonSchema', 'Rest Assured', 'API Testing', 'Contract Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is contract testing and when should you use it?',
  'contract-testing-when-to-use',
  'Contract testing verifies that two services can communicate by testing against a shared contract, essential for microservices.',
  $$## Contract Testing

**Contract testing** is a technique for testing an integration point by checking each application in isolation to ensure the messages it sends or receives conform to a shared understanding documented in a **contract**.

## When to Use Contract Testing

Contract testing is immediately applicable anywhere where you have **two services that need to communicate** — such as an API client and a web front-end.

It really shines in an environment with **many services** (as is common in a **microservice architecture**). Having well-formed contract tests makes it easy for developers to avoid **version hell**.

## Consumer-Driven Contract Testing

In microservices, the **consumer** (client) defines what it expects from the **provider** (API server). The contract is tested independently on both sides.

```
Consumer (Frontend) ──→ defines expected API shape ──→ Contract
Provider (API Server) ──→ verifies it fulfils the contract ──→ Pass/Fail
```

## Popular Tools

| Tool | Language | Description |
|------|----------|-------------|
| **Pact** | Java, JS, Ruby, .NET | Most popular consumer-driven contract testing |
| **Spring Cloud Contract** | Java/Spring | Contract testing for Spring microservices |
| **Dredd** | Any | API Blueprint/OpenAPI contract testing |

## Example with Pact (Java)

```java
@ExtendWith(PactConsumerTestExt.class)
public class UserServiceConsumerTest {

    @Pact(consumer = "FrontendApp", provider = "UserAPI")
    public RequestResponsePact createPact(PactDslWithProvider builder) {
        return builder
            .given("user 1 exists")
            .uponReceiving("get user by id")
                .path("/api/users/1")
                .method("GET")
            .willRespondWith()
                .status(200)
                .body(new PactDslJsonBody()
                    .integerType("id", 1)
                    .stringType("name", "John"))
            .toPact();
    }
}
```

## Contract Testing vs Integration Testing

| Feature | Contract Testing | Integration Testing |
|---------|----------------|-------------------|
| Isolation | Tests each service independently | Tests services together |
| Speed | Fast | Slower |
| Feedback | Early detection | Late detection |
| Environment | No live environment needed | Needs running services |

Contract testing is a **killer app** for microservice development and deployment.$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Contract Testing', 'Pact', 'Microservices', 'API Testing', 'Consumer-Driven', 'Integration Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to check API responses on mobile (Android/iOS) using a proxy tool?',
  'check-api-responses-mobile-android-ios-proxy',
  'Use Fiddler or Charles Proxy to intercept and inspect API traffic between a mobile device and the server.',
  $$## Checking API Responses on Mobile Devices

To inspect API traffic on a mobile device (Android/iOS), you use a **proxy tool** such as Fiddler or Charles Proxy.

## What is a Proxy Server?

A proxy server is an intermediary for requests which travel from client to server and vice-versa. It can exist:
- On the **same machine** as the client or server
- On a **separate machine** in the network

## Setup Architecture

```
Mobile Device (Client)
        |
        | HTTPS Request
        ↓
  Proxy Server (Your PC)
        |
        | HTTPS Request (forwarded)
        ↓
    App Server
```

## Using Fiddler

1. Install Fiddler on your PC
2. Enable **Allow remote computers to connect** in settings
3. Find your PC''s IP address
4. On your mobile, set the **WiFi proxy** to your PC''s IP and Fiddler''s port (8888)
5. Install the **Fiddler root certificate** on your mobile for HTTPS decryption
6. Browse the app — Fiddler captures all traffic

## Using Charles Proxy

1. Install Charles on your Mac/PC
2. Set your mobile''s proxy to your computer''s IP + Charles port (8888)
3. Install the **Charles Root Certificate** on your mobile
4. Trust the certificate in device settings (iOS: Settings > General > About > Certificate Trust)
5. All app API traffic will appear in Charles

## What You Can Inspect

- **Request URL, method, headers, body**
- **Response status code, headers, body**
- **Response time and size**
- **SSL/HTTPS traffic** (with certificate installed)
- **Throttle network speed** to test on 3G/slow connections

## When to Use
- Debugging mobile app API calls
- Verifying requests sent by third-party apps
- Testing with different network conditions$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Mobile Testing', 'Fiddler', 'Charles Proxy', 'API Debugging', 'iOS', 'Android', 'Proxy'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to fix the error: import io.restassured.RestAssured cannot be resolved?',
  'fix-import-restassured-cannot-be-resolved',
  'Add the Rest Assured dependency to pom.xml without the test scope, or move your code to the test sources directory.',
  $$## Fix: import io.restassured.RestAssured cannot be resolved

This error typically occurs when the **scope** of the Rest Assured dependency is set to `test`, which limits access to the classes from within source code (only accessible in the `test` sources).

## Root Cause

When you add the dependency with `scope: test`:

```xml
<!-- WRONG - causes import error in main source -->
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.3.0</version>
    <scope>test</scope>  ← This limits access to test sources only
</dependency>
```

## Solutions

### Solution 1: Remove the `scope` attribute

```xml
<!-- CORRECT - accessible from all source directories -->
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.3.0</version>
    <!-- No scope = compile scope = accessible everywhere -->
</dependency>
```

### Solution 2: Move your class to test sources

If the `scope: test` is intentional, move your API test class to:
```
src/test/java/<package>
```
Not in `src/main/java/<package>`.

### Solution 3: Full Dependency Block

```xml
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.3.0</version>
</dependency>
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>json-path</artifactId>
    <version>5.3.0</version>
</dependency>
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>json-schema-validator</artifactId>
    <version>5.3.0</version>
</dependency>
```

## After Fixing

1. Save `pom.xml`
2. Right-click project → **Maven → Reload project**
3. Or run: `mvn clean install`
4. The import should resolve correctly

## Summary

| Scenario | Fix |
|----------|-----|
| Class in `src/main/java` | Remove `<scope>test</scope>` |
| Class should be in test | Move to `src/test/java` |
| Dependency missing entirely | Add Rest Assured to `pom.xml` |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Rest Assured', 'Maven', 'pom.xml', 'Import Error', 'Setup', 'Troubleshooting'], true, 0
);
