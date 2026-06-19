-- Scenario-Based Advanced Questions Q21–Q35 (Senior Architect Level)
-- technology = 'Scenario-Based', Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Scenario Q21
(
  'How do you handle CAPTCHA in Selenium automation?',
  'selenium-scenario-q21-handle-captcha-automation',
  'CAPTCHA cannot be automated by Selenium — use third-party solving services, ask dev to disable for test environments, or use bypass tokens in API calls.',
  $ans$
## Handling CAPTCHA in Selenium Automation

CAPTCHA is intentionally designed to block automation. There is no clean Selenium-only solution — these are the real approaches used in professional QA:

### Approach 1 — Disable CAPTCHA in Test Environment (Best)

Ask developers to disable CAPTCHA for the staging/test environment:

```java
// Dev adds a feature flag or test bypass
driver.get("https://staging.automateqa.online/login?captcha=disabled");

// Or environment variable in app config
// DISABLE_CAPTCHA=true (staging only, never production)
```

**This is the correct enterprise approach.** Your CI/CD environment should never have CAPTCHA enabled.

### Approach 2 — Backend Bypass via API

Skip the UI entirely for login — get a token via API:

```java
// Use Rest Assured to get auth token directly (bypasses CAPTCHA UI)
Response response = RestAssured
    .given()
    .contentType("application/json")
    .body("{\"email\":\"admin@test.com\",\"password\":\"secret\"}")
    .post("https://api.automateqa.online/auth/login");

String token = response.jsonPath().getString("token");

// Inject token as cookie into browser
driver.get("https://automateqa.online");
driver.manage().addCookie(new Cookie("auth_token", token));
driver.navigate().refresh(); // now logged in, CAPTCHA bypassed
```

### Approach 3 — Third-Party CAPTCHA Solving Services

For cases where CAPTCHA cannot be disabled (audits, production-like tests):

```java
// 2captcha API example (paid service ~$0.001 per CAPTCHA)
// 1. Get the sitekey from page source
String siteKey = driver.findElement(By.cssSelector(".g-recaptcha"))
                       .getAttribute("data-sitekey");

// 2. Send to 2captcha API
String requestUrl = "http://2captcha.com/in.php?key=YOUR_API_KEY"
    + "&method=userrecaptcha&googlekey=" + siteKey
    + "&pageurl=" + driver.getCurrentUrl();
// 3. Poll for result, inject into form
// 4. Submit form with solved token
```

**Note:** This adds cost + latency and violates most sites'' terms of service. Use only for authorized penetration testing.

### Approach 4 — Image-Based CAPTCHA (Optical — Avoid)

Using Tesseract OCR for simple text CAPTCHAs:

```java
// NOT recommended — modern CAPTCHAs defeat OCR
// Only works for very simple legacy CAPTCHAs
```

### Approach 5 — Mock/Stub CAPTCHA Validation

If you control the backend, accept a test bypass token:

```java
// Backend: if captcha_token == "test-bypass-token-xyz", skip validation
// Frontend automation:
driver.findElement(By.id("captcha_token"))
      .sendKeys("test-bypass-token-xyz");
```

### Summary: The Right Approach for Each Situation

| Situation | Approach |
|---|---|
| Staging/CI environment | Disable CAPTCHA via feature flag |
| Login automation | API token injection into cookies |
| Must test CAPTCHA page | Verify CAPTCHA element exists, skip solving |
| Production audit | Third-party solving service (authorized only) |

**The best answer in an interview:** CAPTCHA should be disabled in test environments via a dev-provided flag. If not possible, bypass login via API token and inject as a cookie.
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','CAPTCHA','reCAPTCHA','Bypass','Cookie','Rest Assured','API','Feature Flag'],
  true, 0
),

-- Scenario Q22
(
  'How do you design a Selenium test automation framework from scratch?',
  'selenium-scenario-q22-design-automation-framework-scratch',
  'Start with technology selection, then build layers: BaseTest → Page Objects → Utilities → Data Layer → Reporting — structured around a Maven project with TestNG and Git from day one.',
  $ans$
## Designing a Selenium Framework from Scratch

As a Senior Automation Architect, this is the blueprint for an enterprise-grade framework:

### Phase 1 — Technology Selection

```
Language:        Java (most common for Selenium)
Test Framework:  TestNG (parallel, groups, listeners)
Build Tool:      Maven (dependency management, CI integration)
Browser Driver:  WebDriverManager (auto-manages driver versions)
Reporting:       ExtentReports + Allure
Logging:         Log4j2
Data:            Apache POI (Excel) + Properties files
Version Control: Git + GitHub
CI/CD:           Jenkins / GitHub Actions
```

### Phase 2 — Project Structure

```
project-root/
├── src/
│   ├── main/java/
│   │   ├── base/
│   │   │   ├── BaseTest.java        ← driver init, config load, teardown
│   │   │   └── BasePage.java        ← common wait methods, WebDriver ref
│   │   ├── pages/
│   │   │   ├── LoginPage.java       ← page objects
│   │   │   └── DashboardPage.java
│   │   ├── utils/
│   │   │   ├── DriverManager.java   ← ThreadLocal WebDriver
│   │   │   ├── ExcelUtils.java      ← test data reading
│   │   │   ├── ScreenshotUtils.java ← screenshot on failure
│   │   │   └── WaitUtils.java       ← reusable explicit waits
│   │   ├── listeners/
│   │   │   ├── ExtentReportListener.java
│   │   │   └── RetryListener.java
│   │   └── constants/
│   │       └── FrameworkConstants.java ← paths, timeouts, URLs
│   └── test/
│       ├── java/tests/
│       │   ├── LoginTest.java
│       │   └── CheckoutTest.java
│       └── resources/
│           ├── config.properties        ← env-specific settings
│           ├── log4j2.xml              ← logging config
│           └── testdata/
│               └── TestData.xlsx
├── testng.xml                           ← suite definition
├── testng-regression.xml
├── testng-smoke.xml
├── pom.xml
└── .github/workflows/ci.yml            ← GitHub Actions
```

### Phase 3 — Core Components

**FrameworkConstants.java**
```java
public class FrameworkConstants {
    public static final int EXPLICIT_WAIT = 15;
    public static final int PAGE_LOAD_TIMEOUT = 30;
    public static final String SCREENSHOT_PATH = "test-output/screenshots/";
    public static final String EXTENT_REPORT_PATH = "test-output/ExtentReport.html";
    public static final String EXCEL_DATA_PATH = "src/test/resources/testdata/TestData.xlsx";
}
```

**BasePage.java**
```java
public class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage() {
        this.driver = DriverManager.getDriver();
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(EXPLICIT_WAIT));
    }

    protected WebElement waitForElement(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    protected void clickElement(By locator) {
        waitForElement(locator).click();
    }

    protected void typeText(By locator, String text) {
        WebElement el = waitForElement(locator);
        el.clear();
        el.sendKeys(text);
    }
}
```

### Phase 4 — CI/CD Integration

**GitHub Actions workflow:**
```yaml
name: Selenium Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { java-version: '17', distribution: 'temurin' }
      - name: Run Smoke Tests
        run: mvn test -Dgroups="smoke" -Dheadless=true
      - name: Upload Reports
        uses: actions/upload-artifact@v4
        with:
          name: test-reports
          path: test-output/
```

### Phase 5 — Execution Commands

```bash
# Run smoke tests headless
mvn test -Dgroups="smoke" -Dheadless=true

# Cross-browser regression
mvn test -DsuiteXmlFile=testng-regression.xml

# Rerun failures
mvn test -DsuiteXmlFile=test-output/testng-failed.xml
```

### Framework Design Principles (Senior Level)

1. **No hardcoded values** — everything in `config.properties` or `Constants`
2. **ThreadLocal driver** — mandatory for parallel execution
3. **Page Object Model** — never write locators directly in test classes
4. **Single Responsibility** — each class/page does one thing
5. **Explicit over implicit waits** — predictable, debuggable
6. **Self-documenting tests** — test method names read like user stories
7. **CI/CD first** — framework must run headless in Docker from day 1
  $ans$,
  'Scenario-Based', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Selenium','Framework Design','Architecture','BaseTest','POM','Maven','CI/CD','Enterprise'],
  true, 0
),

