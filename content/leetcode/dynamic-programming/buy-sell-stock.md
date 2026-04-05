---
title: "LeetCode 121-123: Buy and Sell Stock"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Best Time to Buy and Sell Stock (LeetCode 121, 122, 123)
Given prices array, maximize profit through stock transactions.

## 🎯 What the interviewer is testing
- Greedy vs DP thinking per variant.
- State-machine DP for constrained transactions.
- Recognizing the "peak-and-valley" pattern.

---

## 🧠 Deep Explanation

### Stock I — One transaction (Greedy = $O(N)$):
Track minimum price seen so far. At each step: `profit = max(profit, price - minSoFar)`.

### Stock II — Unlimited transactions (Greedy = $O(N)$):
Take every upward step: `profit += max(0, prices[i] - prices[i-1])`.
(Buying & selling on consecutive days decomposes any long gain into daily gains.)

### Stock III — At most 2 transactions (State Machine DP):
Track 4 states: `firstBuy`, `firstSell`, `secondBuy`, `secondSell`.
- `firstBuy = max(firstBuy, -prices[i])`
- `firstSell = max(firstSell, firstBuy + prices[i])`
- `secondBuy = max(secondBuy, firstSell - prices[i])`
- `secondSell = max(secondSell, secondBuy + prices[i])`

---

## 💻 Java Code: Stock III
```java
public class Solution {
    public int maxProfit(int[] prices) {
        int firstBuy = Integer.MIN_VALUE, firstSell = 0;
        int secondBuy = Integer.MIN_VALUE, secondSell = 0;
        for (int p : prices) {
            firstBuy  = Math.max(firstBuy,  -p);
            firstSell = Math.max(firstSell,  firstBuy + p);
            secondBuy = Math.max(secondBuy,  firstSell - p);
            secondSell= Math.max(secondSell, secondBuy + p);
        }
        return secondSell;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Stock with Cooldown?** (After selling, must wait 1 day → 3 states: hold, sold, rest.)
2. **Stock with Transaction Fee?** (Subtract fee from sell profit.)
3. **K transactions?** (LeetCode 188: Generalize with DP table `dp[k][n]`.)
