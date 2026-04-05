---
title: "Java: Arrays.parallelSort() Internals"
date: 2024-04-04
draft: false
weight: 52
---

# 🧩 Question: When should you use `Arrays.parallelSort()` instead of `Arrays.sort()`? Explain the internal ForkJoin threshold.

## 🎯 What the interviewer is testing
- Parallel processing scaling.
- Overhead of "Divide and Conquer."
- Multicore architecture awareness.

---

## 🧠 Deep Explanation

### 1. The Strategy:
`Arrays.parallelSort()` uses the **ForkJoinPool**. 
- It recursively splits the array into sub-arrays.
- When a sub-array is small enough, it uses the standard sequential `Arrays.sort()`.
- After sorting sub-arrays, it merges them in parallel.

### 2. The Threshold:
If the array size is `< 8192` (in modern JVMs), `parallelSort` defaults to the standard **sequential sort** anyway.
- **Why?** The overhead of spawning threads, managing task queues, and context switching for small arrays takes MORE time than just sorting the array on one core.

### 3. Result:
Use `parallelSort` for massive datasets (millions of elements) on multi-core machines. For small lists, it's a no-op or a net loss.

---

## ✅ Ideal Answer
`Arrays.parallelSort()` is a performance multiplier for big data sorting. By leveraging the JVM's common ForkJoinPool, it distributes the sorting workload across all available CPU cores. However, due to the inherent overhead of thread coordination, it is only truly beneficial for large datasets that cross the internal threshold of approximately 8,000 elements, where the gains from parallelism finally outweigh the costs of management.

---

## 🏢 Comparison Table:
| Array Size | Winner | Reason |
|---|---|---|
| < 8k | `Arrays.sort()` | No thread overhead. |
| > 1M | `parallelSort()` | Full core utilization. |

---

## 🔄 Follow-up Questions
1. **Does it preserve order (Stable)?** (Only if sorting objects [uses Parallel TimSort]; primitives use Parallel Quicksort which is not stable.)
2. **Can you control the number of threads?** (Yes, by setting `java.util.concurrent.ForkJoinPool.common.parallelism`.)
3. **What is its space complexity?** ($O(N)$ for the merging phase.)
