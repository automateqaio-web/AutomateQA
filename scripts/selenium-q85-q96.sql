-- Selenium Q85–Q96 | TestNG Fundamentals | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is TestNG?',
  'selenium-q85-what-is-testng',
  'TestNG (Next Generation) is a Java testing framework that extends JUnit with advanced features like assertions, reporting, and parallel test execution.',
  $$## What is TestNG?

**TestNG** (Next Generation) is a powerful testing framework for Java, inspired by JUnit and NUnit. It is designed to cover all categories of tests — unit, functional, end-to-end, and integration tests — and integrates seamlessly with Selenium.

**Key capabilities:**
- **Assertions** – Validate expected vs actual results (`Assert.assertEquals`, `Assert.assertTrue`)
- **Reporting** – Generates HTML and XML test reports automatically
- **Parallel Execution** – Run tests simultaneously across threads or browsers
- **Data-Driven Testing** – `@DataProvider` feeds multiple data sets into one test
- **Grouping** – Tag tests into groups (sanity, regression) and selectively run them
- **Dependency** – Control execution order with `dependsOnMethods`
- **Parameterization** – Pass external values via `testng.xml` using `@Parameters`

**Minimal example:**
```java
import org.testng.annotations.Test;
import org.testng.Assert;

public class LoginTest {
    @Test
    public void verifyLogin() {
        String actual = "Welcome";
        Assert.assertEquals(actual, "Welcome", "Login failed!");
    }
}
```

**Why TestNG over JUnit?**

| Feature | TestNG | JUnit |
|---------|--------|-------|
| Parallel execution | Built-in | Limited |
| Data provider | @DataProvider | @ParameterizedTest |
| Grouping | Yes | Categories |
| Dependencies | Yes | No |
| Suite configuration | testng.xml | Suites runner |
| Reporting | Built-in HTML | Requires plugin |

TestNG is the most popular choice for Selenium automation projects in Java.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'Testing Framework', 'Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are some advantages of TestNG?',
  'selenium-q86-advantages-of-testng',
  'TestNG offers assertions, parallel execution, dependency management, grouping, data-driven testing, and built-in reporting over JUnit.',
  $$## Advantages of TestNG

TestNG provides a rich set of features that make it superior to JUnit for Selenium automation:

**1. Assertions**
Validates expected vs actual values with detailed failure messages.
```java
Assert.assertEquals(driver.getTitle(), "Home Page", "Title mismatch!");
Assert.assertTrue(element.isDisplayed(), "Element not visible");
```

**2. Parallel Execution**
Run test methods, classes, or suites simultaneously to reduce execution time.
```xml
<suite name="MySuite" parallel="methods" thread-count="3">
```

**3. Test Method Dependencies**
Ensure one test runs only after another passes.
```java
@Test(dependsOnMethods = { "loginTest" })
public void dashboardTest() { }
```

**4. Priority Assignment**
Control execution order by setting priority values.
```java
@Test(priority = 1)
public void firstTest() { }

@Test(priority = 2)
public void secondTest() { }
```

**5. Test Grouping**
Organize tests into groups for selective execution.
```java
@Test(groups = { "sanity", "regression" })
public void loginTest() { }
```

**6. Data-Driven Testing via @DataProvider**
Run the same test with multiple data sets.
```java
@DataProvider(name = "loginData")
public Object[][] getData() {
    return new Object[][] {{"user1","pass1"}, {"user2","pass2"}};
}

@Test(dataProvider = "loginData")
public void loginTest(String user, String pass) { }
```

**7. Built-in Reporting**
Auto-generates `index.html` and `emailable-report.html` without plugins.

**8. @Parameters Support**
Pass values from `testng.xml` to test methods.
```java
@Parameters("browser")
@Test
public void launchBrowser(String browser) { }
```

