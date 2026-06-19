-- TestNG Advanced Questions (Senior Level — Gaps from existing coverage)
-- technology = 'TestNG', Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- TestNG Advanced Q1
(
  'What is the @Factory annotation in TestNG and when do you use it?',
  'testng-advanced-q1-factory-annotation',
  '@Factory dynamically creates multiple instances of a test class with different constructor parameters — ideal for running the same tests with different users, environments, or data sets.',
  $ans$
## @Factory Annotation in TestNG

`@Factory` creates multiple instances of a test class at runtime. Unlike `@DataProvider` (which runs one method multiple times), `@Factory` runs **the entire test class** multiple times with different configurations.

### Basic Example

```java
// Test class with constructor parameter
public class LoginTest {
    private String username;
    private String password;
    private String expectedTitle;

    public LoginTest(String username, String password, String expectedTitle) {
        this.username = username;
        this.password = password;
        this.expectedTitle = expectedTitle;
    }

    @Test
    public void loginTest() {
        driver.findElement(By.id("username")).sendKeys(username);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("loginBtn")).click();
        Assert.assertTrue(driver.getTitle().contains(expectedTitle));
    }

    @Test
    public void verifyProfileTest() {
        // Also uses this.username for profile verification
        driver.findElement(By.cssSelector(".profile-name"));
        Assert.assertTrue(/* profile visible */);
    }
}
```

### Factory Class

```java
public class LoginTestFactory {

    @Factory
    public Object[] createInstances() {
        return new Object[] {
            new LoginTest("admin",    "admin123",  "Dashboard"),
            new LoginTest("manager",  "mgr456",    "Reports"),
            new LoginTest("readonly", "read789",   "View Only"),
        };
    }
}
```

### testng.xml — Point to Factory, Not Test Class

```xml
<suite name="MultiUserSuite">
    <test name="Login As Different Users">
        <classes>
            <class name="factory.LoginTestFactory"/>
            <!-- NOT LoginTest — factory creates those instances -->
        </classes>
    </test>
</suite>
```

**Result:** TestNG runs ALL `@Test` methods in `LoginTest` for EACH of the 3 users — 6 total test runs.

### @Factory with @DataProvider

```java
public class BrowserFactory {

    @Factory(dataProvider = "browsers")
    public Object[] createBrowserInstances(String browser) {
        return new Object[] { new CrossBrowserTest(browser) };
    }

    @DataProvider(name = "browsers")
    public Object[][] browsers() {
        return new Object[][] {
            {"chrome"}, {"firefox"}, {"edge"}
        };
    }
}
```

### @Factory vs @DataProvider

| Aspect | @DataProvider | @Factory |
|---|---|---|
| Scope | Single `@Test` method | Entire test class |
| Object creation | One instance, N calls | N instances of class |
| Setup/Teardown | Shared `@Before/@After` | Separate per instance |
| Use case | Same test, different data | Same suite, different config |
| Example | Same login test with 10 users | Entire LoginTest suite for each browser |
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','@Factory','Parallel','Data Provider','Cross Browser','Test Instance','Framework'],
  true, 0
),

-- TestNG Advanced Q2
(
  'What is IRetryAnalyzer in TestNG and how do you implement it?',
  'testng-advanced-q2-iretryanalyzer-retry-failed-tests',
  'IRetryAnalyzer is a TestNG interface that automatically retries failed tests a configurable number of times before marking them as failed.',
  $ans$
## IRetryAnalyzer in TestNG

`IRetryAnalyzer` tells TestNG to re-run a failed test automatically before recording it as failed. Essential for handling flaky tests in CI pipelines.

### Step 1 — Implement IRetryAnalyzer

```java
import org.testng.IRetryAnalyzer;
import org.testng.ITestResult;

public class RetryAnalyzer implements IRetryAnalyzer {
    private int retryCount = 0;
    private static final int MAX_RETRY = 2; // retry up to 2 times (3 total attempts)

    @Override
    public boolean retry(ITestResult result) {
        if (retryCount < MAX_RETRY) {
            System.out.println("Retrying test: " + result.getName()
                + " | Attempt: " + (retryCount + 1));
            retryCount++;
            return true;  // retry
        }
        return false; // stop retrying
    }
}
```

### Step 2 — Apply to a Single Test

```java
@Test(retryAnalyzer = RetryAnalyzer.class)
public void flakeyLoginTest() {
    // If this fails, TestNG retries up to 2 more times
    Assert.assertTrue(driver.getTitle().contains("Dashboard"));
}
```

### Step 3 — Apply to ALL Tests via Listener

```java
import org.testng.IAnnotationTransformer;
import org.testng.annotations.ITestAnnotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

public class RetryListener implements IAnnotationTransformer {

    @Override
    public void transform(ITestAnnotation annotation, Class testClass,
                          Constructor testConstructor, Method testMethod) {
        // Apply RetryAnalyzer to every @Test method automatically
        annotation.setRetryAnalyzer(RetryAnalyzer.class);
    }
}
```

**testng.xml:**
```xml
<suite name="Suite">
    <listeners>
        <listener class-name="listeners.RetryListener"/>
    </listeners>
    <test name="Tests">
        <classes>
            <class name="tests.LoginTest"/>
        </classes>
    </test>
</suite>
```

### Clean Up: Skip Retried Tests in Report

By default, TestNG marks retried attempts as SKIP in reports, cluttering the output. Fix:

```java
public class RetryReportListener implements ITestListener {

    @Override
    public void onTestSkipped(ITestResult result) {
        // If skip was caused by retry, remove from skipped count
        if (result.getMethod().getRetryAnalyzerClass() != null) {
            Reporter.log(result.getName() + " was retried, not truly skipped");
            // Can also programmatically remove from reporter
        }
    }
}
```

### How Retry Works

```
Test FAILS on attempt 1  → retry() returns true  → attempt 2
Test FAILS on attempt 2  → retry() returns true  → attempt 3
Test FAILS on attempt 3  → retry() returns false → FAIL recorded
OR
Test PASSES on attempt 2 → no more retries       → PASS recorded
```

### When to Use (and When NOT To)
- ✓ Flaky network-dependent tests in CI
- ✓ Tests with timing sensitivity
- ✗ Do NOT use to hide real bugs — fix root cause instead
- ✗ Do NOT use for all tests — only truly flaky ones
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','IRetryAnalyzer','Retry','Flaky Tests','IAnnotationTransformer','Listener','CI/CD'],
  true, 0
),

