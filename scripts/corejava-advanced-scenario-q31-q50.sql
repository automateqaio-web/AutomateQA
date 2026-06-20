-- Core Java Advanced + Scenario-Based Q31–Q50 | Paste into Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Java Memory Model? Explain Stack, Heap, and Garbage Collection.',
  'java-memory-model-stack-heap-garbage-collection',
  'Stack stores method calls and local variables; Heap stores objects. Garbage Collector automatically removes unreferenced objects from the heap.',
  $$## Java Memory Model

## JVM Memory Areas

```
┌─────────────────────────────────────────────────────┐
│                     JVM Memory                       │
│                                                     │
│  ┌─────────────┐   ┌──────────────────────────────┐ │
│  │    STACK    │   │            HEAP               │ │
│  │─────────────│   │──────────────────────────────│ │
│  │ Thread-1   │   │  Young Generation             │ │
│  │  frame 1   │   │   ├── Eden Space               │ │
│  │  frame 2   │   │   ├── Survivor S0              │ │
│  │──────────── │   │   └── Survivor S1              │ │
│  │ Thread-2   │   │                               │ │
│  │  frame 1   │   │  Old Generation (Tenured)     │ │
│  └─────────────┘   └──────────────────────────────┘ │
│                                                     │
│  ┌──────────────────────────────────────────────┐   │
│  │          Method Area / Metaspace             │   │
│  │  Class bytecode, static vars, constants      │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## Stack Memory

- Stores **method call frames** and **local variables**
- Each thread has its **own stack**
- Memory is allocated/freed automatically (LIFO)
- Fixed size — `StackOverflowError` if exhausted (infinite recursion)

```java
public static void main(String[] args) {
    int x = 10;          // local variable → stored in stack
    String name = "Alice"; // reference → stack; object → heap
    calculate(x);
}

public static int calculate(int a) {   // new stack frame created
    int result = a * 2;                // local → stack
    return result;
}   // frame popped — result removed from stack
```

## Heap Memory

- Stores **all objects** created with `new`
- Shared across all threads
- Managed by **Garbage Collector**
- Divided into Young and Old Generations

```java
// Object stored in heap — reference variable in stack
Person p = new Person("Alice");  // "new Person()" → heap
                                  // variable p → stack (holds address)
p = null;  // p no longer references object
// Person object becomes eligible for GC
```

## Garbage Collection (GC)

GC automatically reclaims memory occupied by **objects with no references**.

### GC Process
```
1. Eden Space → new objects created here
2. Minor GC → survivors move to S0/S1
3. After several GC cycles → moved to Old Generation
4. Major/Full GC → cleans Old Generation (expensive)
```

### Making Object Eligible for GC
```java
// 1. Set reference to null
Person p = new Person("Alice");
p = null;  // eligible for GC

// 2. Reassign reference
p = new Person("Bob");  // Alice object now unreachable

// 3. Object goes out of scope
{
    Person temp = new Person("Temp");
    // temp goes out of scope here — eligible for GC
}
```

## Memory Leaks (Common in Java)

```java
// Static collections holding references indefinitely
public class SessionManager {
    private static List<Object> activeSessions = new ArrayList<>();

    public void addSession(Object session) {
        activeSessions.add(session); // never removed = memory leak
    }
}

// Fix: remove when done
public void removeSession(Object session) {
    activeSessions.remove(session);
}
```

## JVM Flags for Memory

```bash
java -Xms256m        # Initial heap size 256MB
java -Xmx1024m       # Max heap size 1GB
java -Xss512k        # Thread stack size 512KB
java -XX:+UseG1GC    # Use G1 Garbage Collector
```

## In Automation (OutOfMemoryError)

```java
// Common cause: storing all screenshots in memory
List<byte[]> screenshots = new ArrayList<>();

// In long test suites — screenshots accumulate → OutOfMemoryError
// Fix: process and discard immediately
File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(screenshot, new File("target/" + testName + ".png"));
// Don't store in List
```$$,
  'Core Java', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Memory Model', 'Stack', 'Heap', 'Garbage Collection', 'JVM', 'Core Java', 'Performance'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is deadlock in Java and how do you prevent it?',
  'deadlock-java-prevention',
  'Deadlock occurs when two or more threads wait for each other forever to release locks. Prevent by lock ordering, timeout, or using tryLock().',
  $$## Deadlock in Java

**Deadlock** occurs when two or more threads are blocked forever, each waiting for a resource held by the other.

## Deadlock Example

```java
public class DeadlockDemo {
    private static final Object LOCK_A = new Object();
    private static final Object LOCK_B = new Object();

    public static void main(String[] args) {

        Thread t1 = new Thread(() -> {
            synchronized (LOCK_A) {
                System.out.println("T1: holding A, waiting for B");
                try { Thread.sleep(100); } catch (Exception e) {}
                synchronized (LOCK_B) {
                    System.out.println("T1: acquired B");
                }
            }
        });

        Thread t2 = new Thread(() -> {
            synchronized (LOCK_B) {         // T2 acquires B
                System.out.println("T2: holding B, waiting for A");
                try { Thread.sleep(100); } catch (Exception e) {}
                synchronized (LOCK_A) {     // T2 waits for A — DEADLOCK!
                    System.out.println("T2: acquired A");
                }
            }
        });

        t1.start();
        t2.start();
        // T1 holds A waiting for B
        // T2 holds B waiting for A → DEADLOCK
    }
}
```

## 4 Conditions for Deadlock (Coffman Conditions)
1. **Mutual Exclusion** — one thread at a time can hold the lock
2. **Hold and Wait** — thread holds one lock while waiting for another
3. **No Preemption** — locks can't be forcibly taken
4. **Circular Wait** — T1 waits for T2, T2 waits for T1

## Prevention Strategies

### 1. Lock Ordering — Always acquire locks in the same order
```java
// Both threads acquire A then B — no deadlock possible
Thread t1 = new Thread(() -> {
    synchronized (LOCK_A) {
        synchronized (LOCK_B) {  // same order as T2
            System.out.println("T1 done");
        }
    }
});

