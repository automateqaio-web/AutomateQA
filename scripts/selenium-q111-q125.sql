-- Selenium Q111–Q125 | Window, Auth, Groups, XPath, Assert, Popups | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to set the size of a browser window using Selenium?',
  'selenium-q111-set-browser-window-size-selenium',
  'Use driver.manage().window().maximize() to maximize, or setSize(Dimension) to set a specific browser window size in Selenium.',
  $$## Setting Browser Window Size in Selenium

**Maximize the browser window:**
```java
driver.manage().window().maximize();
```

**Get current window size:**
```java
System.out.println(driver.manage().window().getSize());
// Output: (1024, 768)
```

**Set a specific window size using Dimension:**
```java
import org.openqa.selenium.Dimension;

Dimension d = new Dimension(1280, 800);
driver.manage().window().setSize(d);

// Verify
System.out.println(driver.manage().window().getSize());
// Output: (1280, 800)
```

**Set window position:**
```java
import org.openqa.selenium.Point;

driver.manage().window().setPosition(new Point(0, 0));  // Top-left corner
```

**Fullscreen mode:**
```java
driver.manage().window().fullscreen();
```

**Common dimension presets:**
```java
// Mobile viewport
Dimension mobile = new Dimension(375, 812);  // iPhone X
driver.manage().window().setSize(mobile);

// Tablet viewport
Dimension tablet = new Dimension(768, 1024);  // iPad
driver.manage().window().setSize(tablet);

// Desktop
Dimension desktop = new Dimension(1920, 1080);  // Full HD
driver.manage().window().setSize(desktop);
```

**JavascriptExecutor alternative:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("window.resizeTo(1280, 800);");
```

**Full example in test setup:**
```java
@BeforeClass
public void setup() {
    driver = new ChromeDriver();
    driver.manage().window().maximize();
    // OR for responsive testing:
    // driver.manage().window().setSize(new Dimension(375, 812));
}
```

**Key methods summary:**

| Method | Action |
|--------|--------|
| `maximize()` | Maximize to screen size |
| `fullscreen()` | Full-screen mode (F11) |
| `setSize(Dimension)` | Set exact width x height |
| `getSize()` | Get current dimensions |
| `setPosition(Point)` | Move window position |$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Browser Window', 'Dimension', 'maximize', 'setSize'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Can we enter text without using sendKeys() in Selenium?',
  'selenium-q112-enter-text-without-sendkeys-selenium',
  'Yes, use JavascriptExecutor to set an element''s value property directly without using sendKeys().',
  $$## Entering Text Without sendKeys() in Selenium

Yes, we can enter text without `sendKeys()` by using **JavascriptExecutor** to set the element''s `value` property directly via JavaScript.

**Basic example:**
```java
JavascriptExecutor jse = (JavascriptExecutor) driver;
jse.executeScript("document.getElementById(''Login'').value=''Test text without sendkeys''");
```

**Using WebElement reference:**
```java
WebElement inputField = driver.findElement(By.id("username"));

JavascriptExecutor jse = (JavascriptExecutor) driver;
jse.executeScript("arguments[0].value=''myTestUser'';", inputField);
```

**Full test example:**
```java
@Test
public void enterTextWithoutSendKeys() {
    driver.get("https://example.com/login");

    JavascriptExecutor jse = (JavascriptExecutor) driver;

    // Set username via JS
    jse.executeScript(
        "document.getElementById(''username'').value=''admin''"
    );

    // Set password via JS
    jse.executeScript(
        "document.getElementById(''password'').value=''password123''"
    );

    // Click submit button
    driver.findElement(By.id("loginBtn")).click();

    Assert.assertEquals(driver.getTitle(), "Dashboard");
}
```

**When to use JavascriptExecutor instead of sendKeys():**
- Element is read-only but modifiable via JS
- `sendKeys()` fails due to element not being interactable
- Auto-complete dropdowns that interfere with sendKeys
- Performance: setting large amounts of text instantly

**Limitations vs sendKeys():**
- Does NOT trigger keyboard events (`keydown`, `keyup`, `keypress`)
- Some frameworks (React, Angular) require actual keyboard events to update component state
- For input validation listeners, `sendKeys()` is preferred

**Trigger change event after JS value set (for modern frameworks):**
```java
jse.executeScript("arguments[0].value=''newValue'';", element);
jse.executeScript("arguments[0].dispatchEvent(new Event(''change''));", element);
jse.executeScript("arguments[0].dispatchEvent(new Event(''input''));", element);
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'JavascriptExecutor', 'sendKeys', 'Input', 'Text Entry'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How will you login into a site if it shows an authentication popup for username and password?',
  'selenium-q113-handle-authentication-popup-selenium',
  'Use WebDriverWait with ExpectedConditions.alertIsPresent() and then call alert.authenticateUsing(new UserAndPassword()) to handle HTTP auth popups.',
  $$## Handling Authentication Popup in Selenium

