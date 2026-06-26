-- Java Programs Q31–Q52 (from screenshots batch 2)
-- technology = 'Java Programs', question_type = 'Coding'
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q31
(
  'Write a Java program to check voting eligibility using if-else (age >= 18).',
  'java-prog-q031-if-else-voting',
  'Use if-else with a comparison operator (>=) to check if age meets the threshold. This is the most basic conditional logic pattern in Java — if condition is true execute one block, otherwise execute the else block.',
  $ans$
## If-Else Condition: Voting Eligibility

```java
public class IfElseCondition {
    public static void main(String[] args) {
        int age = 20;

        if (age >= 18) {
            System.out.println("Eligible for vote");
        } else {
            System.out.println("NOT Eligible for vote");
        }
    }
}
```

### Output
```
Eligible for vote
```

### Test with age = 15
```java
int age = 15;
// Output: NOT Eligible for vote
```

### Nested If-Else (multiple conditions)

```java
int age = 20;

if (age < 0) {
    System.out.println("Invalid age");
} else if (age < 18) {
    System.out.println("NOT Eligible for vote (under 18)");
} else if (age < 120) {
    System.out.println("Eligible for vote");
} else {
    System.out.println("Invalid age");
}
```

### Using Ternary Operator

```java
int age = 20;
String result = (age >= 18) ? "Eligible for vote" : "NOT Eligible for vote";
System.out.println(result);
```

### If-Else Syntax Rules

```
if (condition) {
    // runs when condition is TRUE
} else {
    // runs when condition is FALSE
}
```

| Operator | Meaning |
|---|---|
| `==` | equal to |
| `!=` | not equal to |
| `>` | greater than |
| `<` | less than |
| `>=` | greater than or equal to |
| `<=` | less than or equal to |

### Automation Testing Relevance

```java
// Conditional test step based on element state
if (driver.findElement(By.id("modal")).isDisplayed()) {
    driver.findElement(By.id("close-modal")).click();
    System.out.println("Modal closed");
} else {
    System.out.println("No modal, proceeding");
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','If-Else','Conditional','Operators','Basic Program'],
  true, 0
),

-- Q32
(
  'Write a Java program to convert an integer to a String using Integer.toString() and String.valueOf().',
  'java-prog-q032-int-to-string',
  'Integer.toString(i) converts int to String using the Integer wrapper class static method. String.valueOf(i) does the same via the String class. Both produce identical results. A third approach is "" + i (string concatenation). Essential for working with text fields in Selenium.',
  $ans$
## Convert Integer to String in Java

```java
public class ConvertIntegerToString {
    public static void main(String[] args) {

        int i = 123;

        // Method 1: Integer.toString()
        String s = Integer.toString(i);
        System.out.println(s);         // "123"
        System.out.println(s.getClass().getName());  // java.lang.String

        // Method 2: String.valueOf()
        String s2 = String.valueOf(i);
        System.out.println(s2);        // "123"
    }
}
```

### Output
```
123
java.lang.String
123
```

### All Conversion Methods

```java
int num = 456;

// 1. Integer.toString()
String s1 = Integer.toString(num);        // "456"

// 2. String.valueOf()
String s2 = String.valueOf(num);          // "456"

// 3. String concatenation (simplest)
String s3 = "" + num;                     // "456"

// 4. String.format()
String s4 = String.format("%d", num);     // "456"

// All produce identical output
System.out.println(s1.equals(s2));  // true
System.out.println(s2.equals(s3));  // true
```

### Reverse: String to Integer

```java
String s = "789";

// Method 1: Integer.parseInt()
int n1 = Integer.parseInt(s);             // 789

// Method 2: Integer.valueOf()
int n2 = Integer.valueOf(s);              // 789

System.out.println(n1 + 1);  // 790 (arithmetic, not concatenation)
```

### Common Conversions Table

| From | To | Method |
|---|---|---|
| `int` | `String` | `String.valueOf(i)` or `Integer.toString(i)` |
| `String` | `int` | `Integer.parseInt(s)` |
| `double` | `String` | `String.valueOf(d)` or `Double.toString(d)` |
| `String` | `double` | `Double.parseDouble(s)` |
| `boolean` | `String` | `String.valueOf(b)` or `Boolean.toString(b)` |
| `String` | `boolean` | `Boolean.parseBoolean(s)` |

### Automation Testing Relevance

```java
// Getting price from web element and converting for comparison
String priceText = driver.findElement(By.css(".price")).getText();  // "$199"
int price = Integer.parseInt(priceText.replace("$", "").trim());   // 199
assertTrue(price < 500, "Price should be under $500");

// Setting a numeric value into an input field
int qty = 5;
driver.findElement(By.id("quantity")).sendKeys(String.valueOf(qty));
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Type Conversion','Integer','String','parseInt','valueOf'],
  true, 0
),

-- Q33
(
  'Write a Java program to implement Linear Search in an array.',
  'java-prog-q033-linear-search',
  'Linear search (sequential search) checks each element one by one from start to end until the target is found or all elements are exhausted. Time complexity O(n). Works on unsorted arrays unlike binary search which requires sorted data.',
  $ans$
## Linear Search in Java

```java
public class LinearSearch {
    public static void main(String[] args) {
        int array[]         = { 100, 200, 300, 400, 500 };
        int search_element  = 400;
        int c;

        for (c = 0; c < array.length; c++) {
            if (array[c] == search_element) {   // Searching element is present
                System.out.println(search_element +
                    " is present at location " + (c + 1) + ".");
                break;
            }
        }

        if (c == array.length)  /* Element to search isn't present */
            System.out.println(search_element + " isn't present in array.");
    }
}
```

### Output
```
400 is present at location 4.
```

### Using Boolean Flag (Clean Approach)

```java
public class LinearSearchFlag {
    public static void main(String[] args) {
        int[] array        = { 10, 20, 30, 40, 50 };
        int search_element = 30;
        boolean found      = false;

        for (int i = 0; i < array.length; i++) {
            if (array[i] == search_element) {
                System.out.println(search_element + " found at index " + i +
                    " (location " + (i + 1) + ")");
                found = true;
                break;
            }
        }

        if (!found) {
            System.out.println(search_element + " NOT found in array");
        }
    }
}
```

### Search Number Using Enhanced For Loop

```java
int a[] = { 10, 20, 30, 40, 50 };
int num  = 30;
boolean flag = false;

for (int i : a) {
    if (num == i) {
        System.out.println("Element found");
        flag = true;
        break;
    }
}

if (flag == false) {
    System.out.println("Element NOT found");
}
```

### Search String in Array

```java
String[] a = { "abc", "xyz", "pqr", "mno" };
String search_String = "xyz";
boolean flag = false;

for (String s : a) {
    if (search_String.equals(s)) {   // Use .equals() NOT == for Strings
        System.out.println("Element found");
        flag = true;
        break;
    }
}

if (!flag) {
    System.out.println("Element NOT found");
}
```

### Linear vs Binary Search

| | Linear Search | Binary Search |
|---|---|---|
| Array must be sorted | No | Yes |
| Time complexity | O(n) | O(log n) |
| Best for | Small/unsorted arrays | Large sorted arrays |
| Implementation | Simple | Moderate |

### Automation Testing Relevance

```java
// Search for specific text in a list of web elements
List<WebElement> rows = driver.findElements(By.css("table tr"));
boolean found = false;

for (WebElement row : rows) {
    if (row.getText().contains("John Doe")) {
        System.out.println("Record found: " + row.getText());
        found = true;
        break;
    }
}
assertTrue(found, "John Doe not found in table");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Linear Search','Array','Search','Loop','Flag'],
  true, 0
),

-- Q34
(
  'Write a Java program to find the largest of two numbers using if-else.',
  'java-prog-q034-largest-of-two',
  'Compare two integers with if (a > b) — if true a is largest, else b is largest. This simpler form (two numbers) uses plain if-else without the AND (&&) condition needed for three numbers. Also demonstrate Math.max() one-liner.',
  $ans$
## Find Largest of Two Numbers

```java
public class FindLargestOfTwo {
    public static void main(String[] args) {
        int a = 50;
        int b = 20;

        if (a > b) {
            System.out.println("a is largest");
        } else {
            System.out.println("b is largest");
        }
    }
}
```

### Output
```
a is largest
```

### Handle Equal Numbers

```java
int a = 50, b = 20;

if (a > b) {
    System.out.println("a is largest: " + a);
} else if (b > a) {
    System.out.println("b is largest: " + b);
} else {
    System.out.println("Both are equal: " + a);
}
```

### Using Math.max()

```java
int a = 50, b = 20;
int largest = Math.max(a, b);
System.out.println("Largest: " + largest);  // → 50
```

### Using Ternary Operator

```java
int a = 50, b = 20;
int largest = (a > b) ? a : b;
System.out.println("Largest: " + largest);  // → 50
```

### Find Largest of Two Using Scanner

```java
import java.util.Scanner;

public class LargestInput {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter two numbers: ");
        int a = sc.nextInt();
        int b = sc.nextInt();

        System.out.println("Largest: " + Math.max(a, b));
        sc.close();
    }
}
```

### if vs if-else vs if-else-if

```java
// if: runs block only if true, no alternative
if (a > 0) System.out.println("positive");

