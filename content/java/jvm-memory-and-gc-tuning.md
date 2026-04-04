---
title: "Deep Dive: JVM Memory and GC Tuning"
date: 2024-04-04
draft: false
---

# 🧩 Question: Explain the internals of G1GC (Garbage First Garbage Collector) and how to tune it for low-latency applications.

## 🎯 What the interviewer is testing
*   **Memory Models**: Young Gen, Old Gen, Metaspace.
*   **Garbage Collection Algorithms**: Mark-and-Sweep, Copying, Concurrent Marking.
*   **Tuning and Profiling**: Knowledge of flags (`-Xmx`, `-XX:MaxGCPauseMillis`).
*   **Real-world Scalability**: How JVM handles large heaps (32GB+).

---

## 🧠 Deep Explanation

### 1. JVM Memory Layout (Post-Java 8)
-   **Heap Memory**:
    -   **Young Generation**: Eden, Survivor Spaces (S0, S1).
    -   **Old Generation (Tenured)**: Long-lived objects.
-   **Non-Heap Memory**:
    -   **Metaspace**: Replaced PermGen. Stores class metadata. Grows dynamically.
    -   **Code Cache**: JIT compiled code.
    -   **Direct Memory**: NIO buffers outside JVM control.

### 2. G1GC (Garbage First) Internals
-   G1 breaks the heap into **Regions** (usually 1MB to 32MB).
-   Regions are still logically Young or Old, but they don't have to be contiguous.
-   **Humongous Regions**: For objects exceeding 50% of region size.
-   **Garbage-First**: It targets regions with the most reclaimable space (garbage) to maximize throughput while respecting pause times.

### 3. G1GC Phases
1.  **Stop-the-World (STW) Young GC**: Evacuates Young Gen to Survivor/Old Gen regions.
2.  **Concurrent Marking Cycle**: Happens alongside application threads to find live objects in Old Gen.
3.  **Mixed GC Phase**: Reclaims space from both Young and Old Gen regions.

### 4. Tuning for Low Latency
-   **-XX:MaxGCPauseMillis**: Set the target pause time (default is 200ms).
-   **-Xms and -Xmx**: Set initial and max heap size to the same value to avoid resizing pauses.
-   **-XX:InitiatingHeapOccupancyPercent (IHOP)**: Threshold to start a marking cycle (default 45%).
-   **-XX:+ParallelRefProcEnabled**: Parallelize reference processing (Soft/Weak/Phantom refs).

---

## ✅ Ideal Answer (Structured)

*   **Regional Heap**: Explain that G1 divides the heap into regions, unlike contiguous CMS or Parallel collectors.
*   **Pause Time Compliance**: Emphasize that G1 is designed to be a "soft-real-time" collector focusing on high-probability pause time targets.
*   **Generational Phases**: Distinguish between Young GC (STW) and Concurrent Old Gen marking.
*   **Memory Leaks vs GC Overhead**: Briefly mention how to distinguish between a "natural" full GC (heap fragmentation) and a memory leak (objects anchored in a static map).

---

## 💻 Java Code (GC Tuning Example)

```bash
# Production Startup Flags for a 16GB Low-Latency App
java -Xmx16g -Xms16g \
     -XX:+UseG1GC \
     -XX:MaxGCPauseMillis=100 \
     -XX:ParallelGCThreads=8 \
     -XX:ConcGCThreads=2 \
     -XX:InitiatingHeapOccupancyPercent=35 \
     -XX:+PrintGCDetails -Xloggc:gc.log \
     -jar my-heavy-application.jar
```

```java
import java.util.ArrayList;
import java.util.List;

/**
 * Example of a "Soft Memory Leak" that GC cannot reclaim.
 */
public class MemoryLeakDemo {
    // Problem: Static list keeps growing, anchoring objects to GC Root.
    private static final List<Object> CACHE = new ArrayList<>();

    public void processData(Object data) {
        CACHE.add(data); // Objects here will survive Young GC and move to Old Gen.
        
        // Proper way: Use WeakHashMap or a proper LRU cache with eviction.
    }
}
```

---

## ⚠️ Common Mistakes
*   **Implicit G1 Flags**: Over-tuning Young Gen size (`-Xmn`). Setting Young Gen size manually often breaks G1's ability to meet pause time goals.
*   **Metaspace Failure**: Forgetting that `Metaspace` can still throw `OutOfMemoryError` if classes (lambdas, proxies) are continuously generated and not unloaded.

---

## 🔄 Follow-up Questions
1.  **What is a "Full GC" in G1?** (Answer: A fallback STW event when concurrent marking/mixed GC cannot reclaim enough space fast enough).
2.  **Difference between G1GC and ZGC?** (Answer: ZGC is a sub-millisecond pause collector that performs almost all phases concurrently, including evacuation).
3.  **What is "False Sharing" and how does JVM fix it?** (Answer: `@Contended` annotation to avoid multiple threads accessing different fields on the same cache line).
