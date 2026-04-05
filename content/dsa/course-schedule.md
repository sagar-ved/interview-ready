---
title: "DSA: Course Schedule (Topological Sort)"
date: 2024-04-04
draft: false
weight: 35
---

# 🧩 Question: Course Schedule (LeetCode 207)
There are a total of `numCourses` courses you have to take, labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [ai, bi]` indicates that you must take course `bi` first if you want to take course `ai`.
Return `true` if you can finish all courses.

## 🎯 What the interviewer is testing
- Directed Acyclic Graph (DAG) properties.
- **Topological Sort** implementation (Kahn's or DFS).
- Cycle detection in a directed graph.

---

## 🧠 Deep Explanation

### The Logic:
We can finish all courses ONLY if the dependency graph contains no **Cycles**.
For example, if A depends on B, and B depends on A, we have a deadlock.

### Kahn's Algorithm (BFS):
1. Compute the **indegree** (number of incoming edges) for each node.
2. Put all nodes with **indegree 0** (no prerequisites) into a Queue.
3. While Queue is not empty:
   - Pop a node $u$. Increment a count of "visited" nodes.
   - For each neighbor $v$:
     - Decrement $v$'s indegree by 1.
     - If indegree of $v$ becomes 0, add $v$ to the Queue.
4. If visited count == total nodes, no cycle; else yes.

---

## ✅ Ideal Answer
We represent the course dependencies as a directed graph. The problem then becomes: "Is the graph a Directed Acyclic Graph (DAG)?". Using Kahn's algorithm, we iteratively remove nodes with no incoming edges. If we successfully remove all nodes, the graph is a DAG and the order in which we removed them is the valid course sequence.

---

## 💻 Java Code: Kahn's Algorithm
```java
import java.util.*;

public class Solution {
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        int[] indegree = new int[numCourses];
        List<Integer>[] adj = new List[numCourses];
        for (int i = 0; i < numCourses; i++) adj[i] = new ArrayList<>();

        for (int[] p : prerequisites) {
            adj[p[1]].add(p[0]);
            indegree[p[0]]++;
        }

        Queue<Integer> q = new LinkedList<>();
        for (int i = 0; i < numCourses; i++) {
            if (indegree[i] == 0) q.offer(i);
        }

        int count = 0;
        while (!q.isEmpty()) {
            int curr = q.poll();
            count++;
            for (int next : adj[curr]) {
                if (--indegree[next] == 0) {
                    q.offer(next);
                }
            }
        }
        return count == numCourses;
    }
}
```

---

## ⚠️ Common Mistakes
- Confusing directed vs undirected cycle detection.
- Forgeting to handle multiple starting nodes (nodes with 0 prerequisites).
- Returning the order instead of true/false (LeetCode 210 asks for the order).

---

## 🔄 Follow-up Questions
1. **Can you solve it with DFS?** (Yes, use a "visiting" state to detect back-edges.)
2. **What if the graph is huge?** (Parallelize Kahn's? No, but you can distribute the adjacency list.)
3. **What is an Eulerian Path?** (A different graph concept; path that visits every edge.)
