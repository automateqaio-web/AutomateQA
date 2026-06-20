-- Page Object Model & Framework Design Questions Q1–Q35 | Paste into Supabase SQL Editor

-- ══════════════════════════════════════
-- BEGINNER (Q1–Q8)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Page Object Model (POM)? Why is it used in Selenium automation?',
  'what-is-page-object-model-pom',
  'POM is a design pattern where each web page has a corresponding Java class that holds its locators and actions. It separates test logic from UI interaction, making tests maintainable and reusable.',
  $$## Page Object Model (POM)

**Page Object Model** is a design pattern in Selenium automation where each **web page** (or significant page component) is represented as a **Java class** containing:
- All element locators for that page
- All interaction methods (click, type, get text) for those elements

Test classes then call these page methods instead of directly interacting with elements.

## Why Use POM?

```
WITHOUT POM — tests are brittle:

@Test
public void testLogin() {
    driver.findElement(By.id("email")).sendKeys("user@test.com");
    driver.findElement(By.id("password")).sendKeys("pass123");
    driver.findElement(By.id("login-btn")).click();
    // If id="email" changes to id="user-email"...
    // You must update EVERY test that uses this locator!
}
```

```
WITH POM — one change fixes everything:

// LoginPage.java — locators defined ONCE
By emailField = By.id("email");   // change here only

// Test calls the page method
loginPage.login("user@test.com", "pass123");
// No locator in the test — test survives UI change!
```

## Benefits of POM

| Benefit | Explanation |
|---------|------------|
| **Maintainability** | Locator changes in one place (page class), not in every test |
| **Reusability** | `loginPage.login()` called from 50 tests — write once |
| **Readability** | Tests read like business steps: `cartPage.addToCart("Laptop")` |
| **Separation of Concerns** | Test logic ≠ UI interaction code |
| **Team scalability** | QA team can work on different pages independently |

## Basic POM Implementation

```java
// LoginPage.java — Page Object
public class LoginPage {
    private WebDriver driver;

    // 1. Locators
    private By emailField   = By.id("email");
    private By passwordField = By.id("password");
    private By loginButton  = By.cssSelector("[data-testid='login-btn']");
    private By errorMessage = By.className("error-msg");

    // 2. Constructor
    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    // 3. Actions
    public void enterEmail(String email) {
        driver.findElement(emailField).sendKeys(email);
    }

    public void enterPassword(String password) {
        driver.findElement(passwordField).sendKeys(password);
    }

    public void clickLogin() {
        driver.findElement(loginButton).click();
    }

    // 4. Composite action — combines multiple steps
    public DashboardPage login(String email, String password) {
        enterEmail(email);
        enterPassword(password);
        clickLogin();
        return new DashboardPage(driver);   // returns next page
    }

    // 5. Assertions / getters
    public String getErrorMessage() {
        return driver.findElement(errorMessage).getText();
    }

    public boolean isErrorDisplayed() {
        return driver.findElement(errorMessage).isDisplayed();
    }
}
```

## Test Using POM

