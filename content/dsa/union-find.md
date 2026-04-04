---
title: "Union-Find (Disjoint Set Union)"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: Given a list of network cables connecting computers, determine the minimum number of cables to add so all computers are connected. Also, detect if a network has a redundant (cycle-forming) connection.

## 🎯 What the interviewer is testing
- Union-Find (DSU) data structure
- Path compression and union by rank
- Spanning tree problems (Kruskal's MST)
- Cycle detection in undirected graphs

---

## 🧠 Deep Explanation

### 1. Union-Find Core Operations

**find(x)**: Find the root representative of the set containing x.
**union(x, y)**: Merge the sets containing x and y.

**Naive implementation**: Arrays with root tracking → O(n) per operation for tall trees.

**Optimizations**:
1. **Union by Rank/Size**: Always attach smaller tree under larger. Keeps tree height O(log n).
2. **Path Compression**: During `find()`, make every node point directly to the root. Amortizes to nearly O(1) per operation.

Combined: **O(α(n))** per operation — inverse Ackermann function, effectively O(1).

### 2. Connected Components Count

Initially: n components (all separate).
For each edge (u, v): `if find(u) != find(v)` → `union(u, v)` → componentCount--.

Minimum cables to connect all: `componentCount - 1` (minimum spanning tree edges).

### 3. Cycle Detection

If `find(u) == find(v)` when processing edge (u, v) → **cycle detected** (they're already connected).

### 4. Kruskal's MST

Sort edges by weight. Process sorted edges:
- If endpoints in different sets → add to MST
- Else → skip (would form cycle)

Result: Minimum Spanning Tree with `n-1` edges.

---

## 💻 Java Code

```java
public class UnionFind {

    private final int[] parent;
    private final int[] rank;
    private int components;

    public UnionFind(int n) {
        parent = new int[n];
        rank = new int[n];
        components = n;
        for (int i = 0; i < n; i++) parent[i] = i; // Each node is its own root
    }

    // Find with path compression — O(α(n))
    public int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]); // Path compression: make x point to root
        }
        return parent[x];
    }

    // Union by rank — O(α(n))
    public boolean union(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX == rootY) return false; // Already connected — adding this edge creates a cycle

        // Attach smaller tree under larger tree
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++; // Same rank: increase rank of new root
        }
        components--;
        return true; // Merged two distinct components
    }

    public boolean connected(int x, int y) {
        return find(x) == find(y);
    }

    public int getComponents() { return components; }

    // ====== Application 1: Minimum Cables to Connect All Computers ======
    public static int minimumCables(int n, int[][] cables) {
        UnionFind uf = new UnionFind(n);
        for (int[] cable : cables) {
            uf.union(cable[0], cable[1]);
        }
        return uf.getComponents() - 1; // Need (components - 1) more cables
    }

    // ====== Application 2: Find Redundant Connection (Detect Cycle) ======
    public static int[] findRedundantConnection(int[][] edges) {
        int n = edges.length;
        UnionFind uf = new UnionFind(n + 1); // 1-indexed nodes

        for (int[] edge : edges) {
            if (!uf.union(edge[0], edge[1])) {
                return edge; // This edge forms a cycle — it's redundant
            }
        }
        return new int[0]; // Should never reach here
    }

    // ====== Application 3: Kruskal's MST ======
    public static int kruskalMST(int n, int[][] edges) {
        // Sort edges by weight
        java.util.Arrays.sort(edges, java.util.Comparator.comparingInt(e -> e[2]));

        UnionFind uf = new UnionFind(n);
        int totalCost = 0, edgesUsed = 0;

        for (int[] edge : edges) {
            if (uf.union(edge[0], edge[1])) {
                totalCost += edge[2]; // edge[2] = weight
                edgesUsed++;
                if (edgesUsed == n - 1) break; // MST complete
            }
        }
        return uf.getComponents() == 1 ? totalCost : -1; // -1 if graph not connected
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting path compression → O(n) per find instead of O(α(n))
- Using union by rank incorrectly (only increase rank when ranks are equal)
- Initializing parent array without setting `parent[i] = i` → null starts cause incorrect finds
- Not checking `find(u) == find(v)` before union — without the check, you don't detect cycles

---

## 🔄 Follow-up Questions
1. **How does Prim's MST differ from Kruskal's?** (Prim's grows the MST from a starting node — O(E log V) with priority queue. Kruskal's sorts all edges globally — O(E log E). Kruskal's better for sparse graphs.)
2. **How would you handle dynamic connectivity (edges added/removed)?** (Link-Cut Trees support O(log n) dynamic connectivity — complex but correct. In practice, offline algorithms are preferred.)
3. **What is the time complexity of DSU with both optimizations?** (O(α(n)) per operation — inverse Ackermann, effectively O(1) for any practical n.)
