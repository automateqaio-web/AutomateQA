-- Cucumber Scenario-Based Questions (Senior Level) Q1–Q15
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- S1
(
  'You are asked to design a Cucumber BDD framework from scratch for a new e-commerce project. How would you approach it?',
  'cucumber-scenario-q001-framework-design',
  'Design a Cucumber BDD framework with POM + PicoContainer DI, layered architecture (pages/stepDefs/hooks/runners/utils), config-driven environments, parallel execution, and Masterthought reporting — structured for a team of 5 QAs.',
  $ans$
## Designing a Cucumber BDD Framework from Scratch

### Phase 1: Requirements Gathering (Day 1)

Before writing code, answer these:
- Team size and Cucumber experience?
- Application type (web/mobile/API/hybrid)?
- Environments (dev/staging/prod)?
- CI/CD tool (Jenkins/GitHub Actions)?
- Reporting requirements (HTML/Slack/Jira)?
- Parallel execution required?

### Phase 2: Technology Stack Decision

```
Core BDD:       Cucumber 7.x (cucumber-java + cucumber-testng)
Browser:        Selenium WebDriver 4.x
Driver Setup:   WebDriverManager 5.x
Runner:         TestNG 7.x (parallel DataProvider support)
DI:             PicoContainer (constructor injection, zero config)
Build:          Maven 3.x
Reporting:      Masterthought cucumber-reporting + Allure
CI/CD:          Jenkins (Declarative Pipeline)
Version Ctrl:   Git + GitHub/GitLab
API Testing:    REST Assured 5.x (hybrid scenarios)
Assertions:     TestNG Assert + SoftAssert
Test Data:      Faker + config.properties per env
```

### Phase 3: Project Structure

```
cucumber-bdd-framework/
  ├── pom.xml
  ├── testng.xml                          ← suite configuration
  ├── testng-parallel.xml                 ← parallel cross-browser
  ├── src/
  │   └── test/
  │       ├── java/
  │       │   ├── context/
  │       │   │   └── ScenarioContext.java  ← PicoContainer World
  │       │   ├── factory/
  │       │   │   └── DriverFactory.java    ← browser creation
  │       │   ├── hooks/
  │       │   │   └── Hooks.java            ← @Before/@After
  │       │   ├── pages/
  │       │   │   ├── BasePage.java         ← wait utilities
  │       │   │   ├── LoginPage.java
  │       │   │   ├── ProductPage.java
  │       │   │   └── CheckoutPage.java
  │       │   ├── stepDefinitions/
  │       │   │   ├── LoginSteps.java
  │       │   │   ├── ProductSteps.java
  │       │   │   └── CommonSteps.java
  │       │   ├── runners/
  │       │   │   ├── SmokeTestRunner.java
  │       │   │   ├── RegressionTestRunner.java
  │       │   │   └── RerunTestRunner.java
  │       │   └── utils/
  │       │       ├── ConfigReader.java
  │       │       ├── TestDataGenerator.java
  │       │       └── ApiUtils.java
  │       └── resources/
  │           ├── features/
  │           │   ├── login/login.feature
  │           │   ├── product/search.feature
  │           │   └── checkout/payment.feature
  │           └── config/
  │               ├── config.dev.properties
  │               ├── config.staging.properties
  │               └── config.prod.properties
```

### Phase 4: Core Framework Classes

**ScenarioContext.java** (PicoContainer World):
```java
public class ScenarioContext {
    public WebDriver driver;
    public SoftAssert softAssert = new SoftAssert();
    private Map<String, Object> data = new HashMap<>();
    public void set(String key, Object val) { data.put(key, val); }
    public <T> T get(String key) { return (T) data.get(key); }
}
```

**Hooks.java**:
```java
public class Hooks {
    private final ScenarioContext ctx;
    public Hooks(ScenarioContext ctx) { this.ctx = ctx; }

    @Before(order = 100)
    public void setUp() {
        ctx.driver = DriverFactory.createDriver(
            ConfigReader.getBrowser(), ConfigReader.isHeadless());
        ctx.driver.manage().window().maximize();
        ctx.driver.manage().timeouts()
            .implicitlyWait(Duration.ofSeconds(0));  // use explicit waits only
    }

    @After(order = 100)
    public void softAssertAll() { ctx.softAssert.assertAll(); }

    @After(order = 0)
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            scenario.attach(
                ((TakesScreenshot) ctx.driver).getScreenshotAs(OutputType.BYTES),
                "image/png", "Failure");
        }
        ctx.driver.quit();
    }
}
```

### Phase 5: Tagging & Execution Strategy

```
@smoke      → 15 tests  → every commit (<5 min)
@sanity     → 50 tests  → every PR merge (<20 min)
@regression → all tests → nightly (2AM)
@P1/@P2/@P3 → priority-based
@api/@ui/@db → test type
@wip        → excluded from CI
```

### Phase 6: CI/CD Jenkins Pipeline

```groovy
pipeline {
    agent any
    parameters {
        choice(name: 'ENV',    choices: ['staging', 'dev'], description: '')
        choice(name: 'TAGS',   choices: ['@smoke', '@regression'], description: '')
        choice(name: 'BROWSER', choices: ['chrome', 'firefox'], description: '')
    }
    stages {
        stage('Test')   { steps { sh "mvn clean test -Denv=${params.ENV} -Dcucumber.filter.tags='${params.TAGS}' -Dbrowser=${params.BROWSER}" } }
        stage('Rerun')  { steps { sh "mvn test -Prerun" } }
        stage('Report') { steps { sh "mvn verify -DskipTests" } }
    }
    post {
        always  { cucumber fileIncludePattern: '**/cucumber.json', reportTitle: 'BDD Report' }
        failure { slackSend channel: '#qa-alerts', color: 'danger', message: "❌ ${params.TAGS} failed on ${params.ENV}" }
    }
}
```

### Phase 7: Onboarding QA Team

1. Git clone + `mvn clean verify -DskipTests` → verify build
2. Run `@smoke` suite → verify 15 tests pass
3. Write one new feature file + step definition → first contribution
4. Pair review of feature files in 3 Amigos sessions

**Delivery timeline**: Framework ready in 3 days, first regression suite in 2 weeks.
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Framework Design','Architecture','PicoContainer','Senior'],
  true, 0
),

-- S2
(
  'Your project has 200 Cucumber scenarios. 80% of them require login. How do you avoid repeating login steps in every Background?',
  'cucumber-scenario-q002-shared-login-strategy',
  'Use a @Before("@needs-login") tagged hook with API-based session injection instead of UI login. Authenticate via REST API, set the session cookie on the browser, and skip the entire login UI — making tests 30-60 seconds faster each.',
  $ans$
## Handling Login Across 200 Scenarios

### Problem

```gherkin
-- Repeated in 160 feature files = maintenance nightmare
Background:
  Given the user opens the browser
  And navigates to the login page
  And enters username "admin@test.com"
  And enters password "Admin@123"
  And clicks Login
  And waits for dashboard to load
```

This adds ~10-30 seconds to every scenario. For 160 scenarios = 40-80 minutes of wasted login time.

### Solution 1: API Login Hook (Best — Fastest)

```java
// Hooks.java
@Before("@needs-login")
public void loginViaApi() {
    // 1. Get session token via REST API (< 200ms)
    Response resp = given()
        .body(Map.of("email", "admin@test.com", "password", "Admin@123"))
        .post(ConfigReader.getApiUrl() + "/auth/login");

    String sessionToken = resp.jsonPath().getString("token");
    String sessionCookie = resp.jsonPath().getString("sessionId");

    // 2. Open browser to the domain (needed to set cookies)
    ctx.driver.get(ConfigReader.getBaseUrl());

    // 3. Inject session cookie — browser now thinks user is logged in
    ctx.driver.manage().addCookie(
        new Cookie("SESSION", sessionCookie,
            ".example.com", "/", null, false, true));

    // 4. Navigate directly to the page under test
    // No login page visited — user is already authenticated
}

@Before(order = 50)  // runs before @needs-login hook
public void setUp() {
    ctx.driver = DriverFactory.createDriver("chrome", false);
    ctx.driver.manage().window().maximize();
}
```

### Feature Files — Tag Scenarios, Not Background

```gherkin
@regression @needs-login
Feature: Product Catalog

  -- No Background needed for login!

  Scenario: Search for laptop
    Given the user is on the product catalog page
    When the user searches for "laptop"
    Then the search results should appear

  Scenario: Filter by category
    Given the user is on the product catalog page
    When the user filters by "Electronics"
    Then only electronics products should show

@regression @no-login
Feature: Public Landing Page

  Scenario: View hero banner
    Given the user navigates to the home page
    Then the hero banner should be visible
```

### Solution 2: Shared Login State (UI Login Once per Suite)

```java
// For cases where API login injection isn''t possible
public class LoginState {
    private static volatile boolean isLoggedIn = false;
    private static final Object lock = new Object();
}

@Before("@needs-login")
public synchronized void ensureLoggedIn() {
    if (!LoginState.isLoggedIn) {
        ctx.loginPage.login("admin@test.com", "Admin@123");
        LoginState.isLoggedIn = true;
    } else {
        // Reuse cookies from previous session
        ctx.driver.manage().addCookie(savedCookie);
    }
}
```

**Warning**: This breaks parallel execution. Solution 1 is safer.

### Solution 3: Common Step in Background (Acceptable)

```gherkin
-- One-liner Background using a high-level step
Background:
  Given the user is logged in as "admin"

-- Step definition does API login + cookie injection
@Given("the user is logged in as {string}")
public void loginAs(String role) {
    cookieManager.injectSessionFor(role);  // encapsulated in utility
}
```

### Performance Comparison

| Approach | Time per scenario | 160 scenarios total |
|---|---|---|
| UI login in Background | 15-30 sec | 40-80 min |
| API login + cookie | 0.5-1 sec | 1.5-3 min |
| Shared session (serial) | 0.1 sec | 16 sec + 1 UI login |
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Login','API Login','Cookie','Performance','Scenario'],
  true, 0
),

