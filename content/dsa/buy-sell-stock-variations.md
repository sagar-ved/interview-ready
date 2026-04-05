---
title: "DSA: Best Time to Buy and Sell Stock (All)"
date: 2024-04-04
draft: false
weight: 51
---

# 🧩 Question: Best Time to Buy and Sell Stock (Variations I, II)
Given an array `prices` where `prices[i]` is the price of a given stock on the `i`th day. Find the maximum profit.

## 🎯 What the interviewer is testing
- Greedy vs DP thinking.
- Optimizing for state changes.
- Understanding "peak-and-valley" relationships.

---

## 🧠 Deep Explanation

### 1. Stock I (One transaction):
- Find the lowest price seen so far.
- At each step, see what profit we'd get if we sold today: `current_price - min_price`.
- Keep the max.

### 2. Stock II (Unlimited transactions):
- Any time the price goes up tomorrow, "buy" today and "sell" tomorrow.
- Total profit = sum of all positive `prices[i] - prices[i-1]`.
- This works because a longer gain `(A...D)` is the same as sum of small gains `(A-B) + (B-C) + (C-D)`.

### 3. Stock III (At most two transactions):
- Requires tracking multiple states: `firstBuy`, `firstSell`, `secondBuy`, `secondSell`.
- This is a state-machine DP problem.

---

## ✅ Ideal Answer
For a single transaction, we simply track the historical minimum and record the best possible gain. For multiple transactions, we can take advantage of every price increase. For restricted transactions, we use a state-based approach where we track our total net money after each successive buy/sell action.

---

## 💻 Java Code: Stock II (Unlimited)
```java
public class Solution {
    public int maxProfit(int[] prices) {
        int profit = 0;
        for (int i = 1; i < prices.length; i++) {
            if (prices[i] > prices[i-1]) {
                profit += prices[i] - prices[i-1];
            }
        }
        return profit;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Stock with Transaction Fee?** (Subtract fee from every sell or add to every buy.)
2. **Stock with Cooldown?** (After selling, you must wait one day before buying again — requires 3 states in DP.)
3. **What is the complexity?** ($O(N)$ for all basic versions.)
