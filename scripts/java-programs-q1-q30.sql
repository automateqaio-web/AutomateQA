-- Java Programs for Automation Testing Q1–Q30
-- technology = 'Java Programs', question_type = 'Coding'
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q1
(
  'Write a Java program to add two matrices.',
  'java-prog-q001-add-two-matrices',
  'Use nested for loops to iterate through rows and columns of two 2D arrays and store the sum in a result matrix. This tests 2D array handling commonly used in data-driven test frameworks.',
  $ans$
## Add Two Matrices in Java

```java
public class AddTwoMatrix {
    public static void main(String args[]) {
        int m, n, c, d;

        int first[][]  = { { 1, 2 }, { 5, 10 }, { 2, 6 } };
        int second[][] = { { 2, 6 }, { 1, 2 },  { 5, 3 } };

        m = first.length;       // number of rows
        n = first[0].length;    // number of columns

        int sum[][] = new int[m][n];

        System.out.println("Calculating Sum of 2 matrices....");

        for (c = 0; c < m; c++)
            for (d = 0; d < n; d++)
                sum[c][d] = first[c][d] + second[c][d];
                // replace '+' with '-' to subtract matrices

        System.out.println("Sum of 2 matrices....");

        for (c = 0; c < m; c++) {
            for (d = 0; d < n; d++)
                System.out.print(sum[c][d] + "\t");
            System.out.println();
        }
    }
}
```

### Output
```
Calculating Sum of 2 matrices....
Sum of 2 matrices....
3    8
6    12
7    9
```

### Key Concepts
- `first.length` → number of rows
- `first[0].length` → number of columns
- Replace `+` with `-` to **subtract** matrices
- Both matrices must have the same dimensions

### Automation Testing Relevance
Used when comparing test result matrices — e.g., comparing expected vs actual data grids from a web table.
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Arrays','2D Array','Matrix','Loops'],
  true, 0
),

-- Q2
(
  'Write a Java program demonstrating basic ArrayList operations (add, size, iterate).',
  'java-prog-q002-arraylist-basic',
  'ArrayList is a resizable array from java.util. Key operations: add() to insert, size() to count, and enhanced for loop to iterate. Used in Selenium for storing WebElements and test data collections.',
  $ans$
## Basic ArrayList Operations in Java

```java
import java.util.ArrayList;

public class ArrayListExample1 {
    public static void main(String[] args) {
        // Declaration
        ArrayList list = new ArrayList();

        // Add values to arraylist
        list.add("John");
        list.add("David");
        list.add("Scott");
        list.add("Smith");

        System.out.println(list.size()); // returns size of arraylist → 4

        // Reading values from arraylist using enhanced for loop
        for (String s : list) {
            System.out.println(s);
        }
    }
}
```

### Output
```
4
John
David
Scott
Smith
```

### Key Methods
| Method | Purpose |
|---|---|
| `list.add(value)` | Adds element at end |
| `list.size()` | Returns total count |
| `list.get(index)` | Gets element at index (0-based) |
| `list.remove(index)` | Removes element at index |
| `list.contains(value)` | Checks if value exists |
| `list.clear()` | Removes all elements |
| `list.isEmpty()` | Checks if list is empty |

### Automation Testing Relevance
```java
// Collecting all dropdown options
List<WebElement> options = driver.findElements(By.tagName("option"));
ArrayList<String> optionTexts = new ArrayList<>();
for (WebElement opt : options) {
    optionTexts.add(opt.getText());
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','ArrayList','Collections','List','Selenium'],
  true, 0
),

-- Q3
(
  'Write a Java program to check whether a number is even or odd.',
  'java-prog-q003-even-or-odd',
  'Use the modulus operator (%) to check divisibility by 2. If num % 2 == 0 the number is even, otherwise odd. This is a basic conditional logic program tested in Java interviews.',
  $ans$
## Check Even or Odd Number in Java

```java
public class EvenOrOddNumber {
    public static void main(String[] args) {
        int num = 10;

        if (num % 2 == 0) {
            System.out.println("Number is even number");
        } else {
            System.out.println("Number is odd number");
        }
    }
}
```

### Output
```
Number is even number
```

### Using Scanner (User Input)

```java
import java.util.Scanner;

public class EvenOrOddInput {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter a number: ");
        int num = sc.nextInt();

        if (num % 2 == 0)
            System.out.println(num + " is EVEN");
        else
            System.out.println(num + " is ODD");

        sc.close();
    }
}
```

### Using Ternary Operator (Compact Version)

```java
int num = 7;
String result = (num % 2 == 0) ? "Even" : "Odd";
System.out.println(num + " is " + result);  // → 7 is Odd
```

### Key Concept
- `%` is the **modulus operator** — returns the remainder after division
- `10 % 2 = 0` → Even
- `7 % 2 = 1` → Odd

### Automation Testing Relevance
Used in TestNG data providers to alternate test data, or to split test execution into even/odd batches for parallel runs.
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Modulus','If-Else','Conditional','Basic Program'],
  true, 0
),

-- Q4
(
  'Write a Java program to implement Binary Search.',
  'java-prog-q004-binary-search',
  'Binary search works on sorted arrays by repeatedly halving the search space. Compare the middle element with the target — if equal found, if smaller search right half, if larger search left half. Time complexity: O(log n).',
  $ans$
## Binary Search in Java

```java
public class BinarySearch {
    public static void main(String[] args) {
        int c, first, last, middle, n, search_element;

        int array[] = { 100, 200, 300, 400, 500 };
        search_element = 200;

        n = array.length;
        first  = 0;
        last   = n - 1;
        middle = (first + last) / 2;

        while (first <= last) {
            if (array[middle] < search_element)
                first = middle + 1;
            else if (array[middle] == search_element) {
                System.out.println(search_element + " found at location " + (middle + 1) + ".");
                break;
            } else
                last = middle - 1;

            middle = (first + last) / 2;
        }

        if (first > last)
            System.out.println(search_element + " isn't present in the list.\n");
    }
}
```

### Output
```
200 found at location 2.
```

### How Binary Search Works

```
Array: [100, 200, 300, 400, 500]   search: 200

Iteration 1:
  first=0, last=4, middle=2 → array[2]=300
  300 > 200 → search left: last = middle-1 = 1

Iteration 2:
  first=0, last=1, middle=0 → array[0]=100
  100 < 200 → search right: first = middle+1 = 1

Iteration 3:
  first=1, last=1, middle=1 → array[1]=200
  200 == 200 → FOUND at index 1 (location 2)
```

### Prerequisite
Array **must be sorted** before binary search. Use `Arrays.sort(array)` if not.

### Time Complexity
| | Binary Search | Linear Search |
|---|---|---|
| Best | O(1) | O(1) |
| Average | O(log n) | O(n) |
| Worst | O(log n) | O(n) |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Binary Search','Array','Algorithm','Search'],
  true, 0
),

-- Q5
(
  'Write a Java program to find and print even and odd numbers from an array.',
  'java-prog-q005-even-odd-in-array',
  'Iterate through the array and use modulus (%) to separate numbers into even (% 2 == 0) and odd (% 2 != 0) groups. Print each group separately. Demonstrates array traversal and conditional logic.',
  $ans$
## Find Even and Odd Numbers in an Array

```java
package LogicalPrograms;

public class EvenAndOddNumbersInArray {
    public static void main(String[] args) {
        int a[] = { 10, 20, 15, 3, 6, 7, 8, 2, 5, 7 };
        int n = a.length;

        System.out.print("Odd numbers: ");
        for (int i = 0; i < n; i++) {
            if (a[i] % 2 != 0) {        // remainder NOT zero → odd
                System.out.print(a[i] + " ");
            }
        }
        System.out.println();

        System.out.print("Even numbers: ");
        for (int i = 0; i < n; i++) {
            if (a[i] % 2 == 0) {         // remainder IS zero → even
                System.out.print(a[i] + " ");
            }
        }
    }
}
```

### Output
```
Odd numbers: 15 3 7 5 7
Even numbers: 10 20 6 8 2
```

### Compact Version Using Streams (Java 8+)

```java
import java.util.Arrays;
import java.util.stream.*;

int[] a = { 10, 20, 15, 3, 6, 7, 8, 2, 5, 7 };

System.out.println("Even: " +
    Arrays.stream(a).filter(x -> x % 2 == 0)
          .boxed().collect(Collectors.toList()));

System.out.println("Odd: " +
    Arrays.stream(a).filter(x -> x % 2 != 0)
          .boxed().collect(Collectors.toList()));
```

### Output (Stream Version)
```
Even: [10, 20, 6, 8, 2]
Odd: [15, 3, 7, 5, 7]
```

### Automation Testing Relevance
Used to validate numbered test IDs, row indexing in data-driven tests, or alternating CSS classes (even/odd row highlighting in web tables).
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Arrays','Even','Odd','Loop','Modulus'],
  true, 0
),

-- Q6
(
  'Write a Java program to demonstrate advanced ArrayList operations (insert, remove, get by index).',
  'java-prog-q006-arraylist-advanced',
  'ArrayList supports mixed-type storage (raw), add(index, value) for insertion at position, remove(index) to delete, get(index) to retrieve by position, and iteration using enhanced for loop with Object type.',
  $ans$
## Advanced ArrayList Operations in Java

```java
import java.util.ArrayList;

