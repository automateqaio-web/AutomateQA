-- WebDriver Architecture Interview Questions Q1–Q30 | Paste into Supabase SQL Editor

-- ══════════════════════════════════════
-- BEGINNER (Q1–Q8)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'Explain the Selenium WebDriver architecture. How does Selenium communicate with browsers?',
  'selenium-webdriver-architecture-explained',
  'Selenium 4 uses the W3C WebDriver protocol. Your Java test sends HTTP commands to a browser driver (ChromeDriver), which translates them to browser-native commands. The response flows back the same way.',
  $$## Selenium WebDriver Architecture

## Architecture Overview (Selenium 4 / W3C)

```
Your Test Code (Java)
        │
        │  Java Selenium Bindings (selenium-java)
        ↓
   WebDriver API
        │
        │  HTTP requests (W3C WebDriver Protocol / JSON over REST)
        ↓
  Browser Driver
  (ChromeDriver / GeckoDriver / EdgeDriver / SafariDriver)
        │
        │  Browser-native protocol (CDP for Chrome, etc.)
        ↓
    Browser
    (Chrome / Firefox / Edge / Safari)
        │
        │  Interacts with
        ↓
     Web Page
```

## Key Components

### 1. Selenium Client Library (Language Binding)

- Your Java code + `selenium-java` JAR
- Provides `WebDriver` interface, `WebElement`, `By`, `WebDriverWait`
- Converts Java calls → HTTP requests

```java
WebDriver driver = new ChromeDriver();
driver.get("https://example.com");
// ↑ This compiles to an HTTP POST /session/{id}/url
```

### 2. Browser Driver (ChromeDriver / GeckoDriver)

- Standalone binary that **bridges Selenium ↔ Browser**
- Starts an HTTP server on `localhost:9515` (default)
- Receives W3C WebDriver JSON commands from Selenium
- Translates to browser-specific instructions

```bash
# ChromeDriver starts automatically when you call new ChromeDriver()
# But you can start it manually:
chromedriver --port=9515
```

### 3. W3C WebDriver Protocol (Selenium 4)

Every Selenium command is an HTTP request to the driver's server:

| Selenium call | HTTP request |
|---------------|-------------|
| `driver.get(url)` | `POST /session/{id}/url` with `{"url": "https://..."}` |
| `driver.findElement(By.id("x"))` | `POST /session/{id}/element` with `{"using":"id","value":"x"}` |
| `element.click()` | `POST /session/{id}/element/{elemId}/click` |
| `element.sendKeys("text")` | `POST /session/{id}/element/{elemId}/value` |
| `driver.quit()` | `DELETE /session/{id}` |

### 4. Browser

- Receives instructions from its driver
- Executes actions on the real DOM
- Returns results (element handles, text, titles) as JSON

## Selenium 3 vs Selenium 4 Protocol

| | Selenium 3 (JSONWireProtocol) | Selenium 4 (W3C WebDriver) |
|--|-------------------------------|---------------------------|
| Protocol | Custom JSON Wire Protocol | W3C standard (official spec) |
| Status | Deprecated | Current standard |
| Browser support | Via JSON Wire | All major browsers natively |
| Relative locators | No | Yes (`near()`, `above()`, `below()`) |
| CDP access | No | Yes (BiDi / Chrome DevTools Protocol) |
| W3C capabilities | Partial | Full |

## Flow for `driver.findElement(By.id("email")).sendKeys("test@email.com")`

```
1. Java: driver.findElement(By.id("email"))
   ↓
2. Selenium lib sends:
   POST http://localhost:9515/session/abc123/element
   Body: {"using": "id", "value": "email"}
   ↓
3. ChromeDriver receives request
   ↓
4. ChromeDriver tells Chrome to find element with id="email"
   ↓
5. Chrome searches DOM, returns element handle
   ↓
6. ChromeDriver responds:
   {"value": {"element-6066-11e4-a52e-4f735466cecf": "element-1"}}
   ↓
7. Java receives WebElement with internal ID "element-1"
   ↓
8. Java: element.sendKeys("test@email.com")
   ↓
9. POST /session/abc123/element/element-1/value
   Body: {"text": "test@email.com"}
   ↓
10. ChromeDriver types into the element in Chrome
```

## WebDriverManager (Avoid Manual Driver Management)

```java
// Old way — manually download and set path
System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
WebDriver driver = new ChromeDriver();

// Modern way — WebDriverManager auto-downloads correct version
WebDriverManager.chromedriver().setup();
WebDriver driver = new ChromeDriver();

// In Selenium 4.6+ — WebDriverManager is bundled, just:
WebDriver driver = new ChromeDriver();  // no setup() needed
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['WebDriver Architecture', 'W3C Protocol', 'ChromeDriver', 'Selenium 4', 'HTTP', 'JSON Wire Protocol'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between driver.findElement() and driver.findElements()?',
  'difference-findelement-findelements-selenium',
  'findElement() returns a single WebElement and throws NoSuchElementException if not found. findElements() returns a List<WebElement> — empty list if nothing found, never throws an exception.',
  $$## findElement() vs findElements()

## findElement()

```java
// Returns ONE WebElement
// Throws NoSuchElementException if NOT found
WebElement email = driver.findElement(By.id("email"));

// Usage
email.sendKeys("test@email.com");
email.click();
String text = email.getText();

// Always throws if missing — use try/catch if optional
try {
    WebElement optional = driver.findElement(By.id("popup"));
    optional.click();
} catch (NoSuchElementException e) {
    // element not present — that's ok
}
```

## findElements()

```java
// Returns List<WebElement>
// Returns EMPTY LIST if nothing found — NEVER throws
List<WebElement> rows = driver.findElements(By.cssSelector("table tr"));

// Safe size check
System.out.println("Row count: " + rows.size());

// Iterate all elements
for (WebElement row : rows) {
    System.out.println(row.getText());
}

// Check if element exists WITHOUT exception
boolean isDisplayed = !driver.findElements(By.id("error-msg")).isEmpty();
// isEmpty() returns true when element not found
```

## Comparison Table

| | `findElement()` | `findElements()` |
|--|----------------|-----------------|
| Returns | Single `WebElement` | `List<WebElement>` |
| If not found | `NoSuchElementException` | Empty list `[]` |
| Exception risk | Yes | No |
| Best for | Required unique elements | Multiple/optional elements |
| Check existence | No (use try/catch) | `.isEmpty()` |
| First match | Implicit | Use `.get(0)` |

## Common Patterns

```java
// 1. Get text from all product names
List<WebElement> names = driver.findElements(By.className("product-name"));
List<String> nameList = names.stream()
    .map(WebElement::getText)
    .collect(Collectors.toList());

// 2. Count search results
int count = driver.findElements(By.cssSelector(".result-item")).size();
Assert.assertTrue(count > 0, "No results found");

// 3. Check element does NOT exist
List<WebElement> ads = driver.findElements(By.id("ad-banner"));
Assert.assertTrue(ads.isEmpty(), "Ad banner should not appear after login");

