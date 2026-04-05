---
title: "DSA: Binary Tree Zigzag Level Order Traversal"
date: 2024-04-04
draft: false
weight: 83
---

# 🧩 Question: Zigzag Level Order Traversal (LeetCode 103)
Given a binary tree, return the zigzag level order traversal of its nodes' values. (i.e., from left to right, then right to left for the next level and alternate between).

## 🎯 What the interviewer is testing
- Level Order Traversal (BFS) foundation.
- Directional management in queues/deques.
- Efficient result formatting.

---

## 🧠 Deep Explanation

### The Logic:
1. Use a **Queue** for standard BFS.
2. Maintain a boolean `reverse` flag.
3. For each level:
   - Use a `LinkedList` as a temporary result.
   - If `reverse` is false: Add nodes to the **end** of the list.
   - If `reverse` is true: Add nodes to the **front** of the list.
4. Flip the `reverse` flag after each level.

---

## ✅ Ideal Answer
To achieve efficient zigzag traversal, we utilize a standard level-order queue while alternating how we insert elements into our result list. By leveraging a `LinkedList` for each level, we can perform $O(1)$ insertions at either the front or the back. This avoids expensive list reversals while maintaining the correct visual order for the zigzag output.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public List<List<Integer>> zigzagLevelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<>();
        if (root == null) return result;
        
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        boolean reverse = false;
        
        while (!queue.isEmpty()) {
            int size = queue.size();
            LinkedList<Integer> level = new LinkedList<>();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                if (reverse) level.addFirst(node.val);
                else level.addLast(node.val);
                
                if (node.left != null) queue.add(node.left);
                if (node.right != null) queue.add(node.right);
            }
            result.add(level);
            reverse = !reverse;
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you do it with two stacks?** (Yes, standard BFS logic replaced by push/pop between two stacks.)
2. **Complexity?** ($O(N)$ time and space.)
3. **Difference between Zigzag and standard Level Order?** (Just the insertion direction.)