-- Scenario Q23
(
  'How do you handle OTP or 2FA authentication in Selenium automation?',
  'selenium-scenario-q23-handle-otp-2fa-authentication',
  'Bypass 2FA in test environments via feature flags, use test-only OTP seeds with TOTP libraries, or intercept OTP via test email/SMS APIs.',
  $ans$
## Handling OTP / 2FA in Selenium Automation

Two-Factor Authentication (2FA) and OTP are designed to require real-time human verification. Here are the professional approaches:

### Approach 1 — Disable 2FA in Test Environment (Recommended)

Ask dev team to add a test bypass:

```java
// Test accounts have 2FA disabled in staging
// Or: test env config disables 2FA entirely
driver.get("https://staging.automateqa.online/login");
// Login normally — no OTP prompt appears
```

### Approach 2 — TOTP Library (Google Authenticator Compatible)

For apps using Time-based OTP (TOTP), generate the OTP programmatically using the same seed:

```xml
<!-- pom.xml -->
<dependency>
    <groupId>com.warrenstrange</groupId>
    <artifactId>googleauth</artifactId>
    <version>1.5.0</version>
</dependency>
```

```java
import com.warrenstrange.googleauth.GoogleAuthenticator;

public class OTPUtils {
    // Dev shares the test account's TOTP seed/secret key
    private static final String TEST_TOTP_SECRET = "JBSWY3DPEHPK3PXP";

    public static int generateOTP() {
        GoogleAuthenticator gAuth = new GoogleAuthenticator();
        return gAuth.getTotpPassword(TEST_TOTP_SECRET);
    }
}

// In test:
driver.findElement(By.id("username")).sendKeys("testuser@automateqa.online");
driver.findElement(By.id("password")).sendKeys("TestPass123");
driver.findElement(By.id("loginBtn")).click();

// OTP screen appears
int otp = OTPUtils.generateOTP();
driver.findElement(By.id("otpField")).sendKeys(String.valueOf(otp));
driver.findElement(By.id("verifyBtn")).click();
```

### Approach 3 — Test Email API (Mailosaur / Mailhog)

For email-based OTP, read the OTP from a test inbox:

```java
// Use Mailosaur (test email service) to receive OTP email
MailosaurClient mailosaur = new MailosaurClient("YOUR_API_KEY");
Message email = mailosaur.messages().get("SERVER_ID",
    new SearchCriteria().withSentTo("testuser@abc.mailosaur.net"));

// Extract OTP from email body using regex
String otp = email.text().body().replaceAll(".*Your OTP is: (\\d{6}).*", "$1");
driver.findElement(By.id("otpField")).sendKeys(otp);
```

### Approach 4 — SMS Mock / Test Phone Number

For SMS OTP:
- Use Twilio test numbers or mock SMS gateway
- Or ask dev team to accept a static test OTP (e.g., "000000") for test accounts

### Approach 5 — Cookie/Session Injection (Skip Login Entirely)

Best when 2FA protects only the login step:

```java
// Step 1: Login via API (no UI, no 2FA in API test mode)
Response loginResponse = RestAssured.given()
    .header("X-Test-Mode", "true") // dev provides this header to bypass 2FA
    .body("{\"email\":\"test@automateqa.online\",\"password\":\"pass\"}")
    .post("/api/auth/login");

String sessionToken = loginResponse.getCookie("session");

// Step 2: Inject session into browser
driver.get("https://automateqa.online");
driver.manage().addCookie(new Cookie("session", sessionToken));
driver.navigate().refresh(); // authenticated, 2FA bypassed
```

### Summary Table

| 2FA Type | Approach |
|---|---|
| Test env — any type | Disable 2FA via feature flag (ask dev) |
| TOTP / Google Auth | TOTP library with shared secret key |
| Email OTP | Test email API (Mailosaur, Mailhog) |
| SMS OTP | Twilio test numbers / static test OTP |
| Session-based | API login + cookie injection |
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','OTP','2FA','TOTP','Authentication','Cookie','Mailosaur','Google Authenticator'],
  true, 0
),

-- Scenario Q24
(
  'How do you perform visual or image comparison testing in Selenium?',
  'selenium-scenario-q24-visual-image-comparison-testing',
  'Use Ashot or Applitools for pixel-level screenshot comparison against baselines — ideal for catching unintended UI regressions that functional assertions miss.',
  $ans$
## Visual / Image Comparison Testing in Selenium

Functional assertions check data and behavior. Visual testing checks that the UI **looks correct** — catching layout shifts, font changes, color regressions, and overlapping elements.

### Method 1 — Ashot Library (Open Source, Pixel-Level)

```xml
<dependency>
    <groupId>ru.yandex.qatools.ashot</groupId>
    <artifactId>ashot</artifactId>
    <version>1.5.4</version>
</dependency>
```

**Take and Save Baseline Screenshot:**

```java
Screenshot baselineShot = new AShot()
    .shootingStrategy(ShootingStrategies.viewportPasting(100)) // full page
    .takeScreenshot(driver);

ImageIO.write(baselineShot.getImage(), "PNG",
    new File("src/test/resources/baseline/homepage.png"));
```

**Compare with Baseline:**

```java
// Take current screenshot
Screenshot currentShot = new AShot()
    .shootingStrategy(ShootingStrategies.viewportPasting(100))
    .takeScreenshot(driver);

// Load baseline
BufferedImage baseline = ImageIO.read(
    new File("src/test/resources/baseline/homepage.png"));

// Compare
ImageDiffer differ = new ImageDiffer();
ImageDiff diff = differ.makeDiff(
    new Screenshot(baseline), currentShot);

if (diff.hasDiff()) {
    // Save diff image showing changed pixels
    ImageIO.write(diff.getMarkedImage(), "PNG",
        new File("test-output/diff/homepage-diff.png"));
    Assert.fail("Visual difference detected! See: test-output/diff/homepage-diff.png");
}
```

### Method 2 — Element-Level Visual Check

```java
// Compare just the product card, not full page
WebElement productCard = driver.findElement(By.cssSelector(".product-card:first-child"));

Screenshot elementShot = new AShot()
    .takeScreenshot(driver, productCard);

BufferedImage baseline = ImageIO.read(new File("baseline/product-card.png"));
ImageDiff diff = new ImageDiffer().makeDiff(new Screenshot(baseline), elementShot);

Assert.assertFalse(diff.hasDiff(), "Product card UI has changed");
```

### Method 3 — Applitools Eyes (AI-Based, Cloud)

```xml
<dependency>
    <groupId>com.applitools</groupId>
    <artifactId>eyes-selenium-java5</artifactId>
    <version>LATEST</version>
</dependency>
```

```java
EyesRunner runner = new ClassicRunner();
Eyes eyes = new Eyes(runner);
eyes.setApiKey("YOUR_APPLITOOLS_API_KEY");

eyes.open(driver, "AutomateQA", "Homepage Test");
driver.get("https://automateqa.online");

eyes.checkWindow("Full Homepage"); // AI compares to baseline
eyes.checkElement(By.cssSelector(".hero-section"), "Hero Section");

TestResultsSummary results = runner.getAllTestResults();
// Applitools dashboard shows visual diffs with AI filtering of
// dynamic content (ads, timestamps) to reduce false positives
```

### Method 4 — Custom Pixel Comparison

```java
public boolean imagesAreEqual(BufferedImage img1, BufferedImage img2, int tolerance) {
    if (img1.getWidth() != img2.getWidth() || img1.getHeight() != img2.getHeight()) {
        return false;
    }
    int diffPixels = 0;
    for (int y = 0; y < img1.getHeight(); y++) {
        for (int x = 0; x < img1.getWidth(); x++) {
            if (img1.getRGB(x, y) != img2.getRGB(x, y)) diffPixels++;
        }
    }
    double diffPercent = (double) diffPixels / (img1.getWidth() * img1.getHeight()) * 100;
    return diffPercent < tolerance; // e.g., < 1% different = pass
}
```

### Visual Testing Strategy

| Approach | Tool | Best For |
|---|---|---|
| Pixel-perfect | Ashot | Static pages, no dynamic content |
| AI-powered | Applitools | Pages with dates, user names, ads |
| Perceptual hash | Custom | Quick thumbnail comparison |
| Manual review | Screenshot diff tool | One-time regression check |
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Visual Testing','Ashot','Applitools','Screenshot','Image Comparison','UI Regression'],
  true, 0
),

