---
title: "LeetCode 72: Edit Distance"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 LeetCode 72: Edit Distance ⭐ (Hard)
Given `word1` and `word2`, return the minimum operations (insert, delete, replace) to transform `word1` to `word2`.

## 🎯 What the interviewer is testing
- 2D DP with 3-way recurrence.
- Base case initialization (empty string mappings).
- Space optimization to $O(N)$.

---

## 🧠 Deep Explanation

### DP Definition:
`dp[i][j]` = min edits to convert `word1[0..i-1]` to `word2[0..j-1]`.

### Recurrence:
- **Match**: `word1[i-1] == word2[j-1]` → `dp[i][j] = dp[i-1][j-1]`
- **No match**: `dp[i][j] = 1 + min(dp[i][j-1], dp[i-1][j], dp[i-1][j-1])`
  - `dp[i][j-1]` = insert into word1
  - `dp[i-1][j]` = delete from word1
  - `dp[i-1][j-1]` = replace

### Base Cases:
- `dp[i][0] = i` (delete all chars from word1)
- `dp[0][j] = j` (insert all chars to reach word2)

---

## ✅ Ideal Answer
Edit distance (Levenshtein distance) is the canonical 2D DP problem. The three operations map directly to adjacent cells in the DP table. The match case is free (diagonal move); mismatches cost 1 from the cheapest of three neighboring states.

---

## 💻 Java Code
```java
public class Solution {
    public int minDistance(String word1, String word2) {
        int m = word1.length(), n = word2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 0; i <= m; i++) dp[i][0] = i;
        for (int j = 0; j <= n; j++) dp[0][j] = j;
        for (int i = 1; i <= m; i++)
            for (int j = 1; j <= n; j++)
                if (word1.charAt(i-1) == word2.charAt(j-1)) dp[i][j] = dp[i-1][j-1];
                else dp[i][j] = 1 + Math.min(dp[i][j-1], Math.min(dp[i-1][j], dp[i-1][j-1]));
        return dp[m][n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **$O(N)$ space?** (Use two 1D arrays: previous row and current row.)
2. **Different operation costs?** (Replace `1 +` with `cost[op] +`.)
3. **Applications?** (Spell check, diff tools, DNA sequence alignment.)