// 4. Click the 3rd item in a list
List<WebElement> items = driver.findElements(By.cssSelector(".menu-item"));
items.get(2).click();   // index 2 = 3rd item

// 5. Wait for multiple elements
List<WebElement> cards = wait.until(
    ExpectedConditions.numberOfElementsToBeMoreThan(
        By.cssSelector(".card"), 0));
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['findElement', 'findElements', 'NoSuchElementException', 'WebElement', 'Selenium', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between implicit wait, explicit wait, and fluent wait in Selenium?',
  'implicit-explicit-fluent-wait-selenium-difference',
  'Implicit wait is a global timeout for finding elements. Explicit wait (WebDriverWait) waits for a specific condition. Fluent wait adds polling interval and exception ignore list — use explicit or fluent; avoid mixing with implicit.',
  $$## Selenium Wait Types Compared

## 1. Implicit Wait — Global Element Search Timeout

```java
// Set ONCE — applies to every findElement() call globally
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));

// Now every findElement() polls the DOM for up to 10s before throwing
driver.findElement(By.id("submit"));  // waits up to 10s

// ⚠️ Problems with implicit wait:
// 1. Makes "element should not be present" tests SLOW (always waits 10s)
// 2. Unpredictable interaction with explicit waits
// 3. Hides performance issues — elements should load fast!
```

## 2. Explicit Wait — Wait for a Specific Condition

```java
// Wait for a SPECIFIC element to meet a SPECIFIC condition
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

// Visibility
WebElement btn = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.id("submit")));

// Clickable
WebElement link = wait.until(
    ExpectedConditions.elementToBeClickable(By.cssSelector("a.nav-link")));

// Text present
wait.until(
    ExpectedConditions.textToBePresentInElementLocated(
        By.id("status"), "Order Confirmed"));

// URL change
wait.until(ExpectedConditions.urlContains("/dashboard"));

// Staleness — wait for old element to go stale (page refresh)
WebElement oldEl = driver.findElement(By.id("result"));
driver.navigate().refresh();
wait.until(ExpectedConditions.stalenessOf(oldEl));

// Alert
wait.until(ExpectedConditions.alertIsPresent());

// Attribute value
wait.until(ExpectedConditions.attributeToBe(By.id("btn"), "disabled", "true"));

// Number of elements
wait.until(ExpectedConditions.numberOfElementsToBe(By.cssSelector(".row"), 5));
```

## Common ExpectedConditions

```java
// Visibility / Presence
visibilityOfElementLocated(By locator)
presenceOfElementLocated(By locator)         // just in DOM, not visible
visibilityOfAllElementsLocatedBy(By locator) // all visible

// Clickability
elementToBeClickable(By locator)

// Text
textToBePresentInElementLocated(By, String)
textToBePresentInElementValue(By, String)

// URL / Title
urlContains(String fraction)
urlToBe(String exactUrl)
titleContains(String fraction)
titleIs(String exactTitle)

// Other
invisibilityOfElementLocated(By locator)     // wait for element to disappear
alertIsPresent()
frameToBeAvailableAndSwitchToIt(By locator)
stalenessOf(WebElement element)
numberOfElementsToBeMoreThan(By, int)
```

## 3. FluentWait — Maximum Control

```java
// FluentWait: custom polling interval + ignored exceptions + custom message
FluentWait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(20))          // max wait
    .pollingEvery(Duration.ofMillis(500))          // check every 500ms (not 250ms default)
    .ignoring(NoSuchElementException.class)        // don't throw if not found yet
    .ignoring(StaleElementReferenceException.class)
    .withMessage("Button was not clickable after 20s");

WebElement btn = fluentWait.until(driver ->
    driver.findElement(By.id("save-btn")));

// Custom condition with FluentWait
WebElement result = fluentWait.until(driver -> {
    WebElement el = driver.findElement(By.id("status"));
    String text = el.getText();
    return text.equals("Completed") ? el : null;   // return null to keep waiting
});
```

## Comparison Summary

| | Implicit Wait | Explicit Wait | Fluent Wait |
|--|:--:|:--:|:--:|
| Scope | Global | Single condition | Single condition |
| Condition | Element present | Any `ExpectedCondition` | Custom function |
| Polling | Fixed | Fixed (250ms) | Configurable |
| Ignore exceptions | No | No | Yes |
| Use case | Legacy code | Most production use | Complex dynamic pages |

## Best Practice

```java
// ✅ Recommended: Explicit wait per interaction
// ❌ Avoid: Mixing implicit + explicit waits (causes timeout multiplication bugs)
// ❌ Avoid: Thread.sleep() — wastes time, not condition-based
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Implicit Wait', 'Explicit Wait', 'FluentWait', 'WebDriverWait', 'ExpectedConditions', 'Selenium', 'Synchronization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Selenium Grid? How does it work?',
  'selenium-grid-how-it-works',
  'Selenium Grid allows running tests in parallel on multiple machines/browsers. A Hub receives test commands and distributes to Nodes. Selenium 4 has a unified Grid where Hub + Node roles are merged into one server.',
  $$## Selenium Grid

Selenium Grid lets you run Selenium tests on **multiple machines** and **multiple browsers in parallel**, reducing overall test suite execution time.

## Selenium Grid 3 Architecture (Hub-Node)

```
┌──────────────────────────────────┐
│           HUB (Central Server)    │
│  localhost:4444                   │
│  Receives test commands           │
│  Manages node registry           │
│  Routes tests to matching node    │
└──────────────────────────────────┘
          │            │
    ┌─────┴──┐   ┌─────┴──┐
    │ Node 1  │   │ Node 2  │
    │ Chrome  │   │ Firefox │
    │ Windows │   │ Linux   │
    └─────────┘   └─────────┘
```

## Selenium 4 Grid (Unified Architecture)

```
# Selenium 4 Grid modes:

# 1. Standalone (Hub + Node in ONE process)
java -jar selenium-server-4.x.jar standalone

# 2. Distributed (separate components)
java -jar selenium-server-4.x.jar router   --port 4444
java -jar selenium-server-4.x.jar distributor
java -jar selenium-server-4.x.jar node     --port 5555
```

## Starting Grid (Selenium 4 Standalone Mode)

```bash
# Terminal 1 — Start Grid
java -jar selenium-server-4.27.0.jar standalone --port 4444

# Open Grid UI at: http://localhost:4444/ui
```

## Connecting Tests to Grid — RemoteWebDriver

```java
// Instead of new ChromeDriver(), use RemoteWebDriver
URL gridUrl = new URL("http://localhost:4444/wd/hub");

// Specify browser capabilities
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless=new");

// Connect to Grid
WebDriver driver = new RemoteWebDriver(gridUrl, options);

driver.get("https://example.com");
System.out.println(driver.getTitle());
driver.quit();
```

## Cross-Browser Parallel Test with TestNG + Grid

```java
// BaseTest.java — reads browser from TestNG parameter
@Parameters("browser")
@BeforeMethod
public void setUp(@Optional("chrome") String browser) throws MalformedURLException {
    URL gridUrl = new URL("http://localhost:4444/wd/hub");
    MutableCapabilities options;

    switch (browser.toLowerCase()) {
        case "firefox": options = new FirefoxOptions(); break;
        case "edge":    options = new EdgeOptions();    break;
        default:        options = new ChromeOptions();  break;
    }

    WebDriver driver = new RemoteWebDriver(gridUrl, options);
    driver.manage().window().maximize();
    DriverManager.setDriver(driver);
}
```

```xml
<!-- testng.xml — run same tests on 3 browsers simultaneously -->
<suite name="Cross-Browser Grid" parallel="tests" thread-count="3">

    <test name="Chrome">
        <parameter name="browser" value="chrome"/>
        <classes><class name="com.automateqa.tests.LoginTest"/></classes>
    </test>

    <test name="Firefox">
        <parameter name="browser" value="firefox"/>
        <classes><class name="com.automateqa.tests.LoginTest"/></classes>
    </test>

    <test name="Edge">
        <parameter name="browser" value="edge"/>
        <classes><class name="com.automateqa.tests.LoginTest"/></classes>
    </test>

</suite>
```

## Docker Selenium Grid (Industry Standard)

```yaml
# docker-compose.yml — spin up Grid with Chrome + Firefox nodes
version: "3"
services:
  selenium-hub:
    image: selenium/hub:4.27.0
    ports:
      - "4442:4442"
      - "4443:4443"
      - "4444:4444"

  chrome-node:
    image: selenium/node-chrome:4.27.0
    shm_size: 2g
    depends_on: [selenium-hub]
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_NODE_MAX_SESSIONS=3
    deploy:
      replicas: 3   # 3 Chrome nodes

  firefox-node:
    image: selenium/node-firefox:4.27.0
    shm_size: 2g
    depends_on: [selenium-hub]
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
```

```bash
docker-compose up -d
# Grid UI: http://localhost:4444/ui
```

## Grid Benefits

| Without Grid | With Grid |
|-------------|-----------|
| 100 tests × 2 min each = 200 min | 100 tests in parallel = ~10 min |
| 1 browser | Multiple browsers simultaneously |
| 1 OS | Multiple OS simultaneously |
| Local only | Remote cloud machines |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium Grid', 'RemoteWebDriver', 'Hub Node', 'Parallel Testing', 'Docker', 'Cross-Browser', 'Selenium 4'], true, 0
);

-- ══════════════════════════════════════
-- INTERMEDIATE (Q5–Q18)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is JavascriptExecutor in Selenium? When do you use it?',
  'javascriptexecutor-selenium-when-to-use',
  'JavascriptExecutor lets you run JavaScript in the browser from Selenium tests. Use it when: native Selenium can''t click/scroll hidden elements, need to set input values directly, check element state, or scroll to an element.',
  $$## JavascriptExecutor in Selenium

JavascriptExecutor is an interface that lets you run **JavaScript code** in the browser context from your Selenium test.

## Basic Usage

```java
// Cast WebDriver to JavascriptExecutor
JavascriptExecutor js = (JavascriptExecutor) driver;

// Execute JS — no return value
js.executeScript("window.scrollTo(0, 500);");

// Execute JS — with return value
String title = (String) js.executeScript("return document.title;");
Long count    = (Long)   js.executeScript("return document.querySelectorAll('.item').length;");

// Pass element as argument to JS
WebElement btn = driver.findElement(By.id("submit"));
js.executeScript("arguments[0].click();", btn);
// arguments[0] = first passed argument (btn)
```

## Common Use Cases

### 1. Click When Normal Click Fails

```java
// Some elements reject regular .click() due to:
// - covered by overlay
// - hidden but exists in DOM
// - Angular intercepting click

WebElement btn = driver.findElement(By.id("submit"));
js.executeScript("arguments[0].click();", btn);
```

### 2. Scroll to Element / Position

```java
// Scroll to specific element
WebElement element = driver.findElement(By.id("footer-section"));
js.executeScript("arguments[0].scrollIntoView(true);", element);

// Scroll to bottom of page
js.executeScript("window.scrollTo(0, document.body.scrollHeight);");

// Scroll by pixels
js.executeScript("window.scrollBy(0, 300);");   // scroll down 300px

// Scroll element into center of viewport
js.executeScript("arguments[0].scrollIntoView({behavior:'smooth', block:'center'});", element);
```

### 3. Set Input Value Directly (Bypassing Events)

```java
// For date pickers, read-only fields, custom components
WebElement dateInput = driver.findElement(By.id("datepicker"));
js.executeScript("arguments[0].value = '2025-12-31';", dateInput);

// If you also need to trigger change event
js.executeScript(
    "arguments[0].value = arguments[1];" +
    "arguments[0].dispatchEvent(new Event('change'));",
    dateInput, "2025-12-31");
```

### 4. Get/Set Element Properties

```java
// Get computed style
String color = (String) js.executeScript(
    "return window.getComputedStyle(arguments[0]).backgroundColor;", element);

// Check if element is in viewport
Boolean isVisible = (Boolean) js.executeScript(
    "var rect = arguments[0].getBoundingClientRect();" +
    "return (rect.top >= 0 && rect.bottom <= window.innerHeight);", element);

// Get innerHTML
String html = (String) js.executeScript("return arguments[0].innerHTML;", element);

// Remove readonly attribute
js.executeScript("arguments[0].removeAttribute('readonly');", element);

// Remove disabled attribute
js.executeScript("arguments[0].removeAttribute('disabled');", element);
```

### 5. Handle Alerts and Popups

```java
// Create an alert via JS (for testing alert handlers)
js.executeScript("alert('Test alert');");

// Or get localStorage values
String token = (String) js.executeScript("return localStorage.getItem('auth_token');");
js.executeScript("localStorage.setItem('auth_token', arguments[0]);", "test_token_abc");
js.executeScript("localStorage.clear();");
```

### 6. Highlight Elements (Debugging)

```java
// Turn element border red temporarily — useful during debugging
public void highlight(WebElement el) {
    String originalStyle = el.getAttribute("style");
    js.executeScript(
        "arguments[0].style.border = '3px solid red';", el);
    Thread.sleep(500);
    js.executeScript(
        "arguments[0].setAttribute('style', arguments[1]);", el, originalStyle);
}
```

### 7. executeAsyncScript — Async Operations

```java
// Wait for async JS to complete (e.g., AJAX response)
String result = (String) js.executeAsyncScript(
    "var callback = arguments[arguments.length - 1];" +
    "fetch('/api/data').then(r => r.json()).then(d => callback(d.status));");
System.out.println("API status: " + result);
```

## When to Use JS vs Regular Selenium

| Use Regular Selenium | Use JavascriptExecutor |
|---------------------|----------------------|
| Standard visible elements | Hidden/overlaid elements |
| Normal clicks | Element intercepted by overlay |
| sendKeys on regular inputs | Read-only / custom date pickers |
| Standard scroll | Scroll to precise position |
| getAttribute() | computed styles, localStorage |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['JavascriptExecutor', 'Selenium', 'JS Click', 'Scroll', 'executeScript', 'Hidden Elements', 'WebDriver'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Actions class in Selenium? List common use cases.',
  'actions-class-selenium-use-cases',
  'The Actions class handles complex user interactions: mouse hover, right-click, double-click, drag-and-drop, key combos (Ctrl+A, Shift+click), and drawing. Build the action chain then call .build().perform().',
  $$## Actions Class in Selenium

The **Actions** class handles complex user interactions beyond simple `.click()` and `.sendKeys()`.

## Setup

```java
import org.openqa.selenium.interactions.Actions;

Actions actions = new Actions(driver);
```

## Hover / Mouse Over

```java
// Reveal hidden dropdown on hover
WebElement menu = driver.findElement(By.id("nav-products"));
actions.moveToElement(menu).perform();

// Now click the revealed submenu item
driver.findElement(By.linkText("Laptops")).click();
```

## Right Click (Context Menu)

```java
WebElement element = driver.findElement(By.id("file-icon"));
actions.contextClick(element).perform();

// Select option from context menu
driver.findElement(By.xpath("//li[text()='Rename']")).click();
```

## Double Click

```java
WebElement editableField = driver.findElement(By.id("inline-name"));
actions.doubleClick(editableField).perform();
// Makes field editable (inline editing pattern)
```

## Drag and Drop

```java
WebElement source = driver.findElement(By.id("draggable-card"));
WebElement target = driver.findElement(By.id("drop-zone"));

// Method 1 — direct
actions.dragAndDrop(source, target).perform();

// Method 2 — by offset (if target not precise)
actions.dragAndDropBy(source, 300, 0).perform();  // move 300px right

// Method 3 — explicit steps (more reliable on some apps)
actions.clickAndHold(source)
       .moveToElement(target)
       .release(target)
       .perform();
```

## Keyboard Combinations

```java
// Ctrl + A (select all)
actions.keyDown(Keys.CONTROL).sendKeys("a").keyUp(Keys.CONTROL).perform();

// Ctrl + C (copy)
actions.keyDown(Keys.CONTROL).sendKeys("c").keyUp(Keys.CONTROL).perform();

// Ctrl + V (paste)
actions.keyDown(Keys.CONTROL).sendKeys("v").keyUp(Keys.CONTROL).perform();

// Shift + Click (multi-select in lists)
WebElement firstItem = driver.findElement(By.cssSelector(".list-item:first-child"));
WebElement lastItem  = driver.findElement(By.cssSelector(".list-item:last-child"));
actions.click(firstItem)
       .keyDown(Keys.SHIFT)
       .click(lastItem)
       .keyUp(Keys.SHIFT)
       .perform();

// Tab through form fields
actions.sendKeys(Keys.TAB).sendKeys(Keys.TAB).perform();

// Arrow key navigation
actions.sendKeys(Keys.ARROW_DOWN).perform();
```

## Click at Offset (Relative to Element)

```java
// Click at a specific pixel position within an element
// Useful for canvas elements, sliders, maps
WebElement canvas = driver.findElement(By.id("drawing-canvas"));
actions.moveToElement(canvas, 100, 50).click().perform();
// Clicks at 100px right, 50px down from canvas center

// Slider — move to specific position
WebElement slider = driver.findElement(By.id("price-slider"));
actions.moveToElement(slider)
       .clickAndHold()
       .moveByOffset(150, 0)   // slide 150px right
       .release()
       .perform();
```

## Build + Perform vs Just Perform

```java
// .perform() — executes immediately
actions.moveToElement(menu).perform();

// .build().perform() — explicitly builds action chain first
Action chain = actions
    .moveToElement(source)
    .clickAndHold()
    .moveToElement(target)
    .release()
    .build();
chain.perform();
// Same result, but build() is useful if you want to store the action
```

## Common Real-World Scenarios

```java
// 1. Select text in a field and overtype
WebElement field = driver.findElement(By.id("name"));
actions.click(field)
       .keyDown(Keys.CONTROL).sendKeys("a").keyUp(Keys.CONTROL)
       .sendKeys("New Name")
       .perform();

// 2. Hover over map to get tooltip
actions.moveToElement(mapElement, x, y).perform();
String tooltip = wait.until(ExpectedConditions.visibilityOfElementLocated(
    By.cssSelector(".tooltip"))).getText();

// 3. Resize panel by dragging resize handle
WebElement handle = driver.findElement(By.className("resize-handle"));
actions.clickAndHold(handle).moveByOffset(200, 0).release().perform();
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Actions Class', 'Drag and Drop', 'Hover', 'Double Click', 'Keyboard Shortcuts', 'Selenium', 'Mouse Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you handle iframes, multiple windows, and alerts in Selenium?',
  'selenium-iframe-multiple-windows-alerts',
  'iFrames: switch with driver.switchTo().frame(). Multiple windows: get handles with driver.getWindowHandles(), switch with driver.switchTo().window(handle). Alerts: driver.switchTo().alert().accept()/dismiss().',
  $$## iFrames, Multiple Windows & Alerts in Selenium

## 1. Handling iFrames

An iframe embeds a separate HTML document. Selenium must switch context to interact inside it.

```java
// Switch by index (0-based)
driver.switchTo().frame(0);

// Switch by name or id
driver.switchTo().frame("paymentFrame");

// Switch by WebElement
WebElement iFrame = driver.findElement(By.cssSelector("iframe.payment-widget"));
driver.switchTo().frame(iFrame);

// Now interact inside the iframe
driver.findElement(By.id("card-number")).sendKeys("4111111111111111");
driver.findElement(By.id("cvv")).sendKeys("123");

// Switch BACK to main page (parent frame)
driver.switchTo().defaultContent();   // goes to top-level
driver.switchTo().parentFrame();      // goes to immediate parent (for nested iframes)
```

```java
// Nested iframes
driver.switchTo().frame("outer-frame");
driver.switchTo().frame("inner-frame");   // frame within frame
driver.findElement(By.id("inside-nested")).click();
driver.switchTo().defaultContent();       // back to main
```

## 2. Multiple Windows / Tabs

```java
// Get current window handle (before opening new window)
String mainWindow = driver.getWindowHandle();

// Click something that opens a new window/tab
driver.findElement(By.id("open-popup")).click();

// Get all window handles
Set<String> allWindows = driver.getWindowHandles();

// Switch to new window
for (String handle : allWindows) {
    if (!handle.equals(mainWindow)) {
        driver.switchTo().window(handle);
        break;
    }
}

// Perform actions in new window
System.out.println("Popup title: " + driver.getTitle());
driver.findElement(By.id("confirm-btn")).click();

// Close popup window and switch back
driver.close();                             // closes CURRENT window
driver.switchTo().window(mainWindow);       // switch back to main

// Open new tab (Selenium 4)
driver.switchTo().newWindow(WindowType.TAB);
driver.get("https://example.com");

// Open new window (Selenium 4)
driver.switchTo().newWindow(WindowType.WINDOW);
```

## 3. Alerts (JavaScript Popups)

```java
// Wait for alert and switch to it
Alert alert = wait.until(ExpectedConditions.alertIsPresent());

// OR immediately switch (if you know it's there)
Alert alert = driver.switchTo().alert();

// Get alert message
String message = alert.getText();
System.out.println("Alert says: " + message);

// Accept (OK)
alert.accept();

// Dismiss (Cancel)
alert.dismiss();

// Prompt — type text then accept
alert.sendKeys("My input text");
alert.accept();
```

```java
// Handling alert types:

// 1. Simple alert — just OK button
driver.findElement(By.id("show-alert")).click();
driver.switchTo().alert().accept();

// 2. Confirm — OK or Cancel
driver.findElement(By.id("show-confirm")).click();
Alert confirm = driver.switchTo().alert();
System.out.println(confirm.getText());   // "Are you sure?"
confirm.accept();    // clicks OK
// confirm.dismiss(); // clicks Cancel

// 3. Prompt — text input + OK/Cancel
driver.findElement(By.id("show-prompt")).click();
Alert prompt = driver.switchTo().alert();
prompt.sendKeys("John Doe");
prompt.accept();
```

## Complete Window Management Helper

```java
// utility method — switch to window by title
public void switchToWindowByTitle(String targetTitle) {
    String currentHandle = driver.getWindowHandle();
    Set<String> handles  = driver.getWindowHandles();

    for (String handle : handles) {
        driver.switchTo().window(handle);
        if (driver.getTitle().contains(targetTitle)) {
            return;  // found it — stay here
        }
    }
    // Not found — switch back to original
    driver.switchTo().window(currentHandle);
    throw new NoSuchWindowException("Window with title '" + targetTitle + "' not found");
}

// Usage
switchToWindowByTitle("Payment Gateway");
driver.findElement(By.id("pay-btn")).click();
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['iFrame', 'Multiple Windows', 'Alerts', 'switchTo', 'Window Handles', 'JavaScript Alert', 'Selenium'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are the new features in Selenium 4 compared to Selenium 3?',
  'selenium-4-new-features-vs-selenium-3',
  'Selenium 4 adopts W3C WebDriver standard (no JSON Wire Protocol), adds native Chrome DevTools Protocol (CDP), relative locators (above/below/near), improved Grid, new window/tab API, and better documentation.',
  $$## Selenium 4 Key New Features

## 1. W3C WebDriver Standard (No JSON Wire Protocol)

```java
// Selenium 3 — JSON Wire Protocol (custom, not W3C)
// Selenium 4 — W3C WebDriver standard natively
// Impact: Better cross-browser compatibility, no capability translation needed

// Capabilities now use standard W3C format
ChromeOptions options = new ChromeOptions();
options.setCapability("browserVersion", "latest");  // W3C standard key
```

## 2. Relative Locators (Selenium 4 Only)

Find elements based on their position **relative to other elements**:

```java
import static org.openqa.selenium.support.locators.RelativeLocator.with;

// Element ABOVE another
WebElement labelAbove = driver.findElement(
    with(By.tagName("label")).above(By.id("password")));

// Element BELOW another
WebElement helpText = driver.findElement(
    with(By.className("hint")).below(By.id("username")));

// Element to the LEFT
WebElement label = driver.findElement(
    with(By.tagName("label")).toLeftOf(By.id("email")));

// Element to the RIGHT
WebElement icon = driver.findElement(
    with(By.tagName("img")).toRightOf(By.id("email")));

// Element NEAR (within 50px) another
WebElement nearBtn = driver.findElement(
    with(By.tagName("button")).near(By.id("submit")));
```

## 3. Chrome DevTools Protocol (CDP) Integration

```java
// Selenium 4 provides native access to Chrome DevTools Protocol
ChromeDriver driver = new ChromeDriver();
DevTools devTools = driver.getDevTools();
devTools.createSession();

// Mock geolocation
devTools.send(Emulation.setGeolocationOverride(
    Optional.of(37.7749),    // lat (San Francisco)
    Optional.of(-122.4194),  // long
    Optional.of(1.0)));

// Simulate network throttling
devTools.send(Network.emulateNetworkConditions(
    false, 100, 50000, 50000,
    Optional.of(Network.ConnectionType.WIFI)));

// Capture network logs
devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));
devTools.addListener(Network.requestWillBeSent(), request ->
    System.out.println("URL: " + request.getRequest().getUrl()));

