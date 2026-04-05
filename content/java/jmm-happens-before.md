---
title: "Java: Java Memory Model (JMM) Happens-Before"
date: 2024-04-04
draft: false
weight: 40
---

# 🧩 Question: What is the "Happens-Before" relationship in the Java Memory Model? List the 5 most important rules.

## 🎯 What the interviewer is testing
- Deep concurrency foundations.
- Understanding of visibility vs atomicity.
- Knowing why variables aren't immediately visible across threads.

---

## 🧠 Deep Explanation

### 1. The Core Concept:
The JMM defines a set of rules that guarantee when a **write** in one thread is visible to a **read** in another. If Action A *happens-before* Action B, then the results of A are visible to B.

### 2. The 5 Crucial Rules:
1. **Program Order Rule**: Within a single thread, actions happen in the order they appear in the source code.
2. **Volatile Variable Rule**: A write to a `volatile` variable happens-before every subsequent read of that same variable across any thread.
3. **Monitor Lock Rule**: An `unlock` on a monitor (synchronized block) happens-before every subsequent `lock` on that same monitor.
4. **Thread Start Rule**: A call to `thread.start()` happens-before any action in the started thread.
5. **Transitivity**: If A happens-before B, and B happens-before C, then A happens-before C.

---

## ✅ Ideal Answer
The JMM ensures that concurrent code behaves predictably by defining the "happens-before" contract. This contract prevents the CPU and Compiler from reordering instructions in a way that would break visibility. Without these formal rules, things like `volatile` or `synchronized` would not provide any cross-thread data guarantees.

---

## 🏗️ Example:
```java
int a = 0;
volatile boolean flag = false;

// Thread A
a = 42;          // (1)
flag = true;      // (2) -> volatile write

// Thread B
if (flag) {       // (3) -> volatile read
   System.out.println(a); // (4) 
}
```
Rule: (1) happens-before (2); (2) happens-before (3); (3) happens-before (4).
Result: (1) happens-before (4). Thread B is GUARANTEED to see `a = 42`.

---

## 🔄 Follow-up Questions
1. **Does `final` have happens-before?** (Yes, initialization of a final field happens-before it is accessed by another thread.)
2. **What is a Memory Barrier?** (A CPU instruction that forces the flushing/refreshing of caches to satisfy JMM rules.)
3. **Can you break happens-before?** (Only with "unsafe" ops or by having non-synchronized concurrent access [Race Condition].)
