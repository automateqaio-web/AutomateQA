-- Selenium Q146–Q160 | Node, WebDriver APIs, Waits, Scenarios, Recovery | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a Node in Selenium Grid?',
  'selenium-q146-node-selenium-grid',
  'A Node is a machine attached to the Selenium Grid Hub that executes tests on a specific browser and OS configuration. Multiple nodes can be attached to one Hub.',
  $$## Node in Selenium Grid

**Node** is a remote machine (physical or virtual) that is **registered with the Hub** and actually **executes the browser tests**.

**Node characteristics:**
- Has one or more browsers installed (Chrome, Firefox, Edge, etc.)
- Registers itself with the Hub so the Hub knows what capabilities it offers
- Receives test commands from the Hub and executes them in the browser
- Can run multiple browser instances simultaneously (configurable `maxInstances`)
- There can be **multiple nodes** in a Selenium Grid

**Registering a Node with the Hub:**
```bash
# Selenium 3
java -jar selenium-server-standalone-3.141.59.jar \
  -role node \
  -hub http://localhost:4444/grid/register \
  -browser browserName=chrome,maxInstances=3 \
  -browser browserName=firefox,maxInstances=3

# Custom port for node
java -jar selenium-server-standalone-3.141.59.jar \
  -role node \
  -hub http://hub-machine:4444/grid/register \
  -port 5555
```

**Selenium 4 Node:**
```bash
java -jar selenium-server-4.x.x.jar node \
  --hub http://hub-server:4444 \
  --port 5555
```

**Node configuration JSON (Selenium 3):**
```json
{
  "capabilities": [
    {
      "browserName": "chrome",
      "maxInstances": 3,
      "seleniumProtocol": "WebDriver"
    },
    {
      "browserName": "firefox",
      "maxInstances": 3,
      "seleniumProtocol": "WebDriver"
    }
  ],
  "maxSession": 6,
  "port": 5555,
  "host": "node-machine-ip",
  "hubHost": "hub-machine"
}
```

**Multi-node setup:**
```
[Hub: hub-server:4444]
  ├── [Node 1: win-machine:5555] — Chrome x3, Firefox x3
  ├── [Node 2: mac-machine:5556] — Safari x2, Chrome x2
  └── [Node 3: linux-machine:5557] — Firefox x4, Edge x2
```

**Node vs Hub:**

| | Hub | Node |
|--|-----|------|
| Role | Routes requests | Executes tests |
| Has browser | No | Yes |
| Port | 4444 | 5555 (configurable) |
| Count | 1 per Grid | Many |
| Purpose | Central manager | Test executor |

**Key definition:** Node is **the machine which is attached to the Hub**. There can be **multiple nodes** in Selenium Grid. Each node has browsers installed and runs the actual test sessions.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Selenium Grid', 'Node', 'Hub', 'Distributed Testing', 'RemoteWebDriver'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the types of WebDriver APIs available in Selenium?',
  'selenium-q147-types-webdriver-apis-selenium',
  'Selenium provides browser-specific WebDriver implementations: ChromeDriver, FirefoxDriver, IEDriver, SafariDriver, EdgeDriver, HtmlUnitDriver, OperaDriver, and RemoteWebDriver.',
  $$## Types of WebDriver APIs in Selenium

Selenium provides browser-specific driver implementations, each communicating with its target browser natively.

**Available WebDriver implementations:**

**1. FirefoxDriver (geckodriver)**
```java
System.setProperty("webdriver.gecko.driver", "path/to/geckodriver");
WebDriver driver = new FirefoxDriver();
```

**2. ChromeDriver**
```java
System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
WebDriver driver = new ChromeDriver();
```

**3. InternetExplorerDriver (IE Driver)**
```java
System.setProperty("webdriver.ie.driver", "path/to/IEDriverServer.exe");
WebDriver driver = new InternetExplorerDriver();
```

**4. EdgeDriver**
```java
System.setProperty("webdriver.edge.driver", "path/to/msedgedriver");
WebDriver driver = new EdgeDriver();
```

**5. SafariDriver**
```java
// No System.setProperty needed on Mac
WebDriver driver = new SafariDriver();
```

**6. HtmlUnitDriver (headless, fastest)**
```java
WebDriver driver = new HtmlUnitDriver();  // No browser UI
// Fastest implementation — runs in memory, no browser window
```

**7. OperaDriver**
```java
OperaOptions options = new OperaOptions();
options.setBinary("/path/to/opera");
WebDriver driver = new ChromeDriver(options);  // Opera uses Chromium engine
```

**8. RemoteWebDriver (for Selenium Grid)**
```java
WebDriver driver = new RemoteWebDriver(
    new URL("http://localhost:4444/wd/hub"),
    new ChromeOptions()
);
```