Thread t2 = new Thread(() -> {
    synchronized (LOCK_A) {  // SAME order — A first, then B
        synchronized (LOCK_B) {
            System.out.println("T2 done");
        }
    }
});
```

### 2. tryLock with Timeout (java.util.concurrent.locks)
```java
import java.util.concurrent.locks.*;
import java.util.concurrent.TimeUnit;

ReentrantLock lockA = new ReentrantLock();
ReentrantLock lockB = new ReentrantLock();

Thread t1 = new Thread(() -> {
    try {
        if (lockA.tryLock(1, TimeUnit.SECONDS)) {
            try {
                if (lockB.tryLock(1, TimeUnit.SECONDS)) {
                    try {
                        System.out.println("T1 acquired both locks");
                    } finally { lockB.unlock(); }
                } else {
                    System.out.println("T1: couldn''t get B — releasing A");
                }
            } finally { lockA.unlock(); }
        }
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
});
```

### 3. Use Higher-Level Concurrency Utilities
```java
// Prefer ExecutorService over raw threads
ExecutorService executor = Executors.newFixedThreadPool(4);

// Prefer ConcurrentHashMap over synchronized HashMap
Map<String, String> map = new ConcurrentHashMap<>();

// Prefer BlockingQueue for producer-consumer
BlockingQueue<String> queue = new ArrayBlockingQueue<>(100);
```

## Detecting Deadlock — Thread Dump

```bash
# Get thread dump (find deadlocked threads)
kill -3 <pid>        # Unix
Ctrl+Break           # Windows console
jstack <pid>         # JDK tool
```

## In Automation (Parallel Testing)

```java
// Deadlock risk in parallel tests sharing WebDriver
// Fix: use ThreadLocal to give each thread its own driver

private static final ThreadLocal<WebDriver> driverPool = new ThreadLocal<>();

public static WebDriver getDriver() {
    if (driverPool.get() == null) {
        driverPool.set(new ChromeDriver());
    }
    return driverPool.get();
}

@AfterMethod
public void teardown() {
    WebDriver driver = driverPool.get();
    if (driver != null) {
        driver.quit();
        driverPool.remove();  // clean up — prevent memory leak
    }
}
```$$,
  'Core Java', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Deadlock', 'Multithreading', 'synchronized', 'ReentrantLock', 'Thread Safety', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Singleton design pattern in Java? Implement it thread-safely.',
  'singleton-design-pattern-java-thread-safe',
  'Singleton ensures only one instance of a class exists. Thread-safe implementations: double-checked locking, enum singleton, or initialization-on-demand holder.',
  $$## Singleton Design Pattern in Java

**Singleton** ensures only **one instance** of a class exists throughout the application and provides a global access point to it.

## Basic Singleton (NOT Thread-Safe)

```java
public class DatabaseConnection {
    private static DatabaseConnection instance;

    private DatabaseConnection() {
        System.out.println("Connecting to database...");
    }

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();  // ⚠️ Not thread-safe
        }
        return instance;
    }
}
```

## Thread-Safe Implementations

### 1. Synchronized Method (simple but slow)
```java
public class DatabaseConnection {
    private static DatabaseConnection instance;

    private DatabaseConnection() {}

    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }
    // Problem: synchronized on every call — performance overhead
}
```

### 2. Double-Checked Locking (Best for most cases)
```java
public class DatabaseConnection {
    // volatile ensures visibility across threads
    private static volatile DatabaseConnection instance;

    private DatabaseConnection() {}

    public static DatabaseConnection getInstance() {
        if (instance == null) {                  // First check (no lock)
            synchronized (DatabaseConnection.class) {
                if (instance == null) {          // Second check (with lock)
                    instance = new DatabaseConnection();
                }
            }
        }
        return instance;
    }
}
```

### 3. Enum Singleton (Simplest + Thread-Safe + Serialization-Safe)
```java
public enum WebDriverManager {
    INSTANCE;

    private WebDriver driver;

    public WebDriver getDriver() {
        if (driver == null) {
            driver = new ChromeDriver();
        }
        return driver;
    }

    public void quitDriver() {
        if (driver != null) {
            driver.quit();
            driver = null;
        }
    }
}

// Usage
WebDriver driver = WebDriverManager.INSTANCE.getDriver();
```

### 4. Initialization-on-Demand Holder (Lazy, Thread-Safe, No sync)
```java
public class ConfigManager {
    private final Properties properties;

    private ConfigManager() {
        properties = new Properties();
        try {
            properties.load(new FileInputStream("config.properties"));
        } catch (IOException e) {
            throw new RuntimeException("Config not found", e);
        }
    }

    // Inner class — loaded only when first accessed
    private static class Holder {
        static final ConfigManager INSTANCE = new ConfigManager();
    }

    public static ConfigManager getInstance() {
        return Holder.INSTANCE;  // thread-safe without synchronized
    }

    public String get(String key) {
        return properties.getProperty(key);
    }
}
```

## Singleton in Automation Frameworks

```java
// WebDriver Singleton — one browser per test class
public class BrowserFactory {
    private static volatile WebDriver driver;

    private BrowserFactory() {}