-- S3
(
  'Your team reports that 40% of Cucumber tests are flaky — they pass sometimes and fail other times. How do you investigate and fix this?',
  'cucumber-scenario-q003-flaky-tests-cucumber',
  'Investigate flaky Cucumber tests by tagging with @flaky, enabling screenshot on every step, analyzing root causes (timing/data conflicts/parallel interference), then fixing with explicit waits, isolated test data, and API-based test setup.',
  $ans$
## Fixing 40% Flaky Cucumber Tests

### Step 1: Identify and Categorize Flaky Tests

```bash
# Run suite 3 times back-to-back, compare failing scenarios
mvn test -Denv=staging -Dcucumber.filter.tags="@regression" -Drun=1
mvn test -Denv=staging -Dcucumber.filter.tags="@regression" -Drun=2
mvn test -Denv=staging -Dcucumber.filter.tags="@regression" -Drun=3
```

Tag consistently flaky scenarios:
```gherkin
@flaky @regression @P2
Scenario: Load more products on scroll
  ...
```

### Step 2: Add Step-Level Screenshots for Diagnosis

```java
@AfterStep
public void screenshotAfterEachStep(Scenario scenario) {
    if (ctx.driver != null) {
        byte[] screenshot = ((TakesScreenshot) ctx.driver)
            .getScreenshotAs(OutputType.BYTES);
        scenario.attach(screenshot, "image/png",
            "After: " + scenario.getName());
    }
}
```

Now you can see the **exact state** at the step that fails.

### Step 3: Root Cause Categories

**Category A: Timing Issues (Most Common — 60%)**
```java
// BAD — hardcoded sleep
Thread.sleep(3000);
driver.findElement(By.id("results")).click();

// GOOD — explicit wait
new WebDriverWait(driver, Duration.ofSeconds(15))
    .until(ExpectedConditions.elementToBeClickable(By.id("results")))
    .click();
```

**Category B: Test Data Conflicts (25%)**
```java
// BAD — all tests use same email
When the user registers with email "test@example.com"
// Second parallel run fails: email already exists

// GOOD — unique data per scenario
@Before
public void generateUniqueTestData() {
    ctx.testEmail = "qa" + System.currentTimeMillis() + "@test.com";
}
```

**Category C: Parallel Execution State Leakage (10%)**
```java
// BAD — static driver shared between threads
static WebDriver driver;

// GOOD — PicoContainer gives each scenario its own driver
public class ScenarioContext { public WebDriver driver; }
```

**Category D: Environment Instability (5%)**
- Staging server slow/down
- Test DB not reset between runs
- Network latency spikes

### Step 4: Systematic Fixes

```java
// Fix 1: Replace all Thread.sleep with wait utilities
// BasePage.java
protected void waitForElementVisible(By locator) {
    new WebDriverWait(driver, Duration.ofSeconds(15))
        .until(ExpectedConditions.visibilityOfElementLocated(locator));
}

// Fix 2: API-based test data setup (no UI dependency)
@Before("@registration")
public void createUniqueUser() {
    ctx.email = "qa" + UUID.randomUUID().toString().substring(0,8) + "@test.com";
}

// Fix 3: DB cleanup after each scenario
@After("@db-writes")
public void cleanDatabase() {
    dbUtils.executeQuery(
        "DELETE FROM users WHERE email LIKE 'qa%@test.com'");
}

// Fix 4: Retry flaky scenarios
@CucumberOptions(plugin = {"rerun:target/rerun.txt"})
// + RerunTestRunner reads failed scenarios
```

### Step 5: Flaky Test Prevention Policy

```
1. Every PR must run @smoke 3 times — all must pass before merge
2. Scenario fails 2 of 5 runs → automatically tagged @flaky → moved to quarantine suite
3. Weekly flaky review session — fix or remove
4. No Thread.sleep() allowed (enforced by Checkstyle rule)
5. All test data generated uniquely (UUID/timestamp)
6. Parallel execution mandatory for all scenarios from day 1
```

### Step 6: Metrics Tracking

```
Before fixes: 60% pass rate
After Week 1 (timing fixes): 82% pass rate
After Week 2 (data isolation): 94% pass rate
After Week 3 (state leakage): 98% pass rate

Target: < 2% flakiness = acceptable for 200-scenario suite
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Flaky Tests','Debugging','Parallel','Test Data','Senior'],
  true, 0
),

-- S4
(
  'Tests pass on your local machine but consistently fail in the Jenkins CI pipeline. What do you investigate?',
  'cucumber-scenario-q004-local-pass-ci-fail',
  'Investigate differences between local and CI: headless browser behavior, missing env variables, path differences, timing issues in CI server, missing dependencies, display issues (DISPLAY env var), or CI server resource constraints.',
  $ans$
## Local Pass, CI Fail — Debugging Strategy

### Immediate Checks (First 10 Minutes)

```bash
# 1. Check Jenkins console output for actual error
tail -100 jenkins-build.log

# 2. Compare Maven commands
# Local:  mvn test -Dbrowser=chrome
# Jenkins: what exact command is Jenkins running?
#   Go to: Jenkins → Build → Console Output → find the mvn command

# 3. Check environment variables
# Jenkins → Build → Environment Variables → compare to local
```

### Root Cause 1: Non-Headless Browser (Most Common)

```
Local: Chrome opens visually (you can see it)
CI:    Jenkins runs on server with no display → Chrome crashes

Fix: Enable headless mode in CI
```

```java
// Hooks.java
@Before
public void setUp() {
    ChromeOptions options = new ChromeOptions();

    // Detect CI environment
    if (System.getenv("CI") != null || System.getenv("JENKINS_URL") != null) {
        options.addArguments(
            "--headless=new",
            "--no-sandbox",
            "--disable-dev-shm-usage",
            "--disable-gpu",
            "--window-size=1920,1080"
        );
    }
    ctx.driver = new ChromeDriver(options);
}
```

Or via Maven:
```bash
mvn test -Dheadless=true  # Jenkins always passes this flag
```

### Root Cause 2: Missing Environment Variables

```java
// Config reads from system property or env var
String baseUrl = System.getProperty("base.url",
    System.getenv("BASE_URL"));  // check env var too
```

```groovy
// Jenkinsfile — set env vars
environment {
    BASE_URL = 'https://staging.example.com'
    DB_PASSWORD = credentials('staging-db-password')
}
```

### Root Cause 3: File Path Differences

```java
// BAD — Windows absolute path hardcoded
String filePath = "C:\\Users\\dev\\testdata\\users.xlsx";

// GOOD — classpath-relative
String filePath = getClass().getClassLoader()
    .getResource("testdata/users.xlsx").getPath();
```

### Root Cause 4: Timing — CI Server Is Slower

```java
// Local: app responds in 1 second → wait of 5s is fine
// CI: shared server, slower app → 5s timeout expires

// Fix: Increase timeouts for CI
int timeout = Integer.parseInt(
    System.getProperty("wait.timeout", "15")  // 15s default, override in CI
);
this.wait = new WebDriverWait(driver, Duration.ofSeconds(timeout));
```

```bash
# Jenkins runs with longer timeout
mvn test -Dwait.timeout=30
```

### Root Cause 5: ChromeDriver Version Mismatch

```java
// Always use WebDriverManager — no version pinning needed
WebDriverManager.chromedriver().setup();
// WebDriverManager downloads the correct driver for the installed Chrome
```

### Root Cause 6: Port Already in Use (For API Tests)

```bash
# CI server has lingering processes
kill $(lsof -t -i:8080) 2>/dev/null || true
mvn test
```

### Root Cause 7: Shared CI Resources — Parallel Tests Conflict

```
5 Jenkins jobs running at the same time?
All using the same staging database?
→ One job's test data is deleted by another job

Fix: Isolated test data per build
ctx.email = "qa-build-" + System.getenv("BUILD_NUMBER") + "@test.com";
```

### Debugging Checklist

```
☐ Run with -X (debug mode): mvn test -X > debug.log
☐ Screenshot on every step in CI: @AfterStep
☐ Log browser console errors: DevTools CDP
☐ Compare env vars: Jenkins vs local
☐ Check Chrome/ChromeDriver version on CI agent
☐ Check available memory: CI agents often have less RAM
☐ Check /tmp space: screenshots can fill disk
☐ Add explicit --window-size to headless Chrome
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','CI/CD','Jenkins','Headless','Debugging','Local vs CI'],
  true, 0
),

