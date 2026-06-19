-- Selenium Advanced Questions Q166–Q180 (Senior Architect Level)
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q166
(
  'What are the new features introduced in Selenium 4?',
  'selenium-q166-new-features-selenium-4',
  'Selenium 4 introduces Relative Locators, native Chrome DevTools Protocol (CDP), improved Grid 4, new Window/Tab API, and W3C WebDriver standard compliance.',
  $ans$
## New Features in Selenium 4

Selenium 4 is a major release with significant architectural and API improvements over Selenium 3.

### 1. Relative Locators

Find elements relative to other elements — great for dynamic grids:

```java
import static org.openqa.selenium.support.locators.RelativeLocator.*;

// Find password field that is BELOW username field
WebElement username = driver.findElement(By.id("username"));
WebElement password = driver.findElement(
    with(By.tagName("input")).below(username)
);

// Find label to the LEFT of an input
WebElement label = driver.findElement(
    with(By.tagName("label")).toLeftOf(By.id("email"))
);

// Find element NEAR another (within 50px)
WebElement helpIcon = driver.findElement(
    with(By.tagName("span")).near(By.id("phoneField"))
);
```

Available: `above()`, `below()`, `toLeftOf()`, `toRightOf()`, `near()`

### 2. Native Chrome DevTools Protocol (CDP)

Direct access to Chrome DevTools — intercept network, emulate devices, mock geolocation:

```java
ChromeDriver driver = new ChromeDriver();
DevTools devTools = driver.getDevTools();
devTools.createSession();

// Enable network interception
devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));

// Mock geolocation
devTools.send(Emulation.setGeolocationOverride(
    Optional.of(40.7128), Optional.of(-74.0060), Optional.of(1)
));

// Intercept requests
devTools.addListener(Network.requestWillBeSent(), request -> {
    System.out.println("Request: " + request.getRequest().getUrl());
});
```

### 3. New Window / Tab API

```java
// Open a new tab and switch to it
driver.switchTo().newWindow(WindowType.TAB);

// Open a new browser window
driver.switchTo().newWindow(WindowType.WINDOW);
```

### 4. Selenium Grid 4 (Fully Rewritten)

- Standalone, Hub-Node, and Distributed modes
- Docker/Kubernetes native support
- Built-in observability (GraphQL API, event bus)
- No more JSON config files needed

```bash
# Standalone (all-in-one)
java -jar selenium-server.jar standalone

# Hub
java -jar selenium-server.jar hub

# Node
java -jar selenium-server.jar node --hub http://hub:4444
```

### 5. W3C WebDriver Standard (Full Compliance)

- All capability handling moved to browser `Options` classes
- `DesiredCapabilities` deprecated for browser-specific `ChromeOptions`, `FirefoxOptions`
- More consistent cross-browser behavior

### 6. Improved Screenshots

```java
// Screenshot of a specific element (not whole screen)
WebElement card = driver.findElement(By.cssSelector(".product-card"));
File screenshot = card.getScreenshotAs(OutputType.FILE);
```

### 7. Print Page to PDF

```java
PrintsPage printer = (PrintsPage) driver;
PrintOptions printOptions = new PrintOptions();
Pdf pdf = printer.print(printOptions);
String base64pdf = pdf.getContent();
```

### Key Upgrade Summary

| Feature | Selenium 3 | Selenium 4 |
|---|---|---|
| Locators | Standard only | + Relative Locators |
| CDP access | Via third-party | Native built-in |
| Grid | Hub/Node only | Standalone/Hub/Node/Distributed |
| New window | Via JS | `switchTo().newWindow()` |
| W3C compliance | Partial | Full |
| Element screenshot | Full page only | Element-level |
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Selenium 4','CDP','Relative Locators','Grid 4','New Features','W3C','DevTools'],
  true, 0
),

-- Q167
(
  'What is Chrome DevTools Protocol (CDP) and how do you use it in Selenium 4?',
  'selenium-q167-chrome-devtools-protocol-cdp-selenium4',
  'CDP gives direct access to Chrome internals — network interception, console logs, performance metrics, and device emulation — all from Selenium 4.',
  $ans$
## Chrome DevTools Protocol (CDP) in Selenium 4

CDP allows Selenium tests to communicate directly with Chrome''s DevTools, enabling capabilities impossible with standard WebDriver commands.

### Setup

```java
ChromeDriver driver = new ChromeDriver();
DevTools devTools = driver.getDevTools();
devTools.createSession();
```

### 1. Mock Network Conditions (Throttling)

```java
devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));

devTools.send(Network.emulateNetworkConditions(
    false,          // offline
    100,            // latency (ms)
    500 * 1024,     // downloadThroughput (bytes/sec = 500KB/s)
    200 * 1024,     // uploadThroughput
    Optional.of(ConnectionType.CELLULAR3G)
));
driver.get("https://automateqa.online");
```

### 2. Block Specific URLs / Requests

```java
devTools.send(Network.setBlockedURLs(List.of("*.png", "*.jpg", "analytics.js")));
driver.get("https://example.com"); // loads without images/analytics
```

### 3. Capture Console Logs

```java
devTools.addListener(Log.entryAdded(), entry -> {
    System.out.println("[" + entry.getLevel() + "] " + entry.getText());
});
driver.get("https://example.com");
```

### 4. Capture Network Requests/Responses

```java
devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));

devTools.addListener(Network.responseReceived(), response -> {
    System.out.println("URL: " + response.getResponse().getUrl());
    System.out.println("Status: " + response.getResponse().getStatus());
});
```

### 5. Override Geolocation

```java
devTools.send(Emulation.setGeolocationOverride(
    Optional.of(51.5074),  // London latitude
    Optional.of(-0.1278),  // London longitude
    Optional.of(1)         // accuracy
));
driver.get("https://maps.google.com");
```

### 6. Emulate Device (Mobile)

```java
Map<String, Object> deviceMetrics = new HashMap<>();
deviceMetrics.put("width",  375);
deviceMetrics.put("height", 812);
deviceMetrics.put("mobile", true);
deviceMetrics.put("deviceScaleFactor", 3);

driver.executeCdpCommand("Emulation.setDeviceMetricsOverride", deviceMetrics);
```

### 7. Set Authentication Headers

```java
devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));

String credentials = Base64.getEncoder().encodeToString("admin:password".getBytes());
devTools.send(Network.setExtraHTTPHeaders(
    new Headers(Map.of("Authorization", "Basic " + credentials))
));
```

### 8. Get Performance Metrics

```java
devTools.send(Performance.enable(Optional.empty()));
List<Metric> metrics = devTools.send(Performance.getMetrics());
metrics.forEach(m -> System.out.println(m.getName() + ": " + m.getValue()));
```
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','CDP','Chrome DevTools','Network Interception','Selenium 4','Geolocation','Performance'],
  true, 0
),

