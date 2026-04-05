---
title: "DSA: Number of Islands"
date: 2024-04-04
draft: false
weight: 33
---

# 🧩 Question: Number of Islands (LeetCode 200)
Given an `m x n` 2D binary grid `grid` which represents a map of '1's (land) and '0's (water), return the number of islands. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically.

## 🎯 What the interviewer is testing
- Basic graph traversal (DFS/BFS).
- Managing state on a 2D grid.
- Modifying data in-place vs using extra space.

---

## 🧠 Deep Explanation

### Approaches:
1. **DFS (Recursive)**:
   - When we hit land ('1'), start a DFS to visit all connected land.
   - Mark visited land as '0' (water) to avoid re-counting.
   - Count the number of times we start a brand-new DFS.
2. **BFS (Queue-based)**:
   - Same logic but uses a Queue.
3. **Union Find**:
   - Every land cell is initially its own component.
   - Union adjacent land cells.
   - Result is the number of distinct components.

**Inplace vs Extra Space**: 
Changing '1' to '0' on the grid saves $O(M \cdot N)$ space for a `visited` matrix, but you should always ask if you're allowed to modify the input!

---

## ✅ Ideal Answer
To find islands, we iterate through every cell in the grid. If we encounter a '1', it marks the start of a new island. We then use DFS to "sink" the entire island by recursively visiting all its neighbors and marking them as '0'. Each time we start this DFS, we increment our island count.

---

## 💻 Java Code: DFS
```java
public class Solution {
    public int numIslands(char[][] grid) {
        if (grid == null || grid.length == 0) return 0;
        int count = 0;
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                if (grid[i][j] == '1') {
                    count++;
                    sinkIsland(grid, i, j);
                }
            }
        }
        return count;
    }

    private void sinkIsland(char[][] grid, int i, int j) {
        if (i < 0 || j < 0 || i >= grid.length || j >= grid[0].length || grid[i][j] == '0') {
            return;
        }
        grid[i][j] = '0'; // Sink it
        sinkIsland(grid, i + 1, j);
        sinkIsland(grid, i - 1, j);
        sinkIsland(grid, i, j + 1);
        sinkIsland(grid, i, j - 1);
    }
}
```

---

## ⚠️ Common Mistakes
- Not checking grid boundaries in the DFS.
- Not sinking neighbors (only sinking the first cell).
- Not iterating through the entire grid.

---

## 🔄 Follow-up Questions
1. **What is the space complexity?** ($O(M \cdot N)$ in worst-case recursion stack [like a single huge island].)
2. **How to solve if the grid is huge?** (Parallelize by processing different regions and using Union Find to merge the edges.)
3. **Number of distinct islands?** (LeetCode 694: Store the "shape" of the island as a path string in a Set.)
4. **Island Perimeter?** (Each '1' has 4 sides; subtract 2 for each adjacent pair.)
