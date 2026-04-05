---
title: "DSA: Maximum Product Subarray"
date: 2024-04-04
draft: false
weight: 77
---

# 🧩 Question: Maximum Product Subarray (LeetCode 152)
Given an integer array `nums`, find a contiguous non-empty subarray that has the largest product and return the product.

## 🎯 What the interviewer is testing
- Tracking multiple DP states (Max and Min).
- Handling negative numbers (which flip min to max).
- Zero as a reset condition.

---

## 🧠 Deep Explanation

### The Challenge:
Unlike "Maximum Sum Subarray" (Kadane's), where we only care about the max, here a **negative number** can turn a very small (negative) product into a very large (positive) one.

### The Solution:
At each index, track both:
1. `current_max`: The best positive product ending here.
2. `current_min`: The most negative product ending here (waiting for another negative!).

When `nums[i]` is negative, swap `current_max` and `current_min` before multiplying.

---

## ✅ Ideal Answer
To maximize a product subarray, we must account for the fact that two negative values multiply to a positive. We maintain two running products—one for the current maximum and another for the minimum. By swapping these values whenever we encounter a negative number, we capture the potential for a large negative value to suddenly become our global maximum.

---

## 💻 Java Code
```java
public class Solution {
    public int maxProduct(int[] nums) {
        if (nums == null || nums.length == 0) return 0;
        
        int res = nums[0];
        int max = res, min = res;
        
        for (int i = 1; i < nums.length; i++) {
            if (nums[i] < 0) {
                int temp = max;
                max = min;
                min = temp;
            }
            
            max = Math.max(nums[i], max * nums[i]);
            min = Math.min(nums[i], min * nums[i]);
            res = Math.max(res, max);
        }
        return res;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What happens if there's a 0?** (Both `max` and `min` become 0; the logic effectively "restarts" from the next number.)
2. **Complexity?** ($O(N)$ time, $O(1)$ space.)
3. **Comparison to maximum sum?** (Sum only needs one state because adding a negative always decreases the total.)
