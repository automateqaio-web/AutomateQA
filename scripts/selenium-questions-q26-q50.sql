-- Selenium Interview Questions Q26–Q50
-- Run in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES
(
  'How can we click on an element using Selenium WebDriver?',
  'how-to-click-element-using-selenium-webdriver',
  'Use the click() method on a located WebElement to perform a mouse click action in Selenium.',
  $body$Use the **`click()`** method on a `WebElement` to simulate a mouse click.

**Basic click:**
```java
driver.findElement(By.id("loginBtn")).click();
driver.findElement(By.cssSelector(".btn-submit")).click();
driver.findElement(By.xpath("//button[text()='Login']")).click();
```

**Best practice — wait before clicking:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement btn = wait.until(ExpectedConditions.elementToBeClickable(By.id("loginBtn")));
btn.click();
```

**Click with JavaScript (for hidden or overlapping elements):**
```java
WebElement btn = driver.findElement(By.id("loginBtn"));
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].click();", btn);
```

**Common click errors:**
| Error | Cause | Fix |
|-------|-------|-----|
| `ElementNotInteractableException` | Element is hidden | JS click or scroll into view |
| `ElementClickInterceptedException` | Another element overlaps | Wait for overlay to disappear |
| `StaleElementReferenceException` | DOM changed after find | Re-find the element |
| `TimeoutException` | Element not found in time | Increase wait timeout |$body$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'click()', 'Interactions'], true, 0
),
(
  'What are different types of waits available in Selenium WebDriver?',
  'different-types-of-waits-in-selenium-webdriver',
  'Selenium provides three types of waits: Implicit Wait, Explicit Wait, and Fluent Wait.',
  $body$Selenium WebDriver provides **3 types of waits** to handle synchronization between test code and the browser:

**1. Implicit Wait**
Tells WebDriver to wait for a specified time before throwing a `NoSuchElementException`.
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```
- Applied globally to all `findElement()` calls
- Polls at ~500ms intervals

**2. Explicit Wait (WebDriverWait)**
Waits for a specific condition before proceeding.
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("result")));
```
- Applied to specific elements
- Most commonly used in frameworks

**3. Fluent Wait**
Advanced explicit wait with custom polling interval and exception ignore list.
```java
Wait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(30))
    .pollingEvery(Duration.ofSeconds(2))
    .ignoring(NoSuchElementException.class);
```

**Comparison:**
| | Implicit | Explicit | Fluent |
|--|--|--|--|
| Scope | Global | Per element | Per element |
| Custom conditions | No | Yes | Yes |
| Custom polling | No | No | Yes |
| Best use | Quick prototyping | Production tests | Dynamic/AJAX apps |

> **Avoid `Thread.sleep()`** — it is a hard pause and wastes time even when the element is ready.$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'Synchronization', 'WebDriverWait'], true, 0
),
(
  'How to implement Explicit Wait (WebDriverWait) in Selenium?',
  'how-to-implement-explicit-wait-webdriverwait-in-selenium',
  'Explicit Wait uses WebDriverWait with ExpectedConditions to pause execution until a specific condition is met.',
  $body$**Explicit Wait** pauses the test until a specific condition is true, with a timeout.

**Setup:**
```java
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import java.time.Duration;

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
```

**Common ExpectedConditions:**
```java
// Wait for element to be visible
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("result")));

// Wait for element to be clickable
WebElement btn = wait.until(ExpectedConditions.elementToBeClickable(By.id("submitBtn")));
btn.click();

// Wait for text to be present
wait.until(ExpectedConditions.textToBePresentInElementLocated(By.id("msg"), "Success"));

// Wait for element to disappear
wait.until(ExpectedConditions.invisibilityOfElementLocated(By.id("loader")));

// Wait for URL to contain
wait.until(ExpectedConditions.urlContains("/dashboard"));

// Wait for page title
wait.until(ExpectedConditions.titleContains("Home"));

