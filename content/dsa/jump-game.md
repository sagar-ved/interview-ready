---
title: "DSA: Jump Game I & II"
date: 2024-04-04
draft: false
weight: 60
---

# 🧩 Question: Jump Game (LeetCode 55, 45)
Given an array `nums` where each element represents your maximum jump length at that position, determine if you can reach the last index (I) and find the **minimum jumps** to reach it (II).

## 🎯 What the interviewer is testing
- Greedy vs DP.
- Maintaining "Range" or "Reach" states.
- Optimizing from $O(N^2)$ to $O(N)$.

---

## 🧠 Deep Explanation

### Jump Game I (True/False):
Maintain a `maxReach` variable. Iterate through the array; if current `i > maxReach`, you can't proceed. Update `maxReach = max(maxReach, i + nums[i])`. If `maxReach >= lastIndex`, return true.

### Jump Game II (Minimum Jumps):
Use Greedy and think in "levels" (like a 1D BFS).
- `maxReach`: The furthest index you can reach with **one more** jump.
- `currentEnd`: The end of the current jump's range.
- **When `i == currentEnd`**, you MUST take a jump. Increment `jumps` and update `currentEnd = maxReach`.

---

## ✅ Ideal Answer
For reachability, we greedily track the furthest possible index attainable at any step. For minimum jumps, we consider the current range of our previous jump and only increment our counter when we've exhausted all possibilities within that range, always preparing the widest possible next range. This results in an $O(N)$ linear scan.

---

## 💻 Java Code: Jump Game II
```java
public class Solution {
    public int jump(int[] nums) {
        int jumps = 0, currentEnd = 0, maxReach = 0;
        for (int i = 0; i < nums.length - 1; i++) {
            maxReach = Math.max(maxReach, i + nums[i]);
            if (i == currentEnd) {
                jumps++;
                currentEnd = maxReach;
            }
        }
        return jumps;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can it be solved with BFS?** (Yes, each "level" is a jump, but it's more space-intensive.)
2. **Dynamic Programming?** ($O(N^2)$ is too slow.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space.)
