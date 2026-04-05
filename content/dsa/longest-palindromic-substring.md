---
title: "DSA: Longest Palindromic Substring"
date: 2024-04-04
draft: false
weight: 29
---

# 🧩 Question: Longest Palindromic Substring (LeetCode 5)
Given a string `s`, return the longest palindromic substring in `s`.

## 🎯 What the interviewer is testing
- String manipulation and center-based expansion.
- DP vs Greedy vs Manacher's optimization.
- Handling odd vs even length palindromes.

---

## 🧠 Deep Explanation

### Approaches:
1. **Brute Force** ($O(N^3)$): Check every possible substring ($O(N^2)$) if it's a palindrome ($O(N)$).
2. **Dynamic Programming** ($O(N^2)$ time, $O(N^2)$ space):
   - `dp[i][j]` is true if `s[i..j]` is a palindrome. 
   - `dp[i][j] = (s[i] == s[j]) && dp[i+1][j-1]`.
3. **Expand Around Center** ($O(N^2)$ time, $O(1)$ space) - **Optimal for Interviews**:
   - There are $2N-1$ possible centers (each character and between each character).
   - "Expand" outward from each center for as long as it forms a palindrome.
4. **Manacher's Algorithm** ($O(N)$ time, $O(N)$ space): Use previously calculated palindromes to "mirror" and avoid re-checking. (Usually over-kill for interviews unless asked).

---

## ✅ Ideal Answer
To save space while maintaining efficiency, the Expand Around Center approach ($O(N^2)$ time, $O(1)$ space) is the strongest choice. We treat each character (for odd) and the space between characters (for even) as a potential center and expand as far as possible.

---

## 💻 Java Code: Expand Around Center
```java
public class Solution {
    public String longestPalindrome(String s) {
        if (s == null || s.length() < 1) return "";
        int start = 0, end = 0;
        for (int i = 0; i < s.length(); i++) {
            int len1 = expandAroundCenter(s, i, i);     // Odd cases
            int len2 = expandAroundCenter(s, i, i + 1); // Even cases
            int len = Math.max(len1, len2);
            if (len > end - start) {
                start = i - (len - 1) / 2;
                end = i + len / 2;
            }
        }
        return s.substring(start, end + 1);
    }

    private int expandAroundCenter(String s, int left, int right) {
        while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
            left--;
            right++;
        }
        return right - left - 1;
    }
}
```

---

## ⚠️ Common Mistakes
- Only checking for odd-length centers.
- Over-thinking with DP ($O(N^2)$ space is unnecessary here).
- Substring indices confusion (the helper should return the length).

---

## 🔄 Follow-up Questions
1. **Can you solve it in $O(N)$?** (Mention Manacher's Algorithm.)
2. **Difference between Longest Palindromic Subsequence vs Substring?** (Subsequence allows gaps, solvable via DP in $O(N^2)$.)
3. **How to solve with Suffix Trees?** (Longest common substring of `s` and `reverse(s)`).
