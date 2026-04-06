---
author: "sagar ved"
title: "Java Concurrency Basics"
date: 2024-04-04
draft: false
---

# Java Concurrency

## 📌 Question
What is the difference between `synchronized` and `ReentrantLock`? When should we use each?

## 🎯 What is being tested
- Understanding of intrinsic vs extrinsic locking.
- Knowledge of Java's lock features (unfair vs fair, tryLock, lockInterruptibly).
- Performance considerations in multi-threading.

## 🧠 Explanation
- **Synchronized**: Intrinsic locking, managed by the JVM. Simple to use, automatically released, not as flexible.
- **ReentrantLock**: Extrinsic locking from the `java.util.concurrent.locks` package. Explicit lock and unlock. Features like `tryLock`, fairness (guaranteeing FIFO), and better interruptibility.

## ✅ Ideal Answer
`Synchronized` is sufficient for simple use cases where you need a quick lock. Use `ReentrantLock` when you need fairness (avoid starvation), need to attempt a lock without blocking (`tryLock`), or need to support interrupts.

## 💻 Code Example (Java)
```java
import java.util.concurrent.locks.ReentrantLock;

public class LockExample {
    private final ReentrantLock lock = new ReentrantLock(true); // Fair lock

    public void doWork() {
        if (lock.tryLock()) {
            try {
                System.out.println("Processing...");
            } finally {
                lock.unlock();
            }
        } else {
            System.out.println("Couldn't get lock.");
        }
    }
}
```

## ⚠️ Common Mistakes
- Not unlocking `ReentrantLock` in a `finally` block (leads to deadlocks).
- Over-synchronizing, causing performance bottlenecks.

## 🔄 Follow-ups
- What is Starvation?
- How do `ReadWriteLock` and `StampedLock` improve performance?
