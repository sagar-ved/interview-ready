---
title: "DSA: Longest Consecutive Sequence (O(N))"
date: 2024-04-04
draft: false
weight: 72
---

# 🧩 Question: Longest Consecutive Sequence (LeetCode 128)
Given an unsorted array of integers `nums`, return the length of the longest consecutive elements sequence. The algorithm must run in $O(N)$ time.

## 🎯 What the interviewer is testing
- Efficient array searching.
- Using **HashSet** to achieve $O(1)$ lookup.
- Avoiding redundant inner loops.

---

## 🧠 Deep Explanation

### Why $O(N \log N)$ is bad:
Sorting the array takes $O(N \log N)$ and then scanning it takes $O(N)$. The interviewer specifically asks for $O(N)$.

### The Linear ($O(N)$) Logic:
1. Put all numbers in a **HashSet**.
2. Iterate through each number `n`.
3. To find the START of a sequence, check if `n - 1` is in the set.
   - If `n - 1` is NOT in the set: `n` is the beginning. Start counting `n, n+1, n+2...` as long as they exist in the set.
   - If `n - 1` IS in the set: Ignore this `n` for now (it will be picked up as part of a sequence that starts earlier).

### Why is this $O(N)$?
Every number is visited exactly twice: Once in the outer loop, and once in the inner "counting" loop across all sequence attempts.

---

## ✅ Ideal Answer
To find the longest sequence in $O(N)$, we use a HashSet for constant-time complexity. By only initiating a "count" when we find the absolute minimum value of a specific sequence (checked by confirming its predecessor is absent from the set), we ensure that each element is processed a small, finite number of times across the entire algorithm execution.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int longestConsecutive(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for (int num : nums) set.add(num);
        
        int longest = 0;
        for (int num : set) {
            // Only start counting if it's the start of a sequence
            if (!set.contains(num - 1)) {
                int currentNum = num;
                int currentStreak = 1;
                
                while (set.contains(currentNum + 1)) {
                    currentNum++;
                    currentStreak++;
                }
                longest = Math.max(longest, currentStreak);
            }
        }
        return longest;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Does the input size affect the Set performance?** (HashSets can degrade if collisions occur, but on average it's true $O(N)$.)
2. **What if the numbers are negative?** (Set handles them correctly.)
3. **Difference from "Longest Increasing Subsequence"?** (LIS allows skipping numbers; "Consecutive" means values must be $N, N+1, N+2...$)
