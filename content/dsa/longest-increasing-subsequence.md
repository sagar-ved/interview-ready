---
title: "DSA: Longest Increasing Subsequence"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 Question: Longest Increasing Subsequence (LeetCode 300)
Given an integer array `nums`, return the length of the longest strictly increasing subsequence. Can you solve it in $O(n \log n)$ time?

## 🎯 What the interviewer is testing
- Understanding of Dynamic Programming.
- Optimization from $O(n^2)$ to $O(n \log n)$ using Binary Search.
- Patience-sorting-like logic.

---

## 🧠 Deep Explanation

### 1. The $O(n^2)$ DP Approach:
Let `dp[i]` be the length of the LIS ending at index `i`.
`dp[i] = 1 + max(dp[j])` for all `j < i` where `nums[j] < nums[i]`.
This is intuitive but slow for large $n$.

### 2. The $O(n \log n)$ Binary Search Approach:
Maintain a list (or array) `tails` where `tails[i]` is the smallest tail of all increasing subsequences of length `i+1`.
- For each `x` in `nums`:
  - If `x` is larger than the last element of `tails`, append it.
  - Otherwise, find the first element in `tails` that is $\ge x$ using binary search and replace it with `x`.
The size of `tails` at the end is the length of LIS.

---

## ✅ Ideal Answer
While the $O(n^2)$ DP solution is standard, the $O(n \log n)$ approach is much more efficient. We maintain a dynamic array representing the "best" possible subsequence of each length found so far. By replacing larger values with smaller ones, we maximize the potential for future extensions.

---

## 💻 Java Code
```java
import java.util.Arrays;

public class Solution {
    public int lengthOfLIS(int[] nums) {
        int[] tails = new int[nums.length];
        int size = 0;
        for (int x : nums) {
            int i = 0, j = size;
            while (i != j) {
                int m = (i + j) / 2;
                if (tails[m] < x)
                    i = m + 1;
                else
                    j = m;
            }
            tails[i] = x;
            if (i == size) size++;
        }
        return size;
    }
    
    // Alternative using built-in binarySearch
    public int lengthOfLIS_BuiltIn(int[] nums) {
        int[] dp = new int[nums.length];
        int len = 0;
        for (int num : nums) {
            int i = Arrays.binarySearch(dp, 0, len, num);
            if (i < 0) i = -(i + 1);
            dp[i] = num;
            if (i == len) len++;
        }
        return len;
    }
}
```

---

## ⚠️ Common Mistakes
- Confusing LIS with Longest Increasing Sub-array (which must be contiguous).
- Off-by-one errors in custom binary search.
- Not realizing that the `tails` array doesn't represent the *actual* LIS, only its *length*.

---

## 🔄 Follow-up Questions
1. **Can you print the actual LIS?** (Need to store predecessors for each element.)
2. **How to find the number of LIS?** (LeetCode 673: Use another DP array to store counts.)
3. **What is the complexity of Russian Doll Envelopes?** (LeetCode 354: $O(n \log n)$ after sorting by width and using LIS logic on height.)