HTTP Basic Authentication popups (the browser-native username/password dialog) are not regular HTML elements — they are OS-level dialogs that Selenium handles differently.

**Method 1 — Embed credentials in URL (simplest):**
```java
// Format: http://username:password@website.com
driver.get("http://admin:password@the-internet.herokuapp.com/basic_auth");
```

**Method 2 — WebDriverWait + authenticateUsing:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
Alert alert = wait.until(ExpectedConditions.alertIsPresent());
alert.authenticateUsing(new UserAndPassword("username", "password"));
```

**Full example:**
```java
import org.openqa.selenium.Alert;
import org.openqa.selenium.security.UserAndPassword;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

@Test
public void handleAuthPopup() {
    driver.get("https://the-internet.herokuapp.com/basic_auth");

    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

    // Wait for the auth popup to appear
    Alert alert = wait.until(ExpectedConditions.alertIsPresent());

    // Pass credentials
    alert.authenticateUsing(new UserAndPassword("admin", "admin"));

    // Verify successful login
    Assert.assertTrue(driver.getPageSource().contains("Congratulations"));
}
```

**Method 3 — ChromeOptions with authentication extension:**
```java
// For newer Chrome versions, use DevTools Protocol
ChromeDriver chromeDriver = (ChromeDriver) driver;
Map<String, Object> params = new HashMap<>();
params.put("origin", "https://the-internet.herokuapp.com");
params.put("username", "admin");
params.put("password", "admin");
chromeDriver.executeCdpCommand("Network.setExtraHTTPHeaders", params);
```

**Method 4 — AutoIT (for Windows native dialogs):**
When the popup is truly a Windows OS dialog (not a browser dialog), use AutoIT to handle it externally.

**Comparison:**

| Method | Works for | Notes |
|--------|-----------|-------|
| URL credentials | HTTP Basic Auth | Simplest approach |
| `authenticateUsing()` | Browser auth dialogs | Standard Selenium way |
| AutoIT/Sikuli | OS-level popups | Requires external tool |

**Key point:** Since there will be a popup for logging in, we need to use the explicit command and verify if the alert is actually present. Only if the alert is present, we pass the username and password credentials.$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Authentication', 'Alert', 'HTTP Auth', 'WebDriverWait', 'Popup'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Explain what is Group Test in TestNG.',
  'selenium-q114-group-test-testng',
  'Group tests in TestNG allow you to categorize test methods into named groups and selectively run specific groups via testng.xml.',
  $$## Group Test in TestNG

TestNG allows test methods to be **categorized into groups** using the `groups` attribute in `@Test`. When a group is executed, all methods belonging to that group run.

**Defining groups:**
```java
public class GroupTestExample {

    @Test(groups = { "sanity" })
    public void loginByEmail() {
        System.out.println("this is login by email");
    }

    @Test(groups = { "sanity" })
    public void loginByFacebook() {
        System.out.println("this is login by facebook");
    }

    @Test(groups = { "sanity", "regression" })
    public void signupByEmail() {
        System.out.println("signup by email");
    }

    @Test(groups = { "sanity", "regression" })
    public void signupByFacebook() {
        System.out.println("signup by facebbok");
    }

    @Test(groups = { "regression" })
    public void paymentReturnByBank() {
        System.out.println("payment return by bank");
    }

    @Test(groups = { "regression" })
    public void paymentInDollar() {
        System.out.println("this is payment by dollar method");
    }

    @Test(groups = { "regression" })
    public void paymentInRupees() {
        System.out.println("this is payment by rupees method");
    }
}
```

**Running specific groups via testng.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="Sample Suite">
  <test name="testing">
    <groups>
      <run>
        <include name="regression"/>
        <include name="sanity" />
      </run>
    </groups>
    <classes>
      <class name="GroupingTests.GroupTestExample" />
    </classes>
  </test>
</suite>
```

**Run only sanity tests:**
```xml
<groups>
  <run>
    <include name="sanity"/>
  </run>
</groups>
```

**Exclude a group:**
```xml
<groups>
  <run>
    <include name="regression"/>
    <exclude name="sanity"/>
  </run>
</groups>
```

**Common group naming conventions:**
- `smoke` / `sanity` — quick, critical path tests (~5 minutes)
- `regression` — full regression suite
- `critical` — must-pass tests
- `flaky` — known unstable tests to exclude

**Method-level group annotation:**
```java
@Test(groups = { "sanity", "regression" })
// This test runs when EITHER sanity OR regression group is selected
```

