-- Cucumber Advanced Questions Q36–Q55 (Senior Architect Level)
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q36
(
  'How do Cucumber tags work and what is an advanced tagging strategy?',
  'cucumber-q036-tags-strategy',
  'Cucumber tags (@smoke, @regression) filter which scenarios run. Advanced strategy uses AND/OR/NOT logic, priority tags, environment tags, and Maven -D flags to run targeted subsets in CI/CD pipelines.',
  $ans$
## Cucumber Tags — Advanced Strategy

### Basic Tagging

```gherkin
@smoke @login
Scenario: Successful login
  Given the user is on the login page
  ...

@regression @slow @payments
Scenario: Full checkout flow
  Given the user has items in cart
  ...

@skip @wip
Scenario: Feature in development
  Given this is not ready
  ...
```

### Tag Filtering from @CucumberOptions

```java
// Run ONLY @smoke scenarios
@CucumberOptions(tags = "@smoke")

// Run @smoke AND @login (both tags required)
@CucumberOptions(tags = "@smoke and @login")

// Run @smoke OR @sanity
@CucumberOptions(tags = "@smoke or @sanity")

// Run @regression but NOT @slow
@CucumberOptions(tags = "@regression and not @slow")

// Exclude WIP scenarios
@CucumberOptions(tags = "not @wip and not @skip")
```

### Override Tags from Maven CLI

```bash
# CI smoke run
mvn test -Dcucumber.filter.tags="@smoke"

# Full regression excluding slow
mvn test -Dcucumber.filter.tags="@regression and not @slow"

# Environment-specific
mvn test -Dcucumber.filter.tags="@staging"

# Priority-based
mvn test -Dcucumber.filter.tags="@P1 or @P2"
```

### Enterprise Tagging Strategy

```gherkin
-- Execution tier tags
@smoke        -- ~15 tests, runs in < 5 min (every commit)
@sanity       -- ~50 tests, runs in < 20 min (every PR)
@regression   -- all tests, runs nightly

-- Priority tags
@P1           -- business-critical
@P2           -- important
@P3           -- low priority

-- Environment tags
@staging      -- staging environment only
@prod-safe    -- safe to run in production

-- State tags
@wip          -- work in progress (excluded from CI)
@skip         -- permanently excluded
@flaky        -- known flaky (run separately)

-- Module tags
@login @checkout @cart @payments @search

-- Type tags
@api @ui @db
```

### Tagged Hooks (Scope Hooks to Tags)

```java
// Only runs before @login scenarios
@Before("@login")
public void navigateToLoginPage() {
    driver.get(config.getBaseUrl() + "/login");
}

// Only runs after @db scenarios
@After("@db")
public void cleanupDatabase() {
    dbUtils.rollbackTestData();
}

// Tag at Feature level — applies to ALL scenarios in that feature
```

```gherkin
@regression @payments
Feature: Payment Processing

  @smoke @P1
  Scenario: Pay with valid credit card
    ...

  @P2
  Scenario: Pay with expired card
    ...
```

The `@regression @payments` tags apply to both scenarios. `@smoke @P1` applies only to the first.

### Multiple TestRunners for Tag Sets

```java
// SmokeTestRunner.java
@CucumberOptions(tags = "@smoke", plugin = {"html:target/smoke-report.html"})
public class SmokeTestRunner extends AbstractTestNGCucumberTests {}

// RegressionTestRunner.java
@CucumberOptions(tags = "@regression and not @wip", plugin = {"html:target/regression-report.html"})
public class RegressionTestRunner extends AbstractTestNGCucumberTests {}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Intermediate',
  ARRAY['Cucumber','BDD','Tags','Smoke','Regression','CI/CD'],
  true, 0
),

-- Q37
(
  'What are @ParameterType and custom Cucumber Expressions?',
  'cucumber-q037-parameter-type-custom-expressions',
  '@ParameterType lets you define custom named types in Cucumber Expressions (e.g., {color}, {user}), mapping string patterns from step text directly to Java objects. Cleaner than regex for complex parameter conversion.',
  $ans$
## @ParameterType — Custom Cucumber Expressions

### Problem Without Custom Types

```java
// Step text: When the user selects "ADMIN" role
@When("the user selects {string} role")
public void selectRole(String roleString) {
    Role role = Role.valueOf(roleString);  // manual conversion everywhere
    userPage.selectRole(role);
}
```

### Solution: @ParameterType

```java
import io.cucumber.java.ParameterType;

public class CustomTypes {

    // Define custom type {role} that maps string → enum
    @ParameterType("ADMIN|MANAGER|USER|GUEST")
    public Role role(String roleString) {
        return Role.valueOf(roleString);
    }

    // Custom type for date
    @ParameterType("\\d{4}-\\d{2}-\\d{2}")
    public LocalDate date(String dateString) {
        return LocalDate.parse(dateString);
    }

    // Custom type for money
    @ParameterType("\\$\\d+\\.?\\d*")
    public BigDecimal amount(String amountString) {
        return new BigDecimal(amountString.replace("$", ""));
    }
}
```

### Using Custom Types in Feature Files

```gherkin
Scenario: Admin creates new user
  When the admin assigns the ADMIN role to the new user
  Then the user should have ADMIN permissions

Scenario: Filter transactions by date
  When the user filters transactions from 2024-01-01 to 2024-12-31
  Then all transactions in that period should appear

Scenario: Apply discount
  When the user applies a discount of $15.00
  Then the cart total should reduce by $15.00
```

### Step Definitions Using Custom Types

```java
// Now uses {role} instead of {string}
@When("the admin assigns the {role} role to the new user")
public void assignRole(Role role) {
    // role is already a Role enum — no conversion needed
    adminPage.assignRole(role);
}

@When("the user filters transactions from {date} to {date}")
public void filterByDate(LocalDate from, LocalDate to) {
    // Already LocalDate objects — no parsing needed
    reportPage.setDateRange(from, to);
}

@When("the user applies a discount of {amount}")
public void applyDiscount(BigDecimal amount) {
    cartPage.applyDiscount(amount);
}
```

### Built-in Cucumber Expressions

```java
{string}    → "quoted text" → String
{int}       → 42           → Integer
{float}     → 3.14         → Float / Double
{word}      → singleword   → String
{bigdecimal}→ 9.99         → BigDecimal
{long}      → 123456789    → Long
{}          → anything     → String (anonymous)
```

### Cucumber Expression vs Regex

```java
// Cucumber Expression (simpler, recommended)
@When("the user enters {string} into the {word} field")

// Regex (more powerful, harder to read)
@When("^the user enters \"([^\"]*)\" into the (\\w+) field$")
```

Use Cucumber Expressions for most cases. Use Regex only when you need complex pattern matching that `{}` types can''t express.
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','ParameterType','Cucumber Expressions','Custom Types'],
  true, 0
),

-- Q38
(
  'How do you integrate Cucumber with Page Object Model (POM)?',
  'cucumber-q038-cucumber-pom-integration',
  'Cucumber + POM separates Gherkin step definitions from UI interaction logic. Step definitions call Page Object methods, Page Objects contain locators and actions, and Dependency Injection (PicoContainer) shares the driver between classes.',
  $ans$
## Cucumber + Page Object Model Integration

### Project Structure

```
src/
  test/
    java/
      pages/
        BasePage.java          ← shared driver methods
        LoginPage.java         ← login locators + actions
        DashboardPage.java     ← dashboard locators + actions
        CheckoutPage.java
      stepDefinitions/
        LoginSteps.java        ← calls LoginPage methods
        CheckoutSteps.java
      hooks/
        Hooks.java             ← @Before driver init, @After quit
      context/
        TestContext.java        ← shared state (PicoContainer)
      runners/
        TestRunner.java
```

### TestContext — Shared Driver via DI

```java
package context;

import org.openqa.selenium.WebDriver;
import pages.*;

public class TestContext {
    public WebDriver driver;
    public LoginPage loginPage;
    public DashboardPage dashboardPage;
    public CheckoutPage checkoutPage;

    public TestContext() {
        // driver initialized in @Before hook
    }
}
```

### Hooks.java — Driver Lifecycle

```java
package hooks;

import context.TestContext;
import io.cucumber.java.Before;
import io.cucumber.java.After;
import io.cucumber.java.Scenario;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import pages.*;

public class Hooks {

    private final TestContext ctx;

    public Hooks(TestContext ctx) {
        this.ctx = ctx;
    }

    @Before
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ctx.driver = new ChromeDriver();
        ctx.driver.manage().window().maximize();

        // Initialize all page objects with the same driver
        ctx.loginPage      = new LoginPage(ctx.driver);
        ctx.dashboardPage  = new DashboardPage(ctx.driver);
        ctx.checkoutPage   = new CheckoutPage(ctx.driver);
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] screenshot = ((TakesScreenshot) ctx.driver)
                .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Failure Screenshot");
        }
        ctx.driver.quit();
    }
}
```

### LoginPage.java — Page Object

```java
package pages;

