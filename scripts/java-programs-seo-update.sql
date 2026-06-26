-- SEO UPDATE: Java Programs Q1–Q75
-- Fixes short_description (≤155 chars for Google meta) + enriches tags (long-tail keywords)
-- Run in a FRESH new tab in Supabase SQL Editor AFTER running the insert scripts

-- ─────────────────────────────────────────────────────────────────────────────
-- Q1–Q30  (java-programs-q1-q30.sql)
-- ─────────────────────────────────────────────────────────────────────────────

UPDATE interview_questions SET
  short_description = 'Java program to add two matrices using nested for loops on 2D arrays. Code with output, step-by-step trace and automation testing example.',
  tags = ARRAY['Java','Arrays','2D Array','Matrix','Nested Loops','java programs for interview','java program with output','java coding questions for SDET','java array programs']
WHERE slug = 'java-prog-q001-add-two-matrices';

UPDATE interview_questions SET
  short_description = 'Java ArrayList basic operations — add(), size(), enhanced for loop iteration. Code with output. Essential for Selenium WebElement collection handling.',
  tags = ARRAY['Java','ArrayList','Collections','List','Selenium','java programs for interview','java arraylist example','java collections interview questions','java program with output']
WHERE slug = 'java-prog-q002-arraylist-basic';

UPDATE interview_questions SET
  short_description = 'Java program to check even or odd using modulus (%). If-else and ternary operator versions with output. Classic Java fresher interview program.',
  tags = ARRAY['Java','Modulus','If-Else','Conditional','Basic Program','java programs for interview','java fresher programs','even odd java program','java program with output']
WHERE slug = 'java-prog-q003-even-or-odd';

UPDATE interview_questions SET
  short_description = 'Java binary search using while loop on sorted array. Step-by-step trace included. O(log n) vs O(n) linear search comparison. Java algorithm interview.',
  tags = ARRAY['Java','Binary Search','Array','Algorithm','Search','java programs for interview','binary search java program','java algorithm programs','java program with output']
WHERE slug = 'java-prog-q004-binary-search';

UPDATE interview_questions SET
  short_description = 'Java program to separate even and odd numbers in array using modulus. Java 8 stream filter version included. Common Java array interview program.',
  tags = ARRAY['Java','Arrays','Even','Odd','Loop','Modulus','java programs for interview','java array programs','java fresher programs','java program with output']
WHERE slug = 'java-prog-q005-even-odd-in-array';

UPDATE interview_questions SET
  short_description = 'Java ArrayList advanced — add at index, remove by index, get(). Mixed types, Object iteration. Difference between add() and add(index, value) explained.',
  tags = ARRAY['Java','ArrayList','Collections','add','remove','get','java programs for interview','java collections interview questions','java arraylist programs','java program with output']
WHERE slug = 'java-prog-q006-arraylist-advanced';

UPDATE interview_questions SET
  short_description = 'Java generate random numbers in a range using Random class and Math.random(). Used to create unique test data and emails in Selenium automation tests.',
  tags = ARRAY['Java','Random','Math.random','Test Data','Automation','java programs for interview','java random number program','generate random numbers java','java programs for automation testing']
WHERE slug = 'java-prog-q007-random-numbers';

UPDATE interview_questions SET
  short_description = 'Java binary search using Arrays.binarySearch() — returns index or negative value. Manual vs built-in method comparison. Java array interview program.',
  tags = ARRAY['Java','Binary Search','Arrays','Built-in Method','Algorithm','java programs for interview','arrays binarysearch java','java search programs','java program with output']
WHERE slug = 'java-prog-q008-binary-search-method';

UPDATE interview_questions SET
  short_description = 'Java bubble sort with nested loops and swap. Step-by-step trace, optimized early-exit version. O(n²) sorting algorithm explained for Java interviews.',
  tags = ARRAY['Java','Bubble Sort','Sorting','Algorithm','Array','java programs for interview','java sorting programs','bubble sort java program','java algorithm programs']
WHERE slug = 'java-prog-q009-bubble-sort';

