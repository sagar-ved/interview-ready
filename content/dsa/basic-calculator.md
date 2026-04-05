---
title: "DSA: Basic Calculator (Stack Implementation)"
date: 2024-04-04
draft: false
weight: 45
---

# 🧩 Question: Basic Calculator II (LeetCode 227)
Given a string `s` which represents an expression, evaluate this expression and return its value. The expression contains non-negative integers, `+`, `-`, `*`, `/` and spaces.

## 🎯 What the interviewer is testing
- Operator precedence handling.
- Efficiently parsing and state management.
- Stack-based expression evaluation.

---

## 🧠 Deep Explanation

### The Logic:
We don't need a full recursive tree for this. Since `*` and `/` have higher precedence, we should execute them immediately if possible, while deferred `+` and `-` operations can wait.

1. Maintain a `stack`.
2. Keep track of the `currentNumber` and the `lastOperator` encountered.
3. When we find a new operator or reach the end:
   - If `lastOp == '+'`: `stack.push(currentNumber)`.
   - If `lastOp == '-'`: `stack.push(-currentNumber)`.
   - If `lastOp == '*'`: `stack.push(stack.pop() * currentNumber)`.
   - If `lastOp == '/'`: `stack.push(stack.pop() / currentNumber)`.
4. Update `lastOperator` and reset `currentNumber`.
5. Sum all values in the stack at the end.

---

## ✅ Ideal Answer
For expression evaluation, we use a stack to manage operator precedence. We perform multiplication and division immediately as they are encountered by popping the last value, applying the operation, and pushing it back. Addition and subtraction are handled as signed number additions at the final step.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int calculate(String s) {
        if (s == null || s.isEmpty()) return 0;
        Stack<Integer> stack = new Stack<>();
        int currentNumber = 0;
        char lastOperator = '+';
        
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (Character.isDigit(c)) {
                currentNumber = currentNumber * 10 + (c - '0');
            }
            if (!Character.isDigit(c) && c != ' ' || i == s.length() - 1) {
                if (lastOperator == '+') stack.push(currentNumber);
                if (lastOperator == '-') stack.push(-currentNumber);
                if (lastOperator == '*') stack.push(stack.pop() * currentNumber);
                if (lastOperator == '/') stack.push(stack.pop() / currentNumber);
                
                lastOperator = c;
                currentNumber = 0;
            }
        }
        
        int result = 0;
        while (!stack.isEmpty()) result += stack.pop();
        return result;
    }
}
```

---

## ⚠️ Common Mistakes
- Not handling multi-digit numbers ($10 \times \text{num} + \text{digit}$).
- Forgetting the character check for the very last number in the string.
- Dividing by zero? (The problem usually assumes valid math).

---

## 🔄 Follow-up Questions
1. **Can you solve with $O(1)$ extra space?** (Yes, by maintaining a `lastNumber` variable instead of a stack.)
2. **Handle Parentheses?** (Requires recursion or an additional stack for state — LeetCode 224.)
3. **RPN (Reverse Polish Notation)?** (Stack logic becomes even simpler.)
