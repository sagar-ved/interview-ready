---
author: "sagar ved"
title: "Java: WeakHashMap and GC Internals"
date: 2024-04-04
draft: false
weight: 35
---

# 🧩 Question: How does `WeakHashMap` work? When shouldn't you use it, and what happens to the entries when the GC triggers?

## 🎯 What the interviewer is testing
- Advanced Collection usage.
- GC and references integration.
- Understanding "reachability" definitions.

---

## 🧠 Deep Explanation

### 1. The Structure:
`WeakHashMap` stores its **keys** as `WeakReference` objects.
It also uses a `ReferenceQueue`.

### 2. The Cleanup Cycle:
1. When a key is only "weakly reachable," the GC reclaims it.
2. The `WeakReference` corresponding to that key is added to the map's `ReferenceQueue`.
3. During the **next access** (get, put, size) of the `WeakHashMap`, it polls the queue and removes all entries whose keys are in the queue.

### 3. Key Constraints:
- **Strong values can prevent key collection!** If the Value in the map HAS a strong reference back to its own Key, the Key stays alive indefinitely.
- **Good for**: Caches where you want data to die when the rest of the system stops caring about the ID/Key.
- **Bad for**: Storing primitive keys (Integer literals in the pool) as those are eternally strong-referenced.

---

## ✅ Ideal Answer
WeakHashMap is a specialized map where entries are automatically removed when their keys are no longer in ordinary use. It leverages WeakReferences and a ReferenceQueue to perform lazy cleanup. It's ideal for non-critical caches or metadata storage but prone to memory leaks if the values in the map hold references back to their keys.

---

## 💻 Java Note: The ReferenceQueue hook
Internally, `WeakHashMap` periodically calls a `expungeStaleEntries()` method:
```java
private void expungeStaleEntries() {
    for (Object x; (x = queue.poll()) != null; ) {
        // Find the entry that corresponds to this reference and remove it
    }
}
```

---

## 🔄 Follow-up Questions
1. **Why does it use a ReferenceQueue?** (To know EXACTLY which references were cleared by GC.)
2. **IdentityHashMap vs HashMap?** (IdentityHashMap uses `==` instead of `.equals()`).
3. **What is a "Canonicalizing Map"?** (A cache where only one instance of an object exists for any given "value" — WeakHashMap is great for this.)
