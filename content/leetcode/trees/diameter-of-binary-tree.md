---
author: "sagar ved"
title: "LeetCode 543: Diameter of Binary Tree"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 LeetCode 543: Diameter of Binary Tree (Easy)
Return the length of the longest path between any two nodes in a binary tree (may not pass through root).

## 🎯 What the interviewer is testing
- Post-order traversal with global state update.
- The "path peaks at a node" insight.
- Avoiding $O(N^2)$ height recomputation.

---

## 🧠 Deep Explanation

### Key Insight:
The longest path **through node N** = `height(N.left) + height(N.right)`.
The diameter might peak at any node, not just the root.

### Optimal — Single Post-Order DFS:
1. Recurse to get `leftH` and `rightH`.
2. Update `globalMax = max(globalMax, leftH + rightH)`.
3. Return `1 + max(leftH, rightH)` to parent.

This avoids recomputing height separately ($O(N)$ total instead of $O(N^2)$).

---

## ✅ Ideal Answer
By combining height computation and diameter tracking in a single post-order DFS, we visit each node exactly once. At each node we consider it as the "peak" of a horizontal path and update the global max accordingly.

---

## 💻 Java Code
```java
public class Solution {
    int max = 0;
    public int diameterOfBinaryTree(TreeNode root) {
        height(root);
        return max;
    }
    private int height(TreeNode node) {
        if (node == null) return 0;
        int left = height(node.left), right = height(node.right);
        max = Math.max(max, left + right);
        return 1 + Math.max(left, right);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Diameter of N-ary tree?** (Sum of top-2 child heights at each node as the candidate.)
2. **Diameter in a weighted tree?** (Replace `1 +` with `edge_weight +`.)
3. **Complexity?** ($O(N)$ time, $O(H)$ recursion stack.)
