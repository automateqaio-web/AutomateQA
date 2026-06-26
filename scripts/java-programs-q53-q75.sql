-- Java Programs Q53–Q75 (Missing important topics + Streams deep dive)
-- technology = 'Java Programs', question_type = 'Coding'
-- Run in a FRESH new tab in Supabase SQL Editor

INSERT INTO interview_questions
  (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views)
VALUES

-- Q53
(
  'Write a Java program to check if two strings are anagrams of each other.',
  'java-prog-q053-anagram-check',
  'Two strings are anagrams if they contain the same characters in the same frequency (e.g., "listen" and "silent"). Sort both strings and compare, or use a frequency HashMap/char array. Very common Java interview question.',
  $ans$
## Check if Two Strings are Anagrams

### Method 1: Sort and Compare (Simplest)

```java
import java.util.Arrays;

public class AnagramCheck {
    public static void main(String[] args) {
        String s1 = "listen";
        String s2 = "silent";

        // Convert to char arrays, sort, compare
        char[] arr1 = s1.toLowerCase().toCharArray();
        char[] arr2 = s2.toLowerCase().toCharArray();

        Arrays.sort(arr1);
        Arrays.sort(arr2);

        if (Arrays.equals(arr1, arr2)) {
            System.out.println(s1 + " and " + s2 + " ARE anagrams");
        } else {
            System.out.println(s1 + " and " + s2 + " are NOT anagrams");
        }
    }
}
```

### Output
```
listen and silent ARE anagrams
```

### Method 2: Character Frequency Array (O(n) — Fastest)

```java
public static boolean isAnagram(String s1, String s2) {
    if (s1.length() != s2.length()) return false;

    int[] freq = new int[26];   // 26 letters a-z

    for (char c : s1.toLowerCase().toCharArray()) freq[c - 'a']++;
    for (char c : s2.toLowerCase().toCharArray()) freq[c - 'a']--;

    for (int count : freq) {
        if (count != 0) return false;
    }
    return true;
}

System.out.println(isAnagram("listen", "silent"));  // true
System.out.println(isAnagram("hello", "world"));    // false
System.out.println(isAnagram("Triangle", "Integral")); // true
```

### Method 3: HashMap Frequency Map

```java
import java.util.HashMap;

public static boolean isAnagramMap(String s1, String s2) {
    if (s1.length() != s2.length()) return false;

    HashMap<Character, Integer> map = new HashMap<>();

    // Increment count for s1 characters
    for (char c : s1.toLowerCase().toCharArray())
        map.put(c, map.getOrDefault(c, 0) + 1);

    // Decrement count for s2 characters
    for (char c : s2.toLowerCase().toCharArray()) {
        if (!map.containsKey(c) || map.get(c) == 0) return false;
        map.put(c, map.get(c) - 1);
    }
    return true;
}
```

### Test Multiple Pairs

```java
String[][] pairs = {
    {"listen", "silent"},
    {"hello",  "world"},
    {"Astronomer", "Moon starer"},
    {"abc", "cba"},
    {"Java", "avaj"}
};

for (String[] pair : pairs) {
    String a = pair[0].replaceAll("\\s", "");
    String b = pair[1].replaceAll("\\s", "");
    System.out.printf("%-15s %-15s → %s%n",
        pair[0], pair[1], isAnagram(a, b) ? "Anagram" : "Not Anagram");
}
```

### Output
```
listen          silent          → Anagram
hello           world           → Not Anagram
Astronomer      Moon starer     → Anagram
abc             cba             → Anagram
Java            avaj            → Anagram
```

### Using Java 8 Stream

```java
public static boolean isAnagramStream(String s1, String s2) {
    return Arrays.equals(
        s1.toLowerCase().chars().sorted().toArray(),
        s2.toLowerCase().chars().sorted().toArray()
    );
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','String','Anagram','HashMap','Arrays.sort','Interview'],
  true, 0
),

-- Q54
(
  'Write a Java program to check if a number is an Armstrong number (narcissistic number).',
  'java-prog-q054-armstrong-number',
  'An Armstrong number equals the sum of its digits each raised to the power of the number of digits. E.g., 153 = 1³+5³+3³ = 1+125+27 = 153. Use Math.pow() and digit extraction with % 10 and / 10.',
  $ans$
## Armstrong Number in Java

```java
public class ArmstrongNumber {
    public static void main(String[] args) {
        int num = 153;
        int original = num;
        int result = 0;

        // Count number of digits
        int digits = String.valueOf(num).length();  // 3

        int temp = num;
        while (temp != 0) {
            int lastDigit = temp % 10;
            result += (int) Math.pow(lastDigit, digits);  // digit^n
            temp /= 10;
        }

        if (result == original)
            System.out.println(original + " is an Armstrong number");
        else
            System.out.println(original + " is NOT an Armstrong number");
    }
}
```

### Output
```
153 is an Armstrong number
```

### Step-by-Step for 153

```
digits = 3
temp = 153

Iteration 1: lastDigit=3, 3³=27,  result=27,  temp=15
Iteration 2: lastDigit=5, 5³=125, result=152, temp=1
Iteration 3: lastDigit=1, 1³=1,   result=153, temp=0

153 == 153 → Armstrong!
```

### Print All Armstrong Numbers from 1 to 1000

```java
public class PrintAllArmstrong {
    public static void main(String[] args) {
        System.out.print("Armstrong numbers (1-1000): ");

        for (int num = 1; num <= 1000; num++) {
            int digits = String.valueOf(num).length();
            int temp = num, sum = 0;

            while (temp != 0) {
                int d = temp % 10;
                sum  += (int) Math.pow(d, digits);
                temp /= 10;
            }

            if (sum == num) System.out.print(num + " ");
        }
    }
}
```

### Output
```
Armstrong numbers (1-1000): 1 2 3 4 5 6 7 8 9 153 370 371 407
```

### Armstrong Numbers Reference

| Number | Calculation | Armstrong? |
|---|---|---|
| 153 | 1³+5³+3³ = 153 | ✓ Yes |
| 370 | 3³+7³+0³ = 370 | ✓ Yes |
| 371 | 3³+7³+1³ = 371 | ✓ Yes |
| 407 | 4³+0³+7³ = 407 | ✓ Yes |
| 1634 | 1⁴+6⁴+3⁴+4⁴ = 1634 | ✓ Yes |
| 123 | 1³+2³+3³ = 36 ≠ 123 | ✗ No |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Armstrong','Number','Math.pow','Interview','Classic'],
  true, 0
),

-- Q55
(
  'Write a Java program to find the sum of digits of a number.',
  'java-prog-q055-sum-of-digits',
  'Extract each digit using num % 10 (gives last digit), add to sum, then remove last digit with num / 10. Repeat until num becomes 0. E.g., 1234 → 1+2+3+4 = 10. Also works recursively.',
  $ans$
## Sum of Digits of a Number

```java
public class SumOfDigits {
    public static void main(String[] args) {
        int num = 1234;
        int sum = 0;

        while (num != 0) {
            sum += num % 10;    // extract last digit and add to sum
            num  = num / 10;    // remove last digit
        }

        System.out.println("Sum of digits: " + sum);  // 10
    }
}
```

### Output
```
Sum of digits: 10
```

### Step-by-Step Trace

```
num=1234, sum=0

Iteration 1: sum = 0 + 1234%10 = 4,  num = 1234/10 = 123
Iteration 2: sum = 4 + 123%10  = 7,  num = 123/10  = 12
Iteration 3: sum = 7 + 12%10   = 9,  num = 12/10   = 1
Iteration 4: sum = 9 + 1%10    = 10, num = 1/10    = 0
Loop ends → sum = 10
```

### One-Liner Using Streams

```java
int num = 1234;
int sum = String.valueOf(Math.abs(num))
              .chars()
              .map(c -> c - '0')      // char '4' → digit 4
              .sum();
System.out.println(sum);  // 10
```

### Recursive Method

```java
public static int sumOfDigits(int num) {
    if (num == 0) return 0;
    return (num % 10) + sumOfDigits(num / 10);
}

System.out.println(sumOfDigits(9875));  // 9+8+7+5 = 29
System.out.println(sumOfDigits(0));     // 0
System.out.println(sumOfDigits(99));    // 18
```

### Digital Root (Repeat Until Single Digit)

```java
public static int digitalRoot(int num) {
    while (num >= 10) {
        int sum = 0;
        while (num != 0) { sum += num % 10; num /= 10; }
        num = sum;
    }
    return num;
}

System.out.println(digitalRoot(9875));  // 9+8+7+5=29 → 2+9=11 → 1+1=2
```

### Automation Testing Relevance

```java
// Validate credit card Luhn digit sum
String cardNumber = "4532015112830366";
int checkSum = cardNumber.chars()
    .map(c -> c - '0')
    .sum();
System.out.println("Digit sum: " + checkSum);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Sum of Digits','Number','While Loop','Recursion','Stream'],
  true, 0
),

-- Q56
(
  'Write a Java program to print the multiplication table of a given number.',
  'java-prog-q056-multiplication-table',
  'Use a for loop from 1 to 10, multiplying the number by the loop variable each iteration. Print in "n x i = result" format. Demonstrates basic loop usage with arithmetic operations.',
  $ans$
## Multiplication Table in Java

```java
public class MultiplicationTable {
    public static void main(String[] args) {
        int n = 5;

        System.out.println("Multiplication table of " + n + ":");

        for (int i = 1; i <= 10; i++) {
            System.out.println(n + " x " + i + " = " + (n * i));
        }
    }
}
```

### Output
```
Multiplication table of 5:
5 x 1  = 5
5 x 2  = 10
5 x 3  = 15
5 x 4  = 20
5 x 5  = 25
5 x 6  = 30
5 x 7  = 35
5 x 8  = 40
5 x 9  = 45
5 x 10 = 50
```

### Using Scanner (User Input)

```java
import java.util.Scanner;

Scanner sc = new Scanner(System.in);
System.out.print("Enter a number: ");
int n = sc.nextInt();

for (int i = 1; i <= 10; i++) {
    System.out.printf("%d x %2d = %3d%n", n, i, n * i);
}
```

### Print Tables for 1 to 10

```java
for (int n = 1; n <= 10; n++) {
    System.out.println("\nTable of " + n + ":");
    for (int i = 1; i <= 10; i++) {
        System.out.printf("%2d x %2d = %3d%n", n, i, n * i);
    }
}
```

### Print in Grid Format

```java
// Header
System.out.printf("%-5s", " ");
for (int i = 1; i <= 10; i++) System.out.printf("%-5d", i);
System.out.println();

// Rows
for (int n = 1; n <= 10; n++) {
    System.out.printf("%-5d", n);
    for (int i = 1; i <= 10; i++) {
        System.out.printf("%-5d", n * i);
    }
    System.out.println();
}
```

### Output (partial)
```
      1    2    3    4    5    ...
1     1    2    3    4    5    ...
2     2    4    6    8    10   ...
3     3    6    9    12   15   ...
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Multiplication Table','Loop','for loop','Basic Program'],
  true, 0
),

-- Q57
(
  'Write a Java program to count vowels and consonants in a string.',
  'java-prog-q057-count-vowels-consonants',
  'Iterate each character, check if it is a vowel (a,e,i,o,u) using contains() or a switch/if chain, otherwise count as consonant. Convert to lowercase first for case-insensitive check. Skip spaces and special characters.',
  $ans$
## Count Vowels and Consonants in a String

```java
public class CountVowelsConsonants {
    public static void main(String[] args) {
        String str     = "Hello World Java Selenium";
        int vowels     = 0;
        int consonants = 0;

        str = str.toLowerCase();

        for (int i = 0; i < str.length(); i++) {
            char ch = str.charAt(i);

            // Check if character is a letter
            if (ch >= 'a' && ch <= 'z') {
                if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u') {
                    vowels++;
                } else {
                    consonants++;
                }
            }
            // spaces and special chars are skipped
        }

        System.out.println("String:     " + str);
        System.out.println("Vowels:     " + vowels);
        System.out.println("Consonants: " + consonants);
    }
}
```

### Output
```
String:     hello world java selenium
Vowels:     9
Consonants: 13
```

### Using String.contains() (Cleaner)

```java
String str     = "Automation Testing";
String vowelSet = "aeiouAEIOU";
int vowels = 0, consonants = 0;

