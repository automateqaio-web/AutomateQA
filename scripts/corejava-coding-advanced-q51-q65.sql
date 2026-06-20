-- Core Java Coding + Advanced Topics Q51–Q65 | Paste into Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'Write a Java program to print Fibonacci series and find factorial of a number.',
  'fibonacci-factorial-java-program',
  'Fibonacci: each number = sum of previous two (0,1,1,2,3,5...). Factorial: n! = n × (n-1) × ... × 1. Both implemented iteratively and recursively.',
  $$## Fibonacci Series in Java

**Fibonacci**: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34 ...
Each number = sum of previous two.

### Fibonacci — Iterative (Best for interviews)

```java
public static void printFibonacci(int n) {
    int a = 0, b = 1;
    System.out.print("Fibonacci: ");
    for (int i = 0; i < n; i++) {
        System.out.print(a + " ");
        int next = a + b;
        a = b;
        b = next;
    }
}

printFibonacci(10);  // 0 1 1 2 3 5 8 13 21 34
```

### Fibonacci — Recursive

```java
public static int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Print series
for (int i = 0; i < 10; i++) {
    System.out.print(fibonacci(i) + " ");
}
// 0 1 1 2 3 5 8 13 21 34
```

### Fibonacci — Using Stream (Java 8)

```java
// Generate infinite stream of fibonacci numbers
Stream.iterate(new int[]{0, 1}, f -> new int[]{f[1], f[0] + f[1]})
      .limit(10)
      .map(f -> f[0])
      .forEach(n -> System.out.print(n + " "));
// 0 1 1 2 3 5 8 13 21 34
```

### Fibonacci — Memoized (Dynamic Programming)

```java
Map<Integer, Long> memo = new HashMap<>();

public static long fibMemo(int n) {
    if (n <= 1) return n;
    if (memo.containsKey(n)) return memo.get(n);
    long result = fibMemo(n - 1) + fibMemo(n - 2);
    memo.put(n, result);
    return result;
}

System.out.println(fibMemo(50)); // 12586269025 — fast, no stack overflow
```

---

## Factorial in Java

**Factorial**: n! = n × (n-1) × ... × 2 × 1
5! = 5 × 4 × 3 × 2 × 1 = 120

### Factorial — Iterative

```java
public static long factorial(int n) {
    if (n < 0) throw new IllegalArgumentException("n must be >= 0");
    if (n == 0 || n == 1) return 1;
    long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

System.out.println(factorial(5));   // 120
System.out.println(factorial(10));  // 3628800
System.out.println(factorial(0));   // 1 (by convention)
```

### Factorial — Recursive

```java
public static long factorialRecursive(int n) {
    if (n < 0) throw new IllegalArgumentException("n must be >= 0");
    if (n == 0 || n == 1) return 1;
    return n * factorialRecursive(n - 1);
}
```

### Factorial — Java 8 Stream

```java
// Using reduce
public static long factorialStream(int n) {
    return LongStream.rangeClosed(1, n)
                     .reduce(1L, (a, b) -> a * b);
}

System.out.println(factorialStream(5));  // 120
```

### Test Cases

```java
@Test
public void testFactorial() {
    assertEquals(1,        factorial(0));
    assertEquals(1,        factorial(1));
    assertEquals(2,        factorial(2));
    assertEquals(6,        factorial(3));
    assertEquals(120,      factorial(5));
    assertEquals(3628800,  factorial(10));
}
```$$,
  'Core Java', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Fibonacci', 'Factorial', 'Recursion', 'Coding', 'Core Java', 'Interview Program', 'Stream API'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you check if two strings are anagrams in Java?',
  'check-anagram-strings-java',
  'Two strings are anagrams if they have the same characters in the same frequency. Sort both strings and compare, or use a character frequency array.',
  $$## Check if Two Strings are Anagrams

