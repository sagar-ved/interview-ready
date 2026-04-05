---
title: "LeetCode 139: Word Break"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: Word Break (LeetCode 139)
Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a sequence of dictionary words.

## 🎯 What the interviewer is testing
- Overlapping subproblems in string parsing.
- 1D Dynamic Programming.
- Using HashSet for $O(1)$ dictionary lookups.

---

## 🧠 Deep Explanation

### The DP Logic:
Let `dp[i]` = true if `s[0..i-1]` can be segmented using dictionary words.
- `dp[0] = true` (empty string).
- For each `i`, for each `j < i`: if `dp[j] == true` AND `s[j..i-1]` is in the dictionary → `dp[i] = true`.

### Optimization:
Limit the inner loop using the max word length in the dictionary.

---

## ✅ Ideal Answer
We use a boolean DP array representing reachable string positions. For every position `i`, we look back at previous reachable positions `j` and check if the word `s[j..i]` exists in our HashSet dictionary.

---

## 💻 Java Code
```java
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
- Not using a HashSet ($O(N)$ lookup on List is slow).
- DFS without memoization → $O(2^N)$.

---

## 🔄 Follow-up Questions
1. **Word Break II?** (Return all valid sentences — Backtracking + Memoization.)
2. **Complexity?** ($O(N^2)$ general; $O(N \cdot L)$ with max word-length optimization.)