// if-else: one of two blocks always runs
if (a > b) System.out.println("a"); else System.out.println("b");

// if-else-if: chain for multiple exclusive conditions
if (a > b)       System.out.println("a biggest");
else if (b > a)  System.out.println("b biggest");
else             System.out.println("equal");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','If-Else','Math.max','Comparison','Ternary','Basic Program'],
  true, 0
),

-- Q35
(
  'Write a Java program to find the maximum and minimum elements in an array.',
  'java-prog-q035-max-min-array',
  'Initialize max and min to the first element (array[0]), then iterate from index 1 comparing each element. Update max when array[i] > max, update min when array[i] < min. Two separate loops or one combined loop both work.',
  $ans$
## Max and Min Element in an Array

```java
public class MaxAndMinElementInArray {
    public static void main(String[] args) {
        int array[] = { 10, 100, 20, 50, 5, 60 };

        // Max value in array
        int max = array[0];  // assume first element is max

        for (int i = 1; i < array.length; i++) {
            if (array[i] > max) {
                max = array[i];
            }
        }
        System.out.println("Max Element in array: " + max);

        // Min value in array
        int min = array[0];  // assume first element is min

        for (int i = 1; i < array.length; i++) {
            if (array[i] < min) {
                min = array[i];
            }
        }
        System.out.println("Min Element in array: " + min);
    }
}
```

### Output
```
Max Element in array: 100
Min Element in array: 5
```

### Combined Single Loop (Efficient)

```java
int array[] = { 10, 100, 20, 50, 5, 60 };
int max = array[0], min = array[0];

for (int i = 1; i < array.length; i++) {
    if (array[i] > max) max = array[i];
    if (array[i] < min) min = array[i];
}

System.out.println("Max: " + max);   // 100
System.out.println("Min: " + min);   // 5
```

### Using Arrays and Java 8 Streams

```java
import java.util.Arrays;
import java.util.IntSummaryStatistics;
import java.util.stream.IntStream;

int[] array = { 10, 100, 20, 50, 5, 60 };

// Method 1: Sort and pick ends
Arrays.sort(array);
System.out.println("Min: " + array[0]);
System.out.println("Max: " + array[array.length - 1]);

// Method 2: Streams
IntSummaryStatistics stats = IntStream.of(array).summaryStatistics();
System.out.println("Max: " + stats.getMax());
System.out.println("Min: " + stats.getMin());
System.out.println("Sum: " + stats.getSum());
System.out.println("Avg: " + stats.getAverage());
```

### Find Index of Max Element

```java
int array[] = { 10, 100, 20, 50, 5, 60 };
int maxIndex = 0;

for (int i = 1; i < array.length; i++) {
    if (array[i] > array[maxIndex]) {
        maxIndex = i;
    }
}
System.out.println("Max: " + array[maxIndex] + " at index: " + maxIndex);
// → Max: 100 at index: 1
```

### Automation Testing Relevance

```java
// Find max and min price on a product listing page
List<WebElement> priceElements = driver.findElements(By.css(".product-price"));
int max = 0, min = Integer.MAX_VALUE;

for (WebElement el : priceElements) {
    int price = Integer.parseInt(el.getText().replace("$", "").trim());
    if (price > max) max = price;
    if (price < min) min = price;
}
System.out.println("Price range: $" + min + " - $" + max);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Array','Max','Min','Loop','IntSummaryStatistics'],
  true, 0
),

-- Q36
(
  'Write a Java program to print the day of the week using if-else-if and switch-case.',
  'java-prog-q036-day-of-week',
  'Map integer 1-7 to day names using if-else-if chain or switch-case. switch-case is cleaner for multiple fixed values and falls through to default for invalid input. Both demonstrate multi-branch conditional logic.',
  $ans$
## Day of the Week in Java

### Method 1: if-else-if Chain

```java
public class DayOfWeekIfElse {
    public static void main(String[] args) {
        int day = 5;

        if (day == 1) {
            System.out.println("Sunday");
        } else if (day == 2) {
            System.out.println("Monday");
        } else if (day == 3) {
            System.out.println("Tuesday");
        } else if (day == 4) {
            System.out.println("Wednesday");
        } else if (day == 5) {
            System.out.println("Thursday");
        } else if (day == 6) {
            System.out.println("Friday");
        } else if (day == 7) {
            System.out.println("Saturday");
        } else {
            System.out.println("Invalid week number");
        }
    }
}
```

### Output
```
Thursday
```

### Method 2: switch-case (Cleaner)

```java
public class SwitchCaseStatement {
    public static void main(String[] args) {
        int day = 10;  // invalid

        switch (day) {
            case 1:  System.out.println("Sunday");    break;
            case 2:  System.out.println("Monday");    break;
            case 3:  System.out.println("Tuesday");   break;
            case 4:  System.out.println("Wednesday"); break;
            case 5:  System.out.println("Thursday");  break;
            case 6:  System.out.println("Friday");    break;
            case 7:  System.out.println("Saturday");  break;
            default: System.out.println("Invalid week number");
        }
    }
}
```

### Output
```
Invalid week number
```

### switch vs if-else-if Comparison

| | switch-case | if-else-if |
|---|---|---|
| Best for | Fixed discrete values (int, String, enum) | Range checks, complex conditions |
| Readability | Cleaner for many options | Better for few options |
| Fall-through | Yes (if no break) | No |
| Supports ranges | No | Yes (`if (x > 10 && x < 20)`) |

### Java 14+ Switch Expression (Modern)

```java
int day = 5;
String dayName = switch (day) {
    case 1 -> "Sunday";
    case 2 -> "Monday";
    case 3 -> "Tuesday";
    case 4 -> "Wednesday";
    case 5 -> "Thursday";
    case 6 -> "Friday";
    case 7 -> "Saturday";
    default -> "Invalid";
};
System.out.println(dayName);  // Thursday
```

### Switch with String (Java 7+)

```java
String browser = "chrome";

switch (browser.toLowerCase()) {
    case "chrome":   System.out.println("Launch Chrome");   break;
    case "firefox":  System.out.println("Launch Firefox");  break;
    case "edge":     System.out.println("Launch Edge");     break;
    default:         System.out.println("Unknown browser");
}
```

### Automation Testing Relevance
Switch-case on browser type or environment name is a common pattern in Selenium DriverFactory classes to instantiate the correct WebDriver.
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','switch-case','if-else-if','Day of Week','Conditional'],
  true, 0
),

-- Q37
(
  'Write a Java program to count the number of digits in a number.',
  'java-prog-q037-number-of-digits',
  'Divide the number by 10 repeatedly using integer division (num /= 10), incrementing a count each iteration. Loop ends when num becomes 0. For example 3452 → 345 → 34 → 3 → 0 (4 iterations = 4 digits).',
  $ans$
## Count Number of Digits in a Number

```java
public class NumberOfDigits {
    public static void main(String[] args) {
        int count = 0;
        int num   = 3452;

        while (num != 0) {
            num /= 10;   // 3452 → 345 → 34 → 3 → 0
            ++count;     // increment digit count each iteration
        }

        System.out.println("Number of digits: " + count);
    }
}
```

### Output
```
Number of digits: 4
```

### Step-by-Step Trace

```
num=3452, count=0
Iteration 1: num = 3452/10 = 345,  count = 1
Iteration 2: num = 345/10  = 34,   count = 2
Iteration 3: num = 34/10   = 3,    count = 3
Iteration 4: num = 3/10    = 0,    count = 4
Loop ends (num == 0)

Result: 4 digits
```

### One-liner Using String Length

```java
int num = 3452;
int digits = String.valueOf(Math.abs(num)).length();
System.out.println("Digits: " + digits);  // 4
```

### Handle Negative Numbers

```java
public static int countDigits(int num) {
    if (num == 0) return 1;            // special case: 0 has 1 digit
    num = Math.abs(num);               // handle negatives: -345 → 345
    int count = 0;
    while (num != 0) {
        num /= 10;
        count++;
    }
    return count;
}

System.out.println(countDigits(0));       // 1
System.out.println(countDigits(12345));   // 5
System.out.println(countDigits(-999));    // 3
System.out.println(countDigits(1000000)); // 7
```

### Using Math.log10() (Mathematical)

```java
int num = 3452;
int digits = (int) Math.log10(num) + 1;
System.out.println("Digits: " + digits);  // 4
// log10(3452) ≈ 3.537 → (int)3.537 = 3 → 3+1 = 4
```

### Automation Testing Relevance

```java
// Validate phone number digit count
String phone = driver.findElement(By.id("phone")).getAttribute("value");
int digitCount = phone.replaceAll("[^0-9]", "").length();
assertEquals(digitCount, 10, "Phone number must be 10 digits");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Digits','While Loop','Math.log10','Number','Integer Division'],
  true, 0
),

