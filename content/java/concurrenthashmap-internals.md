---
title: "Deep Dive: ConcurrentHashMap Internals"
date: 2024-04-04
draft: false
---

# 🧩 Question: How does `ConcurrentHashMap` achieve high concurrency? Explain the transitions between Java 7 and Java 8.

## 🎯 What the interviewer is testing
*   **Concurrency Models**: Lock striping vs. CAS (Compare And Swap).
*   **Java Evolution**: Understanding how internal data structures evolve for performance.
*   **Thread Safety**: How to handle multi-threaded updates without `Synchronized` overhead.
*   **Volatile & Memory Visibility**: Knowledge of how reads are handled without locks.

---

## 🧠 Deep Explanation

### 1. The Core Problem with `HashMap` and `Hashtable`
-   **`HashMap`**: Not thread-safe. A `put()` while resizing can cause infinite loops or data loss.
-   **`Hashtable`**: Uses a single lock for the entire map. Highly inefficient for multi-threaded access.

### 2. Evolution: Java 7 vs Java 8
-   **Java 7 (Lock Striping)**:
    -   Used **Segments** (an array of reentrant locks).
    -   Default concurrency level was 16 (16 segments).
    -   A thread only locks the segment it is writing to, allowing 16 threads to write simultaneously.
    -   **Cons**: Segment creation overhead and fixed concurrency level.
-   **Java 8 (CAS & TreeBins)**:
    -   Removed segments. Uses a **Node array** with `volatile` fields.
    -   Uses **CAS (Compare And Swap)** for inserting the first node in a bucket.
    -   Uses **synchronized** only on the first node of a bucket (granularity is now at the bucket level).
    -   **TreeBins**: Like HashMap, it converts linked lists to Red-Black Trees (TreeNodes) when a bucket exceeds 8 elements (and map size > 64).

### 3. Internal Working: `put()` operation
1.  Calculate hash.
2.  Spread the hash to reduce collisions.
3.  Enter an infinite `for` loop to handle retries (CAS).
4.  If the bucket is empty, use `CAS` to insert the new node.
5.  If the bucket is not empty, check if the map is resizing (`MOVED` status).
6.  If not resizing, `synchronized` on the **head node** of the bucket and perform the insertion (linked list append or tree rotation).

### 4. Read Operations (Lock-Free)
-   `get()` is **non-blocking**.
-   It uses `volatile` fields (`val` and `next` in the `Node` class) to ensure memory visibility.
-   Since writes to the `next` pointer are atomic, a reader always sees a consistent state.

---

## ✅ Ideal Answer (Structured)

*   **Concurrency Granularity**: Mention that Java 8 moved from segment-level locking to bucket-level locking, significantly increasing concurrency.
*   **Mechanism**: Explain the use of **CAS** for empty buckets and **synchronized blocks** for populated buckets.
*   **Resizing**: Explain that `ConcurrentHashMap` uses a collective resizing mechanism where multiple threads can help move nodes to the new table.
*   **Read-Write Asymmetry**: Highlight that reads are lock-free due to `volatile` semantics, while only writes are synchronized at the bucket level.

---

## 💻 Java Code (Production Style)

```java
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

/**
 * Demonstrating atomicity in ConcurrentHashMap.
 * Simple put() is thread-safe, but "computeIfAbsent" or "merge"
 * is preferred for check-then-act logic.
 */
public class ConcurrencyDemo {
    private final Map<String, Integer> wordCounts = new ConcurrentHashMap<>();

    public void incrementCount(String word) {
        // WRONG: wordCounts.put(word, wordCounts.get(word) + 1); 
        // This is not atomic as get and put are separate operations.

        // RIGHT: Use atomic update methods
        wordCounts.merge(word, 1, Integer::sum);
    }

    public void explainCasUsage() {
        // Internally, if bucket is empty, CHM uses:
        // U.compareAndSwapObject(tab, ((long)i << ASHIFT) + ABASE, null, new Node<>(hash, key, value, null));
    }
}
```

---

## ⚠️ Common Mistakes
*   **Check-then-act**: Thinking individual operations being thread-safe makes the whole sequence thread-safe (e.g., `if (!map.containsKey(k)) map.put(k, v)` is NOT thread-safe).
*   **Null Keys/Values**: Forgetting that `ConcurrentHashMap` does **not** allow `null` keys or values (unlike `HashMap`).

---

## 🔄 Follow-up Questions
1.  **Why doesn't `ConcurrentHashMap` allow `null` keys or values?** (Answer: To avoid ambiguity in `get()` returning `null` vs. key not being present in a multi-threaded environment).
2.  **How does the `size()` method work?** (Answer: It uses `CounterCell` to avoid contention on a single counter, aggregating values only when `size()` is called).
3.  **What happens during a resize?** (Answer: Threads performing `put()` might assist in the transfer of nodes to the new table).