**Summary list:**
1. Different assertion types for flexible validation
2. Parallel execution of test methods
3. Dependency between test methods
4. Priority assignment for test methods
5. Grouping of test methods into test groups
6. Data-driven testing via @DataProvider
7. Inherent HTML reporting support
8. Parameter passing via @Parameters annotation$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'Assertions', 'Parallel Execution', 'DataProvider'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the use of testng.xml file?',
  'selenium-q87-use-of-testng-xml-file',
  'testng.xml is the configuration file for the entire TestNG test suite — it defines suites, groups, parameters, listeners, and parallel settings.',
  $$## Use of testng.xml File

`testng.xml` is the master configuration file for TestNG. It controls how the test suite is organized and executed.

**What you can do with testng.xml:**
- Define **test suites** and **test groups**
- Mark tests for **parallel execution**
- Add **listeners** for custom logging/reporting
- Pass **parameters** to test methods
- **Include or exclude** specific test groups or classes
- **Trigger the entire test suite** from a single file

**Basic testng.xml structure:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="AutomateQA Suite" verbose="1">
  <test name="LoginTests">
    <classes>
      <class name="tests.LoginTest" />
      <class name="tests.DashboardTest" />
    </classes>
  </test>
</suite>
```

**Passing parameters via testng.xml:**
```xml
<suite name="MySuite">
  <test name="ChromeTest">
    <parameter name="browser" value="chrome" />
    <classes>
      <class name="tests.BrowserTest" />
    </classes>
  </test>
</suite>
```

**Including/excluding groups:**
```xml
<suite name="RegressionSuite">
  <test name="RegressionTest">
    <groups>
      <run>
        <include name="regression" />
        <exclude name="smoke" />
      </run>
    </groups>
    <classes>
      <class name="tests.AllTests" />
    </classes>
  </test>
</suite>
```

**Adding listeners:**
```xml
<suite name="MySuite">
  <listeners>
    <listener class-name="listeners.MyTestListener" />
  </listeners>
  <test name="SmokeTest">
    <classes>
      <class name="tests.SmokeTest" />
    </classes>
  </test>
</suite>
```

Run the suite from command line: `mvn test -DsuiteXmlFile=testng.xml`$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'testng.xml', 'Test Suite', 'Configuration'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we pass parameters to a test script using TestNG?',
  'selenium-q88-pass-parameters-testng',
  'Use @Parameters annotation in Java and define the parameter tag in testng.xml to pass external values to test methods.',
  $$## Passing Parameters to Test Scripts Using TestNG

TestNG allows passing runtime values from `testng.xml` to your test methods using the `@Parameters` annotation.

**Step 1 — Define parameter in testng.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="testsuite">
  <test name="sampletest">
    <parameter name="a" value="welcome" />
    <classes>
      <class name="parameterization.Test1" />
    </classes>
  </test>
</suite>
```

**Step 2 — Use @Parameters in Java test:**
```java
package parameterization;

import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

public class Test1 {

    @Parameters("a")
    @Test
    public void m1(String s) {
        System.out.println("The value from xml file is: " + s);
        // Output: The value from xml file is: welcome
    }
}
```

**Practical browser parameterization:**
```xml
<suite name="CrossBrowserSuite">
  <test name="ChromeTest">
    <parameter name="browser" value="chrome" />
    <classes>
      <class name="tests.BrowserTest" />
    </classes>
  </test>
  <test name="FirefoxTest">
    <parameter name="browser" value="firefox" />
    <classes>
      <class name="tests.BrowserTest" />
    </classes>
  </test>
</suite>
```

```java
@Parameters("browser")
@BeforeClass
public void setup(String browser) {
    if (browser.equalsIgnoreCase("chrome")) {
        driver = new ChromeDriver();
    } else if (browser.equalsIgnoreCase("firefox")) {
        driver = new FirefoxDriver();
    }
}
```

**Key rules:**
- Parameter name in `testng.xml` must match the string in `@Parameters("name")`
- Multiple parameters: `@Parameters({"browser", "url"})`
- Optional parameters: use `@Optional("default value")` if param may be absent$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', '@Parameters', 'testng.xml', 'Parameterization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we create a data driven framework using TestNG?',
  'selenium-q89-data-driven-framework-testng',
  'Use @DataProvider annotation to supply multiple data sets to a single test method, enabling data-driven testing in TestNG.',
  $$## Data-Driven Framework Using TestNG @DataProvider

