---
title: "DSA: Meeting Rooms II"
date: 2024-04-04
draft: false
weight: 21
---

# 🧩 Question: Meeting Rooms II (LeetCode 253)
Given an array of meeting time intervals `intervals` where `intervals[i] = [start_i, end_i]`, return the minimum number of conference rooms required.

## 🎯 What the interviewer is testing
- Greedy approach.
- Use of Min-Heap or Chronological sorting.
- Simultaneous events handling.

---

## 🧠 Deep Explanation

### 1. Min-Heap Approach:
- Sort meetings by start time.
- Use a `Min-Heap` to store the **end times** of ongoing meetings.
- If the earliest meeting to end (`heap.peek()`) ends before the current meeting starts, we can reuse that room (pop and push current end time).
- Otherwise, we need a new room (just push current end time).
- Result: `heap.size()`.

### 2. Chronological Sorting (Two Pointer):
- Split all starts and ends into two sorted arrays.
- Iterate through starts. If a start is smaller than the current end, increment `rooms`.
- Otherwise, move the end pointer.

---

## ✅ Ideal Answer
We need to find the maximum number of overlapping intervals at any point in time. By sorting and using a Min-Heap for end times, we can dynamically see how many rooms are occupied. Alternatively, by looking at discrete "start" and "end" events, we can simulate the clock and count how many "start" events occur before "end" events.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int minMeetingRooms(int[][] intervals) {
        if (intervals == null || intervals.length == 0) return 0;

        Arrays.sort(intervals, (a, b) -> Integer.compare(a[0], b[0]));

        PriorityQueue<Integer> minHeap = new PriorityQueue<>();
        minHeap.offer(intervals[0][1]);

        for (int i = 1; i < intervals.length; i++) {
            if (intervals[i][0] >= minHeap.peek()) {
                minHeap.poll(); // Reuse room
            }
            minHeap.offer(intervals[i][1]);
        }

        return minHeap.size();
    }
}
```

---

## ⚠️ Common Mistakes
- Not sorting by start time.
- Confusing start time and end time priorities in the heap.
- Not handling edge cases like empty inputs.

---

## 🔄 Follow-up Questions
1. **Can you solve this without a Heap?** (Yes, use the two-pointer chronological sort approach.)
2. **What if we want to find the maximum load on a server?** (Same problem!)
3. **What is the complexity?** ($O(N \log N)$ for sorting and $O(N \log N)$ for heap operations.)
