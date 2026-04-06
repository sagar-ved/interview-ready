---
author: "sagar ved"
title: "Graph Algorithms: BFS, DFS, Dijkstra, Topological Sort"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: You have a course dependency system. Given a list of courses and prerequisites, determine if all courses can be finished. If yes, return a valid order.

## 🎯 What the interviewer is testing
- Graph representation (adjacency list)
- Topological sort (Kahn's BFS algorithm + DFS-based)
- Cycle detection in directed graphs
- Dijkstra's for weighted shortest path

---

## 🧠 Deep Explanation

### 1. Graph Representations

| Structure | Space | Edge lookup | Best for |
|---|---|---|---|
| Adjacency Matrix | O(V²) | O(1) | Dense graphs |
| Adjacency List | O(V+E) | O(degree) | Sparse graphs (most real problems) |
| Edge List | O(E) | O(E) | Sorting edges (Kruskal's) |

### 2. Topological Sort — Kahn's Algorithm (BFS)

1. Compute **in-degree** for each node.
2. Add all nodes with in-degree 0 to the queue.
3. Repeatedly: dequeue a node, add to result, decrement in-degrees of its neighbors. If a neighbor's in-degree hits 0, enqueue it.
4. **Cycle detected** if result.size() < total nodes.

### 3. DFS-based Topological Sort

- Mark each node as: UNVISITED, VISITING, VISITED.
- During DFS, if you encounter a VISITING node → **cycle detected**.
- Add node to stack AFTER processing all its neighbors (post-order).
- Reverse the stack for the topological order.

### 4. Dijkstra's Algorithm

- Shortest path from source to all vertices in a **weighted, non-negative edge** graph.
- Uses a **Min-Heap** (Priority Queue) to always process the nearest unvisited node.
- Time: O((V + E) log V).

---

## ✅ Ideal Answer

- Model as a **Directed Graph**; prerequisites are edges.
- Use Kahn's BFS (in-degree tracking) for cycle detection + topological order.
- If `result.size() < n`, a cycle exists — return false.
- For shortest path (e.g., minimum course time), use Dijkstra's with the topological order.

---

## 💻 Java Code

```java
import java.util.*;

public class GraphAlgorithms {

    // 1. Course Schedule — Topological Sort (Kahn's BFS) — O(V+E)
    public int[] findOrder(int numCourses, int[][] prerequisites) {
        List<List<Integer>> adj = new ArrayList<>();
        int[] inDegree = new int[numCourses];

        for (int i = 0; i < numCourses; i++) adj.add(new ArrayList<>());

        for (int[] pre : prerequisites) {
            adj.get(pre[1]).add(pre[0]); // pre[1] must be taken before pre[0]
            inDegree[pre[0]]++;
        }

        Queue<Integer> q = new LinkedList<>();
        for (int i = 0; i < numCourses; i++) {
            if (inDegree[i] == 0) q.offer(i); // No prerequisites
        }

        int[] order = new int[numCourses];
        int idx = 0;

        while (!q.isEmpty()) {
            int course = q.poll();
            order[idx++] = course;
            for (int next : adj.get(course)) {
                if (--inDegree[next] == 0) q.offer(next);
            }
        }

        return idx == numCourses ? order : new int[0]; // Empty array if cycle detected
    }

    // 2. Dijkstra's Shortest Path — O((V+E) log V)
    public int[] dijkstra(int n, int[][] edges, int src) {
        List<int[]>[] graph = new List[n];
        for (int i = 0; i < n; i++) graph[i] = new ArrayList<>();

        for (int[] e : edges) {
            graph[e[0]].add(new int[]{e[1], e[2]});
            graph[e[1]].add(new int[]{e[0], e[2]}); // Undirected
        }

        int[] dist = new int[n];
        Arrays.fill(dist, Integer.MAX_VALUE);
        dist[src] = 0;

        // Min-heap: [distance, node]
        PriorityQueue<int[]> pq = new PriorityQueue<>(Comparator.comparingInt(a -> a[0]));
        pq.offer(new int[]{0, src});

        while (!pq.isEmpty()) {
            int[] curr = pq.poll();
            int d = curr[0], u = curr[1];
            if (d > dist[u]) continue; // Stale entry: skip

            for (int[] neighbor : graph[u]) {
                int v = neighbor[0], w = neighbor[1];
                if (dist[u] + w < dist[v]) {
                    dist[v] = dist[u] + w;
                    pq.offer(new int[]{dist[v], v});
                }
            }
        }
        return dist;
    }

    // 3. Number of Islands — BFS flood fill — O(m*n)
    public int numIslands(char[][] grid) {
        int m = grid.length, n = grid[0].length, count = 0;
        int[][] dirs = {{0,1},{0,-1},{1,0},{-1,0}};

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == '1') {
                    count++;
                    Queue<int[]> q = new LinkedList<>();
                    q.offer(new int[]{i, j});
                    grid[i][j] = '0'; // Mark visited

                    while (!q.isEmpty()) {
                        int[] cell = q.poll();
                        for (int[] d : dirs) {
                            int ni = cell[0] + d[0], nj = cell[1] + d[1];
                            if (ni >= 0 && ni < m && nj >= 0 && nj < n && grid[ni][nj] == '1') {
                                q.offer(new int[]{ni, nj});
                                grid[ni][nj] = '0';
                            }
                        }
                    }
                }
            }
        }
        return count;
    }
}
```

---

## ⚠️ Common Mistakes
- Using Dijkstra on negative weight graphs (use Bellman-Ford instead)
- Not marking visited nodes in BFS/DFS (infinite loop in cyclic graphs)
- Forgetting that Kahn's returning fewer nodes than `n` is the cycle detection
- Using `visited[]` array without resetting between different DFS calls in a disconnected graph

---

## 🔄 Follow-up Questions
1. **When would you use DFS-based topological sort vs Kahn's?** (Kahn's is better for cycle detection and level-by-level processing. DFS is better for recursive decomposition.)
2. **What is Bellman-Ford and when is it better than Dijkstra?** (Handles negative weights; works on directed graphs with negative cycles — detects them. O(VE) vs Dijkstra's O((V+E) log V).)
3. **How does Floyd-Warshall differ?** (All-pairs shortest path. O(V³) but works for negative weights and detects negative cycles.)
