---
title: "DSA: Word Break"
date: 2024-04-04
draft: false
weight: 50
---

# 🧩 Question: Word Break (LeetCode 139)
Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

## 🎯 What the interviewer is testing
- Identifying overlapping subproblems in string parsing.
- Dynamic Programming (1D).
- Optimization with word lengths.

---

## 🧠 Deep Explanation

### The Logic:
Let `dp[i]` be true if the substring `s[0..i-1]` can be segmented using dictionary words.
1. Base Case: `dp[0] = true` (empty string).
2. For each `i` from 1 to `s.length()`:
   - For each `j` from 0 to `i-1`:
     - If `s[j..i-1]` is in `wordDict` AND `dp[j]` is true, then `dp[i] = true`.

### Optimization:
Instead of checking all `j` from 0 to `i-1`, we only check `j` such that `i - j <= maxLengthOfWordInDict`. This reduces the inner loop complexity.

---

## ✅ Ideal Answer
To solve this efficiently, we use a boolean DP array representing which positions in the string can be reached by a sequence of dictionary words. For every position `i`, we look back at previous reachable positions `j` and check if the word `s[j..i]` exists in our dictionary. This gives an $O(N \cdot L)$ time complexity where $N$ is string length and $L$ is the max word length.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public boolean wordBreak(String s, List<String> wordDict) {
        Set<String> set = new HashSet<>(wordDict);
        boolean[] dp = new boolean[s.length() + 1];
        dp[0] = true;

        for (int i = 1; i <= s.length(); i++) {
            for (int j = 0; j < i; j++) {
                if (dp[j] && set.contains(s.substring(j, i))) {
                    dp[i] = true;
                    break;
                }
            }
        }
        return dp[s.length()];
    }
}
```

---

## ⚠️ Common Mistakes
- Not using a `HashSet` for $O(1)$ lookups in the dictionary.
- Trying a depth-first search without memoization ($O(2^N)$ complexity).
- Off-by-one errors in indices for the `dp` and `substring`.

---

## 🔄 Follow-up Questions
1. **Word Break II?** (LeetCode 140: Instead of true/false, return all valid sentence combinations. Requires Backtracking + Memoization.)
2. **What if the words have overlapping prefixes?** (DP handles this correctly; simple greedy check does not.)
3. **What is the complexity?** ($O(N^2)$ for building substrings and checking set; optimized to $O(N \cdot L)$ with max word length.)
