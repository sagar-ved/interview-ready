---
title: "LeetCode 309: Stock with Cooldown"
date: 2024-04-04
draft: false
weight: 13
---

# 🧩 LeetCode 309: Best Time to Buy and Sell Stock with Cooldown (Medium)
Unlimited transactions, but after selling you must wait 1 day (cooldown) before buying again. Maximize profit.

## 🎯 What the interviewer is testing
- 3-state State Machine DP.
- Managing mutually exclusive daily states.
- $O(1)$ space because only previous day's states matter.

---

## 🧠 Deep Explanation

### The 3 States:
| State | Meaning |
|---|---|
| `held` | Currently holding stock |
| `sold` | Sold today (must rest tomorrow) |
| `reset` | Not holding, free to buy |

### Daily Transitions:
- `held = max(held, reset - price)` — keep holding or buy now
- `sold = held_prev + price` — sell today's holding
- `reset = max(reset, sold_prev)` — either stay free or come off cooldown

Result = `max(sold, reset)` at the end.

---

## ✅ Ideal Answer
The cooldown creates a forced "rest" day after every sell. We model three mutually exclusive daily states and propagate them forward. Because only the previous day's values matter, the entire history compresses to $O(1)$ space.

---

## 💻 Java Code
```java
public class Solution {
    public int maxProfit(int[] prices) {
        int held = Integer.MIN_VALUE, sold = 0, reset = 0;
        for (int price : prices) {
            int prevSold = sold;
            sold  = held + price;
            held  = Math.max(held, reset - price);
            reset = Math.max(reset, prevSold);
        }
        return Math.max(sold, reset);
    }
}
```

---

## 🔄 Follow-up Questions
1. **N-day cooldown?** (Track `sold` state from N days ago using a deque.)
2. **With transaction fee?** (LC 714: Subtract fee from sell — same state machine, one extra term.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space.)
