---
author: "sagar ved"
title: "Database: B-Tree vs. B+ Tree Internals"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 Question: What is the primary difference between a B-Tree and a B+ Tree? Why do databases use the B+ Tree almost exclusively?

## 🎯 What the interviewer is testing
- Deep knowledge of disk-optimized data structures.
- Range-query performance.
- Cache efficiency in tree traversal.

---

## 🧠 Deep Explanation

### 1. B-Tree:
- **Data Location**: Both keys and data (or pointers to data) are stored in **Internal Nodes**.
- **Issue**: If you are searching for node X, your traversal hits fewer keys per page because space is taken up by the data itself.

### 2. B+ Tree:
- **Data Location**: Only stored in the **Leaf Nodes**. Internal nodes only store keys (for guiding search).
- **Linked Leaves**: All leaf nodes are linked together in a **Doubly Linked List**.
  - **Major Benefit**: For a range query (`SELECT * WHERE price BETWEEN 10 AND 50`), you find '10' once and then just traverse the linked list. In a B-Tree, you would have to go back "up" the tree repeatedly.

### 3. Cache Efficiency:
Because B+ Tree internal nodes don't have data, more keys fit in a single disk block (Page). This means the tree is "flatter" (fewer levels), requiring fewer disk I/O operations.

---

## ✅ Ideal Answer
While a B-Tree can potentially find a value in fewer hops if it's near the root, B+ Trees are superior for real-world database workloads. Their concentration of data in the leaves and the linked-list traversal between them makes range queries incredibly fast and keeps the tree shallow, minimizing the expensive disk seeks that are the primary bottleneck in large-scale storage.

---

## 🏗️ Visual:
- **B-Tree**: `(Node + Data) -> (Node + Data)`
- **B+ Tree**: `Nodes --(Linked List)--> [Data][Data][Data]`

---

## 🔄 Follow-up Questions
1. **What is the "Fan-out" of a tree?** (The number of children each node has; B+ trees have high fan-out.)
2. **Time Complexity of search?** ($O(\log N)$).
3. **What is an "Index-Organized Table"?** (When the physical data is stored directly in the B+ Tree leaves of the Primary Key.)
