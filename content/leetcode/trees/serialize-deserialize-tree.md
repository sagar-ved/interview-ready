---
title: "LeetCode 297: Serialize and Deserialize Binary Tree"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 LeetCode 297: Serialize and Deserialize Binary Tree ⭐ (Hard)
Design an algorithm to serialize and deserialize a binary tree.

## 🎯 What the interviewer is testing
- BFS or DFS-based tree encoding.
- Using `null` markers to preserve structure.
- Queue-based deserialization.

---

## 🧠 Deep Explanation

### BFS (Level-Order) Approach:
- **Serialize**: BFS, write node values and "null" for missing children.
- **Deserialize**: Split by comma, use a Queue. For each node in the queue, read the next two tokens as its left and right children.

### Pre-Order DFS Approach:
- **Serialize**: Pre-order DFS, write "#" for null nodes.
- **Deserialize**: Use a global/array index or iterator. Read token; if "#" return null; else create node, recurse left then right.

---

## ✅ Ideal Answer
The key insight is that a pre-order traversal with explicit null markers fully encodes the tree's structure. Deserialization reconstructs the tree by consuming tokens in the same pre-order sequence.

---

## 💻 Java Code (BFS)
```java
public class Codec {
    public String serialize(TreeNode root) {
        if (root == null) return "";
        Queue<TreeNode> q = new LinkedList<>();
        StringBuilder sb = new StringBuilder();
        q.offer(root);
        while (!q.isEmpty()) {
            TreeNode node = q.poll();
            if (node == null) { sb.append("null,"); continue; }
            sb.append(node.val).append(",");
            q.offer(node.left);
            q.offer(node.right);
        }
        return sb.toString();
    }

    public TreeNode deserialize(String data) {
        if (data.isEmpty()) return null;
        String[] vals = data.split(",");
        Queue<TreeNode> q = new LinkedList<>();
        TreeNode root = new TreeNode(Integer.parseInt(vals[0]));
        q.offer(root);
        int i = 1;
        while (!q.isEmpty()) {
            TreeNode node = q.poll();
            if (!vals[i].equals("null")) { node.left = new TreeNode(Integer.parseInt(vals[i])); q.offer(node.left); } i++;
            if (!vals[i].equals("null")) { node.right = new TreeNode(Integer.parseInt(vals[i])); q.offer(node.right); } i++;
        }
        return root;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Why not use in-order alone?** (In-order doesn't uniquely identify a tree without a second traversal or null markers.)
2. **Compact serialization?** (LeetCode 536/331: Encode as bracket notation or RPN.)
3. **Complexity?** ($O(N)$ time and space for both operations.)
