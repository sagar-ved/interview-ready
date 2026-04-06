---
author: "sagar ved"
title: "LeetCode 198: House Robber"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: House Robber (LeetCode 198)
You are a professional robber. Adjacent houses have a security system. Return the maximum money you can rob without triggering the alarm.

## 🎯 What the interviewer is testing
- Inclusion/Exclusion decision DP.
- Space optimization to $O(1)$.
- Extending to circular/tree variants.

---

## 🧠 Deep Explanation

### The Logic:
For each house `i`:
- **Rob it**: Get `nums[i]` + max money from non-adjacent house `i-2`.
- **Skip it**: Carry over max from house `i-1`.

`dp[i] = max(dp[i-2] + nums[i], dp[i-1])`

We only need the last two values → $O(1)$ space.

---

## ✅ Ideal Answer
At each house we make a binary choice: rob it and combine with i-2, or skip it and carry forward the i-1 best. This ensures we never trigger adjacent alarms while maximizing profit.

---

## 💻 Java Code
```java
public class Solution {
    public int rob(int[] nums) {
        int prev1 = 0, prev2 = 0;
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
1. **House Robber II?** (Houses in a circle: solve twice — once skipping first, once skipping last. Take max.)
2. **House Robber III?** (Houses in a binary tree — requires DFS returning `[rob, skip]` pairs.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space.)
