---
title: "DSA: Longest Valid Parentheses"
date: 2024-04-04
draft: false
weight: 43
---

# 🧩 Question: Longest Valid Parentheses (LeetCode 32)
Given a string containing just the characters '(' and ')', return the length of the longest valid (well-formed) parentheses substring.

## 🎯 What the interviewer is testing
- Stack applications for balanced symbols.
- Dynamic Programming for "matching" structures.
- Optimal space-time trade-off (Two-pass $O(1)$ space).

---

## 🧠 Deep Explanation

### Approaches:
1. **Dynamic Programming** ($O(N)$ time, $O(N)$ space):
   - Let `dp[i]` be the length of the longest valid parentheses ending at `i`.
   - If `s[i] == ')'`:
     - If `s[i-1] == '('`: `dp[i] = dp[i-2] + 2`.
     - Else if `s[i-1] == ')'` and `s[i-dp[i-1]-1] == '('`: `dp[i] = dp[i-1] + dp[i-dp[i-1]-2] + 2`.

2. **Stack** ($O(N)$ time, $O(N)$ space):
   - Store indices in the stack. Initialize stack with `-1`.
   - For `s[i] == '('`: Push `i`.
   - For `s[i] == ')'`:
     - Pop. If stack is empty, push `i` (new boundary). 
     - Else, `length = i - stack.peek()`.

3. **Two Pass (Counter)** ($O(N)$ time, $O(1)$ space):
   - One pass left-to-right, one pass right-to-left. 
   - Count `left` and `right`. If `left == right`, record max. 
   - Reset if a side exceeds the other (meaning the substring is broken).

---

## ✅ Ideal Answer
To solve this in linear time with constant space, we can do two passes across the string using simple counters. In the left-to-right pass, we reset our counts if more closing parentheses are encountered than opening ones. Symmetrically, we handle the right-to-left pass to capture cases leading with excessive opening parentheses.

---

## 💻 Java Code: Stack Approach
```java
import java.util.*;

public class Solution {
    public int longestValidParentheses(String s) {
        int maxLen = 0;
        Stack<Integer> stack = new Stack<>();
        stack.push(-1); // Base for calculations

        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '(') {
                stack.push(i);
            } else {
                stack.pop();
                if (stack.isEmpty()) {
                    stack.push(i); // New start index
                } else {
                    maxLen = Math.max(maxLen, i - stack.peek());
                }
            }
        }
        return maxLen;
    }
}
```

---

## ⚠️ Common Mistakes
- Not initializing the stack correctly (`-1` is needed for calculation).
- Forgetting to handle the "unbalanced opening" case in the one-pass approach.
- Over-complicating with a nested $O(N^2)$ scan.

---

## 🔄 Follow-up Questions
1. **Can you solve in $O(1)$ space?** (Yes, the two-pass approach.)
2. **What is the $O(1)$ space code?** (Count `left`/`right`, update `max` when `left == right`, reset when `right > left`.)
3. **Difference between valid parentheses vs longest valid?** (Valid requires the WHOLE string to be balanced; longest valid is any substring.)
