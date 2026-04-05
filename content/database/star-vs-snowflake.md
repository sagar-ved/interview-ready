---
title: "Database: Star Schema vs. Snowflake Schema"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: Compare Star Schema and Snowflake Schema in Data Warehousing. When would you use each?

## 🎯 What the interviewer is testing
- Data modeling for large-scale analytics.
- Normalization vs Denormalization tradeoff.
- Performance implications for BI tools.

---

## 🧠 Deep Explanation

### 1. Star Schema:
- **Fact Table**: Central table containing metrics (like `SalesValue`).
- **Dimension Tables**: Surrounded by the fact table. These are **Denormalized** (e.g., a single `Product` table containing `Category` names).
- **Benefit**: Fewer joins (usually just one), very fast queries for aggregation. Simplest for BI tools to understand.

### 2. Snowflake Schema:
- An extension of Star where **Dimension tables are Normalized**.
- Instead of a category name in the `Product` table, you have a `CategoryID` pointing to a `Categories` table.
- **Benefit**: Reduced data redundancy and smaller storage.
- **Negative**: Many more joins, which can slow down query performance in analytical environments.

---

## ✅ Ideal Answer
Star schemas are prioritized for query simplicity and performance in OLAP environments, where the cost of disk space is outweighed by the need for fast aggregations. Snowflake schemas are used when data normalization is critical for data integrity or when dealing with extremely hierarchies.

---

## 🏗️ Schema Visual:
- **Star**: Fact → Store (denormalized)
- **Snowflake**: Fact → Store → City → Region → Country (normalized)

---

## 🔄 Follow-up Questions
1. **What is a "Slowly Changing Dimension" (SCD)?** (The way you handle updates to dimension data over time, like a user changing their address.)
2. **What is a Surrogate Key?** (A system-generated ID used as a PK instead of a natural key like SSN.)
3. **Difference between OLTP and OLAP?** (Transactional vs Analytical workloads.)