    public static WebDriver getDriver() {
        if (driver == null) {
            synchronized (BrowserFactory.class) {
                if (driver == null) {
                    WebDriverManager.chromedriver().setup();
                    driver = new ChromeDriver();
                    driver.manage().window().maximize();
                }
            }
        }
        return driver;
    }

    public static void quitDriver() {
        if (driver != null) {
            driver.quit();
            driver = null;
        }
    }
}

// Any test can call
WebDriver driver = BrowserFactory.getDriver();
```

## Breaking Singleton (and Prevention)

```java
// Reflection can break singleton:
Constructor<Singleton> c = Singleton.class.getDeclaredConstructor();
c.setAccessible(true);
Singleton s2 = c.newInstance();  // breaks singleton!

// Prevention — throw exception in constructor if instance exists
private Singleton() {
    if (instance != null) {
        throw new RuntimeException("Use getInstance()");
    }
}
// Or use Enum — reflection-proof
```$$,
  'Core Java', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Singleton', 'Design Pattern', 'Thread-Safe', 'volatile', 'Double-Checked Locking', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Java Generics? Why are they used?',
  'java-generics-explained',
  'Generics enable type-safe collections and methods by specifying the type at compile time, eliminating ClassCastException and reducing boilerplate casting.',
  $$## Java Generics

**Generics** allow you to write **type-safe code** that works with different data types while providing compile-time type checking.

## Why Generics?

```java
// WITHOUT generics — unsafe, requires casting
List list = new ArrayList();
list.add("Hello");
list.add(42);        // no type check!

String s = (String) list.get(1);  // ClassCastException at runtime!

// WITH generics — type-safe
List<String> stringList = new ArrayList<>();
stringList.add("Hello");
// stringList.add(42);  // ❌ Compile error — caught at compile time!
String s = stringList.get(0);  // no cast needed
```

## Generic Class

```java
public class Box<T> {
    private T content;

    public void put(T item) { this.content = item; }
    public T get()          { return content; }
}

Box<String> stringBox = new Box<>();
stringBox.put("Hello");
String s = stringBox.get();   // no cast

