---
title: "DSA: Spiral Matrix"
date: 2024-04-04
draft: false
weight: 71
---

# 🧩 Question: Spiral Matrix (LeetCode 54)
Given an `m x n` matrix, return all elements of the matrix in spiral order.

## 🎯 What the interviewer is testing
- Precise index tracking.
- Boundary condition management.
- Traversing a 2D grid in layers.

---

## 🧠 Deep Explanation

### The Logic (Layer-by-Layer):
1. Define four boundaries: `top`, `bottom`, `left`, `right`.
2. **While** the boundaries haven't crossed:
   - Move **Right**: Across `top`, then increment `top`.
   - Move **Down**: Down `right`, then decrement `right`.
   - Move **Left**: Across `bottom`, then decrement `bottom`. (**Check if still within bounds**).
   - Move **Up**: Up `left`, then increment `left`. (**Check if still within bounds**).

---

## ✅ Ideal Answer
Spiral traversal requires maintaining four pointer boundaries that contract toward the center. By strictly iterating along each edge and adjusting our range after every pass, we can visit every element in a specific order. The key challenge is adding a simple boundary check before the "return" and "upward" passes to avoid double-processing elements in uneven matrices.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public List<Integer> spiralOrder(int[][] matrix) {
        List<Integer> res = new ArrayList<>();
        if (matrix.length == 0) return res;
        
        int top = 0, bottom = matrix.length - 1;
        int left = 0, right = matrix[0].length - 1;
        
        while (top <= bottom && left <= right) {
            // Right
            for (int i = left; i <= right; i++) res.add(matrix[top][i]);
            top++;
            
            // Down
            for (int i = top; i <= bottom; i++) res.add(matrix[i][right]);
            right--;
            
            if (top <= bottom) {
                // Left
                for (int i = right; i >= left; i--) res.add(matrix[bottom][i]);
            }
            bottom--;
            
            if (left <= right) {
                // Up
                for (int i = bottom; i >= top; i--) res.add(matrix[i][left]);
            }
            left++;
        }
        return res;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Spiral Matrix II?** (Generate the matrix with numbers 1 to $N^2$ — same logic.)
2. **Complexity?** ($O(M \cdot N)$ time and $O(1)$ space beyond result storage.)
3. **How to do it with directions?** (Maintain a direction vector `(dr, dc)` and rotate every time you hit a boundary or a visited cell.)