// Custom wait with lambda
wait.until(d -> d.findElement(By.id("count")).getText().equals("10"));
```

> **Best practice:** Always prefer `elementToBeClickable` over `visibilityOfElementLocated` before `.click()` calls.$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'WebDriverWait', 'ExpectedConditions'], true, 0
),
(
  'What is Implicit Wait in Selenium?',
  'what-is-implicit-wait-in-selenium',
  'Implicit Wait sets a global timeout for WebDriver to poll for an element before throwing NoSuchElementException.',
  $body$**Implicit Wait** sets a default timeout for the WebDriver to poll the DOM repeatedly until an element is found, before throwing `NoSuchElementException`.

**How to set:**
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```

**How it works:**
1. You call `driver.findElement(By.id("btn"))`
2. WebDriver polls the DOM for up to 10 seconds
3. If found before 10s → proceeds immediately
4. If not found in 10s → throws `NoSuchElementException`

**Key characteristics:**
- Set **once** per driver session — applies globally
- Polls at ~500ms intervals
- Applies only to `findElement()` and `findElements()`
- Does NOT work with `ExpectedConditions`

**Example:**
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
driver.get("https://automateqa.online");
// All findElement calls now wait up to 10 seconds
WebElement el = driver.findElement(By.id("result")); // Waits if not immediately available
```

**When to use:**
Good for simple scripts. For production frameworks, prefer Explicit Wait instead.

> **Warning:** Mixing implicit and explicit waits can cause unpredictable wait times. Choose one strategy per project.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Waits', 'Implicit Wait', 'Synchronization'], true, 0
),
(
  'How to implement Fluent Wait in Selenium?',
  'how-to-implement-fluent-wait-in-selenium',
  'Fluent Wait provides configurable polling intervals and exception ignoring for waiting on dynamic elements.',
  $body$**Fluent Wait** is an advanced form of Explicit Wait with a customizable polling interval and the ability to ignore specific exceptions during polling.

**Full implementation:**
```java
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import java.time.Duration;
import java.util.function.Function;

Wait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(30))      // Max wait time
    .pollingEvery(Duration.ofSeconds(2))       // Poll every 2 seconds
    .ignoring(NoSuchElementException.class);   // Ignore this exception while polling

// Wait for element with Fluent Wait
WebElement element = fluentWait.until(driver -> driver.findElement(By.id("dynamicResult")));
```

**Custom function wait:**
```java
fluentWait.until(new Function<WebDriver, Boolean>() {
    public Boolean apply(WebDriver driver) {
        String count = driver.findElement(By.id("counter")).getText();
        return count.equals("100");
    }
});
```

**Comparison — Fluent vs Explicit:**
| | Explicit Wait | Fluent Wait |
|--|--|--|
| Polling interval | Fixed (~500ms) | Customizable |
| Ignore exceptions | Cannot customize | Can ignore specific |
| Use case | Most scenarios | AJAX, heavy dynamic pages |$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'Fluent Wait', 'Synchronization'], true, 0
),
(
  'What is the Actions class in Selenium WebDriver?',
  'what-is-actions-class-in-selenium-webdriver',
  'Actions class in Selenium provides methods to perform complex keyboard and mouse interactions like hover, drag-drop, and right-click.',
  $body$The **Actions** class in Selenium WebDriver (`org.openqa.selenium.interactions.Actions`) provides an API to perform complex user interaction sequences — mouse movements, keyboard events, drag-and-drop, etc.

**Import and setup:**
```java
import org.openqa.selenium.interactions.Actions;

Actions actions = new Actions(driver);
```

**Common Actions methods:**
| Method | Description |
|--------|-------------|
| `moveToElement(el)` | Mouse hover over element |
| `click(el)` | Click an element |
| `doubleClick(el)` | Double click |
| `contextClick(el)` | Right click |
| `dragAndDrop(src, tgt)` | Drag from source to target |
| `sendKeys(keys)` | Send keyboard keys |
| `clickAndHold(el)` | Click without releasing |
| `release(el)` | Release mouse button |
| `keyDown(Keys.CONTROL)` | Hold a key |
| `keyUp(Keys.CONTROL)` | Release a key |
| `build().perform()` | Execute the action chain |

**Key pattern:**
```java
actions.moveToElement(menuItem)
       .click(subMenuItem)
       .build()
       .perform();
