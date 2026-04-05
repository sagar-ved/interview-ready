---
title: "LeetCode 739: Daily Temperatures"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 739: Daily Temperatures (Medium)
Given daily temperatures, for each day return how many days until a warmer temperature. Return 0 if no such day exists.

## 🎯 What the interviewer is testing
- Monotonic Stack (decreasing).
- "Next Greater Element" pattern.
- Index arithmetic for distance.

---

## 🧠 Deep Explanation

### Pattern: Next Greater Element
This is the classic "Next Greater Element" problem. We use a **decreasing monotonic stack** of indices.

Algorithm:
1. For each temperature `T[i]`:
2. While stack is not empty AND `T[i] > T[stack.top]`:
   - Pop `j` from stack.
   - `result[j] = i - j` (days to wait).
3. Push `i` onto the stack.
4. Remaining indices in stack → wait 0 days.

---

## ✅ Ideal Answer
We maintain a stack of "unsatisfied" cold days. When we find a warmer day, we retroactively fill in the wait time for all previous days in the stack that are colder than today.

---

## 💻 Java Code
```java
public class Solution {
    public int[] dailyTemperatures(int[] temperatures) {
        int n = temperatures.length;
        int[] result = new int[n];
        Deque<Integer> stack = new ArrayDeque<>();
        for (int i = 0; i < n; i++) {
            while (!stack.isEmpty() && temperatures[i] > temperatures[stack.peek()]) {
                int j = stack.pop();
                result[j] = i - j;
            }
            stack.push(i);
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Next Greater Element I & II (circular)?** (LeetCode 496, 503: Extend the input by iterating twice for circular.)
2. **Nearest Smaller to the Left?** (Same pattern, monotonic increasing stack, traversing left to right.)
3. **Complexity?** ($O(N)$ time — each element pushed and popped at most once.)
