---
author: "sagar ved"
title: "LeetCode 102: Binary Tree Level Order Traversal"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Binary Tree Level Order Traversal (LeetCode 102)
Return the level order (BFS) traversal of a binary tree — left to right, level by level.

## 🎯 What the interviewer is testing
- BFS on trees using a Queue.
- Grouping nodes by depth level.
- Foundation for many BFS variants (Zigzag, Right View, etc.).

---

## 🧠 Deep Explanation

### The Key Trick:
At each level, **capture `queue.size()`** before processing. This is the exact number of nodes at the current depth. Process only that many — children added during this pass belong to the next level.

---

## ✅ Ideal Answer
BFS naturally processes nodes level by level. By snapshotting the current queue size at the start of each iteration, we can cleanly group all nodes at the same depth into a sub-list before moving to the next level.

---

## 💻 Java Code
```java
public class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<>();
        if (root == null) return result;
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while (!queue.isEmpty()) {
            int size = queue.size();
            List<Integer> level = new ArrayList<>();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                level.add(node.val);
                if (node.left != null) queue.add(node.left);
                if (node.right != null) queue.add(node.right);
            }
            result.add(level);
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Zigzag Level Order?** (LeetCode 103: Reverse alternate levels — use a `Deque`.)
2. **Right Side View?** (LeetCode 199: Take the last node of each level list.)
3. **Complexity?** ($O(N)$ time, $O(N)$ space for the queue.)