```java
// LoginTest.java — clean, readable test
public class LoginTest {
    WebDriver driver;
    LoginPage loginPage;

    @BeforeMethod
    public void setup() {
        driver = new ChromeDriver();
        driver.get("https://automateqa.online/login");
        loginPage = new LoginPage(driver);
    }

    @Test
    public void testValidLogin() {
        DashboardPage dashboard = loginPage.login("user@test.com", "pass123");
        Assert.assertTrue(dashboard.isWelcomeMessageDisplayed());
    }

    @Test
    public void testInvalidLogin() {
        loginPage.login("wrong@test.com", "wrongpass");
        Assert.assertEquals(loginPage.getErrorMessage(), "Invalid credentials");
    }

    @AfterMethod
    public void teardown() {
        driver.quit();
    }
}
```$$,
  'Page Object Model', 'Technical', 'Fresher', 'Beginner',
  ARRAY['POM', 'Page Object Model', 'Design Pattern', 'Selenium', 'Maintainability', 'Reusability'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between Page Object Model and Page Factory in Selenium?',
  'pom-vs-page-factory-selenium',
  'POM is a design pattern. Page Factory is a Selenium tool (@FindBy annotations + PageFactory.initElements()) that implements POM. Page Factory uses lazy initialization — elements are located only when used.',
  $$## POM vs Page Factory

**POM** is the design pattern concept (separate page classes with locators + actions).
**Page Factory** is a Selenium built-in tool that implements POM using annotations.

## POM Without Page Factory (Manual)

```java
public class LoginPage {
    private WebDriver driver;

    // Locators defined as By objects
    private By emailInput    = By.id("email");
    private By passwordInput = By.id("password");
    private By loginBtn      = By.cssSelector("[data-testid='login-btn']");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void login(String email, String password) {
        // Element found EVERY TIME method is called
        driver.findElement(emailInput).sendKeys(email);
        driver.findElement(passwordInput).sendKeys(password);
        driver.findElement(loginBtn).click();
    }
}
```

## Page Factory (Annotation-Based)

```java
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LoginPage {
    private WebDriver driver;

    // @FindBy annotations replace By.id(), By.css() etc.
    @FindBy(id = "email")
    private WebElement emailInput;

    @FindBy(id = "password")
    private WebElement passwordInput;

    @FindBy(css = "[data-testid='login-btn']")
    private WebElement loginBtn;

    @FindBy(className = "error-msg")
    private WebElement errorMessage;

    // Multiple locators — tries each until one works
    @FindAll({
        @FindBy(id = "submit"),
        @FindBy(css = "button[type='submit']")
    })
    private WebElement submitBtn;

    // List of elements
    @FindBy(css = ".product-card")
    private List<WebElement> productCards;

    public LoginPage(WebDriver driver) {
        this.driver = driver;
        // This initializes all @FindBy elements (lazy — located on first use)
        PageFactory.initElements(driver, this);
    }

    public void login(String email, String password) {
        emailInput.sendKeys(email);      // clean — no driver.findElement()
        passwordInput.sendKeys(password);
        loginBtn.click();
    }

    public String getErrorText() {
        return errorMessage.getText();
    }
}
```

## @FindBy Locator Strategies

```java
@FindBy(id = "email")                          // By.id
@FindBy(name = "username")                      // By.name
@FindBy(className = "error-msg")               // By.className
@FindBy(tagName = "h1")                        // By.tagName
@FindBy(linkText = "Forgot Password")          // By.linkText
@FindBy(partialLinkText = "Forgot")            // By.partialLinkText
@FindBy(css = ".btn.btn-primary")              // By.cssSelector (most used)
@FindBy(xpath = "//button[@type='submit']")    // By.xpath
```

## Key Differences

| | POM (Manual) | Page Factory |
|--|-------------|-------------|
| Locator syntax | `By.id("email")` | `@FindBy(id = "email")` |
| Element type | Located fresh each call | Proxy — located on first access |
| Stale element | Less issue | Can get `StaleElementReferenceException` |
| Initialization | Not needed | `PageFactory.initElements()` required |
| Readability | Good | Better (less boilerplate) |
| Dynamic elements | Easier to handle | Can be tricky |

## When Stale Element is a Problem (Page Factory)

```java
// Page Factory can cause StaleElementReferenceException
// if DOM changes AFTER initElements() but BEFORE the element is used

// Solution: re-initialize on stale
public WebElement getElement(WebElement element) {
    try {
        return element;
    } catch (StaleElementReferenceException e) {
        PageFactory.initElements(driver, this);  // reinitialize
        return element;
    }
}
```$$,
  'Page Object Model', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Page Factory', 'POM', '@FindBy', 'PageFactory.initElements', 'Selenium', 'Design Pattern'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is a BasePage class in POM? Why do you need it?',
  'base-page-class-pom-selenium',
  'BasePage is a parent class all page objects extend. It holds the WebDriver reference, common utilities (wait, click, type, scroll), and shared methods — avoiding code duplication across every page class.',
  $$## BasePage Class in POM

**BasePage** is the parent class that all Page Object classes extend. It centralises:
- WebDriver reference
- WebDriverWait instance
- Common utility methods (click, type, wait, scroll, check visibility)

## BasePage Implementation

```java
// BasePage.java
public class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait   = new WebDriverWait(driver, Duration.ofSeconds(15));
    }

    // ── Element interactions ───────────────────────────────────────

    protected void click(By locator) {
        waitForClickable(locator).click();
    }

    protected void type(By locator, String text) {
        WebElement el = waitForVisible(locator);
        el.clear();
        el.sendKeys(text);
    }

    protected String getText(By locator) {
        return waitForVisible(locator).getText().trim();
    }

    protected String getAttributeValue(By locator, String attr) {
        return waitForPresent(locator).getAttribute(attr);
    }

    protected boolean isDisplayed(By locator) {
        try {
            return driver.findElement(locator).isDisplayed();
        } catch (NoSuchElementException e) {
            return false;
        }
    }

    // ── Wait utilities ─────────────────────────────────────────────

    protected WebElement waitForVisible(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    protected WebElement waitForClickable(By locator) {
        return wait.until(ExpectedConditions.elementToBeClickable(locator));
    }

    protected WebElement waitForPresent(By locator) {
        return wait.until(ExpectedConditions.presenceOfElementLocated(locator));
    }

    protected void waitForInvisible(By locator) {
        wait.until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }

    protected void waitForTextInElement(By locator, String text) {
        wait.until(ExpectedConditions.textToBePresentInElementLocated(locator, text));
    }

    // ── Navigation ─────────────────────────────────────────────────

    protected void navigateTo(String url) {
        driver.get(url);
    }

    protected String getCurrentUrl() {
        return driver.getCurrentUrl();
    }

    protected String getTitle() {
        return driver.getTitle();
    }

    // ── Scroll ────────────────────────────────────────────────────

    protected void scrollToElement(By locator) {
        WebElement el = driver.findElement(locator);
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", el);
    }

    protected void scrollToBottom() {
        ((JavascriptExecutor) driver).executeScript("window.scrollTo(0, document.body.scrollHeight);");
    }

    // ── Dropdown ──────────────────────────────────────────────────

    protected void selectByText(By locator, String text) {
        new Select(waitForPresent(locator)).selectByVisibleText(text);
    }

    protected void selectByValue(By locator, String value) {
        new Select(waitForPresent(locator)).selectByValue(value);
    }

    // ── Screenshot ────────────────────────────────────────────────

    protected void takeScreenshot(String name) {
        File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        try {
            FileUtils.copyFile(src, new File("screenshots/" + name + ".png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## Page Classes Extending BasePage

```java
// LoginPage.java
public class LoginPage extends BasePage {
    // Locators
    private By emailInput    = By.id("email");
    private By passwordInput = By.id("password");
    private By loginBtn      = By.cssSelector("[data-testid='login-btn']");
    private By errorMsg      = By.className("error-msg");

    public LoginPage(WebDriver driver) {
        super(driver);   // calls BasePage constructor
    }

    public DashboardPage login(String email, String password) {
        type(emailInput, email);          // BasePage method
        type(passwordInput, password);    // BasePage method
        click(loginBtn);                  // BasePage method
        return new DashboardPage(driver);
    }

    public String getError() {
        return getText(errorMsg);         // BasePage method
    }
}

// DashboardPage.java
public class DashboardPage extends BasePage {
    private By welcomeMsg = By.cssSelector("h1.welcome");
    private By logoutBtn  = By.id("logout");

    public DashboardPage(WebDriver driver) {
        super(driver);
    }

    public boolean isWelcomeDisplayed() {
        return isDisplayed(welcomeMsg);   // BasePage method
    }

    public LoginPage logout() {
        click(logoutBtn);                 // BasePage method
        return new LoginPage(driver);
    }
}
```

## Benefits of BasePage

- One place to modify wait strategy (e.g., change 15s → 20s)
- All pages automatically get updated utility methods
- No copy-paste of `new WebDriverWait(driver, Duration.ofSeconds(15))` in every page
- Easy to add new helpers (hover, JS click, file upload) — all pages inherit it$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['BasePage', 'POM', 'Inheritance', 'WebDriverWait', 'Selenium', 'Framework', 'Reusability'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are the different types of test automation frameworks?',
  'types-test-automation-frameworks',
  'Main framework types: Linear (record-playback), Modular (reusable modules), Data-Driven (data from external source), Keyword-Driven (action keywords), Hybrid (data + keyword + POM), BDD (Gherkin/Cucumber).',
  $$## Types of Test Automation Frameworks

## 1. Linear (Record & Playback)

Tests are recorded and played back. No reuse, no abstraction.

```java
// Everything hardcoded in one test — no structure
@Test
public void test() {
    driver.get("https://example.com");
    driver.findElement(By.id("user")).sendKeys("alice");
    driver.findElement(By.id("pass")).sendKeys("pass123");
    driver.findElement(By.id("btn")).click();
    Assert.assertEquals(driver.getTitle(), "Dashboard");
}
// ❌ Not reusable, breaks on any UI change
```
**Use when**: Quick POC, small one-time scripts

## 2. Modular Framework

Tests broken into reusable modules (login module, checkout module).

```java
// Modules are reusable methods
public class AuthModule {
    public static void login(WebDriver d, String user, String pass) {
        d.findElement(By.id("user")).sendKeys(user);
        d.findElement(By.id("pass")).sendKeys(pass);
        d.findElement(By.id("btn")).click();
    }
}
// Tests call the module
AuthModule.login(driver, "alice", "pass123");
```
**Use when**: Medium projects, small teams

## 3. Data-Driven Framework

Test logic is fixed; **test data comes from external source** (Excel, CSV, JSON, DB).

```java
// TestNG DataProvider reads from Excel
@DataProvider(name = "loginData")
public Object[][] getLoginData() throws IOException {
    return ExcelUtil.readData("testdata/login.xlsx", "LoginSheet");
    // Returns: [["alice","pass1","valid"], ["wrong","pass","invalid"], ...]
}

@Test(dataProvider = "loginData")
public void testLogin(String user, String pass, String expected) {
    loginPage.login(user, pass);
    Assert.assertEquals(loginPage.getResult(), expected);
}
// Same test code runs with 10 different data sets
```
**Use when**: Multiple data combinations (login, registration, payment)

## 4. Keyword-Driven Framework

Actions are defined as **keywords** in a spreadsheet. Non-technical staff can write tests.

```
| Keyword        | Object        | Value             |
|----------------|--------------|-------------------|
| OpenBrowser    | Chrome        |                   |
| NavigateTo     |               | https://example.com|
| EnterText      | emailField    | alice@test.com    |
| EnterText      | passwordField | pass123           |
| Click          | loginButton   |                   |
| VerifyText     | welcomeMsg    | Welcome Alice     |
```

```java
// Framework reads keywords and executes them
switch (keyword) {
    case "OpenBrowser": DriverManager.init(value); break;
    case "EnterText":   driver.findElement(OR.get(object)).sendKeys(value); break;
    case "Click":       driver.findElement(OR.get(object)).click(); break;
}
```
**Use when**: Business analysts/manual testers write test cases

## 5. Hybrid Framework (Most Common in Industry)

Combines **Data-Driven + Keyword-Driven + POM**. Most enterprise frameworks are hybrid.

```
Hybrid Framework =
  POM        (page classes, locators separated)
+ Data-Driven (Excel/JSON test data)
+ Modular     (reusable utilities)
+ Reporting   (Extent/Allure)
+ Config      (properties file for env/browser)
+ Logging     (Log4j)
```

## 6. BDD Framework (Behaviour Driven Development)

Tests written in **Gherkin** (plain English). Business + Dev + QA collaborate.

```gherkin
# login.feature
Feature: User Login

  Scenario: Valid login
    Given user is on the login page
    When user enters email "alice@test.com" and password "Pass@123"
    And user clicks the login button
    Then user should be redirected to dashboard
    And welcome message should be displayed
```

```java
// Step definitions — connects Gherkin to Selenium code
@Given("user is on the login page")
public void navigateToLogin() {
    driver.get("https://example.com/login");
}

@When("user enters email {string} and password {string}")
public void enterCredentials(String email, String pass) {
    loginPage.enterEmail(email);
    loginPage.enterPassword(pass);
}
```
**Use when**: Cross-functional teams, living documentation needed

## Framework Comparison

| Framework | Maintenance | Skill Required | Reusability |
|-----------|------------|---------------|-------------|
| Linear | Very Hard | Low | None |
| Modular | Medium | Medium | Medium |
| Data-Driven | Easy | Medium | High |
| Keyword-Driven | Easy | Low (users) / High (builders) | High |
| Hybrid | Easy | High | Very High |
| BDD | Medium | Medium | High |$$,
  'Page Object Model', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Framework Types', 'Data-Driven', 'Keyword-Driven', 'Hybrid', 'BDD', 'Modular', 'Selenium'], true, 0
);

-- ══════════════════════════════════════
-- INTERMEDIATE (Q5–Q20)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you design a hybrid test automation framework from scratch?',
  'hybrid-framework-design-selenium-java',
  'A hybrid framework combines POM, data-driven testing, configuration management, logging, and reporting. Key layers: Driver management, Page Objects, Test Data, Utilities, Test Classes, and Reporting.',
  $$## Hybrid Framework Architecture

## Folder Structure

```
selenium-hybrid-framework/
├── src/
│   ├── main/java/com/automateqa/
│   │   ├── config/
│   │   │   └── ConfigReader.java       ← reads config.properties
│   │   ├── driver/
│   │   │   └── DriverManager.java      ← WebDriver init/quit
│   │   ├── pages/
│   │   │   ├── BasePage.java           ← common utilities
│   │   │   ├── LoginPage.java
│   │   │   └── DashboardPage.java
│   │   └── utils/
│   │       ├── ExcelUtil.java          ← read test data from Excel
│   │       ├── WaitUtil.java           ← explicit waits
│   │       └── ScreenshotUtil.java     ← capture screenshots
│   └── test/java/com/automateqa/
│       ├── base/
│       │   └── BaseTest.java           ← @BeforeMethod / @AfterMethod
│       ├── tests/
│       │   ├── LoginTest.java
│       │   └── CheckoutTest.java
│       └── listeners/
│           └── TestListener.java       ← TestNG listener for reports
├── src/test/resources/
│   ├── testdata/
│   │   └── LoginData.xlsx
│   ├── config/
│   │   ├── config.properties           ← browser, baseUrl, timeout
│   │   └── staging.properties
│   └── testng.xml
└── pom.xml
```

## Layer 1 — Configuration

```java
// config/ConfigReader.java
public class ConfigReader {
    private static Properties props = new Properties();

    static {
        try {
            String env  = System.getProperty("env", "config");
            FileInputStream fis = new FileInputStream(
                "src/test/resources/config/" + env + ".properties");
            props.load(fis);
        } catch (IOException e) {
            throw new RuntimeException("config.properties not found", e);
        }
    }

    public static String get(String key) {
        return System.getProperty(key, props.getProperty(key));
    }
}
```

```properties
# config/config.properties
browser=chrome
baseUrl=https://staging.automateqa.online
implicitWait=10
explicitWait=15
headless=false
```

## Layer 2 — Driver Management

```java
// driver/DriverManager.java
public class DriverManager {
    private static ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    public static WebDriver getDriver() {
        return driver.get();
    }

    public static void init() {
        String browser  = ConfigReader.get("browser");
        boolean headless = Boolean.parseBoolean(ConfigReader.get("headless"));

        WebDriver d;
        switch (browser.toLowerCase()) {
            case "firefox":
                FirefoxOptions ffOpts = new FirefoxOptions();
                if (headless) ffOpts.addArguments("--headless");
                d = new FirefoxDriver(ffOpts);
                break;
            case "edge":
                d = new EdgeDriver();
                break;
            default:  // chrome
                ChromeOptions opts = new ChromeOptions();
                if (headless) opts.addArguments("--headless=new", "--no-sandbox",
                                                "--disable-dev-shm-usage");
                d = new ChromeDriver(opts);
        }
        d.manage().window().maximize();
        d.manage().timeouts().implicitlyWait(
            Duration.ofSeconds(Long.parseLong(ConfigReader.get("implicitWait"))));
        driver.set(d);
    }

    public static void quit() {
        if (driver.get() != null) {
            driver.get().quit();
            driver.remove();
        }
    }
}
```

## Layer 3 — BaseTest

```java
// base/BaseTest.java
public class BaseTest {

    @BeforeMethod(alwaysRun = true)
    public void setUp(Method method) {
        DriverManager.init();
        DriverManager.getDriver().get(ConfigReader.get("baseUrl"));
        LogUtil.info("=== Starting: " + method.getName() + " ===");
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            ScreenshotUtil.capture(result.getName());
            LogUtil.error("TEST FAILED: " + result.getName());
        }
        DriverManager.quit();
    }
}
```

## Layer 4 — Test with Data Provider

```java
// tests/LoginTest.java
public class LoginTest extends BaseTest {

