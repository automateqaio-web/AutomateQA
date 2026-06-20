-- SQL Interview Questions for QA Automation Q1–Q40 | Paste into Supabase SQL Editor

-- ══════════════════════════════════════
-- BEGINNER (Q1–Q12)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is SQL? Explain DDL, DML, DCL, and TCL with examples.',
  'sql-ddl-dml-dcl-tcl-explained',
  'SQL is the language used to communicate with relational databases. It is divided into DDL (structure), DML (data), DCL (permissions), and TCL (transactions).',
  $$## SQL and Its Sub-Languages

**SQL (Structured Query Language)** is used to create, read, update, and delete data in relational databases like MySQL, PostgreSQL, Oracle, and SQL Server.

## DDL — Data Definition Language

Defines and modifies database **structure** (schema). Changes are **auto-committed**.

```sql
-- CREATE — create a new table
CREATE TABLE employees (
    id         INT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary     DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ALTER — modify existing table
ALTER TABLE employees ADD COLUMN email VARCHAR(100);
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12, 2);
ALTER TABLE employees DROP COLUMN email;

-- DROP — permanently delete table + data
DROP TABLE employees;

-- TRUNCATE — delete all rows but keep structure (faster than DELETE)
TRUNCATE TABLE employees;

-- RENAME
RENAME TABLE employees TO staff;
```

## DML — Data Manipulation Language

Works with the **data** inside tables. Changes can be rolled back.

```sql
-- INSERT — add new rows
INSERT INTO employees (id, name, department, salary)
VALUES (1, 'Alice', 'QA', 95000.00);

-- INSERT multiple rows
INSERT INTO employees (id, name, department, salary) VALUES
(2, 'Bob',     'Dev',  120000.00),
(3, 'Charlie', 'QA',    85000.00),
(4, 'Diana',   'Dev',  135000.00);

-- UPDATE — modify existing rows
UPDATE employees SET salary = 100000 WHERE id = 1;
UPDATE employees SET salary = salary * 1.10 WHERE department = 'QA';

-- DELETE — remove rows
DELETE FROM employees WHERE id = 3;
DELETE FROM employees WHERE department = 'QA' AND salary < 80000;

-- SELECT — read data
SELECT name, salary FROM employees WHERE department = 'QA';
```

## DCL — Data Control Language

Manages **permissions** and access.

```sql
-- GRANT — give permission
GRANT SELECT, INSERT ON employees TO 'qa_user'@'localhost';
GRANT ALL PRIVILEGES ON testdb.* TO 'admin'@'%';

-- REVOKE — remove permission
REVOKE INSERT ON employees FROM 'qa_user'@'localhost';
```

## TCL — Transaction Control Language

Controls **transactions** — groups of SQL statements that run as one unit.

```sql
BEGIN;  -- or START TRANSACTION

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

COMMIT;    -- save both changes permanently
-- or
ROLLBACK;  -- undo both changes if something went wrong

-- SAVEPOINT — partial rollback
BEGIN;
INSERT INTO orders VALUES (101, 'Alice', 500);
SAVEPOINT order_placed;

INSERT INTO payments VALUES (201, 101, 500);
-- Something went wrong — rollback only payment, keep order
ROLLBACK TO SAVEPOINT order_placed;

COMMIT;
```

## Quick Summary

