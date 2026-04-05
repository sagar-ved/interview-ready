---
title: "DSA: Minimum Window Subsequence"
date: 2024-04-04
draft: false
weight: 67
---

# 🧩 Question: Minimum Window Subsequence (LeetCode 727 - Hard)
Given strings `s1` and `s2`, return the minimum contiguous substring of `s1` such that `s2` is a subsequence of the substring.

## 🎯 What the interviewer is testing
- Difference between Substring and Subsequence.
- Two Pointers starting from a match.
- Backward scan for optimization.

---

## 🧠 Deep Explanation

### The Challenge:
"Subsequence" means order must be maintained, but characters don't have to be adjacent. However, the result must be a "Contiguous Substring."

### Algorithm:
1. **Find forward**: Use two pointers to find a window where `s2` is a subsequence of `s1[i..j]`.
2. **Find backward**: Once you find the end of `s2` at `j`, move backward from `j` to find the **best/latest** possible starting point for `s2`. This shrinks the window.
3. Update `minLen` and repeat from the next character.

---

## ✅ Ideal Answer
This problem is solved using a "forward and backward" two-pointer search. We first scan linearly to find the earliest point where the entire target subsequence is satisfied. We then scan back from that endpoint to find the tightest possible starting point for the window. This ensures we don't pick an unnecessarily large substring.

---

## 💻 Java Code
```java
public class Solution {
    public String minWindow(String S, String T) {
        int sIndex = 0, tIndex = 0;
        int minLen = Integer.MAX_VALUE;
        String result = "";

        while (sIndex < S.length()) {
            if (S.charAt(sIndex) == T.charAt(tIndex)) {
                tIndex++;
                if (tIndex == T.length()) {
                    // Match found, now shrink from right to left
                    int end = sIndex + 1;
                    tIndex--;
                    while (tIndex >= 0) {
                        if (S.charAt(sIndex) == T.charAt(tIndex)) {
                            tIndex--;
                        }
                        sIndex--;
                    }
                    sIndex++;
                    tIndex = 0;
                    
                    if (end - sIndex < minLen) {
                        minLen = end - sIndex;
                        result = S.substring(sIndex, end);
                    }
                }
            }
            sIndex++;
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Complexity?** ($O(S \cdot T)$ in worst case, but $O(S)$ in practice.)
2. **Difference from Minimum Window Substring?** (That problem ignores order and just cares about character counts.)
3. **Can you use DP?** (Yes, but the logic is more complex to implement and usually takes more space.)
