---
author: "sagar ved"
title: "LeetCode 227: Basic Calculator II"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 LeetCode 227: Basic Calculator II (Medium)
Evaluate a string expression with `+`, `-`, `*`, `/` and non-negative integers.

## 🎯 What the interviewer is testing
- Operator precedence via stack deferral.
- Parsing multi-digit numbers from string.
- Executing high-precedence ops immediately.

---

## 🧠 Deep Explanation

### Key Insight: Operator Precedence
- `*` and `/` must execute immediately (higher precedence).
- `+` and `-` are deferred by pushing signed numbers onto the stack.

### Algorithm:
1. Track `curNum` and `lastOp` (previous operator, init `+`).
2. At each operator or end-of-string:
   - `+`: push `curNum`
   - `-`: push `-curNum`
   - `*`: push `stack.pop() * curNum`
   - `/`: push `stack.pop() / curNum`
3. Sum everything in the stack.

---

## ✅ Ideal Answer
By deferring additions and subtractions to the stack (as signed values) and executing multiplications and divisions immediately via `pop → compute → push`, we naturally respect operator precedence without building an AST.

---

## 💻 Java Code
```java
public class Solution {
    public int calculate(String s) {
        Deque<Integer> stack = new ArrayDeque<>();
        int curNum = 0;
        char lastOp = '+';
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (Character.isDigit(c)) curNum = curNum * 10 + (c - '0');
            if ((!Character.isDigit(c) && c != ' ') || i == s.length() - 1) {
                if (lastOp == '+') stack.push(curNum);
                else if (lastOp == '-') stack.push(-curNum);
                else if (lastOp == '*') stack.push(stack.pop() * curNum);
                else if (lastOp == '/') stack.push(stack.pop() / curNum);
                lastOp = c;
                curNum = 0;
            }
        }
        return stack.stream().mapToInt(x -> x).sum();
    }
}
```

---

## 🔄 Follow-up Questions
1. **With parentheses (LC 224)?** (Need recursion or parenthesis-aware stack to handle nested scopes.)
2. **$O(1)$ space?** (Replace stack with `lastNum` variable — only feasible without `*`/`/`.)
3. **RPN evaluation?** (Much simpler: only a value stack, no operator state needed.)