import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LoginPage extends BasePage {

    @FindBy(id = "username")
    private WebElement usernameField;

    @FindBy(id = "password")
    private WebElement passwordField;

    @FindBy(css = "button[type='submit']")
    private WebElement loginButton;

    @FindBy(css = ".error-message")
    private WebElement errorMessage;

    public LoginPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void navigateTo(String url) {
        driver.get(url + "/login");
    }

    public void enterUsername(String username) {
        usernameField.clear();
        usernameField.sendKeys(username);
    }

    public void enterPassword(String password) {
        passwordField.clear();
        passwordField.sendKeys(password);
    }

    public void clickLogin() {
        loginButton.click();
    }

    public String getErrorMessage() {
        return errorMessage.getText();
    }
}
```

### LoginSteps.java — Step Definitions Call POM

```java
package stepDefinitions;

import context.TestContext;
import io.cucumber.java.en.*;
import static org.testng.Assert.*;

public class LoginSteps {

    private final TestContext ctx;

    public LoginSteps(TestContext ctx) {  // PicoContainer injects
        this.ctx = ctx;
    }

    @Given("the user is on the login page")
    public void navigateToLogin() {
        ctx.loginPage.navigateTo(System.getProperty("baseUrl", "https://example.com"));
    }

    @When("the user enters username {string} and password {string}")
    public void enterCredentials(String username, String password) {
        ctx.loginPage.enterUsername(username);
        ctx.loginPage.enterPassword(password);
    }

    @When("the user clicks the Login button")
    public void clickLogin() {
        ctx.loginPage.clickLogin();
    }

    @Then("the user should be on the dashboard")
    public void verifyDashboard() {
        assertTrue(ctx.driver.getTitle().contains("Dashboard"));
    }

    @Then("the error message {string} should be displayed")
    public void verifyError(String expected) {
        assertEquals(expected, ctx.loginPage.getErrorMessage());
    }
}
```

### Feature File

```gherkin
Feature: User Login

  @smoke @P1
  Scenario: Login with valid credentials
    Given the user is on the login page
    When the user enters username "admin@test.com" and password "Admin@123"
    And the user clicks the Login button
    Then the user should be on the dashboard

  @regression
  Scenario: Login with invalid password
    Given the user is on the login page
    When the user enters username "admin@test.com" and password "wrong"
    And the user clicks the Login button
    Then the error message "Invalid credentials" should be displayed
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Page Object Model','POM','PicoContainer','Step Definition'],
  true, 0
),

-- Q39
(
  'How do you implement Dependency Injection in Cucumber using PicoContainer?',
  'cucumber-q039-dependency-injection-picocontainer',
  'PicoContainer is Cucumber''s built-in DI framework. Add the cucumber-picocontainer dependency, create a shared context class, and inject it via constructor parameters into all step definition classes that need it.',
  $ans$
## Dependency Injection with PicoContainer in Cucumber

### Why DI Is Needed

When you split step definitions across multiple classes (LoginSteps, CheckoutSteps, etc.), each class needs access to the **same WebDriver instance** and shared state. Without DI, you would use static variables — which are not thread-safe and cause issues in parallel execution.

PicoContainer solves this by creating **one instance per scenario** of each class and injecting it automatically.

### Step 1: Add Dependency

```xml
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-picocontainer</artifactId>
    <version>7.15.0</version>
    <scope>test</scope>
</dependency>
```

### Step 2: Create the Shared Context

```java
package context;

import org.openqa.selenium.WebDriver;

public class ScenarioContext {
    // Shared driver
    public WebDriver driver;

    // Shared test data between step classes
    public String authToken;
    public String orderId;
    public String userId;

    // Store data dynamically
    private Map<String, Object> context = new HashMap<>();

    public void set(String key, Object value) {
        context.put(key, value);
    }

    public Object get(String key) {
        return context.get(key);
    }
}
```

### Step 3: Inject into Step Definitions

```java
public class LoginSteps {
    private final ScenarioContext ctx;

    // PicoContainer sees this constructor and auto-injects ScenarioContext
    public LoginSteps(ScenarioContext ctx) {
        this.ctx = ctx;
    }

    @Given("the user logs in as {string}")
    public void login(String username) {
        ctx.driver.findElement(By.id("user")).sendKeys(username);
        ctx.driver.findElement(By.id("login")).click();
        ctx.authToken = getTokenFromCookie();  // store for other steps
    }
}

public class CheckoutSteps {
    private final ScenarioContext ctx;

    public CheckoutSteps(ScenarioContext ctx) {
        this.ctx = ctx;
    }

    @When("the user places an order")
    public void placeOrder() {
        // Uses same driver instance
        // Uses authToken set by LoginSteps
        apiClient.createOrder(ctx.authToken, productId);
    }
}

public class Hooks {
    private final ScenarioContext ctx;

    public Hooks(ScenarioContext ctx) {
        this.ctx = ctx;
    }

    @Before
    public void setUp() {
        ctx.driver = new ChromeDriver();  // one driver per scenario
    }

    @After
    public void tearDown() {
        ctx.driver.quit();
        // ctx is discarded — fresh context for next scenario
    }
}
```

### How PicoContainer Works Internally

```
1. Scenario starts
2. PicoContainer creates ONE instance of ScenarioContext
3. Finds all step definition classes referenced in the scenario
4. Creates ONE instance of each step class, injecting the SAME ScenarioContext
5. All step classes share the same driver, same state
6. Scenario ends → PicoContainer discards all objects
7. Next scenario → fresh objects created
```

### Without DI vs With DI

```java
// WITHOUT DI (anti-pattern)
public class LoginSteps {
    static WebDriver driver;  // ← static = not thread-safe
}

// WITH DI (correct)
public class LoginSteps {
    private final ScenarioContext ctx;  // ← injected = thread-safe
    public LoginSteps(ScenarioContext ctx) { this.ctx = ctx; }
}
```

### Other DI Frameworks Supported

| Framework | Dependency |
|---|---|
| PicoContainer | `cucumber-picocontainer` (simplest) |
| Spring | `cucumber-spring` |
| Guice | `cucumber-guice` |
| CDI | `cucumber-cdi2` |

PicoContainer requires zero configuration — just add the dependency and use constructors.
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','PicoContainer','Dependency Injection','Thread Safe','Parallel'],
  true, 0
),

-- Q40
(
  'How do you run Cucumber tests in parallel?',
  'cucumber-q040-parallel-execution',
  'Cucumber parallel execution uses AbstractTestNGCucumberTests with @DataProvider(parallel=true). Each scenario runs in a separate thread. Use ThreadLocal WebDriver via PicoContainer to avoid driver sharing between threads.',
  $ans$
## Cucumber Parallel Execution

### Method 1: TestNG DataProvider (Scenario-level Parallel)

```java
package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;
import org.testng.annotations.DataProvider;

@CucumberOptions(
    features = "src/test/resources/features",
    glue = {"stepDefinitions", "hooks"},
    plugin = {
        "pretty",
        "html:target/cucumber-parallel-report.html",
        "json:target/cucumber-parallel.json"
    },
    monochrome = true
)
public class ParallelTestRunner extends AbstractTestNGCucumberTests {

    @Override
    @DataProvider(parallel = true)  // ← THIS enables parallelism
    public Object[][] scenarios() {
        return super.scenarios();
    }
}
```

### testng.xml for Thread Count

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.9.dtd">
<suite name="Cucumber Parallel Suite" parallel="methods" thread-count="5">
    <test name="Parallel Cucumber Tests">
        <classes>
            <class name="runners.ParallelTestRunner"/>
        </classes>
    </test>
</suite>
```

### Thread-Safe WebDriver with PicoContainer

```java
// ScenarioContext.java — new instance per scenario (PicoContainer guarantees this)
public class ScenarioContext {
    public WebDriver driver;  // each scenario gets its OWN instance
}

// Hooks.java
public class Hooks {
    private final ScenarioContext ctx;

    public Hooks(ScenarioContext ctx) { this.ctx = ctx; }

    @Before
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage");
        ctx.driver = new ChromeDriver(options);  // each thread gets its own driver
        ctx.driver.manage().window().maximize();
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] screenshot = ((TakesScreenshot) ctx.driver)
                .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Failure");
        }
        ctx.driver.quit();
    }
}
```

### Method 2: Feature-Level Parallel with Multiple Runners

```java
// Runner1.java — runs login.feature
@CucumberOptions(features = "src/test/resources/features/login.feature", ...)
public class Runner1 extends AbstractTestNGCucumberTests {}

// Runner2.java — runs checkout.feature
@CucumberOptions(features = "src/test/resources/features/checkout.feature", ...)
public class Runner2 extends AbstractTestNGCucumberTests {}
```

```xml
<!-- Run both in parallel -->
<suite name="Feature Parallel" parallel="tests" thread-count="2">
    <test name="Login">
        <classes><class name="runners.Runner1"/></classes>
    </test>
    <test name="Checkout">
        <classes><class name="runners.Runner2"/></classes>
    </test>
