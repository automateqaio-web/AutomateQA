-- Jenkins Interview Questions Q1–Q35 | Paste into Supabase SQL Editor

-- ══════════════════════════════════════
-- BEGINNER (Q1–Q10)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Jenkins and why is it used in software development?',
  'what-is-jenkins-ci-cd',
  'Jenkins is an open-source CI/CD automation server that automates building, testing, and deploying software. It integrates with Git, Maven, Docker, and hundreds of plugins.',
  $$## What is Jenkins?

**Jenkins** is an open-source **Continuous Integration / Continuous Delivery (CI/CD)** automation server written in Java. It helps teams automatically build, test, and deploy code every time a developer pushes changes.

## Why Jenkins?

```
Developer pushes code → Git triggers Jenkins → Jenkins:
  1. Pulls latest code
  2. Compiles (Maven/Gradle/npm)
  3. Runs unit tests
  4. Runs automation tests (Selenium/Cypress)
  5. Builds artifact (JAR/Docker image)
  6. Deploys to staging/production
  7. Sends notification (email/Slack)
```

## Key Features

- **Free & Open Source** — large plugin ecosystem (1800+ plugins)
- **Pipeline as Code** — Jenkinsfile (Groovy DSL) stored in Git
- **Distributed Builds** — Master/Agent architecture for parallel execution
- **Integration** — Git, GitHub, GitLab, Bitbucket, Maven, Docker, AWS, Kubernetes
- **Plugin Ecosystem** — Slack, SonarQube, JaCoCo, Allure Reports, etc.
- **Scheduled Jobs** — run builds via cron syntax
- **Parameterized Builds** — pass variables to jobs (environment, browser, etc.)

## Jenkins Architecture

```
┌─────────────────────────────────────────────────┐
│                Jenkins Master                    │
│  - Schedules builds                             │
│  - Monitors agents                              │
│  - Manages plugins & config                     │
│                    │                            │
│        ┌───────────┼───────────┐                │
│        ↓           ↓           ↓                │
│   Agent 1      Agent 2     Agent 3              │
│   (Linux)      (Windows)   (Docker)             │
│   Run tests    Run tests   Build image          │
└─────────────────────────────────────────────────┘
```

## Jenkins vs GitHub Actions

| Feature | Jenkins | GitHub Actions |
|---------|---------|---------------|
| Hosting | Self-hosted | Cloud (GitHub) |
| Cost | Free (self-host) | Free tier + paid |
| Setup | Complex | Simple (YAML) |
| Plugin eco | Huge (1800+) | Growing (marketplace) |
| Control | Full | Limited |
| Scaling | Manual agents | Auto-scaled runners |

## Installation (Quick Start)

```bash
# Docker (easiest)
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

# Access at http://localhost:8080
# Initial password: docker logs <container-id>
```$$,
  'Jenkins', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Jenkins', 'CI/CD', 'Automation Server', 'Continuous Integration', 'DevOps', 'Introduction'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between Freestyle and Pipeline jobs in Jenkins?',
  'jenkins-freestyle-vs-pipeline-job',
  'Freestyle jobs are configured via the Jenkins UI — simple but limited. Pipeline jobs use a Jenkinsfile (code) stored in Git — version-controlled, reusable, and support complex workflows.',
  $$## Freestyle vs Pipeline Jobs in Jenkins

## Freestyle Job

- Configured entirely through the **Jenkins web UI**
- No code required — click and configure
- Good for **simple tasks**: run a shell script, trigger Maven, send email
- **Not version-controlled** — config lives in Jenkins, not Git
- Limited to single sequence of steps

```
Jenkins UI → Source Code Mgmt → Build Steps → Post-build Actions
```

### When to use Freestyle:
- Quick one-off jobs
- Simple build/test without complex logic
- Teams new to Jenkins

## Pipeline Job

- Written as a **Jenkinsfile** (Groovy DSL) stored **in the repository**
- Version-controlled — pipeline changes tracked in Git
- Supports complex workflows: stages, parallel execution, approvals
- Two types: **Declarative** (recommended) and **Scripted** (flexible but complex)

### Declarative Pipeline

```groovy
// Jenkinsfile (in root of repository)
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/org/repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh './scripts/deploy.sh'
            }
        }
    }

    post {
        success {
            echo 'Pipeline passed!'
        }
        failure {
            mail to: 'team@company.com', subject: 'Build Failed', body: 'Check Jenkins'
        }
    }
}
```

## Comparison

| Feature | Freestyle | Pipeline |
|---------|-----------|---------|
| Configuration | Jenkins UI | Code (Jenkinsfile) |
| Version control | No | Yes (in Git) |
| Complex workflows | Limited | Yes (stages, parallel) |
| Reusability | No | Yes (shared libraries) |
| Code review | No | Yes |
| Parallel execution | No | Yes |
| Recommended for | Simple tasks | All CI/CD workflows |$$,
  'Jenkins', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Freestyle Job', 'Pipeline Job', 'Jenkinsfile', 'Jenkins', 'CI/CD', 'Declarative Pipeline'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Jenkins build triggers? How do you automatically trigger a Jenkins build?',
  'jenkins-build-triggers',
  'Jenkins builds can be triggered by SCM polling (check for Git changes on schedule), webhooks (GitHub pushes trigger immediately), scheduled cron, or another upstream job completing.',
  $$## Jenkins Build Triggers