    @DataProvider(name = "loginData", parallel = false)
    public Object[][] loginData() throws Exception {
        return ExcelUtil.readData("src/test/resources/testdata/LoginData.xlsx", "Sheet1");
        // Returns: [["valid","alice@t.com","Pass@123","Dashboard"],
        //           ["invalid","wrong@t.com","bad","Invalid credentials"]]
    }

    @Test(dataProvider = "loginData", groups = {"smoke", "regression"})
    public void testLogin(String scenario, String email, String pass, String expected) {
        LogUtil.info("Running: " + scenario);
        LoginPage loginPage = new LoginPage(DriverManager.getDriver());
        loginPage.login(email, pass);

        if (scenario.equals("valid")) {
            DashboardPage dash = new DashboardPage(DriverManager.getDriver());
            Assert.assertTrue(dash.isWelcomeDisplayed(), "Dashboard not shown");
        } else {
            Assert.assertEquals(loginPage.getError(), expected);
        }
    }
}
```

## Layer 5 — Extent Report Listener

```java
// listeners/TestListener.java
public class TestListener implements ITestListener {
    private static ExtentReports extent = ExtentManager.getInstance();
    private static ThreadLocal<ExtentTest> test = new ThreadLocal<>();

    @Override
    public void onTestStart(ITestResult result) {
        ExtentTest extentTest = extent.createTest(result.getMethod().getMethodName());
        test.set(extentTest);
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        test.get().pass("Test passed");
    }

