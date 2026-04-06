---
author: "sagar ved"
title: "OS: Stepping through a Page Fault"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: What happens step-by-step when a Page Fault occurs?

## 🎯 What the interviewer is testing
- Hardware-Kernel context switching.
- Disk I/O interaction with memory.
- TLB and Page Table updates.

---

## 🧠 Deep Explanation

1. **Hardware Detection**: The CPU (MMU) checks a virtual address in the Page Table and finds the "Present" bit is 0.
2. **The Trap**: The CPU generates a hardware interrupt and traps to the Kernel.
3. **Save Context**: The OS saves current process state (registers, PC).
4. **Identify Fault**: OS checks internal tables (Disk map) to find which page was needed and where it is on disk.
5. **Disk I/O**: OS issues a read request to the disk. **The process is blocked.**
6. **I/O Completion**: Disk finishes. OS picks a physical frame to put the data (might involve evicting another page via LRU).
7. **Update Tables**: OS copies data to RAM, updates the Page Table (Present=1), and invalidates any stale TLB entries.
8. **Resume**: OS restores the process's context and **re-executes** the exact instruction that failed.

---

## ✅ Ideal Answer
A page fault is a precise bridge between virtual abstraction and physical reality. It involves a sophisticated dance between hardware-level traps and kernel-level I/O management. The most critical part is that the faulted instruction is re-run from scratch after the data has been silently swapped into RAM, making virtual memory appear seamless to the application.

---

## 🏗️ Visual Sequence:
`MMU Check -> Trap -> Save -> Disk Seek -> Write to RAM -> Update Table -> Restart Instruction`

---

## 🔄 Follow-up Questions
1. **What is "Minor" vs "Major" page fault?** (Minor: Page is in RAM but not in this process's table [e.g. shared lib]; Major: Requires Disk read.)
2. **What is an Invalid Page Fault?** (Accessing random memory that doesn't belong to you — results in a Segmentation Fault.)
3. **How does the OS choose which page to evict?** (Using Page Replacement Algorithms like Clock or LRU.)
