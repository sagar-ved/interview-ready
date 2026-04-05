---
title: "LeetCode 152: Maximum Product Subarray"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 LeetCode 152: Maximum Product Subarray (Medium)
Find the contiguous subarray with the largest product.

## 🎯 What the interviewer is testing
- Tracking both min and max products simultaneously.
- Negative number behavior (two negatives = positive).
- Zero reset logic.

---

## 🧠 Deep Explanation

### Why not just track max?
Negative × negative = positive. A very negative `curMin` can become the biggest `curMax` when multiplied by the next negative number. We must track both.

### Algorithm:
At each index `i`:
- `curMax = max(nums[i], curMax * nums[i], curMin * nums[i])`
- `curMin = min(nums[i], curMax * nums[i], curMin * nums[i])`
- Update global answer.

(A `0` in the array resets both to `nums[i]`.)

---

## ✅ Ideal Answer
Unlike the maximum subarray sum (Kadane's), products require tracking both extremes since a negative times a negative produces a positive. We maintain both the running max and min and propagate whichever is globally larger.

---

## 💻 Java Code
```java
public class Solution {
    public int maxProduct(int[] nums) {
        int curMax = nums[0], curMin = nums[0], ans = nums[0];
        for (int i = 1; i < nums.length; i++) {
            int tmpMax = Math.max(nums[i], Math.max(curMax * nums[i], curMin * nums[i]));
            curMin = Math.min(nums[i], Math.min(curMax * nums[i], curMin * nums[i]));
            curMax = tmpMax;
            ans = Math.max(ans, curMax);
        }
        return ans;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Max Product of 3 numbers?** (Sort array: either `last3` or `first2 × last` for negative handling.)
2. **What if all numbers are negative?** (The algorithm handles it — you'd pick an even-count subarray.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space.)
