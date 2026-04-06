---
author: "sagar ved"
title: "LeetCode 128: Longest Consecutive Sequence"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 LeetCode 128: Longest Consecutive Sequence ⭐ (Medium)
Given unsorted array `nums`, return the length of the longest consecutive elements sequence in $O(N)$.

## 🎯 What the interviewer is testing
- HashSet for $O(1)$ lookups.
- Avoiding $O(N \log N)$ sorting.
- Sequence starting logic (only start counting from the "root" element).

---

## 🧠 Deep Explanation

### Why not sort?
Sorting is $O(N \log N)$. We need $O(N)$.

### HashSet Strategy:
1. Put all numbers into a `HashSet`.
2. For each number `n`, only start counting if `n-1` is **NOT** in the set (meaning `n` is the start of a sequence).
3. From `n`, keep incrementing while `n+1` exists in the set.
4. Track the max streak length.

This works because each number is only visited once as a "sequence start."

---

## ✅ Ideal Answer
The key insight is only beginning a count from elements that have no predecessor. This prevents redundant counting from the middle of a sequence, keeping the total work $O(N)$ amortized.

---

## 💻 Java Code
```java
public class Solution {
    public int longestConsecutive(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for (int n : nums) set.add(n);
        int longest = 0;
        for (int n : nums) {
            if (!set.contains(n - 1)) { // Start of sequence
                int len = 1;
                while (set.contains(n + len)) len++;
                longest = Math.max(longest, len);
            }
        }
        return longest;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if duplicates?** (HashSet handles them automatically.)
2. **Print the actual sequence?** (Store the sequence with max length.)
3. **Complexity?** ($O(N)$ time, $O(N)$ space for the HashSet.)
