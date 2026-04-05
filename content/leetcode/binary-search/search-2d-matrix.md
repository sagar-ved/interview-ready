---
title: "LeetCode 74: Search a 2D Matrix"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 74: Search a 2D Matrix (Medium)
An `m x n` matrix where each row is sorted and the first integer of each row > last integer of the previous row. Search for a target in $O(\log(m \cdot n))$.

## 🎯 What the interviewer is testing
- Virtualizing 2D as 1D binary search.
- Index conversion: `mid → (mid/n, mid%n)`.
- Differentiating from LC 240 (weaker constraint).

---

## 🧠 Deep Explanation

### The Key Unification:
Because the matrix is **globally sorted** (rows are consecutive), we treat it as a flattened 1D array of length `m*n`.
- `lo = 0`, `hi = m*n - 1`.
- `mid` index → row `mid/n`, col `mid%n`.
- Standard binary search from here.

---

## ✅ Ideal Answer
The global monotonicity of the matrix allows us to treat it as a single sorted array. By mapping 1D index to 2D coordinates, standard binary search gives $O(\log(m \cdot n))$ without any modifications.

---

## 💻 Java Code
```java
public class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length;
        int lo = 0, hi = m * n - 1;
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;
            int val = matrix[mid / n][mid % n];
            if (val == target) return true;
            else if (val < target) lo = mid + 1;
            else hi = mid - 1;
        }
        return false;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Search a 2D Matrix II (LC 240)?** (Weaker guarantee: only row-sorted and column-sorted. Use "Staircase" search from top-right in $O(m+n)$.)
2. **Find the row without target?** (Binary search on just first column values.)
3. **Complexity?** ($O(\log(m \cdot n))$ time, $O(1)$ space.)