</suite>
```

### Method 3: Cucumber-JVM-Parallel-Plugin (Older Projects)

```xml
<plugin>
    <groupId>com.github.temyers</groupId>
    <artifactId>cucumber-jvm-parallel-plugin</artifactId>
    <version>5.0.0</version>
    <executions>
        <execution>
            <goals><goal>generateRunners</goal></goals>
            <configuration>
                <parallelScheme>SCENARIO</parallelScheme>
                <glue>stepDefinitions</glue>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### Common Parallel Issues and Fixes

| Issue | Cause | Fix |
|---|---|---|
| Driver NullPointerException | Sharing driver across threads | Use PicoContainer DI |
| Screenshots missing | Wrong driver reference | Always use `ctx.driver` |
| Flaky test results | Race condition in static fields | Remove all static state |
| Report missing scenarios | Concurrent file write | Use JSON + merge plugin |

### Merging Parallel Reports

```xml
<!-- masterthought plugin merges parallel JSON reports -->
<plugin>
    <groupId>net.masterthought</groupId>
    <artifactId>maven-cucumber-reporting</artifactId>
    <version>5.8.1</version>
    <executions>
        <execution>
            <goals><goal>generate</goal></goals>
            <configuration>
                <projectName>AutomateQA</projectName>
                <outputDirectory>target/cucumber-html-reports</outputDirectory>
                <jsonFiles>
                    <param>target/**/*.json</param>
                </jsonFiles>
            </configuration>
        </execution>
    </executions>
</plugin>
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Parallel Execution','TestNG','Thread Safe','DataProvider'],
  true, 0
),

-- Q41
(
  'How do you generate Cucumber HTML reports using the Masterthought plugin?',
  'cucumber-q041-masterthought-cucumber-reports',
  'The Masterthought maven-cucumber-reporting plugin generates rich HTML reports from Cucumber JSON output. Configure it in pom.xml to run after tests, merge multiple JSON files, and produce a dashboard with charts and scenario details.',
  $ans$
## Cucumber HTML Reports with Masterthought Plugin

### Why Masterthought?

The default Cucumber `html` plugin generates basic reports. The **Masterthought** (net.masterthought) plugin generates **enterprise-grade** reports with:
- Dashboard with pass/fail charts
- Feature-level breakdown
- Scenario timeline
- Expandable step details
- Screenshot embedding
- Trend tracking

### Step 1: Generate JSON Output First

```java
@CucumberOptions(
    plugin = {
        "pretty",
        "json:target/cucumber-reports/cucumber.json"  // ← required input
    }
)
public class TestRunner extends AbstractTestNGCucumberTests {}
```

### Step 2: Add Maven Plugin

```xml
<plugin>
    <groupId>net.masterthought</groupId>
    <artifactId>maven-cucumber-reporting</artifactId>
    <version>5.8.1</version>
    <executions>
        <execution>
            <id>execution</id>
            <phase>verify</phase>  <!-- runs after test phase -->
            <goals>
                <goal>generate</goal>
            </goals>
            <configuration>
                <projectName>AutomateQA-BDD</projectName>
                <skip>false</skip>
                <outputDirectory>target/cucumber-html-reports</outputDirectory>
                <jsonFiles>
                    <param>target/cucumber-reports/cucumber.json</param>
                    <!-- multiple JSON files for parallel runs -->
                    <param>target/cucumber-reports/cucumber2.json</param>
                </jsonFiles>
                <!-- Optional: classify builds -->
                <classifications>
                    <Branch>main</Branch>
                    <Environment>Staging</Environment>
                    <Browser>Chrome</Browser>
                </classifications>
                <mergeFeaturesById>true</mergeFeaturesById>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### Run and View

```bash
# Run tests + generate report
mvn clean verify

# Report location
target/cucumber-html-reports/overview-features.html
```

### Using Allure for Even Richer Reports

```xml
<!-- pom.xml -->
<dependency>
    <groupId>io.qameta.allure</groupId>
    <artifactId>allure-cucumber7-jvm</artifactId>
    <version>2.25.0</version>
</dependency>
```

```java
@CucumberOptions(
    plugin = {
        "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm",
        "json:target/cucumber.json"
    }
)
```

```bash
# Generate and serve Allure report
mvn allure:serve
```

### Allure Annotations in Step Definitions

```java
import io.qameta.allure.Allure;
import io.qameta.allure.Step;

public class LoginSteps {

    @Step("User navigates to login page")
    @Given("the user is on the login page")
    public void navigateToLogin() {
        driver.get(baseUrl + "/login");
        Allure.addAttachment("Page URL", driver.getCurrentUrl());
    }

    @Step("User enters credentials: {username}")
    @When("the user enters username {string} and password {string}")
    public void enterCredentials(String username, String password) {
        loginPage.enterUsername(username);
        loginPage.enterPassword(password);
    }
}
```

### Jenkins Integration

```groovy
// Jenkinsfile
stage('Test') {
    steps {
        sh 'mvn clean verify'
    }
    post {
        always {
            cucumber(
                fileIncludePattern: '**/cucumber.json',
                jsonReportDirectory: 'target/cucumber-reports',
                reportTitle: 'AutomateQA BDD Report'
            )
        }
    }
}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Masterthought','Allure','HTML Report','Jenkins'],
  true, 0
),

-- Q42
(
  'How do you use Cucumber with REST Assured for API testing in BDD?',
  'cucumber-q042-cucumber-rest-assured-api',
  'Cucumber + REST Assured enables API testing with business-readable Gherkin. Feature files describe API behavior, step definitions use REST Assured to send requests and validate responses, with no browser or Selenium needed.',
  $ans$
## Cucumber + REST Assured for API BDD Testing

### Dependencies

```xml
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.4.0</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-java</artifactId>
    <version>7.15.0</version>
    <scope>test</scope>
</dependency>
```

### Feature File — API in Gherkin

```gherkin
Feature: User Management API

  @api @smoke
  Scenario: Create a new user via POST
    Given the API base URL is "https://api.example.com"
    When I send a POST request to "/users" with body:
      | name  | John Doe         |
      | email | john@example.com |
      | role  | USER             |
    Then the response status code should be 201
    And the response body should contain "userId"
    And the response "name" field should equal "John Doe"

  @api @regression
  Scenario: Get user by ID
    Given the API base URL is "https://api.example.com"
    And a user with ID "101" exists
    When I send a GET request to "/users/101"
    Then the response status code should be 200
    And the response "email" field should equal "john@example.com"

  @api @negative
  Scenario: Create user with missing email returns 400
    Given the API base URL is "https://api.example.com"
    When I send a POST request to "/users" with body:
      | name | Jane Doe |
    Then the response status code should be 400
    And the response "error" field should contain "email is required"
```

### Step Definitions with REST Assured

```java
package stepDefinitions;

import io.cucumber.java.en.*;
import io.cucumber.datatable.DataTable;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;
import static org.testng.Assert.*;

public class ApiSteps {

    private Response response;
    private RequestSpecification request;
    private String baseUrl;

    @Given("the API base URL is {string}")
    public void setBaseUrl(String url) {
        this.baseUrl = url;
        RestAssured.baseURI = url;

        request = given()
            .header("Content-Type", "application/json")
            .header("Accept", "application/json");
    }

    @When("I send a POST request to {string} with body:")
    public void sendPostRequest(String endpoint, DataTable dataTable) {
        Map<String, String> body = dataTable.asMap(String.class, String.class);
        response = request
            .body(body)
            .when()
            .post(endpoint)
            .then()
            .extract().response();
    }

    @When("I send a GET request to {string}")
    public void sendGetRequest(String endpoint) {
        response = request
            .when()
            .get(endpoint)
            .then()
            .extract().response();
    }

    @Then("the response status code should be {int}")
    public void verifyStatusCode(int expectedCode) {
        assertEquals(expectedCode, response.getStatusCode(),
            "Status code mismatch. Body: " + response.getBody().asString());
    }

    @Then("the response body should contain {string}")
    public void verifyBodyContains(String key) {
        assertNotNull(response.jsonPath().get(key),
            "Key '" + key + "' not found in response");
    }

    @Then("the response {string} field should equal {string}")
    public void verifyFieldValue(String field, String expected) {
        String actual = response.jsonPath().getString(field);
        assertEquals(expected, actual);
    }

    @Then("the response {string} field should contain {string}")
    public void verifyFieldContains(String field, String expected) {
        String actual = response.jsonPath().getString(field);
        assertTrue(actual.contains(expected));
    }
}
```

### API Context for Chaining Scenarios

```java
// Share response data between steps within one scenario
public class ApiContext {
    public Response lastResponse;
    public String extractedId;
    public String authToken;
    public Map<String, String> requestHeaders = new HashMap<>();
}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','REST Assured','API Testing','Gherkin','DataTable'],
  true, 0
),

