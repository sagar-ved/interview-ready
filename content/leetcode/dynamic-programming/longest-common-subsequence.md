---
title: "LeetCode 1143: Longest Common Subsequence"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 LeetCode 1143: Longest Common Subsequence (Medium)
Return the length of the longest common subsequence of `text1` and `text2`.

## 🎯 What the interviewer is testing
- Classic 2D DP.
- Match vs skip decision at each position.
- Foundation for diff algorithms (git diff).

---

## 🧠 Deep Explanation

### DP Definition:
`dp[i][j]` = LCS length of `text1[0..i-1]` and `text2[0..j-1]`.

### Recurrence:
- **Match**: `text1[i-1] == text2[j-1]` → `dp[i][j] = 1 + dp[i-1][j-1]`
- **No match**: `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`
  - Skip from `text1` or skip from `text2` — take the better result.

---

## ✅ Ideal Answer
LCS is built bottom-up by comparing all pairs of prefixes. When characters match, we extend the LCS from the previous subproblem. When they don't, we take the best of skipping one character from either string.

---

## 💻 Java Code
```java
public class Solution {
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length(), n = text2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++)
            for (int j = 1; j <= n; j++)
                if (text1.charAt(i-1) == text2.charAt(j-1)) dp[i][j] = 1 + dp[i-1][j-1];
                else dp[i][j] = Math.max(dp[i-1][j], dp[i][j-1]);
        return dp[m][n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Reconstruct the actual sequence?** (Backtrack from `dp[m][n]` — move diagonally on matches.)
2. **LCS vs LCS Substring?** (Substring must be contiguous: `dp[i][j] = text1[i-1]==text2[j-1] ? 1+dp[i-1][j-1] : 0`.)
3. **Space optimization?** ($O(N)$ using two rows instead of full 2D matrix.)