**9. AndroidDriver (Appium-based)**
```java
// For mobile browser automation
DesiredCapabilities caps = new DesiredCapabilities();
caps.setCapability("platformName", "Android");
WebDriver driver = new AndroidDriver(new URL("http://localhost:4723"), caps);
```

**10. iPhoneDriver**
For Safari on iOS — typically handled via Appium.

**Selenium 4 — Modern approach (WebDriverManager):**
```java
// No need to set system property manually
WebDriverManager.chromedriver().setup();
WebDriver driver = new ChromeDriver();
```

**Summary list:**
1. FirefoxDriver (geckodriver)
2. InternetExplorerDriver
3. ChromeDriver
4. HtmlUnitDriver (headless, fastest)
5. OperaDriver
6. SafariDriver
7. EdgeDriver
8. AndroidDriver (via Appium)
9. iPhoneDriver (via Appium)
10. RemoteWebDriver (Grid)$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'ChromeDriver', 'FirefoxDriver', 'HtmlUnitDriver', 'RemoteWebDriver'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Which WebDriver implementation claims to be the fastest?',
  'selenium-q148-fastest-webdriver-implementation',
  'HtmlUnitDriver is the fastest WebDriver implementation because it runs headlessly in memory without launching an actual browser window.',
  $$## Fastest WebDriver Implementation

**HtmlUnitDriver** claims to be the fastest WebDriver implementation in Selenium.

**Why HtmlUnitDriver is fastest:**
- It does **NOT launch an actual browser** — it runs entirely in memory (JVM)
- Uses **HtmlUnit** — a headless Java-based browser that simulates browser behavior
- No GUI rendering, no graphics processing, no window management
- Pure Java execution — no inter-process communication with an external driver

**Usage:**
```java
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

// Basic HtmlUnitDriver
WebDriver driver = new HtmlUnitDriver();

// With JavaScript enabled
HtmlUnitDriver driver = new HtmlUnitDriver(true);

// With specific browser version simulation
HtmlUnitDriver driver = new HtmlUnitDriver(BrowserVersion.CHROME);
driver.setJavascriptEnabled(true);
```

**Comparison of driver speed:**

| Driver | Speed | Has Browser UI | JavaScript |
|--------|-------|---------------|------------|
| HtmlUnitDriver | **Fastest** | No (headless) | Simulated |
| ChromeDriver (headless) | Fast | No | Full |
| FirefoxDriver (headless) | Fast | No | Full |
| ChromeDriver (normal) | Moderate | Yes | Full |
| FirefoxDriver (normal) | Moderate | Yes | Full |
| IEDriverServer | Slowest | Yes | Full |

**HtmlUnit limitations:**
- JavaScript support is limited/simulated (not a real JS engine like V8/SpiderMonkey)
- May not behave identically to real browsers for complex JS frameworks
- Modern SPAs (React, Angular, Vue) may not work correctly
- CSS rendering is simulated, not pixel-accurate

**Modern headless alternatives (faster than HtmlUnit for real apps):**
```java
// Headless Chrome — fast AND real browser behavior
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless=new");
WebDriver driver = new ChromeDriver(options);

// Headless Firefox
FirefoxOptions options = new FirefoxOptions();
options.addArguments("-headless");
WebDriver driver = new FirefoxDriver(options);
```

**Key point:** The fastest implementation is **HtmlUnitDriver** because it does **not execute tests in an actual browser** — it simulates browser behavior in pure Java without launching any browser process.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'HtmlUnitDriver', 'Headless', 'Performance', 'WebDriver', 'Speed'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the programming languages supported by Selenium WebDriver?',
  'selenium-q149-programming-languages-selenium-webdriver',
  'Selenium WebDriver officially supports Java, C#, Python, Ruby, JavaScript (Node.js), Kotlin, and PHP for writing test automation scripts.',
  $$## Programming Languages Supported by Selenium WebDriver

Selenium WebDriver provides official client bindings (libraries) for multiple programming languages:

**Officially supported languages:**

**1. Java (most popular)**
```java
WebDriver driver = new ChromeDriver();
driver.get("https://example.com");
WebElement element = driver.findElement(By.id("search"));
element.sendKeys("Selenium");
```

**2. Python**
```python
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("https://example.com")
element = driver.find_element(By.ID, "search")
element.send_keys("Selenium")
```

**3. C# (common in .NET projects)**
```csharp
IWebDriver driver = new ChromeDriver();
driver.Navigate().GoToUrl("https://example.com");
IWebElement element = driver.FindElement(By.Id("search"));
element.SendKeys("Selenium");
```

**4. Ruby**
```ruby
driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://example.com"
element = driver.find_element(id: "search")
element.send_keys "Selenium"
```

**5. JavaScript / Node.js**
```javascript
const { Builder, By } = require("selenium-webdriver");
const driver = new Builder().forBrowser("chrome").build();
await driver.get("https://example.com");
const element = await driver.findElement(By.id("search"));
await element.sendKeys("Selenium");
```

