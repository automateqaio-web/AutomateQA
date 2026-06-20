-- Core Java Beginner Q1–Q15 | Paste into Supabase SQL Editor

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is Java and what are its key features?',
  'what-is-java-key-features',
  'Java is a platform-independent, object-oriented programming language known for WORA (Write Once Run Anywhere), strong typing, and automatic memory management.',
  $$## What is Java?

Java is a **high-level, class-based, object-oriented programming language** designed to have as few implementation dependencies as possible. It was developed by **James Gosling at Sun Microsystems** in 1995.

## Key Features of Java

### 1. Platform Independent — "Write Once, Run Anywhere (WORA)"
Java code compiles to **bytecode** (.class files), not machine code. The JVM (Java Virtual Machine) on any OS can run the same bytecode.

```
Java Code (.java)
      ↓  javac compiler
  Bytecode (.class)
      ↓  JVM
Runs on Windows / Linux / Mac
```

### 2. Object-Oriented
Everything in Java is an object. Supports: Inheritance, Encapsulation, Polymorphism, Abstraction.

### 3. Strongly Typed
Every variable must have a declared type. Type mismatch = compile-time error.

### 4. Automatic Memory Management
The **Garbage Collector (GC)** automatically frees unused objects — no manual memory management like C/C++.

### 5. Multithreading
Java has built-in support for concurrent programming via `Thread` class and `Runnable` interface.

### 6. Robust and Secure
- Compile-time and runtime error checking
- No pointer arithmetic (prevents memory corruption)
- Built-in exception handling

### 7. Rich Standard Library
Java provides a vast API: Collections, I/O, Networking, Concurrency, JDBC, and more.

## JDK vs JRE vs JVM

| Component | Full Form | Purpose |
|-----------|-----------|---------|
| **JDK** | Java Development Kit | For developers — includes compiler (javac), JRE, debugging tools |
| **JRE** | Java Runtime Environment | For running Java apps — includes JVM + libraries |
| **JVM** | Java Virtual Machine | Executes bytecode on the specific OS |

```
JDK ⊃ JRE ⊃ JVM
```

## Why Java for QA/SDET?

- **Selenium WebDriver** is written in Java
- **TestNG, JUnit, Rest Assured, Cucumber** all use Java
- Most enterprise automation frameworks are Java-based
- Strong type system catches bugs at compile time, not runtime$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Java', 'JDK', 'JRE', 'JVM', 'WORA', 'Platform Independent', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are the 4 pillars of Object-Oriented Programming (OOP) in Java?',
  'four-pillars-oop-java',
  'The 4 OOP pillars are Encapsulation, Inheritance, Polymorphism, and Abstraction — each controlling how data and behavior are organized and shared.',
  $$## 4 Pillars of OOP in Java

### 1. Encapsulation — "Data Hiding"
Wrapping data (fields) and methods into a single unit (class), and restricting direct access using access modifiers.

```java
public class BankAccount {
    private double balance;  // hidden — cannot access directly

    public double getBalance() { return balance; }  // controlled access

    public void deposit(double amount) {
        if (amount > 0) balance += amount;  // validation before changing
    }
}

// Usage
BankAccount acc = new BankAccount();
acc.deposit(1000);
System.out.println(acc.getBalance()); // 1000.0
// acc.balance = -5000; // ❌ compile error — private
```

**Benefits:** Data validation, security, flexibility to change implementation.

---

### 2. Inheritance — "Code Reuse"
A child class acquires properties and behavior of a parent class using `extends`.

```java
public class Animal {
    public void eat() {
        System.out.println("Animal eats");
    }
}

public class Dog extends Animal {
    public void bark() {
        System.out.println("Dog barks");
    }
}

Dog dog = new Dog();
dog.eat();   // inherited from Animal
dog.bark();  // own method
```

**Types in Java:** Single, Multilevel, Hierarchical (Multiple inheritance via class is NOT supported — use interfaces).

---

### 3. Polymorphism — "Many Forms"
Same method name behaves differently based on context.

**Compile-time (Method Overloading):**
```java
public class Calculator {
    public int add(int a, int b)       { return a + b; }
    public double add(double a, double b) { return a + b; }
    public int add(int a, int b, int c) { return a + b + c; }
}
```

**Runtime (Method Overriding):**
```java
Animal animal = new Dog();
animal.eat(); // calls Dog's version at runtime
```

---

### 4. Abstraction — "Hide Complexity"
Show only what is necessary; hide implementation details.

```java
// Abstract class
abstract class Shape {
    abstract double area();  // no body — must be implemented
    public void display() {
        System.out.println("Area: " + area());
    }
}

class Circle extends Shape {
    double radius;
    Circle(double r) { radius = r; }

    @Override
    double area() { return Math.PI * radius * radius; }
}
```

Also achieved via **Interfaces** (100% abstraction).

---

## Quick Summary

