-- Selenium Interview Questions Q161–Q165
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q161
(
  'How to send an email stating the execution status to all stakeholders in Selenium?',
  'selenium-q161-send-email-execution-status-stakeholders',
  'Use javax.mail library in Java to send automated execution status emails from Selenium tests.',
  $ans$
## Sending Email in Selenium Using javax.mail

Selenium does not have a built-in email feature, but Java's **javax.mail** (Jakarta Mail) library lets you send emails programmatically — typically called after test execution to notify stakeholders of pass/fail results.

### Steps to Set Up

**1. Add Maven dependency:**

```xml
<dependency>
    <groupId>com.sun.mail</groupId>
    <artifactId>javax.mail</artifactId>
    <version>1.6.2</version>
</dependency>
```

**2. Write the email utility:**

```java
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtility {

    public static void sendEmail(String subject, String body) throws Exception {

        String host     = "smtp.gmail.com";
        String from     = "your-email@gmail.com";
        String password = "your-app-password";
        String to       = "stakeholder@company.com";

        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            host);
        props.put("mail.smtp.port",            "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(body);

        Transport.send(message);
        System.out.println("Email sent successfully!");
    }
}
```

**3. Call after test execution (e.g., in TestNG @AfterSuite):**

```java
@AfterSuite
public void sendReport() throws Exception {
    EmailUtility.sendEmail(
        "Test Execution Report - " + new Date(),
        "Total: 50 | Passed: 45 | Failed: 5 | Skipped: 0"
    );
}
```

### Best Practices
- Use Gmail **App Passwords** (not your real password) with 2FA enabled
- Attach the **ExtentReport HTML file** using `MimeBodyPart` for detailed reports
- Send to a **distribution list** rather than individual addresses
- Integrate with **Jenkins** to auto-email on build completion
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','Java','javax.mail','Email','Reporting','TestNG','Stakeholders'],
  true, 0
),

-- Q162
(
  'What is DesiredCapabilities in Selenium?',
  'selenium-q162-desired-capabilities-selenium',
  'DesiredCapabilities sets browser attributes like browser name, version, and platform before launching a WebDriver session.',
  $ans$
## DesiredCapabilities in Selenium

**DesiredCapabilities** is a class in Selenium used to set the **browser attributes and configuration** before launching a browser session via WebDriver. It tells Selenium which browser, version, OS, and features to use.

### Common Use Cases
- Setting browser name and version
- Configuring Selenium Grid (Hub + Node)
- Enabling/disabling JavaScript, SSL certificates
- Setting proxy, platform, and mobile emulation

### Example — ChromeDriver with Capabilities

```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

ChromeOptions options = new ChromeOptions();
options.addArguments("--disable-notifications");
options.addArguments("--incognito");
options.setAcceptInsecureCerts(true);       // accept SSL errors

WebDriver driver = new ChromeDriver(options);
driver.get("https://example.com");
```

### Example — Selenium Grid (RemoteWebDriver)

```java
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import java.net.URL;

DesiredCapabilities caps = new DesiredCapabilities();
caps.setBrowserName("chrome");
caps.setPlatform(Platform.LINUX);
caps.setVersion("latest");

WebDriver driver = new RemoteWebDriver(
    new URL("http://localhost:4444/wd/hub"), caps
);
```

### Key Methods

| Method | Description |
|---|---|
| `setBrowserName("chrome")` | Set which browser to use |
| `setPlatform(Platform.WIN10)` | Set the OS platform |
| `setVersion("latest")` | Set browser version |
| `setJavascriptEnabled(true)` | Enable/disable JS |
| `setAcceptInsecureCerts(true)` | Accept SSL errors |
| `setCapability("key", value)` | Set any custom capability |

### Note (Selenium 4)
In **Selenium 4**, `DesiredCapabilities` is largely replaced by browser-specific **Options** classes (`ChromeOptions`, `FirefoxOptions`, etc.), which provide stronger type safety and better IDE support.
  $ans$,
  'Selenium', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Selenium','DesiredCapabilities','ChromeOptions','WebDriver','Grid','Browser Configuration'],
  true, 0
),

