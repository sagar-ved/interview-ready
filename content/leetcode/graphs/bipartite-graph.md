---
title: "LeetCode 785: Is Graph Bipartite?"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: Is Graph Bipartite? (LeetCode 785)
Return `true` if the graph can be colored with exactly 2 colors such that no two adjacent nodes share the same color.

## 🎯 What the interviewer is testing
- Graph coloring via BFS/DFS.
- Detecting odd-length cycles (the root cause of non-bipartiteness).
- Handling disconnected components.

---

## 🧠 Deep Explanation

### Algorithm:
- Use a `color` array: `0` = uncolored, `1` = color A, `-1` = color B.
- For each uncolored node, start a DFS.
- Color starting node `1`. For each neighbor: if uncolored → assign opposite color; if same color as current → **NOT bipartite**.

**Key fact**: A graph is bipartite ↔ it has **no odd-length cycles**.

---

## ✅ Ideal Answer
We attempt a 2-coloring of the graph via DFS. If we ever find two adjacent nodes with the same color, the graph cannot be bipartitioned. We must also ensure all components are checked (disconnected nodes start their own DFS).

---

## 💻 Java Code
```java
public class Solution {
    public boolean isBipartite(int[][] graph) {
        int[] colors = new int[graph.length];
        for (int i = 0; i < graph.length; i++)
            if (colors[i] == 0 && !dfs(graph, colors, i, 1)) return false;
        return true;
    }

    private boolean dfs(int[][] graph, int[] colors, int node, int color) {
        if (colors[node] != 0) return colors[node] == color;
        colors[node] = color;
        for (int neighbor : graph[node])
            if (!dfs(graph, colors, neighbor, -color)) return false;
        return true;
    }
}
```

---

## 🔄 Follow-up Questions
1. **BFS version?** (Use a Queue; assign color to each dequeued node's uncolored neighbors.)
2. **Union-Find approach?** (For each node, union all its neighbors together; if a node ends up in the same component as itself, it's not bipartite.)
3. **Complexity?** ($O(V + E)$.)
