---
author: "sagar ved"
title: "LeetCode 572: Subtree of Another Tree"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 572: Subtree of Another Tree (Easy/Medium)
Given the roots of two binary trees `root` and `subRoot`, return `true` if there is a subtree of `root` that has the same structure and values as `subRoot`.

## 🎯 What the interviewer is testing
- Tree equality check as a helper function.
- DFS over entire tree.
- Recognizing recursive subproblem.

---

## 🧠 Deep Explanation

### Strategy:
Two trees are the same if they have identical structure and values.
- Write `isSameTree(s, t)`: check if both nodes are null, or equal values and both subtrees match.
- Then `isSubtree(root, subRoot)`:
  - If `root == null` → false.
  - If `isSameTree(root, subRoot)` → true.
  - Recurse on `root.left` or `root.right`.

Each `isSubtree` call does $O(M)$ work, and there are $O(N)$ nodes → $O(N \cdot M)$ overall.

---

## ✅ Ideal Answer
The problem decomposes cleanly into two recursive functions: one for complete tree equality and one for subtree search. We attempt a match at every node, and the equality check propagates through both trees simultaneously.

---

## 💻 Java Code
```java
public class Solution {
    public boolean isSubtree(TreeNode root, TreeNode subRoot) {
        if (root == null) return false;
        if (isSame(root, subRoot)) return true;
        return isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot);
    }

    private boolean isSame(TreeNode s, TreeNode t) {
        if (s == null && t == null) return true;
        if (s == null || t == null) return false;
        return s.val == t.val && isSame(s.left, t.left) && isSame(s.right, t.right);
    }
}
```

---

## 🔄 Follow-up Questions
1. **$O(N + M)$ approach?** (Serialize both trees as strings — if `subRoot_str` is a substring of `root_str`, return true. Use KMP for $O(N+M)$.)
2. **What if the tree is huge?** (Hashing subtrees can detect matches in $O(N)$.)
3. **Same tree vs Subtree?** (`isSameTree` requires both roots; `isSubtree` only requires the smaller one to match somewhere inside.)