**6. Kotlin (JVM, uses Java bindings)**
```kotlin
val driver = ChromeDriver()
driver.get("https://example.com")
val element = driver.findElement(By.id("search"))
element.sendKeys("Selenium")
```

**7. PHP**
```php
$driver = RemoteWebDriver::create("http://localhost:4444", DesiredCapabilities::chrome());
$driver->get("https://example.com");
$element = $driver->findElement(WebDriverBy::id("search"));
$element->sendKeys("Selenium");
```

**8. Perl (community support)**

**Language popularity in Selenium:**

| Language | Popularity | Common use case |
|----------|-----------|----------------|
| Java | Very High | Enterprise, TestNG, Maven |
| Python | High | Simple scripts, pytest |
| C# | High | .NET/.NET Core projects |
| JavaScript | Medium | Node.js full-stack teams |
| Ruby | Lower | Rails projects |

**Key official list:**
1. Java
2. C#
3. Python
4. Ruby
5. Perl
6. PHP
7. JavaScript (Node.js)$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Programming Languages', 'Java', 'Python', 'C#', 'Ruby', 'JavaScript'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the open-source frameworks supported by Selenium WebDriver?',
  'selenium-q151-open-source-frameworks-selenium-webdriver',
  'Selenium WebDriver integrates with JUnit, TestNG, Cucumber (BDD), and JBehave (BDD) as open-source testing frameworks for Java-based Selenium projects.',
  $$## Open-Source Frameworks Supported by Selenium WebDriver

Selenium WebDriver integrates with several open-source testing frameworks to provide assertions, test lifecycle management, and reporting.

**Primary frameworks:**

**1. JUnit**
The classic Java unit testing framework. Simple and widely used.
```java
import org.junit.Test;
import org.junit.Before;
import org.junit.After;
import static org.junit.Assert.*;

public class LoginTest {

    @Before
    public void setUp() {
        driver = new ChromeDriver();
    }

    @Test
    public void testLogin() {
        driver.get("https://example.com/login");
        assertEquals("Login Page", driver.getTitle());
    }

    @After
    public void tearDown() {
        driver.quit();
    }
}
```

**2. TestNG (most popular for Selenium)**
Feature-rich testing framework with parallel execution, grouping, and data providers.
```java
import org.testng.annotations.*;
import org.testng.Assert;

public class LoginTest {

    @BeforeClass
    public void setUp() { driver = new ChromeDriver(); }

    @Test(groups = "regression", dataProvider = "loginData")
    public void loginTest(String user, String pass) {
        Assert.assertEquals(driver.getTitle(), "Dashboard");
    }

    @AfterClass
    public void tearDown() { driver.quit(); }
}
```

**3. Cucumber (BDD — Behavior-Driven Development)**
Write tests in plain English (Gherkin syntax) with step definitions in Java.
```gherkin
Feature: Login functionality
  Scenario: Valid login
    Given I am on the login page
    When I enter "admin" and "password"
    Then I should see "Dashboard"
```
```java
@Given("I am on the login page")
public void iAmOnLoginPage() {
    driver.get("https://example.com/login");
}
```

**4. JBehave (BDD framework)**
Another BDD framework similar to Cucumber, uses story files.
```story
Given I navigate to login page
When I enter username admin and password password
Then I should be redirected to dashboard
```

**Framework comparison:**

| Framework | Style | Best for |
|-----------|-------|----------|
| JUnit | Annotation-based | Simple unit/integration tests |
| TestNG | Annotation-based | Complex Selenium suites |
| Cucumber | BDD (Gherkin) | Non-technical stakeholders |
| JBehave | BDD (story files) | BDD with story-format specs |

**Key list:**
1. JUnit
2. TestNG
3. CUCUMBER
4. JBEHAVE$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'JUnit', 'TestNG', 'Cucumber', 'JBehave', 'BDD', 'Testing Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the super interface of WebDriver in Selenium?',
  'selenium-q152-super-interface-webdriver-selenium',
  'SearchContext is the super interface (parent interface) of WebDriver in Selenium. It declares the findElement() and findElements() methods.',
  $$## Super Interface of WebDriver

**SearchContext** is the parent (super) interface of `WebDriver` in the Selenium interface hierarchy.

**Selenium interface hierarchy:**
```
SearchContext  ← Super interface
    └── WebDriver  ← Extends SearchContext
            ├── ChromeDriver
            ├── FirefoxDriver
            ├── EdgeDriver
            ├── RemoteWebDriver
            └── ...
```

**SearchContext declares:**
```java
public interface SearchContext {
    // Find a single element
    WebElement findElement(By by);

    // Find multiple elements
    List<WebElement> findElements(By by);
}
```

