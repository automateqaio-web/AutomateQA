-- Cucumber / BDD Interview Questions Q1–Q35
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q1
(
  'What language is used by Cucumber?',
  'cucumber-q001-gherkin-language',
  'Cucumber uses Gherkin — a plain English, human-readable language with keywords like Feature, Scenario, Given, When, Then to describe application behavior.',
  $ans$
## Gherkin — The Language of Cucumber

Cucumber uses **Gherkin** as its language. Gherkin is a simple, plain-English representation of application behavior that can be understood by both technical and non-technical stakeholders.

### Key Characteristics

- Human-readable, plain text format
- Structured around business behavior (not implementation)
- Understood by Business Analysts, Developers, and QA
- Each `.feature` file is written in Gherkin

### Core Gherkin Keywords

| Keyword | Purpose |
|---|---|
| `Feature` | High-level description of the feature under test |
| `Scenario` | A specific test case |
| `Scenario Outline` | Parameterized scenario for multiple data sets |
| `Given` | Precondition / initial state |
| `When` | Action performed by the user |
| `Then` | Expected outcome / assertion |
| `And` | Continues a Given/When/Then step |
| `But` | Negative continuation |
| `Background` | Common steps that run before each scenario |
| `Examples` | Data table for Scenario Outline |

### Example Feature File

```gherkin
Feature: User Login

  Scenario: Successful login with valid credentials
    Given the user is on the login page
    When the user enters username "admin" and password "Admin@123"
    And the user clicks the Login button
    Then the user should be redirected to the dashboard
    And the welcome message "Welcome, Admin" should be displayed
```

### Why Gherkin?

- **Collaboration**: Non-technical stakeholders write/review tests
- **Living documentation**: Feature files serve as up-to-date docs
- **BDD bridge**: Links business requirements to automated tests
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Gherkin','Feature File'],
  true, 0
),

-- Q2
(
  'What is meant by a feature file in Cucumber?',
  'cucumber-q002-feature-file',
  'A feature file is a plain text file with .feature extension that contains test scenarios written in Gherkin language. It describes application behavior in business-readable language.',
  $ans$
## Feature File in Cucumber

A **feature file** is the core component of Cucumber BDD testing. It contains test scenarios written in **Gherkin** language and acts as both executable test specification and living documentation.

### Properties of a Feature File

- Extension: `.feature`
- Location: `src/test/resources/features/`
- Written in plain English (Gherkin)
- Contains one Feature and multiple Scenarios
- **Maximum recommended**: 10 scenarios per feature file

### Structure of a Feature File

```gherkin
Feature: User Registration
  As a new user
  I want to register on the website
  So that I can access premium features

  Background:
    Given the user is on the registration page

  Scenario: Register with valid details
    When the user enters name "John Doe"
    And the user enters email "john@test.com"
    And the user enters password "Pass@123"
    And the user clicks Register
    Then the success message "Registration Successful" should appear

  Scenario: Register with existing email
    When the user enters email "existing@test.com"
    And the user clicks Register
    Then the error "Email already registered" should appear
```

### Rules

1. First line must start with `Feature:` keyword
2. One `Feature` per `.feature` file
3. A feature file can have multiple `Scenario` blocks
4. `Background` steps run before every scenario in the file

### Directory Structure

```
src/
  test/
    resources/
      features/
        login.feature
        registration.feature
        checkout.feature
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Gherkin','Feature File'],
  true, 0
),

-- Q3
(
  'What are the various keywords used in Cucumber for writing a scenario?',
  'cucumber-q003-gherkin-keywords',
  'Cucumber uses Given, When, Then, And, But as the core step keywords. Additional structural keywords include Feature, Scenario, Background, Scenario Outline, and Examples.',
  $ans$
## Gherkin Keywords for Writing Scenarios

### Step Keywords (Most Important)

| Keyword | Purpose | Example |
|---|---|---|
| `Given` | Precondition — sets initial context | `Given the user is on the login page` |
| `When` | Action — event that triggers behavior | `When the user enters valid credentials` |
| `Then` | Outcome — expected result / assertion | `Then the dashboard should be displayed` |
| `And` | Adds another step of the same type | `And the user clicks the Login button` |
| `But` | Negative continuation | `But the error message should not appear` |

### Structural Keywords

| Keyword | Purpose |
|---|---|
| `Feature` | Describes the feature being tested |
| `Scenario` | A single test case |
| `Scenario Outline` | Parameterized test with multiple data sets |
| `Background` | Common steps before each scenario |
| `Examples` | Data table used with Scenario Outline |

### Complete Example

```gherkin
Feature: Shopping Cart

  Background:
    Given the user is logged in
    And the user is on the product page

  Scenario: Add single item to cart
    When the user clicks "Add to Cart" for "Laptop"
    Then the cart count should show "1"
    And the cart total should be "$999"
    But the checkout button should not be disabled

  Scenario Outline: Add multiple products
    When the user adds "<product>" to the cart
    Then the cart should contain "<product>"
    And the price shown should be "<price>"

    Examples:
      | product  | price  |
      | Laptop   | $999   |
      | Phone    | $599   |
      | Tablet   | $399   |
```

### Tips

- `And` / `But` inherit the type of the preceding step (Given/When/Then)
- Use `And` to keep scenarios readable without repeating Given/When/Then
- Steps should describe **business behavior**, not implementation details
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Gherkin','Given When Then','Keywords'],
  true, 0
),

-- Q4
(
  'What is the purpose of a Scenario Outline in Cucumber?',
  'cucumber-q004-scenario-outline',
  'Scenario Outline enables data-driven testing in Cucumber — the same scenario runs multiple times with different data sets defined in an Examples table using angle-bracket placeholders.',
  $ans$
## Scenario Outline in Cucumber

`Scenario Outline` is used for **parameterization** — running the same test scenario with multiple sets of input data. It eliminates duplication when the same test flow must be validated against different data.

### Syntax

```gherkin
Scenario Outline: <description>
  Given ...
  When ... "<placeholder>"
  Then ... "<placeholder>"

  Examples:
    | column1 | column2 |
    | value1  | value2  |
    | value3  | value4  |
```

### Full Example — Login with Multiple Credentials

```gherkin
Feature: Login Validation

  Scenario Outline: Login with different user roles
    Given the user is on the login page
    When the user enters username "<username>" and password "<password>"
    And the user clicks Login
    Then the user should see the "<dashboard>" page

    Examples:
      | username    | password    | dashboard  |
      | admin       | Admin@123   | Admin Home |
      | manager     | Mgr@456     | Manager    |
      | testuser    | Test@789    | User Home  |
```

### How It Works

1. Placeholders in `<angle brackets>` are replaced with values from the `Examples` table
2. Each row in `Examples` = one test execution
3. 3 rows in Examples = 3 separate test runs
4. Results appear individually in the report

### When to Use

| Use Scenario Outline | Use Regular Scenario |
|---|---|
| Same flow, different data | Unique flow for each case |
| Boundary value testing | One-off edge case |
| Multiple user types | Single user journey |
| Form validation | Complex, branching logic |

### Difference from Scenario

```gherkin
-- Without Scenario Outline (repetitive)
Scenario: Login as admin
  Given ...
  When the user enters "admin" and "Admin@123"
  Then ...

Scenario: Login as manager
  Given ...
  When the user enters "manager" and "Mgr@456"
  Then ...

-- With Scenario Outline (clean)
Scenario Outline: Login as <role>
  Given ...
  When the user enters "<username>" and "<password>"
  Then ...
  Examples:
    | role    | username | password  |
    | admin   | admin    | Admin@123 |
    | manager | manager  | Mgr@456   |
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Scenario Outline','Data Driven','Examples'],
  true, 0
),

