---
author: "sagar ved"
title: "Heaps and Priority Queues"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Find the median of a continuous data stream in O(log n) per insertion and O(1) for median query. Then explain how PriorityQueue works internally.

## 🎯 What the interviewer is testing
- Heap property and sift-up/sift-down operations
- Using two heaps (max-heap + min-heap) to maintain dual invariants
- PriorityQueue internals in Java
- Real-world applications: task scheduling, Dijkstra, merge K sorted

---

## 🧠 Deep Explanation

### 1. Heap Internals

A **heap** is a **complete binary tree** stored in an array.
- For a node at index `i`:
  - **Parent**: `(i - 1) / 2`
  - **Left child**: `2*i + 1`
  - **Right child**: `2*i + 2`

**Max-Heap**: `parent ≥ children` for all nodes.
**Min-Heap**: `parent ≤ children`.

**Operations**:
- **Insert**: Add at end; sift-up — O(log n)
- **Poll** (extract max/min): Swap root with last; sift-down from root — O(log n)
- **Peek** (view top): O(1) — just the root
- **Heapify** array: O(n) — not O(n log n)

### 2. Java PriorityQueue

- Backed by an `Object[] queue` array (min-heap by default)
- Default comparator: natural ordering (min at top)
- Custom comparator: `new PriorityQueue<>(Comparator.reverseOrder())` → max-heap
- **NOT thread-safe**: Use `PriorityBlockingQueue` for concurrent access
- **O(n) `contains()`**: No index map — must scan (use `TreeSet` if you need O(log n) contains)

### 3. Two-Heap Strategy for Median

- **Max-Heap (lowerHalf)**: The bottom half of numbers; the MAXIMUM of this heap = larger of the two middle elements.
- **Min-Heap (upperHalf)**: The top half of numbers; the MINIMUM of this heap = smaller of the two middle elements.
- **Invariant**: `lowerHalf.size() == upperHalf.size()` OR `lowerHalf.size() == upperHalf.size() + 1`.

**Median**:
- If sizes equal: `(lowerHalf.peek() + upperHalf.peek()) / 2.0`
- If lowerHalf bigger by 1: `lowerHalf.peek()`

---

## ✅ Ideal Answer

- Maintain two heaps: max-heap for lower half, min-heap for upper half.
- On insert: Add to lower half; rebalance by moving max of lower to upper if needed; balance sizes.
- Median: if equal sizes, average of both tops; if lower has one more, lower.peek().
- Time: O(log n) insert; O(1) median query.

---

## 💻 Java Code

```java
import java.util.*;

public class MedianFinder {

    // Max-heap: largest element of lower half at top
    private final PriorityQueue<Integer> lowerHalf = new PriorityQueue<>(Collections.reverseOrder());
    // Min-heap: smallest element of upper half at top
    private final PriorityQueue<Integer> upperHalf = new PriorityQueue<>();

    public void addNum(int num) {
        // Step 1: Add to lower half
        lowerHalf.offer(num);

        // Step 2: Ensure all elements in lower <= all elements in upper
        // (i.e., max of lower <= min of upper)
        if (!upperHalf.isEmpty() && lowerHalf.peek() > upperHalf.peek()) {
            upperHalf.offer(lowerHalf.poll()); // Move max of lower → upper
        }

        // Step 3: Balance sizes: lower can have at most 1 more element
        if (lowerHalf.size() > upperHalf.size() + 1) {
            upperHalf.offer(lowerHalf.poll());
        } else if (upperHalf.size() > lowerHalf.size()) {
            lowerHalf.offer(upperHalf.poll());
        }
    }

    public double findMedian() {
        if (lowerHalf.size() == upperHalf.size()) {
            return (lowerHalf.peek() + upperHalf.peek()) / 2.0;
        }
        return lowerHalf.peek(); // Lower half has the middle element
    }

    // ===== Classic Heap Operations =====

    // Kth Largest in Stream
    static class KthLargest {
        private final PriorityQueue<Integer> minHeap; // size K min-heap
        private final int k;

        KthLargest(int k, int[] nums) {
            this.k = k;
            this.minHeap = new PriorityQueue<>(k);
            for (int n : nums) add(n);
        }

        public int add(int val) {
            minHeap.offer(val);
            if (minHeap.size() > k) minHeap.poll(); // Evict smallest
            return minHeap.peek(); // Kth largest
        }
    }

    // Merge K Sorted Arrays using Min-Heap
    public int[] mergeKSorted(int[][] arrays) {
        // Min-heap stores [value, arrayIndex, elementIndex]
        PriorityQueue<int[]> pq = new PriorityQueue<>(Comparator.comparingInt(a -> a[0]));
        int totalSize = 0;

        for (int i = 0; i < arrays.length; i++) {
            if (arrays[i].length > 0) {
                pq.offer(new int[]{arrays[i][0], i, 0});
                totalSize += arrays[i].length;
            }
        }

        int[] result = new int[totalSize];
        int idx = 0;

        while (!pq.isEmpty()) {
            int[] curr = pq.poll();
            result[idx++] = curr[0];
            int arrayIdx = curr[1], elemIdx = curr[2] + 1;
            if (elemIdx < arrays[arrayIdx].length) {
                pq.offer(new int[]{arrays[arrayIdx][elemIdx], arrayIdx, elemIdx});
            }
        }
        return result;
    }
}
```

---

## ⚠️ Common Mistakes
- Using a sorted `ArrayList` for median (O(n) insert vs O(log n) heap)
- Not maintaining the size invariant — median formula breaks if sizes are wrong
- Forgetting that `PriorityQueue.peek()` is O(1) but `PriorityQueue.remove(element)` is O(n)
- Using a single max-heap and sorting for KthLargest (O(n log n) vs O(n log k))

---

## 🔄 Follow-up Questions
1. **How does `heapify` work in O(n)?** (Bottom-up sift-down for all non-leaf nodes — half the nodes are leaves, quarter need 1 sift-down level; amortized = O(n).)
2. **What is a Fibonacci Heap and when is it used?** (O(1) amortized insert and decrease-key; O(log n) delete-min. Used in optimized Dijkstra and Prim's — rare in practice due to high constant factors.)
3. **How would you implement a task scheduler with priority?** (Max-heap by priority, tie-break by insertion order using a sequence number; pop → execute → push next task if recurring.)
