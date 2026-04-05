---
title: "DSA: Manacher's Algorithm (O(N) Palindromes)"
date: 2024-04-04
draft: false
weight: 79
---

# 🧩 Question: How can you find the Longest Palindromic Substring in O(N)? Explain Manacher's Algorithm.

## 🎯 What the interviewer is testing
- Advanced string algorithm awareness.
- Symmetry-based optimization.
- Handling odd/even lengths with a unified model.

---

## 🧠 Deep Explanation

### 1. The Pre-match (Universalize):
To handle even/odd palindromes identically, insert a special character (e.g. `#`) between every char:
`"aba" -> "#a#b#a#"`
Now every center is a character, and every palindrome has an odd length.

### 2. The Symmetry Secret:
If we have a huge palindrome with index `CENTER`, any palindrome found inside its left side has a mirror on the right side. 
- We maintain `R` (the furthest right reach of any palindrome) and `C` (its center).
- If current `i < R`: 
  - `i_mirror = 2*C - i`
  - We can skip some expansion because we know `L[i]` is at least `min(R - i, L[i_mirror])`.

### 3. Result:
We only truly "expand" when we are forced to move `R` further right.

---

## ✅ Ideal Answer
Manacher's Algorithm achieves $O(N)$ by reuse of symmetry. By tracking the "rightmost reach" of existing palindromes, we can avoid redundant comparisons for all characters that lie within a previously mapped symmetric boundary. While the setup is more complex than simple expansion, it provides a strictly linear guarantee for string-heavy processing tasks.

---

## 🏗️ Performance Index:
- **Brute Force**: $O(N^3)$ (Compare all pairs)
- **Expansion/DP**: $O(N^2)$
- **Manacher's**: $O(N)$ (One single linear scan)

---

## 🔄 Follow-up Questions
1. **Can this find all palindromes?** (Yes, the total count and the longest.)
2. **Is it common in production?** (Rarely. $O(N^2)$ expansion is usually "fast enough" and much easier to maintain, but Manacher's is the "Staff+ level" answer.)
3. **Space complexity?** ($O(N)$ to store the radius array.)
