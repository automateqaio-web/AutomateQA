-- Selenium Q51–Q60 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to verify tooltip text using Selenium?',
  'how-to-verify-tooltip-text-using-selenium',
  'Tooltip text is stored in the title attribute of a web element and can be verified using getAttribute("title").',
  $$WebElements expose tooltip text via the **`title`** HTML attribute. Use `getAttribute("title")` to read and verify it.

**Basic tooltip verification:**
```java
WebElement element = driver.findElement(By.id("helpIcon"));
String toolTipText = element.getAttribute("title");
System.out.println("Tooltip: " + toolTipText);
Assert.assertEquals(toolTipText, "Click here for help");
```

**Full test example:**
```java
@Test
public void verifyTooltip() {
    driver.get("https://automateqa.online");
    WebElement infoIcon = driver.findElement(By.cssSelector(".info-icon"));
    String tooltip = infoIcon.getAttribute("title");
    Assert.assertFalse(tooltip.isEmpty(), "Tooltip should not be empty");
    Assert.assertEquals(tooltip, "Expected Tooltip Text");
}
```

**For CSS tooltips (shown via ::after pseudo-element or JS):**
Some modern tooltips are rendered via JavaScript or CSS pseudo-elements — not in the `title` attribute. In that case, hover over the element and then read the tooltip element''s text:
```java
Actions actions = new Actions(driver);
actions.moveToElement(element).perform();

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
WebElement tooltip = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.className("tooltip-text"))
);
Assert.assertEquals(tooltip.getText(), "Expected Tooltip");
```

**Key summary:**
- `getAttribute("title")` → for native HTML title tooltips
- Hover + read element text → for JS/CSS-rendered tooltips$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Tooltip', 'getAttribute', 'WebElement'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to locate a link using its text in Selenium?',
  'how-to-locate-link-using-text-in-selenium',
  'Use By.linkText() for exact anchor text match and By.partialLinkText() for partial text match to locate hyperlinks.',
  $$Selenium provides two dedicated locators for anchor (`<a>`) elements:

**1. By.linkText() — Exact match**
Matches the complete visible text of the link.
```java
WebElement link = driver.findElement(By.linkText("pavantestingtools"));
link.click();
```

**2. By.partialLinkText() — Partial match**
Matches a substring of the link''s visible text.
```java
WebElement link = driver.findElement(By.partialLinkText("testingtools"));
link.click();
```

**Comparison:**
| Locator | Matches | Example |
|---------|---------|---------|
| `linkText` | Exact full text | `"Click Here to Register"` |
| `partialLinkText` | Any substring | `"Register"` |

**When to use which:**
- Use `linkText` when the link text is unique and never changes
- Use `partialLinkText` when the link text is long or partially dynamic (e.g., "Download Report 2025-06")

**With Explicit Wait (recommended):**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement link = wait.until(
    ExpectedConditions.elementToBeClickable(By.partialLinkText("Register"))
);
link.click();
```

> **Note:** Both locators are case-sensitive and match only visible text, not the href attribute.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Locators', 'linkText', 'partialLinkText', 'Anchor'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are DesiredCapabilities in Selenium WebDriver?',
  'what-are-desiredcapabilities-in-selenium-webdriver',
  'DesiredCapabilities is a key-value store used to configure browser-specific properties like browser name, version, platform, and SSL handling.',
  $$**DesiredCapabilities** is a class in Selenium that stores browser-specific configuration as key-value pairs. It is used to set browser properties such as browser name, version, platform, and SSL certificate handling before launching the driver.

**Common use cases:**
- Accept SSL certificates
- Set browser version and platform for Selenium Grid
- Enable/disable specific browser features
- Configure remote WebDriver sessions

**Chrome example — accept SSL certs:**
```java
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability(CapabilityType.ACCEPT_SSL_CERTS, true);
WebDriver driver = new ChromeDriver(capabilities);
```

**Firefox example:**
```java
DesiredCapabilities capabilities = DesiredCapabilities.firefox();
capabilities.setBrowserName("firefox");
capabilities.setPlatform(Platform.WINDOWS);
```

**With Selenium Grid:**
```java
DesiredCapabilities caps = new DesiredCapabilities();
caps.setBrowserName("chrome");
caps.setPlatform(Platform.LINUX);
RemoteWebDriver driver = new RemoteWebDriver(new URL("http://hub:4444/wd/hub"), caps);
```

> **Note:** In Selenium 4, `DesiredCapabilities` is largely replaced by browser-specific Options classes (`ChromeOptions`, `FirefoxOptions`). For new projects, prefer Options over DesiredCapabilities.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'DesiredCapabilities', 'Browser Configuration', 'Selenium Grid'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we find all the links on a web page using Selenium?',
  'how-to-find-all-links-on-web-page-using-selenium',
  'All hyperlinks use the anchor tag <a>. Use findElements(By.tagName("a")) to get all links on a page.',
  $$All hyperlinks on a web page use the HTML anchor tag `<a>`. Use `findElements(By.tagName("a"))` to retrieve all links at once.

**Get all links:**
```java
List<WebElement> links = driver.findElements(By.tagName("a"));
System.out.println("Total links: " + links.size());
```

**Print all link texts and URLs:**
```java
List<WebElement> links = driver.findElements(By.tagName("a"));
for (WebElement link : links) {
    System.out.println("Text: " + link.getText());
    System.out.println("URL:  " + link.getAttribute("href"));
    System.out.println("---");
}
```

**Check for broken links (HTTP status):**
```java
List<WebElement> links = driver.findElements(By.tagName("a"));
for (WebElement link : links) {
    String url = link.getAttribute("href");
    if (url != null && !url.isEmpty()) {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("HEAD");
        conn.connect();
        int responseCode = conn.getResponseCode();
        if (responseCode >= 400) {
            System.out.println("Broken link: " + url + " | Code: " + responseCode);
        }
    }
}
```

**Filter only visible links:**
```java
links.stream()
     .filter(WebElement::isDisplayed)
     .forEach(l -> System.out.println(l.getText()));
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Links', 'findElements', 'tagName', 'Broken Links'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are some commonly encountered exceptions in Selenium?',
  'commonly-encountered-exceptions-in-selenium',
  'Common Selenium exceptions include NoSuchElementException, StaleElementReferenceException, TimeoutException, and ElementNotInteractableException.',
  $$Selenium WebDriver throws specific exceptions depending on what goes wrong during automation. Here are the most common ones:

**1. NoSuchElementException**
Element could not be found using the locator provided.
```java
// Fix: check locator, add wait, or verify element exists
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.presenceOfElementLocated(By.id("username")));
```

**2. ElementNotVisibleException / ElementNotInteractableException**
Element is present in DOM but not visible or not interactable.
Fix: scroll to element or use JavascriptExecutor click.

**3. NoAlertPresentException**
Trying to switch to an alert that has not appeared yet.
Fix: use `ExpectedConditions.alertIsPresent()` before switching.

**4. NoSuchFrameException**
Trying to switch to a frame that does not exist.
Fix: verify frame name/id and wait for it to be available.

**5. NoSuchWindowException**
Trying to switch to a window that is not present.
Fix: verify window handle and use `getWindowHandles()`.

**6. TimeoutException**
A wait condition was not met within the timeout period.
Fix: increase timeout or check if element actually appears.

**7. InvalidElementStateException**
Element state is not appropriate for the desired action (e.g., typing in a disabled field).

**8. NoSuchAttributeException**
Trying to get an attribute that does not exist on the element.

**9. StaleElementReferenceException**
Element was found but the DOM was refreshed/updated, making the reference stale.
```java
// Fix: re-find the element after DOM update
WebElement el = driver.findElement(By.id("btn"));
driver.navigate().refresh();
el = driver.findElement(By.id("btn")); // re-locate
el.click();
```

**10. WebDriverException**
General exception when there is an issue with the driver instance itself.$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Exceptions', 'NoSuchElementException', 'StaleElement', 'Error Handling'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we capture screenshots in Selenium?',
  'how-to-capture-screenshots-in-selenium',
  'Use the TakesScreenshot interface with getScreenshotAs(OutputType.FILE) to capture and save screenshots in Selenium.',
  $$Use the **`TakesScreenshot`** interface to capture screenshots. It is built into Selenium WebDriver.

**Basic screenshot:**
```java
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.OutputType;
import org.apache.commons.io.FileUtils;

File scrFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(scrFile, new File("D:\\testScreenShot.jpg"));
```

**Save with dynamic name:**
```java
String timestamp = new SimpleDateFormat("dd-MM-yyyy_HH-mm-ss").format(new Date());
File dest = new File("screenshots/screenshot_" + timestamp + ".png");
FileUtils.copyFile(((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE), dest);
```

**Screenshot of a specific element (Selenium 4+):**
```java
WebElement element = driver.findElement(By.id("loginForm"));
File elementScreenshot = element.getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(elementScreenshot, new File("screenshots/form.png"));
```

**As bytes (for Extent Reports / Allure):**
```java
byte[] screenshotBytes = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
```

**Auto-capture on test failure with TestNG:**
```java
@AfterMethod
public void onFailure(ITestResult result) throws IOException {
    if (result.getStatus() == ITestResult.FAILURE) {
        File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(src, new File("failures/" + result.getName() + ".png"));
    }
}
```$$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Screenshots', 'TakesScreenshot', 'Reporting'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle dropdowns in Selenium?',
  'how-to-handle-dropdowns-in-selenium',
  'Use the Select class from Selenium to interact with HTML <select> dropdowns by visible text, value, or index.',
  $$Use the **`Select`** class from `org.openqa.selenium.support.ui` to handle native HTML `<select>` dropdowns.

**Setup:**
```java
import org.openqa.selenium.support.ui.Select;

Select dropdown = new Select(driver.findElement(By.id("countries")));
```

**Select by visible text:**
```java
dropdown.selectByVisibleText("India");
```

**Select by index (starts from 0):**
```java
dropdown.selectByIndex(1);
```

**Select by value attribute:**
```java
dropdown.selectByValue("Ind");
```