-- Scenario Q25
(
  'How do you integrate Selenium with Rest Assured for API + UI hybrid testing?',
  'selenium-scenario-q25-selenium-restassured-api-ui-hybrid',
  'Use Rest Assured API calls for test setup (create data, get tokens) and Selenium for UI verification — combining speed of API testing with completeness of UI validation.',
  $ans$
## API + UI Hybrid Testing Pattern

Pure UI automation is slow and fragile. Pure API testing misses UI bugs. Hybrid testing uses each tool where it''s strongest.

### Maven Dependencies

```xml
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.4.0</version>
</dependency>
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.18.1</version>
</dependency>
```

### Pattern 1 — API Setup, UI Verification

```java
@Test
public void verifyProductAppearsOnUI() {
    // FAST: Create test product via API (no UI navigation)
    String productJson = "{\"name\":\"Test Widget\",\"price\":99.99,\"stock\":10}";
    Response apiResponse = RestAssured
        .given()
        .header("Authorization", "Bearer " + getAuthToken())
        .contentType("application/json")
        .body(productJson)
        .post("https://api.automateqa.online/products");

    Assert.assertEquals(apiResponse.statusCode(), 201);
    String productId = apiResponse.jsonPath().getString("id");

    // THOROUGH: Verify it appears correctly in the UI
    driver.get("https://automateqa.online/products/" + productId);
    Assert.assertEquals(
        driver.findElement(By.cssSelector(".product-title")).getText(), "Test Widget");
    Assert.assertEquals(
        driver.findElement(By.cssSelector(".product-price")).getText(), "$99.99");
}
```

### Pattern 2 — Login via API, Test UI Features

```java
@BeforeClass
public void loginViaAPI() {
    // Fast API login — no UI login form navigation
    Response response = RestAssured
        .given()
        .body("{\"email\":\"admin@test.com\",\"password\":\"pass123\"}")
        .contentType("application/json")
        .post("https://api.automateqa.online/auth/login");

    String token = response.jsonPath().getString("token");

    // Inject auth as cookie in browser
    driver.get("https://automateqa.online");
    driver.manage().addCookie(new Cookie("auth_token", token));
    driver.navigate().to("https://automateqa.online/dashboard");
    // Now on dashboard — skipped entire login UI flow
}

@Test
public void verifyDashboardStats() {
    // UI test — already authenticated via API
    Assert.assertTrue(
        driver.findElement(By.cssSelector(".welcome-message"))
              .getText().contains("Welcome"));
}
```

### Pattern 3 — UI Action, API Verification

```java
@Test
public void submitOrderViaUIVerifyViaAPI() {
    // UI: Place order
    driver.get("https://automateqa.online/cart");
    driver.findElement(By.id("checkoutBtn")).click();
    driver.findElement(By.id("confirmOrder")).click();

    String orderId = driver.findElement(By.cssSelector(".order-id")).getText();

    // API: Verify order created correctly in backend
    Response orderResponse = RestAssured
        .given()
        .header("Authorization", "Bearer " + authToken)
        .get("https://api.automateqa.online/orders/" + orderId);

    Assert.assertEquals(orderResponse.statusCode(), 200);
    Assert.assertEquals(orderResponse.jsonPath().getString("status"), "CONFIRMED");
    Assert.assertEquals(orderResponse.jsonPath().getFloat("total"), 149.99f, 0.01f);
}
```

### Pattern 4 — API Cleanup After UI Test

```java
@AfterMethod
public void cleanupTestData(ITestResult result) {
    if (createdProductId != null) {
        // Clean up via API — faster and more reliable than UI deletion
        RestAssured
            .given()
            .header("Authorization", "Bearer " + authToken)
            .delete("https://api.automateqa.online/products/" + createdProductId);
    }
}
```

### Hybrid Strategy Benefits

| Phase | Selenium | Rest Assured |
|---|---|---|
| Test Data Setup | Slow (UI forms) | Fast (direct API) |
| Authentication | Slow (login UI) | Fast (token injection) |
| UI Verification | Essential | Cannot do |
| Backend State Check | Limited | Direct + accurate |
| Cleanup | Slow (UI navigation) | Fast (DELETE call) |

**Rule:** Automate anything that doesn''t need visual verification via API. Use Selenium only for what needs UI validation.
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Rest Assured','API Testing','Hybrid Testing','Authentication','Cookie','Test Data'],
  true, 0
),