| Category | Commands | Auto-Commit |
|----------|---------|-------------|
| DDL | CREATE, ALTER, DROP, TRUNCATE, RENAME | Yes |
| DML | SELECT, INSERT, UPDATE, DELETE | No |
| DCL | GRANT, REVOKE | Yes |
| TCL | COMMIT, ROLLBACK, SAVEPOINT | N/A |$$,
  'SQL', 'Technical', 'Fresher', 'Beginner',
  ARRAY['SQL', 'DDL', 'DML', 'DCL', 'TCL', 'Database', 'Basics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are SQL JOINs? Explain INNER, LEFT, RIGHT, and FULL OUTER JOIN with examples.',
  'sql-joins-inner-left-right-full-outer',
  'JOINs combine rows from two or more tables. INNER JOIN returns matching rows only. LEFT JOIN returns all left rows + matches. RIGHT JOIN returns all right rows + matches. FULL OUTER JOIN returns all rows from both.',
  $$## SQL JOINs Explained

## Sample Tables

```sql
-- employees table
| id | name    | dept_id |
|----|---------|---------|
|  1 | Alice   |    10   |
|  2 | Bob     |    20   |
|  3 | Charlie |    30   |
|  4 | Diana   |  NULL   |  ← no department

-- departments table
| id | dept_name   |
|----|-------------|
| 10 | QA          |
| 20 | Development |
| 40 | HR          |   ← no employees
```

## INNER JOIN — Only Matching Rows

Returns rows where the join condition is met in **both** tables.

```sql
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id;

-- Result:
-- Alice   | QA
-- Bob     | Development
-- (Charlie dept_id=30 not in departments → excluded)
-- (Diana dept_id=NULL → excluded)
-- (HR has no employees → excluded)
```

## LEFT JOIN (LEFT OUTER JOIN) — All Left + Matching Right

Returns **all rows from left table** + matching rows from right. Non-matching right rows get NULL.

```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id;

-- Result:
-- Alice   | QA
-- Bob     | Development
-- Charlie | NULL          ← dept_id=30 not in departments
-- Diana   | NULL          ← dept_id is NULL
```

## RIGHT JOIN (RIGHT OUTER JOIN) — All Right + Matching Left

Returns **all rows from right table** + matching rows from left.

```sql
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.id;

-- Result:
-- Alice | QA
-- Bob   | Development
-- NULL  | HR            ← HR has no employees
```

## FULL OUTER JOIN — All Rows From Both Tables

Returns all rows from **both** tables. NULLs fill gaps where no match exists.

```sql
SELECT e.name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.id;

-- Result:
-- Alice   | QA
-- Bob     | Development
-- Charlie | NULL          ← no matching dept
-- Diana   | NULL          ← no dept_id
-- NULL    | HR            ← no employees in HR

-- MySQL doesn''t support FULL OUTER JOIN — emulate it:
SELECT e.name, d.dept_name FROM employees e LEFT  JOIN departments d ON e.dept_id = d.id
UNION
SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.id;
```

## SELF JOIN — Join a Table to Itself

```sql
-- Find employees and their managers (same table)
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

## CROSS JOIN — Every Row Combined With Every Other Row

```sql
-- Generates all combinations (Cartesian product)
SELECT e.name, d.dept_name
FROM employees e
CROSS JOIN departments d;
-- 4 employees × 3 departments = 12 rows
```

## In QA — Verify Referential Integrity

```sql
-- Find orders with no matching customer (data integrity issue)
SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id
WHERE c.id IS NULL;
```$$,
  'SQL', 'Technical', 'Fresher', 'Beginner',
  ARRAY['JOIN', 'INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL OUTER JOIN', 'SQL', 'Database'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between WHERE and HAVING in SQL?',
  'sql-where-vs-having',
  'WHERE filters individual rows before grouping. HAVING filters groups after GROUP BY. WHERE cannot use aggregate functions; HAVING can.',
  $$## WHERE vs HAVING in SQL

## Key Rule

- **WHERE** → filters **rows** (before GROUP BY, no aggregates)
- **HAVING** → filters **groups** (after GROUP BY, can use aggregates)

## Sample Table: employees

```sql
| id | name    | department | salary |
|----|---------|-----------|--------|
|  1 | Alice   | QA        | 95000  |
|  2 | Bob     | Dev       | 120000 |
|  3 | Charlie | QA        | 85000  |
|  4 | Diana   | Dev       | 135000 |
|  5 | Eve     | QA        | 110000 |
|  6 | Frank   | HR        | 65000  |
```

## WHERE — Filter Before Grouping

```sql
-- Only look at QA employees, then group
SELECT department, COUNT(*) AS headcount, AVG(salary) AS avg_salary
FROM employees
WHERE department = 'QA'    -- ← filter ROWS first
GROUP BY department;

-- Result:
-- QA | 3 | 96666.67

-- WHERE with multiple conditions
SELECT name, salary
FROM employees
WHERE salary > 90000
  AND department IN ('QA', 'Dev');
-- Alice, Bob, Diana, Eve
```

## HAVING — Filter After Grouping

```sql
-- Group first, then filter groups where avg salary > 100000
SELECT department, COUNT(*) AS headcount, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 100000;   -- ← filter GROUPS

-- Result:
-- Dev | 2 | 127500

-- WRONG: Using aggregate in WHERE (throws error)
-- SELECT department, AVG(salary)
-- FROM employees
-- WHERE AVG(salary) > 100000   ← ❌ ERROR
-- GROUP BY department;
```

## Using BOTH Together

```sql
-- Active employees (WHERE), grouped by dept (GROUP BY),
-- only depts with 2+ members (HAVING)
SELECT department,
       COUNT(*)      AS headcount,
       AVG(salary)   AS avg_salary,
       MAX(salary)   AS max_salary
FROM employees
WHERE status = 'active'          -- 1. filter active rows
GROUP BY department              -- 2. group them
HAVING COUNT(*) >= 2             -- 3. only groups with 2+ people
ORDER BY avg_salary DESC;        -- 4. sort result
```

## Execution Order (Important!)

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

```sql
-- Find departments where total salary expense > 200000
SELECT department, SUM(salary) AS total_expense
FROM employees
GROUP BY department
HAVING SUM(salary) > 200000;

-- Result:
-- Dev | 255000
-- QA  | 290000
```

## Quick Reference

| | WHERE | HAVING |
|--|-------|--------|
| Filters | Individual rows | Grouped rows |
| Position | Before GROUP BY | After GROUP BY |
| Aggregate functions | ❌ Not allowed | ✅ Allowed |
| Index usage | ✅ Yes (fast) | ❌ No (slower) |$$,
  'SQL', 'Technical', 'Fresher', 'Beginner',
  ARRAY['WHERE', 'HAVING', 'GROUP BY', 'Aggregate', 'SQL', 'Filter', 'Database'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between DELETE, TRUNCATE, and DROP in SQL?',
  'sql-delete-vs-truncate-vs-drop',
  'DELETE removes specific rows (can be rolled back, triggers fire). TRUNCATE removes all rows fast (usually cannot be rolled back, no triggers). DROP removes the entire table structure permanently.',
  $$## DELETE vs TRUNCATE vs DROP

## Quick Comparison

| Feature | DELETE | TRUNCATE | DROP |
|---------|--------|----------|------|
| What it removes | Specific rows | All rows | Entire table |
| WHERE clause | Yes | No | No |
| Rollback | Yes | Depends on DB | No (DDL) |
| Triggers | Fires triggers | No triggers | No triggers |
| Speed | Slow (logs each row) | Fast | Fast |
| Auto-increment reset | No | Yes | N/A |
| Category | DML | DDL | DDL |

## DELETE — Remove Specific Rows

```sql
-- Delete specific rows
DELETE FROM employees WHERE department = 'QA';

-- Delete all rows (can be rolled back)
DELETE FROM employees;

-- With JOIN (delete based on another table)
DELETE e FROM employees e
JOIN departments d ON e.dept_id = d.id
WHERE d.dept_name = 'HR';

-- DELETE with LIMIT
DELETE FROM audit_logs
ORDER BY created_at ASC
LIMIT 1000;  -- delete oldest 1000 rows

-- Rollback is possible
BEGIN;
DELETE FROM employees WHERE id = 5;
ROLLBACK;  -- employee is restored!
```

## TRUNCATE — Remove All Rows Fast

```sql
-- Remove ALL rows instantly
TRUNCATE TABLE employees;

-- Cannot use WHERE
-- TRUNCATE TABLE employees WHERE id = 5;  ← ERROR

-- Resets AUTO_INCREMENT counter
TRUNCATE TABLE orders;
INSERT INTO orders (customer) VALUES ('Alice');
-- id will be 1 again (not continue from last value)

-- In most databases, CANNOT be rolled back
-- In PostgreSQL, TRUNCATE is transactional (can rollback)
```

## DROP — Remove the Entire Table

```sql
-- Remove table structure + all data permanently
DROP TABLE employees;

-- Safe version — no error if table doesn't exist
DROP TABLE IF EXISTS temp_employees;

-- Drop multiple tables
DROP TABLE orders, order_items, payments;

-- Cannot be rolled back (DDL auto-commit)
-- After DROP: table is gone, INSERT will fail
```

## When to Use Which

```sql
-- Use DELETE when:
DELETE FROM session_logs WHERE created_at < NOW() - INTERVAL 30 DAY;
-- ↑ Need WHERE clause to be selective

-- Use TRUNCATE when:
TRUNCATE TABLE test_run_results;
-- ↑ Clearing ALL test data before a test run (fast)

-- Use DROP when:
DROP TABLE IF EXISTS temp_migration_table;
-- ↑ Removing a temporary table no longer needed
```

## In QA Automation — Database Cleanup

```sql
-- Before each test run: clean test data
TRUNCATE TABLE test_orders;
TRUNCATE TABLE test_users;

-- After specific test: clean up created record
DELETE FROM users WHERE email = 'automated_test@example.com';

-- Teardown: remove test schema entirely
DROP SCHEMA IF EXISTS test_run_20240615;
```$$,
  'SQL', 'Technical', 'Fresher', 'Beginner',
  ARRAY['DELETE', 'TRUNCATE', 'DROP', 'SQL', 'Database', 'DDL', 'DML'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are SQL aggregate functions? Explain COUNT, SUM, AVG, MAX, MIN.',
  'sql-aggregate-functions-count-sum-avg-max-min',
  'Aggregate functions perform calculations on a set of rows and return a single value. COUNT counts rows, SUM totals values, AVG calculates mean, MAX/MIN find extremes. Used with GROUP BY for grouping.',
  $$## SQL Aggregate Functions

Aggregate functions compute a single result from multiple rows.

## Sample Table: orders

```sql
| id | customer | product  | quantity | price  | status    |
|----|----------|----------|----------|--------|-----------|
|  1 | Alice    | Laptop   |        1 | 999.99 | completed |
|  2 | Bob      | Mouse    |        3 |  29.99 | completed |
|  3 | Alice    | Keyboard |        2 |  79.99 | pending   |
|  4 | Charlie  | Laptop   |        1 | 999.99 | completed |
|  5 | Bob      | Monitor  |        1 | 299.99 | cancelled |
|  6 | Alice    | Headset  |        2 |  59.99 | completed |
```

## COUNT — Count Rows

```sql
-- Count all rows
SELECT COUNT(*) AS total_orders FROM orders;
-- Result: 6

-- Count non-NULL values in a column
SELECT COUNT(customer) AS orders_with_customer FROM orders;

-- Count distinct values
SELECT COUNT(DISTINCT customer) AS unique_customers FROM orders;
-- Result: 3

-- Count with condition (conditional aggregation)
SELECT
    COUNT(*) AS total,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed,
    COUNT(CASE WHEN status = 'pending'   THEN 1 END) AS pending,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled
FROM orders;
-- total=6, completed=4, pending=1, cancelled=1
```

## SUM — Total of Values

```sql
-- Total revenue from completed orders
SELECT SUM(price * quantity) AS total_revenue
FROM orders
WHERE status = 'completed';
-- (999.99 + 89.97 + 999.99 + 119.98) = 2209.93

-- Sum per customer
SELECT customer, SUM(price * quantity) AS total_spent
FROM orders
WHERE status = 'completed'
GROUP BY customer
ORDER BY total_spent DESC;
```

## AVG — Average Value

```sql
-- Average order value
SELECT AVG(price) AS avg_price FROM orders;

-- Average per product category
SELECT product, AVG(price) AS avg_price
FROM orders
GROUP BY product;

-- Round to 2 decimal places
SELECT ROUND(AVG(price), 2) AS avg_price FROM orders;
```

## MAX and MIN — Extremes

```sql
-- Most and least expensive product
SELECT MAX(price) AS highest_price,
       MIN(price) AS lowest_price
FROM orders;

-- Latest and earliest order
SELECT MAX(created_at) AS latest_order,
       MIN(created_at) AS first_order
FROM orders;

-- Per customer: most expensive purchase
SELECT customer, MAX(price) AS biggest_purchase
FROM orders
GROUP BY customer;
```

## Combining All Aggregates

```sql
SELECT
    customer,
    COUNT(*)                    AS order_count,
    SUM(price * quantity)       AS total_spent,
    ROUND(AVG(price), 2)        AS avg_order_value,
    MAX(price)                  AS most_expensive,
    MIN(price)                  AS cheapest
FROM orders
WHERE status = 'completed'
GROUP BY customer
HAVING COUNT(*) >= 2           -- only customers with 2+ orders
ORDER BY total_spent DESC;
```

## In QA — Validate Test Results

```sql
-- After running tests: check counts match expectations
SELECT
    COUNT(*)                                            AS total_records,
    COUNT(CASE WHEN status = 'active' THEN 1 END)      AS active_count,
    SUM(amount)                                         AS total_amount,
    MAX(created_at)                                     AS latest_record
FROM test_orders
WHERE test_run_id = 'RUN-2024-001';
```$$,
  'SQL', 'Technical', 'Fresher', 'Beginner',
  ARRAY['Aggregate Functions', 'COUNT', 'SUM', 'AVG', 'MAX', 'MIN', 'SQL', 'GROUP BY'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is NULL in SQL? How do you handle NULL values?',
  'sql-null-handling-is-null-coalesce',
  'NULL represents missing or unknown data — it is not zero or empty string. Use IS NULL / IS NOT NULL to check for NULLs. COALESCE() returns the first non-NULL value. NULL in comparisons always returns UNKNOWN.',
  $$## NULL in SQL

**NULL** means the value is **unknown, missing, or not applicable** — it is NOT the same as 0, empty string ''`''`'', or false.

## Checking for NULL — IS NULL / IS NOT NULL

```sql
-- ❌ Wrong — NULL = NULL is always UNKNOWN (not TRUE)
SELECT * FROM employees WHERE manager_id = NULL;   -- returns 0 rows!

-- ✅ Correct
SELECT * FROM employees WHERE manager_id IS NULL;
SELECT * FROM employees WHERE manager_id IS NOT NULL;
```

## NULL in Arithmetic — Always Returns NULL

```sql
SELECT 100 + NULL;   -- NULL
SELECT NULL * 5;     -- NULL
SELECT NULL / 2;     -- NULL

-- This is a trap — NULL salary causes row to be invisible in AVG
SELECT AVG(salary) FROM employees;  -- NULL rows are ignored!
SELECT SUM(salary) FROM employees;  -- NULL rows are ignored!
SELECT COUNT(*) FROM employees;     -- counts all rows INCLUDING NULLs
SELECT COUNT(salary) FROM employees; -- skips NULL salaries
```

## COALESCE() — Return First Non-NULL Value

```sql
-- Return bonus, or 0 if bonus is NULL
SELECT name, COALESCE(bonus, 0) AS bonus
FROM employees;

-- Try multiple fallbacks
SELECT name, COALESCE(phone, email, 'No contact info') AS contact
FROM employees;

-- Replace NULL department with 'Unassigned'
SELECT name, COALESCE(department, 'Unassigned') AS department
FROM employees;
```

## IFNULL() / NVL() — Shorthand for Two-Value COALESCE

```sql
-- MySQL / MariaDB
SELECT name, IFNULL(bonus, 0) AS bonus FROM employees;

-- Oracle
SELECT name, NVL(bonus, 0) AS bonus FROM employees;

-- SQL Server
SELECT name, ISNULL(bonus, 0) AS bonus FROM employees;
```

## NULLIF() — Return NULL if Two Values Are Equal

```sql
-- Avoid divide-by-zero: return NULL instead
SELECT total_sales / NULLIF(total_orders, 0) AS avg_order_value
FROM sales_summary;
-- If total_orders = 0 → NULLIF returns NULL → division returns NULL (safe)

-- Replace empty strings with NULL
SELECT NULLIF(phone, '') AS phone FROM users;
```

## NULL in ORDER BY

```sql
-- NULLs appear LAST by default in ascending order
SELECT name, salary FROM employees ORDER BY salary ASC;

-- Force NULLs first
SELECT name, salary FROM employees ORDER BY salary ASC NULLS FIRST;  -- PostgreSQL/Oracle

-- MySQL workaround
SELECT name, salary FROM employees ORDER BY salary IS NULL ASC, salary ASC;
```

## NULL in GROUP BY

```sql
-- NULL is treated as its own group
SELECT department, COUNT(*) AS headcount
FROM employees
GROUP BY department;
-- department=NULL gets its own row in results
```

## NULL in JOINs

```sql
-- Rows with NULL join key will NOT match any row
SELECT e.name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.id;
-- Employees with dept_id = NULL are excluded from INNER JOIN
-- Use LEFT JOIN to include them
```

## In QA — Common NULL Checks

```sql
-- Find records with missing required data
SELECT id, name FROM users
WHERE email IS NULL OR phone IS NULL;

-- Validate no NULL in mandatory columns after insert
SELECT COUNT(*) AS null_count
FROM orders
WHERE customer_id IS NULL OR product_id IS NULL OR quantity IS NULL;
-- Expected: 0

-- Fill NULLs in report
SELECT
    order_id,
    COALESCE(discount, 0)        AS discount,
    COALESCE(notes, 'None')      AS notes
FROM orders;
```$$,
  'SQL', 'Technical', 'Fresher', 'Beginner',
  ARRAY['NULL', 'IS NULL', 'COALESCE', 'IFNULL', 'NULLIF', 'SQL', 'Database'], true, 0
);

-- ══════════════════════════════════════
-- INTERMEDIATE (Q7–Q20)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are subqueries in SQL? What is the difference between correlated and non-correlated subqueries?',
  'sql-subqueries-correlated-vs-non-correlated',
  'A subquery is a query nested inside another query. Non-correlated subqueries run once independently. Correlated subqueries reference the outer query and run once per outer row — slower but more powerful.',
  $$## Subqueries in SQL

A **subquery** (inner query / nested query) is a SELECT statement inside another SQL statement.

## Non-Correlated Subquery — Runs Once

The inner query executes **once** independently. The result is used by the outer query.

```sql
-- Find employees earning above the average salary
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
-- Inner query: AVG(salary) = 97500 (runs once)
-- Outer query: finds everyone > 97500

-- Find employees in the QA department
SELECT name FROM employees
WHERE dept_id = (SELECT id FROM departments WHERE dept_name = 'QA');

-- Find the highest paid employee
SELECT name, salary FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Subquery in FROM clause (derived table)
SELECT dept_summary.department, dept_summary.avg_salary
FROM (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) AS dept_summary
WHERE dept_summary.avg_salary > 100000;
```

## Correlated Subquery — Runs Per Outer Row

The inner query **references columns from the outer query** — it runs once for each row in the outer query.

```sql
-- Find employees who earn more than the average of their own department
SELECT e1.name, e1.salary, e1.department
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department   -- ← references outer query's e1
);
-- For each employee (e1), the inner query computes avg for THEIR department

