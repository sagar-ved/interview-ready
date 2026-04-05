---
title: "LeetCode 84: Largest Rectangle in Histogram"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 LeetCode 84: Largest Rectangle in Histogram ⭐ (Hard)
Find the area of the largest rectangle that can be formed in a histogram.

## 🎯 What the interviewer is testing
- Monotonic Stack (increasing).
- "Extend left and right" logic.
- Foundation for Maximal Rectangle (LC 85).

---

## 🧠 Deep Explanation

### The Key Insight:
For each bar at index `i`, the rectangle extends left and right as long as bars are **≥ height[i]**.

### Monotonic Stack Approach:
Maintain an **increasing monotonic stack** of indices.
- When we encounter a bar shorter than `stack.top`, pop and calculate area:
  - `height = heights[popped]`
  - `width = i - stack.top - 1` (or `i` if stack is empty — extends to the start)
- Process remaining stack items using `n` as the right boundary.

---

## ✅ Ideal Answer
Each bar is pushed and popped from the stack exactly once. When a bar is popped, it acts as the height of a maximal rectangle that is bounded by the shorter bar that triggered the pop on the right, and whatever is now on top of the stack on the left.

---

## 💻 Java Code
```java
public class Solution {
    public int largestRectangleArea(int[] heights) {
        Deque<Integer> stack = new ArrayDeque<>();
        int maxArea = 0, n = heights.length;
        for (int i = 0; i <= n; i++) {
            int h = (i == n) ? 0 : heights[i];
            while (!stack.isEmpty() && heights[stack.peek()] > h) {
                int height = heights[stack.pop()];
                int width = stack.isEmpty() ? i : i - stack.peek() - 1;
                maxArea = Math.max(maxArea, height * width);
            }
            stack.push(i);
        }
        return maxArea;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Maximal Rectangle (LC 85)?** (Apply this histogram problem to each row of a binary matrix — create a running height array.)
2. **Brute Force?** ($O(N^2)$: for each pair of bars, compute possible area.)
3. **Complexity?** ($O(N)$ time, $O(N)$ stack space.)