-- Q168
(
  'How do you design a BaseTest class in a Selenium framework?',
  'selenium-q168-basetest-class-design-selenium-framework',
  'BaseTest centralizes WebDriver setup/teardown, configuration loading, and common utilities so every test class inherits them without duplication.',
  $ans$
## Designing a BaseTest Class

`BaseTest` is the foundation of a well-structured Selenium framework. Every test class extends it, getting driver management, config loading, and utilities for free.

### Complete BaseTest Implementation

```java
package base;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.testng.annotations.*;
import java.io.FileInputStream;
import java.time.Duration;
import java.util.Properties;

public class BaseTest {

    // ThreadLocal for parallel execution safety
    private static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

    protected Properties config;

    public static WebDriver getDriver() {
        return tlDriver.get();
    }

    @BeforeSuite
    public void loadConfig() throws Exception {
        config = new Properties();
        FileInputStream fis = new FileInputStream(
            System.getProperty("user.dir") + "/src/test/resources/config.properties"
        );
        config.load(fis);
    }

    @Parameters("browser")
    @BeforeMethod
    public void setUp(@Optional("chrome") String browser) {
        WebDriver driver = createDriver(browser);
        tlDriver.set(driver);

        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
        driver.get(config.getProperty("baseUrl", "https://automateqa.online"));
    }

    private WebDriver createDriver(String browser) {
        return switch (browser.toLowerCase()) {
            case "firefox" -> {
                WebDriverManager.firefoxdriver().setup();
                yield new FirefoxDriver();
            }
            case "edge" -> {
                WebDriverManager.edgedriver().setup();
                yield new EdgeDriver();
            }
            default -> {
                WebDriverManager.chromedriver().setup();
                ChromeOptions opts = new ChromeOptions();
                if (Boolean.parseBoolean(System.getProperty("headless", "false"))) {
                    opts.addArguments("--headless=new", "--no-sandbox",
                                     "--disable-dev-shm-usage", "--window-size=1920,1080");
                }
                yield new ChromeDriver(opts);
            }
        };
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        if (getDriver() != null) {
            getDriver().quit();
            tlDriver.remove();
        }
    }
}
```

### config.properties

```properties
baseUrl=https://staging.automateqa.online
browser=chrome
headless=false
implicitWait=10
pageLoadTimeout=30
```

### Test Class — Extends BaseTest

```java
public class LoginTest extends BaseTest {

    @Test
    public void validLoginTest() {
        WebDriver driver = getDriver();
        driver.findElement(By.id("username")).sendKeys("admin");
        driver.findElement(By.id("password")).sendKeys("secret");
        driver.findElement(By.id("loginBtn")).click();

        Assert.assertTrue(driver.getTitle().contains("Dashboard"));
    }
}
```

### What BaseTest Should Handle

| Responsibility | Where |
|---|---|
| Driver creation | `@BeforeMethod` |
| Config loading | `@BeforeSuite` |
| Browser selection | `@Parameters("browser")` |
| Parallel safety | `ThreadLocal<WebDriver>` |
| Screenshots on fail | `@AfterMethod` + `ITestResult` |
| Driver cleanup | `@AfterMethod(alwaysRun=true)` |
| Common waits | Utility methods or separate `BasePage` |
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','BaseTest','ThreadLocal','Framework Design','TestNG','Configuration','Parallel Execution'],
  true, 0
),

-- Q169
(
  'What is ThreadLocal in Selenium and why is it needed for parallel testing?',
  'selenium-q169-threadlocal-webdriver-parallel-testing',
  'ThreadLocal gives each thread its own isolated WebDriver instance, preventing driver conflicts when tests run in parallel across multiple threads.',
  $ans$
## ThreadLocal WebDriver in Selenium

When tests run in parallel, multiple threads share the same class instance. Without `ThreadLocal`, threads overwrite each other''s `driver` variable — causing `NullPointerException`, cross-thread interference, and flaky tests.

### Problem Without ThreadLocal

```java
// BROKEN — shared static driver in parallel
public class BaseTest {
    protected static WebDriver driver; // DANGER: shared across threads

    @BeforeMethod
    public void setUp() {
        driver = new ChromeDriver(); // Thread 2 overwrites Thread 1's driver!
    }
}
```

### Solution — ThreadLocal\<WebDriver\>

```java
public class DriverManager {

    private static final ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

    public static void setDriver(WebDriver driver) {
        tlDriver.set(driver);
    }

    public static WebDriver getDriver() {
        return tlDriver.get();
    }

    public static void removeDriver() {
        if (tlDriver.get() != null) {
            tlDriver.get().quit();
            tlDriver.remove(); // CRITICAL — prevents memory leak
        }
    }
}
```

### BaseTest with ThreadLocal

```java
public class BaseTest {

    @BeforeMethod
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        DriverManager.setDriver(new ChromeDriver());
        DriverManager.getDriver().manage().window().maximize();
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        DriverManager.removeDriver(); // quits + removes from ThreadLocal
    }
}
```

### BasePage with ThreadLocal Driver

```java
public class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage() {
        this.driver = DriverManager.getDriver(); // gets THIS thread's driver
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
    }
}
```

### testng.xml for Parallel Methods

```xml
<suite name="ParallelSuite" parallel="methods" thread-count="4">
    <test name="RegressionTests">
        <classes>
            <class name="tests.LoginTest"/>
            <class name="tests.CheckoutTest"/>
        </classes>
    </test>
</suite>
```

### How ThreadLocal Works

| Thread | tlDriver value |
|---|---|
| Thread-1 | `ChromeDriver` instance A |
| Thread-2 | `ChromeDriver` instance B |
| Thread-3 | `ChromeDriver` instance C |

Each thread sees only its own driver. `getDriver()` returns the correct instance for the calling thread automatically.

### Critical Rules
- Always call `tlDriver.remove()` in `@AfterMethod` — otherwise driver objects leak in thread pools
- Never pass driver as a parameter between page classes — use `DriverManager.getDriver()` everywhere
- `ThreadLocal` only works for same-JVM parallelism — for Grid, each node has its own JVM
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','ThreadLocal','Parallel Testing','WebDriver','Thread Safety','Framework Design','TestNG'],
  true, 0
),

