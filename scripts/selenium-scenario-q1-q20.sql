-- Selenium Scenario-Based Interview Questions (20 questions)
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Scenario 1
(
  'How do you handle dynamic elements in Selenium?',
  'selenium-scenario-q1-handle-dynamic-elements',
  'Use XPath with contains() or starts-with() for dynamic IDs, combined with WebDriverWait to stabilize before interacting.',
  $ans$
## Handling Dynamic Elements in Selenium

Dynamic elements have attributes (id, class, name) that change on every page load — making static locators break. Here are the strategies to handle them:

### Strategy 1 — XPath with contains()

```java
// Element whose id changes like "btn_123", "btn_456"
WebElement btn = driver.findElement(
    By.xpath("//button[contains(@id, 'btn_')]")
);

// Element whose class partially matches
WebElement el = driver.findElement(
    By.xpath("//div[contains(@class, 'active-item')]")
);
```

### Strategy 2 — starts-with()

```java
// id="product_2024_item" — prefix is stable
WebElement item = driver.findElement(
    By.xpath("//li[starts-with(@id, 'product_')]")
);
```

### Strategy 3 — XPath by visible text

```java
// Locate by what the user sees, not a dynamic attribute
WebElement link = driver.findElement(
    By.xpath("//a[text()='View Details']")
);

// Partial text match
WebElement btn = driver.findElement(
    By.xpath("//button[contains(text(),'Submit')]")
);
```

### Strategy 4 — WebDriverWait to stabilize

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

WebElement el = wait.until(
    ExpectedConditions.visibilityOfElementLocated(
        By.xpath("//div[contains(@class,'loaded')]")
    )
);
```

### Strategy 5 — CSS attribute selector

```java
// Match data-* attributes that are stable even when id changes
WebElement el = driver.findElement(
    By.cssSelector("[data-testid='submit-button']")
);
```

### Best Practice — Ask Dev for data-testid
The most reliable fix: ask developers to add stable `data-testid` or `data-qa` attributes specifically for automation. This decouples test locators from UI implementation details.

### Quick Decision Tree
- Partial id/class → `contains()` or `starts-with()`
- Visible text → `text()` or `contains(text(), '')`
- Loading race → `WebDriverWait` + `ExpectedConditions`
- Random attribute → `data-testid` from dev
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Dynamic Elements','XPath','contains()','starts-with()','WebDriverWait','Locators'],
  true, 0
),

-- Scenario 2
(
  'You click a button but nothing happens in Selenium. How do you debug it?',
  'selenium-scenario-q2-click-button-nothing-happens-debug',
  'Check for iframe context, JavaScript blockers, element visibility, and use Actions or JavascriptExecutor as fallback click strategies.',
  $ans$
## Debugging: Button Click Has No Effect

When `element.click()` does nothing, work through these causes systematically:

### Check 1 — Is it inside an iframe?

```java
// Try switching to iframe first
driver.switchTo().frame("frameName");
driver.findElement(By.id("myButton")).click();
driver.switchTo().defaultContent(); // switch back
```

### Check 2 — Is element actually clickable?

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement btn = wait.until(
    ExpectedConditions.elementToBeClickable(By.id("submitBtn"))
);
btn.click();
```

### Check 3 — Is another element covering it?

```java
// Scroll element into view first
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].scrollIntoView({block:'center'});", btn);
btn.click();
```

### Check 4 — Use JavascriptExecutor click

```java
// Bypasses overlays, CSS pointer-events:none, and visibility issues
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].click();", btn);
```

### Check 5 — Use Actions class

```java
// Simulates real mouse movement + click
Actions actions = new Actions(driver);
actions.moveToElement(btn).click().perform();
```

### Check 6 — Check for JS errors in console

```java
// Read browser console logs
LogEntries logs = driver.manage().logs().get(LogType.BROWSER);
for (LogEntry entry : logs) {
    System.out.println(entry.getMessage());
}
```

### Debug Checklist

| Check | How |
|---|---|
| Inside iframe? | `driver.switchTo().frame()` |
| Element covered? | Scroll into view |
| Not clickable yet? | `elementToBeClickable` wait |
| JS event listener? | `js.executeScript("click()")` |
| Overlay/modal? | Close overlay first |
| Wrong window? | `driver.switchTo().window()` |
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Click','Debug','iframe','JavascriptExecutor','Actions','Troubleshooting'],
  true, 0
),

-- Scenario 3
(
  'How do you test a dropdown built with custom HTML instead of <select>?',
  'selenium-scenario-q3-custom-html-dropdown-not-select',
  'Skip the Select class — click to expand the custom dropdown, then locate and click the desired option using XPath or CSS.',
  $ans$
## Handling Custom HTML Dropdowns (Non-<select>)

Many modern UIs (React, Angular, Material UI) build dropdowns using `<div>`, `<ul>`, `<li>` instead of native `<select>`. The Selenium `Select` class only works with native `<select>` — use this approach for custom ones:

### Step-by-Step Approach

```java
// Step 1: Click the dropdown trigger to expand it
WebElement dropdown = driver.findElement(By.cssSelector(".dropdown-trigger"));
dropdown.click();

// Step 2: Wait for options to appear
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
wait.until(ExpectedConditions.visibilityOfElementLocated(
    By.cssSelector(".dropdown-menu")
));

// Step 3: Click the desired option by visible text
WebElement option = driver.findElement(
    By.xpath("//ul[@class='dropdown-menu']//li[text()='India']")
);
option.click();
```

### Generic Reusable Method

```java
public void selectFromCustomDropdown(String dropdownLocator, String optionText) {
    // Open dropdown
    driver.findElement(By.cssSelector(dropdownLocator)).click();

    // Wait for options list
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
    wait.until(ExpectedConditions.visibilityOfElementLocated(
        By.xpath("//li[normalize-space(text())='" + optionText + "']")
    ));

    // Click matching option
    driver.findElement(
        By.xpath("//li[normalize-space(text())='" + optionText + "']")
    ).click();
}

// Usage
selectFromCustomDropdown(".country-dropdown", "India");
```

### If Options Are Dynamically Filtered (Search Dropdown)

```java
// Type in the search box inside the dropdown
WebElement searchBox = driver.findElement(By.cssSelector(".dropdown-search"));
searchBox.sendKeys("India");

// Wait for filtered results and click
wait.until(ExpectedConditions.visibilityOfElementLocated(
    By.xpath("//li[contains(text(),'India')]")
)).click();
```

### Key Rule
- Native `<select>` → use `Select` class
- Custom div/ul/li dropdown → click trigger → wait → click option
- Search-based dropdown → type to filter → click result
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Custom Dropdown','Select Class','XPath','CSS','WebDriverWait','React','Angular'],
  true, 0
),

