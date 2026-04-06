---
author: "sagar ved"
title: "Binary Search Patterns and Variants"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: You have a rotated sorted array `[4, 5, 6, 7, 0, 1, 2]` and need to find a target in O(log n). How do you approach this, and what variants of binary search should every SDE-2 know?

## 🎯 What the interviewer is testing
- Binary search and its non-trivial variants
- Identifying which half is "sorted" after rotation
- Generalizing to: first/last occurrence, search in 2D matrix, peak element
- Clean implementation without off-by-one errors

---

## 🧠 Deep Explanation

### 1. Core Binary Search Template

```
lo = 0, hi = n - 1
while lo <= hi:
    mid = lo + (hi - lo) / 2  // Avoids integer overflow vs (lo + hi) / 2
    if arr[mid] == target: return mid
    elif target < arr[mid]: hi = mid - 1
    else: lo = mid + 1
return -1
```

### 2. Rotated Array Logic

After rotation, one half is always sorted. Identify it:
- If `arr[lo] <= arr[mid]` → **Left half is sorted**
  - If `target` is within `[arr[lo], arr[mid]]` → search left
  - Else → search right
- Else → **Right half is sorted**
  - If `target` is within `[arr[mid], arr[hi]]` → search right
  - Else → search left

### 3. Key Variants Every SDE-2 Must Know

| Variant | Condition change |
|---|---|
| First occurrence | When found, continue left: `hi = mid - 1` |
| Last occurrence | When found, continue right: `lo = mid + 1` |
| First True (boolean predicate) | `f(mid) == true` → hi = mid; else lo = mid + 1 |
| Peak element | `arr[mid] < arr[mid+1]` → go right |
| Sqrt(x) | Find largest k where `k*k <= x` |
| Minimum in rotated array | Find the "break point" |

---

## ✅ Ideal Answer

- Identify which half is sorted first using `arr[lo] vs arr[mid]`.
- Determine if the target falls in the sorted half's range.
- Time Complexity: O(log n). Space: O(1).
- Always initialize `mid = lo + (hi - lo) / 2` to prevent overflow for large indices.

---

## 💻 Java Code

```java
public class BinarySearchPatterns {

    // 1. Search in Rotated Sorted Array — O(log n)
    public int searchRotated(int[] nums, int target) {
        int lo = 0, hi = nums.length - 1;
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;
            if (nums[mid] == target) return mid;

            if (nums[lo] <= nums[mid]) { // Left half is sorted
                if (target >= nums[lo] && target < nums[mid]) {
                    hi = mid - 1; // Target in sorted left half
                } else {
                    lo = mid + 1; // Target in right half
                }
            } else { // Right half is sorted
                if (target > nums[mid] && target <= nums[hi]) {
                    lo = mid + 1; // Target in sorted right half
                } else {
                    hi = mid - 1; // Target in left half
                }
            }
        }
        return -1;
    }

    // 2. First occurrence (useful for counting, range queries)
    public int firstOccurrence(int[] nums, int target) {
        int lo = 0, hi = nums.length - 1, ans = -1;
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;
            if (nums[mid] == target) {
                ans = mid;
                hi = mid - 1; // Keep searching left for earlier occurrence
            } else if (nums[mid] < target) {
                lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }
        return ans;
    }

    // 3. Generic "first true" template — works for monotonic predicates
    // Example: Find smallest x where x*x >= n (ceiling of sqrt)
    public int firstTrue(int lo, int hi, java.util.function.IntPredicate condition) {
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            if (condition.test(mid)) {
                hi = mid; // mid might be the answer
            } else {
                lo = mid + 1;
            }
        }
        return lo; // lo == hi == first true position
    }

    // 4. Peak element in unsorted array
    public int findPeakElement(int[] nums) {
        int lo = 0, hi = nums.length - 1;
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            if (nums[mid] < nums[mid + 1]) {
                lo = mid + 1; // Peak is to the right
            } else {
                hi = mid; // Peak is mid or to the left
            }
        }
        return lo;
    }
}
```

---

## ⚠️ Common Mistakes
- Using `(lo + hi) / 2` — causes integer overflow for large arrays
- Off-by-one: `while lo < hi` vs `while lo <= hi` — depends on whether `mid` can be the answer
- Not handling `nums.length == 1` edge case
- Confusing first/last occurrence logic (when to update `ans` vs move pointer)

---

## 🔄 Follow-up Questions
1. **Search a target in a row-wise and column-wise sorted 2D matrix?** (Start from top-right; if target < current go left, if target > current go down — O(m+n).)
2. **Find the kth smallest element in a sorted matrix?** (Binary search on value range, not index — count elements <= mid to check feasibility.)
3. **Why does `lo + (hi - lo) / 2` prevent overflow?** (Unlike `(lo + hi)` which can exceed `Integer.MAX_VALUE`, this stays within bounds.)