-- Scenario Q26
(
  'How do you manage test data in a large Selenium automation framework?',
  'selenium-scenario-q26-test-data-management-selenium-framework',
  'Use a layered strategy: properties files for config, Excel/JSON for functional data, API calls for dynamic data creation, and database scripts for cleanup.',
  $ans$
## Test Data Management in Large Frameworks

Poor test data management is the #1 cause of brittle automation suites. Here is the professional approach by data type:

### Layer 1 — Configuration Data (config.properties)

```properties
# Environment-specific, never test-specific
baseUrl=https://staging.automateqa.online
apiUrl=https://api.staging.automateqa.online
defaultTimeout=15
browser=chrome
headless=false
```

```java
public class ConfigManager {
    private static Properties config = new Properties();

    static {
        try (FileInputStream fis = new FileInputStream("src/test/resources/config.properties")) {
            config.load(fis);
        } catch (IOException e) {
            throw new RuntimeException("Cannot load config.properties");
        }
    }

    public static String get(String key) {
        return System.getProperty(key, config.getProperty(key));
    }
}
// Usage: ConfigManager.get("baseUrl")
```

### Layer 2 — Functional Test Data (Excel / JSON)

**Excel via Apache POI:**
```java
@DataProvider(name = "loginScenarios")
public Object[][] loginData() throws Exception {
    return ExcelUtils.getSheetData("src/test/resources/testdata/TestData.xlsx", "Login");
}

@Test(dataProvider = "loginScenarios")
public void loginTest(String user, String pass, String expectedResult) { ... }
```

**JSON test data (cleaner for complex objects):**
```json
// src/test/resources/testdata/users.json
[
  {"username": "admin@test.com",    "password": "admin123",  "role": "ADMIN"},
  {"username": "readonly@test.com", "password": "read456",   "role": "VIEWER"},
  {"username": "manager@test.com",  "password": "mgr789",    "role": "MANAGER"}
]
```

```java
// Read JSON test data
ObjectMapper mapper = new ObjectMapper();
List<UserData> users = mapper.readValue(
    new File("src/test/resources/testdata/users.json"),
    new TypeReference<List<UserData>>() {});
```

### Layer 3 — Dynamic Test Data via API

```java
public class TestDataFactory {

    public static String createTestUser(String role) {
        String email = "test_" + System.currentTimeMillis() + "@automateqa.online";
        RestAssured
            .given()
            .header("Authorization", "Bearer " + getAdminToken())
            .body("{\"email\":\"" + email + "\",\"role\":\"" + role + "\"}")
            .post("/api/users");
        return email;
    }

    public static String createTestOrder(String userId, float amount) {
        Response r = RestAssured
            .given().header("Authorization", "Bearer " + getAdminToken())
            .body("{\"userId\":\"" + userId + "\",\"amount\":" + amount + "}")
            .post("/api/orders");
        return r.jsonPath().getString("orderId");
    }
}

// In test
@BeforeMethod
public void setUp() {
    testUserEmail = TestDataFactory.createTestUser("ADMIN");
}

@AfterMethod
public void cleanUp() {
    TestDataFactory.deleteUser(testUserEmail); // API cleanup
}
```

### Layer 4 — Database Scripts for Bulk Setup

```java
// For complex test data that''s hard to create via API
public class DatabaseUtils {
    private static Connection conn;

    public static void insertTestProduct(String name, double price) throws Exception {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO products (name, price, is_test_data) VALUES (?, ?, true)"
        );
        ps.setString(1, name);
        ps.setDouble(2, price);
        ps.executeUpdate();
    }

    public static void cleanTestData() throws Exception {
        conn.createStatement().execute("DELETE FROM products WHERE is_test_data = true");
    }
}
```

### Test Data Best Practices

| Rule | Why |
|---|---|
| Tag test data with `is_test_data=true` | Easy to identify and clean up |
| Use unique IDs with timestamps | Avoid conflicts in parallel runs |
| Never depend on pre-existing data | Tests become brittle |
| Clean up in @AfterMethod | Leave environment in known state |
| Never hardcode credentials | Use properties files or env vars |
| Separate data per environment | Staging data ≠ Prod data |
  $ans$,
  'Scenario-Based', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Selenium','Test Data','Excel','JSON','API','Database','TestNG','DataProvider','Management'],
  true, 0
),

-- Scenario Q27
(
  'How do you report automation metrics to management?',
  'selenium-scenario-q27-report-automation-metrics-management',
  'Track pass rate trend, automation coverage percentage, test execution time, and defect detection rate — present them in dashboards with clear quality health indicators.',
  $ans$
## Reporting Automation Metrics to Management

Management cares about business value — not technical details. Translate test results into meaningful quality indicators.

### Key Metrics to Track

**1. Test Pass Rate (Quality Signal)**
```
Pass Rate = (Passed Tests / Total Executed) × 100%
Target: > 95% consistently

Week 1: 187/200 = 93.5%
Week 2: 195/200 = 97.5%  ← improving
Week 3: 198/200 = 99.0%  ← stable
```

**2. Automation Coverage**
```
Coverage = (Automated Test Cases / Total Test Cases) × 100%

Regression Suite:  234/300 = 78% automated
Smoke Suite:       45/45   = 100% automated
New Features:      12/89   = 13% automated (in progress)
```

**3. Test Execution Time Trend**
```
Manual regression: 3 days (team of 5 testers)
Automated:         45 minutes (headless, parallel, 3 browsers)
Time Saved:        ~95% per release cycle
```

**4. Defect Detection Rate**
```
Bugs found by automation in last sprint: 23
Bugs escaped to production:              2
Detection Rate = 23/25 = 92%
```

**5. Flakiness Rate**
```
Flaky tests = tests that pass/fail intermittently
Target: < 2% of total suite
Current: 8/200 = 4% (action item: fix flaky tests)
```

### Jenkins / GitHub Actions — Trend Reporting

```groovy
// Jenkinsfile — collect and trend results
post {
    always {
        // Publish TestNG results with trend graph
        testNG(reportFilenamePattern: '**/testng-results.xml')

        // Publish Allure report
        allure([results: [[path: 'target/allure-results']]])

        // Notify Slack with summary
        slackSend(
            color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
            message: """*Test Run: ${env.JOB_NAME} #${env.BUILD_NUMBER}*
Passed:  ${testSummary.passed}
Failed:  ${testSummary.failed}
Skipped: ${testSummary.skipped}
Pass Rate: ${passRate}%
Duration: ${duration}"""
        )
    }
}
```

### Management Dashboard (Weekly Report Template)

```
📊 QA AUTOMATION WEEKLY REPORT — Week 24
═══════════════════════════════════════════
✅ Pass Rate:       97.5% (target: 95%)     ▲ +2% vs last week
🔢 Total Tests:     200 automated
⏱ Execution Time:  42 minutes               ▼ -8 min (optimized)
🔍 Coverage:        78% of regression cases  ▲ +5% (new tests added)
🐛 Bugs Found:      14 defects caught early
🧩 Flaky Tests:     3 (being investigated)   ▲ ACTION NEEDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOP FAILURES THIS WEEK:
1. Payment gateway timeout (3 fails) → Known infra issue, ticket raised
2. Search sort order (2 fails)       → Bug filed: JIRA-1234
═══════════════════════════════════════════
```

### Automation ROI Calculation

```
Monthly Manual Testing Cost:
Testers: 3 × $50/hr × 160 hrs = $24,000/month

Automation Investment:
Framework build: $15,000 (one-time)
Maintenance: 1 tester × $50/hr × 40 hrs = $2,000/month

Monthly Saving: $24,000 - $2,000 = $22,000/month
ROI payback period: $15,000 / $22,000 = ~0.7 months
```
  $ans$,
  'Scenario-Based', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Selenium','Metrics','Reporting','Management','Pass Rate','Coverage','ROI','Dashboard','Jenkins'],
  true, 0
),

