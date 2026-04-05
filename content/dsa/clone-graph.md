---
title: "DSA: Clone Graph"
date: 2024-04-04
draft: false
weight: 84
---

# 🧩 Question: Clone Graph (LeetCode 133)
Given a reference of a node in a connected undirected graph. Return a deep copy (clone) of the graph. Each node contains a value (`int`) and a list of its neighbors.

## 🎯 What the interviewer is testing
- Handling cycles in recursive clones.
- DFS/BFS application beyond trees.
- Using a **Map** for node tracking.

---

## 🧠 Deep Explanation

### The Logic:
If you just blindly copy neighbors, a cycle `A -> B -> A` will cause an infinite loop.
1. Use a **HashMap** to store `OriginalNode -> ClonedNode`.
2. When visiting a node:
   - If it's already in the Map: Just return the cloned link.
   - If NOT in the Map: 
     - Create a **New Node**.
     - Add to Map.
     - **Recursively** (DFS) or **Iteratively** (BFS) clone its neighbors and add them to the new node's neighbor list.

---

## ✅ Ideal Answer
Cloning a graph requires careful management of cyclic references. We use a HashMap to maintain a 1:1 mapping between original nodes and their cloned counterparts. This map serves as both our storage for the new graph and a "visited" set to prevent infinite recursion, ensuring each node is instantiated exactly once.

---

## 💻 Java Code: DFS
```java
import java.util.*;

public class Solution {
    private Map<Node, Node> visited = new HashMap<>();

    public Node cloneGraph(Node node) {
        if (node == null) return null;
        
        // If already cloned, return the clone
        if (visited.containsKey(node)) {
            return visited.get(node);
        }
        
        // Create new node and store
        Node clone = new Node(node.val);
        visited.put(node, clone);
        
        // Recursively clone neighbors
        for (Node neighbor : node.neighbors) {
            clone.neighbors.add(cloneGraph(neighbor));
        }
        
        return clone;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you do it with BFS?** (Yes, same map logic, but use a Queue for traversal.)
2. **Complexity?** ($O(V + E)$ where $V$ is nodes and $E$ is edges.)
3. **Difference from a Tree Clone?** (Trees have no cycles, so you don't need the Map for termination.)