Build triggers determine **when** a Jenkins job runs automatically.

## 1. SCM Polling (Poll Source Control Management)

Checks Git for changes on a schedule. If new commits found → triggers build.

```
H/5 * * * *   → check every 5 minutes
H * * * *     → check every hour
```

**Pros**: Simple, no webhook setup needed
**Cons**: Delay (up to 5 min), unnecessary polling

```groovy
// Jenkinsfile
pipeline {
    triggers {
        pollSCM('H/5 * * * *')  // poll every 5 minutes
    }
    ...
}
```

## 2. GitHub/GitLab Webhook (Recommended — Instant)

GitHub calls Jenkins the moment code is pushed.

**Setup:**
1. Jenkins: Install "GitHub plugin", generate token
2. GitHub: Settings → Webhooks → Add webhook → `http://jenkins.url/github-webhook/`
3. Jenkins job: Check "GitHub hook trigger for GITScm polling"

```groovy
// Jenkinsfile
pipeline {
    triggers {
        githubPush()  // triggers on any push to the branch
    }
    ...
}
```

**Pros**: Instant build on every push, no polling overhead
**Cons**: Jenkins must be publicly accessible (or use ngrok for local dev)

## 3. Scheduled Build (Cron Syntax)

Run builds at specific times — nightly regression, weekly reports.

```
// Cron syntax: minute hour day-of-month month day-of-week
0 2 * * *     → every day at 2:00 AM
0 22 * * 1-5  → weekdays at 10 PM
H 0 * * 7     → every Sunday at midnight (H = hash to spread load)
```

```groovy
pipeline {
    triggers {
        cron('0 2 * * *')  // nightly at 2 AM
    }
    ...
}
```

## 4. Upstream Job Trigger

Trigger this job when another job completes.

```
Job: Build → triggers → Job: Test → triggers → Job: Deploy
```

```groovy
pipeline {
    triggers {
        upstream(upstreamProjects: 'my-build-job', threshold: hudson.model.Result.SUCCESS)
    }
    ...
}
```

## 5. Build with Parameters (Manual + API)

```bash
# Trigger via Jenkins API
curl -X POST "http://jenkins/job/my-job/build" \
  --user "admin:token" \
  --data-urlencode json='{"parameter":[{"name":"ENVIRONMENT","value":"staging"}]}'
```

## 6. Pull Request Trigger (Jenkins + GitHub PR Builder)

Trigger builds on PR creation/update — run tests before merge.

```groovy
pipeline {
    triggers {
        pullRequestTrigger(
            events: [openPullRequest(), updatePullRequest()]
        )
    }
}
```

## Summary Table

| Trigger | Speed | Use Case |
|---------|-------|----------|
| Webhook | Instant | Every push, PR builds |
| SCM Poll | ~5 min delay | When webhook isn't possible |
| Cron | Scheduled | Nightly regression tests |
| Upstream | Post-build | Deployment chains |
| Manual | Immediate | On-demand builds |$$,
  'Jenkins', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Build Triggers', 'Webhook', 'SCM Polling', 'Cron', 'Jenkins', 'CI/CD', 'GitHub'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is a Jenkinsfile and what is Declarative vs Scripted Pipeline syntax?',
  'jenkinsfile-declarative-vs-scripted-pipeline',
  'A Jenkinsfile defines your CI/CD pipeline as code stored in Git. Declarative syntax is structured, readable, and recommended. Scripted syntax uses raw Groovy — more powerful but complex.',
  $$## Jenkinsfile: Declarative vs Scripted Pipeline

A **Jenkinsfile** is a text file that defines your Jenkins pipeline as code and lives in your repository root. This enables **Pipeline-as-Code**: version-controlled, peer-reviewed CI/CD.

## Declarative Pipeline (Recommended)

Structured, opinionated syntax with `pipeline {}` block.

```groovy
pipeline {
    // Where to run: any available agent/node
    agent any

    // Environment variables
    environment {
        APP_ENV  = 'staging'
        MAVEN_OPTS = '-Xmx512m'
    }

    // Optional: tools to auto-install
    tools {
        maven 'Maven-3.9'
        jdk   'JDK-17'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm  // checks out the branch that triggered the build
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run Automation Tests') {
            steps {
                sh 'mvn test -Dbrowser=chrome -Denv=${APP_ENV}'
            }
            post {
                always {
                    // Publish JUnit test results
                    junit 'target/surefire-reports/*.xml'
                    // Publish HTML report
                    publishHTML([
                        reportDir:   'target/extent-reports',
                        reportFiles: 'index.html',
                        reportName:  'Test Report',
                    ])
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'             // only deploy on main branch
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                sh './deploy.sh ${APP_ENV}'
            }
        }
    }

    post {
        success { echo 'All stages passed!' }
        failure {
            mail(
                to:      'qa-team@company.com',
                subject: "BUILD FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body:    "Check: ${env.BUILD_URL}"
            )
        }
        always {
            cleanWs()  // clean workspace after every build
        }
    }
}
```

