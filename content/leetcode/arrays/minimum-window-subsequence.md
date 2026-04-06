---
author: "sagar ved"
title: "LeetCode 727: Minimum Window Subsequence"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 LeetCode 727: Minimum Window Subsequence ⭐ (Hard)
Find the minimum contiguous substring of `s1` such that `s2` is a **subsequence** of that substring.

## 🎯 What the interviewer is testing
- Difference between Substring (contiguous) and Subsequence (ordered, non-contiguous).
- Forward + backward two-pointer scan.
- Why a simple sliding window doesn't work.

---

## 🧠 Deep Explanation

### Why not regular Sliding Window?
Regular sliding window tracks only character **counts**, not **order**. Subsequences require order preservation.

### Forward + Backward Scan:
1. **Forward**: Move `i` through `s1`, `j` through `s2`. When `j` reaches end of `s2`: found a window ending at `i`.
2. **Backward**: From `i`, scan backward matching `s2` in reverse to find the tightest start.
3. Update min-length window. Restart from just after the found start.

---

## ✅ Ideal Answer
After finding a forward match (end of subsequence found), we scan backward to find the minimum starting position. This "tightening" backward pass ensures we capture the shortest possible valid window before moving on.

---

## 💻 Java Code
```java
public class Solution {
    public String minWindow(String S, String T) {
        int sI = 0, tI = 0, minLen = Integer.MAX_VALUE;
        String result = "";
        while (sI < S.length()) {
            if (S.charAt(sI) == T.charAt(tI)) {
                tI++;
                if (tI == T.length()) {
                    int end = sI + 1;
                    tI--;
                    while (tI >= 0) {
                        if (S.charAt(sI) == T.charAt(tI)) tI--;
                        sI--;
                    }
                    sI++;
                    tI = 0;
                    if (end - sI < minLen) { minLen = end - sI; result = S.substring(sI, end); }
                }
            }
            sI++;
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Difference from Min Window Substring (LC 76)?** (LC 76 ignores order, just checks char counts — entirely different algorithm.)
2. **DP approach?** ($O(S \cdot T)$ time and space — generally worse in practice.)
3. **Complexity?** ($O(S \cdot T)$ worst case, $O(S)$ typical.)
