---
title: "LeetCode 124: Binary Tree Maximum Path Sum"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 LeetCode 124: Binary Tree Maximum Path Sum ⭐ (Hard)
Find the maximum path sum in a binary tree. A path is a sequence of nodes where each pair of adjacent nodes has an edge. A path does not need to pass through the root.

## 🎯 What the interviewer is testing
- Post-order DFS with global variable.
- Understanding that a path can "peak" at any node.
- Discarding negative subtrees.

---

## 🧠 Deep Explanation

### The Key Distinction:
- **Branch gain**: The maximum sum going through a node in ONE direction (for parent use).
- **Path through node**: Left gain + node value + right gain (uses both children).

The second value updates the global max but **cannot be returned** to the parent (a path can't fork).

### Algorithm (Post-Order):
1. Recursively get max gain from left and right subtrees.
2. Discard negative gains (take `max(gain, 0)`).
3. Update `globalMax = max(globalMax, node.val + leftGain + rightGain)`.
4. Return `node.val + max(leftGain, rightGain)` to parent (choose one direction).

---

## ✅ Ideal Answer
Post-order processing lets us compute the best "contribution" each subtree offers to its parent. The global max is updated at each node considering the possibility of the path "peaking" here — the returned value only contributes one direction to keep paths valid.

---

## 💻 Java Code
```java
public class Solution {
    int maxSum = Integer.MIN_VALUE;

    public int maxPathSum(TreeNode root) {
        maxGain(root);
        return maxSum;
    }

    private int maxGain(TreeNode node) {
        if (node == null) return 0;
        int left = Math.max(maxGain(node.left), 0);
        int right = Math.max(maxGain(node.right), 0);
        maxSum = Math.max(maxSum, node.val + left + right); // Path through this node
        return node.val + Math.max(left, right); // Best single-branch return
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if all nodes are negative?** (The `Integer.MIN_VALUE` initial value handles it — we must pick at least one node.)
2. **Can a path have 0 nodes?** (No — must contain at least one node.)
3. **Complexity?** ($O(N)$ — visit each node once in post-order.)
