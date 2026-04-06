---
author: "sagar ved"
title: "OS: Context Switch Internals"
date: 2024-04-04
draft: false
weight: 31
---

# 🧩 Question: What exactly happens during a Context Switch? What data is saved, and why is it expensive?

## 🎯 What the interviewer is testing
- Low-level CPU states.
- Kernel overhead.
- Relationship between hardware (Registers) and software (PCB).

---

## 🧠 Deep Explanation

### 1. The Trigger:
A timer interrupt, a syscall (I/O), or a high-priority thread waking up.

### 2. The Data (What is saved/restored?):
- **The PC (Program Counter)**: Where we stopped.
- **General Purpose Registers**: Current local variables in-flight.
- **Stack Pointer**: Where our current local variables/calls are in RAM.
- **Address Space Map**: Page Table pointers (CR3 register in x86).

### 3. The Lifecycle:
1. **Enter Kernel**: Trap to OS.
2. **Save Current**: Write current CPU state into the **PCB (Process Control Block)** in RAM.
3. **Pick Next**: The scheduler decides who's next.
4. **Restore Next**: Load the new process's state from its PCB into CPU hardware.
5. **Flush TLB**: (If it's a different process) The translation cache must be cleared.

### 4. Why is it expensive?
- **Raw Work**: Thousands of clock cycles in the kernel.
- **Indirect Cost (The BIG one)**: The CPU **cache (L1/L2)** and **TLB** are now "cold." The fresh process hits a wall of cache misses, making it extremely slow for the first few thousand instructions.

---

## ✅ Ideal Answer
A context switch is the fundamental illusion of multitasking. While the CPU work is fast, the true cost lies in the "cold cache" effect—where a newly restored process must re-prime the L1 cache and TLB with its own data. Minimizing these switches through efficient thread pooling and I/O management is a primary goal for high-performance system engineering.

---

## 🔄 Follow-up Questions
1. **Thread vs Process switch?** (Process switch is more expensive because it must swap the virtual address space [Page Tables / TLB]. Thread switch shares memory.)
2. **What is a "Lightweight Process"?** (Another name for a thread in some kernels like Linux.)
3. **Switch without Kernel?** (User-level threads or Coroutines / Go-routines; these are faster but the OS can't manage them for I/O blocking.)
