---
author: "sagar ved"
title: "OS: Page Table Entry (PTE) Bits"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: What bits are found in a Page Table Entry (PTE)? Explain the purpose of the Present, Dirty, and Referenced bits.

## 🎯 What the interviewer is testing
- Low-level memory management hardware details.
- How the OS tracks page state for paging/caching.
- Security and protection at the page level.

---

## 🧠 Deep Explanation

### 1. Frame Number:
The address of the actual physical block in RAM.

### 2. Control Bits:
- **Present (P)**: 1 if the page is in RAM; 0 if it's in swap (accessing a 0-bit page causes a **Page Fault**).
- **Read/Write (R/W)**: 0 signifies Read-Only (used for code or COW pages).
- **User/Supervisor (U/S)**: Prevents user processes from accessing kernel mapping pages.
- **Dirty (D)**: Set to 1 by the hardware when a page is written to. If the page is "Dirty," it must be written to disk before being cleared from RAM.
- **Accessed/Referenced (A)**: Set when a page is read or written. Used by page replacement algorithms (like LRU) to find "cold" pages.

---

## ✅ Ideal Answer
A Page Table Entry is a bit-structure in memory that instructions the CPU's MMU on how to translate an address. Its control bits allow the OS to perform critical tasks: the "Present" bit triggers swapping, the "Dirty" bit ensures data isn't lost on reclamation, and the "R/W" bit protects code from being overwritten.

---

## 🏗️ Visual Structure:
`[ Physical Frame ID | U/S | R/W | P | D | A | ... ]`

---

## 🔄 Follow-up Questions
1. **What is a "Page Fault"?** (An interrupt triggered when a CPU accesses a page with the Present bit set to 0.)
2. **How is the Dirty bit used in SSDs?** (Helps decide if a block needs to be wear-leveled or written back.)
3. **What is "NX" (No-Execute)?** (A bit that prevents the CPU from executing code from the data stack/heap — prevents many malware attacks.)