-- Q170
(
  'How do you integrate ExtentReports with Selenium and TestNG?',
  'selenium-q170-extentreports-integration-selenium-testng',
  'ExtentReports generates interactive HTML reports with test status, screenshots, logs, and charts — integrated via a TestNG ITestListener or ExtentTestNGIReporterListener.',
  $ans$
## ExtentReports Integration with Selenium + TestNG

ExtentReports produces rich, interactive HTML reports with pass/fail/skip charts, screenshots, and logs — far better than TestNG''s default reports.

### Maven Dependency

```xml
<dependency>
    <groupId>com.aventstack</groupId>
    <artifactId>extentreports</artifactId>
    <version>5.1.1</version>
</dependency>
```

### Step 1 — ExtentReportManager (Singleton)

```java
public class ExtentReportManager {
    private static ExtentReports extent;
    private static ThreadLocal<ExtentTest> extentTest = new ThreadLocal<>();

    public static ExtentReports getInstance() {
        if (extent == null) {
            String reportPath = System.getProperty("user.dir") +
                                "/test-output/ExtentReport.html";
            ExtentSparkReporter spark = new ExtentSparkReporter(reportPath);
            spark.config().setDocumentTitle("AutomateQA Test Report");
            spark.config().setReportName("Regression Suite");
            spark.config().setTheme(Theme.DARK);

            extent = new ExtentReports();
            extent.attachReporter(spark);
            extent.setSystemInfo("OS", System.getProperty("os.name"));
            extent.setSystemInfo("Environment", "Staging");
            extent.setSystemInfo("Tester", "AutomateQA Team");
        }
        return extent;
    }

    public static void setTest(ExtentTest test) { extentTest.set(test); }
    public static ExtentTest getTest()          { return extentTest.get(); }
}
```

### Step 2 — TestNG Listener

```java
public class ExtentReportListener implements ITestListener {

    @Override
    public void onStart(ITestContext context) {
        ExtentReportManager.getInstance();
    }

    @Override
    public void onTestStart(ITestResult result) {
        ExtentTest test = ExtentReportManager.getInstance()
            .createTest(result.getMethod().getMethodName());
        ExtentReportManager.setTest(test);
        ExtentReportManager.getTest().info("Test started: " + result.getMethod().getMethodName());
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        ExtentReportManager.getTest().pass("Test PASSED");
    }

    @Override
    public void onTestFailure(ITestResult result) {
        ExtentReportManager.getTest().fail(result.getThrowable());

        // Attach screenshot on failure
        try {
            WebDriver driver = DriverManager.getDriver();
            String base64 = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BASE64);
            ExtentReportManager.getTest()
                .addScreenCaptureFromBase64String(base64, "Failure Screenshot");
        } catch (Exception e) {
            ExtentReportManager.getTest().warning("Could not capture screenshot: " + e.getMessage());
        }
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        ExtentReportManager.getTest().skip(result.getThrowable());
    }

    @Override
    public void onFinish(ITestContext context) {
        ExtentReportManager.getInstance().flush(); // CRITICAL — writes report to disk
    }
}
```

### Step 3 — Register in testng.xml

```xml
<suite name="Regression">
    <listeners>
        <listener class-name="listeners.ExtentReportListener"/>
    </listeners>
    <test name="AllTests">
        <classes>
            <class name="tests.LoginTest"/>
        </classes>
    </test>
</suite>
```

### Step 4 — Add Logs in Tests

```java
@Test
public void loginTest() {
    ExtentReportManager.getTest().info("Navigating to login page");
    driver.findElement(By.id("username")).sendKeys("admin");

    ExtentReportManager.getTest().info("Entering credentials");
    driver.findElement(By.id("password")).sendKeys("secret");
    driver.findElement(By.id("loginBtn")).click();

    Assert.assertTrue(driver.getTitle().contains("Dashboard"));
    ExtentReportManager.getTest().pass("Login successful — dashboard loaded");
}
```

### Report Output Features
- Interactive pie chart of pass/fail/skip counts
- Timeline view of test execution
- Embedded screenshots on failures
- System info panel
- Dark/light theme support
- Collapsible test step logs
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','ExtentReports','Reporting','TestNG','ITestListener','Screenshot','HTML Report'],
  true, 0
),

-- Q171
(
  'How do you verify CSS properties like color and font in Selenium?',
  'selenium-q171-verify-css-properties-color-font-selenium',
  'Use getCssValue() to read computed CSS property values from an element — colors are returned in rgba() format which you then convert or compare.',
  $ans$
## Verifying CSS Properties in Selenium

`getCssValue(propertyName)` returns the **computed CSS value** of any property on an element. This is used to verify colors, fonts, borders, visibility, and other visual states.

### Get Color Value

```java
WebElement submitBtn = driver.findElement(By.id("submitBtn"));

// Returns rgba format: "rgba(255, 87, 34, 1)"
String bgColor = submitBtn.getCssValue("background-color");
System.out.println("Background color: " + bgColor);

// Verify specific color
Assert.assertEquals(bgColor, "rgba(255, 87, 34, 1)", "Button color mismatch");
```

### Convert RGBA to HEX (Helper Method)

```java
import org.openqa.selenium.support.Color;

public String rgbaToHex(String rgba) {
    return Color.fromString(rgba).asHex().toUpperCase();
}

// Usage
String rgba = submitBtn.getCssValue("background-color");
String hex = rgbaToHex(rgba); // "#FF5722"
Assert.assertEquals(hex, "#FF5722");
```

### Common CSS Properties to Verify

```java
WebElement element = driver.findElement(By.cssSelector(".error-message"));

// Text color
String color = element.getCssValue("color");

// Font size
String fontSize = element.getCssValue("font-size"); // "16px"

// Font family
String fontFamily = element.getCssValue("font-family");

// Font weight (bold = "700")
String fontWeight = element.getCssValue("font-weight");

// Border
String border = element.getCssValue("border");

// Visibility
String visibility = element.getCssValue("visibility"); // "visible" or "hidden"

// Display
String display = element.getCssValue("display"); // "block", "none", "flex"

// Opacity
String opacity = element.getCssValue("opacity"); // "1" or "0.5"

// Text decoration (underline)
String textDecoration = element.getCssValue("text-decoration");

// Cursor type
String cursor = element.getCssValue("cursor"); // "pointer", "not-allowed"
```

### Real-World Validation Example

```java
@Test
public void verifyErrorMessageStyling() {
    // Trigger error
    driver.findElement(By.id("submitBtn")).click();

    WebElement errorMsg = driver.findElement(By.cssSelector(".error-message"));

    // Verify red color
    String rgba = errorMsg.getCssValue("color");
    String hex = Color.fromString(rgba).asHex();
    Assert.assertEquals(hex.toUpperCase(), "#FF0000", "Error text should be red");

    // Verify bold
    Assert.assertEquals(errorMsg.getCssValue("font-weight"), "700", "Error should be bold");

    // Verify visible
    Assert.assertEquals(errorMsg.getCssValue("display"), "block", "Error should be visible");
}
```

### Verify Hover State

```java
WebElement link = driver.findElement(By.cssSelector("nav a"));

// Before hover
String normalColor = link.getCssValue("color");

// Hover
new Actions(driver).moveToElement(link).perform();

// After hover (may need short wait for CSS transition)
Thread.sleep(300);
String hoverColor = link.getCssValue("color");

Assert.assertNotEquals(normalColor, hoverColor, "Color should change on hover");
```

### Key Notes
- Colors are always returned as `rgba(r, g, b, a)` format regardless of how CSS defines them
- Use `org.openqa.selenium.support.Color.fromString(rgba).asHex()` for hex comparison
- CSS transitions may need a short wait before reading the final value
- `getCssValue("display")` is more reliable than `isDisplayed()` for hidden elements
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','getCssValue','Color','CSS Properties','Visual Validation','rgba','Assertion'],
  true, 0
),