-- TestNG Advanced Q3
(
  'What is ITestContext in TestNG and how do you use it?',
  'testng-advanced-q3-itestcontext-share-data-between-tests',
  'ITestContext represents a TestNG test run context — use it to share data between test methods, access suite/test attributes, and read configuration from testng.xml.',
  $ans$
## ITestContext in TestNG

`ITestContext` gives access to the current test run context — including attributes, parameters, included/excluded groups, and test results. It is the primary mechanism for **sharing data between tests** without static variables.

### Access ITestContext in @Before/@After Methods

```java
@BeforeClass
public void setUp(ITestContext context) {
    // Set shared attributes accessible by any test in this class
    context.setAttribute("baseUrl", "https://staging.automateqa.online");
    context.setAttribute("authToken", login());
}

@Test
public void apiTest(ITestContext context) {
    String baseUrl = (String) context.getAttribute("baseUrl");
    String token   = (String) context.getAttribute("authToken");
    // Use shared data without static variables
}
```

### Read testng.xml Parameters

```java
@BeforeClass
public void configure(ITestContext context) {
    // Access <parameter name="env" value="staging"/> from testng.xml
    String env = context.getCurrentXmlTest().getParameter("env");
    System.out.println("Running on: " + env);
}
```

### Access Test Results During Execution

```java
@AfterClass
public void printResults(ITestContext context) {
    System.out.println("Passed:  " + context.getPassedTests().size());
    System.out.println("Failed:  " + context.getFailedTests().size());
    System.out.println("Skipped: " + context.getSkippedTests().size());

    // Get all failed test names
    context.getFailedTests().getAllResults().forEach(result ->
        System.out.println("Failed: " + result.getName())
    );
}
```

### Share Driver Between Tests (Not Recommended but Common Pattern)

```java
@BeforeClass
public void setUp(ITestContext context) {
    WebDriver driver = new ChromeDriver();
    context.setAttribute("driver", driver); // share across methods
}

@Test
public void test1(ITestContext context) {
    WebDriver driver = (WebDriver) context.getAttribute("driver");
    driver.get("https://example.com");
}

@AfterClass
public void tearDown(ITestContext context) {
    ((WebDriver) context.getAttribute("driver")).quit();
}
```

### ITestContext in Listeners

```java
public class CustomListener implements ITestListener {

    @Override
    public void onStart(ITestContext context) {
        System.out.println("Suite: " + context.getSuite().getName());
        System.out.println("Test:  " + context.getName());
        System.out.println("Groups: " + Arrays.toString(context.getIncludedGroups()));
    }

    @Override
    public void onFinish(ITestContext context) {
        int total = context.getPassedTests().size()
                  + context.getFailedTests().size()
                  + context.getSkippedTests().size();
        System.out.println("Execution complete. Total: " + total);
    }
}
```

### ITestContext vs ITestResult

| Interface | Scope | Use For |
|---|---|---|
| `ITestContext` | Entire test (`<test>` tag in XML) | Shared data, suite-level info, results summary |
| `ITestResult` | Single test method | Pass/fail status, exceptions, method name |
| `ISuite` | Entire suite | Suite-level attributes, all tests |
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','ITestContext','Shared Data','Listener','Context','testng.xml','Test Results'],
  true, 0
),

-- TestNG Advanced Q4
(
  'What is the difference between parallel modes in TestNG: methods, tests, classes, and instances?',
  'testng-advanced-q4-parallel-modes-methods-tests-classes-instances',
  'TestNG parallel attribute controls the unit of parallel execution: methods run individual @Test in parallel, tests run <test> blocks, classes run entire test classes, and instances create parallel class instances.',
  $ans$
## TestNG Parallel Execution Modes

The `parallel` attribute in `testng.xml` determines WHAT runs in parallel.

### 1. parallel="methods" — Most Granular

Each `@Test` method runs in its own thread. All `@Test` methods across all classes run simultaneously.

```xml
<suite name="Suite" parallel="methods" thread-count="5">
    <test name="Tests">
        <classes>
            <class name="tests.LoginTest"/>
            <class name="tests.CartTest"/>
        </classes>
    </test>
</suite>
```

- Thread 1: `LoginTest.validLogin()`
- Thread 2: `LoginTest.invalidLogin()`
- Thread 3: `CartTest.addItem()`
- Thread 4: `CartTest.removeItem()`
- Thread 5: etc.

**Requirement:** Each test method must be completely independent. Use `ThreadLocal<WebDriver>`.

### 2. parallel="tests" — Most Common for Cross-Browser

Each `<test>` block in `testng.xml` runs in its own thread. Ideal for cross-browser testing.

```xml
<suite name="CrossBrowserSuite" parallel="tests" thread-count="3">

    <test name="ChromeTests">
        <parameter name="browser" value="chrome"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>

    <test name="FirefoxTests">
        <parameter name="browser" value="firefox"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>

    <test name="EdgeTests">
        <parameter name="browser" value="edge"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>
</suite>
```

All 3 `<test>` blocks run simultaneously — Chrome, Firefox, Edge in parallel.

### 3. parallel="classes" — Class Level

Each test class gets its own thread. All methods within a class run sequentially.

```xml
<suite name="Suite" parallel="classes" thread-count="3">
    <test name="Tests">
        <classes>
            <class name="tests.LoginTest"/>    <!-- Thread 1: all LoginTest methods -->
            <class name="tests.CartTest"/>     <!-- Thread 2: all CartTest methods -->
            <class name="tests.CheckoutTest"/> <!-- Thread 3: all CheckoutTest methods -->
        </classes>
    </test>
</suite>
```

**Use when:** Test methods within a class share state (same login session) but classes are independent.

### 4. parallel="instances" — Instance Level

Each instance of a class runs in its own thread. Used with `@Factory`:

```xml
<suite name="Suite" parallel="instances" thread-count="3">
    <test name="Tests">
        <classes>
            <class name="factory.LoginTestFactory"/>
        </classes>
    </test>
</suite>
```

**Use when:** `@Factory` creates multiple class instances that should run concurrently.

### Comparison Table

| Mode | Unit of Parallelism | Within-Class Methods | Best For |
|---|---|---|---|
| `methods` | Each `@Test` method | Parallel | Independent unit tests |
| `tests` | Each `<test>` block | Sequential | Cross-browser (different configs) |
| `classes` | Each test class | Sequential | Classes sharing a session |
| `instances` | Each class instance | Sequential | `@Factory`-created instances |

### thread-count Setting

```xml
<!-- Max threads in pool — set to (available CPUs × 2) or Grid node count -->
<suite parallel="tests" thread-count="4">
```

### Critical: Always Use ThreadLocal for parallel="methods" or "instances"

```java
// Without ThreadLocal, threads share and overwrite the driver
private static ThreadLocal<WebDriver> driver = new ThreadLocal<>();
```
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','Parallel Execution','thread-count','Cross Browser','ThreadLocal','testng.xml','@Factory'],
  true, 0
),

