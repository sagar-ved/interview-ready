---
title: "DSA: Climbing Stairs"
date: 2024-04-04
draft: false
weight: 57
---

# 🧩 Question: Climbing Stairs (LeetCode 70)
You are climbing a staircase. It takes `n` steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

## 🎯 What the interviewer is testing
- Basic Dynamic Programming.
- Identifying Fibonacci patterns.
- Space optimization from $O(N)$ to $O(1)$.

---

## 🧠 Deep Explanation

### The Logic:
To reach the $N$th step, you could have come from:
1. The $(N-1)$th step (taking 1 step).
2. The $(N-2)$th step (taking 2 steps).
Therefore, `totalWays(N) = totalWays(N-1) + totalWays(N-2)`.

### Why it's Fibonacci:
- `totalWays(1) = 1`
- `totalWays(2) = 2`
- `totalWays(3) = 1 + 2 = 3`
- ... This is the Fibonacci sequence starting from 1 and 2.

---

## ✅ Ideal Answer
To find the number of ways to climb stairs, we recognize that each step is the sum of choices from the previous two steps. This mirrors the Fibonacci sequence. While recursive solutions are $O(2^N)$, we can use Dynamic Programming to calculate it in $O(N)$ time. By only tracking the results of the two previous steps, we reduce space complexity to $O(1)$.

---

## 💻 Java Code: Space Optimized
```java
public class Solution {
    public int climbStairs(int n) {
        if (n <= 2) return n;
        
        int first = 1;
        int second = 2;
        
        for (int i = 3; i <= n; i++) {
            int third = first + second;
            first = second;
            second = third;
        }
        return second;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if you can take 1, 2, or 3 steps?** (`dp[i] = dp[i-1] + dp[i-2] + dp[i-3]`.)
2. **What if some steps are "broken"?** (Set `dp[i] = 0` for those steps.)
3. **What is the complexity?** ($O(N)$ time, $O(1)$ space.)
