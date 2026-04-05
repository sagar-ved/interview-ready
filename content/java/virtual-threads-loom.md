---
title: "Java: Virtual Threads (Project Loom)"
date: 2024-04-04
draft: false
weight: 55
---

# 🧩 Question: What are Java 21 Virtual Threads? How do they solve the "Thread Per Request" scalability problem?

## 🎯 What the interviewer is testing
- Modern Java 21 concurrency model.
- OS Threads vs. Managed Threads.
- Handling blocking I/O without extra hardware.

---

## 🧠 Deep Explanation

### 1. The Old Problem (Platform Threads):
Standard `java.lang.Thread` is a wrapper around an **OS Thread**.
- **Limit**: OS threads are heavy (~1MB stack). You can't have 1,000,000 of them.
- **Waste**: If a thread performs a DB call, it sits idle for 50ms, wasting a precious OS thread.

### 2. The Solution (Virtual Threads):
Virtual threads are **lite** threads managed by the JVM, not the OS.
- **Scale**: You can have **MILLIONS** of them on one machine.
- **Carrier Threads**: A few OS threads (Carrier threads) "carry" the virtual threads. 
- **The Magic**: When a virtual thread performs a **blocking I/O** (like `socket.read()`), the JVM **unmounts** it from the OS thread and lets another virtual thread run. Once the I/O is done, it is remounted.

### 3. Usage:
You can use them like regular threads:
`Thread.ofVirtual().start(() -> { ... });`

---

## ✅ Ideal Answer
Virtual Threads are the most significant change to Java's concurrency in a decade. By decoupling logical execution from physical OS threads, they allow developers to write simple, synchronous "thread-per-request" code that scales to millions of concurrent operations. This eliminates the complexity of reactive programming and callbacks while saturating the CPU and network interfaces far more efficiently than traditional threading models.

---

## 🏗️ Comparison:
| Aspect | Platform Thread | Virtual Thread |
|---|---|---|
| Creation Cost | High (OS Syscall) | Low (JVM Object) |
| Memory | ~1MB | ~Hundreds of Bytes |
| Switching | Kernel Context Switch | JVM Task Switch |
| Max Count | Thousands | Millions |

---

## 🔄 Follow-up Questions
1. **Should I pool Virtual Threads?** (NO! Pooling is for expensive resources. Virtual threads are cheap. Just create a new one for every task.)
2. **What is "Pinning"?** (If a virtual thread calls native code or enters a `synchronized` block, it might become "pinned" to the OS thread and won't unmount on I/O. Use `ReentrantLock` instead of `synchronized` to avoid this.)
3. **Reactive vs Virtual?** (Virtual threads offer similar performance to Reactive [WebFlux] but with much simpler, readable code.)
