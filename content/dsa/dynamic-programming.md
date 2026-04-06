---
author: "sagar ved"
title: "Dynamic Programming: Patterns and Thinking"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Given an irregular grid with obstacles, find the number of unique paths from the top-left to the bottom-right corner. Extend this to the problem of finding the minimum cost path where each cell has a weight.

## 🎯 What the interviewer is testing
- DP problem decomposition: Define state, recurrence, base case
- Top-down (Memoization) vs Bottom-up (Tabulation) trade-offs
- Recognizing DP patterns: paths, knapsack, intervals, subsequences
- Space optimization (rolling array)

---

## 🧠 Deep Explanation

### 1. The DP Mental Model

Every DP problem needs three things:
1. **State Definition**: What does `dp[i][j]` represent?
2. **Recurrence**: How is `dp[i][j]` computed from smaller states?
3. **Base Case**: What are the trivially known states?

### 2. Grid Path Counting

`dp[i][j]` = number of unique paths to reach cell (i, j).

**Recurrence**: `dp[i][j] = dp[i-1][j] + dp[i][j-1]` (came from top or left).

**Base case**: `dp[0][*] = dp[*][0] = 1` (only one way to traverse any edge).

**Obstacle**: `dp[i][j] = 0` if `grid[i][j] == 1`.

### 3. Minimum Cost Path

`dp[i][j]` = minimum cost to reach (i, j).

**Recurrence**: `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])`.

### 4. Space Optimization

The 2D `dp` table only needs the previous row (or current row in-place). Reduce from O(m*n) to O(n) space.

### 5. DP Pattern Catalog

| Pattern | Examples |
|---|---|
| Linear DP | Fibonacci, House Robber, Jump Game |
| Grid DP | Unique Paths, Minimum Path Sum, Cherry Pickup |
| Knapsack | 0/1 Knapsack, Subset Sum, Coin Change |
| Interval DP | Matrix Chain Multiplication, Burst Balloons |
| Subsequence DP | LCS, LIS, Edit Distance |
| Bitmask DP | Traveling Salesman, Assignment Problem |

---

## ✅ Ideal Answer

- **State**: `dp[i][j]` = min cost to reach (i,j) from (0,0).
- **Recurrence**: `dp[i][j] = cost[i][j] + min(dp[i-1][j], dp[i][j-1])`.
- **Return**: `dp[m-1][n-1]`.
- **Optimize**: Use a single 1D `dp` array, updating in place: `dp[j] = cost[i][j] + min(dp[j], dp[j-1])`.

---

## 💻 Java Code

```java
public class GridDP {

    // 1. Count unique paths with obstacles — O(m*n) time, O(n) space
    public int uniquePathsWithObstacles(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        long[] dp = new long[n];
        dp[0] = 1; // Start: 1 path to (0,0)

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    dp[j] = 0; // Obstacle: 0 paths through here
                } else if (j > 0) {
                    dp[j] += dp[j - 1]; // Add paths coming from the left
                }
            }
        }
        return (int) dp[n - 1];
    }

    // 2. Minimum cost path — O(m*n) time, O(n) space
    public int minPathSum(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[] dp = new int[n];

        // Initialize first row
        dp[0] = grid[0][0];
        for (int j = 1; j < n; j++) {
            dp[j] = dp[j - 1] + grid[0][j];
        }

        for (int i = 1; i < m; i++) {
            dp[0] += grid[i][0]; // First column: can only come from above
            for (int j = 1; j < n; j++) {
                dp[j] = grid[i][j] + Math.min(dp[j], dp[j - 1]);
                //                           ↑ from above  ↑ from left
            }
        }
        return dp[n - 1];
    }

    // 3. Coin Change — Classic unbounded knapsack
    // dp[i] = minimum coins to make amount i
    public int coinChange(int[] coins, int amount) {
        int[] dp = new int[amount + 1];
        java.util.Arrays.fill(dp, amount + 1); // Sentinel: larger than any real answer
        dp[0] = 0; // 0 coins needed for amount 0

        for (int i = 1; i <= amount; i++) {
            for (int coin : coins) {
                if (coin <= i && dp[i - coin] + 1 < dp[i]) {
                    dp[i] = dp[i - coin] + 1;
                }
            }
        }
        return dp[amount] > amount ? -1 : dp[amount];
    }

    // 4. Longest Common Subsequence — O(m*n) time, O(n) space
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length(), n = text2.length();
        int[] prev = new int[n + 1], curr = new int[n + 1];

        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (text1.charAt(i - 1) == text2.charAt(j - 1)) {
                    curr[j] = prev[j - 1] + 1;
                } else {
                    curr[j] = Math.max(prev[j], curr[j - 1]);
                }
            }
            int[] temp = prev;
            prev = curr;
            curr = temp; // Swap arrays instead of creating new ones
        }
        return prev[n];
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting to handle the `(0,0)` cell initialization separately
- Off-by-one in space-optimized DP (reading updated values when old values needed)
- Using `int` overflow for counting paths on large grids (use `long`)
- Not memoizing overlapping subproblems in recursive solutions → exponential time

---

## 🔄 Follow-up Questions
1. **What is the difference between DP and Greedy?** (DP considers all subproblems; Greedy makes locally optimal choices. DP is complete; Greedy is not always optimal.)
2. **When should you prefer Top-Down (Memoization) over Bottom-Up?** (Top-Down is easier to code and avoids computing unnecessary states. Bottom-Up is more cache-friendly and eliminates recursion stack overhead.)
3. **How would you reconstruct the actual path (not just the cost) in min cost grid DP?** (Backtrack from `dp[m-1][n-1]` — compare `dp[i-1][j]` and `dp[i][j-1]` to determine direction.)
