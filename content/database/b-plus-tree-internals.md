---
title: "Databases: B-Tree vs B+ Tree Internals"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Why do relational databases (MySQL, Postgres) use B+ Trees instead of B-Trees or Binary Search Trees for indexing? Explain the physical structure.

## 🎯 What the interviewer is testing
- Understanding of disk I/O optimization.
- Cache locality and pointer management.
- Range query performance.

---

## 🧠 Deep Explanation

### 1. The Disk Problem:
Reading from disk (HDD/SSD) is orders of magnitude slower than RAM. Data is read in **Pages** (blocks), typically 4KB or 8KB. A Tree structure for an index must minimize the number of "page reads" to find a key.

### 2. Why NOT BST?
BST is too deep. For 1 million entries, depth is ~20. That's 20 random disk reads.

### 3. B-Tree vs B+ Tree:
- **B-Tree**: Data pointers are stored in **both** internal nodes and leaf nodes.
- **B+ Tree**: Data pointers (or the data itself) are **only** stored in leaf nodes. Internal nodes only store keys for routing.

### 4. Advantages of B+ Tree:
- **Higher Fan-out**: Since internal nodes don't store data/pointers to rows, they can store many more keys per page. 1000 keys per page means 1 billion entries in just 3 levels!
- **Efficient Range Scans**: Leaf nodes are linked together in a **Linked List**. To do a range query `(age > 20 AND age < 30)`, you find '20' in a leaf and just follow the next pointers until you hit '30'. B-Trees would require multiple vertical traversals.
- **Better Cache Locality**: Internal nodes stay cached in memory because they are small and frequently accessed.

---

## ✅ Ideal Answer
Databases prioritize minimizing disk I/O. B+ Trees offer a very high fan-out, meaning the tree is extremely shallow (usually 3-4 levels for billions of rows). By storing data only at leaves and linking leaves together, B+ Trees are significantly faster for range queries and full scans compared to B-Trees.

---

## 💻 Visual Representation
```
Internal Node: [ Key1 | Key2 | Key3 ] (Only for routing)
                   /      |      \
        [Leaf1] <-> [Leaf2] <-> [Leaf3] (Actual data + Next pointers)
```

---

## ⚠️ Common Mistakes
- Saying B+ Tree is better because it's "faster" without explaining disk blocks or fan-out.
- Forgetting the linked-list nature of leaf nodes.
- Thinking B+ Tree is used for NoSQL (usually LSM Trees are used for write-heavy NoSQL).

---

## 🔄 Follow-up Questions
1. **What is an LSM Tree?** (Used in Cassandra/LevelDB; optimized for writes by converting random writes to sequential writes.)
2. **What is a Clustered Index?** (The B+ Tree where the leaf nodes contain the actual row data, not just pointers.)
3. **What is the height of a B+ tree for 100M rows?** (Assuming page size 16KB and key size 16B, fan-out is ~1000. Height 3 is enough.)