**WebDriver extends SearchContext:**
```java
public interface WebDriver extends SearchContext {
    void get(String url);
    String getTitle();
    String getCurrentUrl();
    String getPageSource();
    void close();
    void quit();
    Set<String> getWindowHandles();
    String getWindowHandle();
    Options manage();
    Navigation navigate();
    TargetLocator switchTo();
    // ... plus findElement() and findElements() inherited from SearchContext
}
```

**Why SearchContext?**
`SearchContext` is also implemented by `WebElement` — this allows element-scoped searches:
```java
// Searching from the document root (WebDriver implements SearchContext)
driver.findElement(By.id("container"));

// Searching within a specific element (WebElement also implements SearchContext)
WebElement container = driver.findElement(By.id("container"));
WebElement button = container.findElement(By.tagName("button")); // Scoped search!
```

**Full hierarchy:**
```java
SearchContext
  ├── WebDriver (browser-level search)
  │     ├── ChromeDriver
  │     ├── FirefoxDriver
  │     └── RemoteWebDriver
  └── WebElement (element-level search)
        ├── RemoteWebElement
        └── ...
```

**Key answer:** The super interface of WebDriver is **SearchContext**. It defines `findElement()` and `findElements()` methods that are inherited by both `WebDriver` (for page-level searches) and `WebElement` (for element-scoped searches).$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'SearchContext', 'WebDriver', 'Interface', 'Hierarchy', 'findElement'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the types of waits available in Selenium WebDriver?',
  'selenium-q153-types-of-waits-selenium-webdriver',
  'Selenium provides Implicit Wait, Explicit Wait (WebDriverWait), Fluent Wait, PageLoadTimeout, and Thread.sleep() as synchronization mechanisms.',
  $$## Types of Waits in Selenium WebDriver

Waits are synchronization mechanisms that tell Selenium to pause before interacting with elements that may not yet be available in the DOM.

**1. Implicit Wait**
Applied globally — WebDriver waits up to N seconds for any element before throwing `NoSuchElementException`.
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
// Applies to ALL findElement() calls in this driver session
driver.get("https://example.com");
driver.findElement(By.id("element"));  // Waits up to 10s
```

**2. Explicit Wait (WebDriverWait)**
Waits for a **specific condition** to be true before proceeding.
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

// Wait until element is visible
WebElement element = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.id("myElement"))
);

// Wait until element is clickable
WebElement btn = wait.until(
    ExpectedConditions.elementToBeClickable(By.id("submitBtn"))
);
```

**3. Fluent Wait**
Custom explicit wait with configurable polling interval and exceptions to ignore.
```java
Wait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(30))
    .pollingEvery(Duration.ofMillis(500))  // Check every 500ms
    .ignoring(NoSuchElementException.class)
    .ignoring(StaleElementReferenceException.class);

WebElement element = fluentWait.until(
    driver -> driver.findElement(By.id("dynamicElement"))
);
```

**4. PageLoadTimeout**
Maximum time to wait for a page to fully load.
```java
driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
driver.get("https://heavy-site.com");  // Fails if page doesn''t load in 30s
```

**5. Thread.sleep() — Static Wait**
Hard pause — waits regardless of application state.
```java
Thread.sleep(3000);  // Waits exactly 3 seconds — avoid unless necessary
```

**Comparison table:**

| Wait Type | Scope | Condition-based | Recommended |
|-----------|-------|-----------------|-------------|
| Implicit | Global (all findElement) | No | Use sparingly |
| Explicit (WebDriverWait) | Specific element | Yes | Best choice |
| FluentWait | Specific element | Yes (custom) | Complex cases |
| PageLoadTimeout | Page navigation | No | Global setting |
| Thread.sleep | Fixed pause | No | Rarely / debugging |

**Key list from source:**
- Implicit Waits
- Explicit Waits
- Fluent Waits
- PageLoadTimeOut
- Thread.sleep() — static wait$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Waits', 'Implicit Wait', 'Explicit Wait', 'FluentWait', 'WebDriverWait', 'Synchronization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to clear the text in a text box using Selenium WebDriver?',
  'selenium-q154-clear-text-textbox-selenium',
  'Use element.clear() method to remove all text from an input field. Combine with sendKeys() to replace existing text with new content.',
  $$## Clearing Text in a Text Box Using Selenium

**Method 1 — clear() (standard approach):**
```java
WebDriver driver = new FirefoxDriver();
driver.get("https://www.gmail.com");

WebElement emailField = driver.findElement(By.xpath("xpath_of_element1"));
emailField.sendKeys("Software Testing ");  // Type some text
emailField.clear();  // Clear all text from the field
```