for (char ch : str.toCharArray()) {
    if (Character.isLetter(ch)) {
        if (vowelSet.indexOf(ch) != -1) {
            vowels++;
        } else {
            consonants++;
        }
    }
}

System.out.println("Vowels:     " + vowels);     // 7
System.out.println("Consonants: " + consonants); // 11
```

### Using Java 8 Streams

```java
String str = "Automation Testing";

long vowels = str.toLowerCase().chars()
    .filter(c -> "aeiou".indexOf(c) != -1)
    .count();

long consonants = str.toLowerCase().chars()
    .filter(Character::isLetter)
    .filter(c -> "aeiou".indexOf(c) == -1)
    .count();

System.out.println("Vowels:     " + vowels);     // 7
System.out.println("Consonants: " + consonants); // 11
```

### Using switch Statement

```java
for (char ch : str.toLowerCase().toCharArray()) {
    switch (ch) {
        case 'a': case 'e': case 'i': case 'o': case 'u':
            vowels++;
            break;
        default:
            if (Character.isLetter(ch)) consonants++;
    }
}
```

### Automation Testing Relevance

```java
// Validate that a description field has actual words (not numbers/symbols only)
String description = driver.findElement(By.css(".desc")).getText();
long letterCount = description.chars().filter(Character::isLetter).count();
assertTrue(letterCount > 20, "Description must contain at least 20 letters");
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','String','Vowels','Consonants','char','Stream','Character'],
  true, 0
),

-- Q58
(
  'Write a Java program to find the first non-repeating character in a string.',
  'java-prog-q058-first-non-repeating-char',
  'Use LinkedHashMap to store character frequency while preserving insertion order. Iterate the map to find the first entry with count = 1. LinkedHashMap is key — HashMap does not guarantee order. Alternative: two-pass with char array.',
  $ans$
## First Non-Repeating Character in a String

### Method 1: LinkedHashMap (Preserves Insertion Order)

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class FirstNonRepeatingChar {
    public static void main(String[] args) {
        String str = "aabbcdeeff";

        LinkedHashMap<Character, Integer> map = new LinkedHashMap<>();

        // Build frequency map (insertion order preserved)
        for (char c : str.toCharArray()) {
            map.put(c, map.getOrDefault(c, 0) + 1);
        }

        // Find first character with count = 1
        char result = ' ';
        for (Map.Entry<Character, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 1) {
                result = entry.getKey();
                break;
            }
        }

        if (result != ' ')
            System.out.println("First non-repeating char: " + result);
        else
            System.out.println("No non-repeating character found");
    }
}
```

### Output
```
First non-repeating char: c
```

### Method 2: Two-Pass with int Array (O(n) — Fastest)

```java
public static char firstNonRepeating(String str) {
    int[] freq = new int[256];  // ASCII frequency array

    // Pass 1: count frequency of each char
    for (char c : str.toCharArray()) freq[c]++;

    // Pass 2: find first char with frequency 1
    for (char c : str.toCharArray()) {
        if (freq[c] == 1) return c;
    }
    return '\0';  // no non-repeating char found
}

System.out.println(firstNonRepeating("aabbcdeeff")); // c
System.out.println(firstNonRepeating("aabb"));        // \0 (none)
System.out.println(firstNonRepeating("Selenium"));    // S
```

### Method 3: Java 8 Stream

```java
String str = "aabbcdeeff";

Optional<Character> first = str.chars()
    .mapToObj(c -> (char) c)
    .filter(c -> str.indexOf(c) == str.lastIndexOf(c))  // appears only once
    .findFirst();

first.ifPresent(c -> System.out.println("First non-repeating: " + c));
// → c
```

### Test Multiple Strings

```java
String[] tests = { "aabbcdeeff", "aabb", "Selenium", "swiss", "abcdef" };

for (String s : tests) {
    char result = firstNonRepeating(s);
    System.out.println("\"" + s + "\" → " +
        (result == '\0' ? "None" : String.valueOf(result)));
}
```

### Output
```
"aabbcdeeff" → c
"aabb"       → None
"Selenium"   → S
"swiss"      → w
"abcdef"     → a
```

### LinkedHashMap vs HashMap — Why It Matters Here

```
HashMap:       {a=2, b=2, c=1, d=1, e=2, f=2}  → order NOT guaranteed
LinkedHashMap: {a=2, b=2, c=1, d=1, e=2, f=2}  → insertion order guaranteed
               → iterating gives c as first with count 1 ✓
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','String','LinkedHashMap','HashMap','Character Frequency','Interview'],
  true, 0
),

