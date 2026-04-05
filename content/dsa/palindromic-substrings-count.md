---
title: "DSA: Palindromic Substrings"
date: 2024-04-04
draft: false
weight: 65
---

# 🧩 Question: Palindromic Substrings (LeetCode 647)
Given a string `s`, return the number of palindromic substrings in it.

## 🎯 What the interviewer is testing
- Efficient palindrome counting.
- Expanding around possible centers.
- $O(N^2)$ vs $O(N^3)$ (brute force).

---

## 🧠 Deep Explanation

### The Logic:
Every char in the string is a potential "center" for an odd-length palindrome. Every space between two characters is a potential center for an even-length palindrome.
There are $2N - 1$ total centers in a string of length $N$.

### Algorithm:
1. Iterate through each of the $2N - 1$ centers.
2. Expand outwards as long as the leftmost and rightmost characters are equal.
3. Increment `count` for each expansion step.

---

## ✅ Ideal Answer
To count all palindromic substrings, we treat each character and each gap between characters as a potential center and expand outwards. This $O(N^2)$ approach is more efficient than the $O(N^3)$ brute force of checking every substring individually, as it avoids redundant checks by building on top of previously identified palindromes.

---

## 💻 Java Code
```java
public class Solution {
    int count = 0;
    public int countSubstrings(String s) {
        for (int i = 0; i < s.length(); i++) {
            expandAroundCenter(s, i, i);     // Odd
            expandAroundCenter(s, i, i + 1); // Even
        }
        return count;
    }

    private void expandAroundCenter(String s, int left, int right) {
        while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
            count++;
            left--;
            right++;
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can this be done in $O(N)$?** (Yes, Manacher's Algorithm, though rare in interviews.)
2. **Difference between substring and subsequence?** (Substring is contiguous.)
3. **What is the space complexity?** ($O(1)$ constant space.)
