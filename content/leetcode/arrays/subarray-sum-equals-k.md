---
author: "sagar ved"
title: "LeetCode 560: Subarray Sum Equals K"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Subarray Sum Equals K (LeetCode 560)
Given an array of integers `nums` and an integer `k`, return the total number of subarrays whose sum equals to `k`.

## 🎯 What the interviewer is testing
- Prefix Sum and its relationship with Subarray Sum.
- Optimizing $O(N^2)$ to $O(N)$ using a HashMap.
- Recognition of the mathematical property: `Sum(i, j) = PrefixSum(j) - PrefixSum(i-1)`.

---

## 🧠 Deep Explanation

### The Logic:
We want to find total pairs `(i, j)` such that `PrefixSum(j) - PrefixSum(i) = k`.
This can be rewritten as: `PrefixSum(i) = PrefixSum(j) - k`.

1. Maintain a running sum (PrefixSum).
2. Use a **HashMap** to store the frequency of each PrefixSum encountered so far.
3. At each index `j`, check how many times `PrefixSum(j) - k` has appeared in the past.
4. Add that frequency to our result.

---

## ✅ Ideal Answer
For a linear $O(N)$ solution, we traverse the array while building a PrefixSum. We leverage a HashMap to "look back" at how many previous prefix sums, when subtracted from our current sum, yield $K$.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int subarraySum(int[] nums, int k) {
        int count = 0, sum = 0;
        Map<Integer, Integer> map = new HashMap<>();
        map.put(0, 1); // Base case: prefix sum 0 has appeared once
        
        for (int num : nums) {
            sum += num;
            if (map.containsKey(sum - k)) {
                count += map.get(sum - k);
            }
            map.put(sum, map.getOrDefault(sum, 0) + 1);
        }
        return count;
    }
}
```

---

## ⚠️ Common Mistakes
- Trying to use Sliding Window (only works if all numbers are **positive**).
- Forgetting to put `(0, 1)` into the map (essential for subarrays starting at index 0).
- Using $O(N^2)$ space by building a full prefix sum array unnecessarily.

---

## 🔄 Follow-up Questions
1. **How to solve if only the LONGEST subarray length is needed?** (Store indices instead of frequencies in the map.)
2. **What if the array has only 0s and 1s?** (Look at "Contiguous Array" LeetCode 525, treat 0 as -1.)
3. **What is the complexity?** ($O(N)$ time, $O(N)$ space.)
4. **Subarray Sum Divisible by K?** (Use modulo arithmetic.)
