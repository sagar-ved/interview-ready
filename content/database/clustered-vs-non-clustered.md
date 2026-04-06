---
author: "sagar ved"
title: "Database: Clustered vs. Non-Clustered Indexes"
date: 2024-04-04
draft: false
weight: 14
---

# 🧩 Question: What is the physical difference between a Clustered Index and a Non-Clustered Index? How many of each can you have?

## 🎯 What the interviewer is testing
- Physical data layout on disk.
- How indexes actually speed up `SELECT`.
- Understanding of the "Primary Key" storage.

---

## 🧠 Deep Explanation

### 1. Clustered Index:
- **Physical Order**: The data rows themselves are stored in the index.
- **Constraint**: Only **one** per table (because you can only sort the physical rows once).
- Most databases automatically use the **Primary Key** as the clustered index.
- **Performance**: Extremely fast for range scans on the PK.

### 2. Non-Clustered Index:
- **Physical Order**: Its own structure (typically a B+ tree) that stores a reference (pointer) to the actual data.
- **Limit**: Can have many.
- **Cost**: A "lookup" step. Finding a key in a non-clustered index gives you a pointer → you then have to seek that row in the main table.

### 3. Covering Index:
If a non-clustered index contains all the columns requested in the `SELECT`, it is called a "Covering Index." The DB doesn't even have to look at the main table (avoids the "Bookmark Lookup" cost).

---

## ✅ Ideal Answer
A clustered index determines the physical storage order of the data; it resides with the rows. A non-clustered index is a separate structure that points to the data. While clustered indexes are great for primary ranges, non-clustered indexes allow for multiple efficient search paths at the cost of additional storage and a small overhead for lookups.

---

## 🏗️ Index Visual:
- **Clustered**: `[Key | Data Page]`
- **Non-Clustered**: `[Key | Pointer to Clustered Key]`

---

## 🔄 Follow-up Questions
1. **Why is inserting into a clustered index expensive?** (Might require moving physical rows to make space in the middle of the table.)
2. **What is a "Composite Index"?** (An index on multiple columns.)
3. **When to use non-clustered?** (For search filters that aren't the primary key.)