-- Find the highest earner in each department (correlated)
SELECT e1.name, e1.department, e1.salary
FROM employees e1
WHERE e1.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
);
```

## EXISTS / NOT EXISTS (Correlated)

```sql
-- Find customers who have placed at least one order
SELECT c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);

-- Find customers with NO orders (common QA check)
SELECT c.name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);
-- Equivalent but often faster than:
-- WHERE c.id NOT IN (SELECT customer_id FROM orders)
```

## Subquery vs JOIN Performance

```sql
-- Subquery (readable but sometimes slower)
SELECT name FROM employees
WHERE dept_id IN (SELECT id FROM departments WHERE location = 'Bangalore');

-- JOIN equivalent (often faster for large datasets)
SELECT e.name FROM employees e
JOIN departments d ON e.dept_id = d.id
WHERE d.location = 'Bangalore';
```

## IN vs EXISTS

```sql
-- IN: works well when subquery returns small result set
SELECT name FROM employees
WHERE dept_id IN (SELECT id FROM departments WHERE active = 1);

-- EXISTS: better when subquery could match many rows
-- Stops at first match — more efficient
SELECT name FROM employees e
WHERE EXISTS (SELECT 1 FROM departments d WHERE d.id = e.dept_id AND d.active = 1);
```$$,
  'SQL', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Subquery', 'Correlated', 'Non-Correlated', 'EXISTS', 'IN', 'SQL', 'Nested Query'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is the difference between UNION and UNION ALL in SQL?',
  'sql-union-vs-union-all',
  'UNION combines result sets from two queries and removes duplicates (slower). UNION ALL keeps all rows including duplicates (faster). Both require the same number of columns with compatible data types.',
  $$## UNION vs UNION ALL

## Rules for Both

- Same number of columns in each SELECT
- Columns must have compatible data types
- Column names come from the **first** SELECT

## UNION — Removes Duplicates

```sql
-- Get all unique emails from both active and archived users
SELECT email FROM active_users
UNION
SELECT email FROM archived_users;
-- Duplicates are removed (email appearing in both tables shows once)
-- Sorts the result (implicit ORDER BY to detect duplicates)

