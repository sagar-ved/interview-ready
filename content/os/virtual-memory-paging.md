---
author: "sagar ved"
title: "Memory Management: Paging, Virtual Memory, and Page Faults"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Explain how virtual memory works. What happens when a Java process accesses memory that maps to a page that has been swapped to disk? How does the OS handle it, and what are the performance implications?

## 🎯 What the interviewer is testing
- Virtual memory, page tables, TLB
- Page fault handling and demand paging
- Swap space and its performance impact
- Heap memory allocation in the OS (mmap, brk)

---

## 🧠 Deep Explanation

### 1. Virtual Memory

Every process operates on **virtual addresses** — the OS and MMU (Memory Management Unit) map them to **physical addresses** via the **page table**.

Benefits:
- **Isolation**: Process A can't access Process B's physical memory
- **Illusion of infinite memory**: Use swap space on disk as extension
- **Memory-mapped files**: Files appear as memory regions

### 2. Pages and Frames

- Memory is divided into fixed-size units: **pages** (virtual) and **frames** (physical)
- Typical page size: **4KB** (Linux x86-64). Large pages: **2MB or 1GB** (HugeTLB)
- **Page Table**: Per-process mapping from virtual page number → physical frame number + flags (valid, dirty, writable)

### 3. TLB (Translation Lookaside Buffer)

- A CPU-side **cache** for recent page table entries
- If TLB hit: virtual → physical translation in 1 CPU cycle
- If TLB miss: walk page table (multi-level on x86) → 100+ cycles
- Context switch: TLB is **flushed** (or tagged with ASID to avoid full flush)

### 4. Page Fault Handling

When a process accesses a virtual address with no valid page table entry:
1. MMU raises a **Page Fault Exception** (interrupt)
2. OS kernel fault handler invoked
3. Handler checks: is this a valid address? If not → SIGSEGV (segfault)
4. If valid: fetch page from disk/swap → update page table → resume execution
5. Process never knows the fault happened (transparent to userspace)

**Performance impact**: A page fault requiring disk I/O takes **10–15ms** (vs 100ns for RAM). JVM heap access triggering page faults = catastrophic latency spikes.

### 5. Java Heap and OS Memory

When JVM allocates heap (`-Xmx4g`):
- OS doesn't immediately allocate physical memory (demand paging)
- Physical memory is allocated lazily on first access
- `mmap()` + anonymous mapping for heap; `malloc()` uses `brk()` for smaller allocations
- Pinning the JVM heap to physical memory (`-XX:+AlwaysPreTouch`): touches every page at startup to fault in all pages — eliminates page faults during operation

---

## ✅ Ideal Answer

- **Virtual memory** provides each process an isolated address space, backed by physical RAM + swap.
- When JVM accesses an unmapped page, the OS **page fault handler** loads it from swap/disk.
- A **minor page fault** (page in RAM but not mapped) = microseconds; a **major page fault** (page on disk) = milliseconds.
- For latency-sensitive apps: use `-XX:+AlwaysPreTouch` + `vm.swappiness=0` (disable swap for JVM process).
- **HugeTLB pages**: Reduce TLB misses for large heap JVMs.

---

## 💻 OS Commands and JVM Flags

```bash
# Check page fault rate — major faults are expensive
cat /proc/<PID>/status | grep VmRSS   # Resident physical memory
vmstat 1 5                             # pg columns: page-ins/page-outs

# JVM Flags for memory management
java -Xmx8g -Xms8g \
     -XX:+UseHugeTLBFS \   # Use large pages (reduces TLB miss rate)
     -XX:+AlwaysPreTouch \ # Pre-fault all pages at startup
     -XX:+DisableExplicitGC \  # Prevent System.gc() abuse
     -jar app.jar

# Disable swap for a process (aggressive — reduces latency spikes)
# In /etc/sysctl.conf:
# vm.swappiness = 0

# Lock process memory to RAM (mlockall) — prevent kernel from swapping
# Used in financial/HFT systems
```

```java
import java.io.*;

public class MemoryDemo {
    public static void main(String[] args) {
        // The JVM allocates heap lazily — pages are not in RAM until touched
        byte[] largeArray = new byte[100 * 1024 * 1024]; // 100MB allocated virtually
        
        // At this point: virtual memory allocated, but physical frames may NOT be assigned
        // First access triggers page faults:
        for (int i = 0; i < largeArray.length; i += 4096) { // Touch every page
            largeArray[i] = 1; // Page fault → OS assigns a physical frame
        }
        // Now all 100MB is in physical RAM — no more page faults for this array
        System.out.println("All pages faulted in.");
    }
}
```

---

## ⚠️ Common Mistakes
- Setting `-Xmx` larger than available RAM — forces pages to swap → latency spikes
- Not understanding that OOM Killer can kill a process before JVM throws OutOfMemoryError
- Thinking `new byte[1GB]` immediately allocates 1GB of physical RAM (it doesn't — lazy allocation)
- Confusing Java heap `OutOfMemoryError` with OS-level OOM (different!)

---

## 🔄 Follow-up Questions
1. **What is "thrashing" in virtual memory?** (OS spends more time swapping pages in/out than executing processes — system grinds to halt.)
2. **What are HugePages and when should you use them?** (2MB pages instead of 4KB — reduces TLB misses; critical for JVMs with >8GB heap.)
3. **What is copy-on-write (COW) and how does `fork()` use it?** (Child process initially shares parent's pages; physical copy made only when either modifies a page — enables fast fork.)
