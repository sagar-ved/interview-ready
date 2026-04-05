---
title: "DSA: Coin Change"
date: 2024-04-04
draft: false
weight: 54
---

# 🧩 Question: Coin Change (LeetCode 322)
You are given an integer array `coins` representing coins of different denominations and an integer `amount`. Return the fewest number of coins that you need to make up that amount. If that amount cannot be made up, return -1.

## 🎯 What the interviewer is testing
- Iterative DP on amounts.
- Handling unreachable states.
- Understanding why "Greedy" doesn't work for arbitrary coin denominations.

---

## 🧠 Deep Explanation

### Why doesn't Greedy work?
If coins are `[1, 5, 6]` and amount is `10`.
- **Greedy**: Take 6, then 1, 1, 1, 1 (5 coins).
- **Correct (DP)**: Take 5, 5 (2 coins).

### The DP Logic:
Let `dp[i]` be the minimal coins to make amount `i`.
`dp[i] = 1 + min(dp[i - coin])` for all `coin` in `coins`.
- Initialize `dp` with a large value (`amount + 1`).
- `dp[0] = 0`.

---

## ✅ Ideal Answer
Coin change is a minimization problem with overlapping subproblems. We build our DP table from amount 0 to our target. For each amount, we check every coin denomination; if picking that coin leads to a previously calculated valid sub-amount, we update our current minimum. This results in $O(N \cdot K)$ where $N$ is amount and $K$ is the number of coins.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int coinChange(int[] coins, int amount) {
        int[] dp = new int[amount + 1];
        Arrays.fill(dp, amount + 1);
        dp[0] = 0;

        for (int i = 1; i <= amount; i++) {
            for (int coin : coins) {
                if (i - coin >= 0) {
                    dp[i] = Math.min(dp[i], 1 + dp[i - coin]);
                }
            }
        }
        return dp[amount] > amount ? -1 : dp[amount];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Coin Change 2?** (Find total permutations/combinations; change inner-outer loop order.)
2. **How to save space?** (Already optimized to $O(N)$ for amount.)
3. **What is the complexity?** ($O(S \cdot N)$ where $S$ is amount and $N$ is count of coins.)
