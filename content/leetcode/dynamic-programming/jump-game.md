---
title: "LeetCode 55 & 45: Jump Game I & II"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Jump Game I & II (LeetCode 55, 45)
Each element in `nums` represents your max jump length. Determine if you can reach the last index (I), and find the minimum number of jumps to reach it (II).

## 🎯 What the interviewer is testing
- Greedy vs DP approach.
- Maintaining a "reach" or "range" state.
- Optimizing from $O(N^2)$ to $O(N)$.

---

## 🧠 Deep Explanation

### Jump Game I (Can you reach the end?):
Track `maxReach`. If `i > maxReach` at any point, you're stuck. Update `maxReach = max(maxReach, i + nums[i])`.

### Jump Game II (Minimum Jumps):
Think in "levels" — like 1D BFS:
- `maxReach`: Furthest index reachable with one more jump.
- `currentEnd`: Range boundary of the current jump.
- When `i == currentEnd` → must take a jump → increment `jumps`, update `currentEnd = maxReach`.

---

## ✅ Ideal Answer
For minimum jumps, we greedily track what's reachable within the current jump's range. When we exhaust that range without reaching the end, we commit to a jump extending to the farthest seen point.

---

## 💻 Java Code: Jump Game II
```java
public class Solution {
    public int jump(int[] nums) {
        int jumps = 0, currentEnd = 0, maxReach = 0;
        for (int i = 0; i < nums.length - 1; i++) {
            maxReach = Math.max(maxReach, i + nums[i]);
            if (i == currentEnd) { jumps++; currentEnd = maxReach; }
        }
        return jumps;
    }
}
```

---

## 🔄 Follow-up Questions
1. **BFS approach?** (Yes, each "level" is a jump, but more space-intensive.)
2. **DP approach?** ($O(N^2)$ — too slow.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space.)