-- Q5
(
  'What programming languages does Cucumber support?',
  'cucumber-q005-supported-languages',
  'Cucumber supports multiple languages including Java, Ruby, JavaScript, Python (.NET), C#, and Kotlin. The most widely used combination is Cucumber-Java with Selenium WebDriver.',
  $ans$
## Programming Languages Supported by Cucumber

Cucumber is a polyglot framework — it supports multiple programming languages through official implementations:

### Supported Languages

| Language | Implementation | Package |
|---|---|---|
| Java | Cucumber-JVM | `io.cucumber:cucumber-java` |
| Kotlin | Cucumber-JVM (Kotlin) | `io.cucumber:cucumber-java8` |
| JavaScript | Cucumber.js | `@cucumber/cucumber` |
| Ruby | Cucumber-Ruby | `cucumber` gem |
| Python | Behave / pytest-bdd | `behave` |
| C# / .NET | SpecFlow (Cucumber-inspired) | NuGet `SpecFlow` |
| PHP | Behat | `behat/behat` |

### Most Common Stack (Java + Selenium)

```xml
<!-- pom.xml dependencies -->
<dependency>
  <groupId>io.cucumber</groupId>
  <artifactId>cucumber-java</artifactId>
  <version>7.15.0</version>
</dependency>
<dependency>
  <groupId>io.cucumber</groupId>
  <artifactId>cucumber-testng</artifactId>
  <version>7.15.0</version>
</dependency>
<dependency>
  <groupId>io.cucumber</groupId>
  <artifactId>cucumber-core</artifactId>
  <version>7.15.0</version>
</dependency>
```

### Integration with Test Tools

```
Cucumber + Selenium WebDriver → UI automation
Cucumber + REST Assured      → API testing
Cucumber + Appium            → Mobile testing
Cucumber + TestNG            → Test management & reporting
Cucumber + JUnit 5           → Test runner (modern)
```

### JARs Required (Legacy Maven)

```
cucumber-core-7.x.jar
cucumber-java-7.x.jar
cucumber-testng-7.x.jar (or cucumber-junit)
gherkin-26.x.jar
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Java','Selenium','Maven'],
  true, 0
),

-- Q6
(
  'What is the purpose of the Step Definition file in Cucumber?',
  'cucumber-q006-step-definition',
  'Step Definition file maps each Gherkin step (Given/When/Then) to actual Java code that performs the action. It acts as the glue between feature files and automation code.',
  $ans$
## Step Definition File in Cucumber

A **Step Definition** file contains Java methods annotated with `@Given`, `@When`, `@Then` that map to the natural language steps written in the feature file. It bridges the gap between plain English scenarios and executable automation code.

### How Mapping Works

```
Feature file step:
  "When the user enters username "admin" and password "Admin@123""

Step Definition method:
  @When("the user enters username {string} and password {string}")
  public void enterCredentials(String username, String password) {
      loginPage.enterUsername(username);
      loginPage.enterPassword(password);
  }
```

### Complete Step Definition Example

```java
package stepDefinitions;

import io.cucumber.java.en.*;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import pages.LoginPage;
import static org.testng.Assert.*;

public class LoginSteps {

    WebDriver driver;
    LoginPage loginPage;

    @Given("the user is on the login page")
    public void navigateToLoginPage() {
        driver = new ChromeDriver();
        driver.get("https://example.com/login");
        loginPage = new LoginPage(driver);
    }

    @When("the user enters username {string} and password {string}")
    public void enterCredentials(String username, String password) {
        loginPage.enterUsername(username);
        loginPage.enterPassword(password);
    }

    @When("the user clicks the Login button")
    public void clickLogin() {
        loginPage.clickLoginButton();
    }

    @Then("the user should be redirected to the dashboard")
    public void verifyDashboard() {
        assertTrue(driver.getTitle().contains("Dashboard"));
    }

    @After
    public void tearDown() {
        if (driver != null) driver.quit();
    }
}
```

### Cucumber Expressions vs Regex

```java
// Cucumber Expression (recommended, simpler)
@When("the user enters {string} into the {string} field")
public void enterText(String value, String field) { }

// Regex (more powerful)
@When("^the user enters \"([^\"]*)\" into the \"([^\"]*)\" field$")
public void enterText(String value, String field) { }
```

### File Location

```
src/
  test/
    java/
      stepDefinitions/
        LoginSteps.java
        RegistrationSteps.java
      hooks/
        Hooks.java
```

### Key Rules

1. Step text must **exactly match** feature file (case-sensitive)
2. One step definition class per feature area (recommended)
3. Use `@Before` / `@After` hooks in a separate `Hooks.java`
4. **Glue path** in TestRunner must point to step definition package
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Step Definition','Gherkin','Glue'],
  true, 0
),

-- Q7
(
  'What are the major advantages of the Cucumber framework?',
  'cucumber-q007-advantages',
  'Cucumber advantages include BDD collaboration, plain-text scenarios readable by non-technical stakeholders, reusable step definitions, integration with Selenium/REST Assured, and living documentation.',
  $ans$
## Advantages of the Cucumber Framework

### 1. BDD Collaboration
Bridges the communication gap between Business Analysts, Developers, and QA. All three write/review the same Gherkin feature files — eliminating requirement misunderstandings.

### 2. Plain Text Representation
Feature files written in Gherkin (plain English) are readable by **non-technical stakeholders** without any programming knowledge.

```gherkin
Scenario: Customer places order
  Given the customer has items in the cart
  When the customer completes checkout
  Then the order confirmation email should be sent
```

### 3. Open Source & Free
Cucumber is completely free, open-source, and has a large community with extensive documentation.

### 4. Living Documentation
Feature files serve as always-up-to-date documentation of application behavior — they ARE the tests, so they can't become stale.

### 5. Reusable Step Definitions
The same step definition can be reused across multiple feature files:

```java
@Given("the user is logged in")
public void userIsLoggedIn() {
    // This step can be used in any feature file
}
```

### 6. Multi-Language Support
Works with Java, JavaScript, Ruby, Python, C# — use the language your team already knows.

### 7. Excellent Tool Integration

| Tool | Integration |
|---|---|
| Selenium WebDriver | UI automation |
| REST Assured | API testing |
| TestNG / JUnit | Test runner & reporting |
| Maven / Gradle | Build & CI |
| Jenkins / GitHub Actions | CI/CD pipeline |
| Allure / ExtentReports | Rich reporting |

### 8. Data-Driven Testing
Built-in support via `Scenario Outline + Examples` — run same test with multiple data sets without extra code.

### 9. Easier Test Maintenance
Business logic changes are reflected in feature files (plain text), not in complex code — reducing maintenance overhead.

### 10. Tag-Based Execution
Run only specific scenarios using tags:
```bash
mvn test -Dcucumber.filter.tags="@smoke"
mvn test -Dcucumber.filter.tags="@regression and not @slow"
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Advantages','Selenium'],
  true, 0
),

-- Q8
(
  'Provide an example of a feature file using the Cucumber framework.',
  'cucumber-q008-feature-file-example',
  'A feature file example showing login scenario with Feature, Scenario, Given, When, Then keywords demonstrating the Gherkin syntax structure.',
  $ans$
## Feature File Example

### Login Feature (`login.feature`)

```gherkin
Feature: Login to the Application Under Test

  As a registered user
  I want to log in to the application
  So that I can access my account

  Background:
    Given the user opens the Chrome browser
    And the user navigates to the application URL

  Scenario: Successful login with valid credentials
    When the user enters the username "admin@test.com"
    And the user enters the password "Admin@123"
    And the user clicks on the Login button
    Then the user should be redirected to the dashboard
    And the message "Welcome, Admin" should be displayed

  Scenario: Failed login with invalid password
    When the user enters the username "admin@test.com"
    And the user enters the password "WrongPass"
    And the user clicks on the Login button
    Then the error message "Invalid credentials" should be displayed
    And the user should remain on the login page

  Scenario: Login with empty credentials
    When the user clicks on the Login button
    Then the validation error "Username is required" should appear
```

### E-Commerce Checkout Feature (`checkout.feature`)

```gherkin
Feature: Product Checkout Flow

  Scenario: User purchases a single item
    Given the user is logged in as "customer"
    And the user is on the product page for "Laptop"
    When the user clicks "Add to Cart"
    And the user proceeds to checkout
    And the user enters shipping address "123 Main St, NY"
    And the user selects payment method "Credit Card"
    And the user places the order
    Then the order confirmation page should be displayed
    And an email confirmation should be sent to "customer@test.com"
```

### Key Points

1. First line always starts with `Feature:` keyword
2. The text after `Feature:` describes what is being tested
3. Each `Scenario:` is a complete, independent test case
4. `Background:` contains common steps shared across all scenarios
5. Steps start with `Given`, `When`, `Then`, `And`, or `But`
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Feature File','Gherkin','Example'],
  true, 0
),

-- Q9
(
  'Provide an example of a Scenario Outline using the Cucumber framework.',
  'cucumber-q009-scenario-outline-example',
  'Scenario Outline example for file upload that runs the same steps with different filenames from an Examples table — demonstrating data-driven BDD testing.',
  $ans$
## Scenario Outline Example

### File Upload Test

```gherkin
Feature: File Upload Functionality

  Scenario Outline: Upload files of different types
    Given the user is on the upload file screen
    When the user clicks on the Browse button
    And the user enters "<filename>" onto the upload textbox
    And the user clicks on the Enter button
    Then the message "File uploaded successfully" should be displayed
    And the file "<filename>" should appear in the uploaded files list

    Examples:
      | filename       |
      | file1.pdf      |
      | file2.docx     |
      | image.png      |
      | data.csv       |
```

### Login with Multiple User Roles

```gherkin
Feature: Role-Based Login

  Scenario Outline: Login as different user roles
    Given the application is open
    When the user logs in with username "<username>" and password "<password>"
    Then the user should land on the "<expected_page>" page
    And the role indicator should show "<role>"

    Examples:
      | username      | password    | expected_page  | role      |
      | admin@co.com  | Admin@123   | Admin Panel    | ADMIN     |
      | mgr@co.com    | Mgr@456     | Dashboard      | MANAGER   |
      | user@co.com   | User@789    | Home           | USER      |
```

### Form Validation Test

```gherkin
Feature: Registration Form Validation

  Scenario Outline: Validate mandatory field messages
    Given the user is on the registration page
    When the user submits the form with "<field>" as empty
    Then the error "<error_message>" should appear next to "<field>"

    Examples:
      | field       | error_message             |
      | First Name  | First Name is required    |
      | Email       | Email is required         |
      | Password    | Password is required      |
      | Mobile      | Mobile number is required |
```

### How Execution Works

- **4 rows in Examples** = 4 separate test executions
- Each row is treated as an independent scenario
- Reports show each row's pass/fail individually
- `<placeholder>` must exactly match `Examples` column header
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Scenario Outline','Examples','Data Driven'],
  true, 0
),

-- Q10
(
  'What is the purpose of the BDD (Behaviour Driven Development) methodology?',
  'cucumber-q010-bdd-methodology',
  'BDD (Behaviour Driven Development) is a development methodology that bridges technical and business teams by expressing application behavior in plain English scenarios understood by all stakeholders.',
  $ans$
## Behaviour Driven Development (BDD)

### Definition

**BDD** is a software development methodology where tests are written in plain, human-readable language that describes the **behavior** of an application from a business perspective. It extends TDD (Test Driven Development) by making tests understandable to non-programmers.

### Core Purpose

The main aim of BDD is to make project roles — **Business Analysts, Quality Assurance, Developers, and Support Teams** — understand the application behavior without diving deep into technical aspects.

### TDD vs BDD

| Aspect | TDD | BDD |
|---|---|---|
| Focus | Technical implementation | Business behavior |
| Written by | Developers | Everyone (BA, QA, Dev) |
| Language | Code (assertions) | Plain English (Gherkin) |
| Test style | `assertEquals(200, status)` | `Then the status should be 200` |
| Documentation | In code | In feature files |

### BDD Cycle

```
1. BA/PO writes user story
          ↓
2. Team writes Gherkin scenarios (Given/When/Then)
          ↓
3. Dev writes code to make scenario pass (RED → GREEN)
          ↓
4. QA automates the scenario with Cucumber + Selenium
          ↓
5. Feature file becomes living documentation
```

### Benefits in Real World

```
Without BDD:
  BA writes requirements in Word docs
  → Dev interprets differently
  → QA tests different things
  → Rework + bugs in production

With BDD:
  BA writes feature files in Gherkin
  → Dev implements to make scenarios pass
  → QA verifies same scenarios are automated
  → All three are aligned from day one
```

### BDD Tools

| Tool | Language |
|---|---|
| Cucumber | Java, JS, Ruby |
| SpecFlow | C# / .NET |
| Behave | Python |
| JBehave | Java |
| Behat | PHP |
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Agile','Methodology','Behaviour Driven'],
  true, 0
),