-- Example
-- active_users:   alice@qa.com, bob@dev.com
-- archived_users: alice@qa.com, charlie@hr.com

SELECT email FROM active_users
UNION
SELECT email FROM archived_users;
-- Result: alice@qa.com, bob@dev.com, charlie@hr.com (3 rows, no duplicate alice)
```

## UNION ALL — Keeps Duplicates (Faster)

```sql
-- Keep ALL rows including duplicates
SELECT email FROM active_users
UNION ALL
SELECT email FROM archived_users;
-- Result: alice@qa.com, bob@dev.com, alice@qa.com, charlie@hr.com (4 rows)

-- UNION ALL is faster — no deduplication step
-- Use when you know there are no duplicates OR you want to count them
```

## Practical Examples

```sql
-- Combine this month + last month test results
SELECT test_name, status, run_date FROM test_runs_jan
UNION ALL
SELECT test_name, status, run_date FROM test_runs_feb
ORDER BY run_date DESC;

-- UNION to emulate FULL OUTER JOIN in MySQL
SELECT e.name, d.dept_name
FROM employees e LEFT JOIN departments d ON e.dept_id = d.id
UNION
SELECT e.name, d.dept_name
FROM employees e RIGHT JOIN departments d ON e.dept_id = d.id;

-- Find all product IDs that are either in orders OR in wishlist
SELECT product_id FROM orders
UNION
SELECT product_id FROM wishlist;
```

## Performance: UNION vs UNION ALL

```sql
-- UNION: extra sort + dedup step → slower
-- UNION ALL: no extra processing → faster

-- Rule: Use UNION ALL when:
-- 1. You know results are already distinct
-- 2. You explicitly want duplicates (e.g., combining log tables)
-- 3. Performance matters on large datasets

-- Use UNION when:
-- 1. You need unique results and can't guarantee no duplicates
```

## UNION with Different Columns (Use Aliases)

```sql
-- Columns must be compatible but can have different names
SELECT first_name AS full_name, 'employee' AS type FROM employees
UNION ALL
SELECT company_name AS full_name, 'client' AS type FROM clients
ORDER BY full_name;
```

## Quick Reference

| | UNION | UNION ALL |
|--|-------|-----------|
| Duplicates | Removed | Kept |
| Speed | Slower | Faster |
| Sorting | Implicit sort | No sort |
| Use when | Need unique rows | Need all rows / speed |$$,
  'SQL', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['UNION', 'UNION ALL', 'Set Operations', 'SQL', 'Database', 'Duplicates'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are SQL indexes? When should you use them?',
  'sql-indexes-when-to-use',
  'An index is a data structure that speeds up SELECT queries on a column. Use indexes on columns used in WHERE, JOIN ON, and ORDER BY. Avoid over-indexing — indexes slow down INSERT/UPDATE/DELETE.',
  $$## SQL Indexes

An **index** is a separate data structure (like a book''s index) that allows the database to find rows quickly without scanning the entire table.

## Without vs With Index

```
Without index: Full Table Scan
→ Database reads every row to find WHERE email = 'alice@test.com'
→ 1,000,000 rows scanned

With index on email:
→ B-Tree lookup: O(log n) — finds the row in milliseconds
→ ~20 comparisons to find 1 row in 1,000,000
```

## Creating Indexes

```sql
-- Single column index
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);

-- Composite index (multiple columns — order matters!)
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
-- Covers: WHERE customer_id = 5
-- Covers: WHERE customer_id = 5 AND status = 'completed'
-- Does NOT cover: WHERE status = 'completed' alone (leading column rule)

-- Unique index (also enforces uniqueness)
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Partial index (PostgreSQL) — index subset of rows
CREATE INDEX idx_active_orders ON orders(customer_id)
WHERE status = 'active';  -- only index active orders
```

## Types of Indexes

```sql
-- Clustered index (Primary Key): rows physically sorted by this key
-- Only ONE per table. In MySQL InnoDB, PK is always clustered.
ALTER TABLE employees ADD PRIMARY KEY (id);

-- Non-clustered index: separate structure pointing to rows
-- Multiple allowed per table
CREATE INDEX idx_dept ON employees(department);

-- Covering index: includes all columns a query needs
-- No need to look up the main table at all
CREATE INDEX idx_covering ON orders(customer_id, status, total_amount);
-- Query: SELECT status, total_amount FROM orders WHERE customer_id = 5
-- ↑ Satisfied entirely by the index (index-only scan)
```

## When to Add an Index

```sql
-- ✅ Good candidates for indexing:

-- 1. Columns in WHERE clause
SELECT * FROM orders WHERE customer_id = 123;  -- index on customer_id

-- 2. Columns in JOIN ON
SELECT * FROM orders o JOIN customers c ON o.customer_id = c.id;
-- index on o.customer_id AND c.id (PK usually auto-indexed)

-- 3. Columns in ORDER BY (eliminates sort step)
SELECT * FROM orders ORDER BY created_at DESC;  -- index on created_at

-- 4. Foreign key columns
-- Always index FK columns — JOINs on them are very common

-- 5. High-cardinality columns (many unique values)
-- email, user_id, order_id → great
-- status ('active'/'inactive') → low cardinality, less useful
```

## When NOT to Add an Index

```sql
-- ❌ Avoid indexes on:
-- 1. Small tables (full scan is fine, index overhead not worth it)
-- 2. Columns rarely used in WHERE/JOIN
-- 3. Tables with heavy INSERT/UPDATE/DELETE (each write updates all indexes)
-- 4. Low-cardinality columns (gender, boolean — not selective enough)
```

## Check if Index is Being Used (EXPLAIN)

```sql
-- MySQL
EXPLAIN SELECT * FROM orders WHERE customer_id = 5;
-- Look for: type = 'ref' or 'range' (good) vs 'ALL' (full scan — bad)
-- key column shows which index is used

-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 5;
-- Look for: Index Scan vs Seq Scan

-- Force index (MySQL)
SELECT * FROM orders USE INDEX (idx_customer_id) WHERE customer_id = 5;
```

## In QA — Validate Index Usage

```sql
-- Check indexes on a table
SHOW INDEX FROM orders;  -- MySQL

-- Find slow queries not using indexes
-- Enable slow query log in MySQL:
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- log queries > 1 second
```$$,
  'SQL', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Indexes', 'B-Tree', 'Clustered Index', 'EXPLAIN', 'Performance', 'SQL', 'Database'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are SQL window functions? Explain ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD.',
  'sql-window-functions-row-number-rank-lag-lead',
  'Window functions perform calculations across a set of rows related to the current row without collapsing them into one row. ROW_NUMBER assigns unique numbers, RANK allows gaps, LAG/LEAD access previous/next rows.',
  $$## SQL Window Functions

Window functions compute values across a "window" of rows **without collapsing them** like GROUP BY does. Uses `OVER()` clause.

## Syntax

```sql
function_name() OVER (
    PARTITION BY column   -- divide into groups (optional)
    ORDER BY column       -- order within each group
    ROWS/RANGE ...        -- frame definition (optional)
)
```

## Sample Data

```sql
| id | name    | department | salary |
|----|---------|-----------|--------|
|  1 | Alice   | QA        | 95000  |
|  2 | Bob     | Dev       | 120000 |
|  3 | Charlie | QA        | 85000  |
|  4 | Diana   | Dev       | 135000 |
|  5 | Eve     | QA        | 110000 |
|  6 | Frank   | Dev       | 120000 |
```

## ROW_NUMBER() — Unique Sequential Number

```sql
-- Number each row within each department by salary (desc)
SELECT name, department, salary,
       ROW_NUMBER() OVER (
           PARTITION BY department
           ORDER BY salary DESC
       ) AS row_num