**Anagram**: Two strings that contain the same characters in the same frequency.
"listen" and "silent" → Anagrams
"hello" and "world" → Not Anagrams

### Method 1: Sort and Compare (Simplest)

```java
public static boolean isAnagram(String str1, String str2) {
    if (str1 == null || str2 == null) return false;
    if (str1.length() != str2.length()) return false;

    char[] arr1 = str1.toLowerCase().toCharArray();
    char[] arr2 = str2.toLowerCase().toCharArray();

    Arrays.sort(arr1);
    Arrays.sort(arr2);

    return Arrays.equals(arr1, arr2);
}

System.out.println(isAnagram("listen", "silent")); // true
System.out.println(isAnagram("triangle", "integral")); // true
System.out.println(isAnagram("hello", "world"));   // false
```

### Method 2: Character Frequency Array (Optimal O(n))

```java
public static boolean isAnagramFrequency(String str1, String str2) {
    if (str1.length() != str2.length()) return false;

    int[] count = new int[26];  // for lowercase a-z

    for (char c : str1.toLowerCase().toCharArray()) {
        count[c - 'a']++;  // increment for str1
    }
    for (char c : str2.toLowerCase().toCharArray()) {
        count[c - 'a']--;  // decrement for str2
    }

    // If anagram — all counts should be 0
    for (int c : count) {
        if (c != 0) return false;
    }
    return true;
}
```

### Method 3: HashMap (Handles Unicode/spaces)

```java
public static boolean isAnagramMap(String str1, String str2) {
    str1 = str1.toLowerCase().replaceAll("\\s", "");
    str2 = str2.toLowerCase().replaceAll("\\s", "");

    if (str1.length() != str2.length()) return false;

    Map<Character, Integer> freq = new HashMap<>();

    for (char c : str1.toCharArray()) {
        freq.put(c, freq.getOrDefault(c, 0) + 1);
    }
    for (char c : str2.toCharArray()) {
        if (!freq.containsKey(c)) return false;
        freq.put(c, freq.get(c) - 1);
        if (freq.get(c) == 0) freq.remove(c);
    }

    return freq.isEmpty();
}
```

### Method 4: Java 8 Streams

```java
public static boolean isAnagramStream(String str1, String str2) {
    if (str1.length() != str2.length()) return false;

    Map<Integer, Long> freq1 = str1.toLowerCase().chars()
        .boxed()
        .collect(Collectors.groupingBy(c -> c, Collectors.counting()));

    Map<Integer, Long> freq2 = str2.toLowerCase().chars()
        .boxed()
        .collect(Collectors.groupingBy(c -> c, Collectors.counting()));

    return freq1.equals(freq2);
}
```

### Test Cases

```java
@Test
public void testAnagram() {
    // Anagrams
    assertTrue(isAnagram("listen",   "silent"));
    assertTrue(isAnagram("triangle", "integral"));
    assertTrue(isAnagram("Astronomer", "Moon starer"));  // with spaces
    assertTrue(isAnagram("abc",      "bca"));
    assertTrue(isAnagram("DEBIT CARD", "BAD CREDIT"));

    // Not anagrams
    assertFalse(isAnagram("hello",   "world"));
    assertFalse(isAnagram("rat",     "car"));

    // Edge cases
    assertFalse(isAnagram("abc",     "ab"));   // different lengths
    assertFalse(isAnagram(null,      "abc"));
    assertTrue(isAnagram("",        ""));
}
```$$,
  'Core Java', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Anagram', 'String', 'HashMap', 'Coding', 'Core Java', 'Interview Program', 'Character Frequency'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'Write a Java program to count the frequency of each character in a String.',
  'count-character-frequency-string-java',
  'Count character frequency using a HashMap where each character is a key and its count is the value. Java 8: use Collectors.groupingBy().',
  $$## Count Character Frequency in a String

### Method 1: Using HashMap (Most Common)