**Full test example:**
```java
@Test
public void clearAndRetype() {
    driver.get("https://example.com/form");

    WebElement input = driver.findElement(By.id("username"));

    // Type initial text
    input.sendKeys("oldUsername");
    Assert.assertEquals(input.getAttribute("value"), "oldUsername");

    // Clear and retype
    input.clear();
    Assert.assertEquals(input.getAttribute("value"), "");

    input.sendKeys("newUsername");
    Assert.assertEquals(input.getAttribute("value"), "newUsername");
}
```

**Method 2 — Keyboard shortcuts:**
```java
// Select All + Delete
WebElement input = driver.findElement(By.id("username"));
input.sendKeys(Keys.CONTROL + "a");
input.sendKeys(Keys.DELETE);

// Or using Actions class
Actions actions = new Actions(driver);
actions.click(input)
       .keyDown(Keys.CONTROL)
       .sendKeys("a")
       .keyUp(Keys.CONTROL)
       .sendKeys(Keys.DELETE)
       .perform();
```

**Method 3 — JavascriptExecutor:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
WebElement input = driver.findElement(By.id("username"));
js.executeScript("arguments[0].value='';", input);
```

**Method 4 — Triple-click to select all then type:**
```java
WebElement input = driver.findElement(By.id("username"));
input.click();
input.click();
input.click();  // Triple-click selects all text
input.sendKeys("newValue");  // Overwrites selected text
```

**When clear() might not work:**
- Read-only fields — use JavascriptExecutor instead
- React/Angular inputs that ignore clear() — use keyboard events
- Inputs with `onchange` listeners — trigger event after clear

**Key answer:** Use `element.clear()` method to clear text from a text box using Selenium WebDriver.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'clear()', 'Text Box', 'Input Field', 'WebElement'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to get the text of a web element in Selenium?',
  'selenium-q155-get-text-web-element-selenium',
  'Use element.getText() method to retrieve the visible text content of a web element in Selenium WebDriver.',
  $$## Getting Text of a Web Element

Use the `getText()` method to retrieve the **visible text** content of a web element.

**Basic usage:**
```java
WebElement heading = driver.findElement(By.tagName("h1"));
String text = heading.getText();
System.out.println("Heading text: " + text);
```

**Common examples:**
```java
// Get paragraph text
String paraText = driver.findElement(By.id("description")).getText();

// Get link text
String linkText = driver.findElement(By.cssSelector("a.nav-link")).getText();

// Get button text
String buttonText = driver.findElement(By.id("submitBtn")).getText();

// Get table cell text
String cellText = driver.findElement(
    By.xpath("//table//tr[2]//td[1]")
).getText();
```

**Assertion with getText():**
```java
@Test
public void verifyWelcomeMessage() {
    driver.get("https://example.com/dashboard");

    String welcomeText = driver.findElement(By.id("welcome-msg")).getText();

    Assert.assertEquals(welcomeText, "Welcome, Admin!");
    Assert.assertTrue(welcomeText.contains("Welcome"));
    Assert.assertFalse(welcomeText.isEmpty());
}
```

**getText() vs getAttribute("innerText") vs getAttribute("textContent"):**
```java
WebElement el = driver.findElement(By.id("myElement"));

String text1 = el.getText();
// Returns visible text — excludes hidden text (display:none)

String text2 = (String) js.executeScript("return arguments[0].innerText;", el);
// Returns rendered text — same as getText() essentially

String text3 = (String) js.executeScript("return arguments[0].textContent;", el);
// Returns ALL text including hidden text in nested elements
```

**Get text from multiple elements:**
```java
List<WebElement> items = driver.findElements(By.cssSelector("ul.nav-list li"));

for (WebElement item : items) {
    System.out.println(item.getText());
}

// Or collect to list
List<String> texts = items.stream()
    .map(WebElement::getText)
    .collect(Collectors.toList());
```

**getText() on input fields:**
`getText()` returns empty string for input fields — use `getAttribute("value")` instead:
```java
// For <input> elements
String inputValue = driver.findElement(By.id("username")).getAttribute("value");
```

**Key answer:** Use `element.getText()` method to get the visible text of a web element.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'getText()', 'WebElement', 'Text Verification', 'Assertion'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to get an attribute value using Selenium WebDriver?',
  'selenium-q156-get-attribute-value-selenium',
  'Use element.getAttribute("attributeName") to retrieve the value of any HTML attribute such as id, class, href, placeholder, value, or custom data attributes.',
  $$## Getting Attribute Value Using Selenium

Use `element.getAttribute("attributeName")` to retrieve the value of any HTML attribute.

**Basic usage:**
```java
WebElement element = driver.findElement(By.id("myInput"));
String value = element.getAttribute("value");  // Get input field value
```

**Common attribute examples:**
```java
WebElement input = driver.findElement(By.name("username"));

// Get input value
String inputValue = input.getAttribute("value");

// Get placeholder text
String placeholder = input.getAttribute("placeholder");

// Get class name
String className = input.getAttribute("class");

// Get id
String id = input.getAttribute("id");