UPDATE interview_questions SET
  short_description = 'Java count words in string using Scanner and space detection. split() one-liner and StringTokenizer alternatives. Java string interview program.',
  tags = ARRAY['Java','String','Scanner','Count Words','split','java programs for interview','java string programs','count words in string java','java program with output']
WHERE slug = 'java-prog-q010-count-words';

UPDATE interview_questions SET
  short_description = 'Java count character occurrences using replace() length trick and charAt() loop. Case-insensitive and HashMap frequency map versions included.',
  tags = ARRAY['Java','String','charAt','replace','Count','Characters','java programs for interview','java string programs','count character occurrences java','java program with output']
WHERE slug = 'java-prog-q011-count-char-occurrences';

UPDATE interview_questions SET
  short_description = 'Java greatest of three numbers using if-else with && conditions, Math.max() one-liner and ternary operator. Common Java fresher interview program.',
  tags = ARRAY['Java','Conditional','If-Else','Math.max','Greatest','java programs for interview','java fresher programs','greatest of three numbers java','java program with output']
WHERE slug = 'java-prog-q012-greatest-of-three';

UPDATE interview_questions SET
  short_description = 'Java reverse string — for loop charAt, StringBuilder.reverse(), char array swap, recursion. 4 methods compared. Most asked Java string interview program.',
  tags = ARRAY['Java','String','Reverse','StringBuilder','Interview','java programs for interview','reverse string java program','java string interview programs','java program with output']
WHERE slug = 'java-prog-q013-reverse-string';

UPDATE interview_questions SET
  short_description = 'Java palindrome check using StringBuilder.reverse() and two-pointer approach. Case-insensitive version. Test madam, racecar, level. Java interview program.',
  tags = ARRAY['Java','String','Palindrome','StringBuilder','Interview','java programs for interview','palindrome string java','java string interview programs','java program with output']
WHERE slug = 'java-prog-q014-palindrome-check';

UPDATE interview_questions SET
  short_description = 'Java find duplicate elements in array — nested O(n²), HashSet O(n), sort+compare. Frequency count with HashMap. Java array interview program.',
  tags = ARRAY['Java','Array','HashSet','Duplicates','HashMap','Interview','java programs for interview','find duplicates java array','java array interview programs','java program with output']
WHERE slug = 'java-prog-q015-find-duplicates';

UPDATE interview_questions SET
  short_description = 'Java find second largest element in array — two-variable O(n) single pass, sort method, TreeSet. Most efficient approach explained with examples.',
  tags = ARRAY['Java','Array','Second Largest','Sorting','Algorithm','Interview','java programs for interview','second largest element java','java array programs','java program with output']
WHERE slug = 'java-prog-q016-second-largest';

UPDATE interview_questions SET
  short_description = 'Java prime number check — divisibility loop up to √n with Math.sqrt(). Print all primes 1–50. O(√n) optimization vs O(n) brute force explained.',
  tags = ARRAY['Java','Prime Number','Math.sqrt','Loop','Algorithm','Interview','java programs for interview','prime number java program','java number programs','java program with output']
WHERE slug = 'java-prog-q017-prime-number';

UPDATE interview_questions SET
  short_description = 'Java reverse a number using % 10 and / 10 while loop. Step-by-step trace for 12345→54321. Use to check palindrome number. Java number interview program.',
  tags = ARRAY['Java','Number Reverse','Modulus','While Loop','Palindrome','Interview','java programs for interview','reverse number java','java number programs','java program with output']
WHERE slug = 'java-prog-q018-reverse-number';

UPDATE interview_questions SET
  short_description = 'Java Fibonacci series — iterative loop, while loop and recursive. Print N terms or up to value. Recursive vs iterative performance compared.',
  tags = ARRAY['Java','Fibonacci','Series','Loop','Recursion','Interview','java programs for interview','fibonacci series java','java series programs','java program with output']
WHERE slug = 'java-prog-q019-fibonacci-series';

