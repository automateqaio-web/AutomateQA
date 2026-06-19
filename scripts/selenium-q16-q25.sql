-- Selenium Q16–Q25 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we locate an element by only partially matching its attribute value in XPath?',
  'locate-element-partial-attribute-match-xpath',
  'Use contains() function in XPath to partially match dynamic attribute values.',
  $$Use the **`contains()`** function in XPath to partially match attribute values. This is especially useful for elements with dynamic IDs or class names.

**Syntax:**
```xpath
//*[contains(@attributeName, ''partialValue'')]
```

**Examples:**
```xpath
//*[contains(@id, ''user'')]
//button[contains(@class, ''btn'')]
//a[contains(text(), ''Login'')]
//input[contains(@name, ''search'')]
```

**Other partial matching functions:**
| Function | Description | Example |
|----------|-------------|---------|
| `contains()` | Value contains substring | `contains(@id,''user'')` |
| `starts-with()` | Value starts with | `starts-with(@id,''user'')` |
| `normalize-space()` | Ignore extra spaces | `normalize-space(text())=''Login''` |

**Real-world use case:**
Dynamic IDs like `username_12345` or `username_67890` → use `contains(@id, ''username'')`$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'Locators', 'Dynamic Elements'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we locate elements using their text in XPath?',
  'locate-elements-using-text-in-xpath',
  'Use the text() function or contains(text()) in XPath to locate elements by their visible text content.',
  $$Use the **`text()`** function in XPath to locate elements by their visible text.

**Exact text match:**
```xpath
//button[text()=''Submit'']
//h1[text()=''Welcome'']
//a[text()=''Click Here'']
```

**Partial text match using contains():**
```xpath
//button[contains(text(),''Submit'')]
//span[contains(text(),''Error'')]
//div[contains(text(),''Success'')]
```

**Difference:**
| | `text()` | `contains(text())` |
|--|--|--|
| Match type | Exact | Partial |
| Dynamic text | Fails | Works |
| Example | `[text()=''Login'']` | `[contains(text(),''Log'')]` |

**Important note:**
`text()` is **case-sensitive**:
```xpath
//button[text()=''submit'']  -- Will NOT match ''Submit''
```

**Java code example:**
```java
WebElement btn = driver.findElement(By.xpath("//button[text()=''Login'']"));
btn.click();
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators', 'text()'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we move to the nth child element using XPath?',
  'move-to-nth-child-element-using-xpath',
  'Use index brackets [n] or position() function in XPath to select nth child elements.',
  $$There are two ways to navigate to the nth child element using XPath:

**Method 1: Using Index in Square Brackets**
```xpath
//div[2]
//ul/li[3]
//form//input[1]
```

**Method 2: Using position() Function**
```xpath
//div[position()=3]
//li[position()>2]
//li[last()]
//li[last()-1]
```

**Table example:**
```xpath
//table/tbody/tr[2]
//table/tbody/tr[2]/td[3]
//table/tbody/tr[last()]
```

**Java code:**
```java
WebElement thirdItem = driver.findElement(By.xpath("//ul/li[3]"));
System.out.println(thirdItem.getText());
```

> **Note:** XPath indexing starts from **1**, not 0 (unlike Java arrays).$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the syntax of finding elements by class using CSS Selector?',
  'find-elements-by-class-using-css-selector',
  'Use dot notation (.className) in CSS Selector to find elements by their class attribute.',
  $$In CSS Selector, the **dot (`.`) notation** selects elements by class name.

**Syntax:**
```css
.className
tagName.className
```

**Java examples:**
```java
driver.findElement(By.cssSelector(".btn-primary"));
driver.findElement(By.cssSelector("button.btn-primary"));
driver.findElement(By.cssSelector(".btn.btn-large"));
driver.findElement(By.cssSelector("form .input-field"));
driver.findElement(By.cssSelector("div > .submit-btn"));
```

**By.className() vs By.cssSelector():**
| Method | Example | Notes |
|--------|---------|-------|
| `By.className()` | `By.className("btn")` | Single class only |
| `By.cssSelector()` | `By.cssSelector(".btn.active")` | Supports multiple classes |

> **Important:** `By.className()` does NOT support multiple classes — use CSS Selector for that: `By.cssSelector(".btn.active")`$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'CSS Selector', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the syntax of finding elements by id using CSS Selector?',
  'find-elements-by-id-using-css-selector',
  'Use hash notation (#idValue) in CSS Selector to find elements by their id attribute.',
  $$In CSS Selector, the **hash (`#`) notation** selects elements by their `id` attribute.

**Syntax:**
```css
#idValue
tagName#idValue
```

**Java examples:**
```java
driver.findElement(By.cssSelector("#username"));
driver.findElement(By.cssSelector("input#username"));
driver.findElement(By.cssSelector("#loginForm .submit-btn"));
driver.findElement(By.cssSelector("#container input[type=''text'']"));
```

**Comparison:**
| Locator | Syntax | Notes |
|---------|--------|-------|
| `By.id()` | `By.id("username")` | Simplest, fastest |
| CSS `#id` | `By.cssSelector("#username")` | More flexible, can chain |
| XPath `@id` | `By.xpath("//input[@id=''username'']")` | Verbose |

> **Best Practice:** For elements with unique IDs, `By.id()` is fastest. Use CSS `#id` when you need to combine with other selectors like `#form input[type=''text'']`.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'CSS Selector', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we select elements by their attribute value using CSS Selector?',
  'select-elements-by-attribute-value-using-css-selector',
  'Use [attribute=value] bracket notation in CSS Selector to select elements by any attribute and value.',
  $$Use **square bracket `[attribute=value]`** notation in CSS Selector to select elements by any attribute.

