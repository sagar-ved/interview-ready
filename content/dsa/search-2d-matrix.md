---
title: "DSA: Search a 2D Matrix"
date: 2024-04-04
draft: false
weight: 64
---

# 🧩 Question: Search a 2D Matrix (LeetCode 74, 240)
Search for a target value in an `m x n` matrix.
- Version I: Each row is sorted, and the first element of a row is greater than the last element of the previous.
- Version II: Each row and column are independently sorted.

## 🎯 What the interviewer is testing
- Adapting Binary Search to 2D.
- Staircase search logic.
- Cost-benefit of different search trajectories.

---

## 🧠 Deep Explanation

### Version I: Treat as 1D
Since the first element of row `i` is greater than the last element of row `i-1`, the whole matrix is essentially one sorted 1D array flattened.
- **Algorithm**: Standard Binary Search.
- **Index mapping**: `1D_index -> [1D / cols, 1D % cols]`.

### Version II: Staircase Search
Each row is sorted, every column is sorted.
- **Algorithm**: Start at **Top-Right** corner.
  - If `curr == target`: Found.
  - If `curr > target`: Move **Left** (eliminate current column).
  - If `curr < target`: Move **Down** (eliminate current row).
- **Complexity**: $O(M+N)$.

---

## ✅ Ideal Answer
For a fully sequential matrix, we can use binary search by treating the 2D grid as a flattened 1D array. For matrices where only rows and columns are sorted independently, we use a "staircase" search starting from a corner. By moving either left or down based on the target value, we can find the element in linear time relative to the dimensions.

---

## 💻 Java Code: Version II (Staircase)
```java
public class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        if (matrix == null || matrix.length == 0) return false;
        
        int row = 0;
        int col = matrix[0].length - 1;

        while (row < matrix.length && col >= 0) {
            if (matrix[row][col] == target) return true;
            else if (matrix[row][col] > target) col--;
            else row++;
        }
        return false;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you start from Top-Left?** (No, moving right or down both increase the value, so you don't know which way to go.)
2. **Can you start from Bottom-Left?** (Yes, same logic as Top-Right.)
3. **What is the complexity of Binary Search in 2D?** ($O(\log(M \cdot N))$ for Version I).