-- Scenario Q28
(
  'How do you test a drag and drop feature in Selenium?',
  'selenium-scenario-q28-drag-drop-selenium-actions',
  'Use Actions.dragAndDrop() for standard HTML5 drag-drop, or JavascriptExecutor for custom drag-drop implementations that ignore synthetic mouse events.',
  $ans$
## Drag and Drop in Selenium

### Method 1 — Actions.dragAndDrop() (Standard)

```java
WebElement source = driver.findElement(By.id("dragItem"));
WebElement target = driver.findElement(By.id("dropZone"));

Actions actions = new Actions(driver);
actions.dragAndDrop(source, target).perform();
```

### Method 2 — Actions with Click-Hold-Release

```java
WebElement source = driver.findElement(By.id("dragItem"));
WebElement target = driver.findElement(By.id("dropZone"));

new Actions(driver)
    .clickAndHold(source)
    .pause(Duration.ofMillis(500))  // pause helps with some implementations
    .moveToElement(target)
    .pause(Duration.ofMillis(500))
    .release()
    .perform();
```

### Method 3 — Drag by Offset (Pixel Coordinates)

```java
WebElement source = driver.findElement(By.cssSelector(".draggable-box"));

new Actions(driver)
    .clickAndHold(source)
    .moveByOffset(300, 0)   // move 300px right, 0px down
    .release()
    .perform();
```

### Method 4 — JavaScript Simulation (for HTML5 DnD)

Many modern drag-drop implementations (React DnD, Sortable.js) use custom events that Actions cannot trigger. Use a JS simulation:

```java
String dragDropScript = """
    function simulateDragDrop(sourceSelector, targetSelector) {
        var source = document.querySelector(sourceSelector);
        var target = document.querySelector(targetSelector);
        var dataTransfer = new DataTransfer();

        source.dispatchEvent(new DragEvent('dragstart', {dataTransfer: dataTransfer, bubbles: true}));
        target.dispatchEvent(new DragEvent('dragover',  {dataTransfer: dataTransfer, bubbles: true}));
        target.dispatchEvent(new DragEvent('drop',      {dataTransfer: dataTransfer, bubbles: true}));
        source.dispatchEvent(new DragEvent('dragend',   {dataTransfer: dataTransfer, bubbles: true}));
    }
    simulateDragDrop(arguments[0], arguments[1]);
""";

JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript(dragDropScript, "#dragItem", "#dropZone");
```

### Verify Drop Was Successful

```java
// After drag-drop, verify target contains the item
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement dropZone = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.id("dropZone"))
);
Assert.assertTrue(dropZone.getText().contains("Widget A"),
    "Item was not dropped into the drop zone");
```

### Drag and Reorder List Items

```java
// Drag 3rd item to 1st position
List<WebElement> items = driver.findElements(By.cssSelector(".sortable-item"));
WebElement thirdItem = items.get(2);
WebElement firstItem = items.get(0);

new Actions(driver)
    .clickAndHold(thirdItem)
    .moveToElement(firstItem)
    .release()
    .perform();

// Verify new order
List<WebElement> reordered = driver.findElements(By.cssSelector(".sortable-item"));
Assert.assertEquals(reordered.get(0).getText(), thirdItem.getText());
```

### Common Issues and Fixes

| Issue | Fix |
|---|---|
| DnD doesn''t work with Actions | Use JS simulation for HTML5 DnD |
| Drop happens too fast | Add `.pause(Duration.ofMillis(500))` |
| Source element not draggable | Check `draggable="true"` in HTML |
| React/Vue DnD not responding | Use library-specific event dispatching |
  $ans$,
  'Scenario-Based', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Drag and Drop','Actions','JavascriptExecutor','HTML5','DnD','clickAndHold'],
  true, 0
),

-- Scenario Q29
(
  'How do you test a canvas or chart element in Selenium?',
  'selenium-scenario-q29-test-canvas-chart-element-selenium',
  'Selenium cannot read canvas pixel data directly — use JavascriptExecutor to call canvas APIs, verify via underlying data attributes, or use visual comparison for chart validation.',
  $ans$
## Testing Canvas and Chart Elements

HTML `<canvas>` renders graphics as pixels — Selenium cannot inspect pixel content directly. Use these approaches:

### Approach 1 — Verify Underlying Data (Best)

Most chart libraries (Chart.js, D3, Highcharts) store data in accessible JS variables:

```java
JavascriptExecutor js = (JavascriptExecutor) driver;

// Chart.js — access chart instance data
Object chartData = js.executeScript(
    "return window.myChart.data.datasets[0].data;"
);
System.out.println("Chart data: " + chartData);

// D3 — read bound data
Object d3Data = js.executeScript(
    "return d3.select('.bar').datum();"
);
```

### Approach 2 — Read Chart Tooltips via Hover

```java
WebElement chart = driver.findElement(By.cssSelector("canvas.chart"));

// Hover over chart to trigger tooltip
new Actions(driver)
    .moveToElement(chart, 100, 50) // hover at specific coordinates
    .perform();

// Read tooltip that appears in DOM
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(3));
WebElement tooltip = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".chart-tooltip"))
);
Assert.assertEquals(tooltip.getText(), "Sales: $12,450");
```

### Approach 3 — Verify Highcharts via JS API

```java
// Highcharts exposes data via Highcharts.charts array
String seriesName = (String) js.executeScript(
    "return Highcharts.charts[0].series[0].name;"
);
Double dataPoint = (Double) js.executeScript(
    "return Highcharts.charts[0].series[0].data[2].y;"
);

Assert.assertEquals(seriesName, "Revenue");
Assert.assertEquals(dataPoint, 45000.0, 0.01);
```

### Approach 4 — Screenshot Comparison for Visual Validation

```java
// Take screenshot of just the chart element
WebElement chartElement = driver.findElement(By.cssSelector(".chart-container"));
Screenshot chartShot = new AShot().takeScreenshot(driver, chartElement);

// Compare with baseline
BufferedImage baseline = ImageIO.read(new File("baseline/revenue-chart.png"));
ImageDiff diff = new ImageDiffer().makeDiff(new Screenshot(baseline), chartShot);
Assert.assertFalse(diff.hasDiff(), "Chart appearance has changed");
```

### Approach 5 — Read ARIA / Accessibility Attributes

Many chart libraries add ARIA labels for accessibility:

```java
// Chart.js with accessibility plugin adds aria-label
WebElement bar = driver.findElement(By.cssSelector("[aria-label*='January']"));
String label = bar.getAttribute("aria-label");
// "January: $12,450"
Assert.assertTrue(label.contains("12,450"));
```

### Approach 6 — Read Table Behind Chart

Many dashboards show both a chart and a data table:

```java
// Click "View as Table" or check if underlying table exists
WebElement viewTableBtn = driver.findElement(By.cssSelector(".view-table-btn"));
viewTableBtn.click();

// Now validate the data table rows
List<WebElement> rows = driver.findElements(By.cssSelector("table.chart-data tbody tr"));
Assert.assertEquals(rows.size(), 12, "Should have 12 months of data");
```

### Canvas Interaction (Click on Specific Point)

```java
WebElement canvas = driver.findElement(By.tagName("canvas"));
// Click at pixel coordinates (x=150, y=75) relative to canvas
new Actions(driver)
    .moveToElement(canvas, 150, 75)
    .click()
    .perform();
```
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Canvas','Chart.js','Highcharts','D3','Visual Testing','JavascriptExecutor','Tooltip'],
  true, 0
),