-- Scenario 4
(
  'Multiple browser windows open in Selenium. How do you handle them?',
  'selenium-scenario-q4-multiple-windows-handle-selenium',
  'Use getWindowHandles() to get all window IDs, loop through them, and switchTo().window() to control the desired one.',
  $ans$
## Handling Multiple Browser Windows in Selenium

When an action opens a new browser window or tab, WebDriver stays focused on the original window. You must explicitly switch to the new one.

### Get All Window Handles

```java
// Store the original window handle
String mainWindow = driver.getWindowHandle();

// Click something that opens a new window
driver.findElement(By.id("openNewWindow")).click();

// Get all window handles
Set<String> allWindows = driver.getWindowHandles();

// Switch to the new window
for (String window : allWindows) {
    if (!window.equals(mainWindow)) {
        driver.switchTo().window(window);
        break;
    }
}

// Now work in the new window
System.out.println("New window title: " + driver.getTitle());
driver.findElement(By.id("someElement")).click();

// Close new window and switch back to main
driver.close();
driver.switchTo().window(mainWindow);
```

### Wait for New Window to Open

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.numberOfWindowsToBe(2));

Set<String> handles = driver.getWindowHandles();
```

### Reusable Helper Method

```java
public void switchToNewWindow(String mainWindowHandle) {
    Set<String> allHandles = driver.getWindowHandles();
    for (String handle : allHandles) {
        if (!handle.equals(mainWindowHandle)) {
            driver.switchTo().window(handle);
            return;
        }
    }
}

public void switchToWindowByTitle(String title) {
    for (String handle : driver.getWindowHandles()) {
        driver.switchTo().window(handle);
        if (driver.getTitle().equals(title)) return;
    }
}
```

### Key Methods

| Method | Purpose |
|---|---|
| `getWindowHandle()` | Current window ID |
| `getWindowHandles()` | All open window IDs (Set) |
| `switchTo().window(handle)` | Switch focus to a window |
| `driver.close()` | Close current window |
| `driver.quit()` | Close all windows + quit driver |

> **Note:** `getWindowHandles()` returns a `Set` — order is not guaranteed in older browsers. Use title-based switching when order matters.
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Multiple Windows','getWindowHandles','switchTo','Browser Tabs','Window Handle'],
  true, 0
),

-- Scenario 5
(
  'Your Selenium script works locally but fails in CI/CD. How do you fix it?',
  'selenium-scenario-q5-works-locally-fails-cicd',
  'Check headless mode issues, timing/wait differences, browser version mismatches, and file path problems specific to the CI environment.',
  $ans$
## Script Works Locally but Fails in CI/CD — Diagnosis Guide

This is one of the most common real-world Selenium problems. Work through these causes in order:

### Root Cause 1 — Missing Headless Mode

CI servers have no display. You must run headless:

```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless=new");
options.addArguments("--no-sandbox");            // required in Docker/Linux
options.addArguments("--disable-dev-shm-usage"); // prevents memory crashes
options.addArguments("--disable-gpu");
options.addArguments("--window-size=1920,1080"); // headless has no screen size

WebDriver driver = new ChromeDriver(options);
```

### Root Cause 2 — Timing / Waits

CI machines are slower than your dev machine. Replace all `Thread.sleep()` with proper waits:

```java
// Bad
Thread.sleep(3000);

// Good
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("result")));
```

### Root Cause 3 — Browser/Driver Version Mismatch

Pin versions in CI to match what's installed:

```java
// Use WebDriverManager to auto-manage driver versions
WebDriverManager.chromedriver().setup();
WebDriver driver = new ChromeDriver();
```

Or in `pom.xml`:
```xml
<dependency>
    <groupId>io.github.bonigarcia</groupId>
    <artifactId>webdrivermanager</artifactId>
    <version>5.7.0</version>
</dependency>
```

### Root Cause 4 — File Paths

Local absolute paths break in CI:

```java
// Bad
String filePath = "C:\\Users\\nagen\\test.csv";

// Good — relative to project root
String filePath = System.getProperty("user.dir") + "/src/test/resources/test.csv";
```

### Root Cause 5 — Environment Config

Use environment variables or property files for URLs and credentials:

```java
String baseUrl = System.getenv("BASE_URL");
// Set BASE_URL in Jenkins/GitHub Actions env config
```

### CI/CD Failure Checklist

| Issue | Fix |
|---|---|
| No display | Add `--headless=new` flag |
| Element not found | Increase explicit waits |
| Driver not found | Use WebDriverManager |
| Wrong path | Use relative paths |
| Wrong URL | Use env variables |
| Memory crash | `--disable-dev-shm-usage` |
| Screenshot on fail | Capture in `@AfterMethod` |
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','CI/CD','Jenkins','Headless','Docker','WebDriverManager','Debugging','GitHub Actions'],
  true, 0
),

-- Scenario 6
(
  'How do you handle StaleElementReferenceException in Selenium?',
  'selenium-scenario-q6-handle-stale-element-reference-exception',
  'Re-find the element before using it after any page refresh or DOM change, and use try-catch with retry logic for intermittent cases.',
  $ans$
## Handling StaleElementReferenceException

This exception occurs when a WebElement reference becomes **stale** — meaning the DOM has changed (page refresh, AJAX update, navigation) since the element was first found.

### Cause

```java
WebElement btn = driver.findElement(By.id("submit")); // found element
driver.navigate().refresh();                           // DOM rebuilt
btn.click();                                           // THROWS StaleElementReferenceException
```

### Fix 1 — Re-find the element before use

```java
driver.navigate().refresh();
// Don't reuse old reference — find again
driver.findElement(By.id("submit")).click();
```

### Fix 2 — Retry with try-catch

```java
public void clickWithRetry(By locator, int maxAttempts) {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
        try {
            driver.findElement(locator).click();
            return; // success
        } catch (StaleElementReferenceException e) {
            System.out.println("Stale element, retrying... attempt " + (attempt + 1));
        }
    }
    throw new RuntimeException("Element still stale after " + maxAttempts + " attempts");
}