## Scripted Pipeline (Groovy — More Flexible)

Full Groovy code inside `node {}` block — no structural constraints.

```groovy
node {
    def mavenHome = tool 'Maven-3.9'

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        sh "${mavenHome}/bin/mvn clean package"
    }

    stage('Test') {
        try {
            sh "${mavenHome}/bin/mvn test"
        } catch (Exception e) {
            currentBuild.result = 'UNSTABLE'
            echo "Tests failed: ${e.message}"
        } finally {
            junit 'target/surefire-reports/*.xml'
        }
    }

    if (env.BRANCH_NAME == 'main') {
        stage('Deploy') {
            sh './deploy.sh'
        }
    }
}
```

## Key Differences

| Feature | Declarative | Scripted |
|---------|-------------|---------|
| Syntax | Structured DSL | Full Groovy |
| Learning curve | Easy | Harder |
| Error checking | Upfront validation | Runtime only |
| Flexibility | Limited | Full |
| Recommended | Yes | Legacy/complex only |
| `post {}` section | Built-in | Manual try/finally |$$,
  'Jenkins', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Jenkinsfile', 'Declarative Pipeline', 'Scripted Pipeline', 'Jenkins', 'Pipeline as Code', 'Groovy'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Jenkins agents and how does Master-Agent (Master-Slave) architecture work?',
  'jenkins-master-agent-architecture',
  'Jenkins Master schedules jobs and manages configuration. Agents (slaves) execute the actual build steps on separate machines. This enables parallel, distributed builds across environments.',
  $$## Jenkins Master-Agent Architecture

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Jenkins Master                        │
│                                                         │
│  - Web UI & REST API           - Job scheduling         │
│  - Plugin management           - Build queue            │
│  - User authentication         - Monitors agents        │
│  - Configuration storage       - Distributes work       │
│                                                         │
│  Communication: SSH / JNLP (Java Web Start)            │
│         ┌────────────┬────────────┬────────────┐        │
│         ↓            ↓            ↓            ↓        │
│    Agent-Linux   Agent-Win   Agent-Docker  Agent-Mac    │
│    Selenium      IE tests    Build image   iOS tests    │
│    Tests         Tests                                  │
└─────────────────────────────────────────────────────────┘
```

## Jenkins Master Responsibilities

- Hosts the Jenkins web interface
- Stores all job configuration
- Manages plugins and credentials
- Schedules jobs and assigns them to available agents
- **Should NOT run builds** — delegates to agents

## Jenkins Agent Responsibilities

- Executes the actual pipeline steps
- Has the required tools (JDK, Maven, Node.js, Chrome, etc.)
- Reports results back to master
- Can be on different OS (Linux, Windows, macOS)

## Defining Agents in Jenkinsfile

```groovy
// Run on any available agent
pipeline {
    agent any
    ...
}

// Run on a specific label (e.g., agent with "selenium" label)
pipeline {
    agent { label 'selenium-agent' }
    ...
}

// Run in a Docker container (agent-less infrastructure)
pipeline {
    agent {
        docker {
            image 'maven:3.9-openjdk-17'
            args  '-v /root/.m2:/root/.m2'  // cache Maven deps
        }
    }
    ...
}

// Run on no agent at top level — define per stage
pipeline {
    agent none

    stages {
        stage('Build on Linux') {
            agent { label 'linux' }
            steps { sh 'mvn clean package' }
        }
        stage('Test on Windows') {
            agent { label 'windows' }
            steps { bat 'mvn test' }
        }
    }
}
```

## Adding an Agent to Jenkins

### SSH Agent Setup
1. Jenkins → Manage Jenkins → Manage Nodes → New Node
2. Name: `selenium-agent-01`
3. Remote root directory: `/home/jenkins`
4. Labels: `selenium chrome linux`
5. Launch method: `Launch agents via SSH`
6. Host: `192.168.1.50`
7. Credentials: SSH key pair

### JNLP Agent (Agent connects to master)
```bash
# On agent machine:
java -jar agent.jar \
  -jnlpUrl http://jenkins-master:8080/computer/agent-01/slave-agent.jnlp \
  -secret <secret-key> \
  -workDir /home/jenkins
