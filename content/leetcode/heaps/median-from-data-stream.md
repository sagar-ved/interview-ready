---
title: "LeetCode 295: Find Median from Data Stream"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 LeetCode 295: Find Median from Data Stream ⭐ (Hard)
Design a data structure that supports `addNum(int num)` and `findMedian()` in $O(\log N)$ and $O(1)$ respectively.

## 🎯 What the interviewer is testing
- Two-heap design pattern.
- Keeping heaps balanced (size difference ≤ 1).
- Lower half Max-Heap + Upper half Min-Heap.

---

## 🧠 Deep Explanation

### Design: Two Heaps
- **`smallHeap`** (Max-Heap): stores the smaller half.
- **`largeHeap`** (Min-Heap): stores the larger half.
- Invariant: `smallHeap.size() == largeHeap.size()` OR `smallHeap.size() == largeHeap.size() + 1`.

### addNum:
1. Always add to `smallHeap` first.
2. Rebalance: if `smallHeap.peek() > largeHeap.peek()`, move top of small to large.
3. Balance sizes: if `largeHeap.size() > smallHeap.size()`, move top of large to small.

### findMedian:
- Odd total: return `smallHeap.peek()`.
- Even total: return average of both tops.

---

## ✅ Ideal Answer
By partitioning the stream into two heaps—a max-heap for the lower half and a min-heap for the upper half—we can always access the median in $O(1)$ from the tops of the heaps. Rebalancing on each insertion is $O(\log N)$.

---

## 💻 Java Code
```java
class MedianFinder {
    PriorityQueue<Integer> small = new PriorityQueue<>(Collections.reverseOrder()); // max-heap
    PriorityQueue<Integer> large = new PriorityQueue<>(); // min-heap

    public void addNum(int num) {
        small.offer(num);
        large.offer(small.poll());
        if (large.size() > small.size()) small.offer(large.poll());
    }

    public double findMedian() {
        return small.size() > large.size()
            ? small.peek()
            : (small.peek() + large.peek()) / 2.0;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if the stream is huge?** (Use reservoir sampling or quantile sketches like t-digest.)
2. **What if all numbers <= 100?** (Bucket sort / counting array approach — $O(1)$ add.)
3. **Thread-safe version?** (Use `PriorityBlockingQueue` with locks.)
