-- Selenium Q6–Q15 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Can we test APIs or web services using Selenium WebDriver?',
  'can-we-test-apis-web-services-using-selenium-webdriver',
  'Selenium WebDriver is browser-based and cannot test headless APIs or web services directly.',
  $$No, Selenium WebDriver **cannot** be used to test APIs or web services directly. Selenium automates web browsers using the browser''s native methods. Since web services and APIs are headless (no UI/DOM), Selenium has nothing to interact with.

**What to use instead:**
- **Rest Assured** — Java library for REST API testing
- **Postman / Newman** — Manual and automated API testing
- **Karate Framework** — BDD-style API + UI testing

**Key distinction:**
- Selenium = Browser automation (UI testing)
- REST Assured = HTTP-level API testing (no browser needed)$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'API Testing', 'WebDriver Basics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the testing types supported by Selenium WebDriver?',
  'testing-types-supported-by-selenium-webdriver',
  'Selenium WebDriver supports functional, regression, cross-browser, smoke, and acceptance testing.',
  $$Selenium WebDriver primarily supports:

**1. Functional Testing**
Verifies that web application features work as expected — form submissions, button clicks, navigation.

**2. Regression Testing**
Ensures new code changes do not break existing functionality. This is Selenium''s most common use case.

**3. Cross-Browser Testing**
Validates the application works consistently across Chrome, Firefox, Safari, Edge.

**4. Smoke Testing**
Basic sanity checks on critical features after each build.

**5. Acceptance Testing**
Used with Cucumber/BDD frameworks to validate user stories against acceptance criteria.

> **Note:** Selenium does NOT support performance/load testing (use JMeter), API testing (use Rest Assured), or mobile native apps (use Appium).$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Testing Types', 'WebDriver Basics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are various ways of locating an element in Selenium?',
  'various-ways-of-locating-elements-in-selenium',
  'Selenium provides 8 locator strategies: id, name, className, tagName, linkText, partialLinkText, cssSelector, and xpath.',
  $$Selenium WebDriver provides **8 locator strategies**:

| Locator | Example | Best For |
|---------|---------|----------|
| **id** | `By.id("username")` | Fastest — unique ID |
| **name** | `By.name("email")` | Form fields with name attribute |
| **className** | `By.className("btn")` | Elements with unique class |
| **tagName** | `By.tagName("input")` | Group of same-type elements |
| **linkText** | `By.linkText("Click Here")` | Exact anchor text |
| **partialLinkText** | `By.partialLinkText("Click")` | Partial anchor text |
| **cssSelector** | `By.cssSelector("#id .class")` | Fast, flexible selection |
| **xpath** | `By.xpath("//input[@id=''user'']")` | Most powerful, DOM traversal |

**Priority order (fastest to slowest):**
id > name > cssSelector > xpath

**Quick example:**
```java
driver.findElement(By.id("username")).sendKeys("admin");
driver.findElement(By.cssSelector(".btn-primary")).click();
driver.findElement(By.xpath("//button[text()=''Submit'']")).click();
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Locators', 'XPath', 'CSS Selector'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is an XPath?',
  'what-is-an-xpath',
  'XPath is an XML path expression language used to navigate and locate elements in HTML/XML documents.',
  $$**XPath (XML Path Language)** is a query language used to select nodes from XML/HTML documents. It is one of the most powerful and flexible locators in Selenium WebDriver.

**Key capabilities:**
- Traverse the DOM both **upward** (to parent) and **downward** (to children)
- Match elements by attribute, text, position, or relationship
- Use built-in functions: `contains()`, `starts-with()`, `text()`, `position()`

**Basic Syntax:**
```xpath
//tagName[@attribute=''value'']
```

**Types of XPath:**
1. **Absolute XPath** — starts from root: `html/body/div/input`
2. **Relative XPath** — starts from anywhere: `//input[@id=''username'']`

**Common examples:**
```xpath
//input[@id=''username'']
//button[text()=''Login'']
//div[@class=''container'']//a
//*[contains(@id,''user'')]
```

