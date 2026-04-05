---
title: "DSA: Lowest Common Ancestor (LCA)"
date: 2024-04-04
draft: false
weight: 87
---

# 🧩 Question: Lowest Common Ancestor in BST vs. Binary Tree
Find the lowest common ancestor of two nodes in a tree.
- Scenario I: The tree is a **Binary Search Tree (BST)**.
- Scenario II: The tree is a **Regular Binary Tree**.

## 🎯 What the interviewer is testing
- Binary Search Tree properties (Order).
- Recursive search and state propagation.
- Handling of "node is a descendent of itself."

---

## 🧠 Deep Explanation

### Scenario I: BST (The Easy one)
Because of the sorted structure:
1. If both nodes are smaller than `root`: Search Left.
2. If both nodes are larger than `root`: Search Right.
3. If one is smaller and one is larger (or one is current root): **Current Root IS the LCA**.

### Scenario II: General Binary Tree (The standard one)
We don't know where the values are!
1. Recursively search Left and Right.
2. If you find one of the targets, return it.
3. If a node gets non-null results from BOTH children, it means one target is left and one is right. **This node IS the LCA**.
4. If it only gets a result from one side, it just passes it up.

---

## ✅ Ideal Answer
LCA detection showcases the power of subtree recursion. In a BST, we can navigate directly toward the answer using the directional properties of the values. In a general tree, we perform a dual search; the point where both searches converge is our common ancestor. This $O(N)$ approach properly handles the case where one target resides directly in the lineage of the other.

---

## 💻 Java Code: General Binary Tree
```java
public class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || root == p || root == q) return root;

        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);

        if (left != null && right != null) return root;
        return (left != null) ? left : right;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if the nodes might not exist in the tree?** (The current code would return whichever one exists; to handle "must both exist," you'd need a second pass or a more complex return object.)
2. **What if it's an N-ary tree?** (Iterate through all children instead of just left/right.)
3. **Space complexity?** ($O(H)$ for recursion stack.)
