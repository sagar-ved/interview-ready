---
author: "sagar ved"
title: "OS: Fork vs. Exec (Copy-on-Write)"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: What is the difference between `fork()` and `exec()`? Explain how Copy-on-Write (COW) makes forking efficient.

## 🎯 What the interviewer is testing
- Low-level process creation in Unix.
- Memory management efficiency.
- Understanding of child/parent process relationships.

---

## 🧠 Deep Explanation

### 1. fork():
- Creates a **brand new process** that is an exact duplicate of the parent.
- **Return value**: 0 in the child, PID of child in the parent.
- Both processes continue from the point of the `fork()` call.

### 2. Copy-on-Write (COW):
Naively copying a 4GB process during `fork()` is too slow.
- Instead, both parent and child initially share the **same physical memory pages**.
- These pages are marked as "Read-Only".
- Only when either process attempts to **write** to a page, a hardware interrupt occurs and the OS creates a separate copy of that page for the writer.
- This results in near-instant process creation.

### 3. exec():
- **Replaces** the current process image with a new program.
- It doesn't create a new process; it transforms the caller into the new program (new code, new heap, new stack).
- **Return value**: None on success (it never returns to the old code).

---

## ✅ Ideal Answer
`fork()` creates a clone of the current process, while `exec()` replaces the current process with a different binary. COW makes `fork()` extremely efficient because memory is shared until a modification is needed. In a typical shell command, a shell `forks` a child, which then immediately `execs` the target program.

---

## 💻 Visual / Conceptual Flow
```
1. Shell (PID 100) calls fork().
2. Child (PID 101) created (sharing memory via COW).
3. Child (PID 101) calls exec("ls").
4. PID 101's memory is replaced with the "LS" program.
```

---

## ⚠️ Common Mistakes
- Thinking `fork()` replaces the code.
- Thinking COW only applies to files (it's for RAM pages).
- Forgetting that open file descriptors are shared between parent and child.

---

## 🔄 Follow-up Questions
1. **What is a Zombie Process?** (A process that has finished but its parent hasn't yet "waited" to read its exit status.)
2. **What is `vfork()`?** (An older, less-safe optimization where the parent is blocked until the child execs or exits — sharing memory directly without COW.)
3. **How does standard output work across fork?** (They share the same underlying file offset, so if one writes, the other's pointer moves.)
