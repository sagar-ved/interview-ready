---
title: "DSA: Longest Increasing Path in a Matrix"
date: 2024-04-04
draft: false
weight: 100
---

# 🧩 Question: Longest Increasing Path in a Matrix (LeetCode 329 - Hard)
Given an `m x n` integers matrix, return the length of the longest increasing path in the matrix. You can move in four directions (up, down, left, right).

## 🎯 What the interviewer is testing
- DFS with Memoization.
- Identifying Directed Acyclic Graph (DAG) properties in a grid.
- Avoiding redundant path calculations.

---

## 🧠 Deep Explanation

### The Logic:
Since the path must be **strictly increasing**, there are NO CYCLES in our traversal. This means every cell part of an increasing path is a node in a DAG.

### Algorithm:
1. For each cell `(i, j)`, perform a DFS to find the longest path starting there.
2. **Memoization**: Store the result for each cell in a `memo[m][n]` table. 
   - If `memo[i][j] != 0`, return the stored value immediately.
3. The result for `(i, j)` is `1 + max(LIP of neighbors with larger values)`.
4. Loop through ALL cells as potential starting points and track the global maximum.

---

## ✅ Ideal Answer
To find the longest increasing path, we treat the matrix as a directed acyclic graph where edges only exist between strictly increasing neighbors. By applying depth-first search with memoization, we ensure that the longest path from any specific cell is only calculated once. This reduces a potentially exponential brute-force search into a highly efficient $O(M \cdot N)$ exploration, perfectly balancing depth and breadth in the grid.

---

## 💻 Java Code
```java
public class Solution {
    private int[][] memo;
    private int[][] dirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};

    public int longestIncreasingPath(int[][] matrix) {
        if (matrix == null || matrix.length == 0) return 0;
        int m = matrix.length, n = matrix[0].length;
        memo = new int[m][n];
        int max = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                max = Math.max(max, dfs(matrix, i, j, m, n));
            }
        }
        return max;
    }

    private int dfs(int[][] matrix, int i, int j, int m, int n) {
        if (memo[i][j] != 0) return memo[i][j];
        int max = 1;
        for (int[] d : dirs) {
            int x = i + d[0], y = j + d[1];
            if (x >= 0 && x < m && y >= 0 && y < n && matrix[x][y] > matrix[i][j]) {
                max = Math.max(max, 1 + dfs(matrix, x, y, m, n));
            }
        }
        return memo[i][j] = max;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you use Topological Sort?** (Yes, calculate indegrees for every cell where `indegree` is the number of neighbors strictly smaller. Perform Kahn's algorithm; the number of layers in the sort is the longest path.)
2. **Complexity?** ($O(M \cdot N)$ time and space.)
3. **What if it was "Increasing or Equal"?** (Cycles would be possible, so the DAG property is lost, and the problem becomes much harder [or impossible without a visited set].)