```

## Parallel Stages Across Agents

```groovy
pipeline {
    agent none
    stages {
        stage('Parallel Tests') {
            parallel {
                stage('Chrome Tests') {
                    agent { label 'agent-chrome' }
                    steps { sh 'mvn test -Dbrowser=chrome' }
                }
                stage('Firefox Tests') {
                    agent { label 'agent-firefox' }
                    steps { sh 'mvn test -Dbrowser=firefox' }
                }
                stage('API Tests') {
                    agent { label 'agent-api' }
                    steps { sh 'mvn test -Dsuite=api' }
                }
            }
        }
    }
}
```$$,
  'Jenkins', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Master Agent', 'Distributed Build', 'Jenkins Architecture', 'Slave', 'Labels', 'Docker Agent'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you manage credentials and secrets in Jenkins?',
  'jenkins-credentials-secrets-management',
  'Use Jenkins Credentials Manager to store passwords, SSH keys, and tokens securely. Access in pipelines using the credentials() binding or withCredentials block — never hardcode secrets.',
  $$## Managing Credentials in Jenkins

**Never hardcode passwords or tokens** in Jenkinsfiles. Use Jenkins' built-in Credentials Manager.

## Adding Credentials in Jenkins UI

1. Jenkins → **Manage Jenkins** → **Credentials**
2. Select scope: Global (recommended) or specific folder
3. Click **Add Credentials**
4. Choose type:
   - **Username with password** (DB creds, GitHub HTTPS)
   - **SSH Username with private key** (server access)
   - **Secret text** (API tokens, API keys)
   - **Secret file** (service account JSON, .p12 files)
   - **Certificate** (PKCS#12)

## Using Credentials in Declarative Pipeline

```groovy
pipeline {
    agent any

    environment {
        // Binds credential to env vars (username + password)
        DOCKER_CREDS = credentials('docker-hub-credentials')
        // Creates: DOCKER_CREDS_USR and DOCKER_CREDS_PSW
    }

    stages {
        stage('Docker Login') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
            }
        }

        stage('API Tests') {
            steps {
                // Secret text — bound to single variable
                withCredentials([string(credentialsId: 'api-key', variable: 'API_KEY')]) {
                    sh 'mvn test -Dapi.key=${API_KEY}'
                }
            }
        }

        stage('Deploy via SSH') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'prod-server-ssh',
                        keyFileVariable:  'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh 'ssh -i $SSH_KEY $SSH_USER@prod.server.com "./deploy.sh"'
                }
            }
        }

        stage('Use Secret File') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account', variable: 'GCP_JSON')]) {
                    sh 'gcloud auth activate-service-account --key-file=$GCP_JSON'
                }
            }
        }
    }
}
```

## Credentials in Shared Libraries

```groovy
// vars/deployToK8s.groovy
def call(String environment) {
    withCredentials([
        string(credentialsId: "k8s-token-${environment}", variable: 'K8S_TOKEN')
    ]) {
        sh "kubectl --token=$K8S_TOKEN apply -f k8s/${environment}/"
    }
}
```

## Jenkins Credentials as Environment Variables

```groovy
environment {
    GITHUB_TOKEN   = credentials('github-pat')          // secret text
    SONAR_TOKEN    = credentials('sonarqube-token')     // secret text
    DB_CREDENTIALS = credentials('db-username-password') // user+pass
    // DB_CREDENTIALS_USR = username
    // DB_CREDENTIALS_PSW = password
}
```

## Best Practices

- Use **Folder-scoped credentials** to limit access per project
- Rotate credentials regularly
- Use **HashiCorp Vault plugin** for enterprise secret management
- Never `echo` or `print` credential variables in logs
- Jenkins **masks credential values** in build output automatically$$,
  'Jenkins', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Credentials', 'Secrets', 'withCredentials', 'Jenkins', 'Security', 'Pipeline'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you run Selenium/TestNG automation tests in Jenkins?',
  'run-selenium-testng-tests-jenkins',
  'Configure Jenkins to pull code from Git, build with Maven, run TestNG via Surefire plugin, publish JUnit XML results, and optionally publish an Extent/Allure HTML report.',
  $$## Running Selenium + TestNG Tests in Jenkins

## Project Prerequisites

```xml
<!-- pom.xml — key dependencies -->
<dependencies>
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.18.1</version>
    </dependency>
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.9.0</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.5</version>
            <configuration>
                <suiteXmlFiles>
                    <suiteXmlFile>testng.xml</suiteXmlFile>
                </suiteXmlFiles>
                <!-- Pass Jenkins params to tests -->
                <systemPropertyVariables>
                    <browser>${browser}</browser>
                    <env>${env}</env>
                </systemPropertyVariables>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## Jenkins Declarative Pipeline