-- Q38
(
  'Write a Java program to check if a number is a palindrome (e.g., 121, 171).',
  'java-prog-q038-number-palindrome',
  'A number is a palindrome if reversing its digits gives the same number (e.g., 121 reversed is 121). Reverse using: lastDigit = a % 10, sum = (sum*10) + lastDigit, a = a/10. Compare reversed sum to original inputNumber.',
  $ans$
## Check if a Number is Palindrome

```java
public class Palindrome {
    public static void main(String[] args) {
        int lastDigit, sum = 0, a;
        int inputNumber = 171;

        a = inputNumber;

        // Code to reverse a number
        while (a > 0) {
            System.out.println("Input Number " + a);

            lastDigit = a % 10;               // extract last digit
            System.out.println("Last Digit " + lastDigit);

            System.out.println("Digit " + lastDigit +
                " was added to sum " + (sum * 10));

            sum = (sum * 10) + lastDigit;     // build reversed number
            a   = a / 10;                     // remove last digit
        }

        // If reversed number equals original → palindrome
        if (sum == inputNumber)
            System.out.println("Number is palindrome");
        else
            System.out.println("Number is not palindrome");
    }
}
```

### Output (for 171)
```
Input Number 171
Last Digit 1
Digit 1 was added to sum 0
Input Number 17
Last Digit 7
Digit 7 was added to sum 10
Input Number 1
Last Digit 1
Digit 1 was added to sum 170
Number is palindrome
```

### Clean Version

```java
public class NumberPalindromeClean {
    public static void main(String[] args) {
        int inputNumber = 121;
        int original    = inputNumber;
        int reversed    = 0;

        while (inputNumber > 0) {
            int lastDigit = inputNumber % 10;
            reversed      = (reversed * 10) + lastDigit;
            inputNumber   = inputNumber / 10;
        }

        if (reversed == original)
            System.out.println(original + " is a Palindrome number");
        else
            System.out.println(original + " is NOT a Palindrome number");
    }
}
```

### Test Multiple Numbers

```java
int[] numbers = { 121, 131, 171, 123, 1001, 1221 };

for (int num : numbers) {
    int reversed = 0, temp = num;
    while (temp > 0) {
        reversed = reversed * 10 + temp % 10;
        temp /= 10;
    }
    System.out.println(num + " → " + (reversed == num ? "Palindrome" : "Not Palindrome"));
}
```

### Output
```
121 → Palindrome
131 → Palindrome
171 → Palindrome
123 → Not Palindrome
1001 → Not Palindrome
1221 → Palindrome
```

### Number vs String Palindrome

| | Number Palindrome | String Palindrome |
|---|---|---|
| Input | `int num = 121` | `String s = "madam"` |
| Method | Reverse digits with `% 10` | Reverse with `StringBuilder.reverse()` |
| Compare | `reversed == original` | `rev.equals(s)` |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Palindrome','Number','While Loop','Modulus','Reverse'],
  true, 0
),

-- Q39
(
  'Write a Java program to check if a string is a palindrome using a for loop and StringBuffer.',
  'java-prog-q039-palindrome-string',
  'Reverse the string using a for loop (iterate from length-1 to 0, append charAt(i)), then compare with original using .equals(). StringBuffer.reverse() provides a one-line alternative. String "DAD" reversed is "DAD" — palindrome.',
  $ans$
## Palindrome String Check in Java

```java
public class PalindromeString {
    public static void main(String[] args) {
        String s = "DAD";

        // Method 1: Using for loop
        int len        = s.length();    // 3
        String rev     = "";

        for (int i = len - 1; i >= 0; i--) {
            rev = rev + s.charAt(i);    // build reversed string
        }

        System.out.println("Reversed: " + rev);

        if (s.equals(rev)) {
            System.out.println("Palindrome string");
        } else {
            System.out.println("Not Palindrome string");
        }

        // Method 2: Using StringBuffer class (one-liner)
        StringBuffer sf = new StringBuffer(s);
        System.out.println("StringBuffer reversed: " + sf.reverse());
    }
}
```

### Output
```
Reversed: DAD
Palindrome string
StringBuffer reversed: DAD
```

### Case-Insensitive Palindrome Check

```java
String s = "Madam";

String cleaned = s.toLowerCase().replaceAll("\\s+", "");  // "madam"
String rev     = new StringBuffer(cleaned).reverse().toString();

System.out.println(s + " → " + (cleaned.equals(rev) ? "Palindrome" : "Not Palindrome"));
// Madam → Palindrome
```

### Reusable Method

```java
public static boolean isPalindromeString(String s) {
    String rev = new StringBuilder(s).reverse().toString();
    return s.equalsIgnoreCase(rev);
}

String[] words = { "DAD", "MADAM", "RACECAR", "HELLO", "LEVEL", "JAVA" };
for (String w : words) {
    System.out.println(w + " → " + (isPalindromeString(w) ? "Palindrome" : "Not Palindrome"));
}
```

### Output
```
DAD     → Palindrome
MADAM   → Palindrome
RACECAR → Palindrome
HELLO   → Not Palindrome
LEVEL   → Palindrome
JAVA    → Not Palindrome
```

### Key Difference: String vs StringBuffer vs StringBuilder

| Class | Mutable | Thread-safe | reverse() |
|---|---|---|---|
| `String` | No | Yes (immutable) | No |
| `StringBuffer` | Yes | Yes (synchronized) | Yes |
| `StringBuilder` | Yes | No | Yes (preferred) |

Use `StringBuilder` in single-threaded code (faster), `StringBuffer` in multi-threaded.
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Palindrome','String','StringBuffer','StringBuilder','charAt'],
  true, 0
),

