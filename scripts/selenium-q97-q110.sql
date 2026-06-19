-- Selenium Q97–Q110 | APIs, Logging, InvocationCount, Scroll | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Name an API used for reading and writing data to Excel files in Selenium.',
  'selenium-q97-api-read-write-excel',
  'Apache POI and JXL (Java Excel API) are the most popular Java APIs for reading, writing, and updating Excel files in Selenium automation.',
  $$## APIs for Reading and Writing Excel Files

Two main APIs are used in Java Selenium projects to handle Excel data:

**1. Apache POI (Most Popular)**
Apache POI is an open-source Java library for Microsoft Office documents, including `.xls` and `.xlsx` files.

```java
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFCell;
import java.io.FileInputStream;

public class ExcelReader {

    public static String readCell(String filePath, String sheetName, int row, int col) throws Exception {
        FileInputStream fis = new FileInputStream(filePath);
        XSSFWorkbook wb = new XSSFWorkbook(fis);
        XSSFSheet sheet = wb.getSheet(sheetName);
        XSSFRow rowObj = sheet.getRow(row);
        String cellValue = rowObj.getCell(col).getStringCellValue();
        wb.close();
        return cellValue;
    }

    public static void writeCell(String filePath, String sheetName, int row, int col, String value) throws Exception {
        FileInputStream fis = new FileInputStream(filePath);
        XSSFWorkbook wb = new XSSFWorkbook(fis);
        XSSFSheet sheet = wb.getSheet(sheetName);
        sheet.getRow(row).getCell(col).setCellValue(value);
        FileOutputStream fos = new FileOutputStream(filePath);
        wb.write(fos);
        wb.close();
    }
}
```

**POI class hierarchy:**
| File type | Workbook | Sheet | Row | Cell |
|-----------|----------|-------|-----|------|
| `.xls` (old) | HSSFWorkbook | HSSFSheet | HSSFRow | HSSFCell |
| `.xlsx` (new) | XSSFWorkbook | XSSFSheet | XSSFRow | XSSFCell |

**Maven dependency:**
```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.3</version>
</dependency>
```

**2. JXL (Java Excel API)**
JXL is an older, lighter API that supports only `.xls` (not `.xlsx`) format.

```java
import jxl.Workbook;
import jxl.Sheet;

Workbook wb = Workbook.getWorkbook(new File("data.xls"));
Sheet sheet = wb.getSheet("Sheet1");
String value = sheet.getCell(col, row).getContents();
wb.close();
```

**Apache POI vs JXL:**
| Feature | Apache POI | JXL |
|---------|-----------|-----|
| .xlsx support | Yes | No |
| .xls support | Yes | Yes |
| Actively maintained | Yes | No |
| Usage in projects | Standard | Legacy |

**Recommendation:** Use **Apache POI** for all new projects — it supports modern `.xlsx` files and is actively maintained.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Apache POI', 'JXL', 'Excel', 'Data Driven', 'TestNG'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Name an API used for logging in Java automation.',
  'selenium-q98-logging-api-java',
  'Log4j is the most popular open-source logging API in Java. It supports multiple log levels: ALL, DEBUG, INFO, WARN, ERROR, TRACE, and FATAL.',
  $$## Logging API in Java — Log4j

**Log4j** (Log for Java) is an open-source logging framework maintained by Apache. It is the most widely used logging API in Java Selenium automation projects.

**Log levels (in order of severity):**

| Level | Use Case |
|-------|----------|
| `ALL` | Log everything |
| `TRACE` | Very fine-grained debug info |
| `DEBUG` | Debugging messages |
| `INFO` | General execution info |
| `WARN` | Potential issues, not errors |
| `ERROR` | Errors that allow continuation |
| `FATAL` | Severe errors — app may stop |
| `OFF` | Disable all logging |

**Maven dependency (Log4j 2):**
```xml
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.20.0</version>
</dependency>
```