-- Q59
(
  'Write a Java program to find the missing number in an array of 1 to N.',
  'java-prog-q059-find-missing-number',
  'Use the mathematical formula: sum of 1 to N = N*(N+1)/2. Subtract the actual sum of array elements from the expected sum — the difference is the missing number. O(n) time, O(1) space. No sorting needed.',
  $ans$
## Find Missing Number in Array (1 to N)

```java
public class FindMissingNumber {
    public static void main(String[] args) {
        // Array should contain 1 to 10, but 7 is missing
        int arr[] = { 1, 2, 3, 4, 5, 6, 8, 9, 10 };
        int n     = 10;  // numbers should be 1 to n

        // Expected sum of 1 to n = n*(n+1)/2
        int expectedSum = n * (n + 1) / 2;  // 55

        // Actual sum of array elements
        int actualSum = 0;
        for (int num : arr) actualSum += num;  // 48

        int missing = expectedSum - actualSum;

        System.out.println("Expected sum: " + expectedSum);  // 55
        System.out.println("Actual sum:   " + actualSum);    // 48
        System.out.println("Missing number: " + missing);    // 7
    }
}
```

### Output
```
Expected sum: 55
Actual sum:   48
Missing number: 7
```

### Why This Works

```
1+2+3+4+5+6+7+8+9+10 = 55  (expected)
1+2+3+4+5+6+  8+9+10 = 48  (actual — 7 is missing)
55 - 48 = 7  ← missing number
```

### Using XOR (Handles Large Numbers — No Overflow)

```java
public static int findMissingXOR(int[] arr, int n) {
    int xorAll   = 0;
    int xorArray = 0;

    // XOR of all numbers 1 to n
    for (int i = 1; i <= n; i++) xorAll ^= i;

    // XOR of all array elements
    for (int num : arr) xorArray ^= num;

    // XOR cancels matching numbers, leaving the missing one
    return xorAll ^ xorArray;
}

int[] arr = { 1, 2, 3, 4, 5, 6, 8, 9, 10 };
System.out.println("Missing: " + findMissingXOR(arr, 10));  // 7
```

### Stream Version

```java
int[] arr = { 1, 2, 3, 4, 5, 6, 8, 9, 10 };
int n = 10;

int expectedSum = n * (n + 1) / 2;
int actualSum   = java.util.Arrays.stream(arr).sum();

System.out.println("Missing: " + (expectedSum - actualSum));  // 7
```

### Find Multiple Missing Numbers

```java
import java.util.*;

int[] arr = { 1, 2, 4, 6, 7, 9 };  // missing: 3, 5, 8
int n = 9;

Set<Integer> set = new HashSet<>();
for (int num : arr) set.add(num);

System.out.print("Missing numbers: ");
for (int i = 1; i <= n; i++) {
    if (!set.contains(i)) System.out.print(i + " ");
}
// → Missing numbers: 3 5 8
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Array','Missing Number','XOR','Math Formula','Interview'],
  true, 0
),

-- Q60
(
  'Write a Java program to rotate an array left and right by K positions.',
  'java-prog-q060-rotate-array',
  'Left rotate by K: elements shift left by K positions, first K elements move to end. Right rotate by K: elements shift right, last K elements move to front. Use reversal algorithm (3 reverses) for O(n) time O(1) space, or temp array for simplicity.',
  $ans$
## Rotate Array Left and Right

### Left Rotation by K Positions

```java
import java.util.Arrays;

public class RotateArray {

    // Left rotate: shift all elements left by 1, move first to end
    public static void leftRotateByOne(int[] arr) {
        int first = arr[0];
        for (int i = 0; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr[arr.length - 1] = first;
    }

    public static void leftRotate(int[] arr, int k) {
        int n = arr.length;
        k = k % n;  // handle k > n
        for (int i = 0; i < k; i++) {
            leftRotateByOne(arr);
        }
    }

    public static void main(String[] args) {
        int[] arr = { 1, 2, 3, 4, 5 };
        System.out.println("Original:     " + Arrays.toString(arr));

        leftRotate(arr, 2);
        System.out.println("Left by 2:    " + Arrays.toString(arr));
        // → [3, 4, 5, 1, 2]
    }
}
```

### Output
```
Original:  [1, 2, 3, 4, 5]
Left by 2: [3, 4, 5, 1, 2]
```

### Efficient Rotation Using Reversal Algorithm (O(n), O(1))

```java
public static void reverse(int[] arr, int left, int right) {
    while (left < right) {
        int temp = arr[left];
        arr[left++] = arr[right];
        arr[right--] = temp;
    }
}

public static void leftRotateEfficient(int[] arr, int k) {
    int n = arr.length;
    k = k % n;
    reverse(arr, 0, k - 1);      // Step 1: reverse first k
    reverse(arr, k, n - 1);      // Step 2: reverse remaining
    reverse(arr, 0, n - 1);      // Step 3: reverse whole array
}

public static void rightRotateEfficient(int[] arr, int k) {
    int n = arr.length;
    k = k % n;
    reverse(arr, 0, n - 1);      // Step 1: reverse whole array
    reverse(arr, 0, k - 1);      // Step 2: reverse first k
    reverse(arr, k, n - 1);      // Step 3: reverse remaining
}

// Test
int[] arr1 = { 1, 2, 3, 4, 5 };
leftRotateEfficient(arr1, 2);
System.out.println("Left by 2:  " + Arrays.toString(arr1));  // [3, 4, 5, 1, 2]

int[] arr2 = { 1, 2, 3, 4, 5 };
rightRotateEfficient(arr2, 2);
System.out.println("Right by 2: " + Arrays.toString(arr2));  // [4, 5, 1, 2, 3]
```

### Simple Approach Using Temp Array

```java
public static int[] rotateLeft(int[] arr, int k) {
    int n = arr.length;
    k = k % n;
    int[] result = new int[n];

    for (int i = 0; i < n; i++) {
        result[(i - k + n) % n] = arr[i];
    }
    return result;
}

public static int[] rotateRight(int[] arr, int k) {
    int n = arr.length;
    k = k % n;
    int[] result = new int[n];

    for (int i = 0; i < n; i++) {
        result[(i + k) % n] = arr[i];
    }
    return result;
}
```

### Using Collections.rotate()

```java
import java.util.*;

List<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
Collections.rotate(list, 2);   // right rotate by 2
System.out.println(list);      // [4, 5, 1, 2, 3]

Collections.rotate(list, -2);  // left rotate by 2
System.out.println(list);      // [1, 2, 3, 4, 5]
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Array','Rotate','Reversal Algorithm','Collections.rotate','Interview'],
  true, 0
),

-- Q61
(
  'Write a Java program to demonstrate OOP Inheritance — single, multilevel, and hierarchical.',
  'java-prog-q061-oop-inheritance',
  'Inheritance allows a child class to acquire properties and methods of a parent class using extends keyword. Types: Single (A→B), Multilevel (A→B→C), Hierarchical (A→B and A→C). Java does not support multiple class inheritance but supports it via interfaces.',
  $ans$
## OOP Inheritance in Java

### Single Inheritance (Parent → Child)

```java
// Parent class
class Animal {
    String name;

    void eat() {
        System.out.println(name + " eats food");
    }

    void breathe() {
        System.out.println(name + " breathes air");
    }
}

// Child class inherits from Animal
class Dog extends Animal {
    void bark() {
        System.out.println(name + " barks: Woof!");
    }
}

public class SingleInheritance {
    public static void main(String[] args) {
        Dog dog = new Dog();
        dog.name = "Buddy";

        dog.eat();     // inherited from Animal
        dog.breathe(); // inherited from Animal
        dog.bark();    // Dog's own method
    }
}
```

### Output
```
Buddy eats food
Buddy breathes air
Buddy barks: Woof!
```

### Multilevel Inheritance (A → B → C)

```java
class Vehicle {
    void start() { System.out.println("Vehicle started"); }
}

class Car extends Vehicle {
    void drive() { System.out.println("Car is driving"); }
}

class ElectricCar extends Car {
    void charge() { System.out.println("Electric car is charging"); }
}

public class MultilevelInheritance {
    public static void main(String[] args) {
        ElectricCar tesla = new ElectricCar();
        tesla.start();   // from Vehicle (grandparent)
        tesla.drive();   // from Car (parent)
        tesla.charge();  // own method
    }
}
```

### Output
```
Vehicle started
Car is driving
Electric car is charging
```

### Hierarchical Inheritance (One Parent → Multiple Children)

```java
class WebDriver {
    void open(String url) { System.out.println("Opening: " + url); }
    void close() { System.out.println("Browser closed"); }
}

class ChromeDriver extends WebDriver {
    void launchChrome() { System.out.println("Chrome launched"); }
}

class FirefoxDriver extends WebDriver {
    void launchFirefox() { System.out.println("Firefox launched"); }
}

public class HierarchicalInheritance {
    public static void main(String[] args) {
        ChromeDriver chrome = new ChromeDriver();
        chrome.launchChrome();           // own
        chrome.open("https://google.com"); // inherited

        FirefoxDriver firefox = new FirefoxDriver();
        firefox.launchFirefox();         // own
        firefox.close();                 // inherited
    }
}
```

### Key Concepts

| Concept | Description |
|---|---|
| `extends` | Keyword to inherit from parent class |
| `super()` | Call parent class constructor |
| `super.method()` | Call parent class method |
| `@Override` | Override parent method in child |
| Method Overriding | Child redefines parent method |
| `instanceof` | Check if object is instance of a class |

### Using super keyword

```java
class Parent {
    String name = "Parent";
    void display() { System.out.println("Parent class"); }
}

class Child extends Parent {
    String name = "Child";

    void display() {
        super.display();           // call parent method
        System.out.println("Child class");
        System.out.println("Parent name: " + super.name);  // parent field
        System.out.println("Child name: " + this.name);    // child field
    }
}
```

### Java Does NOT Support Multiple Inheritance (with classes)

```java
// This causes compile error:
// class C extends A, B {}  // ERROR: multiple inheritance not allowed

// Use interfaces instead:
interface A { void methodA(); }
interface B { void methodB(); }
class C implements A, B {
    public void methodA() { System.out.println("A"); }
    public void methodB() { System.out.println("B"); }
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','OOP','Inheritance','extends','super','Multilevel','Hierarchical'],
  true, 0
),

-- Q62
(
  'Write a Java program to demonstrate method overloading and method overriding (polymorphism).',
  'java-prog-q062-overloading-vs-overriding',
  'Overloading: same method name, different parameters, resolved at compile time (static polymorphism). Overriding: child class redefines parent method with same signature, resolved at runtime (dynamic polymorphism). Both are core OOP interview topics.',
  $ans$
## Method Overloading vs Method Overriding

### Method Overloading (Compile-Time / Static Polymorphism)

```java
public class MethodOverloading {

    // Same method name, different parameter types/count
    int add(int a, int b) {
        return a + b;
    }

    double add(double a, double b) {
        return a + b;
    }

    int add(int a, int b, int c) {
        return a + b + c;
    }

    String add(String a, String b) {
        return a + b;     // string concatenation
    }

    public static void main(String[] args) {
        MethodOverloading obj = new MethodOverloading();

        System.out.println(obj.add(2, 3));           // 5       → int version
        System.out.println(obj.add(2.5, 3.5));       // 6.0     → double version
        System.out.println(obj.add(1, 2, 3));        // 6       → three-param version
        System.out.println(obj.add("Hello", "World")); // HelloWorld → String version
    }
}
```

### Output
```
5
6.0
6
HelloWorld
```

### Method Overriding (Runtime / Dynamic Polymorphism)

```java
class Shape {
    String color = "White";

    void draw() {
        System.out.println("Drawing a shape in " + color);
    }

    double area() {
        return 0;
    }
}

class Circle extends Shape {
    double radius;

    Circle(double r) { this.radius = r; }

    @Override
    void draw() {   // overrides Shape.draw()
        System.out.println("Drawing a CIRCLE with radius " + radius);
    }

    @Override
    double area() {
        return Math.PI * radius * radius;
    }
}

class Rectangle extends Shape {
    double width, height;

    Rectangle(double w, double h) { this.width = w; this.height = h; }

    @Override
    void draw() {
        System.out.println("Drawing a RECTANGLE " + width + "x" + height);
    }

    @Override
    double area() {
        return width * height;
    }
}

public class MethodOverriding {
    public static void main(String[] args) {
        // Runtime polymorphism — which draw() is called determined at runtime
        Shape s1 = new Circle(5.0);
        Shape s2 = new Rectangle(4.0, 6.0);

        s1.draw();    // Circle's draw()
        s2.draw();    // Rectangle's draw()

        System.out.printf("Circle area:    %.2f%n", s1.area());
        System.out.printf("Rectangle area: %.2f%n", s2.area());
    }
}
```

### Output
```
Drawing a CIRCLE with radius 5.0
Drawing a RECTANGLE 4.0x6.0
Circle area:    78.54
Rectangle area: 24.00
```

### Overloading vs Overriding — Key Differences

| | Method Overloading | Method Overriding |
|---|---|---|
| Class | Same class | Parent + Child class |
| Parameters | Must differ | Must be same |
| Return type | Can differ | Must be same (or covariant) |
| Binding | Compile time (static) | Runtime (dynamic) |
| Polymorphism | Static / compile-time | Dynamic / runtime |
| `@Override` | Not needed | Recommended |
| `private`/`static` | Can overload | Cannot override |

### Common Interview Question: Can we override static methods?

```java
class Parent {
    static void display() { System.out.println("Parent static"); }
    void show()           { System.out.println("Parent instance"); }
}

class Child extends Parent {
    // This is METHOD HIDING, NOT overriding
    static void display() { System.out.println("Child static"); }

    @Override
    void show() { System.out.println("Child instance"); }  // true override
}

Parent obj = new Child();
obj.display();  // "Parent static" — static: resolved at compile time
obj.show();     // "Child instance" — instance: resolved at runtime
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','OOP','Overloading','Overriding','Polymorphism','@Override','Interview'],
  true, 0
),

-- Q63
(
  'Write a Java program to demonstrate abstract class and interface — their differences and when to use each.',
  'java-prog-q063-abstract-interface',
  'Abstract class: partial implementation, can have constructors, instance variables, concrete methods. Interface: contract (pure abstraction), all methods abstract by default (Java 8+ allows default/static). A class can extend one abstract class but implement multiple interfaces.',
  $ans$
## Abstract Class and Interface in Java

### Abstract Class

```java
// Abstract class — can have abstract + concrete methods
abstract class Browser {
    String name;               // instance variable
    String version;

    Browser(String name) {     // constructor allowed
        this.name = name;
    }

    // Abstract method — no body, subclass MUST implement
    abstract void launch();
    abstract void close();

    // Concrete method — already implemented
    void takescreenshot() {
        System.out.println("[" + name + "] Screenshot taken");
    }

    void printInfo() {
        System.out.println("Browser: " + name);
    }
}

class Chrome extends Browser {
    Chrome() { super("Chrome"); }

    @Override
    public void launch() { System.out.println("Chrome launched"); }

    @Override
    public void close() { System.out.println("Chrome closed"); }
}

class Firefox extends Browser {
    Firefox() { super("Firefox"); }

    @Override
    public void launch() { System.out.println("Firefox launched"); }

    @Override
    public void close() { System.out.println("Firefox closed"); }
}

public class AbstractDemo {
    public static void main(String[] args) {
        Browser b1 = new Chrome();
        b1.launch();
        b1.takescreenshot();
        b1.close();

        Browser b2 = new Firefox();
        b2.launch();
        b2.printInfo();
        b2.close();
    }
}
```

### Output
```
Chrome launched
[Chrome] Screenshot taken
Chrome closed
Firefox launched
Browser: Firefox
Firefox closed
```

### Interface

```java
// Interface — pure contract (all methods are public abstract by default)
interface Clickable {
    void click();
    void doubleClick();

    // Java 8: default method (has body)
    default void highlight() {
        System.out.println("Element highlighted");
    }

    // Java 8: static method
    static void printInfo() {
        System.out.println("Clickable interface");
    }
}

interface Typeable {
    void type(String text);
    void clear();
}

// Class implementing MULTIPLE interfaces
class TextBox implements Clickable, Typeable {
    String locator;

    TextBox(String locator) { this.locator = locator; }

    @Override public void click()              { System.out.println("Clicked " + locator); }
    @Override public void doubleClick()        { System.out.println("Double-clicked " + locator); }
    @Override public void type(String text)    { System.out.println("Typed '" + text + "' into " + locator); }
    @Override public void clear()              { System.out.println("Cleared " + locator); }
}

TextBox input = new TextBox("username-field");
input.click();
input.clear();
input.type("admin@test.com");
input.highlight();          // default method
Clickable.printInfo();      // static method
```

### Abstract Class vs Interface

| | Abstract Class | Interface |
|---|---|---|
| Keyword | `abstract class` | `interface` |
| Methods | Abstract + Concrete | Abstract (default/static in Java 8+) |
| Variables | Any type | `public static final` only |
| Constructor | Yes | No |
| Inheritance | `extends` (one only) | `implements` (multiple allowed) |
| Access modifiers | Any | `public` only |
| Use when | Base class with shared code | Contract/capability for unrelated classes |

### When to Use Each

```
Abstract Class:
✓ Classes share common code (e.g., BasePage with driver, wait)
✓ "IS-A" relationship (Chrome IS-A Browser)
✓ Need constructor logic

Interface:
✓ Unrelated classes share a contract (e.g., all clickable elements)
✓ Need multiple inheritance
✓ "CAN-DO" / capability relationship
✓ Defining API contracts
```

### Real Automation Example

```java
// Abstract BasePage — shared code for all Page Objects
abstract class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait   = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    protected WebElement waitForElement(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    abstract void verifyPageLoaded();  // each page must verify its own load
}
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','OOP','Abstract Class','Interface','extends','implements','BasePage'],
  true, 0
),

-- Q64
(
  'Write a Java program to implement the Singleton Design Pattern.',
  'java-prog-q064-singleton-pattern',
  'Singleton ensures only ONE instance of a class exists throughout the application. Private constructor prevents external instantiation. Static getInstance() returns the same instance every time. Critical in automation for WebDriver manager — one driver per thread.',
  $ans$
## Singleton Design Pattern in Java

### Basic Singleton (Lazy Initialization)

```java
public class Singleton {
    // Static variable holds the single instance
    private static Singleton instance;

    // Private constructor prevents instantiation from outside
    private Singleton() {
        System.out.println("Singleton instance created");
    }

    // Public static method to get/create the instance
    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();   // create only if not exists
        }
        return instance;
    }

    public void showMessage() {
        System.out.println("Hello from Singleton!");
    }
}