-- Q43
(
  'What is dryRun in Cucumber and when should you use it?',
  'cucumber-q043-dry-run',
  'dryRun=true makes Cucumber scan all feature file steps and check if matching step definitions exist — without actually executing any test. Use it after writing feature files to catch undefined or missing step definitions early.',
  $ans$
## dryRun in Cucumber

### What It Does

When `dryRun = true`, Cucumber:
1. Reads all `.feature` files
2. Tries to match each step to a step definition method
3. Reports any **undefined** or **ambiguous** steps
4. **Does NOT execute** any actual test code

### Enable dryRun

```java
@CucumberOptions(
    features = "src/test/resources/features",
    glue = {"stepDefinitions"},
    dryRun = true   // ← enable dry run
)
public class DryRunRunner extends AbstractTestNGCucumberTests {}
```

### When to Use dryRun

| Situation | Use dryRun? |
|---|---|
| Just wrote new feature files | Yes — check all steps are defined |
| Onboarding new feature area | Yes — verify step coverage |
| Refactored step definition text | Yes — ensure nothing broke |
| Normal CI regression run | No |
| Debugging a specific test failure | No |

### dryRun Output Example

```
Undefined scenarios:
  src/test/resources/features/payment.feature:15 # Pay with PayPal

Undefined step definitions:
@Given("the user selects PayPal as payment method")
public void theUserSelectsPayPal() {
    // Write code here
    throw new io.cucumber.java.PendingException();
}
```

Cucumber even generates the **skeleton method** for missing steps.

### dryRun vs Normal Run Comparison

```
dryRun = true:
  ✓ Finds undefined steps (no step definition found)
  ✓ Finds ambiguous steps (multiple step definitions match)
  ✓ Fast — no browser, no network, no WebDriver
  ✗ Does NOT validate step logic
  ✗ Does NOT confirm test passes

dryRun = false (normal):
  ✓ Executes every step
  ✓ Validates actual application behavior
  ✗ Takes full execution time
  ✗ Requires browser/app
```

### Common Workflow

```bash
# Step 1: Write feature files
# Step 2: dryRun to find what step defs are needed
mvn test -Pcucumber-dryrun

# Step 3: Write step definitions for undefined steps
# Step 4: dryRun again to confirm all steps are defined
# Step 5: Normal run
mvn test
```

### Maven Profile for dryRun

```xml
<profiles>
    <profile>
        <id>cucumber-dryrun</id>
        <build>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-surefire-plugin</artifactId>
                    <configuration>
                        <systemPropertyVariables>
                            <cucumber.options>--dry-run</cucumber.options>
                        </systemPropertyVariables>
                    </configuration>
                </plugin>
            </plugins>
        </build>
    </profile>
</profiles>
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','dryRun','Step Definition','Undefined Steps'],
  true, 0
),

-- Q44
(
  'How do you rerun only failed Cucumber scenarios?',
  'cucumber-q044-rerun-failed-scenarios',
  'Cucumber''s rerun plugin writes failed scenario locations to a .txt file. A second runner reads that file as the features path to re-execute only failed scenarios. This is essential for handling flakiness in CI pipelines.',
  $ans$
## Rerunning Failed Cucumber Scenarios

### Step 1: Primary Runner — Write Failed to File

```java
@CucumberOptions(
    features = "src/test/resources/features",
    glue = {"stepDefinitions", "hooks"},
    plugin = {
        "pretty",
        "html:target/reports/cucumber.html",
        "json:target/reports/cucumber.json",
        "rerun:target/rerun/failed_scenarios.txt"  // ← key plugin
    }
)
public class TestRunner extends AbstractTestNGCucumberTests {}
```

After test execution, `failed_scenarios.txt` contains:

```
src/test/resources/features/login.feature:15
src/test/resources/features/checkout.feature:42
src/test/resources/features/payment.feature:8
```

### Step 2: Rerun Runner — Use Failed File as Input

```java
@CucumberOptions(
    features = "@target/rerun/failed_scenarios.txt",  // ← @ prefix = file input
    glue = {"stepDefinitions", "hooks"},
    plugin = {
        "pretty",
        "html:target/reports/rerun-report.html",
        "json:target/reports/rerun.json"
    }
)
public class RerunTestRunner extends AbstractTestNGCucumberTests {}
```

### Maven Profiles for Rerun Flow

```xml
<profiles>
    <!-- Profile 1: Full run -->
    <profile>
        <id>regression</id>
        <properties>
            <runner>runners.TestRunner</runner>
        </properties>
    </profile>

    <!-- Profile 2: Rerun failures only -->
    <profile>
        <id>rerun</id>
        <properties>
            <runner>runners.RerunTestRunner</runner>
        </properties>
    </profile>
</profiles>
```

```bash
# Full run
mvn test -Pregression

# Rerun only failures
mvn test -Prerun
```

### Jenkins Pipeline — Automatic Rerun

```groovy
stage('Run Tests') {
    steps {
        sh 'mvn clean test -Pregression'
    }
}

stage('Rerun Failed Tests') {
    when {
        expression {
            fileExists('target/rerun/failed_scenarios.txt') &&
            readFile('target/rerun/failed_scenarios.txt').trim() != ''
        }
    }
    steps {
        sh 'mvn test -Prerun'
    }
}
```

### Maven Surefire rerunFailingTestsCount

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <rerunFailingTestsCount>2</rerunFailingTestsCount>  <!-- retry 2x -->
    </configuration>
</plugin>
```

### Comparison of Rerun Methods

| Method | Granularity | Setup |
|---|---|---|
| `rerun` plugin | Scenario-level | 2 runners needed |
| `rerunFailingTestsCount` | Method-level | pom.xml change only |
| Retry with `IRetryAnalyzer` | TestNG method | Java code needed |
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Rerun','Flaky Tests','Jenkins','CI/CD'],
  true, 0
),

-- Q45
(
  'What are Cucumber anti-patterns and BDD best practices?',
  'cucumber-q045-antipatterns-best-practices',
  'Common Cucumber anti-patterns include UI-speak in Gherkin, giant step definitions, sharing state via static variables, testing too many things in one scenario, and skipping the "3 Amigos" collaboration. Best practices are the opposite.',
  $ans$
## Cucumber Anti-Patterns and Best Practices

### Anti-Pattern 1: UI Implementation in Gherkin

```gherkin
-- BAD: Implementation details in feature file
When the user clicks the button with id "login-btn"
And waits 3 seconds for the page to load
Then the div with class "dashboard-content" should be visible

-- GOOD: Business behavior
When the user logs in with valid credentials
Then the dashboard should be accessible
```

### Anti-Pattern 2: One Monolithic Step Definition File

```java
// BAD: Everything in one file (500+ lines)
public class AllSteps {
    @Given("...")  // login step
    @When("...")   // checkout step
    @Then("...")   // admin step
    @Given("...")  // 50 more steps...
}

// GOOD: Split by feature domain
LoginSteps.java
CheckoutSteps.java
AdminSteps.java
CommonSteps.java
```

### Anti-Pattern 3: Static WebDriver

```java
// BAD: Not thread-safe, breaks parallel execution
public class StepDefs {
    public static WebDriver driver;
}

// GOOD: PicoContainer DI
public class StepDefs {
    private final ScenarioContext ctx;
    public StepDefs(ScenarioContext ctx) { this.ctx = ctx; }
}
```

### Anti-Pattern 4: Overloaded Scenarios

```gherkin
-- BAD: One scenario tests too many things
Scenario: Full application test
  Given user logs in
  When user adds product to cart
  And user applies coupon
  And user changes shipping address
  And user selects payment method
  And user places order
  And user checks order history
  And user logs out
  Then ... 30 more steps

-- GOOD: Focused scenarios
Scenario: User completes checkout
  Given the user has an item in their cart
  When the user completes checkout with standard shipping
  Then the order confirmation number should be generated
```

### Anti-Pattern 5: Skipping 3 Amigos

```
BAD workflow:
  QA writes all feature files alone
  → Dev implements without review
  → Feature files don't match real behavior
  → All tests fail

GOOD workflow:
  BA + Dev + QA session (3 Amigos)
  → Write Gherkin together
  → Dev confirms feasibility
  → QA confirms testability
  → BA confirms business accuracy
```

### Anti-Pattern 6: Fragile Locator-Dependent Steps

```gherkin
-- BAD: Couples scenario to locators
When the user clicks the 3rd li in the ul with id "nav-menu"

-- GOOD: Business-intent driven
When the user opens the settings menu
```

### Best Practices Summary

| Practice | Rule |
|---|---|
| Scenario focus | One business rule per scenario |
| Step reuse | Shared steps in `CommonSteps.java` |
| Tags | Always tag: `@smoke`, `@regression`, `@P1`, module tags |
| Background | Only shared Given steps (not When/Then) |
| Naming | Scenarios describe "what", not "how" |
| Data | Scenario Outline for data-driven, not hardcoded |
| DI | Always use PicoContainer, never static state |
| Hooks | Browser setup in @Before, not in feature files |
| Step count | Max 5–7 steps per scenario |
| File size | Max 10 scenarios per feature file |

### Scenario Writing Checklist

```
✓ Can a non-technical BA read and understand this?
✓ Does it describe behavior, not implementation?
✓ Does it have a clear pass/fail outcome in Then?
✓ Could it run independently of all other scenarios?
✓ Does it have the right tags?
✓ Is it under 7 steps?
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Best Practices','Anti-Patterns','3 Amigos','Code Quality'],
  true, 0
),

-- Q46
(
  'How do you manage environment-specific configuration in Cucumber?',
  'cucumber-q046-environment-configuration',
  'Use config.properties files per environment, read via System.getProperty() with -D Maven flags. A ConfigReader utility class loads the correct properties file based on the environment parameter passed at runtime.',
  $ans$
## Environment-Specific Configuration in Cucumber

### Project Structure

```
src/
  test/
    resources/
      config/
        config.dev.properties
        config.staging.properties
        config.prod.properties
      features/
        ...
```

### config.staging.properties

```properties
base.url=https://staging.example.com
api.base.url=https://api.staging.example.com
browser=chrome
timeout=15
db.url=jdbc:postgresql://staging-db:5432/testdb
db.user=testuser
db.password=stagingpass
```

### ConfigReader Utility

```java
package utils;

import java.io.*;
import java.util.Properties;

public class ConfigReader {

    private static Properties properties;

    static {
        String env = System.getProperty("env", "staging");  // default: staging
        String configFile = "src/test/resources/config/config." + env + ".properties";

        try (FileInputStream fis = new FileInputStream(configFile)) {
            properties = new Properties();
            properties.load(fis);
        } catch (IOException e) {
            throw new RuntimeException("Cannot load config: " + configFile, e);
        }
    }

    public static String get(String key) {
        String value = System.getProperty(key);  // CLI override takes priority
        return value != null ? value : properties.getProperty(key);
    }

    public static String getBaseUrl()    { return get("base.url"); }
    public static String getBrowser()    { return get("browser"); }
    public static int    getTimeout()    { return Integer.parseInt(get("timeout")); }
}
```

### Using ConfigReader in Hooks

```java
@Before
public void setUp() {
    String browser = ConfigReader.getBrowser();

    WebDriverManager.getInstance(
        browser.equalsIgnoreCase("firefox") ? FirefoxDriver.class : ChromeDriver.class
    ).setup();

    ctx.driver = browser.equalsIgnoreCase("firefox")
        ? new FirefoxDriver()
        : new ChromeDriver();

    ctx.driver.get(ConfigReader.getBaseUrl());
}
```

### Maven Run Commands

```bash
# Run against staging
mvn test -Denv=staging

# Run against dev
mvn test -Denv=dev -Dcucumber.filter.tags="@smoke"

# Override specific property
mvn test -Denv=staging -Dbase.url=https://my-feature-branch.example.com

# CI/CD pipeline
mvn test -Denv=${ENVIRONMENT} -Dcucumber.filter.tags="@smoke"
```

### Jenkins Build Parameters

```groovy
parameters {
    choice(name: 'ENVIRONMENT', choices: ['staging', 'dev', 'prod'], description: 'Target environment')
    choice(name: 'TAGS', choices: ['@smoke', '@regression', '@sanity'], description: 'Test suite to run')
}

stages {
    stage('Run Tests') {
        steps {
            sh "mvn clean test -Denv=${params.ENVIRONMENT} -Dcucumber.filter.tags='${params.TAGS}'"
        }
    }
}
```

### Multiple Environment Profiles in pom.xml

```xml
<profiles>
    <profile>
        <id>staging</id>
        <properties>
            <env>staging</env>
        </properties>
    </profile>
    <profile>
        <id>prod</id>
        <properties>
            <env>prod</env>
        </properties>
    </profile>
</profiles>
```

```bash
mvn test -Pstaging
mvn test -Pprod
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Configuration','Environment','Maven','Jenkins'],
  true, 0
),

