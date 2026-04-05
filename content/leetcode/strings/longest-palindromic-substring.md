---
title: "LeetCode 5: Longest Palindromic Substring"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 LeetCode 5: Longest Palindromic Substring (Medium)
Return the longest palindromic substring of `s`.

## 🎯 What the interviewer is testing
- Center-expansion technique.
- Handling odd vs even length palindromes.
- DP vs Greedy space tradeoff.

---

## 🧠 Deep Explanation

### Approaches:
| Approach | Time | Space | Notes |
|---|---|---|---|
| Brute Force | $O(N^3)$ | $O(1)$ | Too slow |
| DP (`dp[i][j]`) | $O(N^2)$ | $O(N^2)$ | Space heavy |
| **Expand Around Center** | $O(N^2)$ | $O(1)$ | ✅ Best for interviews |
| Manacher's | $O(N)$ | $O(N)$ | Overkill unless asked |

### Expand Around Center:
There are `2N-1` centers (each char + each gap). For each center, expand while `s[left] == s[right]`.

---

## ✅ Ideal Answer
Expanding around each center gives $O(N^2)$ time with $O(1)$ space — better space than DP, simpler than Manacher's. Handle odd (center = single char) and even (center = gap) separately.

---

## 💻 Java Code
```java
public class Solution {
    public String longestPalindrome(String s) {
        int start = 0, end = 0;
        for (int i = 0; i < s.length(); i++) {
            int len = Math.max(expand(s, i, i), expand(s, i, i + 1));
            if (len > end - start) {
                start = i - (len - 1) / 2;
                end   = i + len / 2;
            }
        }
        return s.substring(start, end + 1);
    }
    private int expand(String s, int l, int r) {
        while (l >= 0 && r < s.length() && s.charAt(l) == s.charAt(r)) { l--; r++; }
        return r - l - 1;
    }
}
```

---

## 🔄 Follow-up Questions
1. **$O(N)$ solution?** (Manacher's Algorithm — transforms string to `#a#b#a#` then uses mirror property.)
2. **Longest Palindromic Subsequence?** (Different problem — use DP.)
3. **Shortest Palindrome by prepending?** (LC 214: KMP on `s + "#" + reverse(s)`.)