public class SingletonDemo {
    public static void main(String[] args) {
        Singleton obj1 = Singleton.getInstance();
        Singleton obj2 = Singleton.getInstance();
        Singleton obj3 = Singleton.getInstance();

        obj1.showMessage();

        // All references point to the SAME object
        System.out.println("obj1 == obj2: " + (obj1 == obj2));  // true
        System.out.println("obj1 == obj3: " + (obj1 == obj3));  // true
        System.out.println("Hashcode: " + obj1.hashCode() + " == " + obj2.hashCode());
    }
}
```

### Output
```
Singleton instance created
Hello from Singleton!
obj1 == obj2: true
obj1 == obj3: true
Hashcode: 366712642 == 366712642
```

### Thread-Safe Singleton (Double-Checked Locking)

```java
public class ThreadSafeSingleton {
    // volatile ensures visibility across threads
    private static volatile ThreadSafeSingleton instance;

    private ThreadSafeSingleton() {}

    public static ThreadSafeSingleton getInstance() {
        if (instance == null) {                          // first check (no lock)
            synchronized (ThreadSafeSingleton.class) {  // lock only when needed
                if (instance == null) {                  // second check (with lock)
                    instance = new ThreadSafeSingleton();
                }
            }
        }
        return instance;
    }
}
```

### Eager Initialization (Simplest Thread-Safe)

```java
public class EagerSingleton {
    // Created when class loads — always thread-safe
    private static final EagerSingleton INSTANCE = new EagerSingleton();

    private EagerSingleton() {}

    public static EagerSingleton getInstance() {
        return INSTANCE;
    }
}
```

### Real Automation Example: WebDriver Manager Singleton

```java
public class DriverManager {
    private static DriverManager instance;
    private WebDriver driver;

    private DriverManager() {}

    public static DriverManager getInstance() {
        if (instance == null) {
            instance = new DriverManager();
        }
        return instance;
    }

    public WebDriver getDriver() {
        if (driver == null || ((ChromeDriver) driver).getSessionId() == null) {
            driver = new ChromeDriver();
            driver.manage().window().maximize();
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

// Usage in any test or page object:
WebDriver driver = DriverManager.getInstance().getDriver();
```

### Singleton with ThreadLocal for Parallel Tests

```java
public class ParallelDriverManager {
    // Each thread gets its OWN driver instance
    private static ThreadLocal<WebDriver> driverThread = new ThreadLocal<>();

    public static void setDriver(WebDriver driver) { driverThread.set(driver); }
    public static WebDriver getDriver()             { return driverThread.get(); }
    public static void removeDriver()               { driverThread.remove(); }
}
```

### When to Use Singleton

| Use Case | Example |
|---|---|
| WebDriver management | One driver per test class |
| Configuration reader | Read config.properties once |
| Logger | Single log writer |
| Database connection | Single connection pool |
| Report manager | Single Extent report |
$ans$,
  'Java Programs', 'Coding', 'Intermediate', 'Advanced',
  ARRAY['Java','Design Pattern','Singleton','WebDriver','ThreadLocal','Automation'],
  true, 0
),

-- Q65
(
  'Write a Java program to sort custom objects using Comparable and Comparator interfaces.',
  'java-prog-q065-comparable-comparator',
  'Comparable (java.lang): implement in the class itself via compareTo() — defines natural ordering. Comparator (java.util): external comparison class/lambda — defines custom ordering. Use Comparator when you need multiple sort orders or can''t modify the class.',
  $ans$
## Comparable vs Comparator in Java

### Comparable — Natural Ordering (Built into Class)

```java
import java.util.*;

class Employee implements Comparable<Employee> {
    int id;
    String name;
    double salary;

    Employee(int id, String name, double salary) {
        this.id = id; this.name = name; this.salary = salary;
    }

    // Define natural ordering — sort by ID ascending
    @Override
    public int compareTo(Employee other) {
        return this.id - other.id;  // negative=this before other, 0=equal, positive=other before this
    }

    @Override
    public String toString() {
        return "[" + id + "] " + name + " ($" + salary + ")";
    }
}

public class ComparableDemo {
    public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee(3, "Charlie", 75000));
        employees.add(new Employee(1, "Alice",   90000));
        employees.add(new Employee(2, "Bob",     80000));

        Collections.sort(employees);  // uses compareTo()
        System.out.println("Sorted by ID (natural order):");
        employees.forEach(System.out::println);
    }
}
```

### Output
```
Sorted by ID (natural order):
[1] Alice ($90000.0)
[2] Bob ($80000.0)
[3] Charlie ($75000.0)
```

### Comparator — Custom/Multiple Orderings (External)

```java
import java.util.Comparator;

public class ComparatorDemo {
    public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>(Arrays.asList(
            new Employee(3, "Charlie", 75000),
            new Employee(1, "Alice",   90000),
            new Employee(2, "Bob",     80000)
        ));

        // Sort by name alphabetically
        Comparator<Employee> byName = Comparator.comparing(e -> e.name);
        employees.sort(byName);
        System.out.println("By name:");
        employees.forEach(System.out::println);

        // Sort by salary descending
        employees.sort(Comparator.comparingDouble((Employee e) -> e.salary).reversed());
        System.out.println("\nBy salary (descending):");
        employees.forEach(System.out::println);

        // Sort by salary, then by name (chained)
        employees.sort(
            Comparator.comparingDouble((Employee e) -> e.salary)
                      .thenComparing(e -> e.name)
        );
        System.out.println("\nBy salary then name:");
        employees.forEach(System.out::println);
    }
}
```

### Output
```
By name:
[1] Alice ($90000.0)
[2] Bob ($80000.0)
[3] Charlie ($75000.0)

By salary (descending):
[1] Alice ($90000.0)
[2] Bob ($80000.0)
[3] Charlie ($75000.0)

By salary then name:
[3] Charlie ($75000.0)
[2] Bob ($80000.0)
[1] Alice ($90000.0)
```

### Comparable vs Comparator Summary

| | Comparable | Comparator |
|---|---|---|
| Package | `java.lang` | `java.util` |
| Method | `compareTo(T o)` | `compare(T o1, T o2)` |
| Implemented in | The class itself | Separate class or lambda |
| Sort orders | One (natural) | Many (multiple Comparators) |
| Modifying class | Required | Not required |
| Usage | `Collections.sort(list)` | `Collections.sort(list, comp)` |

### Lambda Comparators (Java 8+)

```java
// Sort strings by length
List<String> tools = Arrays.asList("Selenium", "TestNG", "Cucumber", "Maven");

tools.sort((a, b) -> a.length() - b.length());
System.out.println("By length: " + tools);
// → [Maven, TestNG, Cucumber, Selenium]

// Using Comparator.comparingInt
tools.sort(Comparator.comparingInt(String::length).reversed());
System.out.println("By length desc: " + tools);
// → [Selenium, Cucumber, TestNG, Maven]
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Comparable','Comparator','Sorting','OOP','Collections','Lambda'],
  true, 0
),