public class ArrayListExample2 {
    public static void main(String[] args) {
        // Declaration
        ArrayList list = new ArrayList();

        // Adding values to array list (mixed types)
        list.add("welcome");
        list.add(100);
        list.add(10.5);
        list.add('C');
        list.add(true);

        System.out.println(list.size());      // size of arraylist → 5
        System.out.println(list.get(2));      // returns specific value from list (index=2) → 10.5

        System.out.println("Before inserting: " + list);

        // Insert value at specific position (index 1)
        list.add(1, "selenium");
        System.out.println("After insertion: " + list);

        // Remove value at index 3
        list.remove(3);
        System.out.println("After remove: " + list);

        // Reading values from array list using for loop
        for (Object i : list) {
            System.out.println(i);
        }
    }
}
```

### Output
```
5
10.5
Before inserting: [welcome, 100, 10.5, C, true]
After insertion:  [welcome, selenium, 100, 10.5, C, true]
After remove:     [welcome, selenium, 100, C, true]
welcome
selenium
100
C
true
```

### Key Differences: add() vs add(index, value)

```java
list.add("end");          // appends to END of list
list.add(1, "middle");    // INSERTS at index 1, shifts rest right
```

### Key Differences: remove(int) vs remove(Object)

```java
list.remove(3);           // removes by INDEX (position 3)
list.remove("selenium");  // removes by VALUE (first match)
```

### Typed ArrayList (Best Practice)

```java
ArrayList<String> names = new ArrayList<>();   // type-safe
names.add("John");
names.add("Jane");
String first = names.get(0);  // no casting needed
```

### Automation Testing Relevance

```java
// Storing all link texts on a page
List<WebElement> links = driver.findElements(By.tagName("a"));
ArrayList<String> linkTexts = new ArrayList<>();
for (WebElement link : links) {
    linkTexts.add(link.getText());
}
linkTexts.remove(0);  // remove first irrelevant link
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','ArrayList','Collections','add','remove','get'],
  true, 0
),

-- Q7
(
  'Write a Java program to generate random numbers in a given range.',
  'java-prog-q007-random-numbers',
  'Use java.util.Random class with nextInt(n) to generate 0 to n-1, or Math.random() which returns a double 0.0 to 1.0 multiplied by range. Both approaches are used for generating random test data in automation.',
  $ans$
## Generate Random Numbers in Java

```java
import java.util.Random;

public class GenerateRandomNumbersInGivenRange {
    public static void main(String[] args) {

        // Method 1: Using Random class
        System.out.println("Random integers between 0 and 50 using Random class:");
        Random random = new Random();
        for (int i = 0; i < 5; i++) {
            System.out.println(random.nextInt(50));  // generates 0 to 49
        }

        // Method 2: Using Math.random()
        System.out.println("Random integers between 0 and 50 using Math.random():");
        for (int i = 0; i < 5; i++) {
            System.out.println((int) (Math.random() * 50));  // 0.0-1.0 × 50 = 0-49
        }
    }
}
```

### Sample Output (values vary each run)
```
Random integers between 0 and 50 using Random class:
23
7
41
15
38
Random integers between 0 and 50 using Math.random():
12
29
3
47
8
```

### Common Random Patterns

```java
Random rand = new Random();

// Random int between 0 and max-1
int num = rand.nextInt(100);         // 0 to 99

// Random int between min and max (inclusive)
int min = 10, max = 50;
int inRange = rand.nextInt((max - min) + 1) + min;  // 10 to 50

// Random boolean
boolean flag = rand.nextBoolean();

// Random double (0.0 to 1.0)
double d = rand.nextDouble();

// Random long
long l = rand.nextLong();
```

### Using Math.random()

```java
// Between 1 and 100 (inclusive)
int num = (int)(Math.random() * 100) + 1;

// Random element from array
String[] names = {"John", "Jane", "Bob"};
String picked = names[(int)(Math.random() * names.length)];
```

### Automation Testing Relevance

```java
// Generate unique email for test registration
String email = "qa" + new Random().nextInt(100000) + "@test.com";
driver.findElement(By.id("email")).sendKeys(email);

// Random wait time (avoid fixed sleep)
int wait = new Random().nextInt(3) + 2;  // 2 to 4 seconds
Thread.sleep(wait * 1000);  // use sparingly, prefer explicit waits
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Random','Math.random','Test Data','Automation'],
  true, 0
),

-- Q8
(
  'Write a Java program to implement Binary Search using Arrays.binarySearch() method.',
  'java-prog-q008-binary-search-method',
  'Java''s Arrays.binarySearch() from java.util.Arrays performs binary search in one line on a sorted array and returns the index of the found element, or a negative number if not found.',
  $ans$
## Binary Search Using Arrays.binarySearch() Method

```java
import java.util.Arrays;

public class BinarySearchUsingMethod {
    public static void main(String[] args) {
        int array[] = { 10, 20, 30, 40, 50 };  // Must be sorted

        // Arrays.binarySearch(array, searchElement)
        // Returns: index of found element, or negative if not found
        System.out.println(Arrays.binarySearch(array, 30));  // → 2
        System.out.println(Arrays.binarySearch(array, 10));  // → 0
        System.out.println(Arrays.binarySearch(array, 99));  // → negative (not found)
    }
}
```

### Output
```
2
0
-6
```

### Return Value Rules

```java
int[] arr = { 10, 20, 30, 40, 50 };

// Found: returns index (0-based)
Arrays.binarySearch(arr, 30)  // → 2

// Not found: returns -(insertionPoint) - 1
Arrays.binarySearch(arr, 25)  // → -3  (25 would go at index 2 → -(2)-1 = -3)
Arrays.binarySearch(arr, 99)  // → -6  (99 would go at index 5 → -(5)-1 = -6)
```

### Search in Subarray

```java
int[] arr = { 5, 10, 20, 30, 40, 50, 60 };

// Search only between index 2 and 5 (inclusive)
int result = Arrays.binarySearch(arr, 2, 5, 30);  // → 3
```

### Search String Array

```java
String[] names = { "Alice", "Bob", "Charlie", "David" };  // must be sorted
int idx = Arrays.binarySearch(names, "Charlie");
System.out.println("Found at: " + idx);  // → 2
```

### Full Example with Validation

```java
import java.util.Arrays;

public class BinarySearchComplete {
    public static void main(String[] args) {
        int[] arr = { 10, 20, 30, 40, 50 };
        int target = 30;

        int result = Arrays.binarySearch(arr, target);

        if (result >= 0)
            System.out.println(target + " found at index " + result);
        else
            System.out.println(target + " not found in array");
    }
}
```

### Comparison: Manual vs Method

| | Manual Implementation | Arrays.binarySearch() |
|---|---|---|
| Code | ~20 lines | 1 line |
| Sorted required | Yes | Yes |
| Returns | Custom message | Index or negative |
| Flexibility | High | Medium |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Binary Search','Arrays','Built-in Method','Algorithm'],
  true, 0
),

-- Q9
(
  'Write a Java program to implement Bubble Sort.',
  'java-prog-q009-bubble-sort',
  'Bubble sort repeatedly compares adjacent elements and swaps them if in wrong order. After each pass the largest element "bubbles" to the end. Nested loops: outer controls passes, inner does comparisons. O(n²) time complexity.',
  $ans$
## Bubble Sort in Java

```java
public class BubbleSort {
    public static void main(String[] args) {
        int n, c, d, temp;

        int array[] = { 500, 300, 200, 400, 100 };
        n = array.length;

        System.out.println("Array Before Bubble Sort");
        for (int i = 0; i < array.length; i++)
            System.out.print(array[i] + " ");

        // Sorting
        temp = 0;

        for (int i = 0; i < n; i++) {
            for (int j = 1; j < (n - i); j++) {
                if (array[j - 1] > array[j]) {
                    // Swap adjacent elements
                    temp         = array[j - 1];
                    array[j - 1] = array[j];
                    array[j]     = temp;
                }
            }
        }

        System.out.println();
        System.out.println("Array After Bubble Sort");
        for (int i = 0; i < array.length; i++)
            System.out.print(array[i] + " ");
    }
}
```

### Output
```
Array Before Bubble Sort
500 300 200 400 100
Array After Bubble Sort
100 200 300 400 500
```

### How Bubble Sort Works (Step by Step)

```
Array: [500, 300, 200, 400, 100]

Pass 1: Compare and swap adjacent pairs
  500 > 300 → swap → [300, 500, 200, 400, 100]
  500 > 200 → swap → [300, 200, 500, 400, 100]
  500 > 400 → swap → [300, 200, 400, 500, 100]
  500 > 100 → swap → [300, 200, 400, 100, 500]  ← 500 at end

Pass 2: Largest remaining "bubbles" to 2nd last
  ...and so on until sorted

Final: [100, 200, 300, 400, 500]
```

### Optimized Bubble Sort (with early exit)

```java
for (int i = 0; i < n - 1; i++) {
    boolean swapped = false;
    for (int j = 0; j < n - i - 1; j++) {
        if (array[j] > array[j + 1]) {
            int temp = array[j];
            array[j] = array[j + 1];
            array[j + 1] = temp;
            swapped = true;
        }
    }
    if (!swapped) break;  // already sorted, exit early
}
```

### Time & Space Complexity

| | Best | Average | Worst |
|---|---|---|---|
| Time | O(n) | O(n²) | O(n²) |
| Space | O(1) | O(1) | O(1) |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Bubble Sort','Sorting','Algorithm','Array'],
  true, 0
),

-- Q10
(
  'Write a Java program to count the number of words in a string.',
  'java-prog-q010-count-words',
  'Count words by scanning for spaces between non-space characters. Start count at 1, increment when a space is followed by a non-space. Scanner reads user input. Alternatively use split() for a one-liner approach.',
  $ans$
## Count Words in a String

```java
import java.util.Scanner;

public class CountTheWords {
    public static void main(String[] args) {
        System.out.println("Enter the string:");

        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine();

        int count = 1;

        for (int i = 0; i < s.length() - 1; i++) {
            if ((s.charAt(i) == ' ') && (s.charAt(i + 1) != ' ')) {
                count++;
            }
        }

        System.out.println("Number of words in a string = " + count);
    }
}
```

### Sample Input/Output
```
Enter the string:
Java is a programming language
Number of words in a string = 5
```

### Simpler Approach Using split()

```java
public class CountWordsSimple {
    public static void main(String[] args) {
        String s = "Java is a programming language";

        // split by one or more whitespace characters
        String[] words = s.trim().split("\\s+");
        System.out.println("Word count: " + words.length);  // → 5
    }
}
```

### Handle Edge Cases

```java
public static int countWords(String s) {
    if (s == null || s.trim().isEmpty()) return 0;
    return s.trim().split("\\s+").length;
}

System.out.println(countWords(""));               // → 0
System.out.println(countWords("  hello  world ")); // → 2
System.out.println(countWords("Java"));            // → 1
```

### Using StringTokenizer

```java
import java.util.StringTokenizer;

String s = "Java automation testing is fun";
StringTokenizer st = new StringTokenizer(s);
System.out.println("Word count: " + st.countTokens());  // → 5
```

### Automation Testing Relevance

```java
// Count words in a web element's text
String elementText = driver.findElement(By.css(".description")).getText();
int wordCount = elementText.trim().split("\\s+").length;
assertTrue(wordCount > 10, "Description should have more than 10 words");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Scanner','Count Words','split'],
  true, 0
),

