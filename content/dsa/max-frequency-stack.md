---
title: "DSA: Max Frequency Stack"
date: 2024-04-04
draft: false
weight: 97
---

# 🧩 Question: Maximum Frequency Stack (LeetCode 895 - Hard)
Design a stack-like data structure to push elements to the stack and pop the most frequent element from the stack. If there is a tie, the element closest to the stack's top is removed.

## 🎯 What the interviewer is testing
- Complex state management.
- Multi-dimensional data mapping.
- Constant time $O(1)$ operations for frequency.

---

## 🧠 Deep Explanation

### The Challenge:
A standard PriorityQueue is $O(\log N)$ and doesn't handle "ties by stack position" naturally without extra tracking.

### The Strategy (Nested Stacks):
1. **Map 1**: `frequencyMap` -> `Element -> Count`.
2. **Map 2**: `groupMap` -> `Frequency -> Stack of Elements`.
3. **Variable**: `maxFrequency`.

### Operations:
- **Push(x)**:
  - Increment count for `x`.
  - Update `maxFrequency`.
  - Push `x` into `groupMap.get(count)`.
- **Pop()**:
  - Pop from `groupMap.get(maxFrequency)`.
  - Decrement count for element.
  - If that stack is empty, `maxFrequency--`.

---

## ✅ Ideal Answer
To implement a frequency stack with $O(1)$ performance, we use a tiered stack architecture. By mapping each frequency level to its own stack of elements, we naturally resolve the "tie-breaker" requirement through standard LIFO behavior. This approach eliminates the need for expensive sorting or heap adjustments, allowing the structure to scale efficiently regardless of how many duplicate elements are processed.

---

## 💻 Java Code
```java
import java.util.*;

class FreqStack {
    Map<Integer, Integer> freq = new HashMap<>();
    Map<Integer, Stack<Integer>> group = new HashMap<>();
    int maxFreq = 0;

    public void push(int x) {
        int f = freq.getOrDefault(x, 0) + 1;
        freq.put(x, f);
        maxFreq = Math.max(maxFreq, f);
        group.computeIfAbsent(f, k -> new Stack<>()).push(x);
    }

    public int pop() {
        int x = group.get(maxFreq).pop();
        freq.put(x, freq.get(x) - 1);
        if (group.get(maxFreq).size() == 0) maxFreq--;
        return x;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Complexity?** ($O(1)$ for both push and pop.)
2. **Space complexity?** ($O(N)$ where $N$ is number of elements.)
3. **What if we want to remove a SPECIFIC element?** (Much harder; would likely require a custom doubly-linked structure or Lazy Deletions.)