```java
public static Map<Character, Integer> charFrequency(String str) {
    Map<Character, Integer> freq = new LinkedHashMap<>();  // preserves insertion order

    for (char c : str.toCharArray()) {
        freq.put(c, freq.getOrDefault(c, 0) + 1);
    }
    return freq;
}

Map<Character, Integer> result = charFrequency("programming");
result.forEach((c, count) ->
    System.out.println("'" + c + "' → " + count));
// 'p' → 1, 'r' → 2, 'o' → 1, 'g' → 2, 'a' → 1, 'm' → 2, 'i' → 1, 'n' → 1
```

### Method 2: Sort Characters (Simpler Output)

```java
public static void printFrequencySorted(String str) {
    char[] chars = str.toCharArray();
    Arrays.sort(chars);

    int i = 0;
    while (i < chars.length) {
        int count = 1;
        while (i + count < chars.length && chars[i + count] == chars[i]) {
            count++;
        }
        System.out.println("'" + chars[i] + "' : " + count);
        i += count;
    }
}
```

### Method 3: Java 8 Streams

```java
public static Map<Character, Long> charFrequencyStream(String str) {
    return str.chars()
              .mapToObj(c -> (char) c)
              .collect(Collectors.groupingBy(c -> c, Collectors.counting()));
}

// Sort by frequency descending
str.chars()
   .mapToObj(c -> (char) c)
   .collect(Collectors.groupingBy(c -> c, Collectors.counting()))
   .entrySet().stream()
   .sorted(Map.Entry.<Character, Long>comparingByValue().reversed())
   .forEach(e -> System.out.println("'" + e.getKey() + "': " + e.getValue()));
```

### Find Most Frequent Character

```java
public static char mostFrequentChar(String str) {
    Map<Character, Integer> freq = new HashMap<>();
    for (char c : str.toCharArray()) {
        freq.put(c, freq.getOrDefault(c, 0) + 1);
    }

    return freq.entrySet().stream()
               .max(Map.Entry.comparingByValue())
               .map(Map.Entry::getKey)
               .orElseThrow();
}

System.out.println(mostFrequentChar("aabbccddeeea")); // 'a' (appears 4 times)
```

### Find First Non-Repeating Character

```java
public static char firstNonRepeating(String str) {
    Map<Character, Integer> freq = new LinkedHashMap<>();
    for (char c : str.toCharArray()) {
        freq.put(c, freq.getOrDefault(c, 0) + 1);
    }

    for (Map.Entry<Character, Integer> entry : freq.entrySet()) {
        if (entry.getValue() == 1) {
            return entry.getKey();  // first character with count 1
        }
    }
    return '\0';  // no non-repeating character
}

System.out.println(firstNonRepeating("aabcddee")); // 'b'
System.out.println(firstNonRepeating("aabb"));     // '\0' (none found)
```

### Remove Duplicate Characters (Keep First Occurrence)

```java
public static String removeDuplicates(String str) {
    Set<Character> seen = new LinkedHashSet<>();
    for (char c : str.toCharArray()) {
        seen.add(c);  // Set auto-deduplicates
    }
    StringBuilder sb = new StringBuilder();
    seen.forEach(sb::append);
    return sb.toString();
}

System.out.println(removeDuplicates("programming")); // "progamin"
```

### Complete Test

```java
@Test
public void testCharFrequency() {
    Map<Character, Integer> freq = charFrequency("aabb");
    assertEquals(2, (int) freq.get('a'));
    assertEquals(2, (int) freq.get('b'));

    assertEquals('a', mostFrequentChar("aabbc")); // a appears most
    assertEquals('b', firstNonRepeating("aabcdd")); // b is first non-repeating
    assertEquals("abc", removeDuplicates("aabbcc")); // unique chars preserved
}
```$$,
  'Core Java', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Character Frequency', 'HashMap', 'String', 'Coding', 'Core Java', 'Interview Program', 'Java 8'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the FizzBuzz problem? Write a Java solution.',
  'fizzbuzz-java-solution',
  'FizzBuzz: print Fizz for multiples of 3, Buzz for multiples of 5, FizzBuzz for multiples of both, and the number otherwise.',
  $$## FizzBuzz in Java