UPDATE interview_questions SET
  short_description = 'Java Arrays.sort() for int and String arrays. Collections.sort() for ArrayList. Descending with Comparator.reverseOrder(). Sort partial array range.',
  tags = ARRAY['Java','Arrays.sort','Collections.sort','Sorting','Comparator','java programs for interview','java sorting programs','sort array java program','java program with output']
WHERE slug = 'java-prog-q020-sorting-arrays';

UPDATE interview_questions SET
  short_description = 'Java swap two numbers without third variable — arithmetic and XOR bitwise methods. Why XOR avoids overflow. Classic Java interview trick explained.',
  tags = ARRAY['Java','Swap','XOR','Arithmetic','Variables','Interview','java programs for interview','swap without temp variable java','java interview programs','java program with output']
WHERE slug = 'java-prog-q021-swap-without-temp';

UPDATE interview_questions SET
  short_description = 'Java factorial — iterative loop and recursive methods. Recursion call stack trace for factorial(4). BigInteger for large values like 20!.',
  tags = ARRAY['Java','Factorial','Recursion','Loop','Interview','BigInteger','java programs for interview','factorial program in java','java recursion programs','java program with output']
WHERE slug = 'java-prog-q022-factorial';

UPDATE interview_questions SET
  short_description = 'Java remove duplicates from ArrayList using LinkedHashSet (preserves order), stream distinct() and manual contains() check. Interview comparison included.',
  tags = ARRAY['Java','ArrayList','LinkedHashSet','Duplicates','Stream','Collections','java programs for interview','remove duplicates arraylist java','java collections programs','java program with output']
WHERE slug = 'java-prog-q023-remove-duplicates-list';

UPDATE interview_questions SET
  short_description = 'Java HashMap operations — put, get, containsKey, remove, entrySet iteration. All key methods with examples. Essential Java collections interview topic.',
  tags = ARRAY['Java','HashMap','Collections','Map','put','get','entrySet','java programs for interview','hashmap java example','java collections interview questions','java program with output']
WHERE slug = 'java-prog-q024-hashmap-operations';

UPDATE interview_questions SET
  short_description = 'Java sum and average of array elements using enhanced for loop and IntSummaryStatistics. Overflow handling with long for large arrays explained.',
  tags = ARRAY['Java','Array','Sum','Average','IntStream','Java8','java programs for interview','sum of array java','java array programs','java program with output']
WHERE slug = 'java-prog-q025-sum-average-array';

UPDATE interview_questions SET
  short_description = 'Java String methods — length, trim, toUpperCase, charAt, indexOf, contains, substring, split, replace, equals. All with examples and output.',
  tags = ARRAY['Java','String','Methods','substring','split','trim','Automation','java programs for interview','java string methods interview','java string interview programs','java program with output']
WHERE slug = 'java-prog-q026-string-methods';

UPDATE interview_questions SET
  short_description = 'Java Iterator vs ListIterator — forward/backward traversal, safe remove during loop. Prevents ConcurrentModificationException. Interview comparison table.',
  tags = ARRAY['Java','Iterator','ListIterator','Collections','ArrayList','Loop','java programs for interview','java iterator example','java collections interview questions','java program with output']
WHERE slug = 'java-prog-q027-iterator-listiterator';

UPDATE interview_questions SET
  short_description = 'Java exception handling — try-catch-finally, multiple catch blocks, custom RuntimeException. Checked vs unchecked hierarchy. Selenium graceful handling.',
  tags = ARRAY['Java','Exception Handling','try-catch','Custom Exception','finally','Runtime','java programs for interview','java exception handling example','java interview programs','java program with output']
WHERE slug = 'java-prog-q028-exception-handling';

UPDATE interview_questions SET
  short_description = 'Java 8 — Lambda expressions, Stream API (filter/map/collect), Optional for null safety. Functional interfaces with automation testing use cases.',
  tags = ARRAY['Java','Java8','Lambda','Stream','Optional','Functional','Automation','java programs for interview','java 8 features interview','java lambda stream examples','java coding questions for SDET']
WHERE slug = 'java-prog-q029-java8-features';