TestNG''s `@DataProvider` lets you run the same test method with different data sets — the foundation of data-driven testing.

**How it works:**
1. Create a method annotated with `@DataProvider` that returns `Object[][]` (2D array)
2. Reference the provider in your `@Test` method via `dataProvider="name"`
3. TestNG automatically runs the test once per data row

**Basic example:**
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class DataDrivenExample {

    @DataProvider(name = "loginData")
    public Object[][] getData() {
        return new Object[][] {
            {"user1", "pass1"},
            {"user2", "pass2"},
            {"user3", "pass3"}
        };
    }

    @Test(dataProvider = "loginData")
    public void loginTest(String username, String password) {
        System.out.println("Testing with: " + username + " / " + password);
        // This test runs 3 times — once per row
    }
}
```

**Full Selenium data-driven login test:**
```java
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.*;

public class DataProviderExample {

    WebDriver driver;

    @BeforeClass
    void setup() {
        System.setProperty("webdriver.chrome.driver", "C://Drivers/chromedriver.exe");
        driver = new ChromeDriver();
    }

    @Test(dataProvider = "users")
    void loginTest(String uname, String pwd) {
        driver.get("http://newtours.demoaut.com/");
        driver.findElement(By.name("userName")).sendKeys(uname);
        driver.findElement(By.name("password")).sendKeys(pwd);
        driver.findElement(By.name("login")).click();
        Assert.assertEquals(driver.getTitle(), "Find a Flight: Mercury Tours:");
    }

    @DataProvider(name = "users")
    String[][] logindata() {
        String data[][] = new String[][] {
            {"mercury", "mercury"},
            {"asasa",   "mercury1"},
            {"mercury2","mercury2"}
        };
        return data;
    }

    @AfterClass
    void closeBrowser() {
        driver.quit();
    }
}
```

**Reading data from Excel (with Apache POI):**
```java
@DataProvider(name = "excelData")
public Object[][] getExcelData() throws Exception {
    FileInputStream fis = new FileInputStream("testdata.xlsx");
    XSSFWorkbook wb = new XSSFWorkbook(fis);
    XSSFSheet sheet = wb.getSheet("Sheet1");
    int rows = sheet.getLastRowNum();
    Object[][] data = new Object[rows][2];
    for (int i = 1; i <= rows; i++) {
        data[i-1][0] = sheet.getRow(i).getCell(0).getStringCellValue();
        data[i-1][1] = sheet.getRow(i).getCell(1).getStringCellValue();
    }
    wb.close();
    return data;
}
```

**Key points:**
- `@DataProvider` method must return `Object[][]`
- Test runs once per row in the 2D array
- Use `parallel = true` in `@DataProvider` to run iterations in parallel
- External data sources (Excel, CSV, DB) can feed the provider$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', '@DataProvider', 'Data Driven', 'Excel', 'Apache POI'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the use of TestNG Listeners?',
  'selenium-q90-testng-listeners-use',
  'TestNG Listeners intercept test events (pass, fail, skip) to perform custom actions like logging and reporting.',
  $$## TestNG Listeners

**Listeners** in TestNG allow you to respond to test events — like test start, success, failure, or skip — and perform custom actions such as logging, screenshot capture on failure, or custom reporting.

**How Listeners work:**
1. TestNG fires events when tests run (onTestStart, onTestSuccess, onTestFailure, etc.)
2. You implement the `ITestListener` interface to hook into these events
3. Your custom code runs automatically at each event

**Key Listener interfaces:**
- `ITestListener` – Handles test-level events (most common)
- `ISuiteListener` – Handles suite-level events (onStart, onFinish)
- `IReporter` – Generates custom reports after suite execution

**Implementing ITestListener:**
```java
package testnglisteners;

import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

public class Mylisteners implements ITestListener {

    @Override
    public void onTestStart(ITestResult result) {
        System.out.println("Test started: " + result.getName());
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        System.out.println("Test passed: " + result.getName());
    }