-- Q40
(
  'Write a Java program to check if a number is positive or negative.',
  'java-prog-q040-positive-or-negative',
  'Use if (num > 0) for positive and else for negative. Zero is neither positive nor negative — add else-if (num == 0) for completeness. Simple conditional logic using comparison operators.',
  $ans$
## Check Positive or Negative Number

```java
public class PositiveOrNegativeNumber {
    public static void main(String[] args) {
        int num = 10;   // positive
        // int num = -10;  // Negative

        if (num > 0) {
            System.out.println("Number is Positive");
        } else {
            System.out.println("Number is Negative");
        }
    }
}
```

### Output
```
Number is Positive
```

### Handle Zero (Complete Version)

```java
int num = 0;

if (num > 0) {
    System.out.println(num + " is Positive");
} else if (num < 0) {
    System.out.println(num + " is Negative");
} else {
    System.out.println("Number is Zero");
}
```

### Using Ternary Operator

```java
int num = -5;
String result = (num > 0) ? "Positive" : (num < 0) ? "Negative" : "Zero";
System.out.println(num + " is " + result);  // -5 is Negative
```

### Test Multiple Numbers

```java
int[] numbers = { 15, -3, 0, 100, -99, 7 };

for (int num : numbers) {
    if (num > 0)       System.out.println(num + " → Positive");
    else if (num < 0)  System.out.println(num + " → Negative");
    else               System.out.println(num + " → Zero");
}
```

### Output
```
15  → Positive
-3  → Negative
0   → Zero
100 → Positive
-99 → Negative
7   → Positive
```

### Automation Testing Relevance

```java
// Validate that price difference is not negative (no discount exceeds price)
double originalPrice  = 100.0;
double discountedPrice = 80.0;
double difference      = originalPrice - discountedPrice;

if (difference >= 0) {
    System.out.println("Valid discount: -$" + difference);
} else {
    System.out.println("INVALID: Discounted price exceeds original");
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Positive','Negative','If-Else','Ternary','Conditional'],
  true, 0
),

-- Q41
(
  'Write a Java program to remove duplicate elements from an ArrayList using HashSet.',
  'java-prog-q041-remove-duplicates-hashset',
  'Convert ArrayList to HashSet (HashSet rejects duplicate adds automatically), then convert back to ArrayList. HashSet does NOT preserve insertion order. Use LinkedHashSet to preserve insertion order when order matters.',
  $ans$
## Remove Duplicates from ArrayList Using HashSet

```java
import java.util.ArrayList;
import java.util.HashSet;

public class RemoveDuplicatesFromArrayList {
    public static void main(String[] args) {

        // Constructing An ArrayList with duplicate elements
        ArrayList listWithDuplicateElements = new ArrayList();

        listWithDuplicateElements.add("JAVA");
        listWithDuplicateElements.add("J2EE");
        listWithDuplicateElements.add("JSP");
        listWithDuplicateElements.add("SERVLETS");
        listWithDuplicateElements.add("JAVA");      // duplicate
        listWithDuplicateElements.add("STRUTS");
        listWithDuplicateElements.add("JSP");       // duplicate

        // Printing listWithDuplicateElements
        System.out.print("ArrayList With Duplicate Elements: ");
        System.out.println(listWithDuplicateElements);

        // Constructing HashSet from ArrayList (removes duplicates)
        HashSet set = new HashSet(listWithDuplicateElements);

        // Constructing listWithoutDuplicateElements using set
        ArrayList listWithoutDuplicateElements = new ArrayList(set);

        // Printing listWithoutDuplicateElements
        System.out.print("ArrayList After Removing Duplicate Elements: ");
        System.out.println(listWithoutDuplicateElements);
    }
}
```

### Output
```
ArrayList With Duplicate Elements: [JAVA, J2EE, JSP, SERVLETS, JAVA, STRUTS, JSP]
ArrayList After Removing Duplicate Elements: [JAVA, J2EE, STRUTS, SERVLETS, JSP]
```

### Preserve Insertion Order → Use LinkedHashSet

```java
import java.util.LinkedHashSet;

ArrayList<String> list = new ArrayList<>();
list.add("JAVA"); list.add("J2EE"); list.add("JSP");
list.add("SERVLETS"); list.add("JAVA"); list.add("STRUTS"); list.add("JSP");

// LinkedHashSet preserves order + removes duplicates
LinkedHashSet<String> set = new LinkedHashSet<>(list);
ArrayList<String> result  = new ArrayList<>(set);

System.out.println(result);
// → [JAVA, J2EE, JSP, SERVLETS, STRUTS]  (order preserved)
```

### HashSet vs LinkedHashSet vs TreeSet

| | HashSet | LinkedHashSet | TreeSet |
|---|---|---|---|
| Duplicates | Not allowed | Not allowed | Not allowed |
| Order | No order | Insertion order | Sorted order |
| Null allowed | One null | One null | No null |
| Performance | O(1) | O(1) | O(log n) |
| Use when | Just remove dups | Remove + preserve order | Remove + sort |

### Automation Testing Relevance

```java
// Remove duplicate window handles
Set<String> handles = driver.getWindowHandles();
// getWindowHandles() already returns a Set (no duplicates)

// Remove duplicate element texts from a list
List<WebElement> items = driver.findElements(By.css(".tag"));
List<String> texts = items.stream().map(WebElement::getText).collect(Collectors.toList());
ArrayList<String> uniqueTexts = new ArrayList<>(new LinkedHashSet<>(texts));
System.out.println("Unique tags: " + uniqueTexts);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','ArrayList','HashSet','LinkedHashSet','Duplicates','Collections'],
  true, 0
),