```groovy
pipeline {
    agent any

    parameters {
        choice(name: 'BROWSER', choices: ['chrome', 'firefox', 'edge'], description: 'Browser to run tests')
        choice(name: 'ENV',     choices: ['staging', 'qa', 'prod'],    description: 'Target environment')
        string(name: 'SUITE',   defaultValue: 'testng.xml',             description: 'TestNG suite file')
    }

    tools {
        maven 'Maven-3.9'
        jdk   'JDK-17'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/org/selenium-framework.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile -q'
            }
        }

        stage('Run Tests') {
            steps {
                sh """
                    mvn test \
                        -Dbrowser=${params.BROWSER} \
                        -Denv=${params.ENV} \
                        -Dsurefire.suiteXmlFiles=${params.SUITE}
                """
            }
        }
    }

    post {
        always {
            // Publish JUnit results (shows pass/fail graph in Jenkins)
            junit testResults: 'target/surefire-reports/*.xml',
                  allowEmptyResults: true

            // Publish Allure Report (requires Allure plugin)
            allure([
                includeProperties: false,
                jdk:               '',
                properties:        [],
                reportBuildPolicy: 'ALWAYS',
                results: [[path: 'target/allure-results']],
            ])

            // Or publish Extent Report HTML
            publishHTML([
                allowMissing:          false,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'target/extent-reports',
                reportFiles:           'index.html',
                reportName:            'Extent Test Report',
                reportTitles:          '',
            ])
        }

        failure {
            emailext(
                subject: "TESTS FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body:    "Build URL: ${env.BUILD_URL}\nBrowser: ${params.BROWSER}",
                to:      'qa-team@company.com'
            )
        }

        always {
            cleanWs()  // clean up workspace
        }
    }
}
```

## Headless Chrome on Jenkins (Linux Agent)

```groovy
stage('Run Tests') {
    steps {
        // Chrome options for headless in CI
        sh 'mvn test -Dbrowser=chrome-headless'
    }
}
```

```java
// In your DriverManager.java
if ("chrome-headless".equals(browser)) {
    ChromeOptions options = new ChromeOptions();
    options.addArguments("--headless=new");
    options.addArguments("--no-sandbox");         // required for CI
    options.addArguments("--disable-dev-shm-usage"); // required for CI
    options.addArguments("--window-size=1920,1080");
    return new ChromeDriver(options);
}
```$$,
  'Jenkins', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'TestNG', 'Maven', 'Jenkins Pipeline', 'Surefire', 'JUnit Report', 'Automation CI'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Jenkins Shared Libraries and how do you use them?',
  'jenkins-shared-libraries',
  'Shared Libraries let you define reusable Groovy functions and pipeline steps in a central Git repo, importable by any Jenkinsfile across projects. Avoids copy-pasting pipeline code.',
  $$## Jenkins Shared Libraries

**Shared Libraries** are reusable Groovy code stored in a separate Git repository and imported into any Jenkinsfile. They are the DRY principle applied to pipelines.

## Shared Library Repository Structure

```
jenkins-shared-library/
├── vars/
│   ├── buildMaven.groovy     ← Global variable (call as buildMaven())
│   ├── runTests.groovy       ← Call as runTests()
│   └── deployApp.groovy      ← Call as deployApp()
├── src/
│   └── com/company/
│       ├── Utils.groovy      ← Groovy class
│       └── Notifier.groovy   ← Groovy class
└── resources/
    └── templates/
        └── email-template.html
```

## Creating Shared Library Functions

```groovy
// vars/buildMaven.groovy
def call(String goals = 'clean package') {
    sh "mvn ${goals} -q"
    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
}
```

```groovy
// vars/runTests.groovy
def call(Map config = [:]) {
    def browser = config.browser ?: 'chrome'
    def env     = config.env     ?: 'staging'
    def suite   = config.suite   ?: 'testng.xml'

    sh """
        mvn test \
            -Dbrowser=${browser} \
            -Denv=${env} \
            -Dsurefire.suiteXmlFiles=${suite}
    """

    junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
}
```

```groovy
// vars/deployApp.groovy
def call(String environment, String version) {
    withCredentials([string(credentialsId: "deploy-key-${environment}", variable: 'DEPLOY_KEY')]) {
        sh """
            ./scripts/deploy.sh \
                --env=${environment} \
                --version=${version} \
                --key=${DEPLOY_KEY}
        """
    }
    echo "Deployed version ${version} to ${environment}"
}
```

```groovy
// vars/sendNotification.groovy
def call(String status) {
    def color = status == 'SUCCESS' ? 'good' : 'danger'
    def msg   = "${status}: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${env.BUILD_URL}"

    slackSend(
        channel: '#ci-alerts',
        color:   color,
        message: msg,
    )
}
```

## Registering the Shared Library in Jenkins

1. Jenkins → **Manage Jenkins** → **Configure System**
2. Scroll to **Global Pipeline Libraries**
3. Add:
   - Name: `my-shared-lib`
   - Default version: `main`
   - SCM: Git → URL: `https://github.com/org/jenkins-shared-library.git`

## Using the Shared Library in a Jenkinsfile

```groovy
// Jenkinsfile in your project repository

// Import shared library (implicit — if registered as global)
@Library('my-shared-lib') _

// Or specify a version/branch
@Library('my-shared-lib@v2.1') _

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Call the shared library function
                buildMaven('clean package -DskipTests')
            }
        }

        stage('Test') {
            steps {
                runTests(
                    browser: 'chrome',
                    env:     'staging',
                    suite:   'smoke-testng.xml'
                )
            }
        }

        stage('Deploy') {
            when { branch 'main' }
            steps {
                deployApp('production', '1.5.0')
            }
        }
    }

    post {
        always {
            sendNotification(currentBuild.currentResult)
        }
    }
}
```

## Benefits