Box<Integer> intBox = new Box<>();
intBox.put(42);
Integer n = intBox.get();
```

## Generic Method

```java
public class ArrayUtils {
    // Works with ANY type
    public static <T> void swap(T[] arr, int i, int j) {
        T temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static <T extends Comparable<T>> T max(T a, T b) {
        return a.compareTo(b) > 0 ? a : b;
    }
}

Integer[] nums = {1, 2, 3};
ArrayUtils.swap(nums, 0, 2); // [3, 2, 1]

System.out.println(ArrayUtils.max(10, 20));       // 20
System.out.println(ArrayUtils.max("Apple", "Banana")); // Banana
```

## Bounded Type Parameters

```java
// <T extends Number> — T must be Number or subclass (Integer, Double, Float)
public static <T extends Number> double sum(List<T> list) {
    return list.stream().mapToDouble(Number::doubleValue).sum();
}

List<Integer> ints    = Arrays.asList(1, 2, 3);
List<Double> doubles  = Arrays.asList(1.5, 2.5, 3.5);
System.out.println(sum(ints));    // 6.0
System.out.println(sum(doubles)); // 7.5
```

## Wildcards

```java
// ? — unknown type
// ? extends T — upper bound (T or subclass)
// ? super T — lower bound (T or superclass)

// Read-only — accepts List<Integer>, List<Double>, List<Number>
public static double sumList(List<? extends Number> list) {
    return list.stream().mapToDouble(Number::doubleValue).sum();
}

// Write — accepts List<Integer> or List<Number> or List<Object>
public static void addNumbers(List<? super Integer> list) {
    list.add(1);
    list.add(2);
}
```

## Common Generic Collections

```java
// All Collections use generics
List<String>              names  = new ArrayList<>();
Map<String, Integer>      scores = new HashMap<>();
Set<Long>                 ids    = new HashSet<>();
Queue<Runnable>           tasks  = new LinkedList<>();
Optional<WebDriver>       driver = Optional.empty();
```

## In Automation Frameworks

```java
// Generic utility to wait for any element type
public static <T extends WebElement> T waitForElement(
        WebDriverWait wait, ExpectedCondition<T> condition) {
    return wait.until(condition);
}

// Generic page factory method
public static <T extends BasePage> T initPage(WebDriver driver, Class<T> pageClass) {
    try {
        return pageClass.getConstructor(WebDriver.class).newInstance(driver);
    } catch (Exception e) {
        throw new RuntimeException("Failed to init page: " + pageClass.getName(), e);
    }
}

// Usage
LoginPage loginPage = initPage(driver, LoginPage.class);
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Generics', 'Type Safety', 'Wildcard', 'Collections', 'Core Java', 'Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are method references in Java 8?',
  'method-references-java-8',
  'Method references are shorthand for lambda expressions that call an existing method. Types: static, instance, instance of arbitrary type, and constructor references.',
  $$## Method References in Java 8

A **method reference** is a compact shorthand for a lambda expression that calls an existing method. Uses `::` operator.

## Syntax

```
ClassName::methodName   or   objectName::methodName
```

## 4 Types of Method References

### 1. Static Method Reference — `ClassName::staticMethod`

```java
// Lambda
Function<String, Integer> parseInt = s -> Integer.parseInt(s);

// Method reference — cleaner
Function<String, Integer> parseInt2 = Integer::parseInt;

System.out.println(parseInt2.apply("42")); // 42

// With streams
List<String> numbers = Arrays.asList("1", "2", "3", "4");
List<Integer> ints = numbers.stream()
    .map(Integer::parseInt)   // same as s -> Integer.parseInt(s)
    .collect(Collectors.toList());
```

### 2. Instance Method Reference (specific object) — `object::instanceMethod`

```java
String prefix = "Hello, ";

// Lambda
Function<String, String> greet = name -> prefix.concat(name);

// Method reference (specific object: prefix)
Function<String, String> greet2 = prefix::concat;

System.out.println(greet2.apply("Alice")); // "Hello, Alice"

// Print each element
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
names.forEach(System.out::println); // System.out is the specific object
```

### 3. Instance Method Reference (arbitrary type) — `ClassName::instanceMethod`

```java
// Lambda
Comparator<String> comp = (s1, s2) -> s1.compareToIgnoreCase(s2);

// Method reference — first param is the instance
Comparator<String> comp2 = String::compareToIgnoreCase;

List<String> names = Arrays.asList("Charlie", "alice", "BOB");
names.sort(String::compareToIgnoreCase);
// [alice, BOB, Charlie] — case-insensitive sort

// Getting string length
List<String> words = Arrays.asList("hello", "world", "java");
List<Integer> lengths = words.stream()
    .map(String::length)  // calls .length() on each String
    .collect(Collectors.toList());
// [5, 5, 4]
```

### 4. Constructor Reference — `ClassName::new`

```java
// Lambda
Supplier<ArrayList<String>> listFactory = () -> new ArrayList<>();

// Constructor reference
Supplier<ArrayList<String>> listFactory2 = ArrayList::new;
ArrayList<String> list = listFactory2.get();

// BiFunction constructor
BiFunction<String, Integer, StringBuilder> sbFactory =
    (s, n) -> new StringBuilder(s);

// Convert list of strings to list of objects
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
List<Employee> employees = names.stream()
    .map(Employee::new)  // calls new Employee(String name)
    .collect(Collectors.toList());
```

## Quick Reference

| Lambda | Method Reference |
|--------|-----------------|
| `s -> Integer.parseInt(s)` | `Integer::parseInt` |
| `s -> s.toUpperCase()` | `String::toUpperCase` |
| `() -> new ArrayList<>()` | `ArrayList::new` |
| `s -> System.out.println(s)` | `System.out::println` |
| `(a, b) -> a.compareTo(b)` | `String::compareTo` |

## In Automation Testing

```java
List<WebElement> buttons = driver.findElements(By.tagName("button"));

// Get text of all buttons
List<String> buttonTexts = buttons.stream()
    .map(WebElement::getText)         // method reference
    .collect(Collectors.toList());

// Filter only displayed buttons
List<WebElement> visibleButtons = buttons.stream()
    .filter(WebElement::isDisplayed)  // method reference
    .collect(Collectors.toList());

// Click each button
visibleButtons.forEach(WebElement::click);

// Sort by text
buttonTexts.sort(String::compareTo);
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Method References', 'Java 8', 'Lambda', 'Functional Interface', 'Core Java', '::'], true, 0
);

-- ══════════════════════════════════════
-- SCENARIO-BASED QUESTIONS
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you reverse a String in Java without using StringBuilder.reverse()?',
  'reverse-string-java-without-reverse-method',
  'Reverse a String using a for loop from the end, char array, recursion, or Stack. Common coding interview question for Java developers.',
  $$## Reverse a String Without StringBuilder.reverse()

### Method 1: Using for loop (Most Common Answer)

```java
public static String reverseString(String str) {
    if (str == null || str.length() <= 1) return str;

    String reversed = "";
    for (int i = str.length() - 1; i >= 0; i--) {
        reversed += str.charAt(i);
    }
    return reversed;
}

System.out.println(reverseString("Hello")); // "olleH"
System.out.println(reverseString("AutomateQA")); // "AQetatotuA"
```

### Method 2: Using char array (Optimal)

```java
public static String reverseWithCharArray(String str) {
    char[] chars = str.toCharArray();
    int left = 0, right = chars.length - 1;

    while (left < right) {
        char temp  = chars[left];
        chars[left] = chars[right];
        chars[right] = temp;
        left++;
        right--;
    }
    return new String(chars);
}

System.out.println(reverseWithCharArray("Selenium")); // "muineleS"
```

### Method 3: Using StringBuilder (fastest but using StringBuilder manually)

```java
public static String reverseWithSB(String str) {
    StringBuilder sb = new StringBuilder();
    for (int i = str.length() - 1; i >= 0; i--) {
        sb.append(str.charAt(i));
    }
    return sb.toString();
}
```

### Method 4: Using Recursion

```java
public static String reverseRecursive(String str) {
    if (str.length() == 0) return str;
    return reverseRecursive(str.substring(1)) + str.charAt(0);
}

System.out.println(reverseRecursive("Java")); // "avaJ"
```

### Method 5: Using Stack

```java
public static String reverseWithStack(String str) {
    Stack<Character> stack = new Stack<>();
    for (char c : str.toCharArray()) {
        stack.push(c);
    }
    StringBuilder result = new StringBuilder();
    while (!stack.isEmpty()) {
        result.append(stack.pop());
    }
    return result.toString();
}
```

### Method 6: Using Java 8 Streams

```java
public static String reverseWithStream(String str) {
    return str.chars()
              .mapToObj(c -> String.valueOf((char) c))
              .reduce("", (a, b) -> b + a);
}
```

### Test with JUnit

```java
@Test
public void testReverseString() {
    assertEquals("olleH",     reverseString("Hello"));
    assertEquals("",          reverseString(""));
    assertEquals("a",         reverseString("a"));
    assertEquals("321",       reverseString("123"));
    assertEquals("muineleS",  reverseString("Selenium"));
    assertNull(reverseString(null));
}
```

### Edge Cases to Handle

- `null` input
- Empty string `""`
- Single character `"a"`
- Palindrome `"madam"` → `"madam"`
- String with spaces `"hello world"` → `"dlrow olleh"`$$,
  'Core Java', 'Coding', 'Fresher', 'Beginner',
  ARRAY['String', 'Reverse', 'Coding', 'Core Java', 'Interview Program', 'for loop'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you find duplicate elements in a List in Java?',
  'find-duplicate-elements-list-java',
  'Use HashSet to find duplicates: if add() returns false, the element is a duplicate. Alternatively use frequency(), streams, or HashMap for counts.',
  $$## Find Duplicate Elements in a List

### Method 1: Using HashSet (Most Efficient — O(n))

```java
public static List<String> findDuplicates(List<String> list) {
    Set<String> seen = new HashSet<>();
    List<String> duplicates = new ArrayList<>();

    for (String item : list) {
        if (!seen.add(item)) {  // add() returns false if already exists
            if (!duplicates.contains(item)) {  // avoid adding duplicate twice
                duplicates.add(item);
            }
        }
    }
    return duplicates;
}

List<String> input = Arrays.asList("Alice", "Bob", "Alice", "Charlie", "Bob", "Dave");
System.out.println(findDuplicates(input));  // [Alice, Bob]
```

### Method 2: Using HashMap (Get Count of Each Element)

```java
public static Map<String, Integer> getDuplicatesWithCount(List<String> list) {
    Map<String, Integer> countMap = new HashMap<>();

    // Count occurrences
    for (String item : list) {
        countMap.put(item, countMap.getOrDefault(item, 0) + 1);
    }

    // Filter entries with count > 1
    Map<String, Integer> duplicates = new LinkedHashMap<>();
    for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
        if (entry.getValue() > 1) {
            duplicates.put(entry.getKey(), entry.getValue());
        }
    }
    return duplicates;
}