    @Override
    public void onTestFailure(ITestResult result) {
        test.get().fail(result.getThrowable());
        String screenshotPath = ScreenshotUtil.capture(result.getName());
        test.get().addScreenCaptureFromPath(screenshotPath);
    }

    @Override
    public void onFinish(ITestContext context) {
        extent.flush();
    }
}
```$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Hybrid Framework', 'Framework Design', 'ConfigReader', 'DriverManager', 'BaseTest', 'Extent Reports', 'Selenium'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you implement Data-Driven Testing in Selenium using TestNG DataProvider and Excel?',
  'data-driven-testing-testng-dataprovider-excel',
  'Use @DataProvider in TestNG to supply test data. Read from Excel using Apache POI library. Each row becomes one test iteration. Allows the same test to run with different inputs without code duplication.',
  $$## Data-Driven Testing with TestNG + Excel

## Add Apache POI Dependency (pom.xml)

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.5</version>
</dependency>
```

## Test Data File (LoginData.xlsx)

```
| scenario | email              | password  | expected         |
|----------|-------------------|-----------|-----------------|
| valid    | alice@test.com    | Pass@123  | Dashboard       |
| invalid  | wrong@test.com    | wrongpass | Invalid credentials |
| empty    |                   |           | Email is required|
| locked   | locked@test.com   | Pass@123  | Account locked  |
```

## ExcelUtil — Read Data

