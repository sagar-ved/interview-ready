---
title: "DSA: Longest Happy Prefix"
date: 2024-04-04
draft: false
weight: 70
---

# 🧩 Question: Longest Happy Prefix (LeetCode 1392)
A string is called a "happy prefix" if is a non-empty prefix which is also a suffix (excluding itself). Given a string `s`, return the longest happy prefix of `s`.

## 🎯 What the interviewer is testing
- String matching algorithms (KMP).
- Understanding "Failure Function" / LPS (Longest Prefix Suffix).

---

## 🧠 Deep Explanation

### The Logic:
This is exactly the core of the **KMP (Knuth-Morris-Pratt)** algorithm.
We need to build the **LPS table** for the string `s`. The LPS table `lps[i]` stores the length of the longest proper prefix of `s[0..i]` that is also a suffix of `s[0..i]`.

### Algorithm (KMP preprocessing):
1. Use two pointers `i = 1` and `length = 0`.
2. If `s[i] == s[length]`, it's a match. `lps[i] = ++length`.
3. If no match and `length > 0`, slide `length` back to `lps[length - 1]` and try again.
4. The result for the entire string is `s.substring(0, lps[n-1])`.

---

## ✅ Ideal Answer
To find the longest prefix that is also a suffix, we use the preprocessing phase of the KMP algorithm. This efficiently builds a table of matches using dynamic programming, allowing us to find the longest "happy" boundary in $O(N)$ time without re-comparing substrings repeatedly.

---

## 💻 Java Code
```java
public class Solution {
    public String longestPrefix(String s) {
        int n = s.length();
        int[] lps = new int[n];
        int j = 0;
        for (int i = 1; i < n; i++) {
            while (j > 0 && s.charAt(i) != s.charAt(j)) {
                j = lps[j - 1];
            }
            if (s.charAt(i) == s.charAt(j)) {
                j++;
            }
            lps[i] = j;
        }
        return s.substring(0, lps[n - 1]);
    }
}
```

---

## 🔄 Follow-up Questions
1. **Shortest Palindrome?** (LeetCode 214: Find LPS of `s + "#" + reverse(s)` and prepend the remaining reverse to `s`.)
2. **KMP time complexity?** ($O(N)$ for building the table.)
3. **What is a "Proper" prefix?** (A prefix that is strictly shorter than the string itself.)