**Rules:**
- Print **Fizz** for multiples of 3
- Print **Buzz** for multiples of 5
- Print **FizzBuzz** for multiples of both 3 and 5
- Otherwise print the **number**

### Basic Solution

```java
public static void fizzBuzz(int n) {
    for (int i = 1; i <= n; i++) {
        if (i % 3 == 0 && i % 5 == 0) {
            System.out.println("FizzBuzz");
        } else if (i % 3 == 0) {
            System.out.println("Fizz");
        } else if (i % 5 == 0) {
            System.out.println("Buzz");
        } else {
            System.out.println(i);
        }
    }
}

fizzBuzz(20);
// 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz
```

### Return as List (Testable)

```java
public static List<String> fizzBuzzList(int n) {
    List<String> result = new ArrayList<>();
    for (int i = 1; i <= n; i++) {
        String word = "";
        if (i % 3 == 0) word += "Fizz";
        if (i % 5 == 0) word += "Buzz";
        result.add(word.isEmpty() ? String.valueOf(i) : word);
    }
    return result;
}

System.out.println(fizzBuzzList(15));
// [1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz]
```

### Java 8 Stream Solution

```java
List<String> result = IntStream.rangeClosed(1, 20)
    .mapToObj(i -> {
        if (i % 15 == 0) return "FizzBuzz";
        if (i %  3 == 0) return "Fizz";
        if (i %  5 == 0) return "Buzz";
        return String.valueOf(i);
    })
    .collect(Collectors.toList());
```

### Extensible Solution (Easy to add new rules)

```java
// Use a map of divisor → word
public static String fizzBuzzFor(int n) {
    Map<Integer, String> rules = new LinkedHashMap<>();
    rules.put(3, "Fizz");
    rules.put(5, "Buzz");
    // rules.put(7, "Bazz");  // easy to extend!

    StringBuilder result = new StringBuilder();
    for (Map.Entry<Integer, String> rule : rules.entrySet()) {
        if (n % rule.getKey() == 0) {
            result.append(rule.getValue());
        }
    }
    return result.length() > 0 ? result.toString() : String.valueOf(n);
}
```

### Test Cases

