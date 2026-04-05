---
title: "DSA: 3Sum (Optimized)"
date: 2024-04-04
draft: false
weight: 52
---

# 🧩 Question: 3Sum (LeetCode 15)
Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and `nums[i] + nums[j] + nums[k] == 0`. The solution set must not contain duplicate triplets.

## 🎯 What the interviewer is testing
- Efficient array searching.
- Reducing 3D search space to 2D using sorting.
- Handling duplicate results in a sorted array.

---

## 🧠 Deep Explanation

### The Logic:
To avoid $O(N^3)$, we use a **Two Pointers** approach $O(N^2)$:
1. **Sort** the array.
2. Iterate through each `nums[i]`. This is our "Target": we need to find pairs that sum to `-nums[i]`.
3. Use two pointers `left = i + 1` and `right = n - 1`.
   - If sum matches, add to results.
   - If sum too small, `left++`.
   - If sum too large, `right--`.
4. **Duplicates**: Skip `nums[i]` if it's the same as `nums[i-1]`. Also skip `left` and `right` neighbors if they are the same after finding a match.

---

## ✅ Ideal Answer
We can solve 3Sum by sorting the array and iteratively fixing one element. For each fixed element, we find the remaining pair using two pointers moving from the ends of the array toward each other. This reduces the time complexity from $O(N^3)$ to $O(N^2)$, and sorting helps us easily bypass duplicate triplets.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> result = new ArrayList<>();
        
        for (int i = 0; i < nums.length - 2; i++) {
            if (i > 0 && nums[i] == nums[i-1]) continue; // Skip duplicate targets

            int left = i + 1, right = nums.length - 1;
            while (left < right) {
                int sum = nums[i] + nums[left] + nums[right];
                if (sum == 0) {
                    result.add(Arrays.asList(nums[i], nums[left], nums[right]));
                    while (left < right && nums[left] == nums[left + 1]) left++; // Skip dups
                    while (left < right && nums[right] == nums[right - 1]) right--; // Skip dups
                    left++; right--;
                } else if (sum < 0) {
                    left++;
                } else {
                    right--;
                }
            }
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you solve it without sorting?** (Yes, using a HashMap for the pairs, but handling duplicates is much harder.)
2. **Difference between 3Sum and 2Sum?** (2Sum is $O(N)$; 3Sum is $O(N^2)$.)
3. **What is 3Sum Closest?** (Similar logic, but track the minimal global `abs(diff)`).
