---
title: "Java: LongAdder vs. AtomicLong"
date: 2024-04-04
draft: false
weight: 41
---

# 🧩 Question: Why is `LongAdder` faster than `AtomicLong` under high contention?

## 🎯 What the interviewer is testing
- Advanced concurrency optimizations.
- Understanding of "False Sharing" and "CAS Contention."
- Knowledge of Java 8 concurrent additions.

---

## 🧠 Deep Explanation

### 1. The AtomicLong Problem:
`AtomicLong` uses a single shared variable and CAS (`Compare-And-Swap`).
- Scaling Issue: If 100 threads try to increment at once, only 1 succeeds. The other 99 must loop and retry. This "spinning" consumes CPU and causes massive contention on the shared memory address.

### 2. The LongAdder Solution:
It uses an internal **Cell Array**. 
- Different threads are assigned different "cells" or "stripes" (buckets) in an array based on their thread hash.
- **Independence**: Threads update their own cell with NO contention. 
- **Summation**: When `.sum()` is called, the total is calculated by adding the base value and all cells.

### 3. The Trade-off:
- **LongAdder**: Higher write throughput; slightly more memory usage; `.sum()` is not an atomic snapshot (values can change during summation).
- **AtomicLong**: Useful only if you need very low write volume OR need the guarantee that `.get()` always returns the exact current state.

---

## ✅ Ideal Answer
`LongAdder` scales better because it distributes the write contention across multiple internal cells, effectively turning a single shared bottleneck into a parallelized set of variables. This "striped" approach significantly reduces CPU spinning in high-concurrency environments like counting global metrics or request tracing.

---

## 🔄 Follow-up Questions
1. **What is "False Sharing"?** (When independent variables reside on the same CPU cache line, causing unnecessary cache invalidations across cores. `LongAdder` uses `@Contended` to prevent this.)
2. **When would you use `DoubleAdder`?** (Same logic as LongAdder, but for floating-point values.)
3. **Difference between `.sum()` and `.sumThenReset()`?** (`sumThenReset` combines the read and the clear operation.)