-- S5
(
  'You need to test a registration flow where an OTP is sent to email. How do you automate this in Cucumber?',
  'cucumber-scenario-q005-otp-email-automation',
  'Use Mailosaur (disposable email API) to create a test inbox, capture the OTP from the received email via API, and inject it into the OTP field in the browser. This avoids real email and works reliably in CI pipelines.',
  $ans$
## Automating OTP/Email Verification in Cucumber

### Strategy Options

| Approach | Reliability | CI-Friendly | Speed |
|---|---|---|---|
| Mailosaur (disposable email API) | High | Yes | Fast |
| MailHog (local SMTP mock) | High | Yes | Fast |
| GreenMail (embedded mail server) | High | Yes | Fast |
| DB query for OTP | High | Yes | Fastest |
| Real email (Gmail API) | Medium | Yes (with OAuth) | Slow |

### Recommended: Mailosaur (Best for Staging)

```xml
<dependency>
    <groupId>com.mailosaur</groupId>
    <artifactId>mailosaur-java</artifactId>
    <version>7.x</version>
</dependency>
```

### Feature File

```gherkin
@regression @email-verification
Scenario: Register with email OTP verification
  Given the user is on the registration page
  When the user registers with a unique Mailosaur email
  And the OTP is received in the inbox
  And the user enters the received OTP on the verification page
  Then the user account should be activated
  And the welcome email should be received
```

### Step Definitions

```java
package stepDefinitions;

import com.mailosaur.MailosaurClient;
import com.mailosaur.models.*;

public class OtpSteps {
    private final ScenarioContext ctx;
    private static final String MAILOSAUR_API_KEY  = System.getenv("MAILOSAUR_API_KEY");
    private static final String MAILOSAUR_SERVER_ID = System.getenv("MAILOSAUR_SERVER_ID");

    public OtpSteps(ScenarioContext ctx) { this.ctx = ctx; }

    @When("the user registers with a unique Mailosaur email")
    public void registerWithMailosaurEmail() throws Exception {
        // Mailosaur generates: <anything>@<server-id>.mailosaur.net
        ctx.testEmail = "qa-" + System.currentTimeMillis()
            + "@" + MAILOSAUR_SERVER_ID + ".mailosaur.net";

        ctx.registrationPage.enterEmail(ctx.testEmail);
        ctx.registrationPage.enterPassword("Test@1234");
        ctx.registrationPage.clickRegister();
    }

    @When("the OTP is received in the inbox")
    public void waitForOtpEmail() throws Exception {
        MailosaurClient mailosaur = new MailosaurClient(MAILOSAUR_API_KEY);

        MessageSearchCriteria criteria = new MessageSearchCriteria()
            .withSentTo(ctx.testEmail)
            .withSubject("Your verification code");

        // Wait up to 30 seconds for the email to arrive
        Message email = mailosaur.messages().get(
            MAILOSAUR_SERVER_ID,
            criteria,
            new MessageSearchOptions().withTimeout(30000)
        );

        // Extract OTP from email body (e.g., "Your OTP is: 847291")
        String body = email.text().body();
        ctx.otp = body.replaceAll(".*Your OTP is: (\\d{6}).*", "$1");
        System.out.println("OTP received: " + ctx.otp);
    }

    @When("the user enters the received OTP on the verification page")
    public void enterOtp() {
        ctx.driver.findElement(By.id("otp-field")).sendKeys(ctx.otp);
        ctx.driver.findElement(By.id("verify-btn")).click();
    }
}
```

### Alternative: DB Query for OTP (When DB Access Available)

```java
@When("the OTP is received in the inbox")
public void getOtpFromDatabase() {
    // Wait for OTP to be written to DB
    String otp = null;
    for (int i = 0; i < 30; i++) {
        otp = dbUtils.query(
            "SELECT otp FROM otp_codes WHERE email = ? AND used = false ORDER BY created_at DESC LIMIT 1",
            ctx.testEmail
        );
        if (otp != null) break;
        Thread.sleep(1000);
    }
    ctx.otp = otp;
}
```

### Alternative: MailHog (Local/Dev Environment)

```bash
# Start MailHog locally or in Docker
docker run -p 1025:1025 -p 8025:8025 mailhog/mailhog
```

```java
// Query MailHog REST API
Response response = given()
    .baseUri("http://localhost:8025")
    .when()
    .get("/api/v1/messages");

String otp = response.jsonPath().getString("items[0].Content.Body")
    .replaceAll(".*OTP: (\\d{6}).*", "$1");
```

### ScenarioContext Fields Needed

```java
public class ScenarioContext {
    public WebDriver driver;
    public String testEmail;
    public String otp;
    // ...
}
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','OTP','Email','Mailosaur','Automation','2FA'],
  true, 0
),

-- S6
(
  'You are migrating a legacy Selenium TestNG framework to Cucumber BDD. What is your migration strategy?',
  'cucumber-scenario-q006-selenium-to-cucumber-migration',
  'Migrate incrementally: keep existing Page Objects, add Cucumber layer on top, convert highest-value test cases first to Gherkin, run both frameworks in parallel during transition, and decommission old TestNG tests as BDD coverage grows.',
  $ans$
## Migrating Legacy Selenium TestNG to Cucumber BDD

### Why Not Big-Bang Migration?

A full rewrite is high-risk:
- 3-6 months with no test coverage
- New bugs introduced during rewrite
- Team unfamiliar with Cucumber + old code simultaneously

**Incremental migration** maintains coverage throughout.

### Migration Phases

#### Phase 1: Setup (Week 1) — Add Cucumber Without Removing Anything

```xml
<!-- Add Cucumber to existing pom.xml — keep TestNG -->
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-java</artifactId>
    <version>7.15.0</version>
</dependency>
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-testng</artifactId>
    <version>7.15.0</version>
</dependency>
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-picocontainer</artifactId>
    <version>7.15.0</version>
</dependency>
```

**Keep all existing Page Objects** — they are reusable as-is. Cucumber step definitions call Page Object methods exactly like TestNG tests did.

#### Phase 2: Reuse Existing Page Objects in Step Definitions

```java
// EXISTING Page Object (no changes needed)
public class LoginPage {
    public LoginPage(WebDriver driver) { ... }
    public void enterUsername(String u) { ... }
    public void enterPassword(String p) { ... }
    public void clickLogin()            { ... }
}

// NEW Cucumber Step Definition — calls same Page Object
public class LoginSteps {
    private final ScenarioContext ctx;
    public LoginSteps(ScenarioContext ctx) { this.ctx = ctx; }

    @Given("the user is on the login page")
    public void navigateToLogin() {
        ctx.loginPage = new LoginPage(ctx.driver);
        ctx.driver.get(ConfigReader.getBaseUrl() + "/login");
    }

    @When("the user logs in with username {string} and password {string}")
    public void login(String user, String pass) {
        ctx.loginPage.enterUsername(user);  // same method call
        ctx.loginPage.enterPassword(pass);
        ctx.loginPage.clickLogin();
    }
}
```

#### Phase 3: Prioritize Which Tests to Convert First

```
Conversion priority:
1. Happy path / smoke tests (highest business value)
2. Tests that BAs/POs want to review (living documentation value)
3. Tests that are frequently run and change often
4. Complex data-driven tests (Scenario Outline replaces TestNG @DataProvider)

Defer migration:
5. Internal unit/integration tests (keep in TestNG)
6. Tests with complex setup that won''t benefit from Gherkin
```

#### Phase 4: Run Both Frameworks in Parallel

```xml
<!-- testng.xml — run both during transition -->
<suite name="Migration Suite" parallel="tests" thread-count="2">

    <test name="Legacy TestNG Tests">
        <classes>
            <class name="tests.legacy.LoginTest"/>
            <class name="tests.legacy.CheckoutTest"/>
        </classes>
    </test>

    <test name="New Cucumber BDD Tests">
        <classes>
            <class name="runners.CucumberSmokeRunner"/>
        </classes>
    </test>
</suite>
```

#### Phase 5: Decommission Old Tests

```
As Cucumber coverage for a feature reaches 100%:
1. Verify Cucumber tests cover all cases the old tests covered
2. Run both suites in parallel for 2 sprints — confirm same results
3. Delete old TestNG test class
4. Update testng.xml to remove deleted class
```

### Converting TestNG @DataProvider to Scenario Outline

```java
// BEFORE: TestNG
@DataProvider
public Object[][] loginData() {
    return new Object[][] {
        {"admin@test.com", "Admin@123", "Dashboard"},
        {"user@test.com",  "User@456",  "Home"}
    };
}
@Test(dataProvider = "loginData")
public void testLogin(String email, String pass, String page) { ... }

// AFTER: Cucumber
Scenario Outline: Login with <role>
  When the user logs in as "<email>" with "<password>"
  Then they should land on the "<page>" page
  Examples:
    | email          | password  | page      |
    | admin@test.com | Admin@123 | Dashboard |
    | user@test.com  | User@456  | Home      |
```

### Conversion Timeline (50 Test Classes)

```
Week 1: Framework setup + first 5 feature files (smoke)
Week 2-3: High-priority tests (20 feature files)
Week 4-5: Remaining tests (25 feature files)
Week 6: Remove old TestNG tests, final validation
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Migration','TestNG','Selenium','Strategy','Senior'],
  true, 0
),

