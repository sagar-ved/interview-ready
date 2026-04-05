---
title: "DSA: Diameter of Binary Tree"
date: 2024-04-04
draft: false
weight: 86
---

# 🧩 Question: Diameter of Binary Tree (LeetCode 543)
Given the root of a binary tree, return the length of the diameter of the tree. The diameter is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.

## 🎯 What the interviewer is testing
- Post-order traversal (Bottom-up).
- Simultaneously tracking two states (Depth and Diameter).
- Avoiding $O(N^2)$ by calculating diameter during depth search.

---

## 🧠 Deep Explanation

### The Logic:
The longest path passing through node `N` is `height(N.left) + height(N.right)`.
- We can't just check at the root; the longest path might be deep in a subtree.

### Algorithm (Optimal):
1. Use DFS (Post-order).
2. For each node:
   - Request `leftHeight` from left child.
   - Request `rightHeight` from right child.
   - **Diameter update**: `GlobalMax = max(GlobalMax, leftHeight + rightHeight)`.
   - **Return**: `1 + max(leftHeight, rightHeight)` (passing the height up to the parent).

---

## ✅ Ideal Answer
To find the tree's diameter efficiently, we treat every node as a potential "peak" of a path. By using a post-order traversal, we calculate each subtree's height and simultaneously update our global diameter record. This avoids redundant height calculations and allows us to find the widest path in a single $O(N)$ linear pass.

---

## 💻 Java Code
```java
public class Solution {
    int maxDiameter = 0;

    public int diameterOfBinaryTree(TreeNode root) {
        getHeight(root);
        return maxDiameter;
    }

    private int getHeight(TreeNode node) {
        if (node == null) return 0;
        
        int left = getHeight(node.left);
        int right = getHeight(node.right);
        
        // Update diameter if current node is the center of the longest path
        maxDiameter = Math.max(maxDiameter, left + right);
        
        // Pass height to parent
        return 1 + Math.max(left, right);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can diameter be between two leaf nodes?** (Usually, yes, but not necessarily.)
2. **Complexity?** ($O(N)$ time; $O(H)$ space for recursion.)
3. **What if the tree is null?** (GlobalMax remains 0.)