// Set basic auth (no alert handling needed!)
devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));
((HasAuthentication) driver).register(
    UsernameAndPassword.of("admin", "password"));
```

## 4. New Window and Tab API

```java
// Open NEW tab (clean Selenium 4 API — no JS tricks needed)
driver.switchTo().newWindow(WindowType.TAB);
driver.get("https://example.com");

// Open NEW browser window
driver.switchTo().newWindow(WindowType.WINDOW);
driver.get("https://example.com");
```

## 5. Improved Screenshots

```java
// Selenium 3: screenshot of full page only
// Selenium 4: screenshot of individual ELEMENT

WebElement card = driver.findElement(By.cssSelector(".product-card"));
File cardScreenshot = card.getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(cardScreenshot, new File("card.png"));

// Full page still works
File fullPage = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
```

## 6. Selenium Grid 4 — Fully Revamped

```bash
# Grid 4 — single JAR, multiple modes
java -jar selenium-server.jar standalone      # Hub + Node in one
java -jar selenium-server.jar hub             # Hub only
java -jar selenium-server.jar node            # Node only

# Grid UI at localhost:4444/ui
# Observability: OpenTelemetry tracing, distributed logging
# Docker-ready out of the box
```

## 7. Deprecations Removed in Selenium 4

```java
// Selenium 3 (deprecated in 4)
driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);   // old

