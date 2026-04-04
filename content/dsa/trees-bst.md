---
title: "Trees: Binary Trees, BSTs, and Traversals"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Serialize and deserialize a binary tree (like LeetCode 297). Then explain the inorder property of BSTs and how to validate a BST without extra space.

## 🎯 What the interviewer is testing
- Tree traversal (preorder, inorder, postorder, level-order)
- BST invariant and validation
- Serialization design (preorder with nulls)
- Space optimization (Morris traversal)

---

## 🧠 Deep Explanation

### 1. Traversal Types

| Traversal | Order | Use Case |
|---|---|---|
| **Preorder** | Root → Left → Right | Serialization, copy tree |
| **Inorder** | Left → Root → Right | BST sorted order |
| **Postorder** | Left → Right → Root | Delete tree, evaluate expressions |
| **Level-Order** | BFS row by row | Shortest path, level computation |

### 2. BST Invariant

For each node N:
- All nodes in the **left subtree** have values **< N.val**
- All nodes in the **right subtree** have values **> N.val**

**Common mistake**: Checking only parent vs children. Must validate against the **full valid range** `(min, max)` that gets narrowed as you recurse.

### 3. Serialization Strategy

Preorder + null markers is the simplest:
```
[1, 2, null, null, 3, 4, null, null, 5, null, null]
```
Reconstruct by consuming the array from left to right in preorder.

### 4. Morris Traversal (O(1) Space Inorder)

Traverses BST inorder without a stack or recursion by temporarily modifying tree pointers (right links).

---

## ✅ Ideal Answer

- **Serialize**: Preorder DFS; write node value or "null" separator.
- **Deserialize**: Preorder recursion consuming a queue of values.
- **Validate BST**: Recursive DFS passing `(min, max)` bounds — O(n) time, O(height) space.
- **Inorder Property**: Inorder traversal of a valid BST produces a strictly increasing sequence.

---

## 💻 Java Code

```java
import java.util.*;

public class BinaryTreeProblems {

    static class TreeNode {
        int val;
        TreeNode left, right;
        TreeNode(int val) { this.val = val; }
    }

    // 1. Serialize — Preorder with null markers
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        serializeHelper(root, sb);
        return sb.toString();
    }

    private void serializeHelper(TreeNode node, StringBuilder sb) {
        if (node == null) { sb.append("null,"); return; }
        sb.append(node.val).append(',');
        serializeHelper(node.left, sb);
        serializeHelper(node.right, sb);
    }

    // 2. Deserialize — Consume queue in preorder
    public TreeNode deserialize(String data) {
        Queue<String> nodes = new LinkedList<>(Arrays.asList(data.split(",")));
        return deserializeHelper(nodes);
    }

    private TreeNode deserializeHelper(Queue<String> nodes) {
        String val = nodes.poll();
        if ("null".equals(val)) return null;
        TreeNode node = new TreeNode(Integer.parseInt(val));
        node.left  = deserializeHelper(nodes);  // Must be left FIRST (preorder)
        node.right = deserializeHelper(nodes);
        return node;
    }

    // 3. Validate BST — O(n) time, O(height) stack space
    public boolean isValidBST(TreeNode root) {
        return validate(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }

    private boolean validate(TreeNode node, long min, long max) {
        if (node == null) return true;
        if (node.val <= min || node.val >= max) return false; // Violates BST invariant
        return validate(node.left, min, node.val)  // Left: max bound is parent's value
            && validate(node.right, node.val, max); // Right: min bound is parent's value
    }

    // 4. Level-order traversal (BFS)
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<>();
        if (root == null) return result;

        Queue<TreeNode> q = new LinkedList<>();
        q.offer(root);

        while (!q.isEmpty()) {
            int levelSize = q.size(); // Important: snapshot size BEFORE processing
            List<Integer> level = new ArrayList<>();
            for (int i = 0; i < levelSize; i++) {
                TreeNode node = q.poll();
                level.add(node.val);
                if (node.left  != null) q.offer(node.left);
                if (node.right != null) q.offer(node.right);
            }
            result.add(level);
        }
        return result;
    }

    // 5. Lowest Common Ancestor (LCA) — O(n)
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || root == p || root == q) return root;
        TreeNode left  = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);
        if (left != null && right != null) return root; // p and q are in different subtrees
        return left != null ? left : right;
    }
}
```

---

## ⚠️ Common Mistakes
- Validating BST by only checking `node > left-child && node < right-child` (the range check must be global — a node deep in the right subtree must be > the root)
- Deserializing using index without advancing the pointer correctly
- Using `Integer.MIN_VALUE/MAX_VALUE` for BST validation bounds — fails when tree contains Integer.MIN_VALUE (use `Long`)
- Forgetting to snapshot `q.size()` before the inner BFS loop (queue size changes mid-loop)

---

## 🔄 Follow-up Questions
1. **What is a balanced BST and why does it matter?** (AVL and Red-Black Trees maintain height O(log n) — ensures O(log n) search/insert/delete. Without balance, worst case is O(n) for a skewed tree.)
2. **How does a Trie differ from a BST?** (Trie stores keys character-by-character; faster prefix lookups O(L); BST stores full keys and requires comparison at each node.)
3. **How do you find the kth smallest element in a BST?** (Augmented BST: track subtree size at each node — O(log n) with balanced BST. Or inorder traversal stopping at kth — O(k).)
