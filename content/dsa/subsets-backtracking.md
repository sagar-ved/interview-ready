---
title: "DSA: Subsets (Backtracking)"
date: 2024-04-04
draft: false
weight: 61
---

# 🧩 Question: Subsets (LeetCode 78, 90)
Given an integer array `nums` of unique elements (and a version with duplicates), return all possible subsets (the power set).

## 🎯 What the interviewer is testing
- Power Set generation.
- Backtracking pattern (Decision tree).
- Handling duplicates in combinations.

---

## 🧠 Deep Explanation

### 1. Unique Elements:
For each element, we have two choices: INCLUDE or EXCLUDE. This leads to $2^N$ total subsets.
**Algorithm**: Recursion. In each step, you add the current subset to result, then try adding a new element and recurse further.

### 2. Handling Duplicates (Subsets II):
1. **Sort** the array.
2. In the loop, if `nums[i] == nums[i-1]`, skip the iteration. This ensures the same element doesn't start a duplicate branch from the same level.

---

## ✅ Ideal Answer
Generating a power set is a classic backtracking problem where we explore every branch of the "include/exclude" tree. To handle duplicates, sorting is essential; it allows us to identify and skip identical branches in our recursion, preventing the generation of redundant subsets.

---

## 💻 Java Code: Subsets II (with Duplicates)
```java
import java.util.*;

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
            if (i > start && nums[i] == nums[i - 1]) continue; // Skip dups
            tmp.add(nums[i]);
            backtrack(res, tmp, nums, i + 1);
            tmp.remove(tmp.size() - 1); // Backtrack
        }
    }
}
```

---

## 🔄 Follow-up Questions
1. **Total number of subsets?** ($2^N$).
2. **Iterative approach?** (Start with `[[]]`, for each num, duplicate all current sets and add `num` to the new ones.)
3. **What is the complexity?** ($O(N \cdot 2^N)$ as there are $2^N$ subsets and we copy each to result.)
