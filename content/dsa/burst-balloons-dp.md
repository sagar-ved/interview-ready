---
title: "DSA: Burst Balloons"
date: 2024-04-04
draft: false
weight: 91
---

# 🧩 Question: Burst Balloons (LeetCode 312 - Hard)
Given `n` balloons, each with a number. If you burst a balloon, you get `nums[left] * nums[i] * nums[right]` coins. Find the maximum coins you can collect.

## 🎯 What the interviewer is testing
- Interval Dynamic Programming (DP).
- Thinking in "Reverse Order."
- Optimizing from $O(N!)$ to $O(N^3)$.

---

## 🧠 Deep Explanation

### The Challenge:
If you burst a balloon in the middle, the neighbors change. This makes standard "Forward DP" very difficult because the subproblems are not independent.

### The Reverse Strategy:
Think: **"Which balloon is the LAST one to be burst in the interval [i, j]?"**
1. Let this balloon be `k`. 
2. Because it's the last one, its neighbors are `nums[i-1]` and `nums[j+1]`.
3. The total coins for interval `[i, j]` with `k` as the last burst:
   - `coins = solve(i, k-1) + solve(k+1, j) + (nums[i-1] * nums[k] * nums[j+1])`.

### Algorithm:
- Padded array: Add `1` at both ends.
- `dp[i][j]` stores max coins for subarray from `i` to `j`.
- Iterate through all lengths from 1 to `n`.

---

## ✅ Ideal Answer
Burst Balloons is a classic interval DP challenge that is most elegantly solved by working backward. Instead of picking the first balloon to burst, we identify the last balloon standing in each sub-interval. This ensures our subproblems remain constant and independent, allowing us to build the optimal solution through a bottom-up $O(N^3)$ approach that resolves smaller segments before their parent intervals.

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

        for (int len = 1; len <= n; len++) { // length of interval
            for (int i = 1; i <= n - len + 1; i++) { // start index
                int j = i + len - 1; // end index
                for (int k = i; k <= j; k++) { // k is the LAST balloon burst in [i, j]
                    dp[i][j] = Math.max(dp[i][j], 
                        dp[i][k - 1] + dp[k + 1][j] + (arr[i - 1] * arr[k] * arr[j + 1]));
                }
            }
        }
        return dp[1][n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can this be solved with Memoization?** (Yes, top-down recursion with a table is equally valid and arguably more intuitive.)
2. **Complexity?** ($O(N^3)$ time; $O(N^2)$ space.)
3. **What happens if all balloons are 1?** (The answer follows the interval growth logic, but coins will be minimal.)
