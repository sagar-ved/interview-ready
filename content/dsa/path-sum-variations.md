---
title: "DSA: Path Sum I & II"
date: 2024-04-04
draft: false
weight: 75
---

# 🧩 Question: Path Sum (LeetCode 112, 113)
Given the root of a binary tree and an integer `targetSum`, return `true` if the tree has a root-to-leaf path such that adding up all the values along the path equals `targetSum`.
- **Path Sum II**: Return all such paths.

## 🎯 What the interviewer is testing
- DFS with backtracing.
- Handling leaf node edge cases.
- Efficient path reconstruction.

---

## 🧠 Deep Explanation

### The Logic (Path Sum I):
Recursive DFS. In each step, subtract current `val` from `targetSum`. 
- **Termination**: If you hit a Leaf node and `targetSum == node.val`, you found a path.

### The Logic (Path Sum II):
We must maintain a `currentPath` list.
1. Add `node.val` to list.
2. If Leaf and match: add copy of `currentPath` to result.
3. Recurse Left and Right.
4. **BACKTRACK**: Remove the last element from `currentPath` before returning to the parent.

---

## ✅ Ideal Answer
Path sum problems are solved using a depth-first search that tracks the "remaining target" at each node. For path reconstruction, we use a backtracking list to efficiently explore every possible branch from root to leaf. The core trick is making a copy of our path list only when a valid leaf is reached, ensuring our final result isn't corrupted by subsequent recursive calls.

---

## 💻 Java Code: Path Sum II
```java
import java.util.*;

public class Solution {
    public List<List<Integer>> pathSum(TreeNode root, int targetSum) {
        List<List<Integer>> result = new ArrayList<>();
        backtrack(root, targetSum, new ArrayList<>(), result);
        return result;
    }

    private void backtrack(TreeNode node, int sum, List<Integer> path, List<List<Integer>> res) {
        if (node == null) return;
        
        path.add(node.val);
        if (node.left == null && node.right == null && sum == node.val) {
            res.add(new ArrayList<>(path));
        } else {
            backtrack(node.left, sum - node.val, path, res);
            backtrack(node.right, sum - node.val, path, res);
        }
        path.remove(path.size() - 1); // Backtrack
    }
}
```

---

## 🔄 Follow-up Questions
1. **Path Sum III?** (Path doesn't have to start at root/end at leaf — requires Prefix Sum in Hashmap + DFS.)
2. **What if the values are negative?** (The logic still works, but you can't "prune" early.)
3. **Complexity?** ($O(N)$ time; $O(H)$ space.)
