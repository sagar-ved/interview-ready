---
author: "sagar ved"
title: "LeetCode 46: Permutations"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 46: Permutations (Medium)
Given array of distinct integers, return all possible permutations.

## 🎯 What the interviewer is testing
- Backtracking with a "used" boolean array.
- Understanding permutations (`n!` total).
- Swapping-in-place alternative.

---

## 🧠 Deep Explanation

### Approach 1: Used-array
- Maintain a `used[]` array.
- At each step, pick any unused element, mark it used, recurse, then unmark (backtrack).

### Approach 2: Swap-in-place
- At index `i`, swap `nums[i]` with every element `j >= i`.
- Recurse for `i+1`.
- Swap back to restore.

---

## ✅ Ideal Answer
Permutations require that each element appears exactly once per arrangement, in any order. The "used" bookkeeping, combined with the backtrack (reset), ensures we explore all orderings without repeats while reusing the same buffer for all recursive calls.

---

## 💻 Java Code (Swap In-Place)
```java
public class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> result = new ArrayList<>();
        permute(nums, 0, result);
        return result;
    }

    private void permute(int[] nums, int start, List<List<Integer>> result) {
        if (start == nums.length) {
            List<Integer> perm = new ArrayList<>();
            for (int n : nums) perm.add(n);
            result.add(perm);
            return;
        }
        for (int i = start; i < nums.length; i++) {
            swap(nums, start, i);
            permute(nums, start + 1, result);
            swap(nums, start, i); // Backtrack
        }
    }

    private void swap(int[] nums, int i, int j) { int t = nums[i]; nums[i] = nums[j]; nums[j] = t; }
}
```

---

## 🔄 Follow-up Questions
1. **Permutations II (duplicates)?** (LeetCode 47: Sort first, then skip when `!used[i-1] && nums[i] == nums[i-1]`.)
2. **Next Permutation?** (LeetCode 31: Lexicographically next permutation in $O(N)$ using "find dip from right" logic.)
3. **Complexity?** ($O(N \cdot N!)$ — $N!$ permutations, each $O(N)$ to copy.)