// Check if disabled
String disabled = input.getAttribute("disabled");  // "true" or null

// Get type (text, password, checkbox, etc.)
String type = input.getAttribute("type");
```

**Link href attribute:**
```java
WebElement link = driver.findElement(By.linkText("Home"));
String href = link.getAttribute("href");
System.out.println("Link URL: " + href);
```

**Image src attribute:**
```java
WebElement img = driver.findElement(By.tagName("img"));
String src = img.getAttribute("src");
String alt = img.getAttribute("alt");
System.out.println("Image source: " + src);
```

**Tooltip via title attribute:**
```java
WebElement helpIcon = driver.findElement(By.id("helpIcon"));
String tooltip = helpIcon.getAttribute("title");
Assert.assertEquals(tooltip, "Click for help");
```

**Custom data attributes:**
```java
// For <div data-user-id="123" data-role="admin">
WebElement card = driver.findElement(By.className("user-card"));
String userId = card.getAttribute("data-user-id");   // "123"
String role = card.getAttribute("data-role");         // "admin"
```

**Full test example:**
```java
@Test
public void verifyAttributes() {
    driver.get("https://example.com/form");

    WebElement emailInput = driver.findElement(By.id("email"));

    Assert.assertEquals(emailInput.getAttribute("type"), "email");
    Assert.assertEquals(emailInput.getAttribute("placeholder"), "Enter your email");
    Assert.assertNull(emailInput.getAttribute("disabled"));  // Not disabled
}
```

**getAttribute vs getCssValue:**
```java
// getAttribute — HTML attributes
element.getAttribute("class");   // "btn btn-primary"
element.getAttribute("href");    // "https://example.com"

