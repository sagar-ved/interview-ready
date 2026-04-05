---
title: "Databases: Sparse vs. Dense Indexes"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 Question: Compare Sparse and Dense Indexes. When is it better to use a Sparse index?

## 🎯 What the interviewer is testing
- Understanding of Index-to-Data ratios.
- Impact of storage space vs lookup speed.
- How databases handle huge datasets.

---

## 🧠 Deep Explanation

### 1. Dense Index:
- **Definition**: An index entry for **every single search key** in the data file.
- **Pros**: Fact. To find if a key exists, you only check the index.
- **Cons**: High storage cost.

### 2. Sparse Index:
- **Definition**: Index entries for **only a subset** of the search keys (usually one per data block/page).
- **Pros**: Much smaller. Fits in RAM easily.
- **Cons**: Slower. To find a key, the DB finds the closest "smaller" entry in the index, then performs a sequential scan of the data block.

### 3. Usage:
- **Clustered Indexes** are often Sparse (one entry per page).
- **LSM-based Databases** (like Cassandra) use Sparse indexing in their SSTables.

---

## ✅ Ideal Answer
A dense index accounts for every row, making lookups extremely direct at the cost of memory. A sparse index only maps the beginning of each physical disk block, which dramatically saves space and is highly effective when the data is physically sorted on disk. Sparse indexing is the go-to choice for managing multi-terabyte datasets where the index must remain in memory.

---

## 🏗️ Visual:
- **Dense**: `Row1 -> Ptr1`, `Row2 -> Ptr2`, `Row3 -> Ptr3`
- **Sparse**: `Block1_Start -> Ptr_Block1`, `Block2_Start -> Ptr_Block2`

---

## 🔄 Follow-up Questions
1. **What is a "Multilevel Index"?** (Creating an index for the index itself — e.g. B-Trees.)
2. **What is a "Bitmap Index"?** (Used for columns with low cardinality like "Gender".)
3. **Can a Sparse index be used for non-sorted data?** (No, it relies on the physical order of the data blocks.)
