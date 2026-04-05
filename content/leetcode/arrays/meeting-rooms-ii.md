---
title: "LeetCode 253: Meeting Rooms II"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: Meeting Rooms II (LeetCode 253)
Given an array of meeting time intervals, return the minimum number of conference rooms required.

## 🎯 What the interviewer is testing
- Greedy approach with a Min-Heap.
- Simultaneous events handling.
- Understanding of resource allocation problems.

---

## 🧠 Deep Explanation

### Min-Heap Approach:
- Sort meetings by start time.
- Use a `Min-Heap` storing the **end times** of ongoing meetings.
- If the earliest ending meeting (`heap.peek()`) ends before the current one starts → reuse that room.
- Otherwise → open a new room.
- Result: `heap.size()`.

---

## ✅ Ideal Answer
We need to find the maximum number of overlapping intervals at any point in time. A Min-Heap of end times lets us dynamically track active rooms and greedily reuse whichever room frees up earliest.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int minMeetingRooms(int[][] intervals) {
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

## 🔄 Follow-up Questions
1. **Can you solve without a Heap?** (Yes, using the two-pointer chronological sort approach.)
2. **What if we want the max load on a server?** (Same problem!)
3. **Complexity?** ($O(N \log N)$ for sorting and heap operations.)
