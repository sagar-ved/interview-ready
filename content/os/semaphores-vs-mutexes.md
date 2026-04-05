---
title: "OS: Semaphores vs. Mutexes"
date: 2024-04-04
draft: false
weight: 30
---

# 🧩 Question: Compare a Binary Semaphore and a Mutex. Why is a Mutex considered "Owned" while a Semaphore is not?

## 🎯 What the interviewer is testing
- Synchronization primitive mechanics.
- Awareness of "Priority Inversion" problems.
- Resource counting logic.

---

## 🧠 Deep Explanation

### 1. Mutex (Mutual Exclusion):
- **Ownership**: The thread that **locks** the mutex is the ONLY thread that can **unlock** it.
- **Logic**: Used to protect a shared resource.
- **Optimization**: Modern mutexes support "Priority Inheritance" (if a high-priority thread is waiting for the mutex, it can boost the owner's priority to finish fast).

### 2. Semaphore:
- **Ownership**: Anyone can "signal" (V) or "wait" (P). There is no concept of owner.
- **Counting Semaphore**: Can allow `N` threads into a region (e.g., "Max 5 connections to DB").
- **Binary Semaphore**: A counter values 0/1.

### 3. The Core Difference:
A mutex is for **Mutual Exclusion** (locking). A semaphore is for **Signaling** (one thread telling another "the data is ready").

---

## ✅ Ideal Answer
The fundamental difference lies in ownership. A mutex is a "key" that must be returned by the person who took it, making it ideal for protecting state consistency. A semaphore is a "counter" or a "signal" that can be toggled by different threads to coordinate timing and resource pooling. For most general-purpose locking, mutexes are preferred due to their built-in protection against accidental cross-thread releases and priority management features.

---

## 🏗️ Visual Checklist:
- **Mutex**: `Lock(A) -> Work -> Unlock(A)`. Done by the SAME thread.
- **Semaphore**: `Thread 1: Wait(S) -> Work`. `Thread 2: Signal(S)`.

---

## 🔄 Follow-up Questions
1. **What is a "Recursive Lock"?** (A mutex that can be locked multiple times by the same thread without deadlocking; found in Java's `ReentrantLock`.)
2. **What is Priority Inversion?** (A low-priority thread holds a lock needed by a high-priority thread, effectively stalling the whole system.)
3. **Difference between `acquire()` and `wait()`?** (Terminology depends on language, but functionally similar to "Decrementing the counter.")