-- Scenario Q30
(
  'Your automation suite has 500 tests and takes 2 hours to run. How do you reduce execution time?',
  'selenium-scenario-q30-reduce-test-execution-time-500-tests',
  'Distribute tests across parallel threads and Selenium Grid nodes, split suites by group (smoke/regression), optimize waits, and use API calls instead of UI for setup steps.',
  $ans$
## Reducing Test Execution Time for Large Suites

A 2-hour suite is too slow for CI/CD. Here is the systematic optimization approach:

### Step 1 — Parallel Execution (Biggest Impact: 3-5× speedup)

```xml
<!-- testng.xml — run methods in parallel with 10 threads -->
<suite name="Suite" parallel="methods" thread-count="10">
    <test name="Regression">
        <classes>
            <class name="tests.LoginTest"/>
            <class name="tests.CartTest"/>
            <class name="tests.CheckoutTest"/>
        </classes>
    </test>
</suite>
```

500 tests at 15 min each sequentially = 7,500 min
With 10 parallel threads = 750 min (7.5× speedup, accounting for overhead)

### Step 2 — Selenium Grid / Cloud Parallel (10× speedup)

```java
// Run 50 tests simultaneously on Selenium Grid
WebDriver driver = new RemoteWebDriver(
    new URL("http://selenium-hub:4444/wd/hub"),
    new ChromeOptions()
);
```

```xml
<!-- 50 simultaneous threads across Grid nodes -->
<suite parallel="methods" thread-count="50">
```

### Step 3 — Split by Priority

```bash
# Pipeline Stage 1: Smoke (15 tests, 3 min) — every commit
mvn test -Dgroups="smoke" -Dthread-count=5

# Pipeline Stage 2: Regression (500 tests, 20 min) — every PR
mvn test -Dgroups="regression" -Dthread-count=20

# Pipeline Stage 3: Full suite (nightly only)
mvn test -Dthread-count=50
```

### Step 4 — Replace UI Steps with API Calls

```java
// SLOW: Login via UI every test (30 seconds each)
// × 500 tests = 4 hours just on login!
@BeforeMethod
public void loginViaUI() {
    driver.get(baseUrl + "/login");
    driver.findElement(By.id("username")).sendKeys("admin");
    driver.findElement(By.id("password")).sendKeys("pass");
    driver.findElement(By.id("loginBtn")).click();
}

// FAST: Login via API once, inject cookie
@BeforeSuite
public void loginViaAPI() {
    Response r = RestAssured.given()
        .body("{\"email\":\"admin@test.com\",\"password\":\"pass\"}")
        .post("/api/login");
    this.authCookie = r.getCookie("session");
}

@BeforeMethod
public void injectSession() {
    driver.get(baseUrl);
    driver.manage().addCookie(new Cookie("session", authCookie));
    // 2 seconds instead of 30!
}
```

### Step 5 — Eliminate Unnecessary Waits

```java
// SLOW: Fixed waits everywhere
Thread.sleep(5000); // wasting time 500× = 41 minutes wasted!

// FAST: Wait only as long as needed
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("result")));
// Continues as soon as element appears
```

### Step 6 — Headless Mode in CI

```java
// Headless is 20-40% faster than headed
options.addArguments("--headless=new");
```

### Results After Optimization

```
Before:  2 hours sequential
After:
  Step 1 (parallel, 10 threads): 12 minutes
  Step 2 (Grid, 50 threads):      3 minutes
  Step 3 (API login):              -40 min saved
  Step 4 (no Thread.sleep):        -30 min saved
Final: ~8-12 minutes for 500 tests on Grid
```

### Optimization Priority Matrix

| Optimization | Effort | Impact |
|---|---|---|
| Parallel execution | Low | Very High |
| Selenium Grid | Medium | Very High |
| API login bypass | Medium | High |
| Remove Thread.sleep | Low | High |
| Headless mode | Low | Medium |
| Smoke/regression split | Low | Medium |
| Test data optimization | Medium | Medium |
  $ans$,
  'Scenario-Based', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Selenium','Performance','Parallel','Selenium Grid','Optimization','Headless','API','CI/CD'],
  true, 0
),

-- Scenario Q31
(
  'How do you handle a test that requires database validation in Selenium?',
  'selenium-scenario-q31-database-validation-selenium-jdbc',
  'Use JDBC to query the database directly after UI actions — verify backend data matches UI display, ideal for data integrity checks in form submission and order processing tests.',
  $ans$
## Database Validation in Selenium Tests

UI validation alone is not enough for data integrity. Combine Selenium UI actions with JDBC database queries.

### Setup — JDBC Dependencies

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

### DatabaseUtils Class

```java
public class DatabaseUtils {
    private static Connection connection;

    public static void connect(String url, String user, String pass) throws Exception {
        connection = DriverManager.getConnection(url, user, pass);
    }

    public static String getColumnValue(String query, String column) throws Exception {
        ResultSet rs = connection.createStatement().executeQuery(query);
        if (rs.next()) return rs.getString(column);
        return null;
    }

    public static int getRowCount(String query) throws Exception {
        ResultSet rs = connection.createStatement().executeQuery(query);
        rs.last();
        return rs.getRow();
    }

    public static void closeConnection() throws Exception {
        if (connection != null) connection.close();
    }
}
```

### Test — UI Action + DB Validation

```java
@Test
public void verifyUserRegistrationSavedToDatabase() throws Exception {
    // UI: Submit registration form
    driver.findElement(By.id("firstName")).sendKeys("John");
    driver.findElement(By.id("lastName")).sendKeys("Doe");
    driver.findElement(By.id("email")).sendKeys("john.doe@automateqa.online");
    driver.findElement(By.id("registerBtn")).click();

    // Wait for confirmation
    new WebDriverWait(driver, Duration.ofSeconds(10))
        .until(ExpectedConditions.textToBePresentInElementLocated(
            By.cssSelector(".success-msg"), "Registration successful"));

    // DB: Verify data was actually saved correctly
    String email = DatabaseUtils.getColumnValue(
        "SELECT email FROM users WHERE email = ''john.doe@automateqa.online''",
        "email"
    );

    Assert.assertEquals(email, "john.doe@automateqa.online",
        "User email not found in database after registration");
}
```

### Test — Order Submission

```java
@Test
public void verifyOrderCreatedInDatabase() throws Exception {
    // UI: Place order
    driver.findElement(By.id("checkoutBtn")).click();
    driver.findElement(By.id("confirmBtn")).click();

    String orderId = driver.findElement(By.cssSelector(".order-id")).getText();
    float uiTotal = Float.parseFloat(
        driver.findElement(By.cssSelector(".order-total")).getText().replace("$", ""));

    // DB: Cross-check order record
    String dbStatus = DatabaseUtils.getColumnValue(
        "SELECT status FROM orders WHERE order_id = ''" + orderId + "''", "status");
    String dbTotal = DatabaseUtils.getColumnValue(
        "SELECT total FROM orders WHERE order_id = ''" + orderId + "''", "total");

    Assert.assertEquals(dbStatus, "CONFIRMED", "Order status mismatch in DB");
    Assert.assertEquals(Float.parseFloat(dbTotal), uiTotal, 0.01f, "Order total mismatch");
}
```

### Setup/Teardown

```java
@BeforeSuite
public void dbConnect() throws Exception {
    DatabaseUtils.connect(
        "jdbc:mysql://localhost:3306/testdb",
        System.getenv("DB_USER"),
        System.getenv("DB_PASS")
    );
}

@AfterSuite
public void dbDisconnect() throws Exception {
    DatabaseUtils.closeConnection();
}

@AfterMethod
public void cleanTestData() throws Exception {
    DatabaseUtils.executeUpdate(
        "DELETE FROM users WHERE email LIKE ''%@automateqa.online''"
    );
}
```
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Database','JDBC','MySQL','Data Validation','Integration Test','SQL','Backend'],
  true, 0
),

