---
title: "Java: Volatile vs. Atomic"
date: 2024-04-04
draft: false
weight: 42
---

# 🧩 Question: Compare `volatile` and `AtomicInteger`. When is `volatile` not enough?

## 🎯 What the interviewer is testing
- Memory Visibility vs. Atomicity.
- Race conditions in "Compound Operations" (read-modify-write).
- Understanding of low-level CPU atomics.

---

## 🧠 Deep Explanation

### 1. volatile:
- **Guarantee**: **Visibility** and **Ordering**. A thread always sees the latest value from main memory.
- **Fail Case**: Compound operations like `count++`.
  - `current = count` (Thread 1)
  - `current = count` (Thread 2)
  - `count = current + 1` (Both threads write the SAME value back).
- Result: One increment is lost.

### 2. AtomicInteger:
- **Guarantee**: **Visibility** AND **Atomicity**.
- **The Magic (CAS)**: It uses a CPU instruction called `Compare-And-Swap`. It only updates the value if the current value is what the thread expected. If not, it loops and tries again.

---

## ✅ Ideal Answer
`volatile` ensures that a thread's local cache is always in sync with main memory, but it doesn't protect against race conditions during complex updates. `AtomicInteger` provides true thread-safety for operations like increments and decrements by leveraging hardware-level atomic instructions. Use `volatile` for status flags and `Atomic` for counters.

---

## 🏗️ Conceptual Checklist:
| Operation | Volatile | Atomic | synchronized |
|---|---|---|---|
| Read/Write (int) | Safe (Visibility) | Safe | Safe |
| Increment (`i++`) | **UNSAFE** | Safe | Safe |
| Check-then-act | **UNSAFE**| Safe (using `compareAndSet`) | Safe |
| Performance | Fast | Moderate | Slow |

---

## 🔄 Follow-up Questions
1. **What is a "Spin Lock" in the context of Atomic?** (If the CAS fails, the thread "spins" in a while-loop until successful.)
2. **Is `volatile boolean` enough for a stop flag?** (Yes, because it's a simple write/read.)
3. **What is the ABA problem?** (In CAS, if a value goes from A -> B -> A, the thread checks for A and thinks nothing changed. Avoided in Java using `AtomicStampedReference`.)
