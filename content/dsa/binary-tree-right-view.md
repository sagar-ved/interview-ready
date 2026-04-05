---
title: "DSA: Binary Tree Right Side View"
date: 2024-04-04
draft: false
weight: 76
---

# 🧩 Question: Binary Tree Right Side View (LeetCode 199)
Imagine you are standing on the right side of a binary tree, return the values of the nodes you can see ordered from top to bottom.

## 🎯 What the interviewer is testing
- Level Order Traversal (BFS).
- Identifying the "last" node in each level.
- DFS alternative (Right-leaning DFS).

---

## 🧠 Deep Explanation

### Approach 1: BFS
Perform a standard Breadth-First Search. For each level:
1. Note the size of the queue.
2. Iterate through all nodes of that level.
3. The **last node** in the loop is the one visible from the right.

### Approach 2: DFS (Optimal Space)
Perform a DFS where you visit **Root → Right → Left**.
- Maintain a `currentDepth` variable.
- If `currentDepth == result.size()`, this is the first time we've hit this depth from the right! Add it to the result.

---

## ✅ Ideal Answer
The Right Side View is essentially a list of the rightmost nodes at every horizontal level. We can solve this with BFS by picking the last element of every level queue, or with a modified DFS that prioritizes the right branch. The DFS approach is often preferred in interviews because it elegantly uses the result list's size to ensure only the first visible node at each depth is recorded.

---

## 💻 Java Code: DFS
```java
public class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> result = new ArrayList<>();
        dfs(root, 0, result);
        return result;
    }

    private void dfs(TreeNode node, int depth, List<Integer> res) {
        if (node == null) return;
        
        if (depth == res.size()) {
            res.add(node.val);
        }
        
        // Priority to Right
        dfs(node.right, depth + 1, res);
        dfs(node.left, depth + 1, res);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Left Side View?** (Same logic, but visit Left then Right.)
2. **Top View?** (Requires tracking Horizontal Distance `x` from the root.)
3. **Complexity?** ($O(N)$ time; $O(H)$ space.)