```

> **Always call `.build().perform()`** at the end to execute the action chain.$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Mouse Events', 'Keyboard Events'], true, 0
),
(
  'How to perform mouse hover using Selenium Actions class?',
  'how-to-perform-mouse-hover-using-selenium-actions',
  'Use Actions.moveToElement() to simulate mouse hover and reveal hidden dropdown menus or tooltips.',
  $body$Mouse hover is performed using `Actions.moveToElement()` to simulate moving the cursor over an element.

**Basic mouse hover:**
```java
import org.openqa.selenium.interactions.Actions;

Actions actions = new Actions(driver);
WebElement menu = driver.findElement(By.id("navMenu"));

actions.moveToElement(menu).perform();
```

**Hover and click a sub-menu item:**
```java
WebElement mainMenu = driver.findElement(By.id("productsMenu"));
WebElement subMenu  = driver.findElement(By.id("electronicsSubmenu"));

Actions actions = new Actions(driver);
actions.moveToElement(mainMenu)
       .moveToElement(subMenu)
       .click()
       .build()
       .perform();
```

**Hover to reveal tooltip text:**
```java
WebElement icon = driver.findElement(By.id("helpIcon"));
actions.moveToElement(icon).perform();

// Wait for tooltip to appear
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement tooltip = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("tooltip")));
System.out.println("Tooltip: " + tooltip.getText());
```

**Common use cases:**
- Navigation mega menus
- Hover-to-reveal buttons
- Tooltips and popovers
- Drag handles that appear on hover$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Mouse Hover', 'Mouse Events'], true, 0
),
(
  'How to perform drag and drop in Selenium?',
  'how-to-perform-drag-and-drop-in-selenium',
  'Use Actions.dragAndDrop(source, target) or clickAndHold + moveToElement + release to simulate drag and drop.',
  $body$**Method 1: `dragAndDrop()` — Simplest**
```java
WebElement source = driver.findElement(By.id("draggable"));
WebElement target = driver.findElement(By.id("droppable"));

Actions actions = new Actions(driver);
actions.dragAndDrop(source, target).perform();
```

**Method 2: `clickAndHold + moveToElement + release`**
```java
Actions actions = new Actions(driver);
actions.clickAndHold(source)
       .moveToElement(target)
       .release()
       .build()
       .perform();
```

**Method 3: Drag by offset (pixels)**
```java
actions.clickAndHold(source)
       .moveByOffset(200, 0)  // Move 200px right
       .release()
       .perform();
```

**If dragAndDrop doesn't work (HTML5 drag):**
Some modern apps use HTML5 drag events which Selenium's Actions may not trigger. Use JavaScript:
```java
String script = "var src=arguments[0], tgt=arguments[1];" +
    "var srcRect=src.getBoundingClientRect(); var tgtRect=tgt.getBoundingClientRect();" +
    "src.dispatchEvent(new MouseEvent('mousedown',{bubbles:true,clientX:srcRect.left+srcRect.width/2,clientY:srcRect.top+srcRect.height/2}));" +
    "tgt.dispatchEvent(new MouseEvent('mouseup',{bubbles:true,clientX:tgtRect.left+tgtRect.width/2,clientY:tgtRect.top+tgtRect.height/2}));";
((JavascriptExecutor) driver).executeScript(script, source, target);
```$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Drag and Drop', 'Mouse Events'], true, 0
),
(
  'How to perform double click in Selenium?',
  'how-to-perform-double-click-in-selenium',
  'Use Actions.doubleClick(element) to simulate a double-click mouse event on a web element.',
  $body$Use **`Actions.doubleClick()`** to simulate a double-click event.

**Basic double click:**
```java
import org.openqa.selenium.interactions.Actions;

WebElement element = driver.findElement(By.id("editableField"));
Actions actions = new Actions(driver);
actions.doubleClick(element).perform();
```

**Double click on coordinates (if element cannot be located):**
```java
actions.moveToElement(element).doubleClick().perform();
```

**Verify double click worked:**
```java
WebElement label = driver.findElement(By.id("editableLabel"));
Actions actions = new Actions(driver);
actions.doubleClick(label).perform();

