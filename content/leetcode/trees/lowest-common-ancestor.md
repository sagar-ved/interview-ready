---
title: "LeetCode 235 & 236: Lowest Common Ancestor"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 LeetCode 235 & 236: Lowest Common Ancestor (Easy / Medium)
Find the lowest common ancestor (LCA) of two nodes `p` and `q` in a tree.

## 🎯 What the interviewer is testing
- BST ordering property (LC 235).
- Post-order recursion for general trees (LC 236).
- Handling the case where one node is an ancestor of the other.

---

## 🧠 Deep Explanation

### LC 235: BST — Navigate by Value
- Both `p,q` < `root.val` → go left.
- Both `p,q` > `root.val` → go right.
- Otherwise → `root` IS the LCA (split point).

### LC 236: General Binary Tree — Post-order Search
1. If `root == null || root == p || root == q` → return `root`.
2. Recurse left and right.
3. If **both** return non-null → `root` is LCA.
4. If **only one** returns non-null → pass it up.

---

## ✅ Ideal Answer
For a general tree, post-order recursion finds the LCA at the node where the two search paths converge: left finds one target, right finds the other. For a BST, the BST property lets us navigate in $O(H)$ without touching most of the tree.

---

## 💻 Java Code

### BST (LC 235)
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if (p.val < root.val && q.val < root.val) return lowestCommonAncestor(root.left, p, q);
    if (p.val > root.val && q.val > root.val) return lowestCommonAncestor(root.right, p, q);
    return root;
}
```

### General Tree (LC 236)
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if (root == null || root == p || root == q) return root;
    TreeNode left  = lowestCommonAncestor(root.left, p, q);
    TreeNode right = lowestCommonAncestor(root.right, p, q);
    if (left != null && right != null) return root;
    return left != null ? left : right;
}
```

---

## 🔄 Follow-up Questions
1. **If nodes might not exist?** (Need a wrapper return type — e.g., `{found_p, found_q, lca}`.)
2. **N-ary tree LCA?** (Same post-order logic, but iterate all children.)
3. **Complexity?** ($O(N)$ general tree, $O(H)$ BST.)
