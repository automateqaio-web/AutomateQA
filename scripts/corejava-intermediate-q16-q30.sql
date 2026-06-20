-- Core Java Intermediate Q16–Q30 | Paste into Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Java Collections Framework? Explain the key interfaces and classes.',
  'java-collections-framework-key-interfaces',
  'The Collections Framework provides ready-made data structures. Key interfaces: List, Set, Map, Queue. Key classes: ArrayList, HashMap, HashSet, LinkedList.',
  $$## Java Collections Framework

The **Collections Framework** is a unified architecture for storing and manipulating groups of objects. It provides interfaces, implementations, and algorithms.

## Hierarchy

```
Collection (root interface)
├── List (ordered, duplicates allowed)
│   ├── ArrayList
│   ├── LinkedList
│   └── Vector (legacy, synchronized)
├── Set (no duplicates)
│   ├── HashSet (no order)
│   ├── LinkedHashSet (insertion order)
│   └── TreeSet (sorted order)
└── Queue (FIFO)
    ├── LinkedList
    ├── PriorityQueue
    └── ArrayDeque

Map (key-value pairs — NOT part of Collection)
├── HashMap (no order)
├── LinkedHashMap (insertion order)
├── TreeMap (sorted by key)
└── Hashtable (legacy, synchronized)
```

## List — Ordered, Duplicates Allowed

```java
List<String> list = new ArrayList<>();
list.add("Apple");
list.add("Banana");
list.add("Apple");       // duplicates OK
System.out.println(list.get(0));   // "Apple" — index access
System.out.println(list.size());   // 3
list.remove(0);                    // remove by index
Collections.sort(list);            // sort in-place
```

## Set — No Duplicates

```java
Set<String> set = new HashSet<>();
set.add("Red");
set.add("Green");
set.add("Red");   // duplicate — ignored
System.out.println(set.size()); // 2 — not 3

// LinkedHashSet maintains insertion order
Set<String> ordered = new LinkedHashSet<>();

// TreeSet sorts alphabetically
Set<String> sorted = new TreeSet<>();
```

## Map — Key-Value Pairs

```java
Map<String, Integer> scores = new HashMap<>();
scores.put("Alice", 95);
scores.put("Bob", 87);
scores.put("Alice", 98);  // overwrites previous value for "Alice"

System.out.println(scores.get("Alice")); // 98
System.out.println(scores.containsKey("Bob")); // true
System.out.println(scores.getOrDefault("Charlie", 0)); // 0

// Iterate
for (Map.Entry<String, Integer> entry : scores.entrySet()) {
    System.out.println(entry.getKey() + " → " + entry.getValue());
}
```

## Queue — FIFO

```java
Queue<String> queue = new LinkedList<>();
queue.offer("First");
queue.offer("Second");
queue.offer("Third");

System.out.println(queue.poll());  // "First" — removes and returns head
System.out.println(queue.peek());  // "Second" — returns without removing
```

## Choosing the Right Collection

| Need | Use |
|------|-----|
| Ordered list with duplicates + index access | `ArrayList` |
| Frequent insert/delete at beginning | `LinkedList` |
| No duplicates | `HashSet` |
| No duplicates + sorted | `TreeSet` |
| Key-value lookup | `HashMap` |
| Key-value + sorted keys | `TreeMap` |
| Thread-safe map | `ConcurrentHashMap` |$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Collections', 'ArrayList', 'HashMap', 'HashSet', 'List', 'Set', 'Map', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between HashMap and HashTable in Java?',
  'hashmap-vs-hashtable-java',
  'HashMap is non-synchronized and allows null keys/values; Hashtable is synchronized (thread-safe) but slower and does not allow nulls. Use ConcurrentHashMap instead of Hashtable.',
  $$## HashMap vs Hashtable in Java

## HashMap

Introduced in **Java 1.2**. Part of the Collections Framework. **Not thread-safe** but fast.

```java
HashMap<String, String> map = new HashMap<>();

// Allows ONE null key and multiple null values
map.put(null, "null key value");
map.put("key1", null);
map.put("key2", "value2");

System.out.println(map.get(null));   // "null key value"
System.out.println(map.get("key1")); // null

// Fast — no synchronization overhead
map.put("user", "Alice");
map.put("role", "SDET");
System.out.println(map.size()); // 4
```

## Hashtable

Introduced in **Java 1.0** (legacy). All methods are **synchronized** — thread-safe but slow.

```java
Hashtable<String, String> table = new Hashtable<>();

// Does NOT allow null key or null value
// table.put(null, "value");  // ❌ NullPointerException
// table.put("key", null);    // ❌ NullPointerException

table.put("key1", "value1");
table.put("key2", "value2");

// Thread-safe but slow — synchronization on every method
```

## Comparison Table

| Feature | HashMap | Hashtable |
|---------|---------|-----------|
| **Thread-safe** | ❌ No | ✅ Yes (synchronized) |
| **Null key** | ✅ One null key | ❌ Not allowed |
| **Null values** | ✅ Multiple | ❌ Not allowed |
| **Performance** | Fast | Slow (sync overhead) |
| **Iterator** | Fail-fast | Fail-safe (Enumerator) |
| **Introduced** | Java 1.2 | Java 1.0 |
| **Recommended?** | ✅ Yes | ❌ Use ConcurrentHashMap |

## Better Alternatives for Thread Safety

