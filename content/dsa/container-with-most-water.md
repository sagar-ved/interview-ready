---
title: "DSA: Container With Most Water"
date: 2024-04-04
draft: false
weight: 55
---

# 🧩 Question: Container With Most Water (LeetCode 11)
You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the `i`th line are `(i, 0)` and `(i, height[i])`. Find two lines that together with the x-axis form a container, such that the container contains the most water.

## 🎯 What the interviewer is testing
- Two Pointers optimization.
- Greedy logic (moving the smaller boundary).
- Area calculation on a 2D plot.

---

## 🧠 Deep Explanation

### Why $O(N^2)$ is too slow:
Checking every possible pair of lines for area calculation.

### $O(N)$ Two-Pointer Strategy:
1. Start with one pointer at the **beginning** and one at the **end**.
2. Calculate area: `min(height[left], height[right]) * (right - left)`.
3. **The Greedy Logic**: To find a larger area, we MUST find a taller line. Since the width is already shrinking, moving the **taller** pointer can't possibly help (if the new line is shorter, area decreases; if it's taller, the `min` is still constrained by the current `short` side).
   - Therefore: **Move the pointer with the smaller height**.
4. Repeat until pointers meet.

---

## ✅ Ideal Answer
To find the maximum area efficiently, we start with the widest possible container and iteratively shrink the width. At each step, we discard the shorter of the two boundaries because it is the current limiting factor; only by finding a potentially taller replacement for the shorter side can we ever increase our calculated area.

---

## 💻 Java Code
```java
public class Solution {
    public int maxArea(int[] height) {
        int left = 0, right = height.length - 1;
        int maxArea = 0;

        while (left < right) {
            int h = Math.min(height[left], height[right]);
            maxArea = Math.max(maxArea, h * (right - left));
            
            if (height[left] < height[right]) {
                left++;
            } else {
                right--;
            }
        }
        return maxArea;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can we move both pointers if they are equal?** (Yes, it doesn't hurt.)
2. **Trapping Rain Water vs this?** (Trapping involves multiple "valleys", this is just one container.)
3. **What is the complexity?** ($O(N)$ time, $O(1)$ space.)
