-- Selenium Q71–Q84 | Paste into a FRESH new query tab in Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'How to handle hidden elements in Selenium WebDriver?',
  'how-to-handle-hidden-elements-in-selenium-webdriver',
  'Hidden elements cannot be clicked directly. Use JavascriptExecutor to interact with elements that have display:none or visibility:hidden.',
  $$Hidden elements (those with `display:none` or `visibility:hidden`) are present in the DOM but not visible. Selenium''s standard `click()` or `sendKeys()` throw `ElementNotInteractableException` on them.

**Method 1: JavascriptExecutor — most common fix**
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("document.getElementsByClassName(''ElementLocator'').click();");
```

Or using an element reference:
```java
WebElement hiddenBtn = driver.findElement(By.id("hiddenButton"));
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].click();", hiddenBtn);
```

**Method 2: Make element visible via JS, then interact:**
```java
WebElement el = driver.findElement(By.id("hiddenInput"));
js.executeScript("arguments[0].style.display=''block'';", el);
el.sendKeys("text value");
```

**Method 3: Set value directly via JS (bypass the UI):**
```java
WebElement input = driver.findElement(By.id("hiddenInput"));
js.executeScript("arguments[0].value=''my value'';", input);
```

**When does an element become hidden?**
- CSS: `display: none` or `visibility: hidden`
- HTML attribute: `type="hidden"`
- Conditional rendering (shown only after user action)

> **Best Practice:** Prefer `arguments[0].click()` via JS executor rather than changing element visibility, since visibility changes alter the DOM and may cause different behavior than a real user action.$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'Hidden Elements', 'JavascriptExecutor', 'ElementNotInteractable'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Page Object Model or POM?',
  'what-is-page-object-model-or-pom',
  'POM is a Selenium design pattern where each web page has a dedicated class containing its locators and interaction methods.',
  $$**Page Object Model (POM)** is a design pattern in Selenium that creates a framework for maintaining and organizing automation scripts.

**Core concept:**
- For each page of the application, a **separate Java class** is created
- The class contains all **web elements** (locators) belonging to that page
- The class contains all **methods** (actions) that can be performed on that page
- Test scripts are maintained in **separate files** and call these page object methods

**Why use POM:**
- Separates test logic from page interaction logic
- Locator changes require editing only one class — not every test
- Methods are reusable across multiple test classes
- Makes tests readable like plain English

**Example structure:**
```
src/
├── pages/
│   ├── LoginPage.java      ← Web elements + methods for Login page
│   ├── DashboardPage.java  ← Web elements + methods for Dashboard
│   └── SearchPage.java
└── tests/
    ├── LoginTest.java      ← Calls LoginPage methods
    └── SearchTest.java
```

**LoginPage.java:**
```java
public class LoginPage {
    private By username = By.id("username");
    private By password = By.id("password");
    private By loginBtn = By.id("loginBtn");

    public LoginPage(WebDriver driver) { this.driver = driver; }

    public DashboardPage login(String user, String pass) {
        driver.findElement(username).sendKeys(user);
        driver.findElement(password).sendKeys(pass);
        driver.findElement(loginBtn).click();
        return new DashboardPage(driver);
    }
}
```$$,
  'Selenium', 'Technical', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'POM', 'Page Object Model', 'Framework', 'Design Pattern'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are the advantages of Page Object Model (POM)?',
  'advantages-of-page-object-model-pom',
  'POM improves code reusability, maintainability, and readability by separating page elements from test logic.',
  $$The **advantages of Page Object Model** are:

**1. Object Repository / Code Reusability**
POM creates a centralized repository of all web elements in separate page classes along with their associated methods. The same page class can be used across multiple test scripts without duplicating locators.

**2. Easy Maintenance — Single Point of Change**
For any change in UI or web elements, only the page object file needs to be updated. Test files remain unchanged. This dramatically reduces maintenance effort when the application UI changes.

**3. Readability**
Test scripts become clean and readable — they describe WHAT is being tested, not HOW to find elements. Example:
```java
loginPage.login("admin", "pass123");
dashboardPage.verifyWelcomeMessage();
```

**4. Separation of Concerns**
- Page files → HOW to interact with the page (locators + methods)
- Test files → WHAT to test (test scenarios + assertions)

**5. Reduced Code Duplication**
Common actions like login, navigation, and form filling are written once in the page class and reused everywhere.

**6. Better Collaboration**
Developers and testers can work on page classes and test classes independently without conflicts.

**Summary table:**
| Benefit | Without POM | With POM |
|---------|-------------|---------|
| Locator change | Edit all test files | Edit one page file |
| Code duplication | High | None |
| Readability | Low | High |
| Maintenance effort | High | Low |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'POM', 'Page Object Model', 'Framework', 'Best Practices'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Page Factory in Selenium?',
  'what-is-page-factory-in-selenium',
  'Page Factory is an implementation of POM that uses @FindBy annotations and PageFactory.initElements() to initialize web elements.',
  $$**Page Factory** is an implementation of Page Object Model in Selenium. It provides:
- `@FindBy` annotation to declare web elements
- `PageFactory.initElements()` method to initialize all elements annotated with `@FindBy`

**Benefits over plain POM:**
- Cleaner, annotation-based syntax
- Elements are lazily initialized (looked up when first used)
- No need to write `driver.findElement(By...)` repeatedly

**Full Page Factory example:**
```java
public class SamplePage {

