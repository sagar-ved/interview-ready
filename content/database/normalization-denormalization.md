---
author: "sagar ved"
title: "Database: Normalization vs. Denormalization Rules"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: When should you violate 3rd Normal Form? Explain the tradeoffs of Denormalization.

## 🎯 What the interviewer is testing
- Real-world pragmatic DB design.
- Performance vs Data Integrity.
- SQL for OLTP vs OLAP.

---

## 🧠 Deep Explanation

### 1. Normalization (OLTP - Apps):
- **Goal**: Minimize redundancy and maintain integrity. 
- **1NF, 2NF, 3NF**: Splitting data into many small tables.
- **Problem**: Large queries require 5-6 **JOINS**, which is slow.

### 2. Denormalization (OLAP - Analytics):
- **Goal**: Maximize Read performance.
- **Method**: Intentionally adding redundant data (e.g., storing `username` in the `orders` table even though it's already in the `users` table).
- **Pros**: Fewer joins, faster aggregation.
- **Cons**: 
  1. **Update Anomaly**: If a user changes their name, you must update it in multiple tables.
  2. Increased storage.

### 3. Rule of Thumb:
Normalize for **Transactions** (consistency is key). Denormalize for **Analytics** and **High-traffic Reads** (where storage is cheap but CPU/Joins are expensive).

---

## ✅ Ideal Answer
Normalization is the academic ideal for clean data, but denormalization is the engineering reality for high-performance systems. While normalized schemas protect against data corruption during writes, redundant data structures are often necessary to satisfy complex read patterns in real-time. The key is to manage the redundant "sync" logic, often using application-level events or database triggers.

---

## 🔄 Follow-up Questions
1. **What is a "Flat Table"?** (A completely denormalized table with no joins allowed.)
2. **What is a "Star Schema"?** (A central Fact table surrounded by denormalized Dimension tables.)
3. **What is the risk of update anomalies?** (Inconsistent data — e.g. User shows different names on different pages.)
