---
title: "DSA: Median of Two Sorted Arrays"
date: 2024-04-04
draft: false
weight: 93
---

# 🧩 Question: Median of Two Sorted Arrays (LeetCode 4 - Hard)
Find the median of two sorted arrays of different sizes in $O(\log(\min(M, N)))$.

## 🎯 What the interviewer is testing
- Advanced Binary Search on boundaries.
- Partitioning logic for two streams.
- Handling edge cases in index math.

---

## 🧠 Deep Explanation

### The Goal:
We want to find a partition in Array A and a partition in Array B such that:
1. `count(A_left) + count(B_left) == count(A_right) + count(B_right)`.
2. `max(A_left) <= min(B_right)` and `max(B_left) <= min(A_right)`.

### Algorithm:
1. Always search on the **shorter** array (to guarantee $O(\log(\min(M, N)))$).
2. Binary search for `partitionA` in `[0, lengthA]`.
3. Calculate `partitionB = ((totalLen + 1) / 2) - partitionA`.
4. Check the "Cross Conditions":
   - `L1 = A[partitionA - 1]`, `R1 = A[partitionA]`
   - `L2 = B[partitionB - 1]`, `R2 = B[partitionB]`
   - If `L1 <= R2 && L2 <= R1`: **Target Found**.
   - If `L1 > R2`: Move partitionA **Left**.
   - Else: Move partitionA **Right**.

---

## ✅ Ideal Answer
Finding the median of two separate sorted streams in logarithmic time requires a dual-binary search on a virtual combined partition point. By adjusting the split in the smaller array, we can mathematically determine the corresponding split in the larger array, ensuring that all elements to the left are smaller than all elements to the right. This "partition balancing" approach avoids merging the arrays and achieves the theoretical optimal time complexity.

---

## 💻 Java Code
```java
public class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        if (nums1.length > nums2.length) return findMedianSortedArrays(nums2, nums1);
        
        int x = nums1.length, y = nums2.length;
        int low = 0, high = x;
        
        while (low <= high) {
            int partX = (low + high) / 2;
            int partY = (x + y + 1) / 2 - partX;
            
            int L1 = (partX == 0) ? Integer.MIN_VALUE : nums1[partX - 1];
            int R1 = (partX == x) ? Integer.MAX_VALUE : nums1[partX];
            
            int L2 = (partY == 0) ? Integer.MIN_VALUE : nums2[partY - 1];
            int R2 = (partY == y) ? Integer.MAX_VALUE : nums2[partY];
            
            if (L1 <= R2 && L2 <= R1) {
                if ((x + y) % 2 == 0) 
                    return (Math.max(L1, L2) + Math.min(R1, R2)) / 2.0;
                else 
                    return Math.max(L1, L2);
            } else if (L1 > R2) {
                high = partX - 1;
            } else {
                low = partX + 1;
            }
        }
        return 0.0;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Why search on the smaller array?** (If you searched on the larger, `partitionB` could become negative or out of bounds.)
2. **What if an array is empty?** (The logic naturally handles it with `Integer.MIN/MAX` buffers.)
3. **Complexity?** ($O(\log(\min(M, N)))$ time, $O(1)$ space.)
