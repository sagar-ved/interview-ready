---
title: "DSA: Boundary Traversal of Binary Tree"
date: 2024-04-04
draft: false
weight: 88
---

# 🧩 Question: Boundary Traversal of Binary Tree
Given a binary tree, return its boundary traversal (Root → Left Boundary → Leaves → Right Boundary).

## 🎯 What the interviewer is testing
- Composing multiple traversal policies.
- Avoiding duplicate nodes (corners).
- Implementing "Leaves" vs "Edge" detection.

---

## 🧠 Deep Explanation

### The 4 Segments:
1. **Root**: Add separately.
2. **Left Boundary**: Pre-order (Top down). Skip leaves.
3. **Leaves**: Simple DFS. If node is a leaf, add to result.
4. **Right Boundary**: Post-order (Bottom up). Skip leaves. Add to result.

### Implementation:
- **Left**: Only move left if possible; else move right.
- **Right**: Only move right if possible; else move left.

---

## ✅ Ideal Answer
Boundary traversal is a multi-phase algorithm that requires distinct rules for each directional edge. We isolate the leftmost spine and rightmost spine while ensuring they don't include the leaf nodes, which are collected via a standard bottom-most sweep. By carefully stitching these segments together, we avoid corner-case duplication and achieve a perfect counter-clockwise border wrap of the tree.

---

## 💻 Java Code: Logic structure
```java
public class Solution {
    public List<Integer> boundaryTraversal(TreeNode root) {
        List<Integer> result = new ArrayList<>();
        if (root == null) return result;
        
        result.add(root.val);
        addLeftBoundary(root.left, result);
        addLeaves(root.left, result);
        addLeaves(root.right, result);
        addRightBoundary(root.right, result);
        
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **How to avoid the root being added twice?** (The code starts from `root.left` / `root.right` to handle this naturally.)
2. **Complexity?** ($O(N)$ time as it visits edges and leaves.)
3. **Why do we skip leaves in the boundary methods?** (Because the `addLeaves` method will pick them up later, ensuring a clean sequential list.)
