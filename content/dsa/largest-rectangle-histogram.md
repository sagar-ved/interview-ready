---
title: "DSA: Largest Rectangle in Histogram"
date: 2024-04-04
draft: false
weight: 94
---

# 🧩 Question: Largest Rectangle in Histogram (LeetCode 84 - Hard)
Given an array of integers `heights` representing the histogram's bar height where the width of each bar is 1, find the area of the largest rectangle in the histogram.

## 🎯 What the interviewer is testing
- Monotonic Stack application.
- One-pass logic with immediate state-clearing.
- Determining the "range" each bar is the minimum for.

---

## 🧠 Deep Explanation

### The Logic:
For any bar `i`, the largest rectangle containing that bar's full height `H` is bounded by the first bar to its left and right that is **shorter** than `H`.

### The Monotonic Stack Strategy:
1. Maintain a stack of indices such that heights are **increasing**.
2. For each new height `h`:
   - If `h` is shorter than the stack's top height, it means we found the **right boundary** for the stack's top.
   - Pop from the stack. The rectangle's height is the popped height.
   - The width is `(current_index - new_stack_top - 1)`.
3. Add a "dummy" 0 height at the end to flush the stack.

---

## ✅ Ideal Answer
To find the maximal histogram area in linear time, we focus on identifying the widest possible range for every bar where it remains the bottleneck. By utilizing an increasing monotonic stack, we can determine each bar's left and right boundaries in a single $O(N)$ pass. The moment a shorter bar is encountered, we compute the area for the preceding "峰" (peaks) at the stack's top, ensuring every possible rectangle is evaluated efficiently.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int largestRectangleArea(int[] heights) {
        Stack<Integer> s = new Stack<>();
        int maxArea = 0;
        int n = heights.length;
        
        for (int i = 0; i <= n; i++) {
            int h = (i == n) ? 0 : heights[i];
            while (!s.isEmpty() && heights[s.peek()] >= h) {
                int height = heights[s.pop()];
                int width = s.isEmpty() ? i : i - s.peek() - 1;
                maxArea = Math.max(maxArea, height * width);
            }
            s.push(i);
        }
        return maxArea;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Maximal Rectangle?** (LeetCode 85: 2D version—each row is a histogram base for the ones above. Reduces to this problem.)
2. **Space complexity?** ($O(N)$ for the stack.)
3. **What happens if heights are in increasing order?** (The stack stays filled until the trailing "0" triggers the area calculations.)
