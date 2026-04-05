---
title: "DSA: Search 2D Matrix I & II"
date: 2024-04-04
draft: false
weight: 92
---

# 🧩 Question: Search a 2D Matrix (LeetCode 74, 240)
- **Matrix I**: Sorted such that the first integer of each row is greater than the last integer of the previous row. (Treat as a sorted list).
- **Matrix II**: Each row is sorted, and each column is sorted.

## 🎯 What the interviewer is testing
- Multi-dimensional binary search.
- Optimal coordinate movement ($O(M+N)$).
- Reducing 2D logic to 1D mapping.

---

## 🧠 Deep Explanation

### 1. Matrix I (Total Sorted Order):
Since the whole thing is one big sorted list, we can use standard **Binary Search** once.
- `mid_val = matrix[mid / col_count][mid % col_count]`
- This is $O(\log(M \cdot N))$.

### 2. Matrix II (Row/Col Sorted Order):
Binary search isn't enough because there's no total order.
- **The "Staircase" Strategy**: Start at the **Top-Right** corner.
  - If `curr > target`: Move **Left** (current column is now impossible).
  - If `curr < target`: Move **Down** (current row is now impossible).
- This is $O(M + N)$.

---

## ✅ Ideal Answer
For a fully sorted 2D matrix, we can mathematically flatten the grid into a virtual 1D array and apply standard binary search. For matrices where only rows and columns are independently sorted, we adopt a staircase search starting from the top-right or bottom-left corners. This allows us to eliminate a full row or column at each step, achieving a linear $O(M+N)$ search path that gracefully navigates the directional sorted properties of the grid.

---

## 💻 Java Code: Matrix II
```java
public class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int r = 0;
        int c = matrix[0].length - 1;
        
        while (r < matrix.length && c >= 0) {
            if (matrix[r][c] == target) return true;
            if (matrix[r][c] > target) c--;
            else r++;
        }
        return false;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Where else to start?** (Bottom-left works too. Top-left and bottom-right do NOT work because both directions either only increase or only decrease.)
2. **Complexity of Matrix I?** ($O(\log(M \cdot N))$ is better than $O(M+N)$ in most cases.)
3. **What if the matrix is very wide?** (Binary search within each row might be better in specific edge cases, but staircase is the robust general answer.)