-- Q11
(
  'What is the limit for the maximum number of scenarios in a Cucumber feature file?',
  'cucumber-q011-scenarios-per-feature',
  'There is no technical hard limit, but best practice recommends a maximum of 10 scenarios per feature file. Keeping files small improves readability, maintainability, and execution speed.',
  $ans$
## Maximum Scenarios in a Feature File

### Technical Limit
Cucumber has **no enforced hard limit** on the number of scenarios in a feature file. You can technically add hundreds of scenarios to a single file.

### Recommended Best Practice
Keep feature files to a **maximum of 10 scenarios**. However, this number can vary from project to project and organization to organization.

### Why Limit Scenarios Per Feature File?

```
1. READABILITY
   - Files become hard to scan with 30+ scenarios
   - Difficult to find specific scenarios quickly

2. MAINTAINABILITY
   - One change in Background affects all scenarios
   - Large files have higher merge conflict risk

3. FOCUS
   - Each feature file should test ONE feature/module
   - Mixing multiple features in one file violates SRP

4. EXECUTION TIME
   - Smaller files = faster parallel execution by feature
   - Easier to tag and run subsets
```

### File Organization Strategy

```
features/
  login/
    login_valid.feature       (5 scenarios)
    login_invalid.feature     (6 scenarios)
    login_security.feature    (4 scenarios)
  cart/
    add_to_cart.feature       (8 scenarios)
    remove_from_cart.feature  (5 scenarios)
  checkout/
    payment.feature           (10 scenarios)
    shipping.feature          (7 scenarios)
```

### Signs You Need to Split a Feature File

- More than 10 scenarios
- Background has more than 3-4 steps
- Scenarios test unrelated functionality
- File is longer than 100 lines
- Team members frequently get merge conflicts in the same file
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Feature File','Best Practice'],
  true, 0
),

-- Q12
(
  'What is the use of Background keyword in Cucumber?',
  'cucumber-q012-background-keyword',
  'Background keyword groups common Given steps that run before every Scenario in a feature file. It avoids repetition when all scenarios share the same preconditions.',
  $ans$
## Background Keyword in Cucumber

### Purpose
`Background` is used to define **common precondition steps** that should run before every scenario in a feature file. It avoids duplicating the same `Given` steps in each scenario.

### Syntax

```gherkin
Feature: Online Shopping

  Background:
    Given the user is on the application login page
    And the user is logged in with valid credentials

  Scenario: Add item to cart
    When the user searches for "Laptop"
    And clicks "Add to Cart"
    Then the cart count should be "1"

  Scenario: View cart
    When the user navigates to the cart page
    Then the cart page should be displayed
```

In the example above, both scenarios first execute the `Background` steps before running their own steps.

### Background vs Hooks (@Before)

| | Background | @Before Hook |
|---|---|---|
| Written in | Feature file (Gherkin) | Java step definition |
| Visible to | BAs, PMs, non-technical | Developers only |
| Applies to | Current feature file only | All scenarios (by default) |
| Tagged scope | No | Yes (`@Before("@login")`) |
| Purpose | Business preconditions | Technical setup (driver init) |

### Real Example

```gherkin
Feature: Banking Transactions

  Background:
    Given the user is on the application login page
    When the user enters credentials "user01" and "Pass@123"
    And the user clicks Login
    Then the user should be on the home page

  Scenario: Check account balance
    When the user clicks on "My Account"
    Then the balance should be displayed

  Scenario: Transfer funds
    When the user initiates a transfer of "$500" to "ACC-456"
    Then the transfer confirmation should appear
```

### Key Rules

1. Only `Given` steps should be in Background (best practice)
2. There can be **only one** `Background` per feature file
3. Background runs **before every scenario**, including Scenario Outline rows
4. Background does NOT run before scenarios in other feature files
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Background','Gherkin','Precondition'],
  true, 0
),

-- Q13
(
  'What symbol is used for parameterization in Cucumber?',
  'cucumber-q013-parameterization-symbol',
  'The pipe symbol (|) is used to define parameter tables (Data Tables and Examples tables) in Cucumber. Angle brackets < > are used as placeholders in Scenario Outline steps.',
  $ans$
## Parameterization Symbols in Cucumber

### Two Types of Parameterization

#### 1. Scenario Outline — Angle Brackets `< >`

Placeholders in step text use `<angle brackets>`:

```gherkin
Scenario Outline: Login with <role>
  When the user enters "<username>" and "<password>"
  Then the user sees the "<dashboard>"

  Examples:
    | role    | username | password  | dashboard |
    | admin   | admin    | Admin@123 | AdminHome |
    | manager | manager  | Mgr@456   | MgrHome   |
```

#### 2. Examples / Data Tables — Pipe Symbol `|`

The **pipe symbol `|`** is used to define tabular data:

```gherkin
  Examples:
    | filename |
    | file1    |
    | file2    |
```

Or for inline Data Tables:

```gherkin
  When the user submits the registration form:
    | Field     | Value            |
    | FirstName | John             |
    | LastName  | Doe              |
    | Email     | john@example.com |
    | Mobile    | 9876543210       |
```

### In Step Definitions

```java
// Scenario Outline parameters passed as method arguments
@When("the user enters {string} and {string}")
public void enterCredentials(String username, String password) {
    // username, password come from Examples table row
}

// Data Table accessed via DataTable object
@When("the user submits the registration form:")
public void submitForm(DataTable dataTable) {
    Map<String, String> formData = dataTable.asMap(String.class, String.class);
    String firstName = formData.get("FirstName");
    String email = formData.get("Email");
}
```

### Cucumber Expressions for Parameters

```java
{string}    // matches "quoted string"
{int}       // matches integer: 42
{float}     // matches decimal: 3.14
{word}      // matches single word (no spaces)
{}          // matches anything (anonymous)
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Parameterization','Scenario Outline','Data Table'],
  true, 0
),

-- Q14
(
  'What is the purpose of the Examples keyword in Cucumber?',
  'cucumber-q014-examples-keyword',
  'Examples keyword provides a data table for Scenario Outline. Each row in the Examples table becomes a separate test execution where placeholders are replaced with the row values.',
  $ans$
## Examples Keyword in Cucumber

### Purpose

`Examples` keyword is used to supply **test data** to a `Scenario Outline`. Every row in the Examples table results in one execution of the scenario with that row's values substituted into the `<placeholder>` tokens.

### Rules

1. `Examples` **must follow** `Scenario Outline` — it cannot be used with regular `Scenario`
2. First row is the **header** (column names = placeholder names)
3. Each subsequent row is **one test execution**
4. Column names must exactly match the `<placeholders>` in the scenario

### Syntax

```gherkin
Scenario Outline: Verify product prices
  Given the user is on the product catalog page
  When the user searches for "<product>"
  Then the price displayed should be "<price>"
  And the availability should be "<availability>"

  Examples:
    | product  | price  | availability |
    | Laptop   | $999   | In Stock     |
    | Phone    | $599   | In Stock     |
    | Tablet   | $399   | Out of Stock |
    | Watch    | $199   | In Stock     |
```

This runs **4 tests** — one for each data row.

### Multiple Examples Blocks

You can have multiple `Examples` sections with tags:

```gherkin
Scenario Outline: Login test
  When the user logs in as "<username>"
  Then the result should be "<outcome>"

  @smoke
  Examples: Valid Users
    | username | outcome   |
    | admin    | Dashboard |
    | user     | Home      |

  @negative
  Examples: Invalid Users
    | username  | outcome              |
    | hacker    | Access Denied        |
    | unknown   | User not found       |
```

### In Step Definitions

Parameters from Examples are passed as method arguments in the same order they appear in the step:

```java
@When("the user searches for {string}")
public void searchProduct(String product) {
    // Called once per Examples row with that row's value
    searchBox.sendKeys(product);
}

@Then("the price displayed should be {string}")
public void verifyPrice(String expectedPrice) {
    assertEquals(expectedPrice, priceElement.getText());
}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Examples','Scenario Outline','Data Driven'],
  true, 0
),

-- Q15
(
  'What is the file extension for a Cucumber feature file?',
  'cucumber-q015-feature-file-extension',
  'The file extension for a Cucumber feature file is .feature (e.g., login.feature). Feature files are plain text files written in Gherkin language, usually stored in src/test/resources/features/.',
  $ans$
## Feature File Extension

### Extension: `.feature`

Cucumber feature files use the `.feature` extension.

```
login.feature
registration.feature
checkout.feature
shopping_cart.feature
```

### Key Facts

- **Format**: Plain text (UTF-8 encoded)
- **Editor**: Any text editor, IDE with Cucumber plugin
- **Location**: `src/test/resources/features/` (Maven convention)
- **Readable by**: Anyone — no programming knowledge needed
- **Ideally saved in**: A notepad-type file structure (plain text)

### Standard Project Structure

```
src/
  test/
    resources/
      features/
        login.feature           ← feature files here
        registration.feature
        checkout.feature
    java/
      stepDefinitions/
        LoginSteps.java
        RegistrationSteps.java
      hooks/
        Hooks.java
      runners/
        TestRunner.java
```

### IDE Support

To get syntax highlighting for `.feature` files:

| IDE | Plugin |
|---|---|
| IntelliJ IDEA | Cucumber for Java (bundled in Ultimate) |
| Eclipse | Cucumber Natural Language Plugin |
| VS Code | Cucumber (Gherkin) Full Support |

### Example File Content

```gherkin
# File: src/test/resources/features/login.feature

Feature: User Authentication
  Scenario: Valid login
    Given the user is on the login page
    When the user enters valid credentials
    Then the dashboard should be displayed
```

The first line comment after `#` is optional and ignored by Cucumber. The actual feature content starts with the `Feature:` keyword.
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Feature File','.feature','Extension'],
  true, 0
),