-- Q172
(
  'How do you verify file download in Selenium automation?',
  'selenium-q172-verify-file-download-selenium',
  'Set a custom download directory via ChromeOptions, trigger the download, then verify the file exists in that directory using Java File API.',
  $ans$
## Verifying File Downloads in Selenium

Selenium cannot interact with OS-level download dialogs directly, but you can control the download folder and verify file presence after triggering the download.

### Step 1 — Set Custom Download Directory

```java
String downloadPath = System.getProperty("user.dir") + "/src/test/resources/downloads";

// Create directory if not exists
new File(downloadPath).mkdirs();

Map<String, Object> prefs = new HashMap<>();
prefs.put("download.default_directory", downloadPath);
prefs.put("download.prompt_for_download", false);   // no dialog
prefs.put("download.directory_upgrade", true);
prefs.put("safebrowsing.enabled", true);            // allow downloads

ChromeOptions options = new ChromeOptions();
options.setExperimentalOption("prefs", prefs);
WebDriver driver = new ChromeDriver(options);
```

### Step 2 — Trigger the Download

```java
driver.get("https://example.com/reports");
driver.findElement(By.cssSelector(".download-btn")).click();
```

### Step 3 — Wait for File to Appear

```java
public boolean waitForDownload(String downloadDir, String fileExtension, int timeoutSeconds)
        throws InterruptedException {
    File dir = new File(downloadDir);
    long start = System.currentTimeMillis();
    long timeout = timeoutSeconds * 1000L;

    while (System.currentTimeMillis() - start < timeout) {
        File[] files = dir.listFiles((d, name) ->
            name.endsWith(fileExtension) && !name.endsWith(".crdownload") // exclude in-progress
        );
        if (files != null && files.length > 0) return true;
        Thread.sleep(500);
    }
    return false;
}
```

### Step 4 — Verify File Content

```java
@Test
public void testReportDownload() throws Exception {
    String downloadDir = System.getProperty("user.dir") + "/downloads";
    new File(downloadDir).mkdirs();

    // Clean before test
    Arrays.stream(new File(downloadDir).listFiles()).forEach(File::delete);

    // Trigger download
    driver.findElement(By.id("downloadReport")).click();

    // Wait up to 20 seconds
    boolean downloaded = waitForDownload(downloadDir, ".pdf", 20);
    Assert.assertTrue(downloaded, "PDF file was not downloaded");

    // Verify file name
    File[] files = new File(downloadDir).listFiles((d, n) -> n.endsWith(".pdf"));
    Assert.assertTrue(files[0].getName().contains("report"), "Wrong file downloaded");

    // Verify file size > 0
    Assert.assertTrue(files[0].length() > 0, "Downloaded file is empty");
}
```

### Firefox — Set Download Folder

```java
FirefoxProfile profile = new FirefoxProfile();
profile.setPreference("browser.download.folderList", 2);
profile.setPreference("browser.download.dir", downloadPath);
profile.setPreference("browser.helperApps.neverAsk.saveToDisk",
    "application/pdf,application/octet-stream,text/csv");
profile.setPreference("pdfjs.disabled", true);

FirefoxOptions options = new FirefoxOptions();
options.setProfile(profile);
WebDriver driver = new FirefoxDriver(options);
```

### Headless Chrome Download Fix

Headless Chrome blocks downloads by default. Enable via CDP:

```java
ChromeDriver chromeDriver = (ChromeDriver) driver;
DevTools devTools = chromeDriver.getDevTools();
devTools.createSession();
devTools.send(Browser.setDownloadBehavior(
    Browser.SetDownloadBehaviorBehavior.ALLOW,
    Optional.empty(),
    Optional.of(downloadPath),
    Optional.of(true)
));
```
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','File Download','ChromeOptions','Headless','CDP','Verification','Downloads Folder'],
  true, 0
),

