---
author: "sagar ved"
title: "LeetCode 684 & 685: Redundant Connection"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 LeetCode 684: Redundant Connection (Medium)
Given a tree with `n` nodes plus one extra edge, return the redundant edge that creates a cycle.

## 🎯 What the interviewer is testing
- Union-Find (Disjoint Set Union) pattern.
- Detecting when two nodes are already connected.
- Path compression + Union by Rank for efficiency.

---

## 🧠 Deep Explanation

### Union-Find:
- Initialize each node as its own parent.
- For each edge `(u, v)`:
  - `find(u)` and `find(v)`.
  - If they have the same root → **this edge creates a cycle** → return it.
  - Otherwise, `union(u, v)`.

### Path Compression + Union by Rank:
- `find()` with path compression: `parent[x] = find(parent[x])`.
- `union()` by rank: attach smaller tree under larger root.
- Both operations become nearly $O(1)$ amortized.

---

## ✅ Ideal Answer
Union-Find is the ideal data structure for detecting when adding an edge would create a cycle. Processing edges one at a time, we check connectivity before merging — if two nodes are already in the same component, the current edge is redundant.

---

## 💻 Java Code
```java
public class Solution {
    int[] parent, rank;

    public int[] findRedundantConnection(int[][] edges) {
        int n = edges.length;
        parent = new int[n + 1]; rank = new int[n + 1];
        for (int i = 1; i <= n; i++) parent[i] = i;
        for (int[] e : edges) {
            if (find(e[0]) == find(e[1])) return e;
            union(e[0], e[1]);
        }
        return new int[]{};
    }

    int find(int x) { return parent[x] == x ? x : (parent[x] = find(parent[x])); }

    void union(int x, int y) {
        int px = find(x), py = find(y);
        if (rank[px] < rank[py]) parent[px] = py;
        else if (rank[px] > rank[py]) parent[py] = px;
        else { parent[py] = px; rank[px]++; }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Redundant Connection II (Directed Graph)?** (LeetCode 685: Must detect both "two parents" AND "cycle" cases — significantly more complex.)
2. **Union-Find vs DFS for cycle detection?** (Union-Find: $O(\alpha(N))$ per edge — faster. DFS: $O(V+E)$ — easier to implement.)
3. **What other problems use Union-Find?** (Number of Islands, Accounts Merge, Making a Large Island.)
