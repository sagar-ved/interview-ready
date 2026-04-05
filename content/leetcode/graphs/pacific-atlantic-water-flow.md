---
title: "LeetCode 417: Pacific Atlantic Water Flow"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 LeetCode 417: Pacific Atlantic Water Flow (Medium)
Find all cells from which water can flow to **both** the Pacific and Atlantic oceans. Water flows from high to equal or lower height.

## 🎯 What the interviewer is testing
- Multi-source BFS/DFS.
- Reverse thinking (flow from ocean inward instead of outward).
- Intersection of two reachability sets.

---

## 🧠 Deep Explanation

### Naive Approach: $O((M \cdot N)^2)$
For each cell, run DFS outward to check if both oceans are reachable.

### Optimal: Reverse BFS from Oceans — $O(M \cdot N)$
**Key insight**: Instead of checking if water flows FROM cell TO ocean, ask: can water flow FROM ocean TO cell (going uphill)?

1. Multi-source BFS from all **Pacific border** cells → mark all cells reachable from Pacific.
2. Multi-source BFS from all **Atlantic border** cells → mark all cells reachable from Atlantic.
3. Return intersection: cells reachable from **both**.

BFS moves to neighbors with height `>=` current (going uphill, since we reversed direction).

---

## ✅ Ideal Answer
By reversing the direction — starting BFS from the ocean borders and traveling uphill — we convert what was an $O(N^2)$ multi-source problem into two $O(M \cdot N)$ BFS runs. The intersection gives us all valid cells in linear time.

---

## 💻 Java Code
```java
public class Solution {
    public List<List<Integer>> pacificAtlantic(int[][] heights) {
        int m = heights.length, n = heights[0].length;
        boolean[][] pac = new boolean[m][n], atl = new boolean[m][n];
        Queue<int[]> pq = new LinkedList<>(), aq = new LinkedList<>();
        for (int i = 0; i < m; i++) { pq.offer(new int[]{i,0}); pac[i][0]=true; aq.offer(new int[]{i,n-1}); atl[i][n-1]=true; }
        for (int j = 0; j < n; j++) { pq.offer(new int[]{0,j}); pac[0][j]=true; aq.offer(new int[]{m-1,j}); atl[m-1][j]=true; }
        bfs(heights, pq, pac); bfs(heights, aq, atl);
        List<List<Integer>> res = new ArrayList<>();
        for (int i = 0; i < m; i++) for (int j = 0; j < n; j++) if (pac[i][j] && atl[i][j]) res.add(List.of(i, j));
        return res;
    }

    private void bfs(int[][] h, Queue<int[]> q, boolean[][] vis) {
        int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};
        while (!q.isEmpty()) {
            int[] c = q.poll();
            for (int[] d : dirs) {
                int r = c[0]+d[0], col = c[1]+d[1];
                if (r<0||r>=h.length||col<0||col>=h[0].length||vis[r][col]||h[r][col]<h[c[0]][c[1]]) continue;
                vis[r][col] = true; q.offer(new int[]{r, col});
            }
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Why BFS over DFS here?** (Both work — BFS is often more predictable for multi-source patterns.)
2. **What if we add a third ocean?** (Add a third `visited` array — same pattern extends naturally.)
3. **Complexity?** ($O(M \cdot N)$ time and space.)
