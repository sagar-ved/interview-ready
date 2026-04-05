---
title: "DSA: Sliding Window Maximum"
date: 2024-04-04
draft: false
weight: 80
---

# 🧩 Question: Sliding Window Maximum (LeetCode 239 - Hard)
You are given an array of integers `nums`, there is a sliding window of size `k` which is moving from the very left of the array to the very right. Return the max window.

## 🎯 What the interviewer is testing
- Efficient window tracking ($O(N)$).
- **Monotonic Queue** pattern.
- Understanding of amortized linear complexity.

---

## 🧠 Deep Explanation

### Why $O(N \cdot K)$ is bad:
Using a Max-Heap ($O(N \log K)$) is okay, but $O(N)$ is better. 

### The Monotonic Deque Strategy:
1. Use a **Deque** to store **indices** (so we can check if they've slid out of window).
2. The Deque will be **Monotonically Decreasing** (largest value index always at the front).
3. For each new `nums[i]`:
   - **Pop from Front**: If the index at front is `i - k` (slid out of window).
   - **Pop from Back**: If `nums[i] > nums[deque.peekLast()]`. This current value makes all smaller previous values irrelevant for future maxes.
   - **Push `i`** to Back.
4. **Result**: The max for the current window is always at `deque.peekFirst()`.

---

## ✅ Ideal Answer
To track the sliding maximum in linear time, we maintain a monotonic deque of indices where values are stored in descending order. By discarding all elements from the rear that are smaller than the incoming number, we ensure that the deque's front always points to the current maximum. This amortized linear approach effectively processes each element only twice, regardless of the window size.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        if (nums == null || nums.length == 0) return new int[0];
        int n = nums.length;
        int[] result = new int[n - k + 1];
        Deque<Integer> dq = new ArrayDeque<>();
        
        for (int i = 0; i < n; i++) {
            // 1. Remove indices out of window
            if (!dq.isEmpty() && dq.peekFirst() == i - k) {
                dq.pollFirst();
            }
            
            // 2. Remove smaller elements from back
            while (!dq.isEmpty() && nums[dq.peekLast()] < nums[i]) {
                dq.pollLast();
            }
            
            dq.offerLast(i);
            
            // 3. Extract max from front
            if (i >= k - 1) {
                result[i - k + 1] = nums[dq.peekFirst()];
            }
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you use a PriorityQueue?** (Yes, $O(N \log N)$ or $O(N \log K)$ depending on removal, which is slower.)
2. **Space complexity?** ($O(K)$ for the deque.)
3. **What is an "Amortized" complexity?** (Individual ops might take $O(K)$, but total sum over $N$ steps is $O(N)$.)
