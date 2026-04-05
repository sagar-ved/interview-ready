---
title: "LeetCode 4: Median of Two Sorted Arrays"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 LeetCode 4: Median of Two Sorted Arrays ⭐ (Hard)
Find the median of two sorted arrays in $O(\log(m+n))$ time.

## 🎯 What the interviewer is testing
- Binary search on the shorter array.
- Partition-based thinking.
- Handling edge cases (empty arrays, odd/even total length).

---

## 🧠 Deep Explanation

### Key Insight: Partitioning
We binary search on the smaller array to find a partition point `i` such that:
- Left partition has `(m+n+1)/2` elements combined.
- `maxLeft1 <= minRight2` AND `maxLeft2 <= minRight1`.

If all 4 boundary conditions are satisfied, we've found the correct median.

### The Binary Search:
- On smaller array's partition: `i = (lo + hi) / 2`
- `j = half - i` where `half = (m+n+1)/2`
- Check: `A[i-1] <= B[j]` AND `B[j-1] <= A[i]`
- Adjust `lo`/`hi` based on violations.

---

## ✅ Ideal Answer
Instead of merging both arrays ($O(m+n)$), we binary search for the ideal partition that splits both arrays into equal-sized halves. The median is determined by the boundary elements of these partitions.

---

## 💻 Java Code
```java
public class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        if (nums1.length > nums2.length) return findMedianSortedArrays(nums2, nums1);
        int m = nums1.length, n = nums2.length;
        int lo = 0, hi = m, half = (m + n + 1) / 2;
        while (lo <= hi) {
            int i = (lo + hi) / 2, j = half - i;
            int maxL1 = i == 0 ? Integer.MIN_VALUE : nums1[i-1];
            int minR1 = i == m ? Integer.MAX_VALUE : nums1[i];
            int maxL2 = j == 0 ? Integer.MIN_VALUE : nums2[j-1];
            int minR2 = j == n ? Integer.MAX_VALUE : nums2[j];
            if (maxL1 <= minR2 && maxL2 <= minR1) {
                if ((m + n) % 2 == 1) return Math.max(maxL1, maxL2);
                return (Math.max(maxL1, maxL2) + Math.min(minR1, minR2)) / 2.0;
            } else if (maxL1 > minR2) hi = i - 1;
            else lo = i + 1;
        }
        return 0;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Why binary search on the smaller array?** (Ensures `j >= 0` always, preventing negative partition index.)
2. **What if arrays are equal length?** (Works the same — just processes both arrays equally.)
3. **K-th element of two sorted arrays?** (Generalize: binary search for K-th position instead of median.)