- **DRY**: Write pipeline logic once, reuse across 100+ projects
- **Standardization**: All teams use the same build/deploy pattern
- **Easy updates**: Fix a bug in the library → all pipelines get the fix
- **Testing**: Library code can be unit-tested (JenkinsPipelineUnit)$$,
  'Jenkins', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Shared Libraries', 'Groovy', 'Reusability', 'Jenkins', 'Pipeline', 'DRY', 'vars'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you run parallel stages in a Jenkins pipeline?',
  'jenkins-parallel-stages-pipeline',
  'Use the parallel{} block inside a stage in declarative pipelines to run multiple stages simultaneously. Each parallel branch runs on a separate agent and executes concurrently.',
  $$## Parallel Stages in Jenkins Pipeline

Parallel execution reduces total build time by running independent stages simultaneously.

## Basic Parallel Syntax

```groovy
pipeline {
    agent none

    stages {
        stage('Build') {
            agent any
            steps {
                sh 'mvn clean package -DskipTests'
                stash name: 'build-artifacts', includes: 'target/*.jar'
            }
        }

        stage('Run Tests in Parallel') {
            parallel {

                stage('Smoke Tests — Chrome') {
                    agent { label 'agent-chrome' }
                    steps {
                        unstash 'build-artifacts'
                        sh 'mvn test -Dsuite=smoke -Dbrowser=chrome'
                    }
                    post {
                        always {
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
                }

                stage('Regression Tests — Firefox') {
                    agent { label 'agent-firefox' }
                    steps {
                        unstash 'build-artifacts'
                        sh 'mvn test -Dsuite=regression -Dbrowser=firefox'
                    }
                    post {
                        always {
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
                }

                stage('API Tests') {
                    agent { label 'agent-api' }
                    steps {
                        sh 'mvn test -Dsuite=api-tests'
                    }
                    post {
                        always {
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
                }

            } // end parallel
        }

        stage('Deploy') {
            agent any
            when {
                allOf {
                    branch 'main'
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
                }
            }
            steps {
                sh './deploy.sh staging'
            }
        }
    }
}
```

## Matrix Strategy (Run Same Stage Across Multiple Configurations)

```groovy
pipeline {
    agent none

    stages {
        stage('Cross-Browser Tests') {
            matrix {
                axes {
                    axis {
                        name   'BROWSER'
                        values 'chrome', 'firefox', 'edge'
                    }
                    axis {
                        name   'ENV'
                        values 'staging', 'qa'
                    }
                }
                // Generates 3 × 2 = 6 parallel combinations!

                stages {
                    stage('Test') {
                        agent { label "${BROWSER}-agent" }
                        steps {
                            sh "mvn test -Dbrowser=${BROWSER} -Denv=${ENV}"
                        }
                        post {
                            always {
                                junit 'target/surefire-reports/*.xml'
                            }
                        }
                    }
                }
            }
        }
    }
}
```

## Sharing Artifacts Between Parallel Stages

```groovy
stage('Build') {
    steps {
        sh 'mvn clean package'
        // stash saves files to pass to another agent
        stash name: 'test-classes', includes: 'target/**'
    }
}

stage('Parallel Tests') {
    parallel {
        stage('Suite A') {
            agent { label 'agent-1' }
            steps {
                unstash 'test-classes'  // retrieve stashed files
                sh 'mvn test -Dsuite=suite-a'
            }
        }
        stage('Suite B') {
            agent { label 'agent-2' }
            steps {
                unstash 'test-classes'
                sh 'mvn test -Dsuite=suite-b'
            }
        }
    }
}
```

## failFast — Stop All Parallel Stages on First Failure

```groovy
stage('Parallel Tests') {
    failFast true   // if any parallel branch fails, cancel all others
    parallel {
        stage('Suite A') { ... }
        stage('Suite B') { ... }
    }
}
```$$,
  'Jenkins', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Parallel Stages', 'Matrix', 'Jenkins Pipeline', 'Concurrent', 'stash', 'Cross-Browser', 'Jenkins'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you integrate Jenkins with Docker for CI/CD?',
  'jenkins-docker-integration-cicd',
  'Use Docker agents in Jenkinsfile to run build steps inside containers, or build and push Docker images as part of the pipeline. Eliminates "works on my machine" issues.',
  $$## Jenkins + Docker Integration

## 1. Use Docker as a Build Agent

Run each pipeline stage inside a Docker container — no need to install tools on agents.

```groovy
pipeline {
    agent {
        docker {
            image 'maven:3.9-openjdk-17-slim'
            args  '-v /root/.m2:/root/.m2 --network host'
        }
    }

    stages {
        stage('Build & Test') {
            steps {
                // Runs inside the Maven container
                sh 'mvn clean test'
            }
        }
    }
}
```

## 2. Different Docker Images Per Stage

