---
title: "LeetCode 54: Spiral Matrix"
date: 2024-04-04
draft: false
weight: 14
---

# 🧩 LeetCode 54: Spiral Matrix (Medium)
Return all elements of an `m x n` matrix in spiral order.

## 🎯 What the interviewer is testing
- Simulation with boundary tracking.
- Managing 4 directional pointers.
- Clean termination without extra data structures.

---

## 🧠 Deep Explanation

### Boundary Shrinking Approach:
Maintain 4 boundaries: `top`, `bottom`, `left`, `right`.
1. Traverse `left → right` (top row), then `top++`.
2. Traverse `top → bottom` (right col), then `right--`.
3. If `top <= bottom`: traverse `right → left` (bottom row), then `bottom--`.
4. If `left <= right`: traverse `bottom → top` (left col), then `left++`.
5. Repeat while `top <= bottom && left <= right`.

The boundary guards on steps 3 and 4 prevent double-counting when the matrix has a single row or column remaining.

---

## ✅ Ideal Answer
We simulate the spiral by shrinking boundaries after processing each edge. The critical detail is checking boundary validity before the inward and upward passes to handle non-square matrices correctly.

---

## 💻 Java Code
```java
public class Solution {
    public List<Integer> spiralOrder(int[][] matrix) {
        List<Integer> res = new ArrayList<>();
        int top = 0, bottom = matrix.length-1, left = 0, right = matrix[0].length-1;
        while (top <= bottom && left <= right) {
            for (int i = left; i <= right; i++) res.add(matrix[top][i]); top++;
            for (int i = top; i <= bottom; i++) res.add(matrix[i][right]); right--;
            if (top <= bottom) { for (int i = right; i >= left; i--) res.add(matrix[bottom][i]); bottom--; }
            if (left <= right) { for (int i = bottom; i >= top; i--) res.add(matrix[i][left]); left++; }
        }
        return res;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Spiral Matrix II?** (LeetCode 59: Fill the matrix with 1..N² in spiral order — same logic, reverse.)
2. **Direction-array approach?** (Use `int[][] dirs = {{0,1},{1,0},{0,-1},{-1,0}}` and rotate direction when hitting a boundary.)
3. **Complexity?** ($O(M \cdot N)$ time, $O(1)$ extra space.)
