---
title: "Java Streams and Functional Programming"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: You have a list of 10 million orders. Write a Stream-based pipeline to find the top 5 customers by total order value, grouped by region. Where are the performance bottlenecks?

## 🎯 What the interviewer is testing
- Stream API internals (lazy evaluation, short-circuit)
- Collectors API (`groupingBy`, `toMap`, `summarizingDouble`)
- Parallel streams and the common ForkJoinPool
- When NOT to use parallel streams

---

## 🧠 Deep Explanation

### 1. Stream Internals: Lazy Evaluation

Streams are **lazy** — intermediate operations (filter, map) don't execute until a terminal operation (collect, forEach) is invoked. The pipeline is built as a chain of `Spliterator`-based stages.

This allows **short-circuit evaluation**: `findFirst()` after a `filter()` stops processing as soon as one match is found.

### 2. Reducing vs. Collecting

- **`reduce()`**: Combines elements into a single value. Stateless and safe for parallel.
- **`collect()`**: Builds a mutable container (List, Map). Uses `Supplier + Accumulator + Combiner`.

### 3. Parallel Streams

`stream().parallel()` splits the data source and processes each part on **different ForkJoinPool threads**.

**When parallel is faster**: Large data (> 10,000 elements), CPU-bound operations, stateless operations.

**When parallel is slower or wrong**:
- Operations with shared state
- Small datasets (thread coordination overhead dominates)
- `findFirst()` on parallel streams forces ordering — use `findAny()` for speedup
- External I/O in the lambda (blocks FJP threads)

---

## ✅ Ideal Answer

- Use `groupingBy(region)` → `summingDouble(value)` collectors for the aggregation.
- Use `sorted().limit(5)` per group to get top 5.
- For 10 million records, consider **parallel streams** only if data is CPU-bound.
- Bottlenecks: autoboxing of primitives (use `mapToDouble`), `sorted()` on parallel streams requiring costly merging, and GC pressure from intermediate collections.

---

## 💻 Java Code

```java
import java.util.*;
import java.util.stream.*;

public class OrderAggregation {

    record Order(String customerId, String region, double value) {}

    public Map<String, List<Map.Entry<String, Double>>> topCustomersByRegion(
            List<Order> orders, int topN) {

        // Step 1: Group by region, then sum by customer within each region
        // collectingAndThen wraps the inner collector to apply a finishing transformer
        return orders.stream()
            .collect(Collectors.groupingBy(
                Order::region,
                Collectors.collectingAndThen(
                    Collectors.groupingBy(
                        Order::customerId,
                        Collectors.summingDouble(Order::value)  // No boxing: uses primitive stream internally
                    ),
                    customerMap -> customerMap.entrySet().stream()
                        .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
                        .limit(topN)
                        .collect(Collectors.toList())
                )
            ));
    }

    // For truly large data sets: Parallel stream variant
    public Map<String, Double> totalByRegionParallel(List<Order> orders) {
        // parallelStream() is safe here: stateless, independent aggregation
        return orders.parallelStream()
            .collect(Collectors.groupingByConcurrent(
                Order::region,
                Collectors.summingDouble(Order::value)
            ));
    }

    // Use primitive streams to avoid Double boxing overhead
    public double totalValueOptimized(List<Order> orders) {
        return orders.stream()
            .mapToDouble(Order::value)  // DoubleStream — no boxing
            .sum();
    }
}
```

---

## ⚠️ Common Mistakes
- Using `Collectors.toMap` with duplicate keys without providing a merge function → throws `IllegalStateException`
- Using parallel streams for I/O bound operations or small data sets
- Calling `.sorted()` before `.limit()` on a parallel stream (force merge → slow) — it's often better to use sequential for ordered operations
- Using `forEach` with side effects in parallel streams — non-deterministic ordering

---

## 🔄 Follow-up Questions
1. **How does `Spliterator` enable parallel streams?** (It recursively splits data into halves; each half is processed in a ForkJoinPool task.)
2. **Difference between `map` and `flatMap` in Streams?** (`flatMap` "flattens" a stream of streams into a single stream — useful for one-to-many transformations.)
3. **How do you use a custom `ForkJoinPool` for parallel streams?** (Submit via `pool.submit(() -> list.parallelStream()...).get()`.)