-- TestNG Advanced Q5
(
  'What is dependsOnGroups in TestNG and how does it differ from dependsOnMethods?',
  'testng-advanced-q5-dependsongroups-vs-dependsonmethods',
  'dependsOnGroups creates dependencies between test groups (smoke, regression) rather than specific methods — more maintainable than dependsOnMethods for large test suites.',
  $ans$
## dependsOnGroups vs dependsOnMethods in TestNG

Both create execution order dependencies, but at different granularity levels.

### dependsOnMethods — Method-Level Dependency

```java
@Test
public void openBrowser() {
    driver = new ChromeDriver();
    driver.get("https://automateqa.online");
}

@Test(dependsOnMethods = "openBrowser")
public void login() {
    // Runs only after openBrowser passes
    driver.findElement(By.id("username")).sendKeys("admin");
}

@Test(dependsOnMethods = {"openBrowser", "login"})
public void verifyDashboard() {
    // Runs only after BOTH openBrowser AND login pass
    Assert.assertTrue(driver.getTitle().contains("Dashboard"));
}
```

**Problem:** Hard to maintain in large suites — renaming one method breaks all dependsOnMethods references.

### dependsOnGroups — Group-Level Dependency

```java
@Test(groups = "setup")
public void openBrowser() { ... }

@Test(groups = "setup")
public void navigateToHome() { ... }

// Login depends on the entire "setup" GROUP
@Test(groups = "login", dependsOnGroups = "setup")
public void login() {
    // Runs after ALL "setup" tests pass
}

// Checkout depends on login GROUP
@Test(groups = "checkout", dependsOnGroups = "login")
public void addToCart() { ... }

@Test(groups = "checkout", dependsOnGroups = "login")
public void proceedToPayment() { ... }
```

### testng.xml — Include/Exclude Groups

```xml
<suite name="Suite">
    <test name="E2ETest">
        <groups>
            <run>
                <include name="setup"/>
                <include name="login"/>
                <include name="checkout"/>
                <!-- exclude name="wip"/ -->
            </run>
        </groups>
        <classes>
            <class name="tests.E2ETest"/>
        </classes>
    </test>
</suite>
```

### Multiple Group Dependencies

```java
@Test(groups = "payment",
      dependsOnGroups = {"login", "checkout"})
public void processPayment() {
    // Runs only after all "login" AND all "checkout" tests pass
}
```

### alwaysRun with Group Dependencies

```java
// Run cleanup even if dependent group failed
@Test(groups = "cleanup",
      dependsOnGroups = "payment",
      alwaysRun = true)
public void closeBrowser() {
    driver.quit(); // always runs — even if payment tests failed
}
```

### Comparison

| Feature | dependsOnMethods | dependsOnGroups |
|---|---|---|
| Granularity | Specific method names | Group names |
| Maintainability | Low (names are fragile) | High (groups are stable) |
| Scale | Small suites | Enterprise suites |
| Flexibility | Rigid | Add/remove methods freely |
| testng.xml control | No | Yes (include/exclude) |
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Intermediate',
  ARRAY['TestNG','dependsOnGroups','dependsOnMethods','Groups','Test Order','Suite Design','alwaysRun'],
  true, 0
),

-- TestNG Advanced Q6
(
  'What is the difference between @BeforeSuite, @BeforeTest, @BeforeClass, and @BeforeMethod in TestNG?',
  'testng-advanced-q6-before-suite-test-class-method-lifecycle',
  'These annotations define setup at different scopes: Suite runs once for all tests, Test runs per <test> block, Class runs per test class, Method runs before each @Test method.',
  $ans$
## TestNG Lifecycle Annotation Scopes

Understanding the execution order is critical for framework design.

### Full Execution Order

```
@BeforeSuite       → runs ONCE at very start of entire suite
  @BeforeTest      → runs once per <test> block in testng.xml
    @BeforeClass   → runs once before first @Test method in each class
      @BeforeMethod  → runs before EACH @Test method
        @Test        ← actual test
      @AfterMethod   → runs after EACH @Test method
    @AfterClass    → runs once after all @Test methods in class
  @AfterTest       → runs once after all tests in <test> block
@AfterSuite        → runs ONCE at very end of suite
```

### Practical Example

```java
public class SuiteSetup {

    @BeforeSuite
    public void globalSetup() {
        // Runs ONCE: Start test database, initialize ExtentReports,
        // load global config, start mock server
        System.out.println("Suite started");
        ExtentReportManager.getInstance();
        TestDatabase.startTestDb();
    }

    @AfterSuite
    public void globalTeardown() {
        // Runs ONCE: Flush reports, stop test database, send email
        ExtentReportManager.getInstance().flush();
        TestDatabase.stopTestDb();
        EmailUtility.sendReport();
    }
}

public class LoginTest extends BaseTest {

    @BeforeClass
    public void loginSetup() {
        // Runs ONCE per class: Navigate to login page, set browser cookies
        driver.get(config.get("baseUrl") + "/login");
    }

    @AfterClass
    public void loginCleanup() {
        // Runs ONCE per class: Logout, clear session
        driver.findElement(By.id("logoutBtn")).click();
    }

    @BeforeMethod
    public void beforeEachTest(Method method) {
        // Runs before EVERY @Test: Take note of test name, create ExtentTest entry
        ExtentReportManager.setTest(
            ExtentReportManager.getInstance().createTest(method.getName())
        );
    }

    @AfterMethod
    public void afterEachTest(ITestResult result) {
        // Runs after EVERY @Test: Screenshot on fail, log status
        if (result.getStatus() == ITestResult.FAILURE) {
            captureScreenshot(result.getName());
            ExtentReportManager.getTest().fail(result.getThrowable());
        } else {
            ExtentReportManager.getTest().pass("Test passed");
        }
    }

    @Test
    public void validLogin() { ... }

    @Test
    public void invalidLogin() { ... }
}
```

### What Each Scope Is Best For

| Annotation | Use For |
|---|---|
| `@BeforeSuite` | Start report framework, launch test server, global config |
| `@AfterSuite` | Flush reports, send email, stop services |
| `@BeforeTest` | Setup per-XML-test-block (e.g., browser type for cross-browser) |
| `@AfterTest` | Tear down per-XML-test-block |
| `@BeforeClass` | Login once for all methods in class, navigate to section |
| `@AfterClass` | Logout, clean test data created by class |
| `@BeforeMethod` | Create ExtentTest entry, reset form, navigate to page |
| `@AfterMethod` | Screenshot on fail, log result, reset state |

### Key Rules
- `@BeforeSuite` method must be in a class that is part of the suite (or a listener)
- `@BeforeTest` corresponds to `<test>` in testng.xml — NOT a `@Test` method
- Multiple `@BeforeMethod` methods execute in class hierarchy order (parent first)
- `alwaysRun = true` on `@AfterMethod` ensures cleanup even when test throws
  $ans$,
  'TestNG', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['TestNG','@BeforeSuite','@BeforeTest','@BeforeClass','@BeforeMethod','Lifecycle','Setup','Teardown'],
  true, 0
),

