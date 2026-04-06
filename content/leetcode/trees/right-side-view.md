---
author: "sagar ved"
title: "LeetCode 199: Binary Tree Right Side View"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 LeetCode 199: Binary Tree Right Side View (Medium)
Return all node values visible when looking at the tree from the right side.

## 🎯 What the interviewer is testing
- BFS level order traversal.
- DFS with depth tracking (alternative).
- Extracting the last node of each level.

---

## 🧠 Deep Explanation

### BFS Approach:
Do a level-order traversal. For each level, the **last node** is visible from the right. Add it to the result.

### DFS Approach:
Traverse right-first DFS. Track current depth. If `depth == result.size()`, this is the first node seen at this depth — it's the rightmost visible node.

---

## ✅ Ideal Answer
The right side view is simply the last element of each level in a BFS traversal. The DFS alternative exploits the right-first traversal order: whichever node we reach first at each depth is the rightmost visible one.

---

## 💻 Java Code (BFS)
```java
public class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> result = new ArrayList<>();
        if (root == null) return result;
        Queue<TreeNode> q = new LinkedList<>();
        q.offer(root);
        while (!q.isEmpty()) {
            int size = q.size();
            for (int i = 0; i < size; i++) {
                TreeNode node = q.poll();
                if (i == size - 1) result.add(node.val); // Last in level
                if (node.left != null) q.offer(node.left);
                if (node.right != null) q.offer(node.right);
            }
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Left Side View?** (Take the first node of each level instead of the last.)
2. **DFS code?** (Traverse right child first; add `node.val` when `result.size() == depth`.)
3. **Complexity?** ($O(N)$ time, $O(N)$ space for queue/result.)