    @Override
    public void onTestFailure(ITestResult result) {
        System.out.println("Test failed: " + result.getName());
        // Take screenshot on failure here
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        System.out.println("Test skipped: " + result.getName());
    }

    @Override
    public void onTestFailedButWithinSuccessPercentage(ITestResult result) { }

    @Override
    public void onStart(ITestContext context) { }

    @Override
    public void onFinish(ITestContext context) { }
}
```

**Practical use — screenshot on failure:**
```java
@Override
public void onTestFailure(ITestResult result) {
    TakesScreenshot ts = (TakesScreenshot) driver;
    File src = ts.getScreenshotAs(OutputType.FILE);
    FileUtils.copyFile(src, new File("screenshots/" + result.getName() + ".png"));
}
```

**Register listener in testng.xml:**
```xml
<suite name="MySuite">
  <listeners>
    <listener class-name="testnglisteners.Mylisteners" />
  </listeners>
  <test name="LoginTest">
    <classes>
      <class name="tests.LoginTest" />
    </classes>
  </test>
</suite>
```

**Key points:**
1. TestNG listeners perform actions when test events are triggered
2. Most commonly used for configuring reports and logging
3. `ITestListener` and `TestListenerAdapter` are the most widely used
4. Methods: `onTestSuccess`, `onTestFailure`, `onTestSkipped`, `onStart`, `onFinish`
5. You must implement the interface in a listener class of your own$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Listeners', 'ITestListener', 'Reporting'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the use of @Listeners annotation in TestNG?',
  'selenium-q91-listeners-annotation-testng',
  '@Listeners annotation on a test class tells TestNG to use a specific custom listener class for that test class.',
  $$## @Listeners Annotation in TestNG

The `@Listeners` annotation is used at the **class level** to attach a custom listener to a specific test class, without needing to declare it in `testng.xml`.

**Steps to use @Listeners:**

**Step 1 — Create the Listener class (implements ITestListener):**
```java
package testnglisteners;

import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

public class Mylisteners implements ITestListener {

    @Override
    public void onTestStart(ITestResult result) {
        System.out.println(" test is started");
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        System.out.println(" test is passed");
    }

    @Override
    public void onTestFailure(ITestResult result) {
        System.out.println("test is failed");
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        System.out.println("test is skipped");
    }

    @Override
    public void onTestFailedButWithinSuccessPercentage(ITestResult result) { }

    @Override
    public void onStart(ITestContext context) { }

    @Override
    public void onFinish(ITestContext context) { }
}
```

**Step 2 — Apply @Listeners to the test class:**
```java
package testnglisteners;

import org.testng.Assert;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;

@Listeners(testnglisteners.Mylisteners.class)
public class LoginTest {

    @Test
    void setup() {
        Assert.fail(); // This will trigger onTestFailure
    }

    @Test
    void loginByEmail() {
        Assert.assertTrue(true); // This will trigger onTestSuccess
    }

    @Test(dependsOnMethods = {"setup"})
    void loginByFacebook() {
        Assert.assertTrue(true); // Will be skipped since setup fails
    }
}
```

**@Listeners vs testng.xml listener:**

| Approach | Scope | When to use |
|----------|-------|-------------|
| `@Listeners` on class | Single class | Targeted listener for specific tests |
| `testng.xml` listener | Entire suite | Global listener for all tests |

**Multiple listeners:**
```java
@Listeners({testnglisteners.Mylisteners.class, testnglisteners.ReportListener.class})
public class LoginTest { }
```

**Key point:** We need to implement the `ITestListener` interface by creating a listener class of our own. After that, using the `@Listeners` annotation, we can specify that for a particular test class, our customized listener class should be used.$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', '@Listeners', 'ITestListener', 'Annotation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we make one test method dependent on another using TestNG?',
  'selenium-q92-test-dependency-testng',
  'Use the dependsOnMethods parameter in @Test annotation to ensure one test method runs only after another passes.',
  $$## Test Method Dependencies in TestNG

TestNG''s `dependsOnMethods` allows you to define execution dependencies between test methods — a dependent test runs **only after** its dependency passes.

**Basic dependency:**
```java
@Test
public void loginTest() {
    System.out.println("Login test executed");
}