-- Q173
(
  'What are @FindBys and @FindAll annotations in Selenium PageFactory?',
  'selenium-q173-findbys-findall-pagefactory-selenium',
  '@FindBys uses AND logic (all conditions must match) while @FindAll uses OR logic (any condition can match) for locating elements with multiple criteria in PageFactory.',
  $ans$
## @FindBys and @FindAll in PageFactory

These annotations extend `@FindBy` to support **compound locators** — finding elements that satisfy multiple criteria.

### @FindBy (Single Locator)

```java
@FindBy(id = "username")
private WebElement usernameField;
```

### @FindBys — AND Logic (All Must Match)

All inner `@FindBy` conditions must be satisfied (chained lookup):

```java
// Find <input> that is a descendant of <div class="form-group">
// AND has name="email"
@FindBys({
    @FindBy(className = "form-group"),
    @FindBy(name = "email")
})
private WebElement emailInsideFormGroup;
```

**Behavior:** First finds `div.form-group`, then looks for `[name="email"]` **inside** it. Like chained CSS/XPath.

### @FindAll — OR Logic (Any Can Match)

Elements matching **any** of the conditions are returned together:

```java
// Finds ALL elements that are either h1 OR h2 OR h3
@FindAll({
    @FindBy(tagName = "h1"),
    @FindBy(tagName = "h2"),
    @FindBy(tagName = "h3")
})
private List<WebElement> allHeadings;
```

**Behavior:** Union of results from all locators. Returns a list with duplicates possible.

### Practical Examples

```java
public class SearchPage {
    WebDriver driver;

    // Single match
    @FindBy(css = "input[type='search']")
    private WebElement searchInput;

    // AND — find active nav item inside nav bar
    @FindBys({
        @FindBy(className = "navbar"),
        @FindBy(className = "active")
    })
    private WebElement activeNavItem;

    // OR — find all call-to-action buttons (different styles)
    @FindAll({
        @FindBy(className = "btn-primary"),
        @FindBy(className = "btn-cta"),
        @FindBy(css = "a.action-link")
    })
    private List<WebElement> ctaButtons;

    public SearchPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void clickFirstCTA() {
        ctaButtons.get(0).click();
    }
}
```

### Comparison Table

| Annotation | Logic | Use Case |
|---|---|---|
| `@FindBy` | Single locator | Standard element location |
| `@FindBys` | AND (all conditions) | Element nested inside another |
| `@FindAll` | OR (any condition) | Collect elements of multiple types |

### Important Notes
- `@FindBys` chaining requires the elements to be nested — first locator finds a container, subsequent ones search within it
- `@FindAll` can return duplicates if an element matches multiple conditions
- Both work with `List<WebElement>` for multiple elements
- `PageFactory.initElements()` is still required to initialize all `@FindBy*` annotated fields
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','PageFactory','@FindBy','@FindBys','@FindAll','Page Object Model','Locators'],
  true, 0
),

-- Q174
(
  'What is the difference between driver.close() and driver.quit() in Selenium?',
  'selenium-q174-difference-driver-close-vs-quit',
  'driver.close() closes only the current browser window while keeping the WebDriver session alive. driver.quit() closes all windows and ends the entire WebDriver session.',
  $ans$
## driver.close() vs driver.quit()

This is a very commonly asked interview question. The difference is critical in multi-window tests.

### driver.close()

- Closes **only the currently focused browser window/tab**
- The WebDriver session remains **alive**
- Other open windows stay open
- Must switch to another window after closing to continue

```java
String mainWindow = driver.getWindowHandle();

// Open a new tab
driver.switchTo().newWindow(WindowType.TAB);
driver.get("https://google.com");

// Close only this tab
driver.close();

// Switch back to main window — session still active
driver.switchTo().window(mainWindow);
driver.findElement(By.id("element")).click(); // still works
```

### driver.quit()

- Closes **ALL browser windows** opened by this WebDriver session
- Ends the WebDriver session completely
- Kills the browser driver process (chromedriver.exe, geckodriver.exe)
- Releases all resources — no memory leak

```java
// Close all windows and end session
driver.quit();

// After quit(), driver is null — any call throws exception
// driver.findElement(...) → SessionNotCreatedException
```

### Comparison Table

| Aspect | `driver.close()` | `driver.quit()` |
|---|---|---|
| Windows closed | Current window only | All windows |
| WebDriver session | Still alive | Terminated |
| Driver process | Still running | Killed |
| Memory | Partial release | Full release |
| After call | Can continue on other window | Cannot use driver |

### Common Mistake — Memory Leak

```java
// BAD — close() leaves driver process running if only one window
@AfterMethod
public void tearDown() {
    driver.close(); // WRONG — chromedriver.exe still running!
}

// CORRECT — always quit() in teardown
@AfterMethod(alwaysRun = true)
public void tearDown() {
    if (driver != null) {
        driver.quit(); // closes all + kills chromedriver.exe
    }
}
```

### When to Use close()

```java
// Multi-window test: open popup, verify, close it, return to main
String main = driver.getWindowHandle();
driver.findElement(By.linkText("Open Terms")).click();

// Wait for new window
new WebDriverWait(driver, Duration.ofSeconds(5))
    .until(ExpectedConditions.numberOfWindowsToBe(2));

// Work in popup
driver.getWindowHandles().stream()
    .filter(h -> !h.equals(main))
    .forEach(h -> driver.switchTo().window(h));

// Verify content, then close popup
Assert.assertTrue(driver.getTitle().contains("Terms"));
driver.close(); // close just the popup

// Switch back to main
driver.switchTo().window(main);
```

**Rule of thumb:** Use `close()` during test execution to close popup windows. Use `quit()` in `@AfterMethod`/`@AfterTest` to clean up.
  $ans$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium','close','quit','WebDriver','Memory Leak','Windows','Session'],
  true, 0
),