Map<String, Integer> result = getDuplicatesWithCount(input);
// {Alice=2, Bob=2}
result.forEach((k, v) -> System.out.println(k + " appears " + v + " times"));
```

### Method 3: Using Java 8 Streams

```java
public static List<String> findDuplicatesWithStream(List<String> list) {
    Set<String> seen = new HashSet<>();
    return list.stream()
               .filter(item -> !seen.add(item))
               .distinct()
               .collect(Collectors.toList());
}

// Get count map with streams
Map<String, Long> frequencyMap = list.stream()
    .collect(Collectors.groupingBy(s -> s, Collectors.counting()));

// Only duplicates (count > 1)
frequencyMap.entrySet().stream()
    .filter(e -> e.getValue() > 1)
    .forEach(e -> System.out.println(e.getKey() + ": " + e.getValue()));
```

### Method 4: Using Collections.frequency()

```java
public static List<String> findDuplicatesFrequency(List<String> list) {
    List<String> duplicates = new ArrayList<>();
    for (String item : list) {
        if (Collections.frequency(list, item) > 1 && !duplicates.contains(item)) {
            duplicates.add(item);
        }
    }
    return duplicates;
}
// Note: O(n²) — less efficient than HashSet approach
```

### Remove Duplicates (Bonus)

```java
// Keep only unique elements — insertion order preserved
List<String> unique = new ArrayList<>(new LinkedHashSet<>(input));
System.out.println(unique); // [Alice, Bob, Charlie, Dave]
```

### With Integers

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 2, 4, 3, 5, 1);

// Find duplicates
Set<Integer> seen = new HashSet<>();
Set<Integer> duplicates = new LinkedHashSet<>();
for (int n : numbers) {
    if (!seen.add(n)) duplicates.add(n);
}
System.out.println(duplicates); // [2, 3, 1]
```

### In Automation Testing

```java
// Find duplicate options in a dropdown
List<String> options = driver.findElements(By.tagName("option"))
                             .stream()
                             .map(WebElement::getText)
                             .collect(Collectors.toList());

Set<String> seen = new HashSet<>();
List<String> duplicates = options.stream()
    .filter(o -> !seen.add(o))
    .collect(Collectors.toList());

assertTrue(duplicates.isEmpty(), "Dropdown has duplicate options: " + duplicates);
```$$,
  'Core Java', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Duplicates', 'HashSet', 'Collections', 'Coding', 'Core Java', 'Stream API', 'Interview Program'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you sort a list of custom objects in Java?',
  'sort-list-custom-objects-java',
  'Sort custom objects using Collections.sort() with Comparable (natural order) or Comparator (custom order). Java 8: use list.sort() with lambda.',
  $$## Sort List of Custom Objects in Java

### Define the Employee class

```java
public class Employee {
    private String name;
    private int age;
    private double salary;
    private String department;

    public Employee(String name, int age, double salary, String department) {
        this.name       = name;
        this.age        = age;
        this.salary     = salary;
        this.department = department;
    }

    // Getters
    public String getName()       { return name; }
    public int getAge()           { return age; }
    public double getSalary()     { return salary; }
    public String getDepartment() { return department; }

    @Override
    public String toString() {
        return name + "(" + age + ", $" + salary + ", " + department + ")";
    }
}
```

### Method 1: Comparable — Natural Order (single criterion)

```java
// Make Employee implement Comparable to define natural ordering
public class Employee implements Comparable<Employee> {
    // ... fields and getters ...

    @Override
    public int compareTo(Employee other) {
        return this.name.compareTo(other.name); // natural order = by name
    }
}

List<Employee> employees = Arrays.asList(
    new Employee("Charlie", 30, 75000, "QA"),
    new Employee("Alice",   25, 90000, "Dev"),
    new Employee("Bob",     28, 80000, "QA")
);

Collections.sort(employees);  // uses compareTo
employees.forEach(System.out::println);
// Alice(25, $90000.0, Dev)
// Bob(28, $80000.0, QA)
// Charlie(30, $75000.0, QA)
```

