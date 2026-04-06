---
author: "sagar ved"
title: "LeetCode 98: Validate Binary Search Tree"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Validate Binary Search Tree (LeetCode 98)
Given the root of a binary tree, determine if it is a valid BST.

## 🎯 What the interviewer is testing
- BST invariant applies to ALL descendants, not just immediate children.
- Recursive range-boundary propagation.
- In-order traversal alternative.

---

## 🧠 Deep Explanation

### The Trap:
Only checking `left < root < right` locally fails. Example: `[10, 5, 15, null, null, 6, 20]` — node 6 is right-child of 15 (local check passes) but 6 < 10 (root), violating BST globally.

### Correct Approach: Recursive Range
Pass `(min, max)` boundaries down:
- Root: `(-∞, +∞)`
- Left child of `X`: `(min, X.val)` — must be smaller than parent
- Right child of `X`: `(X.val, max)` — must be larger than parent

---

## ✅ Ideal Answer
Every node must satisfy its inherited range, not just compare to its immediate parent. We pass down the valid range boundary through the recursion.

---

## 💻 Java Code
```java
public class Solution {
    public boolean isValidBST(TreeNode root) { return validate(root, null, null); }

    private boolean validate(TreeNode node, Integer min, Integer max) {
        if (node == null) return true;
        if (min != null && node.val <= min) return false;
        if (max != null && node.val >= max) return false;
        return validate(node.left, min, node.val) && validate(node.right, node.val, max);
    }
}
```

---

## 🔄 Follow-up Questions
1. **In-order traversal approach?** (BST in-order must produce strictly ascending sequence. Track `prev` value.)
2. **Iterative?** (Use a Stack for in-order traversal.)
3. **Space complexity?** ($O(H)$ where H = tree height.)