-- Q175
(
  'How do you implement the Hybrid Framework in Selenium?',
  'selenium-q175-hybrid-framework-selenium-implementation',
  'A Hybrid Framework combines Data-Driven, Keyword-Driven, and POM approaches — test data from Excel, keywords from a sheet, and Page Objects for element management.',
  $ans$
## Hybrid Framework Architecture in Selenium

A **Hybrid Framework** combines the best of **Data-Driven** + **Keyword-Driven** + **Page Object Model** approaches. It is the most commonly used framework in real enterprise QA teams.

### Directory Structure

```
SeleniumHybridFramework/
├── src/
│   ├── main/java/
│   │   ├── base/           BaseTest.java
│   │   ├── pages/          LoginPage.java, DashboardPage.java
│   │   ├── utils/          ExcelUtils.java, DriverManager.java
│   │   └── keywords/       KeywordExecutor.java
│   └── test/
│       ├── java/tests/     LoginTest.java
│       └── resources/
│           ├── config.properties
│           └── testdata/   TestData.xlsx
├── testng.xml
└── pom.xml
```

### Layer 1 — Page Object Layer

```java
public class LoginPage {
    @FindBy(id = "username") private WebElement usernameField;
    @FindBy(id = "password") private WebElement passwordField;
    @FindBy(id = "loginBtn") private WebElement loginBtn;

    public LoginPage(WebDriver driver) {
        PageFactory.initElements(driver, this);
    }

    public void login(String user, String pass) {
        usernameField.sendKeys(user);
        passwordField.sendKeys(pass);
        loginBtn.click();
    }
}
```

### Layer 2 — Data-Driven (Excel)

```java
public class ExcelUtils {
    private XSSFWorkbook workbook;

    public ExcelUtils(String filePath) throws Exception {
        workbook = new XSSFWorkbook(new FileInputStream(filePath));
    }

    public String getCellData(String sheetName, int row, int col) {
        return workbook.getSheet(sheetName).getRow(row).getCell(col).getStringCellValue();
    }

    public int getRowCount(String sheetName) {
        return workbook.getSheet(sheetName).getLastRowNum();
    }
}
```

### Layer 3 — Keyword Engine

```java
public class KeywordExecutor {
    private WebDriver driver;

    public KeywordExecutor(WebDriver driver) { this.driver = driver; }

    public void execute(String keyword, String locator, String value) {
        WebElement el;
        switch (keyword.toUpperCase()) {
            case "CLICK"    -> driver.findElement(By.xpath(locator)).click();
            case "TYPE"     -> { el = driver.findElement(By.xpath(locator));
                                 el.clear(); el.sendKeys(value); }
            case "VERIFY"   -> Assert.assertEquals(
                                 driver.findElement(By.xpath(locator)).getText(), value);
            case "NAVIGATE" -> driver.get(value);
            case "WAIT"     -> new WebDriverWait(driver, Duration.ofSeconds(Integer.parseInt(value)))
                                 .until(ExpectedConditions.visibilityOfElementLocated(By.xpath(locator)));
        }
    }
}
```

### Layer 4 — TestNG Test + DataProvider

```java
public class LoginTest extends BaseTest {
    @Test(dataProvider = "loginData")
    public void loginTest(String username, String password, String expected) {
        LoginPage loginPage = new LoginPage(DriverManager.getDriver());
        loginPage.login(username, password);
        Assert.assertTrue(DriverManager.getDriver().getTitle().contains(expected));
    }

    @DataProvider(name = "loginData")
    public Object[][] loginData() throws Exception {
        ExcelUtils excel = new ExcelUtils("src/test/resources/testdata/TestData.xlsx");
        int rows = excel.getRowCount("Login");
        Object[][] data = new Object[rows][3];
        for (int i = 0; i < rows; i++) {
            data[i][0] = excel.getCellData("Login", i + 1, 0); // username
            data[i][1] = excel.getCellData("Login", i + 1, 1); // password
            data[i][2] = excel.getCellData("Login", i + 1, 2); // expected
        }
        return data;
    }
}
```

### Framework Benefits

| Benefit | How Achieved |
|---|---|
| Easy maintenance | POM — one place to update locators |
| Business-readable | Keyword-driven test sheets |
| Multiple data sets | Excel DataProvider |
| Parallel execution | ThreadLocal driver + TestNG |
| Reports | ExtentReports listener |
| CI/CD ready | Maven + Jenkins |
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Hybrid Framework','POM','Data-Driven','Keyword-Driven','Excel','TestNG','Architecture'],
  true, 0
),

-- Q176
(
  'How do you handle SSL certificate errors in Selenium?',
  'selenium-q176-handle-ssl-certificate-errors-selenium',
  'Use browser-specific Options to set acceptInsecureCerts(true), which tells WebDriver to accept self-signed or expired certificates without warnings.',
  $ans$
## Handling SSL Certificate Errors in Selenium

SSL errors appear when sites use self-signed, expired, or untrusted certificates — common in staging/test environments. Selenium provides browser-specific settings to bypass them.

### Chrome — ChromeOptions

```java
ChromeOptions options = new ChromeOptions();
options.setAcceptInsecureCerts(true); // accept any SSL cert

WebDriver driver = new ChromeDriver(options);
driver.get("https://self-signed.badssl.com/"); // no SSL warning
```

### Firefox — FirefoxOptions

```java
FirefoxOptions options = new FirefoxOptions();
options.setAcceptInsecureCerts(true);

WebDriver driver = new FirefoxDriver(options);
```

### Edge — EdgeOptions

```java
EdgeOptions options = new EdgeOptions();
options.setAcceptInsecureCerts(true);

WebDriver driver = new EdgeDriver(options);
```

### RemoteWebDriver (Selenium Grid)

```java
ChromeOptions options = new ChromeOptions();
options.setAcceptInsecureCerts(true);

WebDriver driver = new RemoteWebDriver(
    new URL("http://localhost:4444/wd/hub"), options
);
```

### Chrome Additional Flags for Strict Environments

```java
ChromeOptions options = new ChromeOptions();
options.setAcceptInsecureCerts(true);
options.addArguments("--ignore-certificate-errors");
options.addArguments("--allow-insecure-localhost");
options.addArguments("--disable-web-security");
```

### Handle "Your connection is not private" Page

If the warning page does appear (e.g., when flag doesn''t work in some configs):

```java
driver.get("https://problematic-site.com");

// Check if on warning page
if (driver.getTitle().contains("Privacy error") ||
    driver.getPageSource().contains("NET::ERR_CERT")) {

    // Click "Advanced" → "Proceed" (Chrome-specific element IDs)
    driver.findElement(By.id("details-button")).click();
    driver.findElement(By.id("proceed-link")).click();
}
```

### Verify Site Still Works

```java
ChromeOptions options = new ChromeOptions();
options.setAcceptInsecureCerts(true);
WebDriver driver = new ChromeDriver(options);

driver.get("https://staging.myapp.com");
Assert.assertEquals(driver.getTitle(), "Dashboard | MyApp");
```

### Important Notes
- `setAcceptInsecureCerts(true)` is the **W3C standard** approach — works across all browsers
- Only use in **test/staging** environments — never disable SSL in production automation
- For API testing with self-signed certs, use `trustAllCerts()` in Rest Assured separately
  $ans$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','SSL','Certificate Error','ChromeOptions','acceptInsecureCerts','HTTPS','Security'],
  true, 0
),