UPDATE interview_questions SET
  short_description = 'Java multithreading — Thread class vs Runnable interface, start() vs run(). ThreadLocal for parallel Selenium WebDriver. Essential SDET interview topic.',
  tags = ARRAY['Java','Multithreading','Thread','Runnable','ThreadLocal','Parallel','Selenium','java programs for interview','java multithreading interview','parallel selenium java','java programs for automation testing']
WHERE slug = 'java-prog-q030-multithreading';

-- ─────────────────────────────────────────────────────────────────────────────
-- Q31–Q52  (java-programs-q31-q52.sql)
-- ─────────────────────────────────────────────────────────────────────────────

UPDATE interview_questions SET
  short_description = 'Java if-else voting eligibility (age >= 18). Nested if-else, ternary operator and Scanner input versions with output. Java fresher interview program.',
  tags = ARRAY['Java','If-Else','Conditional','Operators','Basic Program','java programs for interview','java fresher programs','if else program in java','java program with output']
WHERE slug = 'java-prog-q031-if-else-voting';

UPDATE interview_questions SET
  short_description = 'Java int to String — Integer.toString(), String.valueOf(), concatenation. Reverse: Integer.parseInt(). Full conversion table for all data types.',
  tags = ARRAY['Java','Type Conversion','Integer','String','parseInt','valueOf','java programs for interview','int to string java','java type conversion programs','java program with output']
WHERE slug = 'java-prog-q032-int-to-string';

UPDATE interview_questions SET
  short_description = 'Java linear search — sequential scan with for loop and boolean flag. String array search with equals(). Linear vs binary search O(n) vs O(log n).',
  tags = ARRAY['Java','Linear Search','Array','Search','Loop','Flag','java programs for interview','linear search java program','java search programs','java program with output']
WHERE slug = 'java-prog-q033-linear-search';

UPDATE interview_questions SET
  short_description = 'Java find largest of two numbers using if-else, Math.max() and ternary operator. Handle equal numbers. Basic Java conditional interview program.',
  tags = ARRAY['Java','If-Else','Math.max','Comparison','Ternary','Basic Program','java programs for interview','java fresher programs','largest of two numbers java','java program with output']
WHERE slug = 'java-prog-q034-largest-of-two';

UPDATE interview_questions SET
  short_description = 'Java max and min in array — two loops, single combined loop, IntSummaryStatistics. Find index of max. Selenium price range validation example.',
  tags = ARRAY['Java','Array','Max','Min','Loop','IntSummaryStatistics','java programs for interview','max min array java','java array programs','java program with output']
WHERE slug = 'java-prog-q035-max-min-array';

UPDATE interview_questions SET
  short_description = 'Java day of week using if-else-if chain and switch-case. Java 14+ switch expression. Switch with String for browser selection in Selenium DriverFactory.',
  tags = ARRAY['Java','switch-case','if-else-if','Day of Week','Conditional','java programs for interview','switch case java program','java switch statement','java program with output']
WHERE slug = 'java-prog-q036-day-of-week';

UPDATE interview_questions SET
  short_description = 'Java count digits in a number using while loop with /10. String.valueOf().length() shortcut. Math.log10() formula. Handle negatives and zero.',
  tags = ARRAY['Java','Digits','While Loop','Math.log10','Number','Integer Division','java programs for interview','count digits java','java number programs','java program with output']
WHERE slug = 'java-prog-q037-number-of-digits';

UPDATE interview_questions SET
  short_description = 'Java palindrome number check — reverse digits with % 10 while loop. Step-by-step trace for 171. Test 121, 1221, 1001. Classic Java interview program.',
  tags = ARRAY['Java','Palindrome','Number','While Loop','Modulus','Reverse','java programs for interview','palindrome number java','java number programs','java program with output']
WHERE slug = 'java-prog-q038-number-palindrome';

UPDATE interview_questions SET
  short_description = 'Java palindrome string using for loop charAt() and StringBuffer.reverse(). Case-insensitive with replaceAll. Test DAD, MADAM, RACECAR with output.',
  tags = ARRAY['Java','Palindrome','String','StringBuffer','StringBuilder','charAt','java programs for interview','palindrome string java','java string programs','java program with output']
