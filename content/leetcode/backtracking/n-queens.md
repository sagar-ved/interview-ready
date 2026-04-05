---
title: "LeetCode 51: N-Queens"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 LeetCode 51: N-Queens ⭐ (Hard)
Place `n` queens on an `n×n` chessboard so no two queens attack each other. Return all solutions.

## 🎯 What the interviewer is testing
- Classical constraint-satisfaction backtracking.
- Diagonal conflict detection.
- Pruning the search tree aggressively.

---

## 🧠 Deep Explanation

### Constraints:
Queens cannot share a row, column, or diagonal.
- **Column conflict**: Track via `Set<Integer> cols`.
- **Diagonal (\)**: `row - col` is constant along a `\` diagonal.
- **Anti-diagonal (/)**: `row + col` is constant along a `/` diagonal.

### Algorithm:
Place one queen per row. For each row, try each column. If it's safe (no column/diagonal conflicts), place queen and recurse to next row.

---

## ✅ Ideal Answer
N-Queens is the archetypal backtracking problem. By tracking column, diagonal, and anti-diagonal conflicts in sets, we prune each invalid column in $O(1)$, making the pruning highly efficient. Only valid partial solutions are extended.

---

## 💻 Java Code
```java
public class Solution {
    public List<List<String>> solveNQueens(int n) {
        List<List<String>> result = new ArrayList<>();
        Set<Integer> cols = new HashSet<>(), diag1 = new HashSet<>(), diag2 = new HashSet<>();
        char[][] board = new char[n][n];
        for (char[] row : board) Arrays.fill(row, '.');
        backtrack(result, board, 0, n, cols, diag1, diag2);
        return result;
    }

    private void backtrack(List<List<String>> res, char[][] board, int row, int n,
                           Set<Integer> cols, Set<Integer> diag1, Set<Integer> diag2) {
        if (row == n) {
            List<String> sol = new ArrayList<>();
            for (char[] r : board) sol.add(new String(r));
            res.add(sol); return;
        }
        for (int col = 0; col < n; col++) {
            if (cols.contains(col) || diag1.contains(row - col) || diag2.contains(row + col)) continue;
            board[row][col] = 'Q';
            cols.add(col); diag1.add(row - col); diag2.add(row + col);
            backtrack(res, board, row + 1, n, cols, diag1, diag2);
            board[row][col] = '.';
            cols.remove(col); diag1.remove(row - col); diag2.remove(row + col);
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **N-Queens II (count solutions)?** (LeetCode 52: Just increment a counter instead of storing the board.)
2. **Bitmask optimization?** (Use integer bitmasks for cols/diags — $O(1)$ conflict check with single AND operation.)
3. **Complexity?** ($O(N!)$ time — $N$ choices first row, $N-1$ next, etc.)
