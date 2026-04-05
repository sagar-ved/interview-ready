---
title: "LeetCode 332: Reconstruct Itinerary"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Reconstruct Itinerary (LeetCode 332)
Given airline tickets `[from, to]`, reconstruct itinerary starting from "JFK", visiting every ticket exactly once, with lexicographically smallest result.

## 🎯 What the interviewer is testing
- Eulerian Path (Hierholzer's Algorithm).
- Post-order DFS — building result backwards.
- PriorityQueue for lexical ordering.

---

## 🧠 Deep Explanation

### Problem Type: Eulerian Path
Visit every **edge** exactly once. This is Hierholzer's Algorithm.

### Algorithm:
1. Build adjacency list using `PriorityQueue<String>` per departure airport (lexical order automatic).
2. Start DFS from "JFK".
3. For each node, recursively visit all neighbors (consuming edges).
4. **Post-order**: Add the node to the front of the result **after** all its edges are consumed.

The "add last" trick works because dead-ends (no outgoing edges) must appear at the end of the itinerary.

---

## ✅ Ideal Answer
Hierholzer's algorithm finds an Eulerian path via post-order DFS. A PriorityQueue guarantees we always pick the lexicographically smaller destination first. Nodes are added to the front of the result list as they "exhaust" their edges.

---

## 💻 Java Code
```java
public class Solution {
    Map<String, PriorityQueue<String>> adj = new HashMap<>();
    LinkedList<String> result = new LinkedList<>();

    public List<String> findItinerary(List<List<String>> tickets) {
        for (List<String> t : tickets)
            adj.computeIfAbsent(t.get(0), k -> new PriorityQueue<>()).add(t.get(1));
        dfs("JFK");
        return result;
    }

    private void dfs(String node) {
        PriorityQueue<String> pq = adj.get(node);
        while (pq != null && !pq.isEmpty()) dfs(pq.poll());
        result.addFirst(node);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Eulerian Path vs Hamiltonian Path?** (Eulerian: every edge once; Hamiltonian: every vertex once — NP-complete.)
2. **Is a valid itinerary always guaranteed?** (Yes, the problem guarantees it.)
3. **Complexity?** ($O(E \log E)$ due to PriorityQueue operations.)