-- Q66
(
  'Write a Java program to demonstrate LinkedList operations and compare with ArrayList.',
  'java-prog-q066-linkedlist',
  'LinkedList is a doubly-linked list implementation of List and Deque. It allows O(1) add/remove at both ends (as Queue/Stack), but O(n) random access. Use ArrayList for frequent reads, LinkedList for frequent insertions/deletions at head or tail.',
  $ans$
## LinkedList in Java

```java
import java.util.LinkedList;

public class LinkedListDemo {
    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<>();

        // Add elements
        list.add("Selenium");       // adds to tail
        list.add("TestNG");
        list.add("Cucumber");
        list.addFirst("Maven");     // adds to head
        list.addLast("Jenkins");    // adds to tail

        System.out.println("List: " + list);
        System.out.println("Size: " + list.size());

        // Access elements
        System.out.println("First: " + list.getFirst());  // Maven
        System.out.println("Last:  " + list.getLast());   // Jenkins
        System.out.println("Index 2: " + list.get(2));    // Selenium

        // Remove elements
        list.removeFirst();             // remove Maven
        list.removeLast();              // remove Jenkins
        list.remove("Cucumber");        // remove by value
        System.out.println("After remove: " + list);

        // Peek (view without removing)
        System.out.println("Peek first: " + list.peekFirst());
        System.out.println("Peek last:  " + list.peekLast());

        // Iterate
        System.out.println("\nIterating:");
        for (String tool : list) {
            System.out.println(tool);
        }
    }
}
```

### Output
```
List: [Maven, Selenium, TestNG, Cucumber, Jenkins]
Size: 5
First: Maven
Last:  Jenkins
Index 2: TestNG
After remove: [Selenium, TestNG]
Peek first: Selenium
Peek last:  TestNG

Iterating:
Selenium
TestNG
```

### LinkedList as Stack (LIFO)

```java
LinkedList<String> stack = new LinkedList<>();

stack.push("Page1");    // push to top (addFirst)
stack.push("Page2");
stack.push("Page3");

System.out.println("Stack: " + stack);     // [Page3, Page2, Page1]
System.out.println("Pop:   " + stack.pop());  // removes Page3
System.out.println("Peek:  " + stack.peek()); // views Page2 without removing
System.out.println("Stack: " + stack);     // [Page2, Page1]
```

### LinkedList as Queue (FIFO)

```java
LinkedList<String> queue = new LinkedList<>();

queue.offer("Test1");   // add to tail
queue.offer("Test2");
queue.offer("Test3");

System.out.println("Queue: " + queue);      // [Test1, Test2, Test3]
System.out.println("Poll:  " + queue.poll()); // removes Test1 (head)
System.out.println("Peek:  " + queue.peek()); // views Test2
System.out.println("Queue: " + queue);      // [Test2, Test3]
```

### ArrayList vs LinkedList

| | ArrayList | LinkedList |
|---|---|---|
| Internal | Dynamic array | Doubly linked list |
| Random access `get(i)` | O(1) — fast | O(n) — slow |
| Add/remove at end | O(1) amortized | O(1) |
| Add/remove at middle | O(n) — shifts | O(1) after finding node |
| Memory | Less (no pointers) | More (stores prev+next) |
| Use when | Read-heavy | Insert/delete-heavy |
| Implements | List | List, Deque, Queue, Stack |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','LinkedList','Collections','Queue','Stack','ArrayList','Deque'],
  true, 0
),

-- Q67
(
  'Write a Java program to demonstrate Stack and Queue operations.',
  'java-prog-q067-stack-queue',
  'Stack (LIFO — Last In First Out): push adds to top, pop removes from top. Queue (FIFO — First In First Out): offer adds to tail, poll removes from head. Java provides Stack class and LinkedList/ArrayDeque for Queue. Used in BFS, DFS, undo operations.',
  $ans$
## Stack and Queue in Java

### Stack — LIFO (Last In First Out)

```java
import java.util.Stack;

public class StackDemo {
    public static void main(String[] args) {
        Stack<String> stack = new Stack<>();

        // push — add to top
        stack.push("LoginPage");
        stack.push("ProductPage");
        stack.push("CartPage");
        stack.push("CheckoutPage");

        System.out.println("Stack: " + stack);
        System.out.println("Top (peek): " + stack.peek());  // view without removing
        System.out.println("Size: " + stack.size());

        // pop — remove from top (LIFO)
        System.out.println("\nPopping in LIFO order:");
        while (!stack.isEmpty()) {
            System.out.println("Popped: " + stack.pop());
        }
    }
}
```

### Output
```
Stack: [LoginPage, ProductPage, CartPage, CheckoutPage]
Top (peek): CheckoutPage
Size: 4

Popping in LIFO order:
Popped: CheckoutPage
Popped: CartPage
Popped: ProductPage
Popped: LoginPage
```

### Queue — FIFO (First In First Out)

```java
import java.util.LinkedList;
import java.util.Queue;

public class QueueDemo {
    public static void main(String[] args) {
        Queue<String> queue = new LinkedList<>();

        // offer — add to tail
        queue.offer("Test1-Login");
        queue.offer("Test2-Search");
        queue.offer("Test3-Checkout");
        queue.offer("Test4-Logout");

        System.out.println("Queue: " + queue);
        System.out.println("Front (peek): " + queue.peek());  // view without removing
        System.out.println("Size: " + queue.size());

        // poll — remove from head (FIFO)
        System.out.println("\nProcessing in FIFO order:");
        while (!queue.isEmpty()) {
            System.out.println("Processing: " + queue.poll());
        }
    }
}
```

### Output
```
Queue: [Test1-Login, Test2-Search, Test3-Checkout, Test4-Logout]
Front (peek): Test1-Login
Size: 4

Processing in FIFO order:
Processing: Test1-Login
Processing: Test2-Search
Processing: Test3-Checkout
Processing: Test4-Logout
```

### ArrayDeque (Preferred over Stack and LinkedList)

```java
import java.util.ArrayDeque;
import java.util.Deque;

Deque<String> deque = new ArrayDeque<>();

// Use as Stack
deque.push("A");    deque.push("B");    deque.push("C");
System.out.println("Pop:  " + deque.pop());   // C (LIFO)

// Use as Queue
deque.offer("X");   deque.offer("Y");
System.out.println("Poll: " + deque.poll());  // A (FIFO — next in line)
```

### Stack Methods vs Queue Methods

| Operation | Stack (LIFO) | Queue (FIFO) |
|---|---|---|
| Add element | `push(e)` | `offer(e)` |
| Remove element | `pop()` | `poll()` |
| View top/front | `peek()` | `peek()` |
| Check empty | `isEmpty()` | `isEmpty()` |
| Throws on empty | `pop()` throws | `poll()` returns null |

### Automation Testing Relevance

```java
// Track browser navigation history using Stack
Stack<String> pageHistory = new Stack<>();
pageHistory.push(driver.getCurrentUrl());

// Navigate forward
driver.get("https://example.com/products");
pageHistory.push(driver.getCurrentUrl());

// Go back to previous page
pageHistory.pop();                        // remove current
driver.get(pageHistory.peek());           // navigate to previous
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Stack','Queue','LIFO','FIFO','ArrayDeque','Collections'],
  true, 0
),

-- Q68
(
  'Write a Java program to check if a string contains only digits, only alphabets, or is alphanumeric.',
  'java-prog-q068-string-validation',
  'Use Character class methods (isDigit, isLetter, isLetterOrDigit) in a loop, or regex with matches(). Common validation patterns: "\\d+" for digits only, "[a-zA-Z]+" for letters only, "[a-zA-Z0-9]+" for alphanumeric. Used heavily in form field validation in automation.',
  $ans$
## String Validation — Digits, Alphabets, Alphanumeric

```java
public class StringValidation {
    public static void main(String[] args) {

        String s1 = "12345";
        String s2 = "HelloWorld";
        String s3 = "Hello123";
        String s4 = "Hello@123";

        System.out.println("--- Checking: " + s1 + " ---");
        System.out.println("Only digits:     " + isOnlyDigits(s1));    // true
        System.out.println("Only alphabets:  " + isOnlyAlpha(s1));     // false
        System.out.println("Alphanumeric:    " + isAlphanumeric(s1));  // true

        System.out.println("\n--- Checking: " + s2 + " ---");
        System.out.println("Only digits:     " + isOnlyDigits(s2));    // false
        System.out.println("Only alphabets:  " + isOnlyAlpha(s2));     // true
        System.out.println("Alphanumeric:    " + isAlphanumeric(s2));  // true

        System.out.println("\n--- Checking: " + s4 + " ---");
        System.out.println("Only digits:     " + isOnlyDigits(s4));    // false
        System.out.println("Only alphabets:  " + isOnlyAlpha(s4));     // false
        System.out.println("Alphanumeric:    " + isAlphanumeric(s4));  // false
    }

    static boolean isOnlyDigits(String s) {
        return s.matches("\\d+");                  // one or more digits
    }

    static boolean isOnlyAlpha(String s) {
        return s.matches("[a-zA-Z]+");             // one or more letters
    }

    static boolean isAlphanumeric(String s) {
        return s.matches("[a-zA-Z0-9]+");          // letters and digits only
    }
}
```

### Method 2: Character Class Methods (No Regex)

```java
public static boolean isDigitsOnly(String s) {
    for (char c : s.toCharArray()) {
        if (!Character.isDigit(c)) return false;
    }
    return !s.isEmpty();
}

public static boolean isAlphabetsOnly(String s) {
    for (char c : s.toCharArray()) {
        if (!Character.isLetter(c)) return false;
    }
    return !s.isEmpty();
}

public static boolean isAlphanumericOnly(String s) {
    for (char c : s.toCharArray()) {
        if (!Character.isLetterOrDigit(c)) return false;
    }
    return !s.isEmpty();
}
```

### Method 3: Java 8 Streams

```java
String s = "Hello123";

boolean allDigits = s.chars().allMatch(Character::isDigit);
boolean allLetters = s.chars().allMatch(Character::isLetter);
boolean allAlphanumeric = s.chars().allMatch(Character::isLetterOrDigit);
boolean hasUpperCase = s.chars().anyMatch(Character::isUpperCase);
boolean hasLowerCase = s.chars().anyMatch(Character::isLowerCase);
boolean hasDigit = s.chars().anyMatch(Character::isDigit);
boolean hasSpecial = s.chars().anyMatch(c -> !Character.isLetterOrDigit(c));
```

### Common Regex Patterns for Validation

```java
// Email validation
boolean isEmail = email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");

// Phone number (10 digits)
boolean isPhone = phone.matches("\\d{10}");

// Strong password (min 8 chars, upper, lower, digit, special)
boolean strongPass = pass.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$]).{8,}$");

// Only spaces
boolean onlySpaces = s.matches("\\s+");

// No special characters
boolean noSpecial = s.matches("[a-zA-Z0-9 ]+");
```

### Automation Testing Relevance

```java
// Validate form field accepts only numbers
String ageInput = driver.findElement(By.id("age")).getAttribute("value");
assertTrue(ageInput.matches("\\d+"), "Age field should contain only digits");

// Validate email format
String email = driver.findElement(By.id("email")).getAttribute("value");
assertTrue(email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$"),
    "Email format invalid: " + email);
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','String','Validation','Regex','Character','isDigit','isLetter','Stream'],
  true, 0
),