// Usage
clickWithRetry(By.id("submit"), 3);
```

### Fix 3 — Wait for element staleness to resolve

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

// Wait until element is no longer stale
wait.until(ExpectedConditions.refreshed(
    ExpectedConditions.elementToBeClickable(By.id("submit"))
));
driver.findElement(By.id("submit")).click();
```

### Fix 4 — Don't store elements across actions

```java
// Bad — storing element reference
WebElement row = driver.findElement(By.cssSelector(".data-row:first-child"));
performSomeAction(); // DOM may update
row.getText();       // Might be stale

// Good — re-find each time
performSomeAction();
String text = driver.findElement(By.cssSelector(".data-row:first-child")).getText();
```

### When It Commonly Happens
- After `driver.navigate().refresh()`
- After AJAX/React/Angular DOM updates
- After sorting or filtering a table
- After navigating back with `driver.navigate().back()`
- Frames reloading after interaction
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','StaleElementReferenceException','Exception Handling','Retry','WebDriverWait','DOM','AJAX'],
  true, 0
),

-- Scenario 7
(
  'How do you take a screenshot when a test fails in Selenium?',
  'selenium-scenario-q7-screenshot-on-test-failure',
  'Use TakesScreenshot in a TestNG @AfterMethod or ITestListener to capture and save a screenshot automatically on every failure.',
  $ans$
## Auto-Screenshot on Test Failure

Capturing screenshots on failure helps identify exactly what the browser showed when the test broke — crucial for debugging in CI/CD.

### Method 1 — TestNG @AfterMethod (Simple)

```java
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.OutputType;
import org.apache.commons.io.FileUtils;
import org.testng.ITestResult;
import java.io.File;

@AfterMethod
public void captureScreenshotOnFailure(ITestResult result) throws Exception {
    if (result.getStatus() == ITestResult.FAILURE) {
        TakesScreenshot ts = (TakesScreenshot) driver;
        File src  = ts.getScreenshotAs(OutputType.FILE);
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String path = "screenshots/" + result.getName() + "_" + timestamp + ".png";
        FileUtils.copyFile(src, new File(path));
        System.out.println("Screenshot saved: " + path);
    }
}
```

### Method 2 — TestNG ITestListener (Framework-Level)

```java
public class ScreenshotListener implements ITestListener {

    @Override
    public void onTestFailure(ITestResult result) {
        WebDriver driver = DriverManager.getDriver(); // get driver from ThreadLocal
        TakesScreenshot ts = (TakesScreenshot) driver;
        byte[] screenshot = ts.getScreenshotAs(OutputType.BYTES);

        // Attach to Extent Report
        ExtentReportManager.getTest().addScreenCaptureFromBase64String(
            Base64.getEncoder().encodeToString(screenshot),
            "Failure Screenshot"
        );
    }
}
```

Register the listener in `testng.xml`:
```xml
<listeners>
    <listener class-name="listeners.ScreenshotListener"/>
</listeners>
```

### Method 3 — Save with Timestamp

```java
public static String captureScreenshot(WebDriver driver, String testName) {
    String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
    String screenshotPath = "test-output/screenshots/" + testName + "_" + timestamp + ".png";

    File src  = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
    File dest = new File(screenshotPath);
    try {
        FileUtils.copyFile(src, dest);
    } catch (IOException e) {
        e.printStackTrace();
    }
    return screenshotPath;
}
```

### Best Practices
- Always name screenshots with **test name + timestamp** to avoid overwrites
- Save to a dedicated `screenshots/` folder tracked by CI artifacts
- Attach screenshots to **ExtentReports** or **Allure** for visual reports
- Use **Base64** encoding to embed screenshots directly in HTML reports
- Take screenshot **before** `driver.quit()` in @AfterMethod
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Screenshot','TakesScreenshot','TestNG','ITestListener','Reporting','Failure'],
  true, 0
),

-- Scenario 8
(
  'How do you test file upload in Selenium?',
  'selenium-scenario-q8-test-file-upload-selenium',
  'Use sendKeys() with the absolute file path on the hidden file input element — no need for AutoIt or drag-and-drop for standard upload inputs.',
  $ans$
## Testing File Upload in Selenium

File upload dialogs are OS-level windows that Selenium cannot interact with directly. But for standard HTML `<input type="file">` elements, `sendKeys()` works perfectly.

### Method 1 — sendKeys() on File Input (Most Common)

```java
// Locate the file input element (even if hidden)
WebElement fileInput = driver.findElement(By.cssSelector("input[type='file']"));

// Send the full absolute file path
fileInput.sendKeys("C:\\test-files\\sample.pdf");

// Or on Linux/Mac CI
fileInput.sendKeys("/home/runner/test-files/sample.pdf");
```

### Handle Hidden File Input

Some file inputs have `display:none`. Use JavaScript to make it visible first:

```java
WebElement fileInput = driver.findElement(By.cssSelector("input[type='file']"));

// Remove display:none
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].style.display='block';", fileInput);

fileInput.sendKeys("C:\\test-files\\sample.png");
```

### Verify File Was Selected

```java
// Check the file name appears on page after selection
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement fileNameDisplay = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".file-name"))
);
Assert.assertTrue(fileNameDisplay.getText().contains("sample.png"));
```

### Cross-Platform Path Helper

```java
public String getTestFilePath(String fileName) {
    return System.getProperty("user.dir") +
           File.separator + "src" +
           File.separator + "test" +
           File.separator + "resources" +
           File.separator + fileName;
}

// Usage
fileInput.sendKeys(getTestFilePath("sample.pdf"));
```

### What NOT to Do
- Don't use `AutoIt` or `Robot class` for standard HTML file inputs — `sendKeys()` is sufficient and cross-platform
- Don't click the button that opens the OS dialog — find the `<input type="file">` directly
- Don't use drag-and-drop simulation when sendKeys is simpler

### When AutoIt/Robot IS Needed
Only when the upload is truly OS-native (no `<input type="file">` in DOM) — rare in modern web apps.
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','File Upload','sendKeys','JavascriptExecutor','Input','Cross-Platform'],
  true, 0
),

