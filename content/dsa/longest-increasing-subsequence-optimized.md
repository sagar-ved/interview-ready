---
title: "DSA: Longest Increasing Subsequence (Optimized)"
date: 2024-04-04
draft: false
weight: 53
---

# 🧩 Question: Longest Increasing Subsequence (LeetCode 300)
Given an integer array `nums`, return the length of the longest strictly increasing subsequence.

## 🎯 What the interviewer is testing
- Dynamic Programming ($O(N^2)$).
- **Binary Search** optimization ($O(N \log N)$).
- Patience Sorting conceptual link.

---

## 🧠 Deep Explanation

### 1. The $O(N^2)$ DP:
`dp[i]` is the length of LIS ending at index `i`.
For each `i`, check all `j < i`. If `nums[j] < nums[i]`, `dp[i] = max(dp[i], dp[j] + 1)`.
Simple, but slow for large $N$.

### 2. The $O(N \log N)$ Optimization (Patience Sort):
Maintain a `tails` array where `tails[i]` is the smallest tail of all increasing subsequences of length `i+1`.
- This array will always be **sorted**.
- For each `num`:
  - Find the position `i` where `num` would fit in `tails` using **Binary Search**.
  - If `num` is larger than anything in `tails`, append it (increasing the global length).
  - Otherwise, replace `tails[i]` with `num` (improving/shortening a potential subsequence).

---

## ✅ Ideal Answer
To achieve $O(N \log N)$, we don't just count the length using DP; we build a list of "current tails" for all potential subsequences. By using binary search to decide where to place each new number, we keep the list sorted and ensure we're always looking for the most "efficient" (smallest) possible tail for a subsequence of a given length.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int lengthOfLIS(int[] nums) {
        int[] tails = new int[nums.length];
        int size = 0;
        for (int x : nums) {
            int i = 0, j = size;
            // Binary search to find where x fits
            while (i != j) {
                int m = (i + j) / 2;
                if (tails[m] < x) i = m + 1;
                else j = m;
            }
            tails[i] = x;
            if (i == size) ++size;
        }
        return size;
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking the `tails` array is the actual LIS (it's not, it's just the minimal tails; the order of elements might be scrambled).
- Not handling strictly vs non-strictly increasing correctly.
- Off-by-one errors in binary search.

---

## 🔄 Follow-up Questions
1. **How to print the actual LIS?** (Requires a `parent` array to track where each element came from.)
2. **Russian Doll Envelopes?** (LeetCode 354: Sorting and then applying this $O(N \log N)$ LIS logic.)
3. **What is Patience Sorting?** (A card game logic that mirrors this LIS algorithm.)