@Test(dependsOnMethods = { "loginTest" })
public void dashboardTest() {
    System.out.println("Dashboard test — runs only if loginTest passed");
}
```

**Multiple dependencies:**
```java
@Test(dependsOnMethods = { "loginTest", "verifyHomePageTest" })
public void checkoutTest() {
    System.out.println("Runs only after both loginTest and verifyHomePageTest pass");
}
```

**What happens if the dependency fails?**
- The dependent test is **skipped** (not failed)
- TestNG marks it as `SKIP` in the report
- To force it to always run regardless: add `alwaysRun = true`

```java
@Test
public void loginTest() {
    Assert.fail("Login failed!");  // This fails
}

@Test(dependsOnMethods = { "loginTest" })
public void dashboardTest() {
    // This is SKIPPED because loginTest failed
}
```

**dependsOnGroups:**
```java
@Test(groups = "login")
public void loginTest() { }

@Test(dependsOnGroups = "login")
public void dashboardTest() { }
```

**Real-world use case:**
```java
@Test(priority = 1)
public void openBrowser() { driver = new ChromeDriver(); }

@Test(priority = 2, dependsOnMethods = "openBrowser")
public void navigateToURL() { driver.get("https://example.com"); }

@Test(priority = 3, dependsOnMethods = "navigateToURL")
public void verifyTitle() {
    Assert.assertEquals(driver.getTitle(), "Example Domain");
}

@Test(priority = 4, dependsOnMethods = "verifyTitle")
public void closeBrowser() { driver.quit(); }
```

**Key points:**
- `dependsOnMethods = { "methodName" }` — exact method name as string
- Dependent test is **skipped** (not failed) when dependency fails
- Chain multiple methods: `dependsOnMethods = { "m1", "m2" }`
- Use `dependsOnGroups` for group-level dependencies$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'dependsOnMethods', 'Test Dependency'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we set priority of test cases in TestNG?',
  'selenium-q93-set-priority-testng',
  'Use the priority parameter in @Test annotation to control test execution order. Lower priority value = runs first. Default priority is 0.',
  $$## Setting Priority of Test Cases in TestNG

TestNG allows you to control the order of test execution using the `priority` attribute in the `@Test` annotation.

**Basic priority usage:**
```java
@Test(priority = 1)
public void loginTest() {
    System.out.println("Login test — runs first");
}

@Test(priority = 2)
public void searchTest() {
    System.out.println("Search test — runs second");
}

@Test(priority = 3)
public void logoutTest() {
    System.out.println("Logout test — runs third");
}
```

**Default priority is 0:**
Tests without a priority are assigned value **0** and run before those with higher numbers.

```java
@Test              // priority = 0 (default) → runs first
public void defaultTest() { }

@Test(priority = 1) // runs second
public void firstPriorityTest() { }

@Test(priority = -1) // negative priority → runs before 0
public void negativeTest() { }
```

**Execution order rule:** Lower value = executes first.

| priority value | Execution order |
|----------------|-----------------|
| -1 | 1st |
| 0 (default) | 2nd |
| 1 | 3rd |
| 2 | 4th |

**Same priority — alphabetical order:**
If two tests have the same priority, TestNG runs them in alphabetical order by method name.

**Real-world example:**
```java
public class E2ETest {

    @Test(priority = 1)
    public void openBrowser() { }

    @Test(priority = 2)
    public void login() { }

    @Test(priority = 3)
    public void addToCart() { }

    @Test(priority = 4)
    public void checkout() { }