```java
// Modern thread-safe HashMap
Map<String, String> safeMap = new ConcurrentHashMap<>();
safeMap.put("key", "value");  // thread-safe, better performance than Hashtable

// Synchronized wrapper (less preferred)
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());
```

## Common HashMap Operations

```java
Map<String, Integer> wordCount = new HashMap<>();

// putIfAbsent — only adds if key doesn't exist
wordCount.putIfAbsent("hello", 0);

// compute — update value
wordCount.compute("hello", (k, v) -> v == null ? 1 : v + 1);

// getOrDefault — safe get with fallback
int count = wordCount.getOrDefault("world", 0);

// forEach — Java 8+
wordCount.forEach((word, cnt) ->
    System.out.println(word + ": " + cnt));

// merge — combine values
wordCount.merge("hello", 1, Integer::sum);
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['HashMap', 'Hashtable', 'ConcurrentHashMap', 'Collections', 'Thread-Safe', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between ArrayList and LinkedList in Java?',
  'arraylist-vs-linkedlist-java',
  'ArrayList uses dynamic array (fast random access, slow insert/delete in middle); LinkedList uses doubly-linked list (fast insert/delete, slow random access).',
  $$## ArrayList vs LinkedList

Both implement the `List` interface but have different internal structures and performance characteristics.

## Internal Structure

**ArrayList** — backed by a **dynamic array**:
```
Index:  [0]      [1]      [2]      [3]
Data:  "Alice" "Bob"  "Charlie" "Dave"
       ↑ contiguous memory — O(1) access by index
```

**LinkedList** — backed by a **doubly-linked list**:
```
null ← [Alice|→] ↔ [Bob|→] ↔ [Charlie|→] ↔ [Dave|→] → null
       Each node has: data + prev pointer + next pointer
```

## Performance Comparison

| Operation | ArrayList | LinkedList | Why |
|-----------|-----------|------------|-----|
| **get(i)** | O(1) ✅ fast | O(n) ❌ slow | Array index vs traverse list |
| **add at end** | O(1) amortized | O(1) | Append to array / tail pointer |
| **add at index** | O(n) ❌ slow | O(n) ❌ slow | Shift elements / traverse then add |
| **remove at index** | O(n) ❌ slow | O(n)* | Shift elements / pointer update |
| **Memory** | Less (array) | More (pointers) | No pointers vs prev+next pointers |
| **Iterator add/remove** | O(n) | O(1) ✅ | With ListIterator |

## Code Examples

```java
// ArrayList — use when you read frequently by index
List<String> arrayList = new ArrayList<>();
arrayList.add("Alice");
arrayList.add("Bob");
arrayList.add("Charlie");

String name = arrayList.get(1);  // O(1) — instant
System.out.println(name);        // "Bob"

// LinkedList — use when you insert/delete frequently
LinkedList<String> linkedList = new LinkedList<>();
linkedList.add("Alice");
linkedList.addFirst("Zero");    // O(1) — add to front
linkedList.addLast("Dave");     // O(1) — add to back
linkedList.removeFirst();       // O(1) — remove front
linkedList.pollLast();          // O(1) — remove & return last

// LinkedList also implements Deque (double-ended queue)
Deque<String> deque = new LinkedList<>();
deque.push("item1");  // push to front
deque.pop();          // remove from front
```

## When to Use

| Scenario | Choose |
|---------|--------|
| Frequent random access by index | `ArrayList` |
| Frequent search/iteration | `ArrayList` |
| Frequent insert/delete at beginning | `LinkedList` |
| Need to use as Queue or Deque | `LinkedList` |
| Memory is critical | `ArrayList` |
| Default choice | `ArrayList` (most common) |

## In Automation Testing

```java
// ArrayList — storing and accessing test results by index
List<String> testResults = new ArrayList<>();
testResults.add("PASS");
testResults.add("FAIL");
testResults.add("SKIP");
System.out.println(testResults.get(0)); // "PASS"

// LinkedList — processing test steps as queue (FIFO)
Queue<String> testSteps = new LinkedList<>();
testSteps.offer("Open Browser");
testSteps.offer("Navigate to URL");
testSteps.offer("Login");
testSteps.offer("Verify Dashboard");

