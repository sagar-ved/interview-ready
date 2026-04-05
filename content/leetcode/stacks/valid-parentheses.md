---
title: "LeetCode 20: Valid Parentheses"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Valid Parentheses (LeetCode 20)
Given a string with `(`, `)`, `{`, `}`, `[`, `]` — determine if the input string is valid.

## 🎯 What the interviewer is testing
- Fundamental Stack (LIFO) usage.
- Complementary symbol matching.
- Handling edge cases (empty stack, unmatched closers).

---

## 🧠 Deep Explanation

### The Logic:
We need a structure that remembers the **last** opened bracket and expects it to be closed **first** — that's exactly what a Stack does.

1. Iterate each character.
2. If opening bracket → push expected closer.
3. If closing bracket → check if stack is empty or top doesn't match → invalid.
4. At end → stack must be empty.

**Trick**: Push the expected **closer** (not the opener), so the match check is a simple `pop() != c`.

---

## ✅ Ideal Answer
We push the expected close bracket every time we see an open bracket. When we encounter a close bracket, we simply check if it matches the top of the stack. This way the matching logic is a single comparison.

---

## 💻 Java Code
```java
public class Solution {
    public boolean isValid(String s) {
        Deque<Character> stack = new ArrayDeque<>();
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
1. **Space complexity?** ($O(N)$ for the stack.)
2. **Only one type of bracket?** (Just a counter: increment for open, decrement for close, check it stays ≥ 0.)
3. **`Stack` vs `Deque`?** (`java.util.Stack` is legacy/synchronized; prefer `ArrayDeque` for O(1) push/pop.)
