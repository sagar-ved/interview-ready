---
title: "DSA: Serialize and Deserialize BST"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: Serialize and Deserialize BST (LeetCode 449)
Design an algorithm to serialize and deserialize a binary search tree. There is no restriction on how your serialization/deserialization algorithm should work. You need to ensure that a binary search tree can be serialized to a string, and this string can be deserialized to the original binary search tree.

## 🎯 What the interviewer is testing
- Exploiting BST properties (Inorder is sorted).
- Efficient encoding (Preorder/Postorder is sufficient for BST).
- Reconstructing trees without the need for `null` pointers.

---

## 🧠 Deep Explanation

### How BST is different from Binary Tree:
In a general Binary Tree, you need `null` indicators in preorder serialization to determine the structure. In a BST, the structural information is inherently encoded in the values because:
**Left nodes < Root < Right nodes**.

### Strategy:
1. **Serialize**: Simply do a **Preorder traversal**. The result is a sequence of values.
2. **Deserialize**:
   - For the first value (root), everything smaller than it in the sequence belongs to the left subtree, and everything larger belongs to the right.
   - We can use a **Recursive Bound approach** $O(N)$ or use the property that the first element > root starts the right subtree $O(N \log N)$.

---

## ✅ Ideal Answer
For a BST, a simple preorder or postorder traversal is enough to uniquely reconstruct the tree. By using range bounds `[min, max]` during reconstruction, we can determine where each node belongs in $O(N)$ time. This is more space-efficient than standard binary tree serialization because we don't store "null".

---

## 💻 Java Code
```java
import java.util.*;

public class Codec {

    // Serialize - Preorder traversal
    public String serialize(TreeNode root) {
        if (root == null) return "";
        StringBuilder sb = new StringBuilder();
        preorder(root, sb);
        return sb.substring(0, sb.length() - 1);
    }

    private void preorder(TreeNode root, StringBuilder sb) {
        if (root == null) return;
        sb.append(root.val).append(",");
        preorder(root.left, sb);
        preorder(root.right, sb);
    }

    // Deserialize - Using Range Bounds
    public TreeNode deserialize(String data) {
        if (data.isEmpty()) return null;
        Queue<Integer> q = new LinkedList<>();
        for (String s : data.split(",")) q.offer(Integer.parseInt(s));
        return build(q, Integer.MIN_VALUE, Integer.MAX_VALUE);
    }

    private TreeNode build(Queue<Integer> q, int min, int max) {
        if (q.isEmpty()) return null;
        int val = q.peek();
        if (val < min || val > max) return null;
        
        q.poll();
        TreeNode root = new TreeNode(val);
        root.left = build(q, min, val);
        root.right = build(q, val, max);
        return root;
    }
}
```

---

## ⚠️ Common Mistakes
- Including unnecessary `null` values (waste of space).
- Reconstructing by sorting and building ($O(N \log N)$), which is slower than the range-bound approach ($O(N)$).
- Not handling empty strings.

---

## 🔄 Follow-up Questions
1. **What is the most space-efficient format?** (Use a raw byte array/buffer instead of a comma-separated string.)
2. **Can you do it iteratively?** (Yes, using a stack similar to validating a BST.)
3. **How to handle duplicates?** (Clarify BST definition: usually no duplicates, or they go strictly to one side.)
