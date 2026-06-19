-- Selenium Q38–Q50 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to switch to an iframe in Selenium WebDriver?',
  'how-to-switch-to-iframe-in-selenium-webdriver',
  'Use driver.switchTo().frame() to enter an iframe context before interacting with elements inside it.',
  $$An **iframe** embeds another HTML document inside the current page. Selenium must switch context into the iframe before interacting with its elements.

**Switch by index:**
```java
driver.switchTo().frame(0);
```

**Switch by name or id:**
```java
driver.switchTo().frame("iframeName");
driver.switchTo().frame("iframeId");
```

**Switch by WebElement:**
```java
WebElement iframe = driver.findElement(By.tagName("iframe"));
driver.switchTo().frame(iframe);
```

**Interact with elements inside iframe:**
```java
driver.switchTo().frame("loginFrame");
driver.findElement(By.id("username")).sendKeys("admin");
driver.findElement(By.id("password")).sendKeys("pass123");
driver.findElement(By.id("loginBtn")).click();
```

**Switch back to main document:**
```java
driver.switchTo().defaultContent();
```

**Switch to parent frame (nested iframes):**
```java
driver.switchTo().parentFrame();
```

**Best practice — always switch back:**
```java
try {
    driver.switchTo().frame("myFrame");
    // interact with elements
} finally {
    driver.switchTo().defaultContent();
}
```$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'iFrame', 'Frame', 'switchTo', 'Context Switching'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is JavascriptExecutor in Selenium?',
  'what-is-javascriptexecutor-in-selenium',
  'JavascriptExecutor is a Selenium interface that lets you run JavaScript code directly in the browser during test execution.',
  $$**JavascriptExecutor** is an interface in Selenium WebDriver that allows executing JavaScript code within the browser context.

**Cast the driver:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
```

**Common use cases:**

**Click hidden element:**
```java
WebElement btn = driver.findElement(By.id("hiddenBtn"));
js.executeScript("arguments[0].click();", btn);
```

**Scroll to element:**
```java
WebElement el = driver.findElement(By.id("footer"));
js.executeScript("arguments[0].scrollIntoView(true);", el);
```

**Scroll to bottom of page:**
```java
js.executeScript("window.scrollTo(0, document.body.scrollHeight);");
```

**Set input field value (bypasses readonly):**
```java
js.executeScript("arguments[0].value=''test@email.com'';", emailField);
```

**Get page title:**
```java
String title = (String) js.executeScript("return document.title;");
```

**Highlight element for debugging:**
```java
js.executeScript("arguments[0].style.border=''3px solid red'';", element);
```

**When to use JavascriptExecutor:**
- Element is not interactable via normal Selenium methods
- Need to scroll to a specific position
- Setting readonly or disabled field values
- Triggering custom JS events$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'JavascriptExecutor', 'JavaScript', 'WebDriver'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to take a screenshot in Selenium WebDriver?',
  'how-to-take-screenshot-in-selenium-webdriver',
  'Use TakesScreenshot interface with getScreenshotAs() to capture and save browser screenshots during test execution.',
  $$Use the **`TakesScreenshot`** interface to capture screenshots in Selenium.

**Full screenshot:**
```java
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.OutputType;
import org.apache.commons.io.FileUtils;
import java.io.File;

