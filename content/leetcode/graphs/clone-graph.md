---
author: "sagar ved"
title: "LeetCode 133: Clone Graph"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 LeetCode 133: Clone Graph (Medium)
Deep copy a connected undirected graph. Each node has a `val` and a list of `neighbors`.

## 🎯 What the interviewer is testing
- HashMap as both a "visited" set and node mapping.
- Cycle-safe DFS/BFS on graphs.
- Difference between shallow and deep copy.

---

## 🧠 Deep Explanation

### The Problem with Naive Recursion:
Graph `A → B → A` creates infinite recursion if you don't track visited nodes.

### HashMap Strategy:
`orig → clone` map serves dual purpose:
1. **Visited guard**: If already in map, return existing clone (no re-processing).
2. **Node registry**: Stores the cloned node reference for neighbor linking.

### Algorithm (DFS):
1. If `node == null` → return null.
2. If `map.contains(node)` → return `map.get(node)`.
3. Create `clone = new Node(node.val)`, add to map.
4. Recursively clone each neighbor and add to `clone.neighbors`.

---

## ✅ Ideal Answer
The HashMap prevents cycle-induced infinite loops by ensuring each node is cloned exactly once. Subsequent references to the same original node return the pre-existing clone, correctly wiring up cycles in the new graph.

---

## 💻 Java Code
```java
public class Solution {
    Map<Node, Node> map = new HashMap<>();
    public Node cloneGraph(Node node) {
        if (node == null) return null;
        if (map.containsKey(node)) return map.get(node);
        Node clone = new Node(node.val);
        map.put(node, clone);
        for (Node neighbor : node.neighbors)
            clone.neighbors.add(cloneGraph(neighbor));
        return clone;
    }
}
```

---

## 🔄 Follow-up Questions
1. **BFS version?** (Use a Queue; poll and clone neighbors iteratively.)
2. **Directed graph?** (Same algorithm — direction is just followed, not duplicated.)
3. **Complexity?** ($O(V + E)$ time and space.)
