---
title: "DSA: Serialize and Deserialize Binary Tree"
date: 2024-04-04
draft: false
weight: 85
---

# 🧩 Question: Serialize and Deserialize a Binary Tree (LeetCode 297 - Hard)
Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work.

## 🎯 What the interviewer is testing
- Tree traversal (Pre-order vs Level-order).
- Handling "Null" nodes in a flat format.
- Recursive reconstruction logic.

---

## 🧠 Deep Explanation

### The Strategy (Level-Order):
Similar to how we visualize trees in arrays.
1. **Serialize**: Use a **Queue** for BFS. For every node, add its value to a string. If a child is null, add a marker like `"X"`.
   - Result: `"1,2,3,X,X,4,5,X,X,X,X"`
2. **Deserialize**: 
   - Split the string into a list of values.
   - Use a **Queue** to hold the nodes being processed.
   - For each node in queue, the next TWO values in the list are its children.

---

## ✅ Ideal Answer
To convert a complex tree into a flat string, we use level-order traversal while explicitly marking null children. This preserves the structural "gaps" in the tree, allowing us to accurately reconstruct the hierarchy using a queue-based reconstruction. This approach ensures $O(N)$ time for both operations and is highly robust for network transmission or file storage.

---

## 💻 Java Code: BFS
```java
import java.util.*;

public class Codec {
    public String serialize(TreeNode root) {
        if (root == null) return "X";
        StringBuilder sb = new StringBuilder();
        Queue<TreeNode> q = new LinkedList<>();
        q.add(root);
        while (!q.isEmpty()) {
            TreeNode node = q.poll();
            if (node == null) {
                sb.append("X,");
                continue;
            }
            sb.append(node.val).append(",");
            q.add(node.left);
            q.add(node.right);
        }
        return sb.toString();
    }

    public TreeNode deserialize(String data) {
        if (data.equals("X")) return null;
        String[] values = data.split(",");
        TreeNode root = new TreeNode(Integer.parseInt(values[0]));
        Queue<TreeNode> q = new LinkedList<>();
        q.add(root);
        for (int i = 1; i < values.length; i++) {
            TreeNode parent = q.poll();
            if (!values[i].equals("X")) {
                parent.left = new TreeNode(Integer.parseInt(values[i]));
                q.add(parent.left);
            }
            if (!values[++i].equals("X")) {
                parent.right = new TreeNode(Integer.parseInt(values[i]));
                q.add(parent.right);
            }
        }
        return root;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you use Pre-order?** (Yes, often more elegant for recursion, using `Iterator` to track current position.)
2. **Complexity?** ($O(N)$ time and space.)
3. **What if the tree is extremely skewed (a line)?** (BFS and DFS both still work, but DFS takes less space in terms of queue/stack size relative to the widest part of the tree.)