-- Scenario Q32
(
  'How do you test a rich text editor like TinyMCE or CKEditor in Selenium?',
  'selenium-scenario-q32-test-rich-text-editor-tinymce-ckeditor',
  'Rich text editors use iframes — switch into the iframe, click the body element, and use JavascriptExecutor to set content or Actions to type formatted text.',
  $ans$
## Testing Rich Text Editors (TinyMCE / CKEditor) in Selenium

Rich text editors render inside an `<iframe>` with a `contenteditable` body. Standard `sendKeys` on the visible area does not work.

### TinyMCE — Type Text via iframe

```java
// Switch to TinyMCE''s iframe
driver.switchTo().frame(driver.findElement(By.cssSelector("#tinymce_ifr")));

// Click the body and type
WebElement body = driver.findElement(By.cssSelector("body#tinymce"));
body.click();
body.sendKeys("Hello from Selenium! This is a test article.");

// Switch back to main page
driver.switchTo().defaultContent();
```

### TinyMCE — Set Content via JavaScript API

```java
// Faster and more reliable — use TinyMCE''s own API
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript(
    "tinymce.get(0).setContent('<p><b>Bold Text</b> and <i>Italic Text</i></p>')"
);
```

### TinyMCE — Get Content

```java
String editorContent = (String) js.executeScript(
    "return tinymce.get(0).getContent();"
);
Assert.assertTrue(editorContent.contains("Bold Text"),
    "Expected text not found in editor");
```

### CKEditor — Set Content

```java
// CKEditor 4
js.executeScript(
    "CKEDITOR.instances['editor1'].setData('<p>Test content</p>')"
);

// CKEditor 5
js.executeScript(
    "document.querySelector('.ck-editor__editable').ckeditorInstance" +
    ".setData('<p>Test content</p>')"
);
```

### TinyMCE — Click Toolbar Buttons

```java
// Switch back to main page first
driver.switchTo().defaultContent();

// Click Bold button in toolbar
driver.findElement(By.cssSelector(".tox-tbtn[title='Bold']")).click();

// Now switch back to editor iframe and type bold text
driver.switchTo().frame(driver.findElement(By.cssSelector("#tinymce_ifr")));
driver.findElement(By.cssSelector("body#tinymce")).sendKeys("This will be bold");
driver.switchTo().defaultContent();
```

### Quill.js Editor

```java
// Quill uses a div, not iframe
WebElement editor = driver.findElement(By.cssSelector(".ql-editor"));
editor.click();
editor.sendKeys("Test content for Quill editor");

// Or via JS
js.executeScript(
    "document.querySelector('.ql-editor').innerHTML = '<p>Test content</p>'"
);
```

### Verify Content After Submission

```java
// After saving/submitting the article
driver.findElement(By.id("saveBtn")).click();

// Verify rendered output on view page
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement articleBody = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".article-content"))
);
Assert.assertTrue(articleBody.getText().contains("Bold Text"));
Assert.assertTrue(articleBody.findElement(By.tagName("b")).isDisplayed());
```
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','TinyMCE','CKEditor','Rich Text Editor','iframe','JavascriptExecutor','Quill'],
  true, 0
),

-- Scenario Q33
(
  'How do you prioritize which test cases to automate in a project?',
  'selenium-scenario-q33-prioritize-test-cases-to-automate',
  'Automate high-frequency regression tests, smoke tests, and data-driven scenarios first — avoid automating tests for unstable features, one-time tests, or exploratory scenarios.',
  $ans$
## Prioritizing Test Cases for Automation

Not every test should be automated. Wrong prioritization wastes automation effort on low-ROI tests.

### Automation Candidate Matrix

Score each test on these factors (1-5 scale):

```
Score = Frequency × Risk × Stability × Data-Driven Potential - Manual Effort
```

| Test Type | Automate? | Reason |
|---|---|---|
| Regression suite (run every sprint) | ✅ Yes | High frequency = high ROI |
| Smoke tests (run every build) | ✅ Yes | Critical, frequent, fast |
| Data-driven (50 data sets) | ✅ Yes | Time-consuming manually |
| Cross-browser validation | ✅ Yes | Manual would take days |
| New feature (unstable locators) | ⏳ Later | Wait for feature to stabilize |
| One-time migration test | ❌ No | ROI too low |
| Exploratory testing | ❌ No | Requires human judgment |
| CAPTCHA/OTP flows | ❌ No | Cannot automate reliably |
| Highly visual design tests | ⏳ Maybe | Use visual testing tools |
| Infrequent edge cases | ❌ No | Manual is faster |

### Priority 1 — Automate First

```
✅ Login / Authentication flows
✅ Core user journey (search → add to cart → checkout)
✅ API endpoint smoke tests
✅ Data entry forms with 20+ test data sets
✅ Cross-browser critical flows
✅ Nightly regression suite
✅ Tests that failed in last 3 releases
```

### Priority 2 — Automate Next

```
⏳ Error message validation (forms, boundaries)
⏳ Permission/role-based access tests
⏳ PDF/Email generation triggers
⏳ Search and filter combinations
⏳ Pagination and infinite scroll
```

### Do Not Automate

```
❌ Tests for features being redesigned next sprint
❌ Tests that require subjective judgment ("looks correct")
❌ Production data cleanup scripts
❌ One-time setup scripts
❌ Tests with dynamic, unpredictable data
```

### Automation ROI Formula

```
ROI = (Time saved per sprint × Number of sprints) / Automation effort

Example:
Test: Login regression — 4 scenarios, 20 min manual each sprint
Automation effort: 4 hours to write

ROI = (80 min/sprint × 20 sprints) / 240 min = 6.6×
→ Good candidate: automate it

Test: Visual layout check — 1 test, 5 min manual
Automation effort: 4 hours + visual tool setup

ROI = (5 min/sprint × 20 sprints) / 240 min = 0.4×
→ Poor ROI: keep manual or use lightweight visual snapshot
```

### Automation Coverage Target

```
Smoke tests:     100% automated (run on every commit)
Regression:      80% automated  (run on every PR/daily)
Exploratory:     0%             (always manual)
New features:    Automate after 2nd sprint of stability
```
  $ans$,
  'Scenario-Based', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Selenium','Test Planning','Prioritization','ROI','Automation Strategy','Coverage','Regression'],
  true, 0
),

