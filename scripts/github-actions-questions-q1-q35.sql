-- GitHub Actions Interview Questions Q1–Q35 | Paste into Supabase SQL Editor

-- ══════════════════════════════════════
-- BEGINNER (Q1–Q8)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is GitHub Actions and how does it work?',
  'what-is-github-actions',
  'GitHub Actions is a CI/CD platform built into GitHub. It automates workflows (build, test, deploy) triggered by GitHub events like push or pull request, using YAML files stored in .github/workflows/.',
  $$## What is GitHub Actions?

**GitHub Actions** is a CI/CD and automation platform built directly into GitHub. It lets you automate workflows — build, test, lint, deploy, notify — triggered by events in your repository.

## How It Works

```
GitHub Event (push, PR, schedule)
        ↓
Workflow file (.github/workflows/ci.yml) is triggered
        ↓
Runner (Ubuntu/Windows/macOS VM) is provisioned
        ↓
Jobs run (each job gets a fresh runner)
        ↓
Steps execute inside each job (shell commands or Actions)
        ↓
Results reported back to GitHub (pass/fail, logs, artifacts)
```

## Key Concepts

```
Repository
└── .github/
    └── workflows/
        ├── ci.yml        ← runs tests on every push
        ├── deploy.yml    ← deploys on merge to main
        └── nightly.yml   ← runs regression at 2 AM
```

## Your First Workflow

```yaml
# .github/workflows/hello.yml
name: Hello World

on:
  push:
    branches: [main]

jobs:
  say-hello:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Say hello
        run: echo "Hello from GitHub Actions!"

      - name: Show runner info
        run: |
          echo "OS: ${{ runner.os }}"
          echo "Branch: ${{ github.ref }}"
          echo "Commit: ${{ github.sha }}"
```

## GitHub Actions vs Jenkins

| Feature | GitHub Actions | Jenkins |
|---------|---------------|---------|
| Hosting | GitHub cloud (free tier) | Self-hosted |
| Setup | Zero — YAML in repo | Install + configure server |
| Runners | GitHub-hosted (free) | Your own agents |
| Marketplace | 20,000+ Actions | 1800+ plugins |
| Config | YAML in .github/workflows/ | Jenkinsfile / UI |
| Free tier | 2,000 min/month (public free) | Free (self-hosted cost) |

## Components

