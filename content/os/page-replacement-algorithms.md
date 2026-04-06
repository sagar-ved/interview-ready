---
author: "sagar ved"
title: "OS: Page Replacement - LRU vs. Clock"
date: 2024-04-04
draft: false
weight: 22
---

# 🧩 Question: What is LRU Page Replacement? Explain why the "Clock Algorithm" is used in modern OSes to approximate LRU.

## 🎯 What the interviewer is testing
- Memory management efficiency.
- Hardware-software coordination.
- Approximating complex algorithms with simpler data structures.

---

## 🧠 Deep Explanation

### 1. The Ideal: LRU (Least Recently Used):
- **Concept**: Discard the page that hasn't been used for the longest time.
- **Hardware cost**: Maintaining a truly sorted list of every page access in a busy CPU is **too slow**. Every instruction would need to update a linked list.

### 2. The Solution: Clock Algorithm (Second Chance):
- **Concept**: Uses a **single "Accessed/Referenced" bit** in the Page Table.
- **Logic**: 
  - Arrange pages in a circular list. A "hand" points to the current page.
  - If a page is faulted:
    - If the bit = 1: Set it to 0 and move the hand to the next (Giving it a **Second Chance**).
    - If the bit = 0: **Replace this page**.
  - This effectively lets frequently used pages stay in memory while sweeping out "cold" pages.

---

## ✅ Ideal Answer
Pure LRU is too expensive for high-speed memory management. Modern OSes use the Clock algorithm, which approximates LRU by using a simple hardware "reference bit." This allows the kernel to identify inactive pages with minimal overhead, ensuring that active processes keep their most critical data in RAM while inactive ones are gradually swapped out.

---

## 🏗️ Visual State:
- `Page A (1) -> Page B (0) -> Page C (1)`
- Hand on B? B is evicted.
- Hand on A? A set to (0), hand moves to B.

---

## 🔄 Follow-up Questions
1. **What is Belady's Anomaly?** (In some algorithms like FIFO, adding more RAM can actually result in MORE page faults. LRU does not suffer from this.)
2. **LRU vs LFU (Least Frequently Used)?** (LFU tracks count; poor for temporal locality.)
3. **What is a "Dirty" bit influence?** (Modern clock algorithms prioritize evicting bit=0 [clean] pages over bit=1 [dirty] pages, because clean pages don't need to be written to disk.)