### Method 2: Comparator — Custom Order (multiple criteria)

```java
// Sort by salary ascending
employees.sort(Comparator.comparingDouble(Employee::getSalary));

// Sort by salary descending
employees.sort(Comparator.comparingDouble(Employee::getSalary).reversed());

// Sort by age ascending
employees.sort(Comparator.comparingInt(Employee::getAge));

// Sort by department, then by name within department
employees.sort(
    Comparator.comparing(Employee::getDepartment)
              .thenComparing(Employee::getName)
);

// Sort by salary descending, then age ascending
employees.sort(
    Comparator.comparingDouble(Employee::getSalary).reversed()
              .thenComparingInt(Employee::getAge)
);
```

### Method 3: Lambda Comparator (Inline)

```java
// Sort alphabetically by name
employees.sort((e1, e2) -> e1.getName().compareTo(e2.getName()));

// Sort by salary descending (manual)
employees.sort((e1, e2) -> Double.compare(e2.getSalary(), e1.getSalary()));
```

### Method 4: Java 8 Stream Sorted

```java
// Returns NEW sorted list — doesn''t modify original
List<Employee> byName = employees.stream()
    .sorted(Comparator.comparing(Employee::getName))
    .collect(Collectors.toList());

// Find top 3 highest paid
List<Employee> top3 = employees.stream()
    .sorted(Comparator.comparingDouble(Employee::getSalary).reversed())
    .limit(3)
    .collect(Collectors.toList());
```

### In Automation Testing

```java
// Sort test data before comparison
List<String> actualProducts = getProductNamesFromUI();
List<String> expectedProducts = Arrays.asList("Laptop", "Mouse", "Keyboard");

Collections.sort(actualProducts);
Collections.sort(expectedProducts);
assertEquals(expectedProducts, actualProducts, "Product list mismatch");

// Verify dropdown is sorted
List<String> dropdownOptions = getDropdownOptions();
List<String> sortedExpected = new ArrayList<>(dropdownOptions);
Collections.sort(sortedExpected);
assertEquals(sortedExpected, dropdownOptions, "Dropdown not sorted alphabetically");
```$$,
  'Core Java', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Sorting', 'Comparator', 'Comparable', 'Collections', 'Core Java', 'Java 8', 'Interview Program'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you find the second largest number in an array in Java?',
  'second-largest-number-array-java',
  'Find second largest by sorting (descending) and taking index 1, or using a single pass with two variables tracking largest and second largest.',
  $$## Second Largest Number in an Array

### Method 1: Single Pass — Optimal O(n)

```java
public static int secondLargest(int[] arr) {
    if (arr == null || arr.length < 2) {
        throw new IllegalArgumentException("Array must have at least 2 elements");
    }

    int largest       = Integer.MIN_VALUE;
    int secondLargest = Integer.MIN_VALUE;

    for (int num : arr) {
        if (num > largest) {
            secondLargest = largest;  // old largest becomes second
            largest       = num;       // new largest
        } else if (num > secondLargest && num != largest) {
            secondLargest = num;       // update second largest
        }
    }

    if (secondLargest == Integer.MIN_VALUE) {
        throw new RuntimeException("No distinct second largest element");
    }
    return secondLargest;
}

int[] arr = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
System.out.println(secondLargest(arr));  // 6
```

### Method 2: Sorting (Simple but O(n log n))

```java
public static int secondLargestBySorting(int[] arr) {
    int[] sorted = Arrays.copyOf(arr, arr.length);
    Arrays.sort(sorted);  // ascending

    // Find second distinct from end
    int largest = sorted[sorted.length - 1];
    for (int i = sorted.length - 2; i >= 0; i--) {
        if (sorted[i] != largest) {
            return sorted[i];
        }
    }
    throw new RuntimeException("All elements are equal");
}
```

### Method 3: Using TreeSet (removes duplicates + sorted)

```java
public static int secondLargestWithSet(int[] arr) {
    TreeSet<Integer> set = new TreeSet<>();
    for (int n : arr) set.add(n);  // automatically sorted, no duplicates

    set.pollLast();  // remove largest
    return set.last();  // new last = second largest
}
```

### Method 4: Java 8 Streams

```java
public static OptionalInt secondLargestStream(int[] arr) {
    return Arrays.stream(arr)
                 .distinct()           // remove duplicates
                 .sorted()             // ascending
                 .toArray()            // to array
                 [arr.length - 2];     // second from end

// Better approach:
    return Arrays.stream(arr)
                 .boxed()
                 .distinct()
                 .sorted(Comparator.reverseOrder())
                 .skip(1)       // skip largest
                 .findFirst()
                 .orElseThrow();
}
```

### Complete Solution with Tests

```java
public class SecondLargestTest {

    @Test
    public void testBasic() {
        assertEquals(6, secondLargest(new int[]{3, 1, 4, 1, 5, 9, 2, 6}));
    }

    @Test
    public void testWithDuplicates() {
        assertEquals(5, secondLargest(new int[]{5, 5, 3, 9, 9}));
    }

    @Test
    public void testTwoElements() {
        assertEquals(1, secondLargest(new int[]{5, 1}));
    }

    @Test
    public void testNegativeNumbers() {
        assertEquals(-3, secondLargest(new int[]{-1, -3, -5, -2}));
    }

    @Test(expectedExceptions = IllegalArgumentException.class)
    public void testTooSmallArray() {
        secondLargest(new int[]{5});
    }
}
```