    WebDriver driver;

    @FindBy(id = "search")
    WebElement searchTextBox;

    @FindBy(name = "searchBtn")
    WebElement searchButton;

    // Constructor
    public SamplePage(WebDriver driver) {
        this.driver = driver;
        // initElements method initializes all @FindBy elements
        PageFactory.initElements(driver, this);
    }

    // Sample method
    public void search(String searchTerm) {
        searchTextBox.sendKeys(searchTerm);
        searchButton.click();
    }
}
```

**Using the page in a test:**
```java
SamplePage page = new SamplePage(driver);
page.search("Selenium WebDriver");
```

**Other @FindBy locator strategies:**
```java
@FindBy(xpath = "//button[@type=''submit'']")
@FindBy(css = ".btn-primary")
@FindBy(linkText = "Click Here")
@FindBy(tagName = "input")
```$$,
  'Selenium', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Selenium', 'PageFactory', 'POM', 'FindBy', 'Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is an Object Repository in Selenium?',
  'what-is-object-repository-in-selenium',
  'An Object Repository is a centralized storage location for all web elements and their locators used across test scripts.',
  $$An **Object Repository** is a centralized location where all the web elements (objects) and their locators used in test scripts are stored and managed.

**Why it matters:**
- All locators are in one place — easy to find and update
- Changes to the UI require updating only the repository, not every test
- Promotes reuse — multiple tests can reference the same element

**In Selenium, Object Repositories are implemented using:**

**1. Page Object Model (POM)** — each page class IS the object repository for that page:
```java
public class LoginPage {
    private By usernameField = By.id("username");  // stored here
    private By passwordField = By.id("password");
    private By loginButton   = By.cssSelector(".btn-login");
}
```

**2. Page Factory with @FindBy** — annotations serve as the repository:
```java
@FindBy(id = "username")
WebElement usernameField;
```

**3. Properties file / Excel** — store locators externally:
```properties
# locators.properties
username.locator=id=username
password.locator=id=password
```

**Why not hardcode locators in test methods:**
```java
// BAD — locator repeated in every test method
driver.findElement(By.id("username")).sendKeys("admin");  // test 1
driver.findElement(By.id("username")).sendKeys("user2");  // test 2

// GOOD — locator defined once in page class
loginPage.enterUsername("admin");
loginPage.enterUsername("user2");
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Object Repository', 'POM', 'Framework', 'Locators'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a data driven framework?',
  'what-is-a-data-driven-framework',
  'A data driven framework separates test data from test logic, allowing the same test to run with multiple data sets from external files.',
  $$A **Data Driven Framework** is one in which the test data is stored in **external files** (CSV, Excel, JSON, database) and is completely separated from the test logic written in test scripts. The test data drives the test cases — i.e., the test methods run once for each set of test data values.

**How it works:**
```
External Data (Excel/CSV) → Test Framework → WebDriver → Browser
     ↓                           ↓
  [admin, pass1]            Login test runs for row 1
  [user2, pass2]            Login test runs for row 2
  [guest, pass3]            Login test runs for row 3
```

**Benefits:**
- Same test script runs with many data combinations
- No need to write separate test methods for each data set
- Easy for business teams to add new data without touching code

**TestNG DataProvider example:**
```java
@DataProvider(name = "loginData")
public Object[][] getData() {
    return new Object[][] {
        {"admin",  "pass123"},
        {"user2",  "test456"},
        {"guest",  "guest789"}
    };
}

@Test(dataProvider = "loginData")
public void testLogin(String username, String password) {
    driver.findElement(By.id("username")).sendKeys(username);
    driver.findElement(By.id("password")).sendKeys(password);
    driver.findElement(By.id("loginBtn")).click();
}
```