-- Q16
(
  'Provide an example of a step definition file in Cucumber.',
  'cucumber-q016-step-definition-example',
  'Step definition file example showing @Given, @When, @Then annotations mapping Gherkin steps to Java methods with ChromeDriver browser launch and page interaction.',
  $ans$
## Step Definition File Example

### Basic Login Step Definition

```java
package stepDefinitions;

import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.By;
import static org.testng.Assert.*;

public class LoginStepDefinitions {

    WebDriver driver;

    @Before
    public void setUp() {
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    // Maps to: Given the user opens Chrome browser and launches the application
    @Given("the user opens Chrome browser and launches the application")
    public void openBrowser() {
        driver.get("https://www.example.com");
    }

    // Maps to: When the user enters the username "admin"
    @When("the user enters the username {string}")
    public void enterUsername(String username) {
        driver.findElement(By.id("username")).sendKeys(username);
    }

    // Maps to: And the user enters the password "Admin@123"
    @When("the user enters the password {string}")
    public void enterPassword(String password) {
        driver.findElement(By.id("password")).sendKeys(password);
    }

    // Maps to: And the user clicks on the Login button
    @When("the user clicks on the Login button")
    public void clickLogin() {
        driver.findElement(By.id("loginBtn")).click();
    }

    // Maps to: Then the user should be on the dashboard
    @Then("the user should be on the dashboard")
    public void verifyDashboard() {
        String title = driver.getTitle();
        assertTrue(title.contains("Dashboard"), "Dashboard not loaded. Title: " + title);
    }

    @After
    public void tearDown(io.cucumber.java.Scenario scenario) {
        if (scenario.isFailed()) {
            // Take screenshot on failure
            byte[] screenshot = ((org.openqa.selenium.TakesScreenshot) driver)
                .getScreenshotAs(org.openqa.selenium.OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Failure Screenshot");
        }
        if (driver != null) {
            driver.quit();
        }
    }
}
```

### Step Definition with @CucumberOptions Annotation Example

```java
// The step below corresponds to feature file step:
// Given "^Open Chrome browser and launch the application$"
@Given("^Open Chrome browser and launch the application$")
public void openBrowser() {
    driver = new ChromeDriver();
    driver.manage().window().maximize();
    driver.get("www.facebook.com");
}
```

### Important Notes

1. Method name doesn't matter — only the annotation text matters for matching
2. Use `{string}` for quoted parameters, `{int}` for numbers
3. `@Before` and `@After` are hooks — not step definitions
4. Step text must exactly match the feature file (Cucumber is case-sensitive)
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Step Definition','Java','ChromeDriver'],
  true, 0
),

-- Q17
(
  'What is the purpose of the @CucumberOptions annotation?',
  'cucumber-q017-cucumber-options',
  '@CucumberOptions annotation on the TestRunner class provides configuration for Cucumber — specifying feature file path (features), step definition path (glue), reporting plugins, tags, and dry run settings.',
  $ans$
## @CucumberOptions Annotation

`@CucumberOptions` annotation is used on the **TestRunner class** to configure how Cucumber executes tests. It provides a link between feature files and step definitions, and configures plugins, tags, and execution behavior.

### Syntax

```java
@CucumberOptions(
    features = "src/test/resources/features",
    glue = {"stepDefinitions", "hooks"},
    plugin = {"pretty", "html:target/cucumber-reports/report.html", "json:target/cucumber.json"},
    tags = "@smoke",
    dryRun = false,
    monochrome = true
)
```

### All Available Options

| Option | Purpose | Example |
|---|---|---|
| `features` | Path to feature files | `"src/test/resources/features"` |
| `glue` | Package(s) of step definitions | `{"stepDefs", "hooks"}` |
| `plugin` | Reporting format and output | `"html:target/report.html"` |
| `tags` | Filter which scenarios to run | `"@smoke and not @slow"` |
| `dryRun` | Check for missing step defs | `true` / `false` |
| `monochrome` | Clean console output | `true` |
| `name` | Filter by scenario name regex | `"Login.*"` |
| `publish` | Publish report to Cucumber Cloud | `true` |

### Complete TestRunner Example

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
        "html:target/cucumber-reports/cucumber.html",
        "json:target/cucumber-reports/cucumber.json",
        "junit:target/cucumber-reports/cucumber.xml"
    },
    tags = "@smoke",
    dryRun = false,
    monochrome = true
)
public class TestRunner extends AbstractTestNGCucumberTests {

    @Override
    @DataProvider(parallel = true)
    public Object[][] scenarios() {
        return super.scenarios();
    }
}
```

### dryRun = true

When `dryRun = true`, Cucumber checks if all steps in feature files have corresponding step definitions **without actually executing** the tests. Use this to detect missing step definitions.

### Syntax of @CucumberOptions Tag

```
@CucumberOptions(features="Features", glue={"StepDefinition"})
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','CucumberOptions','TestRunner','Configuration'],
  true, 0
),

-- Q18
(
  'How can Cucumber be integrated with Selenium WebDriver?',
  'cucumber-q018-cucumber-selenium-integration',
  'Cucumber integrates with Selenium by adding cucumber-java and cucumber-testng JARs, writing feature files in Gherkin, creating step definitions with WebDriver code, and running via TestRunner with @CucumberOptions.',
  $ans$
## Cucumber + Selenium WebDriver Integration

### Step 1: Add Maven Dependencies

```xml
<dependencies>
    <!-- Selenium WebDriver -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.18.0</version>
    </dependency>

    <!-- Cucumber Java -->
    <dependency>
        <groupId>io.cucumber</groupId>
        <artifactId>cucumber-java</artifactId>
        <version>7.15.0</version>
        <scope>test</scope>
    </dependency>

    <!-- Cucumber TestNG -->
    <dependency>
        <groupId>io.cucumber</groupId>
        <artifactId>cucumber-testng</artifactId>
        <version>7.15.0</version>
        <scope>test</scope>
    </dependency>

    <!-- WebDriverManager (auto driver setup) -->
    <dependency>
        <groupId>io.github.bonigarcia</groupId>
        <artifactId>webdrivermanager</artifactId>
        <version>5.7.0</version>
    </dependency>
</dependencies>
```

### Required JARs (Legacy - without Maven)

```
cucumber-core-7.x.jar
cucumber-java-7.x.jar
cucumber-testng-7.x.jar
gherkin-26.x.jar
selenium-java-4.x.jar
```

### Step 2: Write Feature File

```gherkin
# src/test/resources/features/login.feature
Feature: Login to Application

  Scenario: Successful Login
    Given the browser is launched and application is opened
    When the user enters username "admin" and password "Admin@123"
    And the user clicks the Login button
    Then the user should be on the dashboard page
```

### Step 3: Create Step Definitions

```java
package stepDefinitions;

import io.cucumber.java.en.*;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import io.github.bonigarcia.wdm.WebDriverManager;
import static org.testng.Assert.*;

public class LoginSteps {

    WebDriver driver;

    @Before
    public void setup() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    @Given("the browser is launched and application is opened")
    public void launchApp() {
        driver.get("https://example.com");
    }

    @When("the user enters username {string} and password {string}")
    public void enterCredentials(String user, String pass) {
        driver.findElement(By.id("username")).sendKeys(user);
        driver.findElement(By.id("password")).sendKeys(pass);
    }

    @When("the user clicks the Login button")
    public void clickLogin() {
        driver.findElement(By.id("loginBtn")).click();
    }

    @Then("the user should be on the dashboard page")
    public void verifyDashboard() {
        assertTrue(driver.getTitle().contains("Dashboard"));
    }

    @After
    public void teardown() {
        if (driver != null) driver.quit();
    }
}
```

### Step 4: Create TestRunner

```java
package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
    features = "src/test/resources/features",
    glue = "stepDefinitions",
    plugin = {"pretty", "html:target/cucumber-report.html"},
    monochrome = true
)
public class TestRunner extends AbstractTestNGCucumberTests {}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','Selenium','Integration','Maven','TestRunner'],
  true, 0
),

-- Q19
(
  'When is Cucumber used in real-time projects?',
  'cucumber-q019-cucumber-real-time-use',
  'Cucumber is used in Agile projects for BDD acceptance testing where non-technical stakeholders co-author test scenarios. It is ideal when business requirements change frequently and living documentation is needed.',
  $ans$
## Cucumber in Real-Time Projects

### Primary Use Cases

**1. Acceptance Testing (Most Common)**
Cucumber is primarily used to write **acceptance tests** — validating that the application meets business requirements from a user perspective.

```
Business Requirement: "User should be able to log in with valid credentials"
                          ↓
Cucumber Feature File: Scenario with Given/When/Then
                          ↓
Automated Test: Selenium + Cucumber executes against real app
```

**2. Who Uses Cucumber in Real Teams?**
- **Functional Testers** — write and execute feature files
- **Business Analysts** — co-author Gherkin scenarios
- **Non-technical stakeholders** — review feature files as documentation
- **Developers** — write step definitions and implement features to pass tests

**3. BDD-Driven Development Workflow**

```
Sprint Planning:
  PO/BA → writes user stories
         ↓
  Team → writes Gherkin scenarios together (3 Amigos: BA + Dev + QA)
         ↓
  Dev → codes until Cucumber tests pass (BDD)
         ↓
  QA → adds more edge case scenarios
         ↓
  CI → Cucumber runs on every commit in Jenkins/GitHub Actions
```

### Real-Time Integration Stack

```
Cucumber (BDD framework)
  + Selenium WebDriver (UI automation)
  + TestNG (runner, parallel execution)
  + Allure / ExtentReports (rich HTML reports)
  + Jenkins + Maven (CI/CD pipeline)
  + Git (version control for .feature files)
```

### When Cucumber Is the Right Choice

| Cucumber Fits | Cucumber May Not Fit |
|---|---|
| Agile teams with active BA involvement | Pure unit/integration testing |
| Multiple stakeholders review tests | Solo developer project |
| Requirements change frequently | Highly technical, low-level tests |
| Living documentation needed | Performance/load testing |
| Client needs to see test scenarios | Simple CRUD with no business logic |

### When NOT to Use

- Unit tests (use JUnit/TestNG directly)
- Performance testing (use JMeter/Gatling)
- API-only testing with no business stakeholders (use REST Assured directly)
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Real Time','Agile','Acceptance Testing'],
  true, 0
),

-- Q20
(
  'Provide an example of the Background keyword in Cucumber.',
  'cucumber-q020-background-example',
  'Background keyword example showing common precondition steps (navigating to login page) that execute before every scenario in the feature file, avoiding duplication across scenarios.',
  $ans$
## Background Keyword Example

### Basic Example

```gherkin
Feature: Banking Application

  Background:
    Given the user is on the application login page

  Scenario: Check account balance
    When the user logs in with valid credentials
    And navigates to "My Account"
    Then the balance "$5,000" should be displayed

  Scenario: Transfer funds
    When the user logs in with valid credentials
    And initiates a transfer of "$200" to account "ACC-789"
    Then the transaction should show "Transfer Successful"
```

The `Background` step `"Given the user is on the application login page"` runs **before each** scenario automatically.

### Real-World Background Example

```gherkin
Feature: E-Commerce Product Management (Admin)

  Background:
    Given the admin opens the Chrome browser
    And the admin navigates to the admin portal
    And the admin logs in with username "admin" and password "Admin@123"
    And the admin is on the Products management page

  Scenario: Add new product
    When the admin clicks "Add New Product"
    And fills in product name "Wireless Headphones"
    And sets price "89.99"
    And clicks "Save Product"
    Then the success message "Product added successfully" should appear

  Scenario: Edit existing product price
    When the admin finds product "Wireless Headphones"
    And updates the price to "79.99"
    And clicks "Update"
    Then the price should show "79.99" in the product list

  Scenario: Delete a product
    When the admin finds product "Old Product"
    And clicks the Delete icon
    And confirms deletion
    Then the product should no longer appear in the list
```

### Execution Order

```
Scenario 1 runs as:
  Given the admin opens Chrome          ← Background
  And admin navigates to portal         ← Background
  And admin logs in                     ← Background
  And admin is on Products page         ← Background
  When admin clicks "Add New Product"   ← Scenario step
  ...

Scenario 2 runs as:
  Given the admin opens Chrome          ← Background (again)
  And admin navigates to portal         ← Background (again)
  ...
```

### Background as Precondition

```gherkin
Background:
  Given the user is on the application login page

-- This is equivalent to writing this in EVERY scenario:
Scenario: Some test
  Given the user is on the application login page
  When ...
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Background','Precondition','Example'],
  true, 0
),

