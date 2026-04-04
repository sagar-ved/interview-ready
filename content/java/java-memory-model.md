---
title: "Java Memory Model and Happens-Before"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: A flag variable `isRunning = true` is set by Thread A, but Thread B never sees the update and loops forever. What is happening and how do you fix it?

## 🎯 What the interviewer is testing
- Java Memory Model (JMM) and CPU cache visibility
- The `volatile` keyword semantics
- Happens-before relationship
- CPU cache coherence and reordering

---

## 🧠 Deep Explanation

### 1. CPU Caches and the Root Problem

Modern CPUs have **multiple levels of cache (L1, L2, L3)** per core. When Thread A on Core 1 writes `isRunning = false`, this write may only be in Core 1's L1 cache for a while. Thread B on Core 2 might read its **stale cached copy** of `isRunning = true` indefinitely.

Without synchronization constraints, the JVM is free to:
1. **Cache** reads in a register or CPU cache.
2. **Reorder** instructions for performance optimization.

### 2. Java Memory Model (JMM)

The JMM defines rules for **when** a write by Thread A is **guaranteed to be visible** to Thread B through the **Happens-Before (HB)** relationship.

**Happens-Before guarantees exist for**:
- `synchronized` block exit → `synchronized` block entry on the **same lock**
- `volatile` write → `volatile` read of the **same variable**
- `Thread.start()` → any action in the started thread
- Any action in thread → `Thread.join()` in another thread
- Constructor completion → finalizer start

### 3. `volatile` — What It Actually Does

Marking `isRunning` as `volatile`:
1. **Visibility**: Writes are immediately flushed to main memory. Reads always fetch from main memory.
2. **Prevents Reordering**: The compiler and CPU cannot reorder instructions around a `volatile` access.
3. **Does NOT guarantee atomicity**: `i++` on a `volatile int` is still NOT atomic (it's `read + increment + write`).

### 4. When `synchronized` Is Needed Instead

`volatile` works for a **single write from one thread, read by many**. For **compound operations** (check-then-act, read-modify-write), you need `synchronized` or `AtomicInteger`.

---

## ✅ Ideal Answer (Structured)

- The root cause is **CPU caching** and **instruction reordering** allowed by the JMM in the absence of synchronization constraints.
- Fix: Declare `isRunning` as `volatile boolean isRunning`. This creates a happens-before relationship between the write on Thread A and the read on Thread B.
- For compound operations (e.g., `counter++`), use `AtomicInteger` or a `synchronized` block.
- `volatile` should be used for **simple flags**, not for guarding complex state.

---

## 💻 Java Code

```java
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Correct patterns for multi-thread visibility
 */
public class VisibilityDemo {

    // ❌ WRONG: No memory visibility guarantee
    private boolean isRunningBad = true;

    // ✅ Option 1: volatile for simple boolean flags
    private volatile boolean isRunning = true;

    // ✅ Option 2: AtomicBoolean for check-and-set (CAS) patterns
    private final AtomicBoolean isRunningAtomic = new AtomicBoolean(true);

    public void runWorker() {
        Thread worker = new Thread(() -> {
            while (isRunning) { // Thread B reads from main memory every iteration
                doWork();
            }
            System.out.println("Worker stopped cleanly.");
        });
        worker.start();
    }

    public void stop() {
        isRunning = false; // Thread A write: immediately flushed to main memory
    }

    // Example of why volatile is NOT enough for compound operations
    private volatile int counter = 0;

    public void unsafeIncrement() {
        counter++; // ❌ NOT atomic: read→modify→write
    }

    // Use AtomicInteger for thread-safe increment
    private final java.util.concurrent.atomic.AtomicInteger atomicCounter =
        new java.util.concurrent.atomic.AtomicInteger(0);

    public void safeIncrement() {
        atomicCounter.incrementAndGet(); // ✅ Atomic CAS operation
    }

    private void doWork() {
        // Simulate work
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking `volatile` makes **all operations** on a variable atomic
- Using `volatile` for collections — the reference is volatile but the contents are NOT
- Confusing `AtomicInteger` with `volatile int` — both give visibility, but only Atomic gives atomic compound operations
- Not knowing that `synchronized` does double duty: visibility **and** exclusion

---

## 🔄 Follow-up Questions
1. **What is a "memory barrier" and how does `volatile` use it?** (A barrier instruction flushes CPU write buffers and prevents instruction reordering.)
2. **Explain the Double-Checked Locking (DCL) pattern for Singleton.** (Without `volatile` on the instance field, the partially constructed object might be visible due to reordering.)
3. **What is the difference between `happens-before` and "program order"?** (Program order is within a single thread; happens-before is a cross-thread guarantee that enforces visibility.)
