---
title: "DSA: Best Time to Buy and Sell Stock with Cooldown"
date: 2024-04-04
draft: false
weight: 74
---

# 🧩 Question: Best Time to Buy and Sell Stock with Cooldown (LeetCode 309 - Hard)
You are given an array `prices`. Find the maximum profit you can achieve. You may complete as many transactions as you like, but you cannot buy on the day after you sell (1-day cooldown).

## 🎯 What the interviewer is testing
- State machine Dynamic Programming.
- Managing "Rest" periods.
- Transitioning between mutually exclusive states.

---

## 🧠 Deep Explanation

### The Logic (States):
At any given day, you can be in one of 3 states:
1. **Held**: You are currently holding a stock.
2. **Sold**: You just sold a stock today (Must rest tomorrow).
3. **Reset**: You are not holding and didn't just sell (Free to buy or rest).

### Transitions:
- **Held**: `max(Previous_Held, Previous_Reset - Price)`
- **Sold**: `Previous_Held + Price`
- **Reset**: `max(Previous_Reset, Previous_Sold)`

### Result: 
The max profit is the maximum of being in **Sold** or **Reset** on the final day.

---

## ✅ Ideal Answer
Because of the cooldown constraint, we must track our profit through three distinct states: holding a stock, recently sold, or resting. By calculating the optimal move for each state based on the previous day's results, we can model the entire trading history in $O(N)$ time. This "state machine" approach is more robust than greedy methods when complex sequence constraints are involved.

---

## 💻 Java Code
```java
public class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length == 0) return 0;
        
        int reset = 0;
        int held = Integer.MIN_VALUE;
        int sold = Integer.MIN_VALUE;
        
        for (int price : prices) {
            int prevSold = sold;
            sold = held + price;
            held = Math.max(held, reset - price);
            reset = Math.max(reset, prevSold);
        }
        
        return Math.max(reset, sold);
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if the cooldown was N days?** (Requires a slightly larger DP table or a deque to track the 'Sold' price from N days ago.)
2. **Why initialize `held` to MIN_VALUE?** (To ensure we can't "Sell" or "Rest" before our first purchase.)
3. **Complexity?** ($O(N)$ time and $O(1)$ space.)