-- Q21
(
  'What is the use of Behaviour Driven Development (BDD) in Agile methodology?',
  'cucumber-q021-bdd-in-agile',
  'BDD in Agile enables non-technical users like Business Analysts to draft requirements as Gherkin scenarios that developers implement. User stories can be written as feature files, shared across all Agile roles.',
  $ans$
## BDD in Agile Methodology

### The Connection

In Agile, requirements are expressed as **User Stories** ("As a user, I want to... so that..."). BDD extends this by converting user stories into **executable Gherkin scenarios** that serve as both specification and test.

### Traditional Agile vs BDD-Agile

```
Traditional Agile:
  Sprint → User story written in Jira
         → Dev interprets and codes
         → QA writes test cases separately
         → Gaps found late (expensive)

BDD-Agile (with Cucumber):
  Sprint Planning → 3 Amigos session (BA + Dev + QA)
                 → Write Gherkin scenarios together
                 → Dev codes until scenarios pass
                 → QA automates the same scenarios
                 → No interpretation gap
```

### Three Amigos — Core BDD Practice

```
BA  → "What does the feature need to do?"
Dev → "How will we build it?"
QA  → "How can this possibly fail?"
         ↓
   Together → Write Gherkin scenarios
```

### Advantages in Agile Context

**1. Non-technical collaboration**
BAs use BDD to draft requirements as Gherkin feature files and provide them to developers for implementation — eliminating the Word document → misunderstanding cycle.

**2. User Stories as Feature Files**
```
User Story:
  As a registered customer, I want to reset my password
  So that I can regain access to my account

Becomes Gherkin Feature:
  Scenario: Reset password via email
    Given the user is on the login page
    When the user clicks "Forgot Password"
    And enters email "user@example.com"
    Then a password reset link should be sent
```

**3. Living Documentation in Sprints**
Feature files checked into Git serve as always-current documentation. Unlike Word docs, they can't become stale — if the test passes, the documentation is accurate.

**4. Continuous Testing in CI/CD**
```
Developer pushes code
      ↓
Jenkins runs Cucumber tests automatically
      ↓
Feature file scenarios pass/fail = instant feedback
      ↓
Broken behavior detected within minutes, not sprint-end
```

### BDD Tools Used in Agile

| Tool | Role |
|---|---|
| Cucumber | BDD framework (Java/JS) |
| Jira + Xray | Link Gherkin scenarios to user stories |
| Confluence | Publish Cucumber HTML reports |
| Jenkins | Trigger Cucumber on every PR merge |
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Agile','User Story','Sprint'],
  true, 0
),

-- Q22
(
  'Explain the purpose of keywords used for writing a scenario in Cucumber.',
  'cucumber-q022-scenario-keywords-purpose',
  'Given sets preconditions, When describes the action/event, Then specifies the expected outcome, And continues any step, But adds a negative continuation. Together they form a complete BDD scenario.',
  $ans$
## Purpose of Scenario Keywords in Cucumber

### The Five Step Keywords Explained

#### 1. `Given` — Precondition
Sets up the **initial state** of the system before any action is performed. Describes what is true at the start of the scenario.

```gherkin
Given the user is on the login page
Given the shopping cart contains 3 items
Given the database has a record with ID "001"
```

#### 2. `When` — Action
Describes the **action or event** that the user performs. This is the trigger that initiates the behavior being tested.

```gherkin
When the user enters the username "admin"
When the user clicks the Submit button
When the user deletes the item from cart
```

#### 3. `Then` — Expected Outcome
Specifies the **observable outcome** or assertion — what should happen after the `When` action. Always maps to an assertion in the step definition.

```gherkin
Then the dashboard should be displayed
Then the error message "Invalid login" should appear
Then the cart total should update to "$699"
```

#### 4. `And` — Continuation
Used to **join multiple steps of the same type** (Given, When, or Then) without repeating the keyword. Makes scenarios more readable.

```gherkin
Given the user is on the login page
And the user has valid credentials           ← same as Given

When the user enters username "admin"
And the user enters password "Admin@123"     ← same as When
And the user clicks Login                    ← same as When

Then the dashboard should be visible
And the welcome message should be displayed  ← same as Then
```

#### 5. `But` — Negative Continuation
Used to add a **negative condition** after Then or Given. Semantically similar to `And`, but adds negative contrast for readability.

```gherkin
Then the user should be logged in
But the admin panel should not be visible
But the error message should not appear
```

### Full Scenario Using All Keywords

```gherkin
Scenario: Successful product purchase
  Given the user is logged in as "customer"
  And the user has $500 credit available

  When the user adds "Headphones" to the cart
  And the user proceeds to checkout
  And the user selects "Credit Card" payment

  Then the order confirmation page should appear
  And the order ID should be generated
  But the payment error should not be displayed
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Given When Then','Keywords','Scenario'],
  true, 0
),

-- Q23
(
  'What is the name of the plugin used to integrate Eclipse with Cucumber?',
  'cucumber-q023-eclipse-cucumber-plugin',
  'The Cucumber Natural Language Plugin (also called "Cucumber Eclipse Plugin") is used to integrate Eclipse IDE with Cucumber, providing syntax highlighting, step navigation, and Gherkin auto-completion.',
  $ans$
## Eclipse Plugin for Cucumber

### Plugin Name
**Cucumber Natural Language Plugin** (also referred to as "Cucumber Eclipse Plugin")

This plugin adds Cucumber/Gherkin support to Eclipse IDE.

### Features of the Plugin

| Feature | Description |
|---|---|
| Syntax highlighting | Colors for Feature, Scenario, Given/When/Then keywords |
| Step navigation | Ctrl+Click on a step to jump to its step definition |
| Auto-completion | Suggestions for existing step definitions while typing |
| Error detection | Highlights steps with no matching step definition |
| Run support | Right-click > Run As > Cucumber Feature |

### How to Install in Eclipse

```
1. Eclipse → Help → Eclipse Marketplace
2. Search: "Cucumber"
3. Select "Cucumber Eclipse Plugin" or "Cucumber Natural Language Plugin"
4. Click Install → Restart Eclipse
```

### Alternative: Install via Update Site

```
Help → Install New Software
URL: https://cucumber.github.com/cucumber-eclipse/update-site
```

### IDE Comparison

| IDE | Plugin |
|---|---|
| **Eclipse** | Cucumber Natural Language Plugin |
| **IntelliJ IDEA** | Cucumber for Java (built-in Ultimate, plugin for Community) |
| **VS Code** | Cucumber (Gherkin) Full Support extension |

### After Installation

1. `.feature` files show syntax highlighting
2. When you type a step that has no step definition, it's underlined in red
3. Right-click on a step → "Create Step Definition" auto-generates the method
4. Clicking a step → jumps to corresponding Java method

### Verify Plugin Is Working

```
1. Open any .feature file
2. Keywords should be colored (Feature=bold, Given/When/Then=colored)
3. Right-click in feature file → "Run As" should show "Cucumber Feature"
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Eclipse','Plugin','IDE'],
  true, 0
),