**Key points:**
- A test method can belong to **multiple groups**
- Groups are specified in testng.xml `<include>` and `<exclude>` tags
- Execute a group: `@Test(groups={"aaa"})` + testng.xml with `<include name="aaa"/>`$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Groups', 'Test Groups', 'testng.xml', 'Sanity', 'Regression'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to run failed test cases using TestNG in Selenium WebDriver?',
  'selenium-q115-run-failed-tests-testng',
  'TestNG automatically generates a testng-failed.xml file after a test run. Re-run only the failed tests by executing this XML file.',
  $$## Running Failed Test Cases Using TestNG

After every TestNG test run, if any tests fail, TestNG automatically generates a **`testng-failed.xml`** file inside the `test-output` folder. This file contains only the failed tests.

**Location:** `test-output/testng-failed.xml`

**Generated testng-failed.xml example:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="Failed suite [MySuite]">
  <test name="Failed test [LoginTests]">
    <classes>
      <class name="tests.LoginTest">
        <methods>
          <include name="loginTest"/>
          <include name="dashboardTest"/>
        </methods>
      </class>
    </classes>
  </test>
</suite>
```

**How to re-run failed tests:**

**Option 1 — Run testng-failed.xml directly:**
Right-click `test-output/testng-failed.xml` → Run As → TestNG Suite

**Option 2 — Maven command:**
```bash
mvn test -DsuiteXmlFile=test-output/testng-failed.xml
```

**Option 3 — Programmatically re-run:**
```java
TestNG testNG = new TestNG();
testNG.setTestSuites(Arrays.asList("test-output/testng-failed.xml"));
testNG.run();
```

**Option 4 — RetryAnalyzer (auto-retry on failure):**
```java
import org.testng.IRetryAnalyzer;
import org.testng.ITestResult;

public class RetryAnalyzer implements IRetryAnalyzer {
    private int count = 0;
    private static final int MAX_RETRY = 2;

    @Override
    public boolean retry(ITestResult result) {
        if (count < MAX_RETRY) {
            count++;
            return true;  // Retry the test
        }
        return false;
    }
}

// Apply to test:
@Test(retryAnalyzer = RetryAnalyzer.class)
public void flakeyTest() { }
```

**Workflow:**
1. Run full suite → some tests fail
2. TestNG generates `test-output/testng-failed.xml`
3. Re-run with `testng-failed.xml` → only failed tests execute
4. Continue until all pass

**Key point:** By using `testng-failed.xml`, you save time by not re-running passing tests — only the failures are re-executed.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Failed Tests', 'testng-failed.xml', 'RetryAnalyzer', 'Rerun'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Stale Element Exception and how to handle it?',
  'selenium-q116-stale-element-exception-selenium',
  'StaleElementReferenceException occurs when a WebElement reference becomes invalid because the DOM was updated after the element was located.',
  $$## Stale Element Exception in Selenium

**Stale** means old, decayed, or no longer fresh.

**StaleElementReferenceException** is thrown when a `WebElement` object you previously found no longer exists in the DOM, typically because:
- The page was refreshed
- An AJAX call updated the DOM
- Navigation occurred after finding the element
- The element was removed and re-added to the DOM

**How it happens:**
```java
WebElement element = driver.findElement(By.id("myElement"));
// Page refreshes or DOM updates...
element.click();  // StaleElementReferenceException thrown here!
```

**Solution 1 — Re-find the element:**
```java
// Instead of caching the element, find it fresh each time
driver.findElement(By.id("myElement")).click();
```

**Solution 2 — Catch and re-find:**
```java
try {
    WebElement element = driver.findElement(By.id("myElement"));
    element.click();
} catch (StaleElementReferenceException e) {
    // Re-find and retry
    driver.findElement(By.id("myElement")).click();
}
```

**Solution 3 — Retry loop:**
```java
int maxRetries = 3;
for (int i = 0; i < maxRetries; i++) {
    try {
        WebElement element = driver.findElement(By.id("myElement"));
        element.click();
        break;  // Success — exit loop
    } catch (StaleElementReferenceException e) {
        if (i == maxRetries - 1) throw e;
        Thread.sleep(500);
    }
}
```

**Solution 4 — Wait for element to be fresh:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement element = wait.until(
    ExpectedConditions.refreshed(
        ExpectedConditions.elementToBeClickable(By.id("myElement"))
    )
);
element.click();
```

**Solution 5 — Use ExpectedConditions.stalenessOf():**
```java
WebElement element = driver.findElement(By.id("myElement"));

// Wait for the stale element to disappear, then re-find
wait.until(ExpectedConditions.stalenessOf(element));
element = driver.findElement(By.id("myElement"));
element.click();
```

**Common scenarios causing StaleElementException:**

| Scenario | Why it happens |
|----------|---------------|
| Page refresh | Old element reference invalid |
| AJAX/dynamic content | DOM modified, element re-rendered |
| Navigation (back/forward) | New page, old references invalid |
| Angular/React re-render | Component re-created after state change |

