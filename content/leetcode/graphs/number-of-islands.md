---
title: "LeetCode 200: Number of Islands"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Number of Islands (LeetCode 200)
Given an `m x n` 2D binary grid where '1' = land and '0' = water, return the number of islands.

## 🎯 What the interviewer is testing
- Basic graph traversal (DFS/BFS).
- In-place state marking.
- Union-Find alternative approach.

---

## 🧠 Deep Explanation

### DFS Approach:
When we hit land ('1'), start a DFS to visit all connected land and mark it as '0' (sunk). Each DFS initiation = one island.

### Union-Find Approach:
Every land cell is its own component. Union adjacent land cells. Result = number of distinct components.

---

## ✅ Ideal Answer
We iterate the grid. On finding a '1', we increment the island count and use DFS to sink (mark '0') all connected land, preventing re-counting. Time: $O(M \cdot N)$. Space: $O(M \cdot N)$ recursion stack in worst case.

---

## 💻 Java Code
```java
public class Solution {
    public int numIslands(char[][] grid) {
        int count = 0;
        for (int i = 0; i < grid.length; i++)
            for (int j = 0; j < grid[0].length; j++)
                if (grid[i][j] == '1') { count++; sink(grid, i, j); }
        return count;
    }

    private void sink(char[][] grid, int i, int j) {
        if (i < 0 || j < 0 || i >= grid.length || j >= grid[0].length || grid[i][j] == '0') return;
        grid[i][j] = '0';
        sink(grid, i+1, j); sink(grid, i-1, j);
        sink(grid, i, j+1); sink(grid, i, j-1);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Space complexity?** ($O(M \cdot N)$ worst-case recursion for a single huge island.)
2. **Number of distinct islands?** (LeetCode 694: Store island "shape" as a path string in a Set.)
3. **Island Perimeter?** (Each '1' has 4 sides; subtract 2 for each adjacent pair.)
