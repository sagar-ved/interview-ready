---
title: "Processes vs Threads in OS"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: A Java application spawns 1000 threads for parallel HTTP calls and runs out of memory. Explain the OS-level difference between processes and threads, and how virtual threads (Project Loom) solve this problem.

## 🎯 What the interviewer is testing
- OS concepts: process vs thread, user-space vs kernel-space threads
- Thread lifecycle and context switching cost
- Why OS threads are "heavy"
- Java's threading model evolution (Platform → Virtual threads)

---

## 🧠 Deep Explanation

### 1. Process vs Thread

**Process**:
- Independent program in execution
- Has its own: address space, heap, code segment, file descriptors, OS resources
- Creation is expensive (fork + exec)
- Communication via IPC: pipes, sockets, shared memory

**Thread**:
- Lightweight unit of execution WITHIN a process
- Shares: heap, code, file descriptors, static data
- Has its own: stack (typically 1MB–8MB per thread), registers, program counter
- Context switch is cheaper than process switch (no address space change)

### 2. Why 1000 Threads Causes OOM

Each Java platform thread = one OS thread.
- Each OS thread requires a **stack**: 512KB to 2MB by default.
- 1000 threads × 1MB = **1GB of stack space** just for thread stacks.
- Plus kernel data structures (kernel stack, task_struct per thread).
- `-Xss512k` can reduce stack size, but doesn't eliminate kernel thread overhead.

### 3. OS Context Switching

When the scheduler preempts a thread:
1. Save current CPU registers to Thread Control Block (TCB).
2. Restore next thread's registers from its TCB.
3. Switch memory mappings if different process (expensive TLB flush).

Context switching frequency × overhead = "context switch tax"

### 4. User-Space Threads (Green Threads / Virtual Threads)

- M green/virtual threads → N OS threads (M >> N)
- Scheduling done in **user space** by the runtime (JVM, Go runtime)
- Blocking a virtual thread does NOT block the OS thread — JVM parks and schedules another virtual thread on the same carrier thread
- Stack size: virtual thread stacks are **segmented/lazy** — start at ~1KB

### 5. Java Virtual Threads (Project Loom — Java 21)

```java
// Platform thread: 1:1 with OS thread
Thread.ofPlatform().start(() -> blockingCall());

// Virtual thread: M:N, scheduled by JVM
Thread.ofVirtual().start(() -> blockingCall());
```

---

## ✅ Ideal Answer

- Each OS thread consumes stack memory + kernel data structures. 1000 threads = ~1GB+ RAM.
- For I/O-bound tasks (HTTP calls), threads spend majority of time **waiting** — wasting OS resources.
- **Virtual Threads (Java 21)**: Multiplexed over a few carrier OS threads. Blocking I/O suspends the virtual thread, not the OS thread. Supports millions of concurrent virtual threads.
- **Alternative for Java 8/11**: Use async I/O (CompletableFuture, WebFlux) to avoid blocking OS threads.

---

## 💻 Java Code

```java
import java.util.concurrent.*;
import java.util.*;

public class ThreadModelDemo {

    // ❌ Problem: 1000 OS threads → ~1GB stack space
    public static void platformThreads() throws InterruptedException {
        List<Thread> threads = new ArrayList<>();
        for (int i = 0; i < 1000; i++) {
            Thread t = Thread.ofPlatform()
                .name("platform-worker-" + i)
                .start(() -> simulateHttpCall());
            threads.add(t);
        }
        for (Thread t : threads) t.join();
    }

    // ✅ Solution (Java 21): Virtual threads — 1000 tasks on handful of OS threads
    public static void virtualThreads() throws Exception {
        try (ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor()) {
            List<Future<?>> futures = new ArrayList<>();
            for (int i = 0; i < 100_000; i++) { // Yes, 100K virtual threads!
                futures.add(executor.submit(ThreadModelDemo::simulateHttpCall));
            }
            for (Future<?> f : futures) f.get();
        }
    }

    // ✅ Alternative (Java 8+): CompletableFuture with dedicated I/O pool
    public static void asyncApproach() {
        ExecutorService ioPool = Executors.newFixedThreadPool(50); // bounded OS threads
        List<CompletableFuture<Void>> futures = new ArrayList<>();
        for (int i = 0; i < 1000; i++) {
            futures.add(CompletableFuture.runAsync(
                ThreadModelDemo::simulateHttpCall, ioPool
            ));
        }
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();
        ioPool.shutdown();
    }

    private static void simulateHttpCall() {
        try { Thread.sleep(100); } // Simulates network I/O
        catch (InterruptedException e) { Thread.currentThread().interrupt(); }
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking threads are "free" — each costs memory and kernel scheduling overhead
- Using virtual threads for CPU-bound work (no benefit vs platform threads for pure computation)
- Pinning carrier threads with `synchronized` in virtual threads (synchronized blocks prevent unmounting — use `ReentrantLock` instead)
- Not understanding that `Executors.newVirtualThreadPerTaskExecutor()` creates one virtual thread per task (not one OS thread)

---

## 🔄 Follow-up Questions
1. **What is a "daemon thread" in Java?** (JVM exits when all non-daemon threads finish; daemon threads are background workers like GC.)
2. **Explain the Go goroutine model.** (Go's scheduler multiplexes goroutines (M:N) onto OS threads; very similar to Java virtual threads.)
3. **What is thread affinity and NUMA?** (Binding a thread to a specific CPU core to improve cache locality; important in HPC and low-latency trading systems.)
