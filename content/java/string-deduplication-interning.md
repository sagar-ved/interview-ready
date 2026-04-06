---
author: "sagar ved"
title: "Java: String Deduplication vs. Interning"
date: 2024-04-04
draft: false
weight: 40
---

# 🧩 Question: What is the difference between `String.intern()` and G1 GC's "String Deduplication"?

## 🎯 What the interviewer is testing
- Memory footprint optimization.
- Understanding of the String Pool.
- GC-level transparent optimizations.

---

## 🧠 Deep Explanation

### 1. String Interning (`intern()`):
- **Manual**: You call it.
- **Result**: Puts the string in a special **Global String Pool**. If identical string exists, returns that reference.
- **Risk**: The pool is a fixed-size hash table in PermGen/Metaspace. Over-interning can lead to performance degradation or OutOfMemory.

### 2. G1 GC String Deduplication:
- **Auto**: The Garbage Collector does it in the background.
- **Process**: GC looks for two different String OBJECTS that have the same character array (`char[]` or `byte[]`). It points both String objects to the **same sharing character array** and discards the duplicate array.
- **Benefit**: No extra code needed. Saves ~10-25% memory in Java heap-heavy apps.

---

## ✅ Ideal Answer
While `intern()` allows a developer to manually coordinate a shared pool of string references, G1's String Deduplication is a transparent optimization that eliminates the redundant weight of duplicate character data. Interning is a precise tool for known constants, whereas GC-level deduplication is a safety net that cleans up the inevitable sprawl of identical strings generated during real-world data processing.

---

## 🏗️ Difference Table:
| Feature | String.intern() | String Deduplication |
|---|---|---|
| User Action | Manual | Automatic (GC) |
| Targets | String Objects | Internal char[] / byte[] |
| Performance | Fast Read | Zero Runtime Overhead |

---

## 🔄 Follow-up Questions
1. **Are Strings immutable?** (Yes, which is exactly WHAT makes these optimizations possible and safe.)
2. **How to enable Deduplication?** (`-XX:+UseG1GC -XX:+UseStringDeduplication`)
3. **Where are interned strings stored?** (Since Java 7, in the main Heap; before that, in Permanent Generation.)
