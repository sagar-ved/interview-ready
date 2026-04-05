---
title: "Java: StampedLock vs. ReadWriteLock"
date: 2024-04-04
draft: false
weight: 47
---

# 🧩 Question: What is a `StampedLock` (Java 8)? How does its "Optimistic Read" prevent thread starvation?

## 🎯 What the interviewer is testing
- Advanced lock performance tuning.
- Understanding of "Writer Starvation" in ReadWriteLocks.
- Conditional state transitions in concurrent code.

---

## 🧠 Deep Explanation

### 1. The ReadWriteLock Problem:
Standard `ReentrantReadWriteLock` is **Pessimistic**. 
- Even a "Read" lock blocks a "Write" lock.
- If there are 100 constant readers, a writer might **starve** (wait forever).

### 2. The StampedLock Solution (Optimistic Read):
Threads can "Read" without taking a full lock.
1. Thread takes a **Stamp** (version number).
2. It reads the data **non-atomically** (fast).
3. It then calls `lock.validate(stamp)`. 
   - If a writer modified the data in the middle, `validate` returns false. 
   - The thread then "upgrades" to a heavy pessimistic lock and re-reads.

### 3. Result:
Writes aren't blocked by millions of reads. Most reads are "free" unless a rare conflict occurs.

---

## ✅ Ideal Answer
`StampedLock` is a high-performance alternative to traditional read-write locks that mitigates the risk of writer starvation. Through its "Optimistic Read" capability, it allows threads to attempt data access without triggering expensive locking machinery. By only falling back to heavy synchronization when a modification is detected, it provides a massive throughput boost for systems with high read-to-write ratios.

---

## 💻 Java Code
```java
private final StampedLock lock = new StampedLock();
private double x, y;

public double readDistance() {
    long stamp = lock.tryOptimisticRead(); // No lock taken!
    double curX = x, curY = y;
    
    if (!lock.validate(stamp)) { // Did someone write?
        stamp = lock.readLock(); // Block and take heavy lock
        try {
            curX = x; curY = y;
        } finally {
            lock.unlockRead(stamp);
        }
    }
    return Math.sqrt(curX*curX + curY*curY);
}
```

---

## 🔄 Follow-up Questions
1. **Is it Reentrant?** (NO! A thread trying to re-lock its own `StampedLock` will deadlock. This is a major difference from `ReentrantLock`.)
2. **What if the thread is interrupted?** (Warning: `lock()` in StampedLock can be problematic with interruptions; use `readLockInterruptibly()`.)
3. **When NOT to use?** (In complex recursive logic where reentrancy is required.)