-- Q177
(
  'What is Allure Report and how does it compare to ExtentReports?',
  'selenium-q177-allure-report-vs-extentreports-selenium',
  'Allure is a lightweight, framework-agnostic report tool with beautiful interactive UI, step-level detail, and built-in CI/CD support — often preferred over ExtentReports for modern frameworks.',
  $ans$
## Allure Report vs ExtentReports

Both generate HTML test reports, but they differ in philosophy, setup, and features.

### Allure Report Setup (Maven)

```xml
<dependency>
    <groupId>io.qameta.allure</groupId>
    <artifactId>allure-testng</artifactId>
    <version>2.25.0</version>
</dependency>
```

**testng.xml listener:**
```xml
<listeners>
    <listener class-name="io.qameta.allure.testng.AllureTestNg"/>
</listeners>
```

**No manual listener code needed** — Allure hooks into TestNG automatically.

### Allure Annotations

```java
import io.qameta.allure.*;

@Epic("User Management")
@Feature("Login")
public class LoginTest extends BaseTest {

    @Test
    @Story("Valid user can login")
    @Severity(SeverityLevel.CRITICAL)
    @Description("Verify that a valid user is redirected to dashboard after login")
    @Link(name = "JIRA", url = "https://jira.company.com/browse/QA-123")
    public void validLoginTest() {
        Allure.step("Navigate to login page", () -> {
            driver.get("https://automateqa.online/login");
        });
        Allure.step("Enter credentials", () -> {
            driver.findElement(By.id("username")).sendKeys("admin");
            driver.findElement(By.id("password")).sendKeys("secret");
        });
        Allure.step("Click login button", () -> {
            driver.findElement(By.id("loginBtn")).click();
        });
        Assert.assertTrue(driver.getTitle().contains("Dashboard"));
    }
}
```

### Attach Screenshot to Allure

```java
@Attachment(value = "Screenshot", type = "image/png")
public byte[] takeScreenshot() {
    return ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
}

// Call on failure in listener
@Override
public void onTestFailure(ITestResult result) {
    takeScreenshot();
}
```

### Generate Report

```bash
mvn test
allure serve target/allure-results  # opens browser with interactive report
# OR
allure generate target/allure-results -o allure-report --clean
```

### Allure vs ExtentReports Comparison

| Feature | Allure | ExtentReports |
|---|---|---|
| Setup effort | Low (auto listener) | Medium (manual listener code) |
| Report quality | Very modern, interactive | Professional, chart-based |
| CI/CD integration | Native (Jenkins plugin) | Manual configuration |
| Step-level detail | Yes (`@Step`, `Allure.step()`) | Manual logs only |
| Severity / epics | `@Severity`, `@Epic`, `@Feature` | No built-in |
| History & trends | Yes (needs history folder) | No |
| Languages | Multi-language | Java primarily |
| File size | Small (JSON + server) | Large (self-contained HTML) |

### Allure Jenkins Integration

```groovy
// Jenkinsfile
post {
    always {
        allure([results: [[path: 'target/allure-results']]])
    }
}
```

**When to choose:**
- **Allure** → modern projects, CI/CD first, need epic/story/severity hierarchy
- **ExtentReports** → quick setup, standalone HTML, team prefers embedded screenshots
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Selenium','Allure','ExtentReports','Reporting','TestNG','Jenkins','CI/CD','HTML Report'],
  true, 0
),

-- Q178
(
  'How do you use WebDriverManager in Selenium and why is it better than manual driver setup?',
  'selenium-q178-webdrivermanager-selenium-automatic-driver',
  'WebDriverManager automatically downloads and configures the correct browser driver version at runtime, eliminating manual driver path setup and version mismatch issues.',
  $ans$
## WebDriverManager in Selenium

Without WebDriverManager, you must manually download `chromedriver.exe`, match its version to the installed Chrome, and set the system property path. This breaks every time Chrome auto-updates.

### Manual Setup (Old Way — Error-Prone)

```java
// Bad — breaks when Chrome updates
System.setProperty("webdriver.chrome.driver", "C:/drivers/chromedriver.exe");
WebDriver driver = new ChromeDriver();
```

### WebDriverManager (Modern Way)

```xml
<!-- pom.xml -->
<dependency>
    <groupId>io.github.bonigarcia</groupId>
    <artifactId>webdrivermanager</artifactId>
    <version>5.7.0</version>
</dependency>
```

```java
// Automatically downloads correct chromedriver for installed Chrome
WebDriverManager.chromedriver().setup();
WebDriver driver = new ChromeDriver();
```

### All Supported Browsers

```java
WebDriverManager.chromedriver().setup();   // Chrome
WebDriverManager.firefoxdriver().setup();  // Firefox (geckodriver)
WebDriverManager.edgedriver().setup();     // Edge
WebDriverManager.safaridriver().setup();   // Safari
WebDriverManager.operadriver().setup();    // Opera
WebDriverManager.chromiumdriver().setup(); // Chromium
```

### Advanced Configuration

```java
// Force a specific driver version
WebDriverManager.chromedriver().driverVersion("114.0.5735.90").setup();

// Use specific browser version
WebDriverManager.chromedriver().browserVersion("114").setup();

// Use proxy for corporate networks
WebDriverManager.chromedriver()
    .proxy("http://proxy.company.com:8080")
    .setup();

// Cache drivers locally (useful for offline CI environments)
WebDriverManager.chromedriver()
    .cachePath("/opt/selenium-drivers")
    .setup();
```

### Using with Different Browser Configs

```java
public WebDriver initDriver(String browser) {
    return switch (browser.toLowerCase()) {
        case "chrome"   -> { WebDriverManager.chromedriver().setup();
                             yield new ChromeDriver(); }
        case "firefox"  -> { WebDriverManager.firefoxdriver().setup();
                             yield new FirefoxDriver(); }
        case "edge"     -> { WebDriverManager.edgedriver().setup();
                             yield new EdgeDriver(); }
        default         -> throw new IllegalArgumentException("Unsupported: " + browser);
    };
}
```

### Selenium 4.6+ — Driver Manager Built In

Selenium 4.6+ includes auto-driver management without WebDriverManager dependency:

```java
// No setup() call needed in Selenium 4.6+
WebDriver driver = new ChromeDriver(); // auto-manages driver
```

### Why WebDriverManager is Better

| Aspect | Manual Setup | WebDriverManager |
|---|---|---|
| Version matching | Manual — breaks on Chrome update | Automatic |
| CI/CD setup | Driver file must be in repo or CI agent | Zero config |
| Multiple browsers | Multiple manual downloads | One line each |
| Corporate proxy | Manual env config | `.proxy()` option |
| Maintenance | Constant updating | Fully automated |
  $ans$,
  'Selenium', 'Technical', '1-2 Years', 'Beginner',
  ARRAY['Selenium','WebDriverManager','ChromeDriver','Driver Setup','Maven','CI/CD','Bonigarcia'],
  true, 0
),

