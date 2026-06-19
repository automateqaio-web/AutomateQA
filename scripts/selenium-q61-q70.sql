-- Selenium Q61–Q70 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between driver.findElement() and driver.findElements() commands?',
  'difference-findelement-findelements-commands',
  'findElement() returns the first matching WebElement or throws NoSuchElementException; findElements() returns a List of all matches or an empty list.',
  $$**findElement()** — returns the first matching element:
```java
WebElement textbox = driver.findElement(By.id("textBoxLocator"));
```
Throws `NoSuchElementException` if no element matches.

**findElements()** — returns all matching elements as a List:
```java
List<WebElement> elements = driver.findElements(By.id("value"));
```
Returns an empty `List` (size 0) if no elements match — never throws.

**Full comparison:**
| Feature | `findElement()` | `findElements()` |
|---------|-----------------|-----------------|
| Return type | `WebElement` | `List<WebElement>` |
| If not found | Throws `NoSuchElementException` | Returns empty list |
| Multiple matches | Returns FIRST match | Returns ALL matches |
| Use case | Unique elements | Tables, lists, repeated items |

**Use findElements() to safely check if element exists:**
```java
List<WebElement> list = driver.findElements(By.id("loginBtn"));
if (!list.isEmpty()) {
    list.get(0).click();
}
```

**Count elements on page:**
```java
int count = driver.findElements(By.cssSelector(".product-card")).size();
System.out.println("Products found: " + count);
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'findElement', 'findElements', 'WebElement', 'WebDriver Commands'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Explain the difference between implicit wait and explicit wait in Selenium.',
  'difference-between-implicit-wait-and-explicit-wait-selenium',
  'Implicit wait applies globally to all element lookups; explicit wait targets a specific element with a specific condition.',
  $$**Implicit Wait** — global wait applied to ALL `findElement()` calls:
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(180));
```
- Set once, applies throughout the entire WebDriver session
- Waits up to the specified time before throwing `NoSuchElementException`
- Cannot wait for specific conditions (visibility, clickability, etc.)

**Explicit Wait** — applied to a SPECIFIC element with a SPECIFIC condition:
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
wait.until(ExpectedConditions.presenceOfElementLocated(ElementLocator));
```
- Created per use — does NOT apply globally
- Supports rich conditions: `visibilityOf`, `elementToBeClickable`, `alertIsPresent`, etc.
- Exits as soon as the condition is met (no unnecessary waiting)

**Key comparison:**
| | Implicit Wait | Explicit Wait |
|--|--|--|
| Scope | Global (all elements) | Specific element only |
| Condition support | Presence only | Any ExpectedCondition |
| Set up | Once per session | Per usage |
| Best for | Simple scripts | Production frameworks |

> **Best Practice:** Never mix implicit and explicit waits — it causes unpredictable timing behavior. Choose one strategy per project and stick to it. Explicit wait is preferred for production frameworks.$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Waits', 'Implicit Wait', 'Explicit Wait', 'WebDriverWait'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we handle window UI elements and window popups using Selenium?',
  'how-to-handle-window-ui-elements-and-popups-using-selenium',
  'Selenium handles only web browser content. For native Windows GUI elements and system popups, use AutoIT or Sikuli.',
  $$**Selenium WebDriver** is designed exclusively for automating **web browsers**. It cannot interact with native Windows GUI elements or OS-level dialogs.

**What Selenium CAN handle:**
- HTML-based browser alerts (using `driver.switchTo().alert()`)
- Browser popup windows and new tabs (using window handles)
- iframe-based modals

```java
// Browser alert
driver.switchTo().alert().accept();

