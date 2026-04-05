---
title: "DSA: Maximal Rectangle"
date: 2024-04-04
draft: false
weight: 99
---

# 🧩 Question: Maximal Rectangle (LeetCode 85 - Hard)
Given a rows x cols binary matrix filled with 0s and 1s, find the largest rectangle containing only 1s and return its area.

## 🎯 What the interviewer is testing
- Mapping a 2D problem to a 1D subproblem.
- Re-using complex logic (Histogram).
- Dynamic Programming for building state.

---

## 🧠 Deep Explanation

### The Logic:
This problem is just "Largest Rectangle in Histogram" applied to **every row**.

1. Imagine each row of the matrix as the base of a histogram.
2. For Row 0: Heights are `[1, 0, 1, 1...]`
3. For Row 1: 
   - If `matrix[1][j] == 1`, `height[j] = prev_height[j] + 1`.
   - If `matrix[1][j] == 0`, `height[j] = 0` (The bar is broken).
4. For every row, calculate the "Largest Rectangle in Histogram" using the current heights array.

### Complexity:
- Time: $O(M \cdot N)$ (Process each row once).
- Space: $O(N)$ (To store the current heights array).

---

## ✅ Ideal Answer
To find the maximal 1-filled rectangle in a grid, we treat each row as the horizontal basis of a collection of histograms. By dynamically building the bar heights as we move down the matrix, we can repeatedly apply the $O(N)$ monotonic stack algorithm to every row. This reduces a potentially exponential 2D search into a linear-time sequence of 1D histogram evaluations, effectively finding the global maximum in $O(M \cdot N)$ time.

---

## 💻 Java Code
```java
public class Solution {
    public int maximalRectangle(char[][] matrix) {
        if (matrix.length == 0) return 0;
        int[] heights = new int[matrix[0].length];
        int maxArea = 0;
        
        for (char[] row : matrix) {
            for (int i = 0; i < row.length; i++) {
                if (row[i] == '1') heights[i]++;
                else heights[i] = 0;
            }
            maxArea = Math.max(maxArea, largestInHistogram(heights));
        }
        return maxArea;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you solve it without the Histogram logic?** (Yes, with 3 DP arrays `left`, `right`, `height`, but it is much more complex to visualize and explain.)
2. **What if the grid is very sparse?** (The monotonic stack approach remains $O(M \cdot N)$ regardles of sparsity.)
3. **Wait time?** (This is a "Hard" problem because it requires connecting two distinct algorithmic concepts [DP + Stack].)
