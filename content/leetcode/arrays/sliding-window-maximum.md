---
author: "sagar ved"
title: "LeetCode 239: Sliding Window Maximum"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 LeetCode 239: Sliding Window Maximum ⭐ (Hard)
Given array `nums` and window size `k`, return the max in each sliding window of size `k`.

## 🎯 What the interviewer is testing
- Monotonic Deque (decreasing order).
- $O(N)$ vs $O(N \cdot k)$ naive approach.
- Understanding "stale" element removal.

---

## 🧠 Deep Explanation

### Naive: $O(N \cdot k)$
For each window, scan all `k` elements to find max.

### Monotonic Deque: $O(N)$
A **decreasing monotonic deque** (stores indices) where the **front is always the maximum** of the current window.

Rules:
1. **Pop from back**: Before adding `nums[i]`, remove all indices from the back where `nums[deque.last] <= nums[i]` (they'll never be the max again).
2. **Pop from front**: If `deque.front == i - k`, it's outside the window — remove it.
3. Add current index `i` to the back.
4. After `i >= k-1`: add `nums[deque.front]` to result.

---

## ✅ Ideal Answer
The monotonic deque maintains the maximum of the current window without scanning all k elements. By ensuring the deque is always in decreasing order, the front always holds the index of the current window's maximum. Elements are added and removed at most once, giving $O(N)$ overall.

---

## 💻 Java Code
```java
public class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        int n = nums.length;
        int[] result = new int[n - k + 1];
        Deque<Integer> deque = new ArrayDeque<>(); // stores indices
        for (int i = 0; i < n; i++) {
            // Remove out-of-window indices
            if (!deque.isEmpty() && deque.peekFirst() == i - k) deque.pollFirst();
            // Maintain decreasing order
            while (!deque.isEmpty() && nums[deque.peekLast()] <= nums[i]) deque.pollLast();
            deque.offerLast(i);
            if (i >= k - 1) result[i - k + 1] = nums[deque.peekFirst()];
        }
        return result;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Min Sliding Window?** (Use an ascending monotonic deque instead.)
2. **What is the deque invariant?** (Indices in the deque always correspond to a decreasing sequence of values in `nums`.)
3. **Can we use a PriorityQueue?** (Yes, but $O(N \log k)$ — harder to remove stale elements.)