**Basic usage in Selenium test:**
```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LoginTest {

    private static final Logger log = LogManager.getLogger(LoginTest.class);

    @Test
    public void loginTest() {
        log.info("Starting login test");
        log.debug("Navigating to URL: https://example.com");
        driver.get("https://example.com");

        try {
            driver.findElement(By.id("username")).sendKeys("admin");
            log.info("Entered username successfully");
        } catch (Exception e) {
            log.error("Failed to enter username: " + e.getMessage());
        }

        log.info("Login test completed");
    }
}
```

**log4j2.xml configuration:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
    <Appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
        </Console>
        <File name="File" fileName="logs/test.log">
            <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss} %-5level %logger - %msg%n"/>
        </File>
    </Appenders>
    <Loggers>
        <Root level="info">
            <AppenderRef ref="Console"/>
            <AppenderRef ref="File"/>
        </Root>
    </Loggers>
</Configuration>
```

**Key benefits:**
- Logs execution flow for debugging failed tests
- Multiple output destinations (console, file, database)
- Configurable log levels — filter noise in CI environments
- Thread-safe for parallel test execution$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Log4j', 'Logging', 'Java', 'Automation Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the use of logging in test automation?',
  'selenium-q99-use-of-logging-automation',
  'Logging captures the runtime behavior of tests, helps debug failures, and creates an audit trail of test execution without re-running tests.',
  $$## Use of Logging in Test Automation

Logging is the practice of recording test execution events, actions, and errors to an output destination (console, file, or database).

**Primary purposes:**

**1. Debugging Test Failures**
When a test fails in CI/CD, you can''t always reproduce it locally. Logs capture exactly what happened:
```
INFO  - Navigating to: https://example.com/login
INFO  - Entering username: testuser
ERROR - Element not found: By.id("loginBtn") — NoSuchElementException
INFO  - Screenshot captured: screenshots/loginTest_2024-01-15.png
```

**2. Audit Trail of Test Execution**
Logs provide a timestamped history of what each test did:
```java
log.info("Test started: " + testName);
log.info("Browser launched: Chrome");
log.info("URL navigated: " + url);
log.info("Test result: PASSED");
```

**3. Performance Monitoring**
Track how long operations take:
```java
long start = System.currentTimeMillis();
driver.findElement(By.id("search")).sendKeys("testNG");
log.debug("Search input took: " + (System.currentTimeMillis() - start) + "ms");
```

**4. Filtering in CI Environments**
Use log levels to control verbosity:
- Development: `DEBUG` level (verbose)
- CI pipeline: `INFO` or `WARN` level (less noise)
- Production monitoring: `ERROR` level only

**Best practice in Selenium framework:**
```java
public class BaseTest {

    protected static final Logger log = LogManager.getLogger(BaseTest.class);

    @BeforeMethod
    public void setup(Method method) {
        log.info("=== Starting test: " + method.getName() + " ===");
        driver = new ChromeDriver();
    }

    @AfterMethod
    public void teardown(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            log.error("Test FAILED: " + result.getName());
            log.error("Cause: " + result.getThrowable().getMessage());
            captureScreenshot(result.getName());
        }
        driver.quit();
        log.info("=== Test finished: " + result.getName() + " ===");
    }
}
```

**Summary:**
- Logging helps **debug** tests when failures occur
- Provides a **storage of test runtime behavior**
- Essential for diagnosing intermittent failures in CI/CD
- Works alongside TestNG Listeners for comprehensive reporting$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Logging', 'Log4j', 'Debugging', 'Automation Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is InvocationCount in TestNG?',
  'selenium-q100-invocationcount-testng',
  'invocationCount is a @Test attribute that defines how many times a test method should be executed consecutively before moving to the next test.',
  $$## InvocationCount in TestNG

`invocationCount` is an attribute of the `@Test` annotation that tells TestNG to run a test method **N times** before proceeding to the next test.

**Basic example:**
```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.Test;

public class InvocationCountExample {

    @Test(invocationCount = 3)
    public void getTitle() {
        System.setProperty("webdriver.chrome.driver", "C://Drivers/chromedriver.exe");
        WebDriver driver = new ChromeDriver();
        driver.get("http://www.pavantestingtools.com/");
        driver.manage().window().maximize();
        System.out.println("Website Title: " + driver.getTitle());
        driver.quit();
    }