while (!testSteps.isEmpty()) {
    System.out.println("Executing: " + testSteps.poll());
}
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['ArrayList', 'LinkedList', 'Collections', 'Performance', 'Core Java', 'Data Structures'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are Java 8 Lambda Expressions and how do you use them?',
  'java-8-lambda-expressions-explained',
  'Lambda expressions are anonymous functions that enable functional programming. They simplify code by removing boilerplate anonymous class syntax.',
  $$## Java 8 Lambda Expressions

A **lambda expression** is a concise way to represent an **anonymous function** (a method without a name). It enables functional programming in Java.

## Syntax

```java
// Traditional anonymous class
Runnable r = new Runnable() {
    @Override
    public void run() {
        System.out.println("Running");
    }
};

// Lambda equivalent — much cleaner
Runnable r = () -> System.out.println("Running");
```

**Lambda Syntax:**
```
(parameters) -> expression
(parameters) -> { statements; }
```

## Examples

### No Parameters
```java
Runnable r = () -> System.out.println("Hello Lambda!");
r.run();
```

### Single Parameter (parentheses optional)
```java
Consumer<String> print = name -> System.out.println("Hello, " + name);
print.accept("Alice");
```

### Multiple Parameters
```java
Comparator<Integer> compare = (a, b) -> a - b;
System.out.println(compare.compare(3, 7)); // -4 (3 < 7)
```

### With Return
```java
Function<Integer, Integer> square = n -> n * n;
System.out.println(square.apply(5)); // 25

// Multi-line — needs {} and return
Function<Integer, String> grade = score -> {
    if (score >= 90) return "A";
    if (score >= 80) return "B";
    return "C";
};
```

## With Collections

```java
List<String> names = Arrays.asList("Charlie", "Alice", "Bob", "Dave");

// Sort with lambda
names.sort((a, b) -> a.compareTo(b));
// or even simpler
names.sort(String::compareTo); // method reference

// forEach with lambda
names.forEach(name -> System.out.println(name));
// or method reference
names.forEach(System.out::println);

// removeIf
names.removeIf(name -> name.startsWith("A"));
```

## Common Functional Interfaces

| Interface | Method | Description |
|-----------|--------|-------------|
| `Runnable` | `run()` | No input, no output |
| `Supplier<T>` | `get()` | No input, returns T |
| `Consumer<T>` | `accept(T)` | Takes T, no return |
| `Function<T,R>` | `apply(T)` | Takes T, returns R |
| `Predicate<T>` | `test(T)` | Takes T, returns boolean |
| `BiFunction<T,U,R>` | `apply(T,U)` | Takes two inputs |

```java
Predicate<String> isEmpty = s -> s.isEmpty();
Predicate<Integer> isEven = n -> n % 2 == 0;

System.out.println(isEmpty.test(""));    // true
System.out.println(isEven.test(4));      // true

// Combine predicates
Predicate<Integer> isPositiveEven = isEven.and(n -> n > 0);
System.out.println(isPositiveEven.test(6));  // true
System.out.println(isPositiveEven.test(-6)); // false
```

## In Automation Testing

```java
// Sort test data
List<String> testUsers = Arrays.asList("admin", "user1", "guest", "moderator");
testUsers.sort((a, b) -> a.length() - b.length()); // sort by length

// Filter elements — find visible dropdowns
List<WebElement> dropdowns = driver.findElements(By.tagName("select"));
List<WebElement> visible = dropdowns.stream()
    .filter(el -> el.isDisplayed())
    .collect(Collectors.toList());

// Execute test step with timeout
Supplier<Boolean> condition = () -> driver.findElement(By.id("result")).isDisplayed();
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Lambda', 'Java 8', 'Functional Interface', 'Core Java', 'Streams', 'Anonymous Function'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Stream API in Java 8? Explain with examples.',
  'java-8-stream-api-explained',
  'Stream API processes collections in a functional style using intermediate operations (filter, map, sorted) and terminal operations (collect, forEach, count).',
  $$## Java 8 Stream API

A **Stream** is a sequence of elements that can be processed in a functional, declarative way. Streams do NOT store data — they process elements from a source (Collection, Array, etc.).

## Creating Streams

```java
// From Collection
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
Stream<String> stream1 = names.stream();

// From Array
int[] arr = {1, 2, 3, 4, 5};
IntStream stream2 = Arrays.stream(arr);

// From values
Stream<String> stream3 = Stream.of("X", "Y", "Z");

// Infinite stream
Stream<Integer> infinite = Stream.iterate(0, n -> n + 2); // 0, 2, 4, 6...
```

## Intermediate Operations (return a new Stream — lazy)

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "Anna", "David");

// filter — keep elements matching condition
List<String> aNames = names.stream()
    .filter(n -> n.startsWith("A"))
    .collect(Collectors.toList());
// ["Alice", "Anna"]

// map — transform each element
List<Integer> lengths = names.stream()
    .map(String::length)
    .collect(Collectors.toList());
// [5, 3, 7, 4, 5]

// sorted — sort elements
List<String> sorted = names.stream()
    .sorted()
    .collect(Collectors.toList());
// ["Alice", "Anna", "Bob", "Charlie", "David"]

// distinct — remove duplicates
List<Integer> unique = Arrays.asList(1, 2, 2, 3, 3, 3).stream()
    .distinct()
    .collect(Collectors.toList());
// [1, 2, 3]

// limit / skip
names.stream().limit(3)  // first 3
names.stream().skip(2)   // skip first 2
```

## Terminal Operations (trigger execution)

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// collect — gather into collection
List<Integer> evens = numbers.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());
// [2, 4, 6, 8, 10]

// count
long count = numbers.stream().filter(n -> n > 5).count(); // 5

// findFirst / findAny
Optional<Integer> first = numbers.stream()
    .filter(n -> n > 3)
    .findFirst();
first.ifPresent(System.out::println); // 4

// min / max
Optional<Integer> max = numbers.stream().max(Integer::compareTo); // 10

// reduce — combine all elements
int sum = numbers.stream().reduce(0, Integer::sum); // 55

// forEach
numbers.stream().filter(n -> n % 2 == 0).forEach(System.out::println);

// anyMatch / allMatch / noneMatch
boolean anyEven   = numbers.stream().anyMatch(n -> n % 2 == 0);  // true
boolean allPositive = numbers.stream().allMatch(n -> n > 0);      // true
boolean noneNeg   = numbers.stream().noneMatch(n -> n < 0);       // true
```

## Real Example — Employee Processing

```java
List<Employee> employees = getEmployees();

