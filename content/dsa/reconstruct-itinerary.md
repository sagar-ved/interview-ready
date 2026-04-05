---
title: "DSA: Reconstruct Itinerary (Hierholzer's Algorithm)"
date: 2024-04-04
draft: false
weight: 31
---

# 🧩 Question: Reconstruct Itinerary (LeetCode 332)
You are given a list of airline tickets where `tickets[i] = [from_i, to_i]` represent the departure and the arrival airports of one flight. Reconstruct the itinerary in order and return it. All of the tickets belong to a man who departs from "JFK", thus, the itinerary must begin with "JFK". If there are multiple valid itineraries, you should return the itinerary that has the smallest lexical order when read as a single string.

## 🎯 What the interviewer is testing
- Finding an **Eulerian Path** in a directed graph.
- Using a Hierholzer's algorithm.
- Managing lexical order with PriorityQueues.

---

## 🧠 Deep Explanation
An Eulerian path is a trail in a graph which visits every edge exactly once.

### The Algorithm (Hierholzer's):
1. Represent the graph as an adjacency list where each neighbor list is a **PriorityQueue** (to guarantee lexical order).
2. Start a DFS from "JFK".
3. For each node, recursively visit all neighbors in sorted order, removing the edge as you go.
4. **Post-order traversal**: Once a node has no more neighbors to visit, add it to the **end** of a result list.
5. Reverse the result list at the very end to get the correct path.

Wait, why add to the end? Because the "leaf" components of the tour (those without further outbound edges) must be visited last.

---

## ✅ Ideal Answer
This is a classic Eulerian Path problem. By using a PriorityQueue for adjacency lists and a post-order DFS, we can ensure we visit all edges while maintaining the required lexical order. We add nodes to our results only when they have no more valid departures, effectively building the path backwards.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    Map<String, PriorityQueue<String>> adj = new HashMap<>();
    LinkedList<String> result = new LinkedList<>();

    public List<String> findItinerary(List<List<String>> tickets) {
        for (List<String> t : tickets) {
            adj.computeIfAbsent(t.get(0), k -> new PriorityQueue<>()).add(t.get(1));
        }
        dfs("JFK");
        return result;
    }

    private void dfs(String node) {
        PriorityQueue<String> pq = adj.get(node);
        while (pq != null && !pq.isEmpty()) {
            dfs(pq.poll());
        }
        result.addFirst(node); // Same as adding to end and reversing
    }
}
```

---

## ⚠️ Common Mistakes
- Using standard BFS (it won't correctly find an Eulerian path).
- Not using a PriorityQueue (failing lexical order).
- Using a simple visited set (you can visit the same node multiple times, but each flight/edge only once).

---

## 🔄 Follow-up Questions
1. **Can an Eulerian path always be found here?** (The problem guarantees a valid itinerary exists.)
2. **Difference between Eulerian Path and Hamiltonian Path?** (Eulerian visits every edge once; Hamiltonian visits every vertex once. Hamiltonian is NP-complete.)
3. **Complexity?** ($O(E \log E)$ due to sorting neighbors in the PriorityQueues.)