```java
@Test
public void testFizzBuzz() {
    List<String> result = fizzBuzzList(15);

    assertEquals("1",        result.get(0));    // 1 → number
    assertEquals("Fizz",     result.get(2));    // 3 → Fizz
    assertEquals("Buzz",     result.get(4));    // 5 → Buzz
    assertEquals("Fizz",     result.get(5));    // 6 → Fizz
    assertEquals("FizzBuzz", result.get(14));   // 15 → FizzBuzz
}
```$$,
  'Core Java', 'Coding', 'Fresher', 'Beginner',
  ARRAY['FizzBuzz', 'Coding', 'Core Java', 'Interview Program', 'Modulo', 'Classic Problem'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between volatile and synchronized in Java?',
  'volatile-vs-synchronized-java',
  'volatile ensures visibility of a variable across threads. synchronized ensures both visibility and atomicity (mutual exclusion). Use volatile for single reads/writes, synchronized for compound actions.',
  $$## volatile vs synchronized in Java

Both deal with **multi-threading**, but solve different problems.

## volatile Keyword

- Guarantees **visibility** — changes to a volatile variable are immediately visible to all threads
- Does NOT guarantee **atomicity** — compound operations (i++) are not thread-safe with volatile
- No locking — threads do NOT block

```java
public class Counter {
    private volatile boolean running = true;  // visible to all threads immediately
    private volatile int    count    = 0;     // reads/writes are atomic for primitives

    public void stop() {
        running = false;  // immediately visible to other threads
    }

    public void run() {
        while (running) {  // sees latest value of running
            // do work
        }
    }
}
```

### volatile is Enough When:
- You have a **flag** (boolean) that one thread writes and others read
- Variable is read/written independently (not compound operation)

```java
// CORRECT: single write, multiple reads — volatile is sufficient
private volatile boolean shutdownRequested = false;

public void shutdown()  { shutdownRequested = true; }
public boolean isDone() { return shutdownRequested; }
```

## synchronized Keyword

- Guarantees both **visibility** AND **atomicity** (mutual exclusion)
- Only one thread enters a synchronized block at a time
- Other threads **block** and wait

```java
public class SafeCounter {
    private int count = 0;

    // synchronized — only one thread increments at a time
    public synchronized void increment() {
        count++;  // read + increment + write = compound operation — needs sync
    }

    public synchronized int getCount() {
        return count;
    }
}
```

## Why volatile is NOT Enough for count++

```java
// count++ is NOT atomic — it's three operations:
// 1. read current value of count
// 2. add 1
// 3. write back the new value

// Two threads can read 5 simultaneously, both write 6 → count = 6 instead of 7!
private volatile int count = 0;  // ⚠️ still broken for count++
```

## Direct Comparison

| Feature | volatile | synchronized |
|---------|---------|-------------|
| Visibility | Yes | Yes |
| Atomicity | No | Yes |
| Performance | Fast (no locking) | Slower (blocks) |
| Use for | Flags, status | Counters, compound actions |
| Blocks threads | No | Yes |

## Better Alternatives — java.util.concurrent.atomic

```java
// AtomicInteger — atomic operations without explicit locking
private AtomicInteger count = new AtomicInteger(0);

public void increment() {
    count.incrementAndGet();  // atomic: read + increment + write
}

public int getCount() {
    return count.get();
}

// Other atomic operations
count.compareAndSet(expected, newValue);
count.addAndGet(delta);
count.getAndSet(newValue);
```

## Practical Example

```java
public class SharedState {
    // volatile — flag that signals all threads to stop
    private volatile boolean stopRequested = false;

    // synchronized — compound operation on shared counter
    private int taskCount = 0;
    private final Object lock = new Object();

    public void requestStop() {
        stopRequested = true;  // volatile write — all threads see immediately
    }

    public boolean isStopRequested() {
        return stopRequested;  // volatile read
    }

    public void incrementTaskCount() {
        synchronized (lock) {
            taskCount++;  // compound — needs synchronization
        }
    }

    public int getTaskCount() {
        synchronized (lock) {
            return taskCount;
        }
    }
}
```$$,
  'Core Java', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['volatile', 'synchronized', 'Multithreading', 'Thread Safety', 'Atomic', 'Core Java', 'Concurrency'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Serialization in Java? How do you implement it?',
  'serialization-java-implementation',
  'Serialization converts an object into a byte stream for storage or transmission. Implement Serializable interface. Use transient for fields to skip. Use serialVersionUID for version control.',
  $$## Serialization in Java

**Serialization** = converting a Java object into a **byte stream** (for storage/network transfer)
**Deserialization** = converting byte stream **back to an object**

## Why Serialization?

- Save object state to a file or database
- Send objects over a network (RMI, sockets)
- Cache objects (Redis, memcached)
- Deep copy of objects

## Implementing Serialization

```java
import java.io.Serializable;

public class Employee implements Serializable {
    // Always define serialVersionUID for version control
    private static final long serialVersionUID = 1L;

    private String name;
    private String department;
    private int    age;
    private double salary;

    // transient — this field will NOT be serialized
    private transient String password;
    // static fields are also NOT serialized (belong to class, not instance)
    private static String companyName = "AutomateQA";

    public Employee(String name, String department, int age, double salary, String password) {
        this.name       = name;
        this.department = department;
        this.age        = age;
        this.salary     = salary;
        this.password   = password;
    }

    @Override
    public String toString() {
        return "Employee{name='" + name + "', dept='" + department +
               "', age=" + age + ", salary=" + salary + ", password=" + password + "}";
    }
}
```

## Serialize (Write to File)

```java
public static void serialize(Employee emp, String filePath) {
    try (ObjectOutputStream oos = new ObjectOutputStream(
             new FileOutputStream(filePath))) {
        oos.writeObject(emp);
        System.out.println("Serialized: " + emp.getName());
    } catch (IOException e) {
        throw new RuntimeException("Serialization failed", e);
    }
}

Employee emp = new Employee("Alice", "QA", 30, 95000, "secret123");
serialize(emp, "employee.ser");
```

## Deserialize (Read from File)

```java
public static Employee deserialize(String filePath) {
    try (ObjectInputStream ois = new ObjectInputStream(
             new FileInputStream(filePath))) {
        return (Employee) ois.readObject();
    } catch (IOException | ClassNotFoundException e) {
        throw new RuntimeException("Deserialization failed", e);
    }
}

Employee loaded = deserialize("employee.ser");
System.out.println(loaded);
// Employee{name='Alice', dept='QA', age=30, salary=95000.0, password=null}
// Note: password is null — transient field not serialized
```

## serialVersionUID — Version Control

```java
// Without explicit serialVersionUID, JVM generates one based on class structure
// If you change the class (add/remove fields) — JVM generates a NEW ID
// Deserialization fails with InvalidClassException!

// BEST PRACTICE: Always declare it explicitly
private static final long serialVersionUID = 1L;

// Use value = 2L when making BREAKING changes to the class
private static final long serialVersionUID = 2L;
```

## transient Keyword

```java
public class UserSession implements Serializable {
    private static final long serialVersionUID = 1L;

    private String username;          // serialized
    private String sessionId;         // serialized
    private transient String token;   // NOT serialized (sensitive)
    private transient WebDriver driver; // NOT serialized (not serializable)
}
```

## Externalizable Interface (Manual Control)

```java
// More control than Serializable — implement read/write yourself
public class Config implements Externalizable {
    private String host;
    private int    port;

    // Required no-arg constructor
    public Config() {}

    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeObject(host);
        out.writeInt(port);
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        host = (String) in.readObject();
        port = in.readInt();
    }
}
```

## In Automation Testing

```java
// Use serialization to save/restore test state
public class TestStateManager {
    public static void saveState(TestState state, String path) throws IOException {
        try (ObjectOutputStream oos = new ObjectOutputStream(
                 new FileOutputStream(path))) {
            oos.writeObject(state);
        }
    }

    public static TestState loadState(String path) throws Exception {
        try (ObjectInputStream ois = new ObjectInputStream(
                 new FileInputStream(path))) {
            return (TestState) ois.readObject();
        }
    }
}
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Serialization', 'Serializable', 'transient', 'serialVersionUID', 'Core Java', 'IO', 'ObjectOutputStream'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between deep copy and shallow copy in Java?',
  'deep-copy-vs-shallow-copy-java',
  'Shallow copy copies object references (both copies point to same nested objects). Deep copy creates new copies of all nested objects independently.',
  $$## Deep Copy vs Shallow Copy

## The Difference

- **Shallow Copy** — copies the object but keeps references to the same nested objects
- **Deep Copy** — copies the object AND all nested objects recursively (fully independent)

```
Original:   Address ──┐
Employee ───────────── ┘ ← same object

Shallow:    Address ──┐
Employee2 ─────────── ┘ ← still pointing to same Address!

Deep:       Address (ORIGINAL)
Employee ───────────────────
Employee2 ─── Address (NEW COPY) ← fully independent
```

## Classes Used in Examples

```java
public class Address {
    String city;
    String country;

    Address(String city, String country) {
        this.city    = city;
        this.country = country;
    }
}

public class Employee {
    String  name;
    Address address;  // nested object

    Employee(String name, Address address) {
        this.name    = name;
        this.address = address;
    }
}
```

## Shallow Copy

```java
// Method 1: new object + copy primitives/references
Employee original = new Employee("Alice", new Address("New York", "USA"));

Employee shallowCopy = new Employee(original.name, original.address); // same Address ref!

// Modify the copy's nested object
shallowCopy.address.city = "London";

// Original is ALSO changed — same Address object!
System.out.println(original.address.city);    // "London" ← CHANGED!
System.out.println(shallowCopy.address.city); // "London"
```

## Shallow Copy with clone() (implements Cloneable)

```java
public class Employee implements Cloneable {
    String  name;
    Address address;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();  // shallow clone — copies reference to address
    }
}

Employee copy = (Employee) original.clone();
// copy.address still points to same Address as original
```

## Deep Copy — Manual

```java
public class Employee implements Cloneable {
    String  name;
    Address address;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        Employee deepCopy = (Employee) super.clone();
        // Manually clone the nested object
        deepCopy.address = new Address(this.address.city, this.address.country);
        return deepCopy;
    }
}