// Selenium 4 (use Duration)
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10)); // new

// DesiredCapabilities replaced by browser-specific Options
// DesiredCapabilities caps = new DesiredCapabilities();  ← Selenium 3
ChromeOptions options = new ChromeOptions();              // ← Selenium 4
```

## Quick Migration: Selenium 3 → 4

| Change | Selenium 3 | Selenium 4 |
|--------|-----------|-----------|
| Capabilities | `DesiredCapabilities` | `BrowserOptions` (ChromeOptions etc.) |
| Timeouts | `TimeUnit.SECONDS` | `Duration.ofSeconds()` |
| Grid | Hub-Node separate JARs | Single JAR, multiple modes |
| Screenshots | Page only | Element-level supported |
| Relative locators | Not available | `with(By.x).above(By.y)` |
| CDP | Not available | Native support |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium 4', 'New Features', 'W3C', 'CDP', 'Relative Locators', 'DevTools', 'Grid 4'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between XPath and CSS Selector in Selenium? Which is faster?',
  'xpath-vs-css-selector-selenium-performance',
  'CSS selectors are faster and simpler for forward/descendant lookups. XPath is more powerful — supports text content matching, parent traversal, and sibling navigation. Prefer CSS for most cases, XPath for text/parent lookup.',
  $$## XPath vs CSS Selector in Selenium

## CSS Selectors (Preferred for Most Cases)

```java
// ID
By.cssSelector("#submit-btn")         // faster than By.id()

