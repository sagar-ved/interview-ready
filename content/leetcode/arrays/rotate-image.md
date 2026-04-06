---
author: "sagar ved"
title: "LeetCode 48: Rotate Image"
date: 2024-04-04
draft: false
weight: 13
---

# 🧩 LeetCode 48: Rotate Image (Medium)
Rotate an `n x n` matrix 90 degrees clockwise **in-place**.

## 🎯 What the interviewer is testing
- In-place matrix manipulation.
- Geometric thinking (transpose + reflect).
- Avoiding $O(N^2)$ extra space.

---

## 🧠 Deep Explanation

### The Trick: Transpose + Reflect
1. **Transpose**: Swap `matrix[i][j]` with `matrix[j][i]`.
   Result: Rows become columns.
2. **Reverse each row**: Reverse every row left-to-right.
   Result: This rotates 90° clockwise.

### Why does it work?
- A 90° clockwise rotation maps `(i, j) → (j, n-1-i)`.
- Transpose maps `(i,j) → (j,i)`. Then reverse row maps `(j, i) → (j, n-1-i)`.
- Combined: correct!

---

## ✅ Ideal Answer
Rotation in-place is achieved via two sequential, non-overlapping operations: a transpose (swap across the diagonal) and a row reversal. Each operation is a classic linear scan, making the total $O(N^2)$ time with $O(1)$ space.

---

## 💻 Java Code
```java
public class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        // Step 1: Transpose
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++) {
                int tmp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = tmp;
            }
        // Step 2: Reverse each row
        for (int[] row : matrix) {
            int l = 0, r = n - 1;
            while (l < r) { int t = row[l]; row[l++] = row[r]; row[r--] = t; }
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Rotate 90° counter-clockwise?** (Transpose first, then reverse each **column**.)
2. **Rotate 180°?** (Reverse all rows, then transpose. Or just reverse the whole matrix.)
3. **Non-square matrix?** (Cannot rotate in-place with the same trick — need extra space.)