FROM employees;

-- Result:
-- Alice   | QA  | 95000  | 2
-- Charlie | QA  | 85000  | 3
-- Eve     | QA  | 110000 | 1   ← highest in QA = 1
-- Bob     | Dev | 120000 | 2
-- Diana   | Dev | 135000 | 1   ← highest in Dev = 1
-- Frank   | Dev | 120000 | 3   ← same salary as Bob but different row_num
```

## RANK() — Allows Gaps for Ties

```sql
SELECT name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_num
FROM employees;

-- Bob and Frank both earn 120000 in Dev:
-- Diana | Dev | 135000 | 1
-- Bob   | Dev | 120000 | 2   ← tied
-- Frank | Dev | 120000 | 2   ← tied (same rank)
-- (rank 3 is SKIPPED — gap after tie)
```

## DENSE_RANK() — No Gaps for Ties

```sql
SELECT name, department, salary,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM employees;

-- Diana | Dev | 135000 | 1
-- Bob   | Dev | 120000 | 2   ← tied
-- Frank | Dev | 120000 | 2   ← tied
-- (next rank is 3, NOT 4 — no gap)
```

## RANK vs DENSE_RANK vs ROW_NUMBER

| Ties get same rank? | Gaps after ties? | |
|---------------------|------------------|-|
| ROW_NUMBER | No | No (always unique) |
| RANK | Yes | Yes |
| DENSE_RANK | Yes | No |

## LAG() — Access Previous Row Value

```sql
-- Compare each month's sales with the previous month
SELECT
    month,
    sales,
    LAG(sales, 1, 0) OVER (ORDER BY month) AS prev_month_sales,
    sales - LAG(sales, 1, 0) OVER (ORDER BY month) AS growth
FROM monthly_sales;

-- LAG(column, offset, default)
-- LAG(sales, 1, 0) → previous row's sales, 0 if no previous row
```

## LEAD() — Access Next Row Value

```sql
SELECT
    month,
    sales,
    LEAD(sales, 1) OVER (ORDER BY month) AS next_month_sales
FROM monthly_sales;
-- Shows what the next month will be for each row
```

## Practical: Find Top Earner Per Department

```sql
-- Using ROW_NUMBER to get top 1 per department
SELECT name, department, salary
FROM (
    SELECT name, department, salary,
           ROW_NUMBER() OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS rn
    FROM employees
) ranked
WHERE rn = 1;

-- Result:
-- Eve   | QA  | 110000
-- Diana | Dev | 135000
```

## Running Total (Cumulative SUM)

```sql
SELECT order_id, amount,
       SUM(amount) OVER (ORDER BY order_date) AS running_total
FROM orders;
```$$,
  'SQL', 'Technical', '3-5 Years', 'Advanced',
  ARRAY['Window Functions', 'ROW_NUMBER', 'RANK', 'DENSE_RANK', 'LAG', 'LEAD', 'SQL', 'Analytics'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What are CTEs (Common Table Expressions) in SQL? How do you use WITH clause?',
  'sql-cte-common-table-expressions-with-clause',
  'A CTE (WITH clause) creates a named temporary result set reusable within a query. It improves readability over subqueries and enables recursive queries. Defined with WITH name AS (SELECT ...).',
  $$## CTEs — Common Table Expressions

A **CTE** creates a named, temporary result set defined **before** the main query using the `WITH` keyword. It exists only for the duration of that query.

## Basic Syntax

```sql
WITH cte_name AS (
    -- CTE definition
    SELECT ...
    FROM ...
    WHERE ...
)
-- Main query using the CTE
SELECT * FROM cte_name;
```

## Simple CTE — Replace Nested Subquery

```sql
-- Without CTE (hard to read):
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- With CTE (much cleaner):
WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal FROM employees
)
SELECT e.name, e.salary
FROM employees e, avg_salary a
WHERE e.salary > a.avg_sal;
```

## Multiple CTEs — Chain Them

```sql
WITH
-- Step 1: get avg salary per department
dept_avg AS (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
),
-- Step 2: find departments above company average
high_paying_depts AS (
    SELECT department, avg_sal
    FROM dept_avg
    WHERE avg_sal > (SELECT AVG(salary) FROM employees)
)
-- Step 3: get employees in those departments
SELECT e.name, e.department, e.salary, h.avg_sal AS dept_avg
FROM employees e
JOIN high_paying_depts h ON e.department = h.department
ORDER BY e.salary DESC;
```

## CTE vs Subquery vs Temp Table

```sql
-- Subquery (can''t reuse, hard to read)
SELECT * FROM (SELECT id, name FROM employees WHERE active = 1) AS active_emps;

-- CTE (readable, reusable within query)
WITH active_emps AS (
    SELECT id, name FROM employees WHERE active = 1
)
SELECT * FROM active_emps;   -- can reference multiple times

-- Temp Table (persists for session — different use case)
CREATE TEMP TABLE active_emps AS
SELECT id, name FROM employees WHERE active = 1;
```

## Recursive CTE — Hierarchical Data (Org Chart, Tree)

```sql
-- employees table with manager_id (self-referencing)
-- | id | name    | manager_id |
-- |  1 | CEO     | NULL       |
-- |  2 | VP_Eng  |    1       |
-- |  3 | SDET1   |    2       |
-- |  4 | SDET2   |    2       |