-- Q47
(
  'How do you handle step definition ambiguity in Cucumber?',
  'cucumber-q047-step-ambiguity',
  'Step ambiguity occurs when multiple step definitions match the same Gherkin step. Fix it by making regex/expressions more specific, renaming steps, using {string} type anchors, or restructuring into unambiguous wording.',
  $ans$
## Step Definition Ambiguity in Cucumber

### What Is Ambiguity?

An **AmbiguousStepDefinitionException** is thrown when Cucumber finds **two or more** step definition methods whose expression/regex matches the same Gherkin step text.

```
io.cucumber.ambiguity.AmbiguousStepDefinitionsException:
"When the user clicks the button" matches more than one step definition:
  - "the user clicks the button" in LoginSteps.java:25
  - "the user clicks the {word} button" in CommonSteps.java:40
```

### Root Cause Example

```java
// LoginSteps.java
@When("the user clicks the button")
public void clickButton() { ... }

// CommonSteps.java
@When("the user clicks the {word} button")
public void clickNamedButton(String buttonName) { ... }
```

When feature file has: `When the user clicks the button`
→ BOTH match → ambiguity error.

### Fix 1: Make Expressions More Specific

```java
// Be explicit — add context to the step text
@When("the user clicks the login submit button")
public void clickLoginButton() { ... }

@When("the user clicks the {word} action button")
public void clickActionButton(String buttonName) { ... }
```

### Fix 2: Use Anchors in Regex

```java
// BAD — too broad
@When("clicks the button")
// matches "When the user clicks the button" and "When admin clicks the button"

// GOOD — anchored
@When("^the user clicks the submit button$")
public void clickSubmitButton() { ... }
```

### Fix 3: Consolidate into One Flexible Method

```java
// Replace both conflicting steps with one
@When("the user clicks the {string} button")
public void clickButton(String buttonLabel) {
    if (buttonLabel.equalsIgnoreCase("login")) {
        loginPage.clickLoginButton();
    } else if (buttonLabel.equalsIgnoreCase("register")) {
        registerPage.clickRegisterButton();
    }
}
```

### Fix 4: Rename Conflicting Step Text

Update both the feature file AND step definition to use unique language:

```gherkin
-- Before (ambiguous)
When the user clicks the button

-- After (unambiguous)
When the user submits the login form
```

```java
@When("the user submits the login form")
public void submitLoginForm() { ... }
```

### How to Detect Ambiguity Early

```java
// Run with dryRun=true
@CucumberOptions(dryRun = true)
```

dryRun will catch ambiguous steps before any actual test runs.

### Best Practice: Consistent Naming Convention

```
Given the <actor> is on the <page> page
When the <actor> clicks the <label> button
When the <actor> enters <value> in the <field> field
Then the <element> should <matcher> <expected>
```

Consistent patterns prevent ambiguity from arising in the first place.
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Intermediate',
  ARRAY['Cucumber','BDD','Step Definition','Ambiguity','Debugging','Gherkin'],
  true, 0
),

-- Q48
(
  'How do you implement soft assertions in Cucumber?',
  'cucumber-q048-soft-assertions',
  'Use TestNG SoftAssert — instantiate it in the step definition or context class, call softAssert.assertEquals() for non-blocking assertions, and call softAssert.assertAll() in the @Then or @After step to fail the scenario if any assertion failed.',
  $ans$
## Soft Assertions in Cucumber

### Why Soft Assertions?

**Hard assertions** (default) stop the test at the first failure — you miss all other failures in that scenario. **Soft assertions** collect all failures and report them together at the end.

```gherkin
Scenario: Verify user profile details
  Given the user is logged in
  When the user opens the profile page
  Then the name should be "John Doe"
  And the email should be "john@example.com"
  And the phone should be "9876543210"
  And the role should be "ADMIN"
  -- With hard assert: stops at first wrong field
  -- With soft assert: checks ALL fields, reports ALL failures at once
```

### Method 1: SoftAssert in Context (Recommended)

```java
// ScenarioContext.java
public class ScenarioContext {
    public WebDriver driver;
    public SoftAssert softAssert = new SoftAssert();  // one per scenario
}

// Step definitions use ctx.softAssert
public class ProfileSteps {
    private final ScenarioContext ctx;

    public ProfileSteps(ScenarioContext ctx) { this.ctx = ctx; }

    @Then("the name should be {string}")
    public void verifyName(String expected) {
        String actual = profilePage.getName();
        ctx.softAssert.assertEquals(actual, expected, "Name mismatch");
    }

    @Then("the email should be {string}")
    public void verifyEmail(String expected) {
        String actual = profilePage.getEmail();
        ctx.softAssert.assertEquals(actual, expected, "Email mismatch");
    }

    @Then("the role should be {string}")
    public void verifyRole(String expected) {
        String actual = profilePage.getRole();
        ctx.softAssert.assertEquals(actual, expected, "Role mismatch");
    }
}

// Hooks.java — trigger assertAll after EVERY scenario
public class Hooks {
    private final ScenarioContext ctx;

    public Hooks(ScenarioContext ctx) { this.ctx = ctx; }

    @After(order = 1)  // runs before driver quit
    public void assertAll() {
        ctx.softAssert.assertAll();  // throws if any soft assertion failed
    }

    @After(order = 0)  // runs last
    public void tearDown() {
        ctx.driver.quit();
    }
}
```

### Method 2: Local SoftAssert Per Step

```java
@Then("all product details should be correct")
public void verifyAllProductDetails() {
    SoftAssert sa = new SoftAssert();

    sa.assertEquals(productPage.getName(), "Laptop Pro", "Name wrong");
    sa.assertEquals(productPage.getPrice(), "$999", "Price wrong");
    sa.assertTrue(productPage.isInStock(), "Should be in stock");
    sa.assertEquals(productPage.getRating(), "4.5/5", "Rating wrong");

    sa.assertAll();  // fail here if any assertion above failed
}
```

### Method 3: JUnit 5 SoftAssertions (Assertj)

```java
import org.assertj.core.api.SoftAssertions;

@Then("all dashboard metrics should be correct")
public void verifyDashboard() {
    SoftAssertions softly = new SoftAssertions();

    softly.assertThat(dashboardPage.getTotalOrders()).isEqualTo(150);
    softly.assertThat(dashboardPage.getPendingOrders()).isLessThan(20);
    softly.assertThat(dashboardPage.getRevenue()).startsWith("$");

    softly.assertAll();  // reports all failures
}
```

### Hook Order for assertAll

```java
// IMPORTANT: order value — HIGHER number runs FIRST in @After
@After(order = 100)
public void runSoftAssertions() {
    ctx.softAssert.assertAll();  // must run BEFORE driver.quit()
}

@After(order = 0)
public void closeDriver() {
    ctx.driver.quit();           // runs AFTER assertAll
}
```

If `driver.quit()` runs before `assertAll()`, screenshots of failures are impossible.
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Intermediate',
  ARRAY['Cucumber','BDD','SoftAssert','Assertions','TestNG','Verification'],
  true, 0
),

