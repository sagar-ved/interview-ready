---
author: "sagar ved"
title: "Database: Partial Indexes (SQL Optimization)"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: What is a Partial Index? How does it help in multitenant or status-driven systems?

## 🎯 What the interviewer is testing
- Precision indexing techniques.
- Minimizing index maintenance overhead.
- Storage efficiency in large tables.

---

## 🧠 Deep Explanation

### 1. The Concept:
A standard index logs every row. A **Partial Index** only includes rows that meet a specific condition (a `WHERE` clause in the index definition).
`CREATE INDEX ... ON orders(created_at) WHERE status = 'PENDING';`

### 2. Why use it?
- **Small Index**: If 99% of your orders are 'COMPLETE', the index on 'PENDING' will be tiny and stay in RAM.
- **Speed**: Inserts for 'COMPLETE' orders don't need to update this index (no overhead).
- **Multitenancy**: If 90% of data belongs to "Default Tenant", you might only index "Paid Tenants."

---

## ✅ Ideal Answer
Partial indexes allow us to selectively index only the "interesting" parts of a table. By excluding vast amounts of stable or irrelevant data from the index structure, we dramatically reduce disk I/O, keep the index memory-resident, and lower the write cost for the majority of database transactions. This is a crucial optimization for high-scale systems where only a fraction of raw data represents active work.

---

## 🏗️ SQL Example:
```sql
-- Only index active users to keep session lookups fast
CREATE INDEX active_users_idx 
ON users (id) 
WHERE is_active = true AND last_login > '2023-01-01';
```

---

## 🔄 Follow-up Questions
1. **Does MySQL support Partial Indexes?** (No, it's primarily a PostgreSQL and SQL Server feature; MySQL uses "Prefix Indexes" but they aren't the same.)
2. **What happens if a query doesn't match the WHERE clause?** (The DB ignores the index and does a sequential scan or uses another index.)
3. **Can you combine a Partial index with a Covering index?** (Yes, providing massive performance for specific, frequent queries.)
