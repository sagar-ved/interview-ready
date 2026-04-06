---
author: "sagar ved"
title: "Database: 4 Normal Forms of Database Design"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: Explain the 1st through 3rd Normal Forms (and BCNF). Why do we denormalize in production?

## 🎯 What the interviewer is testing
- Data integrity principles.
- Identifying and removing redundancies.
- Practical vs Pure database theory.

---

## 🧠 Deep Explanation

### 1. 1NF (Atomic):
- Each column contains only **atomic** (indivisible) values. No lists/arrays in a column.

### 2. 2NF (No Partial Dependency):
- Must be in 1NF.
- All non-key columns must depend on the **entire** composite primary key.

### 3. 3NF (No Transitive Dependency):
- Must be in 2NF.
- Non-key columns should not depend on other non-key columns. ("Dependencies on the PK, and nothing but the PK").

### 4. BCNF (Boyce-Codd):
- Stronger version of 3NF. Handles anomalies when there are multiple overlapping candidate keys.

### Why Denormalize?
Normalization reduces data redundancy and improves integrity. However, it requires many **JOINS** for simple queries.
- In production (e.g., Analytics), we denormalize (duplicate data) to **improve Read performance**.
- Trade-off: Faster reads vs complex/slower updates.

---

## ✅ Ideal Answer
Normalization is about organizing data to minimize redundancy and prevent update anomalies. While 3NF is the gold standard for OLTP systems, we intentionally denormalize (Star schemas) in OLAP/Reporting systems to eliminate costly JOIN operations and speed up wide-scale analytical queries.

---

## 🔄 Follow-up Questions
1. **Explain Transitive Dependency.** (A depends on B, and B depends on C; so A depends on C through B.)
2. **What is an Update Anomaly?** (When you update a value in one place but it remains old elsewhere due to redundancy.)
3. **When to choose 3NF vs BCNF?** (Usually, 3NF is sufficient for practical production systems.)