**Reading from Excel (Apache POI):**
```java
FileInputStream file = new FileInputStream("testdata.xlsx");
Workbook workbook = new XSSFWorkbook(file);
Sheet sheet = workbook.getSheet("LoginData");
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Data Driven', 'Framework', 'TestNG DataProvider', 'Apache POI'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a keyword driven framework?',
  'what-is-a-keyword-driven-framework',
  'A keyword driven framework maps test actions to keywords stored in external files, allowing non-coders to write test cases.',
  $$A **Keyword Driven Framework** is one in which test actions are associated with **keywords** stored in external files (usually Excel or CSV). The actual implementation code for each keyword is in the framework itself.

**Core idea:**
- Each action (click, type, navigate, verify) is represented as a keyword
- Test cases are written as sequences of keywords + parameters in a spreadsheet
- The framework reads each keyword and executes the corresponding method

**Example keyword mapping:**
| Keyword | Action |
|---------|--------|
| `launchBrowser` | Opens the browser |
| `navigateTo` | Navigates to a URL |
| `writeInTextBox(webElement, textToWrite)` | Types text into a field |
| `clickButton(webElement)` | Clicks a button |
| `verifyText(webElement, expectedText)` | Asserts element text |

**External test case file (Excel):**
```
TestStep | Keyword              | Object          | Value
1        | launchBrowser        | chrome          |
2        | navigateTo           |                 | https://automateqa.online
3        | writeInTextBox       | usernameField   | admin
4        | writeInTextBox       | passwordField   | pass123
5        | clickButton          | loginBtn        |
6        | verifyText           | welcomeMsg      | Welcome, Admin
```

**Benefits:**
- Non-technical team members can write test cases using keywords
- Code changes are isolated in the framework — test sheets stay unchanged
- Highly reusable keyword library$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Keyword Driven', 'Framework', 'Test Automation', 'Excel'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a hybrid framework?',
  'what-is-a-hybrid-framework',
  'A hybrid framework combines data driven and keyword driven approaches, storing both test data and test actions in external files.',
  $$A **Hybrid Framework** is a combination of one or more framework types. It is most commonly associated with a combination of **Data Driven** and **Keyword Driven** frameworks, where:
- Test **data** is kept in external files (Excel, CSV)
- Test **actions/keywords** are also kept in external files (in the form of a table)
- The framework engine reads both and executes them

**Structure:**
```
Hybrid Framework
├── Keywords (Excel) → What action to perform
├── Test Data (Excel/CSV) → What data to use
├── Object Repository (POM/Properties) → Which element to act on
└── Framework Engine (Java) → Connects everything
```

**Example test sheet:**
```
TestCase   | Keyword         | Object       | TestData
TC_Login_1 | launchBrowser   |              | chrome
TC_Login_1 | navigateTo      |              | https://automateqa.online
TC_Login_1 | enterText       | usernameField| admin
TC_Login_1 | enterText       | passwordField| pass@123
TC_Login_1 | clickElement    | loginBtn     |
TC_Login_1 | verifyText      | pageTitle    | Dashboard
```

**Advantages:**
- Maximum reusability — both actions and data are externalized
- Easy to add new test cases without touching code
- Supports large enterprise test suites
- Combines strengths of multiple frameworks

> **Most real-world enterprise Selenium frameworks are hybrid** — combining POM, Data Driven, and Keyword Driven patterns with TestNG and Extent Reports.$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Hybrid Framework', 'Data Driven', 'Keyword Driven', 'Framework'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is Selenium Grid?',
  'what-is-selenium-grid',
  'Selenium Grid is a tool that enables distributed running of test scripts across multiple machines with different browsers and platforms in parallel.',
  $$**Selenium Grid** is a tool that helps in **distributed running of test scripts** across different machines having different browsers, browser versions, and platforms — all in **parallel**.

**Architecture:**
- **Hub** — the central server that manages all distributed machines (nodes). It receives test requests and assigns them to available nodes.
- **Node** — the machines attached to the hub where tests actually execute.

```
         [Hub - Central Server]
         /          |          \
   [Node 1]    [Node 2]    [Node 3]
   Chrome      Firefox      Safari
   Windows     Linux        macOS