-- Q69
(
  'Write a Java program to find the frequency of each character in a string.',
  'java-prog-q069-char-frequency',
  'Use a HashMap<Character, Integer> to count how many times each character appears. getOrDefault() handles first-time insertion cleanly. Sort the result by frequency using entrySet().stream() and Comparator. Used in frequency analysis and finding most/least common characters.',
  $ans$
## Frequency of Each Character in a String

### Method 1: HashMap

```java
import java.util.*;

public class CharFrequency {
    public static void main(String[] args) {
        String str = "automation";

        HashMap<Character, Integer> freq = new HashMap<>();

        for (char c : str.toCharArray()) {
            freq.put(c, freq.getOrDefault(c, 0) + 1);
        }

        System.out.println("Character Frequencies:");
        for (Map.Entry<Character, Integer> entry : freq.entrySet()) {
            System.out.println("'" + entry.getKey() + "' → " + entry.getValue());
        }
    }
}
```

### Output
```
Character Frequencies:
'a' → 3
'u' → 1
't' → 2
'o' → 2
'm' → 1
'i' → 1
'n' → 1
```

### Sorted by Frequency (Descending)

```java
String str = "automation testing";

Map<Character, Long> freq = str.chars()
    .filter(c -> c != ' ')
    .mapToObj(c -> (char) c)
    .collect(java.util.stream.Collectors.groupingBy(
        c -> c, java.util.stream.Collectors.counting()));

// Sort by value descending
freq.entrySet().stream()
    .sorted(Map.Entry.<Character, Long>comparingByValue().reversed())
    .forEach(e -> System.out.println("'" + e.getKey() + "' → " + e.getValue()));
```

### Output
```
't' → 4
'a' → 2
'i' → 2
'o' → 2
'n' → 2
's' → 1
'e' → 1
'u' → 1
'm' → 1
'g' → 1
```

### Find Most and Least Frequent Character

```java
String str = "automation";

Map<Character, Integer> freq = new HashMap<>();
for (char c : str.toCharArray())
    freq.put(c, freq.getOrDefault(c, 0) + 1);

char maxChar = Collections.max(freq.entrySet(),
    Map.Entry.comparingByValue()).getKey();

char minChar = Collections.min(freq.entrySet(),
    Map.Entry.comparingByValue()).getKey();

System.out.println("Most frequent:  '" + maxChar + "' (" + freq.get(maxChar) + " times)");
System.out.println("Least frequent: '" + minChar + "' (" + freq.get(minChar) + " time)");
```

### Output
```
Most frequent:  'a' (3 times)
Least frequent: 'u' (1 time)
```

### Print Frequency Chart

```java
String str = "banana";

Map<Character, Long> freq = str.chars()
    .mapToObj(c -> (char)c)
    .collect(java.util.stream.Collectors.groupingBy(
        c -> c, LinkedHashMap::new, java.util.stream.Collectors.counting()));

freq.forEach((ch, count) -> {
    System.out.printf("'%c': %s (%d)%n", ch, "*".repeat(count.intValue()), count);
});
```

### Output
```
'b': * (1)
'a': *** (3)
'n': ** (2)
```

### Automation Testing Relevance

```java
// Count tag occurrences on a page
List<WebElement> elements = driver.findElements(By.cssSelector("*"));
Map<String, Long> tagFreq = elements.stream()
    .collect(Collectors.groupingBy(
        e -> e.getTagName().toLowerCase(), Collectors.counting()));
tagFreq.entrySet().stream()
    .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
    .limit(5)
    .forEach(e -> System.out.println(e.getKey() + ": " + e.getValue()));
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','HashMap','Character Frequency','Stream','groupingBy','Collectors','Interview'],
  true, 0
),

-- Q70
(
  'Write a Java program to print star patterns — right-angled triangle, inverted triangle, and pyramid.',
  'java-prog-q070-star-patterns',
  'Star patterns test understanding of nested loops — outer loop controls rows, inner loop controls columns/stars. Right triangle: inner loop prints i stars. Pyramid: combine spaces and stars. Inverted: start from n and decrease. Common in fresher Java interviews.',
  $ans$
## Star Patterns in Java

### Pattern 1: Right-Angled Triangle

```java
public class StarPattern1 {
    public static void main(String[] args) {
        int n = 5;

        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= i; j++) {
                System.out.print("* ");
            }
            System.out.println();
        }
    }
}
```

### Output
```
*
* *
* * *
* * * *
* * * * *
```

### Pattern 2: Inverted Triangle

```java
for (int i = n; i >= 1; i--) {
    for (int j = 1; j <= i; j++) {
        System.out.print("* ");
    }
    System.out.println();
}
```

### Output
```
* * * * *
* * * *
* * *
* *
*
```

### Pattern 3: Pyramid (Centered)

```java
for (int i = 1; i <= n; i++) {
    // Print spaces
    for (int j = i; j < n; j++) {
        System.out.print("  ");
    }
    // Print stars
    for (int j = 1; j <= (2 * i - 1); j++) {
        System.out.print("* ");
    }
    System.out.println();
}
```

### Output
```
        *
      * * *
    * * * * *
  * * * * * * *
* * * * * * * * *
```

### Pattern 4: Diamond

```java
// Upper half
for (int i = 1; i <= n; i++) {
    for (int j = i; j < n; j++) System.out.print(" ");
    for (int j = 1; j <= (2*i-1); j++) System.out.print("*");
    System.out.println();
}
// Lower half
for (int i = n-1; i >= 1; i--) {
    for (int j = n; j > i; j--) System.out.print(" ");
    for (int j = 1; j <= (2*i-1); j++) System.out.print("*");
    System.out.println();
}
```

### Output
```
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *
```

### Pattern 5: Number Triangle

```java
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= i; j++) {
        System.out.print(j + " ");
    }
    System.out.println();
}
```

### Output
```
1
1 2
1 2 3
1 2 3 4
1 2 3 4 5
```

### Pattern 6: Hollow Rectangle

```java
int rows = 4, cols = 8;
for (int i = 1; i <= rows; i++) {
    for (int j = 1; j <= cols; j++) {
        if (i == 1 || i == rows || j == 1 || j == cols)
            System.out.print("*");
        else
            System.out.print(" ");
    }
    System.out.println();
}
```

### Output
```
********
*      *
*      *
********
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Beginner',
  ARRAY['Java','Star Pattern','Nested Loops','Pattern','Triangle','Pyramid','Interview'],
  true, 0
),

-- Q71
(
  'Write a Java program to merge two sorted arrays into a single sorted array.',
  'java-prog-q071-merge-sorted-arrays',
  'Use two pointers starting at index 0 of each array. Compare elements at both pointers — copy the smaller one to result array and advance that pointer. After one array is exhausted copy remaining elements from the other. O(m+n) time O(m+n) space.',
  $ans$
## Merge Two Sorted Arrays

### Method 1: Two-Pointer Technique (Efficient)

```java
import java.util.Arrays;

public class MergeSortedArrays {
    public static void main(String[] args) {
        int[] arr1 = { 1, 3, 5, 7, 9 };
        int[] arr2 = { 2, 4, 6, 8, 10 };

        int m = arr1.length, n = arr2.length;
        int[] merged = new int[m + n];

        int i = 0, j = 0, k = 0;

        // Compare elements from both arrays, copy smaller
        while (i < m && j < n) {
            if (arr1[i] <= arr2[j]) {
                merged[k++] = arr1[i++];
            } else {
                merged[k++] = arr2[j++];
            }
        }

        // Copy remaining elements from arr1 (if any)
        while (i < m) merged[k++] = arr1[i++];

        // Copy remaining elements from arr2 (if any)
        while (j < n) merged[k++] = arr2[j++];

        System.out.println("Array 1: " + Arrays.toString(arr1));
        System.out.println("Array 2: " + Arrays.toString(arr2));
        System.out.println("Merged:  " + Arrays.toString(merged));
    }
}
```

### Output
```
Array 1: [1, 3, 5, 7, 9]
Array 2: [2, 4, 6, 8, 10]
Merged:  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

### How Two-Pointer Works

```
arr1: [1, 3, 5, 7, 9]   i=0
arr2: [2, 4, 6, 8, 10]  j=0

Step 1: arr1[0]=1 < arr2[0]=2 → copy 1, i=1  → merged=[1]
Step 2: arr1[1]=3 > arr2[0]=2 → copy 2, j=1  → merged=[1,2]
Step 3: arr1[1]=3 < arr2[1]=4 → copy 3, i=2  → merged=[1,2,3]
...and so on
```

### Method 2: Simple — Combine and Sort

```java
int[] arr1 = { 1, 3, 5 };
int[] arr2 = { 2, 4, 6, 8 };

int[] merged = new int[arr1.length + arr2.length];
System.arraycopy(arr1, 0, merged, 0, arr1.length);
System.arraycopy(arr2, 0, merged, arr1.length, arr2.length);
Arrays.sort(merged);

System.out.println(Arrays.toString(merged));
// → [1, 2, 3, 4, 5, 6, 8]
```

### Method 3: Using Streams (Java 8+)

```java
int[] arr1 = { 1, 3, 5, 7 };
int[] arr2 = { 2, 4, 6, 8 };

int[] merged = IntStream.concat(
    IntStream.of(arr1),
    IntStream.of(arr2)
).sorted().toArray();

System.out.println(Arrays.toString(merged));
// → [1, 2, 3, 4, 5, 6, 7, 8]
```

### Find Intersection of Two Arrays

```java
int[] arr1 = { 1, 2, 3, 4, 5 };
int[] arr2 = { 3, 4, 5, 6, 7 };

Set<Integer> set = new HashSet<>();
for (int n : arr1) set.add(n);

List<Integer> intersection = new ArrayList<>();
for (int n : arr2) {
    if (set.contains(n)) intersection.add(n);
}
System.out.println("Intersection: " + intersection);  // [3, 4, 5]
```
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Array','Merge','Two Pointer','IntStream','Sorted','Algorithm'],
  true, 0
),

-- Q72
(
  'Write a Java program to implement Selection Sort and Insertion Sort algorithms.',
  'java-prog-q072-selection-insertion-sort',
  'Selection Sort: find minimum in unsorted portion, swap to sorted end — O(n²). Insertion Sort: take each element and insert into correct position in sorted portion — O(n²) worst, O(n) best for nearly sorted data. Both are simpler than merge sort but less efficient for large data.',
  $ans$
## Selection Sort and Insertion Sort

### Selection Sort

```java
import java.util.Arrays;

public class SelectionSort {
    public static void main(String[] args) {
        int arr[] = { 64, 25, 12, 22, 11 };

        System.out.println("Before: " + Arrays.toString(arr));

        int n = arr.length;

        for (int i = 0; i < n - 1; i++) {
            // Find minimum element in unsorted portion (i to n-1)
            int minIndex = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIndex]) {
                    minIndex = j;
                }
            }

            // Swap minimum with first unsorted element
            int temp       = arr[minIndex];
            arr[minIndex]  = arr[i];
            arr[i]         = temp;
        }

        System.out.println("After:  " + Arrays.toString(arr));
    }
}
```

### Output
```
Before: [64, 25, 12, 22, 11]
After:  [11, 12, 22, 25, 64]
```

### How Selection Sort Works

```
Pass 1: min=11 at index 4 → swap with index 0 → [11, 25, 12, 22, 64]
Pass 2: min=12 at index 2 → swap with index 1 → [11, 12, 25, 22, 64]
Pass 3: min=22 at index 3 → swap with index 2 → [11, 12, 22, 25, 64]
Pass 4: min=25 at index 3 → already in place  → [11, 12, 22, 25, 64]
```

### Insertion Sort

```java
public class InsertionSort {
    public static void main(String[] args) {
        int arr[] = { 12, 11, 13, 5, 6 };

        System.out.println("Before: " + Arrays.toString(arr));

        int n = arr.length;

        for (int i = 1; i < n; i++) {
            int key = arr[i];  // element to be inserted
            int j   = i - 1;

            // Shift elements greater than key one position right
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;  // insert key at correct position
        }

        System.out.println("After:  " + Arrays.toString(arr));
    }
}
```

### Output
```
Before: [12, 11, 13, 5, 6]
After:  [5, 6, 11, 12, 13]
```

### How Insertion Sort Works

```
i=1: key=11, shift 12 right → [11, 12, 13, 5, 6]
i=2: key=13, 12<13 no shift → [11, 12, 13, 5, 6]
i=3: key=5,  shift 13,12,11 → [5, 11, 12, 13, 6]
i=4: key=6,  shift 13,12,11 → [5, 6, 11, 12, 13]
```

### Sorting Algorithms Comparison

| Algorithm | Best | Average | Worst | Space | Stable |
|---|---|---|---|---|---|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Arrays.sort() | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Sorting','Selection Sort','Insertion Sort','Algorithm','Interview'],
  true, 0
),

-- Q73
(
  'Write a Java program demonstrating Java 8 Streams — filter, map, collect, reduce, flatMap, groupingBy, partitioningBy.',
  'java-prog-q073-streams-deep-dive',
  'Java 8 Stream API provides a functional, pipeline-based approach to process collections. Key operations: intermediate (filter, map, sorted, distinct, limit) and terminal (collect, reduce, count, forEach, findFirst). Streams are lazy — intermediate ops run only when terminal op is called.',
  $ans$
## Java 8 Streams — Complete Deep Dive

```java
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

