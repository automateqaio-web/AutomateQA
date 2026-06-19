-- API Scenario-Based Questions Q1–Q15 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you test authentication functionality of an API using Rest Assured?',
  'test-authentication-api-rest-assured-scenario',
  'Validate auth with valid credentials, invalid credentials, missing tokens, and expired tokens to cover all auth scenarios.',
  $$## Scenario: Testing API Authentication

You are tasked with testing the authentication functionality of an API using Rest Assured.

## Approach

### Step 1: Understand the Auth Mechanism
First, I would ensure that I have clear documentation or understanding of the authentication mechanism — whether it is basic authentication, OAuth, or token-based authentication.

### Step 2: Write Test Cases

**Happy Path — Valid Credentials:**
```java
@Test
public void testLoginWithValidCredentials() {
    String body = "{ \"username\": \"admin\", \"password\": \"admin123\" }";

    Response response = given()
                            .contentType(ContentType.JSON)
                            .body(body)
                            .when()
                            .post("/api/auth/login");

    assertEquals(response.getStatusCode(), 200);
    assertNotNull(response.jsonPath().getString("token"));

    // Save token for subsequent requests
    String token = response.jsonPath().getString("token");
    System.out.println("Token: " + token);
}
```

**Negative Path — Invalid Credentials:**
```java
@Test
public void testLoginWithInvalidCredentials() {
    String body = "{ \"username\": \"admin\", \"password\": \"wrongpassword\" }";

    given()
        .contentType(ContentType.JSON)
        .body(body)
        .when()
        .post("/api/auth/login")
        .then()
        .statusCode(401)
        .body("error", equalTo("Invalid credentials"));
}
```

**Missing Token Scenario:**
```java
@Test
public void testAccessProtectedRouteWithoutToken() {
    given()
        .when()
        .get("/api/protected/resource")
        .then()
        .statusCode(401)
        .body("message", containsString("token"));
}
```

**Expired Token Scenario:**
```java
@Test
public void testWithExpiredToken() {
    String expiredToken = "eyJhbGciOiJIUzI1NiJ9.expired.signature";

    given()
        .header("Authorization", "Bearer " + expiredToken)
        .when()
        .get("/api/users")
        .then()
        .statusCode(401)
        .body("error", equalTo("Token expired"));
}
```

### Step 3: Verify Edge Cases
- Empty username/password → 400 Bad Request
- SQL injection in credentials → 400/401 (not 500)
- Very long password strings → 400
- Special characters in password → Should work if valid

## Test Coverage Matrix

