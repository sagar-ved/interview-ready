---
author: "sagar ved"
title: "OS: CPU Affinity and Pinning"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: What is CPU Affinity (Processor Pinning)? Why and when should you use it, and what are its drawbacks?

## 🎯 What the interviewer is testing
- Deeper knowledge of OS scheduler behavior.
- Cache Locality and NUMA awareness.
- Real-world performance tuning for low-latency systems.

---

## 🧠 Deep Explanation

### 1. What is CPU Affinity?
By default, the OS scheduler moves processes between different CPU cores to balance load. CPU Affinity allows you to "pin" a process or thread to a specific set of cores.

### 2. Benefits:
- **Cache Locality**: Moving a process from Core A to Core B requires fetching data from RAM back into L1/L2 caches. Pinning keeps the cache "hot."
- **NUMA (Non-Uniform Memory Access)**: In multi-socket servers, accessing memory "near" a CPU is faster than memory "far" (attached to another CPU). Affinity ensures a process stays on the CPU local to its memory allocation.
- **Deterministic Latency**: Prevents jitter caused by the scheduler's migration overhead.

### 3. Drawbacks:
- **Imbalance**: If a pinned CPU is overwhelmed, it can't "share" the load with idle neighbors.
- **Under-utilization**: Other CPUs remain idle while the pinned one is a bottleneck.

---

## ✅ Ideal Answer
CPU Affinity is used in high-performance computing (HFT, Databases) to maximize cache efficiency and minimize latency jitter. By restricting a thread to a specific core, we eliminate the costly cache misses associated with context switches and process migrations. However, it should be used cautiously as it disables the OS's built-in load balancing.

---

## 💻 Technical Note: Java and Affinity
In standard Java, you can't easily pin threads, but libraries like **OpenHFT's JavaThreadAffinity** bridge this gap.

```bash
# Linux command to pin a process to core 0 and 1
taskset -c 0,1 java -jar myapp.jar
```

---

## ⚠️ Common Mistakes
- Pinning every single process (defeats load balancing).
- Not understanding the difference between a Physical Core and a Logical/Hyper-threaded core.
- Ignoring the impacts of interrupt handling on the pinned core.

---

## 🔄 Follow-up Questions
1. **What is Context Switching?** (The process of saving and restoring the state of a CPU so that multiple processes can share it.)
2. **What is SMP?** (Symmetric Multi-Processing.)
3. **How does the CFS scheduler work?** (Completely Fair Scheduler used in Linux.)