// New popup window
Set<String> handles = driver.getWindowHandles();
for (String handle : handles) {
    driver.switchTo().window(handle);
}
```

**What Selenium CANNOT handle:**
- Windows file upload/download dialogs (OS-level)
- Desktop application windows
- Captcha dialogs
- Certificate security popups

**Tools for native Windows UI:**

**AutoIT** — Windows-only scripting tool for native GUI automation:
```
; AutoIT script to handle file upload dialog
WinWaitActive("Open")
ControlSetText("Open", "", "Edit1", "C:\path\to\file.txt")
ControlClick("Open", "", "Button1")
```
Compile to `.exe` and call from Selenium:
```java
Runtime.getRuntime().exec("path/to/upload.exe");
```

**Sikuli** — image-based automation that works on any OS:
```java
Screen screen = new Screen();
screen.click("path/to/button_image.png");
```$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'AutoIT', 'Sikuli', 'Windows Popups', 'Native GUI'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Robot API in Selenium?',
  'what-is-robot-api-in-selenium',
  'Robot API is a Java class used to simulate keyboard and mouse events at the OS level, often used for file uploads in Selenium.',
  $$**Robot API** (`java.awt.Robot`) is a Java built-in class that can simulate keyboard and mouse events at the operating system level — outside the browser. It is commonly used in Selenium for handling native OS dialogs like file upload windows.

**Import and create Robot:**
```java
import java.awt.Robot;
import java.awt.event.KeyEvent;

Robot robot = new Robot();
```

**Simulate keyboard events:**
```java
// Press Enter key
robot.keyPress(KeyEvent.VK_ENTER);
robot.keyRelease(KeyEvent.VK_ENTER);

// Type a file path (for upload dialog)
robot.keyPress(KeyEvent.VK_C);  // Press C
robot.keyRelease(KeyEvent.VK_C);
```

**Copy file path to clipboard and paste in dialog:**
```java
// Copy path to clipboard using Java Toolkit
StringSelection selection = new StringSelection("C:\\files\\upload.pdf");
Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, null);

// Paste using Robot
Robot robot = new Robot();
robot.keyPress(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_ENTER);
robot.keyRelease(KeyEvent.VK_ENTER);
```

**Limitations:**
- Works only on the local machine (not Selenium Grid or remote machines)
- OS and resolution dependent
- Prefer `sendKeys("file path")` directly on `<input type="file">` when possible$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Robot API', 'File Upload', 'Keyboard Events', 'OS Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to do file upload in Selenium?',
  'how-to-do-file-upload-in-selenium',
  'For native HTML file inputs, use sendKeys() with the file path. For system dialogs use Robot API, AutoIT, or Sikuli.',
  $$**Method 1: sendKeys() — Best approach for HTML file inputs**
Works when the upload button is a native `<input type="file">` element:
```java
WebElement uploadInput = driver.findElement(By.id("fileUpload"));
uploadInput.sendKeys("C:\\Users\\nagen\\Desktop\\document.pdf");
```
No need to click the button — just send the file path directly.

**Method 2: Robot API — for OS-level file dialog**
```java
// Click the upload button to open OS dialog
driver.findElement(By.id("uploadBtn")).click();

// Copy path to clipboard
StringSelection path = new StringSelection("C:\\files\\test.pdf");
Toolkit.getDefaultToolkit().getSystemClipboard().setContents(path, null);

