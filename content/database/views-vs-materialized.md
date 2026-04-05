---
title: "Database: Database View vs. Materialized View"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 Question: Compare a standard Database View and a Materialized View. When would you use each?

## 🎯 What the interviewer is testing
- Memory/Disk vs CPU trade-off.
- Caching results of complex queries.
- Impact on data freshness and storage.

---

## 🧠 Deep Explanation

### 1. Standard View (Virtual):
- **What**: Just a stored query.
- **Execution**: Every time you `SELECT * FROM view`, the underlying query is executed **at that moment**.
- **Storage**: Almost zero (just the text of the SQL query).
- **Freshness**: 100% (it's live data).

### 2. Materialized View (Physical Cache):
- **What**: The results of the query are stored as a **physical table** on disk.
- **Execution**: Queries against it are instant because the data is pre-calculated.
- **Storage**: High (duplicate of the underlying data).
- **Freshness**: Not guaranteed. It must be **refreshed** periodically or on-demand.

---

## ✅ Ideal Answer
A standard view is great for simplifying complex queries or providing security layers without using storage. A materialized view is a powerful optimization for heavy analytical queries (reporting) where you can tolerate slightly stale data in exchange for massive performance gains.

---

## 🏗️ Use Case Table:
| Feature | View | Materialized View |
|---|---|---|
| Speed | Slow (runs on demand) | Fast (pre-calculated) |
| Freshness | Always Live | Periodic Refresh |
| Storage | No | Yes |
| Use Case | Security / Simplification | Analytics / Reports |

---

## 🔄 Follow-up Questions
1. **What is an "Incremental Refresh"?** (Only updating the materialized view with rows that changed in the base tables, rather than re-calculating the whole thing.)
2. **Can you index a view?** (Generally no for standard views, but you CAN index a Materialized View because it's a physical table.)
3. **What is an "Indexed View" in SQL Server?** (A specific implementation of a Materialized View that updates automatically.)
