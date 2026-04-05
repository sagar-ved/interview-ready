---
title: "DSA: Merge Intervals"
date: 2024-04-04
draft: false
weight: 38
---

# 🧩 Question: Merge Intervals (LeetCode 56)
Given an array of `intervals` where `intervals[i] = [start_i, end_i]`, merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.

## 🎯 What the interviewer is testing
- Sorting based on custom objects/arrays.
- Greedy merging logic.
- Range-based problem solving.

---

## 🧠 Deep Explanation

### The Algorithm:
1. **Sort** the intervals by their start time. This is critical because it ensures that if interval A overlaps with another, that other must be its neighbor or close successor.
2. Maintain a `current` interval (starting with the first one).
3. Iterate through the rest:
   - If `next.start <= current.end`: They overlap. Update `current.end = max(current.end, next.end)`.
   - Else: No overlap. Add `current` to result, set `current = next`.

---

## ✅ Ideal Answer
By sorting the intervals first, we reduce the complexity $O(N \log N)$. Once sorted, a single linear pass is sufficient to merge overlaps. We simply compare each interval's start with the end of the previously merged one.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int[][] merge(int[][] intervals) {
        if (intervals.length <= 1) return intervals;

        // 1. Sort by start time
        Arrays.sort(intervals, (a, b) -> Integer.compare(a[0], b[0]));

        List<int[]> result = new ArrayList<>();
        int[] current = intervals[0];
        result.add(current);

        for (int[] next : intervals) {
            if (next[0] <= current[1]) {
                // 2. Merge
                current[1] = Math.max(current[1], next[1]);
            } else {
                // 3. New interval
                current = next;
                result.add(current);
            }
        }
        return result.toArray(new int[result.size()][]);
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting to sort (leads to $O(N^2)$ brute force or wrong results).
- Not using `Math.max` for the new end (an interval might be entirely contained in a previous one).
- Handling the empty/single interval case.

---

## 🔄 Follow-up Questions
1. **Insert Interval?** (LeetCode 57: Similar, but you can do it in $O(N)$ if the input is already sorted.)
2. **Meeting Rooms?** (Check if any overlap exists — simpler version.)
3. **Complexity?** ($O(N \log N)$ time for sorting; $O(N)$ space for the result.)