// Check if the field became an input after double-click
WebElement input = driver.findElement(By.cssSelector("#editableLabel input"));
input.sendKeys("new text");
```

**Common use cases:**
- Double-click to edit inline table cells
- Double-click to open files in a file manager component
- Double-click to select a word in a text editor

> **Note:** `doubleClick(element)` is equivalent to `moveToElement(element).doubleClick()` — both work the same way.$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Double Click', 'Mouse Events'], true, 0
),
(
  'How to perform right click (context click) in Selenium?',
  'how-to-perform-right-click-context-click-in-selenium',
  'Use Actions.contextClick(element) to simulate a right-click mouse event, which triggers context menus.',
  $body$Use **`Actions.contextClick()`** to simulate a right-click / context-click event.

**Basic right click:**
```java
import org.openqa.selenium.interactions.Actions;

WebElement element = driver.findElement(By.id("fileItem"));
Actions actions = new Actions(driver);
actions.contextClick(element).perform();
```

**Right click then select context menu option:**
```java
WebElement element = driver.findElement(By.id("fileIcon"));
Actions actions = new Actions(driver);

// Right click to open context menu
actions.contextClick(element).perform();

// Wait for context menu to appear and click option
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement deleteOption = wait.until(
    ExpectedConditions.elementToBeClickable(By.xpath("//li[text()='Delete']"))
);
deleteOption.click();
```

**Full working example:**
```java
@Test
public void rightClickTest() {
    driver.get("https://demoqa.com/buttons");
    WebElement rightClickBtn = driver.findElement(By.id("rightClickBtn"));

    Actions actions = new Actions(driver);
    actions.contextClick(rightClickBtn).perform();

    String message = driver.findElement(By.id("rightClickMessage")).getText();
    Assert.assertEquals(message, "You have done a right click");
}
```$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Right Click', 'Context Menu', 'Mouse Events'], true, 0
),
(
  'How to handle dropdowns in Selenium WebDriver?',
  'how-to-handle-dropdowns-in-selenium-webdriver',
  'Use the Select class from Selenium support library to interact with HTML <select> dropdown elements.',
  $body$Use the **`Select`** class from `org.openqa.selenium.support.ui.Select` to handle standard HTML `<select>` dropdowns.

**Setup:**
```java
import org.openqa.selenium.support.ui.Select;

WebElement dropdown = driver.findElement(By.id("countrySelect"));
Select select = new Select(dropdown);
```

**3 ways to select an option:**
```java
// 1. By visible text
select.selectByVisibleText("India");

// 2. By value attribute
select.selectByValue("IN");

// 3. By index (0-based)
select.selectByIndex(2);
```

**Get selected value:**
```java
String selected = select.getFirstSelectedOption().getText();
System.out.println("Selected: " + selected);
```

**Get all options:**
```java
List<WebElement> options = select.getOptions();
for (WebElement option : options) {
    System.out.println(option.getText());
}
```

**Multi-select dropdowns:**
```java
if (select.isMultiple()) {
    select.selectByVisibleText("India");
    select.selectByVisibleText("USA");
    // Deselect
    select.deselectAll();
}
```

> **Note:** The `Select` class only works with native `<select>` HTML elements. For custom dropdowns (React/Material UI), use `click()` + `findElement()` on the options directly.$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Dropdowns', 'Select Class', 'Form Elements'], true, 0
),
(
  'How to handle multiple windows or tabs in Selenium WebDriver?',
  'how-to-handle-multiple-windows-tabs-in-selenium-webdriver',
  'Use getWindowHandles() to get all window IDs and switchTo().window() to switch between browser windows or tabs.',
  $body$Selenium handles multiple windows using **window handles** — unique string IDs for each open window/tab.

**Get all window handles:**
```java
String mainWindow = driver.getWindowHandle();
Set<String> allWindows = driver.getWindowHandles();
```

**Switch to a new window:**
```java
// Click something that opens a new window
driver.findElement(By.linkText("Open New Window")).click();

// Get all handles
Set<String> handles = driver.getWindowHandles();

