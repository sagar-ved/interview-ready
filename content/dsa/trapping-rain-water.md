---
title: "DSA: Trapping Rain Water"
date: 2024-04-04
draft: false
weight: 73
---

# 🧩 Question: Trapping Rain Water (LeetCode 42)
Given `n` non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.

## 🎯 What the interviewer is testing
- Two Pointers vs. Stack vs. DP.
- Identifying "min(leftMax, rightMax)" relationship.
- Optimizing from $O(N)$ space to $O(1)$ space.

---

## 🧠 Deep Explanation

### The Logic:
The water trapped at any bar `i` is determined by:
- `Water[i] = max(0, min(maxLeftToI, maxRightToI) - elevation[i])`.

### Two-Pointer Strategy ($O(1)$ Space):
1. Keep `left` and `right` pointers at ends.
2. Maintain `leftMax` and `rightMax`.
3. If `leftMax < rightMax`:
   - The bottleneck is on the left.
   - Water trapped at `left` depends on `leftMax`.
   - Update `leftMax`, add water, move `left++`.
4. Else:
   - The bottleneck is on the right.
   - Water trapped at `right` depends on `rightMax`.
   - Update `rightMax`, add water, move `right--`.

---

## ✅ Ideal Answer
To solve Trapping Rain Water efficiently, we must recognize that the water level at any point is constrained by the shorter of the two maximum peaks surrounding it. By using two pointers moving inward, we can track these peaks dynamically, calculating and summing the volume in a single $O(N)$ pass with zero extra space.

---

## 💻 Java Code
```java
public class Solution {
    public int trap(int[] height) {
        if (height == null || height.length == 0) return 0;
        
        int left = 0, right = height.length - 1;
        int leftMax = 0, rightMax = 0;
        int result = 0;
        
        while (left < right) {
            if (height[left] < height[right]) {
                if (height[left] >= leftMax) leftMax = height[left];
                else result += leftMax - height[left];
                left++;
            } else {
                if (height[right] >= rightMax) rightMax = height[right];
                else result += rightMax - height[right];
                right--;
            }
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you use a Monotonic Stack?** (Yes, useful for calculating "horizontal" rectangles of water.)
2. **What is the space complexity of the DP approach?** ($O(N)$ to store `leftMax` and `rightMax` arrays.)
3. **What happens if the array is sorted?** (No water can be trapped.)
