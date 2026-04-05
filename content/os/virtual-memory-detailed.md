---
title: "OS: Virtual Memory and Swapping"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: What is Virtual Memory? Explain the role of Swapping and how the OS manages Page Faults.

## 🎯 What the interviewer is testing
- Memory hierarchy and abstraction.
- Practical understanding of hardware-software interaction (MMU, TLB).
- Performance impacts of memory over-subscription.

---

## 🧠 Deep Explanation

### 1. Virtual Memory:
Virtual memory provides an illusion of a large, contiguous private address space for each process, decoupled from physical RAM.
- **Security**: Processes can't access each other's memory.
- **Abstraction**: Programmer doesn't care about physical fragmentation.

### 2. Swapping:
The OS can move inactive pages from RAM to a disk secondary storage (Swap Space) to free up RAM for active processes.

### 3. Page Fault Cycle:
1. Process accesses an address.
2. MMU (Hardware) checks the **Page Table**.
3. If page is not in RAM (Present Bit is 0), an **Interrupt (Page Fault)** is triggered.
4. OS trap handler finds the page in swap/file.
5. OS selects a "Victim Page" to swap out (using algorithms like LRU).
6. OS reads requested page into RAM, updates Page Table, and restarts the process.

---

## ✅ Ideal Answer
Virtual memory allows programs to use more memory than physically available. It maps virtual addresses to physical frames. When a page isn't in memory, a page fault occurs, prompting the OS to retrieve it from disk. Excessive swapping leads to "Thrashing," where the system spends more time moving pages than executing tasks.

---

## 💻 Java Note: Direct Buffers
In Java, `ByteBuffer.allocateDirect(1024)` allocates memory outside the JVM heap. This uses the OS's native memory management and can avoid JVM GC overhead, but is still governed by the OS's virtual memory subsystem.

---

## ⚠️ Common Mistakes
- Thinking Virtual Memory and Physical Memory are the same size.
- Confusing a Page (Virtual) with a Frame (Physical).
- Not understanding that SSD/HDD latency is huge compared to actual RAM.

---

## 🔄 Follow-up Questions
1. **What is the TLB?** (Translation Lookaside Buffer: a cache for the Page Table.)
2. **What is Thrashing?** (A state where CPU is under-utilized because it's constantly waiting for disk I/O due to swapping.)
3. **What is Segmented vs Paged memory?** (Paging uses fixed sizes; segmentation uses logical, variable sizes.)