    @Test
    public void secondTest() {
        System.out.println("This will be executed at the end");
    }
}
```

**Output:** `getTitle()` runs 3 consecutive times, then `secondTest()` runs once.

**invocationCount with threadPoolSize (parallel invocations):**
```java
@Test(invocationCount = 5, threadPoolSize = 3)
public void parallelTest() {
    System.out.println("Running in thread: " + Thread.currentThread().getId());
}
```
This runs the test 5 times using 3 parallel threads simultaneously.

**Use cases:**
- **Stability testing** — Run a flaky test multiple times to confirm it consistently passes
- **Load simulation** — Repeat an action to simulate multiple user interactions
- **Stress testing** — Verify a feature holds up under repeated execution

**invocationCount vs @DataProvider:**

| Feature | invocationCount | @DataProvider |
|---------|----------------|---------------|
| Same data each run | Yes | No |
| Different data each run | No | Yes |
| External data source | No | Yes |
| Simple repetition | Yes | Overkill |

**Key point:** `invocationCount` runs the exact same test logic N times without changing any data — useful for flaky test analysis and stability checks.$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'invocationCount', '@Test', 'Test Execution'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we run a test method multiple times in a loop without using any data provider?',
  'selenium-q101-run-test-multiple-times-loop',
  'Use the invocationCount parameter in @Test annotation to run a test method N times in a loop without needing @DataProvider.',
  $$## Running a Test Method Multiple Times in a Loop

Set `invocationCount` in the `@Test` annotation to make a test run N times in a loop without any data provider.

**Example — run getTitle() 5 times:**
```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.Test;

public class InvocationCountLoop {

    @Test(invocationCount = 5)
    public void getTitle() {
        System.setProperty("webdriver.chrome.driver", "C://Drivers/chromedriver_win32/chromedriver.exe");
        WebDriver driver = new ChromeDriver();
        driver.get("http://www.pavantestingtools.com/");
        driver.manage().window().maximize();
        System.out.println("Website Title: " + driver.getTitle());
        driver.quit();
    }

    @Test
    public void secondTest() {
        System.out.println("This will be executed at the end");
    }
}
```

**Execution order:**
1. `getTitle()` runs — iteration 1
2. `getTitle()` runs — iteration 2
3. `getTitle()` runs — iteration 3
4. `getTitle()` runs — iteration 4
5. `getTitle()` runs — iteration 5
6. `secondTest()` runs — once

**Getting current invocation index:**
```java
@Test(invocationCount = 5)
public void repeatedTest(ITestContext context) {
    // ITestResult gives you the invocation count
    System.out.println("Invocation #" + (System.currentTimeMillis()));
}
```

**With parallel threads:**
```java
@Test(invocationCount = 10, threadPoolSize = 5)
public void parallelRepeatedTest() {
    // Runs 10 times using up to 5 parallel threads
    System.out.println("Thread: " + Thread.currentThread().getName());
}
```

**Difference from @DataProvider:**
- `invocationCount = 5` → runs same logic 5 times, same data each time
- `@DataProvider` → runs same logic N times, **different data** each time

**When to use invocationCount:**
- Confirming a flaky test is not intermittently failing
- Performance/stress testing a specific action
- Running a teardown/setup cycle N times$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'invocationCount', 'Loop', 'Test Repetition'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the default priority of test cases in TestNG?',
  'selenium-q102-default-priority-testng',
  'The default priority in TestNG is 0. Tests with lower priority numbers run first, so a test with priority 0 runs before a test with priority 1.',
  $$## Default Priority of Test Cases in TestNG

The default priority assigned to a `@Test` method when no `priority` is specified is **integer value 0**.

**Key rule:** Lower priority number = **runs first**

```java
@Test(priority = 1)
public void testWithPriority1() {
    System.out.println("Runs SECOND");
}

@Test
// No priority = defaults to 0
public void testWithDefaultPriority() {
    System.out.println("Runs FIRST (priority 0)");
}
```

**Order of execution:** `testWithDefaultPriority()` → `testWithPriority1()`

**Extended example:**
```java
@Test(priority = -1)
public void negativeTest() {
    System.out.println("1st — priority -1");
}