-- TestNG Advanced Q7
(
  'What is Reporter.log() in TestNG and how do you use it?',
  'testng-advanced-q7-reporter-log-testng-logging',
  'Reporter.log() adds custom log messages to TestNG HTML reports at the test-method level — useful for step-by-step execution details in the built-in report.',
  $ans$
## Reporter.log() in TestNG

`Reporter.log()` writes messages that appear in TestNG''s built-in HTML report (`index.html` → test method details). Each log entry is tied to the current test method.

### Basic Usage

```java
import org.testng.Reporter;

@Test
public void loginTest() {
    Reporter.log("Step 1: Navigating to login page");
    driver.get("https://automateqa.online/login");

    Reporter.log("Step 2: Entering username");
    driver.findElement(By.id("username")).sendKeys("admin");

    Reporter.log("Step 3: Entering password");
    driver.findElement(By.id("password")).sendKeys("secret");

    Reporter.log("Step 4: Clicking login button");
    driver.findElement(By.id("loginBtn")).click();

    Assert.assertTrue(driver.getTitle().contains("Dashboard"),
        "Login failed — expected Dashboard");

    Reporter.log("Step 5: PASSED — Dashboard loaded successfully");
}
```

### Log to Console AND Report Simultaneously

The second argument `true` echoes the message to System.out as well:

```java
Reporter.log("Clicking submit button", true); // goes to report AND console
Reporter.log("Element found", false);          // goes to report only
```

### Log with HTML Formatting

Reporter.log supports HTML:

```java
Reporter.log("<b>Step 1:</b> Login page loaded ✓");
Reporter.log("<span style='color:green'>PASS: Dashboard visible</span>");
Reporter.log("<pre>" + driver.getPageSource().substring(0, 200) + "</pre>");
```

### Reusable Step Logger Utility

```java
public class StepLogger {

    public static void step(String stepDescription) {
        Reporter.log("<b>➤ " + stepDescription + "</b>", true);
    }

    public static void pass(String message) {
        Reporter.log("<span style='color:#28a745'>✓ PASS: " + message + "</span>", true);
    }

    public static void fail(String message) {
        Reporter.log("<span style='color:#dc3545'>✗ FAIL: " + message + "</span>", true);
    }

    public static void info(String message) {
        Reporter.log("<span style='color:#6c757d'>ℹ " + message + "</span>", true);
    }
}

// In tests:
StepLogger.step("Navigate to checkout page");
StepLogger.pass("Cart total displayed correctly");
StepLogger.fail("Payment button not clickable");
```

### Access Logged Messages Programmatically

```java
// In a listener or reporter — get all logs for a test
List<String> logs = Reporter.getOutput(testResult);
logs.forEach(System.out::println);
```

### Reporter.log() vs System.out.println()

| Aspect | Reporter.log() | System.out.println() |
|---|---|---|
| Appears in TestNG report | Yes | No |
| Appears in console | Only if second arg is `true` | Yes |
| Per-test association | Yes — tied to current test | No |
| HTML formatting | Yes | No |
| ExtentReports | Separate — use `.info()` | No |
  $ans$,
  'TestNG', 'Technical', '1-2 Years', 'Beginner',
  ARRAY['TestNG','Reporter.log','Logging','HTML Report','Test Steps','ITestResult','Console'],
  true, 0
),

-- TestNG Advanced Q8
(
  'How do you use testng.xml groups to include and exclude tests in TestNG?',
  'testng-advanced-q8-testng-xml-groups-include-exclude',
  'Groups in testng.xml let you run targeted subsets of tests — include smoke/regression groups for CI, exclude wip/broken groups, or define run/define group hierarchies.',
  $ans$
## Groups Include/Exclude in testng.xml

Groups allow you to run only specific categories of tests without changing code.

### Define Groups in Test Code

```java
@Test(groups = {"smoke", "login"})
public void validLoginTest() { ... }

@Test(groups = {"regression", "login"})
public void loginWithInvalidEmailTest() { ... }

@Test(groups = {"smoke", "checkout"})
public void addToCartTest() { ... }

@Test(groups = {"regression", "checkout", "payment"})
public void fullCheckoutFlowTest() { ... }

@Test(groups = "wip") // work in progress — exclude from CI
public void newFeatureTest() { ... }
```

### testng.xml — Include Specific Groups

```xml
<!-- Run ONLY smoke tests -->
<suite name="SmokeSuite">
    <test name="SmokeTests">
        <groups>
            <run>
                <include name="smoke"/>
            </run>
        </groups>
        <classes>
            <class name="tests.LoginTest"/>
            <class name="tests.CheckoutTest"/>
        </classes>
    </test>
</suite>
```

### testng.xml — Exclude Groups

```xml
<!-- Run everything EXCEPT wip and broken groups -->
<suite name="RegressionSuite">
    <test name="AllTests">
        <groups>
            <run>
                <include name="regression"/>
                <exclude name="wip"/>
                <exclude name="broken"/>
            </run>
        </groups>
        <classes>
            <class name="tests.LoginTest"/>
            <class name="tests.CartTest"/>
            <class name="tests.PaymentTest"/>
        </classes>
    </test>
</suite>
```

### Group Definitions — Define Group Hierarchy

```xml
<suite name="Suite">
    <test name="Tests">
        <groups>
            <define name="allTests">
                <include name="smoke"/>
                <include name="regression"/>
            </define>
            <run>
                <include name="allTests"/>
                <exclude name="wip"/>
            </run>
        </groups>
    </test>
</suite>
```

### Run via Maven — Override Groups at Runtime

```bash
# Run only smoke tests from command line
mvn test -Dgroups="smoke"

# Run smoke AND login groups
mvn test -Dgroups="smoke,login"

# Exclude wip
mvn test -DexcludedGroups="wip"
```

### Common Group Strategy in Enterprise

```java
// Group naming convention
@Test(groups = {"smoke"})           // Critical path — run on every commit
@Test(groups = {"regression"})      // Full suite — run nightly
@Test(groups = {"api"})             // API-only — fast, no browser needed
@Test(groups = {"ui"})              // Browser tests — slower
@Test(groups = {"wip"})             // In progress — never run in CI
@Test(groups = {"broken"})          // Known defect — document and exclude
@Test(groups = {"performance"})     // Load tests — run weekly
```

### CI/CD Pipeline Group Strategy

```groovy
// Jenkinsfile
stage('Smoke Tests') {
    steps { sh 'mvn test -Dgroups="smoke"' }
}
stage('Full Regression') {
    when { branch 'main' }
    steps { sh 'mvn test -Dgroups="regression" -DexcludedGroups="wip,broken"' }
}
```
  $ans$,
  'TestNG', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['TestNG','Groups','Include','Exclude','testng.xml','Smoke','Regression','CI/CD','Maven'],
  true, 0
),