File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(screenshot, new File("screenshots/test-failure.png"));
```

**Save with timestamp:**
```java
String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
File dest = new File("screenshots/screenshot_" + timestamp + ".png");
FileUtils.copyFile(((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE), dest);
```

**Screenshot of specific element (Selenium 4):**
```java
WebElement element = driver.findElement(By.id("loginForm"));
File elementScreenshot = element.getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(elementScreenshot, new File("screenshots/login-form.png"));
```

**Capture on test failure in TestNG:**
```java
@AfterMethod
public void captureOnFailure(ITestResult result) throws IOException {
    if (result.getStatus() == ITestResult.FAILURE) {
        File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(src, new File("failures/" + result.getName() + ".png"));
    }
}
```$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Screenshots', 'TakesScreenshot', 'Reporting'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle alerts and popups in Selenium WebDriver?',
  'how-to-handle-alerts-popups-in-selenium-webdriver',
  'Use driver.switchTo().alert() to interact with JavaScript alert, confirm, and prompt dialog boxes.',
  $$JavaScript alerts are native browser dialogs. Use `driver.switchTo().alert()` to handle them.

**Alert types:**
| Type | Description |
|------|-------------|
| `alert()` | Info message with OK button |
| `confirm()` | Question with OK and Cancel |
| `prompt()` | Input request with OK and Cancel |

**Accept (click OK):**
```java
Alert alert = driver.switchTo().alert();
System.out.println("Alert text: " + alert.getText());
alert.accept();
```

**Dismiss (click Cancel):**
```java
driver.switchTo().alert().dismiss();
```

**Type into prompt:**
```java
Alert prompt = driver.switchTo().alert();
prompt.sendKeys("My input text");
prompt.accept();
```

**Wait for alert before switching:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.alertIsPresent());
Alert alert = driver.switchTo().alert();
alert.accept();
```

> **Common error:** `NoAlertPresentException` — alert has not appeared yet. Always use `ExpectedConditions.alertIsPresent()` before switching.$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Alerts', 'Popups', 'switchTo', 'JavaScript Alert'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle dynamic web elements in Selenium?',
  'how-to-handle-dynamic-web-elements-in-selenium',
  'Handle dynamic elements using XPath contains(), starts-with(), explicit waits, and stable relative locators.',
  $$Dynamic elements change their attributes on each page load. Here are strategies to handle them:

**1. Use contains() in XPath for partial attribute match:**
```java
driver.findElement(By.xpath("//*[contains(@id, ''username'')]"));
```

**2. Use starts-with() for predictable prefixes:**
```java
driver.findElement(By.xpath("//input[starts-with(@name, ''search'')]"));
```

**3. Use stable attributes (data-*, aria-*, name):**
```java
driver.findElement(By.cssSelector("[data-testid=''login-btn'']"));
driver.findElement(By.cssSelector("[aria-label=''Search'']"));
```

**4. Use text-based XPath:**
```java
driver.findElement(By.xpath("//button[text()=''Submit Order'']"));
driver.findElement(By.xpath("//label[contains(text(),''First Name'')]/following-sibling::input"));
```

**5. Use Explicit Wait for elements that load dynamically:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
WebElement el = wait.until(ExpectedConditions.visibilityOfElementLocated(
    By.xpath("//div[@class=''result-item'']")
));
```

**6. Relative Locators (Selenium 4):**
```java
WebElement emailField = driver.findElement(
    RelativeLocator.with(By.tagName("input")).below(By.id("userLabel"))
);
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Dynamic Elements', 'XPath', 'Waits', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the Page Object Model (POM) design pattern in Selenium?',
  'what-is-page-object-model-pom-in-selenium',
  'Page Object Model is a design pattern that creates separate Java classes for each web page to store locators and actions.',
  $$**Page Object Model (POM)** is a design pattern where each web page is represented as a separate Java class. The class stores all the page''s locators and the methods to interact with them.

**Benefits:**
- Reusable code — one class for all tests using that page
- Easy maintenance — locator changes in one place only
- Readable tests — test code reads like plain English
- Separation of concerns — test logic vs page interaction

**Page class structure:**
```java
public class LoginPage {
    private WebDriver driver;
    private By usernameField = By.id("username");
    private By passwordField = By.id("password");
    private By loginButton   = By.id("loginBtn");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void login(String username, String password) {
        driver.findElement(usernameField).sendKeys(username);
        driver.findElement(passwordField).sendKeys(password);
        driver.findElement(loginButton).click();
    }
}
```

**Test class using POM:**
```java
@Test
public void testLogin() {
    LoginPage loginPage = new LoginPage(driver);
    loginPage.login("admin", "pass123");
    Assert.assertEquals(driver.getTitle(), "Dashboard");
}
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'POM', 'Page Object Model', 'Framework', 'Design Pattern'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is PageFactory in Selenium?',
  'what-is-pagefactory-in-selenium',
  'PageFactory is a Selenium support class that uses @FindBy annotations to initialize web elements automatically.',
  $$**PageFactory** extends POM by using `@FindBy` annotations and lazy element initialization, making code cleaner.

**Full PageFactory example:**
```java
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LoginPage {

    @FindBy(id = "username")
    private WebElement usernameField;

    @FindBy(id = "password")
    private WebElement passwordField;

    @FindBy(css = ".btn-login")
    private WebElement loginButton;

    @FindBy(xpath = "//span[@class=''error-msg'']")
    private WebElement errorMessage;

    public LoginPage(WebDriver driver) {
        PageFactory.initElements(driver, this);
    }

    public void login(String user, String pass) {
        usernameField.sendKeys(user);
        passwordField.sendKeys(pass);
        loginButton.click();
    }

    public String getError() {
        return errorMessage.getText();
    }
}
```

**POM vs PageFactory:**
| | POM (By) | PageFactory (@FindBy) |
|--|--|--|
| Element init | On each call | Once at initialization |
| Syntax | More verbose | Annotation-based |
| Lazy loading | Yes | Yes |
| Best for | Dynamic pages | Stable pages |$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'PageFactory', 'POM', 'FindBy', 'Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is TestNG and why is it used with Selenium?',
  'what-is-testng-and-why-used-with-selenium',
  'TestNG is a Java testing framework used with Selenium to organize tests, manage dependencies, run in parallel, and generate reports.',
  $$**TestNG** (Test Next Generation) is a Java testing framework designed for automation testing. It is the most commonly used testing framework alongside Selenium WebDriver.

**Why TestNG with Selenium:**
- `@Test` annotation marks test methods
- `@BeforeMethod` and `@AfterMethod` for setup and teardown
- Run tests in parallel — reduces execution time significantly
- Group tests by category (smoke, regression, sanity)
- Data-driven testing with `@DataProvider`
- Prioritize test order with `priority` attribute
- XML suite configuration with `testng.xml`
- Built-in HTML reporting

**Basic TestNG test:**
```java
import org.testng.annotations.*;
import org.testng.Assert;

public class LoginTest {
    WebDriver driver;

    @BeforeMethod
    public void setUp() {
        driver = new ChromeDriver();
        driver.get("https://automateqa.online");
    }

    @Test(priority = 1, groups = {"smoke"})
    public void testLoginSuccess() {
        driver.findElement(By.id("username")).sendKeys("admin");
        driver.findElement(By.id("password")).sendKeys("pass123");
        driver.findElement(By.id("loginBtn")).click();
        Assert.assertTrue(driver.getTitle().contains("Dashboard"));
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
}
```$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Framework', 'Annotations', 'Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the important TestNG annotations in Selenium?',
  'important-testng-annotations-in-selenium',
  'TestNG provides lifecycle annotations like @BeforeSuite, @BeforeTest, @BeforeClass, @BeforeMethod, @Test, and their @After counterparts.',
  $$TestNG annotations control the execution order of methods, from broadest scope (Suite) to narrowest (Method).

**Execution order:**
```
@BeforeSuite
  @BeforeTest
    @BeforeClass
      @BeforeMethod
        @Test
      @AfterMethod
    @AfterClass
  @AfterTest
@AfterSuite
```

**Annotation reference:**
| Annotation | When it runs |
|-----------|-------------|
| `@BeforeSuite` | Once before all test suites |
| `@AfterSuite` | Once after all test suites |
| `@BeforeTest` | Before each test tag in testng.xml |
| `@AfterTest` | After each test tag |
| `@BeforeClass` | Once before first method in the class |
| `@AfterClass` | Once after last method in the class |
| `@BeforeMethod` | Before each @Test method |
| `@AfterMethod` | After each @Test method |
| `@Test` | Marks a test method |
| `@DataProvider` | Supplies data to @Test methods |
| `@Parameters` | Passes parameters from testng.xml |

**Example:**
```java
@BeforeClass
public void launchBrowser() { driver = new ChromeDriver(); }

@BeforeMethod
public void openURL() { driver.get("https://automateqa.online"); }

@Test
public void verifyTitle() { Assert.assertEquals(driver.getTitle(), "AutomateQA"); }

@AfterClass
public void closeBrowser() { driver.quit(); }
```$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Annotations', 'Framework', 'BeforeMethod'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Selenium Grid and why is it used?',
  'what-is-selenium-grid-and-why-used',
  'Selenium Grid allows running tests in parallel across multiple machines, browsers, and OS combinations simultaneously.',
  $$**Selenium Grid** allows running Selenium tests on multiple machines (nodes) simultaneously, controlled by a central Hub. It enables parallel execution and cross-browser/cross-OS testing at scale.

**Architecture:**
- **Hub** — central controller that receives test requests and routes them to nodes
- **Node** — machines that execute the actual tests in different browsers/OS

**Why use Selenium Grid:**
- **Parallel execution** — run many tests at once, much faster
- **Cross-browser testing** — Chrome, Firefox, Edge, Safari simultaneously
- **Cross-OS testing** — Windows, Linux, macOS in one run
- **Scalable** — add more nodes for more capacity

**Selenium 4 Grid — standalone setup:**
```bash
java -jar selenium-server-4.x.jar standalone
```

**Connect tests to Grid:**
```java
ChromeOptions options = new ChromeOptions();
RemoteWebDriver driver = new RemoteWebDriver(
    new URL("http://localhost:4444"),
    options
);
```

**Cloud alternatives:**
BrowserStack, Sauce Labs, LambdaTest — managed Selenium Grid as a service, no maintenance needed.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Selenium Grid', 'Parallel Testing', 'Cross Browser', 'Hub Node'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is headless browser testing in Selenium?',
  'what-is-headless-browser-testing-in-selenium',
  'Headless browser testing runs Selenium tests without a visible browser UI, making it faster and suitable for CI/CD pipelines.',
  $$**Headless browser testing** runs browser tests without displaying the browser window. The browser still renders pages and executes JavaScript — everything happens in the background.

**Benefits:**
- Faster execution — no UI rendering overhead
- Runs in CI/CD pipelines — no display server needed
- Consumes less memory
- Still supports screenshots and JavaScript execution

**Chrome Headless:**
```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless");
options.addArguments("--no-sandbox");
options.addArguments("--disable-dev-shm-usage");
options.addArguments("--window-size=1920,1080");

WebDriver driver = new ChromeDriver(options);
driver.get("https://automateqa.online");
System.out.println(driver.getTitle());
```

**Firefox Headless:**
```java
FirefoxOptions options = new FirefoxOptions();
options.addArguments("--headless");
WebDriver driver = new FirefoxDriver(options);
```

**Common use cases:**
- Jenkins, GitHub Actions, GitLab CI pipelines
- Docker containers
- Scheduled overnight regression runs

> **Note:** Chrome 112+ uses `--headless=new` for better compatibility with modern web apps.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Headless', 'CI/CD', 'Chrome Headless', 'Pipeline'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between driver.close() and driver.quit() in Selenium?',
  'difference-between-driver-close-and-driver-quit-in-selenium',
  'driver.close() closes only the current active window; driver.quit() closes all open windows and ends the WebDriver session.',
  $$| Method | What it does |
|--------|-------------|
| `driver.close()` | Closes the current/active browser window only |
| `driver.quit()` | Closes all browser windows and ends the entire WebDriver session |

**driver.close():**
```java
driver.close();
// Only closes the currently focused window
// If this was the last window, session ends but driver object remains
```

**driver.quit():**
```java
driver.quit();
// Closes all windows (main + all popups/tabs) and kills the driver process
```

**Example with multiple windows:**
```java
String mainHandle = driver.getWindowHandle();
driver.switchTo().window(popupHandle);

driver.close();                          // Only closes popup
driver.switchTo().window(mainHandle);   // Main window is still open

// At end of test:
driver.quit();                           // Closes everything
```

**When to use:**
- Use `driver.close()` in the middle of a test when closing a specific window/tab
- Use `driver.quit()` in `@AfterMethod` or teardown — **always prefer quit() to fully clean up**

> **Best practice:** Always call `driver.quit()` in a `finally` block or `@AfterMethod` to prevent browser processes from lingering in memory.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'close()', 'quit()', 'Browser Management'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between findElement() and findElements() in Selenium?',
  'difference-between-findelement-and-findelements-in-selenium',
  'findElement() returns a single WebElement and throws NoSuchElementException if not found; findElements() returns a List that is empty if nothing matches.',
  $$| Feature | `findElement()` | `findElements()` |
|---------|-----------------|------------------|
| **Returns** | Single `WebElement` | `List<WebElement>` |
| **If not found** | Throws `NoSuchElementException` | Returns empty list |
| **Multiple matches** | Returns first match only | Returns all matches |
| **Use case** | Unique elements | Lists, tables, repeated items |

**findElement():**
```java
WebElement btn = driver.findElement(By.cssSelector(".submit-btn"));
btn.click();
// Throws NoSuchElementException if not found
```

**findElements():**
```java
List<WebElement> items = driver.findElements(By.cssSelector(".product-item"));
System.out.println("Count: " + items.size());

for (WebElement item : items) {
    System.out.println(item.getText());
}
```

**Check element exists without exception:**
```java
List<WebElement> elements = driver.findElements(By.id("loginBtn"));
if (!elements.isEmpty()) {
    elements.get(0).click();
}
```

**Get row count of a table:**
```java
int rowCount = driver.findElements(By.tagName("tr")).size();
System.out.println("Table rows: " + rowCount);
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'findElement', 'findElements', 'WebDriver Commands'], true, 0
);