// Paste and confirm
Robot robot = new Robot();
robot.keyPress(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_ENTER);
robot.keyRelease(KeyEvent.VK_ENTER);
```

**Method 3: AutoIT**
Compile an AutoIT script to `.exe` and run it from Selenium:
```java
Runtime.getRuntime().exec("C:\\scripts\\fileUpload.exe");
```

**Method 4: Sikuli**
Use image-based recognition to click the upload button and type the path:
```java
Screen screen = new Screen();
screen.click("upload_dialog.png");
screen.type("C:\\files\\test.pdf");
```

**Recommended priority:**
1. `sendKeys()` on `<input type="file">` — simplest and most reliable
2. Robot API — when sendKeys does not work
3. AutoIT / Sikuli — for complex OS dialogs$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'File Upload', 'sendKeys', 'Robot API', 'AutoIT'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle HTTPS website in Selenium? or How to accept the SSL untrusted connection?',
  'how-to-handle-https-ssl-untrusted-connection-in-selenium',
  'Accept SSL certificates in Selenium using browser Options or DesiredCapabilities with ACCEPT_SSL_CERTS capability.',
  $$When a site has an untrusted or self-signed SSL certificate, browsers show a security warning. Configure the browser to accept these automatically.

**Chrome (Selenium 4 — recommended):**
```java
ChromeOptions options = new ChromeOptions();
options.setAcceptInsecureCerts(true);
WebDriver driver = new ChromeDriver(options);
```

**Firefox (Selenium 4 — recommended):**
```java
FirefoxOptions options = new FirefoxOptions();
options.setAcceptInsecureCerts(true);
WebDriver driver = new FirefoxDriver(options);
```

**Firefox using FirefoxProfile (older approach):**
```java
FirefoxProfile profile = new FirefoxProfile();
profile.setAcceptUntrustedCertificates(true);
profile.setAssumeUntrustedCertificateIssuer(false);
WebDriver driver = new FirefoxDriver(profile);
```

**IE using DesiredCapabilities (legacy):**
```java
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability(CapabilityType.ACCEPT_SSL_CERTS, true);
System.setProperty("webdriver.ie.driver", "IEDriverServer.exe");
WebDriver driver = new InternetExplorerDriver(capabilities);
```

**Chrome using DesiredCapabilities (legacy):**
```java
DesiredCapabilities handlSSLErr = DesiredCapabilities.chrome();
handlSSLErr.setCapability(CapabilityType.ACCEPT_SSL_CERTS, true);
WebDriver driver = new ChromeDriver(handlSSLErr);
```

> **Best Practice:** Always use browser-specific Options classes (`ChromeOptions`, `FirefoxOptions`) in Selenium 4+ instead of the deprecated `DesiredCapabilities`.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'HTTPS', 'SSL', 'DesiredCapabilities', 'Browser Configuration'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to do drag and drop in Selenium?',
  'how-to-do-drag-and-drop-in-selenium-actions',
  'Use Actions class with dragAndDrop() or clickAndHold + moveToElement + release to perform drag and drop in Selenium.',
  $$Use the **Actions** class to perform drag and drop operations.

**Method 1: dragAndDrop() — simplest:**
```java
Actions act = new Actions(driver);
act.dragAndDrop(sourceElement, targetElement).build().perform();
```

**Method 2: clickAndHold + moveToElement + release:**
```java
Actions act = new Actions(driver);
act.clickAndHold(sourceElement)
   .moveToElement(targetElement)
   .release()
   .build()
   .perform();
```

**Method 3: Move by offset (pixel-based):**
```java
Actions act = new Actions(driver);
act.clickAndHold(sourceElement)
   .moveByOffset(200, 0)
   .release()
   .perform();
```

**Full test example:**
```java
@Test
public void dragAndDropTest() {
    driver.get("https://jqueryui.com/droppable/");
    driver.switchTo().frame(driver.findElement(By.className("demo-frame")));

    WebElement source = driver.findElement(By.id("draggable"));
    WebElement target = driver.findElement(By.id("droppable"));

    new Actions(driver).dragAndDrop(source, target).perform();

    String result = driver.findElement(By.id("droppable")).getText();
    Assert.assertEquals(result, "Dropped!");
}
```

> **Note:** If `dragAndDrop()` does not work, try Method 2. Some HTML5 drag implementations require a JavaScript-based approach.$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Actions Class', 'Drag and Drop', 'Mouse Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to execute JavaScript in Selenium?',
  'how-to-execute-javascript-in-selenium',
  'Use JavascriptExecutor interface by casting the WebDriver instance and calling executeScript() to run JavaScript in the browser.',
  $$JavaScript can be executed in Selenium using the **JavascriptExecutor** interface.

**Cast the driver:**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("{Java script code}");
```

**Common use cases with examples:**

**Scroll to bottom:**
```java
js.executeScript("window.scrollTo(0, document.body.scrollHeight);");
```

**Click a hidden or overlapping element:**
```java
WebElement btn = driver.findElement(By.id("hiddenBtn"));
js.executeScript("arguments[0].click();", btn);
```

