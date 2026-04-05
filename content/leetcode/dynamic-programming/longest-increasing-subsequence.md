---
title: "LeetCode 300: Longest Increasing Subsequence"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: Longest Increasing Subsequence (LeetCode 300)
Return the length of the longest strictly increasing subsequence. Solve in $O(n \log n)$.

## 🎯 What the interviewer is testing
- Classic $O(n^2)$ DP warmup.
- Patience-sorting-like $O(n \log n)$ Binary Search optimization.
- Understanding `tails` array semantics.

---

## 🧠 Deep Explanation

### $O(n^2)$ DP:
`dp[i]` = LIS length ending at index `i`.
`dp[i] = 1 + max(dp[j])` for all `j < i` where `nums[j] < nums[i]`.

### $O(n \log n)$ — Binary Search on `tails`:
Maintain array `tails` where `tails[i]` = smallest tail of all increasing subsequences of length `i+1`.
- If `x > tails.last` → append (new longer LIS found).
- Else → binary search for first `tails[i] >= x` → replace (keep smallest possible tail for future extensions).

**Note**: `tails` doesn't represent the actual LIS — only its **length**.

---

## ✅ Ideal Answer
By replacing larger elements with smaller candidates in the `tails` array, we maintain the best possible "running board" for future extensions, achieving $O(n \log n)$.

---

## 💻 Java Code ($O(n \log n)$)
```java
public class Solution {
    public int lengthOfLIS(int[] nums) {
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

## 🔄 Follow-up Questions
1. **Print the actual sequence?** (Track predecessors during DP.)
2. **Count number of LIS?** (LeetCode 673: Use a separate `count[]` DP array.)
3. **Russian Doll Envelopes?** (LeetCode 354: Sort by width asc, height desc, then LIS on height.)
