---
title: "HashMap Internals and Resizing"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: How does `HashMap` work internally in Java 8+? What happens during a resize and how does treeification affect performance?

## 🎯 What the interviewer is testing
- Internal data structures (Node array + linked lists + Red-Black trees)
- Hash function mechanics: spread(), index calculation
- Resize triggering (load factor) and rehashing cost
- Performance implications of poor hash functions

---

## 🧠 Deep Explanation

### 1. Internal Structure

A `HashMap` is backed by an `Node<K,V>[] table` array.
- Each index in the array is a **bucket**.
- Each bucket holds a **singly-linked list** of Node objects.
- In Java 8+, if a bucket's list exceeds **8 entries** AND the total table size is >= **64**, the list is converted to a **Red-Black Tree** (`TreeNode`). This is called **Treeification**.

### 2. Hash Computation

```java
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```

The XOR with the upper 16 bits is called **hash spreading** — it ensures good distribution even for hash functions that differ only in the upper bits. The bucket index is then `(n - 1) & hash` where `n` is the array length (always a power of 2).

### 3. Resizing / Rehashing

- **Load Factor** (default: 0.75): When `size > capacity * loadFactor`, a resize is triggered.
- The table is **doubled** in size.
- Each existing node must be **rehashed** and placed into the new table.
- Java 8 optimization: Because `n` is always a power of 2, a node's new bucket is either `oldIndex` or `oldIndex + oldCapacity` — no need to recompute the full hash. This cuts rehashing cost significantly.

### 4. Treeification and Untreeification

- **Treeify**: Bucket list length > 8 AND table.length >= 64
- **Untreeify**: Treeified bucket shrinks to <= 6 elements
- **Why 8?** Statistical analysis: collision probability drops below 1 in 8 million with a proper hash function. Treeification handles worst-case malicious inputs.

---

## ✅ Ideal Answer

- `HashMap` uses a **Node array** with chaining for collision resolution.
- Java 8 adds **treeification** (linked list → Red-Black Tree) for buckets with many collisions.
- Default `loadFactor` is 0.75 — above this, the table doubles and rehashes.
- Poor `hashCode()` implementations cause **hash collisions**, degrading performance from O(1) to O(n) [or O(log n) with trees].
- With `null` key, it's always stored at bucket index 0.

---

## 💻 Java Code

```java
import java.util.HashMap;
import java.util.Objects;

/**
 * Demonstrates HashMap behavior with a custom equals/hashCode
 */
public class HashMapDemo {

    static class CacheKey {
        final String userId;
        final String region;

        CacheKey(String userId, String region) {
            this.userId = userId;
            this.region = region;
        }

        @Override
        public int hashCode() {
            // Good: Combines multiple fields for distribution
            return Objects.hash(userId, region);
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (!(obj instanceof CacheKey)) return false;
            CacheKey other = (CacheKey) obj;
            return Objects.equals(userId, other.userId) &&
                   Objects.equals(region, other.region);
        }
    }

    public static void main(String[] args) {
        // Pre-size to 64 when you know the expected capacity to avoid rehashing
        // Formula: initialCapacity = (expectedEntries / loadFactor) + 1
        HashMap<CacheKey, String> cache = new HashMap<>(128, 0.75f);

        cache.put(new CacheKey("u1", "IN"), "User A");
        cache.put(new CacheKey("u2", "US"), "User B");

        // A bug: If hashCode() is not overridden, two logically equal objects
        // are treated as different keys!
        CacheKey k = new CacheKey("u1", "IN");
        System.out.println(cache.get(k)); // "User A" — only works if equals + hashCode correct
    }
}
```

---

## ⚠️ Common Mistakes
- **Breaking the equals/hashCode contract**: If two objects are `equal()`, they MUST have the same `hashCode()`. Violating this corrupts the map.
- Not pre-sizing `HashMap` when the expected size is known (avoids multiple resize cycles)
- Using mutable keys — if a key's hash changes after insertion, the value becomes unreachable

---

## 🔄 Follow-up Questions
1. **Why is the `loadFactor` default 0.75 and not 1.0?** (At 1.0, almost all buckets are occupied, collisions spike, and O(1) gets is no longer guaranteed.)
2. **What is the time complexity of `get()` in the worst case?** (O(log n) with Java 8 treeification; was O(n) before.)
3. **How does `LinkedHashMap` differ internally?** (Adds doubly-linked list across all entries to maintain insertion order or LRU access order.)
4. **What happens if two threads do `put()` on the same `HashMap` simultaneously?** (Race condition on resize — can cause an **infinite loop** in Java 6 or data loss in Java 8+.)
