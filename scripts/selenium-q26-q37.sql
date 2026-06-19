-- Selenium Q26–Q37 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we click on an element using Selenium WebDriver?',
  'how-to-click-element-using-selenium-webdriver',
  'Use the click() method on a located WebElement to perform a mouse click action in Selenium.',
  $$Use the **`click()`** method on a `WebElement` to simulate a mouse click.

**Basic click:**
```java
driver.findElement(By.id("loginBtn")).click();
driver.findElement(By.cssSelector(".btn-submit")).click();
driver.findElement(By.xpath("//button[text()=''Login'']")).click();
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
| `TimeoutException` | Element not found in time | Increase wait timeout |$$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'click()', 'Interactions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are different types of waits available in Selenium WebDriver?',
  'different-types-of-waits-in-selenium-webdriver',
  'Selenium provides three types of waits: Implicit Wait, Explicit Wait, and Fluent Wait.',
  $$Selenium WebDriver provides **3 types of waits** to handle synchronization between test code and the browser:

**1. Implicit Wait**
Tells WebDriver to wait for a specified time before throwing `NoSuchElementException`.
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```
Applied globally to all `findElement()` calls.

**2. Explicit Wait (WebDriverWait)**
Waits for a specific condition before proceeding.
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("result")));
```
Applied to specific elements. Most commonly used in frameworks.

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
| Best use | Prototyping | Production tests | AJAX/dynamic apps |

> **Avoid `Thread.sleep()`** — hard pause that wastes time even when element is ready.$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'Synchronization', 'WebDriverWait'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to implement Explicit Wait (WebDriverWait) in Selenium?',
  'how-to-implement-explicit-wait-webdriverwait-in-selenium',
  'Explicit Wait uses WebDriverWait with ExpectedConditions to pause execution until a specific condition is met.',
  $$**Explicit Wait** pauses the test until a specific condition is true, with a timeout.

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

// Wait for URL to contain a value
wait.until(ExpectedConditions.urlContains("/dashboard"));

// Custom wait with lambda
wait.until(d -> d.findElement(By.id("count")).getText().equals("10"));
```

> **Best practice:** Always prefer `elementToBeClickable` before calling `.click()`.$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'WebDriverWait', 'ExpectedConditions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Implicit Wait in Selenium?',
  'what-is-implicit-wait-in-selenium',
  'Implicit Wait sets a global timeout for WebDriver to poll for an element before throwing NoSuchElementException.',
  $$**Implicit Wait** sets a default timeout for the WebDriver to poll the DOM repeatedly until an element is found, before throwing `NoSuchElementException`.

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
- Polls at approximately 500ms intervals
- Applies only to `findElement()` and `findElements()`
- Does NOT work with `ExpectedConditions`

**Example:**
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
driver.get("https://automateqa.online");
WebElement el = driver.findElement(By.id("result")); // Waits if not immediately available
```

> **Warning:** Mixing implicit and explicit waits can cause unpredictable wait times. Choose one strategy per project.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Waits', 'Implicit Wait', 'Synchronization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to implement Fluent Wait in Selenium?',
  'how-to-implement-fluent-wait-in-selenium',
  'Fluent Wait provides configurable polling intervals and exception ignoring for waiting on dynamic elements.',
  $$**Fluent Wait** is an advanced form of Explicit Wait with a customizable polling interval and the ability to ignore specific exceptions during polling.

**Full implementation:**
```java
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import java.time.Duration;

Wait<WebDriver> fluentWait = new FluentWait<>(driver)
    .withTimeout(Duration.ofSeconds(30))
    .pollingEvery(Duration.ofSeconds(2))
    .ignoring(NoSuchElementException.class);

WebElement element = fluentWait.until(
    driver -> driver.findElement(By.id("dynamicResult"))
);
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

**Fluent vs Explicit:**
| | Explicit Wait | Fluent Wait |
|--|--|--|
| Polling interval | Fixed (~500ms) | Customizable |
| Ignore exceptions | No | Yes |
| Use case | Most scenarios | AJAX, heavy dynamic pages |$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'Fluent Wait', 'Synchronization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the Actions class in Selenium WebDriver?',
  'what-is-actions-class-in-selenium-webdriver',
  'Actions class in Selenium provides methods to perform complex keyboard and mouse interactions like hover, drag-drop, and right-click.',
  $$The **Actions** class (`org.openqa.selenium.interactions.Actions`) provides an API to perform complex user interaction sequences — mouse movements, keyboard events, drag-and-drop, etc.

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

**Key pattern — always end with build().perform():**
```java
actions.moveToElement(menuItem)
       .click(subMenuItem)
       .build()
       .perform();
```$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Mouse Events', 'Keyboard Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to perform mouse hover using Selenium Actions class?',
  'how-to-perform-mouse-hover-using-selenium-actions',
  'Use Actions.moveToElement() to simulate mouse hover and reveal hidden dropdown menus or tooltips.',
  $$Mouse hover is performed using `Actions.moveToElement()` to simulate moving the cursor over an element.

**Basic mouse hover:**
```java
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

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement tooltip = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.className("tooltip"))
);
System.out.println("Tooltip: " + tooltip.getText());
```

