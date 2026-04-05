---
title: "LeetCode: Two Sum"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 LeetCode 1: Two Sum
Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

## 🎯 What the interviewer is testing
- Hash Map lookups (Complementary search).
- Space-Time trade-off analysis.
- One-pass iteration.

---

## 🧠 Deep Explanation

### The Brute Force:
Nested loops finding all pairs. $O(N^2)$ time.

### The Optimal:
We iterate through the array once. For each number `x`, we look for `target - x` in our Hash Map.
1. If found, we return the pair.
2. If not found, we store the current number and its index in the map for future looks.
- **Time**: $O(N)$ (Average).
- **Space**: $O(N)$ (Store the hash map).

---

## ✅ Ideal Answer
To solve this in linear time, we utilize a Hash Map to store the numerical complements as we traverse the array. By looking up the difference between the target and our current value in constant time, we avoid the quadratic cost of nested loops. This approach efficiently trades a small amount of memory for significant performance gains, ensuring $O(N)$ complexity regardless of the arrival order of elements.

---

## 💻 Java Code
```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[] { map.get(complement), i };
            }
            map.put(nums[i], i);
        }
        return new int[] {};
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if the array is already sorted?** (You could use the **Two-Pointer** technique for $O(N)$ space-efficient searching.)
2. **Handle duplicates?** (The Hash Map handles duplicates naturally as we only check "complements" before overwriting.)
3. **Wait time?** (Average $O(1)$ lookup for the map makes this a single-pass solution.)