**When to use XPath over CSS:**
Use XPath when you need to traverse to a **parent element** — CSS Selector can only go downward.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is an absolute XPath?',
  'what-is-an-absolute-xpath',
  'Absolute XPath starts from the root HTML node and traverses the entire DOM to reach the target element.',
  $$An **Absolute XPath** starts from the root node (`html`) of the HTML document and traverses the full DOM tree down to the target element.

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
| Starts from | Root (html) | Anywhere (//) |
| Stability | Fragile | Robust |
| Length | Long | Short |
| Maintenance | High | Low |

> **Golden Rule:** Always prefer Relative XPath in automation frameworks.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators', 'Absolute XPath'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a relative XPath?',
  'what-is-a-relative-xpath',
  'Relative XPath starts from anywhere in the DOM using // and is more stable and preferred over absolute XPath.',
  $$A **Relative XPath** starts from anywhere in the HTML document using the double-slash `//` notation. It is the **preferred** approach in automation testing.

**Syntax:** Starts with `//`
```xpath
//input[@id=''username'']
//button[text()=''Login'']
//div[@class=''header'']//a[@href=''/home'']
```

**Advantages over Absolute XPath:**
- Survives UI structural changes above the target element
- Shorter, more readable
- Supports powerful functions like `contains()`, `starts-with()`, `text()`

**Common patterns:**
```xpath
//input[@name=''email'']
//button[text()=''Submit'']
//input[contains(@id,''user'')]
//input[starts-with(@class,''btn'')]
//div[@class=''form'']//input[@type=''text'']
//label[@for=''email'']/following-sibling::input
```$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators', 'Relative XPath'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between single slash (/) and double slash (//) in XPath?',
  'difference-between-single-slash-double-slash-in-xpath',
  'Single slash (/) creates absolute XPath from root; double slash (//) creates relative XPath from anywhere in DOM.',
  $$| Syntax | Type | Description | Example |
|--------|------|-------------|---------|
| `/` (Single Slash) | Absolute XPath | Selects from root node only. Every intermediate node must be specified. | `html/body/div/input` |
| `//` (Double Slash) | Relative XPath | Selects matching nodes anywhere in the document. | `//input[@id=''user'']` |

**Single Slash Example:**
```xpath
html/body/div[1]/form/input
```
Must start from html root — very rigid.

**Double Slash Example:**
```xpath
//form/input
```
Finds any form > input combo anywhere in the DOM.

**Combined usage:**
```xpath
//div[@id=''login'']//input[@type=''text'']
```
Start relative, then go deeper.

> **Key Rule:** Always prefer `//` in automation — makes tests resilient to DOM changes.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Which XPath will you prefer to use? Why?',
  'which-xpath-you-will-prefer-to-use-and-why',
  'Relative XPath is always preferred as it is stable, shorter, and survives UI structural changes.',
  $$In automation testing, **Relative XPath is always preferred** over Absolute XPath.

**Reasons:**

**1. Stability**
Relative XPath survives UI changes. Even if elements are added/removed above the target element, the XPath still works.

**2. Shorter and Readable**
`//input[@id=''username'']` vs `html/body/div[1]/div[2]/form/div[1]/input`

**3. Flexible**
Supports `contains()`, `starts-with()`, `text()` for dynamic elements.

**4. Maintainable**
Less code to update when the UI changes.

**Comparison:**
```xpath
-- Preferred (Relative)
//input[@id=''username'']

-- Avoid (Absolute)
html/body/div[1]/div[2]/form/div[1]/input
```

> **Exception:** Absolute XPath may be used temporarily for debugging but should never be committed to your automation framework.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Best Practices'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the difference between Absolute XPath and Relative XPath?',
  'difference-between-absolute-xpath-and-relative-xpath',
  'Absolute XPath traverses from root HTML node; Relative XPath jumps directly to the element using attributes.',
  $$| Feature | Absolute XPath | Relative XPath |
|---------|---------------|----------------|
| **Starts from** | Root node (html) | Anywhere in DOM (//) |
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
//form//input[@type=''text'']
```

> **Golden Rule:** Always use Relative XPath in your automation framework.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'XPath', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How can we inspect web element attributes to use in different locators?',
  'how-to-inspect-web-element-attributes-for-locators',
  'Use browser DevTools (F12) or ChroPath plugin to inspect element attributes like id, class, name for building locators.',
  $$**1. Browser Developer Tools (F12) — Most Common**

Right-click the element on the page → click "Inspect" → The Elements panel shows full HTML with all attributes. Look for: id, name, class, type, placeholder attributes. Right-click the HTML node → Copy → "Copy XPath" or "Copy selector".

**2. ChroPath Plugin (Chrome/Firefox)**
Browser extension that auto-generates XPath and CSS Selectors. Shows relative XPath, absolute XPath, and CSS Selector for any element. Best tool for beginners.

**3. Selenium IDE**
Chrome/Firefox extension that records interactions and auto-generates locators.

**What attributes to look for:**
```html
<input id="username" name="user" class="form-input"
       type="text" placeholder="Enter username">
```

From the above HTML:
- `id="username"` → `By.id("username")`
- `name="user"` → `By.name("user")`
- `class="form-input"` → `By.cssSelector(".form-input")`
- `placeholder="Enter username"` → `By.xpath("//input[@placeholder=''Enter username'']")`$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'Locators', 'DevTools', 'XPath'], true, 0
);
