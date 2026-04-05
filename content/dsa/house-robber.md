---
title: "DSA: House Robber"
date: 2024-04-04
draft: false
weight: 58
---

# 🧩 Question: House Robber (LeetCode 198)
You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security systems connected and it will automatically contact the police if two adjacent houses were broken into on the same night. Return the maximum amount of money you can rob.

## 🎯 What the interviewer is testing
- Identifying optimal subproblems.
- Managing "Inclusion/Exclusion" logic.
- DP optimization.

---

## 🧠 Deep Explanation

### The Logic:
For each house `i`:
1. **Rob it**: You get `nums[i]` plus the max money from non-adjacent house `i-2`.
2. **Don't rob it**: You carry over the max money from house `i-1`.
`dp[i] = max(dp[i-2] + nums[i], dp[i-1])`.

### Space Optimization:
Just like the staircase problem, we only need the results of the previous two houses (`rob_previous` and `rob_current`).

---

## ✅ Ideal Answer
To maximize the loot, we use DP to decide at each house whether it is better to rob the current house and add it to our total from two houses ago, or to simply take our current maximum from the adjacent house. This ensures we never trigger an alarm while always selecting the most profitable path.

---

## 💻 Java Code
```java
public class Solution {
    public int rob(int[] nums) {
        if (nums == null || nums.length == 0) return 0;
        int prev1 = 0;
        int prev2 = 0;
        for (int num : nums) {
            int tmp = prev1;
            prev1 = Math.max(prev2 + num, prev1);
            prev2 = tmp;
        }
        return prev1;
    }
}
```

---

## 🔄 Follow-up Questions
1. **House Robber II?** (Houses are in a circle; solve twice: once without the first, once without the last, and take max.)
2. **House Robber III?** (Houses are in a binary tree — requires DFS.)
3. **What is the complexity?** ($O(N)$ time, $O(1)$ space.)