// Find all senior SDETs earning > 80k, sorted by salary descending
List<Employee> topSDETs = employees.stream()
    .filter(e -> e.getRole().equals("SDET"))
    .filter(e -> e.getSalary() > 80000)
    .sorted(Comparator.comparingDouble(Employee::getSalary).reversed())
    .limit(5)
    .collect(Collectors.toList());

// Group by department
Map<String, List<Employee>> byDept = employees.stream()
    .collect(Collectors.groupingBy(Employee::getDepartment));

// Average salary
OptionalDouble avgSalary = employees.stream()
    .mapToDouble(Employee::getSalary)
    .average();
```

## In Automation Testing

```java
// Get all visible text from a list of elements
List<String> menuItems = driver.findElements(By.cssSelector(".nav-item"))
    .stream()
    .filter(WebElement::isDisplayed)
    .map(WebElement::getText)
    .collect(Collectors.toList());

// Check if expected option exists in dropdown
boolean hasOption = driver.findElements(By.tagName("option"))
    .stream()
    .map(WebElement::getText)
    .anyMatch(text -> text.equals("New York"));
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Stream API', 'Java 8', 'filter', 'map', 'collect', 'Lambda', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between Comparable and Comparator in Java?',
  'comparable-vs-comparator-java',
  'Comparable defines natural ordering within the class (compareTo); Comparator defines external custom ordering (compare). Use Comparator for multiple sort criteria.',
  $$## Comparable vs Comparator in Java

Both are used for **sorting objects**, but they differ in where and how they define sorting logic.

## Comparable — Natural Ordering (built into the class)

Implements `java.lang.Comparable<T>`. The class itself defines how its objects are ordered.

```java
public class Employee implements Comparable<Employee> {
    private String name;
    private double salary;

    public Employee(String name, double salary) {
        this.name   = name;
        this.salary = salary;
    }

    // Natural order = sort by salary ascending
    @Override
    public int compareTo(Employee other) {
        return Double.compare(this.salary, other.salary);
    }

    // Getters...
}

List<Employee> employees = new ArrayList<>();
employees.add(new Employee("Bob", 75000));
employees.add(new Employee("Alice", 95000));
employees.add(new Employee("Charlie", 60000));

Collections.sort(employees);  // uses compareTo automatically
// Result: Charlie(60k), Bob(75k), Alice(95k) — sorted by salary ascending
```

## Comparator — External Custom Ordering

Implements `java.util.Comparator<T>`. Defined outside the class — multiple comparators possible.

```java
// Sort by name
Comparator<Employee> byName = Comparator.comparing(Employee::getName);

// Sort by salary descending
Comparator<Employee> bySalaryDesc = Comparator
    .comparingDouble(Employee::getSalary)
    .reversed();

// Sort by salary, then by name (chained)
Comparator<Employee> bySalaryThenName = Comparator
    .comparingDouble(Employee::getSalary)
    .thenComparing(Employee::getName);

// Use with sort
employees.sort(byName);
employees.sort(bySalaryDesc);
employees.sort(bySalaryThenName);

// Inline lambda comparator
employees.sort((e1, e2) -> e1.getName().compareTo(e2.getName()));
```

## compareTo / compare Return Values

| Return | Meaning |
|--------|---------|
| Negative (`< 0`) | this / first object comes BEFORE |
| Zero (`0`) | Objects are equal |
| Positive (`> 0`) | this / first object comes AFTER |

## Comparison Table

| Feature | Comparable | Comparator |
|---------|-----------|-----------|
| Package | `java.lang` | `java.util` |
| Method | `compareTo(T)` | `compare(T, T)` |
| Modifies class | ✅ Yes (implement in class) | ❌ No (external) |
| Multiple orderings | ❌ One only | ✅ Multiple |
| Lambda-friendly | No | ✅ Yes |
| `Collections.sort()` | ✅ No comparator needed | ✅ Pass comparator |

## When to Use

- **Comparable:** One natural ordering that makes sense for the class (e.g., `String` sorts alphabetically, `Integer` numerically)
- **Comparator:** Multiple sort criteria, sorting third-party classes, complex comparisons

## In Automation Testing

```java
// Sort test data alphabetically by username
List<TestUser> users = getTestUsers();
users.sort(Comparator.comparing(TestUser::getUsername));

// Verify dropdown is sorted
List<String> options = getDropdownOptions();
List<String> expected = new ArrayList<>(options);
Collections.sort(expected); // natural alphabetical order
assertEquals(expected, options, "Dropdown is not sorted alphabetically");

// Sort test results by execution time
testResults.sort(Comparator.comparingLong(TestResult::getDurationMs));
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Comparable', 'Comparator', 'Sorting', 'Collections', 'Core Java', 'Java 8'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is multithreading in Java? How do you create threads?',
  'multithreading-java-create-threads',
  'Multithreading allows multiple threads to run concurrently. Create threads by extending Thread class, implementing Runnable, or using ExecutorService.',
  $$## Multithreading in Java

**Multithreading** allows a program to run multiple threads (lightweight processes) concurrently, enabling parallel execution and better CPU utilization.

## Thread Lifecycle

```
NEW → RUNNABLE → RUNNING → BLOCKED/WAITING → DEAD
```

## Method 1: Extending Thread class

```java
class MyThread extends Thread {
    private String threadName;