public class StreamsDeepDive {
    public static void main(String[] args) {

        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        List<String>  tools   = Arrays.asList(
            "Selenium", "TestNG", "Cucumber", "Maven", "Jenkins",
            "Postman", "Selenium", "Appium", "JMeter"
        );

        // ─── FILTER ───
        List<Integer> evens = numbers.stream()
            .filter(n -> n % 2 == 0)
            .collect(Collectors.toList());
        System.out.println("Evens: " + evens);  // [2, 4, 6, 8, 10]

        // ─── MAP ───
        List<String> upperTools = tools.stream()
            .map(String::toUpperCase)
            .collect(Collectors.toList());
        System.out.println("Upper: " + upperTools);

        // ─── MAP to different type ───
        List<Integer> lengths = tools.stream()
            .map(String::length)
            .collect(Collectors.toList());
        System.out.println("Lengths: " + lengths);

        // ─── FILTER + MAP + COLLECT ───
        List<String> longToolsUpper = tools.stream()
            .filter(t -> t.length() > 6)        // keep tools with >6 chars
            .map(String::toUpperCase)            // convert to uppercase
            .sorted()                            // alphabetical order
            .distinct()                          // remove duplicates
            .collect(Collectors.toList());
        System.out.println("Long tools: " + longToolsUpper);

        // ─── REDUCE ───
        int sum = numbers.stream()
            .reduce(0, Integer::sum);            // 0 is identity, sum accumulator
        System.out.println("Sum: " + sum);       // 55

        Optional<Integer> product = numbers.stream()
            .reduce((a, b) -> a * b);
        System.out.println("Product: " + product.get());  // 3628800

        // ─── COUNT ───
        long countLong = tools.stream()
            .filter(t -> t.length() > 5)
            .count();
        System.out.println("Tools > 5 chars: " + countLong);

        // ─── findFirst / findAny ───
        Optional<String> first = tools.stream()
            .filter(t -> t.startsWith("S"))
            .findFirst();
        first.ifPresent(t -> System.out.println("First S: " + t));  // Selenium

        // ─── anyMatch / allMatch / noneMatch ───
        boolean hasSelenium   = tools.stream().anyMatch(t -> t.equals("Selenium"));
        boolean allUpperCheck = tools.stream().allMatch(t -> t.length() > 2);
        boolean noNumbers     = tools.stream().noneMatch(t -> t.matches(".*\\d.*"));
        System.out.println("Has Selenium: " + hasSelenium);   // true
        System.out.println("All > 2 chars: " + allUpperCheck); // true
        System.out.println("No numbers in names: " + noNumbers); // true

        // ─── MIN / MAX ───
        Optional<Integer> max = numbers.stream().max(Integer::compareTo);
        Optional<Integer> min = numbers.stream().min(Integer::compareTo);
        System.out.println("Max: " + max.get() + ", Min: " + min.get());  // 10, 1

        // ─── SORTED with Comparator ───
        List<String> sortedByLength = tools.stream()
            .sorted(Comparator.comparingInt(String::length))
            .collect(Collectors.toList());
        System.out.println("By length: " + sortedByLength);

        // ─── DISTINCT ───
        List<String> distinctTools = tools.stream()
            .distinct()
            .collect(Collectors.toList());
        System.out.println("Distinct: " + distinctTools);

        // ─── LIMIT / SKIP ───
        List<Integer> top3 = numbers.stream().limit(3).collect(Collectors.toList());
        List<Integer> skip3 = numbers.stream().skip(3).collect(Collectors.toList());
        System.out.println("Top 3:  " + top3);   // [1, 2, 3]
        System.out.println("Skip 3: " + skip3);  // [4, 5, 6, 7, 8, 9, 10]
    }
}
```

### flatMap — Flatten Nested Collections

```java
List<List<String>> nested = Arrays.asList(
    Arrays.asList("Selenium", "TestNG"),
    Arrays.asList("Cucumber", "Maven"),
    Arrays.asList("Jenkins", "Postman")
);

List<String> flat = nested.stream()
    .flatMap(Collection::stream)    // flatten List<List<String>> → Stream<String>
    .collect(Collectors.toList());

System.out.println("Flat: " + flat);
// → [Selenium, TestNG, Cucumber, Maven, Jenkins, Postman]

// Split sentence into words and collect all
List<String> sentences = Arrays.asList("Hello World", "Java Streams", "are great");
List<String> words = sentences.stream()
    .flatMap(s -> Arrays.stream(s.split(" ")))
    .collect(Collectors.toList());
System.out.println("Words: " + words);
// → [Hello, World, Java, Streams, are, great]
```

### Collectors.groupingBy — Group Elements

```java
List<String> tools = Arrays.asList(
    "Selenium", "TestNG", "Cucumber", "Maven", "Jenkins", "Postman", "Appium"
);

// Group by first letter
Map<Character, List<String>> byFirstLetter = tools.stream()
    .collect(Collectors.groupingBy(t -> t.charAt(0)));
System.out.println("By first letter: " + byFirstLetter);

// Group by length
Map<Integer, List<String>> byLength = tools.stream()
    .collect(Collectors.groupingBy(String::length));
System.out.println("By length: " + byLength);

// Count in each group
Map<Integer, Long> countByLength = tools.stream()
    .collect(Collectors.groupingBy(String::length, Collectors.counting()));
System.out.println("Count by length: " + countByLength);
```

### Output
```
By first letter: {A=[Appium], C=[Cucumber], J=[Jenkins], M=[Maven], P=[Postman], S=[Selenium], T=[TestNG]}
By length: {6=[TestNG, Appium], 7=[Selenium, Jenkins, Postman], 8=[Cucumber]}
Count by length: {6=2, 7=3, 8=1}
```

### Collectors.partitioningBy — Split into Two Groups

```java
// Split numbers into even and odd
Map<Boolean, List<Integer>> partitioned = numbers.stream()
    .collect(Collectors.partitioningBy(n -> n % 2 == 0));

System.out.println("Even: " + partitioned.get(true));   // [2,4,6,8,10]
System.out.println("Odd:  " + partitioned.get(false));  // [1,3,5,7,9]

// Split tools by length > 6
Map<Boolean, List<String>> toolParts = tools.stream()
    .collect(Collectors.partitioningBy(t -> t.length() > 6));
System.out.println("Long:  " + toolParts.get(true));
System.out.println("Short: " + toolParts.get(false));
```

### Collectors.joining — Concatenate Strings

```java
String joined = tools.stream()
    .collect(Collectors.joining(", "));
System.out.println(joined);  // Selenium, TestNG, Cucumber, Maven, Jenkins, Postman, Appium

String withBrackets = tools.stream()
    .collect(Collectors.joining(", ", "[", "]"));
System.out.println(withBrackets);  // [Selenium, TestNG, Cucumber, Maven, Jenkins, Postman, Appium]
```

### Collectors.toMap — Convert to Map

```java
List<String> tools = Arrays.asList("Selenium", "TestNG", "Cucumber");

Map<String, Integer> toolLengthMap = tools.stream()
    .collect(Collectors.toMap(
        t -> t,           // key: tool name
        String::length    // value: length
    ));
System.out.println(toolLengthMap);
// {Selenium=8, TestNG=6, Cucumber=8}
```

### IntStream / LongStream / DoubleStream

```java
// Range of numbers
IntStream.range(1, 6).forEach(i -> System.out.print(i + " "));
// → 1 2 3 4 5

IntStream.rangeClosed(1, 5).forEach(i -> System.out.print(i + " "));
// → 1 2 3 4 5

// Sum, average, statistics
IntSummaryStatistics stats = IntStream.of(1,2,3,4,5,6,7,8,9,10).summaryStatistics();
System.out.println("Sum: "   + stats.getSum());      // 55
System.out.println("Avg: "   + stats.getAverage());  // 5.5
System.out.println("Max: "   + stats.getMax());      // 10
System.out.println("Count: " + stats.getCount());    // 10
```

### Method References with Streams

```java
List<String> tools = Arrays.asList("selenium", "testng", "cucumber");

// :: method reference types:
tools.stream().map(String::toUpperCase).forEach(System.out::println);  // instance method ref
tools.stream().filter(Objects::nonNull).collect(Collectors.toList());   // static method ref

// Custom class method reference
tools.stream().map(StringUtils::capitalize).collect(Collectors.toList()); // if method exists
```

### Parallel Streams (Faster for Large Data)

```java
List<Integer> bigList = IntStream.rangeClosed(1, 1_000_000)
    .boxed().collect(Collectors.toList());

// Sequential
long seqSum = bigList.stream().mapToLong(Integer::longValue).sum();

// Parallel (uses ForkJoinPool — multiple CPU cores)
long parSum = bigList.parallelStream().mapToLong(Integer::longValue).sum();

System.out.println("Sequential sum: " + seqSum);
System.out.println("Parallel sum:   " + parSum);  // same result, faster
```

### Automation Testing Relevance

```java
List<WebElement> products = driver.findElements(By.css(".product-card"));

// Get all product names that are in stock
List<String> inStockNames = products.stream()
    .filter(p -> p.findElement(By.css(".stock")).getText().equals("In Stock"))
    .map(p -> p.findElement(By.css(".name")).getText())
    .collect(Collectors.toList());