// getCssValue — CSS style properties
element.getCssValue("color");    // "rgba(255, 0, 0, 1)"
element.getCssValue("font-size"); // "16px"
```

**Key answer:** Use `element.getAttribute(value)` to get any HTML attribute value from a web element.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'getAttribute', 'WebElement', 'HTML Attributes', 'CSS Values'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'List scenarios which we cannot automate using Selenium WebDriver.',
  'selenium-q157-scenarios-cannot-automate-webdriver',
  'Selenium WebDriver cannot automate: bitmap/image comparison, CAPTCHA, barcode reading, Windows OS pop-ups, third-party calendar widgets, Image/Word/PDF processing.',
  $$## Scenarios We Cannot Automate Using Selenium WebDriver

Selenium WebDriver, despite being a powerful browser automation tool, has specific limitations:

**1. Bitmap/Image Comparison**
Selenium cannot compare screenshots pixel-by-pixel or validate visual appearance.
```
Cannot check: "Does this button look exactly like in the design spec?"
Workaround: Applitools Eyes, Percy.io, Sikuli for visual testing
```

**2. CAPTCHA (Completely Automated Public Turing Test)**
CAPTCHA is specifically designed to prevent bots — Selenium cannot solve it.
```
Cannot automate: reCAPTCHA, image CAPTCHAs, puzzle CAPTCHAs
Workaround: Disable in test environment, use test bypass tokens
```

**3. Barcode Reading**
Selenium cannot decode barcodes or QR codes from images on the page.
```
Cannot read: Product barcodes, QR codes displayed in browser
Workaround: Zxing library for standalone barcode decoding
```

**4. Windows OS-Level Pop-ups**
Native Windows dialogs (file upload/download, Windows Security) are outside browser control.
```
Cannot handle: Windows file dialog, Windows Security popup
Workaround: AutoIT, Sikuli, Robot class (Java), browser profile settings
```

**5. Third-Party Calendar / Date Picker Widgets**
Flash-based or JS widgets that are heavily obfuscated.
```
Cannot interact with: Flash datepickers, some JavaScript calendar libraries
Workaround: JavascriptExecutor to set date field value directly
```

**6. Image Files**
Reading text from images, verifying visual content of images.
```
Cannot verify: Image content, OCR on images
Workaround: Tesseract OCR for image text recognition
```

**7. Word Documents and PDFs**
Browser displays them as embedded viewers — content not accessible via DOM.
```
Cannot read: Text in PDF/Word files embedded in browser
Workaround: Apache POI (Word), Apache PDFBox (PDF), download and parse
```

**8. Biometric Authentication**
Fingerprint, Face ID, Touch ID — requires physical hardware interaction.

**Complete list:**
1. Bitmap comparison — not possible with Selenium WebDriver
2. CAPTCHA — not possible with Selenium WebDriver
3. Barcode reading — not possible with Selenium WebDriver
4. Windows OS-based pop-ups — requires AutoIT/Sikuli
5. Third-party calendars/elements — use JS workaround
6. Image content reading — requires OCR tools
7. Word/PDF processing — requires Apache POI/PDFBox

**Best practice:** For each limitation, identify a complementary tool:
- **Visual testing** → Applitools
- **Native dialogs** → AutoIT
- **Document reading** → Apache POI / PDFBox
- **CAPTCHA bypass** → Test environment configuration$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Limitations', 'CAPTCHA', 'Bitmap Comparison', 'AutoIT', 'Barcode', 'Selenium WebDriver'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can you use the Recovery Scenario in Selenium WebDriver?',
  'selenium-q158-recovery-scenario-selenium',
  'Use Try-Catch blocks in Java within Selenium WebDriver tests to handle exceptions and implement recovery actions when unexpected errors occur.',
  $$## Recovery Scenarios in Selenium WebDriver

**Recovery scenarios** allow your test to handle unexpected failures gracefully — catch an error and attempt a recovery action instead of letting the test terminate abruptly.

**Basic Try-Catch:**
```java
@Test
public void recoveryTest() {
    try {
        driver.get("www.xyz.com");
    } catch (Exception e) {
        System.out.println(e.getMessage());
        // Recovery action: navigate to alternate URL or log and continue
    }
}
```

**Recover from NoSuchElementException:**
```java
@Test
public void elementRecovery() {
    try {
        driver.findElement(By.id("loginBtn")).click();
    } catch (NoSuchElementException e) {
        System.out.println("Login button not found, trying alternate locator");
        // Recovery: try alternate locator
        driver.findElement(By.cssSelector("button[type=''submit'']")).click();
    }
}
```

**Recover from StaleElementReferenceException:**
```java
@Test
public void staleElementRecovery() {
    int retries = 3;
    while (retries > 0) {
        try {
            driver.findElement(By.id("dynamicElement")).click();
            break;  // Success — exit loop
        } catch (StaleElementReferenceException e) {
            retries--;
            System.out.println("Stale element, retrying... " + retries + " retries left");
            Thread.sleep(500);
        }
    }
}
```

**Recovery with screenshot on failure:**
```java
@Test
public void testWithRecovery() {
    try {
        driver.get("https://example.com");
        driver.findElement(By.id("nonExistent")).click();
    } catch (NoSuchElementException e) {
        // Capture screenshot for evidence
        TakesScreenshot ts = (TakesScreenshot) driver;
        File screenshot = ts.getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(screenshot, new File("recovery_screenshot.png"));

        System.out.println("Recovery: element not found. Screenshot captured.");
        // Optionally: navigate to known state and retry
        driver.navigate().refresh();
    }
}
```

**Recovery in @AfterMethod (TestNG):**
```java
@AfterMethod
public void recoverIfNeeded(ITestResult result) {
    if (result.getStatus() == ITestResult.FAILURE) {
        System.out.println("Test failed — performing cleanup recovery");
        try {
            driver.manage().deleteAllCookies();
            driver.navigate().to("https://example.com");
        } catch (Exception e) {
            System.out.println("Recovery also failed: " + e.getMessage());
        }
    }
}
```

**Common recovery exceptions to handle:**

| Exception | Recovery Action |
|-----------|----------------|
| `NoSuchElementException` | Try alternate locator or wait |
| `StaleElementReferenceException` | Re-find element, retry |
| `TimeoutException` | Increase wait or skip assertion |
| `ElementNotInteractableException` | Scroll to element, JS click |
| `WebDriverException` | Restart driver, refresh page |

**Key answer:** Use **Try-Catch blocks** within Selenium WebDriver Java tests for recovery scenarios. Catch the exception, log it, take a screenshot if needed, and attempt a recovery action.$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Recovery Scenario', 'Try-Catch', 'Exception Handling', 'NoSuchElementException'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to perform database testing in Selenium?',
  'selenium-q159-database-testing-selenium',
  'Selenium does not support databases directly. Use JDBC (Java Database Connectivity) driver to connect to any database and validate data as part of your Selenium test.',
  $$## Database Testing in Selenium

Selenium itself cannot interact with databases — it''s a browser automation tool. However, you can combine Selenium with **JDBC** (Java Database Connectivity) to validate database state as part of your tests.

**Using JDBC to connect to a database:**
```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseTest {

    @Test
    public void verifyUserInDatabase() throws Exception {
        // JDBC connection
        String dbUrl = "jdbc:mysql://localhost:3306/testdb";
        String dbUser = "root";
        String dbPassword = "password";

        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        Statement stmt = conn.createStatement();

        // Query the database
        ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE email=''test@example.com''");

        // Validate result
        if (rs.next()) {
            String name = rs.getString("name");
            String email = rs.getString("email");
            System.out.println("User found: " + name + " — " + email);
            Assert.assertEquals(email, "test@example.com");
        } else {
            Assert.fail("User not found in database!");
        }

        rs.close();
        stmt.close();
        conn.close();
    }
}
```

**End-to-end test with Selenium + JDBC:**
```java
@Test
public void registrationCreatesUserInDB() throws Exception {
    // Step 1: Register via browser (Selenium)
    driver.get("https://example.com/register");
    driver.findElement(By.id("name")).sendKeys("Test User");
    driver.findElement(By.id("email")).sendKeys("testuser@example.com");
    driver.findElement(By.id("password")).sendKeys("Password123");
    driver.findElement(By.id("registerBtn")).click();

    // Wait for success message
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    wait.until(ExpectedConditions.titleIs("Registration Successful"));

    // Step 2: Verify in database (JDBC)
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/app", "root", "pass");
    ResultSet rs = conn.createStatement().executeQuery(
        "SELECT COUNT(*) AS cnt FROM users WHERE email=''testuser@example.com''"
    );
    rs.next();
    int count = rs.getInt("cnt");
    Assert.assertEquals(count, 1, "User should exist in database after registration");
    conn.close();
}
```

**JDBC drivers by database:**

| Database | JDBC Driver Class | Maven Artifact |
|----------|------------------|----------------|
| MySQL | `com.mysql.cj.jdbc.Driver` | `mysql-connector-java` |
| PostgreSQL | `org.postgresql.Driver` | `postgresql` |
| Oracle | `oracle.jdbc.driver.OracleDriver` | `ojdbc8` |
| SQL Server | `com.microsoft.sqlserver.jdbc.SQLServerDriver` | `mssql-jdbc` |
| H2 (in-memory) | `org.h2.Driver` | `h2` |

**Key answer:** We can use **JDBC driver** to connect to any database in Java and validate data as part of Selenium test execution. Selenium handles the UI part, JDBC handles the database validation.$$,
  'Selenium', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Database Testing', 'JDBC', 'MySQL', 'SQL', 'Data Validation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to schedule the test suite execution in Selenium?',
  'selenium-q160-schedule-test-suite-execution-selenium',
  'Use CI tools like Jenkins, GitHub Actions, or Bamboo to schedule and trigger test suite execution automatically on a schedule or on code commits.',
  $$## Scheduling Test Suite Execution

Selenium tests can be scheduled and automated using CI/CD tools — they trigger test execution on a schedule, on code commits, or on demand.

**Method 1 — Jenkins (most popular CI tool)**
```groovy
// Jenkinsfile — Schedule nightly regression at midnight
pipeline {
    agent any
    triggers {
        cron(''0 0 * * *'')  // Every day at midnight
    }
    stages {
        stage(''Run Selenium Tests'') {
            steps {
                sh ''mvn clean test -DsuiteXmlFile=testng.xml''
            }
        }
    }
    post {
        always {
            publishHTML([
                reportDir: ''test-output'',
                reportFiles: ''index.html'',
                reportName: ''TestNG Report''
            ])
        }
    }
}
```

**Jenkins cron schedule examples:**
```
0 0 * * *    → Every day at midnight
0 8 * * 1-5  → Every weekday at 8 AM
*/30 * * * * → Every 30 minutes
0 20 * * 5   → Every Friday at 8 PM
```

**Method 2 — GitHub Actions**
```yaml
# .github/workflows/selenium-tests.yml
name: Selenium Test Suite

