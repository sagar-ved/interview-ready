---
title: "LeetCode 155: Min Stack"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 LeetCode 155: Min Stack (Medium)
Design a stack that supports `push`, `pop`, `top`, and `getMin` — all in $O(1)$.

## 🎯 What the interviewer is testing
- Auxiliary data structure design.
- Maintaining state across operations.
- $O(1)$ minimum lookup without sorting.

---

## 🧠 Deep Explanation

### The Problem:
After popping, how do we know the new minimum without scanning?

### Two-Stack Approach:
- `stack`: main data stack.
- `minStack`: tracks the current minimum at each level.

When pushing `x`:
- Push `x` to `stack`.
- Push `min(x, minStack.peek())` to `minStack`.

When popping from `stack`, also pop from `minStack`.

`getMin()` always peeks the top of `minStack`.

---

## ✅ Ideal Answer
By maintaining a parallel "min stack" that always holds the current minimum at each depth, we capture the minimum after every push and restore it correctly after every pop. This ensures $O(1)$ for all operations.

---

## 💻 Java Code
```java
class MinStack {
    Deque<Integer> stack = new ArrayDeque<>();
    Deque<Integer> minStack = new ArrayDeque<>();

    public void push(int val) {
        stack.push(val);
        minStack.push(minStack.isEmpty() ? val : Math.min(val, minStack.peek()));
    }

    public void pop() { stack.pop(); minStack.pop(); }
    public int top() { return stack.peek(); }
    public int getMin() { return minStack.peek(); }
}
```

---

## 🔄 Follow-up Questions
1. **Single-stack approach?** (Store pairs `(value, minAtThisPoint)` as custom objects — same idea, one stack.)
2. **Max Stack?** (Symmetric design with a `maxStack`.)
3. **What if we need K-th minimum?** (Two stacks won't work — need a different data structure like an Order Statistics Tree.)