WHERE slug = 'java-prog-q039-palindrome-string';

UPDATE interview_questions SET
  short_description = 'Java check positive, negative or zero using if-else-if and ternary operator. Test multiple values. Selenium price difference validation example.',
  tags = ARRAY['Java','Positive','Negative','If-Else','Ternary','Conditional','java programs for interview','positive negative zero java','java fresher programs','java program with output']
WHERE slug = 'java-prog-q040-positive-or-negative';

UPDATE interview_questions SET
  short_description = 'Java remove duplicates from ArrayList using HashSet. LinkedHashSet preserves insertion order. HashSet vs LinkedHashSet vs TreeSet comparison table.',
  tags = ARRAY['Java','ArrayList','HashSet','LinkedHashSet','Duplicates','Collections','java programs for interview','remove duplicates java','java collections programs','java program with output']
WHERE slug = 'java-prog-q041-remove-duplicates-hashset';

UPDATE interview_questions SET
  short_description = 'Java remove special characters using replaceAll() with regex [^a-zA-Z0-9]. Clean currency text for Selenium. Common regex patterns reference table.',
  tags = ARRAY['Java','String','replaceAll','Regex','Special Characters','Clean','java programs for interview','remove special characters java','java regex programs','java programs for automation testing']
WHERE slug = 'java-prog-q042-remove-junk-characters';

UPDATE interview_questions SET
  short_description = 'Java remove whitespace with replaceAll(\\s). trim() vs strip() vs replaceAll difference. Collapse multiple spaces. Selenium text comparison cleaning.',
  tags = ARRAY['Java','String','replaceAll','Whitespace','trim','Regex','java programs for interview','remove whitespace java string','java string programs','java programs for automation testing']
WHERE slug = 'java-prog-q043-remove-whitespace';

UPDATE interview_questions SET
  short_description = 'Java reverse string using reverseCharacters() method with charAt() loop. Scanner input validation with isEmpty(). Method decomposition example.',
  tags = ARRAY['Java','String','Reverse','charAt','Scanner','Method','Validation','java programs for interview','reverse string java program','java string programs','java program with output']
WHERE slug = 'java-prog-q044-reverse-chars-method';

UPDATE interview_questions SET
  short_description = 'Java reverse each word individually using split() and charAt() nested loops. Three different reverse operations compared side by side with output.',
  tags = ARRAY['Java','String','Reverse Words','split','charAt','StringBuilder','java programs for interview','reverse each word in java','java string programs','java program with output']
WHERE slug = 'java-prog-q045-reverse-each-word';

UPDATE interview_questions SET
  short_description = 'Java reverse number — mathematical % 10 algorithm and StringBuffer.reverse() method. Step-by-step trace. Check palindrome using reversed number.',
  tags = ARRAY['Java','Reverse Number','Algorithm','StringBuffer','While Loop','Modulus','java programs for interview','reverse number java program','java number programs','java program with output']
WHERE slug = 'java-prog-q046-reverse-number-two-methods';

UPDATE interview_questions SET
  short_description = 'Java reverse string with Scanner input using for loop and StringBuffer. StringBuilder O(n) vs string += O(n²) performance comparison explained.',
  tags = ARRAY['Java','String','Reverse','StringBuffer','StringBuilder','Scanner','charAt','java programs for interview','reverse string java','java string programs','java program with output']
WHERE slug = 'java-prog-q047-reverse-string-scanner';

UPDATE interview_questions SET
  short_description = 'Java 1D array — declare without size, enhanced for loop, break to exit early. Array methods: length, sort, binarySearch. Java array interview basics.',
  tags = ARRAY['Java','Array','1D Array','break','for loop','Enhanced For','java programs for interview','java array programs','single dimension array java','java program with output']
WHERE slug = 'java-prog-q048-single-dim-array';