```groovy
pipeline {
    agent none

    stages {
        stage('Build') {
            agent {
                docker { image 'maven:3.9-openjdk-17' }
            }
            steps {
                sh 'mvn clean package -DskipTests'
                stash name: 'jar', includes: 'target/*.jar'
            }
        }

        stage('Code Quality') {
            agent {
                docker { image 'sonarsource/sonar-scanner-cli:latest' }
            }
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh 'sonar-scanner -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }

        stage('Run Selenium Tests') {
            agent {
                docker {
                    image 'selenium/standalone-chrome:latest'
                    args  '-p 4444:4444 --shm-size=2g'
                }
            }
            steps {
                unstash 'jar'
                sh 'mvn test -Dbrowser=chrome -Dselenium.hub=http://localhost:4444'
            }
        }
    }
}
```

## 3. Build and Push a Docker Image

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "myorg/myapp:${env.BUILD_NUMBER}"
        DOCKER_CREDS = credentials('docker-hub-creds')
    }

    stages {
        stage('Build App') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Run Tests Against Container') {
            steps {
                sh "docker run --rm ${DOCKER_IMAGE} mvn test"
            }
        }

        stage('Push to Docker Hub') {
            when { branch 'main' }
            steps {
                sh """
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                    docker push ${DOCKER_IMAGE}
                    docker tag ${DOCKER_IMAGE} myorg/myapp:latest
                    docker push myorg/myapp:latest
                """
            }
        }

        stage('Deploy') {
            when { branch 'main' }
            steps {
                sh "docker-compose -f docker-compose.prod.yml up -d"
            }
        }
    }

    post {
        always {
            // Clean up local Docker images
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
    }
}
```

## 4. Dockerfile for the Application

```dockerfile
# Dockerfile
FROM openjdk:17-jre-slim
WORKDIR /app
COPY target/myapp-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## Requirements on Jenkins Agent

```bash
# Docker must be installed on agent
sudo apt install docker.io
sudo usermod -aG docker jenkins   # allow jenkins user to run docker
sudo systemctl restart jenkins
```$$,
  'Jenkins', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Docker', 'Jenkins', 'CI/CD', 'Docker Agent', 'Container', 'Build Image', 'Pipeline'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What Jenkins plugins do you commonly use in QA automation?',
  'jenkins-plugins-qa-automation',
  'Common QA plugins: Maven Integration, Git, JUnit, Allure Reports, HTML Publisher, Email-ext, Slack Notification, Parameterized Trigger, Blue Ocean, and Green Balls.',
  $$## Essential Jenkins Plugins for QA Automation

## Source Control

| Plugin | Purpose |
|--------|---------|
| **Git Plugin** | Clone Git repos, checkout branches |
| **GitHub Integration** | PR builds, webhook triggers |
| **GitLab Plugin** | GitLab webhook integration |
| **Bitbucket Branch Source** | Multibranch pipelines for Bitbucket |

## Build Tools

```groovy
tools {
    maven 'Maven-3.9'    // Maven Integration Plugin
    jdk   'JDK-17'       // JDK Plugin
    nodejs 'Node-20'     // NodeJS Plugin (for Cypress/Playwright)
}
```

## Test Results & Reporting

| Plugin | Purpose | Usage |
|--------|---------|-------|
| **JUnit Plugin** | Parse TestNG/JUnit XML → graphs | `junit 'target/surefire-reports/*.xml'` |
| **Allure Jenkins Plugin** | Beautiful Allure HTML reports | `allure([results: [[path: 'allure-results']]])` |
| **HTML Publisher** | Publish any HTML report | `publishHTML([reportDir: 'reports', ...])` |
| **TestNG Results** | TestNG-specific result parsing | Built-in to JUnit plugin |
| **Cucumber Reports** | BDD Cucumber HTML reports | `cucumber 'target/cucumber.json'` |

## Notifications

```groovy
// Email Extension (emailext)
post {
    failure {
        emailext(
            subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body:    '<b>Build URL:</b> ${BUILD_URL}',
            to:      'qa-team@company.com',
            mimeType: 'text/html',
            attachLog: true,
        )
    }
}

// Slack Notification Plugin
post {
    always {
        slackSend(
            channel: '#qa-builds',
            color:   currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
            message: "${currentBuild.result}: ${env.JOB_NAME} #${env.BUILD_NUMBER} ${env.BUILD_URL}",
        )
    }
}
```

## Parameterized Builds

```groovy
// Parameterized Trigger Plugin
parameters {
    choice(name: 'BROWSER', choices: ['chrome', 'firefox'], description: 'Browser')
    choice(name: 'ENV',     choices: ['staging', 'qa'],     description: 'Environment')
    booleanParam(name: 'FULL_REGRESSION', defaultValue: false, description: 'Run full suite?')
    string(name:  'TAGS',  defaultValue: '@smoke',          description: 'Test tags to run')
}
```

## Other Useful Plugins

| Plugin | Purpose |
|--------|---------|
| **Blue Ocean** | Modern Jenkins UI with visual pipelines |
| **Pipeline Utility Steps** | `readJSON`, `readYaml`, `findFiles` in pipelines |
| **Credentials Binding** | Safely inject secrets into builds |
| **Workspace Cleanup** | `cleanWs()` — clean after builds |
| **Build Timeout** | Kill hung builds after N minutes |
| **Green Balls** | Green icons for success (vs Jenkins default blue!) |
| **Docker Pipeline** | `docker.build()`, `docker.push()` in pipelines |
| **SonarQube Scanner** | Code quality gate integration |
| **AnsiColor** | Colored console output |
| **Timestamper** | Timestamps on each console line |

