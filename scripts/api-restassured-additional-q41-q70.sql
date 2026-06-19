-- API / REST Assured Additional Q41–Q70 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you set up a Rest Assured project with Maven? What are the required dependencies?',
  'rest-assured-project-setup-maven-dependencies',
  'Add rest-assured, json-path, json-schema-validator, TestNG, and jackson-databind dependencies to pom.xml to set up a REST Assured project.',
  $$## Rest Assured Project Setup with Maven

### Complete pom.xml Setup

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.automateqa</groupId>
    <artifactId>api-automation</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <rest-assured.version>5.3.2</rest-assured.version>
        <testng.version>7.8.0</testng.version>
    </properties>

    <dependencies>
        <!-- REST Assured Core -->
        <dependency>
            <groupId>io.rest-assured</groupId>
            <artifactId>rest-assured</artifactId>
            <version>${rest-assured.version}</version>
        </dependency>

        <!-- JSON Path -->
        <dependency>
            <groupId>io.rest-assured</groupId>
            <artifactId>json-path</artifactId>
            <version>${rest-assured.version}</version>
        </dependency>

        <!-- JSON Schema Validator -->
        <dependency>
            <groupId>io.rest-assured</groupId>
            <artifactId>json-schema-validator</artifactId>
            <version>${rest-assured.version}</version>
        </dependency>

        <!-- TestNG -->
        <dependency>
            <groupId>org.testng</groupId>
            <artifactId>testng</artifactId>
            <version>${testng.version}</version>
        </dependency>

        <!-- Jackson (for serialization/deserialization) -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.15.2</version>
        </dependency>

        <!-- Apache Commons IO (for reading files) -->
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.13.0</version>
        </dependency>

        <!-- Lombok (optional - reduces boilerplate in POJOs) -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.28</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
                <configuration>
                    <suiteXmlFiles>
                        <suiteXmlFile>testng.xml</suiteXmlFile>
                    </suiteXmlFiles>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

### Project Folder Structure

```
api-automation/
├── src/
│   ├── main/java/
│   │   └── com/automateqa/
│   │       ├── config/ConfigManager.java
│   │       ├── models/User.java
│   │       └── utils/TokenManager.java
│   └── test/java/
│       └── com/automateqa/
│           ├── base/BaseTest.java
│           └── tests/UserApiTest.java
├── src/test/resources/
│   ├── config.properties
│   └── schemas/user-schema.json
├── pom.xml
└── testng.xml
```

### BaseTest Setup

```java
import io.restassured.RestAssured;
import org.testng.annotations.BeforeClass;

public class BaseTest {

    @BeforeClass
    public void setup() {
        RestAssured.baseURI  = "https://reqres.in";
        RestAssured.basePath = "/api";
        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
    }
}
```$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Rest Assured', 'Maven', 'pom.xml', 'Project Setup', 'Dependencies', 'TestNG'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between REST and SOAP? When would you use each?',
  'difference-between-rest-and-soap',
  'REST is lightweight and uses JSON/HTTP; SOAP is a protocol using XML with built-in security. REST is preferred for web/mobile; SOAP for enterprise banking.',
  $$## REST vs SOAP — Complete Comparison

| Feature | REST | SOAP |
|---------|------|------|
| **Type** | Architectural style | Protocol |
| **Format** | JSON, XML, HTML, plain text | XML only |
| **Transport** | HTTP/HTTPS | HTTP, SMTP, TCP |
| **Standards** | No strict standard | Strict WSDL contract |
| **Security** | HTTPS, OAuth, JWT | WS-Security (built-in) |
| **Performance** | Faster (lightweight JSON) | Slower (verbose XML) |
| **Error handling** | HTTP status codes | SOAP fault elements |
| **Browser support** | Yes (native HTTP) | No |
| **Stateless** | Yes | Can be stateful or stateless |
| **Learning curve** | Easy | Steep |

## REST — Representational State Transfer

- Uses **HTTP methods** (GET, POST, PUT, DELETE)
- **Stateless** — each request is independent
- Returns **JSON** (lightweight, browser-friendly)
- No strict standard — flexible implementation
- Best for **web APIs, mobile apps, microservices**

```
GET /api/users/1
Response: { "id": 1, "name": "John" }
```

## SOAP — Simple Object Access Protocol

- Uses **XML envelope** structure for every message
- Has **WSDL** (Web Service Description Language) contract
- Built-in **WS-Security** for message-level encryption
- Better for **complex transactions** requiring ACID compliance

```xml
<soapenv:Envelope>
  <soapenv:Body>
    <GetUser>
      <userId>1</userId>
    </GetUser>
  </soapenv:Body>
</soapenv:Envelope>
```

## When to Use REST

- Public APIs (Twitter, GitHub, Stripe)
- Mobile and web applications
- Microservices communication
- When performance matters

## When to Use SOAP

- **Banking and financial services** (requires ACID transactions)
- **Legacy enterprise systems** (ERP, SAP integrations)
- When **WS-Security** is required
- When strict contracts (WSDL) are needed

## In Interviews