-- Scenario Q34
(
  'How do you maintain a large Selenium test suite and prevent test rot?',
  'selenium-scenario-q34-maintain-large-selenium-test-suite',
  'Adopt strict naming conventions, locator centralization in Page Objects, flakiness tracking, regular refactoring cycles, and CI failure review processes to prevent test suite degradation.',
  $ans$
## Maintaining Large Selenium Test Suites

Test suites rot when locators break, tests become flaky, and nobody refactors. Here is the maintenance discipline used in mature QA teams:

### Rule 1 — Centralize All Locators in Page Objects

```java
// WRONG — locators scattered in test methods
@Test
public void loginTest() {
    driver.findElement(By.id("username")).sendKeys("admin"); // hardcoded
}

// RIGHT — all locators in Page Object
public class LoginPage {
    private By usernameField = By.id("username");  // change once, fixes all tests
    private By passwordField = By.id("password");
    private By loginBtn      = By.cssSelector(".btn-login");

    public LoginPage typeUsername(String user) {
        driver.findElement(usernameField).sendKeys(user);
        return this;
    }
}
```

### Rule 2 — Track and Fix Flaky Tests Weekly

```java
// Tag flaky tests explicitly — don''t hide them
@Test(groups = {"flaky"})
@Issue("JIRA-456 — intermittent timeout on slow CI")
public void checkoutTest() { ... }

// Exclude flaky from main pipeline
// Fix by end of sprint — otherwise delete the test
```

### Rule 3 — Strict Naming Conventions

```java
// Method name pattern: should{ExpectedBehavior}When{Condition}
public void shouldShowErrorWhenPasswordIsMissing() { }
public void shouldRedirectToDashboardAfterValidLogin() { }
public void shouldDisplayTotalPriceIncludingTax() { }

// Easy to understand failures without reading code
```

### Rule 4 — Page Object Review on UI Changes

When dev pushes a UI change:
1. Run smoke suite — identify broken tests
2. Update locators in Page Object only (not in 50 test methods)
3. Re-run to verify fix
4. Merge Page Object update

### Rule 5 — Monthly Refactoring Sprint

```
Week 1-3: Feature/test development
Week 4:   Maintenance week
  - Fix all flaky tests (or delete them)
  - Update deprecated locators
  - Remove obsolete tests (feature removed)
  - Add missing test coverage
  - Review test execution time trends
```

### Rule 6 — Code Review for Test PRs

Every new test must be reviewed for:
- [ ] No hardcoded waits (`Thread.sleep`)
- [ ] No hardcoded locators outside Page Object
- [ ] Test is independent (no dependency on other tests)
- [ ] Meaningful assertion messages
- [ ] Clean setup and teardown

### Rule 7 — Deletion Policy for Dead Tests

```java
// Test has failed 5+ consecutive runs
// No one has fixed it in 2 sprints
// → DELETE the test, file bug separately

// Keeping broken tests is worse than no test
// They add noise and reduce trust in the suite
```

### Maintenance Metrics to Track

```
Flakiness rate:     Target < 2%  — Alert if > 5%
Pass rate trend:    Alert if drops > 3% week-over-week
Test count growth:  +5-10 new tests per sprint
Execution time:     Alert if suite grows > 30 min
Disabled tests:     Review all @Test(enabled=false) monthly
```
  $ans$,
  'Scenario-Based', 'Scenario-Based', '5+ Years', 'Advanced',
  ARRAY['Selenium','Maintenance','Page Object','Flaky Tests','Naming Convention','Refactoring','Test Suite'],
  true, 0
),

-- Scenario Q35
(
  'How do you test responsive design across different screen sizes in Selenium?',
  'selenium-scenario-q35-test-responsive-design-screen-sizes',
  'Use driver.manage().window().setSize() to test at breakpoints (mobile/tablet/desktop), or use Chrome DevTools Protocol to emulate specific devices with correct viewport and user agent.',
  $ans$
## Testing Responsive Design in Selenium

### Method 1 — Resize Browser Window (Breakpoints)

```java
public class ResponsiveTest extends BaseTest {

    // Common breakpoints to test
    private static final Dimension MOBILE_PORTRAIT  = new Dimension(375,  812);
    private static final Dimension MOBILE_LANDSCAPE = new Dimension(812,  375);
    private static final Dimension TABLET           = new Dimension(768,  1024);
    private static final Dimension DESKTOP          = new Dimension(1366, 768);
    private static final Dimension WIDE             = new Dimension(1920, 1080);

    @Test(dataProvider = "screenSizes")
    public void verifyNavbarAtBreakpoints(Dimension size, String label) {
        driver.manage().window().setSize(size);
        driver.get("https://automateqa.online");

        System.out.println("Testing at: " + label + " (" + size.width + "×" + size.height + ")");

        if (size.width < 768) {
            // Mobile: hamburger menu should be visible, desktop nav hidden
            Assert.assertTrue(
                driver.findElement(By.cssSelector(".hamburger-menu")).isDisplayed(),
                "Hamburger menu not visible on " + label);
            Assert.assertFalse(
                driver.findElement(By.cssSelector(".desktop-nav")).isDisplayed(),
                "Desktop nav should be hidden on " + label);
        } else {
            // Desktop: full nav visible, hamburger hidden
            Assert.assertTrue(
                driver.findElement(By.cssSelector(".desktop-nav")).isDisplayed(),
                "Desktop nav not visible on " + label);
        }

        // Take screenshot for each breakpoint
        ScreenshotUtils.capture(driver, label.replace(" ", "_") + "_navbar");
    }

    @DataProvider(name = "screenSizes")
    public Object[][] screenSizes() {
        return new Object[][] {
            {MOBILE_PORTRAIT,  "Mobile Portrait"},
            {MOBILE_LANDSCAPE, "Mobile Landscape"},
            {TABLET,           "Tablet"},
            {DESKTOP,          "Desktop"},
            {WIDE,             "Wide Desktop"},
        };
    }
}
```

### Method 2 — CDP Device Emulation (Selenium 4)

```java
ChromeDriver chromeDriver = (ChromeDriver) driver;
DevTools devTools = chromeDriver.getDevTools();
devTools.createSession();

// Emulate iPhone 14 Pro
Map<String, Object> iPhoneMetrics = Map.of(
    "width",             393,
    "height",            852,
    "mobile",            true,
    "deviceScaleFactor", 3.0
);
chromeDriver.executeCdpCommand("Emulation.setDeviceMetricsOverride", iPhoneMetrics);

// Set mobile user agent
chromeDriver.executeCdpCommand("Emulation.setUserAgentOverride", Map.of(
    "userAgent", "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"
));

driver.get("https://automateqa.online");
// Now browser behaves like iPhone 14 Pro
```

### Method 3 — ChromeOptions Mobile Emulation

```java
Map<String, Object> mobileEmulation = new HashMap<>();
mobileEmulation.put("deviceName", "iPhone 14 Pro"); // Chrome DevTools device list

ChromeOptions options = new ChromeOptions();
options.setExperimentalOption("mobileEmulation", mobileEmulation);
WebDriver mobileDriver = new ChromeDriver(options);
```

### Method 4 — Verify CSS Media Query Breakpoints

```java
// Verify element visibility at different widths
JavascriptExecutor js = (JavascriptExecutor) driver;

driver.manage().window().setSize(new Dimension(375, 812));
Boolean isMobileNavVisible = (Boolean) js.executeScript(
    "return window.getComputedStyle(document.querySelector('.mobile-nav')).display !== 'none'"
);
Assert.assertTrue(isMobileNavVisible, "Mobile nav should show at 375px");

driver.manage().window().setSize(new Dimension(1366, 768));
Boolean isDesktopNavVisible = (Boolean) js.executeScript(
    "return window.getComputedStyle(document.querySelector('.desktop-nav')).display !== 'none'"
);
Assert.assertTrue(isDesktopNavVisible, "Desktop nav should show at 1366px");
```

### Responsive Test Checklist

| Element | Mobile (<768px) | Tablet (768-1024px) | Desktop (>1024px) |
|---|---|---|---|
| Navigation | Hamburger menu | Full or collapsible | Full menu |
| Hero image | Stack vertically | Side by side | Wide banner |
| Product grid | 1 column | 2 columns | 4 columns |
| Font size | 14-16px | 16px | 16-18px |
| CTA buttons | Full width | Auto | Auto |
| Footer | Stacked | 2 columns | 4 columns |
  $ans$,
  'Scenario-Based', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Responsive Design','Mobile','Breakpoints','CDP','Device Emulation','ChromeOptions','Media Query'],
  true, 0
);
