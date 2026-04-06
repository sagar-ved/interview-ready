---
author: "sagar ved"
title: "LeetCode: 4Sum"
date: 2024-04-04
draft: false
weight: 102
---

# 🧩 LeetCode 18: 4Sum
Given an integer array `nums` and a target, find all unique quadruplets that sum to target.

## 🎯 What the interviewer is testing
- Recursive K-Sum logic ($O(N^{k-1})$).
- Reusing the 2-Sum problem as a base case.
- Efficient deduplication on multiple nesting levels.

---

## 🧠 Deep Explanation

### The "General K-Sum" Logic:
1. Sort the array.
2. If $K > 2$: 
   - Iterate through current array, fix one element `nums[i]`.
   - Call `K-1 Sum` on the remainder of the array with target = `target - nums[i]`.
3. If $K == 2$: 
   - Use the **Two-Pointer** technique ($O(N)$).

### Performance for 4Sum:
This results in an $O(N^3)$ complexity.
- Loop 1 (Fixed) -> Loop 2 (Fixed) -> Two-Pointer Search.

---

## ✅ Ideal Answer
For higher-order summation problems like 4Sum, the optimal approach is a recursive framework that reduces the problem complexity by one level with each iteration. By sorting the data and applying the two-pointer technique at the base level (K=2), we transition from a chaotic nested-search into a structured $O(N^{K-1})$ exploration. This methodology is highly extensible, allowing us to solve any K-Sum variant with a single, unified algorithm.

---

## 🔄 Follow-up Questions
1. **Complexity for K-Sum?** ($O(N^{K-1})$).
2. **Can we use a Hash Set or Map?** (For 4Sum, we can use a Hash Map to store "Sums of Pairs" to achieve $O(N^2)$ average case, but deduplication and memory overhead make it tricky for interviews.)
3. **What is the `i > 0 && nums[i] == nums[i-1]` skip for?** (To ensure we don't pick the same number as a starting point twice, which would lead to duplicate quadruplets.)