**Best practice:** Avoid caching `WebElement` objects across interactions that might change the DOM. Prefer calling `driver.findElement()` immediately before each interaction.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'StaleElementReferenceException', 'DOM', 'Exception Handling', 'AJAX'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are different XPath functions you have used in your Selenium project?',
  'selenium-q117-xpath-functions-selenium-project',
  'Commonly used XPath functions in Selenium include contains(), starts-with(), text(), and logical operators OR (|) and AND.',
  $$## XPath Functions Used in Selenium Projects

XPath functions make locators more flexible and dynamic, handling elements with partial or changing attribute values.

**1. contains() — Partial attribute match:**
Matches elements where the attribute contains a given substring.
```java
// Find element where id contains "log"
driver.findElement(By.xpath("//*[contains(@id, 'log')]"));

// Find button where text contains "Sign"
driver.findElement(By.xpath("//button[contains(text(), 'Sign')]"));

// Dynamic class name
driver.findElement(By.xpath("//div[contains(@class, 'nav-item')]"));
```

**2. text() — Match by visible text:**
Matches elements with exact or partial visible text.
```java
// Exact text match
driver.findElement(By.xpath("//a[text()='Click Here']"));

// With contains for partial text
driver.findElement(By.xpath("//p[contains(text(), 'Welcome')]"));

// Heading with specific text
driver.findElement(By.xpath("//h2[text()='Login']"));
```

**3. starts-with() — Match beginning of attribute:**
Useful when an attribute starts with a known prefix but ends dynamically.
```java
// ID starts with "user_"
driver.findElement(By.xpath("//*[starts-with(@id, 'user_')]"));

// Name attribute starts with "login"
driver.findElement(By.xpath("//input[starts-with(@name, 'login')]"));
```

**4. OR operator (|) — Multiple conditions:**
Match elements that satisfy either condition.
```java
// Element with class "btn" OR id "submit"
driver.findElements(By.xpath("//*[@class='btn' or @id='submit']"));

// Multiple possible text values
driver.findElement(By.xpath("//button[text()='Login' or text()='Sign In']"));
```

**5. AND operator — Multiple conditions:**
Match elements that satisfy all conditions.
```java
// Input with type="text" AND placeholder="Username"
driver.findElement(By.xpath("//input[@type='text' and @placeholder='Username']"));

// Link with specific class AND text
driver.findElement(By.xpath("//a[@class='nav-link' and text()='Home']"));
```

**Combined functions:**
```java
// contains + starts-with
driver.findElement(By.xpath("//input[starts-with(@id, 'user') and contains(@class, 'form')]"));

// Text with contains + and
driver.findElement(By.xpath("//div[@class='item' and contains(text(), 'Product')]"));
```

**Quick reference:**

| Function | Syntax | Use case |
|----------|--------|----------|
| `contains()` | `contains(@attr, 'val')` | Partial attribute value |
| `text()` | `text()='value'` | Exact visible text |
| `starts-with()` | `starts-with(@attr, 'prefix')` | Dynamic ID/name prefix |
| `or` | `@a='x' or @b='y'` | Either condition |
| `and` | `@a='x' and @b='y'` | Both conditions |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'contains()', 'starts-with()', 'text()', 'XPath Functions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What will happen in the background when you execute new FirefoxDriver()?',
  'selenium-q118-new-firefoxdriver-background',
  'new FirefoxDriver() triggers the Firefox binary, opens the browser with default options, and creates a FirefoxDriver object connected via geckodriver.',
  $$## What Happens When You Execute new FirefoxDriver()

When you call `new FirefoxDriver()`, the following sequence happens in the background:

**Step-by-step execution:**

1. **geckodriver is located** — Selenium finds the geckodriver executable via `System.setProperty("webdriver.gecko.driver", "path/to/geckodriver")`

2. **geckodriver process starts** — A new geckodriver process is launched on a local port (e.g., 4444 or random)

3. **Firefox binary is triggered** — geckodriver launches the Firefox browser executable with default options

4. **New browser window opens** — A fresh Firefox browser window appears with no extensions, no cookies, no history (clean profile)

5. **FirefoxDriver object is created** — Java creates a `FirefoxDriver` instance that holds a connection to this browser via the WebDriver protocol (W3C JSON Wire Protocol)

6. **Session is established** — A unique session ID is created, allowing commands to be routed to that specific browser instance

**Code sequence:**
```java
System.setProperty("webdriver.gecko.driver", "C://Drivers/geckodriver.exe");
// Step 1: Points to geckodriver binary

WebDriver driver = new FirefoxDriver();
// Steps 2-6: geckodriver launches → Firefox opens → connection established

driver.get("https://example.com");
// HTTP command sent via geckodriver to Firefox
```

**Architecture:**
```
Java Test ←→ geckodriver ←→ Firefox Browser
(sends W3C commands) (translates to Marionette protocol)
```

