---
author: "sagar ved"
title: "CPU Scheduling Algorithms"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: Explain the difference between FCFS, SJF, Round Robin, and Linux's CFS. Which does Linux use and why? How does it relate to Java thread priority?

## 🎯 What the interviewer is testing
- CPU scheduling concepts: preemption, starvation, fairness
- CFS (Completely Fair Scheduler) internals
- Java thread priority mapping to OS scheduling
- Context switching implications for application design

---

## 🧠 Deep Explanation

### 1. Scheduling Metrics

- **Throughput**: Jobs completed per second
- **Turnaround Time**: Completion − Arrival time
- **Waiting Time**: Time spent in ready queue
- **Response Time**: Time from arrival to first CPU time (critical for interactive tasks)

### 2. Classic Algorithms

| Algorithm | Preemptive | Starvation | Use Case |
|---|---|---|---|
| **FCFS** (First Come) | No | Possible (convoy effect) | Batch systems |
| **SJF** (Shortest Job First) | No | Yes (short jobs prioritized) | Optimal avg wait time |
| **SRTF** (Preemptive SJF) | Yes | Yes | Theoretically optimal |
| **Round Robin** | Yes | No | Interactive systems; fair |
| **Priority** | Yes | Yes (low priority starves) | OS services, RT systems |
| **MLFQ** (Multi-level Feedback) | Yes | Rare | macOS XNU, older Linux |

### 3. Linux CFS (Completely Fair Scheduler)

CFS models an "ideal" CPU that runs all tasks simultaneously at equal speed.

- Each task has a **virtual runtime (`vruntime`)** that increases as it uses CPU time.
- The scheduler always picks the task with the **lowest `vruntime`** (stored in a Red-Black Tree ordered by `vruntime`).
- **Find min: O(log n)** — RB-Tree leftmost node is cached → O(1).
- A newly woken task gets a `vruntime` boost (set to min_vruntime) to prevent starvation.
- `nice` values modify the rate at which `vruntime` advances: nice -20 (high priority) advances slower → gets more CPU.

### 4. Java Thread Priority and OS Mapping

Java thread priorities (1–10) map to OS `nice` values (Linux: -20 to +19).

```java
Thread.MIN_PRIORITY = 1  → nice +19 (lowest)
Thread.NORM_PRIORITY = 5 → nice 0
Thread.MAX_PRIORITY = 10 → nice -19 (highest)
```

**Caveat**: On Linux, `nice` priority is **advisory** — the OS may not honor it uniformly. Java thread priorities are often meaningless in practice for fine-grained control.

---

## ✅ Ideal Answer

- **Linux uses CFS**: Modeled as a multi-task processor sharing, using a red-black tree keyed by `vruntime`.
- Tasks with lowest `vruntime` run next — inherently fair and prevents starvation.
- **Java Thread Priority**: Maps to OS `nice` values, but JVM makes no strong guarantees about scheduling order.
- **Round Robin**: Used within a priority level in CFS; time slice = `sched_latency / n_tasks`.
- For latency-critical Java services: pin threads to CPUs (`taskset`), use real-time priority, or use `Thread.sleep(0)` as a yield hint.

---

## 💻 Java Code and OS Configuration

```java
/**
 * Thread priorities and their (limited) effects in Java
 */
public class SchedulingDemo {

    public static void main(String[] args) throws InterruptedException {
        // Priority hint — not guaranteed to be respected
        Thread highPriority = Thread.ofPlatform()
            .priority(Thread.MAX_PRIORITY)
            .name("high-priority-worker")
            .start(() -> {
                for (int i = 0; i < 5; i++) {
                    System.out.println("HIGH PRIORITY: " + i);
                    Thread.yield(); // Voluntary context switch hint
                }
            });

        Thread lowPriority = Thread.ofPlatform()
            .priority(Thread.MIN_PRIORITY)
            .name("low-priority-worker")
            .start(() -> {
                for (int i = 0; i < 5; i++) {
                    System.out.println("low priority: " + i);
                    Thread.yield();
                }
            });

        highPriority.join();
        lowPriority.join();
        // Output order not guaranteed despite priority difference on Linux CFS!
    }
}
```

```bash
# View per-process scheduling info
cat /proc/<PID>/sched

# Set CPU affinity (pin process to CPU cores 0-3)
taskset -c 0-3 java -jar app.jar

# Set real-time priority (requires root — for latency-critical apps)
chrt -f 99 java -jar app.jar

# View context switch rate
vmstat 1 | awk '{print $12, $13}'  # cs column = context switches/sec
```

---

## ⚠️ Common Mistakes
- Thinking Java thread priorities reliably control execution order (they don't on Linux)
- Using `Thread.sleep(0)` as a scheduling guarantee (it's only a hint)
- Not understanding that high context switching rate (>100K/sec) is a performance red flag
- Confusing preemption with cooperative scheduling

---

## 🔄 Follow-up Questions
1. **What is the difference between preemptive and cooperative scheduling?** (Preemptive: OS can interrupt any thread. Cooperative: Thread must voluntarily yield — Go `gopark()`, early Node.js.)
2. **What is "priority inversion" and how does Mars Pathfinder's bug relate?** (Low-priority task holds a lock needed by a high-priority task; medium-priority tasks preempt the low-one holding the lock — system hangs. Solution: priority inheritance.)
3. **What is the `O(1) scheduler` in older Linux kernels?** (Fixed-size hash array per priority; O(1) task selection. Replaced by CFS for better fairness.)