- **Workflow** — the YAML file that defines the automation
- **Event (trigger)** — what causes the workflow to run
- **Job** — a unit of work that runs on one runner
- **Step** — an individual task inside a job
- **Action** — a reusable step from GitHub Marketplace (e.g., `actions/checkout@v4`)
- **Runner** — the VM/container where jobs execute
- **Artifact** — files saved after a job (test reports, builds)
- **Secret** — encrypted variables (passwords, API keys)$$,
  'GitHub Actions', 'Technical', 'Fresher', 'Beginner',
  ARRAY['GitHub Actions', 'CI/CD', 'Introduction', 'Workflow', 'DevOps', 'Automation'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are GitHub Actions triggers? Explain on: push, pull_request, schedule, and workflow_dispatch.',
  'github-actions-triggers-events',
  'Triggers (on:) define what starts a workflow. Common triggers: push (code pushed), pull_request (PR opened/updated), schedule (cron timer), workflow_dispatch (manual run with inputs).',
  $$## GitHub Actions Triggers (Events)

The `on:` key defines what event causes the workflow to run.

## push — Trigger on Code Push

```yaml
on:
  push:
    branches:
      - main
      - develop
      - 'release/**'   # wildcard: release/1.0, release/2.0
    branches-ignore:
      - 'dependabot/**'
    paths:
      - 'src/**'       # only trigger if files in src/ changed
      - 'pom.xml'
    paths-ignore:
      - '**.md'        # ignore markdown file changes
      - 'docs/**'
```

## pull_request — Trigger on PR Events

```yaml
on:
  pull_request:
    branches: [main, develop]   # PRs targeting these branches
    types:
      - opened        # new PR created
      - synchronize   # new commit pushed to PR
      - reopened      # PR reopened
      - ready_for_review  # draft → ready
```

## schedule — Run on a Timer (Cron)

```yaml
on:
  schedule:
    - cron: '0 2 * * *'      # every day at 2:00 AM UTC
    - cron: '0 22 * * 1-5'   # weekdays at 10 PM UTC
    - cron: '0 0 * * 0'      # every Sunday at midnight

# Cron format: minute hour day-of-month month day-of-week
# H = hash in Jenkins, but GitHub Actions uses standard cron only
```

## workflow_dispatch — Manual Trigger with Inputs

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'staging'
        type: choice
        options: [staging, qa, production]

      browser:
        description: 'Browser to test with'
        required: true
        default: 'chrome'
        type: choice
        options: [chrome, firefox, edge]

      run_full_suite:
        description: 'Run full regression?'
        required: false
        default: false
        type: boolean

# Access inputs in steps:
# ${{ github.event.inputs.environment }}
# ${{ inputs.environment }}  (newer syntax)
```

## workflow_call — Trigger from Another Workflow

```yaml
# Called by another workflow (reusable workflow)
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      deploy-key:
        required: true
```

## Multiple Triggers Together

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 1 * * *'    # nightly regression
  workflow_dispatch:        # manual trigger anytime
```

## Trigger Context Variables

```yaml
steps:
  - name: Show trigger info
    run: |
      echo "Event: ${{ github.event_name }}"     # push / pull_request / schedule
      echo "Branch: ${{ github.ref_name }}"       # main / develop
      echo "Actor: ${{ github.actor }}"            # who triggered it
      echo "SHA: ${{ github.sha }}"               # commit hash
      echo "PR number: ${{ github.event.number }}" # only for pull_request
```$$,
  'GitHub Actions', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Triggers', 'push', 'pull_request', 'schedule', 'workflow_dispatch', 'GitHub Actions', 'Events'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are GitHub Actions runners? What is the difference between GitHub-hosted and self-hosted runners?',
  'github-actions-runners-hosted-vs-self-hosted',
  'Runners are the VMs that execute jobs. GitHub-hosted runners are free, managed VMs (Ubuntu/Windows/macOS). Self-hosted runners are your own machines — needed for private networks, custom tools, or cost savings at scale.',
  $$## GitHub Actions Runners

A **runner** is the machine (VM or container) that executes the steps in a job. Every job gets a **fresh runner** by default.

## GitHub-Hosted Runners

Managed by GitHub — free for public repos, 2000 min/month for private.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest      # Latest Ubuntu LTS
    # or:
    runs-on: ubuntu-22.04       # Specific Ubuntu version
    runs-on: windows-latest     # Windows Server
    runs-on: windows-2022
    runs-on: macos-latest       # macOS (most expensive minutes)
    runs-on: macos-14
```

### What's Pre-installed on ubuntu-latest

```yaml
- Java (multiple versions via setup-java)
- Node.js (multiple versions)
- Python 3.x
- Maven, Gradle
- Docker
- Chrome, Firefox (for headless Selenium/Cypress)
- git, curl, wget, jq
- AWS CLI, Azure CLI, GCP SDK
```

### Check Installed Software

```yaml
steps:
  - run: java -version
  - run: mvn -version
  - run: node --version
  - run: google-chrome --version
  - run: docker --version
```

## Self-Hosted Runners

Your own machine registered with GitHub. Used when you need:
- Access to private network / internal services
- Specific hardware (GPU, arm64)
- Custom pre-installed tools
- High usage (cost savings vs GitHub-hosted minutes)

### Register a Self-Hosted Runner

```bash
# 1. Go to: Repo → Settings → Actions → Runners → New self-hosted runner
# 2. Choose OS, download runner package
# 3. Configure and start:

./config.sh --url https://github.com/org/repo --token YOUR_TOKEN
./run.sh   # starts the runner (or install as service)
```

### Use Self-Hosted Runner in Workflow

```yaml
jobs:
  test:
    runs-on: self-hosted           # any self-hosted runner
    # or with labels:
    runs-on: [self-hosted, linux, selenium]   # runner with these labels
    runs-on: [self-hosted, windows, gpu]
```

### Label Your Runners

```bash
# Add labels when registering
./config.sh --url ... --token ... --labels "linux,selenium,chrome"
```

## Comparison

| | GitHub-Hosted | Self-Hosted |
|--|--------------|-------------|
| Setup | Zero | Install runner agent |
| Cost | Free (public) / Minutes (private) | Infrastructure cost |
| Maintenance | GitHub manages | You manage OS, updates |
| Network | Public internet only | Access internal systems |
| Hardware | Fixed (2 CPU, 7GB RAM) | Your spec |
| Security | Ephemeral (fresh each job) | Persistent — careful with secrets |
| Best for | Most projects | Private network, custom env |

## Docker Container Runner

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: maven:3.9-openjdk-17   # run job inside this container
      options: --user root
    steps:
      - uses: actions/checkout@v4
      - run: mvn test  # runs inside Maven container
```$$,
  'GitHub Actions', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Runners', 'GitHub-Hosted', 'Self-Hosted', 'ubuntu-latest', 'GitHub Actions', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you use secrets and environment variables in GitHub Actions?',
  'github-actions-secrets-environment-variables',
  'Store sensitive values in GitHub Secrets (Settings → Secrets). Access with ${{ secrets.SECRET_NAME }}. Plain env vars set with env: key. Never hardcode passwords or tokens in workflow files.',
  $$## Secrets and Environment Variables in GitHub Actions

## GitHub Secrets — For Sensitive Values

Secrets are encrypted and never visible in logs. GitHub masks them automatically.

### Adding Secrets

```
Repository → Settings → Secrets and variables → Actions → New repository secret

Name:  DB_PASSWORD
Value: mySecretP@ss123
```

### Using Secrets in Workflows

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Login to Docker Hub
        run: echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin

      - name: Run tests with DB credentials
        run: mvn test
        env:
          DB_HOST:     ${{ secrets.DB_HOST }}
          DB_USER:     ${{ secrets.DB_USER }}
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}

      - name: Deploy with API key
        run: ./deploy.sh
        env:
          API_KEY: ${{ secrets.PROD_API_KEY }}
```

### Organization Secrets (Shared Across Repos)

```
Organization → Settings → Secrets → Available to all/selected repos
# Access the same way: ${{ secrets.ORG_SECRET_NAME }}
```

## Environment Variables — For Non-Sensitive Config

### Workflow-Level (All Jobs)

```yaml
name: CI Pipeline
on: push

env:
  APP_NAME:    my-app
  JAVA_VERSION: '17'
  MAVEN_OPTS:  '-Xmx512m'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building ${{ env.APP_NAME }}"
```

### Job-Level (One Job)

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    env:
      TEST_ENV: staging
      BROWSER:  chrome

    steps:
      - run: mvn test -Denv=$TEST_ENV -Dbrowser=$BROWSER
```

### Step-Level (One Step Only)

```yaml
steps:
  - name: Run API tests
    run: mvn test -Dsuite=api
    env:
      API_BASE_URL: https://staging.api.example.com
      API_TOKEN:    ${{ secrets.STAGING_API_TOKEN }}
```

## GitHub Default Environment Variables

```yaml
steps:
  - run: |
      echo "Repo:    $GITHUB_REPOSITORY"     # org/repo-name
      echo "Branch:  $GITHUB_REF_NAME"       # main
      echo "SHA:     $GITHUB_SHA"            # commit hash (full)
      echo "Actor:   $GITHUB_ACTOR"          # username who triggered
      echo "RunID:   $GITHUB_RUN_ID"         # unique run ID
      echo "RunNum:  $GITHUB_RUN_NUMBER"     # sequential build number
      echo "Workspace: $GITHUB_WORKSPACE"    # /home/runner/work/repo/repo
```

## Dynamic Environment Variables (Between Steps)

```yaml
steps:
  - name: Set version
    run: echo "VERSION=$(mvn help:evaluate -q -Dexpression=project.version -DforceStdout)" >> $GITHUB_ENV

  - name: Use version in next step
    run: echo "Building version $VERSION"    # ← available now
    # Also accessible as: ${{ env.VERSION }}
```

