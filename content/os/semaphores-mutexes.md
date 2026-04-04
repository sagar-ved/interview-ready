---
title: "Semaphores, Mutexes, and Monitors"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: Explain the difference between a mutex, a semaphore, and a monitor. Implement a bounded buffer (producer-consumer) using each approach.

## 🎯 What the interviewer is testing
- OS synchronization primitives from first principles
- Understanding wait/signal (P/V) semantics
- How Java's `synchronized` + `wait/notify` maps to OS monitors
- Producer-consumer pattern: a classic OS interview problem

---

## 🧠 Deep Explanation

### 1. Mutex (Mutual Exclusion Lock)

- **Binary semaphore** — only two states: locked / unlocked
- Only the **owner** can unlock it (vs counting semaphore)
- Used for: protecting critical sections

### 2. Semaphore

- Has an integer counter (≥ 0)
- **P/Wait/Acquire**: Decrement counter; if 0, block
- **V/Signal/Release**: Increment counter; if threads waiting, wake one
- **Two types**:
  - **Binary Semaphore** (0–1): Like a mutex but NO ownership
  - **Counting Semaphore**: Control access to N resources (e.g., max 10 DB connections)

### 3. Monitor

- A high-level construct combining: **mutex** + one or more **condition variables**
- Only one thread executes inside the monitor at a time (mutex)
- Threads wait on condition variables inside the monitor (`wait()`)
- When a thread signals a condition (`notify()`), the waiting thread wakes up

Java's `synchronized` keyword implements a **monitor**. Every Java object has an implicit monitor.

### 4. Producer-Consumer Problem

N producers add to a buffer; M consumers remove from it. Buffer has max capacity K.
- **Constraint 1**: Don't add when buffer is full.
- **Constraint 2**: Don't remove when buffer is empty.
- **Constraint 3**: Only one thread can access buffer at a time (mutex).

---

## ✅ Ideal Answer

Use Java's `BlockingQueue` in production (it uses `ReentrantLock` + `Condition` internally). Understand the manual `wait/notify` or `Semaphore` approach for interviews.

---

## 💻 Java Code

```java
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.locks.*;

/**
 * Bounded Buffer implementations
 */
public class ProducerConsumerDemo {

    // ======= Approach 1: Using Semaphore (OS-level analog) =======
    static class SemaphoreBuffer<T> {
        private final Queue<T> queue = new LinkedList<>();
        private final Semaphore empty;    // Tracks empty slots
        private final Semaphore full;     // Tracks filled slots
        private final Semaphore mutex;    // Binary semaphore for mutual exclusion

        SemaphoreBuffer(int capacity) {
            this.empty = new Semaphore(capacity); // Start: all slots empty
            this.full  = new Semaphore(0);         // Start: no filled slots
            this.mutex = new Semaphore(1);         // Binary mutex
        }

        public void produce(T item) throws InterruptedException {
            empty.acquire(); // Wait for empty slot
            mutex.acquire(); // Enter critical section
            queue.offer(item);
            mutex.release(); // Leave critical section
            full.release();  // Signal: one more item available
        }

        public T consume() throws InterruptedException {
            full.acquire();  // Wait for filled slot
            mutex.acquire(); // Enter critical section
            T item = queue.poll();
            mutex.release(); // Leave critical section
            empty.release(); // Signal: one more slot now empty
            return item;
        }
    }

    // ======= Approach 2: Using synchronized + wait/notify (Monitor pattern) =======
    static class MonitorBuffer<T> {
        private final Queue<T> queue = new LinkedList<>();
        private final int capacity;

        MonitorBuffer(int capacity) { this.capacity = capacity; }

        public synchronized void produce(T item) throws InterruptedException {
            while (queue.size() == capacity) {
                wait(); // Release monitor lock and sleep
            }
            queue.offer(item);
            notifyAll(); // Wake all waiting consumers
        }

        public synchronized T consume() throws InterruptedException {
            while (queue.isEmpty()) {
                wait(); // Release monitor lock and sleep
            }
            T item = queue.poll();
            notifyAll(); // Wake all waiting producers
            return item;
        }
    }

    // ======= Approach 3: ReentrantLock + Condition (Java best practice) =======
    static class ConditionBuffer<T> {
        private final Queue<T> queue = new LinkedList<>();
        private final int capacity;
        private final ReentrantLock lock = new ReentrantLock();
        private final Condition notFull  = lock.newCondition();
        private final Condition notEmpty = lock.newCondition();

        ConditionBuffer(int capacity) { this.capacity = capacity; }

        public void produce(T item) throws InterruptedException {
            lock.lock();
            try {
                while (queue.size() == capacity) notFull.await();
                queue.offer(item);
                notEmpty.signal(); // Only signal one waiting consumer
            } finally {
                lock.unlock();
            }
        }

        public T consume() throws InterruptedException {
            lock.lock();
            try {
                while (queue.isEmpty()) notEmpty.await();
                T item = queue.poll();
                notFull.signal(); // Only signal one waiting producer
                return item;
            } finally {
                lock.unlock();
            }
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Using `if` instead of `while` for wait conditions (spurious wakeups can bypass the check — must re-check with `while`)
- Using `notify()` instead of `notifyAll()` in single-condition monitors (can wake the wrong waiting thread)
- Not releasing the lock in a `finally` block (deadlock if exception thrown in critical section)
- Confusing binary semaphore with mutex (binary semaphore has no ownership — danger of signaling from wrong thread)

---

## 🔄 Follow-up Questions
1. **What is a spurious wakeup?** (A thread wakes from `wait()` without a corresponding `notify()` — most OSes allow this; always use `while` loop, never `if` for wait conditions.)
2. **Difference between `notify()` and `notifyAll()`?** (`notify()` wakes ONE arbitrary waiting thread; `notifyAll()` wakes ALL — safer but more contention.)
3. **How does `java.util.concurrent.ArrayBlockingQueue` implement this internally?** (Uses `ReentrantLock` + two `Condition` variables: `notFull` and `notEmpty` — exactly Approach 3.)
