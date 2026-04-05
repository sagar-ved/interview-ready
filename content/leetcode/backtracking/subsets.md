---
title: "LeetCode 78 & 90: Subsets"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Subsets I & II (LeetCode 78, 90)
Generate all possible subsets (the power set) of intger array `nums`. In Subsets II, the array may have duplicates.

## 🎯 What the interviewer is testing
- Backtracking pattern (Decision tree: include or exclude).
- Handling duplicates by sorting and skipping.
- Building all $2^N$ combinations systematically.

---

## 🧠 Deep Explanation

### Subsets I (Unique elements):
For each element: INCLUDE or EXCLUDE → $2^N$ total subsets.
- Backtrack: Add current subset to result, then try adding each next element.

### Subsets II (Duplicates):
1. **Sort** the array.
2. In the loop, if `nums[i] == nums[i-1]` and we're not at the start of the current level → **skip** (same element shouldn't start a duplicate branch from the same recursion level).

---

## ✅ Ideal Answer
The classic backtracking decision tree explores all include/exclude combinations. Sorting allows duplicate detection — when we see the same element at the same recursion depth, we skip it to prevent identical subsets.

---

## 💻 Java Code: Subsets II
```java
public class Solution {
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> result = new ArrayList<>();
        backtrack(result, new ArrayList<>(), nums, 0);
        return result;
    }

    private void backtrack(List<List<Integer>> res, List<Integer> tmp, int[] nums, int start) {
        res.add(new ArrayList<>(tmp));
        for (int i = start; i < nums.length; i++) {
            if (i > start && nums[i] == nums[i - 1]) continue; // Skip duplicates
            tmp.add(nums[i]);
            backtrack(res, tmp, nums, i + 1);
            tmp.remove(tmp.size() - 1); // Backtrack
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Total subsets?** ($2^N$ for unique, varies with duplicates.)
2. **Iterative approach?** (Start with `[[]]`, for each num duplicate all current sets and append num to new copies.)
3. **Complexity?** ($O(N \cdot 2^N)$ — $2^N$ subsets, each copied in $O(N)$.)
