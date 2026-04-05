---
title: "DSA: Find Median from Data Stream"
date: 2024-04-04
draft: false
weight: 34
---

# 🧩 Question: Find Median from Data Stream (LeetCode 295)
Design a data structure that supports adding an integer from the stream and finding the median.

## 🎯 What the interviewer is testing
- Maintaining sorted/semi-sorted order in a dynamic stream.
- The **Two Heaps** pattern.
- Balancing logic.

---

## 🧠 Deep Explanation

### Why not a List?
Adding to a list is $O(1)$, but finding the median requires sorting $O(N \log N)$.
Keeping a list sorted is $O(N)$ for every insertion.

### Two Heaps Strategy:
Divide the numbers into two halves:
1. **Max-Heap (`small`)**: Stores the smaller half of the numbers.
2. **Min-Heap (`large`)**: Stores the larger half.

### Balancing:
- `small` can have at most one more element than `large`.
- All elements in `small` must be $\le$ elements in `large`.

### Algorithm:
- **Add**: 
  - Add to `small`.
  - Move `small.poll()` to `large`.
  - If `large` is bigger than `small`, move `large.poll()` back to `small`.
- **Median**:
  - If `small.size() > large.size()`, return `small.peek()`.
  - Else, return `(small.peek() + large.peek()) / 2.0`.

---

## ✅ Ideal Answer
We maintain two priority queues: a max-heap for the smaller elements and a min-heap for the larger ones. By keeping them balanced, the roots of these heaps always represent the middle elements of the collection. This allows `addNum` in $O(\log N)$ and `findMedian` in $O(1)$.

---

## 💻 Java Code
```java
import java.util.*;

class MedianFinder {
    private PriorityQueue<Integer> small = new PriorityQueue<>(Collections.reverseOrder());
    private PriorityQueue<Integer> large = new PriorityQueue<>();

    public void addNum(int num) {
        small.offer(num);
        large.offer(small.poll());
        if (small.size() < large.size()) {
            small.offer(large.poll());
        }
    }

    public double findMedian() {
        if (small.size() > large.size()) return small.peek();
        return (small.peek() + large.peek()) / 2.0;
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting to balance the heaps after insertion.
- Not handling the floating-point division when the total count is even.
- Using a single heap (which only gives min or max).

---

## 🔄 Follow-up Questions
1. **What if numbers are already sorted?** (Heaps still perform $O(\log N)$.)
2. **What if 99% of numbers are in [0, 100]?** (Use counts/buckets instead of heaps for faster $O(1)$ lookup.)
3. **How to handle deletions?** (Lazy deletion or a balanced BST like TreeMap, though duplicates are tricky in BST.)