```java
// utils/ExcelUtil.java
public class ExcelUtil {

    public static Object[][] readData(String filePath, String sheetName) throws IOException {
        FileInputStream fis       = new FileInputStream(filePath);
        XSSFWorkbook   workbook   = new XSSFWorkbook(fis);
        XSSFSheet      sheet      = workbook.getSheet(sheetName);

        int rowCount = sheet.getLastRowNum();            // skip header row
        int colCount = sheet.getRow(0).getLastCellNum();

        Object[][] data = new Object[rowCount][colCount];

        for (int row = 1; row <= rowCount; row++) {          // start from row 1 (skip header)
            XSSFRow currentRow = sheet.getRow(row);
            for (int col = 0; col < colCount; col++) {
                XSSFCell cell = currentRow.getCell(col);
                data[row - 1][col] = getCellValue(cell);
            }
        }
        workbook.close();
        fis.close();
        return data;
    }

    private static String getCellValue(XSSFCell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:  return cell.getStringCellValue();
            case NUMERIC: return String.valueOf((long) cell.getNumericCellValue());
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            default:      return "";
        }
    }
}
```

## Test Using @DataProvider

```java
// tests/LoginTest.java
public class LoginTest extends BaseTest {

    // DataProvider reads from Excel
    @DataProvider(name = "loginData")
    public Object[][] getLoginData() throws IOException {
        return ExcelUtil.readData(
            "src/test/resources/testdata/LoginData.xlsx", "Login");
    }

    @Test(dataProvider = "loginData")
    public void testLogin(String scenario, String email, String pass, String expected) {
        LoginPage login = new LoginPage(DriverManager.getDriver());
        login.login(email, pass);

        if (scenario.equals("valid")) {
            Assert.assertTrue(
                new DashboardPage(DriverManager.getDriver()).isLoaded(),
                "Dashboard not loaded for: " + scenario);
        } else {
            Assert.assertEquals(login.getError(), expected,
                "Error message mismatch for: " + scenario);
        }
    }
}
```

## Inline DataProvider (Without Excel)

```java
// For simple cases — hardcoded in test class
@DataProvider(name = "searchTerms")
public Object[][] searchData() {
    return new Object[][] {
        { "Selenium",   true  },
        { "Cypress",    true  },
        { "xyznothing", false },
    };
}

@Test(dataProvider = "searchTerms")
public void testSearch(String term, boolean hasResults) {
    homePage.search(term);
    Assert.assertEquals(resultsPage.hasResults(), hasResults);
}
```

## DataProvider from JSON (Alternative to Excel)

```java
@DataProvider(name = "usersJson")
public Object[][] getUsersFromJson() throws Exception {
    ObjectMapper mapper = new ObjectMapper();
    JsonNode root = mapper.readTree(new File("src/test/resources/testdata/users.json"));
    Object[][] data = new Object[root.size()][3];
    for (int i = 0; i < root.size(); i++) {
        data[i][0] = root.get(i).get("email").asText();
        data[i][1] = root.get(i).get("password").asText();
        data[i][2] = root.get(i).get("role").asText();
    }
    return data;
}
```

## Parallel DataProvider Execution

```java
// Run each data row in parallel (separate threads)
@DataProvider(name = "loginData", parallel = true)
public Object[][] parallelData() throws IOException {
    return ExcelUtil.readData("testdata/login.xlsx", "Sheet1");
}
// Requires ThreadLocal WebDriver in DriverManager!
```$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Data-Driven Testing', 'DataProvider', 'Apache POI', 'Excel', 'TestNG', 'Selenium', 'Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you handle configuration management in a Selenium framework?',
  'selenium-framework-configuration-management',
  'Store environment-specific config (URL, browser, credentials) in .properties files. Read via Properties class. Override with system properties for CI/CD. Use separate files per environment (staging, qa, prod).',
  $$## Configuration Management in Selenium Framework

## config.properties

```properties
# src/test/resources/config/config.properties

# Browser
browser=chrome
headless=false

# Timeouts (seconds)
implicit.wait=10
explicit.wait=15
page.load.timeout=30

# URLs
base.url=https://staging.automateqa.online
api.base.url=https://api.staging.automateqa.online

# Test data
test.user.email=testuser@automateqa.com
test.user.password=Test@123

# Reports
report.dir=test-output/reports
screenshot.dir=test-output/screenshots
```

## Environment-Specific Files

```
src/test/resources/config/
├── config.properties      ← default (staging)
├── qa.properties          ← QA environment
└── prod.properties        ← production (read-only tests)
```

```properties
# qa.properties
base.url=https://qa.automateqa.online
test.user.email=qa_test@automateqa.com
```

## ConfigReader — Singleton

```java
// config/ConfigReader.java
public class ConfigReader {
    private static Properties properties;

    // Singleton — load only once
    private static Properties getProperties() {
        if (properties == null) {
            properties = new Properties();
            // env can be passed via Maven: -Denv=qa
            String env = System.getProperty("env", "config");
            String path = "src/test/resources/config/" + env + ".properties";
            try (FileInputStream fis = new FileInputStream(path)) {
                properties.load(fis);
            } catch (IOException e) {
                throw new RuntimeException("Cannot load: " + path, e);
            }
        }
        return properties;
    }

    // System properties override file values (great for CI/CD)
    public static String get(String key) {
        return System.getProperty(key, getProperties().getProperty(key));
    }

    public static int getInt(String key) {
        return Integer.parseInt(get(key));
    }

    public static boolean getBoolean(String key) {
        return Boolean.parseBoolean(get(key));
    }

    // Typed getters for common config
    public static String getBrowser()     { return get("browser"); }
    public static String getBaseUrl()     { return get("base.url"); }
    public static boolean isHeadless()    { return getBoolean("headless"); }
    public static int getExplicitWait()   { return getInt("explicit.wait"); }
}
```

## Usage in Framework

```java
// DriverManager reads browser type from config
String browser = ConfigReader.getBrowser();

// BaseTest reads URL from config
driver.get(ConfigReader.getBaseUrl());

// Tests use credentials from config
loginPage.login(
    ConfigReader.get("test.user.email"),
    ConfigReader.get("test.user.password")
);
```

## Override Config in CI/CD (Maven / GitHub Actions)

```bash
# Switch environment via Maven system property
mvn test -Denv=qa -Dbrowser=firefox -Dheadless=true

# In GitHub Actions
- run: mvn test
  env:
    # These override config.properties values
  with:
  # Pass as system property
- run: mvn test -Denv=qa -Dbase.url=${{ secrets.QA_URL }} -Dheadless=true
```