@Test
// Default priority = 0
public void defaultTest() {
    System.out.println("2nd — priority 0 (default)");
}

@Test(priority = 1)
public void firstPriority() {
    System.out.println("3rd — priority 1");
}

@Test(priority = 2)
public void secondPriority() {
    System.out.println("4th — priority 2");
}
```

**What happens with same priority?**
If two tests have the same priority (including the default 0), TestNG sorts them **alphabetically** by method name:
```java
@Test  // priority 0
public void loginTest() { }  // runs before searchTest (l < s alphabetically)

@Test  // priority 0
public void searchTest() { }
```

**Summary table:**

| Scenario | Execution order |
|----------|-----------------|
| No priority (default 0) | Before priority 1, 2, 3... |
| priority = -1 | Before default (0) |
| priority = 0 (same as default) | Same bucket, sorted alphabetically |
| priority = 1 | After default (0) |

**Best practice:** Prefer `dependsOnMethods` for explicit ordering rather than relying on priority numbers alone.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'Priority', 'Default Priority', '@Test'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between soft assertion and hard assertion in TestNG?',
  'selenium-q103-soft-vs-hard-assertion-testng',
  'Hard assertions stop test execution immediately on failure. Soft assertions allow the test to continue and collect all failures, reported at the end via assertAll().',
  $$## Soft Assertion vs Hard Assertion in TestNG

**Hard Assertions (default Assert class):**
The usual assertions from TestNG. If any assertion **fails**, the test method stops immediately — no further steps are executed.

```java
@Test
public void hardAssertionTest() {
    Assert.assertEquals(driver.getTitle(), "Home Page");  // If this fails...
    System.out.println("This line is NOT reached if assertion above fails");
    Assert.assertTrue(element.isDisplayed());  // This is also skipped
}
```

**Soft Assertions (SoftAssert class):**
Allows multiple assertions in one test — even if one fails, the test **continues** executing. All failures are collected and reported together at the end via `assertAll()`.

```java
import org.testng.asserts.SoftAssert;

@Test
public void softAssertionTest() {
    SoftAssert softAssert = new SoftAssert();

    // Assertion failing — but test continues
    softAssert.fail();
    System.out.println("Failing");  // This IS printed despite the failure above

    // Assertion passing
    softAssert.assertEquals(1, 1);
    System.out.println("Passing");  // This is also printed

    // Collates all assertion results — test is marked FAIL here
    softAssert.assertAll();
}
```

**Another soft assert example:**
```java
@Test
public void verifyHomePage() {
    SoftAssert sa = new SoftAssert();

    sa.assertEquals(driver.getTitle(), "Home Page", "Title mismatch");
    sa.assertTrue(logo.isDisplayed(), "Logo not visible");
    sa.assertFalse(errorBanner.isDisplayed(), "Error banner should be hidden");
    sa.assertNotNull(driver.findElement(By.id("search")), "Search box missing");

    // Reports ALL failures at once
    sa.assertAll();
}
```

**Comparison table:**

| Feature | Hard Assert | Soft Assert |
|---------|-------------|-------------|
| Class | `Assert` | `SoftAssert` |
| On failure | Stops test immediately | Continues test |
| Failures reported | First failure only | All failures |
| Report failures | `Assert.assertEquals()` | `softAssert.assertAll()` |
| Use case | Critical blockers | Multiple validations |

**When to use which:**
- **Hard Assert** → When subsequent steps depend on the assertion (e.g., login must succeed before checking dashboard)
- **Soft Assert** → When you want to check multiple UI elements in one test and get a complete picture of what failed

**Critical rule:** Always call `softAssert.assertAll()` at the end — without it, soft assertion failures are silently ignored.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'SoftAssert', 'Hard Assert', 'Assertions', 'assertAll'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to fail a TestNG test if it does not get executed within a specified time?',
  'selenium-q104-timeout-testng-test',
  'Use the timeOut attribute in @Test annotation to set a maximum execution time. If the test exceeds this time, it fails with TimeoutException.',
  $$## Failing a TestNG Test on Timeout

Use the `timeOut` attribute in `@Test` to set an **upper bound** on how long the test may run (in milliseconds). If the test takes longer, TestNG marks it as **FAILED** with an interrupted exception.

**Basic example:**
```java
import org.testng.annotations.Test;