// Iterate and switch to the new window
for (String handle : handles) {
    if (!handle.equals(mainWindow)) {
        driver.switchTo().window(handle);
        break;
    }
}

// Now interacting with new window
System.out.println("New window title: " + driver.getTitle());

// Switch back to main window
driver.switchTo().window(mainWindow);
```

**Helper method:**
```java
public void switchToNewWindow(WebDriver driver, String mainHandle) {
    for (String handle : driver.getWindowHandles()) {
        if (!handle.equals(mainHandle)) {
            driver.switchTo().window(handle);
            return;
        }
    }
}
```

**Close the new window and return:**
```java
driver.close();                          // Close current window
driver.switchTo().window(mainWindow);   // Switch back$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Windows', 'Tabs', 'Window Handles', 'switchTo'], true, 0
),
(
  'How to switch to an iframe in Selenium WebDriver?',
  'how-to-switch-to-iframe-in-selenium-webdriver',
  'Use driver.switchTo().frame() to enter an iframe context before interacting with elements inside it.',
  $body$An **iframe** is an HTML element that embeds another HTML document. Selenium must switch context into the iframe before interacting with elements inside it.

**Switch by index (0-based):**
```java
driver.switchTo().frame(0);  // First iframe on page
```

**Switch by name or id attribute:**
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
    driver.switchTo().defaultContent();  // Always switch back
}
```$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'iFrame', 'Frame', 'switchTo', 'Context Switching'], true, 0
),
(
  'What is JavascriptExecutor in Selenium?',
  'what-is-javascriptexecutor-in-selenium',
  'JavascriptExecutor is a Selenium interface that lets you run JavaScript code directly in the browser during test execution.',
  $body$**JavascriptExecutor** is an interface in Selenium WebDriver that allows executing JavaScript code within the browser context.

**Cast the driver:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
```

**Common use cases:**

**1. Click hidden element:**
```java
WebElement btn = driver.findElement(By.id("hiddenBtn"));
js.executeScript("arguments[0].click();", btn);
```

**2. Scroll to element:**
```java
WebElement el = driver.findElement(By.id("footer"));
js.executeScript("arguments[0].scrollIntoView(true);", el);
```

**3. Scroll to bottom of page:**
```java
js.executeScript("window.scrollTo(0, document.body.scrollHeight);");
```

**4. Set input field value:**
```java
js.executeScript("arguments[0].value='test@email.com';", emailField);
```

**5. Get page title:**
```java
String title = (String) js.executeScript("return document.title;");
```

**6. Highlight element (for debugging):**
```java
js.executeScript("arguments[0].style.border='3px solid red';", element);
```

