---
title: "DSA: Minimum Knight Moves"
date: 2024-04-04
draft: false
weight: 90
---

# 🧩 Question: Minimum Knight Moves (LeetCode 1197 - Hard)
Find the minimum moves for a knight to reach `(x, y)` on an infinite chessboard.

## 🎯 What the interviewer is testing
- Shortest path in a graph (BFS).
- Symmetry optimization (reducing the search space).
- Memoization for repeated coordinates.

---

## 🧠 Deep Explanation

### The Logic (BFS):
Since an infinite board is huge, standard BFS will be slow.
1. **Symmetry**: `(x, y)` is the same as `(|x|, |y|)`. We only need to search one quadrant.
2. **Move Optimization**:
   - `x + 2, y + 1`, `x + 1, y + 2`... (8 total moves).
3. **The Trap**: Even if `(x, y)` is in the first quadrant, the knight might briefly hop into a negative zone to find a faster route. We should include a small buffer (e.g., `-2` to `302`).

---

## ✅ Ideal Answer
To find the shortest path for a knight, we use Breadth-First Search to explore neighbors layer by layer. By utilizing coordinate symmetry and mapping coordinates to an absolute-value space, we drastically reduce our search perimeter. For large targets, combining BFS with memoization ensures we never double-process a state, achieving the optimal move count in polynomial time.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int minKnightMoves(int x, int y) {
        x = Math.abs(x); y = Math.abs(y);
        Queue<int[]> queue = new LinkedList<>();
        queue.add(new int[]{0, 0, 0});
        
        Set<String> visited = new HashSet<>();
        visited.add("0,0");
        
        int[][] dirs = {{2, 1}, {2, -1}, {1, 2}, {1, -2}, {-2, 1}, {-2, -1}, {-1, 2}, {-1, -2}};
        
        while (!queue.isEmpty()) {
            int[] curr = queue.poll();
            if (curr[0] == x && curr[1] == y) return curr[2];
            
            for (int[] d : dirs) {
                int nx = curr[0] + d[0], ny = curr[1] + d[1];
                if (!visited.contains(nx + "," + ny) && nx >= -2 && ny >= -2) {
                    visited.add(nx + "," + ny);
                    queue.add(new int[]{nx, ny, curr[2] + 1});
                }
            }
        }
        return -1;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Bidirectional BFS?** (Can be much faster for deep targets; search from both `(0,0)` and `(x,y)` until they meet.)
2. **Complexity?** ($O(X \cdot Y)$ for reachability.)
3. **Can you use Math?** (There are specific mathematical formulas for knight moves, but rare for coding interviews.)