public class TimeoutTest {

    @Test(timeOut = 1000)  // Test must complete within 1000ms (1 second)
    public void timeOutTest() throws InterruptedException {
        // Sleep for 2 seconds — will cause timeout failure
        Thread.sleep(2000);
        System.out.println("Will throw Timeout exception!");
    }
}
```

**Test that passes within timeout:**
```java
@Test(timeOut = 5000)  // 5 seconds max
public void quickTest() throws InterruptedException {
    Thread.sleep(1000);  // Only 1 second — passes fine
    System.out.println("Test completed within timeout");
}
```

**Practical use in Selenium — page load timeout:**
```java
@Test(timeOut = 10000)  // 10 seconds
public void verifyPageLoad() {
    driver.get("https://example.com");
    // If page takes more than 10 seconds to load and assertions run, test fails
    Assert.assertEquals(driver.getTitle(), "Example Domain");
}
```

**Timeout for detecting stuck tests:**
```java
@Test(timeOut = 30000)  // 30 seconds
public void loginFlowTest() {
    driver.get("https://example.com/login");
    driver.findElement(By.id("username")).sendKeys("admin");
    driver.findElement(By.id("password")).sendKeys("password");
    driver.findElement(By.id("loginBtn")).click();
    // If login hangs indefinitely, this will fail at 30s
    wait.until(ExpectedConditions.titleIs("Dashboard"));
}
```

**timeOut vs WebDriverWait:**

| Feature | @Test(timeOut) | WebDriverWait |
|---------|---------------|---------------|
| Scope | Entire test method | Specific element wait |
| Action on timeout | Test FAILED | TimeoutException thrown |
| Use case | Overall test duration cap | Wait for specific condition |

**Key points:**
- Value is in **milliseconds**
- Test is interrupted and marked `FAILED` if it exceeds the limit
- Use to prevent tests from hanging indefinitely in CI pipelines$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'timeOut', '@Test', 'Timeout', 'Test Execution'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we skip a test case conditionally in TestNG?',
  'selenium-q105-skip-test-conditionally-testng',
  'Throw SkipException inside your test method to conditionally skip it. The test is marked as skipped and remaining code in that method does not execute.',
  $$## Conditionally Skipping a Test Case in TestNG

Use `throw new SkipException("reason")` inside your test to conditionally skip it based on runtime conditions.

**Basic example:**
```java
import org.testng.SkipException;
import org.testng.annotations.Test;

public class ConditionalSkipTest {

    @Test
    public void testMethod() {
        boolean conditionToCheckForSkippingTest = true;

        if (conditionToCheckForSkippingTest) {
            throw new SkipException("Skipping the test");
            // Any code after this line is NOT executed
        }
        // Test logic here — only reached if condition is false
        System.out.println("Running test logic");
    }
}
```

**Real-world conditional skip:**
```java
@Test
public void featureTest() {
    String environment = System.getProperty("env", "staging");

    // Skip this test in production environment
    if (environment.equals("production")) {
        throw new SkipException("Skipping in production — destructive test");
    }

    // Test runs only in staging/dev
    driver.findElement(By.id("deleteAllBtn")).click();
}
```

**Skip based on browser:**
```java
@Test
public void ie11SpecificTest() {
    String browser = System.getProperty("browser", "chrome");

    if (!browser.equalsIgnoreCase("ie")) {
        throw new SkipException("This test is only for IE browser");
    }

    // IE-specific test logic
}
```

**What happens when SkipException is thrown:**
1. Test method stops executing at the `throw` line
2. Test is marked as **SKIPPED** (yellow) in the TestNG report
3. `@AfterMethod` still runs (cleanup still happens)
4. `dependsOnMethods` tests are also skipped

**SkipException vs dependsOnMethods:**

| Approach | When to use |
|----------|-------------|
| `SkipException` | Runtime condition — data, environment, browser |
| `dependsOnMethods` | Structural dependency — test A must pass first |

**Key points:**
- `throw new SkipException("message")` marks test as SKIPPED in report
- Any code after the throw is **not executed**
- The test is not counted as a failure — it''s explicitly skipped
- `@AfterMethod` cleanup still executes after a skip$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'SkipException', 'Skip Test', 'Conditional'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we make sure a test method runs even if the methods it depends on fail or get skipped?',
  'selenium-q106-alwaysrun-testng',
  'Set alwaysRun=true in @Test annotation to force a test method to execute regardless of whether its dependencies passed, failed, or were skipped.',
  $$## alwaysRun Attribute in TestNG

By default, if a method listed in `dependsOnMethods` fails, the dependent test is **skipped**. Setting `alwaysRun = true` overrides this — the test runs **regardless** of what happened to its dependencies.

**Without alwaysRun (default behavior):**
```java
@Test
public void parentTest() {
    Assert.fail("Failed test");  // This FAILS
}