-- S7
(
  'A Product Manager asks you to reduce the Cucumber regression suite runtime from 4 hours to under 30 minutes. How do you do it?',
  'cucumber-scenario-q007-reduce-execution-time',
  'Cut 4-hour Cucumber regression to 30 minutes using parallel execution (5-10 threads), API-based login bypass, Selenium Grid on cloud, eliminating Thread.sleep, API test data setup, and splitting into tiered suites with targeted @smoke runs.',
  $ans$
## Reducing Cucumber Regression from 4 Hours to 30 Minutes

### Current State Analysis

```
Total: 500 scenarios × 30 seconds average = 4.2 hours (serial)

Breakdown of time per scenario:
  Browser open/close:    3 sec
  UI login:             15 sec  ← biggest waste
  Test steps:           10 sec
  Waits/Thread.sleep:    2 sec
```

### Optimization 1: Parallel Execution (Biggest Win — 5x speedup)

```java
@CucumberOptions(features = "src/test/resources/features", glue = {"stepDefs","hooks"})
public class ParallelTestRunner extends AbstractTestNGCucumberTests {
    @Override
    @DataProvider(parallel = true)
    public Object[][] scenarios() { return super.scenarios(); }
}
```

```xml
<!-- testng.xml: 10 parallel threads -->
<suite name="Fast Regression" parallel="methods" thread-count="10">
    <test name="Cucumber BDD">
        <classes><class name="runners.ParallelTestRunner"/></classes>
    </test>
</suite>
```

```
Before: 500 scenarios × 30s = 4.2h
After: 500 ÷ 10 threads = 50 scenarios per thread × 30s = 25 min
```

### Optimization 2: API Login (Saves 15s × 400 scenarios = 100 min)

```java
@Before("@needs-login")
public void loginViaApi() {
    String token = apiClient.getAuthToken("admin@test.com", "Admin@123");
    ctx.driver.get(baseUrl);
    ctx.driver.manage().addCookie(new Cookie("auth_token", token));
    // 0.5 sec instead of 15 sec
}
```

```
Savings: 400 scenarios × 14.5s saved = 96.7 minutes saved
```

### Optimization 3: Headless Chrome (Saves 2-3s per scenario)

```java
options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage");
```

### Optimization 4: Eliminate Thread.sleep

```bash
# Find all sleeps in the project
grep -rn "Thread.sleep" src/test/java/

# Replace with explicit waits
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
```

```
Savings: 200 sleeps × 2s average = 6.7 minutes saved
```

### Optimization 5: API Test Data Setup (Saves 5-10s per scenario)

```java
@Before("@needs-product")
public void createProductViaApi() {
    // 0.2s via API vs 30s clicking through admin UI
    ctx.productId = apiClient.createProduct("Test Laptop", 999.00);
}
```

### Optimization 6: Suite Tiering Strategy

```
Suite 1: @smoke (15 scenarios, 3 threads) = 2 min → every commit
Suite 2: @sanity (50 scenarios, 5 threads) = 5 min → every PR
Suite 3: @regression (500 scenarios, 10 threads) = 25 min → nightly
Suite 4: @P1 (80 critical scenarios, 10 threads) = 8 min → post-deploy
```

### Optimization 7: Selenium Grid for Cloud Scale

```java
// Run 50 parallel browsers on Selenium Grid / LambdaTest / BrowserStack
ctx.driver = new RemoteWebDriver(
    new URL("https://hub.lambdatest.com/wd/hub"),
    capabilities
);
```

```
500 scenarios ÷ 50 browsers = 10 scenarios per browser × 30s = 5 min!
```

### Results After All Optimizations

```
Before: 4.2 hours (serial, UI login, Thread.sleep)
After:  22-28 minutes (10 parallel, API login, headless, no sleep)

Optimization breakdown:
  Parallel (10 threads):    4.2h → 25 min  (10x)
  API login bypass:         -97 min
  No Thread.sleep:          -7 min
  Headless browser:         -4 min
  API test data:            -8 min

Final: ~22 minutes ✓ (under 30 minute target)
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Performance','Parallel Execution','Optimization','Senior'],
  true, 0
),

-- S8
(
  'How do you implement a hybrid API + UI Cucumber test where you create a user via API and verify them in the UI?',
  'cucumber-scenario-q008-api-ui-hybrid-cucumber',
  'Hybrid API+UI Cucumber tests use API calls in @Before or When steps to set up data (faster, more reliable), then switch to Selenium WebDriver UI steps to verify the data visually. The ScenarioContext shares the created entity IDs between API and UI steps.',
  $ans$
## API + UI Hybrid Cucumber Testing

### Why Hybrid Testing?

```
API setup (0.2s) + UI verification (5s) = 5.2s per test
vs
UI setup (30s) + UI verification (5s) = 35s per test

Hybrid is 6x faster and more stable because:
- API calls don''t depend on UI rendering
- UI test focuses only on what matters: the display
- Faster feedback on UI bugs specifically
```

### Feature File

```gherkin
@regression @hybrid
Feature: User Management (Admin Portal)

  Scenario: Newly created user appears in admin user list
    Given a user is created via API with role "MANAGER"
    When the admin navigates to the user management page
    And the admin searches for the created user
    Then the user should appear with role "MANAGER"
    And the user status should show "Active"

  Scenario: Deleted user no longer appears in UI
    Given a user is created via API with role "USER"
    When the admin deletes the user via API
    And the admin refreshes the user management page
    Then the user should not appear in the list

  Scenario: Product created via API is visible in storefront
    Given a product is created via API:
      | name     | Wireless Headphones |
      | price    | 89.99               |
      | category | Electronics         |
      | status   | active              |
    When the customer navigates to the Electronics category
    And the customer searches for "Wireless Headphones"
    Then the product should appear with price "$89.99"
```

### ScenarioContext — Shared Between API and UI Steps

```java
public class ScenarioContext {
    // Shared state
    public WebDriver driver;
    public String createdUserId;
    public String createdUserEmail;
    public String createdProductId;
    public SoftAssert softAssert = new SoftAssert();
}
```

### API Step Definitions

```java
public class ApiSteps {
    private final ScenarioContext ctx;
    public ApiSteps(ScenarioContext ctx) { this.ctx = ctx; }

    @Given("a user is created via API with role {string}")
    public void createUserViaApi(String role) {
        ctx.createdUserEmail = "test-" + System.currentTimeMillis() + "@qa.com";

        Response resp = given()
            .header("Authorization", "Bearer " + getAdminToken())
            .contentType("application/json")
            .body(Map.of(
                "email", ctx.createdUserEmail,
                "role",  role,
                "name",  "QA Test User"
            ))
            .post(ConfigReader.getApiUrl() + "/admin/users");

        assertEquals(201, resp.statusCode());
        ctx.createdUserId = resp.jsonPath().getString("id");
        System.out.println("Created user: " + ctx.createdUserId);
    }

    @When("the admin deletes the user via API")
    public void deleteUserViaApi() {
        given()
            .header("Authorization", "Bearer " + getAdminToken())
            .delete(ConfigReader.getApiUrl() + "/admin/users/" + ctx.createdUserId)
            .then().statusCode(200);
    }
}
```

### UI Step Definitions

```java
public class AdminUserSteps {
    private final ScenarioContext ctx;
    public AdminUserSteps(ScenarioContext ctx) { this.ctx = ctx; }

    @When("the admin navigates to the user management page")
    public void navigateToUserManagement() {
        ctx.driver.get(ConfigReader.getBaseUrl() + "/admin/users");
    }

    @When("the admin searches for the created user")
    public void searchForCreatedUser() {
        ctx.adminPage.searchUser(ctx.createdUserEmail);  // use email from API step
    }

    @Then("the user should appear with role {string}")
    public void verifyUserRole(String expectedRole) {
        ctx.softAssert.assertEquals(
            ctx.adminPage.getUserRole(ctx.createdUserEmail),
            expectedRole, "Role mismatch");
    }

    @Then("the user should not appear in the list")
    public void verifyUserDeleted() {
        ctx.softAssert.assertFalse(
            ctx.adminPage.isUserVisible(ctx.createdUserEmail),
            "Deleted user still visible");
    }
}
```

### Cleanup Hook

```java
@After("@hybrid")
public void cleanupCreatedEntities() {
    if (ctx.createdUserId != null) {
        // API cleanup — faster than UI deletion
        given()
            .header("Authorization", "Bearer " + getAdminToken())
            .delete(ConfigReader.getApiUrl() + "/admin/users/" + ctx.createdUserId);
        ctx.createdUserId = null;
    }
}
```

### Test Execution Flow

```
@Before:         Initialize WebDriver + API client
@Given (API):    Create user via REST API (0.2s)
@When (UI):      Navigate to admin page, search user (3s)
@Then (UI):      Verify user appears correctly (1s)
@After cleanup:  Delete user via API (0.1s)

Total: ~4.5 seconds vs 35s for full UI test
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','API Testing','UI Testing','Hybrid','REST Assured','Senior'],
  true, 0
),

