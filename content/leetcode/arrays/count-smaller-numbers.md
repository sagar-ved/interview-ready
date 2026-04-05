---
title: "LeetCode 315: Count of Smaller Numbers After Self"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 LeetCode 315: Count of Smaller Numbers After Self ⭐ (Hard)
For each element, count how many numbers to its right are smaller than it.

## 🎯 What the interviewer is testing
- Fenwick Tree (Binary Indexed Tree) with Coordinate Compression.
- Modified Merge Sort (inversion count).
- Recognizing this as an inversion-counting problem.

---

## 🧠 Deep Explanation

### Fenwick Tree + Coordinate Compression:
1. **Compress**: Map values to ranks `1..N` (sort + index).
2. **Scan right to left**:
   - `count[i] = query(rank[i] - 1)` — how many smaller ranks seen so far?
   - `update(rank[i], 1)` — mark this value as seen.

### Modified Merge Sort:
During merge, when right-half element `R[j]` is placed before left-half element `L[i]`, all remaining elements in `L[i..]` have `R[j]` smaller to their right. Count these.

---

## ✅ Ideal Answer
We process right-to-left using a Fenwick Tree with coordinate compression. At each element, we query how many elements with smaller rank have already been registered (seen to the right), which gives the count directly in $O(\log N)$.

---

## 💻 Java Code (BIT)
```java
public class Solution {
    int[] bit;
    public List<Integer> countSmaller(int[] nums) {
        int n = nums.length;
        int[] sorted = nums.clone(); Arrays.sort(sorted);
        Map<Integer, Integer> rank = new HashMap<>();
        int r = 1;
        for (int v : sorted) if (!rank.containsKey(v)) rank.put(v, r++);
        bit = new int[r + 1];
        Integer[] res = new Integer[n];
        for (int i = n - 1; i >= 0; i--) {
            res[i] = query(rank.get(nums[i]) - 1);
            update(rank.get(nums[i]));
        }
        return Arrays.asList(res);
    }
    void update(int i) { for (; i < bit.length; i += i & -i) bit[i]++; }
    int query(int i) { int s = 0; for (; i > 0; i -= i & -i) s += bit[i]; return s; }
}
```

---

## 🔄 Follow-up Questions
1. **Coordinate Compression?** (Maps large values like `[100, 1M, 5]` → ranks `[2, 3, 1]` to fit a small BIT.)
2. **Merge Sort approach?** (Track indices during merge; when right-side placed first, add remaining left-side count.)
3. **Complexity?** ($O(N \log N)$ time, $O(N)$ space.)
