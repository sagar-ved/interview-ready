---
author: "sagar ved"
title: "OS: Context Switching Overhead"
date: 2024-04-04
draft: false
weight: 17
---

# 🧩 Question: What exactly happens during a Context Switch? How do you measure its overhead, and how can it be minimized?

## 🎯 What the interviewer is testing
- Deeper understanding of CPU and OS interaction.
- Impact on caches (L1/L2).
- Thread-heavy vs Process-heavy architectures.

---

## 🧠 Deep Explanation

### 1. The Sequence:
1. **Trap**: CPU is interrupted.
2. **Save State**: Save current registers, stack pointer, and Program Counter (PC) into the current process's **PCB (Process Control Block)**.
3. **Scheduler**: OS picks the next process.
4. **Load State**: Restore registers, stack, and PC from the new process's PCB.
5. **Resume**: CPU starts execution.

### 2. The Invisible Cost (Cache Invalidation):
The direct cost of saving/loading registers is tiny (~1-5 microseconds). The BIG cost is that the new process's data isn't in the **L1/L2 caches** or the **TLB**. The CPU must wait to fetch data from the slower RAM.

### 3. Measuring Overhead:
Use tools like `vmstat` or `perf` on Linux.
```bash
vmstat 1 # Look for 'cs' (context switches) column
```

---

## ✅ Ideal Answer
Context switching is the process of delegating CPU time between tasks. While the state-saving logic is fast, the primary performance penalty comes from the "warming up" of CPU caches for the new task. To minimize this, we can use non-blocking I/O (like Nginx) or user-space thread models (like Go's goroutines) that don't require full OS-level context switches.

---

## 🏗️ Thread vs Process:
- **Thread Context Switch**: Same address space; Page Table remains the same. Faster.
- **Process Context Switch**: Change address space; Page Table (and TLB) must be flushed. Slower.

---

## 🔄 Follow-up Questions
1. **What is a "Voluntary" vs "Involuntary" context switch?** (Voluntary: waiting on I/O. Involuntary: time slice expired.)
2. **How do Goroutines (Go) or Virtual Threads (Java 21) help?** (They move context switching to "user-space," avoiding expensive kernel entries.)
3. **What is the `sched_yield` syscall?** (A way for a process to voluntarily give up the CPU.)
