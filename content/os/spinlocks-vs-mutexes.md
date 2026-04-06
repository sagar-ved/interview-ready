---
author: "sagar ved"
title: "OS: Spinlocks vs. Mutexes"
date: 2024-04-04
draft: false
weight: 29
---

# 🧩 Question: Compare Spinlocks and Mutexes. When is "Spinning" better than "Sleeping"?

## 🎯 What the interviewer is testing
- CPU core utilization.
- Context switch overhead.
- Low-latency synchronization.

---

## 🧠 Deep Explanation

### 1. Mutex (The Sleeper):
- **Behavior**: If the lock is held, the thread is **suspended** (Context Switch).
- **Cost**: High. Saving registers, updating scheduler tables, and waking up later takes thousands of CPU cycles.
- **Best Use**: Long-duration locks (e.g., File I/O).

### 2. Spinlock (The Spinner):
- **Behavior**: If the lock is held, the thread sits in a **`while(true)` loop** (Spinning) repeatedly checking the lock.
- **Cost**: CPU usage stays at 100% on that core, but there is **zero context switch** overhead.
- **Best Use**: Extremely short locks (e.g., updating a counter in a few cycles).

### 3. The Rule of Thumb:
If the expected wait time is **shorter** than the time it takes to perform two context switches, a **Spinlock** wins. Otherwise, a **Mutex** is more efficient for the overall system.

---

## ✅ Ideal Answer
Spinlocks are a low-latency optimization for multi-core processors. While they waste CPU cycles in a tight loop, they avoid the "expensive" process of suspending and resuming a thread through the OS kernel. We use spinlocks for hyper-fast data updates where the lock is held for mere nanoseconds, and mutexes for traditional task synchronization where threads might need to wait for significant periods.

---

## 🏗️ Performance Table:
| Aspect | Spinlock | Mutex |
|---|---|---|
| Core Status | Busy (100% CPU) | Idle (Asleep) |
| Multi-core? | Mandatory | Optional |
| Context Switch | None | Possible |

---

## 🔄 Follow-up Questions
1. **Can a Spinlock be used on a single-core CPU?** (NO! If the thread spins, it never yields the CPU for the owner to release the lock. You'll deadlock instantly unless the system is preemptive.)
2. **What is a "Hybrid Lock" (Adaptive)?** (Modern OSes spin for a few cycles [optimism] and then switch to a Mutex if the lock hasn't been released [pessimism/cleanup].)
3. **Is `synchronized` a spinlock?** (In Java, it starts as biased/thin and can become a full OS-level monitor/mutex.)