on:
  schedule:
    - cron: ''0 1 * * *''  # Daily at 1 AM UTC
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          java-version: ''11''
      - name: Run Selenium Tests
        run: mvn clean test
```

**Method 3 — Bamboo**
Bamboo supports scheduling build plans via the UI — set "Build Triggers" to schedule at specific times.

**Method 4 — Maven with TestNG**
```bash
# Run suite directly via Maven (schedule this in any scheduler)
mvn clean test -DsuiteXmlFile=regression.xml

# With specific browser
mvn test -Dbrowser=chrome -DsuiteXmlFile=testng.xml
```

**Method 5 — Windows Task Scheduler**
```powershell
# Create scheduled task on Windows
schtasks /create /tn "SeleniumNightlyRun" /tr "mvn -f C:\project\pom.xml test" /sc daily /st 23:00
```

**CI/CD integration best practices:**
- Trigger on every **pull request** — smoke tests only (fast)
- Trigger **nightly** — full regression suite
- Trigger on **release tags** — E2E tests
- Send results to **Slack/email** on failure

**Tool comparison:**

| Tool | Best for | Scheduling |
|------|----------|-----------|
| Jenkins | On-premise, mature | Cron syntax |
| GitHub Actions | GitHub repos | YAML cron |
| Bamboo | Atlassian stack | Built-in UI |
| Windows Scheduler | Windows-only | Task UI |

**Key answer:** We can schedule the test suite execution using CI tools like **Hudson (Jenkins)** and **Bamboo**. Alternatively, we can use the **Windows Task Scheduler** to launch test execution at specified times.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Jenkins', 'CI/CD', 'Test Scheduling', 'GitHub Actions', 'Bamboo', 'Cron'], true, 0
);