-- Q49
(
  'How do you handle dynamic test data (random emails, unique IDs) in Cucumber?',
  'cucumber-q049-dynamic-test-data',
  'Store dynamic values in the ScenarioContext during a When step and reference them in subsequent Then steps. Use Faker library for realistic random data, UUID for unique IDs, and Timestamp for unique emails.',
  $ans$
## Dynamic Test Data in Cucumber

### The Problem

```gherkin
-- This fails on second run because email already exists:
When the user registers with email "test@example.com"
```

### Solution 1: Faker Library for Realistic Random Data

```xml
<dependency>
    <groupId>net.datafaker</groupId>
    <artifactId>datafaker</artifactId>
    <version>2.1.0</version>
</dependency>
```

```java
import net.datafaker.Faker;

public class TestDataGenerator {
    private static final Faker faker = new Faker();

    public static String randomEmail() {
        return faker.internet().emailAddress();
        // → "john.smith.7g3k@example.org"
    }

    public static String randomName() {
        return faker.name().fullName();
        // → "Jane Williams"
    }

    public static String randomPhone() {
        return faker.phoneNumber().cellPhone();
        // → "9876543210"
    }

    public static String uniqueEmail(String prefix) {
        return prefix + System.currentTimeMillis() + "@test.com";
        // → "qa1718123456789@test.com"
    }

    public static String randomPassword() {
        return "Test@" + faker.number().digits(6);
        // → "Test@847291"
    }
}
```

### Solution 2: Store Dynamic Data in ScenarioContext

```java
// ScenarioContext.java
public class ScenarioContext {
    public WebDriver driver;
    public String registeredEmail;
    public String generatedOrderId;
    public String createdUserId;
}

// Step definitions
public class RegistrationSteps {
    private final ScenarioContext ctx;
    public RegistrationSteps(ScenarioContext ctx) { this.ctx = ctx; }

    @When("the user registers with a unique email")
    public void registerWithUniqueEmail() {
        ctx.registeredEmail = TestDataGenerator.uniqueEmail("qa");
        registrationPage.enterEmail(ctx.registeredEmail);
        registrationPage.submit();
    }

    @Then("the confirmation email should be sent to the registered address")
    public void verifyConfirmationEmail() {
        // Use ctx.registeredEmail — the same unique value
        emailClient.waitForEmail(ctx.registeredEmail, "Registration Confirmation");
    }
}
```

### Solution 3: Feature File with Placeholder Indication

```gherkin
Scenario: Register with unique credentials
  When the user registers with a unique email address
  And the user completes registration
  Then the welcome email should be sent to the registered email

-- NOT:
-- When the user registers with email "fixed@test.com"
```

### Solution 4: Scenario Outline with Multiple Pre-set Data Points

```gherkin
Scenario Outline: Register different user types
  When the user registers as "<role>" with email "<email>"
  Then the user should be assigned the "<role>" permissions

  Examples:
    | role    | email                         |
    | ADMIN   | admin.test@qa-team.com        |
    | MANAGER | manager.test@qa-team.com      |
    | USER    | user.test@qa-team.com         |
```

Use **dedicated test email domains** that your team controls.

### Solution 5: API-Based Test Data Setup

```java
@Before("@needs-user")
public void createTestUserViaApi() {
    String uniqueEmail = TestDataGenerator.uniqueEmail("api");
    Response resp = given()
        .body(Map.of("email", uniqueEmail, "role", "USER"))
        .post("/api/users");

    ctx.createdUserId = resp.jsonPath().getString("id");
    ctx.registeredEmail = uniqueEmail;
}

@After("@needs-user")
public void deleteTestUserViaApi() {
    if (ctx.createdUserId != null) {
        delete("/api/users/" + ctx.createdUserId);
    }
}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Test Data','Faker','Dynamic Data','ScenarioContext'],
  true, 0
),

-- Q50
(
  'How do you integrate Cucumber with Jenkins CI/CD pipeline?',
  'cucumber-q050-cucumber-jenkins-cicd',
  'Integrate Cucumber with Jenkins by adding a Maven build step running mvn clean verify, publishing HTML/JSON reports via the Cucumber Reports plugin, sending Slack notifications on failure, and triggering on every PR merge.',
  $ans$
## Cucumber + Jenkins CI/CD Integration

### Jenkins Pipeline (Declarative)

```groovy
pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['staging', 'dev'], description: 'Target environment')
        choice(name: 'TAGS', choices: ['@smoke', '@regression', '@sanity'], description: 'Test suite')
        choice(name: 'BROWSER', choices: ['chrome', 'firefox'], description: 'Browser')
    }

    environment {
        MAVEN_OPTS = '-Xmx1024m'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/org/automateqa.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile -q'
            }
        }

        stage('Run Cucumber Tests') {
            steps {
                sh """
                    mvn test \
                        -Denv=${params.ENV} \
                        -Dcucumber.filter.tags="${params.TAGS}" \
                        -Dbrowser=${params.BROWSER} \
                        -Dmaven.test.failure.ignore=true
                """
            }
        }

        stage('Rerun Failed Tests') {
            when {
                expression {
                    fileExists('target/rerun/failed_scenarios.txt') &&
                    readFile('target/rerun/failed_scenarios.txt').trim() != ''
                }
            }
            steps {
                sh 'mvn test -Prerun -Dmaven.test.failure.ignore=true'
            }
        }

        stage('Publish Reports') {
            steps {
                sh 'mvn verify -DskipTests'  // triggers masterthought plugin
            }
        }
    }

    post {
        always {
            // Publish Cucumber HTML report
            cucumber(
                fileIncludePattern: '**/cucumber.json',
                jsonReportDirectory: 'target/cucumber-reports',
                reportTitle: 'AutomateQA BDD Report'
            )

            // Archive reports
            archiveArtifacts artifacts: 'target/cucumber-html-reports/**/*', allowEmptyArchive: true
        }

        failure {
            // Slack notification on failure
            slackSend(
                channel: '#qa-alerts',
                color: 'danger',
                message: """
                    🔴 Cucumber Tests FAILED
                    Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}
                    Environment: ${params.ENV}
                    Tags: ${params.TAGS}
                    Report: ${env.BUILD_URL}cucumber-html-reports/overview-features.html
                """.stripIndent()
            )
        }

        success {
            slackSend(
                channel: '#qa-alerts',
                color: 'good',
                message: "✅ ${params.TAGS} passed on ${params.ENV} — Build #${env.BUILD_NUMBER}"
            )
        }
    }
}
```

### Jenkins Cucumber Reports Plugin

```
Jenkins → Manage Plugins → Available → "Cucumber Reports" → Install
```

Adds a **"Cucumber Reports"** link to each build with:
- Dashboard (pass/fail chart)
- Feature breakdown
- Scenario details
- Failure stack traces

### Trigger Strategy

```groovy
triggers {
    // On every PR merge to main
    githubPush()

    // Nightly regression
    cron('0 22 * * *')  // 10 PM daily

    // Scheduled smoke after deployment
    upstream(upstreamProjects: 'deploy-to-staging', threshold: hudson.model.Result.SUCCESS)
}
```

### Maven pom.xml CI Configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <!-- Don't fail build on test failure — Jenkins handles it -->
        <testFailureIgnore>true</testFailureIgnore>
        <suiteXmlFiles>
            <suiteXmlFile>testng.xml</suiteXmlFile>
        </suiteXmlFiles>
    </configuration>
</plugin>
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Jenkins','CI/CD','Pipeline','Slack','Automation'],
  true, 0
),

-- Q51
(
  'How do you handle AJAX/dynamic content and waits in Cucumber step definitions?',
  'cucumber-q051-ajax-dynamic-waits',
  'Use WebDriverWait with ExpectedConditions in step definitions or a BasePage waitFor() utility. Never use Thread.sleep(). Create reusable wait methods in BasePage that all Page Objects inherit, keeping step definitions clean.',
  $ans$
## Handling AJAX and Dynamic Content in Cucumber

### The Problem

```gherkin
When the user clicks "Search"
Then the results should show "15 products"
-- AJAX loads results asynchronously — immediate assertion fails
```

### Solution: WebDriverWait in BasePage (not in step defs)

```java
// BasePage.java — shared wait utilities
public class BasePage {

    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
    }

    protected WebElement waitForVisible(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    protected WebElement waitForClickable(By locator) {
        return wait.until(ExpectedConditions.elementToBeClickable(locator));
    }

    protected void waitForTextToBe(By locator, String expectedText) {
        wait.until(ExpectedConditions.textToBe(locator, expectedText));
    }

    protected void waitForInvisible(By locator) {
        wait.until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }

    protected void waitForAjax() {
        wait.until(driver -> ((JavascriptExecutor) driver)
            .executeScript("return jQuery.active").equals(0L));
    }

    protected void waitForPageLoad() {
        wait.until(driver -> ((JavascriptExecutor) driver)
            .executeScript("return document.readyState").equals("complete"));
    }

    protected WebElement waitForPresent(By locator) {
        return wait.until(ExpectedConditions.presenceOfElementLocated(locator));
    }
}
```

### Page Object Uses Wait (Clean Step Defs)

```java
// SearchPage.java
public class SearchPage extends BasePage {