-- Q42
(
  'Write a Java program to remove junk/special characters from a string using replaceAll() with regex.',
  'java-prog-q042-remove-junk-characters',
  'Use String.replaceAll() with the regex pattern [^a-zA-Z0-9] to match any character that is NOT a letter or digit, replacing it with an empty string "". The caret ^ inside [] means negation (NOT these characters).',
  $ans$
## Remove Junk/Special Characters from String

```java
public class RemoveJunk {
    public static void main(String[] args) {

        String s  = "â°?ç±³å¥½éQç¸~ latin string 0123456789 0";
        String s1 = "@#$@#$@ testing #@$@#$@$ Selenium !@#$@#$@ &&&&  Java";

        // Regular Expression: [^a-zA-Z0-9]
        // ^ inside [] means NOT: remove everything that is NOT a letter or digit
        s  = s.replaceAll("[^a-zA-Z0-9]", "");
        System.out.println(s);   // → latinstrinq01234567890

        s1 = s1.replaceAll("[^a-zA-Z0-9]", "");
        System.out.println(s1);  // → testingSeleniumJava
    }
}
```

### Output
```
latinstrinq01234567890
testingSeleniumJava
```

### Common Regex Patterns for String Cleaning

```java
String s = "@#$Hello, World!!! 123   ";

// Remove all special characters (keep only letters and digits)
s.replaceAll("[^a-zA-Z0-9]", "");            // "HelloWorld123"

// Keep letters, digits, and spaces
s.replaceAll("[^a-zA-Z0-9 ]", "");           // "Hello World 123"

// Remove only digits
s.replaceAll("[0-9]", "");                   // "@#$Hello, World!!!   "

// Remove only special characters (keep letters, digits, spaces)
s.replaceAll("[^\\w\\s]", "");               // "Hello World 123   "

// Remove leading/trailing whitespace
s.trim();                                    // "@#$Hello, World!!! 123"

// Remove ALL whitespace (spaces, tabs, newlines)
s.replaceAll("\\s", "");                     // "@#$Hello,World!!!123"
s.replaceAll("\\s+", "");                    // same result

// Remove multiple spaces (collapse to single space)
s.replaceAll("\\s+", " ").trim();            // "@#$Hello, World!!! 123"
```

### Regex Quick Reference

| Pattern | Meaning |
|---|---|
| `[a-zA-Z0-9]` | Letters and digits |
| `[^a-zA-Z0-9]` | NOT letters or digits (special chars) |
| `\\s` | Whitespace (space, tab, newline) |
| `\\d` | Digit (0-9) |
| `\\w` | Word character (letter, digit, underscore) |
| `.` | Any single character |
| `+` | One or more |
| `*` | Zero or more |

### Automation Testing Relevance

```java
// Clean currency text for numeric comparison
String priceText = "$1,299.00";
String cleanPrice = priceText.replaceAll("[^0-9.]", "");  // "1299.00"
double price = Double.parseDouble(cleanPrice);

// Validate that a field contains no special characters
String username = driver.findElement(By.id("username")).getAttribute("value");
String cleaned = username.replaceAll("[^a-zA-Z0-9_]", "");
assertEquals(username, cleaned, "Username contains invalid characters");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','String','replaceAll','Regex','Special Characters','Clean'],
  true, 0
),

-- Q43
(
  'Write a Java program to remove all whitespace characters from a string.',
  'java-prog-q043-remove-whitespace',
  'Use String.replaceAll("\\s", "") to replace every whitespace character (space, tab, newline, carriage return) with empty string. \\s matches all whitespace. Use trim() only to remove leading/trailing spaces, not internal spaces.',
  $ans$
## Remove Whitespace from a String

```java
public class RemoveWhiteSpacesInaString {
    public static void main(String[] args) {
        String str = " Core Java selenium automation oops programming ";

        String strWithoutSpace = str.replaceAll("\\s", "");

        System.out.println("Original: '" + str + "'");
        System.out.println("Without spaces: '" + strWithoutSpace + "'");
    }
}
```

### Output
```
Original: ' Core Java selenium automation oops programming '
Without spaces: 'CoreJavaseleniomautomationoopsprogramming'
```

### Different Whitespace Removal Options

```java
String str = "  Core  Java  Selenium  Testing  ";

// 1. Remove ALL whitespace (spaces, tabs, newlines)
System.out.println(str.replaceAll("\\s", ""));
// → CoreJavaSeleniumTesting

// 2. Remove only leading and trailing whitespace
System.out.println(str.trim());
// → "Core  Java  Selenium  Testing"

// 3. Remove only leading whitespace
System.out.println(str.replaceAll("^\\s+", ""));
// → "Core  Java  Selenium  Testing  "

// 4. Remove only trailing whitespace
System.out.println(str.replaceAll("\\s+$", ""));
// → "  Core  Java  Selenium  Testing"

// 5. Collapse multiple spaces into single space
System.out.println(str.trim().replaceAll("\\s+", " "));
// → "Core Java Selenium Testing"

// 6. Java 11+ strip() — handles Unicode whitespace too
System.out.println(str.strip());         // trim + Unicode whitespace
System.out.println(str.stripLeading());  // leading only
System.out.println(str.stripTrailing()); // trailing only
```

### \\s vs \\s+ Difference

```java
String str = "Hello   World";

str.replaceAll("\\s", "");   // removes each space individually → "HelloWorld"
str.replaceAll("\\s+", " "); // replaces groups of spaces with single space → "Hello World"
```

### Automation Testing Relevance

```java
// Handle unpredictable whitespace in element text
String elementText = driver.findElement(By.css(".title")).getText();
String cleanText   = elementText.trim().replaceAll("\\s+", " ");  // normalize spaces

// Compare text ignoring whitespace differences
String expected = "Confirm Order";
String actual   = driver.findElement(By.id("btn")).getText().trim();
assertEquals(actual, expected, "Button text mismatch");

// Remove whitespace when checking phone number format
String phone   = driver.findElement(By.id("phone")).getText();
String digits  = phone.replaceAll("\\s", "");  // "(555) 123 4567" → "5551234567"
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','replaceAll','Whitespace','trim','Regex'],
  true, 0
),