-- Q11
(
  'Write a Java program to count the number of occurrences of a character in a string.',
  'java-prog-q011-count-char-occurrences',
  'Count character occurrences using String.length() minus the length after replacing the target character with empty string. Alternatively use a loop with charAt() comparison. Both approaches are O(n).',
  $ans$
## Count Character Occurrences in a String

```java
public class CountCharacterOccurence {
    public static void main(String[] args) {
        String s = "Java is java again java again";
        char c = 'a';

        // Count using replace technique
        int count = s.length() - s.replace("a", "").length();

        System.out.println("Number of occurances of 'a' is: " + count);  // → 10
    }
}
```

### Output
```
Number of occurances of 'a' is: 10
```

### How the Replace Technique Works

```
Original string: "Java is java again java again"  length = 29
After removing 'a': "Jv is jv gin jv gin"         length = 19
Difference: 29 - 19 = 10  → 10 occurrences of 'a'
```

### Alternative: Loop with charAt()

```java
public class CountCharLoop {
    public static void main(String[] args) {
        String s = "Java is java again java again";
        char target = 'a';
        int count = 0;

        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == target) {
                count++;
            }
        }
        System.out.println("Count of '" + target + "': " + count);  // → 10
    }
}
```

### Case-Insensitive Count

```java
String s = "Java is Java again";
char target = 'j';  // count both 'j' and 'J'

long count = s.toLowerCase()
              .chars()
              .filter(ch -> ch == Character.toLowerCase(target))
              .count();

System.out.println("Case-insensitive count: " + count);  // → 2
```

### Count All Characters (Frequency Map)

```java
import java.util.HashMap;
import java.util.Map;

String s = "automation";
Map<Character, Integer> freq = new HashMap<>();

for (char ch : s.toCharArray()) {
    freq.put(ch, freq.getOrDefault(ch, 0) + 1);
}

System.out.println(freq);
// {a=3, u=1, t=2, o=2, i=1, n=1, m=1}
```

### Automation Testing Relevance

```java
// Verify a field contains exactly N special characters
String password = driver.findElement(By.id("password")).getAttribute("value");
int specialCount = password.length() - password.replace("@", "").length();
assertTrue(specialCount >= 1, "Password must contain at least one @");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','charAt','replace','Count','Characters'],
  true, 0
),

-- Q12
(
  'Write a Java program to find the greatest of three numbers.',
  'java-prog-q012-greatest-of-three',
  'Compare three numbers using if-else if-else with AND (&&) conditions. a is greatest if a > b AND a > c. b is greatest if b > a AND b > c. Otherwise c is greatest. A clean conditional logic problem.',
  $ans$
## Find Greatest of Three Numbers

```java
public class GreatestOfThreeNumbers {
    public static void main(String[] args) {
        int a = 50;
        int b = 100;
        int c = 20;

        if (a > b && a > c) {
            System.out.println("a is greatest");
        } else if (b > a && b > c) {
            System.out.println("b is largest");
        } else {
            System.out.println("c is greatest");
        }
    }
}
```

### Output
```
b is largest
```

### Using Scanner (User Input)

```java
import java.util.Scanner;

public class GreatestInput {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter a, b, c: ");
        int a = sc.nextInt(), b = sc.nextInt(), c = sc.nextInt();

        int greatest = Math.max(a, Math.max(b, c));
        System.out.println("Greatest: " + greatest);
        sc.close();
    }
}
```

### Using Math.max() (Cleanest)

```java
int a = 50, b = 100, c = 20;
int greatest = Math.max(a, Math.max(b, c));
System.out.println("Greatest: " + greatest);  // → 100
```

### Using Ternary Operator

```java
int a = 50, b = 100, c = 20;
int greatest = (a > b) ? (a > c ? a : c) : (b > c ? b : c);
System.out.println("Greatest: " + greatest);  // → 100
```

### Handle Equal Numbers

```java
if (a >= b && a >= c)
    System.out.println("a is greatest (or tied)");
else if (b >= a && b >= c)
    System.out.println("b is greatest (or tied)");
else
    System.out.println("c is greatest");
```

### Automation Testing Relevance

```java
// Find the highest priced product on a page
List<WebElement> prices = driver.findElements(By.css(".price"));
int maxPrice = prices.stream()
    .mapToInt(e -> Integer.parseInt(e.getText().replace("$", "")))
    .max().orElse(0);
System.out.println("Highest price: $" + maxPrice);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Conditional','If-Else','Math.max','Greatest'],
  true, 0
),

-- Q13
(
  'Write a Java program to reverse a string without using built-in reverse methods.',
  'java-prog-q013-reverse-string',
  'Reverse a string by iterating from the last character to the first using a for loop and appending each character to a new string or StringBuilder. A very common Java coding interview question.',
  $ans$
## Reverse a String in Java

### Method 1: Using a Loop (Manual)

```java
public class ReverseString {
    public static void main(String[] args) {
        String original = "Automation";
        String reversed = "";

        for (int i = original.length() - 1; i >= 0; i--) {
            reversed = reversed + original.charAt(i);
        }

        System.out.println("Original: " + original);
        System.out.println("Reversed: " + reversed);
    }
}
```

### Output
```
Original: Automation
Reversed: noitamotuA
```

### Method 2: StringBuilder (Best Performance)

```java
public class ReverseStringBuilder {
    public static void main(String[] args) {
        String str = "Automation Testing";

        // StringBuilder has built-in reverse()
        String reversed = new StringBuilder(str).reverse().toString();
        System.out.println(reversed);  // → gnitseT noitamotuA
    }
}
```

### Method 3: char Array Swap

```java
public static String reverseWithSwap(String str) {
    char[] arr = str.toCharArray();
    int left = 0, right = arr.length - 1;

    while (left < right) {
        char temp = arr[left];
        arr[left]  = arr[right];
        arr[right] = temp;
        left++;
        right--;
    }
    return new String(arr);
}

System.out.println(reverseWithSwap("Selenium"));  // → muineleS
```

### Method 4: Recursion

```java
public static String reverseRecursive(String s) {
    if (s.isEmpty()) return s;
    return reverseRecursive(s.substring(1)) + s.charAt(0);
}
System.out.println(reverseRecursive("TestNG"));  // → GNtseT
```

### Check Palindrome Using Reverse

```java
String str = "madam";
String rev = new StringBuilder(str).reverse().toString();
boolean isPalindrome = str.equals(rev);
System.out.println(str + " is palindrome: " + isPalindrome);  // → true
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Reverse','StringBuilder','Interview'],
  true, 0
),

-- Q14
(
  'Write a Java program to check if a string is a palindrome.',
  'java-prog-q014-palindrome-check',
  'A palindrome reads the same forwards and backwards (e.g., "madam", "racecar"). Compare the original string with its reversed version. Use StringBuilder.reverse() or compare characters from both ends toward the middle.',
  $ans$
## Palindrome Check in Java

### Method 1: Using StringBuilder.reverse()

```java
public class PalindromeCheck {
    public static void main(String[] args) {
        String str = "madam";

        String reversed = new StringBuilder(str).reverse().toString();

        if (str.equals(reversed)) {
            System.out.println(str + " is a PALINDROME");
        } else {
            System.out.println(str + " is NOT a palindrome");
        }
    }
}
```

### Output
```
madam is a PALINDROME
```

### Method 2: Two-Pointer Approach (Efficient)

```java
public static boolean isPalindrome(String str) {
    int left = 0;
    int right = str.length() - 1;

    while (left < right) {
        if (str.charAt(left) != str.charAt(right)) {
            return false;  // mismatch found
        }
        left++;
        right--;
    }
    return true;  // all characters matched
}

System.out.println(isPalindrome("racecar"));  // true
System.out.println(isPalindrome("hello"));    // false
System.out.println(isPalindrome("A"));        // true (single char)
```

### Case-Insensitive + Ignore Spaces

```java
public static boolean isPalindromeIgnoreCase(String str) {
    String cleaned = str.toLowerCase().replaceAll("\\s+", "");
    String reversed = new StringBuilder(cleaned).reverse().toString();
    return cleaned.equals(reversed);
}

System.out.println(isPalindromeIgnoreCase("Race Car"));  // true
System.out.println(isPalindromeIgnoreCase("Never Odd Or Even"));  // true
```

### Test Multiple Words

```java
String[] words = { "madam", "racecar", "hello", "level", "java" };

for (String word : words) {
    boolean result = new StringBuilder(word).reverse().toString().equals(word);
    System.out.println(word + " → " + (result ? "Palindrome" : "Not palindrome"));
}
```

### Output
```
madam   → Palindrome
racecar → Palindrome
hello   → Not palindrome
level   → Palindrome
java    → Not palindrome
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Palindrome','StringBuilder','Interview'],
  true, 0
),

