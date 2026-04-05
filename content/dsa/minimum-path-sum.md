---
title: "DSA: Minimum Path Sum"
date: 2024-04-04
draft: false
weight: 63
---

# 🧩 Question: Minimum Path Sum (LeetCode 64)
Given a `m x n` grid filled with non-negative numbers, find a path from top left to bottom right, which minimizes the sum of all numbers along its path. You can only move either down or right at any point in time.

## 🎯 What the interviewer is testing
- Grid-based DP optimization.
- Accumulative state management.
- Modifying the input grid in-place (if allowed).

---

## 🧠 Deep Explanation

### The Logic:
To reach grid point `(i, j)`, you could only have come from `(i-1, j)` (above) or `(i, j-1)` (left).
- `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])`.

### Base cases:
1. Top row: Only reachable from the left.
2. Leftmost column: Only reachable from above.

### Space Optimization:
You can overwrite the `grid` itself if allowed. If not, use one 1D row of $O(N)$ space.

---

## ✅ Ideal Answer
For grid path minimization, we apply Dynamic Programming where each cell's value is updated to represent the minimal cost to reach that point. We iterate row by row, adding the smaller of the two possible preceding costs. This ensures an optimal global path in $O(M \cdot N)$ time.

---

## 💻 Java Code: In-place DP
```java
public class Solution {
    public int minPathSum(int[][] grid) {
        int m = grid.length, n = grid[0].length;

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j == 0) continue;
                if (i == 0) {
                    grid[i][j] += grid[i][j - 1];
                } else if (j == 0) {
                    grid[i][j] += grid[i - 1][j];
                } else {
                    grid[i][j] += Math.min(grid[i - 1][j], grid[i][j - 1]);
                }
            }
        }
        return grid[m - 1][n - 1];
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if negative numbers are allowed?** (DP still works, but Dijkstra's might be relevant if it was a general graph.)
2. **What if obstacles are present?** (LeetCode 63: Unique Paths II.)
3. **What is the space complexity?** ($O(1)$ if modifying in-place; $O(M \cdot N)$ for full DP matrix.)