// Class
By.cssSelector(".error-message")
By.cssSelector(".btn.btn-primary")    // multiple classes

// Attribute
By.cssSelector("[data-testid='login']")
By.cssSelector("input[type='email']")
By.cssSelector("[placeholder='Enter email']")
By.cssSelector("[href*='login']")     // href CONTAINS 'login'
By.cssSelector("[class^='btn-']")     // class STARTS WITH 'btn-'
By.cssSelector("[class$='-primary']") // class ENDS WITH '-primary'

// Parent → Child (direct)
By.cssSelector("form > input")        // input is DIRECT child of form

// Ancestor → Descendant
By.cssSelector("div.container input") // input anywhere inside div.container

// nth-child
By.cssSelector("table tr:nth-child(2)")   // 2nd row
By.cssSelector("ul li:first-child")
By.cssSelector("ul li:last-child")

// Combination
By.cssSelector("div.login-form input[type='password']")
```

## XPath Selectors

```java
// Absolute (fragile — never use)
By.xpath("/html/body/div/form/input")   // ❌ breaks on any DOM change

// Relative (always use)
By.xpath("//input[@id='email']")
By.xpath("//button[@type='submit']")
By.xpath("//div[@class='login-form']//input[@type='email']")

// By TEXT CONTENT (XPath unique advantage)
By.xpath("//button[text()='Submit']")
By.xpath("//button[contains(text(),'Sign')]")
By.xpath("//label[normalize-space(text())='Email Address']")