| Pillar | Keyword | Purpose |
|--------|---------|---------|
| Encapsulation | `private` + getters/setters | Data protection |
| Inheritance | `extends` | Code reuse |
| Polymorphism | Overloading / Overriding | Flexibility |
| Abstraction | `abstract` / `interface` | Hide complexity |$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['OOP', 'Encapsulation', 'Inheritance', 'Polymorphism', 'Abstraction', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between == and .equals() in Java?',
  'difference-equals-operator-equals-method-java',
  '== compares object references (memory address); .equals() compares the actual content of objects. Always use .equals() for Strings.',
  $$## == vs .equals() in Java

This is one of the most common Java interview questions for QA/SDET roles.

## == Operator — Reference Comparison

`==` checks if **two variables point to the same memory address** (same object in heap).

```java
String s1 = new String("hello");
String s2 = new String("hello");

System.out.println(s1 == s2);      // false — different objects in heap
System.out.println(s1.equals(s2)); // true  — same content
```

## .equals() — Content Comparison

`.equals()` compares the **actual value/content** of objects.

```java
String a = "hello";
String b = "hello";

System.out.println(a == b);      // true — both point to same String pool entry
System.out.println(a.equals(b)); // true — same content
```

## String Pool Trick

Java maintains a **String Constant Pool** for string literals. Same literal = same object.

```java
String x = "test";           // goes to String pool
String y = "test";           // reuses same pool entry
String z = new String("test"); // creates NEW object in heap

System.out.println(x == y);     // true  (same pool object)
System.out.println(x == z);     // false (z is in heap, not pool)
System.out.println(x.equals(z)); // true (same content)
```

## == with Primitives vs Objects

```java
int a = 5;
int b = 5;
System.out.println(a == b); // true — primitives compare VALUE with ==

Integer x = 127;
Integer y = 127;
System.out.println(x == y); // true — Integer cache (-128 to 127)

Integer p = 200;
Integer q = 200;
System.out.println(p == q); // false — outside cache range, different objects
System.out.println(p.equals(q)); // true
```

## In Automation Testing

```java
// ❌ Wrong — comparing String values in Selenium tests
String actualTitle = driver.getTitle();
String expectedTitle = "Login Page";
if (actualTitle == expectedTitle) { ... }  // UNRELIABLE

// ✅ Correct
if (actualTitle.equals(expectedTitle)) { ... }
// or even safer (handles null)
if (expectedTitle.equals(actualTitle)) { ... }
```

## Summary Table

| Aspect | == | .equals() |
|--------|-----|-----------|
| Compares | Memory address (reference) | Content/value |
| Works on | Primitives + Objects | Objects only |
| For Strings | Unreliable | Always use this |
| null-safe? | Yes (won't throw NPE) | Throws NPE if called on null |$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['equals', '==', 'String', 'Reference', 'Core Java', 'Common Mistakes'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are access modifiers in Java? Explain with examples.',
  'access-modifiers-java-explained',
  'Java has 4 access modifiers: public, protected, default (package-private), and private — controlling visibility of classes, methods, and fields.',
  $$## Access Modifiers in Java

Access modifiers control the **visibility and accessibility** of classes, methods, constructors, and fields.

## The 4 Access Modifiers

| Modifier | Same Class | Same Package | Subclass | Everywhere |
|----------|-----------|--------------|----------|-----------|
| **private** | ✅ | ❌ | ❌ | ❌ |
| **default** (none) | ✅ | ✅ | ❌ | ❌ |
| **protected** | ✅ | ✅ | ✅ | ❌ |
| **public** | ✅ | ✅ | ✅ | ✅ |

## 1. private — Most Restrictive

Only accessible within the **same class**.

```java
public class Employee {
    private String salary;   // only this class can access

    private void calculateBonus() { ... }  // private method

    public String getSalary() {
        return salary;   // public getter exposes private field safely
    }
}
```

## 2. default (no keyword) — Package-Private

Accessible within the **same package** only.

```java
class DatabaseConfig {         // no modifier = default
    String connectionUrl;      // default field

    void connect() { ... }    // default method
}
// Accessible only within same package
```

## 3. protected — Package + Subclasses

Accessible in same package AND in subclasses (even in different packages).

```java
public class Vehicle {
    protected int speed;       // accessible to subclasses

    protected void accelerate() {
        speed += 10;
    }
}

public class Car extends Vehicle {
    public void drive() {
        accelerate();   // ✅ can access protected method from parent
        speed = 60;     // ✅ can access protected field
    }
}
```

## 4. public — Most Open

Accessible from **anywhere** — any class, any package.

```java
public class MathUtils {
    public static int add(int a, int b) {
        return a + b;
    }
}
// Any class anywhere can call MathUtils.add(2, 3)
```

## Best Practices (Encapsulation)

```java
public class User {
    private String username;    // private field
    private String password;    // private field

    public String getUsername() { return username; }    // public getter
    public void setUsername(String u) { this.username = u; }  // public setter

    // No getter/setter for password — intentionally hidden
    public boolean authenticate(String input) {
        return this.password.equals(input);
    }
}
```

## In Automation Frameworks

```java
public class BasePage {
    protected WebDriver driver;     // subclasses (LoginPage, HomePage) can use it
    private String baseUrl;         // only BasePage needs this

    public void openUrl(String url) { driver.get(url); }  // public for tests
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Access Modifiers', 'public', 'private', 'protected', 'Encapsulation', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between String, StringBuilder, and StringBuffer in Java?',
  'string-stringbuilder-stringbuffer-difference-java',
  'String is immutable; StringBuilder is mutable and fast (not thread-safe); StringBuffer is mutable and thread-safe but slower.',
  $$## String vs StringBuilder vs StringBuffer

## String — Immutable

Every modification creates a **new String object** in memory.

```java
String s = "Hello";
s = s + " World";   // creates NEW object — old "Hello" stays in pool
System.out.println(s); // "Hello World"

// Performance problem in loops:
String result = "";
for (int i = 0; i < 10000; i++) {
    result += i;    // creates 10000 new String objects! Very slow.
}
```

**When to use:** When the value won't change (passwords, config keys, constants).

---

## StringBuilder — Mutable, Fast, Not Thread-Safe

Modifies the **same object** in memory. Best for single-threaded string manipulation.

```java
StringBuilder sb = new StringBuilder("Hello");
sb.append(" World");    // modifies same object
sb.insert(5, ",");      // "Hello, World"
sb.reverse();           // "dlroW ,olleH"
sb.delete(0, 6);        // "olleH"
sb.replace(0, 2, "XX"); // "XXleH"

System.out.println(sb.toString());

// Efficient in loops:
StringBuilder sb2 = new StringBuilder();
for (int i = 0; i < 10000; i++) {
    sb2.append(i);  // modifies same object — fast!
}
```

**Common StringBuilder methods:**

| Method | Example | Result |
|--------|---------|--------|
| `append(x)` | `sb.append("!")` | Adds to end |
| `insert(i, x)` | `sb.insert(0, "Hi ")` | Inserts at index |
| `delete(s, e)` | `sb.delete(0, 2)` | Removes chars |
| `reverse()` | `sb.reverse()` | Reverses string |
| `replace(s,e,x)` | `sb.replace(0,1,"A")` | Replaces range |
| `length()` | `sb.length()` | Returns length |

---

## StringBuffer — Mutable, Thread-Safe, Slower

Same as StringBuilder but all methods are **synchronized** — safe in multi-threaded code.

```java
StringBuffer sbf = new StringBuffer("Hello");
sbf.append(" World");
// Thread-safe: multiple threads can append without data corruption
```

---

## Comparison Table

| Feature | String | StringBuilder | StringBuffer |
|---------|--------|---------------|--------------|
| **Mutable?** | No | Yes | Yes |
| **Thread-safe?** | Yes (immutable) | No | Yes (synchronized) |
| **Performance** | Slow (new objects) | Fast | Medium |
| **Introduced** | Java 1.0 | Java 1.5 | Java 1.0 |
| **Use when** | Fixed values | Single-thread | Multi-thread |

## In Automation Testing

```java
// Building dynamic XPaths or URLs — use StringBuilder
StringBuilder xpath = new StringBuilder("//div[@class='");
xpath.append(className).append("']//button[text()='");
xpath.append(buttonText).append("']");
driver.findElement(By.xpath(xpath.toString())).click();

// Building API request bodies dynamically
StringBuilder body = new StringBuilder("{");
body.append("\"name\":\"").append(userName).append("\",");
body.append("\"email\":\"").append(userEmail).append("\"}");
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['String', 'StringBuilder', 'StringBuffer', 'Immutable', 'Thread-Safe', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is a constructor in Java? What are the types of constructors?',
  'constructor-types-java',
  'A constructor is a special method called when an object is created. Types: default (no-arg), parameterized, and copy constructor.',
  $$## Constructors in Java

A **constructor** is a special method that is **automatically called when an object is created** using `new`. It has the same name as the class and no return type.

## Types of Constructors

### 1. Default Constructor (No-arg)

Provided by Java automatically if you don''t define any constructor. Sets all fields to default values.

```java
public class Car {
    String brand;
    int speed;

    // Default constructor (Java creates this automatically if not defined)
    public Car() {
        brand = "Unknown";
        speed = 0;
    }
}

Car car = new Car();  // calls default constructor
System.out.println(car.brand); // "Unknown"
```

### 2. Parameterized Constructor

Accepts arguments to initialize fields with specific values.

```java
public class Car {
    String brand;
    int speed;
    String color;

    public Car(String brand, int speed, String color) {
        this.brand = brand;   // 'this' refers to current object
        this.speed = speed;
        this.color = color;
    }
}

Car car1 = new Car("Toyota", 120, "Red");
Car car2 = new Car("BMW", 200, "Black");
```

### 3. Copy Constructor

Creates a new object as a copy of an existing object.

```java
public class Car {
    String brand;
    int speed;

    public Car(String brand, int speed) {
        this.brand = brand;
        this.speed = speed;
    }

    // Copy constructor
    public Car(Car other) {
        this.brand = other.brand;
        this.speed = other.speed;
    }
}

Car original = new Car("Honda", 100);
Car copy     = new Car(original);   // copy constructor
copy.brand = "Modified";
System.out.println(original.brand); // "Honda" — not affected
```

## Constructor Overloading

Multiple constructors with different parameter lists.

```java
public class User {
    String name;
    String email;
    String role;

    public User() {
        this("Unknown", "N/A", "viewer");  // calls 3-arg constructor
    }

    public User(String name) {
        this(name, "N/A", "viewer");
    }

    public User(String name, String email, String role) {
        this.name  = name;
        this.email = email;
        this.role  = role;
    }
}
```

## Constructor vs Method

| Aspect | Constructor | Method |
|--------|-------------|--------|
| Name | Same as class | Any name |
| Return type | None (not even void) | Must have return type |
| Called | Automatically on `new` | Manually |
| Purpose | Initialize object | Perform operation |

## In Automation Frameworks

```java
public class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    // Constructor — called when BasePage (or subclass) is created
    public BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        PageFactory.initElements(driver, this);
    }
}

// LoginPage inherits and calls parent constructor
public class LoginPage extends BasePage {
    public LoginPage(WebDriver driver) {
        super(driver);  // calls BasePage constructor
    }
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Constructor', 'Default Constructor', 'Parameterized', 'Copy Constructor', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between method overloading and method overriding in Java?',
  'method-overloading-vs-overriding-java',
  'Overloading = same method name, different parameters in same class (compile-time). Overriding = subclass redefines parent method (runtime).',
  $$## Method Overloading vs Method Overriding

## Method Overloading — Compile-Time Polymorphism

**Same method name, different parameter list** in the **same class**.

```java
public class Calculator {

    // Overloaded methods — same name, different params
    public int add(int a, int b) {
        return a + b;
    }

    public double add(double a, double b) {
        return a + b;
    }

    public int add(int a, int b, int c) {
        return a + b + c;
    }

    public String add(String a, String b) {
        return a + b;
    }
}

Calculator c = new Calculator();
c.add(1, 2);         // calls int version
c.add(1.0, 2.0);     // calls double version
c.add(1, 2, 3);      // calls 3-arg version
c.add("Hello", " World"); // calls String version
```

**Rules for Overloading:**
- Must change parameter **type, number, or order**
- Return type alone is NOT enough to overload
- Can have different return types (but must also differ in params)

---

## Method Overriding — Runtime Polymorphism

**Subclass redefines a method** from the parent class with the **same signature**.

```java
class Animal {
    public void sound() {
        System.out.println("Some generic sound");
    }
}

class Dog extends Animal {
    @Override
    public void sound() {
        System.out.println("Woof!");
    }
}

class Cat extends Animal {
    @Override
    public void sound() {
        System.out.println("Meow!");
    }
}

// Runtime polymorphism — decided at runtime
Animal a1 = new Dog();
Animal a2 = new Cat();
a1.sound();  // "Woof!"
a2.sound();  // "Meow!"
```

**Rules for Overriding:**
- Same method name, same return type, same parameters
- Cannot override `static`, `final`, or `private` methods
- `@Override` annotation is recommended (compiler catches mistakes)
- Overriding method cannot throw broader checked exceptions

---

## Comparison Table

| Aspect | Overloading | Overriding |
|--------|------------|------------|
| Class | Same class | Parent + Child class |
| Parameters | Must differ | Must be same |
| Return type | Can differ | Must be same (or covariant) |
| Binding | Compile-time (static) | Runtime (dynamic) |
| Polymorphism | Compile-time | Runtime |
| `@Override` | Not needed | Recommended |
| Static methods | Can be overloaded | Cannot be overridden |

## In Automation

```java
// Overloading — click method with different wait times
public void click(By locator) { ... }
public void click(By locator, int timeoutSeconds) { ... }

// Overriding — each page implements its own setup
class BasePage {
    public void waitForPageLoad() { ... }
}
class CheckoutPage extends BasePage {
    @Override
    public void waitForPageLoad() {
        // Wait for specific checkout elements
        wait.until(ExpectedConditions.visibilityOf(totalAmount));
    }
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Overloading', 'Overriding', 'Polymorphism', 'Core Java', 'OOP', 'Methods'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the static keyword in Java? Explain static variables, methods, and blocks.',
  'static-keyword-java-variables-methods-blocks',
  'static means the member belongs to the class, not to instances. Static variables are shared across all objects; static methods can be called without creating an object.',
  $$## The static Keyword in Java

`static` means the member **belongs to the class itself**, not to any individual object.

## 1. Static Variable — Class-Level Variable

Shared across **all instances** of the class. One copy in memory regardless of how many objects are created.

```java
public class Employee {
    String name;           // instance variable — each object has its own
    static int count = 0;  // static variable — shared across all objects

    public Employee(String name) {
        this.name = name;
        count++;           // increments the shared counter
    }
}

Employee e1 = new Employee("Alice");
Employee e2 = new Employee("Bob");
Employee e3 = new Employee("Charlie");

System.out.println(Employee.count); // 3 — accessed via class name
```

## 2. Static Method — Class-Level Method

Can be called **without creating an object**. Cannot access instance (non-static) variables directly.

```java
public class MathUtils {
    public static int add(int a, int b) {
        return a + b;
    }

    public static double square(double n) {
        return n * n;
    }
}

// No object needed
int result = MathUtils.add(3, 4);      // 7
double sq  = MathUtils.square(5.0);   // 25.0
```

**Restriction:** Static methods CANNOT access `this` or non-static members directly.

```java
public class Example {
    int x = 10;  // instance variable

    public static void staticMethod() {
        // System.out.println(x);  // ❌ Compile error — x is instance variable
        System.out.println("Static method");
    }
}
```

## 3. Static Block — Class Initialization

Runs **once when the class is first loaded** into memory. Used for one-time initialization.

```java
public class DatabaseConfig {
    static String url;
    static String username;

    static {
        // Runs once when class loads
        url      = System.getenv("DB_URL");
        username = System.getenv("DB_USER");
        System.out.println("DB config loaded");
    }
}
```

## 4. Static Nested Class

A nested class declared static — can exist without an instance of the outer class.

```java
public class Outer {
    static class Inner {
        void display() { System.out.println("Static inner class"); }
    }
}

Outer.Inner obj = new Outer.Inner();  // no Outer instance needed
```

## Static vs Instance

| Feature | static | Instance |
|---------|--------|---------|
| Belongs to | Class | Object |
| Memory | One copy | Per-object copy |
| Access | ClassName.member | object.member |
| `this` keyword | ❌ Not available | ✅ Available |

## In Automation Frameworks

```java
public class DriverManager {
    private static WebDriver driver;  // one shared driver instance

    public static WebDriver getDriver() {
        if (driver == null) {
            driver = new ChromeDriver();
        }
        return driver;
    }
}

// Any test class can call without creating DriverManager object
WebDriver driver = DriverManager.getDriver();
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['static', 'Static Variable', 'Static Method', 'Static Block', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between final, finally, and finalize in Java?',
  'final-finally-finalize-difference-java',
  'final is a keyword to restrict modification; finally is a try-catch block that always runs; finalize is a method called by GC before object destruction.',
  $$## final vs finally vs finalize

These three sound similar but serve completely different purposes.

## 1. final — Keyword to Restrict

### final variable — constant (cannot be reassigned)
```java
final int MAX_RETRY = 3;
MAX_RETRY = 5;  // ❌ compile error — cannot reassign final variable
```

### final method — cannot be overridden
```java
class Parent {
    public final void display() {
        System.out.println("Cannot override this");
    }
}

class Child extends Parent {
    // @Override
    // public void display() { }  // ❌ compile error
}
```

### final class — cannot be extended (subclassed)
```java
public final class String { ... }  // Java's String is final
// class MyString extends String { } // ❌ compile error
```

---

## 2. finally — Always Executes Block

Part of try-catch. The `finally` block **always runs** — whether an exception occurred or not. Used for cleanup (closing connections, drivers, files).

```java
WebDriver driver = null;
try {
    driver = new ChromeDriver();
    driver.get("https://example.com");
    // test logic...

} catch (Exception e) {
    System.out.println("Test failed: " + e.getMessage());

} finally {
    // Always runs — even if test throws exception
    if (driver != null) {
        driver.quit();  // always close the browser
    }
}
```

**finally does NOT run only when:**
- `System.exit()` is called
- JVM crashes

---

## 3. finalize — Called Before GC (Deprecated)

The `finalize()` method is called by the **Garbage Collector** before destroying an object. Deprecated since Java 9 — unreliable, don''t use it.

```java
public class Resource {
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Object being GC'd — cleanup");
        super.finalize();
    }
}
```

**Better alternative:** Use `try-with-resources` or explicit cleanup.

---

## Comparison Table

| Feature | final | finally | finalize |
|---------|-------|---------|---------|
| Type | Keyword | Block | Method |
| Applied to | Variables, Methods, Classes | try-catch block | Object |
| Purpose | Restrict modification | Guaranteed cleanup | Pre-GC cleanup |
| Mandatory? | Optional | Optional | Optional (auto-called) |
| Status | Active | Active | Deprecated (Java 9+) |

## try-with-resources (Modern Alternative to finally)

```java
// Automatically closes resources — no finally needed
try (WebDriver driver = new ChromeDriver()) {
    driver.get("https://example.com");
    // driver.quit() called automatically when try block exits
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['final', 'finally', 'finalize', 'Core Java', 'Keywords', 'Exception Handling'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is inheritance in Java? What are the types of inheritance?',
  'inheritance-types-java',
  'Inheritance allows a child class to acquire properties and methods of a parent class. Java supports Single, Multilevel, and Hierarchical inheritance via classes.',
  $$## Inheritance in Java

**Inheritance** is an OOP mechanism where a **child class (subclass)** acquires the properties and behaviors of a **parent class (superclass)** using the `extends` keyword.

**Purpose:** Code reuse, method overriding, hierarchical classification.

## Types of Inheritance in Java

### 1. Single Inheritance
One child extends one parent.

```java
class Animal {
    public void breathe() {
        System.out.println("Animal breathes");
    }
}

class Dog extends Animal {
    public void bark() {
        System.out.println("Dog barks");
    }
}

Dog d = new Dog();
d.breathe(); // inherited
d.bark();    // own method
```

### 2. Multilevel Inheritance
Chain: Grandparent → Parent → Child.

```java
class Animal {
    public void eat() { System.out.println("Eating"); }
}

class Mammal extends Animal {
    public void breatheAir() { System.out.println("Breathing air"); }
}

class Dog extends Mammal {
    public void bark() { System.out.println("Woof!"); }
}

Dog d = new Dog();
d.eat();        // from Animal
d.breatheAir(); // from Mammal
d.bark();       // own
```

### 3. Hierarchical Inheritance
Multiple children extend the same parent.

```java
class Shape {
    public void draw() { System.out.println("Drawing shape"); }
}

class Circle extends Shape {
    public double area(double r) { return Math.PI * r * r; }
}

class Rectangle extends Shape {
    public double area(double l, double w) { return l * w; }
}
```

### 4. Multiple Inheritance — NOT supported via classes
Java does NOT allow a class to extend multiple classes (to avoid the "Diamond Problem").

```java
// ❌ NOT allowed
class C extends A, B { }  // compile error
```

**Solution:** Use **Interfaces** (a class can implement multiple interfaces).

```java
interface Flyable  { void fly();  }
interface Swimmable { void swim(); }

class Duck implements Flyable, Swimmable {
    public void fly()  { System.out.println("Duck flies"); }
    public void swim() { System.out.println("Duck swims"); }
}
```

## super Keyword

Used to call parent class constructor or methods.

```java
class BasePage {
    WebDriver driver;

    BasePage(WebDriver driver) {
        this.driver = driver;
    }

    public void waitForElement(By locator) {
        new WebDriverWait(driver, Duration.ofSeconds(10))
            .until(ExpectedConditions.visibilityOfElementLocated(locator));
    }
}

class LoginPage extends BasePage {
    LoginPage(WebDriver driver) {
        super(driver);   // calls parent constructor
    }

    public void login(String user, String pass) {
        super.waitForElement(By.id("username")); // calls parent method
        driver.findElement(By.id("username")).sendKeys(user);
    }
}
```

## Inheritance in Automation Frameworks

```java
// Page Object Model uses inheritance
BasePage
  ├── LoginPage
  ├── HomePage
  ├── ProductPage
  └── CheckoutPage
// All inherit WebDriver, wait, and common utility methods from BasePage
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Inheritance', 'extends', 'super', 'Core Java', 'OOP', 'Types of Inheritance'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between an interface and an abstract class in Java?',
  'interface-vs-abstract-class-java',
  'Abstract class can have both abstract and concrete methods with state; interface is a contract with all abstract methods (Java 8+ allows default/static methods).',
  $$## Interface vs Abstract Class in Java

## Abstract Class

A class declared with `abstract` keyword. Can have both **abstract methods** (no body) and **concrete methods** (with body). Can have fields/state.

```java
abstract class Vehicle {
    // Field — state is allowed
    protected String brand;
    protected int speed;

    // Concrete method — has implementation
    public void startEngine() {
        System.out.println(brand + " engine started");
    }

    // Abstract method — subclass MUST implement
    abstract void refuel();

    // Constructor allowed
    Vehicle(String brand) {
        this.brand = brand;
    }
}

class Car extends Vehicle {
    Car(String brand) { super(brand); }

    @Override
    void refuel() { System.out.println("Filling petrol"); }
}
```

## Interface

A pure contract — defines WHAT to do, not HOW. Before Java 8: all methods abstract. Java 8+: allows `default` and `static` methods.

```java
interface Drivable {
    void drive();          // abstract (implicitly public abstract)
    void applyBrakes();    // abstract

    // Java 8+ default method — has body
    default void honk() {
        System.out.println("Beep beep!");
    }

    // Java 8+ static method
    static String getType() { return "Motor Vehicle"; }
}

interface Flyable {
    void fly();
}

// A class can implement MULTIPLE interfaces
class FlyingCar implements Drivable, Flyable {
    public void drive()       { System.out.println("Driving"); }
    public void applyBrakes() { System.out.println("Braking"); }
    public void fly()         { System.out.println("Flying"); }
}
```

## Comparison Table

| Feature | Abstract Class | Interface |
|---------|---------------|-----------|
| `extends` / `implements` | `extends` (one only) | `implements` (multiple) |
| Method types | Abstract + Concrete | Abstract + default + static |
| Fields | Any (static, instance) | Only `public static final` constants |
| Constructor | ✅ Yes | ❌ No |
| Access modifiers | Any | `public` only |
| Multiple inheritance | ❌ One parent only | ✅ Multiple interfaces |
| When to use | IS-A with shared code | CAN-DO contract |

## When to Use Which

**Use Abstract Class when:**
- Classes share common code/state
- IS-A relationship (Car IS-A Vehicle)
- You need constructors or non-public methods

**Use Interface when:**
- Unrelated classes share a capability (Flyable — birds AND planes)
- You want multiple inheritance
- Defining a contract (API design)

## In Automation Frameworks

```java
// Interface — contract for all page objects
interface PageObject {
    boolean isPageLoaded();
    String getPageTitle();
}

// Abstract class — shared Selenium setup
abstract class BasePage implements PageObject {
    protected WebDriver driver;
    protected WebDriverWait wait;

    BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait   = new WebDriverWait(driver, Duration.ofSeconds(10));
        PageFactory.initElements(driver, this);
    }

    // Concrete shared utility
    protected void click(WebElement el) {
        wait.until(ExpectedConditions.elementToBeClickable(el)).click();
    }

    // Subclasses define these
    public abstract boolean isPageLoaded();
    public String getPageTitle() { return driver.getTitle(); }
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Interface', 'Abstract Class', 'Core Java', 'OOP', 'Comparison', 'Inheritance'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are primitive data types in Java?',
  'primitive-data-types-java',
  'Java has 8 primitive types: byte, short, int, long, float, double, boolean, and char. They are not objects and stored on the stack.',
  $$## Primitive Data Types in Java

Java has **8 primitive data types** — the most basic data types, stored on the **stack** (not heap), not objects.

## The 8 Primitive Types

| Type | Size | Default | Range | Example |
|------|------|---------|-------|---------|
| `byte` | 1 byte | 0 | -128 to 127 | `byte b = 100;` |
| `short` | 2 bytes | 0 | -32,768 to 32,767 | `short s = 1000;` |
| `int` | 4 bytes | 0 | -2B to 2B | `int i = 50000;` |
| `long` | 8 bytes | 0L | -9.2Q to 9.2Q | `long l = 9999999999L;` |
| `float` | 4 bytes | 0.0f | ±3.4×10³⁸ | `float f = 3.14f;` |
| `double` | 8 bytes | 0.0 | ±1.7×10³⁰⁸ | `double d = 3.14159;` |
| `boolean` | 1 bit | false | true/false | `boolean flag = true;` |
| `char` | 2 bytes | ' ' | 0 to 65,535 | `char c = 'A';` |

## Examples

```java
byte   age        = 25;
short  year       = 2024;
int    population = 1_400_000_000;  // underscores for readability
long   distance   = 9_460_730_472_580_800L;  // must end with L
float  price      = 9.99f;          // must end with f
double pi         = 3.141592653589793;
boolean isActive  = true;
char   grade      = 'A';

System.out.println((int) 'A');  // 65 — char to int conversion
System.out.println((char) 66);  // 'B' — int to char conversion
```

## Primitives vs Wrapper Classes

Every primitive has a corresponding **Wrapper class** (object):

| Primitive | Wrapper |
|-----------|---------|
| `int` | `Integer` |
| `double` | `Double` |
| `boolean` | `Boolean` |
| `char` | `Character` |
| `long` | `Long` |

```java
// Autoboxing — primitive → object (automatic)
int primitive = 42;
Integer wrapped = primitive;   // autoboxing

// Unboxing — object → primitive (automatic)
Integer obj = 100;
int value = obj;               // unboxing

// Useful for collections (which need objects, not primitives)
List<Integer> numbers = new ArrayList<>();
numbers.add(1);   // autoboxing — int → Integer
int n = numbers.get(0);  // unboxing — Integer → int
```

## Type Casting

```java
// Widening (automatic — no data loss)
int i = 100;
long l = i;        // int → long (safe)
double d = l;      // long → double (safe)

// Narrowing (explicit — possible data loss)
double pi = 3.14;
int truncated = (int) pi;  // 3 — decimal part lost

long big = 1_000_000_000_000L;
int small = (int) big;     // data loss — overflow!
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Primitives', 'Data Types', 'int', 'double', 'boolean', 'Wrapper Classes', 'Core Java'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between ArrayList and Array in Java?',
  'arraylist-vs-array-java',
  'Array is fixed-size and can hold primitives; ArrayList is dynamic, resizable, part of Collections, and holds only objects.',
  $$## ArrayList vs Array in Java

## Array

A **fixed-size, indexed collection** that can hold primitives or objects.

```java
// Declaration and initialization
int[] numbers = new int[5];          // fixed size 5
String[] names = {"Alice", "Bob", "Charlie"};

// Access
System.out.println(names[0]);  // "Alice"
numbers[0] = 10;

// Size is fixed — cannot add/remove
// names[3] = "Dave";  // ArrayIndexOutOfBoundsException if size was 3

// Iterate
for (String name : names) {
    System.out.println(name);
}

System.out.println(names.length);  // 3 — property, not method
```

## ArrayList

A **dynamic, resizable** list from the Collections Framework. Holds only objects (uses autoboxing for primitives).

```java
import java.util.ArrayList;

ArrayList<String> names = new ArrayList<>();

// Add elements
names.add("Alice");
names.add("Bob");
names.add("Charlie");
names.add(1, "Dave");   // insert at index 1

// Access
System.out.println(names.get(0));  // "Alice"

// Size grows automatically
System.out.println(names.size());  // 4 — method

// Remove
names.remove("Bob");    // remove by value
names.remove(0);        // remove by index

// Check
System.out.println(names.contains("Alice")); // true

// Iterate
for (String name : names) {
    System.out.println(name);
}
```

## Comparison Table

| Feature | Array | ArrayList |
|---------|-------|-----------|
| **Size** | Fixed at creation | Dynamic (grows/shrinks) |
| **Primitives** | ✅ int[], double[] | ❌ Must use Integer, Double |
| **Add element** | Not possible | `.add()` |
| **Remove element** | Not possible | `.remove()` |
| **Length/Size** | `.length` (property) | `.size()` (method) |
| **Performance** | Faster (direct memory) | Slightly slower (overhead) |
| **Type-safe** | Yes | Yes (with generics) |
| **Part of** | Core Java | Collections Framework |
| **Multi-dimensional** | ✅ int[][] | ❌ (use List<List<>>) |

## When to Use Which

- **Array:** Fixed number of elements, primitives, performance-critical code
- **ArrayList:** Unknown/changing number of elements, need add/remove operations

## In Automation Testing

```java
// Array — fixed test data
String[] browsers = {"chrome", "firefox", "edge"};

// ArrayList — dynamic collection of WebElements
ArrayList<String> actualOptions = new ArrayList<>();
List<WebElement> dropdownOptions = driver.findElements(By.tagName("option"));
for (WebElement opt : dropdownOptions) {
    actualOptions.add(opt.getText());
}
assertTrue(actualOptions.contains("New York"));
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['ArrayList', 'Array', 'Collections', 'Core Java', 'Data Structures'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is exception handling in Java? Explain try, catch, throw, throws, and finally.',
  'exception-handling-java-try-catch-throw-throws-finally',
  'Exception handling prevents program crashes. try wraps risky code, catch handles errors, finally always runs, throw creates exceptions, throws declares them.',
  $$## Exception Handling in Java

Exception handling prevents **abnormal program termination** when runtime errors occur.

## Exception Hierarchy

```
Throwable
├── Error (JVM errors — don't catch these)
│   ├── OutOfMemoryError
│   └── StackOverflowError
└── Exception
    ├── Checked (must handle — compiler enforces)
    │   ├── IOException
    │   ├── SQLException
    │   └── FileNotFoundException
    └── Unchecked (RuntimeException — optional to handle)
        ├── NullPointerException
        ├── ArrayIndexOutOfBoundsException
        ├── IllegalArgumentException
        └── NumberFormatException
```

## try-catch-finally

```java
public void readFile(String path) {
    FileReader reader = null;
    try {
        reader = new FileReader(path);  // might throw FileNotFoundException
        // risky code
        int data = reader.read();       // might throw IOException

    } catch (FileNotFoundException e) {
        System.out.println("File not found: " + e.getMessage());

    } catch (IOException e) {
        System.out.println("IO error: " + e.getMessage());

    } finally {
        // Always runs — good for cleanup
        try { if (reader != null) reader.close(); } catch (IOException e) {}
    }
}
```

## Multiple Catch + Multi-catch (Java 7+)

```java
try {
    String s = null;
    s.length();  // NullPointerException

} catch (NullPointerException | IllegalArgumentException e) {
    // Handle both with single catch (Java 7+)
    System.out.println("Error: " + e.getMessage());
}
```

## throw — Manually Throw Exception

```java
public void setAge(int age) {
    if (age < 0 || age > 150) {
        throw new IllegalArgumentException("Invalid age: " + age);
    }
    this.age = age;
}

// Caller must handle it
try {
    setAge(-5);
} catch (IllegalArgumentException e) {
    System.out.println(e.getMessage()); // "Invalid age: -5"
}
```

## throws — Declare Exception in Signature

```java
// Method declares it MIGHT throw — caller must handle
public void connectDB() throws SQLException {
    Connection conn = DriverManager.getConnection(url, user, pass);
}

// Caller handles it
try {
    connectDB();
} catch (SQLException e) {
    System.out.println("DB connection failed: " + e.getMessage());
}
```

## Custom Exception

```java
public class InvalidLoginException extends RuntimeException {
    public InvalidLoginException(String message) {
        super(message);
    }
}

// Usage
public void login(String user, String pass) {
    if (!isValid(user, pass)) {
        throw new InvalidLoginException("Invalid credentials for: " + user);
    }
}
```

## try-with-resources (Java 7+)

```java
// Auto-closes resources — no finally needed
try (Connection conn = getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {
    ps.executeQuery();
} catch (SQLException e) {
    e.printStackTrace();
}
```

## In Automation Testing

```java
@Test
public void testLogin() {
    try {
        driver.findElement(By.id("submit")).click();
        String title = driver.getTitle();
        assertEquals("Dashboard", title);

    } catch (NoSuchElementException e) {
        fail("Submit button not found: " + e.getMessage());

    } catch (TimeoutException e) {
        fail("Page took too long to load");

    } finally {
        takeScreenshot("login_test");  // always capture screenshot
    }
}
```$$,
  'Core Java', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Exception Handling', 'try', 'catch', 'finally', 'throw', 'throws', 'Core Java'], true, 0
);
