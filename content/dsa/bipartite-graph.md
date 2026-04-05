---
title: "DSA: Bipartite Graph / Graph Coloring"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: Is Graph Bipartite? (LeetCode 785)
There is an undirected graph with `n` nodes, where each node is numbered between `0` and `n - 1`. You are given a 2D array `graph`, where `graph[u]` is an array of nodes that node `u` is adjacent to. Return `true` if it is bipartite.

## 🎯 What the interviewer is testing
- Graph traversal (BFS/DFS).
- Node coloring concept.
- Ability to detect odd-length cycles.

---

## 🧠 Deep Explanation
A bipartite graph is a graph whose vertices can be divided into two independent sets $U$ and $V$ such that every edge $(u, v)$ connects a vertex from $U$ to one from $V$.

### Algorithm:
- Use a `color` array: `0` (uncolored), `1` (color 1), `-1` (color 2).
- For each uncolored node, start a BFS/DFS.
- Color the starting node with `1`.
- For each neighbor:
  - If uncolored, color it with opposite color (`-color[current]`).
  - If already colored with the **same** color, the graph is NOT bipartite.

A graph is bipartite if and only if it **does not contain an odd-length cycle**.

---

## ✅ Ideal Answer
We can determine if a graph is bipartite by attempting to color it with two colors such that no two adjacent nodes have the same color. If we encounter a contradiction while traversing (a node connected to another of the same color), the graph is not bipartite.

---

## 💻 Java Code
```java
public class Solution {
    public boolean isBipartite(int[][] graph) {
        int n = graph.length;
        int[] colors = new int[n]; // 0: uncolored, 1: red, -1: blue
        
        for (int i = 0; i < n; i++) {
            if (colors[i] == 0 && !validColor(graph, colors, i, 1)) {
                return false;
            }
        }
        return true;
    }

    private boolean validColor(int[][] graph, int[] colors, int node, int color) {
        if (colors[node] != 0) {
            return colors[node] == color;
        }
        
        colors[node] = color;
        for (int neighbor : graph[node]) {
            if (!validColor(graph, colors, neighbor, -color)) {
                return false;
            }
        }
        return true;
    }
}
```

---

## ⚠️ Common Mistakes
- Not handling disconnected components (must loop through all nodes in the outer layer).
- Forgetting that uncolored nodes started from separate components should also be colored.

---

## 🔄 Follow-up Questions
1. **How to find the number of ways to color a graph with $K$ colors?** (Backtracking problem.)
2. **What is the 2-Colorable problem?** (Same as Bipartite check.)
3. **Can you solve it iteratively?** (Yes, using a Queue and standard BFS BFS logic.)