## vars — Non-Secret Configuration Values (GitHub Variables)

```
Settings → Secrets and variables → Actions → Variables tab
Name: BASE_URL  Value: https://staging.automateqa.online
```

```yaml
- run: mvn test -DbaseUrl=${{ vars.BASE_URL }}
```

## Best Practices

```yaml
# ❌ Never do this
- run: curl -H "Authorization: token hardcoded-secret-here" ...

# ✅ Always use secrets
- run: curl -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" ...

# GITHUB_TOKEN is auto-provided by GitHub (no setup needed)
# Has read/write access to the repo depending on permissions
```$$,
  'GitHub Actions', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Secrets', 'Environment Variables', 'GitHub Actions', 'Security', 'GITHUB_TOKEN', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are jobs and steps in GitHub Actions? How do jobs depend on each other?',
  'github-actions-jobs-steps-needs',
  'Jobs are independent units of work that run in parallel by default, each on a fresh runner. Steps are sequential tasks inside a job. Use needs: to create dependencies between jobs.',
  $$## Jobs and Steps in GitHub Actions

## Jobs — Parallel Units of Work

By default, **all jobs run in parallel**. Each job gets its own fresh runner.

```yaml
name: CI Pipeline
on: push

jobs:
  build:          # ← Job 1
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."

  test:           # ← Job 2 (runs IN PARALLEL with build by default)
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing..."

  lint:           # ← Job 3 (also runs in parallel)
    runs-on: ubuntu-latest
    steps:
      - run: echo "Linting..."
```

## needs: — Job Dependencies (Sequential)

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: mvn clean package -DskipTests

  test:
    needs: build          # ← waits for build to succeed
    runs-on: ubuntu-latest
    steps:
      - run: mvn test

  deploy:
    needs: [build, test]  # ← waits for BOTH build AND test
    runs-on: ubuntu-latest
    steps:
      - run: ./deploy.sh

  notify:
    needs: deploy         # ← runs after deploy
    if: always()          # ← runs even if deploy failed
    runs-on: ubuntu-latest
    steps:
      - run: echo "Sending notification..."
```

## Steps — Sequential Tasks Inside a Job

Steps run **one after another** in the order defined. If a step fails, subsequent steps are skipped by default.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout repo
      - name: Checkout code
        uses: actions/checkout@v4

      # Step 2: Set up Java
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      # Step 3: Cache Maven dependencies
      - name: Cache Maven packages
        uses: actions/cache@v4
        with:
          path: ~/.m2
          key: ${{ runner.os }}-m2-${{ hashFiles('**/pom.xml') }}

      # Step 4: Run tests
      - name: Run TestNG tests
        run: mvn test -Dbrowser=chrome -Denv=staging

      # Step 5: Always upload report (even if tests fail)
      - name: Upload test report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-report
          path: target/surefire-reports/
```

## Step Conditions (if:)

```yaml
steps:
  - name: Run tests
    run: mvn test

  - name: Upload on failure only
    if: failure()           # only if previous step failed
    uses: actions/upload-artifact@v4
    with:
      name: failure-screenshots
      path: screenshots/

  - name: Deploy on main branch only
    if: github.ref == 'refs/heads/main' && success()
    run: ./deploy.sh

  - name: Always notify
    if: always()            # success OR failure
    run: echo "Done"
```

## Pass Data Between Steps Using outputs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.get-version.outputs.version }}

    steps:
      - id: get-version
        run: |
          VERSION=$(mvn help:evaluate -q -Dexpression=project.version -DforceStdout)
          echo "version=$VERSION" >> $GITHUB_OUTPUT

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying version ${{ needs.build.outputs.version }}"
```$$,
  'GitHub Actions', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Jobs', 'Steps', 'needs', 'Dependencies', 'GitHub Actions', 'Workflow', 'Parallel'], true, 0
);

-- ══════════════════════════════════════
-- INTERMEDIATE (Q6–Q18)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the matrix strategy in GitHub Actions? How do you run cross-browser or cross-version tests?',
  'github-actions-matrix-strategy-cross-browser',
  'Matrix strategy runs the same job with different combinations of variables. Use it to test across multiple browsers, Java versions, or OS combinations simultaneously — all running in parallel.',
  $$## Matrix Strategy in GitHub Actions

The **matrix strategy** runs one job multiple times with different variable combinations — all in parallel.

## Basic Matrix — Multiple Values

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        browser: [chrome, firefox, edge]

    steps:
      - uses: actions/checkout@v4
      - name: Run tests on ${{ matrix.browser }}
        run: mvn test -Dbrowser=${{ matrix.browser }}

# Creates 3 parallel jobs:
# test (chrome), test (firefox), test (edge)
```

## Multi-Dimensional Matrix — Cross-Browser × OS

```yaml
jobs:
  cross-platform-tests:
    strategy:
      matrix:
        os:      [ubuntu-latest, windows-latest]
        browser: [chrome, firefox]
        java:    ['17', '21']
      # 2 OS × 2 browsers × 2 Java = 8 parallel jobs!

    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK ${{ matrix.java }}
        uses: actions/setup-java@v4
        with:
          java-version: ${{ matrix.java }}
          distribution: 'temurin'

      - name: Run tests
        run: mvn test -Dbrowser=${{ matrix.browser }}

      - name: Upload results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: results-${{ matrix.os }}-${{ matrix.browser }}-java${{ matrix.java }}
          path: target/surefire-reports/
```

## include — Add Extra Variables to Specific Combinations

```yaml
strategy:
  matrix:
    browser: [chrome, firefox]
    include:
      - browser: chrome
        headless: true
        driver-version: '120'
      - browser: firefox
        headless: true
        driver-version: '121'
      - browser: safari    # extra combination not in base list
        os: macos-latest
        headless: false
```

## exclude — Remove Specific Combinations