WITH RECURSIVE org_chart AS (
    -- Anchor: start with the CEO (no manager)
    SELECT id, name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: join each employee to their manager
    SELECT e.id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT REPEAT('  ', level) || name AS org_tree, level
FROM org_chart
ORDER BY level, name;

-- Result:
-- CEO          (level 0)
--   VP_Eng     (level 1)
--     SDET1    (level 2)
--     SDET2    (level 2)
```

## CTE for Test Data Preparation

```sql
-- Generate test IDs using CTE
WITH test_users AS (
    SELECT 'user_' || generate_series AS username,
           'user_' || generate_series || '@test.com' AS email,
           'Test@123' AS password
    FROM generate_series(1, 100)  -- PostgreSQL
)
INSERT INTO users (username, email, password)
SELECT username, email, password FROM test_users;
```$$,
  'SQL', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['CTE', 'WITH clause', 'Recursive CTE', 'Common Table Expression', 'SQL', 'Readability'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'What is database normalization? Explain 1NF, 2NF, and 3NF.',
  'sql-database-normalization-1nf-2nf-3nf',
  'Normalization organizes tables to reduce redundancy. 1NF: atomic values, no repeating groups. 2NF: no partial dependency on composite PK. 3NF: no transitive dependency on non-key columns.',
  $$## Database Normalization

**Normalization** is the process of structuring a database to reduce redundancy and improve data integrity by following a set of normal forms (NF).

## Unnormalized Table (Problems)

```sql
-- Single table with all data mixed in
| order_id | customer | phone      | product1  | product2  | city     | state |
|----------|----------|-----------|-----------|-----------|----------|-------|
|        1 | Alice    | 9876543210 | Laptop    | Mouse     | Bangalore| KA    |
|        2 | Bob      | 9123456789 | Keyboard  | NULL      | Mumbai   | MH    |

-- Problems:
-- 1. Multiple products in one row (repeating groups)
-- 2. Update anomaly: if Alice moves, update multiple rows
-- 3. Delete anomaly: delete order 1 → lose Alice's info
-- 4. Insert anomaly: can''t add customer without an order
```

## 1NF — First Normal Form

**Rule**: Each column must hold **atomic (single) values**. No repeating groups. Each row must be unique.

```sql
-- ❌ Violates 1NF: multiple products in one row
| order_id | customer | products        |
|----------|----------|----------------|
|        1 | Alice    | Laptop, Mouse  |

-- ✅ 1NF: one product per row
| order_id | customer | product  |
|----------|----------|---------|
|        1 | Alice    | Laptop  |
|        1 | Alice    | Mouse   |
|        2 | Bob      | Keyboard|
```

## 2NF — Second Normal Form

**Rule**: Must be in 1NF + no **partial dependency** (non-key column depends on only part of a composite primary key).

```sql
-- Table with composite PK: (order_id, product)
-- ❌ Violates 2NF: customer_name depends only on order_id, not on (order_id + product)
| order_id | product  | customer_name | qty |
|----------|----------|--------------|-----|
|        1 | Laptop   | Alice        |   1 |
|        1 | Mouse    | Alice        |   2 |  ← Alice repeated!

-- ✅ 2NF: Split into two tables
-- orders table (order_id → customer_name)
| order_id | customer_name |
|----------|--------------|
|        1 | Alice        |
|        2 | Bob          |

-- order_items table (order_id + product → qty)
| order_id | product  | qty |
|----------|---------|-----|
|        1 | Laptop  |   1 |
|        1 | Mouse   |   2 |
|        2 | Keyboard|   1 |
```

## 3NF — Third Normal Form

**Rule**: Must be in 2NF + no **transitive dependency** (non-key column depends on another non-key column).

```sql
-- ❌ Violates 3NF: zip_code → city and state (transitive dependency!)
-- zip_code is not the PK, but city and state depend on it
| order_id | customer | zip_code | city      | state |
|----------|----------|---------|-----------|-------|
|        1 | Alice    |  560001 | Bangalore | KA    |
|        2 | Bob      |  400001 | Mumbai    | MH    |

-- ✅ 3NF: Move zip_code → city/state to its own table
-- orders table
| order_id | customer | zip_code |
|----------|----------|---------|
|        1 | Alice    |  560001 |
|        2 | Bob      |  400001 |

-- zip_codes table
| zip_code | city      | state |
|---------|-----------|-------|
|  560001 | Bangalore | KA    |
|  400001 | Mumbai    | MH    |
```

## Summary

| Normal Form | Eliminates |
|------------|-----------|
| 1NF | Repeating groups, multi-valued cells |
| 2NF | Partial dependencies on composite PK |
| 3NF | Transitive dependencies between non-key columns |

## Denormalization — When to Break the Rules

```sql
-- Sometimes purposely denormalize for read performance
-- E.g., in a reporting table or data warehouse:
CREATE TABLE order_summary AS
SELECT o.order_id, c.customer_name, c.email,
       p.product_name, oi.quantity, oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON oi.product_id = p.id;
-- Redundant but fast for reports — no JOINs needed
```$$,
  'SQL', 'Technical', '1-2 Years', 'Intermediate',
  ARRAY['Normalization', '1NF', '2NF', '3NF', 'Database Design', 'SQL', 'Redundancy'], true, 0
);

-- ══════════════════════════════════════
-- SCENARIO-BASED / QA-FOCUSED (Q14–Q22)
-- ══════════════════════════════════════

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you find duplicate records in a SQL table?',
  'sql-find-duplicate-records',
  'Use GROUP BY with HAVING COUNT(*) > 1 to find duplicate values. To find entire duplicate rows, use a self-join or ROW_NUMBER() window function. Use DELETE with CTE to remove them.',
  $$## Find Duplicate Records in SQL

## Sample Table: customers

```sql
| id | name    | email              | phone      |
|----|---------|-------------------|-----------|
|  1 | Alice   | alice@test.com    | 9876543210 |
|  2 | Bob     | bob@test.com      | 9123456789 |
|  3 | Alice   | alice@test.com    | 9876543210 | ← duplicate of row 1
|  4 | Charlie | charlie@test.com  | 9999999999 |
|  5 | Bob     | bob@test.com      | 9123456789 | ← duplicate of row 2
```

## Method 1: GROUP BY + HAVING (Most Common)

```sql
-- Find duplicate emails
SELECT email, COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- Result:
-- alice@test.com | 2
-- bob@test.com   | 2

-- Find duplicates across multiple columns
SELECT name, email, COUNT(*) AS count
FROM customers
GROUP BY name, email
HAVING COUNT(*) > 1;
```

## Method 2: Show the Actual Duplicate Rows

```sql
-- Using a subquery to show all columns of duplicate rows
SELECT *
FROM customers
WHERE email IN (
    SELECT email
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email;

-- Result: all 4 duplicate rows shown (ids 1,2,3,5)
```

## Method 3: ROW_NUMBER() to Identify Which to Delete

```sql
-- Assign row number within each duplicate group
-- Keep row_num = 1 (first occurrence), delete rest
WITH ranked AS (
    SELECT id, name, email,
           ROW_NUMBER() OVER (
               PARTITION BY email          -- group duplicates
               ORDER BY id ASC            -- keep lowest id
           ) AS rn
    FROM customers
)
SELECT * FROM ranked;

-- Result:
-- 1 | Alice | alice@test.com | 1 ← keep
-- 3 | Alice | alice@test.com | 2 ← delete
-- 2 | Bob   | bob@test.com   | 1 ← keep
-- 5 | Bob   | bob@test.com   | 2 ← delete
```

## Delete Duplicate Rows (Keep One)

```sql
-- MySQL: delete duplicates, keep the lowest id
DELETE c1
FROM customers c1
JOIN customers c2
  ON c1.email = c2.email
  AND c1.id > c2.id;  -- keep lower id, delete higher

-- PostgreSQL / SQL Server: using CTE + ROW_NUMBER
WITH ranked AS (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM customers
)
DELETE FROM customers
WHERE id IN (SELECT id FROM ranked WHERE rn > 1);
```

## Count Total Duplicates

```sql
-- How many duplicate rows exist?
SELECT COUNT(*) - COUNT(DISTINCT email) AS duplicate_count
FROM customers;
-- COUNT(*) = 5 (all rows)
-- COUNT(DISTINCT email) = 3 (unique emails)
-- Duplicates = 5 - 3 = 2
```

## In QA — Validate No Duplicates After Test Run

```sql
-- Assert unique constraint not violated after data load
SELECT email, COUNT(*) AS cnt
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
-- Expected: 0 rows (no duplicates)

-- Assert test data seeded correctly (no accidental duplicates)
SELECT test_case_id, COUNT(*) AS cnt
FROM test_results
WHERE test_run_id = 'RUN-001'
GROUP BY test_case_id
HAVING COUNT(*) > 1;
-- Expected: 0 rows
```$$,
  'SQL', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Duplicates', 'GROUP BY', 'HAVING', 'ROW_NUMBER', 'SQL', 'Data Quality', 'QA'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you find the Nth highest salary in SQL?',
  'sql-nth-highest-salary',
  'Use ROW_NUMBER() / DENSE_RANK() window function for the cleanest solution. Alternatively use a subquery with DISTINCT and OFFSET, or a correlated subquery. DENSE_RANK handles ties correctly.',
  $$## Find the Nth Highest Salary in SQL

## Sample Table

```sql
| id | name    | salary |
|----|---------|--------|
|  1 | Alice   | 95000  |
|  2 | Bob     | 120000 |
|  3 | Charlie | 85000  |
|  4 | Diana   | 135000 |
|  5 | Eve     | 120000 | ← same as Bob
|  6 | Frank   | 75000  |
```

## Method 1: DENSE_RANK() — Best for Handling Ties

```sql
-- Find the 2nd highest salary
WITH ranked AS (
    SELECT name, salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT name, salary
FROM ranked
WHERE rnk = 2;

-- Result: Bob | 120000, Eve | 120000 (both rank 2)

-- Generic: replace 2 with any N
WITH ranked AS (
    SELECT name, salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT name, salary FROM ranked WHERE rnk = &N;
```

## Method 2: Subquery with DISTINCT + OFFSET

```sql
-- 2nd highest (distinct values)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;  -- skip 1 (highest), return next

-- Nth highest (replace OFFSET 1 with N-1)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET (N - 1);
-- For N=3: OFFSET 2 → skips top 2 unique salaries → returns 3rd
```

## Method 3: Correlated Subquery (Classic Interview Answer)

```sql
-- Find Nth highest: find salary where exactly N-1 salaries are greater
SELECT DISTINCT salary
FROM employees e1
WHERE N - 1 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary > e1.salary
);

-- For N=2 (2nd highest):
SELECT DISTINCT salary
FROM employees e1
WHERE 1 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary > e1.salary
);
-- salary = 120000 (exactly 1 salary [135000] is greater)
```

## Method 4: Using Subquery + NOT IN

```sql
-- 2nd highest salary
SELECT MAX(salary)
FROM employees
WHERE salary NOT IN (SELECT MAX(salary) FROM employees);

-- 3rd highest salary (repeat)
SELECT MAX(salary)
FROM employees
WHERE salary NOT IN (
    SELECT MAX(salary) FROM employees
    UNION
    SELECT MAX(salary) FROM employees WHERE salary != (SELECT MAX(salary) FROM employees)
);
-- Messy for higher N — use DENSE_RANK instead!
```

## Handle No Result (N Exceeds Number of Distinct Salaries)

```sql
-- Return NULL if Nth salary doesn't exist
WITH ranked AS (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT COALESCE(MAX(salary), NULL) AS nth_salary
FROM ranked
WHERE rnk = 5;  -- If only 3 distinct salaries → returns NULL
```

## Common Variations

```sql
-- Nth LOWEST salary
WITH ranked AS (
    SELECT name, salary,
           DENSE_RANK() OVER (ORDER BY salary ASC) AS rnk  -- ASC for lowest
    FROM employees
)
SELECT name, salary FROM ranked WHERE rnk = 2;

-- Nth highest within a department
WITH ranked AS (
    SELECT name, department, salary,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT name, department, salary FROM ranked WHERE rnk = 2;
```$$,
  'SQL', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Nth Highest Salary', 'DENSE_RANK', 'Window Functions', 'SQL', 'Interview Program', 'Subquery'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you use SQL in test automation for database validation?',
  'sql-database-validation-test-automation',
  'In automation, use SQL to verify data after UI/API actions: check record was created, values are correct, no duplicates exist, counts match, and referential integrity is maintained using JDBC or a DB utility class.',
  $$## SQL for Database Validation in Test Automation

Database validation confirms the **backend state** matches what the UI/API claimed to do.

## Why Database Validation?

```
Test Scenario:
1. User submits an order form (UI action)
2. Assert success message appears (UI assertion) ← verifies response
3. Assert order exists in DB with correct data (DB assertion) ← verifies persistence
```

## Java JDBC Database Utility

```java
// src/main/java/utils/DatabaseUtil.java
public class DatabaseUtil {
    private static Connection connection;

    public static void init() throws SQLException {
        String url  = System.getProperty("db.url",  "jdbc:mysql://localhost:3306/testdb");
        String user = System.getProperty("db.user", "qa_user");
        String pass = System.getProperty("db.pass", "qa_pass");
        connection = DriverManager.getConnection(url, user, pass);
    }

    public static ResultSet executeQuery(String sql) throws SQLException {
        return connection.createStatement().executeQuery(sql);
    }

    public static int executeUpdate(String sql) throws SQLException {
        return connection.createStatement().executeUpdate(sql);
    }

    public static String getSingleValue(String sql) throws SQLException {
        ResultSet rs = executeQuery(sql);
        if (rs.next()) return rs.getString(1);
        return null;
    }

    public static int getCount(String sql) throws SQLException {
        ResultSet rs = executeQuery(sql);
        if (rs.next()) return rs.getInt(1);
        return 0;
    }

    public static void close() throws SQLException {
        if (connection != null) connection.close();
    }
}
```

## Test Examples Using JDBC

```java
@Test
public void testOrderCreatedInDatabase() {
    // 1. Place order via UI
    OrderPage orderPage = new OrderPage(driver);
    String orderId = orderPage.placeOrder("Laptop", 1);

    // 2. Validate in database
    String sql = "SELECT status, total_amount FROM orders WHERE order_id = '" + orderId + "'";
    // ⚠️ Use PreparedStatement in real code to avoid SQL injection:
    // SELECT status, total_amount FROM orders WHERE order_id = ?

    String status = DatabaseUtil.getSingleValue(
        "SELECT status FROM orders WHERE order_id = '" + orderId + "'"
    );
    assertEquals("pending", status, "Order status should be 'pending' after creation");

    int count = DatabaseUtil.getCount(
        "SELECT COUNT(*) FROM orders WHERE order_id = '" + orderId + "'"
    );
    assertEquals(1, count, "Exactly one order should exist with this ID");
}
```

## Common DB Validation Queries

```sql
-- 1. Verify record was created
SELECT COUNT(*) FROM users WHERE email = 'newuser@test.com';
-- Expected: 1

-- 2. Verify field values after update
SELECT first_name, last_name, phone
FROM users
WHERE email = 'alice@test.com';
-- Assert: first_name='Alice', last_name='Smith', phone='9999999999'

-- 3. Verify record was deleted
SELECT COUNT(*) FROM products WHERE id = 42 AND deleted_at IS NULL;
-- Expected: 0 (soft-delete) or hard delete = no row at all

-- 4. Verify order total is calculated correctly
SELECT SUM(quantity * unit_price) AS calculated_total, total_amount
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
WHERE o.order_id = 'ORD-001'
GROUP BY total_amount;
-- Assert: calculated_total = total_amount

-- 5. Verify referential integrity after insert
SELECT COUNT(*) FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.id
WHERE o.id IS NULL;
-- Expected: 0 (no orphan order items)

-- 6. Verify audit log entry created
SELECT action, performed_by, timestamp
FROM audit_logs
WHERE entity_type = 'user' AND entity_id = 101
ORDER BY timestamp DESC
LIMIT 1;
```

## Test Data Setup and Teardown

```java
@BeforeMethod
public void setupTestData() throws SQLException {
    // Insert test data before test
    DatabaseUtil.executeUpdate(
        "INSERT INTO users (email, name, status) " +
        "VALUES ('test_auto@test.com', 'Test User', 'active')"
    );
}

@AfterMethod
public void cleanupTestData() throws SQLException {
    // Remove test data after test
    DatabaseUtil.executeUpdate(
        "DELETE FROM users WHERE email = 'test_auto@test.com'"
    );
}
```

## REST Assured + DB Validation

```java
@Test
public void testCreateUserApiAndVerifyInDB() {
    // 1. API call
    Response response = given()
        .contentType(ContentType.JSON)
        .body("{\"name\":\"Alice\",\"email\":\"alice@api.com\"}")
        .post("/api/users")
        .then()
        .statusCode(201)
        .extract().response();

    int userId = response.jsonPath().getInt("id");

    // 2. Verify in database
    String dbName = DatabaseUtil.getSingleValue(
        "SELECT name FROM users WHERE id = " + userId
    );
    assertEquals("Alice", dbName, "Name should match in DB");
}
```$$,
  'SQL', 'Scenario-Based', '1-2 Years', 'Intermediate',
  ARRAY['Database Validation', 'JDBC', 'Test Automation', 'SQL', 'QA', 'Selenium', 'REST Assured'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'Write SQL queries to validate data integrity between two tables.',
  'sql-data-integrity-validation-queries',
  'Validate data integrity by checking foreign key violations (LEFT JOIN where right is NULL), orphan records, referential consistency, and row count matches between source and target tables.',
  $$## Data Integrity Validation Queries

Data integrity checks ensure relationships and constraints are maintained across tables.

## 1. Find Orphan Records (Foreign Key Violations)

```sql
-- Find order_items with no matching order (orphans)
SELECT oi.*
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.id
WHERE o.id IS NULL;
-- Expected: 0 rows (no orphan items)

-- Find orders with no matching customer
SELECT o.id, o.customer_id, o.total_amount
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id
WHERE c.id IS NULL;
-- Expected: 0 rows

-- Find employees assigned to non-existent departments
SELECT e.id, e.name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id
WHERE d.id IS NULL AND e.dept_id IS NOT NULL;
-- Expected: 0 rows
```

## 2. Verify Row Counts Match (Source vs Target)

```sql
-- After data migration: source vs target count
SELECT
    (SELECT COUNT(*) FROM source_customers) AS source_count,
    (SELECT COUNT(*) FROM target_customers) AS target_count,
    (SELECT COUNT(*) FROM source_customers) -
    (SELECT COUNT(*) FROM target_customers) AS difference;
-- Expected: difference = 0

-- Per-status count comparison
SELECT
    status,
    COUNT(*) AS source_count
FROM source_orders
GROUP BY status

EXCEPT   -- or MINUS in Oracle

SELECT
    status,
    COUNT(*) AS target_count
FROM target_orders
GROUP BY status;
-- Expected: 0 rows (both have same status distribution)
```

## 3. Find Records Missing in Target (Data Loss Check)

```sql
-- Rows in source but NOT in target after migration
SELECT id, email FROM source_users
WHERE id NOT IN (SELECT id FROM target_users);

-- Or using EXCEPT (more efficient)
SELECT id, email FROM source_users
EXCEPT
SELECT id, email FROM target_users;
-- Expected: 0 rows

-- Records in target but not in source (phantom records)
SELECT id FROM target_users
EXCEPT
SELECT id FROM source_users;
-- Expected: 0 rows
```

## 4. Verify Data Values Match Between Tables

```sql
-- Check users table matches between source and target
SELECT s.id, s.email AS source_email, t.email AS target_email,
       s.name AS source_name, t.name AS target_name
FROM source_users s
JOIN target_users t ON s.id = t.id
WHERE s.email != t.email
   OR s.name  != t.name
   OR COALESCE(s.phone, '') != COALESCE(t.phone, '');
-- Expected: 0 rows (no mismatches)
```

## 5. Check Financial/Calculation Integrity

```sql
-- Verify order total = sum of line items
SELECT o.id, o.total_amount,
       SUM(oi.quantity * oi.unit_price) AS calculated_total,
       o.total_amount - SUM(oi.quantity * oi.unit_price) AS discrepancy
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.total_amount
HAVING ABS(o.total_amount - SUM(oi.quantity * oi.unit_price)) > 0.01;
-- Expected: 0 rows (no calculation errors)

-- Verify payment amounts match order amounts
SELECT o.id, o.total_amount, p.amount AS paid_amount
FROM orders o
JOIN payments p ON p.order_id = o.id
WHERE o.total_amount != p.amount
  AND o.status = 'paid';
-- Expected: 0 rows
```

## 6. Validate Uniqueness Constraints

```sql
-- Ensure no duplicate primary keys (shouldn't happen but good to check)
SELECT id, COUNT(*) FROM users GROUP BY id HAVING COUNT(*) > 1;

-- Ensure email is unique
SELECT email, COUNT(*) AS cnt
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
-- Expected: 0 rows

-- Ensure unique order numbers
SELECT order_number, COUNT(*)
FROM orders
GROUP BY order_number
HAVING COUNT(*) > 1;
```

## 7. Date/Sequence Integrity

```sql
-- Find orders where created_at > updated_at (impossible)
SELECT id, created_at, updated_at
FROM orders
WHERE updated_at < created_at;
-- Expected: 0 rows

-- Find cancelled orders that still have active payments
SELECT o.id AS order_id, p.id AS payment_id
FROM orders o
JOIN payments p ON p.order_id = o.id
WHERE o.status = 'cancelled'
  AND p.status = 'active';
-- Expected: 0 rows (business rule violation)
```$$,
  'SQL', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Data Integrity', 'Foreign Key', 'Orphan Records', 'Validation', 'SQL', 'QA', 'Migration Testing'], true, 0
);

INSERT INTO interview_questions (question, slug, short_description, answer, technology, question_type, experience_level, difficulty, tags, published, views) VALUES (
  'How do you write a SQL query to get employees without a manager and display the hierarchy?',
  'sql-employee-hierarchy-self-join-recursive-cte',
  'Find employees without a manager using WHERE manager_id IS NULL. Display the full org hierarchy using a recursive CTE with UNION ALL joining each employee to their manager iteratively.',
  $$## Employee Hierarchy with Self-Join and Recursive CTE

## Sample Table: employees

```sql
CREATE TABLE employees (
    id         INT PRIMARY KEY,
    name       VARCHAR(100),
    role       VARCHAR(100),
    manager_id INT REFERENCES employees(id)  -- self-referencing
);

INSERT INTO employees VALUES
(1, 'CEO Sarah',    'CEO',      NULL),   -- top level, no manager
(2, 'CTO Mike',     'CTO',      1),
(3, 'QA Lead Amy',  'QA Lead',  2),
(4, 'SDET Alice',   'SDET',     3),
(5, 'SDET Bob',     'SDET',     3),
(6, 'Dev Lead Dan', 'Dev Lead', 2),
(7, 'Dev Eve',      'Developer',6);
```

## Find Employees Without a Manager (Top Level)

```sql
SELECT id, name, role
FROM employees
WHERE manager_id IS NULL;

-- Result:
-- 1 | CEO Sarah | CEO
```

## Find Direct Reports of a Specific Manager

```sql
-- Who reports directly to the CTO (id = 2)?
SELECT e.id, e.name, e.role
FROM employees e
WHERE e.manager_id = 2;

-- Result:
-- 3 | QA Lead Amy  | QA Lead
-- 6 | Dev Lead Dan | Dev Lead
```

## Display Full Hierarchy Using Recursive CTE

```sql
WITH RECURSIVE hierarchy AS (
    -- Anchor: start from the top (no manager)
    SELECT
        id,
        name,
        role,
        manager_id,
        0 AS depth,
        CAST(name AS VARCHAR(500)) AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: join each employee to their manager
    SELECT
        e.id,
        e.name,
        e.role,
        e.manager_id,
        h.depth + 1,
        CONCAT(h.path, ' → ', e.name)  -- build path
    FROM employees e
    JOIN hierarchy h ON e.manager_id = h.id
)
SELECT
    REPEAT('  ', depth) || name AS indented_name,
    role,
    depth AS level,
    path
FROM hierarchy
ORDER BY path;

-- Result:
-- CEO Sarah              | CEO      | 0 | CEO Sarah
--   CTO Mike             | CTO      | 1 | CEO Sarah → CTO Mike
--     Dev Lead Dan       | Dev Lead | 2 | CEO Sarah → CTO Mike → Dev Lead Dan
--       Dev Eve          | Developer| 3 | ...
--     QA Lead Amy        | QA Lead  | 2 | ...
--       SDET Alice       | SDET     | 3 | ...
--       SDET Bob         | SDET     | 3 | ...
```

## Find All Subordinates of a Given Manager

```sql
-- Find everyone under CTO Mike (id = 2), any number of levels deep
WITH RECURSIVE subordinates AS (
    -- Start with direct reports of CTO
    SELECT id, name, role, manager_id, 1 AS level
    FROM employees
    WHERE manager_id = 2

    UNION ALL

    -- Recursively get their reports
    SELECT e.id, e.name, e.role, e.manager_id, s.level + 1
    FROM employees e
    JOIN subordinates s ON e.manager_id = s.id
)
SELECT name, role, level
FROM subordinates
ORDER BY level, name;

-- Result: Amy, Dan (level 1), Alice, Bob, Eve (level 2)
```

## Count Employees Under Each Manager

```sql
WITH RECURSIVE subordinates AS (
    SELECT id, manager_id FROM employees WHERE manager_id IS NOT NULL
    UNION ALL
    SELECT e.id, s.manager_id
    FROM employees e JOIN subordinates s ON e.manager_id = s.id
)
SELECT m.name AS manager, COUNT(s.id) AS total_reports
FROM employees m
LEFT JOIN subordinates s ON s.manager_id = m.id
GROUP BY m.id, m.name
ORDER BY total_reports DESC;
```$$,
  'SQL', 'Scenario-Based', '3-5 Years', 'Advanced',
  ARRAY['Recursive CTE', 'Self-Join', 'Hierarchy', 'Manager Employee', 'SQL', 'Tree Structure'], true, 0
);