-- S9
(
  'Your Cucumber feature file has grown to 80 scenarios in one file. A team member wants to keep it as-is. How do you convince them to split it and how do you do it?',
  'cucumber-scenario-q009-feature-file-organization',
  'An 80-scenario feature file is a maintenance problem: slow to navigate, high merge conflict risk, no clear ownership. Split by user journey or business rule, with max 10 scenarios per file. Use consistent naming and directory structure by module.',
  $ans$
## Splitting an 80-Scenario Feature File

### Why 80 Scenarios in One File Is a Problem

Present these points to the team member:

**1. Readability**
```
login.feature with 80 scenarios:
  - Takes 5 minutes to scroll through
  - Can''t tell what''s covered without reading everything
  - New team member has to read 1000+ lines to understand login

vs 8 files × 10 scenarios:
  - File name tells you the focus: login_2fa.feature
  - Open, scan 10 scenarios, done in 30 seconds
```

**2. Merge Conflicts**
```
With 80 scenarios in one file:
  - 5 QAs working on login tests → 5 people editing same file
  - Every PR has a merge conflict in login.feature

With split files:
  - QA1 edits login_valid.feature, QA2 edits login_2fa.feature
  - Zero merge conflicts
```

**3. Execution Granularity**
```
Tag @smoke to first 5 scenarios in the file → fragile (line-number dependent)
Tag @smoke on login_happy_path.feature → robust, file-level control
```

**4. Parallel Execution Efficiency**
```
Cucumber can parallelize at feature file level
1 file × 80 scenarios = serial within the file
8 files × 10 scenarios each = 8x parallel potential
```

### How to Split

**Original monolithic file:**
```
login.feature (80 scenarios):
  Scenario 1-10:  Valid login
  Scenario 11-20: Invalid credentials
  Scenario 21-30: Password reset
  Scenario 31-40: 2FA/OTP
  Scenario 41-50: Session management
  Scenario 51-60: Remember me
  Scenario 61-70: Account lockout
  Scenario 71-80: Social login
```

**After split:**
```
features/
  login/
    login_valid_credentials.feature      (10 scenarios) @smoke @P1
    login_invalid_credentials.feature    (10 scenarios) @regression @P2
    login_password_reset.feature         (10 scenarios) @regression @P2
    login_two_factor_auth.feature        (10 scenarios) @regression @P1
    login_session_management.feature     (10 scenarios) @regression @P2
    login_remember_me.feature            (10 scenarios) @regression @P3
    login_account_lockout.feature        (10 scenarios) @regression @P2
    login_social_oauth.feature           (10 scenarios) @regression @P3
```

### Naming Convention

```
<module>_<sub-feature>_<scenario-type>.feature

login_valid_credentials.feature
login_error_messages.feature
checkout_payment_credit_card.feature
checkout_payment_paypal.feature
cart_add_remove_items.feature
cart_coupon_codes.feature
```

### Directory Structure

```
features/
  auth/
    login_valid.feature
    login_invalid.feature
    login_2fa.feature
    registration.feature
    password_reset.feature
  product/
    search.feature
    filter.feature
    product_detail.feature
  cart/
    add_to_cart.feature
    coupon.feature
    cart_persistence.feature
  checkout/
    payment_card.feature
    payment_paypal.feature
    shipping.feature
  admin/
    user_management.feature
    product_management.feature
```

### How to Split Without Disrupting CI

```bash
# Step 1: Create directory structure
mkdir -p src/test/resources/features/auth

# Step 2: Copy relevant scenarios to new files (keep original)
# Step 3: Run both original + new files - verify same results
# Step 4: Delete original file
# Step 5: Update any hardcoded references to old filename
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Feature File','Organization','Best Practice','Team','Senior'],
  true, 0
),

-- S10
(
  'How do you present Cucumber test results and automation metrics to non-technical management?',
  'cucumber-scenario-q010-reporting-to-management',
  'Present metrics in business terms: defect detection rate, release confidence score, automation coverage %, time saved vs manual testing, ROI. Use Masterthought dashboard screenshots, trend charts in Confluence, and a weekly Slack digest with pass/fail trends.',
  $ans$
## Reporting Cucumber Metrics to Management

### What Management Actually Wants to Know

Management does NOT care about:
- Which step definitions passed
- What the assertion message was
- How many Gherkin keywords were used

Management DOES care about:
- "Is the product ready to release?"
- "Are we finding bugs before production?"
- "Is automation saving us money?"
- "Are we getting better or worse?"

### Key Metrics to Track and Report

```
1. AUTOMATION COVERAGE (%)
   Automated / Total test cases × 100
   Target: > 70% of regression test cases

2. PASS RATE (%)
   Passed scenarios / Total scenarios × 100
   Target: > 95% for release

3. DEFECTS FOUND BY AUTOMATION
   Bugs caught in CI before manual QA
   Target: > 60% defects caught by automation

4. TIME SAVED (Hours/Month)
   Manual execution time - Automated execution time
   Example: 40 manual hours/month → 0.5 hours automated = 39.5h saved

5. ROI
   (Hours saved × hourly cost) / Framework investment cost × 100
   Example: (39.5h × $50) / $10,000 = 19.75% monthly ROI

6. FLAKINESS RATE (%)
   Flaky scenarios / Total × 100
   Target: < 2%

7. MEAN TIME TO DETECT (MTTD)
   How quickly automation finds a regression after deployment
   Target: < 30 minutes
```

### Weekly Slack Digest (Automated)

```java
// Jenkins post-build: send Slack summary
post {
    always {
        script {
            def passed = sh(script: "grep -o '\"passed\":[0-9]*' target/cucumber.json | awk -F: '{sum+=$2} END {print sum}'", returnStdout: true).trim()
            def failed = sh(script: "grep -o '\"failed\":[0-9]*' target/cucumber.json | awk -F: '{sum+=$2} END {print sum}'", returnStdout: true).trim()
            def total = passed.toInteger() + failed.toInteger()
            def passRate = (passed.toInteger() * 100 / total).toInteger()
        }
        slackSend channel: '#qa-metrics', color: passRate >= 95 ? 'good' : 'danger',
            message: """
*📊 Daily Automation Report — ${params.ENV}*
✅ Passed:     ${passed}/${total} (${passRate}%)
❌ Failed:     ${failed}
⏱️ Duration:  ${currentBuild.durationString}
🔗 Report: ${env.BUILD_URL}cucumber-html-reports/overview-features.html
            """
    }
}
```

### Monthly Management Dashboard (Confluence/PowerPoint)

```
Slide 1: Executive Summary
  "Automation caught 12 production-equivalent bugs this month
   before any user was affected. Time saved: 160 hours."

Slide 2: Coverage Trend Chart
  [Jan: 45%] [Feb: 58%] [Mar: 71%] [Apr: 78%] ← visual trend

Slide 3: Pass Rate (last 30 days)
  Week 1: 91%  Week 2: 94%  Week 3: 97%  Week 4: 98%
  Status: ✅ Improving trend, above 95% threshold

Slide 4: ROI Calculation
  Manual testing would cost: 160h × $50 = $8,000/month
  Automation maintenance:    10h × $50 = $500/month
  NET SAVING: $7,500/month
  Framework paid off in: Month 2

Slide 5: Top 5 Failures This Month (with root cause)
  1. Payment timeout on staging (env issue — not a bug)
  2. Search filter regression (real bug — caught before release)
  ...
```

### Release Go/No-Go Dashboard

```
GREEN  (Release now):    @smoke ≥ 100%, @regression ≥ 95%
YELLOW (Release with risk): @smoke 100%, @regression 85-94%
RED    (Do NOT release): @smoke < 100% OR @regression < 85%

Current status: 🟢 GREEN — smoke 100%, regression 97%
Release recommendation: APPROVED ✅
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Reporting','Metrics','Management','ROI','Dashboard'],
  true, 0
),