UPDATE interview_questions SET
  short_description = 'Java swap two strings without temp variable using substring() trick. Step-by-step trace. Compare with standard temp variable approach.',
  tags = ARRAY['Java','String','Swap','substring','No Temp Variable','String Manipulation','java programs for interview','swap strings without temp java','java string programs','java program with output']
WHERE slug = 'java-prog-q049-string-swapping';

UPDATE interview_questions SET
  short_description = 'Java sum of array elements using enhanced for loop. Index-based loop, IntStream.sum() Java 8 version. Long overflow prevention for large arrays.',
  tags = ARRAY['Java','Array','Sum','Enhanced For','IntStream','Loop','java programs for interview','sum of array elements java','java array programs','java program with output']
WHERE slug = 'java-prog-q050-sum-of-array';

UPDATE interview_questions SET
  short_description = 'Java 2D array — declare with new int[rows][cols], inline init, nested for loops traversal. Print as grid with printf. Sum all elements example.',
  tags = ARRAY['Java','2D Array','Matrix','Nested Loop','Array Traversal','java programs for interview','2d array java program','java matrix programs','java program with output']
WHERE slug = 'java-prog-q051-two-dim-array';

UPDATE interview_questions SET
  short_description = 'Java count words, lines and chars in file using BufferedReader. try-with-resources modern version. Files.readAllLines() Java 8 stream approach.',
  tags = ARRAY['Java','File IO','BufferedReader','FileReader','Word Count','try-with-resources','java programs for interview','java file reading programs','bufferedreader java example','java program with output']
WHERE slug = 'java-prog-q052-word-count-in-file';

-- ─────────────────────────────────────────────────────────────────────────────
-- Q53–Q75  (java-programs-q53-q75.sql)
-- ─────────────────────────────────────────────────────────────────────────────

UPDATE interview_questions SET
  short_description = 'Java anagram check — sort and compare arrays, char frequency O(n), HashMap method and Java 8 stream. Test listen/silent. Most asked Java string program.',
  tags = ARRAY['Java','String','Anagram','HashMap','Arrays.sort','Interview','java programs for interview','anagram program in java','java string interview programs','java program with output']
WHERE slug = 'java-prog-q053-anagram-check';

UPDATE interview_questions SET
  short_description = 'Java Armstrong number — 153=1³+5³+3³ using Math.pow(). Print all Armstrong numbers 1–1000. Step-by-step trace. Classic Java number interview program.',
  tags = ARRAY['Java','Armstrong','Number','Math.pow','Interview','Classic','java programs for interview','armstrong number java program','java number programs','java program with output']
WHERE slug = 'java-prog-q054-armstrong-number';

UPDATE interview_questions SET
  short_description = 'Java sum of digits using while loop with %10. Stream one-liner, recursion and digital root (repeat until single digit). Java number interview program.',
  tags = ARRAY['Java','Sum of Digits','Number','While Loop','Recursion','Stream','java programs for interview','sum of digits java program','java number programs','java program with output']
WHERE slug = 'java-prog-q055-sum-of-digits';

UPDATE interview_questions SET
  short_description = 'Java multiplication table using for loop. Scanner user input version, grid format 1–10 x 1–10, printf formatting. Basic Java loop interview program.',
  tags = ARRAY['Java','Multiplication Table','Loop','for loop','Basic Program','java programs for interview','multiplication table java program','java loop programs','java program with output']
WHERE slug = 'java-prog-q056-multiplication-table';

UPDATE interview_questions SET
  short_description = 'Java count vowels and consonants using Character.isLetter(), String.contains(), switch and Java 8 stream. Selenium text field validation example.',
  tags = ARRAY['Java','String','Vowels','Consonants','char','Stream','Character','java programs for interview','count vowels consonants java','java string programs','java program with output']
WHERE slug = 'java-prog-q057-count-vowels-consonants';

UPDATE interview_questions SET
  short_description = 'Java first non-repeating character using LinkedHashMap (insertion order), char frequency array O(n) and Java 8 stream. Classic HashMap interview program.',
  tags = ARRAY['Java','String','LinkedHashMap','HashMap','Character Frequency','Interview','java programs for interview','first non repeating character java','java hashmap programs','java program with output']