**Get all options:**
```java
List<WebElement> options = dropdown.getOptions();
for (WebElement opt : options) {
    System.out.println(opt.getText());
}
```

**Multi-select dropdown:**
```java
if (dropdown.isMultiple()) {
    dropdown.selectByVisibleText("India");
    dropdown.selectByVisibleText("USA");
    dropdown.deselectAll();
}
```

> **Important:** `Select` class works ONLY with native HTML `<select>` elements. For custom dropdowns built with React, Angular, or Material UI — click the dropdown trigger and then click the option directly using `findElement()`.$$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Dropdowns', 'Select Class', 'Form Elements'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to check which option in the dropdown is selected?',
  'how-to-check-which-option-is-selected-in-dropdown',
  'Use getFirstSelectedOption().getText() to get the selected option or isSelected() to check if a specific option is selected.',
  $$Use `getFirstSelectedOption()` to get the currently selected dropdown value, or `isSelected()` to check a specific option.

**Get first selected option:**
```java
Select dropdown = new Select(driver.findElement(By.id("countries")));
WebElement selectedOption = dropdown.getFirstSelectedOption();
System.out.println("Selected: " + selectedOption.getText());
```

**Using isSelected() — returns true or false:**
```java
Select dropdown = new Select(driver.findElement(By.id("countries")));
dropdown.selectByVisibleText("India");
System.out.println(driver.findElement(By.id("India")).isSelected());
// Returns: true
```

**Check all selected options (multi-select):**
```java
List<WebElement> selected = dropdown.getAllSelectedOptions();
for (WebElement opt : selected) {
    System.out.println("Selected: " + opt.getText());
}
```

**Full assertion example:**
```java
Select dropdown = new Select(driver.findElement(By.id("countries")));
dropdown.selectByVisibleText("India");

String selectedValue = dropdown.getFirstSelectedOption().getText();
Assert.assertEquals(selectedValue, "India", "Wrong option selected");
```

**isSelected() vs getFirstSelectedOption():**
| Method | Use case |
|--------|----------|
| `isSelected()` | Check if a specific WebElement option is selected |
| `getFirstSelectedOption()` | Get the currently selected option element |$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Dropdowns', 'Select Class', 'isSelected', 'Form Elements'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we check if an element is getting displayed on a web page?',
  'how-to-check-if-element-is-displayed-on-web-page',
  'Use the isDisplayed() method on a WebElement to check if it is visible on the page.',
  $$Use the **`isDisplayed()`** method on a `WebElement` to check if it is visible on the web page.

**Basic usage:**
```java
WebElement element = driver.findElement(By.id("errorMessage"));
boolean isVisible = element.isDisplayed();
System.out.println("Is displayed: " + isVisible);
```

**With assertion:**
```java
WebElement successBanner = driver.findElement(By.id("successBanner"));
Assert.assertTrue(successBanner.isDisplayed(), "Success banner should be visible");
```

**Check visibility with wait:**
```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("loader")));
boolean visible = driver.findElement(By.id("loader")).isDisplayed();
```

**isDisplayed() vs isEnabled() vs isSelected():**
| Method | What it checks |
|--------|---------------|
| `isDisplayed()` | Element is visible on screen (not hidden) |
| `isEnabled()` | Element is enabled for interaction (not disabled) |
| `isSelected()` | Element is selected (checkboxes, radio buttons, options) |

> **Note:** `isDisplayed()` returns `false` for elements with `display:none` or `visibility:hidden`. It still returns `true` for off-screen elements (scrolled out of view).$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'isDisplayed', 'Visibility', 'Assertions'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we check if an element is enabled for interaction on a web page?',
  'how-to-check-if-element-is-enabled-for-interaction',
  'Use the isEnabled() method on a WebElement to check if it is enabled and can be interacted with.',
  $$Use the **`isEnabled()`** method to check if an element is active and accepts user interaction.

**Basic usage:**
```java
boolean isEnabled = driver.findElement(By.locator).isEnabled();
System.out.println("Is enabled: " + isEnabled);
```

**Practical examples:**
```java
// Check if Submit button is enabled
WebElement submitBtn = driver.findElement(By.id("submitBtn"));
if (submitBtn.isEnabled()) {
    submitBtn.click();
} else {
    System.out.println("Submit button is disabled — fill in required fields first");
}

// Assert that input field is enabled
WebElement emailField = driver.findElement(By.id("email"));
Assert.assertTrue(emailField.isEnabled(), "Email field should be enabled");

// Check disabled state
WebElement disabledField = driver.findElement(By.id("readonlyField"));
Assert.assertFalse(disabledField.isEnabled(), "Field should be disabled");
```

**Real-world use case:**
Verifying that a "Submit" button only becomes enabled after all required fields are filled:
```java
WebElement name  = driver.findElement(By.id("name"));
WebElement email = driver.findElement(By.id("email"));
WebElement btn   = driver.findElement(By.id("submit"));

Assert.assertFalse(btn.isEnabled()); // disabled before filling
name.sendKeys("John");
email.sendKeys("john@test.com");
Assert.assertTrue(btn.isEnabled());  // enabled after filling
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'isEnabled', 'Form Validation', 'Assertions'], true, 0
);