-- Q24
(
  'What is the meaning of the TestRunner class in Cucumber?',
  'cucumber-q024-testrunner-class',
  'TestRunner class is the entry point for Cucumber test execution. It is an empty class annotated with @CucumberOptions that specifies feature file path, glue path, plugins, and tags to control which tests run.',
  $ans$
## TestRunner Class in Cucumber

### Definition

The **TestRunner** class is the **starting point of execution** for Cucumber tests. It is typically an **empty class** (no code in the body) that uses annotations to configure Cucumber behavior.

### Why It''s Empty

The TestRunner class itself contains **no code** — all configuration is done through the `@CucumberOptions` annotation. The actual execution is delegated to the Cucumber runner (TestNG or JUnit).

```java
package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
    features = "src/test/resources/features",
    glue = {"stepDefinitions"},
    plugin = {"pretty", "html:target/report.html"},
    monochrome = true
)
public class TestRunner extends AbstractTestNGCucumberTests {
    // No code here — Cucumber handles execution
}
```

### Key Responsibilities

| Responsibility | How |
|---|---|
| Link feature files | `features = "path/to/features"` |
| Link step definitions | `glue = {"stepDefinitions", "hooks"}` |
| Configure reporting | `plugin = {"html:...", "json:..."}` |
| Filter scenarios | `tags = "@smoke"` |
| Dry run check | `dryRun = true` |

### TestNG vs JUnit Runner

**With TestNG:**
```java
import io.cucumber.testng.AbstractTestNGCucumberTests;
@CucumberOptions(...)
public class TestRunner extends AbstractTestNGCucumberTests {}
```

**With JUnit 4:**
```java
import org.junit.runner.RunWith;
import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;

@RunWith(Cucumber.class)
@CucumberOptions(...)
public class TestRunner {}
```

**With JUnit 5 (modern):**
```java
import org.junit.platform.suite.api.*;
@Suite
@IncludeEngines("cucumber")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "stepDefinitions")
@ConfigurationParameter(key = FEATURES_PROPERTY_NAME, value = "src/test/resources/features")
class TestRunner {}
```

### Execution Flow

```
TestRunner (entry point)
    ↓ reads @CucumberOptions
    ↓ finds .feature files
    ↓ loads step definitions from glue package
    ↓ matches Gherkin steps to Java methods
    ↓ executes test scenarios
    ↓ generates reports via plugins
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','TestRunner','CucumberOptions','TestNG'],
  true, 0
),

-- Q25
(
  'Provide an example of the TestRunner class in Cucumber.',
  'cucumber-q025-testrunner-example',
  'TestRunner class example showing @CucumberOptions with features, glue, plugin (pretty and HTML report), DryRun, Monochrome configuration extending AbstractTestNGCucumberTests.',
  $ans$
## TestRunner Class Example

### Basic TestRunner with TestNG

```java
package com.sample.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
    features = "src/test/resources/Features",
    glue = {"stepDefinitions"},
    plugin = {
        "pretty",
        "html:/report/report.html"
    },
    dryRun = false,
    monochrome = true
)
public class TestRunner extends AbstractTestNGCucumberTests {
    // Empty class body — Cucumber manages execution
}
```

### Production-Ready TestRunner

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
        "html:target/cucumber-reports/cucumber.html",
        "json:target/cucumber-reports/cucumber.json",
        "junit:target/cucumber-reports/cucumber.xml",
        "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm"
    },
    tags = "@smoke and not @skip",
    dryRun = false,
    monochrome = true,
    publish = false
)
public class TestRunner extends AbstractTestNGCucumberTests {

    // Enable parallel execution by scenario
    @Override
    @DataProvider(parallel = true)
    public Object[][] scenarios() {
        return super.scenarios();
    }
}
```

### JUnit TestRunner

```java
package com.sample;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
    features = "Features",
    glue = {"StepDefinition"},
    plugin = {"pretty", "html:/report/report.html"},
    dryRun = false,
    monochrome = true
)
public class Runner {
    // Empty — @RunWith(Cucumber.class) delegates execution
}
```

### How to Run

```bash
# Maven command line
mvn test -Dcucumber.filter.tags="@smoke"

# Specific feature
mvn test -Dcucumber.features="src/test/resources/features/login.feature"

# With testng.xml
mvn test -DsuiteXmlFile=testng.xml
```

### testng.xml for Cucumber

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.9.dtd">
<suite name="Cucumber Suite" parallel="false">
    <test name="Regression Tests">
        <classes>
            <class name="runners.TestRunner"/>
        </classes>
    </test>
</suite>
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','TestRunner','Example','CucumberOptions'],
  true, 0
),

-- Q26
(
  'What is the starting point of execution for Cucumber feature files?',
  'cucumber-q026-execution-starting-point',
  'When Cucumber is integrated with Selenium, the starting point of execution is the TestRunner class. Cucumber reads @CucumberOptions from TestRunner to locate and execute the feature files.',
  $ans$
## Starting Point of Execution in Cucumber

### Answer: The TestRunner Class

When Cucumber is integrated with Selenium (and TestNG/JUnit), the **TestRunner class** is the starting point of execution. You run this class (or specify it in testng.xml) to trigger all Cucumber tests.

### Execution Flow from TestRunner

```
1. JVM starts TestRunner class
          ↓
2. @CucumberOptions is read:
   - features → where .feature files are
   - glue → where step definitions are
   - plugin → report format and path
   - tags → which scenarios to run
          ↓
3. Cucumber scans feature files in the features path
          ↓
4. For each Scenario:
   - Matches each step to a @Given/@When/@Then method
   - Executes @Before hooks
   - Executes step methods in order
   - Executes @After hooks
          ↓
5. Reports generated via plugin configuration
```

### Ways to Trigger Execution

| Method | How |
|---|---|
| **IDE** | Right-click TestRunner → Run As → TestNG Test |
| **Maven** | `mvn test` (if TestRunner is configured in pom.xml) |
| **testng.xml** | `mvn test -DsuiteXmlFile=testng.xml` |
| **Command line** | `java -cp ... io.cucumber.core.cli.Main --features ...` |
| **Jenkins** | Maven build step with `mvn test` |
| **Feature file** | Right-click .feature file → Run As → Cucumber Feature |

### Setting Up Maven Surefire for TestRunner

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.2.5</version>
    <configuration>
        <suiteXmlFiles>
            <suiteXmlFile>testng.xml</suiteXmlFile>
        </suiteXmlFiles>
    </configuration>
</plugin>
```

### Note on Feature File Direct Execution
You can right-click a `.feature` file and run it directly in IDE — but in CI/CD pipelines, the TestRunner class is always the starting point.
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','TestRunner','Execution','Maven'],
  true, 0
),

-- Q27
(
  'Should any code be written within the TestRunner class in Cucumber?',
  'cucumber-q027-testrunner-no-code',
  'No code should be written inside the TestRunner class body. It should only include @CucumberOptions annotation (and @RunWith in JUnit). All logic goes in step definitions and hooks.',
  $ans$
## Code in TestRunner Class

### Answer: No Code Inside the Class Body

The **TestRunner class should be empty** — no methods, no logic, no assertions inside its class body. It should only include:

1. Package declaration
2. Import statements
3. `@CucumberOptions` annotation
4. Class declaration (extending `AbstractTestNGCucumberTests` for TestNG)

### Correct TestRunner (Empty Body)

```java
package runners;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

// All configuration is in the annotation — no code in the body
@CucumberOptions(
    features = "src/test/resources/features",
    glue = {"stepDefinitions", "hooks"}
)
public class TestRunner extends AbstractTestNGCucumberTests {
    // NOTHING HERE — this is intentional and correct
}
```

### Exception: Parallel Execution DataProvider

The only acceptable code is overriding `scenarios()` for parallel execution:

```java
@CucumberOptions(...)
public class TestRunner extends AbstractTestNGCucumberTests {

    @Override
    @DataProvider(parallel = true)  // ← only allowed code
    public Object[][] scenarios() {
        return super.scenarios();
    }
}
```

### Where Should Code Go?

| Code Type | Where It Lives |
|---|---|
| Browser setup / teardown | `@Before` / `@After` in Hooks.java |
| Step actions (click, type) | Step Definition classes |
| Page interactions | Page Object classes |
| Test data | Properties files / Excel / DataProvider |
| Assertions | Step definition `@Then` methods |
| Driver management | BaseTest / DriverFactory class |

### Why Keep TestRunner Empty?

1. **Separation of Concerns** — TestRunner configures, step definitions act
2. **Readability** — Configuration in one place, logic in another
3. **Cucumber convention** — Framework is designed for empty runner
4. **Maintainability** — Changing test behavior = change step defs, not runner
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','TestRunner','Best Practice','Code Structure'],
  true, 0
),

-- Q28
(
  'What is the use of the features property under @CucumberOptions?',
  'cucumber-q028-features-property',
  'The features property in @CucumberOptions tells Cucumber where to find .feature files. It accepts a file path string or array of paths. Cucumber scans these locations to load all Gherkin scenarios.',
  $ans$
## features Property in @CucumberOptions

### Purpose
The `features` property tells the Cucumber framework **where to find the `.feature` files** that contain Gherkin scenarios. Without this, Cucumber does not know which scenarios to execute.

### Syntax

```java
@CucumberOptions(
    features = "src/test/resources/features"
)
```

### Supported Path Formats

```java
// Single directory — all .feature files inside
features = "src/test/resources/features"

// Specific feature file
features = "src/test/resources/features/login.feature"

// Multiple locations (array)
features = {
    "src/test/resources/features/login",
    "src/test/resources/features/checkout"
}

// Specific scenario by line number
features = "src/test/resources/features/login.feature:15"

// Classpath (when resources are in classpath)
features = "classpath:features"
```

### Directory Scanning

When you provide a directory path, Cucumber **recursively scans** all subdirectories for `.feature` files:

```
src/test/resources/features/          ← features = "src/test/resources/features"
  login/
    login.feature         ← found
    login_forgot.feature  ← found
  checkout/
    payment.feature       ← found
    shipping.feature      ← found
  cart/
    add_to_cart.feature   ← found
```

### Common Mistakes

```java
// WRONG — path doesn't exist
features = "features"  // relative path might not resolve

// WRONG — missing the full path
features = "resources/features"

// CORRECT
features = "src/test/resources/features"
```

### Override from Maven Command Line

```bash
# Run only smoke features
mvn test -Dcucumber.features="src/test/resources/features/login.feature"

# Run specific scenario (by line number)
mvn test -Dcucumber.features="src/test/resources/features/login.feature:25"
```

### Combined with Tags

```java
@CucumberOptions(
    features = "src/test/resources/features",  // WHERE
    tags = "@smoke"                             // WHICH scenarios
)
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','CucumberOptions','features','Configuration'],
  true, 0
),