@Test(dependsOnMethods = {"parentTest"})
public void dependentTest() {
    System.out.println("This is SKIPPED because parentTest failed");
}
```

**With alwaysRun = true:**
```java
@Test
public void parentTest() {
    Assert.fail("Failed test");  // This FAILS
}

@Test(dependsOnMethods = {"parentTest"}, alwaysRun = true)
public void dependentTest() {
    System.out.println("Running even if parent test failed");
    // This RUNS despite parentTest failing
}
```

**Report difference:**

| Scenario | parentTest | dependentTest |
|----------|-----------|---------------|
| Without alwaysRun | FAILED | SKIPPED |
| With alwaysRun = true | FAILED | RUNS (passes or fails on its own) |

**Practical use case — cleanup after failure:**
```java
@Test
public void createUserTest() {
    // Create a user — might fail
    Assert.assertTrue(createUser("testUser"), "User creation failed");
}

@Test(dependsOnMethods = {"createUserTest"}, alwaysRun = true)
public void deleteUserTest() {
    // ALWAYS delete the user to clean up, even if creation failed
    deleteUser("testUser");
}
```

**alwaysRun with groups:**
```java
@Test(dependsOnGroups = {"login"}, alwaysRun = true)
public void teardownTest() {
    // Always runs cleanup even if login group tests fail
    driver.quit();
}
```

**Key points:**
- Without `alwaysRun`: dependent test is **SKIPPED** when dependency fails
- With `alwaysRun = true`: dependent test **ALWAYS RUNS** regardless
- Useful for cleanup tests that must run even after failure
- Removing `alwaysRun=true` from `@AfterClass`/`@AfterMethod` can prevent cleanup$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'alwaysRun', 'dependsOnMethods', '@Test', 'Test Execution'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Why and how will you use an Excel Sheet in your Selenium project?',
  'selenium-q107-excel-sheet-selenium-project',
  'Excel sheets are used as external data sources for data-driven testing — storing test credentials, input values, and expected results for test methods.',
  $$## Using Excel Sheets in Selenium Projects

**Why use Excel?**
Excel sheets serve as a **centralized, non-technical data source** for test data. Business analysts or QA managers can update test data without touching code.

**Primary use cases:**
1. **Data-Driven Testing** — Store login credentials, search terms, form values
2. **Test Data Management** — Maintain datasets for multiple environments
3. **Result Storage** — Write pass/fail status back to the sheet

**How to use (Apache POI + TestNG @DataProvider):**

**Excel structure (testdata.xlsx):**
| username | password | expectedTitle |
|----------|----------|---------------|
| user1 | pass1 | Dashboard |
| user2 | pass2 | Dashboard |
| invaliduser | wrongpass | Login Error |

**ExcelReader utility class:**
```java
import org.apache.poi.xssf.usermodel.*;
import java.io.FileInputStream;

public class ExcelUtils {

    private XSSFWorkbook workbook;
    private XSSFSheet sheet;

    public ExcelUtils(String filePath, String sheetName) throws Exception {
        FileInputStream fis = new FileInputStream(filePath);
        workbook = new XSSFWorkbook(fis);
        sheet = workbook.getSheet(sheetName);
    }

    public String getCellData(int row, int col) {
        return sheet.getRow(row).getCell(col).getStringCellValue();
    }

