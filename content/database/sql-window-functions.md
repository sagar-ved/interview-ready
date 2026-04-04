---
title: "Database SQL: Window Functions and Advanced Queries"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Given an orders table, write a query to find the running total, rank customers by total spend, and find the previous order value for each customer using window functions. Explain EXPLAIN ANALYZE output.

## 🎯 What the interviewer is testing
- SQL Window Functions (ROW_NUMBER, RANK, LAG, SUM OVER)
- Query execution plan analysis
- CTE vs subquery performance
- Real-world analytical queries in e-commerce/finance context

---

## 🧠 Deep Explanation

### 1. Window Functions vs GROUP BY

`GROUP BY` collapses rows. Window functions **preserve the rows** and add a computed column.

```sql
-- GROUP BY: collapses to 1 row per customer
SELECT customer_id, SUM(amount) FROM orders GROUP BY customer_id;

-- Window: each order row retained, total added alongside
SELECT customer_id, amount, SUM(amount) OVER (PARTITION BY customer_id) AS customer_total
FROM orders;
```

### 2. Core Window Function Syntax

```sql
function_name() OVER (
  PARTITION BY column   -- Like GROUP BY: restart per group
  ORDER BY column       -- Defines row ordering within partition
  ROWS BETWEEN ...      -- Frame: which rows to include
)
```

### 3. Key Window Functions

| Function | Description |
|---|---|
| `ROW_NUMBER()` | Sequential number — no ties |
| `RANK()` | Gap after ties (1,1,3) |
| `DENSE_RANK()` | No gap after ties (1,1,2) |
| `LAG(col, n)` | Value n rows before current |
| `LEAD(col, n)` | Value n rows after current |
| `SUM() OVER (ORDER BY)` | Running total |
| `FIRST_VALUE()` | Value of first row in partition |
| `NTILE(n)` | Divide into n buckets |

### 4. EXPLAIN ANALYZE

```
Seq Scan on orders (cost=0.00..1234.00 rows=10000 width=32)
→ Full table scan — missing index

Index Scan using idx_customer_id (cost=0.43..8.45 rows=1 width=32)
→ Using index — fast single-row lookup

Sort (cost=1234.56..1259.56 rows=10000 width=32)
→ In-memory sort; "Sort Method: quicksort Memory: 8195kB"
→ If "external merge Disk:", add more work_mem
```

**Key metrics**: `cost` (planner estimate), `rows` (estimated vs actual), `loops`.

---

## ✅ Ideal Answer

- Use `SUM() OVER (PARTITION BY customer_id ORDER BY order_date)` for running totals per customer.
- Use `DENSE_RANK() OVER (ORDER BY total_spend DESC)` for customer ranking.
- Use `LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date)` for previous value.
- Analyze with `EXPLAIN ANALYZE` to identify sequential scans vs index scans.

---

## 💻 SQL Code

```sql
-- Schema
CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INT          NOT NULL,
    order_date  DATE         NOT NULL,
    amount      DECIMAL(10,2) NOT NULL,
    status      VARCHAR(20)
);

-- 1. Running total per customer (ordered by date)
SELECT 
    order_id,
    customer_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id       -- Reset sum per customer
        ORDER BY order_date            -- Accumulate chronologically
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
ORDER BY customer_id, order_date;

-- 2. Rank customers by total spending (DENSE_RANK: no gaps on ties)
SELECT 
    customer_id,
    total_amount,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS spending_rank
FROM (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM orders
    GROUP BY customer_id
) customer_totals;

-- 3. Compare each order to the previous order for the same customer
SELECT 
    order_id,
    customer_id,
    order_date,
    amount,
    LAG(amount, 1, 0) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS prev_order_amount,
    amount - LAG(amount, 1, 0) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS amount_change
FROM orders
ORDER BY customer_id, order_date;

-- 4. Top 3 orders per customer using ROW_NUMBER
WITH ranked_orders AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY amount DESC
        ) AS rn
    FROM orders
)
SELECT * FROM ranked_orders WHERE rn <= 3;

-- 5. Moving 7-day average of daily revenue
SELECT 
    order_date,
    SUM(amount) AS daily_revenue,
    AVG(SUM(amount)) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW  -- 7-day window
    ) AS moving_avg_7d
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- EXPLAIN ANALYZE: read the execution plan
EXPLAIN ANALYZE
SELECT customer_id, SUM(amount) 
FROM orders 
WHERE status = 'SHIPPED'
GROUP BY customer_id;
```

---

## ⚠️ Common Mistakes
- Confusing `RANK` vs `DENSE_RANK` (for leaderboards, DENSE_RANK is usually preferred — no phantom ranks)
- Using `ORDER BY` inside window function without `PARTITION BY` — operates over ALL rows
- Not indexing window function partition/order columns in large datasets
- Using subquery instead of CTE for readability (CTEs are generally not materialized in modern RDBMS → same performance)

---

## 🔄 Follow-up Questions
1. **When does PostgreSQL materialize a CTE?** (By default CTEs are optimization fences in PG < 12; in PG12+, they can be inlined. Use `WITH MATERIALIZED` or `NOT MATERIALIZED` to control.)
2. **What is the performance difference between `RANK()` and `DENSE_RANK()`?** (Same O(n log n) performance; only output differs.)
3. **How would you find the median salary per department without Window Functions?** (Correlated subquery counting rows before/after current — very slow O(n²). Window NTILE(2) or PERCENTILE_CONT(0.5) is far better.)