WHERE slug = 'java-prog-q058-first-non-repeating-char';

UPDATE interview_questions SET
  short_description = 'Java find missing number in 1 to N array using sum formula N(N+1)/2. XOR method avoids overflow. Find multiple missing numbers with HashSet.',
  tags = ARRAY['Java','Array','Missing Number','XOR','Math Formula','Interview','java programs for interview','missing number in array java','java array interview programs','java program with output']
WHERE slug = 'java-prog-q059-find-missing-number';

UPDATE interview_questions SET
  short_description = 'Java rotate array left and right — reversal algorithm O(n)O(1), temp array O(n), Collections.rotate(). Handle K > array length with modulo.',
  tags = ARRAY['Java','Array','Rotate','Reversal Algorithm','Collections.rotate','Interview','java programs for interview','rotate array left right java','java array programs','java program with output']
WHERE slug = 'java-prog-q060-rotate-array';

UPDATE interview_questions SET
  short_description = 'Java OOP inheritance — single, multilevel and hierarchical with extends and super. Multiple inheritance via interface. Selenium WebDriver hierarchy example.',
  tags = ARRAY['Java','OOP','Inheritance','extends','super','Multilevel','Hierarchical','java programs for interview','java oops concepts','java inheritance example','java oops interview questions']
WHERE slug = 'java-prog-q061-oop-inheritance';

UPDATE interview_questions SET
  short_description = 'Java method overloading vs overriding — compile-time vs runtime polymorphism. @Override annotation, static method hiding. Most asked Java OOP interview.',
  tags = ARRAY['Java','OOP','Overloading','Overriding','Polymorphism','@Override','Interview','java programs for interview','method overloading overriding java','java oops interview questions','java program with output']
WHERE slug = 'java-prog-q062-overloading-vs-overriding';

UPDATE interview_questions SET
  short_description = 'Java abstract class vs interface — concrete methods, constructors, multiple implementation. BasePage abstract class and Clickable interface Selenium example.',
  tags = ARRAY['Java','OOP','Abstract Class','Interface','extends','implements','BasePage','java programs for interview','abstract class vs interface java','java oops interview questions','java oops concepts']
WHERE slug = 'java-prog-q063-abstract-interface';

UPDATE interview_questions SET
  short_description = 'Java Singleton design pattern — lazy, eager, thread-safe double-checked locking. WebDriver manager and ThreadLocal for parallel Selenium test execution.',
  tags = ARRAY['Java','Design Pattern','Singleton','WebDriver','ThreadLocal','Automation','java programs for interview','singleton pattern java','java design patterns interview','java programs for automation testing']
WHERE slug = 'java-prog-q064-singleton-pattern';

UPDATE interview_questions SET
  short_description = 'Java Comparable vs Comparator — natural ordering with compareTo(), multiple sort orders with Comparator lambda. Sort Employee objects by name and salary.',
  tags = ARRAY['Java','Comparable','Comparator','Sorting','OOP','Collections','Lambda','java programs for interview','comparable vs comparator java','java sorting objects','java collections interview questions']
WHERE slug = 'java-prog-q065-comparable-comparator';

UPDATE interview_questions SET
  short_description = 'Java LinkedList — addFirst, addLast, getFirst, removeFirst, peek. Used as Stack (LIFO) and Queue (FIFO). ArrayList vs LinkedList performance comparison.',
  tags = ARRAY['Java','LinkedList','Collections','Queue','Stack','ArrayList','Deque','java programs for interview','java linkedlist example','java collections interview questions','java data structures']
WHERE slug = 'java-prog-q066-linkedlist';

UPDATE interview_questions SET
  short_description = 'Java Stack (LIFO) and Queue (FIFO) — push/pop/peek vs offer/poll/peek. ArrayDeque preferred. Page navigation history automation testing example.',
  tags = ARRAY['Java','Stack','Queue','LIFO','FIFO','ArrayDeque','Collections','java programs for interview','stack queue java program','java data structures interview','java collections programs']
WHERE slug = 'java-prog-q067-stack-queue';

