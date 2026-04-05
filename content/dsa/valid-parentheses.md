---
title: "DSA: Validate Parentheses (Basic)"
date: 2024-04-04
draft: false
weight: 48
---

# 🧩 Question: Valid Parentheses (LeetCode 20)
Given a string `s` containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

## 🎯 What the interviewer is testing
- Fundamental understanding of Stacks (LIFO).
- Complementary symbol matching.

---

## 🧠 Deep Explanation

### The Logic:
We need a structure that remembers the *last* opened bracket and expects it to be closed *first*. This is exactly how a Stack works.

1. Create a `Stack`.
2. Iterate through the string:
   - If it's an opening bracket `(`, `[`, `{`, push it.
   - If it's a closing bracket:
     - Check if stack is empty (invalid).
     - Pop the top. If the popped bracket doesn't match the current closer, invalid.
3. At the end, if stack is empty, it's valid.

---

## ✅ Ideal Answer
We use a stack to track opening brackets. For every closing bracket, we verify it matches the most recent opening bracket currently at the top of the stack. If the stack is empty at the end, all brackets were correctly paired and closed.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public boolean isValid(String s) {
        Stack<Character> stack = new Stack<>();
        for (char c : s.toCharArray()) {
            if (c == '(') stack.push(')');
            else if (c == '{') stack.push('}');
            else if (c == '[') stack.push(']');
            else if (stack.isEmpty() || stack.pop() != c) return false;
        }
        return stack.isEmpty();
    }
}
```

---

## 🔄 Follow-up Questions
1. **What is the space complexity?** ($O(N)$ for the stack.)
2. **Can you solve it without a Stack for just ONE type of bracket?** (Yes, use a simple counter; increment for `(` and decrement for `)`.)
3. **Why use `Stack` vs `Deque` in Java?** (`java.util.Stack` is legacy and synchronized; `ArrayDeque` is safer and faster for most modern use cases.)