    public int getRowCount() {
        return sheet.getLastRowNum();
    }
}
```

**TestNG DataProvider reading from Excel:**
```java
public class LoginTest {

    ExcelUtils excel;

    @DataProvider(name = "loginData")
    public Object[][] getLoginData() throws Exception {
        excel = new ExcelUtils("src/test/resources/testdata.xlsx", "LoginSheet");
        int rows = excel.getRowCount();
        Object[][] data = new Object[rows][2];

        for (int i = 1; i <= rows; i++) {
            data[i-1][0] = excel.getCellData(i, 0);  // username
            data[i-1][1] = excel.getCellData(i, 1);  // password
        }
        return data;
    }

    @Test(dataProvider = "loginData")
    public void loginTest(String username, String password) {
        driver.findElement(By.id("username")).sendKeys(username);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("loginBtn")).click();
    }
}
```

**Key benefits:**
- Non-developers can manage test data
- No code recompilation when data changes
- Single source of truth for test inputs
- Scales easily to hundreds of data rows$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Excel', 'Apache POI', 'Data Driven', 'TestNG', '@DataProvider'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can you redirect browsing from a browser through some proxy in Selenium?',
  'selenium-q108-redirect-browser-proxy-selenium',
  'Use Selenium''s Proxy class and set it via DesiredCapabilities or ChromeOptions to route browser traffic through a proxy server.',
  $$## Redirecting Browser Through a Proxy in Selenium

Selenium provides a `Proxy` class to configure browser traffic through a proxy server.

**Basic proxy setup:**
```java
import org.openqa.selenium.Proxy;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.firefox.FirefoxDriver;

String PROXY = "199.201.125.147:8080";

org.openqa.selenium.Proxy proxy = new org.openqa.selenium.Proxy();
proxy.setHttpProxy(PROXY)
     .setFtpProxy(PROXY)
     .setSslProxy(PROXY);

DesiredCapabilities cap = new DesiredCapabilities();
cap.setCapability(CapabilityType.PROXY, proxy);

WebDriver driver = new FirefoxDriver(cap);
```

**Modern approach with ChromeOptions:**
```java
import org.openqa.selenium.Proxy;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.chrome.ChromeDriver;

Proxy proxy = new Proxy();
proxy.setHttpProxy("proxy.company.com:8080");
proxy.setSslProxy("proxy.company.com:8080");

ChromeOptions options = new ChromeOptions();
options.setProxy(proxy);

WebDriver driver = new ChromeDriver(options);
driver.get("https://example.com");
```

**SOCKS proxy:**
```java
Proxy proxy = new Proxy();
proxy.setSocksProxy("socks.proxy.com:1080");
proxy.setSocksVersion(5);

ChromeOptions options = new ChromeOptions();
options.setProxy(proxy);
```

**Proxy with authentication (ChromeOptions extension):**
```java
// For authenticated proxies, pass credentials in the URL
String proxyUrl = "username:password@proxy.server.com:8080";
Proxy proxy = new Proxy();
proxy.setHttpProxy(proxyUrl);
```

**Proxy types supported:**
| Method | Protocol |
|--------|----------|
| `setHttpProxy()` | HTTP traffic |
| `setSslProxy()` | HTTPS/SSL traffic |
| `setFtpProxy()` | FTP traffic |
| `setSocksProxy()` | SOCKS4/5 traffic |

**Common use cases:**
- Route test traffic through a corporate proxy
- Capture requests via a local proxy (BrowserMob, Charles)
- Test geo-restricted content via regional proxies
- Monitor network calls during test execution$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Proxy', 'ChromeOptions', 'DesiredCapabilities', 'Network'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to scroll down a page using JavaScript in Selenium?',
  'selenium-q109-scroll-down-page-javascript-selenium',
  'Use JavascriptExecutor with window.scrollBy(x, y) to scroll the page by a specified number of pixels in Selenium.',
  $$## Scrolling Down a Page Using JavaScript in Selenium

Use `JavascriptExecutor` to execute JavaScript''s `window.scrollBy()` function to scroll the page by a specified pixel offset.

**Basic scroll down:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("window.scrollBy(0, 500)");  // Scroll down 500 pixels
```