```groovy
// Build Timeout Plugin
options {
    timeout(time: 60, unit: 'MINUTES')  // fail if build takes > 60 min
    timestamps()                         // Timestamper Plugin
    ansiColor('xterm')                  // AnsiColor Plugin
    disableConcurrentBuilds()           // prevent concurrent runs
}
```$$,
  'Jenkins', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Jenkins Plugins', 'Allure', 'JUnit Plugin', 'Slack', 'Email', 'QA Automation', 'Reporting'], true, 0
);

-- SCENARIO-BASED

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you set up a complete CI/CD pipeline in Jenkins for a Selenium Java project?',
  'jenkins-cicd-pipeline-selenium-java-complete',
  'A complete Jenkins CI/CD pipeline for Selenium: checkout from Git, build with Maven, run headless Selenium tests, publish Allure/JUnit results, notify on failure, and optionally deploy.',
  $$## Complete Jenkins CI/CD Pipeline for Selenium Java

## Step 1: Project Structure

```
selenium-framework/
├── src/
│   ├── main/java/com/automateqa/
│   │   ├── pages/
│   │   ├── utils/
│   │   └── config/
│   └── test/java/com/automateqa/
│       └── tests/
├── testng.xml
├── smoke-testng.xml
├── pom.xml
└── Jenkinsfile            ← pipeline definition
```

## Step 2: pom.xml — Maven Surefire Configuration

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.2.5</version>
    <configuration>
        <suiteXmlFiles>
            <suiteXmlFile>${suite}</suiteXmlFile>
        </suiteXmlFiles>
        <systemPropertyVariables>
            <browser>${browser}</browser>
            <env>${env}</env>
            <baseUrl>${baseUrl}</baseUrl>
        </systemPropertyVariables>
    </configuration>
</plugin>
```

## Step 3: Jenkinsfile — Complete Pipeline

```groovy
pipeline {
    agent any

    parameters {
        choice(name: 'BROWSER',
               choices: ['chrome', 'firefox', 'edge'],
               description: 'Browser to use for tests')
        choice(name: 'ENV',
               choices: ['staging', 'qa', 'prod'],
               description: 'Target environment')
        choice(name: 'SUITE',
               choices: ['testng.xml', 'smoke-testng.xml', 'regression-testng.xml'],
               description: 'TestNG suite to run')
    }

    tools {
        maven 'Maven-3.9'
        jdk   'JDK-17'
    }

    options {
        timeout(time: 90, unit: 'MINUTES')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    environment {
        BASE_URL = credentials("base-url-${params.ENV}")
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: env.BRANCH_NAME ?: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/org/selenium-framework.git'
                echo "Building branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile -q'
            }
        }

        stage('Run Tests') {
            steps {
                sh """
                    mvn test \
                      -Dbrowser=${params.BROWSER} \
                      -Denv=${params.ENV} \
                      -DbaseUrl=${BASE_URL} \
                      -Dsuite=${params.SUITE}
                """
            }
        }
    }

    post {
        always {
            // JUnit results — shows trends graph
            junit testResults: 'target/surefire-reports/*.xml',
                  allowEmptyResults: true

            // Allure Report
            allure([
                reportBuildPolicy: 'ALWAYS',
                results: [[path: 'target/allure-results']],
            ])

            // Cleanup workspace
            cleanWs()
        }

        failure {
            emailext(
                subject: "TESTS FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER} [${params.BROWSER}/${params.ENV}]",
                body:    """
                    <h2>Build Failed</h2>
                    <p><b>Job:</b>     ${env.JOB_NAME}</p>
                    <p><b>Build:</b>   #${env.BUILD_NUMBER}</p>
                    <p><b>Browser:</b> ${params.BROWSER}</p>
                    <p><b>Env:</b>     ${params.ENV}</p>
                    <p><b>URL:</b>     <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to:       'qa-team@company.com',
                mimeType: 'text/html',
            )
        }

        success {
            echo "All tests passed! Browser: ${params.BROWSER} | Env: ${params.ENV}"
        }
    }
}
```

## Step 4: Headless Chrome Driver Setup (for Jenkins Linux)

```java
public static WebDriver createChromeDriver() {
    ChromeOptions options = new ChromeOptions();
    if (System.getProperty("browser", "chrome").equals("chrome")
            && Boolean.parseBoolean(System.getenv().getOrDefault("CI", "false"))) {
        options.addArguments("--headless=new");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--window-size=1920,1080");
    }
    return new ChromeDriver(options);
}
```$$,
  'Jenkins', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['CI/CD Pipeline', 'Selenium', 'TestNG', 'Maven', 'Jenkins', 'Allure', 'Complete Setup'], true, 0
);
