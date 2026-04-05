---
title: "DSA: Validate Binary Search Tree (BST)"
date: 2024-04-04
draft: false
weight: 47
---

# 🧩 Question: Validate Binary Search Tree (LeetCode 98)
Given the root of a binary tree, determine if it is a valid binary search tree (BST).

## 🎯 What the interviewer is testing
- Definition of a BST (not just immediate children).
- Recursive thinking with boundaries.
- Traversal properties (In-order traversal).

---

## 🧠 Deep Explanation

### The Logic Traps:
A common mistake is just checking `left < root < right` for each node individually. This fails for trees like `[10, 5, 15, null, null, 6, 20]`, where `6` is a right child of `15` (passing local check) but is nested under the root `10`'s right side, requiring it to be `> 10`.

### Best Approach: Recursive Range
Every node must fall within a specific range `(min, max)`.
- Root can be anything: `(null, null)`.
- Left child of `root` must be in `(min, root.val)`.
- Right child of `root` must be in `(root.val, max)`.

### Alternative: In-order Traversal
An in-order traversal of a BST **must yield a strictly increasing sequence**.
1. Traverse in-order.
2. Keep track of the `prev` value.
3. If current $\le$ `prev`, it's not a BST.

---

## ✅ Ideal Answer
A true BST must satisfy the condition that ALL nodes in a left subtree are smaller than the node, and ALL in the right are larger. We validate this by passing down a range constraint as we recurse. For the root, the range is $(-\infty, +\infty)$, and as we move left or right, we update the upper or lower boundary respectively.

---

## 💻 Java Code: Recursive Range
```java
public class Solution {
    public boolean isValidBST(TreeNode root) {
        return validate(root, null, null);
    }

    private boolean validate(TreeNode node, Integer min, Integer max) {
        if (node == null) return true;

        if (min != null && node.val <= min) return false;
        if (max != null && node.val >= max) return false;

        return validate(node.left, min, node.val) && validate(node.right, node.val, max);
    }
}
```

---

## ⚠️ Common Mistakes
- Only checking local child relationships.
- Not using `Long` or `Integer` wrappers for boundaries, potentially colliding with `Integer.MIN_VALUE` or `MAX_VALUE`.
- Not ensuring strictly increasing (forgetting the "equal" case).

---

## 🔄 Follow-up Questions
1. **Can you do it iteratively?** (Yes, using a Stack for in-order traversal.)
2. **What is the space complexity?** ($O(H)$ where $H$ is the height of the tree for recursion stack.)
3. **What is Morris In-order Traversal?** (An advanced $O(1)$ space traversal technique using thread-safe pointers.)
