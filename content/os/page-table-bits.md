---
title: "OS: Virtual Memory - Dirty and Reference Bits"
date: 2024-04-04
draft: false
weight: 33
---

# 🧩 Question: What are "Dirty" and "Reference" bits in a Page Table Entry? How do they help the OS decide which page to evict?

## 🎯 What the interviewer is testing
- Memory maintenance overhead.
- Disk I/O reduction.
- Page Replacement algorithm (LRU approximation).

---

## 🧠 Deep Explanation

### 1. The Reference Bit (R):
- **Set**: By the hardware whenever the page is **Accessed** (Read or Write).
- **Reset**: Periodically by the OS (Clock algorithm).
- **Usage**: Tells the OS "This page is popular." Don't evict it!

### 2. The Dirty Bit (M - Modified):
- **Set**: By the hardware whenever the page is **Written** to.
- **Usage**: 
  - If `Dirty = 0`: Page is identical to the file on disk. We can just discard it. **Fast eviction**.
  - If `Dirty = 1`: Page has changed. We MUST write it back to disk before discarding. **Slow eviction**.

### 3. Eviction Priority:
The OS prefers evicting `R=0, D=0` (Not used, not changed), followed by `R=0, D=1` (Not used lately, but needs disk write).

---

## ✅ Ideal Answer
Dirty and Reference bits are the hardware signals that drive the OS's memory eviction policy. The reference bit acts as a popularity gauge, allowing the kernel to approximate an LRU policy without expensive record keeping. The dirty bit is a cost-saver—it tells the OS whether a page can be instantly discarded or if it requires a slow, blocking disk synchronization before its frame can be reused.

---

## 🏢 State Matrix:
| R | D | Class | Priority |
|---|---|---|---|
| 0 | 0 | Not referenced, Clean | 1 (Best to pick) |
| 1 | 0 | Referenced, Clean | 2 |
| 0 | 1 | Not referenced, Dirty | 3 |
| 1 | 1 | Referenced, Dirty | 4 (Worst to pick) |

---

## 🔄 Follow-up Questions
1. **What is "Thrashing"?** (If all pages have R=1, the OS struggles to find any good victim, potentially swapping continuously.)
2. **Does every CPU have these?** (Yes, these are standard bits in the x86 and ARM MMU structures.)
3. **What is the "Clock Algorithm"?** (Using the R-bit to simulate LRU by treating memory pages like a circular clock face.)