**Syntax:** `window.scrollBy(x, y)`
- `x` = horizontal scroll (pixels) — use `0` for vertical-only scroll
- `y` = vertical scroll (pixels) — positive = down, negative = up

**Common scroll patterns:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;

// Scroll down 500px
js.executeScript("window.scrollBy(0, 500)");

// Scroll up 300px
js.executeScript("window.scrollBy(0, -300)");

// Scroll to bottom of page
js.executeScript("window.scrollTo(0, document.body.scrollHeight)");

// Scroll to top of page
js.executeScript("window.scrollTo(0, 0)");

// Scroll to specific coordinates
js.executeScript("window.scrollTo(0, 1000)");
```

**Full test example:**
```java
@Test
public void scrollTest() {
    driver.get("https://example.com/long-page");

    JavascriptExecutor js = (JavascriptExecutor) driver;

    // Scroll down to load lazy content
    js.executeScript("window.scrollBy(0, 500)");
    Thread.sleep(1000);

    // Verify element is now visible after scroll
    WebElement element = driver.findElement(By.id("lazy-section"));
    Assert.assertTrue(element.isDisplayed());

    // Scroll back to top
    js.executeScript("window.scrollTo(0, 0)");
}
```

**When to use JavaScript scrolling:**
- Elements that load lazily as you scroll
- Infinite scroll pages
- Fixed headers blocking element interaction
- Elements not interactable until scrolled into view

**Alternative — Actions class scroll (Selenium 4):**
```java
// Selenium 4+
Actions actions = new Actions(driver);
actions.scrollByAmount(0, 500).perform();
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'JavascriptExecutor', 'Scroll', 'JavaScript', 'scrollBy'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to scroll down to a particular element in Selenium?',
  'selenium-q110-scroll-to-element-selenium',
  'Use JavascriptExecutor with arguments[0].scrollIntoView() to scroll the browser view to a specific WebElement.',
  $$## Scrolling to a Particular Element in Selenium

Use `JavascriptExecutor` with the `scrollIntoView()` JavaScript method to bring a specific element into the visible viewport.

**Basic example:**
```java
WebElement element = driver.findElement(By.id("targetElement"));
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].scrollIntoView();", element);
```

**scrollIntoView with alignment options:**
```java
// Scroll to element, align to top of viewport
js.executeScript("arguments[0].scrollIntoView(true);", element);

// Scroll to element, align to bottom of viewport
js.executeScript("arguments[0].scrollIntoView(false);", element);

// Scroll with smooth behavior and center alignment
js.executeScript("arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});", element);
```

**Full test example — click element after scrolling:**
```java
@Test
public void scrollAndClickTest() {
    driver.get("https://example.com/long-page");

    // Find the element (may be off-screen)
    WebElement submitBtn = driver.findElement(By.id("submitBtn"));

    // Scroll to it
    JavascriptExecutor js = (JavascriptExecutor) driver;
    js.executeScript("arguments[0].scrollIntoView(true);", submitBtn);

    // Wait for it to be visible and click
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
    wait.until(ExpectedConditions.elementToBeClickable(submitBtn));
    submitBtn.click();

    Assert.assertEquals(driver.getTitle(), "Confirmation Page");
}
```

**Common issue — fixed header covers element after scroll:**
```java
// Scroll into view then adjust for fixed header (e.g., 100px header)
js.executeScript("arguments[0].scrollIntoView(true);", element);
js.executeScript("window.scrollBy(0, -100);");  // Scroll back up 100px
```

**scrollIntoView vs scrollBy comparison:**

| Method | Use when |
|--------|----------|
| `scrollIntoView(element)` | You know the target element |
| `scrollBy(0, pixels)` | You want to scroll a specific pixel amount |
| `scrollTo(0, height)` | You want to go to a specific Y coordinate |

**Selenium 4 alternative:**
```java
// Selenium 4+
Actions actions = new Actions(driver);
actions.scrollToElement(element).perform();
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'JavascriptExecutor', 'scrollIntoView', 'Scroll', 'WebElement'], true, 0
);