    @Test(priority = 5)
    public void logout() { }
}
```

**Key points:**
- `priority` controls execution order (lower = earlier)
- Default priority = **0** when not specified
- Tests with lower priority run before tests with higher priority
- Combine with `dependsOnMethods` for more explicit control$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'Priority', '@Test', 'Execution Order'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are commonly used TestNG annotations?',
  'selenium-q94-testng-annotations-list',
  'TestNG annotations include @Test, @BeforeMethod, @AfterMethod, @BeforeClass, @AfterClass, @BeforeTest, @AfterTest, @BeforeSuite, and @AfterSuite.',
  $$## Commonly Used TestNG Annotations

TestNG annotations define **when** a method should run relative to the test lifecycle.

**Complete list of commonly used annotations:**

```java
@Test              // Marks the method as a test case
@BeforeMethod      // Runs BEFORE each @Test method
@AfterMethod       // Runs AFTER each @Test method
@BeforeClass       // Runs BEFORE the first test in the class
@AfterClass        // Runs AFTER all tests in the class
@BeforeTest        // Runs BEFORE the first test tag in testng.xml
@AfterTest         // Runs AFTER all tests in the <test> tag
@BeforeSuite       // Runs BEFORE the entire test suite
@AfterSuite        // Runs AFTER the entire test suite
```

**Execution order (lifecycle):**
```
@BeforeSuite
  @BeforeTest
    @BeforeClass
      @BeforeMethod → @Test → @AfterMethod
      @BeforeMethod → @Test → @AfterMethod
    @AfterClass
  @AfterTest
@AfterSuite
```

**Practical example:**
```java
public class AnnotationDemo {

    @BeforeSuite
    public void beforeSuite() {
        System.out.println("Suite started — setup DB connection");
    }

    @BeforeClass
    public void beforeClass() {
        System.out.println("Class started — launch browser");
        driver = new ChromeDriver();
    }

    @BeforeMethod
    public void beforeMethod() {
        System.out.println("Before each test — navigate to home");
        driver.get("https://example.com");
    }

    @Test
    public void loginTest() {
        System.out.println("Running login test");
    }

    @Test
    public void searchTest() {
        System.out.println("Running search test");
    }

    @AfterMethod
    public void afterMethod() {
        System.out.println("After each test — clear cookies");
    }

    @AfterClass
    public void afterClass() {
        System.out.println("Class finished — close browser");
        driver.quit();
    }

    @AfterSuite
    public void afterSuite() {
        System.out.println("Suite finished — close DB connection");
    }
}
```

**Common patterns:**
- `@BeforeClass` → Launch browser
- `@AfterClass` → Quit browser
- `@BeforeMethod` → Navigate to test page / clear state
- `@AfterMethod` → Take screenshot on failure, logout$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'TestNG', 'Annotations', '@BeforeClass', '@AfterClass', '@Test'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are some common assertions provided by TestNG?',
  'selenium-q95-testng-common-assertions',
  'TestNG assertions include assertEquals, assertNotEquals, assertTrue, assertFalse, assertNull, assertNotNull, and fail() for validating test conditions.',
  $$## Common TestNG Assertions

TestNG''s `Assert` class provides static methods to validate test conditions. A failed assertion throws `AssertionError` and marks the test as **FAILED**.

**Commonly used assertion methods:**

**1. assertEquals — Check equality:**
```java
Assert.assertEquals(actual, expected);
Assert.assertEquals(driver.getTitle(), "Home Page");
Assert.assertEquals(actual, expected, "Custom failure message");
// Overloaded for: String, int, double, boolean, Object, etc.
```

**2. assertNotEquals — Check inequality:**
```java
Assert.assertNotEquals(actual, notExpected);
Assert.assertNotEquals(driver.getTitle(), "Error Page");
```

**3. assertTrue — Check condition is true:**
```java
Assert.assertTrue(condition);
Assert.assertTrue(element.isDisplayed(), "Element should be visible");
```

**4. assertFalse — Check condition is false:**
```java
Assert.assertFalse(condition);
Assert.assertFalse(errorMsg.isDisplayed(), "No error should appear");
```

**5. assertNull — Check object is null:**
```java
Assert.assertNull(object);
Assert.assertNull(driver.findElements(By.id("popup")).isEmpty() ? null : "popup");
```

**6. assertNotNull — Check object is not null:**
```java
Assert.assertNotNull(object);
Assert.assertNotNull(driver.findElement(By.id("username")));
```

**7. fail — Force test failure:**
```java
Assert.fail("Test deliberately failed");
Assert.fail("Expected exception was not thrown");
```

**Full example:**
```java
@Test
public void validateHomePage() {
    driver.get("https://example.com");

    // Title validation
    Assert.assertEquals(driver.getTitle(), "Example Domain");

    // Element presence
    WebElement heading = driver.findElement(By.tagName("h1"));
    Assert.assertNotNull(heading, "Heading should exist");
    Assert.assertTrue(heading.isDisplayed(), "Heading should be visible");

    // URL check
    Assert.assertFalse(driver.getCurrentUrl().contains("error"));
}
```

**Quick reference table:**

| Method | Checks |
|--------|--------|
| `assertEquals(a, e)` | a equals e |
| `assertNotEquals(a, n)` | a does not equal n |
| `assertTrue(condition)` | condition is true |
| `assertFalse(condition)` | condition is false |
| `assertNull(obj)` | obj is null |
| `assertNotNull(obj)` | obj is not null |
| `fail(msg)` | Always fails the test |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Assertions', 'assertEquals', 'assertTrue', 'assertFalse'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we run test cases in parallel using TestNG?',
  'selenium-q96-parallel-execution-testng',
  'Add parallel and thread-count attributes to the suite tag in testng.xml to run tests simultaneously across threads.',
  $$## Running Test Cases in Parallel Using TestNG

TestNG supports parallel execution at **method**, **test**, **class**, or **suite** level. Add two attributes to the `<suite>` tag in `testng.xml`:

```xml
<suite name="MySuite" parallel="{methods|tests|classes}" thread-count="{N}">
```

**Parallel modes:**
- `methods` – Each test method runs in its own thread
- `tests` – Each `<test>` tag in xml runs in its own thread
- `classes` – Each test class runs in its own thread
- `instances` – Each instance of a class runs in its own thread

**Cross-browser parallel example:**

**Java test class:**
```java
import org.testng.Assert;
import org.testng.annotations.*;

