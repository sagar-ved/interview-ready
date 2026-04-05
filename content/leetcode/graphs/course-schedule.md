---
title: "LeetCode 207: Course Schedule"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Course Schedule (LeetCode 207)
There are `numCourses` courses. Given prerequisites `[a, b]` meaning "take b before a", return `true` if you can finish all courses.

## 🎯 What the interviewer is testing
- Directed Acyclic Graph (DAG) properties.
- Topological Sort (Kahn's Algorithm).
- Cycle detection in a directed graph.

---

## 🧠 Deep Explanation

### The Logic:
We can finish all courses ONLY if the dependency graph has **no cycles**.

### Kahn's Algorithm (BFS):
1. Compute the **indegree** for each node.
2. Put all nodes with **indegree 0** into a Queue.
3. Pop a node, increment visited count, decrement neighbors' indegrees. If neighbor reaches 0 → enqueue it.
4. If `visited == numCourses` → no cycle → return true.

---

## ✅ Ideal Answer
The problem reduces to DAG cycle detection. Kahn's algorithm iteratively removes nodes with no prerequisites. If all nodes can be removed, the graph is a DAG and all courses can be completed.

---

## 💻 Java Code
```java
public class Solution {
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        int[] indegree = new int[numCourses];
        List<Integer>[] adj = new List[numCourses];
        for (int i = 0; i < numCourses; i++) adj[i] = new ArrayList<>();
        for (int[] p : prerequisites) { adj[p[1]].add(p[0]); indegree[p[0]]++; }

        Queue<Integer> q = new LinkedList<>();
        for (int i = 0; i < numCourses; i++) if (indegree[i] == 0) q.offer(i);

        int count = 0;
        while (!q.isEmpty()) {
            int curr = q.poll(); count++;
            for (int next : adj[curr]) if (--indegree[next] == 0) q.offer(next);
        }
        return count == numCourses;
    }
}
```

---

## 🔄 Follow-up Questions
1. **DFS alternative?** (Use a 3-state visited array: 0=unvisited, 1=visiting, 2=done. A back-edge to 1 means cycle.)
2. **Course Schedule II?** (LeetCode 210: Return the actual topological ordering.)
3. **Complexity?** ($O(V + E)$ where V=courses, E=prerequisites.)
