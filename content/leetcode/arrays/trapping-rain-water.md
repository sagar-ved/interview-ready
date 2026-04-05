---
title: "LeetCode 42: Trapping Rain Water"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 LeetCode 42: Trapping Rain Water ⭐ (Hard)
Given `n` non-negative integers representing an elevation map, compute how much water it can trap after raining.

## 🎯 What the interviewer is testing
- Two-pointer greedy logic.
- Prefix/Suffix max array approach.
- Monotonic stack alternative.

---

## 🧠 Deep Explanation

### Approach 1: Prefix/Suffix Arrays — $O(N)$ space
At each index `i`, water trapped = `min(maxLeft[i], maxRight[i]) - height[i]`.
- Build `maxLeft[]` from left.
- Build `maxRight[]` from right.
- Sum it up.

### Approach 2: Two Pointers — $O(1)$ space (Optimal)
- `left` and `right` pointers from both ends.
- Track `leftMax` and `rightMax`.
- If `leftMax < rightMax`: process `left` side (water = `leftMax - height[left]`), move `left++`.
- Else: process `right` side, move `right--`.

**Why?** When `leftMax < rightMax`, the water at the left pointer is bounded by `leftMax` regardless of what's on the right.

---

## ✅ Ideal Answer
Water at any index is bounded by the shorter of its maximum left and right walls. The two-pointer approach avoids building the prefix arrays explicitly by observing that whichever side has the smaller max is the "binding constraint."

---

## 💻 Java Code (Two Pointers)
```java
public class Solution {
    public int trap(int[] height) {
        int left = 0, right = height.length - 1;
        int leftMax = 0, rightMax = 0, water = 0;
        while (left < right) {
            if (height[left] < height[right]) {
                if (height[left] >= leftMax) leftMax = height[left];
                else water += leftMax - height[left];
                left++;
            } else {
                if (height[right] >= rightMax) rightMax = height[right];
                else water += rightMax - height[right];
                right--;
            }
        }
        return water;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Monotonic stack approach?** (Process bars and calculate water in "valleys" as each taller bar is found.)
2. **Trapping Rain Water II (3D)?** (LeetCode 407: Use a Min-Heap of boundary cells — BFS from edges inward.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space for two-pointer.)