**Common use cases:**
- Navigation mega menus
- Hover-to-reveal buttons
- Tooltips and popovers
- Drag handles that appear on hover$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Mouse Hover', 'Mouse Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to perform drag and drop in Selenium?',
  'how-to-perform-drag-and-drop-in-selenium',
  'Use Actions.dragAndDrop(source, target) or clickAndHold + moveToElement + release to simulate drag and drop.',
  $$**Method 1: dragAndDrop() — Simplest**
```java
WebElement source = driver.findElement(By.id("draggable"));
WebElement target = driver.findElement(By.id("droppable"));

Actions actions = new Actions(driver);
actions.dragAndDrop(source, target).perform();
```

**Method 2: clickAndHold + moveToElement + release**
```java
Actions actions = new Actions(driver);
actions.clickAndHold(source)
       .moveToElement(target)
       .release()
       .build()
       .perform();
```

**Method 3: Drag by pixel offset**
```java
actions.clickAndHold(source)
       .moveByOffset(200, 0)
       .release()
       .perform();
```

**If dragAndDrop does not work (HTML5 drag events):**
Some modern apps use HTML5 drag events that Selenium Actions may not trigger. Use JavaScript in that case:
```java
String script = "var dt = new DataTransfer(); " +
    "arguments[0].dispatchEvent(new DragEvent(''dragstart'',{dataTransfer:dt,bubbles:true})); " +
    "arguments[1].dispatchEvent(new DragEvent(''drop'',{dataTransfer:dt,bubbles:true}));";
((JavascriptExecutor) driver).executeScript(script, source, target);
```$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Drag and Drop', 'Mouse Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to perform double click in Selenium?',
  'how-to-perform-double-click-in-selenium',
  'Use Actions.doubleClick(element) to simulate a double-click mouse event on a web element.',
  $$Use **`Actions.doubleClick()`** to simulate a double-click event.

**Basic double click:**
```java
WebElement element = driver.findElement(By.id("editableField"));
Actions actions = new Actions(driver);
actions.doubleClick(element).perform();
```

**Double click then verify:**
```java
WebElement label = driver.findElement(By.id("editableLabel"));
Actions actions = new Actions(driver);
actions.doubleClick(label).perform();

WebElement input = driver.findElement(By.cssSelector("#editableLabel input"));
input.sendKeys("new text");
```

**Common use cases:**
- Double-click to edit inline table cells
- Double-click to open files in a file manager component
- Double-click to select a word in a text editor

> **Note:** `doubleClick(element)` is equivalent to `moveToElement(element).doubleClick()` — both achieve the same result.$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Double Click', 'Mouse Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to perform right click (context click) in Selenium?',
  'how-to-perform-right-click-context-click-in-selenium',
  'Use Actions.contextClick(element) to simulate a right-click mouse event, which triggers context menus.',
  $$Use **`Actions.contextClick()`** to simulate a right-click event.

**Basic right click:**
```java
WebElement element = driver.findElement(By.id("fileItem"));
Actions actions = new Actions(driver);
actions.contextClick(element).perform();
```

**Right click then select a context menu option:**
```java
WebElement element = driver.findElement(By.id("fileIcon"));
Actions actions = new Actions(driver);
actions.contextClick(element).perform();

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement deleteOption = wait.until(
    ExpectedConditions.elementToBeClickable(By.xpath("//li[text()=''Delete'']"))
);
deleteOption.click();
```

**Full working test example:**
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
```$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Right Click', 'Context Menu', 'Mouse Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle dropdowns in Selenium WebDriver?',
  'how-to-handle-dropdowns-in-selenium-webdriver',
  'Use the Select class from Selenium support library to interact with HTML select dropdown elements.',
  $$Use the **`Select`** class from `org.openqa.selenium.support.ui.Select` to handle standard HTML `<select>` dropdowns.

**Setup:**
```java
import org.openqa.selenium.support.ui.Select;

WebElement dropdown = driver.findElement(By.id("countrySelect"));
Select select = new Select(dropdown);
```

**3 ways to select an option:**
```java
select.selectByVisibleText("India");
select.selectByValue("IN");
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
    select.deselectAll();
}
```

> **Note:** The `Select` class only works with native `<select>` HTML elements. For custom dropdowns (React/Material UI), use `click()` on the dropdown trigger then `findElement()` on the options.$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Dropdowns', 'Select Class', 'Form Elements'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle multiple windows or tabs in Selenium WebDriver?',
  'how-to-handle-multiple-windows-tabs-in-selenium-webdriver',
  'Use getWindowHandles() to get all window IDs and switchTo().window() to switch between browser windows or tabs.',
  $$Selenium handles multiple windows using **window handles** — unique string IDs for each open window/tab.

**Get all window handles:**
```java
String mainWindow = driver.getWindowHandle();
Set<String> allWindows = driver.getWindowHandles();
```

**Switch to a new window:**
```java
driver.findElement(By.linkText("Open New Window")).click();

String mainHandle = driver.getWindowHandle();
for (String handle : driver.getWindowHandles()) {
    if (!handle.equals(mainHandle)) {
        driver.switchTo().window(handle);
        break;
    }
}

System.out.println("New window title: " + driver.getTitle());
driver.switchTo().window(mainHandle);
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

**Close new window and return:**
```java
driver.close();
driver.switchTo().window(mainHandle);
```$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Windows', 'Tabs', 'Window Handles', 'switchTo'], true, 0
);