-- TestNG Advanced Q9
(
  'What is IReporter in TestNG and how do you create a custom report?',
  'testng-advanced-q9-ireporter-custom-report-testng',
  'IReporter is a TestNG interface that runs after suite completion — implement it to generate custom CSV, JSON, email, or dashboard reports from test results.',
  $ans$
## IReporter in TestNG

`IReporter` is called once after the entire suite finishes. It receives the complete test results and lets you generate any output format — CSV, JSON, email, custom HTML.

### Implement IReporter

```java
import org.testng.IReporter;
import org.testng.ISuite;
import org.testng.ISuiteResult;
import org.testng.ITestContext;
import org.testng.ITestNGMethod;
import org.testng.xml.XmlSuite;

import java.io.*;
import java.util.*;

public class CustomCSVReporter implements IReporter {

    @Override
    public void generateReport(List<XmlSuite> xmlSuites,
                               List<ISuite> suites,
                               String outputDirectory) {

        StringBuilder sb = new StringBuilder();
        sb.append("TestName,Status,Duration(ms),ClassName\n");

        for (ISuite suite : suites) {
            Map<String, ISuiteResult> results = suite.getResults();

            for (ISuiteResult suiteResult : results.values()) {
                ITestContext context = suiteResult.getTestContext();

                // Passed tests
                context.getPassedTests().getAllResults().forEach(result -> {
                    sb.append(result.getName()).append(",PASS,")
                      .append(result.getEndMillis() - result.getStartMillis()).append(",")
                      .append(result.getTestClass().getName()).append("\n");
                });

                // Failed tests
                context.getFailedTests().getAllResults().forEach(result -> {
                    sb.append(result.getName()).append(",FAIL,")
                      .append(result.getEndMillis() - result.getStartMillis()).append(",")
                      .append(result.getTestClass().getName()).append("\n");
                });

                // Skipped tests
                context.getSkippedTests().getAllResults().forEach(result -> {
                    sb.append(result.getName()).append(",SKIP,0,")
                      .append(result.getTestClass().getName()).append("\n");
                });
            }
        }

        // Write to file
        try {
            String filePath = outputDirectory + "/custom-report.csv";
            new File(outputDirectory).mkdirs();
            try (FileWriter fw = new FileWriter(filePath)) {
                fw.write(sb.toString());
            }
            System.out.println("Custom CSV report generated: " + filePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### Register in testng.xml

```xml
<suite name="Suite">
    <listeners>
        <listener class-name="reporters.CustomCSVReporter"/>
    </listeners>
    <test name="Tests">
        <classes><class name="tests.LoginTest"/></classes>
    </test>
</suite>
```

### Generate Summary Statistics

```java
@Override
public void generateReport(List<XmlSuite> xmlSuites, List<ISuite> suites, String outDir) {
    int passed = 0, failed = 0, skipped = 0;

    for (ISuite suite : suites) {
        for (ISuiteResult result : suite.getResults().values()) {
            ITestContext ctx = result.getTestContext();
            passed  += ctx.getPassedTests().size();
            failed  += ctx.getFailedTests().size();
            skipped += ctx.getSkippedTests().size();
        }
    }

    int total = passed + failed + skipped;
    double passRate = total > 0 ? (double) passed / total * 100 : 0;

    System.out.println("========= Test Summary =========");
    System.out.printf("Total:   %d%n", total);
    System.out.printf("Passed:  %d (%.1f%%)%n", passed, passRate);
    System.out.printf("Failed:  %d%n", failed);
    System.out.printf("Skipped: %d%n", skipped);
    System.out.println("================================");
}
```

### IReporter vs ITestListener

| Interface | When Called | Scope | Use For |
|---|---|---|---|
| `ITestListener` | During execution (per test) | Real-time | Live logging, ExtentReports |
| `IReporter` | After entire suite | Post-execution | Final CSV/JSON/email reports |
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','IReporter','Custom Report','CSV','ISuite','ITestContext','Reporting','Post-Suite'],
  true, 0
),

-- TestNG Advanced Q10
(
  'What is threadPoolSize in TestNG @Test and how does it work with invocationCount?',
  'testng-advanced-q10-threadpoolsize-invocationcount',
  'threadPoolSize defines how many parallel threads run simultaneous invocations of the same @Test method — combined with invocationCount to stress-test or load-test a single method.',
  $ans$
## threadPoolSize + invocationCount in TestNG

These two attributes work together to run a single `@Test` method multiple times across multiple parallel threads.

### Basic Concept

```java
@Test(invocationCount = 10, threadPoolSize = 3)
public void loadTest() {
    // Runs 10 times total, with 3 running in parallel at any moment
    driver.get("https://automateqa.online");
    Assert.assertTrue(driver.getTitle().contains("AutomateQA"));
}
```

**Execution:** 3 threads run the method simultaneously. When one finishes, the next invocation starts, until all 10 are done.

### invocationCount Only (Sequential)

```java
// Run 5 times — one at a time, sequentially
@Test(invocationCount = 5)
public void repeatTest() {
    System.out.println("Run #" + getCurrentInvocationCount());
    // Use case: verify no memory leak or state corruption over repeated runs
}
```

### threadPoolSize Only (Without invocationCount)

```java
// threadPoolSize without invocationCount = ignored
// invocationCount defaults to 1 — only 1 run
@Test(threadPoolSize = 5) // no effect without invocationCount
public void singleRun() { ... }
```

### API Load Testing Pattern

```java
@Test(invocationCount = 100, threadPoolSize = 10)
public void apiConcurrencyTest() {
    // Simulates 100 concurrent API calls, 10 at a time
    Response response = RestAssured
        .given().baseUri("https://api.automateqa.online")
        .get("/interview-questions");

    Assert.assertEquals(response.getStatusCode(), 200);
    Assert.assertTrue(response.time() < 2000, "Response > 2s");
}
```

### Get Current Invocation Number

```java
@Test(invocationCount = 5, threadPoolSize = 2)
public void trackedTest(ITestContext context) {
    // Track via thread ID
    System.out.println("Thread: " + Thread.currentThread().getId()
        + " | Invocation: " + /* no direct API, use AtomicInteger */ counter.incrementAndGet());
}

private AtomicInteger counter = new AtomicInteger(0);
```

### Use Cases

| Scenario | invocationCount | threadPoolSize |
|---|---|---|
| Verify test is not flaky | 10 | 1 (sequential) |
| Load test API endpoint | 100 | 20 |
| Check for race conditions | 50 | 10 |
| Stress test login | 200 | 25 |
| Verify session isolation | 20 | 5 |

### Important: ThreadLocal Required

With `threadPoolSize > 1`, multiple threads execute the same method:

```java
@Test(invocationCount = 20, threadPoolSize = 5)
public void parallelSessionTest() {
    // MUST use ThreadLocal driver — 5 threads run this simultaneously
    WebDriver driver = DriverManager.getDriver(); // ThreadLocal
    driver.get("https://automateqa.online");
    Assert.assertNotNull(driver.getTitle());
}
```
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','threadPoolSize','invocationCount','Parallel','Load Testing','Thread Safety','Concurrency'],
  true, 0
),

-- TestNG Advanced Q11
(
  'What is @Test(enabled=false) in TestNG and when should you use it?',
  'testng-advanced-q11-test-enabled-false-disable-test',
  '@Test(enabled=false) skips a test method without removing it from code — useful for temporarily disabling broken tests, WIP tests, or tests blocked by a known defect.',
  $ans$
## @Test(enabled=false) in TestNG

`enabled=false` disables a `@Test` method — TestNG completely skips it (not even counted as skipped in most reporters).

### Basic Usage

```java
@Test(enabled = false) // disabled — will not run
public void brokenFeatureTest() {
    // Known defect: JIRA-456 — payment gateway returns 500
    // Re-enable when JIRA-456 is fixed
    driver.findElement(By.id("payBtn")).click();
    Assert.assertEquals(getPaymentStatus(), "Success");
}

@Test // enabled = true is default
public void workingTest() {
    Assert.assertTrue(driver.getTitle().contains("Home"));
}
```

### When to Use enabled=false

```java
// 1. Known production bug — test would always fail, blocking CI
@Test(enabled = false, description = "Disabled: JIRA-789 — search returns wrong results")
public void searchFilterTest() { ... }

// 2. Feature in development — not ready yet
@Test(enabled = false, description = "WIP: Checkout flow not implemented")
public void checkoutTest() { ... }

// 3. Test is environment-specific — not applicable to current environment
@Test(enabled = false, description = "Only runs on staging — disabled for prod")
public void dataResetTest() { ... }
```

### Conditional Enable/Disable (Dynamic)

Better than hardcoding `enabled=false` — use `IAnnotationTransformer` to control at runtime:

```java
public class ConditionalEnableTransformer implements IAnnotationTransformer {

    @Override
    public void transform(ITestAnnotation annotation, Class testClass,
                          Constructor testConstructor, Method testMethod) {

        String env = System.getProperty("env", "staging");

        // Disable prod-data-reset tests on production
        if (testMethod != null && testMethod.isAnnotationPresent(ProdOnly.class)
                && !env.equals("production")) {
            annotation.setEnabled(false);
        }
    }
}
```

### enabled=false vs Groups Exclusion

| Approach | Visible | Flexible | Report |
|---|---|---|---|
| `enabled=false` | In code | No — needs code change | Not shown |
| `groups="broken"` + exclude | In code + XML | Yes — XML/Maven flag | Shown as excluded |
| `@Test(enabled=false)` | In code | No | Not shown |
| Comment out test | Hidden | Worst | Not shown |

### Best Practice for Disabled Tests

Always add documentation:

```java
@Test(
    enabled = false,
    description = "DISABLED: JIRA-1234 — dropdown broken on Chrome 120. Re-enable after hotfix."
)
public void dropdownTest() { ... }
```

This way, any team member can search for `enabled = false` in the codebase and find all disabled tests with their reasons.
  $ans$,
  'TestNG', 'Technical', 'Fresher', 'Beginner',
  ARRAY['TestNG','enabled','@Test','Disable Test','Skip','JIRA','Known Defect','Best Practice'],
  true, 0
),

-- TestNG Advanced Q12
(
  'How do you pass parameters from testng.xml to test methods using @Parameters?',
  'testng-advanced-q12-parameters-testng-xml',
  'Define <parameter> tags in testng.xml and read them in test methods using @Parameters annotation — ideal for environment URLs, browser names, and credentials.',
  $ans$
## @Parameters in TestNG

`@Parameters` lets you pass values from `testng.xml` into test methods or `@Before*/@After*` setup methods — without hardcoding environment-specific values in test code.

### Step 1 — Define Parameters in testng.xml

```xml
<suite name="Suite">
    <parameter name="env"      value="staging"/>
    <parameter name="baseUrl"  value="https://staging.automateqa.online"/>
    <parameter name="browser"  value="chrome"/>

    <test name="SmokeTests">
        <parameter name="emailUser" value="smoke@test.com"/>
        <parameter name="emailPass" value="smoke123"/>

        <classes>
            <class name="tests.LoginTest"/>
        </classes>
    </test>
</suite>
```

### Step 2 — Read in Test Class

```java
public class LoginTest extends BaseTest {

    @Parameters({"browser"})
    @BeforeMethod
    public void setUp(String browser) {
        // browser = "chrome" from testng.xml
        initDriver(browser);
    }

    @Parameters({"baseUrl", "emailUser", "emailPass"})
    @Test
    public void loginTest(String baseUrl, String email, String password) {
        driver.get(baseUrl + "/login");
        driver.findElement(By.id("email")).sendKeys(email);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("loginBtn")).click();
        Assert.assertTrue(driver.getTitle().contains("Dashboard"));
    }
}
```

### @Optional — Default Values

```java
@Parameters({"browser"})
@BeforeMethod
public void setUp(@Optional("chrome") String browser) {
    // Uses "chrome" if "browser" parameter not defined in testng.xml
    initDriver(browser);
}
```

### Multi-Environment testng.xml Files

```xml
<!-- testng-staging.xml -->
<suite name="Staging Suite">
    <parameter name="baseUrl" value="https://staging.automateqa.online"/>
    <parameter name="env"     value="staging"/>