**Summary:**
- Firefox binary is triggered
- Firefox browser opens with default options
- FirefoxDriver object is created and connected to the browser
- The driver is ready to receive commands$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'FirefoxDriver', 'WebDriver', 'geckodriver', 'Browser Launch'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What does the statement WebDriver driver = new FirefoxDriver() mean?',
  'selenium-q119-webdriver-driver-new-firefoxdriver-meaning',
  'WebDriver is an interface. driver is a reference variable of WebDriver type. new FirefoxDriver() creates the actual FirefoxDriver object — this enables polymorphism for cross-browser switching.',
  $$## Understanding WebDriver driver = new FirefoxDriver()

This statement uses **interface reference and object polymorphism** — a core Java OOP concept.

**Breaking it down:**
```
WebDriver   driver   =   new FirefoxDriver();
↑           ↑               ↑
Interface   Reference var   Actual object created
(type)      (name)          (implementation)
```

**WebDriver is an interface:**
```java
public interface WebDriver {
    void get(String url);
    String getTitle();
    String getCurrentUrl();
    WebElement findElement(By by);
    List<WebElement> findElements(By by);
    // ... many more abstract methods
}
```

**FirefoxDriver implements WebDriver:**
```java
public class FirefoxDriver implements WebDriver {
    // Implements all abstract methods from WebDriver interface
    @Override
    public void get(String url) { /* Firefox-specific implementation */ }
    @Override
    public String getTitle() { /* Firefox-specific implementation */ }
    // ...
}
```

**Why use WebDriver type instead of FirefoxDriver type?**

```java
// Option 1 - WebDriver type (PREFERRED)
WebDriver driver = new FirefoxDriver();
// Can reassign to any browser implementation:
driver = new ChromeDriver();   // Works!
driver = new SafariDriver();   // Works!

// Option 2 - FirefoxDriver type (LIMITING)
FirefoxDriver driver = new FirefoxDriver();
// Cannot reassign to other browsers easily
```

**Cross-browser switching with WebDriver type:**
```java
WebDriver driver;

String browser = System.getProperty("browser", "chrome");

if (browser.equals("firefox")) {
    driver = new FirefoxDriver();
} else if (browser.equals("ie")) {
    driver = new InternetExplorerDriver();
} else {
    driver = new ChromeDriver();
}

// driver.get() works identically regardless of browser
driver.get("https://example.com");
```

**Key concept:**
`WebDriver` is an interface containing several abstract methods such as `get()`, `findElement()` etc. We create a reference to the WebDriver interface, and we can assign objects (FirefoxDriver, ChromeDriver, IEDriver, AndroidDriver) to it — enabling polymorphism for cross-browser testing.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'Interface', 'Polymorphism', 'FirefoxDriver', 'Cross Browser'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How do you handle inner Frames and Adjacent Frames in Selenium?',
  'selenium-q120-handle-inner-adjacent-frames-selenium',
  'Use driver.switchTo().frame() to enter frames, and driver.switchTo().defaultContent() to return to the main page. For nested frames, switch to each level sequentially.',
  $$## Handling Inner and Adjacent Frames in Selenium

**switchTo().frame()** moves WebDriver''s focus into an iframe so you can interact with its contents.

**Types of frames:**
1. **Adjacent frames** — Multiple iframes at the same level in the DOM
2. **Inner/nested frames** — An iframe inside another iframe

**Switching to a frame:**
```java
// By index (0-based)
driver.switchTo().frame(0);

// By name or id attribute
driver.switchTo().frame("frameName");
driver.switchTo().frame("frameId");

// By WebElement
WebElement frame = driver.findElement(By.id("myFrame"));
driver.switchTo().frame(frame);
```

**Working with adjacent frames:**
```java
// Switch to first iframe and interact
driver.switchTo().frame("frame1");
driver.findElement(By.id("element1")).click();

// Return to main page, then switch to adjacent frame
driver.switchTo().defaultContent();  // Back to main document
driver.switchTo().frame("frame2");
driver.findElement(By.id("element2")).sendKeys("text");

// Return to main page when done
driver.switchTo().defaultContent();
```

**Working with nested (inner) frames:**
```java
// Switch to outer frame
driver.switchTo().frame("outerFrame");

// Switch to inner frame (inside outerFrame)
driver.switchTo().frame("innerFrame");

// Interact with inner frame content
driver.findElement(By.id("innerElement")).click();

// Return to parent frame (one level up)
driver.switchTo().parentFrame();

// Or return all the way to main document
driver.switchTo().defaultContent();
```