-- Scenario 9
(
  'How do you validate tooltip text on hover in Selenium?',
  'selenium-scenario-q9-validate-tooltip-text-hover',
  'Use Actions.moveToElement() to trigger the hover, then read the title attribute or wait for the tooltip element to appear.',
  $ans$
## Validating Tooltip Text on Hover

Tooltips appear on mouse hover. Selenium''s `Actions` class simulates real mouse movement to trigger them.

### Method 1 — Read title Attribute (Native HTML Tooltip)

Native tooltips use the `title` attribute — no hover simulation needed:

```java
WebElement element = driver.findElement(By.id("helpIcon"));

// Read tooltip directly from attribute
String tooltipText = element.getAttribute("title");
System.out.println("Tooltip: " + tooltipText);
Assert.assertEquals(tooltipText, "Click here for help");
```

### Method 2 — Hover + Read Tooltip Element (CSS/JS Tooltip)

Modern UI libraries show a separate DOM element on hover:

```java
WebElement hoverTarget = driver.findElement(By.cssSelector(".tooltip-trigger"));

// Hover over element
Actions actions = new Actions(driver);
actions.moveToElement(hoverTarget).perform();

// Wait for tooltip to appear
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement tooltip = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".tooltip-content"))
);

String tooltipText = tooltip.getText();
Assert.assertEquals(tooltipText, "This field is required");
```

### Method 3 — JavaScript Tooltip (aria-label or data attribute)

```java
// Some tooltips use aria-label
String tooltip = element.getAttribute("aria-label");

// Some use data-tooltip attribute
String tooltip2 = element.getAttribute("data-tooltip");
```

### Method 4 — Peek Into Shadow DOM / JS tooltip

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
String tooltipText = (String) js.executeScript(
    "return arguments[0].getAttribute('data-original-title');", element
);
```

### Tooltip Type Quick Guide

| Tooltip Type | Approach |
|---|---|
| Native `title` attribute | `element.getAttribute("title")` |
| CSS tooltip (::before/::after) | Hover + read `content` via JS |
| Bootstrap/Material tooltip | Hover + wait for `.tooltip` element |
| aria-label | `getAttribute("aria-label")` |
| JS tooltip | `data-original-title` attribute |
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Tooltip','Hover','Actions','moveToElement','getAttribute','title','aria-label'],
  true, 0
),

-- Scenario 10
(
  'How do you handle elements that take time to load in Selenium?',
  'selenium-scenario-q10-handle-slow-loading-elements',
  'Use WebDriverWait with ExpectedConditions to wait for specific element states instead of fixed Thread.sleep delays.',
  $ans$
## Handling Slow-Loading Elements in Selenium

Never use fixed `Thread.sleep()` for loading — it makes tests slow when things are fast and brittle when things are slow. Use intelligent waits instead.

### WebDriverWait + ExpectedConditions (Recommended)

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

// Wait for element to be visible
WebElement el = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.id("results"))
);

// Wait for element to be clickable
WebElement btn = wait.until(
    ExpectedConditions.elementToBeClickable(By.cssSelector(".submit-btn"))
);

// Wait for text to appear inside element
wait.until(
    ExpectedConditions.textToBePresentInElementLocated(By.id("status"), "Success")
);

// Wait for element count
wait.until(
    ExpectedConditions.numberOfElementsToBeMoreThan(By.cssSelector(".product-card"), 0)
);
```

### Fluent Wait — Polling with Ignore Exceptions

```java
Wait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(30))
    .pollingEvery(Duration.ofMillis(500))
    .ignoring(NoSuchElementException.class)
    .ignoring(StaleElementReferenceException.class);

WebElement el = fluentWait.until(
    d -> d.findElement(By.cssSelector(".async-loaded"))
);
```

### Implicit Wait (Baseline Only)

```java
// Set once — applies to all findElement calls
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```

> Avoid mixing implicit + explicit waits — they can conflict and cause unexpected timeouts.

### Wait for AJAX / API Response

```java
// Wait until loading spinner disappears
wait.until(
    ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".spinner"))
);

// Wait until URL changes (after form submit)
wait.until(ExpectedConditions.urlContains("/dashboard"));

// Wait until page title changes
wait.until(ExpectedConditions.titleContains("Dashboard"));
```

### Common ExpectedConditions

| Condition | Use When |
|---|---|
| `visibilityOfElementLocated` | Element appears on screen |
| `elementToBeClickable` | Button becomes enabled |
| `invisibilityOfElementLocated` | Loader/spinner disappears |
| `presenceOfElementLocated` | Element exists in DOM (may not be visible) |
| `textToBePresentInElement` | Text loads into element |
| `urlToBe` / `urlContains` | Page navigation completes |
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','WebDriverWait','ExpectedConditions','FluentWait','AJAX','Loading','Explicit Wait'],
  true, 0
),