-- S11
(
  'A developer changes a UI element locator and breaks 50 Cucumber scenarios. How do you prevent this from recurring?',
  'cucumber-scenario-q011-locator-maintenance',
  'Prevent locator breakage by centralizing all locators in Page Objects (never in step definitions or feature files), using data-testid HTML attributes negotiated with developers, and running the @smoke suite in the CI PR pipeline before merge.',
  $ans$
## Preventing Locator-Based Cucumber Test Breakage

### Why 50 Tests Broke

Root cause: Locators were scattered in step definitions:

```java
// BAD — locator in step definition
@When("the user clicks the login button")
public void clickLogin() {
    driver.findElement(By.css(".btn-primary")).click();  // if this changes → 1 test breaks
}

// If the SAME locator is copy-pasted in 50 step methods:
// Developer changes class "btn-primary" → "btn-login-submit"
// → 50 tests break at once
```

### Fix 1: Single Source of Truth — Locators Only in Page Objects

```java
// LoginPage.java — ONE place for all login locators
public class LoginPage extends BasePage {

    // Define locators ONCE
    private static final By USERNAME_FIELD = By.id("username");
    private static final By PASSWORD_FIELD = By.id("password");
    private static final By LOGIN_BUTTON   = By.css("[data-testid='login-submit']");
    private static final By ERROR_MESSAGE  = By.css(".error-banner");

    public void enterUsername(String u) {
        waitForClickable(USERNAME_FIELD).clear();
        waitForClickable(USERNAME_FIELD).sendKeys(u);
    }

    public void clickLogin() {
        waitForClickable(LOGIN_BUTTON).click();
    }
}

// Step definition — ZERO locators, only page object calls
@When("the user clicks the Login button")
public void clickLogin() {
    ctx.loginPage.clickLogin();  // if locator changes → fix in ONE place
}
```

### Fix 2: data-testid Agreement with Developers

Negotiate with the dev team:
```html
<!-- Developers add stable test attributes -->
<button data-testid="login-submit">Login</button>
<input  data-testid="username-field" />
<div    data-testid="error-banner" />
```

```java
// Locator uses data-testid — never changes even if CSS class changes
private static final By LOGIN_BUTTON = By.cssSelector("[data-testid='login-submit']");
```

**Why data-testid is better:**
- CSS classes change for design reasons
- IDs get reused across pages
- `data-testid` is explicitly for testing → developers know not to rename it casually

### Fix 3: PR Checks — Run @smoke in CI Before Merge

```groovy
// Jenkinsfile (PR validation pipeline)
stage('Smoke Tests') {
    when { changeRequest() }  // runs on every PR
    steps {
        sh 'mvn test -Dcucumber.filter.tags="@smoke" -Dheadless=true'
    }
    post {
        failure {
            // PR cannot be merged if smoke fails
            error 'Smoke tests failed — locator may have broken. Fix before merge.'
        }
    }
}
```

This catches locator breaks **before** the developer''s change reaches main.

### Fix 4: Page Object Registry (Centralized Locator Map)

```java
public class LoginPageLocators {
    public static final By USERNAME     = By.id("username");
    public static final By PASSWORD     = By.id("password");
    public static final By SUBMIT       = By.cssSelector("[data-testid='login-btn']");
    public static final By ERROR        = By.cssSelector(".alert-error");
    public static final By FORGOT_PASS  = By.linkText("Forgot Password?");
}

// Page Object uses the registry
public class LoginPage extends BasePage {
    public void clickLogin() {
        waitForClickable(LoginPageLocators.SUBMIT).click();
    }
}
```

### Fix 5: Immediate Recovery Protocol

```
When 50 tests break:
1. grep for the broken locator across all Page Objects: grep -rn "btn-primary" src/
2. Fix in Page Object only — step defs unchanged
3. Re-run: mvn test -Dcucumber.filter.tags="@regression"
4. 5-minute fix instead of 2-day crisis
```

### Summary: Prevention Checklist

```
✅ Locators ONLY in Page Objects — never in step definitions
✅ data-testid attributes on all interactable elements
✅ @smoke runs on every PR via CI gating
✅ Page Object per page/component (not one huge class)
✅ Grep-check before changing any UI element attribute names
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Page Object','Locator','Maintenance','data-testid','Senior'],
  true, 0
),

-- S12
(
  'How do you test a multi-step form wizard (3 pages) in Cucumber BDD?',
  'cucumber-scenario-q012-multi-step-form-wizard',
  'Test a multi-step wizard with one Scenario per page-level validation and one full end-to-end Scenario for the happy path. Use a shared ScenarioContext to pass data between steps, and use Background to navigate to the wizard start.',
  $ans$
## Testing Multi-Step Form Wizard in Cucumber

### Example: 3-Page Registration Wizard

```
Page 1: Personal Details (name, email, phone)
Page 2: Account Setup (username, password, security question)
Page 3: Preferences (notifications, theme, language)
→ Submit → Account Created
```

### Feature File Design

```gherkin
@regression @registration
Feature: Multi-Step Registration Wizard

  Background:
    Given the user navigates to the registration wizard

  @smoke @P1
  Scenario: Complete wizard with all valid data (happy path)
    When the user fills in personal details:
      | firstName | John              |
      | lastName  | Doe               |
      | email     | john@example.com  |
      | phone     | 9876543210        |
    And the user clicks Next on page 1
    And the user fills in account setup:
      | username          | johndoe123        |
      | password          | Test@1234         |
      | confirmPassword   | Test@1234         |
      | securityQuestion  | What is your pet? |
      | securityAnswer    | Fluffy            |
    And the user clicks Next on page 2
    And the user sets preferences:
      | emailNotifications | enabled  |
      | theme              | dark     |
      | language           | English  |
    And the user clicks Submit
    Then the account should be created successfully
    And the welcome email should be sent to "john@example.com"

  @regression @P2
  Scenario: Page 1 validation — missing required fields
    When the user clicks Next on page 1 without filling any fields
    Then the validation errors should appear:
      | First Name is required |
      | Email is required      |
      | Phone is required      |
    And the user should remain on page 1

  @regression @P2
  Scenario: Page 1 validation — invalid email format
    When the user fills in personal details:
      | firstName | John           |
      | lastName  | Doe            |
      | email     | not-an-email   |
      | phone     | 9876543210     |
    And the user clicks Next on page 1
    Then the error "Please enter a valid email address" should appear

  @regression @P2
  Scenario: Password mismatch on page 2
    Given the user has completed page 1 successfully
    When the user fills in account setup:
      | username          | johndoe123   |
      | password          | Test@1234    |
      | confirmPassword   | Different@99 |
    And the user clicks Next on page 2
    Then the error "Passwords do not match" should appear

  @regression @P3
  Scenario: Navigate back from page 2 to page 1 — data preserved
    Given the user has completed page 1 successfully
    When the user fills in partial account setup
    And the user clicks Back on page 2
    Then page 1 should show the previously entered personal details
```

### Page Objects

```java
// WizardPage1.java
public class WizardPage1 extends BasePage {
    public void fillDetails(Map<String, String> data) {
        waitForClickable(By.id("firstName")).sendKeys(data.get("firstName"));
        waitForClickable(By.id("email")).sendKeys(data.get("email"));
        waitForClickable(By.id("phone")).sendKeys(data.get("phone"));
    }
    public void clickNext() { waitForClickable(By.id("next-btn")).click(); }
    public List<String> getValidationErrors() {
        return driver.findElements(By.css(".field-error"))
            .stream().map(WebElement::getText).collect(Collectors.toList());
    }
    public boolean isOnPage1() {
        return waitForVisible(By.css("[data-step='1']")).isDisplayed();
    }
}
```

### Step Definitions

```java
public class WizardSteps {
    private final ScenarioContext ctx;

    @When("the user fills in personal details:")
    public void fillPersonalDetails(DataTable data) {
        ctx.page1Data = data.asMap(String.class, String.class);
        ctx.wizardPage1.fillDetails(ctx.page1Data);
    }

    @When("the user clicks Next on page {int}")
    public void clickNext(int pageNum) {
        if (pageNum == 1) ctx.wizardPage1.clickNext();
        if (pageNum == 2) ctx.wizardPage2.clickNext();
    }

    @Then("the account should be created successfully")
    public void verifyAccountCreated() {
        waitForVisible(By.css(".success-banner"));
        ctx.softAssert.assertTrue(
            ctx.driver.getCurrentUrl().contains("/account/welcome"),
            "Not redirected to welcome page");
    }

    @Then("the validation errors should appear:")
    public void verifyErrors(List<String> expectedErrors) {
        List<String> actual = ctx.wizardPage1.getValidationErrors();
        for (String expected : expectedErrors) {
            ctx.softAssert.assertTrue(
                actual.contains(expected),
                "Missing error: " + expected);
        }
    }
}
```

### ScenarioContext Additions

```java
public class ScenarioContext {
    public WebDriver driver;
    public SoftAssert softAssert = new SoftAssert();
    public WizardPage1 wizardPage1;
    public WizardPage2 wizardPage2;
    public WizardPage3 wizardPage3;
    public Map<String, String> page1Data;  // preserve between wizard steps
    public String registeredEmail;
}
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Form Wizard','Multi Step','DataTable','Page Object','Scenario'],
  true, 0
),

