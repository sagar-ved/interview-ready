---
title: "LeetCode: 3Sum"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 LeetCode 15: 3Sum
Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j, i != k, j != k` and the sum equals zero.

## 🎯 What the interviewer is testing
- Sorting for efficient searching.
- Two-pointer technique on sorted boundaries.
- Deduplication of identical triplets.

---

## 🧠 Deep Explanation

### The Logic (Sort + 2 Pointers):
1. **Sort** the array.
2. Iterate through each number `a` (at index `i`).
3. For each `a`, the goal is to find two other numbers `b` and `c` such that `b + c = -a`.
4. Use **Two Pointers** (left = `i+1`, right = `n-1`):
   - If sum < -a: move `left++`.
   - If sum > -a: move `right--`.
   - If sum == -a: **FOUND**. Store triplet and skip duplicate children.
5. **Deduplication**: Skip the same element if it's the same as the previous one at the same level.

---

## ✅ Ideal Answer
3Sum is a natural extension of the Two Sum problem, optimized for sorted sets. By fixing one element and using the two-pointer technique on the rest of the array, we reduce an $O(N^3)$ search into an $O(N^2)$ solution. The critical part of this challenge is ensuring uniqueness; by sorting the array first and skipping identical consecutive values, we efficiently eliminate duplicate triplets without expensive post-processing or secondary sets.

---

## 💻 Java Code
```java
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> res = new ArrayList<>();
        for (int i = 0; i < nums.length - 2; i++) {
            if (i > 0 && nums[i] == nums[i-1]) continue; // Skip duplicates
            int left = i + 1, right = nums.length - 1;
            while (left < right) {
                int sum = nums[i] + nums[left] + nums[right];
                if (sum == 0) {
                    res.add(Arrays.asList(nums[i], nums[left], nums[right]));
                    while (left < right && nums[left] == nums[left+1]) left++; // Skip dups
                    while (left < right && nums[right] == nums[right-1]) right--; // Skip dups
                    left++; right--;
                } else if (sum < 0) left++;
                else right--;
            }
        }
        return res;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Time Complexity?** ($O(N^2)$ for the nested search + $O(N \log N)$ for sorting = $O(N^2)$ overall.)
2. **Can you solve without sorting?** (Yes, using a Hash Set for complements, but it's much harder to handle duplicates correctly.)
3. **Space complexity?** ($O(1)$ for the search logic; $O(N)$ for sorting recursion.)
