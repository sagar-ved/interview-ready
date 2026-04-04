---
title: "Database: Indexing and Optimization"
date: 2024-04-04
draft: false
---

# 🧩 Question: Explain B+ Trees vs LSM Trees. How do composite indexes work, and what is the "Leftmost Prefix" rule?

## 🎯 What the interviewer is testing
*   **Storage Engines**: B+ Trees (Read-optimized) vs LSM Trees (Write-optimized).
*   **Query Performance**: Indexing strategies, covering indexes, and query plans.
*   **Relational Algebra**: Understanding how multiple columns are indexed together.
*   **Real-world Trade-offs**: When to use SQL (B+ Tree) vs NoSQL (LSM Tree).

---

## 🧠 Deep Explanation

### 1. B+ Trees (Relational Databases)
-   Used in **MySQL (InnoDB)**, **PostgreSQL**.
-   Optimized for **Read** and **Range scans**.
-   All data is stored in the **leaf nodes**.
-   Internal nodes only store keys (higher fan-out, fewer tree levels).
-   **Cons**: Random writes (inserting in the middle of a page) cause fragmentation and page splits.

### 2. LSM Trees (Log-Structured Merge Trees)
-   Used in **Cassandra**, **LevelDB**, **RocksDB** (NoSQL).
-   Optimized for **Write** throughput.
-   Writes are initially stored in an in-memory **Memtable**.
-   Once full, the Memtable is flushed to an immutable **SSTable** on disk.
-   Background **Compaction** merges SSTables.
-   **Cons**: Read Amplification (might need to check multiple SSTables for a single read). Use **Bloom Filters** to optimize.

### 3. Composite Indexes and the Leftmost Prefix Rule
-   A **Composite Index** is an index on multiple columns, e.g., `INDEX(last_name, first_name)`.
-   The index is sorted first by `last_name`, and then by `first_name` for each last name.
-   **Leftmost Prefix Rule**:
    -   `WHERE last_name = 'Doe'` → USES INDEX.
    -   `WHERE last_name = 'Doe' AND first_name = 'John'` → USES INDEX.
    -   `WHERE first_name = 'John'` → DOES NOT USE INDEX (the index isn't sorted solely by first_name).

### 4. Covering Indexes
-   An index that contains all the columns needed for a query.
-   **Result**: The database doesn't have to perform a "Book Lookup" (Heap Fetch) from the actual table, leading to much faster results.

---

## ✅ Ideal Answer (Structured)

*   **Tree Structures**: Distinguish between B+ Trees for consistency/reads and LSM Trees for massive writes.
*   **Index Composition**: Explain that a composite index `(A, B, C)` can satisfy queries for `(A)`, `(A, B)`, and `(A, B, C)`, but not `(B)` or `(C)`.
*   **Query Plans**: Mention `EXPLAIN ANALYZE` as the primary tool to verify index usage.
*   **Trade-offs**: Explain that more indexes speed up reads but slow down `INSERT/UPDATE/DELETE` operations.

---

## 💻 SQL Example (Indexing Strategy)

```sql
-- Table Definition
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    status VARCHAR(20),
    order_date TIMESTAMP,
    total_amount DECIMAL(10, 2)
);

-- 1. Composite Index with Leftmost Prefix Rule
CREATE INDEX idx_customer_status ON orders(customer_id, status);

-- ✅ This query uses the index
SELECT * FROM orders WHERE customer_id = 500;

-- ✅ This query also uses the index
SELECT * FROM orders WHERE customer_id = 500 AND status = 'SHIPPED';

-- ❌ This query DOES NOT use the index (Violates Leftmost Prefix)
SELECT * FROM orders WHERE status = 'SHIPPED';

-- 2. Covering Index Example
CREATE INDEX idx_customer_amount ON orders(customer_id, total_amount);

-- ✅ This query is "Index-Only" (Covering Index)
-- The DB gets 'total_amount' directly from the index.
SELECT total_amount FROM orders WHERE customer_id = 500;
```

---

## ⚠️ Common Mistakes
*   **Over-indexing**: Adding too many indexes, which slows down write operations significantly.
*   **Index on Low Cardinality Columns**: Creating an index on a boolean column (e.g., `is_active`). The optimizer will likely ignore it and perform a full table scan.
*   **Functions in WHERE**: `WHERE YEAR(order_date) = 2024` often prevents index usage unless a functional index is created.

---

## 🔄 Follow-up Questions
1.  **What is a "Clustered Index"?** (Answer: The index that dictates the physical storage order of data, usually the Primary Key).
2.  **Explain "Index Fragmentation".** (Answer: Occurs when random inserts leave holes in B+ tree pages; fixed via `OPTIMIZE TABLE`).
3.  **How do Bloom Filters help LSM Trees?** (Answer: They provide a probabilistic way to check if a key *might* exist in an SSTable, avoiding unnecessary disk reads).