public class CrossBrowserTest {

    WebDriver driver = null;

    @Parameters("browser")
    @Test
    public void launchBrowser(String br) {
        if (br.equals("FF")) {
            System.setProperty("webdriver.gecko.driver", "C://Drivers/geckodriver.exe");
            driver = new FirefoxDriver();
        } else if (br.equals("IE")) {
            System.setProperty("webdriver.ie.driver", "C://Drivers/IEDriverServer.exe");
            driver = new InternetExplorerDriver();
        } else if (br.equals("CH")) {
            System.setProperty("webdriver.chrome.driver", "C://Drivers/chromedriver.exe");
            driver = new ChromeDriver();
        }
        driver.get("http://newtours.demoaut.com/");
    }

    @Test(dependsOnMethods = "launchBrowser")
    public void verifyTitle() {
        Assert.assertEquals(driver.getTitle(), "Welcome: Mercury Tours");
    }

    @AfterClass
    public void closeBrowser() {
        driver.quit();
    }
}
```

**testng.xml for parallel cross-browser:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="paralleltesting" parallel="tests" thread-count="5">

  <test name="FirefoxTest">
    <parameter name="browser" value="FF" />
    <classes>
      <class name="parameterization.CrossBrowserTest" />
    </classes>
  </test>

  <test name="ChromeTest">
    <parameter name="browser" value="CH" />
    <classes>
      <class name="parameterization.CrossBrowserTest" />
    </classes>
  </test>

  <test name="IETest">
    <parameter name="browser" value="IE" />
    <classes>
      <class name="parameterization.CrossBrowserTest" />
    </classes>
  </test>

</suite>
```

**Important:** Use `ThreadLocal<WebDriver>` when running in parallel to avoid thread-safety issues:
```java
ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

public WebDriver getDriver() {
    return tlDriver.get();
}
```

**Key points:**
- `parallel="tests"` with `thread-count="3"` runs 3 `<test>` blocks simultaneously
- Combine with Selenium Grid to run on multiple machines
- Always use `ThreadLocal<WebDriver>` for thread-safe parallel execution$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Parallel Execution', 'Cross Browser', 'testng.xml', 'ThreadLocal'], true, 0
);