    public SearchPage(WebDriver driver) {
        super(driver);
    }

    public void search(String keyword) {
        waitForClickable(By.id("searchBox")).sendKeys(keyword);
        waitForClickable(By.id("searchBtn")).click();
        waitForInvisible(By.css(".loading-spinner"));  // wait for spinner to go away
    }

    public int getResultCount() {
        String countText = waitForVisible(By.css(".result-count")).getText();
        // "Showing 15 products" → extract 15
        return Integer.parseInt(countText.replaceAll("[^0-9]", ""));
    }
}

// SearchSteps.java — clean, no waits here
public class SearchSteps {

    @When("the user searches for {string}")
    public void search(String keyword) {
        ctx.searchPage.search(keyword);  // wait is inside searchPage
    }

    @Then("the results should show {int} products")
    public void verifyResultCount(int expected) {
        assertEquals(expected, ctx.searchPage.getResultCount());
    }
}
```

### Feature File stays clean

```gherkin
Scenario: Search for products
  Given the user is on the product catalog page
  When the user searches for "laptop"
  Then the results should show 15 products
  And the first result should be "Laptop Pro 15"
```

### Common Wait Patterns in Cucumber

| Scenario | Wait to Use |
|---|---|
| After AJAX call | `waitForInvisible(spinner)` then `waitForVisible(results)` |
| After button click | `waitForPageLoad()` or `waitForUrl()` |
| After form submit | `waitForVisible(successMessage)` |
| Dynamic dropdown | `waitForPresent(dropdownOption)` |
| Toast notification | `waitForVisible(toast)` + `waitForInvisible(toast)` |
| File download | `Files.waitFor(path, Duration.ofSeconds(30))` |

### Never Use Thread.sleep

```java
// BAD — brittle, wastes time, causes CI flakiness
Thread.sleep(3000);

// GOOD — waits exactly as long as needed
waitForVisible(By.css(".results-container"));
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','WebDriverWait','AJAX','Dynamic Content','BasePage'],
  true, 0
),

-- Q52
(
  'What is the @DataTableType annotation and how do you use it?',
  'cucumber-q052-datatable-type',
  '@DataTableType transforms DataTable rows into custom Java objects. Define it in a separate class with @DataTableType annotation, map the row Map to a POJO, and the step definition receives a typed List<YourClass> directly.',
  $ans$
## @DataTableType — Custom Object Mapping for Data Tables

### The Problem Without @DataTableType

```java
// Without custom type — messy manual mapping
@When("the admin creates these users:")
public void createUsers(DataTable dataTable) {
    List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);
    for (Map<String, String> row : rows) {
        String name  = row.get("name");
        String email = row.get("email");
        String role  = Role.valueOf(row.get("role"));   // manual conversion
        int    age   = Integer.parseInt(row.get("age")); // manual conversion
        createUser(name, email, role, age);
    }
}
```

### Solution: @DataTableType with POJO

```java
// User POJO
public class UserData {
    public String name;
    public String email;
    public String role;
    public int    age;

    public UserData(String name, String email, String role, int age) {
        this.name  = name;
        this.email = email;
        this.role  = role;
        this.age   = age;
    }
}

// DataTableTypeRegistry.java — define the transformation
public class DataTableTypeRegistry {

    @DataTableType
    public UserData userEntry(Map<String, String> entry) {
        return new UserData(
            entry.get("name"),
            entry.get("email"),
            entry.get("role"),
            Integer.parseInt(entry.get("age"))
        );
    }

    @DataTableType
    public ProductData productEntry(Map<String, String> entry) {
        return new ProductData(
            entry.get("name"),
            new BigDecimal(entry.get("price").replace("$", "")),
            entry.get("category")
        );
    }
}
```

### Feature File

```gherkin
Scenario: Admin creates multiple users
  When the admin creates these users:
    | name      | email              | role    | age |
    | John Doe  | john@example.com   | ADMIN   | 30  |
    | Jane Smith| jane@example.com   | MANAGER | 28  |
    | Bob Lee   | bob@example.com    | USER    | 25  |
  Then all 3 users should appear in the user management list
```

### Clean Step Definition

```java
@When("the admin creates these users:")
public void createUsers(List<UserData> users) {  // ← Cucumber auto-converts
    for (UserData user : users) {
        adminPage.createUser(user.name, user.email, user.role);
    }
}

@Then("all {int} users should appear in the user management list")
public void verifyUsers(int expectedCount) {
    assertEquals(expectedCount, adminPage.getUserCount());
}
```

### Single Row → Object (not List)

```java
// Feature file
When the user updates their profile to:
  | firstName | John    |
  | lastName  | Doe     |
  | phone     | 9876543 |

// Step definition receives a single object
@When("the user updates their profile to:")
public void updateProfile(UserData updatedData) {  // ← single object
    profilePage.updateName(updatedData.firstName + " " + updatedData.lastName);
    profilePage.updatePhone(updatedData.phone);
}
```

### @DocStringType for Multi-line Strings

```java
// For JSON/XML in feature files:
@DocStringType
public JsonNode json(String docString) throws Exception {
    return new ObjectMapper().readTree(docString);
}

// Feature file:
When I send request with body:
  """json
  {"name": "John", "role": "ADMIN"}
  """
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','DataTableType','DataTable','POJO','Custom Type'],
  true, 0
),

-- Q53
(
  'What is the Cucumber World object and how is it different from PicoContainer?',
  'cucumber-q053-world-object',
  'The World object is a concept from Ruby/JavaScript Cucumber where a shared context object is automatically available in all step definitions. In Java Cucumber, PicoContainer DI serves the same role — a shared ScenarioContext class injected into all step definition classes.',
  $ans$
## Cucumber World Object

### What Is the World Object?

In **Ruby and JavaScript Cucumber**, the `World` is a special shared object that is automatically available in all step definition files for a single scenario. It resets between scenarios.

**Ruby example:**
```ruby
# World is implicitly available
Given("the user is logged in") do
  @driver = Selenium::WebDriver.for :chrome   # World variable
end

When("the user clicks checkout") do
  @driver.find_element(id: "checkout").click  # same World variable
end
```

### Java Equivalent: PicoContainer ScenarioContext

Java Cucumber does not have a built-in `World` object, but the same concept is achieved with **PicoContainer dependency injection**:

```java
// ScenarioContext = Java's equivalent of World
public class ScenarioContext {
    public WebDriver driver;
    public String lastApiResponse;
    public Map<String, Object> testData = new HashMap<>();

    // Lifecycle: created fresh for each scenario by PicoContainer
}
```

```java
// ALL step classes share the same ScenarioContext instance
public class LoginSteps {
    private final ScenarioContext world;  // "world" in Ruby terms
    public LoginSteps(ScenarioContext world) { this.world = world; }
}

public class CheckoutSteps {
    private final ScenarioContext world;
    public CheckoutSteps(ScenarioContext world) { this.world = world; }
}
```

### Comparison: World vs PicoContainer

| | Ruby World | Java PicoContainer |
|---|---|---|
| Automatic availability | Yes (implicit) | No (constructor injection) |
| Configuration needed | None | Add `cucumber-picocontainer` dep |
| Reset per scenario | Yes | Yes (new instance per scenario) |
| Thread safety | Per-scenario isolation | Per-scenario isolation |
| Custom data storage | `@variable` | `ctx.variable` or `ctx.testData.put()` |

### Generic Context Store Pattern

```java
// Flexible World-like context with Map storage
public class ScenarioContext {
    public WebDriver driver;
    private Map<String, Object> scenarioData = new HashMap<>();

    public void set(String key, Object value) {
        scenarioData.put(key, value);
    }

    @SuppressWarnings("unchecked")
    public <T> T get(String key) {
        return (T) scenarioData.get(key);
    }

    public boolean has(String key) {
        return scenarioData.containsKey(key);
    }
}

// Usage
@When("an order is created")
public void createOrder() {
    String orderId = orderPage.placeOrder();
    ctx.set("orderId", orderId);   // store dynamically
}

@Then("the order confirmation should show the order ID")
public void verifyOrderId() {
    String orderId = ctx.get("orderId");   // retrieve
    assertTrue(confirmationPage.getOrderId().equals(orderId));
}
```

### When to Use World/ScenarioContext

- Sharing driver between step definition classes
- Storing API tokens for use in subsequent steps
- Passing created entity IDs from When to Then
- Storing test run metadata (browser, env, user)
- Accumulating SoftAssert instances
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','World Object','PicoContainer','ScenarioContext','Ruby'],
  true, 0
),

-- Q54
(
  'How do you implement cross-browser testing with Cucumber and TestNG?',
  'cucumber-q054-cross-browser-cucumber',
  'Cross-browser testing in Cucumber uses @CucumberOptions tags per browser, a DriverFactory class that reads a -Dbrowser system property, parallel testng.xml for multi-browser runs, and PicoContainer to safely share the driver.',
  $ans$
## Cross-Browser Testing with Cucumber + TestNG

### DriverFactory — Browser Selection

```java
package factory;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.*;
import org.openqa.selenium.firefox.*;
import org.openqa.selenium.edge.*;

public class DriverFactory {

    public static WebDriver createDriver(String browser, boolean headless) {
        return switch (browser.toLowerCase()) {
            case "chrome" -> {
                WebDriverManager.chromedriver().setup();
                ChromeOptions opts = new ChromeOptions();
                if (headless) opts.addArguments("--headless=new", "--no-sandbox");
                yield new ChromeDriver(opts);
            }
            case "firefox" -> {
                WebDriverManager.firefoxdriver().setup();
                FirefoxOptions opts = new FirefoxOptions();
                if (headless) opts.addArguments("--headless");
                yield new FirefoxDriver(opts);
            }
            case "edge" -> {
                WebDriverManager.edgedriver().setup();
                EdgeOptions opts = new EdgeOptions();
                if (headless) opts.addArguments("--headless=new");
                yield new EdgeDriver(opts);
            }
            default -> throw new IllegalArgumentException("Unknown browser: " + browser);
        };
    }
}
```

### Hooks — Read Browser from System Property

```java
public class Hooks {
    private final ScenarioContext ctx;
    public Hooks(ScenarioContext ctx) { this.ctx = ctx; }

    @Before
    public void setUp() {
        String browser  = System.getProperty("browser", "chrome");
        boolean headless = Boolean.parseBoolean(System.getProperty("headless", "false"));
        ctx.driver = DriverFactory.createDriver(browser, headless);
        ctx.driver.manage().window().maximize();
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] ss = ((TakesScreenshot) ctx.driver).getScreenshotAs(OutputType.BYTES);
            scenario.attach(ss, "image/png", "Failure - " + scenario.getName());
        }
        ctx.driver.quit();
    }
}
```

### testng.xml — Run All Browsers in Parallel

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.9.dtd">
<suite name="Cross-Browser Suite" parallel="tests" thread-count="3">

    <test name="Chrome Tests">
        <parameter name="browser" value="chrome"/>
        <classes>
            <class name="runners.TestRunner"/>
        </classes>
    </test>

    <test name="Firefox Tests">
        <parameter name="browser" value="firefox"/>
        <classes>
            <class name="runners.TestRunner"/>
        </classes>
    </test>

    <test name="Edge Tests">
        <parameter name="browser" value="edge"/>
        <classes>
            <class name="runners.TestRunner"/>
        </classes>
    </test>
</suite>
```