</suite>

<!-- testng-prod.xml -->
<suite name="Prod Suite">
    <parameter name="baseUrl" value="https://automateqa.online"/>
    <parameter name="env"     value="production"/>
</suite>
```

Run for specific environment:
```bash
mvn test -DsuiteXmlFile=testng-staging.xml
mvn test -DsuiteXmlFile=testng-prod.xml
```

### Cross-Browser Matrix

```xml
<suite name="CrossBrowserSuite" parallel="tests" thread-count="3">
    <test name="Chrome">
        <parameter name="browser" value="chrome"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>
    <test name="Firefox">
        <parameter name="browser" value="firefox"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>
    <test name="Edge">
        <parameter name="browser" value="edge"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>
</suite>
```

### @Parameters vs @DataProvider

| Aspect | @Parameters | @DataProvider |
|---|---|---|
| Data source | testng.xml | Java method (array) |
| Multiple data sets | No | Yes |
| Runtime override | Maven `-D` flags | Code change needed |
| Use case | Config values, env, browser | Functional data sets |
  $ans$,
  'TestNG', 'Technical', '1-2 Years', 'Beginner',
  ARRAY['TestNG','@Parameters','testng.xml','@Optional','Cross Browser','Environment','Configuration'],
  true, 0
),

-- TestNG Advanced Q13
(
  'What is the difference between SoftAssert and HardAssert in TestNG with real examples?',
  'testng-advanced-q13-softassert-vs-hardassert-real-examples',
  'HardAssert stops test execution on first failure; SoftAssert collects all failures and reports them together at assertAll() — use SoftAssert to validate multiple fields in one test run.',
  $ans$
## SoftAssert vs HardAssert in TestNG

### HardAssert (Default) — Stops on First Failure

```java
import org.testng.Assert;