Employee original = new Employee("Alice", new Address("New York", "USA"));
Employee deepCopy = (Employee) original.clone();

deepCopy.address.city = "London";

System.out.println(original.address.city);  // "New York" ← NOT changed!
System.out.println(deepCopy.address.city);  // "London"
```

## Deep Copy via Serialization (Easy for complex graphs)

```java
// Both classes must implement Serializable
public static <T extends Serializable> T deepCopy(T obj) {
    try {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ObjectOutputStream oos    = new ObjectOutputStream(bos);
        oos.writeObject(obj);

        ByteArrayInputStream bis  = new ByteArrayInputStream(bos.toByteArray());
        ObjectInputStream ois     = new ObjectInputStream(bis);
        return (T) ois.readObject();
    } catch (Exception e) {
        throw new RuntimeException("Deep copy failed", e);
    }
}

Employee deepCopy = deepCopy(original); // fully independent copy
```

## Deep Copy via Copy Constructor (Recommended)

```java
public class Employee {
    String  name;
    Address address;

    // Copy constructor — deep copy
    public Employee(Employee other) {
        this.name    = other.name;
        this.address = new Address(other.address.city, other.address.country);
    }
}

Employee copy = new Employee(original);  // clean, explicit deep copy
```

## In Automation Testing

```java
// Deep copy test data to avoid mutations between tests
TestData original = new TestData("Alice", new Config("chrome", "https://qa.example.com"));
TestData testCopy = original.deepCopy();  // each test gets independent copy

