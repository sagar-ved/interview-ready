---
title: "DSA: Edit Distance"
date: 2024-04-04
draft: false
weight: 37
---

# 🧩 Question: Edit Distance (LeetCode 72)
Given two strings `word1` and `word2`, return the minimum number of operations required to convert `word1` to `word2`. You have three operations: Insert, Delete, and Replace.

## 🎯 What the interviewer is testing
- Complex 2D Dynamic Programming.
- Identifying overlapping subproblems in string conversion.
- Understanding transformation costs.

---

## 🧠 Deep Explanation

### The Logic:
Let `dp[i][j]` be the minimum edit distance between `word1[0..i-1]` and `word2[0..j-1]`.

1. **If characters match**: `word1[i-1] == word2[j-1]`:
   - No cost. `dp[i][j] = dp[i-1][j-1]`.
2. **If characters don't match**:
   - **Insert**: `1 + dp[i][j-1]`
   - **Delete**: `1 + dp[i-1][j]`
   - **Replace**: `1 + dp[i-1][j-1]`
   - `dp[i][j] = 1 + min(Insert, Delete, Replace)`.

### Base Case:
Mapping an empty string to a string of length $L$ requires $L$ insertions.

---

## ✅ Ideal Answer
Edit distance measures how different two strings are. By recursively calculating the cost of inserting, deleting, or replacing characters at each position, and using a DP table to cache results, we achieve an $O(M \cdot N)$ time complexity. This is the foundation of fuzzy matching and spell checking.

---

## 💻 Java Code
```java
public class Solution {
    public int minDistance(String word1, String word2) {
        int m = word1.length(), n = word2.length();
        int[][] dp = new int[m + 1][n + 1];

        for (int i = 0; i <= m; i++) dp[i][0] = i;
        for (int j = 0; j <= n; j++) dp[0][j] = j;

        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (word1.charAt(i - 1) == word2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    int insert = dp[i][j - 1];
                    int delete = dp[i - 1][j];
                    int replace = dp[i - 1][j - 1];
                    dp[i][j] = 1 + Math.min(insert, Math.min(delete, replace));
                }
            }
        }
        return dp[m][n];
    }
}
```

---

## ⚠️ Common Mistakes
- Mis-indexing the base cases (must represent length 0 to N).
- Forgetting that "Replace" takes you from `(i-1, j-1)`.
- Swapping insertion/deletion logic (though result stays the same here).

---

## 🔄 Follow-up Questions
1. **Can you solve in $O(N)$ space?** (Yes, only need current and previous row.)
2. **What is Levenshtein distance?** (This algorithm IS the Levenshtein distance.)
3. **What if the operations have different costs?** (Just replace `1 + ...` with `cost[op] + ...`.)