-- Q15
(
  'Write a Java program to find duplicate elements in an array.',
  'java-prog-q015-find-duplicates',
  'Find duplicates by nested loop comparison, or use a HashSet (add returns false for duplicates), or sort and compare adjacent elements. HashSet approach is O(n) time — most efficient and commonly expected in interviews.',
  $ans$
## Find Duplicate Elements in an Array

### Method 1: Nested Loop (Simple)

```java
public class FindDuplicates {
    public static void main(String[] args) {
        int arr[] = { 1, 2, 3, 4, 2, 7, 8, 8, 3 };

        System.out.println("Duplicate elements:");

        for (int i = 0; i < arr.length - 1; i++) {
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[i] == arr[j]) {
                    System.out.println(arr[j]);
                }
            }
        }
    }
}
```

### Output
```
Duplicate elements:
2
3
8
```

### Method 2: HashSet (Efficient — O(n))

```java
import java.util.HashSet;
import java.util.Set;

public class FindDuplicatesHashSet {
    public static void main(String[] args) {
        int arr[] = { 1, 2, 3, 4, 2, 7, 8, 8, 3 };
        Set<Integer> seen    = new HashSet<>();
        Set<Integer> duplicates = new HashSet<>();

        for (int num : arr) {
            if (!seen.add(num)) {         // add() returns false if already present
                duplicates.add(num);
            }
        }

        System.out.println("Duplicates: " + duplicates);  // {2, 3, 8}
    }
}
```

### Method 3: Sort + Adjacent Compare

```java
import java.util.Arrays;

int arr[] = { 1, 2, 3, 4, 2, 7, 8, 8, 3 };
Arrays.sort(arr);  // [1, 2, 2, 3, 3, 4, 7, 8, 8]

System.out.print("Duplicates: ");
for (int i = 0; i < arr.length - 1; i++) {
    if (arr[i] == arr[i + 1]) {
        System.out.print(arr[i] + " ");
    }
}
// Output: Duplicates: 2 3 8
```

### Count Frequency of Each Element

```java
import java.util.HashMap;
import java.util.Map;

int arr[] = { 1, 2, 3, 4, 2, 7, 8, 8, 3 };
Map<Integer, Integer> freq = new HashMap<>();

for (int num : arr) {
    freq.put(num, freq.getOrDefault(num, 0) + 1);
}

System.out.println("Frequency map: " + freq);
// {1=1, 2=2, 3=2, 4=1, 7=1, 8=2}

freq.entrySet().stream()
    .filter(e -> e.getValue() > 1)
    .forEach(e -> System.out.println(e.getKey() + " appears " + e.getValue() + " times"));
```

### Automation Testing Relevance

```java
// Check for duplicate values in a dropdown
List<WebElement> options = driver.findElements(By.tagName("option"));
Set<String> seen = new HashSet<>();
for (WebElement opt : options) {
    if (!seen.add(opt.getText())) {
        System.out.println("Duplicate option found: " + opt.getText());
    }
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Array','HashSet','Duplicates','HashMap','Interview'],
  true, 0
),

-- Q16
(
  'Write a Java program to find the second largest element in an array.',
  'java-prog-q016-second-largest',
  'Find the second largest by iterating once keeping track of both largest and second largest values. Update second largest when a value is larger than current second but smaller than first. O(n) single pass solution.',
  $ans$
## Find Second Largest Element in an Array

### Method 1: Two-Variable Tracking (Most Efficient)

```java
public class SecondLargest {
    public static void main(String[] args) {
        int arr[] = { 12, 35, 1, 10, 34, 1 };

        int largest  = Integer.MIN_VALUE;
        int secondLargest = Integer.MIN_VALUE;

        for (int num : arr) {
            if (num > largest) {
                secondLargest = largest;  // old largest becomes second
                largest = num;
            } else if (num > secondLargest && num != largest) {
                secondLargest = num;
            }
        }

        System.out.println("Largest: " + largest);
        System.out.println("Second Largest: " + secondLargest);
    }
}
```

### Output
```
Largest: 35
Second Largest: 34
```

### Method 2: Sort and Pick (Simple)

```java
import java.util.Arrays;

int arr[] = { 12, 35, 1, 10, 34, 1 };
Arrays.sort(arr);  // [1, 1, 10, 12, 34, 35]

// Second largest is at arr.length - 2
System.out.println("Second Largest: " + arr[arr.length - 2]);  // → 34
```

**Note**: Works only if no duplicates at the top. For unique second largest, traverse from end:
```java
for (int i = arr.length - 2; i >= 0; i--) {
    if (arr[i] != arr[arr.length - 1]) {
        System.out.println("Second Largest: " + arr[i]);
        break;
    }
}
```

### Method 3: Using TreeSet (Unique values sorted)

```java
import java.util.TreeSet;

int arr[] = { 12, 35, 1, 10, 34, 1, 35 };
TreeSet<Integer> set = new TreeSet<>();
for (int num : arr) set.add(num);  // TreeSet removes duplicates, keeps sorted

// headSet(max) = all elements less than max → last() is second largest
int secondLargest = set.headSet(set.last()).last();
System.out.println("Second Largest: " + secondLargest);  // → 34
```

### Automation Testing Relevance

```java
// Find the second highest priced item on a product listing page
List<WebElement> priceElements = driver.findElements(By.css(".product-price"));
int largest = 0, second = 0;

for (WebElement el : priceElements) {
    int price = Integer.parseInt(el.getText().replace("$", "").trim());
    if (price > largest) { second = largest; largest = price; }
    else if (price > second) second = price;
}
System.out.println("Second highest price: $" + second);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Array','Second Largest','Sorting','Algorithm','Interview'],
  true, 0
),

-- Q17
(
  'Write a Java program to check if a number is prime.',
  'java-prog-q017-prime-number',
  'A prime number is divisible only by 1 and itself. Check divisibility from 2 to √n — if any divides evenly, it''s not prime. Checking up to √n is the key optimization reducing O(n) to O(√n).',
  $ans$
## Check Prime Number in Java

```java
public class PrimeNumber {
    public static void main(String[] args) {
        int num = 29;
        boolean isPrime = true;

        if (num <= 1) {
            isPrime = false;
        } else {
            // Check divisibility from 2 to √num
            for (int i = 2; i <= Math.sqrt(num); i++) {
                if (num % i == 0) {
                    isPrime = false;
                    break;
                }
            }
        }

        if (isPrime)
            System.out.println(num + " is a Prime number");
        else
            System.out.println(num + " is NOT a Prime number");
    }
}
```

### Output
```
29 is a Prime number
```

### Why Check Only Up to √n?

```
If n = 36:
  Factors: 1×36, 2×18, 3×12, 4×9, 6×6
  After √36=6, factors repeat in reverse
  So checking 2 to 6 is enough
```

### Print All Primes Up to N (Sieve of Eratosthenes)

```java
public class PrintPrimes {
    public static void main(String[] args) {
        int n = 50;

        System.out.print("Primes up to " + n + ": ");
        for (int num = 2; num <= n; num++) {
            boolean prime = true;
            for (int i = 2; i <= Math.sqrt(num); i++) {
                if (num % i == 0) { prime = false; break; }
            }
            if (prime) System.out.print(num + " ");
        }
    }
}
```

### Output
```
Primes up to 50: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
```

### Method as Function (Reusable)

```java
public static boolean isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (int i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
}

// Usage
System.out.println(isPrime(17));  // true
System.out.println(isPrime(25));  // false
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Prime Number','Math.sqrt','Loop','Algorithm','Interview'],
  true, 0
),

-- Q18
(
  'Write a Java program to reverse a number (e.g., 12345 → 54321).',
  'java-prog-q018-reverse-number',
  'Reverse an integer by extracting the last digit with % 10, building the reversed number by multiplying current result by 10 and adding the digit, then removing the last digit with / 10. Loop until number becomes 0.',
  $ans$
## Reverse a Number in Java

```java
public class ReverseNumber {
    public static void main(String[] args) {
        int number  = 12345;
        int reverse = 0;
        int temp    = number;

        while (temp != 0) {
            int lastDigit = temp % 10;       // extract last digit
            reverse = (reverse * 10) + lastDigit;  // build reversed number
            temp    = temp / 10;             // remove last digit
        }

        System.out.println("Original: " + number);
        System.out.println("Reversed: " + reverse);
    }
}
```

### Output
```
Original: 12345
Reversed: 54321
```

### Step-by-Step Trace

```
number = 12345

Iteration 1: temp=12345, lastDigit=5, reverse=5,    temp=1234
Iteration 2: temp=1234,  lastDigit=4, reverse=54,   temp=123
Iteration 3: temp=123,   lastDigit=3, reverse=543,  temp=12
Iteration 4: temp=12,    lastDigit=2, reverse=5432, temp=1
Iteration 5: temp=1,     lastDigit=1, reverse=54321,temp=0
Loop ends → 54321
```

### Using String Conversion

```java
int number  = 12345;
String str  = Integer.toString(number);
String rev  = new StringBuilder(str).reverse().toString();
int reversed = Integer.parseInt(rev);
System.out.println(reversed);  // → 54321
```

### Check if Number is Palindrome

```java
int num = 121;
int reverse = 0, temp = num;

while (temp != 0) {
    reverse = (reverse * 10) + (temp % 10);
    temp /= 10;
}

if (num == reverse)
    System.out.println(num + " is a palindrome number");
else
    System.out.println(num + " is NOT a palindrome number");
```

### Output
```
121 is a palindrome number
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Number Reverse','Modulus','While Loop','Palindrome','Interview'],
  true, 0
),