-- Scenario 11
(
  'How do you test a table where data changes frequently in Selenium?',
  'selenium-scenario-q11-test-dynamic-table-selenium',
  'Use XPath or CSS to locate rows and columns dynamically, validate only key columns, and avoid hardcoded row indices.',
  $ans$
## Testing Dynamic Tables in Selenium

Dynamic tables change rows, order, and content based on filters or live data. Never hardcode row numbers — use flexible locators.

### Get All Rows and Columns

```java
// Get all rows in tbody
List<WebElement> rows = driver.findElements(By.cssSelector("table tbody tr"));
System.out.println("Total rows: " + rows.size());

// Iterate each row and get columns
for (WebElement row : rows) {
    List<WebElement> cols = row.findElements(By.tagName("td"));
    System.out.println("Name: " + cols.get(0).getText());
    System.out.println("Status: " + cols.get(2).getText());
}
```

### Find a Row by Column Value

```java
// XPath: find row where first column is "John"
WebElement targetRow = driver.findElement(
    By.xpath("//table/tbody/tr[td[1][text()='John']]")
);

// Get another column from that same row
String status = targetRow.findElement(By.xpath("td[3]")).getText();
System.out.println("John's status: " + status);
```

### Validate Specific Column in All Rows

```java
// Validate all "Status" column values are "Active"
List<WebElement> statusCells = driver.findElements(
    By.xpath("//table/tbody/tr/td[3]")
);
for (WebElement cell : statusCells) {
    Assert.assertEquals(cell.getText(), "Active",
        "Row has unexpected status: " + cell.getText());
}
```

### Validate Table Sorting

```java
List<WebElement> nameCells = driver.findElements(
    By.xpath("//table/tbody/tr/td[1]")
);
List<String> actual  = nameCells.stream().map(WebElement::getText).collect(toList());
List<String> sorted  = new ArrayList<>(actual);
Collections.sort(sorted);
Assert.assertEquals(actual, sorted, "Table is not sorted alphabetically");
```

### Handle Pagination

```java
while (true) {
    // Process current page rows
    List<WebElement> rows = driver.findElements(By.cssSelector("table tbody tr"));
    for (WebElement row : rows) {
        // validate or extract data
    }

    // Check if Next button is enabled
    WebElement nextBtn = driver.findElement(By.cssSelector(".pagination-next"));
    if (nextBtn.getAttribute("class").contains("disabled")) break;
    nextBtn.click();
    Thread.sleep(1000); // or use explicit wait
}
```

### Best Practices
- Validate only **critical columns** — not all data (avoid brittle tests)
- Take a **screenshot** when a mismatch is found as evidence
- Use `XPath td[position()]` instead of hardcoded column index where possible
- For live data, validate **structure/format** rather than exact values
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','Table','Dynamic Table','XPath','Pagination','Data Validation','WebElement'],
  true, 0
),

-- Scenario 12
(
  'A loader appears after clicking a button then content loads. How do you handle it in Selenium?',
  'selenium-scenario-q12-handle-loader-spinner-then-content',
  'Wait for the loader/spinner to become invisible using invisibilityOfElementLocated, then wait for the content to appear.',
  $ans$
## Handling Loader → Content Pattern in Selenium

This is a very common pattern: click action → spinner appears → content loads. You must wait for the **spinner to disappear** before interacting with the loaded content.

### Standard Pattern

```java
// Step 1: Click the action button
driver.findElement(By.id("loadDataBtn")).click();

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(20));

// Step 2: Wait for loader/spinner to DISAPPEAR
wait.until(
    ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".spinner"))
);

// Step 3: Wait for content to APPEAR
WebElement content = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".data-container"))
);

// Step 4: Interact with loaded content
System.out.println("Content loaded: " + content.getText());
```

### If Loader Is Not in DOM Initially

```java
// Click
driver.findElement(By.id("loadBtn")).click();

// Wait for loader to APPEAR first (confirms action triggered)
wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".loading-overlay"))
);

// Then wait for it to DISAPPEAR
wait.until(
    ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".loading-overlay"))
);

// Now content is ready
```

### Reusable Method

```java
public void waitForLoaderAndContent(String loaderCss, String contentCss) {
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(30));

    // Wait for loader to go away
    wait.until(ExpectedConditions.invisibilityOfElementLocated(
        By.cssSelector(loaderCss)
    ));

    // Wait for content
    wait.until(ExpectedConditions.visibilityOfElementLocated(
        By.cssSelector(contentCss)
    ));
}

// Usage
clickLoadButton();
waitForLoaderAndContent(".spinner", ".results-grid");
```

### Handle Slow Networks in CI

```java
// Increase timeout for CI environments
int timeout = System.getenv("CI") != null ? 45 : 15;
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(timeout));
```

### When Timeout Happens
If the wait times out, it is a **real defect** — the spinner never disappeared or content never loaded within the acceptable time. Log it, take a screenshot, and report it as a bug rather than increasing the timeout further.
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Loader','Spinner','invisibilityOfElement','WebDriverWait','AJAX','Loading'],
  true, 0
),

-- Scenario 13
(
  'How do you maximize a Chrome window without using driver.manage().window().maximize()?',
  'selenium-scenario-q13-maximize-window-without-maximize-command',
  'Use Dimension to set a custom window size with driver.manage().window().setSize(), or pass --start-maximized via ChromeOptions.',
  $ans$
## Maximizing Chrome Window Without maximize()

There are two reliable alternatives when `driver.manage().window().maximize()` is not preferred or doesn''t work (e.g., in headless mode).

### Method 1 — Set Dimension Manually

```java
import org.openqa.selenium.Dimension;

// Set to full HD resolution
Dimension dimension = new Dimension(1920, 1080);
driver.manage().window().setSize(dimension);
```

### Method 2 — ChromeOptions --start-maximized

```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--start-maximized");
// For Linux CI where no screen exists:
options.addArguments("--window-size=1920,1080");

WebDriver driver = new ChromeDriver(options);
```

### Method 3 — Use setPosition + setSize Together

```java
driver.manage().window().setPosition(new Point(0, 0));
driver.manage().window().setSize(new Dimension(1920, 1080));
```

### Method 4 — JavaScript fullscreen

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("window.moveTo(0, 0);"
    + "window.resizeTo(screen.width, screen.height);");
```

### Headless — Must Use setSize

In headless mode, `maximize()` often has no effect because there is no physical screen. Always set explicit dimensions:

```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless=new");
options.addArguments("--window-size=1920,1080"); // mandatory for headless
WebDriver driver = new ChromeDriver(options);
```

### When to Use Each

| Method | Best For |
|---|---|
| `setSize(new Dimension(...))` | Custom resolution testing |
| `--start-maximized` | Headed Chrome launch |
| `--window-size=W,H` | Headless / CI environments |
| JavaScript resize | Cross-browser fallback |
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Beginner',
  ARRAY['Selenium','Window Size','Maximize','Dimension','ChromeOptions','Headless','setSize'],
  true, 0
),

-- Scenario 14 (Additional — Important)
(
  'How do you handle random alerts or pop-ups that appear unexpectedly in Selenium?',
  'selenium-scenario-q14-handle-random-alerts-popups',
  'Wrap clicks in try-catch for UnexpectedAlertPresentException, or proactively check and dismiss alerts before each action.',
  $ans$
## Handling Random/Unexpected Alerts in Selenium

Some applications show alerts randomly — cookie consent banners, session warnings, or promotional pop-ups. These break tests if not handled.

### Dismiss Alert If Present (Try-Catch Pattern)

```java
public void dismissAlertIfPresent() {
    try {
        Alert alert = driver.switchTo().alert();
        System.out.println("Alert text: " + alert.getText());
        alert.dismiss(); // or alert.accept()
    } catch (NoAlertPresentException e) {
        // No alert — that''s fine, continue
    }
}

// Call before any critical action
dismissAlertIfPresent();
driver.findElement(By.id("checkoutBtn")).click();
```

### Wait for Alert and Handle

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
try {
    Alert alert = wait.until(ExpectedConditions.alertIsPresent());
    alert.accept();
} catch (TimeoutException e) {
    // No alert appeared within 5 seconds
}
```

### Handle CSS/Modal Pop-ups (Not JS Alerts)

```java
// Check if modal is visible and close it
try {
    WebElement closeBtn = driver.findElement(By.cssSelector(".modal .close-btn"));
    if (closeBtn.isDisplayed()) {
        closeBtn.click();
    }
} catch (NoSuchElementException e) {
    // Modal not present
}
```

### TestNG Listener — Handle Alerts on Every Failure

```java
@Override
public void onTestFailure(ITestResult result) {
    try {
        driver.switchTo().alert().dismiss();
    } catch (NoAlertPresentException ignored) {}
    // Then take screenshot
}
```

### Types of Pop-ups and How to Handle

| Pop-up Type | Selenium Approach |
|---|---|
| JS `alert()` | `driver.switchTo().alert().accept()` |
| JS `confirm()` | `.accept()` or `.dismiss()` |
| JS `prompt()` | `.sendKeys("text")` then `.accept()` |
| CSS Modal | Find and click close button |
| Browser auth dialog | Pass credentials in URL |
| Cookie banner | Click "Accept" button |
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Alert','Pop-up','Modal','switchTo','UnexpectedAlertPresentException','Cookie'],
  true, 0
),

