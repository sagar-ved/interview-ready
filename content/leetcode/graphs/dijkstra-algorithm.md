---
title: "Dijkstra's Shortest Path Algorithm"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Dijkstra's Algorithm: Single-Source Shortest Path ⭐
Find the shortest path from a source node to all other nodes in a weighted directed graph with **non-negative** edges.

## 🎯 What the interviewer is testing
- Min-Heap priority queue for greedy selection.
- Relaxation: updating shortest known distance.
- Why it fails for negative edges.

---

## 🧠 Deep Explanation

### The Algorithm:
1. `dist[source] = 0`, all others = `∞`.
2. Min-Heap stores `(distance, nodeId)`.
3. Poll the smallest distance node `u`.
4. Skip if `polled dist > dist[u]` (stale entry).
5. **Relax**: for each neighbor `v`: if `dist[u] + w < dist[v]`, update and push to heap.

**Why greedy works**: With non-negative weights, once a node is popped with the minimum distance, that distance is finalized.

### Complexity: $O((V + E) \log V)$

---

## ✅ Ideal Answer
Dijkstra works by greedily visiting the nearest node first. The "stale check" (`polled > dist[u]`) is critical for performance — without it we'd reprocess outdated heap entries. It cannot handle negative edges because a later-found negative path might improve an already-finalized distance.

---

## 💻 Java Code
```java
public int[] dijkstra(int n, List<int[]>[] adj, int src) {
    int[] dist = new int[n];
    Arrays.fill(dist, Integer.MAX_VALUE);
    dist[src] = 0;
    PriorityQueue<int[]> pq = new PriorityQueue<>(Comparator.comparingInt(a -> a[0]));
    pq.offer(new int[]{0, src});
    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int d = curr[0], u = curr[1];
        if (d > dist[u]) continue; // stale
        for (int[] edge : adj[u]) {
            int v = edge[0], w = edge[1];
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                pq.offer(new int[]{dist[v], v});
            }
        }
    }
    return dist;
}
```

---

## 🔄 Follow-up Questions
1. **Negative edges?** (Use Bellman-Ford — $O(V \cdot E)$.)
2. **Negative cycles?** (Detect with Bellman-Ford by checking if any distance keeps decreasing after V-1 passes.)
3. **A* vs Dijkstra?** (A* adds a heuristic to guide toward the target — faster but not always optimal without admissible heuristics.)
