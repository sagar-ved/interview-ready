---
title: "DSA: Binary Tree Level Order Traversal"
date: 2024-04-04
draft: false
weight: 49
---

# 🧩 Question: Binary Tree Level Order Traversal (LeetCode 102)
Given the root of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).

## 🎯 What the interviewer is testing
- BFS on trees.
- Grouping nodes by their "depth" or "level".
- Handling nulls and queue mechanics.

---

## 🧠 Deep Explanation

### The Logic (BFS):
Unlike DFS (which is recursive), BFS is usually iterative and uses a **Queue**.
1. Add root to the queue.
2. While queue is not empty:
   - Find the current `size` of the queue (this is the number of nodes at the current level).
   - Process exactly `size` nodes:
     - Pop node, add to a list.
     - Add its children to the queue for the *next* level.
   - Add the level-list to your final result.

---

## ✅ Ideal Answer
We use a Breadth-First Search (BFS) with a queue. To separate results by level, we iterate through the current size of the queue at the start of each layer. This guarantees that all nodes added to a specific list belong to the same depth in the tree.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<>();
        if (root == null) return result;

        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);

        while (!queue.isEmpty()) {
            int size = queue.size();
            List<Integer> currentLevel = new ArrayList<>();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                currentLevel.add(node.val);
                if (node.left != null) queue.add(node.left);
                if (node.right != null) queue.add(node.right);
            }
            result.add(currentLevel);
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **How to do it recursively?** (Yes, pass down a `level` variable and add to the corresponding sub-list in the result.)
2. **Zig-Zag Level Order?** (LeetCode 103: Reverse every other level list.)
3. **What is the time complexity?** ($O(N)$ since we visit every node once.)