-- Q44
(
  'Write a Java program to reverse characters of a string using a method with input validation.',
  'java-prog-q044-reverse-chars-method',
  'Create a method reverseCharacters() that loops from the last index to 0 using charAt() to build the reversed string. In main(), read input with Scanner and validate non-empty using isEmpty(). Demonstrates method decomposition and input validation.',
  $ans$
## Reverse Characters of a String (With Method and Validation)

```java
import java.util.Scanner;

public class ReverseChars {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        System.out.println("Please enter a string: ");

        String original = scan.nextLine();

        // Input validation: reject empty or null strings
        while (original.isEmpty() || original == null) {
            System.out.println(
                "Please enter a valid string, empty and null strings are not accepted:");
            original = scan.nextLine();
        }
        scan.close();

        // Call method to reverse
        ReverseChars output = new ReverseChars();
        String reverseCharacters = output.reverseCharacters(original);
        System.out.println(reverseCharacters);
    }

    private String reverseCharacters(String originalString) {
        String reverse = "";

        for (int i = originalString.length() - 1; i >= 0; i--) {
            reverse = reverse + originalString.charAt(i);
        }
        return reverse;
    }
}
```

### Sample Input/Output
```
Please enter a string:
Automation
noitamotuA
```

### Improved Validation (Correct Order)

```java
String original = scan.nextLine();

// Fix: check for null BEFORE calling isEmpty()
// In practice scan.nextLine() never returns null, but for safety:
while (original == null || original.trim().isEmpty()) {
    System.out.println("Please enter a non-empty string:");
    original = scan.nextLine();
}
```

### StringBuilder Version (Faster)

```java
private String reverseCharacters(String str) {
    return new StringBuilder(str).reverse().toString();
}
```

### Reverse Words (Not Characters)

```java
String sentence = "Hello World Java";
String[] words   = sentence.split(" ");
StringBuilder reversed = new StringBuilder();

for (int i = words.length - 1; i >= 0; i--) {
    reversed.append(words[i]);
    if (i > 0) reversed.append(" ");
}

System.out.println(reversed);  // "Java World Hello"
```

### Automation Testing Relevance

```java
// Verify reversed text (CAPTCHA alternative validation)
public String reverseText(String text) {
    return new StringBuilder(text).reverse().toString();
}

// Verify order ID displayed in reverse on confirmation page
String orderId       = "ORD-12345";
String expectedDisplay = reverseText(orderId);  // "54321-DRO"
String actualDisplay = driver.findElement(By.id("order-display")).getText();
assertEquals(actualDisplay, expectedDisplay);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Reverse','charAt','Scanner','Method','Validation'],
  true, 0
),

-- Q45
(
  'Write a Java program to reverse each word in a sentence individually.',
  'java-prog-q045-reverse-each-word',
  'Split the sentence by space into words array, then reverse each individual word using a nested loop (charAt from end to start). Concatenate reversed words with spaces. Different from reversing the whole string or reversing word order.',
  $ans$
## Reverse Each Word in a String

```java
public class ReverseEachWord {

    public static void main(String[] args) {
        reverseEachWordOfString("Java Concept Of The Day");
        reverseEachWordOfString("Java J2EE JSP Servlets Hibernate Struts");
        reverseEachWordOfString("I am string not reversed");
        reverseEachWordOfString("Reverse Me");
    }

    static void reverseEachWordOfString(String inputString) {
        // Step 1: split by space into individual words
        String[] words = inputString.split(" ");

        String reverseString = "";

        // Step 2: reverse each word individually
        for (int i = 0; i < words.length; i++) {
            String word        = words[i];
            String reverseWord = "";

            // Reverse individual word characters
            for (int j = word.length() - 1; j >= 0; j--) {
                reverseWord = reverseWord + word.charAt(j);
            }

            reverseString = reverseString + reverseWord + " ";
        }

        System.out.println(inputString);
        System.out.println(reverseString);
        System.out.println("---------------------------");
    }
}
```

### Output
```
Java Concept Of The Day
avaJ tpecnoC fO ehT yaD
---------------------------
Java J2EE JSP Servlets Hibernate Struts
avaJ EE2J PSJ stelvreS etanrebiH struts
---------------------------
I am string not reversed
I ma gnirts ton desrever
---------------------------
Reverse Me
esreveR eM
---------------------------
```

### Cleaner Version Using StringBuilder

```java
public static String reverseEachWord(String sentence) {
    String[] words = sentence.split(" ");
    StringBuilder result = new StringBuilder();

    for (String word : words) {
        result.append(new StringBuilder(word).reverse());
        result.append(" ");
    }

    return result.toString().trim();
}

System.out.println(reverseEachWord("Hello World"));       // olleH dlroW
System.out.println(reverseEachWord("Selenium Testing"));  // muineLeS gnitseT
```

### Three Different "Reverse" Operations Compared

```java
String s = "Java Selenium Testing";

// 1. Reverse entire string (characters)
new StringBuilder(s).reverse()
// → "gnitseT muineLeS avaJ"

// 2. Reverse each word (keep word order)
reverseEachWord(s)
// → "avaJ muineLeS gnitseT"

// 3. Reverse word order (keep characters in each word)
String[] words = s.split(" ");
Collections.reverse(Arrays.asList(words));
String.join(" ", words)
// → "Testing Selenium Java"
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','String','Reverse Words','split','charAt','StringBuilder'],
  true, 0
),