-- Scenario 15 (Additional — Important)
(
  'Your Selenium test is flaky — it sometimes passes and sometimes fails. How do you fix it?',
  'selenium-scenario-q15-fix-flaky-selenium-tests',
  'Root causes of flakiness are timing issues, dynamic locators, test data dependency, and environment differences — fix each systematically.',
  $ans$
## Fixing Flaky Selenium Tests

Flaky tests are the #1 pain point in automation. They destroy trust in the test suite. Here is a systematic approach to diagnose and fix them.

### Root Cause 1 — Timing / Race Conditions (Most Common)

```java
// Bad — fixed sleep
Thread.sleep(3000);

// Good — wait for specific condition
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("result")));
```

### Root Cause 2 — Stale Element Reference

```java
// Bad — reusing stored reference across actions
WebElement btn = driver.findElement(By.id("submit"));
performIntermediateAction(); // DOM may update
btn.click(); // may be stale

// Good — find fresh before each use
performIntermediateAction();
driver.findElement(By.id("submit")).click();
```

### Root Cause 3 — Test Data Dependency / Order

```java
// Bad — tests share state
// Test B depends on Test A creating data

// Good — each test creates its own data
@BeforeMethod
public void createTestData() {
    // Create fresh user/order via API
}

@AfterMethod
public void cleanupTestData() {
    // Delete test data
}
```

### Root Cause 4 — Hardcoded Waits in Loops

```java
// FluentWait with polling handles intermittent element appearance
Wait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(30))
    .pollingEvery(Duration.ofMillis(300))
    .ignoring(StaleElementReferenceException.class)
    .ignoring(NoSuchElementException.class);
```

### Root Cause 5 — Environment Differences

- Use `WebDriverManager` to auto-match browser/driver versions
- Pin browser versions in CI Docker image
- Use relative file paths, not absolute
- Externalize environment URLs via properties/env vars

### Retry Failed Tests (Short-Term Fix)

In `testng.xml`:
```xml
<suite name="Regression" verbose="1">
    <test name="Tests" preserve-order="true">
        <parameter name="retryCount" value="2"/>
    </test>
</suite>
```

```java
public class RetryAnalyzer implements IRetryAnalyzer {
    private int count = 0;
    private static final int MAX_RETRY = 2;

    @Override
    public boolean retry(ITestResult result) {
        return count++ < MAX_RETRY;
    }
}

// On test
@Test(retryAnalyzer = RetryAnalyzer.class)
public void myTest() { ... }
```

### Flakiness Investigation Checklist

| Symptom | Likely Cause |
|---|---|
| Fails on first run, passes on retry | Timing / race condition |
| Fails only in CI, passes locally | Environment / headless issue |
| Fails randomly, no pattern | Stale element or shared state |
| Fails after another test | Test order dependency |
| Fails on slow machines | Insufficient wait timeouts |
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Flaky Tests','Retry','WebDriverWait','StaleElement','Test Data','CI/CD','Stability'],
  true, 0
),

