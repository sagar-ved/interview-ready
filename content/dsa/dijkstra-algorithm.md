---
title: "DSA: Dijkstra's Algorithm Detailed"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: Dijkstra's Shortest Path
Design an algorithm to find the shortest path from a source node to all other nodes in a directed graph with non-negative edge weights.

## 🎯 What the interviewer is testing
- Familiarity with Priority Queues.
- Understanding of "Greedy" relaxation.
- Time complexity analysis of graph algorithms.

---

## 🧠 Deep Explanation
Dijkstra's finds the shortest path by maintaining a set of "visited" nodes and a "min-distance" array.

### Steps:
1. Initialize `dist[]` to infinity, `dist[source] = 0`.
2. Use a `Min-PriorityQueue` to store nodes as `(distance, nodeID)`.
3. Pop the node `u` with the smallest `dist`.
4. **Relaxation**: For each neighbor `v` of `u`:
   - If `dist[u] + weight(u, v) < dist[v]`:
     - Update `dist[v]`.
     - Push `(dist[v], v)` to the PriorityQueue.
5. Repeat until the queue is empty.

**Complexity**: $O((E+V) \log V)$ using a binary heap.

---

## ✅ Ideal Answer
Dijkstra's is a greedy algorithm that always visits the "nearest" unvisited node. It only works for non-negative weights because it assumes that as we move away from the source, distances only increase. If edges could be negative, this assumption fails, and Bellman-Ford should be used.

---

## 💻 Java Code
```java
import java.util.*;

public class Dijkstra {
    static class Node implements Comparable<Node> {
        int id, distance;
        Node(int id, int d) { this.id = id; this.distance = d; }
        public int compareTo(Node o) { return Integer.compare(this.distance, o.distance); }
    }

    public int[] dijkstra(int n, List<int[]>[] adj, int source) {
        int[] dist = new int[n];
        Arrays.fill(dist, Integer.MAX_VALUE);
        dist[source] = 0;

        PriorityQueue<Node> pq = new PriorityQueue<>();
        pq.offer(new Node(source, 0));

        while (!pq.isEmpty()) {
            Node curr = pq.poll();
            int u = curr.id;

            if (curr.distance > dist[u]) continue; // Optimization: Skip stale values

            for (int[] edge : adj[u]) {
                int v = edge[0];
                int weight = edge[1];
                if (dist[u] + weight < dist[v]) {
                    dist[v] = dist[u] + weight;
                    pq.offer(new Node(v, dist[v]));
                }
            }
        }
        return dist;
    }
}
```

---

## ⚠️ Common Mistakes
- Using a BFS Queue instead of a PriorityQueue ($O(V \cdot E)$ worst case).
- Not checking `curr.distance > dist[u]` (leads to redundant processing).
- Using Dijkstra for negative edge weights.

---

## 🔄 Follow-up Questions
1. **What if edge weights are 1?** (Use simple BFS — $O(V+E)$.)
2. **What if the graph has negative edges?** (Use Bellman-Ford — $O(V \cdot E)$.)
3. **What is A* search?** (Dijkstra + Heuristic to guide the search toward the target.)