-- Q46
(
  'Write a Java program to reverse a number using algorithm and StringBuffer.',
  'java-prog-q046-reverse-number-two-methods',
  'Two approaches: (1) Algorithm — extract last digit with % 10, build reversed by rev = rev*10 + digit, remove digit with /10 in a while loop. (2) StringBuffer.reverse() — convert long to String, wrap in StringBuffer, call reverse(). Both produce the same result.',
  $ans$
## Reverse a Number — Two Methods

```java
public class ReverseNumber {
    public static void main(String[] args) {

        // Method 1: Using algorithm (mathematical approach)
        long num = 12345;  // result: 54321
        long rev = 0;

        while (num != 0) {
            rev = rev * 10 + num % 10;   // extract last digit and build reversed
            num = num / 10;               // remove last digit
        }

        System.out.println("Reverse num is: " + rev);  // 54321

        // Method 2: Using StringBuffer
        long num1 = 12345;
        System.out.println(new StringBuffer(String.valueOf(num1)).reverse());  // 54321
    }
}
```

### Output
```
Reverse num is: 54321
54321
```

### Step-by-Step Trace (Algorithm)

```
num=12345, rev=0

Loop 1: rev = 0*10 + 12345%10 = 5,    num = 12345/10 = 1234
Loop 2: rev = 5*10 + 1234%10  = 54,   num = 1234/10  = 123
Loop 3: rev = 54*10 + 123%10  = 543,  num = 123/10   = 12
Loop 4: rev = 543*10 + 12%10  = 5432, num = 12/10    = 1
Loop 5: rev = 5432*10 + 1%10  = 54321,num = 1/10     = 0
Loop ends → 54321
```

### Reverse Negative Number

```java
long num = -12345;
boolean negative = num < 0;
num = Math.abs(num);  // work with positive

long rev = 0;
while (num != 0) {
    rev = rev * 10 + num % 10;
    num /= 10;
}

if (negative) rev = -rev;
System.out.println(rev);  // -54321
```

### Check Palindrome Number Using Reverse

```java
long original = 121;
long temp     = original;
long reversed = 0;

while (temp > 0) {
    reversed = reversed * 10 + temp % 10;
    temp /= 10;
}

System.out.println(original == reversed
    ? original + " is palindrome"
    : original + " is not palindrome");
// → 121 is palindrome
```

### StringBuffer vs StringBuilder for Reverse

```java
// StringBuffer (thread-safe, slightly slower)
new StringBuffer("12345").reverse().toString()  // "54321"

// StringBuilder (not thread-safe, faster)
new StringBuilder("12345").reverse().toString() // "54321"
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Reverse Number','Algorithm','StringBuffer','While Loop','Modulus'],
  true, 0
),

-- Q47
(
  'Write a Java program to reverse a string using a for loop and StringBuffer (with Scanner input).',
  'java-prog-q047-reverse-string-scanner',
  'Read string from user using Scanner.nextLine(), then reverse using: (1) for loop iterating from length-1 to 0 with charAt(), (2) StringBuffer constructor — new StringBuffer(s).reverse(). Both produce the same reversed output.',
  $ans$
## Reverse a String Using For Loop and StringBuffer

```java
import java.util.Scanner;

public class ReverseString {
    public static void main(String[] args) {
        // Reverse a String using for loop and StringBuffer
        System.out.println("Enter the string:");

        Scanner sc = new Scanner(System.in);
        String s   = sc.nextLine();

        // Method 1: Using for loop
        int len    = s.length();
        String rev = "";

        for (int i = len - 1; i >= 0; i--) {
            rev = rev + s.charAt(i);   // build reversed string char by char
        }

        System.out.println("Reversed (for loop): " + rev);

        // Method 2: Using StringBuffer class
        StringBuffer sf = new StringBuffer(s);
        System.out.println("Reversed (StringBuffer): " + sf.reverse());
    }
}
```

### Sample Input/Output
```
Enter the string:
Selenium
Reversed (for loop): muineLeS
Reversed (StringBuffer): muineLeS
```

### Method Comparison

```java
String s = "AutomationTesting";

// 1. For loop (manual, educational)
String rev = "";
for (int i = s.length() - 1; i >= 0; i--)
    rev += s.charAt(i);
// → "gnitseT noitamotuA"

// 2. StringBuffer (Java classic)
String rev2 = new StringBuffer(s).reverse().toString();
// → "gnitseT noitamotuA"

// 3. StringBuilder (Java 5+ preferred)
String rev3 = new StringBuilder(s).reverse().toString();
// → "gnitseT noitamotuA"

// 4. char array swap
char[] arr = s.toCharArray();
int l = 0, r = arr.length - 1;
while (l < r) {
    char t = arr[l]; arr[l++] = arr[r]; arr[r--] = t;
}
String rev4 = new String(arr);
// → "gnitseT noitamotuA"
```

### Performance Note

| Method | Time | Space | Best for |
|---|---|---|---|
| `+= charAt(i)` | O(n²) | O(n) | Learning only |
| `StringBuilder` | O(n) | O(n) | Preferred |
| char swap | O(n) | O(n) | In-place feel |

Avoid `String +=` in a loop for large strings — each concatenation creates a new String object. Use `StringBuilder.append()` instead.
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Reverse','StringBuffer','StringBuilder','Scanner','charAt'],
  true, 0
),

-- Q48
(
  'Write a Java program to demonstrate single-dimensional array operations including break inside a for loop.',
  'java-prog-q048-single-dim-array',
  'Declare a 1D array with values (without specifying size — Java infers it), print all elements, then demonstrate break by stopping the loop early when a condition is met. a.length gives element count.',
  $ans$
## Single-Dimensional Array in Java

```java
public class SingleDimArray {
    public static void main(String[] args) {

        // Declare an array without size — store values directly
        int a[] = { 100, 200, 300, 400, 500 };

        System.out.println("Array length: " + a.length);   // 5

        // Print all elements using enhanced for loop
        System.out.println("All elements:");
        for (int i : a) {
            System.out.println(i);
        }

        // How to break out of for loop in the middle
        System.out.println("\nBreak when element == 400:");
        for (int i : a) {
            if (i == 400) {
                break;             // stops loop immediately when 400 is reached
            }
            System.out.println(i);
        }
    }
}
```

### Output
```
Array length: 5
All elements:
100
200
300
400
500

Break when element == 400:
100
200
300
```

### Array Declaration Styles

```java
// Style 1: Declare with size, assign later
int[] a = new int[5];
a[0] = 100; a[1] = 200; // ...

// Style 2: Declare with values (size inferred)
int a[] = { 100, 200, 300, 400, 500 };

// Style 3: new int[] with values
int[] a = new int[]{ 100, 200, 300, 400, 500 };
```

### break vs continue vs return

```java
int[] arr = { 1, 2, 3, 4, 5 };

// break: exits the entire loop
for (int i : arr) {
    if (i == 3) break;
    System.out.print(i + " ");  // → 1 2
}

// continue: skips current iteration, continues loop
for (int i : arr) {
    if (i == 3) continue;
    System.out.print(i + " ");  // → 1 2 4 5
}

// return: exits the entire method
```

### Common Array Operations

```java
int[] a = { 100, 200, 300, 400, 500 };

System.out.println(a.length);          // 5
System.out.println(a[0]);              // 100 (first)
System.out.println(a[a.length - 1]);   // 500 (last)
System.out.println(Arrays.toString(a));// [100, 200, 300, 400, 500]

Arrays.sort(a);                        // sort in-place
int idx = Arrays.binarySearch(a, 300); // search after sort
```

### Automation Testing Relevance

```java
// Process test data from array with early exit
String[] testUrls = { "/home", "/products", "/cart", "/broken-page", "/checkout" };

for (String url : testUrls) {
    driver.get(baseUrl + url);
    if (driver.getTitle().contains("Error")) {
        System.out.println("Broken page found: " + url);
        break;   // stop testing if broken page found
    }
    System.out.println("OK: " + url);
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Array','1D Array','break','for loop','Enhanced For'],
  true, 0
),

-- Q49
(
  'Write a Java program to swap two strings without using a third variable.',
  'java-prog-q049-string-swapping',
  'Swap two strings without a temp variable: (1) append b to a: a = a+b, (2) extract original a by substring: b = a.substring(0, a.length()-b.length()), (3) extract original b: a = a.substring(b.length()). Uses String length difference.',
  $ans$
## Swap Two Strings Without Third Variable

```java
public class StringSwapping {
    public static void main(String[] args) {
        String a = "Hello";
        String b = "World";

        System.out.println("before swapping: ");
        System.out.println("the value of a is: " + a);
        System.out.println("the value of b is: " + b);

        // Step 1: append a and b
        a = a + b;   // a = "HelloWorld"

        // Step 2: store initial string a in String b
        b = a.substring(0, a.length() - b.length());
        // b = "HelloWorld".substring(0, 10-5) = "HelloWorld".substring(0,5) = "Hello"

        // Step 3: store initial string b in String a
        a = a.substring(b.length());
        // a = "HelloWorld".substring(5) = "World"

        System.out.println("the value of a and b after swapping: ");
        System.out.println("the value of a is: " + a);
        System.out.println("the value of b is: " + b);
    }
}
```

### Output
```
before swapping:
the value of a is: Hello
the value of b is: World
the value of a and b after swapping:
the value of a is: World
the value of b is: Hello
```

### Step-by-Step Trace

```
a = "Hello" (length=5)
b = "World" (length=5)

Step 1: a = a + b = "HelloWorld"  (length=10)

Step 2: b = a.substring(0, a.length()-b.length())
           = "HelloWorld".substring(0, 10-5)
           = "HelloWorld".substring(0, 5)
           = "Hello"

Step 3: a = a.substring(b.length())
           = "HelloWorld".substring(5)
           = "World"

Result: a="World", b="Hello"  ✓
```

### Simpler: Using Temp Variable (Standard Practice)

```java
String a = "Hello";
String b = "World";
String temp = a;
a = b;
b = temp;
System.out.println("a=" + a + ", b=" + b);  // a=World, b=Hello
```

### With StringBuilder

```java
StringBuilder a = new StringBuilder("Hello");
StringBuilder b = new StringBuilder("World");

a.append(b);                                     // a = "HelloWorld"
b = new StringBuilder(a.substring(0, a.length() - b.length()));  // b = "Hello"
a = new StringBuilder(a.substring(b.length()));  // a = "World"
```

### Important Note
The without-temp approach only works correctly when both strings have no overlapping characters that could confuse the substring extraction. For production code, always use a temp variable — it's clearer and safer.
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','String','Swap','substring','No Temp Variable','String Manipulation'],
  true, 0
),

-- Q50
(
  'Write a Java program to calculate the sum of all elements in an array.',
  'java-prog-q050-sum-of-array',
  'Iterate through the array using an enhanced for loop (for-each), accumulating sum += num each iteration. More readable than index-based loop for simple sum. Final sum holds total. Works for both int and long arrays.',
  $ans$
## Sum of Array Elements

```java
public class SumOfArray {
    public static void main(String[] args) {
        int array[] = { 10, 20, 30, 40, 50, 10 };
        int sum = 0;

        // Advanced for loop (enhanced for / for-each)
        for (int num : array) {
            sum = sum + num;   // or: sum += num
        }

        System.out.println("Sum of array elements is: " + sum);
    }
}
```

### Output
```
Sum of array elements is: 160
```

### Index-Based For Loop

```java
int[] array = { 10, 20, 30, 40, 50 };
int sum = 0;

for (int i = 0; i < array.length; i++) {
    sum += array[i];
}
System.out.println("Sum: " + sum);  // 150
```

### Using Java 8 IntStream

```java
import java.util.stream.IntStream;

int[] array = { 10, 20, 30, 40, 50 };

int sum = IntStream.of(array).sum();
System.out.println("Sum: " + sum);  // 150

// Or using Arrays.stream()
int sum2 = java.util.Arrays.stream(array).sum();
```

### Sum With Statistics

```java
int[] array = { 10, 20, 30, 40, 50 };

int sum = 0, max = array[0], min = array[0];

for (int num : array) {
    sum += num;
    if (num > max) max = num;
    if (num < min) min = num;
}

System.out.println("Sum:     " + sum);                          // 150
System.out.println("Count:   " + array.length);                 // 5
System.out.printf("Average: %.2f%n", (double)sum/array.length); // 30.00
System.out.println("Max:     " + max);                          // 50
System.out.println("Min:     " + min);                          // 10
```

### Long Array (Avoid Overflow)

```java
int[] array = { Integer.MAX_VALUE, 1, 2, 3 };

// Bug: int overflow!
int badSum = 0;
for (int n : array) badSum += n;
System.out.println(badSum);  // negative! overflow

// Fix: use long
long goodSum = 0L;
for (int n : array) goodSum += n;
System.out.println(goodSum);  // correct: 2147483653
```

### Automation Testing Relevance

```java
// Sum all product quantities in a cart
List<WebElement> qtyFields = driver.findElements(By.css(".cart-qty"));
int totalItems = 0;
for (WebElement qty : qtyFields) {
    totalItems += Integer.parseInt(qty.getAttribute("value"));
}
assertEquals(totalItems, 5, "Cart should have 5 items total");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Array','Sum','Enhanced For','IntStream','Loop'],
  true, 0
),

-- Q51
(
  'Write a Java program to demonstrate 2D (two-dimensional) array declaration and traversal.',
  'java-prog-q051-two-dim-array',
  'A 2D array is an array of arrays. Declare with int[][] a = new int[rows][cols]. Access rows with a.length, columns with a[0].length. Traverse with nested for loops: outer for rows, inner for columns.',
  $ans$
## Two-Dimensional Array in Java

```java
public class TwoDimArray {
    public static void main(String[] args) {

        // Declare a 2D array: 3 rows, 2 columns
        int a[][] = new int[3][2];

        // Assign values to each cell
        a[0][0] = 100;
        a[0][1] = 200;

        a[1][0] = 300;
        a[1][1] = 400;

        a[2][0] = 500;
        a[2][1] = 600;

        // Alternative: inline initialization
        // int a[][] = { {100,200}, {300,400}, {500,600} };

        System.out.println("Rows:    " + a.length);       // 3
        System.out.println("Columns: " + a[0].length);    // 2

        // Traverse using nested enhanced for loops
        System.out.println("All elements:");
        for (int[] r : a) {           // r = each row (1D array)
            for (int c : r) {         // c = each element in the row
                System.out.println(c);
            }
        }
    }
}
```

### Output
```
Rows:    3
Columns: 2
All elements:
100
200
300
400
500
600
```

### Inline Initialization

```java
// Declare and initialize in one line
int[][] matrix = {
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
};

System.out.println("Rows: " + matrix.length);       // 3
System.out.println("Cols: " + matrix[0].length);    // 3
System.out.println("Center: " + matrix[1][1]);      // 5
```

### Print as Grid (Tabular)

```java
int[][] matrix = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } };

for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
        System.out.printf("%-5d", matrix[i][j]);
    }
    System.out.println();
}
```

### Output
```
1    2    3
4    5    6
7    8    9
```

### Sum of 2D Array Elements

```java
int[][] matrix = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } };
int sum = 0;

for (int[] row : matrix)
    for (int val : row)
        sum += val;

System.out.println("Sum: " + sum);  // 45
```

### Automation Testing Relevance

```java
// Read a web table into a 2D array
List<WebElement> rows = driver.findElements(By.css("table tr"));
String[][] tableData  = new String[rows.size()][];

for (int i = 0; i < rows.size(); i++) {
    List<WebElement> cols = rows.get(i).findElements(By.tagName("td"));
    tableData[i] = new String[cols.size()];
    for (int j = 0; j < cols.size(); j++) {
        tableData[i][j] = cols.get(j).getText();
    }
}

// Verify specific cell
assertEquals(tableData[1][2], "Active", "Row 2, Col 3 should be Active");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','2D Array','Matrix','Nested Loop','Array Traversal'],
  true, 0
),

-- Q52
(
  'Write a Java program to count words, characters, and lines in a text file using BufferedReader.',
  'java-prog-q052-word-count-in-file',
  'Read a file line by line using BufferedReader wrapping FileReader. For each line: increment lineCount, split by space for words (wordCount += words.length), iterate words for character count. Use try-catch-finally for IOException and close reader in finally.',
  $ans$
## Count Words, Characters, and Lines in a File

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class WordCountInFile {
    public static void main(String[] args) {
        BufferedReader reader = null;

        // Initialize counters to 0
        int charCount = 0;
        int wordCount = 0;
        int lineCount = 0;

        try {
            // Creating BufferedReader object to read the file
            reader = new BufferedReader(
                new FileReader("C:\\SeleniumPractice\\Test.txt"));

            // Reading the first line
            String currentLine = reader.readLine();

            while (currentLine != null) {
                // Increment line count for each line read
                lineCount++;

                // Split line by spaces to get words
                String[] words = currentLine.split(" ");

                // Add word count for this line
                wordCount = wordCount + words.length;

                // Iterate each word to count characters
                for (String word : words) {
                    charCount = charCount + word.length();
                }

                // Read next line
                currentLine = reader.readLine();
            }

            System.out.println("Number Of Chars In A File : " + charCount);
            System.out.println("Number Of Words In A File : " + wordCount);
            System.out.println("Number Of Lines In A File : " + lineCount);

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // Always close reader in finally block
            try {
                reader.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```

### Sample Output (for a test file)
```
Number Of Chars In A File : 142
Number Of Words In A File : 28
Number Of Lines In A File : 5
```

### Modern Version: try-with-resources (Java 7+)

```java
import java.io.*;
import java.nio.file.*;

// Auto-closes reader — no need for finally block
try (BufferedReader reader = new BufferedReader(new FileReader("Test.txt"))) {
    int lineCount = 0, wordCount = 0, charCount = 0;
    String line;

    while ((line = reader.readLine()) != null) {
        lineCount++;
        String[] words = line.trim().split("\\s+");
        wordCount += words.length;
        for (String w : words) charCount += w.length();
    }

    System.out.println("Lines: " + lineCount);
    System.out.println("Words: " + wordCount);
    System.out.println("Chars: " + charCount);
}
```

### Simplest: Using Files.readAllLines() (Java 8+)

```java
import java.nio.file.*;
import java.util.*;

Path path = Paths.get("Test.txt");
List<String> lines = Files.readAllLines(path);

long lineCount = lines.size();
long wordCount = lines.stream()
    .flatMap(l -> Arrays.stream(l.trim().split("\\s+")))
    .count();
long charCount = lines.stream()
    .flatMap(l -> Arrays.stream(l.trim().split("\\s+")))
    .mapToLong(String::length).sum();

System.out.println("Lines: " + lineCount);
System.out.println("Words: " + wordCount);
System.out.println("Chars: " + charCount);
```

### File Reading Classes Comparison

| Class | Buffered | Best for |
|---|---|---|
| `FileReader` | No | Simple char-by-char reading |
| `BufferedReader` | Yes | Line-by-line reading (most common) |
| `Scanner` | Yes | Tokenized reading with `nextLine()`/`nextInt()` |
| `Files.readAllLines()` | Internal | Modern, all lines into List |
| `Files.lines()` | Internal | Stream-based, large files |

### Automation Testing Relevance

```java
// Read test data from a CSV file for data-driven testing
try (BufferedReader br = new BufferedReader(new FileReader("testdata.csv"))) {
    String line;
    while ((line = br.readLine()) != null) {
        String[] data = line.split(",");
        String username = data[0];
        String password = data[1];
        // run test with each username/password pair
        performLogin(username, password);
    }
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','File IO','BufferedReader','FileReader','Word Count','try-with-resources'],
  true, 0
);
