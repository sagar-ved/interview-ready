---
author: "sagar ved"
title: "Prefix Sums and Difference Arrays"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: You have a list of 10 million time-series events with timestamps. Answer 1 million range sum queries efficiently. Also, apply 1 million range update operations efficiently.

## 🎯 What the interviewer is testing
- Prefix sum for range queries: O(1) query after O(n) build
- Difference array for range updates: O(1) update, O(n) rebuild
- Segment tree for both queries AND updates: O(log n)
- Fenwick Tree (BIT) as a concise alternative

---

## 🧠 Deep Explanation

### 1. Prefix Sum (Immutable Array, Range Queries)

`prefix[i] = arr[0] + arr[1] + ... + arr[i]`

Range sum `[l, r]` = `prefix[r] - prefix[l-1]`

**Build**: O(n) **Query**: O(1) **Update**: O(n) — NOT efficient for updates!

### 2. Difference Array (Frequent Updates, Single Final Query)

For range updates `add(l, r, val)`:
- `diff[l] += val; diff[r+1] -= val`
- After all updates, prefix sum of `diff` = final array

**Update**: O(1) **Rebuild**: O(n) — NOT efficient for frequent per-element queries!

### 3. Segment Tree (Both Queries AND Updates)

A balanced binary tree where each node stores aggregate (sum/min/max) of its range.
- **Query**: O(log n)
- **Point Update**: O(log n)
- **Range Update (lazy propagation)**: O(log n)

### 4. Fenwick Tree (Binary Indexed Tree)

More space-efficient than Segment Tree for prefix sums and point updates.
- **Update**: O(log n)
- **Prefix Query**: O(log n)
- Smaller constants; harder to generalize to non-commutative operations

---

## ✅ Ideal Answer

- For **read-only** range queries: prefix sum (O(1) query).
- For **write-heavy** range updates + single final read: difference array (O(1) update).
- For **mixed** read-write at arbitrary positions: Segment Tree (O(log n) both).
- For pure prefix sum + point updates: Fenwick Tree (simpler code, O(log n)).

---

## 💻 Java Code

```java
public class RangeQueryStructures {

    // 1. Prefix Sum — O(n) build, O(1) range sum
    static class PrefixSum {
        private final int[] prefix;

        PrefixSum(int[] arr) {
            prefix = new int[arr.length + 1]; // prefix[0] = 0 (sentinel)
            for (int i = 0; i < arr.length; i++) {
                prefix[i + 1] = prefix[i] + arr[i];
            }
        }

        public int rangeSum(int l, int r) { // 0-indexed [l, r]
            return prefix[r + 1] - prefix[l];
        }
    }

    // 2. Difference Array — O(1) range update, O(n) rebuild
    static class DifferenceArray {
        private final int[] diff;

        DifferenceArray(int n) { diff = new int[n + 1]; }

        public void rangeUpdate(int l, int r, int val) {
            diff[l] += val;
            if (r + 1 < diff.length) diff[r + 1] -= val;
        }

        public int[] buildResult() {
            int[] result = new int[diff.length - 1];
            result[0] = diff[0];
            for (int i = 1; i < result.length; i++) {
                result[i] = result[i - 1] + diff[i];
            }
            return result;
        }
    }

    // 3. Segment Tree — O(log n) range query + point update
    static class SegmentTree {
        private final int[] tree;
        private final int n;

        SegmentTree(int[] arr) {
            n = arr.length;
            tree = new int[4 * n];
            build(arr, 0, 0, n - 1);
        }

        private void build(int[] arr, int node, int start, int end) {
            if (start == end) {
                tree[node] = arr[start];
            } else {
                int mid = (start + end) / 2;
                build(arr, 2 * node + 1, start, mid);
                build(arr, 2 * node + 2, mid + 1, end);
                tree[node] = tree[2 * node + 1] + tree[2 * node + 2];
            }
        }

        public int rangeSum(int l, int r) {
            return query(0, 0, n - 1, l, r);
        }

        private int query(int node, int start, int end, int l, int r) {
            if (r < start || end < l) return 0; // Out of range
            if (l <= start && end <= r) return tree[node]; // Fully within range
            int mid = (start + end) / 2;
            return query(2 * node + 1, start, mid, l, r)
                 + query(2 * node + 2, mid + 1, end, l, r);
        }

        public void update(int idx, int val) {
            update(0, 0, n - 1, idx, val);
        }

        private void update(int node, int start, int end, int idx, int val) {
            if (start == end) {
                tree[node] = val;
            } else {
                int mid = (start + end) / 2;
                if (idx <= mid) update(2 * node + 1, start, mid, idx, val);
                else update(2 * node + 2, mid + 1, end, idx, val);
                tree[node] = tree[2 * node + 1] + tree[2 * node + 2];
            }
        }
    }

    // 4. Fenwick Tree (BIT) — simpler for prefix sums
    static class FenwickTree {
        private final int[] tree;
        private final int n;

        FenwickTree(int n) { this.n = n; tree = new int[n + 1]; }

        public void update(int i, int delta) { // 1-indexed
            for (i++; i <= n; i += i & (-i)) tree[i] += delta;
        }

        public int prefixSum(int i) { // 1-indexed, sum [0..i]
            int sum = 0;
            for (i++; i > 0; i -= i & (-i)) sum += tree[i];
            return sum;
        }

        public int rangeSum(int l, int r) {
            return prefixSum(r) - (l > 0 ? prefixSum(l - 1) : 0);
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Using `prefix[r] - prefix[l]` instead of `prefix[r+1] - prefix[l]` (off-by-one for 0-indexed)
- Building segment tree of size `2*n` (incorrect; need `4*n` for general arrays)
- Using Fenwick Tree for range minimum (BIT only supports invertible operations — min is not invertible)

---

## 🔄 Follow-up Questions
1. **When would you use a Sparse Table over a Segment Tree?** (Sparse Table: O(n log n) build, O(1) read-only idempotent queries like range min/max. Cannot handle updates.)
2. **How do you extend Segment Tree to support range updates?** (Lazy propagation: mark a node as "pending update"; push down lazily when children are accessed.)
3. **What is a 2D prefix sum and when is it used?** (For 2D range sum queries on a matrix — used in image processing, 2D sliding window.)