-- Q19
(
  'Write a Java program to print the Fibonacci series up to N terms.',
  'java-prog-q019-fibonacci-series',
  'Fibonacci series: 0, 1, 1, 2, 3, 5, 8... where each number is the sum of the two before it. Use two variables to track the previous two numbers and a loop to generate N terms.',
  $ans$
## Fibonacci Series in Java

### Method 1: Iterative (Loop)

```java
public class FibonacciSeries {
    public static void main(String[] args) {
        int n = 10;  // print first 10 Fibonacci numbers
        int a = 0, b = 1;

        System.out.print("Fibonacci Series: ");

        for (int i = 0; i < n; i++) {
            System.out.print(a + " ");
            int next = a + b;
            a = b;
            b = next;
        }
    }
}
```

### Output
```
Fibonacci Series: 0 1 1 2 3 5 8 13 21 34
```

### Method 2: While Loop

```java
int a = 0, b = 1, count = 0;
int n = 8;

System.out.print("Fibonacci: ");
while (count < n) {
    System.out.print(a + " ");
    int temp = a + b;
    a = b;
    b = temp;
    count++;
}
// Output: Fibonacci: 0 1 1 2 3 5 8 13
```

### Method 3: Recursive

```java
public static int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

// Print first 8 terms
for (int i = 0; i < 8; i++) {
    System.out.print(fib(i) + " ");
}
// Output: 0 1 1 2 3 5 8 13
```

**Note**: Recursion is simple but inefficient O(2^n). Use iteration O(n) for large n.

### Fibonacci Up to a Value (Not Count)

```java
int limit = 100;
int a = 0, b = 1;

System.out.print("Fibonacci up to " + limit + ": ");
while (a <= limit) {
    System.out.print(a + " ");
    int temp = a + b;
    a = b;
    b = temp;
}
// Output: Fibonacci up to 100: 0 1 1 2 3 5 8 13 21 34 55 89
```

### Check if N is a Fibonacci Number

```java
public static boolean isFibonacci(int n) {
    int a = 0, b = 1;
    while (b < n) {
        int temp = a + b; a = b; b = temp;
    }
    return b == n || n == 0;
}

System.out.println(isFibonacci(13));  // true
System.out.println(isFibonacci(14));  // false
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Fibonacci','Series','Loop','Recursion','Interview'],
  true, 0
),

-- Q20
(
  'Write a Java program to sort an array using Arrays.sort() and demonstrate sorting a list of strings.',
  'java-prog-q020-sorting-arrays',
  'Arrays.sort() sorts primitive arrays ascending in-place using a dual-pivot Quicksort. Collections.sort() sorts Lists. For descending order use Comparator.reverseOrder() with boxed types or Arrays.sort() with a reverse-sorted copy.',
  $ans$
## Sorting Arrays in Java

### Sort Integer Array (Ascending)

```java
import java.util.Arrays;

public class SortArray {
    public static void main(String[] args) {
        int arr[] = { 64, 34, 25, 12, 22, 11, 90 };

        System.out.println("Before sort: " + Arrays.toString(arr));

        Arrays.sort(arr);  // in-place ascending sort

        System.out.println("After sort:  " + Arrays.toString(arr));
    }
}
```

### Output
```
Before sort: [64, 34, 25, 12, 22, 11, 90]
After sort:  [11, 12, 22, 25, 34, 64, 90]
```

### Sort String Array (Alphabetical)

```java
String[] fruits = { "Mango", "Apple", "Banana", "Cherry" };

Arrays.sort(fruits);
System.out.println(Arrays.toString(fruits));
// → [Apple, Banana, Cherry, Mango]
```

### Sort Descending (Integer Array)

```java
// Must use Integer[] (not int[]) for Comparator
Integer[] arr = { 64, 34, 25, 12, 22 };
Arrays.sort(arr, java.util.Comparator.reverseOrder());
System.out.println(Arrays.toString(arr));
// → [64, 34, 25, 22, 12]
```

### Sort ArrayList

```java
import java.util.ArrayList;
import java.util.Collections;

ArrayList<String> names = new ArrayList<>();
names.add("David");
names.add("Alice");
names.add("Bob");

Collections.sort(names);           // ascending
System.out.println(names);        // [Alice, Bob, David]

Collections.sort(names, Collections.reverseOrder());  // descending
System.out.println(names);        // [David, Bob, Alice]
```

### Sort Part of an Array

```java
int arr[] = { 5, 2, 8, 1, 9, 3 };
Arrays.sort(arr, 1, 4);  // sort index 1 to 3 only (4 is exclusive)
System.out.println(Arrays.toString(arr));
// → [5, 1, 2, 8, 9, 3]
```

### Automation Testing Relevance

```java
// Verify dropdown options are sorted alphabetically
List<WebElement> options = driver.findElements(By.tagName("option"));
List<String> actual = options.stream().map(WebElement::getText).collect(Collectors.toList());
List<String> expected = new ArrayList<>(actual);
Collections.sort(expected);
assertEquals(actual, expected, "Dropdown options not in alphabetical order");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Arrays.sort','Collections.sort','Sorting','Comparator'],
  true, 0
),

-- Q21
(
  'Write a Java program to swap two numbers without using a third variable.',
  'java-prog-q021-swap-without-temp',
  'Swap two numbers without a third variable using arithmetic (a = a+b, b = a-b, a = a-b) or XOR bitwise operation (a = a^b, b = a^b, a = a^b). Both work without extra memory.',
  $ans$
## Swap Two Numbers Without Third Variable

### Method 1: Using Arithmetic (+/-)

```java
public class SwapWithoutTemp {
    public static void main(String[] args) {
        int a = 10, b = 20;

        System.out.println("Before: a=" + a + ", b=" + b);

        a = a + b;  // a = 30
        b = a - b;  // b = 30 - 20 = 10
        a = a - b;  // a = 30 - 10 = 20

        System.out.println("After:  a=" + a + ", b=" + b);
    }
}
```

### Output
```
Before: a=10, b=20
After:  a=20, b=10
```

### Method 2: Using XOR Bitwise (No Overflow Risk)

```java
int a = 10, b = 20;

a = a ^ b;   // a = 10 XOR 20 = 30 (binary: 01010 XOR 10100 = 11110)
b = a ^ b;   // b = 30 XOR 20 = 10
a = a ^ b;   // a = 30 XOR 10 = 20

System.out.println("a=" + a + ", b=" + b);  // a=20, b=10
```

### Method 3: Using Multiplication/Division

```java
int a = 10, b = 20;
a = a * b;   // a = 200
b = a / b;   // b = 10
a = a / b;   // a = 20
// ⚠️ Fails if either value is 0
```

### Method 4: With Temp Variable (Standard, Clearest)

```java
int a = 10, b = 20, temp;
temp = a;
a    = b;
b    = temp;
System.out.println("a=" + a + ", b=" + b);  // a=20, b=10
```

### Why Arithmetic Can Overflow

```java
int a = Integer.MAX_VALUE;  // 2147483647
int b = 1;
a = a + b;  // OVERFLOW! wraps to negative
// Use XOR method for safety with large numbers
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Swap','XOR','Arithmetic','Variables','Interview'],
  true, 0
),

-- Q22
(
  'Write a Java program to find the factorial of a number using recursion and iteration.',
  'java-prog-q022-factorial',
  'Factorial of n (n!) = n × (n-1) × ... × 1. Factorial of 0 is 1. Implement iteratively with a loop (O(n) space O(1)) or recursively (n! = n × (n-1)!). Both are classic Java interview problems.',
  $ans$
## Factorial of a Number in Java

### Method 1: Iterative (Loop)

```java
public class FactorialIterative {
    public static void main(String[] args) {
        int n = 5;
        long factorial = 1;

        for (int i = 1; i <= n; i++) {
            factorial *= i;
        }

        System.out.println("Factorial of " + n + " = " + factorial);
    }
}
```

### Output
```
Factorial of 5 = 120
```

### Step Trace for 5!
```
i=1: factorial = 1 × 1 = 1
i=2: factorial = 1 × 2 = 2
i=3: factorial = 2 × 3 = 6
i=4: factorial = 6 × 4 = 24
i=5: factorial = 24 × 5 = 120
```

### Method 2: Recursive

```java
public class FactorialRecursive {

    public static long factorial(int n) {
        if (n == 0 || n == 1) return 1;   // base case
        return n * factorial(n - 1);       // recursive call
    }

    public static void main(String[] args) {
        for (int i = 0; i <= 10; i++) {
            System.out.println(i + "! = " + factorial(i));
        }
    }
}
```

### Output
```
0! = 1
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
6! = 720
7! = 5040
8! = 40320
9! = 362880
10! = 3628800
```

### Recursion Call Stack for factorial(4)

```
factorial(4)
  → 4 × factorial(3)
      → 3 × factorial(2)
          → 2 × factorial(1)
              → return 1      [base case]
          → 2 × 1 = 2
      → 3 × 2 = 6
  → 4 × 6 = 24
```

### Using BigInteger for Large Factorials

```java
import java.math.BigInteger;

public static BigInteger bigFactorial(int n) {
    BigInteger result = BigInteger.ONE;
    for (int i = 2; i <= n; i++) {
        result = result.multiply(BigInteger.valueOf(i));
    }
    return result;
}

System.out.println("20! = " + bigFactorial(20));
// → 2432902008176640000
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Factorial','Recursion','Loop','Interview','BigInteger'],
  true, 0
),

