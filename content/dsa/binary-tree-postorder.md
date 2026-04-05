---
title: "DSA: Binary Tree Postorder Traversal"
date: 2024-04-04
draft: false
weight: 59
---

# 🧩 Question: Binary Tree Postorder Traversal (LeetCode 145)
Given the root of a binary tree, return the postorder traversal of its nodes' values.

## 🎯 What the interviewer is testing
- Recursive vs. Iterative DFS.
- Handling "process after children" logic.
- Using a stack for non-linear structures.

---

## 🧠 Deep Explanation

### The Logic:
Postorder is **Left → Right → Root**.
This is particularly useful for problems like "Maximum Depth" or "Deleting a Tree," where you must visit/process children before the parent.

### Iterative Implementation (The tricky part):
Postorder is the reverse of a modified Preorder (Root → Right → Left).
1. Perform preorder, but push children as **Left then Right**.
2. Add the result to a list and **reverse** the list.

---

## ✅ Ideal Answer
Postorder traversal visits children before parents. While simple recursively, the iterative approach usually involves a stack. A common trick is to perform a Root-Right-Left traversal and reverse the resulting list, which yields the correct Left-Right-Root order.

---

## 💻 Java Code: Iterative
```java
import java.util.*;

public class Solution {
    public List<Integer> postorderTraversal(TreeNode root) {
        LinkedList<Integer> result = new LinkedList<>();
        if (root == null) return result;
        
        Stack<TreeNode> stack = new Stack<>();
        stack.push(root);
        
        while (!stack.isEmpty()) {
            TreeNode node = stack.pop();
            result.addFirst(node.val); // Add to front = reverse order
            if (node.left != null) stack.push(node.left);
            if (node.right != null) stack.push(node.right);
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **When to use Postorder?** (Deleting nodes, Dependency resolution in a tree, calculating tree depth.)
2. **What is the complexity?** ($O(N)$ time and space.)
3. **Difference between Preorder, Inorder, and Postorder?** (Just the position of the `Root` relative to children.)
