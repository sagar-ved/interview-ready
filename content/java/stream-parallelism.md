---
title: "Java: Java 8 Stream vs. ParallelStream"
date: 2024-04-04
draft: false
weight: 38
---

# 🧩 Question: When should you use `parallelStream()` in Java? Explain the overheads and when a standard stream is faster.

## 🎯 What the interviewer is testing
- Awareness of ForkJoinPool usage.
- Performance profiling mindset.
- Understanding of stateful vs stateless operations.

---

## 🧠 Deep Explanation

### 1. How parallelStream works:
It uses the common `ForkJoinPool` to split the task into multiple threads. It follows a "split-iterate-merge" pattern.

### 2. When to use Parallel:
- Large datasets.
- Computation-heavy operations per element (e.g., complex math).
- The task is easily "splittable" (e.g., ArrayList, array vs LinkedList).

### 3. The Pitfalls:
- **Overhead**: Splitting and merging results takes time. For small collections, this overhead is larger than the computation itself.
- **Stateful Operations**: Operations like `limit()`, `sorted()`, `distinct()` are hard to parallelize and can be slower in parallel.
- **Shared Pool**: Using `parallelStream` for blocking I/O can block other unrelated parallel streams in the JVM because they share the one `commonPool`.
- **Thread-Safety**: Operations inside the stream MUST be thread-safe.

---

## ✅ Ideal Answer
Parallel streams are not a magic performance booster. They are best for CPU-bound computations on large, splittable data structures. For small datasets or I/O-bound tasks, the overhead of context switching and task management often makes them slower than synchronous streams. Always benchmark your specific use case.

---

## 🏗️ The "NQ model":
Performance depends on $N \times Q$ where:
- $N$ = number of elements.
- $Q$ = cost of operation on one element.
If $N \times Q$ is small, stick with standard Streams.

---

## 🔄 Follow-up Questions
1. **Can you specify a custom pool for parallelStream?** (Not easily; you can execute a stream inside a `pool.submit` block, but it's a bit of a hack.)
2. **ArrayList vs LinkedList in parallelStream?** (ArrayList is much better because it's indexed and easy to split into equal chunks.)
3. **What is a Spliterator?** (The interface used by streams to partition data for parallel processing.)