    MyThread(String name) {
        this.threadName = name;
    }

    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(threadName + " - Count: " + i);
            try { Thread.sleep(500); } catch (InterruptedException e) {}
        }
    }
}

// Create and start threads
MyThread t1 = new MyThread("Thread-1");
MyThread t2 = new MyThread("Thread-2");
t1.start();  // starts a new thread — calls run() in new thread
t2.start();
```

## Method 2: Implementing Runnable (Preferred)

```java
class MyTask implements Runnable {
    private String taskName;

    MyTask(String name) { this.taskName = name; }

    @Override
    public void run() {
        System.out.println(taskName + " executing on: " + Thread.currentThread().getName());
    }
}

Thread t1 = new Thread(new MyTask("Login Test"));
Thread t2 = new Thread(new MyTask("Search Test"));
t1.start();
t2.start();

// With Lambda (Java 8+)
Thread t3 = new Thread(() -> System.out.println("Lambda thread"));
t3.start();
```

## Method 3: ExecutorService (Modern, Preferred for Pools)

```java
import java.util.concurrent.*;

// Fixed thread pool — reuses 3 threads
ExecutorService executor = Executors.newFixedThreadPool(3);

// Submit tasks
executor.submit(() -> System.out.println("Task 1 running"));
executor.submit(() -> System.out.println("Task 2 running"));
executor.submit(() -> {
    System.out.println("Task 3 running");
    return "result";
});

executor.shutdown();  // no new tasks, finish existing
executor.awaitTermination(30, TimeUnit.SECONDS);
```

## Thread Methods

```java
Thread t = new Thread(() -> {
    System.out.println("Running: " + Thread.currentThread().getName());
});

t.setName("MyThread");
t.setPriority(Thread.MAX_PRIORITY); // 1-10, default 5
t.setDaemon(true);   // daemon thread — dies when main thread dies
t.start();
t.join();            // wait for this thread to finish
t.interrupt();       // request interruption
Thread.sleep(1000);  // current thread sleeps 1 second
Thread.currentThread().getName(); // get current thread name
```

## Synchronization — Thread Safety

```java
class Counter {
    private int count = 0;

    // synchronized — only one thread can execute this at a time
    public synchronized void increment() {
        count++;
    }

    public int getCount() { return count; }
}

Counter counter = new Counter();
Thread t1 = new Thread(() -> { for (int i=0; i<1000; i++) counter.increment(); });
Thread t2 = new Thread(() -> { for (int i=0; i<1000; i++) counter.increment(); });
t1.start(); t2.start();
t1.join();  t2.join();
System.out.println(counter.getCount()); // 2000 — correct with sync
```

## In Parallel Test Execution (TestNG)

```java
// TestNG runs tests in parallel across browsers using multithreading
// ThreadLocal ensures each thread has its own WebDriver instance
ThreadLocal<WebDriver> driverThreadLocal = new ThreadLocal<>();

public WebDriver getDriver() {
    return driverThreadLocal.get();
}

@BeforeMethod
public void setup() {
    driverThreadLocal.set(new ChromeDriver());
}

@AfterMethod
public void teardown() {
    getDriver().quit();
    driverThreadLocal.remove();
}
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Multithreading', 'Thread', 'Runnable', 'ExecutorService', 'Synchronization', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the Optional class in Java 8 and how does it help?',
  'optional-class-java-8',
  'Optional is a container that may or may not hold a value. It eliminates NullPointerException by forcing explicit null handling.',
  $$## Optional Class in Java 8

`Optional<T>` is a **container object** that may or may not contain a non-null value. It is designed to **eliminate NullPointerException** by making null-handling explicit.

## Creating Optional

```java
// Empty Optional
Optional<String> empty = Optional.empty();

// Optional with value (throws NPE if value is null)
Optional<String> name = Optional.of("Alice");

// Optional that allows null (use this when value might be null)
Optional<String> nullable = Optional.ofNullable(getUserName());
```

## Checking and Getting Value

```java
Optional<String> opt = Optional.ofNullable(getEmail());

// isPresent / isEmpty
if (opt.isPresent()) {
    System.out.println(opt.get()); // "alice@example.com"
}

// ifPresent — run action only if value exists
opt.ifPresent(email -> System.out.println("Sending to: " + email));

// orElse — default value if empty
String email = opt.orElse("default@example.com");

// orElseGet — use supplier for lazy default
String email2 = opt.orElseGet(() -> generateDefaultEmail());

// orElseThrow — throw exception if empty
String email3 = opt.orElseThrow(() -> new RuntimeException("Email not found"));
```

## Transforming with map and flatMap

```java
Optional<String> upperEmail = Optional.ofNullable(getEmail())
    .map(String::toUpperCase)
    .filter(e -> e.contains("@"));

System.out.println(upperEmail.orElse("N/A"));

// Chained Optional — avoids nested null checks
// Before Optional (nested null checks):
String city = null;
if (user != null && user.getAddress() != null) {
    city = user.getAddress().getCity();
}

// With Optional:
String city = Optional.ofNullable(user)
    .map(User::getAddress)
    .map(Address::getCity)
    .orElse("Unknown");
```

## Real-World Example