## testng.xml — Pass Parameters to Tests

```xml
<suite name="Automation Suite">
    <parameter name="browser" value="chrome"/>
    <parameter name="env"     value="staging"/>

    <test name="Smoke Tests">
        <classes>
            <class name="com.automateqa.tests.LoginTest"/>
        </classes>
    </test>
</suite>
```

```java
// Read TestNG parameter in BaseTest
@Parameters({"browser", "env"})
@BeforeMethod
public void setUp(@Optional("chrome") String browser,
                  @Optional("staging") String env) {
    System.setProperty("browser", browser);
    System.setProperty("env",     env);
    DriverManager.init();
}
```$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Configuration Management', 'Properties File', 'ConfigReader', 'Selenium', 'Framework', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you implement Extent Reports in a Selenium TestNG framework?',
  'extent-reports-selenium-testng-framework',
  'Add ExtentReports dependency, create an ExtentManager singleton, implement a TestNG ITestListener that creates test nodes on start and logs pass/fail/screenshot on finish. Flush at the end of the suite.',
  $$## Extent Reports in Selenium TestNG

## Dependency (pom.xml)

```xml
<dependency>
    <groupId>com.aventstack</groupId>
    <artifactId>extentreports</artifactId>
    <version>5.1.1</version>
</dependency>
```

## ExtentManager — Singleton Report Instance

```java
// utils/ExtentManager.java
public class ExtentManager {
    private static ExtentReports extent;

    public static ExtentReports getInstance() {
        if (extent == null) {
            ExtentSparkReporter spark = new ExtentSparkReporter("test-output/ExtentReport.html");
            spark.config().setDocumentTitle("AutomateQA Test Report");
            spark.config().setReportName("Regression Suite");
            spark.config().setTheme(Theme.DARK);

            extent = new ExtentReports();
            extent.attachReporter(spark);
            extent.setSystemInfo("OS",      System.getProperty("os.name"));
            extent.setSystemInfo("Browser", ConfigReader.getBrowser());
            extent.setSystemInfo("Env",     ConfigReader.getBaseUrl());
        }
        return extent;
    }
}
```

## TestNG Listener

```java
// listeners/TestListener.java
public class TestListener implements ITestListener, ISuiteListener {
    private static ExtentReports        extent = ExtentManager.getInstance();
    private static ThreadLocal<ExtentTest> test = new ThreadLocal<>();

    @Override
    public void onTestStart(ITestResult result) {
        String testName = result.getMethod().getMethodName();
        String desc     = result.getMethod().getDescription();

        ExtentTest extentTest = extent.createTest(testName, desc);
        // Add categories from TestNG groups
        for (String group : result.getMethod().getGroups()) {
            extentTest.assignCategory(group);
        }
        test.set(extentTest);
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        test.get().pass("✅ Test PASSED");
    }

    @Override
    public void onTestFailure(ITestResult result) {
        test.get().fail(result.getThrowable());

        // Attach screenshot
        String path = ScreenshotUtil.capture(result.getName());
        test.get().addScreenCaptureFromPath(path, "Failure Screenshot");
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        test.get().skip("⚠️ Test SKIPPED: " + result.getThrowable().getMessage());
    }

    @Override
    public void onFinish(ISuite suite) {
        extent.flush();   // write HTML file
        System.out.println("Report: test-output/ExtentReport.html");
    }
}
```

## Register Listener in testng.xml

```xml
<suite name="Suite">
    <listeners>
        <listener class-name="com.automateqa.listeners.TestListener"/>
    </listeners>

    <test name="Regression">
        <classes>
            <class name="com.automateqa.tests.LoginTest"/>
            <class name="com.automateqa.tests.DashboardTest"/>
        </classes>
    </test>
</suite>
```

## ScreenshotUtil

```java
// utils/ScreenshotUtil.java
public class ScreenshotUtil {
    public static String capture(String testName) {
        File src = ((TakesScreenshot) DriverManager.getDriver())
                       .getScreenshotAs(OutputType.FILE);
        String dir  = "test-output/screenshots/";
        String name = testName + "_" + LocalDateTime.now()
                          .format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".png";
        String path = dir + name;
        try {
            new File(dir).mkdirs();
            FileUtils.copyFile(src, new File(path));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return path;
    }
}
```

## Log Within Tests (Optional)

```java
// In any test — log steps to the Extent report
@Test
public void testLogin() {
    ExtentTestLogger.log("Navigating to login page");
    loginPage.visit();

    ExtentTestLogger.log("Entering credentials");
    loginPage.login("alice@test.com", "Pass@123");

    ExtentTestLogger.log("Verifying dashboard");
    Assert.assertTrue(dashPage.isLoaded());
}

// Where ExtentTestLogger accesses ThreadLocal test:
public class ExtentTestLogger {
    public static void log(String msg) {
        TestListener.getCurrentTest().info(msg);
    }
}
```$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Extent Reports', 'TestNG Listener', 'Reporting', 'ITestListener', 'Selenium', 'Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is fluent interface / method chaining in POM? Show an example.',
  'fluent-interface-method-chaining-pom',
  'Method chaining (fluent interface) means each page method returns the page object itself (return this) or the next page, enabling readable test code like loginPage.enterEmail().enterPassword().clickLogin().',
  $$## Fluent Interface / Method Chaining in POM

**Method chaining** makes tests read like a natural sentence by returning `this` (same page) or the next page object from each method.

## Without Method Chaining (Verbose)

```java
@Test
public void testCheckout() {
    loginPage.enterEmail("alice@test.com");
    loginPage.enterPassword("Pass@123");
    loginPage.clickLogin();

    productPage.searchProduct("Laptop");
    productPage.selectProduct("MacBook Pro");
    productPage.clickAddToCart();

    cartPage.clickCheckout();
    cartPage.enterAddress("123 QA Street");
    cartPage.clickPlaceOrder();

    Assert.assertTrue(confirmPage.isOrderConfirmed());
}
```

## With Method Chaining (Clean & Readable)

