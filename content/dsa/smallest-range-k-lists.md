---
title: "DSA: Smallest Range Covering Elements from K Lists"
date: 2024-04-04
draft: false
weight: 89
---

# 🧩 Question: Smallest Range Covering Elements from K Lists (LeetCode 632 - Hard)
You have `k` lists of sorted integers. Find the smallest range that includes at least one number from each of the `k` lists.

## 🎯 What the interviewer is testing
- Advanced sliding window or heap-based multi-way merge.
- Tracking boundaries across multiple streams.
- Optimizing for the narrowest intersection.

---

## 🧠 Deep Explanation

### The Logic (Min-Heap):
This is a variation of "Merging K Sorted Lists."
1. Put the **First Element** of each list into a Min-Heap.
2. Track the `max` value currently in the heap.
3. Your current range is `[heap.peek().val, max]`.
4. To find a potential smaller range:
   - Poll the min node.
   - Replace it with the **next element** from its same list.
   - Update `max` if the new element is larger.
   - Update `GlobalSmallestRange` if this new range is narrower.
5. If any list is exhausted, **STOP** (no further range can include at least one from each list).

---

## ✅ Ideal Answer
To identify the narrowest range covering all lists, we maintain a "sliding snapshot" of one element from every list using a min-heap. By continuously moving our lower boundary forward (polling from the heap) and adjusting our upper boundary (incorporating the next element from that same list), we systematically shrink the range while maintaining the "one from each" requirement. This $O(N \log K)$ approach provides the optimal solution without exhaustive comparisons.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int[] smallestRange(List<List<Integer>> nums) {
        PriorityQueue<int[]> minHeap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
        int max = Integer.MIN_VALUE;
        
        // Load first elements
        for (int i = 0; i < nums.size(); i++) {
            int val = nums.get(i).get(0);
            minHeap.offer(new int[]{val, i, 0});
            max = Math.max(max, val);
        }
        
        int start = -100000, end = 100000;
        
        while (minHeap.size() == nums.size()) {
            int[] curr = minHeap.poll();
            int minVal = curr[0], row = curr[1], col = curr[2];
            
            // Update global range
            if (max - minVal < end - start) {
                start = minVal;
                end = max;
            }
            
            // Add next element from same row
            if (col + 1 < nums.get(row).size()) {
                int nextVal = nums.get(row).get(col + 1);
                minHeap.offer(new int[]{nextVal, row, col + 1});
                max = Math.max(max, nextVal);
            }
        }
        
        return new int[]{start, end};
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can this be solved with a Sliding Window on a flat array?** (Yes, map each number to its "Origin List Index," sort all numbers, then use standard sliding window to find "K distinct origins".)
2. **Complexity?** ($O(N \log K)$ where $N$ is total elements and $K$ is number of lists.)
3. **What happens if multiple ranges have the same minimal length?** (The problem usually asks for the one starting with the smallest number.)