-- Scenario 16 (Additional — Important)
(
  'How do you automate a date picker or calendar widget in Selenium?',
  'selenium-scenario-q16-automate-date-picker-calendar',
  'Use sendKeys() for plain text inputs, or navigate the calendar UI by clicking month/year arrows and selecting the date element.',
  $ans$
## Automating Date Picker / Calendar in Selenium

Date pickers vary widely — from simple text inputs to complex month/year navigation calendars. Here are strategies for each:

### Type 1 — Simple Text Input (Easiest)

If the date field is a plain `<input>`, just send the date as text:

```java
WebElement dateField = driver.findElement(By.id("startDate"));
dateField.clear();
dateField.sendKeys("12/25/2025");
```

For HTML5 date inputs (`type="date"`):

```java
WebElement dateInput = driver.findElement(By.cssSelector("input[type='date']"));
// Format: yyyy-MM-dd for HTML5 date input
dateInput.sendKeys("2025-12-25");
```

### Type 2 — Navigate Calendar UI

```java
// Click to open calendar
driver.findElement(By.cssSelector(".datepicker-input")).click();

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".calendar")));

// Navigate to the correct month
// Click Next arrow until we reach December 2025
while (!driver.findElement(By.cssSelector(".calendar-month-year")).getText().equals("December 2025")) {
    driver.findElement(By.cssSelector(".next-month-arrow")).click();
}

// Click the specific date
driver.findElement(
    By.xpath("//td[@class='calendar-day'][text()='25']")
).click();
```

### Type 3 — Set Via JavaScript (Bypass Calendar UI)

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
WebElement dateInput = driver.findElement(By.id("datePicker"));

js.executeScript(
    "arguments[0].value = arguments[1];",
    dateInput, "2025-12-25"
);

// Trigger change event so the UI updates
js.executeScript(
    "arguments[0].dispatchEvent(new Event(''change''));", dateInput
);
```

### Type 4 — Material UI / React DatePicker

```java
WebElement dateField = driver.findElement(By.cssSelector("input[placeholder='MM/DD/YYYY']"));
dateField.click();
dateField.sendKeys(Keys.CONTROL + "a"); // select all
dateField.sendKeys("12/25/2025");
dateField.sendKeys(Keys.TAB); // close picker
```

### Decision Tree

| Date Picker Type | Best Approach |
|---|---|
| Plain text input | `sendKeys("12/25/2025")` |
| HTML5 `input[type=date]` | `sendKeys("2025-12-25")` |
| Calendar navigation UI | Click arrows + click day |
| JS-controlled picker | `js.executeScript` + `dispatchEvent` |
| Material / React picker | `sendKeys` + `TAB` to close |
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Date Picker','Calendar','sendKeys','JavascriptExecutor','Material UI','React'],
  true, 0
),

-- Scenario 17 (Additional — Important)
(
  'How do you handle basic authentication pop-ups in Selenium?',
  'selenium-scenario-q17-handle-basic-authentication-popup',
  'Pass credentials directly in the URL (http://user:pass@site.com), use CDP in Selenium 4, or configure proxy authentication headers.',
  $ans$
## Handling Basic Authentication Pop-ups in Selenium

Browser-level HTTP Basic Auth dialog boxes are OS-level prompts that Selenium cannot interact with using `switchTo().alert()`. Here are the proper approaches:

### Method 1 — Credentials in URL (Simplest)

```java
// Format: http://username:password@hostname/path
String url = "https://admin:password123@staging.myapp.com/dashboard";
driver.get(url);
```

> Works well for HTTP Basic Auth on most browsers.

### Method 2 — Selenium 4 CDP (Chrome DevTools Protocol)

```java
import org.openqa.selenium.devtools.DevTools;
import org.openqa.selenium.devtools.v117.network.Network;

ChromeDriver chromeDriver = (ChromeDriver) driver;
DevTools devTools = chromeDriver.getDevTools();
devTools.createSession();

devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));

// Set auth credentials
devTools.send(Network.setExtraHTTPHeaders(
    new Headers(Map.of("Authorization",
        "Basic " + Base64.getEncoder().encodeToString("admin:password123".getBytes())))
));

driver.get("https://staging.myapp.com/dashboard");
```

### Method 3 — ChromeOptions Extension for Auth

```java
// Use with Selenium Grid or proxy auth scenarios
ChromeOptions options = new ChromeOptions();
options.addArguments("--disable-blink-features=AutomationControlled");

// Handle via browser extension or proxy settings
```

### Method 4 — WebDriverWait + Alert (Some Browsers)

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
try {
    Alert alert = wait.until(ExpectedConditions.alertIsPresent());
    // Does NOT work for HTTP Basic Auth in Chrome/Edge
    // Works in some older Firefox versions
    alert.authenticateUsing(new UserAndPassword("admin", "password123"));
} catch (TimeoutException e) {
    System.out.println("No auth popup appeared");
}
```

### Recommended Approach by Browser

| Browser | Best Method |
|---|---|
| Chrome / Edge | Credentials in URL or CDP |
| Firefox | `authenticateUsing()` or URL |
| Headless (all) | Credentials in URL |
| Selenium Grid | CDP or URL method |
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Basic Authentication','Auth Popup','CDP','URL Credentials','Chrome','Security'],
  true, 0
),

-- Scenario 18 (Additional — Important)
(
  'How do you handle iframes in Selenium WebDriver?',
  'selenium-scenario-q18-handle-iframes-selenium-webdriver',
  'Use driver.switchTo().frame() to enter an iframe context before interacting with elements inside it, then switchTo().defaultContent() to return.',
  $ans$
## Handling iFrames in Selenium

An **iframe** is an HTML document embedded inside another. Elements inside an iframe are not accessible from the parent page context — you must switch into it first.

### Switch by Index

```java
// Switch to first iframe on page (0-based index)
driver.switchTo().frame(0);

// Interact with element inside iframe
driver.findElement(By.id("username")).sendKeys("testuser");

// Switch back to main page
driver.switchTo().defaultContent();
```

### Switch by Name or ID

```java
// <iframe name="loginFrame" id="loginFrame">
driver.switchTo().frame("loginFrame");
driver.findElement(By.name("password")).sendKeys("secret");
driver.switchTo().defaultContent();
```

### Switch by WebElement

```java
WebElement iframeElement = driver.findElement(By.cssSelector("iframe.content-frame"));
driver.switchTo().frame(iframeElement);

driver.findElement(By.id("submitBtn")).click();
driver.switchTo().defaultContent();
```

### Nested iFrames

```java
// Switch to outer iframe
driver.switchTo().frame("outerFrame");

// Then switch to inner iframe within it
driver.switchTo().frame("innerFrame");

driver.findElement(By.id("element")).click();

// Go up one level (to outerFrame)
driver.switchTo().parentFrame();

// Go back to main page
driver.switchTo().defaultContent();
```

### Wait for iFrame to Load

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.frameToBeAvailableAndSwitchToIt(
    By.cssSelector("iframe#content")
));
// Now inside the iframe
driver.findElement(By.id("element")).click();
```

### Common Mistake

```java
// BAD — trying to find element inside iframe without switching
driver.findElement(By.id("insideIframe")); // NoSuchElementException