```

**Benefits:**
1. **Parallel execution** — multiple tests run simultaneously, drastically reducing total test time
2. **Multi-browser testing** — run on Chrome, Firefox, Edge, Safari at the same time
3. **Multi-platform testing** — run on Windows, Linux, macOS simultaneously
4. **Scalable** — add more nodes to handle more tests

**Selenium 4 Grid — Quick start:**
```bash
# Standalone mode (hub + node in one)
java -jar selenium-server-4.x.jar standalone

# Or hub mode
java -jar selenium-server-4.x.jar hub

# And on another machine start a node
java -jar selenium-server-4.x.jar node --hub http://hub-ip:4444
```

**Connect test to Grid:**
```java
ChromeOptions options = new ChromeOptions();
RemoteWebDriver driver = new RemoteWebDriver(
    new URL("http://hub-ip:4444"), options
);
```$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Selenium Grid', 'Parallel Testing', 'Hub', 'Node'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What are some advantages of Selenium Grid?',
  'advantages-of-selenium-grid',
  'Selenium Grid enables parallel test execution, multi-browser testing, and multi-platform testing to save time and increase coverage.',
  $$The main advantages of **Selenium Grid** are:

**1. Parallel Execution — Saves Time**
Grid allows running multiple test cases simultaneously across different nodes. A test suite that takes 2 hours sequentially can run in 20 minutes with 6 parallel nodes.

**2. Multi-Browser Testing**
Grid allows running the same test on Chrome, Firefox, Edge, and Safari at the same time. This ensures cross-browser compatibility without sequential waits.

**3. Multi-Platform Testing**
By configuring nodes with different operating systems (Windows, Linux, macOS), Grid enables cross-platform testing in a single test run.

**4. Scalability**
Simply add more nodes to scale up testing capacity. No code changes required — just attach new machines to the hub.

**5. Reduces Total Testing Time**
Parallel execution across multiple nodes directly reduces CI/CD pipeline feedback time — critical for agile development teams.

**6. Centralized Control**
The Hub provides a single entry point to manage and monitor all distributed test executions.

**Summary:**
| Advantage | Without Grid | With Grid |
|-----------|-------------|-----------|
| Execution speed | Sequential (slow) | Parallel (fast) |
| Browser coverage | One at a time | All at once |
| Platform coverage | One machine | Multiple OS |
| Scalability | Limited | Add more nodes |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Selenium Grid', 'Parallel Testing', 'Cross Browser', 'Performance'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a Hub in Selenium Grid?',
  'what-is-hub-in-selenium-grid',
  'A Hub is the central server in Selenium Grid that receives test requests and routes them to the appropriate available nodes.',
  $$A **Hub** is the **central server** (or central point) in Selenium Grid that:
1. Receives incoming test execution requests
2. Manages and tracks all registered nodes
3. Routes each test to an appropriate node based on requested capabilities
4. Monitors the overall execution status

**Key characteristics:**
- There is only **ONE Hub** per Selenium Grid setup
- Acts as the entry point — test scripts connect to the hub
- Does NOT execute tests itself — delegates to nodes
- Runs on port **4444** by default

**Starting the Hub (Selenium 4):**
```bash
java -jar selenium-server-4.x.jar hub
```

**Hub URL:**
```
http://hub-machine-ip:4444
```

**Connecting a test to the Hub:**
```java
RemoteWebDriver driver = new RemoteWebDriver(
    new URL("http://hub-machine-ip:4444"),
    new ChromeOptions()
);
```

**Hub vs Node:**
| | Hub | Node |
|--|--|--|
| Count | One per grid | Multiple |
| Role | Routes requests | Executes tests |
| Runs browser | No | Yes |
| Port | 4444 | 5555, 5556... |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Selenium Grid', 'Hub', 'Distributed Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is a Node in Selenium Grid?',
  'what-is-node-in-selenium-grid',
  'A Node is a machine registered with the Selenium Grid Hub where actual browser test execution takes place.',
  $$**Nodes** are the machines that are **attached to the Selenium Grid Hub** and have Selenium WebDriver instances running test scripts.

**Key characteristics:**
- Multiple nodes can be attached to one Hub
- Each node can have different browsers, browser versions, or operating systems
- Nodes actually **execute the tests** (unlike the Hub which only routes)
- A single machine can run multiple node instances on different ports

**Starting a Node (Selenium 4):**
```bash
# Node on the same machine as hub
java -jar selenium-server-4.x.jar node --hub http://localhost:4444