-- Q29
(
  'What is the use of the glue property under @CucumberOptions?',
  'cucumber-q029-glue-property',
  'The glue property specifies the Java package(s) where Cucumber looks for step definitions and hooks. It maps Gherkin steps to Java methods by scanning the specified packages for @Given/@When/@Then annotations.',
  $ans$
## glue Property in @CucumberOptions

### Purpose
The `glue` property tells Cucumber **where to find the step definitions and hooks**. It specifies the Java package(s) that contain classes annotated with `@Given`, `@When`, `@Then`, `@Before`, and `@After`.

Glue is the binding between plain English Gherkin steps and actual Java implementation code.

### Syntax

```java
@CucumberOptions(
    glue = "stepDefinitions"
    // OR
    glue = {"stepDefinitions", "hooks"}
)
```

### Single Package

```java
@CucumberOptions(
    features = "src/test/resources/features",
    glue = "stepDefinitions"   // All step defs in stepDefinitions package
)
```

### Multiple Packages

```java
@CucumberOptions(
    features = "src/test/resources/features",
    glue = {
        "stepDefinitions",    // Step definition classes
        "hooks",              // @Before/@After hook classes
        "utils"               // Utility classes with @ParameterType
    }
)
```

### Project Structure with Glue

```
src/
  test/
    java/
      stepDefinitions/        ← glue = "stepDefinitions"
        LoginSteps.java
        RegistrationSteps.java
        CheckoutSteps.java
      hooks/                  ← glue includes "hooks"
        Hooks.java
        ScreenshotHook.java
      runners/
        TestRunner.java
```

### What Happens Without Correct Glue

```
Error: io.cucumber.junit.UndefinedStepException
  Step "When the user clicks Login" is undefined

Reason: Cucumber couldn't find the step definition
        because the package isn't listed in glue
```

### Common Mistakes

```java
// WRONG — wrong package name
glue = "stepDefinition"   // should be "stepDefinitions"

// WRONG — using file path instead of package name
glue = "src/test/java/stepDefinitions"  // should be just "stepDefinitions"

// CORRECT
glue = {"stepDefinitions", "hooks"}
```

### Difference: features vs glue

| Property | Purpose | Example |
|---|---|---|
| `features` | Where `.feature` files are (file path) | `"src/test/resources/features"` |
| `glue` | Where step definitions are (Java package) | `"stepDefinitions"` |
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','CucumberOptions','glue','Step Definition'],
  true, 0
),

-- Q30
(
  'How do you execute a Cucumber feature file from the command line?',
  'cucumber-q030-command-line-execution',
  'Cucumber feature files are executed via Maven using mvn test. You can pass tags, specific feature files, and cucumber options as -D system properties on the command line.',
  $ans$
## Executing Cucumber from the Command Line

### Basic Maven Execution

```bash
# Run all tests (all feature files in configured path)
mvn test

# Run with specific testng.xml
mvn test -DsuiteXmlFile=testng.xml
```

### Run Specific Scenario by Line Number

```bash
# Run specific line in feature file
mvn test -Dcucumber.features="src/test/features/login.feature:4"

# The original command format
mvn test -Dcucumber.option="src/test/features/login.feature:4"
```

### Filter by Tags

```bash
# Run only @smoke tests
mvn test -Dcucumber.filter.tags="@smoke"

# Run @regression but exclude @slow
mvn test -Dcucumber.filter.tags="@regression and not @slow"

# Run @smoke OR @sanity
mvn test -Dcucumber.filter.tags="@smoke or @sanity"
```

### Run Specific Feature File

```bash
mvn test -Dcucumber.features="src/test/resources/features/login.feature"
```

### Pass Multiple Options

```bash
mvn test \
  -Dcucumber.features="src/test/resources/features" \
  -Dcucumber.filter.tags="@smoke" \
  -Dcucumber.plugin="html:target/report.html,json:target/cucumber.json"
```

### Skip Tests (just compile)

```bash
mvn test -DskipTests
```

### Environment-Specific Execution

```bash
# Pass browser type as system property
mvn test -Dbrowser=firefox -Denvironment=staging
```

### Complete CLI Execution Reference

```bash
# Standard run
mvn clean test

# Specific tag
mvn clean test -Dcucumber.filter.tags="@login"

# Specific feature file
mvn clean test -Dcucumber.features="src/test/resources/features/login.feature"

# Specific scenario line
mvn clean test -Dcucumber.features="src/test/resources/features/login.feature:12"

# Run with profile (Maven profile)
mvn clean test -Pstaging
```

### Without Maven (Direct Java)

```bash
java -cp "target/classes:target/test-classes:lib/*" \
  io.cucumber.core.cli.Main \
  --features src/test/resources/features \
  --glue stepDefinitions \
  --plugin html:target/report.html \
  --tags @smoke
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Beginner',
  ARRAY['Cucumber','BDD','Maven','Command Line','Execution'],
  true, 0
),

-- Q31
(
  'How do you take a screenshot for a failed scenario in Cucumber?',
  'cucumber-q031-screenshot-failed-scenario',
  'Use the @After hook in Cucumber — check scenario.isFailed(), capture screenshot with TakesScreenshot, and attach it to the scenario report using scenario.attach() for embedding in HTML reports.',
  $ans$
## Screenshot for Failed Scenarios in Cucumber

### Method 1: Using @After Hook with Scenario (Recommended)

```java
package hooks;

import io.cucumber.java.After;
import io.cucumber.java.Scenario;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

public class Hooks {

    WebDriver driver = DriverManager.getDriver(); // get from ThreadLocal

    @After
    public void closeBrowser(Scenario scenario) {
        if (scenario.isFailed()) {
            // Capture screenshot as byte array
            byte[] screenshot = ((TakesScreenshot) driver)
                .getScreenshotAs(OutputType.BYTES);

            // Attach to Cucumber HTML report
            scenario.attach(screenshot, "image/png", "Failure Screenshot");
        }

        if (driver != null) {
            driver.quit();
        }
    }
}
```

### Method 2: Save to File + Attach

```java
@After
public void closeBrowser(Scenario scenario) {
    if (scenario.isFailed()) {
        // Save to file
        File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        String path = "screenshots/" + scenario.getName().replaceAll(" ", "_") + ".png";
        FileUtils.copyFile(src, new File(path));

        // Also embed in report
        byte[] bytes = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
        scenario.attach(bytes, "image/png", scenario.getName());
    }
    driver.quit();
}
```

### Legacy Method (Cucumber 4 and below)

```java
@After
public void closeBrowser(Scenario scenario) {
    if (scenario.isFailed()) {
        // write code for screenshot
        byte[] screenshot = ((TakesScreenshot) driver)
            .getScreenshotAs(OutputType.BYTES);
        scenario.embed(screenshot, "image/png");  // deprecated in v5+
    }
}
```

### Where Screenshots Appear

When using `scenario.attach()`:
- Screenshot is **embedded** in the Cucumber HTML report
- Click on failed scenario → screenshot visible inline
- JSON report includes base64-encoded image

### Full Hooks.java Structure

```java
public class Hooks {

    @Before
    public void setUp(Scenario scenario) {
        // Initialize driver before scenario
        System.out.println("Starting: " + scenario.getName());
        DriverManager.initDriver("chrome");
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] screenshot = ((TakesScreenshot) DriverManager.getDriver())
                .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Failure Screenshot");
        }
        DriverManager.quitDriver();
    }
}
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','Screenshot','Failed Scenario','Hooks'],
  true, 0
),

-- Q32
(
  'What is the difference between Hooks and Background in Cucumber?',
  'cucumber-q032-hooks-vs-background',
  'Background contains Gherkin steps visible to all stakeholders and runs before scenarios in the same feature file. Hooks are Java methods (@Before/@After) invisible in feature files, applying globally or by tag across all features.',
  $ans$
## Hooks vs Background in Cucumber

### Side-by-Side Comparison

| | Background | Hooks (@Before/@After) |
|---|---|---|
| **Written in** | Feature file (Gherkin) | Java step definition class |
| **Visible to** | Everyone (BA, PMs, non-tech) | Developers only |
| **Applies to** | Only current feature file | All scenarios (global) |
| **Tagged scope** | No | Yes (`@Before("@login")`) |
| **Language** | Plain English | Java code |
| **Purpose** | Business preconditions | Technical setup/teardown |
| **Mapped in reports** | Yes (as scenario steps) | Yes (as Before/After section) |

### Background — Business Preconditions

```gherkin
Feature: User Account Management

  Background:                               # ← in .feature file
    Given the user is on the login page     # ← visible to BA/PO
    And the user is logged in               # ← plain English

  Scenario: View profile
    When the user clicks "My Profile"
    Then the profile page should load

  Scenario: Update email
    When the user updates email to "new@test.com"
    Then success message should appear
```

The Background steps run before **every scenario in this file only**.

### Hooks — Technical Setup

```java
package hooks;

import io.cucumber.java.Before;
import io.cucumber.java.After;
import io.cucumber.java.Scenario;

public class Hooks {

    // Runs before EVERY scenario across ALL feature files
    @Before
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    // Runs after EVERY scenario across ALL feature files
    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] screenshot = ((TakesScreenshot) driver)
                .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Failure");
        }
        driver.quit();
    }

    // Runs only before scenarios tagged @login
    @Before("@login")
    public void loginSetup() {
        loginPage = new LoginPage(driver);
        loginPage.navigateTo();
    }
}
```

### When to Use Which

| Use Background | Use Hooks |
|---|---|
| Steps that make sense to non-technical readers | Browser/driver initialization |
| Preconditions specific to one feature area | Taking screenshots on failure |
| Part of the "living documentation" | Database setup/teardown |
| UI navigation steps (Given the user is on...) | Injecting test data via API |
| Visible to BA in sprint review | Configuring test environment |

### Execution Order

```
@Before hook (global)
    → Background step 1
    → Background step 2
    → Scenario step 1
    → Scenario step 2
    → ...
@After hook (global)
```
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','Hooks','Background','Before After'],
  true, 0
),

