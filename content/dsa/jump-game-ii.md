---
title: "DSA: Jump Game II"
date: 2024-04-04
draft: false
weight: 28
---

# 🧩 Question: Jump Game II (LeetCode 45)
You are given a 0-indexed array of integers `nums`. Each element `nums[i]` represents the maximum length of a forward jump from index `i`. You are initially positioned at `nums[0]`. Return the minimum number of jumps to reach `nums[n - 1]`.

## 🎯 What the interviewer is testing
- Optimal strategy (Greedy).
- Range-based thinking (BFS-like strategy).
- Reducing $O(N^2)$ DP to $O(N)$.

---

## 🧠 Deep Explanation

### The Greedy Approach:
Instead of exploring all possible jumps, we maintain the **current jump's range** and find how far we can jump from *anywhere* in that range.

1. `farthest`: The furthest we can reach from the current index.
2. `end`: The boundary of the current jump.
3. `jumps`: Count of jumps taken.

As we iterate, we update `farthest`. When we reach `end`, we increment `jumps` and update `end = farthest`.

---

## ✅ Ideal Answer
We use a greedy approach to compute the furthest point reachable within each jump's range. Effectively, we treat this as a BFS level-by-level traversal where each "jump" is a level.

---

## 💻 Java Code
```java
public class Solution {
    public int jump(int[] nums) {
        int jumps = 0, currentEnd = 0, farthest = 0;
        // Don't process the last element as we're already there 
        // if the jump count is incremented at the previous end.
        for (int i = 0; i < nums.length - 1; i++) {
            farthest = Math.max(farthest, i + nums[i]);
            if (i == currentEnd) {
                jumps++;
                currentEnd = farthest;
            }
        }
        return jumps;
    }
}
```

---

## ⚠️ Common Mistakes
- Processing the loop until `nums.length` (can lead to an extra jump count).
- Not updating `farthest` correctly.
- Over-complicating with Dynamic Programming ($O(N^2)$ is too slow).

---

## 🔄 Follow-up Questions
1. **Difference from Jump Game I?** (In I, you only need to return if it's POSSIBLE — simpler greedy.)
2. **Can there be multiple paths?** (Yes, but greedy ensures minimum.)
3. **What if some values are 0?** (The current range `farthest` might never reach `n-1`.)