// Modifying testCopy doesn''t affect original
testCopy.config.url = "https://staging.example.com";
// original.config.url still = "https://qa.example.com"
```$$,
  'Core Java', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Deep Copy', 'Shallow Copy', 'Cloneable', 'clone()', 'Core Java', 'Object Copying', 'Serialization'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How does ConcurrentHashMap work in Java? How is it different from HashMap and Hashtable?',
  'concurrenthashmap-vs-hashmap-vs-hashtable',
  'ConcurrentHashMap allows concurrent reads and partial locks (segment-level in Java 7, node-level in Java 8). HashMap is not thread-safe. Hashtable locks the entire map.',
  $$## ConcurrentHashMap vs HashMap vs Hashtable

## Quick Comparison

| Feature | HashMap | Hashtable | ConcurrentHashMap |
|---------|---------|-----------|-------------------|
| Thread-safe | No | Yes (full lock) | Yes (partial lock) |
| Performance | Fast | Slow (lock on all ops) | High concurrency |
| Null keys | 1 allowed | Not allowed | Not allowed |
| Null values | Allowed | Not allowed | Not allowed |
| Synchronized | No | Every method | Bucket/node level |
| Java version | 1.2 | 1.0 (legacy) | 1.5 (java.util.concurrent) |

## HashMap — Not Thread-Safe

```java
Map<String, Integer> map = new HashMap<>();