UPDATE interview_questions SET
  short_description = 'Java string validation — only digits, only alphabets, alphanumeric using regex matches() and Character methods. Email, phone and password validation.',
  tags = ARRAY['Java','String','Validation','Regex','Character','isDigit','isLetter','Stream','java programs for interview','java string validation regex','java regex programs','java programs for automation testing']
WHERE slug = 'java-prog-q068-string-validation';

UPDATE interview_questions SET
  short_description = 'Java character frequency using HashMap, stream groupingBy. Find most and least frequent char. Print frequency chart. Classic Java HashMap interview program.',
  tags = ARRAY['Java','HashMap','Character Frequency','Stream','groupingBy','Collectors','Interview','java programs for interview','character frequency java','java hashmap programs','java program with output']
WHERE slug = 'java-prog-q069-char-frequency';

UPDATE interview_questions SET
  short_description = 'Java star patterns — right triangle, inverted, centered pyramid, diamond, hollow rectangle and number triangle. Nested loop logic step by step.',
  tags = ARRAY['Java','Star Pattern','Nested Loops','Pattern','Triangle','Pyramid','Interview','java programs for interview','star pattern programs in java','java pattern programs','java loop programs']
WHERE slug = 'java-prog-q070-star-patterns';

UPDATE interview_questions SET
  short_description = 'Java merge two sorted arrays using two-pointer O(m+n). arraycopy+sort shortcut and IntStream.concat() Java 8. Find array intersection with HashSet.',
  tags = ARRAY['Java','Array','Merge','Two Pointer','IntStream','Sorted','Algorithm','java programs for interview','merge two sorted arrays java','java array programs','java algorithm programs']
WHERE slug = 'java-prog-q071-merge-sorted-arrays';

UPDATE interview_questions SET
  short_description = 'Java selection sort (find min and swap) and insertion sort (shift and insert). Step-by-step traces. O(n²) vs O(n) best case. Sorting algorithm interview.',
  tags = ARRAY['Java','Sorting','Selection Sort','Insertion Sort','Algorithm','Interview','java programs for interview','selection sort java program','insertion sort java program','java sorting programs']
WHERE slug = 'java-prog-q072-selection-insertion-sort';

UPDATE interview_questions SET
  short_description = 'Java 8 Streams — filter, map, collect, reduce, flatMap, groupingBy, partitioningBy, joining, toMap and parallel streams. Complete interview guide.',
  tags = ARRAY['Java','Streams','filter','map','collect','reduce','flatMap','groupingBy','partitioningBy','Java8','java programs for interview','java 8 streams interview questions','java stream api examples','java coding questions for SDET']
WHERE slug = 'java-prog-q073-streams-deep-dive';

UPDATE interview_questions SET
  short_description = 'Java type casting — widening (automatic) vs narrowing (explicit cast). Object upcasting and downcasting with instanceof. Java 16 pattern matching.',
  tags = ARRAY['Java','Type Casting','Widening','Narrowing','instanceof','Upcasting','Downcasting','java programs for interview','java type casting examples','java oops concepts','java program with output']
WHERE slug = 'java-prog-q074-type-casting';

UPDATE interview_questions SET
  short_description = 'Java varargs (T...), 4 method reference types (::), Builder pattern for test data with validation. SDET automation interview essentials in one program.',
  tags = ARRAY['Java','Varargs','Method References','Builder Pattern','Design Pattern','Functional','Automation','java programs for interview','java varargs method references','builder pattern java','java 8 features','java programs for automation testing']
WHERE slug = 'java-prog-q075-varargs-method-refs-builder';

-- ─────────────────────────────────────────────────────────────────────────────
-- Verify the updates
-- Run this SELECT after the UPDATE to confirm all 75 rows were updated
-- ─────────────────────────────────────────────────────────────────────────────

SELECT
  slug,
  LENGTH(short_description) AS desc_length,
  short_description,
  array_length(tags, 1) AS tag_count
FROM interview_questions
WHERE slug LIKE 'java-prog-%'
ORDER BY slug;