// Parent traversal (XPath unique advantage)
By.xpath("//input[@id='email']/parent::div")             // go UP to parent
By.xpath("//input[@id='email']/ancestor::form")          // go UP to ancestor
By.xpath("//label[text()='Email']/following-sibling::input")  // sibling
By.xpath("//tr[td[text()='Alice']]//button[@class='edit']")   // row by cell

// Index (1-based in XPath!)
By.xpath("(//input[@type='text'])[2]")   // 2nd text input

// contains() — partial match
By.xpath("//div[contains(@class,'error')]")
By.xpath("//a[contains(@href,'logout')]")

// Multiple conditions (and / or)
By.xpath("//input[@type='text' and @required]")
By.xpath("//button[@id='ok' or @id='confirm']")

// starts-with()
By.xpath("//input[starts-with(@id,'user-')]")
```

## Key Differences

| | CSS Selector | XPath |
|--|:--:|:--:|
| Speed | Faster (browser-native) | Slightly slower |
| Readability | Cleaner | Verbose |
| Text matching | ❌ Not supported | ✅ `text()`, `contains(text())` |
| Parent traversal | ❌ Not supported | ✅ `parent::`, `ancestor::` |
| Preceding sibling | ❌ Not supported | ✅ `preceding-sibling::` |
| Index | `:nth-child(n)` | `[n]` (1-based) |
| Browser support | All browsers | All browsers |

## When to Use Each

```java
// Use CSS when:
// - ID, class, attribute, or structural location
By.cssSelector("[data-testid='login-btn']")    // attribute
By.cssSelector("table tr:nth-child(3) td")     // table cell
By.cssSelector(".nav-menu > li:first-child a") // nested structure

// Use XPath when:
// - Need to match by text
By.xpath("//button[text()='Delete']")

// - Need to traverse UP the DOM (find parent)
By.xpath("//input[@id='search']/ancestor::form")

// - Need preceding-sibling
By.xpath("//td[text()='Alice']/preceding-sibling::td[1]")

// - Dynamic content where text is the only stable identifier
By.xpath("//span[contains(text(),'Order #')]")
```

## Best Practice Hierarchy

1. `By.id()` — most reliable, fastest
2. `By.cssSelector("[data-testid='x']")` — test-specific attributes
3. `By.cssSelector()` — general CSS
4. `By.xpath()` — when text matching or parent traversal needed
5. Never: `By.xpath("/html/body/...")` — absolute paths$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['XPath', 'CSS Selector', 'Locators', 'Performance', 'Selenium', 'WebDriver', 'Best Practices'], true, 0
);

-- ══════════════════════════════════════
-- ADVANCED / SCENARIO-BASED
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you handle file upload and download in Selenium?',
  'selenium-file-upload-download-handling',
  'File upload: use sendKeys() with the local file path on the input[type=file] element. File download: configure ChromeOptions to set download directory; verify file exists post-action.',
  $$## File Upload and Download in Selenium

## File Upload

### Method 1 — sendKeys() on input[type=file] (Most Reliable)

```java
// Works when there is a visible or hidden <input type="file">
WebElement uploadInput = driver.findElement(By.cssSelector("input[type='file']"));
uploadInput.sendKeys("C:\\Users\\user\\Downloads\\test-document.pdf");
// Or for Linux/Mac: "/home/user/test-document.pdf"

// For hidden file inputs (display:none) — still works!
// Selenium can sendKeys to hidden file inputs
WebElement hiddenInput = driver.findElement(By.id("file-upload"));
hiddenInput.sendKeys("/path/to/file.txt");

// If JavaScript is needed to unhide the input first:
js.executeScript("arguments[0].style.display='block';", hiddenInput);
hiddenInput.sendKeys("/path/to/file.txt");
```

### Method 2 — Robot Class (System File Dialog)

```java
// When you MUST interact with OS file dialog (not recommended)
driver.findElement(By.id("upload-btn")).click();

// Small sleep to let dialog open
Thread.sleep(1000);

// Type the path using Robot (keyboard simulation)
Robot robot = new Robot();
StringSelection selection = new StringSelection("/path/to/file.txt");
Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, null);
robot.keyPress(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_ENTER);
robot.keyRelease(KeyEvent.VK_ENTER);
```

### Multiple File Upload

```java
// Upload multiple files in one input
WebElement multiUpload = driver.findElement(By.id("multi-file-input"));
String files = "C:\\file1.txt" + "\n" + "C:\\file2.txt" + "\n" + "C:\\file3.txt";
multiUpload.sendKeys(files);
```

## File Download

### Configure ChromeOptions Download Directory

```java
// Set download path before launching Chrome
String downloadPath = System.getProperty("user.dir") + "/downloads";
new File(downloadPath).mkdirs();

Map<String, Object> prefs = new HashMap<>();
prefs.put("download.default_directory", downloadPath);
prefs.put("download.prompt_for_download", false);        // no save dialog
prefs.put("download.directory_upgrade", true);
prefs.put("safebrowsing.enabled", true);                 // allow downloads