```yaml
strategy:
  matrix:
    os:      [ubuntu-latest, windows-latest, macos-latest]
    browser: [chrome, firefox, edge]
    exclude:
      - os: ubuntu-latest
        browser: edge     # Edge not supported on Linux
      - os: macos-latest
        browser: edge     # Edge has issues on macOS
```

## fail-fast and max-parallel

```yaml
strategy:
  fail-fast: false      # don't cancel other matrix jobs if one fails
  max-parallel: 3       # run max 3 jobs at a time (limit concurrency)
  matrix:
    browser: [chrome, firefox, edge, safari]
```

## Matrix with Environment Targets

```yaml
jobs:
  regression:
    strategy:
      matrix:
        environment: [staging, qa]
        suite: [smoke, regression]

    environment: ${{ matrix.environment }}

    steps:
      - run: mvn test -Denv=${{ matrix.environment }} -Dsuite=${{ matrix.suite }}
```

## Real-World: Java Multi-Version Testing

```yaml
jobs:
  test-java-compatibility:
    strategy:
      matrix:
        java: ['11', '17', '21']

    runs-on: ubuntu-latest
    name: Test on Java ${{ matrix.java }}

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          java-version: ${{ matrix.java }}
          distribution: 'temurin'

      - run: mvn test
        name: Run tests on Java ${{ matrix.java }}
```$$,
  'GitHub Actions', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Matrix Strategy', 'Cross-Browser', 'Parallel Testing', 'GitHub Actions', 'CI/CD', 'include', 'exclude'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you cache dependencies in GitHub Actions to speed up builds?',
  'github-actions-cache-dependencies',
  'Use actions/cache@v4 with a cache key based on dependency lock files. For Maven cache ~/.m2, for npm cache node_modules or ~/.npm, for pip cache ~/.cache/pip. Cache hit skips the install step.',
  $$## Caching Dependencies in GitHub Actions

Without caching, every run downloads all dependencies fresh — slow and wasteful. Caching saves them between runs.

## Cache a Maven Project (~/.m2)

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Cache Maven dependencies
        uses: actions/cache@v4
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            ${{ runner.os }}-maven-
        # key:          exact match (pom.xml unchanged → cache hit)
        # restore-keys: partial match fallback (pom.xml changed → use old cache, update after)

      - name: Build and test
        run: mvn clean verify
```

## Built-in Cache via setup-java (Simpler)

```yaml
- name: Set up JDK 17 with Maven cache
  uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'
    cache: 'maven'   # ← handles caching automatically!
    # also supports: 'gradle', 'sbt'
```

## Cache npm / Node.js (Cypress, Playwright)

```yaml
- name: Set up Node.js with npm cache
  uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'       # ← built-in cache for npm
    # cache: 'yarn' or 'pnpm' also supported

- run: npm ci          # use ci (not install) for reproducible installs

# Or manual cache:
- name: Cache node_modules
  uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

## Cache Gradle

```yaml
- name: Cache Gradle packages
  uses: actions/cache@v4
  with:
    path: |
      ~/.gradle/caches
      ~/.gradle/wrapper
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
    restore-keys: |
      ${{ runner.os }}-gradle-
```

## Cache Python (pip)

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'
    cache: 'pip'       # built-in pip cache

- run: pip install -r requirements.txt
```

## How Cache Keys Work

```
key: ubuntu-latest-maven-abc123   ← exact match → CACHE HIT (fastest)

restore-keys:
  ubuntu-latest-maven-           ← prefix match → CACHE MISS but partial restore
  ubuntu-latest-                  ← broader fallback

On CACHE HIT:  restores files, skips download
On CACHE MISS: downloads normally, saves new cache after job
```

## Cache Limits

- Max cache size per entry: **10 GB**
- Cache evicted after **7 days** of no use
- Per-repo cache limit: **10 GB** (then oldest evicted)

## Measuring Cache Impact

```yaml
- name: Cache Maven
  id: cache-maven
  uses: actions/cache@v4
  with:
    path: ~/.m2/repository
    key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}

- name: Check cache status
  run: |
    if [ "${{ steps.cache-maven.outputs.cache-hit }}" == "true" ]; then
      echo "Cache HIT — dependencies restored from cache"
    else
      echo "Cache MISS — downloading dependencies"
    fi
```

## Typical Time Savings

| Project | Without Cache | With Cache |
|---------|-------------|-----------|
| Maven (200 deps) | 3–5 min | 20–30 sec |
| npm (node_modules) | 2–4 min | 15–25 sec |
| pip (ML packages) | 5–10 min | 30–60 sec |$$,
  'GitHub Actions', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Cache', 'actions/cache', 'Maven Cache', 'npm cache', 'GitHub Actions', 'Performance', 'Dependencies'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are GitHub Actions artifacts? How do you upload and download them?',
  'github-actions-artifacts-upload-download',
  'Artifacts are files persisted after a job ends — test reports, screenshots, build JARs. Use actions/upload-artifact to save and actions/download-artifact to retrieve them in another job.',
  $$## GitHub Actions Artifacts

**Artifacts** let you persist files generated during a workflow — test reports, screenshots, build outputs, coverage reports — so you can download them after the workflow finishes.

## Upload Artifacts

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run tests
        run: mvn test
        continue-on-error: true    # don't stop if tests fail

      - name: Upload Surefire reports
        if: always()               # upload even if tests failed
        uses: actions/upload-artifact@v4
        with:
          name: surefire-reports
          path: target/surefire-reports/
          retention-days: 14       # keep for 14 days (default 90)

      - name: Upload Allure results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: allure-results
          path: target/allure-results/

      - name: Upload screenshots on failure
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: failure-screenshots-${{ github.run_number }}
          path: screenshots/

      - name: Upload built JAR
        uses: actions/upload-artifact@v4
        with:
          name: app-jar
          path: target/*.jar
```

