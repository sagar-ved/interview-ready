---
title: "LeetCode 322: Coin Change"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Coin Change (LeetCode 322)
Given coins of different denominations and a target `amount`, return the fewest coins needed to make up that amount. Return -1 if impossible.

## 🎯 What the interviewer is testing
- Iterative DP on amounts.
- Understanding why Greedy fails for arbitrary coin systems.
- Handling unreachable states.

---

## 🧠 Deep Explanation

### Why doesn't Greedy work?
Coins `[1, 5, 6]`, amount `10`:
- **Greedy**: 6 + 1+1+1+1 = 5 coins.
- **Optimal (DP)**: 5+5 = 2 coins.

### DP Logic:
Let `dp[i]` = minimum coins to make amount `i`.
- `dp[0] = 0`
- `dp[i] = 1 + min(dp[i - coin])` for each valid coin.

---

## ✅ Ideal Answer
This is a minimization problem with overlapping subproblems. We build the DP table from 0 to our target amount, checking every coin denomination at each step. Result: $O(N \cdot K)$ where $N$ is amount and $K$ is the number of coin types.

---

## 💻 Java Code
```java
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
1. **Coin Change 2?** (Count total combinations — swap loop order.)
2. **Can we do better than $O(N \cdot K)$?** (Not in the general case.)
3. **Complexity?** ($O(S \cdot N)$ where $S$ is amount and $N$ is coin count.)