-- Q23
(
  'Write a Java program to remove duplicates from an ArrayList.',
  'java-prog-q023-remove-duplicates-list',
  'Remove duplicates from ArrayList using LinkedHashSet (preserves insertion order), or stream().distinct(), or iterating with contains() check into a new list. LinkedHashSet is the most concise and commonly expected approach.',
  $ans$
## Remove Duplicates from ArrayList

### Method 1: LinkedHashSet (Preserves Order — Best)

```java
import java.util.ArrayList;
import java.util.LinkedHashSet;

public class RemoveDuplicates {
    public static void main(String[] args) {
        ArrayList<String> list = new ArrayList<>();
        list.add("Selenium");
        list.add("TestNG");
        list.add("Cucumber");
        list.add("Selenium");     // duplicate
        list.add("TestNG");       // duplicate
        list.add("Maven");

        System.out.println("With duplicates:    " + list);

        // LinkedHashSet removes duplicates AND preserves insertion order
        LinkedHashSet<String> set = new LinkedHashSet<>(list);
        list.clear();
        list.addAll(set);

        System.out.println("Without duplicates: " + list);
    }
}
```

### Output
```
With duplicates:    [Selenium, TestNG, Cucumber, Selenium, TestNG, Maven]
Without duplicates: [Selenium, TestNG, Cucumber, Maven]
```

### Method 2: Java 8 Stream distinct()

```java
import java.util.stream.Collectors;

ArrayList<String> list = new ArrayList<>(
    Arrays.asList("Selenium", "TestNG", "Cucumber", "Selenium", "TestNG")
);

ArrayList<String> unique = list.stream()
    .distinct()
    .collect(Collectors.toCollection(ArrayList::new));

System.out.println(unique);
// → [Selenium, TestNG, Cucumber]
```

### Method 3: Manual with Contains Check

```java
ArrayList<String> list = new ArrayList<>(
    Arrays.asList("A", "B", "C", "A", "B", "D")
);
ArrayList<String> unique = new ArrayList<>();

for (String item : list) {
    if (!unique.contains(item)) {
        unique.add(item);
    }
}
System.out.println(unique);  // → [A, B, C, D]
```

### Remove Duplicate Integers

```java
ArrayList<Integer> nums = new ArrayList<>(Arrays.asList(1, 2, 3, 2, 4, 1, 5));
LinkedHashSet<Integer> set = new LinkedHashSet<>(nums);
ArrayList<Integer> result = new ArrayList<>(set);
System.out.println(result);  // → [1, 2, 3, 4, 5]
```

### Automation Testing Relevance

```java
// Remove duplicate window handles before switching
Set<String> handles = driver.getWindowHandles();
ArrayList<String> uniqueHandles = new ArrayList<>(new LinkedHashSet<>(handles));

// Verify no duplicate rows in a web table
List<WebElement> rows = driver.findElements(By.css("table tr td:first-child"));
List<String> ids = rows.stream().map(WebElement::getText).collect(Collectors.toList());
long unique = ids.stream().distinct().count();
assertEquals(ids.size(), unique, "Duplicate rows found in table");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','ArrayList','LinkedHashSet','Duplicates','Stream','Collections'],
  true, 0
),

-- Q24
(
  'Write a Java program to demonstrate HashMap operations (put, get, iterate, check key/value).',
  'java-prog-q024-hashmap-operations',
  'HashMap stores key-value pairs with O(1) average get/put. Keys are unique, values can repeat. Common operations: put() to add, get() by key, containsKey(), remove(), and entrySet() iteration. Used extensively in Selenium for test data.',
  $ans$
## HashMap Operations in Java

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapOperations {
    public static void main(String[] args) {

        // Create HashMap
        HashMap<String, String> map = new HashMap<>();

        // put() - add key-value pairs
        map.put("browser",     "Chrome");
        map.put("environment", "Staging");
        map.put("username",    "admin@test.com");
        map.put("password",    "Admin@123");
        map.put("baseUrl",     "https://staging.example.com");

        System.out.println("Map: " + map);
        System.out.println("Size: " + map.size());

        // get() - retrieve by key
        System.out.println("Browser: " + map.get("browser"));

        // containsKey() and containsValue()
        System.out.println("Has 'browser' key: " + map.containsKey("browser"));
        System.out.println("Has 'Chrome' value: " + map.containsValue("Chrome"));

        // Update value
        map.put("browser", "Firefox");
        System.out.println("Updated browser: " + map.get("browser"));

        // remove()
        map.remove("password");
        System.out.println("After remove: " + map);

        // Iterate using entrySet()
        System.out.println("\n--- All key-value pairs ---");
        for (Map.Entry<String, String> entry : map.entrySet()) {
            System.out.println(entry.getKey() + " → " + entry.getValue());
        }

        // Iterate keys only
        System.out.println("\n--- Keys only ---");
        for (String key : map.keySet()) {
            System.out.println(key);
        }
    }
}
```

### Output
```
Map: {browser=Chrome, environment=Staging, username=admin@test.com, ...}
Size: 5
Browser: Chrome
Has 'browser' key: true
Has 'Chrome' value: true
Updated browser: Firefox
After remove: {browser=Firefox, environment=Staging, ...}

--- All key-value pairs ---
browser → Firefox
environment → Staging
username → admin@test.com
baseUrl → https://staging.example.com
```

### Key HashMap Methods

| Method | Purpose |
|---|---|
| `put(key, value)` | Add/update key-value |
| `get(key)` | Get value by key (null if missing) |
| `getOrDefault(key, default)` | Get value or default |
| `containsKey(key)` | Check if key exists |
| `containsValue(value)` | Check if value exists |
| `remove(key)` | Delete entry |
| `size()` | Number of entries |
| `keySet()` | Set of all keys |
| `values()` | Collection of all values |
| `entrySet()` | Set of all key-value pairs |
| `isEmpty()` | Check if empty |
| `clear()` | Remove all entries |

### Automation Testing Relevance

```java
// Store test data per environment
HashMap<String, String> testData = new HashMap<>();
testData.put("dev_url",     "https://dev.example.com");
testData.put("staging_url", "https://staging.example.com");

String env = System.getProperty("env", "staging");
driver.get(testData.get(env + "_url"));

// Store expected vs actual results
HashMap<String, String> results = new HashMap<>();
results.put("Title",  driver.getTitle());
results.put("URL",    driver.getCurrentUrl());
results.put("Header", driver.findElement(By.h1).getText());
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','HashMap','Collections','Map','put','get','entrySet'],
  true, 0
),

-- Q25
(
  'Write a Java program to find the sum and average of elements in an array.',
  'java-prog-q025-sum-average-array',
  'Iterate through the array accumulating the sum, then divide by array length for the average. Use long for sum to avoid integer overflow on large arrays. Java 8 IntStream provides a one-liner alternative.',
  $ans$
## Sum and Average of Array Elements

```java
public class SumAndAverage {
    public static void main(String[] args) {
        int arr[] = { 10, 20, 30, 40, 50 };
        int sum   = 0;

        // Calculate sum
        for (int num : arr) {
            sum += num;
        }

        // Calculate average
        double average = (double) sum / arr.length;

        System.out.println("Array: " + java.util.Arrays.toString(arr));
        System.out.println("Sum:   " + sum);
        System.out.println("Count: " + arr.length);
        System.out.printf("Avg:   %.2f%n", average);
    }
}
```

### Output
```
Array: [10, 20, 30, 40, 50]
Sum:   150
Count: 5
Avg:   30.00
```

### Using Java 8 IntStream (One-liner)

```java
import java.util.IntSummaryStatistics;
import java.util.stream.IntStream;

int arr[] = { 10, 20, 30, 40, 50 };

int sum        = IntStream.of(arr).sum();          // 150
double avg     = IntStream.of(arr).average().getAsDouble();  // 30.0
int max        = IntStream.of(arr).max().getAsInt();         // 50
int min        = IntStream.of(arr).min().getAsInt();         // 10

IntSummaryStatistics stats = IntStream.of(arr).summaryStatistics();
System.out.println("Sum: " + stats.getSum());
System.out.println("Avg: " + stats.getAverage());
System.out.println("Max: " + stats.getMax());
System.out.println("Min: " + stats.getMin());
System.out.println("Count: " + stats.getCount());
```

### Find Max and Min in Same Loop

```java
int arr[] = { 64, 34, 25, 12, 22, 11, 90 };
int sum = 0, max = arr[0], min = arr[0];

for (int num : arr) {
    sum += num;
    if (num > max) max = num;
    if (num < min) min = num;
}

System.out.println("Sum: " + sum);
System.out.println("Max: " + max);
System.out.println("Min: " + min);
System.out.printf("Avg: %.2f%n", (double) sum / arr.length);
```

### Automation Testing Relevance

```java
// Calculate average response time from multiple API calls
List<Long> responseTimes = new ArrayList<>(Arrays.asList(120L, 95L, 150L, 88L, 130L));
long totalTime = responseTimes.stream().mapToLong(Long::longValue).sum();
double avgTime = responseTimes.stream().mapToLong(Long::longValue).average().getAsDouble();

System.out.printf("Avg response time: %.2f ms%n", avgTime);
assertTrue(avgTime < 200, "Average response time exceeds 200ms threshold");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Array','Sum','Average','IntStream','Java8'],
  true, 0
),