### Variation: Second Smallest

```java
public static int secondSmallest(int[] arr) {
    int smallest = Integer.MAX_VALUE, second = Integer.MAX_VALUE;
    for (int n : arr) {
        if (n < smallest) { second = smallest; smallest = n; }
        else if (n < second && n != smallest) { second = n; }
    }
    return second;
}
```$$,
  'Core Java', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Arrays', 'Second Largest', 'Coding', 'Core Java', 'Interview Program', 'Algorithm'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you check if a string is a palindrome in Java?',
  'check-palindrome-string-java',
  'A palindrome reads the same forwards and backwards. Check by comparing characters from both ends or by reversing the string and comparing with original.',
  $$## Check if String is Palindrome

A **palindrome** reads the same forwards and backwards: "madam", "racecar", "level".

### Method 1: Two-Pointer Approach (Optimal)

```java
public static boolean isPalindrome(String str) {
    if (str == null) return false;

    str = str.toLowerCase().replaceAll("[^a-z0-9]", "");  // ignore case + spaces

    int left = 0, right = str.length() - 1;
    while (left < right) {
        if (str.charAt(left) != str.charAt(right)) {
            return false;
        }
        left++;
        right--;
    }
    return true;
}

System.out.println(isPalindrome("madam"));          // true
System.out.println(isPalindrome("racecar"));        // true
System.out.println(isPalindrome("A man a plan a canal Panama")); // true (ignores spaces)
System.out.println(isPalindrome("Hello"));          // false
```

### Method 2: Using StringBuilder.reverse()

```java
public static boolean isPalindromeReverse(String str) {
    if (str == null) return false;
    String clean = str.toLowerCase().replaceAll("\\s+", "");
    return clean.equals(new StringBuilder(clean).reverse().toString());
}
```

### Method 3: Recursive

```java
public static boolean isPalindromeRecursive(String str) {
    if (str.length() <= 1) return true;
    if (str.charAt(0) != str.charAt(str.length() - 1)) return false;
    return isPalindromeRecursive(str.substring(1, str.length() - 1));
}
```

### Method 4: Check Palindrome Number

```java
public static boolean isPalindromeNumber(int num) {
    if (num < 0) return false;
    String s = String.valueOf(num);
    return s.equals(new StringBuilder(s).reverse().toString());
}

System.out.println(isPalindromeNumber(121));   // true
System.out.println(isPalindromeNumber(1221));  // true
System.out.println(isPalindromeNumber(123));   // false
```

### Comprehensive Test Cases

```java
@Test
public void testPalindrome() {
    // True cases
    assertTrue(isPalindrome("madam"));
    assertTrue(isPalindrome("racecar"));
    assertTrue(isPalindrome("level"));
    assertTrue(isPalindrome("A"));
    assertTrue(isPalindrome(""));

    // False cases
    assertFalse(isPalindrome("hello"));
    assertFalse(isPalindrome("java"));
    assertFalse(isPalindrome("selenium"));

    // Edge cases
    assertFalse(isPalindrome(null));
    assertTrue(isPalindrome("Madam"));  // case-insensitive
    assertTrue(isPalindrome("A man a plan a canal Panama"));  // with spaces
}
```

### Find All Palindromes in a List

```java
List<String> words = Arrays.asList("madam", "hello", "racecar", "java", "level");

List<String> palindromes = words.stream()
    .filter(w -> isPalindrome(w))
    .collect(Collectors.toList());

System.out.println(palindromes); // [madam, racecar, level]
```$$,
  'Core Java', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Palindrome', 'String', 'Coding', 'Core Java', 'Two Pointer', 'Interview Program'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you iterate a HashMap in Java? Explain all methods.',
  'iterate-hashmap-java-all-methods',
  'Iterate HashMap using entrySet() (key+value), keySet() (keys only), values() (values only), or Java 8 forEach(). entrySet() is most efficient.',
  $$## Iterating a HashMap in Java

### Sample Data

```java
Map<String, Integer> scores = new HashMap<>();
scores.put("Alice",   95);
scores.put("Bob",     87);
scores.put("Charlie", 92);
scores.put("Diana",   88);
```

### Method 1: entrySet() — Most Common and Efficient

```java
// Access both key and value in each iteration
for (Map.Entry<String, Integer> entry : scores.entrySet()) {
    System.out.println(entry.getKey() + " → " + entry.getValue());
}
// Alice → 95
// Bob → 87
// Charlie → 92
```

### Method 2: keySet() — When You Only Need Keys

```java
for (String name : scores.keySet()) {
    System.out.println("Key: " + name);
    // To get value: scores.get(name)  — extra lookup
}
```

### Method 3: values() — When You Only Need Values

```java
for (int score : scores.values()) {
    System.out.println("Score: " + score);
}

// Sum all values
int total = scores.values().stream().mapToInt(Integer::intValue).sum();
System.out.println("Total: " + total); // 362
```

### Method 4: Java 8 forEach with Lambda (Most Readable)

```java
scores.forEach((name, score) ->
    System.out.println(name + " scored " + score));

// With condition
scores.forEach((name, score) -> {
    if (score >= 90) {
        System.out.println(name + " gets A grade");
    }
});
```

### Method 5: Iterator (When You Need to Remove During Iteration)

```java
Iterator<Map.Entry<String, Integer>> iterator = scores.entrySet().iterator();
while (iterator.hasNext()) {
    Map.Entry<String, Integer> entry = iterator.next();
    if (entry.getValue() < 90) {
        iterator.remove();  // ✅ Safe removal during iteration
        // scores.remove(entry.getKey()); // ❌ ConcurrentModificationException!
    }
}
System.out.println(scores); // Only Alice and Charlie remain
```

