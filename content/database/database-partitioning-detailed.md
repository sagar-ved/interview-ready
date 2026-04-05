---
title: "Database: Horizontal vs. Vertical Partitioning"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: Explain the difference between Horizontal and Vertical Partitioning. Which one solves "Wide Tables"?

## 🎯 What the interviewer is testing
- Logical vs Physical storage optimization.
- Scaling database limits.
- Impact on JOIN operations and maintenance.

---

## 🧠 Deep Explanation

### 1. Vertical Partitioning (Splitting Columns):
- **The Problem**: A "Wide Table" with 100 columns. Most queries only need `ID` and `Name`. The `Description` (text-heavy) slows down every scan.
- **The Fix**: Move the heavy/rarely-used columns into a separate table.
- **Result**: More rows fit in one disk page for the "Main" table (faster scans).

### 2. Horizontal Partitioning / Sharding (Splitting Rows):
- **The Problem**: A table with 1 Billion rows. Searching becomes slow even with indexes.
- **The Fix**: Put Rows 1-500M on Server A, and 500M-1B on Server B.
- **Result**: Parallel processing of data.

---

## ✅ Ideal Answer
Vertical partitioning optimizes the database for specific access patterns by pruning unnecessary columns, thereby increasing cache efficiency. Horizontal partitioning, or sharding, is our primary tool for high availability and volume management, allowing us to distribute a massive dataset across multiple physical nodes. Together, these strategies ensure that neither the count of rows nor the width of records becomes a structural bottleneck.

---

## 🏗️ Visual State:
- **Vertical**: `[Col A, Col B] | [Col C (Heavy)]`
- **Horizontal**: `[Row 1-10] | [Row 11-20]`

---

## 🔄 Follow-up Questions
1. **What is a "Shard Key"?** (The column used to decide where a row goes — e.g. `user_id % 4`.)
2. **Risk of Vertical Partitioning?** (Increases the number of JOINS needed to see the full record.)
3. **What is "List Partitioning"?** (Splitting by a specific list of values, like `Country = 'US'`.)
