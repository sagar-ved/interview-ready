---
title: "DSA: Longest Palindromic Subsequence"
date: 2024-04-04
draft: false
weight: 62
---

# 🧩 Question: Longest Palindromic Subsequence (LeetCode 516)
Given a string `s`, find the length of the longest palindromic subsequence in `s`.

## 🎯 What the interviewer is testing
- Fundamental 2D Dynamic Programming.
- Identifying a hidden LCS problem.
- Space optimization patterns.

---

## 🧠 Deep Explanation

### 1. Two-Pointer DP Logic:
Let `dp[i][j]` be the length of the longest palindromic subsequence in `s[i..j]`.
- If `s[i] == s[j]`: They match! `dp[i][j] = 2 + dp[i+1][j-1]` (if `i != j`) or `1` (if `i == j`).
- Otherwise: `dp[i][j] = max(dp[i+1][j], dp[i][j-1])`.

### 2. The LCS Link (Clever Trick):
The Longest Palindromic Subsequence of string `s` is exactly the same as the **Longest Common Subsequence (LCS)** of `s` and `reverse(s)`.
- If you already know LCS, this is a 2-line solution.

---

## ✅ Ideal Answer
While we can use 2D DP directly to calculate our palindrome length from the inside out, a faster mental model is recognizing that a palindromic subsequence is simply a common subsequence shared between the string and its reverse. This allows us to re-use standard LCS logic to find our result in $O(N^2)$ time.

---

## 💻 Java Code: Direct DP
```java
public class Solution {
    public int longestPalindromeSubseq(String s) {
        int n = s.length();
        int[][] dp = new int[n][n];

        for (int i = n - 1; i >= 0; i--) {
            dp[i][i] = 1;
            for (int j = i + 1; j < n; j++) {
                if (s.charAt(i) == s.charAt(j)) {
                    dp[i][j] = dp[i + 1][j - 1] + 2;
                } else {
                    dp[i][j] = Math.max(dp[i + 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Subsequence vs Substring?** (Subsequence is non-contiguous.)
2. **Space optimization?** (Already $O(N^2)$ space; can be reduced to $O(N)$ because the row calculation only depends on the previous row.)
3. **What is the complexity?** ($O(N^2)$ time and space.)