@Test
public void hardAssertExample() {
    driver.get("https://automateqa.online/profile");

    Assert.assertEquals(getFieldValue("name"),  "AutomateQA Team"); // if FAILS → test stops here
    Assert.assertEquals(getFieldValue("email"), "team@automateqa.online"); // NEVER REACHED
    Assert.assertEquals(getFieldValue("role"),  "Admin");            // NEVER REACHED
}
// Result: Only the first failure is reported. Other fields not validated.
```

### SoftAssert — Collects All Failures

```java
import org.testng.asserts.SoftAssert;

@Test
public void softAssertExample() {
    SoftAssert soft = new SoftAssert();
    driver.get("https://automateqa.online/profile");

    soft.assertEquals(getFieldValue("name"),  "AutomateQA Team");      // recorded
    soft.assertEquals(getFieldValue("email"), "team@automateqa.online");// recorded
    soft.assertEquals(getFieldValue("role"),  "Admin");                 // recorded
    soft.assertTrue(isProfileImageVisible(),  "Profile image missing"); // recorded

    soft.assertAll(); // NOW reports ALL failures at once
}
// Result: All 4 assertions evaluated; report shows all that failed.
```

### Real-World: Registration Form Validation

```java
@Test
public void verifyRegistrationForm() {
    SoftAssert soft = new SoftAssert();

    driver.findElement(By.id("submitBtn")).click(); // submit empty form

    // Validate ALL error messages in one test
    soft.assertTrue(isErrorVisible("name"),       "Name field error missing");
    soft.assertTrue(isErrorVisible("email"),      "Email field error missing");
    soft.assertTrue(isErrorVisible("password"),   "Password field error missing");
    soft.assertTrue(isErrorVisible("phone"),      "Phone field error missing");
    soft.assertEquals(getErrorText("email"),      "Please enter a valid email");
    soft.assertEquals(getErrorText("password"),   "Password must be 8+ characters");

    soft.assertAll(); // report all field validation failures
}
```

### Common Mistake — Forgetting assertAll()

```java
@Test
public void badSoftAssert() {
    SoftAssert soft = new SoftAssert();
    soft.assertTrue(false, "This failure is recorded but...");
    // FORGOT soft.assertAll() — test PASSES despite failure!
}
```

### SoftAssert in Page Objects

```java
public class ProfilePage {
    SoftAssert soft = new SoftAssert();

    public ProfilePage verifyName(String expected) {
        soft.assertEquals(getField("name"), expected, "Name mismatch");
        return this; // fluent
    }
    public ProfilePage verifyEmail(String expected) {
        soft.assertEquals(getField("email"), expected, "Email mismatch");
        return this;
    }
    public void assertAll() { soft.assertAll(); }
}

// In test:
new ProfilePage(driver)
    .verifyName("AutomateQA Team")
    .verifyEmail("team@automateqa.online")
    .assertAll();