**When to use JavascriptExecutor:**
- Element is not interactable via normal Selenium methods
- Need to scroll to a specific position
- Setting readonly/disabled field values
- Triggering custom JS events$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'JavascriptExecutor', 'JavaScript', 'WebDriver'], true, 0
),
(
  'How to take a screenshot in Selenium WebDriver?',
  'how-to-take-screenshot-in-selenium-webdriver',
  'Use TakesScreenshot interface with getScreenshotAs() to capture and save browser screenshots during test execution.',
  $body$Use the **`TakesScreenshot`** interface to capture screenshots in Selenium.

**Full screenshot (entire browser viewport):**
```java
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.OutputType;
import org.apache.commons.io.FileUtils;
import java.io.File;

// Take screenshot
File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);

// Save to disk
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

**As byte array (for reporting tools):**
```java
byte[] screenshotBytes = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
// Pass to Extent Reports or Allure
```

**In TestNG @AfterMethod — capture on failure:**
```java
@AfterMethod
public void captureOnFailure(ITestResult result) throws IOException {
    if (result.getStatus() == ITestResult.FAILURE) {
        File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(src, new File("failures/" + result.getName() + ".png"));
    }
}
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Screenshots', 'TakesScreenshot', 'Reporting'], true, 0
),
(
  'How to handle alerts and popups in Selenium WebDriver?',
  'how-to-handle-alerts-popups-in-selenium-webdriver',
  'Use driver.switchTo().alert() to interact with JavaScript alert, confirm, and prompt dialog boxes.',
  $body$JavaScript alerts, confirms, and prompts are native browser dialogs. Use `driver.switchTo().alert()` to handle them.

**Alert types:**
| Type | Description | Has input? |
|------|-------------|------------|
| `alert()` | Info message + OK button | No |
| `confirm()` | Question + OK/Cancel | No |
| `prompt()` | Input request + OK/Cancel | Yes |

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

**Common error:**
`NoAlertPresentException` — alert hasn't appeared yet. Always wait with `ExpectedConditions.alertIsPresent()` before switching.$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Alerts', 'Popups', 'switchTo', 'JavaScript Alert'], true, 0
),
(
  'How to handle dynamic web elements in Selenium?',
  'how-to-handle-dynamic-web-elements-in-selenium',
  'Handle dynamic elements using XPath contains(), starts-with(), explicit waits, and stable relative locators.',
  $body$Dynamic elements change their attributes (id, class, href) on each page load. Here are strategies to handle them:

**1. Use `contains()` in XPath for partial attribute match:**
```java
// Dynamic id like: id="username_12345" or "username_67890"
driver.findElement(By.xpath("//*[contains(@id, 'username')]"));
```

**2. Use `starts-with()` for predictable prefixes:**
```java
driver.findElement(By.xpath("//input[starts-with(@name, 'search')]"));
```

**3. Use stable attributes (data-*, aria-*, name):**
```java
driver.findElement(By.cssSelector("[data-testid='login-btn']"));
driver.findElement(By.cssSelector("[aria-label='Search']"));
```

**4. Use text-based XPath:**
```java
driver.findElement(By.xpath("//button[text()='Submit Order']"));
driver.findElement(By.xpath("//label[contains(text(),'First Name')]/following-sibling::input"));
```

**5. Use Explicit Wait for elements that load dynamically:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
WebElement el = wait.until(ExpectedConditions.visibilityOfElementLocated(
    By.xpath("//div[@class='result-item']")
));
```

**6. Use Relative Locators (Selenium 4):**
```java
WebElement emailField = driver.findElement(
    RelativeLocator.with(By.tagName("input")).below(By.id("userLabel"))
);
```$body$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Dynamic Elements', 'XPath', 'Waits', 'Locators'], true, 0
),
(
  'What is the Page Object Model (POM) design pattern in Selenium?',
  'what-is-page-object-model-pom-in-selenium',
  'Page Object Model is a design pattern that creates separate Java classes for each web page to store locators and actions.',
  $body$**Page Object Model (POM)** is a design pattern where each web page is represented as a separate Java class. The class stores all the page's locators and the methods to interact with them.

**Benefits:**
- Reusable code — one class for all tests using that page
- Easy maintenance — locator change in one place
- Readable tests — test code reads like plain English
- Separation of concerns — test logic vs page interaction

**Page class structure:**
```java
// LoginPage.java
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

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

**Test class:**
```java
@Test
public void testLogin() {
    LoginPage loginPage = new LoginPage(driver);
    loginPage.login("admin", "pass123");
    Assert.assertEquals(driver.getTitle(), "Dashboard");
}
```$body$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'POM', 'Page Object Model', 'Framework', 'Design Pattern'], true, 0
),
(
  'What is PageFactory in Selenium?',
  'what-is-pagefactory-in-selenium',
  'PageFactory is a Selenium support class that uses @FindBy annotations to initialize web elements automatically using lazy initialization.',
  $body$**PageFactory** is an extension of POM that uses `@FindBy` annotations and lazy element initialization, making code cleaner and eliminating repetitive `driver.findElement()` calls.

**Key annotation:**
```java
@FindBy(id = "username")
private WebElement usernameField;
```

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

    @FindBy(xpath = "//span[@class='error-msg']")
    private WebElement errorMessage;

    public LoginPage(WebDriver driver) {
        PageFactory.initElements(driver, this);  // Initialize all @FindBy elements
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
| Stale element | Less prone | Can get stale |
| Lazy loading | Yes | Yes (default) |$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'PageFactory', 'POM', 'FindBy', 'Framework'], true, 0
),
(
  'What is TestNG and why is it used with Selenium?',
  'what-is-testng-and-why-used-with-selenium',
  'TestNG is a Java testing framework used with Selenium to organize tests, manage dependencies, run in parallel, and generate reports.',
  $body$**TestNG** (Test Next Generation) is a Java testing framework inspired by JUnit/NUnit, designed for automation testing. It is the most commonly used testing framework alongside Selenium WebDriver.

**Why TestNG with Selenium:**
- `@Test` annotation to define test methods
- `@BeforeMethod` / `@AfterMethod` for setup/teardown
- Run tests in parallel (reduces execution time)
- Group tests by category (smoke, regression, sanity)
- Data-driven testing with `@DataProvider`
- Prioritize test order with `priority` attribute
- Built-in HTML reports with TestNG report
- XML suite configuration (`testng.xml`)

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
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Framework', 'Annotations', 'Testing'], true, 0
),
(
  'What are the important TestNG annotations in Selenium?',
  'important-testng-annotations-in-selenium',
  'TestNG provides lifecycle annotations like @BeforeSuite, @BeforeTest, @BeforeClass, @BeforeMethod, @Test, and their @After counterparts.',
  $body$TestNG annotations control the execution order of methods. They run from broadest scope (Suite) to narrowest (Method).

**Execution order (top to bottom):**
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
| `@BeforeTest` | Before each `<test>` tag in testng.xml |
| `@AfterTest` | After each `<test>` tag |
| `@BeforeClass` | Once before first method in the class |
| `@AfterClass` | Once after last method in the class |
| `@BeforeMethod` | Before each `@Test` method |
| `@AfterMethod` | After each `@Test` method |
| `@Test` | Marks a test method |
| `@DataProvider` | Supplies data to `@Test` methods |
| `@Parameters` | Passes parameters from testng.xml |

**Example:**
```java
@BeforeClass
public void launchBrowser() {
    driver = new ChromeDriver();
}

@BeforeMethod
public void openURL() {
    driver.get("https://automateqa.online");
}

@Test
public void verifyTitle() {
    Assert.assertEquals(driver.getTitle(), "AutomateQA");
}

@AfterClass
public void closeBrowser() {
    driver.quit();
}
```$body$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Annotations', 'Framework', 'BeforeMethod'], true, 0
),
(
  'What is Selenium Grid and why is it used?',
  'what-is-selenium-grid-and-why-used',
  'Selenium Grid allows running tests in parallel across multiple machines, browsers, and OS combinations simultaneously.',
  $body$**Selenium Grid** is a tool that allows running Selenium tests on **multiple machines** (nodes) simultaneously, controlled by a central **Hub**. It enables parallel execution and cross-browser/cross-OS testing at scale.

**Architecture:**
```
      [Hub / Router]
     /      |       \
[Node 1]  [Node 2]  [Node 3]
Chrome     Firefox    Safari
Windows    Linux      macOS
```

**Why use Selenium Grid:**
- **Parallel execution** — run 10 tests at once → 10x faster
- **Cross-browser testing** — Chrome, Firefox, Edge, Safari simultaneously
- **Cross-OS testing** — Windows, Linux, macOS in one run
- **Scalable** — add more nodes for more capacity

**Selenium 4 Grid — standalone (simple setup):**
```bash
# Download selenium-server-4.x.jar
java -jar selenium-server-4.x.jar standalone
```

**Selenium 4 Grid — hub + node:**
```bash
# Start Hub
java -jar selenium-server.jar hub

# Start Node (on same or different machine)
java -jar selenium-server.jar node --hub http://hub-ip:4444
```

**Connect tests to Grid:**
```java
ChromeOptions options = new ChromeOptions();
RemoteWebDriver driver = new RemoteWebDriver(
    new URL("http://hub-ip:4444"),
    options
);
```

**Cloud alternatives:** Sauce Labs, BrowserStack, LambdaTest — managed Selenium Grid as a service.$body$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Selenium Grid', 'Parallel Testing', 'Cross Browser', 'Hub Node'], true, 0
),
(
  'What is headless browser testing in Selenium?',
  'what-is-headless-browser-testing-in-selenium',
  'Headless browser testing runs Selenium tests without a visible browser UI, making it faster and suitable for CI/CD pipelines.',
  $body$**Headless browser testing** runs browser tests without displaying the browser UI (no graphical window). The browser still renders and executes JavaScript, but everything happens in the background.

**Benefits:**
- Faster execution (no UI rendering overhead)
- Runs in CI/CD environments (no display server needed)
- Consumes less memory
- Supports screenshots and JavaScript execution

**Chrome Headless:**
```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless");
options.addArguments("--no-sandbox");
options.addArguments("--disable-dev-shm-usage");

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

**Set window size (important for headless):**
```java
options.addArguments("--window-size=1920,1080");
// OR
driver.manage().window().setSize(new Dimension(1920, 1080));
```

**Common use cases:**
- Jenkins/GitHub Actions CI pipelines
- Docker containers
- Scheduled overnight regression runs

> **Note:** Chrome headless mode 2 (Chrome 112+) uses `--headless=new` for better compatibility with modern web apps.$body$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Headless', 'CI/CD', 'Chrome Headless', 'Pipeline'], true, 0
),
(
  'What is the difference between driver.close() and driver.quit() in Selenium?',
  'difference-between-driver-close-and-driver-quit-in-selenium',
  'driver.close() closes only the current active window; driver.quit() closes all open windows and ends the WebDriver session.',
  $body$| Method | What it does |
|--------|-------------|
| `driver.close()` | Closes the **current/active** browser window only |
| `driver.quit()` | Closes **all** browser windows and ends the WebDriver session |

**driver.close():**
```java
// Only closes the currently focused window
driver.close();
// If this was the last window, the session ends but WebDriver object remains
```

**driver.quit():**
```java
// Closes all windows (main + all popups/tabs) and kills the driver process
driver.quit();
```

**Example with multiple windows:**
```java
// Main window + popup are open
String mainHandle = driver.getWindowHandle();
driver.switchTo().window(popupHandle);

driver.close();  // Only closes popup
driver.switchTo().window(mainHandle);  // Switch back to main (still open)

// Later at end of test:
driver.quit();  // Closes everything
```

**When to use:**
- Use `driver.close()` in the middle of a test when you want to close a specific window/tab
- Use `driver.quit()` in `@AfterMethod` or teardown — **always prefer quit() to clean up completely**

> **Best practice:** Always call `driver.quit()` in your `@AfterMethod` or `finally` block to avoid browser processes lingering in memory.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'close()', 'quit()', 'Browser Management'], true, 0
),
(
  'What is the difference between findElement() and findElements() in Selenium?',
  'difference-between-findelement-and-findelements-in-selenium',
  'findElement() returns a single WebElement and throws NoSuchElementException if not found; findElements() returns a List that is empty if nothing matches.',
  $body$| Feature | `findElement()` | `findElements()` |
|---------|-----------------|------------------|
| **Returns** | Single `WebElement` | `List<WebElement>` |
| **If not found** | Throws `NoSuchElementException` | Returns empty list `[]` |
| **Multiple matches** | Returns first match only | Returns all matches |
| **Use case** | Unique elements | Lists, tables, repeated items |

**findElement():**
```java
// Returns the FIRST matching element
WebElement btn = driver.findElement(By.cssSelector(".submit-btn"));
btn.click();

// Throws NoSuchElementException if not found
```

**findElements():**
```java
// Returns ALL matching elements as a List
List<WebElement> items = driver.findElements(By.cssSelector(".product-item"));
System.out.println("Count: " + items.size());  // 0 if none found (no exception)

for (WebElement item : items) {
    System.out.println(item.getText());
}
```

**Check element exists without exception:**
```java
// Best way to check if element is present
List<WebElement> elements = driver.findElements(By.id("loginBtn"));
if (!elements.isEmpty()) {
    elements.get(0).click();
}
```

**Get count of elements:**
```java
int rowCount = driver.findElements(By.tagName("tr")).size();
System.out.println("Table rows: " + rowCount);
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'findElement', 'findElements', 'WebDriver Commands'], true, 0
);