```java
@Test
public void testCheckout() {
    boolean confirmed = loginPage
        .enterEmail("alice@test.com")
        .enterPassword("Pass@123")
        .clickLogin()                     // returns ProductPage
        .searchProduct("Laptop")
        .selectProduct("MacBook Pro")
        .clickAddToCart()                 // returns CartPage
        .clickCheckout()                  // returns CheckoutPage
        .enterAddress("123 QA Street")
        .clickPlaceOrder()                // returns ConfirmPage
        .isOrderConfirmed();

    Assert.assertTrue(confirmed);
}
```

## Implementation — Return This (Same Page)

```java
// LoginPage.java
public class LoginPage extends BasePage {
    private By emailInput    = By.id("email");
    private By passwordInput = By.id("password");
    private By loginBtn      = By.cssSelector("[data-testid='login-btn']");

    public LoginPage(WebDriver driver) { super(driver); }

    public LoginPage enterEmail(String email) {
        type(emailInput, email);
        return this;   // ← returns same page
    }

    public LoginPage enterPassword(String password) {
        type(passwordInput, password);
        return this;   // ← returns same page
    }

    public ProductPage clickLogin() {
        click(loginBtn);
        return new ProductPage(driver);   // ← returns NEXT page
    }
}
```

```java
// ProductPage.java
public class ProductPage extends BasePage {
    private By searchInput   = By.id("search");
    private By addToCartBtn  = By.cssSelector("[data-testid='add-to-cart']");

    public ProductPage(WebDriver driver) { super(driver); }

    public ProductPage searchProduct(String name) {
        type(searchInput, name);
        driver.findElement(By.id("search-btn")).click();
        return this;
    }

    public ProductPage selectProduct(String productName) {
        click(By.xpath("//h3[text()='" + productName + "']"));
        return this;
    }

    public CartPage clickAddToCart() {
        click(addToCartBtn);
        return new CartPage(driver);   // ← transition to next page
    }
}
```

## Complex Chaining — With Assertions Built In

```java
// Return this even from assertion methods for chain continuation
public LoginPage verifyErrorMessage(String expected) {
    String actual = getText(errorMsg);
    Assert.assertEquals(actual, expected, "Error message mismatch");
    return this;   // can continue chaining
}

// Usage:
loginPage
    .enterEmail("bad@test.com")
    .enterPassword("wrong")
    .clickLoginExpectingError()
    .verifyErrorMessage("Invalid credentials")
    .verifyEmailFieldHighlighted();
```

## Benefits

- **Readability** — test reads like a user story
- **Fewer variables** — no need to store intermediate page objects
- **Conciseness** — fewer lines of code
- **Business alignment** — PO/BA can read and verify the test flow$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Fluent Interface', 'Method Chaining', 'POM', 'Selenium', 'Design Pattern', 'Readability'], true, 0
);

-- ══════════════════════════════════════
-- ADVANCED / SCENARIO-BASED
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you handle dynamic elements and StaleElementReferenceException in POM?',
  'handle-dynamic-elements-stale-element-pom',
  'For dynamic elements, use flexible locators (contains, starts-with XPath). For StaleElementReferenceException, re-find the element or use explicit wait with ExpectedConditions.refreshed().',
  $$## Handling Dynamic Elements in POM

## Problem: Dynamic IDs / Attributes

```html
<!-- ID changes every page load — unusable locator -->
<button id="btn-29xk7q">Submit</button>

<!-- Use stable attributes instead -->
<button data-testid="submit-btn" class="btn-primary">Submit</button>
```

## Stable Locator Strategies

```java
// ❌ Fragile — dynamic ID
By fragile = By.id("btn-29xk7q");

// ✅ Stable alternatives
By byTestId  = By.cssSelector("[data-testid='submit-btn']");
By byClass   = By.className("btn-primary");
By byText    = By.xpath("//button[text()='Submit']");
By contains  = By.xpath("//button[contains(text(),'Submit')]");
By startsWith = By.xpath("//button[starts-with(@id,'btn-')]");
By ancestor  = By.xpath("//div[@class='form-footer']//button");
By following = By.xpath("//label[text()='Name']/following-sibling::input");
```

## Dynamic Table Row Locator

```java
// Find row containing specific text
public WebElement getTableRowByName(String name) {
    return driver.findElement(
        By.xpath("//table//tr[td[text()='" + name + "']]")
    );
}

// Find delete button in a specific row
public void deleteUser(String username) {
    String xpath = "//tr[td[text()='" + username + "']]//button[@data-action='delete']";
    click(By.xpath(xpath));
}
```

## StaleElementReferenceException

Occurs when the DOM is refreshed/updated **after** you found an element but **before** you interacted with it.

### Common Causes
- Page refreshes or redirects
- AJAX updates part of the DOM
- Angular/React re-renders the component

### Fix 1 — Re-find Element

```java
protected void clickWithRetry(By locator) {
    int attempts = 0;
    while (attempts < 3) {
        try {
            driver.findElement(locator).click();
            return;
        } catch (StaleElementReferenceException e) {
            attempts++;
            if (attempts == 3) throw e;
        }
    }
}
```

### Fix 2 — ExpectedConditions.refreshed()

```java
protected WebElement waitForRefreshed(By locator) {
    return wait.until(
        ExpectedConditions.refreshed(
            ExpectedConditions.elementToBeClickable(locator)
        )
    );
}

// Usage
waitForRefreshed(By.id("save-btn")).click();
```

### Fix 3 — Don't Store WebElements (Re-find Every Time)

```java
// ❌ Storing element — goes stale after DOM update
WebElement btn = driver.findElement(By.id("save-btn"));
doSomethingThatUpdatesDOM();
btn.click();   // StaleElementReferenceException!

// ✅ Find fresh every time
By saveBtn = By.id("save-btn");
driver.findElement(saveBtn);   // fresh find each time
```

## Handling Loading Spinners / Overlays

