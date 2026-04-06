---
author: "sagar ved"
title: "LeetCode 322 Variant: Coin Change 2"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 LeetCode 518: Coin Change 2 (Medium)
Given coins and amount, return the number of **combinations** (not minimum count) that make up the amount.

## 🎯 What the interviewer is testing
- Combinations vs Permutations in DP.
- Inner/outer loop order significance.
- Unbounded Knapsack pattern.

---

## 🧠 Deep Explanation

### The Crucial Difference from Coin Change 1:
- **Coin Change 1**: Fewest coins → `min` over choices.
- **Coin Change 2**: Count of combinations → `sum` over choices.

### The Loop Order Trick:
- **Outer loop: Coins, Inner loop: Amounts** → counts unique **combinations** (no duplicates like `[1,2]` and `[2,1]` counted separately).
- **Outer loop: Amounts, Inner loop: Coins** → counts **permutations** (both orderings counted).

The combinations loop ensures each coin is considered "cumulatively" across the amount range.

---

## ✅ Ideal Answer
This is the unbounded knapsack variant. The key insight is loop ordering: iterating coins in the outer loop ensures each coin's contribution is built upon previous coins, naturally producing unique combinations without repetition.

---

## 💻 Java Code
```java
public class Solution {
    public int change(int amount, int[] coins) {
        int[] dp = new int[amount + 1];
        dp[0] = 1; // One way to make 0: use no coins
        for (int coin : coins) {         // OUTER: coins = combinations
            for (int i = coin; i <= amount; i++) {
                dp[i] += dp[i - coin];
            }
        }
        return dp[amount];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Why does swapping loops give permutations?** (Moving amount to outer loop re-considers all coins fresh at each amount — order matters → permutations.)
2. **Bounded knapsack (each coin used at most once)?** (Add each coin's constraint; reachable only from the state before picking the current coin.)
3. **Complexity?** ($O(S \cdot C)$ where $S$ = amount and $C$ = number of coins. $O(S)$ space.)
