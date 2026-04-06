---
author: "sagar ved"
title: "OS: Amdahl's Law (Parallel Limits)"
date: 2024-04-04
draft: false
weight: 32
---

# 🧩 Question: What is Amdahl's Law? Why can't we speed up a program infinitely by adding more CPU cores?

## 🎯 What the interviewer is testing
- Theoretical limits of parallelization.
- Understanding the "Sequential Bottleneck."
- Pragmatic software scaling expectations.

---

## 🧠 Deep Explanation

### 1. The Formula:
$Speedup = \frac{1}{(1 - P) + \frac{P}{S}}$
- $P$: Parallelizable fraction of the task.
- $S$: Speedup of the parallel part (number of cores).

### 2. The Meaning:
Even if you have 1000 cores, if **10% of your code is sequential** (must run on one core), your MAXIMUM speedup is **10x**.
- The "Sequential part" (loading data, merging results, locking shared state) eventually dominates the total time.

### 3. Real-world constraints:
Adding more cores also adds **Communication Overhead**. 
- Coordination between 100 threads can eventually take MORE time than the actual computation. This leads to **Negative returns**.

---

## ✅ Ideal Answer
Amdahl's Law defines the hard mathematical limit of parallel performance. It teaches us that the sequential bottlenecks in our code—such as disk I/O, initial parsing, or final data aggregation—will always dictate the maximum possible speedup, regardless of hardware scale. Therefore, engineering efforts are often better spent reducing the sequential fraction of a task than simply increasing the processor count.

---

## 🏗️ Visual Summary:
- If 50% is sequential -> Max 2x speedup.
- If 5% is sequential -> Max 20x speedup.

---

## 🔄 Follow-up Questions
1. **Difference between Amdahl and Gustafson?** (Gustafson's law argues that as we get more cores, we solve *larger* problems, not just the same problem faster.)
2. **Identify sequential parts?** (Thread spawning, result merging, mutex locking, I/O writes.)
3. **Diminishing Returns?** (The point where the cost of coordinating cores exceeds the gain from their computation.)
