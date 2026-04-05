---
title: "DSA: Longest Common Subsequence (LCS)"
date: 2024-04-04
draft: false
weight: 96
---

# 🧩 Question: Longest Common Subsequence (LeetCode 1143)
Given two strings `text1` and `text2`, return the length of their longest common subsequence. A subsequence is a new string generated from the original string with some characters deleted.

## 🎯 What the interviewer is testing
- Basic 2D Dynamic Programming.
- Identifying overlapping subproblems.
- Handling string offsets.

---

## 🧠 Deep Explanation

### The Logic (DP Table):
`dp[i][j]` is the LCS of `text1[0...i]` and `text2[0...j]`.

1. **If Chars Match** (`s1[i] == s2[j]`):
   - Perfect! We just found a character of our subsequence.
   - `dp[i][j] = 1 + dp[i-1][j-1]`
2. **If Chars DON'T Match**:
   - We must "skip" a character from either string and see which path was better.
   - `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`

---

## ✅ Ideal Answer
Longest Common Subsequence is a classic problem solved by evaluating character matches across a 2D state space. By breaking the problem down into smaller string comparisons, we can record the optimal alignment at every possible prefix. This $O(M \cdot N)$ approach ensures that we find the longest shared path without the exponential cost of checking every possible subsequence combination.

---

## 💻 Java Code
```java
public class Solution {
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length(), n = text2.length();
        int[][] dp = new int[m + 1][n + 1];

        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (text1.charAt(i - 1) == text2.charAt(j - 1)) {
                    dp[i][j] = 1 + dp[i - 1][j - 1];
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you reconstruct the actual string?** (Yes, by backtracking from `dp[m][n]` toward `(0,0)`, moving diagonally when a match was found.)
2. **What if the strings were very similar?** (Optimization techniques like Myers' Diff algorithm can be much faster.)
3. **Space complexity?** ($O(M \cdot N)$; can be optimized to $O(N)$ with two rows.)
