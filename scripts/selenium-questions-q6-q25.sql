-- Selenium Interview Questions Q6–Q25
-- Run in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES
(
  'Can we test APIs or web services using Selenium WebDriver?',
  'can-we-test-apis-web-services-using-selenium-webdriver',
  'Selenium WebDriver is browser-based and cannot test headless APIs or web services directly.',
  $body$No, Selenium WebDriver **cannot** be used to test APIs or web services directly.

Selenium automates web browsers using the browser's native methods. Since web services and APIs are headless (no UI/DOM), Selenium has nothing to interact with.

**What to use instead:**
- **Rest Assured** — Java library for REST API testing
- **Postman / Newman** — Manual and automated API testing
- **Karate Framework** — BDD-style API + UI testing
- **HttpClient / OkHttp** — Raw Java HTTP clients

**Key distinction:**
- Selenium = Browser automation (UI testing)
- REST Assured = HTTP-level API testing (no browser needed)$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'API Testing', 'WebDriver Basics'], true, 0
),
(
  'What are the testing types supported by Selenium WebDriver?',
  'testing-types-supported-by-selenium-webdriver',
  'Selenium WebDriver supports functional, regression, cross-browser, smoke, and acceptance testing.',
  $body$Selenium WebDriver primarily supports:

**1. Functional Testing**
Verifies that web application features work as expected — form submissions, button clicks, navigation.

**2. Regression Testing**
Ensures new code changes don't break existing functionality. This is Selenium's most common use case.

**3. Cross-Browser Testing**
Validates the application works consistently across Chrome, Firefox, Safari, Edge.

**4. Smoke Testing**
Basic sanity checks on critical features after each build.

**5. Acceptance Testing**
Used with Cucumber/BDD frameworks to validate user stories against acceptance criteria.

> **Note:** Selenium does NOT support performance/load testing (use JMeter), API testing (use Rest Assured), or mobile native apps (use Appium).$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Testing Types', 'WebDriver Basics'], true, 0
),
(
  'What are various ways of locating an element in Selenium?',
  'various-ways-of-locating-elements-in-selenium',
  'Selenium provides 8 locator strategies: id, name, className, tagName, linkText, partialLinkText, cssSelector, and xpath.',
  $body$Selenium WebDriver provides **8 locator strategies**:

| Locator | Example | Best For |
|---------|---------|----------|
| **id** | `By.id("username")` | Fastest — unique ID |
| **name** | `By.name("email")` | Form fields with name attribute |
| **className** | `By.className("btn")` | Elements with unique class |
| **tagName** | `By.tagName("input")` | Group of same-type elements |
| **linkText** | `By.linkText("Click Here")` | Exact anchor text |
| **partialLinkText** | `By.partialLinkText("Click")` | Partial anchor text |
| **cssSelector** | `By.cssSelector("#id .class")` | Fast, flexible selection |
| **xpath** | `By.xpath("//input[@id='user']")` | Most powerful, DOM traversal |

**Priority order (fastest to slowest):**
`id > name > cssSelector > xpath`

**Quick example:**
```java
driver.findElement(By.id("username")).sendKeys("admin");
driver.findElement(By.cssSelector(".btn-primary")).click();
driver.findElement(By.xpath("//button[text()='Submit']")).click();
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Locators', 'XPath', 'CSS Selector'], true, 0
),
(
  'What is an XPath?',
  'what-is-an-xpath',
  'XPath is an XML path expression language used to navigate and locate elements in HTML/XML documents.',
  $body$**XPath (XML Path Language)** is a query language used to select nodes from XML/HTML documents. It is one of the most powerful and flexible locators in Selenium WebDriver.

**Key capabilities:**
- Traverse the DOM both **upward** (to parent) and **downward** (to children)
- Match elements by attribute, text, position, or relationship
- Use built-in functions: `contains()`, `starts-with()`, `text()`, `position()`

**Basic Syntax:**
```xpath
//tagName[@attribute='value']
```

**Types of XPath:**
1. **Absolute XPath** — starts from root: `html/body/div/input`
2. **Relative XPath** — starts from anywhere: `//input[@id='username']`

**Examples:**
```xpath
//input[@id='username']
//button[text()='Login']
//div[@class='container']//a
//*[contains(@id,'user')]
```

**When to use XPath over CSS:**
Use XPath when you need to traverse to a **parent element** — CSS Selector can only go downward.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
),
(
  'What is an absolute XPath?',
  'what-is-an-absolute-xpath',
  'Absolute XPath starts from the root HTML node and traverses the entire DOM to reach the target element.',
  $body$An **Absolute XPath** starts from the root node (`html`) of the HTML document and traverses the full DOM tree down to the target element.

**Syntax:** Uses single forward slash `/`
```xpath
html/body/div/div[2]/div/form/input[1]
```

**Disadvantages:**
- Very **fragile** — any DOM change breaks it
- Long and hard to read/maintain
- Slower to execute (traverses entire document from root)
- Adding/removing one element breaks the entire path

**When to avoid:** Never commit absolute XPaths to automation code. Use only for quick one-time debugging.

**Comparison:**
| | Absolute XPath | Relative XPath |
|--|--|--|
| Starts from | Root (`html`) | Anywhere (`//`) |
| Stability | Fragile | Robust |
| Length | Long | Short |
| Maintenance | High | Low |

> **Golden Rule:** Always prefer Relative XPath in automation frameworks.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators', 'Absolute XPath'], true, 0
),
(
  'What is a relative XPath?',
  'what-is-a-relative-xpath',
  'Relative XPath starts from anywhere in the DOM using // and is more stable and preferred over absolute XPath.',
  $body$A **Relative XPath** starts from anywhere in the HTML document using the double-slash `//` notation. It is the **preferred** approach in automation testing.

**Syntax:** Starts with `//`
```xpath
//input[@id='username']
//button[text()='Login']
//div[@class='header']//a[@href='/home']
```

**Advantages over Absolute XPath:**
- Survives UI structural changes above the target element
- Shorter, more readable
- Can use powerful functions like `contains()`, `starts-with()`, `text()`

**Common patterns:**
```xpath
// By attribute
//input[@name='email']

// By text
//button[text()='Submit']

// Partial attribute match
//input[contains(@id,'user')]

// Starts-with
//input[starts-with(@class,'btn')]

// Parent-child chain
//div[@class='form']//input[@type='text']

// Following sibling
//label[@for='email']/following-sibling::input
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators', 'Relative XPath'], true, 0
),
(
  'What is the difference between single slash (/) and double slash (//) in XPath?',
  'difference-between-single-slash-double-slash-in-xpath',
  'Single slash (/) creates absolute XPath from root; double slash (//) creates relative XPath from anywhere in DOM.',
  $body$| Syntax | Type | Description | Example |
|--------|------|-------------|---------|
| `/` (Single Slash) | Absolute XPath | Selects from **root node** only. Every intermediate node must be specified. | `html/body/div/input` |
| `//` (Double Slash) | Relative XPath | Selects matching nodes **anywhere** in the document. | `//input[@id='user']` |

**Single Slash Example:**
```xpath
html/body/div[1]/form/input
-- Must start from html root — very rigid
```

**Double Slash Example:**
```xpath
//form/input
-- Finds any form > input combo anywhere in the DOM
```

**Combined usage:**
```xpath
//div[@id='login']//input[@type='text']
-- Start relative, then go deeper
```

> **Key Rule:** Always prefer `//` in automation — makes tests resilient to DOM changes.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
),
(
  'Which XPath will you prefer to use? Why?',
  'which-xpath-you-will-prefer-to-use-and-why',
  'Relative XPath is always preferred as it is stable, shorter, and survives UI structural changes.',
  $body$In automation testing, **Relative XPath is always preferred** over Absolute XPath.

**Reasons:**

**1. Stability**
Relative XPath survives UI changes. Even if elements are added/removed above the target element, the XPath still works.

**2. Shorter & Readable**
`//input[@id='username']` vs `html/body/div[1]/div[2]/form/div[1]/input`

**3. Flexible**
Supports `contains()`, `starts-with()`, `text()` for dynamic elements.

**4. Maintainable**
Less code to update when the UI changes.

**Comparison:**
```xpath
-- Preferred (Relative)
//input[@id='username']

-- Avoid (Absolute)
html/body/div[1]/div[2]/form/div[1]/input
```

> **Exception:** Absolute XPath may be used temporarily for debugging but should never be committed to your automation framework.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Best Practices'], true, 0
),
(
  'What is the difference between Absolute XPath and Relative XPath?',
  'difference-between-absolute-xpath-and-relative-xpath',
  'Absolute XPath traverses from root HTML node; Relative XPath jumps directly to the element using attributes.',
  $body$| Feature | Absolute XPath | Relative XPath |
|---------|---------------|----------------|
| **Starts from** | Root node (`html`) | Anywhere in DOM (`//`) |
| **Syntax** | `/html/body/div/input` | `//input[@id=''user'']` |
| **Stability** | Fragile — breaks on DOM changes | Robust — survives UI changes |
| **Length** | Long | Short and concise |
| **Maintenance** | Difficult | Easy |
| **Performance** | Slower | Faster |
| **Recommended** | No | Yes |

**Absolute XPath:**
```xpath
html/body/div[1]/div[2]/form/input[1]
```

**Equivalent Relative XPath:**
```xpath
//form//input[@type='text']
```

> **Golden Rule:** Always use Relative XPath in your automation framework.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
),
(
  'How can we inspect web element attributes to use in different locators?',
  'how-to-inspect-web-element-attributes-for-locators',
  'Use browser DevTools (F12) or ChroPath plugin to inspect element attributes like id, class, name for building locators.',
  $body$**1. Browser Developer Tools (F12) — Most Common**
```
1. Right-click the element on the page
2. Click "Inspect" or "Inspect Element"
3. The Elements panel shows full HTML with all attributes
4. Look for: id, name, class, type, placeholder attributes
5. Right-click HTML node → Copy → "Copy XPath" or "Copy selector"
```

**2. ChroPath Plugin (Chrome/Firefox)**
- Browser extension that auto-generates XPath and CSS Selectors
- Shows relative XPath, absolute XPath, and CSS Selector for any element
- Best tool for beginners

**3. Selenium IDE**
- Chrome/Firefox extension
- Records interactions and auto-generates locators

**What attributes to look for:**
```html
<input id="username" name="user" class="form-input"
       type="text" placeholder="Enter username">
```
- `id="username"` → `By.id("username")`
- `name="user"` → `By.name("user")`
- `class="form-input"` → `By.cssSelector(".form-input")`
- `placeholder="Enter username"` → `By.xpath("//input[@placeholder='Enter username']")`$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Locators', 'DevTools', 'XPath'], true, 0
),
(
  'How can we locate an element by only partially matching its attribute value in XPath?',
  'locate-element-partial-attribute-match-xpath',
  'Use contains() function in XPath to partially match dynamic attribute values.',
  $body$Use the **`contains()`** function in XPath to partially match attribute values. This is especially useful for elements with dynamic IDs or class names.

**Syntax:**
```xpath
//*[contains(@attributeName, 'partialValue')]
```

**Examples:**
```xpath
-- Match any element whose id contains 'user'
//*[contains(@id, 'user')]

-- Match input whose class contains 'btn'
//button[contains(@class, 'btn')]

-- Match link text containing 'Login'
//a[contains(text(), 'Login')]

-- Match name containing 'search'
//input[contains(@name, 'search')]
```

**Other partial matching functions:**
| Function | Description | Example |
|----------|-------------|---------|
| `contains()` | Value contains substring | `contains(@id,'user')` |
| `starts-with()` | Value starts with | `starts-with(@id,'user')` |
| `normalize-space()` | Ignore extra spaces | `normalize-space(text())='Login'` |

**Real-world use case:**
Dynamic IDs like `username_12345` or `username_67890` → `contains(@id, 'username')`$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'Locators', 'Dynamic Elements'], true, 0
),
(
  'How can we locate elements using their text in XPath?',
  'locate-elements-using-text-in-xpath',
  'Use the text() function or contains(text()) in XPath to locate elements by their visible text content.',
  $body$Use the **`text()`** function in XPath to locate elements by their visible text.

**Exact text match:**
```xpath
//button[text()='Submit']
//h1[text()='Welcome']
//a[text()='Click Here']
```

**Partial text match using contains():**
```xpath
//button[contains(text(),'Submit')]
//span[contains(text(),'Error')]
//div[contains(text(),'Success')]
```

**Difference:**
| | `text()` | `contains(text())` |
|--|--|--|
| Match type | Exact | Partial |
| Dynamic text | Fails | Works |
| Example | `[text()='Login']` | `[contains(text(),'Log')]` |

**Important note:**
`text()` is **case-sensitive**:
```xpath
//button[text()='submit']  -- Will NOT match 'Submit'
```

**When element has child elements:**
Use `.` (dot) instead of `text()`:
```xpath
//div[.='Some text with child elements']
```

**Java code example:**
```java
WebElement btn = driver.findElement(By.xpath("//button[text()='Login']"));
btn.click();
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators', 'text()'], true, 0
),
(
  'How can we move to the nth child element using XPath?',
  'move-to-nth-child-element-using-xpath',
  'Use index brackets [n] or position() function in XPath to select nth child elements.',
  $body$There are two ways to navigate to the nth child element using XPath:

**Method 1: Using Index in Square Brackets**
```xpath
-- Select 2nd div
//div[2]

-- Select 3rd li inside ul
//ul/li[3]

-- Select 1st input inside a form
//form//input[1]
```

**Method 2: Using position() Function**
```xpath
-- Select the 3rd div
//div[position()=3]

-- Select elements after position 2
//li[position()>2]

-- Select last element
//li[last()]

-- Select second to last
//li[last()-1]
```

**Table example:**
```xpath
-- 2nd row of a table
//table/tbody/tr[2]

-- 3rd cell of 2nd row
//table/tbody/tr[2]/td[3]

-- Last row
//table/tbody/tr[last()]
```

**Java code:**
```java
// Get 3rd item in a list
WebElement thirdItem = driver.findElement(By.xpath("//ul/li[3]"));
System.out.println(thirdItem.getText());
```

> **Note:** XPath indexing starts from **1**, not 0 (unlike Java arrays).$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
),
(
  'What is the syntax of finding elements by class using CSS Selector?',
  'find-elements-by-class-using-css-selector',
  'Use dot notation (.className) in CSS Selector to find elements by their class attribute.',
  $body$In CSS Selector, the **dot (`.`) notation** selects elements by class name.

**Syntax:**
```css
.className
tagName.className
```

**Java examples:**
```java
// By class name
driver.findElement(By.cssSelector(".btn-primary"));

// Tag + class
driver.findElement(By.cssSelector("button.btn-primary"));

// Multiple classes (element must have BOTH)
driver.findElement(By.cssSelector(".btn.btn-large"));

// Descendant with class
driver.findElement(By.cssSelector("form .input-field"));

// Direct child with class
driver.findElement(By.cssSelector("div > .submit-btn"));
```

**By.className() vs By.cssSelector():**
| Method | Example | Notes |
|--------|---------|-------|
| `By.className()` | `By.className("btn")` | Single class only |
| `By.cssSelector()` | `By.cssSelector(".btn.active")` | Supports multiple classes |

> **Important:** `By.className()` does NOT support multiple classes — use CSS Selector for that: `By.cssSelector(".btn.active")`$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'CSS Selector', 'Locators'], true, 0
),
(
  'What is the syntax of finding elements by id using CSS Selector?',
  'find-elements-by-id-using-css-selector',
  'Use hash notation (#idValue) in CSS Selector to find elements by their id attribute.',
  $body$In CSS Selector, the **hash (`#`) notation** selects elements by their `id` attribute.

**Syntax:**
```css
#idValue
tagName#idValue
```

**Java examples:**
```java
// By id
driver.findElement(By.cssSelector("#username"));

// Tag + id
driver.findElement(By.cssSelector("input#username"));

// Combine id with descendant
driver.findElement(By.cssSelector("#loginForm .submit-btn"));

// id with attribute
driver.findElement(By.cssSelector("#container input[type='text']"));
```

**Comparison:**
| Locator | Syntax | Notes |
|---------|--------|-------|
| `By.id()` | `By.id("username")` | Simplest, fastest |
| CSS `#id` | `By.cssSelector("#username")` | More flexible, can chain |
| XPath `@id` | `By.xpath("//input[@id='username']")` | Verbose |

> **Best Practice:** For elements with unique IDs, `By.id()` is fastest. Use CSS `#id` when you need to combine with other selectors like `#form input[type='text']`.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'CSS Selector', 'Locators'], true, 0
),
(
  'How can we select elements by their attribute value using CSS Selector?',
  'select-elements-by-attribute-value-using-css-selector',
  'Use [attribute=value] bracket notation in CSS Selector to select elements by any attribute and value.',
  $body$Use **square bracket `[attribute=value]`** notation in CSS Selector to select elements by any attribute.

**Syntax:**
```css
[attribute='value']
tagName[attribute='value']
```

**Java examples:**
```java
// By type attribute
driver.findElement(By.cssSelector("[type='submit']"));
driver.findElement(By.cssSelector("input[type='text']"));

// By placeholder
driver.findElement(By.cssSelector("[placeholder='Enter email']"));

// By name attribute
driver.findElement(By.cssSelector("[name='username']"));

// Combine multiple attributes
driver.findElement(By.cssSelector("input[type='password'][name='pwd']"));
```

**Partial Attribute Matching:**
| Operator | Meaning | Example |
|----------|---------|---------|
| `[attr='val']` | Exact match | `[type='text']` |
| `[attr^='val']` | Starts with | `[id^='user']` |
| `[attr$='val']` | Ends with | `[id$='name']` |
| `[attr*='val']` | Contains | `[id*='user']` |

```java
// id starts with 'user'
driver.findElement(By.cssSelector("input[id^='user']"));

// class contains 'btn'
driver.findElement(By.cssSelector("button[class*='btn']"));
```$body$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'CSS Selector', 'Locators'], true, 0
),
(
  'What is the fundamental difference between XPath and CSS Selector?',
  'fundamental-difference-between-xpath-and-css-selector',
  'XPath can traverse both up and down the DOM; CSS Selector can only move downward to child elements.',
  $body$The most fundamental difference is **DOM traversal direction**:

| Feature | XPath | CSS Selector |
|---------|-------|-------------|
| **DOM traversal** | Both up (parent) and down (child) | Only downward |
| **Parent selection** | Yes | No |
| **Speed** | Slightly slower | Slightly faster |
| **Text matching** | Yes — `text()` | No |
| **Partial matching** | `contains()`, `starts-with()` | `*=`, `^=`, `$=` |
| **Readability** | Verbose | Concise |

**XPath traversing UP to parent (CSS cannot do this):**
```xpath
-- Find parent div of an input
//input[@id='username']/parent::div

-- Find ancestor form
//input[@id='username']/ancestor::form

-- Find following sibling
//label[@for='email']/following-sibling::input
```

**CSS equivalent (downward only):**
```css
/* Can only go down */
form input[type='text']
div > .submit-btn
```

**Recommendation:**
- Use **CSS Selector** when possible — faster and cleaner
- Use **XPath** when you need parent traversal or text-based matching$body$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'XPath', 'CSS Selector', 'Locators'], true, 0
),
(
  'How can we launch different browsers in Selenium WebDriver?',
  'how-to-launch-different-browsers-in-selenium-webdriver',
  'Launch different browsers by creating instances of ChromeDriver, FirefoxDriver, EdgeDriver, or SafariDriver.',
  $body$Different browsers are launched by instantiating the respective WebDriver class.

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

**With options (headless Chrome):**
```java
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless", "--no-sandbox");
WebDriver driver = new ChromeDriver(options);
```

**Browser factory pattern (recommended):**
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

> **Note:** Since **Selenium 4.6+**, Selenium Manager automatically downloads the correct driver binary — no manual ChromeDriver setup or WebDriverManager dependency needed.$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'Cross Browser', 'ChromeDriver'], true, 0
),
(
  'What is the difference between driver.get() and driver.navigate().to() in Selenium?',
  'difference-between-driver-get-and-driver-navigate-to',
  'Both navigate to a URL, but driver.navigate() also supports back(), forward(), and refresh() for browser history.',
  $body$Both commands navigate to a URL but have different capabilities:

**Similarity — both navigate to URL:**
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

**navigate() extras (not in get()):**
```java
// Browser back
driver.navigate().back();

// Browser forward
driver.navigate().forward();

// Refresh page
driver.navigate().refresh();

// Navigate using java.net.URL object
URL url = new URL("https://automateqa.online");
driver.navigate().to(url);
```

**Best Practice:**
- Use `driver.get()` for the initial URL at test start
- Use `driver.navigate().to()` when navigating between pages within a test flow$body$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Navigation', 'WebDriver Commands'], true, 0
),
(
  'How can we type text in a textbox element using Selenium?',
  'how-to-type-text-in-textbox-using-selenium',
  'Use sendKeys() method on a located WebElement to type text into an input field or textbox.',
  $body$Use the **`sendKeys()`** method to type text into a textbox.

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
driver.findElement(By.xpath("//input[@placeholder='Search']")).sendKeys("QA");
```

**Clear before typing (best practice):**
```java
WebElement input = driver.findElement(By.id("username"));
input.clear();              // Clear existing text
input.sendKeys("newuser");  // Type new text
```

**Sending special keys:**
```java
import org.openqa.selenium.Keys;

// Press Enter after typing
driver.findElement(By.id("search")).sendKeys("Selenium", Keys.ENTER);

// Press Tab to move to next field
driver.findElement(By.id("username")).sendKeys("admin", Keys.TAB);

// Select all and replace
input.sendKeys(Keys.CONTROL + "a");
input.sendKeys("replacement text");
```$body$,
  'Selenium', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebElement', 'sendKeys', 'Input'], true, 0
);