**Basic examples:**
```java
driver.findElement(By.cssSelector("[type=''submit'']"));
driver.findElement(By.cssSelector("input[type=''text'']"));
driver.findElement(By.cssSelector("[placeholder=''Enter email'']"));
driver.findElement(By.cssSelector("[name=''username'']"));
driver.findElement(By.cssSelector("input[type=''password''][name=''pwd'']"));
```

**Partial Attribute Matching:**
| Operator | Meaning | Example |
|----------|---------|---------|
| `[attr=''val'']` | Exact match | `[type=''text'']` |
| `[attr^=''val'']` | Starts with | `[id^=''user'']` |
| `[attr$=''val'']` | Ends with | `[id$=''name'']` |
| `[attr*=''val'']` | Contains | `[id*=''user'']` |

```java
driver.findElement(By.cssSelector("input[id^=''user'']"));
driver.findElement(By.cssSelector("button[class*=''btn'']"));
```$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'CSS Selector', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the fundamental difference between XPath and CSS Selector?',
  'fundamental-difference-between-xpath-and-css-selector',
  'XPath can traverse both up and down the DOM; CSS Selector can only move downward to child elements.',
  $$The most fundamental difference is **DOM traversal direction**:

| Feature | XPath | CSS Selector |
|---------|-------|-------------|
| **DOM traversal** | Both up (parent) and down (child) | Only downward |
| **Parent selection** | Yes | No |
| **Speed** | Slightly slower | Slightly faster |
| **Text matching** | Yes — `text()` function | No native support |
| **Partial matching** | `contains()`, `starts-with()` | `*=`, `^=`, `$=` |

**XPath traversing UP to parent (CSS cannot do this):**
```xpath
//input[@id=''username'']/parent::div
//input[@id=''username'']/ancestor::form
//label[@for=''email'']/following-sibling::input
```

**CSS goes downward only:**
```css
form input[type=''text'']
div > .submit-btn
```

**Recommendation:**
- Use **CSS Selector** when possible — faster and cleaner
- Use **XPath** when you need parent traversal or text-based matching$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'CSS Selector', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we launch different browsers in Selenium WebDriver?',
  'how-to-launch-different-browsers-in-selenium-webdriver',
  'Launch different browsers by creating instances of ChromeDriver, FirefoxDriver, EdgeDriver, or SafariDriver.',
  $$Different browsers are launched by instantiating the respective WebDriver class.

**Chrome:**
```java
WebDriver driver = new ChromeDriver();
driver.get("https://automateqa.online");
```

**Firefox:**
```java
WebDriver driver = new FirefoxDriver();
```

**Microsoft Edge:**
```java
WebDriver driver = new EdgeDriver();
```

**Safari (Mac only):**
```java
WebDriver driver = new SafariDriver();
```

**Headless Chrome:**
```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless", "--no-sandbox");
WebDriver driver = new ChromeDriver(options);
```

**Browser factory pattern:**
```java
public WebDriver getDriver(String browser) {
    return switch (browser.toLowerCase()) {
        case "chrome"  -> new ChromeDriver();
        case "firefox" -> new FirefoxDriver();
        case "edge"    -> new EdgeDriver();
        default -> throw new IllegalArgumentException("Unknown: " + browser);
    };
}
```

> **Note:** Since Selenium 4.6+, Selenium Manager automatically downloads the correct driver binary — no manual ChromeDriver setup needed.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'Cross Browser', 'ChromeDriver'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between driver.get() and driver.navigate().to() in Selenium?',
  'difference-between-driver-get-and-driver-navigate-to',
  'Both navigate to a URL, but driver.navigate() also supports back(), forward(), and refresh() for browser history.',
  $$Both commands navigate to a URL but have different capabilities:

**Both navigate to URL:**
```java
driver.get("https://automateqa.online");
driver.navigate().to("https://automateqa.online");
```

**Key Differences:**
| Feature | `driver.get()` | `driver.navigate().to()` |
|---------|----------------|--------------------------|
| Waits for page load | Yes | Yes |
| Supports history | No | Yes |
| Accepts URL object | No | Yes |
| Use case | Initial page load | Navigation within flow |

**navigate() extras (not available in get()):**
```java
driver.navigate().back();
driver.navigate().forward();
driver.navigate().refresh();

// Navigate using java.net.URL object
URL url = new URL("https://automateqa.online");
driver.navigate().to(url);
```

**Best Practice:**
- Use `driver.get()` for the initial URL at test start
- Use `driver.navigate().to()` when navigating between pages within a test flow$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Navigation', 'WebDriver Commands'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we type text in a textbox element using Selenium?',
  'how-to-type-text-in-textbox-using-selenium',
  'Use sendKeys() method on a located WebElement to type text into an input field or textbox.',
  $$Use the **`sendKeys()`** method to type text into a textbox.

**Basic usage:**
```java
WebElement searchBox = driver.findElement(By.id("search"));
searchBox.sendKeys("Selenium WebDriver");
```

**With different locators:**
```java
driver.findElement(By.id("username")).sendKeys("testuser");
driver.findElement(By.name("email")).sendKeys("test@example.com");
driver.findElement(By.cssSelector("#password")).sendKeys("pass123");
```

**Clear before typing (best practice):**
```java
WebElement input = driver.findElement(By.id("username"));
input.clear();
input.sendKeys("newuser");
```

**Sending special keys:**
```java
import org.openqa.selenium.Keys;

// Press Enter after typing
driver.findElement(By.id("search")).sendKeys("Selenium", Keys.ENTER);

// Press Tab to move to next field
driver.findElement(By.id("username")).sendKeys("admin", Keys.TAB);

// Select all text and replace
input.sendKeys(Keys.CONTROL + "a");
input.sendKeys("replacement text");
```$$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'sendKeys', 'Input'], true, 0
);