**Full practical example:**
```java
@Test
public void handleFrames() {
    driver.get("https://example.com/page-with-frames");

    // Verify we''re on main page
    Assert.assertEquals(driver.getTitle(), "Main Page");

    // Switch to frame1 (adjacent)
    driver.switchTo().frame("frame1");
    String frameText = driver.findElement(By.tagName("p")).getText();
    Assert.assertEquals(frameText, "Frame 1 content");

    // Move to main page, then frame2 (adjacent)
    driver.switchTo().defaultContent();
    driver.switchTo().frame("frame2");

    // Switch to nested iframe inside frame2
    driver.switchTo().frame("nestedFrame");
    driver.findElement(By.id("nestedBtn")).click();

    // Return to main document
    driver.switchTo().defaultContent();
}
```

**Key methods:**

| Method | Action |
|--------|--------|
| `switchTo().frame(0)` | Switch by index |
| `switchTo().frame("name")` | Switch by name/id |
| `switchTo().frame(element)` | Switch by WebElement |
| `switchTo().parentFrame()` | Go one level up |
| `switchTo().defaultContent()` | Return to main document |

**Important:** Always return to `defaultContent()` when done with frames — otherwise subsequent `findElement()` calls will still search inside the last frame.$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Frames', 'iFrame', 'switchTo', 'defaultContent', 'Nested Frames'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to click on an element which is not visible using Selenium WebDriver?',
  'selenium-q121-click-invisible-element-selenium',
  'Use JavascriptExecutor to click elements that are hidden, off-screen, or not interactable through normal WebDriver click.',
  $$## Clicking an Invisible Element Using JavascriptExecutor

When an element is not visible or interactable via normal `click()`, use `JavascriptExecutor` to click it directly via JavaScript.

**Basic approach:**
```java
WebElement element = driver.findElement(By.id("gbqfd"));
JavascriptExecutor executor = (JavascriptExecutor) driver;
executor.executeScript("arguments[0].click();", element);
```

**Full example:**
```java
@Test
public void clickHiddenElement() {
    driver.get("https://example.com");

    // Find the element (even if hidden)
    WebElement hiddenBtn = driver.findElement(By.id("hiddenButton"));

    // Click via JavaScript
    JavascriptExecutor js = (JavascriptExecutor) driver;
    js.executeScript("arguments[0].click();", hiddenBtn);

    // Verify action was taken
    Assert.assertEquals(driver.getTitle(), "Result Page");
}
```

**Make element visible first, then click:**
```java
WebElement element = driver.findElement(By.id("hiddenElement"));
JavascriptExecutor js = (JavascriptExecutor) driver;

// Make visible via JS
js.executeScript("arguments[0].style.display='block';", element);
js.executeScript("arguments[0].style.visibility='visible';", element);
js.executeScript("arguments[0].removeAttribute('hidden');", element);

// Now click normally or via JS
element.click();
```

**Scroll into view then click:**
```java
WebElement element = driver.findElement(By.id("offScreenElement"));
JavascriptExecutor js = (JavascriptExecutor) driver;

// Scroll element into viewport
js.executeScript("arguments[0].scrollIntoView(true);", element);

// Wait for it to be clickable
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
wait.until(ExpectedConditions.elementToBeClickable(element));
element.click();
```

**When to use JS click:**
- Element is `display:none` or `visibility:hidden`
- Element is behind an overlay/modal
- Element is outside the viewport
- Element returns `ElementNotInteractableException`
- Fixed banners/headers covering the element

**JS click vs normal click:**

| Aspect | Normal click() | JS click |
|--------|---------------|----------|
| Visibility required | Yes | No |
| Events fired | mousedown, mouseup, click | click only |
| Best for | Visible elements | Hidden/overlapping elements |
| Reliability | Higher | Use when normal click fails |$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'JavascriptExecutor', 'Hidden Element', 'Click', 'ElementNotInteractable'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between verify and assert in Selenium TestNG?',
  'selenium-q122-verify-vs-assert-selenium-testng',
  'Assert stops test execution on failure. Verify (soft assert) continues executing the test and reports all failures at the end via assertAll().',
  $$## Verify vs Assert in Selenium TestNG

**Assert (Hard Assertion):**
Checks a condition. If it **fails**, the test method **stops immediately** — no further code executes.

```java
Assert.assertEquals(driver.getTitle(), "Home Page");
// If this fails, all code below is NOT executed
System.out.println("This line is skipped if assertion failed");
```

**Verify (Soft Assertion — SoftAssert):**
Checks a condition. If it **fails**, the test method **continues** executing. All failures are collected and reported together at the end via `assertAll()`.

```java
SoftAssert sa = new SoftAssert();

sa.assertEquals(driver.getTitle(), "Home Page");
// Even if this fails, execution continues

System.out.println("This line IS executed even if assertion above failed");

sa.assertTrue(element.isDisplayed());

sa.assertAll();  // Reports all failures here
```

