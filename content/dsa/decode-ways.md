---
title: "DSA: Decode Ways"
date: 2024-04-04
draft: false
weight: 56
---

# 🧩 Question: Decode Ways (LeetCode 91)
A message containing letters from A-Z can be encoded into numbers using the following mapping: 'A' -> "1", 'B' -> "2", ... 'Z' -> "26". Given a string `s`, return the number of ways to decode it.

## 🎯 What the interviewer is testing
- Handling constraints (like "0").
- Sequential DP.
- Fibonacci-like dependencies with edge cases.

---

## 🧠 Deep Explanation

### The Logic:
Let `dp[i]` be the number of ways to decode `s[0..i-1]`.
1. **Single Digit**: If `s[i-1]` is not '0', we can add all ways from `dp[i-1]`.
2. **Double Digit**: If `s[i-2..i-1]` is between "10" and "26", we can add all ways from `dp[i-2]`.

### Edge Case: "0"
- '0' by itself is invalid.
- '0' can only exist as "10" or "20". Any other combination involving '0' at the start or mid-sequence might lead to 0 result.

---

## ✅ Ideal Answer
To count decoding combinations, we use a 1D DP array where each step evaluates whether the current digit (or current pair of digits) forms a valid character. If a single digit is valid, it inherits the count from the previous step; if a double-digit pair is valid, it adds the count from two steps back. This $O(N)$ approach efficiently sums all possible branching paths.

---

## 💻 Java Code
```java
public class Solution {
    public int numDecodings(String s) {
        if (s == null || s.length() == 0 || s.charAt(0) == '0') return 0;
        int n = s.length();
        int[] dp = new int[n + 1];
        dp[0] = 1;
        dp[1] = 1;

        for (int i = 2; i <= n; i++) {
            // One digit check
            if (s.charAt(i - 1) != '0') {
                dp[i] += dp[i - 1];
            }
            // Two digit check
            int twoDigit = Integer.parseInt(s.substring(i - 2, i));
            if (twoDigit >= 10 && twoDigit <= 26) {
                dp[i] += dp[i - 2];
            }
        }
        return dp[n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you optimize space?** (Yes, only need `prev` and `prevPrev`, reducing space to $O(1)$.)
2. **What if the message could contain '*'?** (LeetCode 639: wildcard decoding.)
3. **Complexity?** ($O(N)$ time and space.)