> "REST is preferred for most modern APIs because it's lightweight, uses JSON, and is easy to consume from browsers. SOAP is still used in enterprise environments like banking where security contracts and formal WSDL definitions are required."$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['REST', 'SOAP', 'Comparison', 'API Testing', 'WSDL', 'XML', 'JSON'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the different types of API testing?',
  'types-of-api-testing',
  'API testing includes functional, integration, load/performance, security, negative, contract, regression, and end-to-end testing.',
  $$## Types of API Testing

### 1. Functional Testing
Verifies that the API works as specified — correct inputs return correct outputs.

```java
// Test: POST /users creates a user and returns 201
given()
    .body("{ \"name\": \"John\" }")
    .contentType(ContentType.JSON)
    .when()
    .post("/api/users")
    .then()
    .statusCode(201)
    .body("name", equalTo("John"));
```

### 2. Integration Testing
Tests how multiple APIs or services work together.
- Login → Get Token → Use Token to Access Protected Resource

### 3. Load / Performance Testing
Checks API behavior under expected and peak loads.
- **Tools:** JMeter, k6, Gatling
- Metrics: response time, throughput, error rate under 100, 500, 1000 concurrent users

### 4. Security Testing
Verifies the API is protected against common vulnerabilities:
- **SQL Injection** — malicious SQL in request params
- **XSS** — script injection in body fields
- **Auth bypass** — accessing resources without valid token
- **IDOR** — accessing another user's data by changing ID
- **Rate limiting** — brute force protection

### 5. Negative Testing
Tests that invalid inputs are handled gracefully:
- Missing required fields → 400
- Invalid data types → 400 / 422
- Non-existent resources → 404
- Expired tokens → 401

### 6. Contract Testing
Verifies the API response structure matches the agreed schema.
- **Tools:** Pact, JSON Schema Validator

### 7. Regression Testing
Re-runs existing tests after code changes to catch regressions.

### 8. End-to-End (E2E) Testing
Tests complete business workflows across multiple APIs:
1. Register user
2. Login → get token
3. Create order
4. Make payment
5. Verify order status

### 9. Compatibility Testing
Verifies API works across different:
- API versions (v1, v2, v3)
- Client types (mobile, web, third-party)
- Response formats (JSON, XML)

## Test Coverage Pyramid

```
         [E2E Tests]     ← few, slow, expensive
       [Integration Tests]
    [Contract / Schema Tests]
  [Functional API Tests]    ← many, fast, cheap
```$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['API Testing Types', 'Functional', 'Load Testing', 'Security', 'Negative Testing', 'Contract Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between API testing and UI testing?',
  'api-testing-vs-ui-testing',
  'API testing validates business logic at the service layer without a browser; UI testing validates the frontend through a real browser.',
  $$## API Testing vs UI Testing

| Feature | API Testing | UI Testing |
|---------|------------|------------|
| **Layer tested** | Service layer (backend) | Presentation layer (frontend) |
| **Tools** | Rest Assured, Postman, Karate | Selenium, Playwright, Cypress |
| **Speed** | Very fast (no browser) | Slow (browser rendering) |
| **Stability** | Very stable | Fragile (UI changes break tests) |
| **Scope** | Business logic, data validation | User workflows, visual validation |
| **When to use** | Anytime the API exists | After UI is built |
| **Test pyramid** | Middle / base layer | Top layer (few tests) |
| **Coverage** | Data, status codes, headers | Button clicks, forms, navigation |

## API Testing Advantages

```java
// Direct, fast, stable
given()
    .body("{ \"username\": \"admin\", \"password\": \"pass\" }")
    .contentType(ContentType.JSON)
    .when()
    .post("/api/login")
    .then()
    .statusCode(200)
    .body("token", notNullValue());
// Runs in ~50ms
```

- Tests business logic independently of the UI
- Catches bugs earlier in the SDLC (Shift-Left)
- Not affected by CSS/layout changes
- Can run before UI is built
- Faster feedback loops

## UI Testing Use Cases

```java
// Slower, more brittle
driver.findElement(By.id("username")).sendKeys("admin");
driver.findElement(By.id("password")).sendKeys("pass");
driver.findElement(By.id("login-btn")).click();
assertTrue(driver.findElement(By.id("dashboard")).isDisplayed());
// Runs in ~3-5 seconds
```

- Validates visual rendering
- Tests user experience flows
- Catches frontend-specific bugs
- Required for accessibility testing

## Recommended Strategy (Test Pyramid)

```
         UI Tests (10%)      ← Playwright/Selenium
      API Tests (30%)        ← Rest Assured/Postman
   Unit Tests (60%)          ← JUnit/Mockito
```

## In Interviews

> "I prefer testing at the API layer whenever possible because it's faster, more stable, and catches business logic issues before the UI is even built. UI tests should be used for critical end-to-end user journeys only."$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['API Testing', 'UI Testing', 'Selenium', 'Rest Assured', 'Test Pyramid', 'Comparison'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between authentication and authorization in API testing?',
  'authentication-vs-authorization-api-testing',
  'Authentication verifies WHO you are (login); Authorization verifies WHAT you can access (permissions).',
  $$## Authentication vs Authorization

This is one of the most frequently asked API security questions in interviews.

## Authentication — "Who are you?"

Authentication **verifies the identity** of a user or system. It answers: **"Are you who you claim to be?"**

### Common Authentication Methods

| Method | Description | Example |
|--------|-------------|---------|
| **Basic Auth** | Username + password (Base64) | `Authorization: Basic dXNlcjpwYXNz` |
| **Bearer Token** | JWT token passed in header | `Authorization: Bearer eyJhbG...` |
| **API Key** | Unique key per client | `X-API-Key: abc123key` |
| **OAuth 2.0** | Delegated access via access token | Login with Google/GitHub |
| **Session Cookie** | Server-side session ID | `Cookie: session=xyz` |

```java
// Authentication example in Rest Assured
given()
    .header("Authorization", "Bearer " + getToken())
    .when()
    .get("/api/profile");
```

## Authorization — "What can you do?"

Authorization **determines what actions** an authenticated user is allowed to perform. It answers: **"Do you have permission?"**

### Common Authorization Patterns

| Pattern | Description |
|---------|-------------|
| **RBAC** | Role-Based Access Control (admin/user/guest) |
| **ABAC** | Attribute-Based Access Control (department, location) |
| **ACL** | Access Control Lists (per-resource permissions) |
| **Scopes** | OAuth 2.0 scopes (read:users, write:orders) |

```java
// Authorization test — user role cannot delete
given()
    .header("Authorization", "Bearer " + userToken) // not admin
    .when()
    .delete("/api/users/123")
    .then()
    .statusCode(403); // Forbidden — not authorized
```

## Key Differences

| Aspect | Authentication | Authorization |
|--------|----------------|---------------|
| Question | Who are you? | What can you do? |
| Happens | First | After authentication |
| Failure code | **401 Unauthorized** | **403 Forbidden** |
| Example | Login with password | Admin vs regular user access |
| Can work alone? | Yes | No (needs authentication first) |

## HTTP Status Codes

- **401 Unauthorized** → Authentication failed (no token, wrong password)
- **403 Forbidden** → Authenticated but not authorized (wrong role/permissions)

## Interview Answer

> "Authentication is verifying identity — like showing your ID at the door. Authorization is determining what you're allowed to do once you're inside — like which rooms you can enter. In API testing, a 401 means the user isn't logged in; a 403 means they're logged in but don't have permission."$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Authentication', 'Authorization', '401', '403', 'Security', 'API Testing', 'JWT', 'OAuth'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to automate the DELETE method in Rest Assured?',
  'automate-delete-method-rest-assured',
  'Use given().header().when().delete(url) and validate 200 or 204 No Content status code in Rest Assured.',
  $$## Automating DELETE Method in Rest Assured

The **DELETE** method removes a resource at the specified URI. A successful DELETE typically returns **204 No Content** or **200 OK**.

### Basic DELETE Request

```java
@Test
public void testDeleteUser() {

    int userId = 2;

    Response response = given()
                            .header("Authorization", "Bearer " + token)
                            .when()
                            .delete("https://reqres.in/api/users/" + userId);

    assertEquals(response.getStatusCode(), 204);
}
```

### DELETE with Path Parameter

```java
@Test
public void deleteUserByPathParam() {

    given()
        .header("Authorization", "Bearer " + token)
        .pathParam("id", 5)
        .when()
        .delete("/api/users/{id}")
        .then()
        .statusCode(204);
}
```

### Verify Resource is Gone After DELETE

```java
@Test
public void testDeleteThenVerifyGone() {

    int userId = 3;

    // Step 1: Delete the user
    given()
        .header("Authorization", "Bearer " + token)
        .when()
        .delete("/api/users/" + userId)
        .then()
        .statusCode(204);

    // Step 2: Verify user no longer exists
    given()
        .when()
        .get("/api/users/" + userId)
        .then()
        .statusCode(404)
        .body("message", equalTo("User not found"));
}
```

### DELETE with Request Body (some APIs require it)

```java
@Test
public void deleteWithBody() {

    String body = "{ \"reason\": \"Account closure requested by user\" }";

    given()
        .contentType(ContentType.JSON)
        .body(body)
        .header("Authorization", "Bearer " + token)
        .when()
        .delete("/api/users/5")
        .then()
        .statusCode(200)
        .body("message", equalTo("User deleted successfully"));
}
```

### Test Deleting Non-Existent Resource

```java
@Test
public void testDeleteNonExistentUser() {

    given()
        .when()
        .delete("/api/users/999999")
        .then()
        .statusCode(404);
}
```

## DELETE Response Codes

| Status | Meaning |
|--------|---------|
| **204 No Content** | Deleted successfully, no body returned |
| **200 OK** | Deleted successfully with response body |
| **404 Not Found** | Resource didn't exist |
| **403 Forbidden** | Not authorized to delete |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['DELETE', 'Rest Assured', 'API Automation', '204', 'HTTP Methods', 'TestNG'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to log requests and responses in Rest Assured?',
  'log-requests-responses-rest-assured',
  'Use .log().all(), .log().request(), .log().response(), or enableLoggingOfRequestAndResponseIfValidationFails() for debugging in Rest Assured.',
  $$## Logging in Rest Assured

Logging is essential for debugging failing API tests. Rest Assured provides built-in logging through the `.log()` method.

## Log Request Details

```java
// Log all request details (method, URL, headers, body)
given()
    .log().all()
    .contentType(ContentType.JSON)
    .body("{ \"name\": \"John\" }")
    .when()
    .post("/api/users");
```

Output:
```
Request method: POST
Request URI:    https://api.example.com/api/users
Headers:        Content-Type=application/json
Body:           { "name": "John" }
```

## Log Response Details

```java
// Log all response details (status, headers, body)
given()
    .when()
    .get("/api/users/2")
    .then()
    .log().all()
    .statusCode(200);
```

## Specific Logging Options

```java
// Log only request headers
given().log().headers()

// Log only request body
given().log().body()

// Log only request parameters
given().log().params()

// Log only if request matches a condition
given().log().ifValidationFails()

// Log only response status
.then().log().status()

// Log only response headers
.then().log().headers()

// Log only response body
.then().log().body()

// Log only if test fails
.then().log().ifError()
.then().log().ifValidationFails()
```

## Global Logging (Best Practice for CI/CD)

```java
@BeforeClass
public void setup() {
    RestAssured.baseURI = "https://api.example.com";

    // Only logs when a test fails — keeps CI output clean
    RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
}
```

## Log to a File (for Reports)

```java
PrintStream fileOutput = new PrintStream(new File("target/api-logs.txt"));
RequestSpecification request = given()
    .filter(new RequestLoggingFilter(fileOutput))
    .filter(new ResponseLoggingFilter(fileOutput));
```

## Recommended Logging Strategy

| Environment | Strategy |
|------------|---------|
| **Local dev** | `.log().all()` on failing tests |
| **CI/CD** | `enableLoggingOfRequestAndResponseIfValidationFails()` |
| **Debugging** | `.log().all()` on both request and response |
| **Reports** | Log to file using RequestLoggingFilter |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Logging', 'Rest Assured', 'Debugging', 'log().all()', 'API Testing', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is RequestSpecification and ResponseSpecification in Rest Assured and why use them?',
  'requestspecification-responsespecification-rest-assured',
  'RequestSpecification and ResponseSpecification allow you to define reusable request/response configurations to avoid duplication across tests.',
  $$## RequestSpecification and ResponseSpecification

These are **reusable specification builders** that let you define common request/response settings once and reuse them across all tests — following the DRY principle.

## RequestSpecification

Defines common **request** settings: base URL, headers, auth, content type.

```java
import io.restassured.specification.RequestSpecification;
import io.restassured.builder.RequestSpecBuilder;

public class BaseTest {

    protected static RequestSpecification requestSpec;

    @BeforeClass
    public static void buildRequestSpec() {
        requestSpec = new RequestSpecBuilder()
            .setBaseUri("https://api.example.com")
            .setBasePath("/api")
            .setContentType(ContentType.JSON)
            .addHeader("Authorization", "Bearer " + getToken())
            .addHeader("Accept", "application/json")
            .setRelaxedHTTPSValidation()
            .log(LogDetail.ALL)
            .build();
    }
}
```

**Using RequestSpecification in tests:**

```java
@Test
public void testGetUser() {
    given(requestSpec)          // ← reuse the spec
        .pathParam("id", 2)
        .when()
        .get("/users/{id}")
        .then()
        .statusCode(200);
}

@Test
public void testCreateUser() {
    given(requestSpec)          // ← same spec, different endpoint
        .body("{ \"name\": \"John\" }")
        .when()
        .post("/users")
        .then()
        .statusCode(201);
}
```

## ResponseSpecification

Defines common **response** validations: status code, content type, response time.

```java
import io.restassured.specification.ResponseSpecification;
import io.restassured.builder.ResponseSpecBuilder;

public class BaseTest {

    protected static ResponseSpecification responseSpec;

    @BeforeClass
    public static void buildResponseSpec() {
        responseSpec = new ResponseSpecBuilder()
            .expectStatusCode(200)
            .expectContentType(ContentType.JSON)
            .expectResponseTime(lessThan(2000L))
            .expectHeader("Content-Type", containsString("application/json"))
            .build();
    }
}
```

**Using ResponseSpecification in tests:**

```java
@Test
public void testGetAllUsers() {
    given(requestSpec)
        .when()
        .get("/users")
        .then()
        .spec(responseSpec)            // ← reuse the response spec
        .body("data.size()", greaterThan(0));
}
```

## Combined Usage

```java
given(requestSpec)
    .when()
    .get("/users/1")
    .then()
    .spec(responseSpec)
    .body("data.first_name", equalTo("Janet"));
```

## Benefits

| Without Specs | With Specs |
|--------------|-----------|
| Repeat headers in every test | Define once, use everywhere |
| Inconsistent auth setup | Centralized auth management |
| Hard to update base URL | One-line change |
| Duplicated content-type | DRY (Don''t Repeat Yourself) |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['RequestSpecification', 'ResponseSpecification', 'Rest Assured', 'Reusability', 'DRY', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to set baseURI, basePath, and basePort in Rest Assured?',
  'set-baseuri-basepath-baseport-rest-assured',
  'Use RestAssured.baseURI, RestAssured.basePath, and RestAssured.port as global settings to avoid repeating base URL in every test.',
  $$## BaseURI, BasePath, and BasePort in Rest Assured

These static fields allow you to configure the **base URL globally** so you don''t need to repeat it in every test.

## Setting Global Defaults

```java
import io.restassured.RestAssured;
import org.testng.annotations.BeforeClass;

public class BaseTest {

    @BeforeClass
    public void setupRestAssured() {

        // Base URI — the scheme and host
        RestAssured.baseURI = "https://reqres.in";

        // Base Path — common path prefix
        RestAssured.basePath = "/api";

        // Base Port — if not default (80/443)
        RestAssured.port = 8080; // only needed for non-standard ports

        // SSL relaxation (for test environments with self-signed certs)
        RestAssured.useRelaxedHTTPSValidation();
    }
}
```

**Result:** Every request automatically uses `https://reqres.in:8080/api` as the prefix.

## Using Without Repeating Base URL

```java
@Test
public void testGetUser() {
    // Full URL: https://reqres.in/api/users/2
    given()
        .when()
        .get("/users/2")   // ← only relative path needed
        .then()
        .statusCode(200);
}

@Test
public void testCreateUser() {
    // Full URL: https://reqres.in/api/users
    given()
        .body("{ \"name\": \"John\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/users")    // ← only relative path
        .then()
        .statusCode(201);
}
```

## Environment-Based Configuration

```java
// config.properties
base.url=https://api.staging.com
base.path=/api/v2
port=443

// BaseTest.java
@BeforeClass
public void setup() {
    RestAssured.baseURI  = ConfigManager.get("base.url");
    RestAssured.basePath = ConfigManager.get("base.path");
    RestAssured.port     = Integer.parseInt(ConfigManager.get("port"));
}
```

## Resetting Defaults

```java
@AfterClass
public void teardown() {
    RestAssured.reset(); // Resets all static defaults
}
```

## Summary

| Config | Example | Effect |
|--------|---------|--------|
| `baseURI` | `https://api.example.com` | Scheme + host |
| `basePath` | `/api/v1` | Common URL prefix |
| `port` | `8080` | Non-default port |
| `useRelaxedHTTPSValidation()` | — | Skip SSL cert check |$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['baseURI', 'basePath', 'Rest Assured', 'Configuration', 'API Testing', 'Setup'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to extract values from response using extract() and JsonPath in Rest Assured?',
  'extract-values-jsonpath-rest-assured',
  'Use .extract().path(), .extract().jsonPath(), or .extract().response() to pull specific values from API responses in Rest Assured.',
  $$## Extracting Values in Rest Assured

Rest Assured provides multiple ways to extract data from API responses for use in subsequent requests (API chaining).

## Method 1: extract().path() — Extract Single Field

```java
// Extract a single field directly
String userId = given()
                    .contentType(ContentType.JSON)
                    .body("{ \"name\": \"John\", \"job\": \"QA\" }")
                    .when()
                    .post("/api/users")
                    .then()
                    .statusCode(201)
                    .extract()
                    .path("id");

System.out.println("Created user ID: " + userId);
```

## Method 2: extract().jsonPath() — Extract Multiple Fields

```java
Response response = given()
                        .when()
                        .get("/api/users/2")
                        .then()
                        .statusCode(200)
                        .extract()
                        .response();

JsonPath jsonPath = response.jsonPath();

String firstName = jsonPath.getString("data.first_name");
String lastName  = jsonPath.getString("data.last_name");
String email     = jsonPath.getString("data.email");
int    id        = jsonPath.getInt("data.id");

System.out.println(firstName + " " + lastName + " - " + email);
```

## Method 3: extract().as() — Deserialize to POJO

```java
UserResponse user = given()
                        .when()
                        .get("/api/users/2")
                        .then()
                        .statusCode(200)
                        .extract()
                        .as(UserResponse.class); // deserialization

assertEquals(user.getData().getFirstName(), "Janet");
```

## Method 4: extract() from Array

```java
// Extract list of all email addresses
List<String> emails = given()
                          .when()
                          .get("/api/users")
                          .then()
                          .extract()
                          .jsonPath()
                          .getList("data.email");

emails.forEach(System.out::println);
```

## Method 5: Extract Response as String

```java
String responseBody = given()
                          .when()
                          .get("/api/users/1")
                          .then()
                          .extract()
                          .asString();

System.out.println(responseBody);
```

## Common JsonPath Expressions

| Expression | Gets |
|-----------|------|
| `"name"` | Top-level "name" field |
| `"data.email"` | Nested "email" inside "data" |
| `"data[0].id"` | First item in "data" array |
| `"data.findAll { it.id > 3 }.email"` | Filter array and get emails |
| `"data.size()"` | Array length |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['extract()', 'JsonPath', 'Rest Assured', 'Response Extraction', 'API Chaining', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is JWT (JSON Web Token) and how do you use it in API testing?',
  'jwt-json-web-token-api-testing',
  'JWT is a compact token for transmitting claims between parties. In API testing, fetch it via login, store it, and pass it in Authorization: Bearer header.',
  $$## JWT — JSON Web Token

**JWT** (JSON Web Token) is a compact, self-contained token used to securely transmit information between parties as a JSON object. It is the most common authentication mechanism for modern REST APIs.

## JWT Structure

A JWT has 3 parts separated by dots: `header.payload.signature`

```
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsImlhdCI6MTcxODAwMDAwMCwiZXhwIjoxNzE4MDAzNjAwfQ.abc123
        ↑                              ↑                                                    ↑
     Header                         Payload                                            Signature
  (algorithm)           (userId, role, expiry time)                            (verifies authenticity)
```

**Decoded Payload:**
```json
{
  "sub": "user1",
  "role": "admin",
  "iat": 1718000000,
  "exp": 1718003600
}
```

## Step 1: Get JWT Token via Login

```java
public class TokenManager {

    private static String token;

    public static String getToken() {
        if (token == null) {
            token = given()
                        .contentType(ContentType.JSON)
                        .body("{ \"username\": \"admin\", \"password\": \"admin123\" }")
                        .when()
                        .post("https://api.example.com/auth/login")
                        .then()
                        .statusCode(200)
                        .extract()
                        .path("access_token");
        }
        return token;
    }
}
```

## Step 2: Use Token in API Requests

```java
@Test
public void testGetProtectedResource() {

    given()
        .header("Authorization", "Bearer " + TokenManager.getToken())
        .when()
        .get("/api/users/profile")
        .then()
        .statusCode(200)
        .body("role", equalTo("admin"));
}
```

## Step 3: Test Token Expiry

```java
@Test
public void testExpiredTokenReturns401() {

    String expiredToken = "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjEwMDAwMH0.invalid";

    given()
        .header("Authorization", "Bearer " + expiredToken)
        .when()
        .get("/api/users")
        .then()
        .statusCode(401)
        .body("error", equalTo("Token expired"));
}
```

## Step 4: Test Missing Token

```java
@Test
public void testMissingTokenReturns401() {
    given()
        .when()
        .get("/api/users")  // no Authorization header
        .then()
        .statusCode(401);
}
```

## JWT vs Session Tokens

| Feature | JWT | Session Token |
|---------|-----|--------------|
| Stateless | Yes | No (server stores session) |
| Self-contained | Yes (has user data) | No (just a reference ID) |
| Expiry | Encoded in token | Managed server-side |
| Scalable | Yes | Harder (sticky sessions) |
| Revocable | Hard (until expiry) | Easy |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['JWT', 'JSON Web Token', 'Authentication', 'Bearer Token', 'Rest Assured', 'API Security'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is CORS and how do you test CORS in API testing?',
  'cors-cross-origin-resource-sharing-api-testing',
  'CORS (Cross-Origin Resource Sharing) is a security feature that restricts web pages from calling APIs on a different domain. Test it via OPTIONS preflight requests.',
  $$## CORS — Cross-Origin Resource Sharing

**CORS** is a browser security mechanism that **restricts web pages from making requests to a different origin** (domain, protocol, or port) than the one that served the web page.

## Why CORS Exists

```
https://myfrontend.com  →  API call →  https://api.backend.com
       (Origin A)                            (Origin B)

Browser blocks this by default unless api.backend.com
explicitly allows requests from myfrontend.com
```

## CORS Headers

| Header | Example | Purpose |
|--------|---------|---------|
| `Access-Control-Allow-Origin` | `*` or `https://myfrontend.com` | Allowed origins |
| `Access-Control-Allow-Methods` | `GET, POST, PUT, DELETE` | Allowed HTTP methods |
| `Access-Control-Allow-Headers` | `Content-Type, Authorization` | Allowed request headers |
| `Access-Control-Max-Age` | `3600` | Cache preflight for 1 hour |

## How CORS Works — Preflight Request

For non-simple requests (POST with JSON), browsers send a **preflight OPTIONS request** first:

```
OPTIONS /api/users HTTP/1.1
Origin: https://myfrontend.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type, Authorization

Response:
Access-Control-Allow-Origin: https://myfrontend.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 3600
```

## Testing CORS in Rest Assured

```java
@Test
public void testCORSHeadersPresent() {

    given()
        .header("Origin", "https://myfrontend.com")
        .when()
        .options("/api/users")
        .then()
        .statusCode(200)
        .header("Access-Control-Allow-Origin", "https://myfrontend.com")
        .header("Access-Control-Allow-Methods", containsString("GET"))
        .header("Access-Control-Allow-Methods", containsString("POST"));
}

@Test
public void testCORSWithUnauthorizedOrigin() {

    given()
        .header("Origin", "https://malicious-site.com")
        .when()
        .options("/api/users")
        .then()
        // Should NOT allow unauthorized origins
        .header("Access-Control-Allow-Origin", not("https://malicious-site.com"));
}
```

## CORS Test Checklist

- ✅ Allowed origins can make preflight OPTIONS requests
- ✅ `Access-Control-Allow-Origin` header is present in responses
- ✅ Wildcard `*` is NOT used for authenticated endpoints
- ✅ Unauthorized origins are rejected
- ✅ `Access-Control-Allow-Methods` includes only necessary methods
- ✅ Credentials are handled correctly (cookies, auth headers)$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['CORS', 'Cross-Origin', 'Security', 'API Testing', 'OPTIONS', 'Preflight', 'Headers'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is JSON vs XML in API testing and what are the differences?',
  'json-vs-xml-api-testing-differences',
  'JSON is lightweight and browser-friendly using key-value pairs; XML is verbose and self-describing using tags. REST APIs prefer JSON; SOAP uses XML.',
  $$## JSON vs XML in API Testing

## JSON (JavaScript Object Notation)

JSON is a **lightweight, human-readable** data format using key-value pairs.

```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "roles": ["admin", "editor"],
    "active": true
  }
}
```

## XML (eXtensible Markup Language)

XML is a **self-describing** markup language using tags.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<user>
  <id>1</id>
  <name>John Doe</name>
  <email>john@example.com</email>
  <roles>
    <role>admin</role>
    <role>editor</role>
  </roles>
  <active>true</active>
</user>
```

## Comparison

| Feature | JSON | XML |
|---------|------|-----|
| **Readability** | Easier to read | More verbose |
| **Size** | Smaller payload | Larger payload |
| **Parsing speed** | Faster | Slower |
| **Browser support** | Native | Needs XML parser |
| **Data types** | String, number, boolean, array, object | Strings only (need schema for types) |
| **Comments** | Not supported | Supported |
| **Attributes** | No attributes | Supports attributes |
| **Used in** | REST APIs | SOAP, some legacy REST |
| **Schema validation** | JSON Schema | XSD (XML Schema Definition) |

## Parsing XML in Rest Assured

```java
// XML response — use XmlPath
given()
    .header("Accept", "application/xml")
    .when()
    .get("/api/users/1")
    .then()
    .statusCode(200)
    .body("user.name", equalTo("John Doe"))
    .body("user.email", equalTo("john@example.com"));

// Extract using XmlPath
XmlPath xmlPath = given()
                      .when()
                      .get("/api/users/1")
                      .then()
                      .extract()
                      .xmlPath();

String name = xmlPath.getString("user.name");
```

## Parsing JSON in Rest Assured

```java
// JSON response — use JsonPath
given()
    .when()
    .get("/api/users/1")
    .then()
    .statusCode(200)
    .body("user.name", equalTo("John Doe"))
    .body("user.roles[0]", equalTo("admin"));
```

## In Interviews

> "Most modern REST APIs use JSON because it's lightweight, fast to parse, and natively supported by JavaScript. XML is still used in enterprise SOAP services and some legacy systems. When testing, Rest Assured supports both — JsonPath for JSON and XmlPath for XML."$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['JSON', 'XML', 'API Testing', 'JsonPath', 'XmlPath', 'REST', 'SOAP', 'Comparison'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is API rate limiting and how do you test it?',
  'api-rate-limiting-testing',
  'Rate limiting restricts how many API requests a client can make in a time window. Test with 429 Too Many Requests and retry-after headers.',
  $$## API Rate Limiting

**Rate limiting** restricts the **number of API requests** a client can make within a given time window. It protects APIs from abuse, DDoS attacks, and overloading.

## Common Rate Limit Headers

| Header | Value | Meaning |
|--------|-------|---------|
| `X-Rate-Limit-Limit` | `100` | Total requests allowed per window |
| `X-Rate-Limit-Remaining` | `45` | Requests remaining in current window |
| `X-Rate-Limit-Reset` | `1718003600` | Unix timestamp when limit resets |
| `Retry-After` | `60` | Seconds to wait before retrying |

## HTTP Status Code for Rate Limit

**429 Too Many Requests** — returned when the rate limit is exceeded.

## Testing Rate Limiting in Rest Assured

### Test 1: Verify Rate Limit Headers Exist

```java
@Test
public void testRateLimitHeadersPresent() {

    Response response = given()
                            .header("Authorization", "Bearer " + token)
                            .when()
                            .get("/api/users");

    // Verify rate limit headers are present
    assertNotNull(response.getHeader("X-Rate-Limit-Limit"));
    assertNotNull(response.getHeader("X-Rate-Limit-Remaining"));

    int remaining = Integer.parseInt(response.getHeader("X-Rate-Limit-Remaining"));
    assertTrue(remaining >= 0);
}
```

### Test 2: Verify 429 When Limit Exceeded

```java
@Test
public void testRateLimitExceeded() {

    int requestCount = 0;
    int statusCode = 200;

    // Keep calling until rate limited
    while (statusCode == 200 && requestCount < 200) {
        statusCode = given()
                         .header("Authorization", "Bearer " + token)
                         .when()
                         .get("/api/users")
                         .getStatusCode();
        requestCount++;
    }

    assertEquals(statusCode, 429, "Expected 429 Too Many Requests after " + requestCount + " calls");
}
```

### Test 3: Verify Retry-After Header on 429

```java
@Test
public void testRetryAfterHeaderOn429() {

    // Simulate rate limit exceeded (use test API key with very low limit)
    Response response = given()
                            .header("X-API-Key", "low-limit-test-key")
                            .when()
                            .get("/api/rate-limited-endpoint");

    if (response.getStatusCode() == 429) {
        assertNotNull(response.getHeader("Retry-After"),
            "Retry-After header must be present on 429 responses");

        int retryAfter = Integer.parseInt(response.getHeader("Retry-After"));
        assertTrue(retryAfter > 0, "Retry-After should be positive seconds");
    }
}
```

### Test 4: Rate Limit Resets After Window

```java
@Test
public void testRateLimitResetsAfterWindow() throws InterruptedException {

    // Exhaust rate limit
    // ... (call API many times)

    // Wait for window to reset (based on Retry-After value)
    Thread.sleep(60_000); // wait 60 seconds

    // Verify requests work again
    given()
        .header("Authorization", "Bearer " + token)
        .when()
        .get("/api/users")
        .then()
        .statusCode(200);
}
```

## Rate Limiting Strategies

| Strategy | Description |
|----------|-------------|
| **Fixed window** | 100 requests per minute |
| **Sliding window** | 100 requests in any 60-second period |
| **Token bucket** | Requests consume tokens; tokens refill over time |
| **Leaky bucket** | Requests processed at a fixed rate |$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Rate Limiting', '429', 'API Testing', 'Security', 'Retry-After', 'REST Assured'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle multipart file upload in Rest Assured?',
  'multipart-file-upload-rest-assured',
  'Use .multiPart() method in Rest Assured to upload files as multipart/form-data in API tests.',
  $$## Multipart File Upload in Rest Assured

File uploads use `multipart/form-data` content type. Rest Assured supports this via the `.multiPart()` method.

### Method 1: Upload a File from Disk

```java
@Test
public void testFileUpload() {

    File uploadFile = new File("src/test/resources/testfile.pdf");

    Response response = given()
                            .header("Authorization", "Bearer " + token)
                            .multiPart("file", uploadFile, "application/pdf")
                            .when()
                            .post("/api/files/upload");

    assertEquals(response.getStatusCode(), 200);
    assertNotNull(response.jsonPath().getString("file_id"));
    assertEquals(response.jsonPath().getString("filename"), "testfile.pdf");
}
```

### Method 2: Upload with Additional Form Fields

```java
@Test
public void testFileUploadWithMetadata() {

    File imageFile = new File("src/test/resources/profile.jpg");

    given()
        .header("Authorization", "Bearer " + token)
        .multiPart("file", imageFile, "image/jpeg")
        .multiPart("title", "Profile Picture")
        .multiPart("description", "User avatar image")
        .multiPart("category", "profile")
        .when()
        .post("/api/media/upload")
        .then()
        .statusCode(201)
        .body("url", containsString("https://"))
        .body("type", equalTo("image/jpeg"));
}
```

### Method 3: Upload Multiple Files

```java
@Test
public void testMultipleFileUpload() {

    File file1 = new File("src/test/resources/doc1.pdf");
    File file2 = new File("src/test/resources/doc2.pdf");

    given()
        .header("Authorization", "Bearer " + token)
        .multiPart("files", file1, "application/pdf")
        .multiPart("files", file2, "application/pdf")
        .when()
        .post("/api/files/batch-upload")
        .then()
        .statusCode(200)
        .body("uploaded_count", equalTo(2));
}
```

### Method 4: Upload File Content as Byte Array

```java
@Test
public void testUploadFromByteArray() throws IOException {

    byte[] fileContent = Files.readAllBytes(
        Paths.get("src/test/resources/testfile.csv")
    );

    given()
        .header("Authorization", "Bearer " + token)
        .multiPart("file", "data.csv", fileContent, "text/csv")
        .when()
        .post("/api/import/csv")
        .then()
        .statusCode(200)
        .body("imported_rows", greaterThan(0));
}
```

### Method 5: Validate Upload Constraints

```java
@Test
public void testUploadTooLargeFile() {

    File largeFile = new File("src/test/resources/large_50mb.zip");

    given()
        .header("Authorization", "Bearer " + token)
        .multiPart("file", largeFile, "application/zip")
        .when()
        .post("/api/files/upload")
        .then()
        .statusCode(413) // 413 Payload Too Large
        .body("error", containsString("File size exceeds limit"));
}

@Test
public void testUploadInvalidFileType() {

    File exeFile = new File("src/test/resources/malware.exe");

    given()
        .header("Authorization", "Bearer " + token)
        .multiPart("file", exeFile, "application/octet-stream")
        .when()
        .post("/api/files/upload")
        .then()
        .statusCode(400)
        .body("error", containsString("File type not allowed"));
}
```

## Content Type Note

Rest Assured automatically sets `Content-Type: multipart/form-data` when you use `.multiPart()` — you do NOT need to set it manually.$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['File Upload', 'multiPart', 'Rest Assured', 'multipart/form-data', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is GraphQL and how is it different from REST APIs?',
  'graphql-vs-rest-api-differences',
  'GraphQL is a query language for APIs that lets clients request exactly the data they need, unlike REST which has fixed endpoints returning fixed data.',
  $$## GraphQL vs REST

**GraphQL** is a **query language for APIs** and a runtime for fulfilling those queries. Unlike REST which has multiple endpoints, GraphQL has a **single endpoint** where clients specify exactly what data they need.

## REST API — Fixed Endpoints, Fixed Data

```
GET /api/users/1          → Returns ALL user fields
GET /api/users/1/posts    → Separate request needed for posts
GET /api/users/1/friends  → Yet another request for friends
```

**Problems:**
- **Over-fetching:** Gets all fields even if you only need name
- **Under-fetching:** Need multiple requests to get related data
- **N+1 problem:** 10 users = 1 + 10 = 11 requests for their posts

## GraphQL — Single Endpoint, Precise Data

```graphql
# Get ONLY what you need in ONE request
query {
  user(id: 1) {
    name
    email
    posts {
      title
      createdAt
    }
    friends {
      name
    }
  }
}
```

One request returns exactly: name, email, posts, and friends.

## GraphQL vs REST Comparison

| Feature | REST | GraphQL |
|---------|------|---------|
| **Endpoints** | Multiple (`/users`, `/posts`) | Single (`/graphql`) |
| **Data fetching** | Fixed — server decides | Flexible — client decides |
| **Over-fetching** | Common | Eliminated |
| **Under-fetching** | Common (N+1 problem) | Eliminated |
| **Versioning** | URL versioning (`/v1`, `/v2`) | No versioning needed |
| **HTTP method** | GET, POST, PUT, DELETE | Usually POST |
| **Response format** | JSON | JSON |
| **Learning curve** | Low | Medium |
| **Caching** | Easy (HTTP cache) | Harder (POST requests) |

## Testing GraphQL with Rest Assured

```java
@Test
public void testGraphQLQuery() {

    String query = """
        {
            "query": "{ user(id: 1) { name email } }"
        }
        """;

    given()
        .contentType(ContentType.JSON)
        .header("Authorization", "Bearer " + token)
        .body(query)
        .when()
        .post("/graphql")
        .then()
        .statusCode(200)
        .body("data.user.name", equalTo("John"))
        .body("data.user.email", equalTo("john@example.com"))
        .body("errors", nullValue()); // No errors means success
}
```

## Testing GraphQL Mutations (Create/Update/Delete)

```java
@Test
public void testGraphQLMutation() {

    String mutation = """
        {
            "query": "mutation { createUser(name: \\"Jane\\", email: \\"jane@test.com\\") { id name } }"
        }
        """;

    given()
        .contentType(ContentType.JSON)
        .body(mutation)
        .when()
        .post("/graphql")
        .then()
        .statusCode(200)
        .body("data.createUser.id", notNullValue())
        .body("data.createUser.name", equalTo("Jane"));
}
```

## In Interviews

> "GraphQL solves REST's over-fetching and under-fetching problems by letting the client specify exactly what data it needs. REST is simpler and better for public APIs and caching. GraphQL is better for complex, data-heavy applications like Facebook, GitHub, or Shopify where clients have varying data needs."$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['GraphQL', 'REST', 'API Testing', 'Query Language', 'Comparison', 'Over-fetching', 'Under-fetching'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the best practices for API testing?',
  'best-practices-for-api-testing',
  'API testing best practices include test independence, proper assertions, data cleanup, using specs for reuse, and shifting left in the SDLC.',
  $$## Best Practices for API Testing

### 1. Test Independence — Each Test Must Stand Alone

```java
// BAD: test2 depends on test1 creating the user
@Test(dependsOnMethods = "createUser")
public void getUser() { ... }

// GOOD: each test sets up its own data
@Test
public void testGetUser() {
    int userId = createTestUser(); // own setup
    given().when().get("/api/users/" + userId).then().statusCode(200);
    deleteTestUser(userId);        // own cleanup
}
```

### 2. Use RequestSpecification for Reusability

```java
// BAD: repeat headers in every test
given().header("Authorization", "Bearer " + token)
       .header("Content-Type", "application/json")
       .when().get("/users");

// GOOD: reuse spec
given(requestSpec).when().get("/users");
```

### 3. Validate More Than Just Status Code

```java
// BAD: only check status
.then().statusCode(200);

// GOOD: validate status + body + headers + response time
.then()
.statusCode(200)
.contentType(ContentType.JSON)
.header("Content-Type", containsString("application/json"))
.body("data.id", notNullValue())
.body("data.email", matchesPattern(".+@.+\\..+"))
.time(lessThan(2000L));
```

### 4. Always Clean Up Test Data

```java
@AfterMethod
public void cleanup() {
    if (createdUserId != null) {
        given(requestSpec)
            .when()
            .delete("/api/users/" + createdUserId);
    }
}
```

### 5. Use Meaningful Test Names

```java
// BAD
@Test public void test1() { ... }

// GOOD
@Test public void testCreateUser_WithValidData_Returns201() { ... }
@Test public void testCreateUser_WithMissingEmail_Returns400() { ... }
```

### 6. Test Both Positive and Negative Scenarios

- ✅ Valid data → 200/201
- ✅ Missing required field → 400
- ✅ Invalid data type → 400/422
- ✅ Unauthorized → 401
- ✅ Forbidden → 403
- ✅ Not found → 404

### 7. Use Environment Variables for Sensitive Data

```java
// BAD: hardcoded credentials
String token = "abc123secrettoken";

// GOOD: from environment/config
String token = System.getenv("API_TOKEN");
```

### 8. Keep Tests Fast and Parallel-Safe

```xml
<suite parallel="methods" thread-count="5">
```

- Use unique test data per thread (randomize emails, IDs)
- Avoid shared mutable state between tests

### 9. Log on Failure, Not Always

```java
// GOOD: only log when something fails
RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
```

### 10. Shift Left — Test APIs Early

- Start testing APIs as soon as the endpoint is deployed
- Don''t wait for the UI to be built
- Run API tests in CI/CD pipeline on every commit$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Best Practices', 'API Testing', 'Rest Assured', 'Test Design', 'Clean Code', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is response time validation in Rest Assured and how do you assert it?',
  'response-time-validation-rest-assured',
  'Use .time(lessThan(2000L)) in BDD style or System.currentTimeMillis() to measure and assert API response time in Rest Assured.',
  $$## Response Time Validation in Rest Assured

Response time is a critical non-functional requirement for APIs. Rest Assured provides built-in support for measuring and asserting response times.

### Method 1: BDD Style (Recommended)

```java
import static org.hamcrest.Matchers.lessThan;

@Test
public void testResponseTimeUnder2Seconds() {

    given()
        .when()
        .get("https://reqres.in/api/users")
        .then()
        .statusCode(200)
        .time(lessThan(2000L)); // response must be under 2000 milliseconds
}
```

### Method 2: TimeUnit Version

```java
import java.util.concurrent.TimeUnit;

@Test
public void testResponseTimeInSeconds() {

    given()
        .when()
        .get("/api/users")
        .then()
        .time(lessThan(2L), TimeUnit.SECONDS); // under 2 seconds
}
```

### Method 3: Extract and Assert Manually

```java
@Test
public void testResponseTimeManually() {

    long responseTimeMs = given()
                              .when()
                              .get("/api/users")
                              .timeIn(TimeUnit.MILLISECONDS);

    System.out.println("Response time: " + responseTimeMs + "ms");

    assertTrue(responseTimeMs < 2000,
        "Response time " + responseTimeMs + "ms exceeded 2000ms threshold");
}
```

### Method 4: With Full Assertions

```java
@Test
public void testGetUsersPerformance() {

    given()
        .header("Authorization", "Bearer " + token)
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .contentType(ContentType.JSON)
        .time(lessThan(1000L))         // under 1 second
        .body("data.size()", greaterThan(0));
}
```

### Method 5: Different SLAs by Endpoint Type

```java
// Search endpoint — can be slower
@Test
public void testSearchPerformance() {
    given().queryParam("q", "john")
           .when().get("/api/search")
           .then().time(lessThan(3000L)); // 3 seconds for complex search
}

// Simple GET — must be fast
@Test
public void testSimpleGetPerformance() {
    given().when().get("/api/users/1")
           .then().time(lessThan(500L)); // 500ms for simple lookup
}
```

## SLA Guidelines

| Operation | Target Response Time |
|-----------|---------------------|
| Simple GET (by ID) | < 200ms |
| GET list (with pagination) | < 500ms |
| POST create | < 300ms |
| Complex search/filter | < 1000ms |
| File upload | < 5000ms |
| Batch operations | < 10000ms |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Response Time', 'Performance', 'Rest Assured', 'SLA', 'Assertions', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle cookies in Rest Assured?',
  'handle-cookies-rest-assured',
  'Use .cookie() to send cookies, .cookies() to send multiple, and response.getCookies() to extract cookies from API responses.',
  $$## Handling Cookies in Rest Assured

Some APIs use cookies for session management instead of Bearer tokens. Rest Assured provides full cookie support.

### Sending a Cookie in Request

```java
@Test
public void testWithSingleCookie() {

    given()
        .cookie("session_id", "abc123xyz")
        .when()
        .get("/api/dashboard")
        .then()
        .statusCode(200);
}
```

### Sending Multiple Cookies

```java
@Test
public void testWithMultipleCookies() {

    given()
        .cookie("session_id", "abc123xyz")
        .cookie("user_role", "admin")
        .cookie("locale", "en-US")
        .when()
        .get("/api/dashboard")
        .then()
        .statusCode(200);
}
```

### Extract Cookies from Response

```java
@Test
public void testExtractCookiesFromLoginResponse() {

    // Step 1: Login and get session cookie
    Response loginResponse = given()
                                 .contentType(ContentType.JSON)
                                 .body("{ \"username\": \"admin\", \"password\": \"pass\" }")
                                 .when()
                                 .post("/api/auth/login");

    // Extract the session cookie
    String sessionCookie = loginResponse.getCookie("session_id");
    System.out.println("Session Cookie: " + sessionCookie);

    // Step 2: Use the cookie in next request
    given()
        .cookie("session_id", sessionCookie)
        .when()
        .get("/api/profile")
        .then()
        .statusCode(200);
}
```

### Get All Cookies from Response

```java
@Test
public void testGetAllResponseCookies() {

    Response response = given()
                            .when()
                            .get("/api/users");

    // Get all cookies as a map
    Map<String, String> cookies = response.getCookies();
    cookies.forEach((name, value) ->
        System.out.println(name + " = " + value));

    // Get a specific cookie
    String token = response.getCookie("auth_token");
}
```

### Validate Cookie Properties

```java
@Test
public void testCookieProperties() {

    given()
        .when()
        .post("/api/auth/login")
        .then()
        .statusCode(200)
        .cookie("session_id")                                // cookie exists
        .cookie("session_id", notNullValue())                // not null
        .cookie("session_id", not(emptyOrNullString()));     // not empty
}
```

### Using DetailedCookie for Full Attributes

```java
@Test
public void testCookieAttributesSecure() {

    DetailedCookie sessionCookie = given()
                                       .when()
                                       .post("/api/login")
                                       .then()
                                       .extract()
                                       .detailedCookie("session_id");

    assertTrue(sessionCookie.isSecured(), "Cookie should be Secure");
    assertTrue(sessionCookie.isHttpOnly(), "Cookie should be HttpOnly");
    assertEquals(sessionCookie.getPath(), "/");
}
```

## Security Checks for Cookies

| Attribute | Importance | Test |
|-----------|-----------|------|
| `Secure` | Cookie only sent over HTTPS | Must be true in production |
| `HttpOnly` | JS cannot access the cookie | Prevents XSS theft |
| `SameSite` | CSRF protection | Should be `Strict` or `Lax` |$$,
  'Rest Assured', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Cookies', 'Rest Assured', 'Session', 'Authentication', 'Security', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is BDD (Given/When/Then) syntax in Rest Assured and how does it work?',
  'bdd-given-when-then-syntax-rest-assured',
  'Rest Assured uses BDD-style Given/When/Then syntax where Given sets preconditions, When triggers the action, and Then validates the result.',
  $$## BDD Syntax in Rest Assured — Given / When / Then

Rest Assured is designed around **BDD (Behavior-Driven Development)** syntax, making API tests highly readable and self-documenting.

## The Three Pillars

```java
given()      // GIVEN: Set up the request (preconditions)
    .when()  // WHEN:  Perform the action (send request)
    .then()  // THEN:  Validate the result (assertions)
```

## Complete BDD Example

```java
@Test
public void testGetUserById() {

    given()
        // GIVEN: I have a valid auth token and request spec
        .header("Authorization", "Bearer " + token)
        .header("Accept", "application/json")

    .when()
        // WHEN: I GET user with id 2
        .get("https://reqres.in/api/users/2")

    .then()
        // THEN: I should get a 200 with correct data
        .statusCode(200)
        .contentType("application/json")
        .body("data.id",         equalTo(2))
        .body("data.first_name", equalTo("Janet"))
        .body("data.email",      containsString("@reqres.in"))
        .time(lessThan(2000L));
}
```

## Mapping BDD to English

```
GIVEN I have a logged-in user with admin role
WHEN  I send DELETE to /api/users/5
THEN  the response status should be 204
AND   the user should no longer exist
```

```java
given()
    .header("Authorization", "Bearer " + adminToken)   // logged-in admin
.when()
    .delete("/api/users/5")                              // send DELETE
.then()
    .statusCode(204);                                    // 204 No Content

// AND verify user is gone
given().when().get("/api/users/5").then().statusCode(404);
```

## BDD vs Non-BDD Style

```java
// BDD Style (Fluent) — more readable
given()
    .contentType(ContentType.JSON)
    .body("{ \"name\": \"John\" }")
    .when()
    .post("/api/users")
    .then()
    .statusCode(201)
    .body("name", equalTo("John"));

// Non-BDD Style — also valid
Response response = given()
                        .contentType(ContentType.JSON)
                        .body("{ \"name\": \"John\" }")
                        .when()
                        .post("/api/users");

assertEquals(response.getStatusCode(), 201);
assertEquals(response.path("name"), "John");
```

## When to Use Each Style

| Style | Best For |
|-------|---------|
| **BDD (fluent)** | Single assertions, readable test output |
| **Non-BDD** | Extracting values for use in next step (chaining) |
| **Mixed** | Validate response AND extract a value |

```java
// Mixed — validate AND extract
String userId = given()
                    .body("{ \"name\": \"John\" }")
                    .contentType(ContentType.JSON)
                    .when()
                    .post("/api/users")
                    .then()
                    .statusCode(201)           // validate
                    .extract().path("id");     // extract
```$$,
  'Rest Assured', 'Technical', 'Fresher', 'Beginner',
  ARRAY['BDD', 'Given When Then', 'Rest Assured', 'API Testing', 'Fluent API', 'Syntax'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is API security testing and what vulnerabilities do you test for?',
  'api-security-testing-vulnerabilities',
  'API security testing checks for OWASP API Top 10 vulnerabilities including broken auth, SQL injection, excessive data exposure, BOLA, and SSRF.',
  $$## API Security Testing

API security testing verifies that APIs are protected against common attacks and vulnerabilities. The **OWASP API Security Top 10** is the industry standard reference.

## OWASP API Security Top 10

### 1. Broken Object Level Authorization (BOLA/IDOR)
Accessing another user's data by changing the ID:

```java
@Test
public void testIDORVulnerability() {
    // User 1 should NOT be able to access User 2's orders
    given()
        .header("Authorization", "Bearer " + user1Token)
        .when()
        .get("/api/users/2/orders")  // accessing user 2 as user 1
        .then()
        .statusCode(403); // Must be 403, NOT 200
}
```

### 2. Broken Authentication

```java
@Test
public void testWeakPassword() {
    given()
        .body("{ \"username\": \"admin\", \"password\": \"123\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/auth/login")
        .then()
        .statusCode(400) // Should reject weak passwords
        .body("error", containsString("Password too weak"));
}

@Test
public void testBruteForceProtection() {
    // After 5 failed attempts, should get 429
    for (int i = 0; i < 5; i++) {
        given().body("{ \"username\": \"admin\", \"password\": \"wrong\" + i }")
               .contentType(ContentType.JSON)
               .when().post("/api/auth/login");
    }

    given().body("{ \"username\": \"admin\", \"password\": \"wrong6\" }")
           .contentType(ContentType.JSON)
           .when().post("/api/auth/login")
           .then().statusCode(429); // Too Many Requests
}
```

### 3. Excessive Data Exposure

```java
@Test
public void testNoSensitiveDataExposed() {
    Response response = given()
                            .when()
                            .get("/api/users/1");

    String body = response.getBody().asString();

    // Sensitive fields should NOT appear in response
    assertFalse(body.contains("password"), "Password should not be in response");
    assertFalse(body.contains("credit_card"), "Credit card should not be in response");
    assertFalse(body.contains("ssn"), "SSN should not be in response");
}
```

### 4. SQL Injection

```java
@Test
public void testSQLInjectionInQueryParam() {
    given()
        .queryParam("id", "1 OR 1=1")
        .when()
        .get("/api/users")
        .then()
        .statusCode(anyOf(equalTo(400), equalTo(404)))
        // Should NOT return all users due to SQL injection
        .statusCode(not(200));
}

@Test
public void testSQLInjectionInBody() {
    given()
        .body("{ \"username\": \"admin'' OR ''1''=''1\", \"password\": \"x\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/auth/login")
        .then()
        .statusCode(anyOf(equalTo(400), equalTo(401)))
        .statusCode(not(200)); // Must NOT succeed
}
```

### 5. Lack of Rate Limiting

```java
@Test
public void testPasswordResetRateLimited() {
    for (int i = 0; i < 10; i++) {
        given().body("{ \"email\": \"user@test.com\" }")
               .contentType(ContentType.JSON)
               .when().post("/api/auth/forgot-password");
    }

    given().body("{ \"email\": \"user@test.com\" }")
           .contentType(ContentType.JSON)
           .when().post("/api/auth/forgot-password")
           .then().statusCode(429);
}
```

### 6. Mass Assignment Vulnerability

```java
@Test
public void testMassAssignmentProtection() {
    // User should NOT be able to set themselves as admin
    given()
        .header("Authorization", "Bearer " + userToken)
        .body("{ \"name\": \"John\", \"role\": \"admin\", \"is_admin\": true }")
        .contentType(ContentType.JSON)
        .when()
        .put("/api/users/profile")
        .then()
        .statusCode(200)
        // Role should remain 'user', not 'admin'
        .body("role", not(equalTo("admin")));
}
```

## Security Test Checklist

| Vulnerability | Test |
|---------------|------|
| BOLA/IDOR | Access other users' resources |
| Broken Auth | Brute force, weak passwords |
| Data Exposure | Check for sensitive fields in response |
| SQL Injection | Inject SQL in params and body |
| Rate Limiting | Flood endpoint, check 429 |
| Mass Assignment | Try to set privileged fields |
| CORS | Test unauthorized origins |
| JWT | Test expired/tampered tokens |$$,
  'Rest Assured', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Security Testing', 'OWASP', 'SQL Injection', 'BOLA', 'IDOR', 'Rest Assured', 'API Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to import and export Postman collections, and what are Postman workspaces?',
  'import-export-postman-collections-workspaces',
  'Export collections as JSON from the ... menu and share them via file or Postman cloud. Workspaces are shared project spaces for team collaboration.',
  $$## Import/Export Postman Collections

### Exporting a Collection

1. Click on your **Collection** in the sidebar
2. Click the **...** (three dots) menu
3. Select **Export**
4. Choose **Collection v2.1** (recommended) or v2.0
5. Click **Export** and save the JSON file

The exported file (`MyCollection.json`) can be:
- Committed to **Git** for version control
- Shared via **email/Slack**
- Used with **Newman** for CI/CD

### Importing a Collection

**Method 1: Drag and Drop**
Simply drag the `.json` file into the Postman window.

**Method 2: Import Button**
1. Click **Import** (top left)
2. Choose: File, Folder, Link, Raw text, or Code
3. Select your file → Click **Import**

**Method 3: Import from URL**
```
Import → Link → https://raw.githubusercontent.com/org/repo/main/collection.json
```

**Method 4: Import from GitHub**
1. Import → Code Repository → Connect GitHub
2. Select your repository and collection file

### Import Environment

```json
// staging-environment.json
{
  "name": "Staging",
  "values": [
    { "key": "base_url", "value": "https://api.staging.com", "enabled": true },
    { "key": "api_token", "value": "staging-token-xyz", "enabled": true }
  ]
}
```

Import via: **Import → Files → Select environment.json**

---

## Postman Workspaces

A **Workspace** is a collaborative environment where you organize and share collections, environments, and APIs with your team.

### Types of Workspaces

| Type | Visibility | Use Case |
|------|-----------|---------|
| **Personal** | Only you | Personal experiments |
| **Team** | All team members | Shared project APIs |
| **Private** | Invited members only | Confidential internal APIs |
| **Public** | Everyone on internet | Open-source API docs |

### Creating a Workspace

1. Click **Workspaces** (top menu)
2. Click **Create Workspace**
3. Choose type: Personal / Team / Private / Public
4. Add team members (for Team/Private)
5. Move collections into the workspace

### Benefits of Team Workspaces

- Everyone sees the **same collections** without exporting/importing
- Changes are **synced in real-time**
- Share environments (staging, prod configs)
- **Activity feed** — see who changed what and when
- **Role-based access** — admin, editor, viewer

### Workspace Best Practices

```
📁 Team Workspace: "User Service API"
  ├── 📂 Collections
  │   ├── User API Tests
  │   ├── Auth API Tests
  │   └── Regression Suite
  ├── 🌍 Environments
  │   ├── Development
  │   ├── Staging
  │   └── Production
  └── 📋 APIs
      └── User Service OpenAPI Spec
```$$,
  'Postman', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Postman', 'Import', 'Export', 'Workspaces', 'Collections', 'Team Collaboration'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle file uploads in Postman?',
  'file-upload-postman',
  'Use Body > form-data in Postman, select File type for the file field, and choose your file to upload to the API.',
  $$## File Upload in Postman

Postman supports file uploads using the **form-data** body type, which sends files as `multipart/form-data`.

## Step-by-Step File Upload

1. **Set method to POST** (or PUT)
2. **Enter the upload URL:** `https://api.example.com/upload`
3. **Click the Body tab**
4. **Select form-data** radio button
5. **Add a key field:**
   - Type: `file` (name of the file parameter the API expects)
   - Hover over the key field → dropdown appears
   - Change type from **Text** to **File**
6. **Click "Select Files"** in the Value column
7. **Browse and select your file** (PDF, image, CSV, etc.)
8. **Click Send**

## Multiple Files

```
KEY         TYPE    VALUE
files       File    [Select document1.pdf]
files       File    [Select document2.pdf]
description Text    "Batch upload test"
```

## File Upload with Additional Fields

```
KEY             TYPE    VALUE
file            File    [Select profile.jpg]
user_id         Text    12345
title           Text    "Profile Picture"
is_public       Text    true
```

## Checking Upload Worked

```javascript
// In Tests tab — validate upload response
pm.test("File uploaded successfully", function () {
    pm.response.to.have.status(200);
    const json = pm.response.json();
    pm.expect(json.file_id).to.be.a('string');
    pm.expect(json.url).to.match(/^https/);
    pm.expect(json.size).to.be.above(0);
});

pm.test("Filename is correct", function () {
    const json = pm.response.json();
    pm.expect(json.filename).to.include("profile");
});
```

## Using Variables for File Paths

In **Postman Desktop**, you can use the `pm.iterationData` to pass file paths in Collection Runner:

```javascript
// Pre-request Script
const filePath = pm.iterationData.get("file_path");
// Note: Postman doesn't support dynamic file paths via variables
// File selection must be done manually in form-data
```

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| 400 Bad Request | Wrong field name | Match API's expected parameter name |
| 413 Payload Too Large | File too big | Check API's max file size |
| 415 Unsupported Media Type | Wrong content type | Use form-data, not raw |
| File not attached | Type is Text not File | Change key type to File |

## Testing Upload Limits

Test with:
- ✅ Valid file types (PDF, JPG, PNG, CSV)
- ✅ File at size limit (e.g., exactly 5MB)
- ❌ Oversized file (e.g., 6MB when limit is 5MB) → expect 413
- ❌ Invalid file type (e.g., .exe when only images allowed) → expect 400$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'File Upload', 'form-data', 'multipart', 'API Testing', 'POST'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you write assertions for arrays and nested objects in Postman test scripts?',
  'assertions-arrays-nested-objects-postman',
  'Use pm.response.json() to parse, then access arrays with index notation and validate each element with forEach or find.',
  $$## Array and Nested Object Assertions in Postman

### Basic Array Access

```javascript
const json = pm.response.json();

// Access array element by index
pm.test("First user ID is 1", function () {
    pm.expect(json.data[0].id).to.equal(1);
});

// Check array length
pm.test("Returns 6 users", function () {
    pm.expect(json.data).to.have.length(6);
});

// Check array is not empty
pm.test("Data is not empty", function () {
    pm.expect(json.data).to.be.an('array').that.is.not.empty;
});
```

### Validate Every Element in Array

```javascript
pm.test("All users have email addresses", function () {
    json.data.forEach(function(user) {
        pm.expect(user.email).to.be.a('string');
        pm.expect(user.email).to.include('@');
        pm.expect(user.id).to.be.a('number').above(0);
    });
});
```

### Nested Object Assertions

```javascript
// Response:
// {
//   "data": {
//     "id": 2,
//     "email": "janet@reqres.in",
//     "first_name": "Janet",
//     "avatar": "https://cdn...."
//   },
//   "support": {
//     "url": "https://reqres.in/#support-heading",
//     "text": "To keep..."
//   }
// }

pm.test("Nested: user data is correct", function () {
    pm.expect(json.data.id).to.equal(2);
    pm.expect(json.data.first_name).to.equal("Janet");
    pm.expect(json.data.email).to.include("reqres.in");
    pm.expect(json.data.avatar).to.match(/^https:\/\//);
});

pm.test("Nested: support object exists", function () {
    pm.expect(json.support).to.be.an('object');
    pm.expect(json.support.url).to.be.a('string');
    pm.expect(json.support.text).to.be.a('string').and.not.empty;
});
```

### Find Element in Array

```javascript
pm.test("Find user with id 3 in results", function () {
    const user = json.data.find(u => u.id === 3);
    pm.expect(user).to.not.be.undefined;
    pm.expect(user.first_name).to.be.a('string');
});
```

### Array Contains Specific Value

```javascript
pm.test("Roles array includes 'admin'", function () {
    const roles = json.user.roles; // ["admin", "editor"]
    pm.expect(roles).to.include('admin');
});
```

### Deep Equal for Object

```javascript
pm.test("User object matches expected", function () {
    pm.expect(json.data).to.deep.include({
        id: 2,
        first_name: "Janet",
        last_name: "Weaver"
    });
});
```

### Array of Objects Validation

```javascript
pm.test("All orders have required fields", function () {
    const orders = json.orders;
    orders.forEach(order => {
        pm.expect(order).to.have.property('id');
        pm.expect(order).to.have.property('status');
        pm.expect(order).to.have.property('total');
        pm.expect(order.total).to.be.above(0);
        pm.expect(['pending', 'completed', 'cancelled'])
            .to.include(order.status);
    });
});
```

### Filter and Validate

```javascript
pm.test("All active users have email verified", function () {
    const activeUsers = json.data.filter(u => u.status === 'active');
    activeUsers.forEach(u => {
        pm.expect(u.email_verified).to.equal(true);
    });
});
```$$,
  'Postman', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Postman', 'Assertions', 'Arrays', 'Nested Objects', 'Test Scripts', 'JavaScript', 'pm.response.json'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the purpose of the pm.sendRequest() in Postman and how do you use it?',
  'pm-sendrequest-postman-pre-request',
  'pm.sendRequest() lets you make HTTP calls inside Pre-request Scripts to fetch tokens, set up test data, or chain API calls before the main request.',
  $$## pm.sendRequest() in Postman

`pm.sendRequest()` allows you to make **asynchronous HTTP calls from within scripts** (Pre-request or Tests). It is the key to advanced request chaining in Postman.

## Primary Use Cases

1. **Fetch an auth token before the main request**
2. **Set up test data** (create a user before testing)
3. **Get dynamic values** (timestamps, IDs) for use in the request
4. **Clean up data** after a test

## Syntax

```javascript
pm.sendRequest(requestObject, callback);

// requestObject can be:
// 1. A URL string: "https://api.example.com/data"
// 2. A full request object with method, headers, body
```

## Example 1: Fetch Auth Token Before Request

Put this in the **Pre-request Script** of your main request:

```javascript
pm.sendRequest({
    url: pm.environment.get("base_url") + "/auth/login",
    method: "POST",
    header: {
        "Content-Type": "application/json"
    },
    body: {
        mode: "raw",
        raw: JSON.stringify({
            username: pm.environment.get("username"),
            password: pm.environment.get("password")
        })
    }
}, function (err, response) {
    if (err) {
        console.error("Login failed:", err);
        return;
    }

    const token = response.json().access_token;
    pm.environment.set("auth_token", token);
    console.log("Token fetched successfully");
});

// Now in the main request Headers:
// Authorization: Bearer {{auth_token}}
```

## Example 2: Create Test Data Before Test

```javascript
// Pre-request Script — create a user to test getting them
pm.sendRequest({
    url: pm.environment.get("base_url") + "/api/users",
    method: "POST",
    header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + pm.environment.get("admin_token")
    },
    body: {
        mode: "raw",
        raw: JSON.stringify({
            name: "Test User " + Date.now(),
            email: "test_" + Date.now() + "@example.com"
        })
    }
}, function (err, res) {
    const newUserId = res.json().id;
    pm.environment.set("created_user_id", newUserId);
    console.log("Created test user with ID:", newUserId);
});

// Main request: GET {{base_url}}/api/users/{{created_user_id}}
```

## Example 3: Clean Up After Test (in Tests tab)

```javascript
// Tests tab — delete test data after validation
pm.test("User created successfully", function () {
    pm.response.to.have.status(201);
});

// Cleanup
const userId = pm.response.json().id;
pm.sendRequest({
    url: pm.environment.get("base_url") + "/api/users/" + userId,
    method: "DELETE",
    header: { "Authorization": "Bearer " + pm.environment.get("auth_token") }
}, function (err, res) {
    console.log("Cleanup: deleted user " + userId + ", status: " + res.code);
});
```

## Key Points

| Feature | Detail |
|---------|--------|
| Location | Pre-request Script or Tests tab |
| Async | Yes — uses callback function |
| Error handling | Check `err` parameter in callback |
| Use case | Token fetch, data setup, cleanup |
| Alternative | Collection Runner with ordered requests |$$,
  'Postman', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Postman', 'pm.sendRequest', 'Pre-request Script', 'API Chaining', 'Auth Token', 'Advanced'], true, 0
);