**Side-by-side comparison:**
```java
@Test
public void hardAssertTest() {
    Assert.assertEquals(1, 2);  // FAILS → test stops
    System.out.println("Never reached");
}

@Test
public void softAssertTest() {
    SoftAssert sa = new SoftAssert();
    sa.assertEquals(1, 2);      // FAILS → but continues
    System.out.println("This IS printed");
    sa.assertEquals(3, 3);      // PASSES
    sa.assertAll();             // Reports: 1 failure
}
```

**Summary table:**

| Feature | Assert (Hard) | Verify (SoftAssert) |
|---------|--------------|---------------------|
| On failure | **Stops** test immediately | **Continues** test |
| Reports | First failure only | ALL failures |
| Class | `Assert` | `SoftAssert` |
| End call needed | No | Yes — `assertAll()` |
| TestNG behavior | Test = FAILED (immediately) | Test = FAILED at `assertAll()` |

**When to use which:**

| Scenario | Use |
|----------|-----|
| Critical step (login must pass to continue) | Assert |
| UI validation (check multiple elements) | Verify (SoftAssert) |
| Sequential dependencies | Assert |
| Independent checks on same page | Verify (SoftAssert) |

**Key rule:** Always call `sa.assertAll()` at the end of a soft assert test — without it, failures are silently ignored and the test passes incorrectly.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Assert', 'Verify', 'SoftAssert', 'Hard Assert'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the use of @FindBy annotation in TestNG/Selenium?',
  'selenium-q123-findbyas-annotation-selenium',
  '@FindBy is a PageFactory annotation used to locate WebElements in the Page Object Model, replacing driver.findElement() calls with cleaner field declarations.',
  $$## @FindBy Annotation in Selenium

`@FindBy` is an annotation from Selenium''s `PageFactory` class used in the **Page Object Model (POM)** to identify and initialize web elements.

**Basic usage:**
```java
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LoginPage {

    @FindBy(id = "username")
    WebElement usernameField;

    @FindBy(name = "password")
    WebElement passwordField;

    @FindBy(xpath = "//button[@type='submit']")
    WebElement loginButton;

    @FindBy(css = ".error-message")
    WebElement errorMessage;

    public LoginPage(WebDriver driver) {
        PageFactory.initElements(driver, this);
        // @FindBy elements are initialized here
    }

    public void login(String user, String pass) {
        usernameField.sendKeys(user);
        passwordField.sendKeys(pass);
        loginButton.click();
    }
}
```

**Supported locator strategies:**
```java
@FindBy(id = "elementId")
@FindBy(name = "elementName")
@FindBy(className = "css-class")
@FindBy(tagName = "input")
@FindBy(linkText = "Click Here")
@FindBy(partialLinkText = "Click")
@FindBy(css = "div.container > input")
@FindBy(xpath = "//div[@class='content']")
```

**Multiple locators with @FindBys (AND logic):**
```java
// Finds element with id="search" AND class="active"
@FindBys({
    @FindBy(id = "search"),
    @FindBy(className = "active")
})
WebElement searchBox;
```

**Multiple locators with @FindAll (OR logic):**
```java
// Finds all elements matching EITHER locator
@FindAll({
    @FindBy(id = "btn1"),
    @FindBy(className = "submit-btn")
})
List<WebElement> buttons;
```

**@FindBy vs driver.findElement():**

| Feature | @FindBy (PageFactory) | driver.findElement() |
|---------|----------------------|---------------------|
| Code readability | Cleaner, declarative | Verbose, inline |
| Element caching | Lazy (found when used) | Immediate |
| POM integration | Standard approach | Used anywhere |
| StaleElement risk | Higher (cached) | Lower (re-found each time) |

**Key point:** `@FindBy` is used to identify elements in the **Page Factory** approach to POM. Elements are initialized by calling `PageFactory.initElements(driver, this)` in the page constructor.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', '@FindBy', 'PageFactory', 'POM', 'Page Object Model', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Do you use Thread.sleep() in Selenium? When?',
  'selenium-q124-thread-sleep-selenium',
  'Thread.sleep() should be used rarely — only as a last resort when no explicit wait or event-based wait can handle the timing requirement.',
  $$## Thread.sleep() in Selenium — When to Use It

**Short answer: Rarely.**

`Thread.sleep(milliseconds)` is a **static wait** that pauses the entire thread for a fixed duration, regardless of whether the application is ready or not.

**Why it''s bad practice:**
```java
// BAD — wastes time if page loads in 1s but sleep is 5s
Thread.sleep(5000);
driver.findElement(By.id("element")).click();

// What if the page takes 6s on a slow CI machine? It still fails!
```

**Problems with Thread.sleep:**
- **Wastes time** — always waits the full duration even if ready sooner
- **Fragile** — fails if the wait is too short on slow environments
- **Not synchronized** — doesn''t respond to application state
- **Hard-coded** — each machine''s speed differs

