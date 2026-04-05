---
title: "LeetCode 33: Search in Rotated Sorted Array"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Search in Rotated Sorted Array (LeetCode 33)
A sorted array has been rotated at an unknown pivot. Find `target` in $O(\log n)$.

## 🎯 What the interviewer is testing
- Binary search on non-standard sorted structures.
- Logic for identifying which half is "sorted".
- Boundary condition handling.

---

## 🧠 Deep Explanation

### The Key Insight:
In a rotated sorted array, **one of the two halves split by `mid` is always sorted**. We check which half is sorted, then decide if the target is in that range.

### Algorithm:
1. Calculate `mid`.
2. If `nums[low] <= nums[mid]` → left half is sorted.
   - If `target` in `[nums[low], nums[mid])` → shrink right.
   - Else → shrink left.
3. Else → right half is sorted.
   - If `target` in `(nums[mid], nums[high]]` → shrink left.
   - Else → shrink right.

---

## ✅ Ideal Answer
Even a rotated array has at least one monotonically sorted half. We identify it on each iteration and check if the target fits within it, discarding the half where it cannot be.

---

## 💻 Java Code
```java
public class Solution {
    public int search(int[] nums, int target) {
        int low = 0, high = nums.length - 1;
        while (low <= high) {
            int mid = low + (high - low) / 2;
            if (nums[mid] == target) return mid;
            if (nums[low] <= nums[mid]) { // Left sorted
                if (target >= nums[low] && target < nums[mid]) high = mid - 1;
                else low = mid + 1;
            } else { // Right sorted
                if (target > nums[mid] && target <= nums[high]) low = mid + 1;
                else high = mid - 1;
            }
        }
        return -1;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Array with duplicates?** (LeetCode 81: Worst case degrades to $O(N)$ when `nums[low] == nums[mid] == nums[high]`.)
2. **Find the rotation pivot?** (LeetCode 153: Binary search comparing `nums[mid]` vs `nums[high]`.)
3. **Complexity?** ($O(\log N)$ time, $O(1)$ space.)