-- Q163
(
  'What are version control tools used with Selenium like SVN and GIT?',
  'selenium-q163-version-control-tools-svn-git-selenium',
  'Version control tools like Git and SVN track code changes, enable team collaboration, and maintain history of your automation framework.',
  $ans$
## Version Control Tools in Selenium Automation

Version control tools are essential for managing your **Selenium automation framework source code**. They track changes, support collaboration, and allow rollback to previous versions.

### Most Common Tools

**1. Git + GitHub / GitLab / Bitbucket (Most Popular)**

Git is a distributed version control system. Every developer has a full copy of the repository locally.

```bash
# Initialize a repository
git init

# Add files to staging
git add src/test/java/tests/LoginTest.java

# Commit with message
git commit -m "Add login test automation"

# Push to remote (GitHub)
git push origin main

# Pull latest changes from team
git pull origin main

# Create a feature branch
git checkout -b feature/payment-tests
```

**2. SVN (Apache Subversion) — Centralized**

SVN is a centralized version control system — all code lives on a single server.

```bash
# Check out repository
svn checkout http://svn.company.com/repo/selenium-framework

# Add new file
svn add src/tests/NewTest.java

# Commit changes
svn commit -m "Add new regression test"

# Update local copy
svn update
```

### Git vs SVN Comparison

| Feature | Git | SVN |
|---|---|---|
| Type | Distributed | Centralized |
| Offline work | Yes | No |
| Branching | Fast and lightweight | Slower |
| Industry usage | Very high | Declining |
| CI/CD integration | Excellent | Good |

### Why Version Control Matters for Selenium
- Track who changed which test and when
- Merge changes from multiple team members
- Roll back broken test code instantly
- Trigger CI/CD pipelines (Jenkins, GitHub Actions) on push
- Maintain separate branches for different sprints or releases
  $ans$,
  'Selenium', 'Technical', '1-2 Years', 'Beginner',
  ARRAY['Selenium','Git','SVN','Version Control','GitHub','Collaboration','CI/CD'],
  true, 0
),

-- Q164
(
  'What are build tools used in Selenium like Ant and Maven?',
  'selenium-q164-build-tools-ant-maven-selenium',
  'Build tools like Maven and Ant manage project dependencies, compile code, and run Selenium test suites automatically.',
  $ans$
## Build Tools in Selenium — Ant and Maven

Build tools automate the process of **compiling, managing dependencies, and running tests** in your Selenium framework. They are essential for CI/CD integration.

### 1. Maven (Most Widely Used)

Maven uses a `pom.xml` file to declare dependencies and project structure.

```xml
<!-- pom.xml — Selenium + TestNG setup -->
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.automateqa</groupId>
  <artifactId>selenium-framework</artifactId>
  <version>1.0</version>

  <dependencies>
    <!-- Selenium WebDriver -->
    <dependency>
      <groupId>org.seleniumhq.selenium</groupId>
      <artifactId>selenium-java</artifactId>
      <version>4.18.1</version>
    </dependency>

    <!-- TestNG -->
    <dependency>
      <groupId>org.testng</groupId>
      <artifactId>testng</artifactId>
      <version>7.9.0</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <!-- Run TestNG suite via Maven -->
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
    </plugins>
  </build>
</project>
```

```bash
# Run all tests
mvn test

# Clean and run
mvn clean test

# Skip tests (just build)
mvn install -DskipTests
```

### 2. Ant (Older, XML-based)

Ant uses a `build.xml` file with explicit task definitions.

```xml
<!-- build.xml -->
<project name="SeleniumTests" default="run-tests">

  <path id="classpath">
    <fileset dir="lib" includes="*.jar"/>
  </path>

  <target name="compile">
    <javac srcdir="src" destdir="bin" classpathref="classpath"/>
  </target>

  <target name="run-tests" depends="compile">
    <testng classpathref="classpath" outputdir="test-output">
      <xmlfileset dir="." includes="testng.xml"/>
    </testng>
  </target>
</project>
```

```bash
# Run Ant build
ant run-tests
```

### Maven vs Ant

| Feature | Maven | Ant |
|---|---|---|
| Dependency management | Automatic (Maven Central) | Manual (copy JARs) |
| Convention | Convention over config | Fully manual |
| Learning curve | Low | Medium |
| Industry adoption | Very high | Low (legacy) |
| CI/CD support | Excellent | Good |

**Gradle** is another modern alternative, especially popular with Android and Kotlin-based frameworks.
  $ans$,
  'Selenium', 'Technical', '1-2 Years', 'Beginner',
  ARRAY['Selenium','Maven','Ant','Build Tools','pom.xml','TestNG','CI/CD','Gradle'],
  true, 0
),

