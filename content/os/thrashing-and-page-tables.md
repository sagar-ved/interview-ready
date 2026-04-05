---
title: "OS: Thrashing and Inverted Page Tables"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 Question: What is Thrashing in Operating Systems? Explain the "Working Set" model and Inverted Page Tables.

## 🎯 What the interviewer is testing
- Memory management at the breaking point.
- Understanding of the locality of reference.
- Modern page table optimizations.

---

## 🧠 Deep Explanation

### 1. Thrashing:
Thrashing occurs when the OS spends more time **swapping pages** in and out of disk than executing instructions.
- Happens when the total "Working Set" of all processes exceeds physical RAM.
- CPU utilization drops because all processes are blocked waiting for disk I/O.
- OS might wrongly believe CPU is idle and start *more* processes, making the problem worse!

### 2. Working Set Model:
The set of pages a process has referenced in its most recent $\Delta$ time units.
- If $Sum(\text{Working Sets}) > \text{Total RAM}$, Thrashing will occur.

### 3. Inverted Page Table:
Standard Page Tables store one entry per page of virtual memory (huge!).
**Inverted Page Table** stores one entry per **frame of physical memory**.
- Index = Physical Frame.
- Entry = `(Process ID, Page Number)`.
- **PRO**: Saves massive memory on huge systems.
- **CON**: Search is harder (solved with a Hash Table wrapper).

---

## ✅ Ideal Answer
Thrashing is a performance collapse caused by the OS over-paging. We prevent it by monitoring the working set of each process and using page fault frequency to adjust resource allocation. On systems with huge address spaces (64-bit), inverted page tables are used to keep the overhead of memory accounting minimal.

---

## 🔄 Follow-up Questions
1. **What is a "Resident Set"?** (The actual physical pages currently in RAM for a process.)
2. **What is Demand Paging?** (Only loading pages into memory when they are actually accessed/faulted.)
3. **What is a Dirty bit?** (Bit in page table indicating if a page was modified; if so, it must be written to disk before being swapped out.)