### Read Browser from testng.xml Parameter

```java
// Use @BeforeTest with ITestContext to read testng.xml parameter
// OR read via System.getProperty set by Maven
@Before
public void setUp(Scenario scenario) {
    // Tags can indicate browser too
    if (scenario.getSourceTagNames().contains("@firefox")) {
        ctx.driver = DriverFactory.createDriver("firefox", false);
    } else {
        String browser = System.getProperty("browser", "chrome");
        ctx.driver = DriverFactory.createDriver(browser, false);
    }
}
```

### Maven Commands

```bash
# Run on Chrome (default)
mvn test -Dcucumber.filter.tags="@regression"

# Run on Firefox
mvn test -Dbrowser=firefox -Dcucumber.filter.tags="@regression"

# Run all browsers in parallel (via testng.xml)
mvn test -DsuiteXmlFile=cross-browser-testng.xml

# Headless Chrome in CI
mvn test -Dbrowser=chrome -Dheadless=true -Dcucumber.filter.tags="@smoke"
```

### Selenium Grid for Distributed Cross-Browser

```java
@Before
public void setUp() {
    String browser = System.getProperty("browser", "chrome");
    String gridUrl = System.getProperty("grid.url", "http://localhost:4444");

    DesiredCapabilities caps = new DesiredCapabilities();
    caps.setBrowserName(browser);

    ctx.driver = new RemoteWebDriver(new URL(gridUrl), caps);
}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Cross Browser','TestNG','DriverFactory','Selenium Grid'],
  true, 0
),

-- Q55
(
  'What is the difference between @Before, @BeforeStep, @After, and @AfterStep hooks in Cucumber?',
  'cucumber-q055-hook-types',
  '@Before runs once before a scenario, @BeforeStep before every step, @After once after a scenario, @AfterStep after every step. Use @Before/@After for setup/teardown, @BeforeStep/@AfterStep for logging or screenshots on each step.',
  $ans$
## Cucumber Hook Types

### All Four Hook Types

```java
package hooks;

import io.cucumber.java.*;

public class AllHooks {

    // Runs ONCE before the entire scenario
    @Before(order = 1)
    public void beforeScenario(Scenario scenario) {
        System.out.println("▶ Starting: " + scenario.getName());
        initializeDriver();
    }

    // Runs before EVERY individual step within the scenario
    @BeforeStep
    public void beforeEachStep(Scenario scenario) {
        // Useful for: logging step name, setting up step-level state
        System.out.println("  → Step starting in: " + scenario.getName());
    }

    // Runs after EVERY individual step within the scenario
    @AfterStep
    public void afterEachStep(Scenario scenario) {
        if (scenario.isFailed()) {
            // Take screenshot after the SPECIFIC step that failed
            byte[] screenshot = ((TakesScreenshot) driver)
                .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Step Failed Screenshot");
        }
        // Useful for: step-level logging, performance timing
    }

    // Runs ONCE after the entire scenario completes
    @After(order = 1)
    public void afterScenario(Scenario scenario) {
        System.out.println("■ Finished: " + scenario.getName() +
            " Status: " + scenario.getStatus());
        softAssert.assertAll();  // collect all soft assertion failures
    }

    @After(order = 0)
    public void quitDriver() {
        if (driver != null) driver.quit();
    }
}
```

### Execution Order Within a Scenario

```
Scenario: Login test
  ↓ @Before (order=1)       -- once
  ↓ @BeforeStep             -- before Given step
    Given the user is on the login page
  ↓ @AfterStep              -- after Given step
  ↓ @BeforeStep             -- before When step
    When the user enters credentials
  ↓ @AfterStep              -- after When step
  ↓ @BeforeStep             -- before Then step
    Then the dashboard should appear
  ↓ @AfterStep              -- after Then step
  ↓ @After (order=1)        -- once
  ↓ @After (order=0)        -- once (driver quit)
```

### @Before Order — Higher Runs First

```java
@Before(order = 100)  // runs FIRST
public void initializeFramework() { ... }

@Before(order = 50)   // runs SECOND
public void setUpTestData() { ... }

@Before(order = 1)    // runs LAST (default)
public void setUp() { ... }
```

### @After Order — Lower Runs First

```java
@After(order = 100)  // runs FIRST after scenario
public void softAssertAll() { softAssert.assertAll(); }

@After(order = 50)   // runs SECOND
public void captureExtentReport() { ... }

@After(order = 0)    // runs LAST
public void quitDriver() { driver.quit(); }
```

### When to Use Each Hook

| Hook | Use Case |
|---|---|
| `@Before` | Browser init, DB setup, login, reset state |
| `@BeforeStep` | Step-level logging, performance timer start |
| `@After` | Assertions, report capture, cleanup |
| `@AfterStep` | Step-level screenshot on failure, timer end |

### Tagged Hooks

```java
@Before("@payments")
public void loadPaymentTestData() {
    dbUtils.loadPaymentFixtures();
}

@After("@payments")
public void cleanupPaymentData() {
    dbUtils.deletePaymentTestData();
}
```

Only runs for scenarios tagged `@payments` — other scenarios are unaffected.
$ans$,
  'Cucumber', 'Interview Q&A', 'Intermediate', 'Advanced',
  ARRAY['Cucumber','BDD','Hooks','Before','After','BeforeStep','AfterStep','Lifecycle'],
  true, 0
);