-- Q165
(
  'What are CI tools used with Selenium like Jenkins and Bamboo?',
  'selenium-q165-ci-tools-jenkins-bamboo-selenium',
  'CI tools like Jenkins and Bamboo trigger Selenium test suites automatically on code changes and report results to the team.',
  $ans$
## CI Tools Used with Selenium — Jenkins and Bamboo

**Continuous Integration (CI) tools** automatically build, test, and deploy your application whenever code is pushed. They integrate with Selenium to run your test suite without manual intervention.

### 1. Jenkins (Most Popular — Free & Open Source)

Jenkins is the most widely used CI tool in the QA automation world.

**How to trigger Selenium tests in Jenkins:**

1. Install Jenkins and the **Maven plugin**
2. Create a **Freestyle** or **Pipeline** project
3. Connect to your **GitHub/GitLab** repository
4. Add a build step: `mvn clean test`
5. Set triggers: **on push**, **scheduled (cron)**, or **on PR**
6. Publish **TestNG/Extent reports** using the HTML Publisher plugin

```groovy
// Jenkinsfile (Pipeline as Code)
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo/selenium-framework.git'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'mvn clean test -Dsuite=regression'
            }
        }
        stage('Publish Report') {
            steps {
                publishHTML([
                    reportDir:   'test-output',
                    reportFiles: 'index.html',
                    reportName:  'TestNG Report'
                ])
            }
        }
    }

    post {
        always {
            emailext(
                subject: "Build ${env.BUILD_STATUS} — ${env.JOB_NAME}",
                body:    "See report: ${env.BUILD_URL}",
                to:      "team@company.com"
            )
        }
    }
}
```

### 2. Bamboo (Atlassian — Paid)

Bamboo is Atlassian's CI/CD server, tightly integrated with **Jira** and **Bitbucket**.

- Create a **Plan** → **Stage** → **Job** structure
- Add a **Maven task**: `clean test`
- Link test results to **Jira tickets** automatically
- Supports **parallel test execution** across multiple agents

### 3. Other CI Tools

| Tool | Best For |
|---|---|
| **GitHub Actions** | GitHub repos, free for public |
| **GitLab CI** | GitLab repos, built-in |
| **CircleCI** | Fast cloud builds |
| **Azure DevOps** | Microsoft/enterprise teams |
| **TeamCity** | JetBrains ecosystem |

### Benefits of CI for Selenium
- Tests run automatically on every code commit
- Catch regressions immediately — not days later
- Parallel execution across multiple browsers/OS
- Automatic email/Slack notifications on failure
- Test history and trend reports over time
- Schedule nightly full regression runs
  $ans$,
  'Selenium', 'Technical', '3-5 Years', 'Intermediate',
  ARRAY['Selenium','Jenkins','Bamboo','CI/CD','Continuous Integration','GitHub Actions','Pipeline','Automation'],
  true, 0
);
