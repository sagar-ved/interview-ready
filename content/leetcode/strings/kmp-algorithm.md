---
author: "sagar ved"
title: "LeetCode 1392: Longest Happy Prefix (KMP)"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 LeetCode 1392: Longest Happy Prefix (KMP) (Hard)
A "happy prefix" is a non-empty prefix that is also a suffix (excluding the string itself). Return the longest one.

## 🎯 What the interviewer is testing
- KMP failure function (LPS array).
- String matching and prefix-suffix relationships.
- Building the foundation for KMP pattern search.

---

## 🧠 Deep Explanation

### This is exactly the KMP preprocessing phase:
The KMP `lps[]` table: `lps[i]` = length of the longest proper prefix of `s[0..i]` that is also a suffix.

### Building LPS:
- Two pointers: `i` (current), `len` (length of current match).
- If `s[i] == s[len]`: `lps[i] = ++len`.
- Else if `len > 0`: fall back to `lps[len-1]` (don't reset to 0).
- Else: `lps[i] = 0`.

Result = `s.substring(0, lps[n-1])`.

---

## ✅ Ideal Answer
The KMP preprocessing phase builds the LPS table in $O(N)$ by reusing previously computed matches. `lps[n-1]` gives the length of the longest prefix-suffix of the entire string.

---

## 💻 Java Code
```java
public class Solution {
    public String longestPrefix(String s) {
        int n = s.length();
        int[] lps = new int[n];
        int len = 0, i = 1;
        while (i < n) {
            if (s.charAt(i) == s.charAt(len)) {
                lps[i++] = ++len;
            } else if (len > 0) {
                len = lps[len - 1];
            } else {
                lps[i++] = 0;
            }
        }
        return s.substring(0, lps[n - 1]);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Full KMP Search?** (Use LPS table to skip re-comparisons during pattern matching — $O(N + M)$.)
2. **Shortest Palindrome?** (LC 214: Create `s + "#" + reverse(s)`, run KMP, use `lps[last]`.)
3. **Proper prefix?** (A prefix strictly shorter than the full string itself.)
