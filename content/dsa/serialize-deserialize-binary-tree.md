---
title: "DSA: Serialize and Deserialize Binary Tree"
date: 2024-04-04
draft: false
weight: 39
---

# 🧩 Question: Serialize and Deserialize Binary Tree (LeetCode 297)
Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment. Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work.

## 🎯 What the interviewer is testing
- Tree traversal (BFS or DFS).
- Handling `null` pointers in data structures.
- Practical understanding of data persistence.

---

## 🧠 Deep Explanation

### Why it's different from BST:
In a general Binary Tree, you MUST store "null" indicators (like '#' or 'X') to preserve the structure during traversal.

### Strategy (DFS Approach):
- **Serialize**: Preorder traversal. If node is null, append "null,". Else append "val," and recurse.
- **Deserialize**: Convert string to a Queue. Pull from queue to create root, then recursively call for left and right children.

---

## ✅ Ideal Answer
To serialize a general binary tree, we use a preorder traversal and explicitly represent null nodes with a placeholder. This ensures that the structure is uniquely preserved. For reconstruction, we use a queue-based recursive approach that mirrors the original traversal.

---

## 💻 Java Code
```java
import java.util.*;

public class Codec {
    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        serialize(root, sb);
        return sb.toString();
    }

    private void serialize(TreeNode root, StringBuilder sb) {
        if (root == null) {
            sb.append("null,");
            return;
        }
        sb.append(root.val).append(",");
        serialize(root.left, sb);
        serialize(root.right, sb);
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        Queue<String> q = new LinkedList<>(Arrays.asList(data.split(",")));
        return deserialize(q);
    }

    private TreeNode deserialize(Queue<String> q) {
        String val = q.poll();
        if (val.equals("null")) return null;
        
        TreeNode root = new TreeNode(Integer.parseInt(val));
        root.left = deserialize(q);
        root.right = deserialize(q);
        return root;
    }
}
```

---

## ⚠️ Common Mistakes
- Not including "null" (makes reconstruction impossible).
- Using $O(N)$ string concatenations instead of `StringBuilder`.
- Not handling the splitting of the string correctly.

---

## 🔄 Follow-up Questions
1. **Can you do it with BFS?** (Yes, use a Queue and level-order traversal, similar logic.)
2. **How to minimize storage space?** (Use binary format instead of a comma-separated string; use bit-flags for existence.)
3. **What is the limit for tree depth?** (StackOverflow risk for very deep trees — may need iterative DFS.)