-- Q179
(
  'What is the Robot class in Java and when do you use it in Selenium?',
  'selenium-q179-robot-class-java-selenium',
  'Robot class simulates real OS-level keyboard and mouse events — useful for handling OS-level dialogs, file uploads via dialog boxes, and keyboard shortcuts Selenium cannot handle.',
  $ans$
## Robot Class in Selenium

`java.awt.Robot` simulates **native operating system** keyboard and mouse events — not browser-level like Selenium. It is used when WebDriver cannot reach OS-level pop-ups.

### When to Use Robot Class

- OS file upload dialogs (not HTML input)
- Windows authentication pop-ups
- Print dialogs
- Keyboard shortcuts at OS level (Win key, Alt+F4)
- Moving/clicking outside browser window

### Setup and Basic Usage

```java
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.awt.Toolkit;
import java.awt.datatransfer.StringSelection;

Robot robot = new Robot();
```

### Handle OS File Upload Dialog

```java
// Click button that opens OS file upload dialog
driver.findElement(By.id("uploadBtn")).click();
Thread.sleep(1000); // wait for OS dialog to appear

// Type file path using clipboard (handles special chars/spaces)
StringSelection filePathSelection = new StringSelection("C:\\test\\sample.pdf");
Toolkit.getDefaultToolkit().getSystemClipboard().setContents(filePathSelection, null);

robot.keyPress(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_V);    // Ctrl+V to paste
robot.keyRelease(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_CONTROL);

Thread.sleep(500);
robot.keyPress(KeyEvent.VK_ENTER); // Press Enter to confirm
robot.keyRelease(KeyEvent.VK_ENTER);
```

### Keyboard Shortcuts

```java
// Press Tab key
robot.keyPress(KeyEvent.VK_TAB);
robot.keyRelease(KeyEvent.VK_TAB);

// Press Enter
robot.keyPress(KeyEvent.VK_ENTER);
robot.keyRelease(KeyEvent.VK_ENTER);

// Press Escape
robot.keyPress(KeyEvent.VK_ESCAPE);
robot.keyRelease(KeyEvent.VK_ESCAPE);

// Ctrl+A (Select All)
robot.keyPress(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_A);
robot.keyRelease(KeyEvent.VK_A);
robot.keyRelease(KeyEvent.VK_CONTROL);

// Alt+F4 (Close window)
robot.keyPress(KeyEvent.VK_ALT);
robot.keyPress(KeyEvent.VK_F4);
robot.keyRelease(KeyEvent.VK_F4);
robot.keyRelease(KeyEvent.VK_ALT);
```

### Mouse Operations

```java
// Move mouse to specific screen coordinates
robot.mouseMove(500, 300);

// Left click
robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);

// Right click
robot.mousePress(InputEvent.BUTTON3_DOWN_MASK);
robot.mouseRelease(InputEvent.BUTTON3_DOWN_MASK);
```

### Important Limitations
- Works only when tests run on a **machine with a display** (not headless servers)
- Not cross-platform reliable — coordinate-based clicks depend on screen resolution
- Does not work inside Docker containers or CI without virtual display (Xvfb on Linux)
- Prefer `sendKeys()` on `<input type="file">` for file uploads over Robot when possible

### Robot vs Actions vs JavascriptExecutor

| Capability | Robot | Actions | JavascriptExecutor |
|---|---|---|---|
| OS dialogs | ✓ | ✗ | ✗ |
| Browser elements | ✗ | ✓ | ✓ |
| Keyboard shortcuts | ✓ (OS level) | ✓ (browser) | ✗ |
| Drag & drop | ✓ | ✓ | ✓ |
| Headless support | ✗ | ✓ | ✓ |
  $ans$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','Robot Class','Java AWT','File Upload','OS Dialog','Keyboard','Mouse'],
  true, 0
),

-- Q180
(
  'How do you handle infinite scrolling pages in Selenium?',
  'selenium-q180-handle-infinite-scroll-selenium',
  'Use JavascriptExecutor to scroll to the bottom of the page in a loop, waiting for new content to load each time, until no more items are added.',
  $ans$
## Handling Infinite Scrolling in Selenium

Infinite scroll pages (like LinkedIn, Twitter, Instagram) load more content as you scroll down instead of using pagination.

### Method 1 — Scroll to Page Bottom (Loop)

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
long lastHeight = (long) js.executeScript("return document.body.scrollHeight");

while (true) {
    // Scroll to bottom
    js.executeScript("window.scrollTo(0, document.body.scrollHeight);");

    // Wait for new content to load
    Thread.sleep(2000);

    long newHeight = (long) js.executeScript("return document.body.scrollHeight");

    if (newHeight == lastHeight) {
        // No new content loaded — we''ve reached the end
        break;
    }
    lastHeight = newHeight;
}

System.out.println("Reached end of infinite scroll");
```

### Method 2 — Scroll Until Target Count Reached

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
JavascriptExecutor js = (JavascriptExecutor) driver;

int targetCount = 50;
int previousCount = 0;

while (true) {
    List<WebElement> items = driver.findElements(By.cssSelector(".feed-item"));

    if (items.size() >= targetCount) break;

    if (items.size() == previousCount) {
        System.out.println("No new items loaded. Stopping.");
        break;
    }

    previousCount = items.size();

    // Scroll last item into view
    js.executeScript("arguments[0].scrollIntoView(true);", items.get(items.size() - 1));

    // Wait for new items to load
    wait.until(d -> d.findElements(By.cssSelector(".feed-item")).size() > previousCount);
}
```

### Method 3 — Scroll N Times (When Count Unknown)

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
int scrollTimes = 10;

for (int i = 0; i < scrollTimes; i++) {
    js.executeScript("window.scrollBy(0, 1000);"); // scroll 1000px down
    Thread.sleep(1500); // wait for content
}

// Collect all loaded items
List<WebElement> allItems = driver.findElements(By.cssSelector(".product-card"));
System.out.println("Total items loaded: " + allItems.size());
```

### Method 4 — Scroll to Specific Element (Load Until Found)

```java
String targetText = "Selenium Framework";
JavascriptExecutor js = (JavascriptExecutor) driver;
boolean found = false;

for (int attempt = 0; attempt < 20 && !found; attempt++) {
    List<WebElement> items = driver.findElements(By.cssSelector(".item-title"));

    for (WebElement item : items) {
        if (item.getText().contains(targetText)) {
            found = true;
            item.click();
            break;
        }
    }

    if (!found) {
        js.executeScript("window.scrollTo(0, document.body.scrollHeight);");
        Thread.sleep(1500);
    }
}

Assert.assertTrue(found, "Target item '" + targetText + "' not found after scrolling");
```

### Extract All Data After Full Scroll

```java
// First scroll through entire page
scrollToBottom(driver);

// Then collect all loaded data
List<WebElement> allProducts = driver.findElements(By.cssSelector(".product"));
List<String> productNames = allProducts.stream()
    .map(WebElement::getText)
    .collect(Collectors.toList());

System.out.println("Total products: " + productNames.size());
```
  $ans$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','Infinite Scroll','JavascriptExecutor','scrollIntoView','Dynamic Loading','WebDriverWait'],
  true, 0
);