-- S13
(
  'How do you maintain a growing Cucumber suite of 1000+ scenarios to prevent test rot?',
  'cucumber-scenario-q013-large-suite-maintenance',
  'Maintain 1000+ Cucumber scenarios with quarterly audits, flakiness tracking (auto-quarantine @flaky), step definition linting (CheckStyle), Page Object reviews, scenario naming conventions, and a dedicated 20% sprint capacity for test maintenance.',
  $ans$
## Maintaining 1000+ Cucumber Scenarios

### The Problem: Test Rot

Test rot happens when:
- Old scenarios test removed features
- Step definitions drift from actual UI
- Duplicate scenarios cover the same case
- @wip scenarios accumulate and never get finished
- No one knows which tests are worth keeping

### Strategy 1: Quarterly Test Audit

```bash
# Find scenarios not tagged with a required tag (no owner)
grep -rn "Scenario:" src/test/resources/features/ | wc -l

# Find scenarios missing required tags
grep -rL "@P1\|@P2\|@P3" src/test/resources/features/**/*.feature

# Find @wip scenarios older than 30 days (Git blame)
git log --follow -p src/test/resources/features/checkout/payment.feature \
  | grep "@wip"
```

**Quarterly review checklist:**
```
For each feature file:
☐ Does this feature still exist in production?
☐ Are all scenarios still relevant?
☐ Are any scenarios duplicates?
☐ Do all @wip scenarios have a JIRA ticket?
☐ Have @flaky scenarios been fixed or removed?
```

### Strategy 2: Automatic Flakiness Tracking

```java
// Track scenario flakiness in a results database
@After
public void trackResults(Scenario scenario) {
    dbUtils.insertResult(
        scenario.getName(),
        scenario.getStatus().toString(),
        LocalDateTime.now(),
        System.getenv("BUILD_NUMBER")
    );
}
```

```sql
-- Find scenarios that failed > 20% of runs in last 30 days
SELECT scenario_name,
       COUNT(*) total_runs,
       SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) failures,
       ROUND(SUM(CASE WHEN status = 'FAILED' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) flakiness_pct
FROM cucumber_results
WHERE run_date > NOW() - INTERVAL 30 DAY
GROUP BY scenario_name
HAVING flakiness_pct > 20
ORDER BY flakiness_pct DESC;
```

Auto-tag scenarios with > 20% flakiness as `@flaky` and move to quarantine suite.

### Strategy 3: Step Definition Governance

```
Rules enforced via CheckStyle + Code Review:

1. No Thread.sleep() in step definitions
   → CheckStyle rule: IllegalMethodCallCheck

2. No WebDriver calls in step definitions
   → All locator code must be in Page Objects

3. Step definitions max 5 lines
   → Anything longer = extract to Page Object method

4. One step definition file per feature domain
   → LoginSteps.java, not AllSteps.java
```

### Strategy 4: Scenario Naming Convention

```gherkin
-- Good naming — searchable, self-documenting
Scenario: Login - valid credentials - admin user
Scenario: Login - invalid password - standard user
Scenario: Checkout - payment - credit card - success
Scenario: Checkout - payment - credit card - expired
Scenario: Checkout - coupon - valid 10% discount - applied

-- Bad naming — vague, unsearchable
Scenario: Test login
Scenario: Verify payment
Scenario: Check coupon
```

### Strategy 5: Ownership via Tags

```gherkin
@owner-payments-team @regression @P1
Scenario: Credit card payment processes correctly
```

When a scenario fails:
```bash
# Find owner of failing scenario
grep -r "@owner-" failing_scenario.feature
# → @owner-payments-team → alert payments team Slack channel
```

### Strategy 6: Sprint Allocation for Maintenance

```
20% of every sprint = test maintenance:
  Week 1: Fix @flaky scenarios (top 10 by flakiness rate)
  Week 2: Remove obsolete scenarios for deprecated features
  Week 3: Update step definitions for UI changes
  Week 4: Add missing coverage for new features
```

### Strategy 7: Feature File "Last Updated" Header

```gherkin
# Feature: User Login
# Last reviewed: 2024-Q4 by QA Team
# Owner: @auth-team
# Linked story: PROJ-1234

Feature: User Login
  ...
```

### KPIs for Healthy Suite

```
Target metrics for 1000+ scenarios:
  Flakiness rate:      < 2%   (< 20 flaky scenarios)
  Execution time:      < 30m  (parallel, not serial)
  Coverage gap:        < 10%  (known uncovered flows)
  @wip backlog:        < 15   (open WIP scenarios)
  Step def reuse rate: > 60%  (shared steps, not duplicates)
  Build green rate:    > 97%  (36 days of 37 pass)
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','Maintenance','Scale','Test Rot','Best Practice','Senior'],
  true, 0
),

-- S14
(
  'How do you handle a scenario where the application shows a cookie consent popup that blocks automation?',
  'cucumber-scenario-q014-cookie-consent-popup',
  'Handle cookie consent popups with a @Before hook that checks for and dismisses the banner before each scenario. Use JavaScript click as fallback, or configure browser to auto-accept cookies via ChromeOptions preferences.',
  $ans$
## Handling Cookie Consent Popups in Cucumber

### The Problem

```gherkin
Scenario: User searches for product
  Given the user navigates to the home page   ← cookie banner appears here
  When the user types "laptop" in search      ← FAILS: banner blocks the search box
  Then results should show
```

### Solution 1: @Before Hook — Dismiss Banner Before Every Scenario

```java
package hooks;

import io.cucumber.java.Before;
import context.ScenarioContext;
import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.*;
import java.time.Duration;

public class CookieConsentHook {

    private final ScenarioContext ctx;

    public CookieConsentHook(ScenarioContext ctx) { this.ctx = ctx; }

    @Before(order = 50)  // runs after driver init, before test steps
    public void dismissCookieConsent() {
        try {
            WebDriverWait wait = new WebDriverWait(ctx.driver, Duration.ofSeconds(5));

            // Try common cookie consent button selectors
            String[] consentSelectors = {
                "[data-testid='cookie-accept']",
                "#cookie-consent-accept",
                ".cookie-banner button.accept",
                "button[id*='accept']",
                "button[class*='accept-cookie']",
                "//button[contains(text(), 'Accept All')]",
                "//button[contains(text(), 'Accept Cookies')]"
            };

            for (String selector : consentSelectors) {
                try {
                    WebElement btn = selector.startsWith("//")
                        ? wait.until(ExpectedConditions.elementToBeClickable(By.xpath(selector)))
                        : wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(selector)));
                    btn.click();
                    System.out.println("Cookie consent dismissed via: " + selector);
                    return;  // dismissed successfully
                } catch (TimeoutException | NoSuchElementException e) {
                    // try next selector
                }
            }

            System.out.println("No cookie consent banner found — proceeding");

        } catch (Exception e) {
            System.out.println("Cookie consent hook skipped: " + e.getMessage());
            // Never let this hook fail the actual test
        }
    }
}
```

### Solution 2: JavaScript Click (When Normal Click Fails)

```java
@Before(order = 50)
public void dismissCookieBannerViaJS() {
    try {
        WebElement acceptBtn = ctx.driver.findElement(
            By.cssSelector("[data-testid='cookie-accept']"));

        if (acceptBtn.isDisplayed()) {
            ((JavascriptExecutor) ctx.driver).executeScript(
                "arguments[0].click();", acceptBtn);
        }
    } catch (NoSuchElementException e) {
        // No banner — normal scenario, do nothing
    }
}
```

### Solution 3: ChromeOptions — Set Cookie at Browser Level

```java
// Inject cookie before page load — browser never shows consent banner
@Before(order = 40)  // before navigation
public void setConsentCookie() {
    ctx.driver.get(ConfigReader.getBaseUrl());  // navigate first to set domain

    ctx.driver.manage().addCookie(new Cookie(
        "cookieConsent",    // cookie name used by the app
        "accepted",         // accepted value
        ".example.com",     // domain
        "/",                // path
        null,               // no expiry → session cookie
        false,              // not secure (adjust per site)
        true                // httpOnly
    ));

    ctx.driver.navigate().refresh();  // reload with cookie set → no banner
}
```

### Solution 4: Disable Consent Banner in Test Environment

Negotiate with developers to add a URL param or env flag:

```java
// Ask dev team to skip consent banner for test users
ctx.driver.get(ConfigReader.getBaseUrl() + "?disable_consent=true");

