---
title: "DSA: Regular Expression Matching"
date: 2024-04-04
draft: false
weight: 98
---

# 🧩 Question: Regular Expression Matching (LeetCode 10 - Hard)
Given an input string `s` and a pattern `p`, implement regular expression matching with support for `.` and `*`.
- `.` Matches any single character.
- `*` Matches zero or more of the preceding element.

## 🎯 What the interviewer is testing
- Advanced 2D Dynamic Programming (DP).
- Complex transition logic for the "wildcard" `*`.
- Handling empty string matches.

---

## 🧠 Deep Explanation

### The Logic (DP Table):
`dp[i][j]` is true if `s[0...i-1]` matches `p[0...j-1]`.

1. **Basic Match** (`p[j]` is a char or `.`): 
   - `dp[i][j] = dp[i-1][j-1]` (if `s[i] == p[j]` or `p[j] == '.'`).
2. **Wildcard Match** (`p[j]` is `*`):
   - **Case 0 matches**: We treat `a*` as empty. `dp[i][j] = dp[i][j-2]`.
   - **Case 1+ matches**: If `s[i]` matches the char before `*`: `dp[i][j] = dp[i-1][j]`. (We "stay" in the state because `*` can eat more characters).

---

## ✅ Ideal Answer
Regex matching is a classic recursive problem best optimized through dynamic programming. The primary challenge lies in the asterisk wildcard, which creates a non-deterministic branch. By building a 2D state table, we can account for both the "skip" and "consume" scenarios of the wildcard, ensuring that we find a valid match path in $O(M \cdot N)$ time without the exponential cost of backtracking.

---

## 💻 Java Code: Core Transition
```java
if (p.charAt(j - 1) == '*') {
    // 0 copies of character
    dp[i][j] = dp[i][j - 2];
    if (matches(s, p, i, j - 1)) {
        // or 1+ copies
        dp[i][j] = dp[i][j] || dp[i - 1][j];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Wildcard Matching (LeetCode 44)?** (Difference: `*` matches ANY sequence, not "preceding char." Much easier logic.)
2. **Complexity?** ($O(M \cdot N)$ time and space.)
3. **Base Case for p = `a*b*` and s = `""`?** (Must be true; handled by checking `dp[0][j] = dp[0][j-2]`.)
