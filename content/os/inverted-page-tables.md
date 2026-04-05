---
title: "OS: Inverted Page Table"
date: 2024-04-04
draft: false
weight: 27
---

# 🧩 Question: What is an Inverted Page Table? How does it save memory compared to standard page tables?

## 🎯 What the interviewer is testing
- Advanced memory management strategies.
- Handling huge address spaces (64-bit).
- Physical vs Virtual mapping approach.

---

## 🧠 Deep Explanation

### 1. Standard Page Table (Virtual-led):
One table (or tree) per process. Maps **Virtual -> Physical**.
- **Problem**: In a 64-bit system, the table size is astronomical.

### 2. Inverted Page Table (Physical-led):
**One table for the ENTIRE system**. One entry per physical frame in RAM.
- Maps **Physical -> (ProcessID, VirtualPage)**.
- **Size**: Scaled to the size of Physical RAM, not Virtual Address Space.

### 3. The Catch:
Search is slow! To translate an address, you'd have to search the whole table.
- **Solution**: Use a **Hash Table** for lookup. 
- **Hash(ProcessID, VirtualPage) -> Index in IPT**.

---

## ✅ Ideal Answer
Standard page tables scale with the theoretical size of memory, while Inverted Page Tables scale with the actual physical RAM installed. This makes them significantly more efficient for 64-bit systems. However, this space efficiency comes at the cost of lookup speed, requiring a robust hashing mechanism to maintain acceptable performance during address translation.

---

## 🏗️ Comparison:
- **Standard**: `Input: Virtual Addr` -> `Output: Physical Addr`. (Many tables)
- **Inverted**: `Search: (PID, Virtual)` -> `Result: Index of Table`. (One table)

---

## 🔄 Follow-up Questions
1. **Is IPT used in modern PCs?** (Mostly no. 4-level standard page tables are faster given the high performance of modern MMUs.)
2. **What happens if two processes share memory?** (Inverted tables make this difficult because each entry only has one (PID, VPage) slot.)
3. **What is the search complexity of IPT?** ($O(1)$ on average with Hash; $O(N)$ worst case.)