-- Q33
(
  'How do you implement data-driven testing in Cucumber BDD?',
  'cucumber-q033-data-driven-testing',
  'Data-driven testing in Cucumber is done using Scenario Outline + Examples table (built-in), or using DataTable in step definitions for inline tables, or reading from external Excel/JSON/CSV files via custom DataProvider.',
  $ans$
## Data-Driven Testing in Cucumber BDD

### Approach 1: Scenario Outline + Examples (Built-in — Most Common)

```gherkin
Feature: Login Validation

  Scenario Outline: Login with multiple users
    Given the user is on the login page
    When the user enters "<username>" and "<password>"
    Then the result should be "<expected>"

    Examples:
      | username        | password    | expected          |
      | admin@test.com  | Admin@123   | Dashboard         |
      | user@test.com   | User@456    | Home Page         |
      | wrong@test.com  | badpass     | Invalid Credentials |
      | locked@test.com | Locked@123  | Account Locked    |
```

**Step Definition:**
```java
@When("the user enters {string} and {string}")
public void enterCredentials(String username, String password) {
    driver.findElement(By.id("email")).sendKeys(username);
    driver.findElement(By.id("password")).sendKeys(password);
}

@Then("the result should be {string}")
public void verifyResult(String expected) {
    assertTrue(driver.getPageSource().contains(expected));
}
```

### Approach 2: DataTable (Inline Table in Step)

```gherkin
Scenario: Register with full form data
  Given the user fills in the registration form:
    | Field     | Value             |
    | FirstName | John              |
    | LastName  | Doe               |
    | Email     | john@example.com  |
    | Mobile    | 9876543210        |
    | Password  | Test@123          |
  Then the user should be registered successfully
```

**Step Definition with DataTable:**
```java
@Given("the user fills in the registration form:")
public void fillRegistrationForm(DataTable dataTable) {
    Map<String, String> formData = dataTable.asMap(String.class, String.class);

    driver.findElement(By.id("firstName")).sendKeys(formData.get("FirstName"));
    driver.findElement(By.id("lastName")).sendKeys(formData.get("LastName"));
    driver.findElement(By.id("email")).sendKeys(formData.get("Email"));
    driver.findElement(By.id("mobile")).sendKeys(formData.get("Mobile"));
    driver.findElement(By.id("password")).sendKeys(formData.get("Password"));
}
```

### Approach 3: External Data (Excel/JSON)

```java
// Read from Excel using Apache POI
@When("the user tests login with external data")
public void loginWithExternalData() throws Exception {
    FileInputStream fis = new FileInputStream("testdata/login.xlsx");
    XSSFWorkbook workbook = new XSSFWorkbook(fis);
    XSSFSheet sheet = workbook.getSheetAt(0);

    for (Row row : sheet) {
        String username = row.getCell(0).getStringCellValue();
        String password = row.getCell(1).getStringCellValue();
        // perform login with each row
    }
    workbook.close();
}
```

### Comparison

| Approach | Best For | Visibility |
|---|---|---|
| Scenario Outline | Simple tabular data | Feature file (BA visible) |
| DataTable | Complex form data | Feature file (BA visible) |
| External Excel/JSON | Large data sets | Java only (not in feature file) |
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','Data Driven','Scenario Outline','DataTable','Excel'],
  true, 0
),

-- Q34
(
  'What are Data Tables in Cucumber and what are their use cases?',
  'cucumber-q034-data-tables',
  'Data Tables in Cucumber are inline tables within a Gherkin step (using pipe | separator) that pass structured data to step definitions as a DataTable object. They are used for form submission, bulk data, and list verification.',
  $ans$
## Data Tables in Cucumber

### Definition

A **Data Table** is a table of values passed directly within a Gherkin step using the pipe `|` character as column separator. Unlike Scenario Outline (which drives multiple scenario runs), a Data Table passes all data to a **single step execution**.

### Syntax

```gherkin
When the user submits the following form data:
  | Field     | Value            |
  | FirstName | John             |
  | Email     | john@example.com |
  | Phone     | 9876543210       |
```

### Use Cases

#### 1. Form Submission
```gherkin
Scenario: Submit contact form
  When the user fills in the contact form with:
    | Name    | Alice Smith       |
    | Email   | alice@example.com |
    | Message | Hello, I need help |
  Then the form should be submitted successfully
```

#### 2. Verifying a List
```gherkin
Scenario: Verify product list
  Then the homepage should display these products:
    | Laptop   |
    | Phone    |
    | Tablet   |
    | Watch    |
```

#### 3. API Request Body
```gherkin
Scenario: Create new user via API
  When I send a POST request to "/api/users" with:
    | Field    | Value          |
    | name     | John Doe       |
    | email    | john@test.com  |
    | role     | ADMIN          |
  Then the response status should be 201
```

### Accessing DataTable in Step Definition

```java
import io.cucumber.datatable.DataTable;
import java.util.*;

// As Map<String,String> (key-value pairs)
@When("the user fills in the contact form with:")
public void fillForm(DataTable dataTable) {
    Map<String, String> data = dataTable.asMap(String.class, String.class);
    driver.findElement(By.id("name")).sendKeys(data.get("Name"));
    driver.findElement(By.id("email")).sendKeys(data.get("Email"));
}

// As List<String> (single column)
@Then("the homepage should display these products:")
public void verifyProducts(DataTable dataTable) {
    List<String> expectedProducts = dataTable.asList(String.class);
    for (String product : expectedProducts) {
        assertTrue(driver.getPageSource().contains(product),
            "Product not found: " + product);
    }
}

// As List<Map<String,String>> (multiple rows with headers)
@When("the admin creates these users:")
public void createUsers(DataTable dataTable) {
    List<Map<String, String>> users = dataTable.asMaps(String.class, String.class);
    for (Map<String, String> user : users) {
        createUser(user.get("name"), user.get("email"), user.get("role"));
    }
}
```

### DataTable vs Scenario Outline

| | DataTable | Scenario Outline |
|---|---|---|
| Runs scenario | Once | Multiple times (one per row) |
| Data access | Via DataTable object | Via method parameters |
| Header row | Optional | Required (= placeholder names) |
| Use case | Structured data for one action | Multiple test iterations |
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Intermediate',
  ARRAY['Cucumber','BDD','DataTable','Data Driven','Gherkin'],
  true, 0
),

-- Q35
(
  'How do you pass data from one scenario to another in Cucumber?',
  'cucumber-q035-share-data-between-scenarios',
  'Scenarios in Cucumber are independent by design. To share data between scenarios, use Dependency Injection (PicoContainer), static variables, external storage (files/DB), or World object — though redesigning to avoid inter-scenario dependency is preferred.',
  $ans$
## Passing Data Between Scenarios in Cucumber

### The Problem

In Cucumber, **each Scenario runs in isolation** — this is by design. You cannot directly share state between scenarios because Cucumber intentionally isolates them.

```gherkin
-- You CANNOT directly do this:

Scenario: Generate token
  When I call the auth API
  Then I store the token   ← token created here

Scenario: Use token
  Given I use the token from previous scenario  ← this will NOT work
  When I call protected API
```

### Why Isolation Matters

Scenarios should be:
- **Independent** — run in any order, run individually
- **Idempotent** — same result every time
- **Reproducible** — pass/fail without depending on other tests

### Solutions for Sharing Data

#### Solution 1: Dependency Injection with PicoContainer (Recommended)

Share state within a feature using a shared **World** context object:

```xml
<!-- pom.xml -->
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-picocontainer</artifactId>
    <version>7.15.0</version>
</dependency>
```

```java
// Shared context class
public class TestContext {
    public String authToken;
    public String userId;
    public String orderId;
}

// Step definition that SETS data
public class AuthSteps {
    private TestContext context;

    public AuthSteps(TestContext context) {  // PicoContainer injects
        this.context = context;
    }

    @When("I authenticate with the API")
    public void authenticate() {
        String token = apiClient.getToken("user", "pass");
        context.authToken = token;  // ← stored in shared context
    }
}

// Step definition that USES data
public class OrderSteps {
    private TestContext context;

    public OrderSteps(TestContext context) {  // same instance injected
        this.context = context;
    }

    @When("I create an order")
    public void createOrder() {
        // Uses token set by AuthSteps (within same scenario)
        apiClient.createOrder(context.authToken, orderData);
    }
}
```

#### Solution 2: Static Variables (Simple but Risky)

```java
public class SharedState {
    public static String authToken;
    public static String userId;
}

// Setter step
@When("I authenticate")
public void authenticate() {
    SharedState.authToken = apiClient.login("user", "pass");
}

// Getter step (different scenario)
@Given("I am authenticated")
public void useToken() {
    apiClient.setToken(SharedState.authToken);
}
```

**Warning**: Static variables persist across scenarios — parallel execution will cause race conditions.

#### Solution 3: External Storage (Database / File / Redis)

```java
// Write token to file
@After
public void saveToken(Scenario scenario) {
    if (scenario.getName().contains("Generate Token")) {
        Files.write(Paths.get("token.txt"), authToken.getBytes());
    }
}

// Read token from file
@Before
public void loadToken(Scenario scenario) {
    if (scenario.getName().contains("Use Token")) {
        authToken = new String(Files.readAllBytes(Paths.get("token.txt")));
    }
}
```

### Best Practice: Redesign to Avoid Cross-Scenario Dependency

```gherkin
-- BETTER: Each scenario is self-contained
Scenario: Create and use order in one flow
  Given I am authenticated as "customer"     ← sets up everything needed
  When I create an order for "Laptop"
  Then the order should be in my order history
```

Use API calls in `@Before` hooks to set up preconditions rather than depending on other scenarios.
$ans$,
  'Cucumber', 'Interview Q&A', 'Fresher', 'Advanced',
  ARRAY['Cucumber','BDD','Scenario','Data Sharing','PicoContainer','World'],
  true, 0
);