# Node on a different machine
java -jar selenium-server-4.x.jar node --hub http://hub-ip:4444
```

**Node registers its capabilities to the hub:**
- Browser name (Chrome, Firefox, Edge)
- Browser version
- Platform (Windows, Linux, macOS)
- Max concurrent sessions

**Typical multi-node setup:**
```
Hub (192.168.1.100:4444)
    ├── Node 1 (192.168.1.101) → Chrome, Windows
    ├── Node 2 (192.168.1.102) → Firefox, Linux
    └── Node 3 (192.168.1.103) → Safari, macOS
```

**Hub vs Node summary:**
| | Hub | Node |
|--|--|--|
| Purpose | Route test requests | Execute tests |
| Browser | No browser | Has browsers installed |
| Count per Grid | One | Many |$$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Selenium Grid', 'Node', 'Distributed Testing', 'Hub'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'Explain the line of code: WebDriver driver = new FirefoxDriver();',
  'explain-webdriver-driver-new-firefoxdriver',
  'WebDriver is an interface; FirefoxDriver is a class that implements it. This line creates a FirefoxDriver object referenced by the WebDriver interface type.',
  $$In the line `WebDriver driver = new FirefoxDriver();`:

**Breaking it down:**
```java
WebDriver  driver  =  new FirefoxDriver();
    ↑         ↑              ↑
Interface  Reference      Object creation
  type     variable       (concrete class)
```

- **`WebDriver`** — is an **interface** (defined in `org.openqa.selenium.WebDriver`). It declares all browser automation methods like `get()`, `findElement()`, `quit()`, etc.
- **`driver`** — is a **reference variable** of type `WebDriver`
- **`new FirefoxDriver()`** — creates an **object** of `FirefoxDriver` class, which **implements** the `WebDriver` interface

**Class hierarchy:**
```
WebDriver (interface)
    ↑
RemoteWebDriver (class implements WebDriver)
    ↑
FirefoxDriver (class extends RemoteWebDriver)
ChromeDriver
EdgeDriver
```

**Why this works — polymorphism:**
Since `FirefoxDriver` implements `WebDriver`, a `FirefoxDriver` object can be assigned to a `WebDriver` reference. This is standard Java **polymorphism**.

**Practical meaning:**
When `new FirefoxDriver()` is called, Selenium launches the Firefox browser and returns a driver object through which all browser interactions happen.$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'FirefoxDriver', 'Java', 'OOP', 'Interface'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES (
  'What is the purpose of using WebDriver type for driver variable instead of FirefoxDriver directly?',
  'purpose-of-webdriver-type-variable-instead-of-firefoxdriver',
  'Using the WebDriver interface type allows the same variable to work with any browser driver, enabling easy cross-browser switching.',
  $$**By creating a reference variable of type `WebDriver` instead of `FirefoxDriver`**, we can use the SAME variable to work with multiple browsers like `ChromeDriver`, `FirefoxDriver`, `EdgeDriver`, etc.

**Without WebDriver interface (bad approach):**
```java
FirefoxDriver driver = new FirefoxDriver();
// driver can ONLY hold a FirefoxDriver — no flexibility
```

**With WebDriver interface (good approach):**
```java
WebDriver driver = new FirefoxDriver();    // Firefox
WebDriver driver = new ChromeDriver();    // Chrome — same variable type!
WebDriver driver = new EdgeDriver();      // Edge — same variable type!
```

**Practical cross-browser factory:**
```java
public WebDriver getDriver(String browser) {
    WebDriver driver;
    switch (browser.toLowerCase()) {
        case "firefox": driver = new FirefoxDriver(); break;
        case "chrome":  driver = new ChromeDriver();  break;
        case "edge":    driver = new EdgeDriver();    break;
        default: throw new IllegalArgumentException("Unknown browser: " + browser);
    }
    return driver;
}

// Usage — same WebDriver reference works for all browsers
WebDriver driver = getDriver(System.getProperty("browser", "chrome"));
driver.get("https://automateqa.online");
```

**Java OOP concept applied:**
This is **programming to an interface** — a Java best practice. It enables:
- **Polymorphism** — one type, many implementations
- **Flexibility** — switch browsers by changing one line
- **Extensibility** — new browsers can be added without changing caller code$$,
  'Selenium', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Selenium', 'WebDriver', 'Interface', 'Cross Browser', 'Java', 'OOP', 'Polymorphism'], true, 0
);