// Get prices sorted ascending
List<Double> sortedPrices = products.stream()
    .map(p -> Double.parseDouble(
        p.findElement(By.css(".price")).getText().replace("$", "")))
    .sorted()
    .collect(Collectors.toList());

// Find most expensive product
Optional<WebElement> expensive = products.stream()
    .max(Comparator.comparingDouble(p ->
        Double.parseDouble(p.findElement(By.css(".price")).getText().replace("$", ""))));

expensive.ifPresent(p -> System.out.println("Most expensive: " +
    p.findElement(By.css(".name")).getText()));
```
$ans$,
  'Java Programs', 'Coding', 'Intermediate', 'Advanced',
  ARRAY['Java','Streams','filter','map','collect','reduce','flatMap','groupingBy','partitioningBy','Java8'],
  true, 0
),

-- Q74
(
  'Write a Java program to demonstrate type casting — widening, narrowing, and object casting.',
  'java-prog-q074-type-casting',
  'Widening (implicit): smaller type auto-converted to larger (byte→short→int→long→float→double). Narrowing (explicit): larger type cast to smaller with possible data loss — requires explicit cast (int). Object casting: upcasting (auto) and downcasting (explicit with instanceof check).',
  $ans$
## Type Casting in Java

### Primitive Type Casting

```java
public class TypeCasting {
    public static void main(String[] args) {

        // ─── WIDENING (Implicit/Automatic) ───
        // byte → short → int → long → float → double
        byte   b = 10;
        short  s = b;     // byte → short (automatic)
        int    i = s;     // short → int (automatic)
        long   l = i;     // int → long (automatic)
        float  f = l;     // long → float (automatic)
        double d = f;     // float → double (automatic)

        System.out.println("byte:   " + b);
        System.out.println("short:  " + s);
        System.out.println("int:    " + i);
        System.out.println("long:   " + l);
        System.out.println("float:  " + f);
        System.out.println("double: " + d);

        // ─── NARROWING (Explicit/Manual) ───
        // May lose data!
        double pi      = 3.14159;
        int piInt      = (int) pi;         // explicit cast — truncates decimal
        byte smallByte = (byte) 300;       // 300 > 127 (byte max) → overflow: 44

        System.out.println("\ndouble to int: " + pi + " → " + piInt);  // 3
        System.out.println("300 to byte:   300 → " + smallByte);       // 44
    }
}
```

### Output
```
byte:   10
short:  10
int:    10
long:   10
float:  10.0
double: 10.0

double to int: 3.14159 → 3
300 to byte:   300 → 44
```

### Common Conversions for Automation

```java
// String → int (parse)
String strNum = "42";
int    intNum = Integer.parseInt(strNum);     // 42

// int → String
String fromInt = String.valueOf(42);          // "42"
String fromInt2 = Integer.toString(42);       // "42"

// String → double
double price = Double.parseDouble("29.99");   // 29.99

// double → int (truncate)
int priceInt = (int) price;                   // 29

// char → int (ASCII value)
char c = 'A';
int ascii = (int) c;                          // 65

// int → char
char fromInt3 = (char) 65;                    // 'A'
```

### Object Casting — Upcasting and Downcasting

```java
class Animal {
    void sound() { System.out.println("Some sound"); }
}

class Dog extends Animal {
    void sound() { System.out.println("Woof"); }
    void fetch() { System.out.println("Fetching ball!"); }
}

// ─── UPCASTING (Implicit) ───
// Child → Parent reference (automatic, safe)
Animal animal = new Dog();   // Dog IS-A Animal
animal.sound();               // "Woof" (runtime polymorphism)
// animal.fetch();            // ERROR: Animal reference can't call Dog methods

// ─── DOWNCASTING (Explicit) ───
// Parent → Child reference (must be explicit, may fail)
if (animal instanceof Dog) {   // always check with instanceof first!
    Dog dog = (Dog) animal;    // safe downcast
    dog.fetch();               // "Fetching ball!" — Dog method accessible now
}

// Unsafe downcast — causes ClassCastException
Animal cat = new Animal();
// Dog dog2 = (Dog) cat;      // ClassCastException at runtime!
```

### instanceof Operator

```java
Object obj = "Hello";

System.out.println(obj instanceof String);   // true
System.out.println(obj instanceof Integer);  // false
System.out.println(obj instanceof Object);   // true (everything is Object)

// Java 16+ Pattern Matching instanceof
if (obj instanceof String s) {
    System.out.println("Length: " + s.length());  // no explicit cast needed
}
```

### Data Loss Table

| From | To | Loss? |
|---|---|---|
| `int` (100) | `byte` | Possible (byte max=127) |
| `double` (3.14) | `int` | Yes — decimal lost → 3 |
| `long` (10L) | `int` | Possible (if > Integer.MAX_VALUE) |
| `int` | `double` | No |
| `int` | `long` | No |
$ans$,
  'Java Programs', 'Coding', 'Fresher', 'Intermediate',
  ARRAY['Java','Type Casting','Widening','Narrowing','instanceof','Upcasting','Downcasting'],
  true, 0
),

-- Q75
(
  'Write a Java program to demonstrate varargs, method references, and the Builder pattern for test data.',
  'java-prog-q075-varargs-method-refs-builder',
  'Varargs (variable arguments) allow a method to accept zero or more arguments of the same type using T... syntax. Method references (::) are shorthand for lambdas calling a single method. Builder pattern constructs complex objects step-by-step — widely used for test data creation in automation.',
  $ans$
## Varargs, Method References, and Builder Pattern

### Varargs (Variable Arguments)

```java
public class VarargsDemo {

    // sum accepts any number of ints
    public static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) total += n;
        return total;
    }

    // Can mix regular params with varargs — varargs must be LAST
    public static void printAll(String prefix, String... values) {
        for (String v : values) {
            System.out.println(prefix + v);
        }
    }

    public static void main(String[] args) {
        System.out.println(sum());           // 0
        System.out.println(sum(1, 2));       // 3
        System.out.println(sum(1, 2, 3, 4, 5)); // 15

        printAll("Tool: ", "Selenium", "TestNG", "Cucumber");
    }
}
```

### Output
```
0
3
15
Tool: Selenium
Tool: TestNG
Tool: Cucumber
```

### Method References (::)

```java
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

public class MethodReferencesDemo {
    public static void main(String[] args) {
        List<String> tools = Arrays.asList("selenium", "testng", "cucumber", "maven");

        // 1. Static Method Reference: ClassName::staticMethod
        //    equivalent to: t -> Integer.parseInt(t)
        List<String> nums = Arrays.asList("1", "2", "3");
        nums.stream().map(Integer::parseInt).forEach(System.out::println);

        // 2. Instance Method Reference on type: ClassName::instanceMethod
        //    equivalent to: t -> t.toUpperCase()
        tools.stream()
             .map(String::toUpperCase)
             .forEach(System.out::println);

        // 3. Instance Method Reference on object: object::instanceMethod
        //    equivalent to: t -> System.out.println(t)
        tools.forEach(System.out::println);

        // 4. Constructor Reference: ClassName::new
        //    equivalent to: s -> new StringBuilder(s)
        List<StringBuilder> sbs = tools.stream()
            .map(StringBuilder::new)
            .collect(Collectors.toList());

        // Common functional interface → method reference
        Predicate<String>  isEmpty   = String::isEmpty;         // t -> t.isEmpty()
        Function<String,Integer> len = String::length;          // t -> t.length()
        Consumer<Object>  printer    = System.out::println;     // t -> sysout(t)
        Supplier<List<String>> newList = ArrayList::new;        // () -> new ArrayList<>()

        System.out.println(isEmpty.test(""));      // true
        System.out.println(len.apply("Selenium")); // 8
    }
}
```

### Builder Pattern for Test Data

```java
// Without Builder — hard to read, easy to pass args in wrong order
User user1 = new User("John", "john@test.com", "Admin", true, 25, "New York");

// With Builder — readable, flexible, no parameter order confusion
public class User {
    private String name;
    private String email;
    private String role;
    private boolean active;
    private int age;
    private String city;

    // Private constructor — only Builder can create User
    private User(Builder builder) {
        this.name   = builder.name;
        this.email  = builder.email;
        this.role   = builder.role;
        this.active = builder.active;
        this.age    = builder.age;
        this.city   = builder.city;
    }

    @Override
    public String toString() {
        return "User{name='" + name + "', email='" + email +
               "', role='" + role + "', active=" + active +
               ", age=" + age + ", city='" + city + "'}";
    }

    // Static inner Builder class
    public static class Builder {
        private String  name;
        private String  email;
        private String  role   = "User";     // default value
        private boolean active = true;       // default value
        private int     age;
        private String  city   = "Unknown";  // default value

        public Builder name(String name)     { this.name = name;     return this; }
        public Builder email(String email)   { this.email = email;   return this; }
        public Builder role(String role)     { this.role = role;     return this; }
        public Builder active(boolean active){ this.active = active; return this; }
        public Builder age(int age)          { this.age = age;       return this; }
        public Builder city(String city)     { this.city = city;     return this; }

        public User build() {
            // Validate required fields
            if (name == null || email == null)
                throw new IllegalStateException("Name and email are required");
            return new User(this);
        }
    }

    public static void main(String[] args) {
        // Build full user
        User admin = new User.Builder()
            .name("Alice")
            .email("alice@test.com")
            .role("Admin")
            .active(true)
            .age(30)
            .city("New York")
            .build();

        // Build minimal user (uses defaults)
        User guest = new User.Builder()
            .name("Guest")
            .email("guest@test.com")
            .build();  // role=User, active=true, city=Unknown

        System.out.println(admin);
        System.out.println(guest);
    }
}
```

### Output
```
User{name='Alice', email='alice@test.com', role='Admin', active=true, age=30, city='New York'}
User{name='Guest', email='guest@test.com', role='User', active=true, age=0, city='Unknown'}
```

### Builder in Automation Testing

```java
// Create test data cleanly for different test scenarios
User loginUser       = new User.Builder().name("John").email("john@qa.com").role("User").build();
User adminUser       = new User.Builder().name("Admin").email("admin@qa.com").role("Admin").build();
User inactiveUser    = new User.Builder().name("Bob").email("bob@qa.com").active(false).build();

// Lombok @Builder annotation (production-grade shortcut)
// @Builder on class generates builder automatically — no manual code needed
```

### Method Reference vs Lambda

| | Lambda | Method Reference |
|---|---|---|
| Syntax | `t -> t.toUpperCase()` | `String::toUpperCase` |
| Readability | OK | Better (when method name is descriptive) |
| Use when | Logic in lambda | Calls single existing method |
| Performance | Same | Same |
$ans$,
  'Java Programs', 'Coding', 'Intermediate', 'Advanced',
  ARRAY['Java','Varargs','Method References','Builder Pattern','Design Pattern','Functional','Automation'],
  true, 0
);