// GOOD
driver.switchTo().frame("myFrame");
driver.findElement(By.id("insideIframe")); // works
driver.switchTo().defaultContent();
```

### Always Remember
- After switching to an iframe, all `findElement` calls target **inside the iframe**
- Use `defaultContent()` to return to the top-level page
- Use `parentFrame()` to go up one level in nested iframes
  $ans$,
  'Selenium', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','iframe','switchTo','frame','Nested iframe','WebDriverWait','DOM'],
  true, 0
),

-- Scenario 19 (Additional — Important)
(
  'How do you run Selenium tests in parallel across multiple browsers?',
  'selenium-scenario-q19-parallel-execution-multiple-browsers',
  'Use TestNG parallel="tests" in testng.xml with browser parameter, or use Selenium Grid to distribute tests across browser nodes.',
  $ans$
## Parallel Execution Across Multiple Browsers

### Method 1 — TestNG Parallel with Browser Parameter

**testng.xml:**
```xml
<suite name="CrossBrowserSuite" parallel="tests" thread-count="3">

    <test name="ChromeTest">
        <parameter name="browser" value="chrome"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>

    <test name="FirefoxTest">
        <parameter name="browser" value="firefox"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>

    <test name="EdgeTest">
        <parameter name="browser" value="edge"/>
        <classes><class name="tests.LoginTest"/></classes>
    </test>

</suite>
```

**Base Test Class:**
```java
public class BaseTest {
    protected WebDriver driver;

    @Parameters("browser")
    @BeforeMethod
    public void setUp(String browser) {
        switch (browser.toLowerCase()) {
            case "chrome":
                WebDriverManager.chromedriver().setup();
                driver = new ChromeDriver();
                break;
            case "firefox":
                WebDriverManager.firefoxdriver().setup();
                driver = new FirefoxDriver();
                break;
            case "edge":
                WebDriverManager.edgedriver().setup();
                driver = new EdgeDriver();
                break;
        }
        driver.manage().window().maximize();
    }

    @AfterMethod
    public void tearDown() {
        if (driver != null) driver.quit();
    }
}
```

### Method 2 — ThreadLocal for Thread-Safe Driver

```java
public class DriverManager {
    private static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

    public static WebDriver getDriver() { return tlDriver.get(); }

    public static void setDriver(WebDriver driver) { tlDriver.set(driver); }

    public static void removeDriver() {
        tlDriver.get().quit();
        tlDriver.remove();
    }
}
```

### Method 3 — Selenium Grid

```bash
# Start Hub
java -jar selenium-server.jar hub

# Register Chrome Node
java -jar selenium-server.jar node --hub http://localhost:4444
```

```java
DesiredCapabilities caps = new DesiredCapabilities();
caps.setBrowserName("chrome");
WebDriver driver = new RemoteWebDriver(
    new URL("http://localhost:4444/wd/hub"), caps
);
```

### Key Rules for Parallel Execution
- Always use **ThreadLocal\<WebDriver\>** — never share driver instances between threads
- Each test must create and destroy its own driver in `@Before/@AfterMethod`
- Use **independent test data** per thread to avoid conflicts
- Set `thread-count` in testng.xml to match available machine cores/nodes
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Parallel Execution','Cross Browser','TestNG','Selenium Grid','ThreadLocal','WebDriverManager'],
  true, 0
),

-- Scenario 20 (Additional — Important)
(
  'How do you handle shadow DOM elements in Selenium?',
  'selenium-scenario-q20-handle-shadow-dom-selenium',
  'Use JavascriptExecutor to access the shadowRoot property, then query elements inside it — standard locators cannot penetrate shadow DOM.',
  $ans$
## Handling Shadow DOM in Selenium

**Shadow DOM** is an encapsulated DOM tree that hides internal implementation of web components. Standard `findElement` cannot cross the shadow boundary.

### Understand the Structure

```html
<!-- Host element -->
<custom-input id="myInput">
  <!-- Shadow DOM (not visible to standard XPath/CSS) -->
  #shadow-root
    <input type="text" class="internal-input">
</custom-input>
```

### Method 1 — Selenium 4 getShadowRoot() (Native Support)

```java
// Selenium 4.x has native shadow DOM support
WebElement host = driver.findElement(By.cssSelector("custom-input#myInput"));
SearchContext shadowRoot = host.getShadowRoot();

// Now find element inside shadow DOM
WebElement innerInput = shadowRoot.findElement(By.cssSelector("input.internal-input"));
innerInput.sendKeys("Hello Shadow DOM");
```

### Method 2 — JavascriptExecutor (Selenium 3 / Fallback)

```java
JavascriptExecutor js = (JavascriptExecutor) driver;

// Access shadowRoot and find inner element
WebElement innerInput = (WebElement) js.executeScript(
    "return document.querySelector('custom-input#myInput').shadowRoot.querySelector('input')"
);
innerInput.sendKeys("Hello");
```

### Nested Shadow DOM

```java
WebElement outerInput = (WebElement) js.executeScript(
    "return document.querySelector('outer-element')" +
    ".shadowRoot.querySelector('inner-element')" +
    ".shadowRoot.querySelector('input')"
);
outerInput.click();
```

### Selenium 4 Chained Shadow Roots

```java
WebElement host1 = driver.findElement(By.cssSelector("outer-element"));
SearchContext shadow1 = host1.getShadowRoot();

WebElement host2 = shadow1.findElement(By.cssSelector("inner-element"));
SearchContext shadow2 = host2.getShadowRoot();

WebElement target = shadow2.findElement(By.cssSelector("button.submit"));
target.click();
```

### When You Encounter Shadow DOM
- Browser extensions UI
- Google Pay / Stripe checkout widgets
- Chrome built-in elements (like `<input type="date">`)
- Custom web components (Lit, Stencil, Polymer)

### Key Limitations
- Cannot use XPath inside shadow DOM — only CSS selectors work within `getShadowRoot()`
- `findElements` works within shadow context but not across multiple shadow roots in one call
- Some closed shadow roots (`{mode: ''closed''}`) cannot be accessed at all
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Shadow DOM','JavascriptExecutor','getShadowRoot','Web Components','Selenium 4','CSS'],
  true, 0
);