**Use WebDriverWait instead (almost always):**
```java
// GOOD — waits up to 10s, proceeds as soon as element is ready
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement element = wait.until(
    ExpectedConditions.elementToBeClickable(By.id("submitBtn"))
);
element.click();
```

**When Thread.sleep() is acceptable (rare cases):**
```java
// 1. Waiting for animation to complete (no DOM event to listen to)
driver.findElement(By.id("menuToggle")).click();
Thread.sleep(500);  // Wait for CSS animation (300ms) to finish
driver.findElement(By.id("menuItem")).click();

// 2. Debugging — to slow down test visually
Thread.sleep(2000);  // Pause to observe browser state

// 3. Rate limiting — avoid overwhelming a slow external API
for (String url : urlList) {
    driver.get(url);
    Thread.sleep(1000);  // Throttle requests
}
```

**Wait hierarchy (best to worst):**

| Wait Type | Use Case | Rating |
|-----------|----------|--------|
| `WebDriverWait` (Explicit) | Specific element condition | Best |
| `FluentWait` | Custom polling + ignore exceptions | Best |
| `ImplicitWait` | Global default wait | OK |
| `Thread.sleep()` | Fixed pause, no event | Last resort |

**Key answer:** Use `Thread.sleep()` **rarely** — prefer explicit waits that respond to actual application state. The only valid uses are animations, debugging, or situations where no DOM event signals readiness.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Thread.sleep', 'WebDriverWait', 'Waits', 'Synchronization', 'Best Practices'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are different types of pop-ups you have handled in Selenium projects?',
  'selenium-q125-popup-types-selenium',
  'Selenium handles JavaScript alerts, browser popups, and native OS popups using different techniques: Alert API, Browser Profiles, AutoIT, Sikuli, and Robot class.',
  $$## Types of Pop-ups Handled in Selenium Projects

**1. JavaScript Pop-ups (Alert, Confirm, Prompt):**
Native browser dialogs triggered by JavaScript. Handled via Selenium''s `Alert` API.

```java
// Simple alert
Alert alert = driver.switchTo().alert();
alert.accept();  // Click OK

// Confirm dialog
Alert confirm = driver.switchTo().alert();
System.out.println(confirm.getText());
confirm.dismiss();  // Click Cancel

// Prompt dialog
Alert prompt = driver.switchTo().alert();
prompt.sendKeys("My input");
prompt.accept();
```

**2. Browser Authentication Pop-ups (HTTP Basic Auth):**
Browser-native authentication dialogs — not HTML elements.
```java
// Method 1: Embed in URL
driver.get("http://admin:password@the-internet.herokuapp.com/basic_auth");

// Method 2: Alert API
Alert alert = new WebDriverWait(driver, Duration.ofSeconds(10))
    .until(ExpectedConditions.alertIsPresent());
alert.authenticateUsing(new UserAndPassword("admin", "admin"));
```

**3. Browser Pop-up Windows:**
New browser windows or tabs opened by the application.
```java
// Get all window handles
String mainWindow = driver.getWindowHandle();
Set<String> handles = driver.getWindowHandles();

for (String handle : handles) {
    if (!handle.equals(mainWindow)) {
        driver.switchTo().window(handle);
        // Interact with popup window
        driver.close();
    }
}
driver.switchTo().window(mainWindow);
```

**4. Native OS Pop-ups (Windows dialogs):**
File download/upload dialogs, Windows Security dialogs — outside browser control.
- **AutoIT** — Windows automation scripting tool
- **Sikuli** — Image-based automation
- **Robot class** — Java''s built-in keyboard/mouse simulation

```java
// Robot class for keyboard input on OS dialog
Robot robot = new Robot();
robot.keyPress(KeyEvent.VK_ENTER);  // Press Enter
robot.keyRelease(KeyEvent.VK_ENTER);
```

**5. Browser Profile-based Pop-up Suppression:**
Pre-configure browser to automatically handle certain pop-ups.
```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--disable-notifications");  // Block notification pop-ups
options.addArguments("--disable-popup-blocking");

// For file download — suppress download dialog
HashMap<String, Object> prefs = new HashMap<>();
prefs.put("download.prompt_for_download", false);
prefs.put("download.default_directory", "C:\\Downloads");
options.setExperimentalOption("prefs", prefs);
```

**Summary table:**

| Pop-up Type | Method |
|-------------|--------|
| JS Alert/Confirm/Prompt | `driver.switchTo().alert()` |
| Browser window/tab | `driver.switchTo().window(handle)` |
| HTTP Auth dialog | URL credentials / `authenticateUsing()` |
| File upload/download | Robot class / AutoIT / Sikuli |
| Notification requests | ChromeOptions `--disable-notifications` |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Popups', 'Alert', 'AutoIT', 'Sikuli', 'Robot Class', 'Browser Window'], true, 0
);