```java
// Without Optional — multiple null checks
public String getUserCity(int userId) {
    User user = userRepository.findById(userId);
    if (user == null) return "Unknown";
    Address address = user.getAddress();
    if (address == null) return "Unknown";
    return address.getCity() != null ? address.getCity() : "Unknown";
}

// With Optional — clean pipeline
public String getUserCity(int userId) {
    return userRepository.findOptionalById(userId)   // returns Optional<User>
        .map(User::getAddress)
        .map(Address::getCity)
        .orElse("Unknown");
}
```

## In Automation Testing

```java
// Safe element lookup — return Optional instead of null
public Optional<WebElement> findOptional(By locator) {
    List<WebElement> elements = driver.findElements(locator);
    return elements.isEmpty() ? Optional.empty() : Optional.of(elements.get(0));
}

// Usage
findOptional(By.id("success-message"))
    .map(WebElement::getText)
    .ifPresent(msg -> assertTrue(msg.contains("Success")));

// Cookie retrieval
Optional.ofNullable(driver.manage().getCookieNamed("session_id"))
    .map(Cookie::getValue)
    .ifPresent(token -> setAuthToken(token));
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Optional', 'Java 8', 'NullPointerException', 'Null Safety', 'Core Java', 'Functional'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are checked and unchecked exceptions in Java?',
  'checked-vs-unchecked-exceptions-java',
  'Checked exceptions (IOException, SQLException) must be handled at compile time. Unchecked exceptions (RuntimeException) occur at runtime and are optional to handle.',
  $$## Checked vs Unchecked Exceptions

## Checked Exceptions

Must be **handled at compile time** — either with `try-catch` or declared with `throws`. The compiler enforces this. Extend `Exception` (but not `RuntimeException`).

```java
// Reading a file — checked exception
public void readFile(String path) throws IOException {
    FileReader reader = new FileReader(path); // FileNotFoundException (checked)
    reader.read();                            // IOException (checked)
    reader.close();
}

// Caller must handle it
try {
    readFile("data.txt");
} catch (IOException e) {
    System.out.println("File error: " + e.getMessage());
}
```

**Common Checked Exceptions:**
- `IOException` — file operations
- `FileNotFoundException` — file not found
- `SQLException` — database errors
- `ClassNotFoundException` — class loading
- `InterruptedException` — thread interrupted

## Unchecked Exceptions (RuntimeException)

**NOT enforced by compiler** — can choose to handle or not. Usually indicate programming bugs. Extend `RuntimeException`.

```java
// These don't require try-catch (but will crash at runtime if not handled)
String s = null;
s.length();           // NullPointerException (unchecked)

int[] arr = new int[3];
arr[10] = 5;          // ArrayIndexOutOfBoundsException (unchecked)

int result = 10 / 0; // ArithmeticException (unchecked)

String num = "abc";
int n = Integer.parseInt(num); // NumberFormatException (unchecked)

Object obj = "hello";
Integer i = (Integer) obj;    // ClassCastException (unchecked)
```

**Common Unchecked Exceptions:**
- `NullPointerException` — null reference
- `ArrayIndexOutOfBoundsException` — invalid array index
- `ClassCastException` — invalid type cast
- `NumberFormatException` — invalid string to number
- `ArithmeticException` — divide by zero
- `StackOverflowError` — infinite recursion
- `IllegalArgumentException` — invalid argument
- `IllegalStateException` — invalid state

## Creating Custom Exceptions

```java
// Custom checked exception
public class DatabaseConnectionException extends Exception {
    public DatabaseConnectionException(String message) {
        super(message);
    }
    public DatabaseConnectionException(String message, Throwable cause) {
        super(message, cause);
    }
}

// Custom unchecked exception
public class InvalidPageStateException extends RuntimeException {
    public InvalidPageStateException(String page) {
        super("Page not in expected state: " + page);
    }
}