## Download Artifacts in Another Job

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: mvn clean package -DskipTests
      - uses: actions/upload-artifact@v4
        with:
          name: app-jar
          path: target/*.jar

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Download built JAR
        uses: actions/download-artifact@v4
        with:
          name: app-jar
          path: ./artifacts/

      - name: Deploy
        run: |
          ls -la ./artifacts/
          ./deploy.sh ./artifacts/myapp-1.0.jar
```

## Upload Multiple Paths

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: test-results
    path: |
      target/surefire-reports/
      target/extent-reports/
      screenshots/
      logs/*.log
```

## Download All Artifacts From a Run

```yaml
- name: Download all artifacts
  uses: actions/download-artifact@v4
  # No 'name' = downloads all artifacts into separate directories
  with:
    path: all-artifacts/

- run: ls -la all-artifacts/
# all-artifacts/
# ├── surefire-reports/
# ├── allure-results/
# └── app-jar/
```

## Artifact Naming with Matrix

```yaml
strategy:
  matrix:
    browser: [chrome, firefox]

steps:
  - name: Upload results
    if: always()
    uses: actions/upload-artifact@v4
    with:
      name: test-results-${{ matrix.browser }}   # unique name per matrix job
      path: target/surefire-reports/
```

## View and Download Artifacts

After workflow runs:
1. Go to the **Actions** tab
2. Click the workflow run
3. Scroll down to **Artifacts** section
4. Click to download as ZIP

## Artifact vs Cache

| | Cache | Artifact |
|--|-------|---------|
| Purpose | Speed up builds (dependencies) | Store outputs (reports, builds) |
| Shared between | Runs (persists across runs) | Jobs (within one run) |
| Downloadable | No | Yes (from Actions UI) |
| Auto-deleted | After 7 days unused | After 90 days (configurable) |$$,
  'GitHub Actions', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Artifacts', 'upload-artifact', 'download-artifact', 'GitHub Actions', 'Test Reports', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are reusable workflows in GitHub Actions? How do you create and call them?',
  'github-actions-reusable-workflows',
  'Reusable workflows are workflow files called by other workflows using workflow_call trigger. They accept inputs and secrets, avoiding duplication across multiple repos or pipelines.',
  $$## Reusable Workflows in GitHub Actions

**Reusable workflows** are workflow files that can be **called from other workflows** — the DRY principle for GitHub Actions. One team defines the standard pipeline; all projects reuse it.

## Creating a Reusable Workflow

```yaml
# .github/workflows/run-tests.yml  (in your repo or a shared org repo)
name: Reusable — Run Automation Tests

on:
  workflow_call:             # ← this makes it reusable
    inputs:
      environment:
        description: 'Target environment'
        required: true
        type: string
      browser:
        description: 'Browser'
        required: false
        type: string
        default: 'chrome'
      java-version:
        required: false
        type: string
        default: '17'

    secrets:
      DB_PASSWORD:
        required: true
      API_KEY:
        required: false

    outputs:
      test-result:
        description: 'Pass or Fail'
        value: ${{ jobs.test.outputs.result }}

jobs:
  test:
    runs-on: ubuntu-latest
    outputs:
      result: ${{ steps.run.outcome }}

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          java-version: ${{ inputs.java-version }}
          distribution: temurin
          cache: maven

      - id: run
        name: Run Tests
        run: mvn test -Denv=${{ inputs.environment }} -Dbrowser=${{ inputs.browser }}
        env:
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
          API_KEY:     ${{ secrets.API_KEY }}

      - if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-results-${{ inputs.environment }}
          path: target/surefire-reports/
```

## Calling the Reusable Workflow

```yaml
# .github/workflows/ci.yml  (in any project repo)
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  smoke-tests:
    uses: my-org/shared-workflows/.github/workflows/run-tests.yml@main
    with:
      environment: staging
      browser:     chrome
    secrets:
      DB_PASSWORD: ${{ secrets.STAGING_DB_PASSWORD }}
      API_KEY:     ${{ secrets.STAGING_API_KEY }}

  regression-tests:
    uses: my-org/shared-workflows/.github/workflows/run-tests.yml@main
    with:
      environment: qa
      browser:     firefox
    secrets:
      DB_PASSWORD: ${{ secrets.QA_DB_PASSWORD }}
      API_KEY:     ${{ secrets.QA_API_KEY }}

  use-output:
    needs: smoke-tests
    runs-on: ubuntu-latest
    steps:
      - run: echo "Smoke test result: ${{ needs.smoke-tests.outputs.test-result }}"
```

## Reusable Workflow vs Composite Action

| | Reusable Workflow | Composite Action |
|--|------------------|-----------------|
| File location | `.github/workflows/` | `action.yml` in any directory |
| Contains | Full workflow (jobs + steps) | Only steps |
| Runs on | Its own runner | Caller's runner |
  | Called via | `uses: org/repo/.github/workflows/file.yml@ref` | `uses: org/repo/path@ref` |
| Can use secrets | Yes | No (must pass as input) |
| Best for | Full pipelines | Small reusable step groups |

## Secrets Inheritance (inherit keyword)

```yaml
# Pass ALL calling workflow's secrets automatically
jobs:
  call-workflow:
    uses: org/repo/.github/workflows/deploy.yml@main
    secrets: inherit    # ← passes all secrets from caller
    with:
      environment: production
```$$,
  'GitHub Actions', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Reusable Workflows', 'workflow_call', 'DRY', 'GitHub Actions', 'Shared Pipelines', 'CI/CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are GitHub Actions environments? How do you use deployment protection rules?',
  'github-actions-environments-deployment-protection',
  'Environments represent deployment targets (staging, production). They support protection rules: required reviewers, wait timers, and branch restrictions — ensuring only approved code deploys to production.',
  $$## GitHub Actions Environments

**Environments** represent deployment targets — staging, qa, production — with their own secrets, variables, and protection rules.

## Creating an Environment

```
Repository → Settings → Environments → New environment
```

### Configure:
- **Name**: `production`
- **Protection rules**:
  - Required reviewers: 2 people must approve
  - Wait timer: 5 minutes before deploy starts
  - Deployment branch rule: only `main` branch
- **Secrets**: `PROD_DB_URL`, `PROD_API_KEY` (scoped to this env only)

## Using an Environment in a Workflow

```yaml
name: Deploy Pipeline

on:
  push:
    branches: [main]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment: staging          # ← links to staging environment
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to staging
        run: ./deploy.sh staging
        env:
          DB_URL: ${{ secrets.DB_URL }}     # staging secret
          API_KEY: ${{ secrets.API_KEY }}   # staging secret

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment:
      name: production            # ← links to production environment
      url: https://automateqa.online  # shown in GitHub UI as deployment URL
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to production
        run: ./deploy.sh production
        env:
          DB_URL: ${{ secrets.DB_URL }}     # production secret (different values!)
          API_KEY: ${{ secrets.API_KEY }}
```

## Protection Rules in Action

```
Flow with required reviewer:

1. Workflow runs → reaches deploy-production job
2. GitHub PAUSES the job ← waiting for approval
3. Reviewers get notified via email/GitHub notification
4. Reviewer clicks "Approve" in GitHub UI
5. Job resumes and deploys to production
```

## Wait Timer

```
Settings → Environment → Wait timer: 10 minutes

→ After all checks pass, GitHub waits 10 minutes
→ Then auto-starts the deployment
→ Use case: gives team time to notice and cancel if needed
```

## Branch Protection — Only Deploy From Specific Branches

```
Settings → Environment → Deployment branch and tag rules
→ Selected branches: main
→ Only workflows running on 'main' branch can deploy here
→ PRs cannot accidentally trigger production deployments
```

## Staged Deployment Pattern

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: mvn test

  deploy-staging:
    needs: test
    runs-on: ubuntu-latest
    environment: staging      # no protection — auto-deploys
    steps:
      - run: ./deploy.sh staging

  integration-tests:
    needs: deploy-staging
    runs-on: ubuntu-latest
    steps:
      - run: mvn test -Dsuite=integration -Denv=staging

  deploy-production:
    needs: integration-tests
    runs-on: ubuntu-latest
    environment: production   # REQUIRES APPROVAL ← protected
    steps:
      - run: ./deploy.sh production
```

## Environment Variables (Not Secrets)

```
Settings → Environment → Variables (non-sensitive config)
Name: BASE_URL   Value: https://staging.automateqa.online
```

```yaml
steps:
  - run: mvn test -DbaseUrl=${{ vars.BASE_URL }}
```$$,
  'GitHub Actions', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Environments', 'Deployment Protection', 'Required Reviewers', 'GitHub Actions', 'Production Deploy', 'CD'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are composite actions in GitHub Actions? How do you create a custom action?',
  'github-actions-composite-custom-action',
  'Composite actions bundle multiple steps into a reusable action stored in a repository. Define in action.yml with using: composite. Call from any workflow with uses: org/repo/path@version.',
  $$## Composite Actions in GitHub Actions

A **composite action** groups multiple steps into a single reusable block — like a helper function for workflows.

## Project Structure

```
my-actions/
└── setup-and-test/
    └── action.yml     ← the composite action
```

## Creating a Composite Action

```yaml
# .github/actions/setup-and-test/action.yml
name: 'Setup Java and Run Tests'
description: 'Sets up JDK, caches Maven, and runs TestNG suite'

inputs:
  java-version:
    description: 'Java version to use'
    required: false
    default: '17'
  browser:
    description: 'Browser for tests'
    required: false
    default: 'chrome'
  suite:
    description: 'TestNG suite file'
    required: false
    default: 'testng.xml'
  environment:
    description: 'Target environment'
    required: true

outputs:
  test-status:
    description: 'Pass or Fail'
    value: ${{ steps.run-tests.outcome }}

runs:
  using: 'composite'      # ← makes this a composite action
  steps:
    - name: Set up JDK
      uses: actions/setup-java@v4
      with:
        java-version: ${{ inputs.java-version }}
        distribution: temurin
        cache: maven

    - name: Install Chrome
      shell: bash
      run: |
        sudo apt-get update -q
        sudo apt-get install -y google-chrome-stable

    - name: Run tests
      id: run-tests
      shell: bash
      run: |
        mvn test \
          -Dbrowser=${{ inputs.browser }} \
          -Denv=${{ inputs.environment }} \
          -Dsurefire.suiteXmlFiles=${{ inputs.suite }}

    - name: Upload results
      if: always()
      uses: actions/upload-artifact@v4
      with:
        name: results-${{ inputs.environment }}-${{ inputs.browser }}
        path: target/surefire-reports/
```

## Using the Composite Action

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  smoke-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup and run smoke tests
        uses: ./.github/actions/setup-and-test    # local path
        # OR from another repo:
        # uses: my-org/shared-actions/setup-and-test@v1
        with:
          browser:     chrome
          suite:       smoke-testng.xml
          environment: staging

  regression-firefox:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup and run regression on Firefox
        uses: ./.github/actions/setup-and-test
        with:
          browser:     firefox
          suite:       regression-testng.xml
          environment: qa
```

## Publish Action to Marketplace (action.yml in root)

```yaml
# action.yml (at repo ROOT for marketplace publishing)
name: 'Run Selenium Tests'
description: 'Run Selenium/TestNG automation tests with configurable browser and environment'
author: 'AutomateQA'

branding:
  icon:  'play-circle'
  color: 'green'

inputs:
  browser:
    description: 'Browser (chrome/firefox/edge)'
    required: false
    default: 'chrome'

runs:
  using: 'composite'
  steps:
    - shell: bash
      run: echo "Running tests on ${{ inputs.browser }}"
```

## Composite vs JavaScript/Docker Actions

| | Composite | JavaScript | Docker |
|--|-----------|-----------|--------|
| Language | YAML steps | Node.js | Any language |
| Speed | Medium | Fast | Slowest (pulls image) |
| Complexity | Simple | Medium | Complex |
| Reuse existing Actions | Yes | No | No |
| Best for | Grouping workflow steps | Speed-critical logic | Custom environments |$$,
  'GitHub Actions', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Composite Action', 'Custom Action', 'action.yml', 'GitHub Actions', 'Reusability', 'Marketplace'], true, 0
);

-- ══════════════════════════════════════
-- SCENARIO-BASED (Q14–Q20)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you set up a complete GitHub Actions CI pipeline for a Selenium Java project?',
  'github-actions-selenium-java-pipeline',
  'A complete GitHub Actions pipeline for Selenium Java: trigger on push/PR, set up JDK + Maven cache, run headless Chrome tests, upload Allure/Surefire reports, send Slack/email notification on failure.',
  $$## Complete GitHub Actions Pipeline for Selenium Java

## Directory Structure

```
selenium-framework/
├── .github/
│   └── workflows/
│       ├── ci.yml           ← runs on every push/PR
│       └── nightly.yml      ← full regression at 2 AM
├── src/
│   └── test/java/...
├── testng.xml
├── smoke-testng.xml
└── pom.xml
```

## CI Workflow — Every Push and PR

```yaml
# .github/workflows/ci.yml
name: Selenium Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  workflow_dispatch:
    inputs:
      browser:
        type: choice
        options: [chrome, firefox, edge]
        default: chrome
      environment:
        type: choice
        options: [staging, qa]
        default: staging
      suite:
        type: choice
        options: [testng.xml, smoke-testng.xml]
        default: smoke-testng.xml

env:
  JAVA_VERSION:   '17'
  BROWSER:        ${{ inputs.browser || 'chrome' }}
  ENVIRONMENT:    ${{ inputs.environment || 'staging' }}
  SUITE:          ${{ inputs.suite || 'smoke-testng.xml' }}
  MAVEN_OPTS:     '-Xmx1024m'

jobs:
  selenium-tests:
    name: "${{ env.SUITE }} on ${{ env.BROWSER }} (${{ env.ENVIRONMENT }})"
    runs-on: ubuntu-latest

    steps:
      # 1. Get the code
      - name: Checkout repository
        uses: actions/checkout@v4

      # 2. Set up Java with Maven cache
      - name: Set up JDK ${{ env.JAVA_VERSION }}
        uses: actions/setup-java@v4
        with:
          java-version: ${{ env.JAVA_VERSION }}
          distribution: temurin
          cache: maven

      # 3. Install Chrome for headless execution
      - name: Install Google Chrome
        run: |
          sudo apt-get update -q
          sudo apt-get install -y google-chrome-stable
          google-chrome --version

      # 4. Run Selenium tests
      - name: Run Selenium Tests
        id: test-run
        run: |
          mvn test \
            -Dbrowser=${{ env.BROWSER }} \
            -Denv=${{ env.ENVIRONMENT }} \
            -Dsurefire.suiteXmlFiles=${{ env.SUITE }} \
            -Dheadless=true
        env:
          BASE_URL:    ${{ secrets.BASE_URL }}
          DB_USER:     ${{ secrets.DB_USER }}
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
        continue-on-error: true

      # 5. Upload test reports (always)
      - name: Upload Surefire Reports
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: surefire-${{ env.BROWSER }}-${{ github.run_number }}
          path: target/surefire-reports/
          retention-days: 14

      - name: Upload Allure Results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: allure-results-${{ github.run_number }}
          path: target/allure-results/
          retention-days: 14

      # 6. Upload screenshots on failure
      - name: Upload failure screenshots
        if: failure() || steps.test-run.outcome == 'failure'
        uses: actions/upload-artifact@v4
        with:
          name: screenshots-${{ github.run_number }}
          path: screenshots/
          if-no-files-found: ignore

      # 7. Notify Slack on failure
      - name: Slack notification on failure
        if: failure()
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "❌ *Tests FAILED*: ${{ github.repository }} | Branch: ${{ github.ref_name }} | Browser: ${{ env.BROWSER }} | <${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}|View Run>"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

      # 8. Fail the job if tests failed
      - name: Fail if tests failed
        if: steps.test-run.outcome == 'failure'
        run: exit 1
```

## Nightly Regression Workflow

```yaml
# .github/workflows/nightly.yml
name: Nightly Regression

on:
  schedule:
    - cron: '0 2 * * 1-5'   # 2 AM UTC weekdays

jobs:
  regression:
    strategy:
      fail-fast: false
      matrix:
        browser: [chrome, firefox]

    runs-on: ubuntu-latest
    name: Regression on ${{ matrix.browser }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: temurin
          cache: maven

      - run: sudo apt-get install -y google-chrome-stable firefox

      - name: Full regression
        run: mvn test -Dbrowser=${{ matrix.browser }} -Dsurefire.suiteXmlFiles=testng.xml
        env:
          BASE_URL: ${{ secrets.STAGING_URL }}

      - if: always()
        uses: actions/upload-artifact@v4
        with:
          name: nightly-${{ matrix.browser }}
          path: target/surefire-reports/
```

## Java Headless Driver Config

```java
// Read from system property set by Maven
boolean headless = Boolean.parseBoolean(System.getProperty("headless", "false"));

ChromeOptions opts = new ChromeOptions();
if (headless) {
    opts.addArguments("--headless=new", "--no-sandbox",
                      "--disable-dev-shm-usage", "--window-size=1920,1080");
}
driver = new ChromeDriver(opts);
```$$,
  'GitHub Actions', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Selenium', 'Java', 'GitHub Actions', 'CI Pipeline', 'Maven', 'TestNG', 'Headless Chrome'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you run Cypress tests in GitHub Actions with parallel execution?',
  'github-actions-cypress-parallel',
  'Use the official cypress-io/github-action with the matrix strategy for parallelization, or Cypress Cloud with record: true and parallel: true. Always upload screenshots and videos as artifacts on failure.',
  $$## Running Cypress Tests in GitHub Actions

## Basic Cypress Workflow

```yaml
# .github/workflows/cypress.yml
name: Cypress E2E Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  cypress-tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run Cypress tests
        uses: cypress-io/github-action@v6
        with:
          start: npm start              # start dev server
          wait-on: 'http://localhost:3000'
          wait-on-timeout: 60
          browser: chrome
          headed: false
        env:
          CYPRESS_BASE_URL:   ${{ secrets.CYPRESS_BASE_URL }}
          CYPRESS_USERNAME:   ${{ secrets.TEST_USERNAME }}
          CYPRESS_PASSWORD:   ${{ secrets.TEST_PASSWORD }}

      - name: Upload screenshots on failure
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: cypress-screenshots
          path: cypress/screenshots
          if-no-files-found: ignore

      - name: Upload videos
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: cypress-videos
          path: cypress/videos
          if-no-files-found: ignore
```

## Parallel Execution — Matrix Strategy (Free, No Cypress Cloud)

```yaml
name: Cypress Parallel Tests

on: [push, pull_request]

jobs:
  cypress-parallel:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        spec:
          - 'cypress/e2e/auth/**'
          - 'cypress/e2e/dashboard/**'
          - 'cypress/e2e/checkout/**'
          - 'cypress/e2e/api/**'

    name: Tests — ${{ matrix.spec }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci

      - name: Run spec
        uses: cypress-io/github-action@v6
        with:
          start: npm start
          wait-on: 'http://localhost:3000'
          spec: ${{ matrix.spec }}
        env:
          CYPRESS_BASE_URL: ${{ secrets.CYPRESS_BASE_URL }}

      - if: always()
        uses: actions/upload-artifact@v4
        with:
          name: results-${{ strategy.job-index }}
          path: |
            cypress/screenshots
            cypress/videos
          if-no-files-found: ignore
```

## Parallel Execution — Cypress Cloud (Paid)

```yaml
jobs:
  cypress-cloud:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        containers: [1, 2, 3, 4]   # 4 parallel machines

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci

      - uses: cypress-io/github-action@v6
        with:
          start: npm start
          wait-on: 'http://localhost:3000'
          record: true       # ← Cypress Cloud
          parallel: true     # ← auto-balances specs
          group: 'E2E Tests'
        env:
          CYPRESS_RECORD_KEY:  ${{ secrets.CYPRESS_RECORD_KEY }}
          GITHUB_TOKEN:        ${{ secrets.GITHUB_TOKEN }}
```

## Cross-Browser Cypress

```yaml
jobs:
  cypress-cross-browser:
    strategy:
      matrix:
        browser: [chrome, firefox, edge]
    runs-on: ubuntu-latest
    name: Cypress on ${{ matrix.browser }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20', cache: 'npm' }
      - run: npm ci

      - uses: cypress-io/github-action@v6
        with:
          browser: ${{ matrix.browser }}
          start: npm start
          wait-on: 'http://localhost:3000'
        env:
          CYPRESS_BASE_URL: ${{ secrets.CYPRESS_BASE_URL }}

      - if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: screenshots-${{ matrix.browser }}
          path: cypress/screenshots
```

## cypress.config.js — CI Optimized

```javascript
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl:                 process.env.CYPRESS_BASE_URL || 'http://localhost:3000',
    video:                   true,
    screenshotOnRunFailure:  true,
    defaultCommandTimeout:   10000,
    viewportWidth:           1280,
    viewportHeight:          720,
    retries: {
      runMode:  2,    // retry failed tests 2x in CI
      openMode: 0,    // no retry in interactive mode
    },
  },
})
```$$,
  'GitHub Actions', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Cypress', 'GitHub Actions', 'Parallel Testing', 'CI/CD', 'Matrix', 'E2E', 'Cross-Browser'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you build and push a Docker image using GitHub Actions?',
  'github-actions-docker-build-push',
  'Use docker/login-action to authenticate, docker/build-push-action to build and push the image to Docker Hub or GHCR. Tag images with git SHA and latest. Use build cache to speed up builds.',
  $$## Build and Push Docker Image with GitHub Actions

## Push to Docker Hub

```yaml
# .github/workflows/docker.yml
name: Build and Push Docker Image

on:
  push:
    branches: [main]
    tags: ['v*.*.*']     # also trigger on version tags like v1.2.3

env:
  IMAGE_NAME: myorg/myapp

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      # Extract metadata (tags, labels) for Docker
      - name: Extract Docker metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix=sha-                   # sha-abc1234
            type=ref,event=branch                  # main
            type=semver,pattern={{version}}        # 1.2.3  (from git tag)
            type=semver,pattern={{major}}.{{minor}} # 1.2
            type=raw,value=latest,enable={{is_default_branch}}

      # Login to Docker Hub
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}    # use token, not password

      # Set up Docker Buildx (for multi-platform builds + cache)
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Build and push
      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags:    ${{ steps.meta.outputs.tags }}
          labels:  ${{ steps.meta.outputs.labels }}
          cache-from: type=gha              # use GitHub Actions cache
          cache-to:   type=gha,mode=max    # save cache after build
          platforms: linux/amd64,linux/arm64   # multi-arch
```

## Push to GitHub Container Registry (GHCR — Free)

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}   # org/repo → ghcr.io/org/repo

jobs:
  docker:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write   # needed to push to GHCR

    steps:
      - uses: actions/checkout@v4

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}   # auto-provided, no setup needed!

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: ${{ github.ref == 'refs/heads/main' }}   # only push on main
          tags: |
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
```

## Full CI/CD: Test → Build → Push → Deploy

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { java-version: '17', distribution: temurin, cache: maven }
      - run: mvn test

  build-push:
    needs: test
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ github.sha }}

    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: myorg/myapp:${{ github.sha }},myorg/myapp:latest
          cache-from: type=gha
          cache-to:   type=gha,mode=max

  deploy:
    needs: build-push
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Deploy to server
        run: |
          ssh -i ${{ secrets.SSH_KEY }} user@server.example.com \
            "docker pull myorg/myapp:${{ github.sha }} && \
             docker stop myapp || true && \
             docker run -d --name myapp -p 8080:8080 myorg/myapp:${{ github.sha }}"
```

## Dockerfile Example

```dockerfile
FROM openjdk:17-jre-slim
WORKDIR /app
COPY target/myapp-*.jar app.jar
EXPOSE 8080
HEALTHCHECK --interval=30s CMD curl -f http://localhost:8080/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
```$$,
  'GitHub Actions', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Docker', 'GitHub Actions', 'Build Push', 'GHCR', 'Docker Hub', 'CI/CD', 'Container'], true, 0
);