**Set value on readonly input:**
```java
WebElement field = driver.findElement(By.id("datePicker"));
js.executeScript("arguments[0].value=''2025-12-31'';", field);
```

**Scroll element into view:**
```java
js.executeScript("arguments[0].scrollIntoView(true);", element);
```

**Return a value:**
```java
String title = (String) js.executeScript("return document.title;");
Long count = (Long) js.executeScript("return document.querySelectorAll(''.item'').length;");
```

**Highlight element (debugging):**
```java
js.executeScript("arguments[0].style.background=''yellow'';", element);
```

**When to use JavascriptExecutor:**
- Element not interactable with standard Selenium commands
- Need to bypass browser focus/scroll restrictions
- Setting values on read-only or disabled inputs
- Checking page state via DOM properties$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'JavascriptExecutor', 'JavaScript', 'executeScript'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle alerts in Selenium?',
  'how-to-handle-alerts-in-selenium',
  'Switch to an alert using driver.switchTo().alert() then use accept() to click OK or dismiss() to click Cancel.',
  $$To handle JavaScript alerts (alert, confirm, prompt), first switch to the alert and then use `accept()` or `dismiss()`.

**Accept (click OK):**
```java
Alert alert = driver.switchTo().alert();
alert.accept();
```

**Dismiss (click Cancel):**
```java
Alert alert = driver.switchTo().alert();
alert.dismiss();
```

**Get alert text:**
```java
Alert alert = driver.switchTo().alert();
String alertText = alert.getText();
System.out.println("Alert message: " + alertText);
alert.accept();
```

**Type into prompt alert:**
```java
Alert prompt = driver.switchTo().alert();
prompt.sendKeys("My answer");
prompt.accept();
```

**Wait for alert before switching:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.alertIsPresent());

Alert alert = driver.switchTo().alert();
System.out.println(alert.getText());
alert.accept();
```

**Alert types:**
| Type | Description | Method |
|------|-------------|--------|
| `alert` | Simple message + OK | `accept()` |
| `confirm` | Question + OK + Cancel | `accept()` or `dismiss()` |
| `prompt` | Input + OK + Cancel | `sendKeys()` then `accept()` |

> **Common error:** `NoAlertPresentException` — the alert has not appeared yet. Always use `ExpectedConditions.alertIsPresent()` before `switchTo().alert()`.$$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Alerts', 'switchTo', 'JavaScript Alert', 'Popups'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is HtmlUnitDriver in Selenium?',
  'what-is-htmlunitdriver-in-selenium',
  'HtmlUnitDriver is the fastest Selenium WebDriver implementation — a headless, non-GUI driver that simulates a browser without opening one.',
  $$**HtmlUnitDriver** is the fastest WebDriver implementation in Selenium. Unlike `ChromeDriver`, `FirefoxDriver`, etc., it is a **non-GUI (headless) driver** — no actual browser window is launched.

**Key characteristics:**
- Pure Java implementation — no browser binary needed
- Fastest execution speed of all WebDrivers
- Non-GUI (headless) — runs entirely in memory
- Limited JavaScript support compared to real browsers
- Best for testing simple HTML pages or fast regression runs

**Basic usage:**
```java
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

WebDriver driver = new HtmlUnitDriver();
driver.get("https://automateqa.online");
System.out.println(driver.getTitle());
driver.quit();
```

**Enable JavaScript:**
```java
HtmlUnitDriver driver = new HtmlUnitDriver(true); // true = enable JS
```

**When to use HtmlUnitDriver:**
- Fast smoke tests with no JS-heavy pages
- CI/CD pipelines where speed is critical and browser installation is not available
- Lightweight unit-level web testing

**When NOT to use:**
- Pages with heavy JavaScript, React, Angular, or Vue — use Chrome headless instead
- Cross-browser compatibility testing

> **Recommendation:** For modern web apps, prefer **Chrome headless** (`ChromeOptions --headless`) over HtmlUnitDriver for better JS compatibility.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'HtmlUnitDriver', 'Headless', 'WebDriver', 'CI/CD'], true, 0
);