ChromeOptions options = new ChromeOptions();
options.setExperimentalOption("prefs", prefs);

WebDriver driver = new ChromeDriver(options);
```

### Verify Downloaded File

```java
// Wait for file to appear (download takes time)
public boolean waitForDownload(String fileName, int timeoutSeconds) throws InterruptedException {
    String downloadPath = System.getProperty("user.dir") + "/downloads/";
    File expectedFile = new File(downloadPath + fileName);

    int elapsed = 0;
    while (elapsed < timeoutSeconds) {
        if (expectedFile.exists() && expectedFile.length() > 0) {
            System.out.println("Downloaded: " + expectedFile.getAbsolutePath());
            return true;
        }
        Thread.sleep(1000);
        elapsed++;
    }
    return false;
}

// Usage in test
driver.findElement(By.id("download-report")).click();
boolean downloaded = waitForDownload("report.pdf", 30);
Assert.assertTrue(downloaded, "Report PDF was not downloaded within 30s");
```

### For Headless Chrome (Grid / CI)

```java
// Headless Chrome needs extra setting for downloads
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage");
options.addArguments("--disable-gpu");

// Enable downloads in headless mode via CDP
ChromeDriver driver = new ChromeDriver(options);
DevTools devTools = driver.getDevTools();
devTools.createSession();
devTools.send(Browser.setDownloadBehavior(
    Browser.SetDownloadBehaviorBehavior.ALLOW,
    Optional.empty(),
    Optional.of("/tmp/downloads"),
    Optional.of(true)));