// Two threads writing simultaneously → data corruption, infinite loop (Java 7)!
// Thread 1
map.put("Alice", 1);
// Thread 2 (at same time)
map.put("Bob", 2);
// Result: ConcurrentModificationException or data loss!

// Use only in single-threaded context
Map<String, Integer> local = new HashMap<>();  // safe in single thread
```

## Hashtable — Fully Synchronized (Legacy, Avoid)

```java
Map<String, Integer> table = new Hashtable<>();

// Every method is synchronized — only one thread at a time
// Even reads block other reads!
table.put("Alice", 1);    // locks entire map
table.get("Alice");       // also locks entire map

// Problem: bottleneck in high-concurrency scenarios
```

## ConcurrentHashMap — Fine-Grained Locking (Best Choice)

```java
Map<String, Integer> concurrentMap = new ConcurrentHashMap<>();

// Java 7: divided into 16 segments, each with own lock
// Java 8: CAS (Compare-And-Swap) operations at node level

// Safe for concurrent reads — no locking at all!
// Safe for concurrent writes — only locks the specific bucket

concurrentMap.put("Alice", 1);   // locks only Alice's bucket
concurrentMap.put("Bob", 2);     // locks only Bob's bucket — PARALLEL!
```

## Atomic Operations in ConcurrentHashMap

```java
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
map.put("counter", 0);

// putIfAbsent — atomic check-and-insert
map.putIfAbsent("newKey", 42);  // only puts if key doesn''t exist (atomic)

// computeIfAbsent — compute value if missing (atomic)
map.computeIfAbsent("user123", key -> loadFromDB(key));

// compute — atomic update
map.compute("counter", (k, v) -> v == null ? 1 : v + 1);  // atomic increment!

// merge — atomic merge with function
map.merge("counter", 1, Integer::sum);  // adds 1 to existing value
```

## Producer-Consumer with ConcurrentHashMap

```java
ConcurrentHashMap<String, String> sessionCache = new ConcurrentHashMap<>();

// Thread 1 (writing sessions)
Thread writer = new Thread(() -> {
    for (int i = 0; i < 100; i++) {
        sessionCache.put("session-" + i, "user-" + i);
    }
});

// Thread 2 (reading sessions)
Thread reader = new Thread(() -> {
    sessionCache.forEach((sessionId, userId) ->
        System.out.println("Active: " + sessionId + " → " + userId));
});

writer.start();
reader.start();
// Safe! No ConcurrentModificationException
```

## When to Use What

```java
// 1. Single thread — use HashMap (fastest)
Map<String, String> config = new HashMap<>();

// 2. Legacy code / simple sync — use Collections.synchronizedMap
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());
// Still locks the whole map though

// 3. High concurrency reads + some writes — use ConcurrentHashMap
Map<String, UserSession> sessions = new ConcurrentHashMap<>();

// 4. NEVER use Hashtable in new code — it''s legacy
```

## In Automation Testing (Parallel Tests)

```java
// Share test results across parallel test threads
public class TestResultStore {
    private static final ConcurrentHashMap<String, String> results =
        new ConcurrentHashMap<>();

    public static void record(String testName, String status) {
        results.put(testName, status);  // thread-safe across parallel tests
    }

    public static Map<String, String> getAll() {
        return Collections.unmodifiableMap(results);
    }

    public static long countPassed() {
        return results.values().stream().filter("PASSED"::equals).count();
    }
}

// In any test thread
TestResultStore.record(testName, "PASSED");
```$$,
  'Core Java', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['ConcurrentHashMap', 'HashMap', 'Hashtable', 'Thread Safety', 'Concurrency', 'Core Java', 'Collections'], true, 0
);
