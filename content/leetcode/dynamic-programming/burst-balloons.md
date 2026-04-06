---
author: "sagar ved"
title: "LeetCode 312: Burst Balloons"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 LeetCode 312: Burst Balloons ⭐ (Hard)
Burst balloons to collect coins: bursting `i` gives `nums[left] * nums[i] * nums[right]`. Maximize total coins.

## 🎯 What the interviewer is testing
- Interval DP ("last to burst" thinking).
- Reverse-order reasoning.
- $O(N^3)$ vs naive $O(N!)$.

---

## 🧠 Deep Explanation

### The Critical Insight: Think Backwards
Forward reasoning is hard because bursting changes neighbors. Instead, ask: **"Which balloon is the LAST to be burst in subarray `[i, j]`?"**

If balloon `k` is the last: its neighbors are the padded borders `nums[i-1]` and `nums[j+1]` (everything else is already gone).

### Recurrence:
`dp[i][j] = max over k in [i,j] of: dp[i][k-1] + nums[i-1]*nums[k]*nums[j+1] + dp[k+1][j]`

Pad with `1` on both ends of the array.

---

## ✅ Ideal Answer
Treating the problem as interval DP and "last burst" selection eliminates the dependency-ordering problem. Smaller subproblems (sub-intervals) are solved first and their results are combined when we select the last balloon for a larger interval.

---

## 💻 Java Code
```java
public class Solution {
    public int maxCoins(int[] nums) {
        int n = nums.length;
        int[] arr = new int[n + 2];
        arr[0] = arr[n + 1] = 1;
        for (int i = 0; i < n; i++) arr[i + 1] = nums[i];
        int[][] dp = new int[n + 2][n + 2];
        for (int len = 1; len <= n; len++) {
            for (int i = 1; i <= n - len + 1; i++) {
                int j = i + len - 1;
                for (int k = i; k <= j; k++) {
                    dp[i][j] = Math.max(dp[i][j],
                        dp[i][k-1] + arr[i-1]*arr[k]*arr[j+1] + dp[k+1][j]);
                }
            }
        }
        return dp[1][n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Memoization approach?** (Top-down recursion with `memo[i][j]` — equally valid.)
2. **Complexity?** ($O(N^3)$ time, $O(N^2)$ space.)
3. **Similar problems?** (Strange Printer LC 664, Remove Boxes LC 546 — all use interval DP.)
