---
title: "Backtracking: N-Queens, Permutations, Sudoku"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: Given a 9x9 Sudoku board with some filled cells, write a solver. Then explain the backtracking template and when pruning matters at scale.

## 🎯 What the interviewer is testing
- Backtracking mental model (choose, explore, unchoose)
- Pruning/constraint propagation for efficiency
- N-Queens optimization with bit manipulation
- Applications: Sudoku, Permutations, Subsets, Word Search

---

## 🧠 Deep Explanation

### Backtracking Template
```
function backtrack(state):
    if is_solution(state): record/return
    for choice in choices(state):
        if is_valid(state, choice):
            apply(state, choice)     // Choose
            backtrack(state)          // Explore
            undo(state, choice)       // Unchoose
```

**Key**: The `undo` step is what makes it backtracking — you restore state after each branch.

### Sudoku Strategy
1. Find the next empty cell.
2. Try digits 1-9; check row, column, and 3x3 box constraints.
3. If valid, place digit and recurse.
4. If no digit works, backtrack.

**Pruning**: Instead of trying all 9 digits, precompute valid candidates (intersection of row/col/box allowed sets).

---

## 💻 Java Code

```java
import java.util.*;

public class BacktrackingProblems {

    // 1. Sudoku Solver — O(9^(empty cells)) worst case, much better in practice
    public void solveSudoku(char[][] board) {
        Set<Integer>[] rows = new HashSet[9];
        Set<Integer>[] cols = new HashSet[9];
        Set<Integer>[] boxes = new HashSet[9];

        for (int i = 0; i < 9; i++) {
            rows[i] = new HashSet<>();
            cols[i] = new HashSet<>();
            boxes[i] = new HashSet<>();
        }

        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                if (board[r][c] != '.') {
                    int num = board[r][c] - '0';
                    rows[r].add(num);
                    cols[c].add(num);
                    boxes[(r / 3) * 3 + c / 3].add(num);
                }
            }
        }
        backtrackSudoku(board, rows, cols, boxes, 0, 0);
    }

    private boolean backtrackSudoku(char[][] board, Set<Integer>[] rows, Set<Integer>[] cols,
                                     Set<Integer>[] boxes, int row, int col) {
        if (row == 9) return true; // All rows filled!
        int nextRow = col == 8 ? row + 1 : row;
        int nextCol = col == 8 ? 0 : col + 1;

        if (board[row][col] != '.') {
            return backtrackSudoku(board, rows, cols, boxes, nextRow, nextCol);
        }

        int boxId = (row / 3) * 3 + col / 3;
        for (int num = 1; num <= 9; num++) {
            if (!rows[row].contains(num) && !cols[col].contains(num) && !boxes[boxId].contains(num)) {
                board[row][col] = (char) ('0' + num);
                rows[row].add(num);
                cols[col].add(num);
                boxes[boxId].add(num);

                if (backtrackSudoku(board, rows, cols, boxes, nextRow, nextCol)) return true;

                // Backtrack
                board[row][col] = '.';
                rows[row].remove(num);
                cols[col].remove(num);
                boxes[boxId].remove(num);
            }
        }
        return false;
    }

    // 2. Generate all Permutations — O(n! * n)
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> result = new ArrayList<>();
        boolean[] used = new boolean[nums.length];
        backtrackPermute(nums, used, new ArrayList<>(), result);
        return result;
    }

    private void backtrackPermute(int[] nums, boolean[] used, List<Integer> current, List<List<Integer>> result) {
        if (current.size() == nums.length) {
            result.add(new ArrayList<>(current)); // Copy — don't add reference
            return;
        }
        for (int i = 0; i < nums.length; i++) {
            if (used[i]) continue;
            used[i] = true;
            current.add(nums[i]);
            backtrackPermute(nums, used, current, result);
            current.remove(current.size() - 1); // Unchoose
            used[i] = false;
        }
    }

    // 3. N-Queens — O(n!) with bitmask optimization
    public int totalNQueens(int n) {
        return solveNQueens(n, 0, 0, 0, 0);
    }

    private int solveNQueens(int n, int row, int cols, int diag1, int diag2) {
        if (row == n) return 1;
        int count = 0;
        int available = ((1 << n) - 1) & ~(cols | diag1 | diag2); // Bitmask of available columns

        while (available != 0) {
            int pos = available & (-available); // Lowest set bit (pick a column)
            available &= available - 1; // Clear this bit
            count += solveNQueens(n, row + 1,
                cols | pos,
                (diag1 | pos) << 1, // Shift diagonals
                (diag2 | pos) >> 1
            );
        }
        return count;
    }
}
```

---

## ⚠️ Common Mistakes
- Adding the current list reference instead of a copy to results (`result.add(current)` vs `result.add(new ArrayList<>(current))`)
- Not undoing the state change (missing the "unchoose" step)
- Forgetting the constraint check before recursing (leads to invalid solutions)

---

## 🔄 Follow-up Questions
1. **How does constraint propagation (like Arc Consistency) improve Sudoku solving?** (Before backtracking, propagate constraints — if a cell has only one candidate, fill it. Reduces search space dramatically.)
2. **What is the time complexity of N-Queens?** (O(n!) branches pruned significantly by row/column/diagonal constraints — in practice much faster.)
3. **How is backtracking different from DFS?** (Not fundamentally — backtracking IS DFS with state reconstruction on backtrack. The key addition is: undo state changes when returning.)