```

### When to Use Each

| Scenario | Use |
|---|---|
| Login — if wrong URL, rest makes no sense | HardAssert |
| Form field validation — check all errors | SoftAssert |
| Navigation — wrong page = test meaningless | HardAssert |
| Dashboard widget values — check all at once | SoftAssert |
| Precondition checks | HardAssert |
| Multi-field UI regression | SoftAssert |
  $ans$,
  'TestNG', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['TestNG','SoftAssert','HardAssert','Assertion','assertAll','Validation','Form Testing'],
  true, 0
),

-- TestNG Advanced Q14
(
  'How do you run only failed test cases using testng-failed.xml in TestNG?',
  'testng-advanced-q14-run-failed-tests-testng-failed-xml',
  'TestNG auto-generates testng-failed.xml after a suite run — rerun it directly to execute only the failed tests without re-running passed ones.',
  $ans$
## Running Failed Tests with testng-failed.xml

After every TestNG suite run, TestNG automatically generates `test-output/testng-failed.xml` containing only the tests that failed.

### How It Works

1. Run your full suite — some tests fail
2. TestNG creates `test-output/testng-failed.xml` automatically
3. Run `testng-failed.xml` to re-execute ONLY those failures

### testng-failed.xml Structure (Auto-Generated)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="Failed suite [Suite]" verbose="2">
  <test name="Failed tests from Login Tests [LoginTest]">
    <classes>
      <class name="tests.LoginTest">
        <methods>
          <include name="invalidPasswordTest"/>
          <include name="sessionTimeoutTest"/>
        </methods>
      </class>
    </classes>
  </test>
</suite>
```

### Run via Maven

```bash
# First run — some tests fail
mvn test

# Re-run only failures
mvn test -DsuiteXmlFile=test-output/testng-failed.xml
```

### Run via IntelliJ / Eclipse

Right-click `test-output/testng-failed.xml` → Run As → TestNG Suite

### IRetryAnalyzer vs testng-failed.xml

| Approach | When | How |
|---|---|---|
| `IRetryAnalyzer` | During current run | Automatically retries immediately |
| `testng-failed.xml` | After run completes | Manual re-run of failures |
| Maven Surefire rerun | During run | `<rerunFailingTestsCount>2</rerunFailingTestsCount>` |

### Maven Surefire — Auto-Retry on Failure

```xml
<!-- pom.xml — automatically reruns failures up to 2 times -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.2.5</version>
    <configuration>
        <suiteXmlFiles>
            <suiteXmlFile>testng.xml</suiteXmlFile>
        </suiteXmlFiles>
        <rerunFailingTestsCount>2</rerunFailingTestsCount>
    </configuration>
</plugin>
```

### Jenkins Pipeline — Re-Run on Failure

```groovy
pipeline {
    agent any
    stages {
        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Rerun Failures') {
            when {
                expression { currentBuild.result == 'FAILURE' }
            }
            steps {
                sh 'mvn test -DsuiteXmlFile=test-output/testng-failed.xml'
            }
        }
    }
}
```

### Important Notes
- `testng-failed.xml` is overwritten on every run — save a copy if needed
- It only includes `@Test` methods, not `@Before*/@After*` (those still run normally)
- If testng-failed.xml shows 0 tests = all passed
- The file is in `test-output/` by default — can configure output directory
  $ans$,
  'TestNG', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['TestNG','testng-failed.xml','Failed Tests','Rerun','Maven Surefire','Jenkins','IRetryAnalyzer'],
  true, 0
),

-- TestNG Advanced Q15
(
  'What is singleThreaded in TestNG and when do you use it?',
  'testng-advanced-q15-singlethreaded-test-class',
  'singleThreaded=true on a test class ensures all its @Test methods run in the same thread even when parallel execution is enabled — used for tests that share browser state.',
  $ans$
## singleThreaded in TestNG

When a suite runs in `parallel="methods"` mode, individual `@Test` methods from the same class can run in different threads. `@Test(singleThreaded = true)` at class level overrides this — forcing all methods of that class to run in ONE thread.

### The Problem Without singleThreaded

```java
// parallel="methods" — each method runs in its own thread
// LoginTest.validLogin     → Thread-1
// LoginTest.invalidLogin   → Thread-2   ← CONFLICT: both share driver!
// LoginTest.sessionTimeout → Thread-3
```

Without ThreadLocal, multiple threads interfere with each other''s driver.

### Solution 1 — singleThreaded (Keep Class Sequential)

```java
@Test(singleThreaded = true) // ALL methods run in same thread
public class LoginTest extends BaseTest {

    @Test
    public void openLoginPage() {
        driver.get("https://automateqa.online/login");
    }

    @Test(dependsOnMethods = "openLoginPage")
    public void enterCredentials() {
        driver.findElement(By.id("username")).sendKeys("admin");
    }

    @Test(dependsOnMethods = "enterCredentials")
    public void submitAndVerify() {
        driver.findElement(By.id("loginBtn")).click();
        Assert.assertTrue(driver.getTitle().contains("Dashboard"));
    }
}
```

All 3 methods run sequentially in the same thread → same driver instance → no conflict.

### testng.xml Configuration

```xml
<suite name="Suite" parallel="methods" thread-count="5">
    <test name="Tests">
        <classes>
            <class name="tests.LoginTest"/>      <!-- singleThreaded=true in class -->
            <class name="tests.CartTest"/>       <!-- can run methods in parallel -->
            <class name="tests.ProductTest"/>
        </classes>
    </test>
</suite>
```

`LoginTest` runs its methods sequentially, while `CartTest` and `ProductTest` methods run in parallel.

### Solution 2 — ThreadLocal (Better for Parallel Methods)

Rather than using `singleThreaded`, the modern approach is:

```java
// No singleThreaded needed — each thread gets its OWN driver
public class LoginTest extends BaseTest {
    // BaseTest uses ThreadLocal<WebDriver>

    @Test
    public void validLogin() {
        DriverManager.getDriver().get("..."); // Thread-safe
    }

    @Test
    public void invalidLogin() {
        DriverManager.getDriver().get("..."); // Different thread, different driver
    }
}
```

### When to Use singleThreaded

| Scenario | Use singleThreaded? |
|---|---|
| Tests share browser session (login → cart → checkout) | Yes |
| Tests are fully independent | No — use ThreadLocal |
| Methods have `dependsOnMethods` chain | Yes (or use `parallel="classes"`) |
| Complex state machine tests | Yes |
| Stateless API tests | No |

### singleThreaded vs parallel="classes"

- `singleThreaded=true` on a class: that specific class is sequential; others may be parallel
- `parallel="classes"` in XML: all classes run in parallel, but each class''s methods are sequential

**Best modern approach:** Use `ThreadLocal<WebDriver>` + `parallel="methods"` rather than `singleThreaded`.
  $ans$,
  'TestNG', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['TestNG','singleThreaded','Parallel','Thread Safety','ThreadLocal','Test Order','Framework Design'],
  true, 0
);