// Usage
public void connectToDb() throws DatabaseConnectionException {
    try {
        // DB connection attempt
    } catch (SQLException e) {
        throw new DatabaseConnectionException("Failed to connect", e);
    }
}
```

## Exception Hierarchy

```
Throwable
├── Error (don't catch — JVM issues)
│   ├── OutOfMemoryError
│   └── StackOverflowError
└── Exception
    ├── CHECKED (must handle)
    │   ├── IOException
    │   ├── SQLException
    │   └── ClassNotFoundException
    └── RuntimeException (UNCHECKED — optional)
        ├── NullPointerException
        ├── IllegalArgumentException
        └── ArrayIndexOutOfBoundsException
```

## Best Practices

```java
// ✅ Catch specific exceptions, not generic Exception
try {
    connectToDb();
} catch (DatabaseConnectionException e) {
    log.error("DB error", e);
} catch (IOException e) {
    log.error("IO error", e);
}

// ❌ Avoid swallowing exceptions silently
try { ... } catch (Exception e) { }  // BAD — hides errors

// ✅ Always log or rethrow
try { ... } catch (Exception e) {
    log.error("Unexpected error", e);
    throw new RuntimeException("Operation failed", e);
}
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Checked Exception', 'Unchecked Exception', 'RuntimeException', 'Exception Handling', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the this and super keyword in Java?',
  'this-and-super-keyword-java',
  'this refers to the current object instance; super refers to the parent class. Both are used to access members and call constructors.',
  $$## this and super Keywords in Java

## this — Current Object Reference

Refers to the **current class instance**. Used to distinguish instance variables from local variables, call other constructors, and pass current object as argument.

### 1. Distinguish instance vs local variable
```java
public class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;  // this.name = instance variable
        this.age  = age;   // age (right side) = parameter
    }
}
```

### 2. Call another constructor — this()
```java
public class Car {
    String brand;
    String color;
    int speed;

    public Car() {
        this("Toyota", "White", 0); // calls 3-arg constructor
    }

    public Car(String brand) {
        this(brand, "Black", 0);    // calls 3-arg constructor
    }

    public Car(String brand, String color, int speed) {
        this.brand = brand;
        this.color = color;
        this.speed = speed;
    }
}
```

### 3. Pass current object to method
```java
public class Builder {
    private String name;

    public Builder setName(String name) {
        this.name = name;
        return this;  // return current object — enables method chaining
    }

    public Builder setAge(int age) { return this; }
    public User build() { return new User(this); }
}

// Method chaining
User user = new Builder()
    .setName("Alice")
    .setAge(30)
    .build();
```

---

## super — Parent Class Reference

Refers to the **immediate parent class**. Used to access parent fields, methods, and constructors.

### 1. Call parent constructor — super()
```java
class Animal {
    String name;
    Animal(String name) {
        this.name = name;
        System.out.println("Animal created: " + name);
    }
}

class Dog extends Animal {
    String breed;

    Dog(String name, String breed) {
        super(name);       // MUST be first statement — calls Animal()
        this.breed = breed;
        System.out.println("Dog created: " + breed);
    }
}
```

### 2. Access overridden parent method
```java
class Shape {
    public void draw() {
        System.out.println("Drawing a shape");
    }
}

class Circle extends Shape {
    @Override
    public void draw() {
        super.draw();                  // calls Shape.draw() first
        System.out.println("Drawing a circle");
    }
}
```

### 3. Access parent field (when hidden by child)
```java
class Parent {
    int x = 10;
}

class Child extends Parent {
    int x = 20;  // hides parent x

    void display() {
        System.out.println(x);       // 20 — child's x
        System.out.println(super.x); // 10 — parent's x
    }
}
```

## In Automation (Page Object Model)

```java
public class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage(WebDriver driver) {
        this.driver = driver;        // this = current BasePage instance
        this.wait   = new WebDriverWait(driver, Duration.ofSeconds(10));
        PageFactory.initElements(driver, this);  // pass this object
    }

    public void waitForElement(By locator) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }
}

public class LoginPage extends BasePage {
    @FindBy(id = "username") WebElement usernameField;
    @FindBy(id = "password") WebElement passwordField;

    public LoginPage(WebDriver driver) {
        super(driver);  // super = BasePage constructor
    }

    public void login(String user, String pass) {
        super.waitForElement(By.id("username")); // parent method
        usernameField.sendKeys(user);
        passwordField.sendKeys(pass);
    }
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['this', 'super', 'Constructor', 'Core Java', 'OOP', 'Inheritance'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is a functional interface in Java 8? Explain with examples.',
  'functional-interface-java-8',
  'A functional interface has exactly one abstract method. It is the target type for lambda expressions. @FunctionalInterface annotation verifies this.',
  $$## Functional Interface in Java 8

A **functional interface** is an interface with **exactly ONE abstract method**. It is the foundation of lambda expressions in Java 8.

```java
@FunctionalInterface  // optional but recommended — compiler enforces 1 method
public interface Greeting {
    void greet(String name);  // single abstract method
    // void anotherMethod();  // ❌ would make it non-functional
}

// Lambda implements the interface
Greeting g = name -> System.out.println("Hello, " + name + "!");
g.greet("Alice");  // "Hello, Alice!"
```

## Built-in Functional Interfaces (java.util.function)

### Predicate<T> — takes T, returns boolean
```java
Predicate<String> isLong  = s -> s.length() > 5;
Predicate<Integer> isEven = n -> n % 2 == 0;

System.out.println(isLong.test("Hello"));   // false
System.out.println(isLong.test("Welcome")); // true

// Combine predicates
Predicate<Integer> isPositiveEven = isEven.and(n -> n > 0);
Predicate<String> isLongOrEmpty = isLong.or(String::isEmpty);
Predicate<Integer> isOdd = isEven.negate();
```

### Function<T, R> — takes T, returns R
```java
Function<String, Integer> strLen = String::length;
Function<Integer, String> intToStr = n -> "Number: " + n;

System.out.println(strLen.apply("Hello"));  // 5
System.out.println(intToStr.apply(42));     // "Number: 42"

// Chain functions
Function<String, String> upper = String::toUpperCase;
Function<String, String> exclaim = s -> s + "!";
Function<String, String> shout = upper.andThen(exclaim);
System.out.println(shout.apply("hello")); // "HELLO!"
```

### Consumer<T> — takes T, returns nothing
```java
Consumer<String> print   = System.out::println;
Consumer<String> logInfo = msg -> System.out.println("[INFO] " + msg);

print.accept("Test passed");
logInfo.accept("Login successful");

// andThen — chain consumers
Consumer<String> printAndLog = print.andThen(logInfo);
printAndLog.accept("Hello"); // prints then logs
```

### Supplier<T> — no input, returns T
```java
Supplier<String> greeting   = () -> "Good morning!";
Supplier<Double> randomNum  = Math::random;
Supplier<List<String>> newList = ArrayList::new;

System.out.println(greeting.get());   // "Good morning!"
System.out.println(randomNum.get());  // 0.7823...
```

### BiFunction<T, U, R> — takes two inputs, returns R
```java
BiFunction<String, Integer, String> repeat = (s, n) -> s.repeat(n);
System.out.println(repeat.apply("Ha", 3)); // "HaHaHa"
```

## Custom Functional Interface

```java
@FunctionalInterface
public interface TriFunction<A, B, C, R> {
    R apply(A a, B b, C c);
}

TriFunction<Integer, Integer, Integer, Integer> sum = (a, b, c) -> a + b + c;
System.out.println(sum.apply(1, 2, 3)); // 6
```

## In Automation Testing

```java
// Define custom functional interface for wait conditions
@FunctionalInterface
interface PageCondition {
    boolean isMet(WebDriver driver);
}

public void waitFor(PageCondition condition) {
    new FluentWait<>(driver)
        .withTimeout(Duration.ofSeconds(10))
        .pollingEvery(Duration.ofMillis(500))
        .until(condition::isMet);
}

// Usage
waitFor(driver -> driver.findElement(By.id("result")).isDisplayed());
waitFor(driver -> driver.getTitle().equals("Dashboard"));
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Functional Interface', 'Java 8', 'Predicate', 'Function', 'Consumer', 'Supplier', 'Lambda', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between HashMap, LinkedHashMap, and TreeMap in Java?',
  'hashmap-linkedhashmap-treemap-difference',
  'HashMap has no ordering; LinkedHashMap maintains insertion order; TreeMap sorts keys in natural or custom order. All implement Map interface.',
  $$## HashMap vs LinkedHashMap vs TreeMap

All implement the `Map` interface but differ in **ordering and performance**.

## HashMap — No Order Guaranteed

```java
Map<String, Integer> hashMap = new HashMap<>();
hashMap.put("Banana", 2);
hashMap.put("Apple", 1);
hashMap.put("Cherry", 3);
hashMap.put("Date", 4);

// Iteration order is NOT predictable
hashMap.forEach((k, v) -> System.out.println(k + "=" + v));
// Could print in any order: Cherry=3, Date=4, Apple=1, Banana=2
```

**Performance:** O(1) average for get/put.

## LinkedHashMap — Insertion Order

```java
Map<String, Integer> linkedMap = new LinkedHashMap<>();
linkedMap.put("Banana", 2);
linkedMap.put("Apple", 1);
linkedMap.put("Cherry", 3);
linkedMap.put("Date", 4);

// Always prints in insertion order
linkedMap.forEach((k, v) -> System.out.println(k + "=" + v));
// Banana=2, Apple=1, Cherry=3, Date=4
```

**Also supports access-order (LRU cache):**
```java
// true = access-order (most-recently-accessed last)
Map<String, Integer> lruCache = new LinkedHashMap<>(16, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry<String, Integer> eldest) {
        return size() > 3;  // max 3 entries — evict oldest
    }
};
```

## TreeMap — Sorted by Key

```java
Map<String, Integer> treeMap = new TreeMap<>();
treeMap.put("Banana", 2);
treeMap.put("Apple", 1);
treeMap.put("Cherry", 3);
treeMap.put("Date", 4);

// Always prints in natural (alphabetical) key order
treeMap.forEach((k, v) -> System.out.println(k + "=" + v));
// Apple=1, Banana=2, Cherry=3, Date=4

// Extra methods
System.out.println(treeMap.firstKey()); // "Apple"
System.out.println(treeMap.lastKey());  // "Date"
System.out.println(treeMap.headMap("Cherry")); // {Apple=1, Banana=2}
System.out.println(treeMap.tailMap("Cherry")); // {Cherry=3, Date=4}
```

**Custom key order:**
```java
Map<String, Integer> reverseMap = new TreeMap<>(Comparator.reverseOrder());
reverseMap.put("Banana", 2);
reverseMap.put("Apple", 1);
// Date=4, Cherry=3, Banana=2, Apple=1
```

## Comparison Table

| Feature | HashMap | LinkedHashMap | TreeMap |
|---------|---------|---------------|---------|
| **Order** | None | Insertion order | Sorted (key) |
| **Null key** | ✅ 1 null | ✅ 1 null | ❌ No null key |
| **Performance** | O(1) | O(1) | O(log n) |
| **Thread-safe** | ❌ | ❌ | ❌ |
| **Implements** | Map | Map | NavigableMap |
| **Use when** | Just key-value | Need insertion order | Need sorted keys |

## In Automation Testing

```java
// HashMap — store test data (order doesn't matter)
Map<String, String> testData = new HashMap<>();
testData.put("username", "alice");
testData.put("password", "pass123");

// LinkedHashMap — maintain form field order for ordered input
Map<String, String> formData = new LinkedHashMap<>();
formData.put("firstName", "John");
formData.put("lastName", "Doe");
formData.put("email", "john@example.com");
// Fill form fields in order
formData.forEach((field, value) ->
    driver.findElement(By.name(field)).sendKeys(value));

// TreeMap — sorted test parameter names for reports
Map<String, String> sortedParams = new TreeMap<>(testParameters);
sortedParams.forEach((k, v) -> report.addParameter(k, v));
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['HashMap', 'LinkedHashMap', 'TreeMap', 'Map', 'Collections', 'Core Java'], true, 0
);
