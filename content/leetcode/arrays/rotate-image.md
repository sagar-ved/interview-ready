---
title: "DSA: Rotate Image (90 Degrees)"
date: 2024-04-04
draft: false
weight: 69
---

# 🧩 Question: Rotate Image (LeetCode 48)
You are given an `n x n` 2D matrix representing an image, rotate the image by 90 degrees (clockwise). You have to rotate the image in-place.

## 🎯 What the interviewer is testing
- Matrix transposition and reversal.
- In-place manipulation without extra $O(N^2)$ space.
- Identifying geometric patterns in indices.

---

## 🧠 Deep Explanation

### Two-Step Strategy:
A 90-degree clockwise rotation is equivalent to:
1. **Transpose the matrix**: Swap `matrix[i][j]` with `matrix[j][i]`. (The diagonal acts as the mirror).
2. **Reverse each row**: Swap `matrix[i][j]` with `matrix[i][n-1-j]`.

This avoids complex four-way swaps and is much easier to implement and debug.

---

## ✅ Ideal Answer
To rotate a matrix 90 degrees in-place, we first flip it over its diagonal (transposing it) and then reverse each row horizontally. This geometric decomposition is mathematically sound and keeps our space complexity constant, requiring only $O(N^2)$ time to visit each cell.

---

## 💻 Java Code
```java
public class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        
        // 1. Transpose
        for (int i = 0; i < n; i++) {
            for (int j = i; j < n; j++) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = temp;
            }
        }
        
        // 2. Reverse each row
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n / 2; j++) {
                int temp = matrix[i][j];
                matrix[i][j] = matrix[i][n - 1 - j];
                matrix[i][n - 1 - j] = temp;
            }
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Rotate Anti-clockwise?** (Transpose, then reverse each **column**.)
2. **Rotate 180 degrees?** (Reverse each row, then reverse each column.)
3. **What is the complexity?** ($O(N^2)$ time, $O(1)$ space.)