-- Q26
(
  'Write a Java program to demonstrate String methods (length, charAt, substring, indexOf, split, replace, trim, toUpperCase).',
  'java-prog-q026-string-methods',
  'Java String class has 60+ built-in methods. The most important for automation: length(), charAt(), substring(), indexOf(), contains(), split(), replace(), trim(), toUpperCase()/toLowerCase(), startsWith()/endsWith(), equals()/equalsIgnoreCase().',
  $ans$
## Important Java String Methods

```java
public class StringMethods {
    public static void main(String[] args) {
        String s = "  Automation Testing with Selenium  ";

        // Length
        System.out.println("Length: " + s.length());              // 36

        // Trim whitespace
        String trimmed = s.trim();
        System.out.println("Trimmed: '" + trimmed + "'");

        // Upper and Lower Case
        System.out.println("Upper: " + trimmed.toUpperCase());
        System.out.println("Lower: " + trimmed.toLowerCase());

        // charAt - get character at index
        System.out.println("charAt(0): " + trimmed.charAt(0));    // A

        // indexOf - find position of substring
        System.out.println("indexOf 'Testing': " + trimmed.indexOf("Testing"));  // 11

        // contains - check if substring exists
        System.out.println("Contains 'Selenium': " + trimmed.contains("Selenium"));  // true

        // substring - extract part of string
        System.out.println("substring(0,10): " + trimmed.substring(0, 10));  // Automation

        // replace - replace text
        System.out.println("Replace: " + trimmed.replace("Selenium", "Playwright"));

        // split - split by delimiter
        String csv = "Chrome,Firefox,Edge,Safari";
        String[] browsers = csv.split(",");
        System.out.println("Split count: " + browsers.length);  // 4
        for (String b : browsers) System.out.print(b + " ");

        // startsWith / endsWith
        System.out.println("\nstartsWith 'Auto': " + trimmed.startsWith("Auto"));    // true
        System.out.println("endsWith 'ium':   " + trimmed.endsWith("ium"));         // true

        // equals vs equalsIgnoreCase
        System.out.println("equals: "            + "Selenium".equals("selenium"));            // false
        System.out.println("equalsIgnoreCase: " + "Selenium".equalsIgnoreCase("selenium"));  // true

        // isEmpty / isBlank
        System.out.println("isEmpty: "  + "".isEmpty());    // true
        System.out.println("isBlank: "  + "  ".isBlank());  // true (Java 11+)
    }
}
```

### Output
```
Length: 36
Trimmed: 'Automation Testing with Selenium'
Upper: AUTOMATION TESTING WITH SELENIUM
Lower: automation testing with selenium
charAt(0): A
indexOf 'Testing': 11
Contains 'Selenium': true
substring(0,10): Automation
Replace: Automation Testing with Playwright
Split count: 4
Chrome Firefox Edge Safari
startsWith 'Auto': true
endsWith 'ium': true
equals: false
equalsIgnoreCase: true
isEmpty: true
isBlank: true
```

### String Comparison — Common Mistake

```java
String a = new String("hello");
String b = new String("hello");

System.out.println(a == b);       // FALSE — compares references
System.out.println(a.equals(b));  // TRUE  — compares content
```

**Always use `.equals()` to compare String content, never `==`.**

### Automation Testing Relevance

```java
// Verify page title
String title = driver.getTitle().trim().toLowerCase();
assertTrue(title.contains("dashboard"), "Title doesn't contain dashboard");

// Extract number from text like "$1,299.00"
String priceText = element.getText().replace("$", "").replace(",", "").trim();
double price = Double.parseDouble(priceText);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Methods','substring','split','trim','Automation'],
  true, 0
),

-- Q27
(
  'Write a Java program to demonstrate the use of Iterator and ListIterator on a collection.',
  'java-prog-q027-iterator-listiterator',
  'Iterator provides forward-only traversal with hasNext()/next() for any Collection. ListIterator additionally supports backward traversal, add/set during iteration, and index access — only for Lists. Both avoid ConcurrentModificationException.',
  $ans$
## Iterator and ListIterator in Java

### Iterator — Forward Traversal Only

```java
import java.util.*;

public class IteratorDemo {
    public static void main(String[] args) {
        ArrayList<String> list = new ArrayList<>(
            Arrays.asList("Selenium", "TestNG", "Cucumber", "Maven", "Jenkins")
        );

        // Get Iterator
        Iterator<String> it = list.iterator();

        System.out.println("Using Iterator (forward):");
        while (it.hasNext()) {
            String tool = it.next();
            System.out.println(tool);

            // Safe removal during iteration (avoids ConcurrentModificationException)
            if (tool.equals("Maven")) {
                it.remove();  // removes "Maven" safely
            }
        }

        System.out.println("After removing Maven: " + list);
    }
}
```

### Output
```
Using Iterator (forward):
Selenium
TestNG
Cucumber
Maven
Jenkins
After removing Maven: [Selenium, TestNG, Cucumber, Jenkins]
```

### ListIterator — Bidirectional + Modify

```java
ArrayList<String> list = new ArrayList<>(
    Arrays.asList("Chrome", "Firefox", "Edge", "Safari")
);

ListIterator<String> lit = list.listIterator();

// Forward traversal
System.out.println("Forward:");
while (lit.hasNext()) {
    System.out.println(lit.nextIndex() + ": " + lit.next());
}

// Backward traversal
System.out.println("Backward:");
while (lit.hasPrevious()) {
    System.out.println(lit.previousIndex() + ": " + lit.previous());
}

// Modify during iteration
ListIterator<String> lit2 = list.listIterator();
while (lit2.hasNext()) {
    String browser = lit2.next();
    lit2.set(browser + "-Driver");   // replace each element
}
System.out.println("Modified: " + list);
// → [Chrome-Driver, Firefox-Driver, Edge-Driver, Safari-Driver]
```

### Iterator vs ListIterator vs For-Each

| Feature | Iterator | ListIterator | For-Each |
|---|---|---|---|
| Direction | Forward only | Both | Forward only |
| Remove during loop | Yes (it.remove()) | Yes | NO (ConcurrentModificationException) |
| Add during loop | No | Yes (lit.add()) | No |
| Index access | No | Yes | No |
| Works on | Any Collection | List only | Any Iterable |

### Automation Testing Relevance

```java
// Safely remove stale elements from list
List<WebElement> elements = driver.findElements(By.css(".item"));
Iterator<WebElement> it = elements.iterator();
while (it.hasNext()) {
    WebElement el = it.next();
    if (!el.isDisplayed()) {
        it.remove();  // remove elements that are not visible
    }
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Iterator','ListIterator','Collections','ArrayList','Loop'],
  true, 0
),

-- Q28
(
  'Write a Java program to demonstrate exception handling with try-catch-finally and custom exceptions.',
  'java-prog-q028-exception-handling',
  'Exception handling with try-catch prevents program crash on runtime errors. finally always runs (used for cleanup). Custom exceptions extend Exception or RuntimeException. Checked exceptions must be declared; unchecked do not.',
  $ans$
## Exception Handling in Java

### Basic try-catch-finally

```java
public class ExceptionHandling {
    public static void main(String[] args) {
        try {
            int result = 10 / 0;  // ArithmeticException
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.out.println("Caught: " + e.getMessage());
        } finally {
            System.out.println("Finally always runs");
        }
    }
}
```

### Output
```
Caught: / by zero
Finally always runs
```

### Multiple catch Blocks

```java
public class MultiCatch {
    public static void main(String[] args) {
        try {
            String str = null;
            int[] arr = { 1, 2, 3 };

            System.out.println(str.length());    // NullPointerException
            System.out.println(arr[10]);         // ArrayIndexOutOfBoundsException

        } catch (NullPointerException e) {
            System.out.println("Null pointer: " + e.getMessage());
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Array index out of bounds: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("General exception: " + e.getMessage());
        } finally {
            System.out.println("Cleanup done");
        }
    }
}
```

### Custom Exception

```java
// Define custom exception
class ElementNotFoundException extends RuntimeException {
    public ElementNotFoundException(String message) {
        super(message);
    }
    public ElementNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}

// Use custom exception
public class CustomExceptionDemo {

    public static void clickElement(String selector) {
        try {
            // Simulating element not found
            if (selector.isEmpty()) {
                throw new ElementNotFoundException(
                    "Element with selector '" + selector + "' not found on page");
            }
        } catch (ElementNotFoundException e) {
            System.out.println("Test failed: " + e.getMessage());
            throw e;  // re-throw to fail the test
        }
    }

    public static void main(String[] args) {
        try {
            clickElement("");  // will throw custom exception
        } catch (ElementNotFoundException e) {
            System.out.println("Caught custom exception: " + e.getMessage());
        }
    }
}
```

### Exception Hierarchy

```
Throwable
  ├── Error (JVM errors — don't catch these)
  │     └── OutOfMemoryError, StackOverflowError
  └── Exception
        ├── Checked Exceptions (must handle or declare throws)
        │     └── IOException, SQLException, ClassNotFoundException
        └── RuntimeException (unchecked — optional to catch)
              └── NullPointerException, ArrayIndexOutOfBoundsException,
                  ArithmeticException, ClassCastException
```

### Automation Testing Relevance

```java
// Graceful element interaction with exception handling
public void clickIfExists(By locator) {
    try {
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
        WebElement el = wait.until(
            ExpectedConditions.elementToBeClickable(locator));
        el.click();
    } catch (TimeoutException e) {
        System.out.println("Element not found, skipping click: " + locator);
        // Don't throw — element is optional
    } catch (StaleElementReferenceException e) {
        // Retry once on stale element
        driver.findElement(locator).click();
    }
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Exception Handling','try-catch','Custom Exception','finally','Runtime'],
  true, 0
),

-- Q29
(
  'Write a Java program using Java 8 features: Lambda expressions, Stream API, and Optional.',
  'java-prog-q029-java8-features',
  'Java 8 introduced Lambdas (anonymous functions replacing verbose anonymous classes), Streams (functional pipeline for collections — filter/map/collect), and Optional (null-safe container). All three are heavily used in modern automation frameworks.',
  $ans$
## Java 8 Features: Lambda, Streams, Optional

### 1. Lambda Expressions

```java
import java.util.*;
import java.util.function.*;

public class LambdaDemo {
    public static void main(String[] args) {

        // Before Java 8 — Anonymous class
        Runnable oldWay = new Runnable() {
            @Override
            public void run() {
                System.out.println("Old way");
            }
        };

        // Java 8 — Lambda
        Runnable lambda = () -> System.out.println("Lambda way");

        // Lambda with parameter
        Comparator<String> comp = (a, b) -> a.compareTo(b);

        // Common functional interfaces
        Predicate<Integer> isEven  = n -> n % 2 == 0;
        Function<String, Integer> len = s -> s.length();
        Consumer<String> printer   = s -> System.out.println(s);
        Supplier<String> greeting  = () -> "Hello, QA!";

        System.out.println(isEven.test(4));       // true
        System.out.println(len.apply("Selenium")); // 8
        printer.accept("Testing");                  // Testing
        System.out.println(greeting.get());         // Hello, QA!
    }
}
```

### 2. Stream API

```java
import java.util.stream.*;

List<String> tools = Arrays.asList(
    "Selenium", "TestNG", "Cucumber", "Maven", "Jenkins", "Postman"
);

// filter + collect
List<String> longNames = tools.stream()
    .filter(t -> t.length() > 6)
    .collect(Collectors.toList());
System.out.println("Long names: " + longNames);  // [Selenium, TestNG, Cucumber, Jenkins, Postman]

// map — transform
List<String> upperTools = tools.stream()
    .map(String::toUpperCase)
    .collect(Collectors.toList());
System.out.println("Uppercase: " + upperTools);

// sorted
List<String> sorted = tools.stream()
    .sorted()
    .collect(Collectors.toList());
System.out.println("Sorted: " + sorted);

// count
long count = tools.stream().filter(t -> t.startsWith("S")).count();
System.out.println("Starts with S: " + count);  // 2

// anyMatch / allMatch / noneMatch
boolean anySelenium = tools.stream().anyMatch(t -> t.equals("Selenium"));
System.out.println("Has Selenium: " + anySelenium);  // true

// forEach
tools.stream().forEach(t -> System.out.print(t + " "));

// reduce
int totalLength = tools.stream()
    .mapToInt(String::length)
    .sum();
System.out.println("Total chars: " + totalLength);
```

### 3. Optional (Null-Safe)

```java
import java.util.Optional;

Optional<String> opt1 = Optional.of("Selenium");
Optional<String> opt2 = Optional.empty();
Optional<String> opt3 = Optional.ofNullable(null);  // safe for null

System.out.println(opt1.isPresent());    // true
System.out.println(opt2.isPresent());    // false
System.out.println(opt1.get());          // Selenium
System.out.println(opt2.orElse("Default"));  // Default
System.out.println(opt3.orElseGet(() -> "Generated Default"));

// Map with Optional
Optional<Integer> length = opt1.map(String::length);
System.out.println(length.get());  // 8
```

### Automation Testing Relevance

```java
// Filter visible elements using Stream
List<WebElement> allElements = driver.findElements(By.css(".product"));
List<WebElement> visible = allElements.stream()
    .filter(WebElement::isDisplayed)
    .collect(Collectors.toList());

// Extract text from all elements
List<String> texts = allElements.stream()
    .map(WebElement::getText)
    .collect(Collectors.toList());

// Find element by text using Optional (null-safe)
Optional<WebElement> button = driver.findElements(By.tagName("button"))
    .stream()
    .filter(b -> b.getText().equals("Submit"))
    .findFirst();

button.ifPresent(WebElement::click);  // click only if found
```
$ans$,
  'Java Programs', 'Coding', 'Intermediate', 'Advanced',
  ARRAY['Java','Java8','Lambda','Stream','Optional','Functional','Automation'],
  true, 0
),

-- Q30
(
  'Write a Java program to demonstrate multithreading with Thread class and Runnable interface.',
  'java-prog-q030-multithreading',
  'Java multithreading allows concurrent execution. Extend Thread class or implement Runnable interface, override run(), then call start() (NOT run()) to create a new OS thread. Used in Selenium parallel execution with ThreadLocal WebDriver.',
  $ans$
## Multithreading in Java

### Method 1: Extending Thread Class

```java
public class MyThread extends Thread {

    private String threadName;

    MyThread(String name) {
        this.threadName = name;
    }

    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(threadName + " → count: " + i);
            try {
                Thread.sleep(100);  // pause 100ms
            } catch (InterruptedException e) {
                System.out.println("Thread interrupted");
            }
        }
        System.out.println(threadName + " finished.");
    }

    public static void main(String[] args) {
        MyThread t1 = new MyThread("Thread-1");
        MyThread t2 = new MyThread("Thread-2");

        t1.start();  // starts new OS thread and calls run()
        t2.start();  // t1 and t2 run concurrently
    }
}
```

### Sample Output (order varies each run)
```
Thread-1 → count: 1
Thread-2 → count: 1
Thread-1 → count: 2
Thread-2 → count: 2
...
```

### Method 2: Implementing Runnable (Preferred)

```java
public class RunnableDemo implements Runnable {

