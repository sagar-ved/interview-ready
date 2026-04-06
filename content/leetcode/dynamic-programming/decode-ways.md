---
author: "sagar ved"
title: "LeetCode 91: Decode Ways"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Decode Ways (LeetCode 91)
A message encoded with A=1, B=2, ... Z=26. Given string `s`, return the number of ways to decode it.

## 🎯 What the interviewer is testing
- Sequential DP with Fibonacci-like dependencies.
- Strict constraint handling (the '0' case).
- Space optimization to $O(1)$.

---

## 🧠 Deep Explanation

### The DP Logic:
`dp[i]` = number of ways to decode `s[0..i-1]`.
- **Single digit**: If `s[i-1] != '0'` → `dp[i] += dp[i-1]`.
- **Double digit**: If `s[i-2..i-1]` is between 10-26 → `dp[i] += dp[i-2]`.

### Edge Case: '0'
- '0' alone is invalid (no mapping A-Z).
- '0' only valid as part of "10" or "20".

---

## ✅ Ideal Answer
Each position inherits from one step back (single decode) and potentially two steps back (double decode). We need to carefully validate both options to avoid invalid mappings involving leading zeros.

---

## 💻 Java Code
```java
public class Solution {
    public int numDecodings(String s) {
        if (s == null || s.charAt(0) == '0') return 0;
        int n = s.length();
        int[] dp = new int[n + 1];
        dp[0] = 1; dp[1] = 1;
        for (int i = 2; i <= n; i++) {
            if (s.charAt(i - 1) != '0') dp[i] += dp[i-1];
            int two = Integer.parseInt(s.substring(i-2, i));
            if (two >= 10 && two <= 26) dp[i] += dp[i-2];
        }
        return dp[n];
    }
}
```

---

## 🔄 Follow-up Questions
1. **Space optimization?** (Only need `prev` and `prevPrev` → $O(1)$ space.)
2. **Wildcard '*'?** (LeetCode 639 — much more complex branching.)
3. **Complexity?** ($O(N)$ time and space.)