```

## Clean Up After Test

```java
@AfterMethod
public void cleanupDownloads() {
    File dir = new File(System.getProperty("user.dir") + "/downloads");
    if (dir.exists()) {
        for (File f : Objects.requireNonNull(dir.listFiles())) {
            f.delete();
        }
    }
}
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['File Upload', 'File Download', 'ChromeOptions', 'sendKeys', 'Selenium', 'WebDriver', 'Robot Class'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'Scenario: Your Selenium test is flaky — sometimes passes, sometimes fails. How do you debug and fix it?',
  'debug-fix-flaky-selenium-tests',
  'Flaky test causes: timing issues (missing explicit wait), stale elements, environment inconsistency, test order dependency, or hardcoded sleeps. Debug by adding waits, screenshots on failure, logging, and isolating the test.',
  $$## Debugging and Fixing Flaky Selenium Tests

## What Makes Tests Flaky?

```
Root Causes of Flakiness:
1. Timing/Synchronization — element not ready yet
2. StaleElementReferenceException — DOM changed between find and use
3. Test order dependency — Test B relies on state left by Test A
4. Environment inconsistency — different browser version, network speed
5. Thread safety — parallel tests sharing state
6. Hardcoded sleeps — sleep(3000) too short on slow machine
7. Implicit + explicit wait conflicts — doubled timeouts
8. Element covered by another — ads, spinners, cookie banners
```

## Diagnosis Steps

### Step 1 — Capture Evidence

```java
// Add a TestNG listener that screenshots on every failure
@Override
public void onTestFailure(ITestResult result) {
    // Screenshot
    File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
    FileUtils.copyFile(screenshot, new File("fails/" + result.getName() + ".png"));

    // Page source
    String source = driver.getPageSource();
    FileUtils.writeStringToFile(new File("fails/" + result.getName() + ".html"), source);

    // Current URL
    System.out.println("FAIL URL: " + driver.getCurrentUrl());
    System.out.println("FAIL Title: " + driver.getTitle());
}
```

### Step 2 — Add Detailed Logging

```java
// Log what happens at each step
public void click(By locator) {
    log.info("Waiting for element: " + locator);
    WebElement el = waitForClickable(locator);
    log.info("Clicking: " + locator);
    el.click();
    log.info("Clicked: " + locator);
}
```

### Step 3 — Run in Isolation

```java
// Run the specific flaky test 10 times alone
// testng.xml
<suite name="Flaky Debug" verbose="2">
    <test name="FlickyTest" preserve-order="true">
        <classes>
            <class name="com.tests.PaymentTest">
                <methods>
                    <include name="testCheckoutFlow"/>
                </methods>
            </class>
        </classes>
    </test>
</suite>
```

## Common Fixes

### Fix 1 — Replace sleep() With Explicit Wait

```java
// ❌ Flaky
Thread.sleep(3000);
driver.findElement(By.id("result")).click();

// ✅ Reliable
wait.until(ExpectedConditions.elementToBeClickable(By.id("result"))).click();
```

### Fix 2 — Wait for Loading Spinners to Disappear

```java
// Wait for spinner to vanish before acting
protected void waitForPageLoad() {
    By spinner = By.cssSelector(".spinner, .loading-overlay, [data-loading='true']");
    try {
        new WebDriverWait(driver, Duration.ofSeconds(3))
            .until(ExpectedConditions.visibilityOfElementLocated(spinner));
    } catch (TimeoutException ignored) {}
    wait.until(ExpectedConditions.invisibilityOfElementLocated(spinner));
}
```

### Fix 3 — Handle StaleElementReferenceException

```java
protected WebElement findWithRetry(By locator) {
    for (int attempt = 0; attempt < 3; attempt++) {
        try {
            return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
        } catch (StaleElementReferenceException e) {
            log.warn("Stale element, retrying: " + locator + " attempt " + attempt);
        }
    }
    throw new RuntimeException("Element stale after 3 attempts: " + locator);
}
```

### Fix 4 — Wait for AJAX/Network Calls

```java
// Wait for jQuery AJAX to complete
public void waitForAjax() {
    wait.until(driver -> {
        Boolean isIdle = (Boolean) ((JavascriptExecutor) driver)
            .executeScript("return jQuery.active === 0");
        return isIdle;
    });
}

// Wait for Angular to stabilize
public void waitForAngular() {
    js.executeAsyncScript(
        "var callback = arguments[arguments.length - 1];" +
        "angular.getTestability(document.body).whenStable(callback);");
}
```

### Fix 5 — Fix Test Order Dependency

```java
// ❌ Depends on previous test
@Test(priority = 2)
public void testCheckout() {
    // Assumes testLogin() ran first and left cookies
}

// ✅ Each test sets its own state
@Test
public void testCheckout() {
    loginPage.login("alice@test.com", "Pass@123");  // explicit setup
    productPage.addToCart("Laptop");
    cartPage.checkout();
}
```

### Fix 6 — Dismiss Cookie Banners / Popups

```java
@BeforeMethod
public void dismissCookieBanner() {
    try {
        WebElement cookieBtn = new WebDriverWait(driver, Duration.ofSeconds(3))
            .until(ExpectedConditions.elementToBeClickable(
                By.cssSelector("#cookie-accept, .cookie-consent-btn")));
        cookieBtn.click();
    } catch (TimeoutException e) {
        // No cookie banner — that's fine
    }
}
```

### Fix 7 — JS Click for Intercepted Clicks

```java
// ❌ org.openqa.selenium.ElementClickInterceptedException
element.click();

// ✅ JavaScript click bypasses element interception
((JavascriptExecutor) driver).executeScript("arguments[0].click();", element);
```

## Retry Mechanism for Critical Tests

```java
// TestNG retry analyzer — re-run flaky tests up to 2 times
public class RetryAnalyzer implements IRetryAnalyzer {
    private int count = 0;
    private static final int MAX_RETRY = 2;

    @Override
    public boolean retry(ITestResult result) {
        if (count < MAX_RETRY) {
            count++;
            log.warn("Retrying test: " + result.getName() + " (attempt " + count + ")");
            return true;
        }
        return false;
    }
}

// Apply to test
@Test(retryAnalyzer = RetryAnalyzer.class)
public void testFlickyFeature() { ... }
```$$,
  'Selenium', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Flaky Tests', 'Debugging', 'Explicit Wait', 'StaleElement', 'Retry', 'Framework', 'Selenium'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you design a Selenium framework to run tests on multiple browsers and environments (staging/QA/prod)?',
  'selenium-multi-browser-multi-environment-framework',
  'Use ChromeOptions/FirefoxOptions/EdgeOptions selected by a config property (browser). Point RemoteWebDriver to Selenium Grid for cross-browser. Use separate .properties files per environment (staging/qa/prod) selected via -Denv=qa.',
  $$## Multi-Browser, Multi-Environment Selenium Framework

## Architecture Overview

```
                     testng.xml / Maven CLI
                           │
                    ┌──────┴──────┐
                    │  BaseTest   │
                    │ @BeforeMethod│
                    └──────┬──────┘
                           │
               ┌───────────┴────────────┐
               │      DriverFactory      │
               │  browser=chrome/ff/edge │
               │  mode=local/grid/sauce  │
               └───────────┬────────────┘
               │           │           │
         ChromeDriver  FirefoxDriver  RemoteWebDriver (Grid)
                           │
               ┌───────────┴────────────┐
               │     ConfigReader       │
               │  env=staging/qa/prod   │
               └────────────────────────┘
```

## Environment Config Files

```properties
# config/staging.properties
base.url=https://staging.automateqa.online
db.url=jdbc:postgresql://staging-db:5432/automateqa
api.base=https://api.staging.automateqa.online
test.user=staging_test@automateqa.com
test.pass=StagingPass@123

# config/qa.properties
base.url=https://qa.automateqa.online
api.base=https://api.qa.automateqa.online

# config/prod.properties  (read-only smoke tests only!)
base.url=https://automateqa.online
test.user=prod_smoke@automateqa.com
```

## DriverFactory — Supports Local + Grid

```java
public class DriverFactory {

    public static WebDriver createDriver(String browser, boolean headless)
            throws MalformedURLException {

        String gridUrl = ConfigReader.get("grid.url");  // "" or actual Grid URL

        if (gridUrl != null && !gridUrl.isEmpty()) {
            return createRemoteDriver(browser, headless, gridUrl);
        } else {
            return createLocalDriver(browser, headless);
        }
    }

    private static WebDriver createLocalDriver(String browser, boolean headless) {
        switch (browser.toLowerCase()) {
            case "firefox":
                FirefoxOptions ffOpts = new FirefoxOptions();
                if (headless) ffOpts.addArguments("--headless");
                return new FirefoxDriver(ffOpts);

            case "edge":
                EdgeOptions edgeOpts = new EdgeOptions();
                if (headless) edgeOpts.addArguments("--headless");
                return new EdgeDriver(edgeOpts);

            default: // chrome
                ChromeOptions opts = new ChromeOptions();
                if (headless) opts.addArguments("--headless=new",
                    "--no-sandbox", "--disable-dev-shm-usage");
                return new ChromeDriver(opts);
        }
    }

    private static WebDriver createRemoteDriver(String browser, boolean headless, String gridUrl)
            throws MalformedURLException {
        MutableCapabilities options;
        switch (browser.toLowerCase()) {
            case "firefox": options = new FirefoxOptions(); break;
            case "edge":    options = new EdgeOptions();    break;
            default:        options = new ChromeOptions();  break;
        }
        if (headless) ((ChromeOptions) options).addArguments("--headless=new");
        return new RemoteWebDriver(new URL(gridUrl), options);
    }
}
```

## BaseTest — Reads From Config

```java
public class BaseTest {

    @Parameters({"browser", "env"})
    @BeforeMethod(alwaysRun = true)
    public void setUp(@Optional("chrome") String browser,
                      @Optional("staging") String env)
            throws MalformedURLException {

        // Set env so ConfigReader loads the right .properties file
        System.setProperty("env", env);
        System.setProperty("browser", browser);

        boolean headless = ConfigReader.isHeadless();
        WebDriver driver = DriverFactory.createDriver(browser, headless);
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        DriverManager.setDriver(driver);

        String baseUrl = ConfigReader.getBaseUrl();
        driver.get(baseUrl);
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            ScreenshotUtil.capture(result.getName());
        }
        DriverManager.quitDriver();
    }
}
```

## testng.xml — Cross-Browser on Staging

```xml
<suite name="Cross-Browser Staging" parallel="tests" thread-count="3">
    <parameter name="env" value="staging"/>

    <test name="Chrome-Staging">
        <parameter name="browser" value="chrome"/>
        <classes><class name="com.automateqa.tests.SmokeTest"/></classes>
    </test>

    <test name="Firefox-Staging">
        <parameter name="browser" value="firefox"/>
        <classes><class name="com.automateqa.tests.SmokeTest"/></classes>
    </test>

    <test name="Edge-Staging">
        <parameter name="browser" value="edge"/>
        <classes><class name="com.automateqa.tests.SmokeTest"/></classes>
    </test>
</suite>
```

## GitHub Actions — Multi-Environment Matrix

```yaml
name: Multi-Environment Tests

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 */6 * * *'   # Every 6 hours

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        env:     [staging, qa]
        browser: [chrome, firefox]

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'

      - name: Start Selenium Grid
        run: |
          docker network create grid
          docker run -d -p 4444:4444 --network grid selenium/standalone-chrome:latest
          sleep 10

      - name: Run Tests — ${{ matrix.env }} / ${{ matrix.browser }}
        run: |
          mvn test \
            -Denv=${{ matrix.env }} \
            -Dbrowser=${{ matrix.browser }} \
            -Dheadless=true \
            -Dgrid.url=http://localhost:4444 \
            -Dbase.url=${{ secrets[format('{0}_BASE_URL', matrix.env)] }}

      - name: Upload Report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: report-${{ matrix.env }}-${{ matrix.browser }}
          path: test-output/
```$$,
  'Selenium', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Multi-Browser', 'Multi-Environment', 'DriverFactory', 'ConfigReader', 'Selenium Grid', 'GitHub Actions', 'Framework'], true, 0
);