    private String name;

    RunnableDemo(String name) { this.name = name; }

    @Override
    public void run() {
        for (int i = 1; i <= 3; i++) {
            System.out.println(name + ": step " + i +
                " [Thread: " + Thread.currentThread().getName() + "]");
        }
    }

    public static void main(String[] args) {
        Runnable task1 = new RunnableDemo("LoginTest");
        Runnable task2 = new RunnableDemo("CheckoutTest");

        Thread t1 = new Thread(task1, "Browser-1");
        Thread t2 = new Thread(task2, "Browser-2");

        t1.start();
        t2.start();

        // Wait for both threads to finish
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("All tests completed");
    }
}
```

### Method 3: Lambda Runnable (Java 8+)

```java
Thread t1 = new Thread(() -> {
    System.out.println("Running in: " + Thread.currentThread().getName());
}, "TestThread-1");

t1.start();
```

### Thread vs Runnable

| | Thread | Runnable |
|---|---|---|
| Inheritance | Extends Thread (single inheritance limit) | Implements interface (flexible) |
| Preferred | Less preferred | Preferred |
| Lambda | No | Yes (`() -> {}`) |

### ThreadLocal — For Parallel Selenium Tests

```java
// Each thread gets its OWN driver — no sharing
public class DriverManager {
    private static final ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    public static void setDriver(WebDriver d) { driver.set(d); }
    public static WebDriver getDriver()        { return driver.get(); }
    public static void quit()                  { driver.get().quit(); driver.remove(); }
}

// Thread 1 uses its own Chrome instance
// Thread 2 uses its own Firefox instance
// No interference between parallel tests
```

### Automation Testing Relevance
ThreadLocal WebDriver is the foundation of parallel Selenium execution in TestNG parallel suites and Cucumber parallel runners.
$ans$,
  'Java Programs', 'Coding', 'Intermediate', 'Advanced',
  ARRAY['Java','Multithreading','Thread','Runnable','ThreadLocal','Parallel','Selenium'],
  true, 0
);