### Method 6: Java 8 Streams

```java
// Filter and collect
Map<String, Integer> highScorers = scores.entrySet().stream()
    .filter(e -> e.getValue() >= 90)
    .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
System.out.println(highScorers); // {Alice=95, Charlie=92}

// Sort by value
scores.entrySet().stream()
    .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
    .forEach(e -> System.out.println(e.getKey() + ": " + e.getValue()));
// Alice: 95, Charlie: 92, Diana: 88, Bob: 87
```

### Performance Comparison

| Method | Use When |
|--------|---------|
| `entrySet()` | Need both key and value (most common) |
| `keySet()` | Only need keys |
| `values()` | Only need values |
| `forEach` | Cleaner code, Java 8+ |
| `Iterator` | Need to remove elements safely |
| `streams` | Complex filtering/transformation |

### In Automation Testing

```java
// Verify test configuration from map
Map<String, String> testConfig = loadConfig();
testConfig.forEach((key, value) ->
    System.out.println("Config: " + key + " = " + value));

// Check all required config keys are present
Map<String, String> required = new LinkedHashMap<>();
required.put("browser", "chrome");
required.put("baseUrl", "https://qa.example.com");
required.put("timeout", "30");

required.forEach((key, defaultVal) -> {
    String actual = testConfig.getOrDefault(key, defaultVal);
    System.out.println("Using " + key + ": " + actual);
});
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['HashMap', 'Iteration', 'entrySet', 'forEach', 'Collections', 'Core Java', 'Java 8'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'Given a list of employees, how do you find the highest paid using Java 8 Streams?',
  'find-highest-paid-employee-java-8-streams',
  'Use stream().max(Comparator.comparingDouble(Employee::getSalary)) or sorted().findFirst() to find the highest paid employee using Java 8 Streams.',
  $$## Find Highest Paid Employee Using Java 8 Streams

### Employee Class

```java
public class Employee {
    private String name;
    private String department;
    private double salary;
    private String role;
    private int yearsOfExp;

    public Employee(String name, String department, double salary, String role, int exp) {
        this.name = name; this.department = department;
        this.salary = salary; this.role = role; this.yearsOfExp = exp;
    }
    // Getters omitted for brevity
}
```

### Test Data

```java
List<Employee> employees = Arrays.asList(
    new Employee("Alice",   "QA",      95000, "SDET",    5),
    new Employee("Bob",     "Dev",     120000, "Engineer", 8),
    new Employee("Charlie", "QA",      85000, "SDET",    3),
    new Employee("Diana",   "Dev",     135000, "Lead",    10),
    new Employee("Eve",     "QA",      110000, "Manager", 7),
    new Employee("Frank",   "Dev",     90000, "Engineer", 4)
);
```

### Find Highest Paid Overall

```java
// Using max() — most efficient
Optional<Employee> highestPaid = employees.stream()
    .max(Comparator.comparingDouble(Employee::getSalary));

highestPaid.ifPresent(e ->
    System.out.println("Highest paid: " + e.getName() + " - $" + e.getSalary()));
// "Highest paid: Diana - $135000.0"
```

### Find Highest Paid per Department

```java
// Group by department, find max salary in each
Map<String, Optional<Employee>> highestPerDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.maxBy(Comparator.comparingDouble(Employee::getSalary))
    ));

highestPerDept.forEach((dept, emp) ->
    emp.ifPresent(e -> System.out.println(dept + ": " + e.getName() + " $" + e.getSalary())));
// Dev: Diana $135000.0
// QA: Eve $110000.0
```

### Top 3 Highest Paid

```java
List<Employee> top3 = employees.stream()
    .sorted(Comparator.comparingDouble(Employee::getSalary).reversed())
    .limit(3)
    .collect(Collectors.toList());

top3.forEach(e -> System.out.println(e.getName() + ": $" + e.getSalary()));
// Diana: $135000.0, Bob: $120000.0, Eve: $110000.0
```

### Average Salary per Department

```java
Map<String, Double> avgByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.averagingDouble(Employee::getSalary)
    ));

avgByDept.forEach((dept, avg) ->
    System.out.printf("%s avg: $%.0f%n", dept, avg));
// Dev avg: $115000, QA avg: $96667
```

### Employees Earning Above Average

```java
double avg = employees.stream()
    .mapToDouble(Employee::getSalary)
    .average()
    .orElse(0);

List<Employee> aboveAvg = employees.stream()
    .filter(e -> e.getSalary() > avg)
    .sorted(Comparator.comparingDouble(Employee::getSalary).reversed())
    .collect(Collectors.toList());

System.out.println("Average: $" + avg);
aboveAvg.forEach(e -> System.out.println(e.getName() + ": $" + e.getSalary()));
```

### Count per Department

```java
Map<String, Long> countByDept = employees.stream()
    .collect(Collectors.groupingBy(Employee::getDepartment, Collectors.counting()));
// {QA=3, Dev=3}
```

### Salary Statistics

```java
DoubleSummaryStatistics stats = employees.stream()
    .mapToDouble(Employee::getSalary)
    .summaryStatistics();

System.out.println("Max: $"   + stats.getMax());
System.out.println("Min: $"   + stats.getMin());
System.out.println("Avg: $"   + stats.getAverage());
System.out.println("Sum: $"   + stats.getSum());
System.out.println("Count: "  + stats.getCount());
```$$,
  'Core Java', 'Coding', '1-2 Years', 'Intermediate',
  ARRAY['Stream API', 'Java 8', 'Collectors', 'groupingBy', 'Employee', 'Core Java', 'Interview Program'], true, 0
);