| Scenario | Expected Status |
|----------|----------------|
| Valid credentials | 200 |
| Wrong password | 401 |
| Non-existent user | 401 or 404 |
| Missing auth header | 401 |
| Expired token | 401 |
| Malformed token | 401 |
| Missing required field | 400 |$$,
  'API Automation', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['API Testing', 'Authentication', 'Rest Assured', 'Security Testing', 'JWT', 'OAuth', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you design test cases for an API endpoint that retrieves user data based on criteria?',
  'design-test-cases-api-endpoint-user-data-retrieval',
  'Design tests for valid criteria combinations, invalid inputs, edge cases, pagination, sorting, and performance scenarios.',
  $$## Scenario: Testing a User Data Retrieval API Endpoint

You need to test an API endpoint `GET /api/users` that retrieves user data based on certain criteria.

## Approach

### Step 1: Identify All Criteria/Filters
- `gender` — male/female/other
- `status` — active/inactive
- `page` / `per_page` — pagination
- `sort_by` — name/email/created_at
- `search` — partial name search

### Step 2: Design Test Cases

**Valid Criteria Combinations:**
```java
@Test
public void testGetUsersByGender() {
    given()
        .queryParam("gender", "female")
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .body("data.size()", greaterThan(0))
        .body("data.gender", everyItem(equalTo("female")));
}

@Test
public void testGetUsersByStatusActive() {
    given()
        .queryParam("status", "active")
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .body("data.status", everyItem(equalTo("active")));
}

@Test
public void testGetUsersWithPagination() {
    given()
        .queryParam("page", 2)
        .queryParam("per_page", 5)
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .body("page", equalTo(2))
        .body("per_page", equalTo(5))
        .body("data.size()", lessThanOrEqualTo(5));
}
```

**Edge Cases — Non-existent Users:**
```java
@Test
public void testGetNonExistentUser() {
    given()
        .when()
        .get("/api/users/99999")
        .then()
        .statusCode(404)
        .body("message", containsString("not found"));
}
```

**Invalid Criteria:**
```java
@Test
public void testInvalidGenderFilter() {
    given()
        .queryParam("gender", "robot")
        .when()
        .get("/api/users")
        .then()
        .statusCode(400)
        .body("error", containsString("Invalid value for gender"));
}
```

**Performance Test:**
```java
@Test
public void testResponseTimeForUserList() {
    given()
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .time(lessThan(2000L)); // response under 2 seconds
}
```

### Step 3: Validate Response Structure
```java
@Test
public void testUserResponseSchema() {
    given()
        .when()
        .get("/api/users/1")
        .then()
        .statusCode(200)
        .body("data", hasKey("id"))
        .body("data", hasKey("email"))
        .body("data", hasKey("first_name"))
        .body("data", hasKey("last_name"));
}
```

## Test Coverage Matrix

| Test Type | Scenarios |
|-----------|-----------|
| Valid filters | gender, status, search |
| Pagination | page, per_page, last page |
| Invalid input | wrong values, missing required |
| Edge cases | empty result set, non-existent user |
| Performance | response time < 2s |
| Security | auth token required |$$,
  'API Automation', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['API Testing', 'Test Design', 'REST Assured', 'Pagination', 'Filters', 'Edge Cases', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'You are testing an e-commerce website and customers report checkout issues. How would you approach testing this?',
  'testing-ecommerce-checkout-issues-approach',
  'Reproduce the issue, analyze logs, isolate components, run automated regression, and collaborate with developers to resolve.',
  $$## Scenario: E-Commerce Checkout Testing

Customers are reporting issues with the checkout process. Here is a systematic approach.

## Approach

### 1. Reproduce the Issue
Start by reproducing the issue reported by customers. This helps in understanding the exact problem.

```
- Collect exact steps customers followed
- Identify browser/device combinations where it occurs
- Try different payment methods, shipping addresses, product types
- Check if it's intermittent or consistent
```

### 2. Check Logs
Analyze server logs, client-side logs, and any error messages to identify where the issue might be occurring.

```bash
# Check application logs
grep -i "checkout\|payment\|order" app.log | tail -100

# Check API error logs
grep "500\|400\|422" api-access.log | grep "/api/checkout"
```

### 3. API Testing of Checkout Flow

```java
@Test
public void testCompleteCheckoutFlow() {

    // Step 1: Add item to cart
    String addToCart = given()
        .header("Authorization", "Bearer " + token)
        .body("{ \"product_id\": \"SKU123\", \"quantity\": 2 }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/cart/add")
        .then()
        .statusCode(200)
        .extract().path("cart_id");

    // Step 2: Apply coupon
    given()
        .header("Authorization", "Bearer " + token)
        .body("{ \"cart_id\": \"" + addToCart + "\", \"coupon\": \"SAVE10\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/cart/coupon")
        .then()
        .statusCode(200);

    // Step 3: Set shipping address
    given()
        .header("Authorization", "Bearer " + token)
        .body("{ \"cart_id\": \"" + addToCart + "\", \"address_id\": \"ADDR001\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/cart/shipping")
        .then()
        .statusCode(200);

    // Step 4: Place order
    given()
        .header("Authorization", "Bearer " + token)
        .body("{ \"cart_id\": \"" + addToCart + "\", \"payment_method\": \"card\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/orders/create")
        .then()
        .statusCode(201)
        .body("order_id", notNullValue())
        .body("status", equalTo("pending"));
}
```

### 4. Isolate Components
Break down the checkout process and test each component separately:
- Cart updates correctly?
- Payment gateway API is functioning?
- Inventory check is passing?
- Email notification triggered?

### 5. Run Automated Regression Tests
```java
@Test
public void testPaymentGatewayIntegration() {
    // Test with valid card
    testPaymentWithCard("4111111111111111", 200, "success");
    // Test with declined card
    testPaymentWithCard("4000000000000002", 402, "declined");
    // Test with invalid card
    testPaymentWithCard("1234567890123456", 400, "invalid");
}
```

### 6. Usability & Cross-Browser Testing
- Test on Chrome, Firefox, Safari, Edge
- Test on mobile devices (iOS/Android)
- Test with slow network (3G simulation)

### 7. Collaborate with Developers
Share specific API request/response logs, error stack traces, and reproduction steps with the dev team.$$,
  'API Automation', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['E-Commerce', 'Checkout', 'API Testing', 'Debugging', 'Regression', 'Test Strategy', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'You are on a tight deadline with many API test cases. What strategies would you use to meet the deadline without compromising quality?',
  'tight-deadline-many-api-tests-strategies',
  'Prioritize P1 critical APIs, automate with Rest Assured, use data-driven testing, run tests in parallel, and use risk-based testing.',
  $$## Scenario: Tight Deadline with Many API Test Cases

## Strategy

### 1. Prioritize Test Cases (Risk-Based Testing)

**P1 — Critical (Must test):**
- Authentication/Authorization APIs
- Payment/checkout APIs
- Data creation APIs (POST)
- Core business workflow

**P2 — High Priority:**
- Read endpoints (GET)
- Update APIs (PUT/PATCH)
- Error handling (400, 401, 404)

**P3 — Lower Priority:**
- Edge cases
- Performance tests
- Rarely-used endpoints

```java
// Tag tests by priority in TestNG
@Test(groups = {"P1", "critical"})
public void testPaymentAPI() { ... }

@Test(groups = {"P2", "regression"})
public void testGetAllUsers() { ... }
```

### 2. Parallel Test Execution

```xml
<!-- TestNG suite file -->
<suite name="API Tests" parallel="methods" thread-count="5">
    <test name="Critical API Tests">
        <classes>
            <class name="tests.AuthApiTest"/>
            <class name="tests.PaymentApiTest"/>
            <class name="tests.UserApiTest"/>
        </classes>
    </test>
</suite>
```

Running tests in parallel can reduce 100 minutes → 20 minutes.

### 3. Data-Driven Testing to Maximize Coverage

```java
@DataProvider(name = "userData")
public Object[][] userData() {
    return new Object[][] {
        {"John", "john@test.com", "active", 201},
        {"",     "invalid",       "active", 400},
        {"Jane", "jane@test.com", "",       400}
    };
}

@Test(dataProvider = "userData")
public void testCreateUser(String name, String email, String status, int expectedCode) {
    String body = String.format("{ \"name\": \"%s\", \"email\": \"%s\", \"status\": \"%s\" }", name, email, status);

    given().body(body).contentType(ContentType.JSON)
           .when().post("/api/users")
           .then().statusCode(expectedCode);
}
```

One test method covers 3 scenarios — maximizing coverage with minimal code.

### 4. Automated Smoke Suite First

Run the 10 most critical tests first:
```bash
mvn test -Dgroups="smoke" -DthreadCount=5
```

If smoke fails, alert immediately. If smoke passes, proceed with full regression.

### 5. Use Pre-built Utilities

```java
// Reuse base spec instead of repeating setup in every test
public static RequestSpecification getBaseSpec() {
    return given()
                .baseUri(BASE_URL)
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + getToken());
}
```

### 6. Shift-Left — Test Early

Don't wait for the full build. Test each API as soon as it's deployed to the test environment.

## Timeline Strategy for Tight Deadline

| Phase | Time | Activity |
|-------|------|---------|
| 30 min | Setup | Configure environment, auth tokens |
| 2 hours | P1 tests | Critical auth, payment, CRUD |
| 1 hour | P2 tests | Regression, pagination, sorting |
| 1 hour | Negative tests | 400, 401, 404, 422 |
| 30 min | Report | Generate HTML report, share results |$$,
  'API Automation', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['API Testing', 'Test Strategy', 'Prioritization', 'Parallel Testing', 'Data-Driven', 'Tight Deadline', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you test a new API feature involving user authentication and authorization?',
  'test-api-user-authentication-authorization-feature',
  'Test RBAC, JWT tokens, session management, security vulnerabilities, and performance of the auth system comprehensively.',
  $$## Scenario: Testing Authentication and Authorization Feature

## Approach

### 1. Requirements Review
Ensure authentication and authorization requirements are well-defined:
- Which endpoints require authentication?
- What roles exist (admin, user, guest)?
- What can each role access?

### 2. Role-Based Access Control (RBAC) Testing

```java
@Test
public void testAdminCanAccessAllResources() {
    given()
        .header("Authorization", "Bearer " + adminToken)
        .when()
        .get("/api/admin/users")
        .then()
        .statusCode(200);
}

@Test
public void testUserCannotAccessAdminEndpoints() {
    given()
        .header("Authorization", "Bearer " + userToken)
        .when()
        .get("/api/admin/users")
        .then()
        .statusCode(403)
        .body("error", containsString("Forbidden"));
}

@Test
public void testGuestCanOnlyAccessPublicEndpoints() {
    // No auth header
    given()
        .when()
        .get("/api/public/products")
        .then()
        .statusCode(200);

    given()
        .when()
        .get("/api/private/orders")
        .then()
        .statusCode(401);
}
```

### 3. JWT Token Testing

```java
@Test
public void testJWTTokenContainsRequiredClaims() {
    Response loginResponse = given()
        .body("{ \"username\": \"admin\", \"password\": \"admin123\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/auth/login");

    String token = loginResponse.jsonPath().getString("token");

    // Decode JWT and verify claims
    // (Use java-jwt or nimbus-jose-jwt library)
    assertNotNull(token);

    // Token should expire in 1 hour
    String expiry = loginResponse.jsonPath().getString("expires_in");
    assertEquals(expiry, "3600");
}

@Test
public void testExpiredTokenRejected() {
    String expiredToken = "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDAwMDAwMDB9.invalid";

    given()
        .header("Authorization", "Bearer " + expiredToken)
        .when()
        .get("/api/users")
        .then()
        .statusCode(401)
        .body("error", equalTo("Token expired"));
}
```

### 4. Security Testing

```java
@Test
public void testSQLInjectionInLoginEndpoint() {
    String maliciousBody = "{ \"username\": \"admin'' OR ''1''=''1\", \"password\": \"x\" }";

    given()
        .contentType(ContentType.JSON)
        .body(maliciousBody)
        .when()
        .post("/api/auth/login")
        .then()
        .statusCode(anyOf(equalTo(400), equalTo(401)))
        // Should NOT return 200
        .statusCode(not(equalTo(200)));
}

@Test
public void testBruteForceProtection() {
    // After 5 failed attempts, should be locked out
    for (int i = 0; i < 5; i++) {
        given()
            .body("{ \"username\": \"user@test.com\", \"password\": \"wrong\" }")
            .contentType(ContentType.JSON)
            .when()
            .post("/api/auth/login");
    }

    // 6th attempt should be rate-limited
    given()
        .body("{ \"username\": \"user@test.com\", \"password\": \"wrong\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/auth/login")
        .then()
        .statusCode(429); // Too Many Requests
}
```

### 5. Session Management Testing

```java
@Test
public void testLogoutInvalidatesToken() {
    String token = getAuthToken();

    // Logout
    given()
        .header("Authorization", "Bearer " + token)
        .when()
        .post("/api/auth/logout")
        .then()
        .statusCode(200);

    // Try using the token after logout
    given()
        .header("Authorization", "Bearer " + token)
        .when()
        .get("/api/users")
        .then()
        .statusCode(401); // Token should now be invalid
}
```

## Test Coverage Summary

| Category | Tests |
|----------|-------|
| Auth success/fail | Valid/invalid credentials |
| RBAC | Admin, User, Guest role access |
| Token validation | Expiry, format, claims |
| Security | SQL injection, brute force |
| Session | Logout, token invalidation |
| Performance | Auth response < 500ms |$$,
  'API Automation', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Authentication', 'Authorization', 'RBAC', 'JWT', 'Security Testing', 'API Testing', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'You are testing a file-sharing app where uploaded files are occasionally corrupted. How would you investigate this?',
  'testing-file-upload-corruption-investigation',
  'Reproduce with various file types, test API upload endpoint directly, verify checksums, test network conditions, and check error handling.',
  $$## Scenario: Investigating File Upload Corruption

Users report that uploaded files are occasionally corrupted. Here''s how to investigate using API testing.

## Approach

### 1. Reproduce the Issue

```java
@Test
public void testFileUploadSmallFile() throws IOException {
    File smallFile = new File("src/test/resources/test_small.pdf");

    Response response = given()
                            .header("Authorization", "Bearer " + token)
                            .multiPart("file", smallFile, "application/pdf")
                            .when()
                            .post("/api/files/upload");

    assertEquals(response.getStatusCode(), 200);
    assertNotNull(response.jsonPath().getString("file_id"));
}

@Test
public void testFileUploadLargeFile() throws IOException {
    File largeFile = new File("src/test/resources/test_large_50mb.zip");

    Response response = given()
                            .header("Authorization", "Bearer " + token)
                            .multiPart("file", largeFile, "application/zip")
                            .when()
                            .post("/api/files/upload");

    assertEquals(response.getStatusCode(), 200);
}
```

### 2. Implement Checksum Verification

```java
@Test
public void testFileIntegrityWithChecksum() throws IOException, NoSuchAlgorithmException {
    File uploadFile = new File("src/test/resources/test_document.pdf");

    // Calculate MD5 before upload
    String originalMD5 = calculateMD5(uploadFile);

    // Upload the file
    Response uploadResponse = given()
                                .header("Authorization", "Bearer " + token)
                                .multiPart("file", uploadFile)
                                .when()
                                .post("/api/files/upload");

    String fileId = uploadResponse.jsonPath().getString("file_id");
    String serverChecksum = uploadResponse.jsonPath().getString("checksum");

    // Compare checksums
    assertEquals(originalMD5, serverChecksum,
        "File checksum mismatch — file may be corrupted during upload!");

    // Download and verify again
    byte[] downloadedFile = given()
                                .header("Authorization", "Bearer " + token)
                                .when()
                                .get("/api/files/" + fileId + "/download")
                                .asByteArray();

    String downloadedMD5 = calculateMD5ByteArray(downloadedFile);
    assertEquals(originalMD5, downloadedMD5, "Downloaded file is corrupted!");
}

private String calculateMD5(File file) throws IOException, NoSuchAlgorithmException {
    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] bytes = Files.readAllBytes(file.toPath());
    byte[] hash = md.digest(bytes);
    return DatatypeConverter.printHexBinary(hash).toLowerCase();
}
```

### 3. Test Different File Types

```java
@DataProvider(name = "fileTypes")
public Object[][] fileTypes() {
    return new Object[][] {
        {"test.pdf", "application/pdf"},
        {"test.jpg", "image/jpeg"},
        {"test.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
        {"test.zip", "application/zip"},
        {"test.csv", "text/csv"}
    };
}

@Test(dataProvider = "fileTypes")
public void testUploadByFileType(String fileName, String mimeType) {
    File file = new File("src/test/resources/" + fileName);

    given()
        .header("Authorization", "Bearer " + token)
        .multiPart("file", file, mimeType)
        .when()
        .post("/api/files/upload")
        .then()
        .statusCode(200)
        .body("status", equalTo("success"));
}
```

### 4. Test Network Condition Edge Cases

```java
@Test
public void testUploadWithSlowConnection() {
    // Simulate slow network — use connection throttling in test environment
    // Or test with a proxy like Charles set to throttle bandwidth

    File largeFile = new File("src/test/resources/large_file.pdf");

    Response response = given()
                            .config(RestAssured.config()
                                .httpClient(HttpClientConfig.httpClientConfig()
                                    .setParam(CoreConnectionPNames.CONNECTION_TIMEOUT, 60000)
                                    .setParam(CoreConnectionPNames.SO_TIMEOUT, 60000)))
                            .multiPart("file", largeFile)
                            .when()
                            .post("/api/files/upload");

    // Should succeed even on slow connection
    assertEquals(response.getStatusCode(), 200);
}
```

### 5. Test Upload Interruption / Resume

```java
@Test
public void testUploadResumable() {
    // Test that partial uploads are handled gracefully
    given()
        .header("Authorization", "Bearer " + token)
        .header("Content-Range", "bytes 0-1023/10240")
        .when()
        .post("/api/files/upload/resumable")
        .then()
        .statusCode(206); // Partial Content — resumable upload supported
}
```

## Investigation Findings Template

| Check | Status | Notes |
|-------|--------|-------|
| Small files (<1MB) | ✅ OK | No corruption |
| Large files (>10MB) | ❌ Fail | Corruption at 10MB+ |
| PDF files | ✅ OK | All valid |
| Binary/ZIP files | ❌ Fail | Encoding issue suspected |
| MD5 checksum match | ❌ Fail | Server-side checksum differs |
| Slow network | ❌ Fail | Timeout causes partial write |$$,
  'API Automation', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['File Upload', 'API Testing', 'Checksum', 'Data Integrity', 'Multipart', 'Rest Assured', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How would you design an API test automation framework from scratch for a team?',
  'design-api-test-automation-framework-team',
  'Use layered architecture with base config, request builders, POJOs, utility classes, and CI integration for maintainable API automation.',
  $$## Scenario: Designing an API Test Automation Framework

## Framework Architecture

```
api-test-framework/
├── src/
│   ├── main/java/
│   │   ├── config/
│   │   │   └── ConfigManager.java       ← Read config.properties
│   │   ├── api/
│   │   │   ├── BaseApi.java             ← Base RequestSpec setup
│   │   │   ├── UserApi.java             ← User endpoint methods
│   │   │   ├── AuthApi.java             ← Auth endpoint methods
│   │   │   └── OrderApi.java            ← Order endpoint methods
│   │   ├── models/
│   │   │   ├── User.java                ← POJO for User
│   │   │   └── Order.java               ← POJO for Order
│   │   └── utils/
│   │       ├── TestDataFactory.java     ← Generate test data
│   │       └── FileUtils.java           ← File helpers
│   └── test/java/
│       ├── tests/
│       │   ├── UserApiTest.java
│       │   ├── AuthApiTest.java
│       │   └── OrderApiTest.java
│       └── schemas/
│           └── user-schema.json         ← JSON schema files
├── src/test/resources/
│   ├── config.properties
│   └── testdata/
│       └── users.csv
├── pom.xml
└── testng.xml
```

## Base API Class

```java
public class BaseApi {

    private static String BASE_URL;
    private static String AUTH_TOKEN;

    @BeforeSuite
    public void setUp() {
        BASE_URL = ConfigManager.get("base.url");
        AUTH_TOKEN = AuthApi.getToken();

        RestAssured.baseURI = BASE_URL;
        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
    }

    protected RequestSpecification getAuthSpec() {
        return given()
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + AUTH_TOKEN);
    }

    protected RequestSpecification getPublicSpec() {
        return given()
                    .header("Content-Type", "application/json");
    }
}
```

## API Layer — UserApi

```java
public class UserApi extends BaseApi {

    public Response createUser(User user) {
        return getAuthSpec()
                    .body(user)
                    .when()
                    .post("/api/users");
    }

    public Response getUserById(int userId) {
        return getAuthSpec()
                    .pathParam("id", userId)
                    .when()
                    .get("/api/users/{id}");
    }

    public Response updateUser(int userId, User user) {
        return getAuthSpec()
                    .pathParam("id", userId)
                    .body(user)
                    .when()
                    .put("/api/users/{id}");
    }

    public Response deleteUser(int userId) {
        return getAuthSpec()
                    .pathParam("id", userId)
                    .when()
                    .delete("/api/users/{id}");
    }
}
```

## Test Class — Clean and Readable

```java
public class UserApiTest extends BaseApi {

    private UserApi userApi = new UserApi();
    private static int createdUserId;

    @Test(priority = 1)
    public void testCreateUser() {
        User user = TestDataFactory.createRandomUser();

        Response response = userApi.createUser(user);

        assertEquals(response.getStatusCode(), 201);
        assertNotNull(response.jsonPath().getInt("id"));
        assertEquals(response.jsonPath().getString("name"), user.getName());

        createdUserId = response.jsonPath().getInt("id");
    }

    @Test(priority = 2, dependsOnMethods = "testCreateUser")
    public void testGetCreatedUser() {
        Response response = userApi.getUserById(createdUserId);

        assertEquals(response.getStatusCode(), 200);
        assertEquals(response.jsonPath().getInt("id"), createdUserId);
    }

    @Test(priority = 3, dependsOnMethods = "testGetCreatedUser")
    public void testDeleteUser() {
        Response response = userApi.deleteUser(createdUserId);
        assertEquals(response.getStatusCode(), 204);
    }
}
```

## Configuration Management

```properties
# config.properties
base.url=https://api.example.com
test.username=testuser
test.password=testpass
```

```java
public class ConfigManager {
    private static Properties props = new Properties();

    static {
        props.load(new FileInputStream("src/test/resources/config.properties"));
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}
```

## CI/CD Integration

```yaml
# pom.xml profile for CI
<profiles>
  <profile>
    <id>staging</id>
    <properties>
      <base.url>https://api.staging.com</base.url>
    </properties>
  </profile>
</profiles>
```

```bash
# Run staging tests
mvn test -P staging -Dgroups="smoke"
```$$,
  'API Automation', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Framework Design', 'API Testing', 'Rest Assured', 'Test Architecture', 'CI/CD', 'Team', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you mock failed API responses for testing error handling in your application?',
  'mock-failed-api-responses-testing-error-handling',
  'Use WireMock to stub API responses with specific status codes and delays to test how your application handles errors.',
  $$## Scenario: Mocking Failed API Responses

To test how your application handles API failures, you need to simulate various error scenarios without actually breaking the real API.

## Tools: WireMock (Java)

**Add to pom.xml:**
```xml
<dependency>
    <groupId>com.github.tomakehurst</groupId>
    <artifactId>wiremock-jre8</artifactId>
    <version>2.35.0</version>
    <scope>test</scope>
</dependency>
```

## Setup WireMock Server

```java
public class MockApiTest {

    @Rule
    public WireMockRule wireMockRule = new WireMockRule(8089);

    private String mockBaseUrl = "http://localhost:8089";
}
```

## Mock 500 Internal Server Error

```java
@Test
public void testApplicationHandles500Error() {
    // Setup stub
    stubFor(get(urlEqualTo("/api/users"))
        .willReturn(aResponse()
            .withStatus(500)
            .withHeader("Content-Type", "application/json")
            .withBody("{ \"error\": \"Internal Server Error\" }")));

    // Test your application''s behavior
    Response response = given()
                            .when()
                            .get(mockBaseUrl + "/api/users");

    assertEquals(response.getStatusCode(), 500);
    assertEquals(response.jsonPath().getString("error"), "Internal Server Error");
    // Verify your app shows a user-friendly error, not a crash
}
```

## Mock 404 Not Found

```java
@Test
public void testApplicationHandles404() {
    stubFor(get(urlPathMatching("/api/users/.*"))
        .willReturn(aResponse()
            .withStatus(404)
            .withBody("{ \"message\": \"User not found\" }")));

    Response response = given()
                            .when()
                            .get(mockBaseUrl + "/api/users/999");

    assertEquals(response.getStatusCode(), 404);
}
```

## Mock 401 Unauthorized

```java
@Test
public void testApplicationHandlesUnauthorized() {
    stubFor(get(urlEqualTo("/api/profile"))
        .willReturn(aResponse()
            .withStatus(401)
            .withBody("{ \"error\": \"Token expired\" }")));

    // Verify app redirects to login
    Response response = given().when().get(mockBaseUrl + "/api/profile");
    assertEquals(response.getStatusCode(), 401);
}
```

## Mock Network Failure / Slow Response

```java
@Test
public void testApplicationHandlesTimeout() {
    stubFor(get(urlEqualTo("/api/users"))
        .willReturn(aResponse()
            .withStatus(200)
            .withFixedDelay(10000)  // 10 second delay
            .withBody("{ \"data\": [] }")));

    // Your app should timeout and show an appropriate message
    given()
        .config(RestAssured.config().httpClient(
            HttpClientConfig.httpClientConfig()
                .setParam(CoreConnectionPNames.SO_TIMEOUT, 5000))) // 5s timeout
        .when()
        .get(mockBaseUrl + "/api/users")
        .then()
        .time(lessThan(6000L)); // Verify timeout was triggered
}
```

## Mock Flaky API (Intermittent Failures)

```java
@Test
public void testApplicationHandlesFlakyApi() {
    // First call fails, second call succeeds
    stubFor(get(urlEqualTo("/api/data"))
        .inScenario("Flaky API")
        .whenScenarioStateIs(Scenario.STARTED)
        .willReturn(aResponse().withStatus(503))
        .willSetStateTo("Second Call"));

    stubFor(get(urlEqualTo("/api/data"))
        .inScenario("Flaky API")
        .whenScenarioStateIs("Second Call")
        .willReturn(aResponse()
            .withStatus(200)
            .withBody("{ \"data\": \"success\" }")));

    // First call
    given().when().get(mockBaseUrl + "/api/data").then().statusCode(503);

    // Second call (retry)
    given().when().get(mockBaseUrl + "/api/data").then().statusCode(200);
}
```

## Error Scenarios to Mock

| Scenario | Status Code | Purpose |
|----------|------------|---------|
| Server crash | 500 | Test graceful degradation |
| Resource missing | 404 | Test user-facing error message |
| Auth expired | 401 | Test auto-refresh or redirect |
| Rate limited | 429 | Test backoff/retry logic |
| Service unavailable | 503 | Test fallback mechanisms |
| Network timeout | N/A | Test timeout handling |$$,
  'API Automation', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['WireMock', 'API Mocking', 'Error Handling', 'Rest Assured', 'Negative Testing', '500', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you perform API performance testing and what tools do you use?',
  'api-performance-testing-tools-approach',
  'Use JMeter, k6, or Gatling for API load testing to check response times, throughput, and behavior under concurrent user load.',
  $$## API Performance Testing

Performance testing verifies that APIs respond within acceptable time limits under expected and peak loads.

## Types of Performance Tests

| Type | Description | Example |
|------|-------------|---------|
| **Load Test** | Expected concurrent users | 100 users, 5 minutes |
| **Stress Test** | Beyond normal capacity | 500-1000 users until failure |
| **Spike Test** | Sudden traffic increase | Spike from 10 to 1000 users |
| **Soak Test** | Sustained load over time | 100 users for 2 hours |
| **Endurance Test** | Long-duration stability | 50 users for 24 hours |

## Tool 1: Apache JMeter

**Test Plan for API:**
```xml
Thread Group:
  - Number of Threads: 100
  - Ramp-Up Period: 10 seconds
  - Loop Count: 10

HTTP Request:
  - Method: GET
  - URL: https://api.example.com/users
  - Header: Authorization: Bearer {{token}}

Assertions:
  - Response Assertion: Status Code = 200
  - Duration Assertion: Response time < 2000ms

Listeners:
  - Summary Report
  - Response Time Graph
  - Active Threads Over Time
```

## Tool 2: k6 (Modern Performance Testing)

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '30s', target: 20 },   // Ramp up to 20 users
        { duration: '1m',  target: 100 },  // Stay at 100 users
        { duration: '20s', target: 0 },    // Ramp down
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'],  // 95% requests < 500ms
        http_req_failed:   ['rate<0.01'],  // Error rate < 1%
    }
};

export default function() {
    const res = http.get('https://api.example.com/users', {
        headers: { Authorization: 'Bearer your-token' }
    });

    check(res, {
        'status is 200': (r) => r.status === 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });

    sleep(1); // 1 second think time
}
```

**Run k6:**
```bash
k6 run --out influxdb=http://localhost:8086/k6 load-test.js
```

## Baseline Performance Checks in Rest Assured

```java
@Test
public void testGetUsersResponseTime() {
    long startTime = System.currentTimeMillis();

    Response response = given()
                            .header("Authorization", "Bearer " + token)
                            .when()
                            .get("/api/users");

    long responseTime = System.currentTimeMillis() - startTime;

    assertEquals(response.getStatusCode(), 200);
    assertTrue(responseTime < 1000, "Response time exceeded 1 second: " + responseTime + "ms");
}

// Rest Assured built-in time assertion
@Test
public void testResponseTimeWithRestAssured() {
    given()
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .time(lessThan(2000L)); // 2 seconds
}
```

## Key Metrics to Monitor

| Metric | Target |
|--------|--------|
| Response Time (avg) | < 200ms |
| Response Time (p95) | < 500ms |
| Response Time (p99) | < 1000ms |
| Throughput | > 1000 req/sec |
| Error Rate | < 0.1% |
| CPU Usage | < 70% under load |
| Memory Usage | Stable (no leaks) |$$,
  'API Automation', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Performance Testing', 'JMeter', 'k6', 'Load Testing', 'API Testing', 'Stress Testing', 'Throughput'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle token refresh and session management in API test automation?',
  'token-refresh-session-management-api-automation',
  'Use a BeforeSuite method to fetch tokens once, implement refresh logic for expired tokens, and use storageState or session variables.',
  $$## Token Refresh and Session Management in API Test Automation

Managing authentication tokens efficiently is critical for reliable API test suites.

## Strategy 1: Fetch Once Per Suite

```java
public class BaseApiTest {

    private static String ACCESS_TOKEN;
    private static long TOKEN_EXPIRY;

    @BeforeSuite
    public void setUp() {
        ACCESS_TOKEN = fetchToken();
        TOKEN_EXPIRY = System.currentTimeMillis() + (3600 * 1000); // 1 hour
    }

    private String fetchToken() {
        Response response = given()
                                .contentType(ContentType.JSON)
                                .body("{ \"username\": \"testuser\", \"password\": \"testpass\" }")
                                .when()
                                .post(BASE_URL + "/auth/login");

        assertEquals(response.getStatusCode(), 200);
        return response.jsonPath().getString("access_token");
    }

    protected String getToken() {
        // Refresh token if expired
        if (System.currentTimeMillis() >= TOKEN_EXPIRY) {
            ACCESS_TOKEN = fetchToken();
            TOKEN_EXPIRY = System.currentTimeMillis() + (3600 * 1000);
        }
        return ACCESS_TOKEN;
    }
}
```

## Strategy 2: Token Refresh using Refresh Token

```java
public class TokenManager {

    private static String accessToken;
    private static String refreshToken;
    private static long expiresAt;

    public static void login() {
        Response response = given()
            .body("{ \"username\": \"user\", \"password\": \"pass\" }")
            .contentType(ContentType.JSON)
            .when()
            .post("/auth/login");

        accessToken  = response.jsonPath().getString("access_token");
        refreshToken = response.jsonPath().getString("refresh_token");
        int expiresIn = response.jsonPath().getInt("expires_in");
        expiresAt = System.currentTimeMillis() + (expiresIn * 1000L);
    }

    public static String getAccessToken() {
        if (System.currentTimeMillis() >= expiresAt - 30000) { // refresh 30s early
            refreshAccessToken();
        }
        return accessToken;
    }

    private static void refreshAccessToken() {
        Response response = given()
            .body("{ \"refresh_token\": \"" + refreshToken + "\" }")
            .contentType(ContentType.JSON)
            .when()
            .post("/auth/refresh");

        if (response.getStatusCode() == 200) {
            accessToken = response.jsonPath().getString("access_token");
            int expiresIn = response.jsonPath().getInt("expires_in");
            expiresAt = System.currentTimeMillis() + (expiresIn * 1000L);
        } else {
            // Refresh token also expired — re-login
            login();
        }
    }
}
```

## Strategy 3: Per-Test Token with @BeforeMethod

```java
public class UserApiTest {

    private String token;

    @BeforeMethod
    public void setUp() {
        // Fetch fresh token before each test (slower but safest)
        token = AuthApi.getToken();
    }

    @Test
    public void testGetUser() {
        given()
            .header("Authorization", "Bearer " + token)
            .when()
            .get("/api/users/1")
            .then()
            .statusCode(200);
    }
}
```

## Handling 401 — Auto-Retry with New Token

```java
public Response executeWithRetry(Supplier<Response> request) {
    Response response = request.get();

    if (response.getStatusCode() == 401) {
        // Token expired — refresh and retry once
        TOKEN = TokenManager.refreshAccessToken();
        response = request.get();
    }

    return response;
}
```

## Best Practices

| Practice | Reason |
|----------|--------|
| Fetch token once per suite | Performance — avoid login on every test |
| Implement refresh logic | Handle long-running test suites |
| Store token in ThreadLocal | Thread-safe for parallel tests |
| Never hardcode tokens | Security — use env variables or fetch dynamically |
| Log token expiry issues | Easier debugging |$$,
  'API Automation', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Token Management', 'Session Management', 'JWT', 'Refresh Token', 'Rest Assured', 'API Automation', 'Auth'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you test microservices APIs and what are the unique challenges?',
  'testing-microservices-apis-challenges',
  'Microservices testing requires contract testing, service virtualization, environment management, and distributed tracing to handle inter-service dependencies.',
  $$## Testing Microservices APIs

Microservices present unique API testing challenges because services are distributed, independently deployed, and communicate with each other.

## Unique Challenges

| Challenge | Description |
|-----------|-------------|
| **Service Dependencies** | Service A calls Service B — you need both running |
| **Environment Complexity** | Multiple services, each needing their own config |
| **Data Consistency** | Data spread across multiple databases |
| **Network Failures** | Calls between services can fail |
| **API Versioning** | Multiple versions of APIs running simultaneously |
| **Asynchronous Flows** | Events, queues, eventual consistency |

## Strategy 1: Test Each Service in Isolation

```java
// Test User Service independently — mock Payment Service
public class UserServiceTest {

    @Rule
    public WireMockRule paymentServiceMock = new WireMockRule(8090);

    @Test
    public void testCreateUserTriggersAccountCreation() {
        // Mock Payment Service response
        stubFor(post(urlEqualTo("/payment/accounts"))
            .willReturn(aResponse()
                .withStatus(201)
                .withBody("{ \"account_id\": \"ACC123\" }")));

        // Test User Service
        given()
            .body("{ \"name\": \"John\", \"email\": \"john@test.com\" }")
            .contentType(ContentType.JSON)
            .when()
            .post("http://localhost:8080/users")
            .then()
            .statusCode(201)
            .body("account_id", equalTo("ACC123"));

        // Verify Payment Service was called
        verify(postRequestedFor(urlEqualTo("/payment/accounts")));
    }
}
```

## Strategy 2: Contract Testing with Pact

Consumer (Frontend) defines what it needs from the Provider (API):

```java
// Consumer Test
@Pact(consumer = "UserFrontend", provider = "UserAPI")
public RequestResponsePact getUserPact(PactDslWithProvider builder) {
    return builder
        .given("user 1 exists")
        .uponReceiving("get user by id")
            .path("/api/users/1")
            .method("GET")
        .willRespondWith()
            .status(200)
            .body(new PactDslJsonBody()
                .integerType("id", 1)
                .stringType("name", "John")
                .stringType("email", "john@test.com"))
        .toPact();
}
```

## Strategy 3: Integration Testing via API Gateway

```java
@Test
public void testEndToEndUserOrderFlow() {
    // Create user (User Service)
    String userId = given()
                        .body("{ \"name\": \"Jane\" }")
                        .contentType(ContentType.JSON)
                        .when()
                        .post(API_GATEWAY + "/users")
                        .then()
                        .statusCode(201)
                        .extract().path("id");

    // Create order for user (Order Service)
    String orderId = given()
                        .body("{ \"user_id\": \"" + userId + "\", \"product_id\": \"P001\" }")
                        .contentType(ContentType.JSON)
                        .when()
                        .post(API_GATEWAY + "/orders")
                        .then()
                        .statusCode(201)
                        .extract().path("order_id");

    // Verify order appears in user''s orders (via API Gateway)
    given()
        .when()
        .get(API_GATEWAY + "/users/" + userId + "/orders")
        .then()
        .statusCode(200)
        .body("orders.order_id", hasItem(orderId));
}
```

## Strategy 4: Test Asynchronous Event Flows

```java
@Test
public void testOrderCreatedEventPublished() throws InterruptedException {
    // Create order
    given()
        .body("{ \"user_id\": \"1\", \"product_id\": \"P001\" }")
        .contentType(ContentType.JSON)
        .when()
        .post("/api/orders");

    // Wait for async processing
    Thread.sleep(2000);

    // Verify downstream effect (inventory service decremented)
    given()
        .when()
        .get("/api/inventory/P001")
        .then()
        .statusCode(200)
        .body("available_qty", lessThan(initialQty));
}
```

## Best Practices for Microservices API Testing

1. **Test services in isolation** with service virtualization (WireMock)
2. **Use contract testing** (Pact) to prevent integration breaks
3. **Test via API Gateway** for end-to-end flows
4. **Add distributed tracing** (Zipkin, Jaeger) to follow requests across services
5. **Use chaos engineering** — kill a service and verify graceful degradation$$,
  'API Automation', 'Technical', '5+ Years', 'Advanced',
  ARRAY['Microservices', 'API Testing', 'Contract Testing', 'WireMock', 'Pact', 'Service Virtualization', 'Scenario'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle API versioning in test automation?',
  'handle-api-versioning-test-automation',
  'Create separate test suites per version or use parameterized version constants, and use smoke tests to verify each version independently.',
  $$## API Versioning in Test Automation

APIs evolve over time. Good test automation handles multiple versions cleanly.

## Common API Versioning Patterns

| Pattern | Example |
|---------|---------|
| URL path versioning | `/api/v1/users`, `/api/v2/users` |
| Query parameter | `/api/users?version=2` |
| Header versioning | `Accept-Version: 2` |
| Subdomain | `v2.api.example.com/users` |

## Strategy 1: Version-Based Test Configuration

```java
// config.properties
api.version=v2
base.url=https://api.example.com

// BaseApiTest.java
public class BaseApiTest {
    protected static final String VERSION = ConfigManager.get("api.version");
    protected static final String BASE_URL = ConfigManager.get("base.url");

    protected String endpoint(String path) {
        return BASE_URL + "/api/" + VERSION + path;
    }
}

// Usage in test
@Test
public void testGetUsers() {
    given()
        .when()
        .get(endpoint("/users"))  // resolves to /api/v2/users
        .then()
        .statusCode(200);
}
```

## Strategy 2: Separate Test Suites Per Version

```
tests/
├── v1/
│   ├── UserApiV1Test.java
│   └── OrderApiV1Test.java
└── v2/
    ├── UserApiV2Test.java   ← New fields in v2
    └── OrderApiV2Test.java
```

```java
// V1 Test
public class UserApiV1Test {
    private static final String BASE = "/api/v1";

    @Test
    public void testGetUserV1() {
        given().when().get(BASE + "/users/1")
               .then().statusCode(200)
               .body("$", hasKey("name"))
               .body("$", not(hasKey("full_name"))); // v1 uses 'name', not 'full_name'
    }
}

// V2 Test
public class UserApiV2Test {
    private static final String BASE = "/api/v2";

    @Test
    public void testGetUserV2() {
        given().when().get(BASE + "/users/1")
               .then().statusCode(200)
               .body("$", hasKey("full_name"))  // v2 renamed to 'full_name'
               .body("$", hasKey("profile_picture"));  // v2 added new field
    }
}
```

## Strategy 3: Parameterized Version Tests

```java
@DataProvider(name = "apiVersions")
public Object[][] apiVersions() {
    return new Object[][] {
        { "v1" },
        { "v2" }
    };
}

@Test(dataProvider = "apiVersions")
public void testUsersEndpointAcrossVersions(String version) {
    given()
        .when()
        .get("/api/" + version + "/users")
        .then()
        .statusCode(200); // Both versions should return 200
}
```

## Strategy 4: Header-Based Versioning

```java
@Test
public void testApiWithVersionHeader() {
    // Request v1 response
    given()
        .header("Accept-Version", "1.0")
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .header("API-Version", "1.0");

    // Request v2 response — different fields
    given()
        .header("Accept-Version", "2.0")
        .when()
        .get("/api/users")
        .then()
        .statusCode(200)
        .header("API-Version", "2.0")
        .body("data[0]", hasKey("full_name")); // v2-specific field
}
```

## CI/CD: Testing Multiple Versions in Pipeline

```yaml
# GitHub Actions matrix strategy
strategy:
  matrix:
    api-version: [v1, v2]

steps:
  - name: Run API Tests for ${{ matrix.api-version }}
    run: mvn test -Dapi.version=${{ matrix.api-version }}
```

## Best Practices

- Keep **v1 smoke tests** running alongside v2 tests during deprecation period
- Use **semantic versioning** contracts with Pact
- Document version differences in test class Javadoc
- Remove tests for **officially deprecated** versions after sunset date$$,
  'API Automation', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['API Versioning', 'Test Automation', 'REST API', 'CI/CD', 'Rest Assured', 'Version Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you implement data-driven API testing with Rest Assured and TestNG?',
  'data-driven-api-testing-rest-assured-testng',
  'Use TestNG @DataProvider with inline data, Excel/CSV files, or JSON files to run the same API test with multiple data sets.',
  $$## Data-Driven API Testing with Rest Assured + TestNG

Data-driven testing runs the **same test logic with multiple sets of data**, maximizing test coverage with minimal code.

## Method 1: @DataProvider with Inline Data

```java
public class DataDrivenUserTest {

    @DataProvider(name = "createUserData")
    public Object[][] createUserData() {
        return new Object[][] {
            // name,          email,                  status,   expectedCode
            { "John Doe",    "john@example.com",     "active", 201 },
            { "Jane Smith",  "jane@example.com",     "active", 201 },
            { "",            "invalid",               "active", 400 }, // empty name
            { "Alice",       "not-an-email",          "active", 400 }, // bad email
            { "Bob",         "bob@example.com",      "invalid", 400 }  // bad status
        };
    }

    @Test(dataProvider = "createUserData")
    public void testCreateUser(String name, String email, String status, int expectedCode) {
        String body = String.format(
            "{ \"name\": \"%s\", \"email\": \"%s\", \"status\": \"%s\" }",
            name, email, status
        );

        given()
            .contentType(ContentType.JSON)
            .body(body)
            .when()
            .post("/api/users")
            .then()
            .statusCode(expectedCode);
    }
}
```

## Method 2: @DataProvider from CSV File

```java
@DataProvider(name = "csvUserData")
public Object[][] csvUserData() throws IOException {
    List<Object[]> data = new ArrayList<>();

    try (CSVReader reader = new CSVReader(
            new FileReader("src/test/resources/testdata/users.csv"))) {

        String[] row;
        reader.readNext(); // skip header

        while ((row = reader.readNext()) != null) {
            data.add(new Object[]{ row[0], row[1], Integer.parseInt(row[2]) });
        }
    }

    return data.toArray(new Object[0][]);
}

// users.csv:
// name,email,expectedStatus
// John,john@test.com,201
// ,invalid,400
```

## Method 3: @DataProvider from JSON File

```java
// testdata/users.json
// [
//   { "name": "Alice", "email": "alice@test.com", "expected": 201 },
//   { "name": "",      "email": "bad",             "expected": 400 }
// ]

@DataProvider(name = "jsonUserData")
public Object[][] jsonUserData() throws IOException {
    String content = new String(Files.readAllBytes(
        Paths.get("src/test/resources/testdata/users.json")));

    JSONArray jsonArray = new JSONArray(content);
    Object[][] data = new Object[jsonArray.length()][3];

    for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject obj = jsonArray.getJSONObject(i);
        data[i][0] = obj.getString("name");
        data[i][1] = obj.getString("email");
        data[i][2] = obj.getInt("expected");
    }

    return data;
}
```

## Method 4: Parallel Data-Driven Tests

```java
@DataProvider(name = "parallelData", parallel = true)
public Object[][] parallelData() {
    return new Object[][] {
        { "user1@test.com", 200 },
        { "user2@test.com", 200 },
        { "user3@test.com", 200 }
    };
}

@Test(dataProvider = "parallelData")
public void testGetUserByEmail(String email, int expectedCode) {
    given()
        .queryParam("email", email)
        .when()
        .get("/api/users/search")
        .then()
        .statusCode(expectedCode);
}
```

## testng.xml Configuration for Data-Driven

```xml
<suite name="API Data-Driven Tests" parallel="tests" thread-count="4">
    <test name="User API Tests">
        <classes>
            <class name="tests.DataDrivenUserTest"/>
        </classes>
    </test>
</suite>
```

## Test Results View

Running with 5 data sets shows 5 separate results:
```
testCreateUser[0] - PASS (John Doe → 201)
testCreateUser[1] - PASS (Jane Smith → 201)
testCreateUser[2] - PASS (empty name → 400)
testCreateUser[3] - PASS (bad email → 400)
testCreateUser[4] - PASS (bad status → 400)
```$$,
  'API Automation', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Data-Driven Testing', 'TestNG', 'Rest Assured', 'DataProvider', 'CSV', 'JSON', 'API Testing'], true, 0
);