// Or configure via config property
ctx.driver.get(ConfigReader.getBaseUrl() + ConfigReader.get("consent.bypass.param"));
```

### Solution 5: CookieUtils Reusable Helper

```java
public class CookieUtils {

    public static void dismissConsentBanner(WebDriver driver) {
        String[] selectors = {
            "[data-testid='cookie-accept']",
            "#onetrust-accept-btn-handler",   // OneTrust (common CMP)
            ".cc-btn.cc-allow",               // Cookie Consent.js
            "#CybotCookiebotDialogBodyButtonAccept"  // Cookiebot
        };

        for (String sel : selectors) {
            try {
                WebElement el = new WebDriverWait(driver, Duration.ofSeconds(3))
                    .until(ExpectedConditions.elementToBeClickable(By.cssSelector(sel)));
                el.click();
                return;
            } catch (Exception ignored) {}
        }
    }
}
```

### Feature File — No Mention of Cookies

The feature file stays clean — cookie handling is purely in the hook:

```gherkin
-- No "And the user accepts cookies" step needed
Scenario: Search for product
  Given the user navigates to the home page
  When the user types "laptop" in the search box
  Then the search results should appear
```

The `@Before` hook handles consent automatically before the `Given` step runs.
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Intermediate',
  ARRAY['Cucumber','BDD','Cookie Consent','Popup','Hooks','JavaScript','ChromeOptions'],
  true, 0
),

-- S15
(
  'You have a Cucumber BDD suite that needs to run against both a web browser and a REST API for the same business flow. How do you structure this?',
  'cucumber-scenario-q015-dual-channel-bdd',
  'Use a driver-agnostic step definition layer where a "channel" property switches the execution layer — Selenium WebDriver for UI channel, REST Assured for API channel. The same Gherkin feature file runs both, validating consistency between API and UI behavior.',
  $ans$
## Dual-Channel BDD: Web UI + REST API from Same Feature File

### The Business Need

```
Same business rule verified two ways:
  "A user with ADMIN role can access the user management module"

  Channel 1 (UI):  Navigate to /admin/users → page loads
  Channel 2 (API): GET /api/admin/users with ADMIN token → 200 OK
  Channel 3 (API): GET /api/admin/users with USER token → 403 Forbidden

Running both channels from same Gherkin = consistency testing
```

### Feature File — Channel-Tagged

```gherkin
@regression
Feature: Role-Based Access Control

  @smoke @ui-channel
  Scenario: Admin can access user management via UI
    Given I am authenticated as role "ADMIN"
    When I navigate to the user management section
    Then I should have full access to the section

  @smoke @api-channel
  Scenario: Admin can access user management via API
    Given I am authenticated as role "ADMIN"
    When I request access to "user-management" via API
    Then the API should respond with status 200
    And the response should contain a list of users

  @regression @api-channel
  Scenario: Standard user cannot access admin APIs
    Given I am authenticated as role "USER"
    When I request access to "user-management" via API
    Then the API should respond with status 403
    And the response error should say "Access Denied"
```

### Execution Context — Strategy Pattern

```java
// Channel interface
public interface ExecutionChannel {
    void navigateTo(String section);
    int checkAccess(String section);
    String getResponseBody();
}

// UI Channel Implementation
public class UIChannel implements ExecutionChannel {
    private final WebDriver driver;
    public UIChannel(WebDriver driver) { this.driver = driver; }

    @Override
    public void navigateTo(String section) {
        Map<String, String> urls = Map.of(
            "user-management", "/admin/users",
            "product-management", "/admin/products"
        );
        driver.get(ConfigReader.getBaseUrl() + urls.get(section));
    }

    @Override
    public int checkAccess(String section) {
        try {
            navigateTo(section);
            return new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(d -> d.findElement(By.css("[data-page='" + section + "']")))
                != null ? 200 : 403;
        } catch (Exception e) { return 403; }
    }
}

// API Channel Implementation
public class APIChannel implements ExecutionChannel {
    private Response lastResponse;
    private String authToken;

    public void setToken(String token) { this.authToken = token; }

    @Override
    public void navigateTo(String section) {
        // No-op for API channel — navigation = API call
    }

    @Override
    public int checkAccess(String section) {
        Map<String, String> endpoints = Map.of(
            "user-management", "/api/admin/users",
            "product-management", "/api/admin/products"
        );
        lastResponse = given()
            .header("Authorization", "Bearer " + authToken)
            .get(ConfigReader.getApiUrl() + endpoints.get(section));
        return lastResponse.statusCode();
    }

    @Override
    public String getResponseBody() {
        return lastResponse.getBody().asString();
    }
}
```

### ScenarioContext — Channel Aware

```java
public class ScenarioContext {
    public WebDriver driver;
    public ExecutionChannel channel;
    public String authToken;
    public int lastStatusCode;
    public SoftAssert softAssert = new SoftAssert();
}
```

### Shared Step Definitions — Channel Agnostic

```java
public class AccessControlSteps {
    private final ScenarioContext ctx;

    @Before("@ui-channel")
    public void initUIChannel() {
        ctx.driver = DriverFactory.createDriver("chrome", true);
        ctx.channel = new UIChannel(ctx.driver);
    }

    @Before("@api-channel")
    public void initAPIChannel() {
        ctx.channel = new APIChannel();
    }

    @Given("I am authenticated as role {string}")
    public void authenticateAs(String role) {
        ctx.authToken = ApiAuth.getTokenForRole(role);
        if (ctx.channel instanceof APIChannel) {
            ((APIChannel) ctx.channel).setToken(ctx.authToken);
        } else {
            // UI: inject session cookie
            ctx.driver.get(ConfigReader.getBaseUrl());
            ctx.driver.manage().addCookie(
                new Cookie("auth_token", ctx.authToken));
        }
    }

    @When("I request access to {string} via API")
    public void requestViaApi(String section) {
        ctx.lastStatusCode = ctx.channel.checkAccess(section);
    }

    @Then("the API should respond with status {int}")
    public void verifyStatus(int expected) {
        ctx.softAssert.assertEquals(ctx.lastStatusCode, expected,
            "Wrong status code for section access");
    }

    @Then("I should have full access to the section")
    public void verifyUIAccess() {
        ctx.softAssert.assertFalse(
            ctx.driver.getPageSource().contains("403") ||
            ctx.driver.getPageSource().contains("Access Denied"),
            "User does not have UI access");
    }
}
```

### Benefits of This Approach

```
1. Single Gherkin source of truth for both channels
2. API tests verify backend behavior
3. UI tests verify what users actually see
4. Inconsistency detected: API returns 200 but UI shows error → real bug
5. API tests run 10x faster → quick smoke before UI suite
6. Feature parity: any API endpoint that works must also work in UI
```
$ans$,
  'Cucumber', 'Scenario-Based', 'Senior', 'Advanced',
  ARRAY['Cucumber','BDD','API Testing','UI Testing','Strategy Pattern','Dual Channel','Senior'],
  true, 0
);
