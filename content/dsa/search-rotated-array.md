---
title: "DSA: Search in Rotated Sorted Array"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 Question: Search in Rotated Sorted Array (LeetCode 33)
There is an integer array `nums` sorted in ascending order (with distinct values). Prior to being passed to your function, `nums` is possibly rotated at an unknown pivot index `k`. Given the array `nums` after the rotation and an integer `target`, return the index of `target` if it is in `nums`, or `-1` if it is not in `nums`. You must write an algorithm with $O(\log n)$ runtime complexity.

## 🎯 What the interviewer is testing
- Efficient binary search on non-standard sorted structures.
- Logic for identifying which half of the array is "well-behaved" (sorted).
- Boundary condition handling.

---

## 🧠 Deep Explanation
A standard binary search works because the whole range is sorted. In a rotated sorted array, only one of the two halves (split by `mid`) is guaranteed to be sorted.

### The Algorithm:
1. Initialize `low = 0`, `high = n - 1`.
2. While `low <= high`:
   - Calculate `mid`.
   - If `nums[mid] == target`, return `mid`.
   - **Identify the sorted half**:
     - If `nums[low] <= nums[mid]`: The left half `[low, mid]` is sorted.
       - Check if `target` lies within `[nums[low], nums[mid]]`.
       - If yes, move `high = mid - 1`.
       - Else, move `low = mid + 1`.
     - Else: The right half `[mid, high]` is sorted.
       - Check if `target` lies within `[nums[mid], nums[high]]`.
       - If yes, move `low = mid + 1`.
       - Else, move `high = mid - 1`.

---

## ✅ Ideal Answer
To achieve $O(\log n)$, we use binary search. The key insight is that even in a rotated array, at least one half of the current range is always strictly sorted. We find which half is sorted, check if the target is in that range, and discard the other half.

---

## 💻 Java Code
```java
public class Solution {
    public int search(int[] nums, int target) {
        int low = 0, high = nums.length - 1;

        while (low <= high) {
            int mid = low + (high - low) / 2;

            if (nums[mid] == target) return mid;

            // Left side is sorted
            if (nums[low] <= nums[mid]) {
                if (target >= nums[low] && target < nums[mid]) {
                    high = mid - 1;
                } else {
                    low = mid + 1;
                }
            } 
            // Right side is sorted
            else {
                if (target > nums[mid] && target <= nums[high]) {
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
            }
        }
        return -1;
    }
}
```

---

## ⚠️ Common Mistakes
- Not handling the `low <= mid` condition correctly (distinct vs non-distinct).
- Confusing the target range check within the sorted half.
- Integer overflow in `mid` calculation (always use `low + (high - low) / 2`).

---

## 🔄 Follow-up Questions
1. **What if the array contains duplicates?** (LeetCode 81: Average $O(\log n)$, but worst case $O(n)$ because we may need to decrement pointers when `nums[low] == nums[mid] == nums[high]`.)
2. **How to find the minimum element in a rotated sorted array?** (LeetCode 153: Similar binary search but compare `nums[mid]` with `nums[high]`.)