```java
// Wait for spinner to disappear before interacting
protected void waitForSpinner() {
    By spinner = By.cssSelector(".loading-spinner");
    try {
        // Wait for spinner to appear (might miss it if fast)
        new WebDriverWait(driver, Duration.ofSeconds(2))
            .until(ExpectedConditions.visibilityOfElementLocated(spinner));
    } catch (TimeoutException ignored) {}

    // Wait for spinner to disappear
    wait.until(ExpectedConditions.invisibilityOfElementLocated(spinner));
}

// Usage in BasePage before any click
protected void click(By locator) {
    waitForSpinner();   // ensure overlay is gone
    waitForClickable(locator).click();
}
```

## Dynamic Dropdowns (Angular/React)

```java
public void selectFromCustomDropdown(String containerSelector, String optionText) {
    // Click trigger
    click(By.cssSelector(containerSelector));

    // Wait for options panel to appear
    By options = By.cssSelector(containerSelector + " .dropdown-option");
    waitForVisible(options);

    // Click the right option
    driver.findElements(options).stream()
        .filter(el -> el.getText().trim().equals(optionText))
        .findFirst()
        .orElseThrow(() -> new NoSuchElementException("Option not found: " + optionText))
        .click();
}
```$$,
  'Page Object Model', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Dynamic Elements', 'StaleElementReferenceException', 'XPath', 'POM', 'Selenium', 'Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you implement parallel test execution with ThreadLocal WebDriver in a Selenium framework?',
  'parallel-test-execution-threadlocal-webdriver',
  'Use ThreadLocal<WebDriver> in DriverManager so each thread gets its own driver instance. Set parallel="methods" or parallel="tests" in testng.xml. This prevents thread interference in parallel runs.',
  $$## Parallel Test Execution with ThreadLocal WebDriver

## Why ThreadLocal?

Without ThreadLocal, a shared static `WebDriver` causes thread interference:
```
Thread 1: opens Chrome → clicks Login
Thread 2: opens Chrome → OVERWRITES driver reference
Thread 1: tries to click → NullPointerException or wrong browser!
```

With ThreadLocal, **each thread gets its own WebDriver**:
```
Thread 1: driver = ChromeDriver #1 → clicks Login
Thread 2: driver = ChromeDriver #2 → independent
No interference!
```

## DriverManager with ThreadLocal

```java
// driver/DriverManager.java
public class DriverManager {

    // ThreadLocal stores separate driver per thread
    private static ThreadLocal<WebDriver> driverThread = new ThreadLocal<>();

    public static WebDriver getDriver() {
        return driverThread.get();
    }

    public static void initDriver(String browser, boolean headless) {
        WebDriver driver;

        switch (browser.toLowerCase()) {
            case "firefox":
                FirefoxOptions ffOpts = new FirefoxOptions();
                if (headless) ffOpts.addArguments("--headless");
                driver = new FirefoxDriver(ffOpts);
                break;

            case "edge":
                driver = new EdgeDriver();
                break;

            default: // chrome
                ChromeOptions opts = new ChromeOptions();
                if (headless) opts.addArguments(
                    "--headless=new", "--no-sandbox",
                    "--disable-dev-shm-usage", "--window-size=1920,1080");
                driver = new ChromeDriver(opts);
        }

        driver.manage().window().maximize();
        driver.manage().timeouts()
              .implicitlyWait(Duration.ofSeconds(10));

        driverThread.set(driver);   // set for THIS thread only
    }

    public static void quitDriver() {
        if (driverThread.get() != null) {
            driverThread.get().quit();
            driverThread.remove();   // IMPORTANT: prevent memory leak
        }
    }
}
```

## BaseTest — Parallel-Safe Setup

```java
// base/BaseTest.java
public class BaseTest {

    @BeforeMethod(alwaysRun = true)
    public void setUp(Method method) {
        String browser  = ConfigReader.getBrowser();
        boolean headless = ConfigReader.isHeadless();

        DriverManager.initDriver(browser, headless);
        DriverManager.getDriver().get(ConfigReader.getBaseUrl());
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            ScreenshotUtil.capture(result.getName());
        }
        DriverManager.quitDriver();   // quits THIS thread's driver
    }
}
```

## testng.xml — Enable Parallel Execution

```xml
<!-- Run each test METHOD in parallel (max 3 at a time) -->
<suite name="Parallel Suite" parallel="methods" thread-count="3">
    <test name="Regression">
        <classes>
            <class name="com.automateqa.tests.LoginTest"/>
            <class name="com.automateqa.tests.SearchTest"/>
            <class name="com.automateqa.tests.CheckoutTest"/>
        </classes>
    </test>
</suite>

<!-- OR: run each <test> block in parallel (different env/browser) -->
<suite name="Cross-Browser Suite" parallel="tests" thread-count="3">
    <test name="Chrome Tests">
        <parameter name="browser" value="chrome"/>
        <classes><class name="com.automateqa.tests.SmokeTest"/></classes>
    </test>
    <test name="Firefox Tests">
        <parameter name="browser" value="firefox"/>
        <classes><class name="com.automateqa.tests.SmokeTest"/></classes>
    </test>
    <test name="Edge Tests">
        <parameter name="browser" value="edge"/>
        <classes><class name="com.automateqa.tests.SmokeTest"/></classes>
    </test>
</suite>
```

## Thread-Safe Extent Reports Logging

```java
// Use ThreadLocal for ExtentTest too!
public class TestListener implements ITestListener {
    private static ExtentReports                extent = ExtentManager.getInstance();
    private static ThreadLocal<ExtentTest>       test   = new ThreadLocal<>();

    public static ExtentTest getTest() { return test.get(); }

    @Override
    public void onTestStart(ITestResult result) {
        test.set(extent.createTest(result.getMethod().getMethodName()));
    }

    @Override
    public void onTestSuccess(ITestResult result) { test.get().pass("PASSED"); }

    @Override
    public void onTestFailure(ITestResult result) {
        test.get().fail(result.getThrowable());
        test.get().addScreenCaptureFromPath(ScreenshotUtil.capture(result.getName()));
    }

    @Override
    public void onFinish(ITestContext context) { extent.flush(); }
}
```$$,
  'Page Object Model', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Parallel Execution', 'ThreadLocal', 'WebDriver', 'TestNG', 'Framework', 'Selenium', 'thread-count'], true, 0
);
