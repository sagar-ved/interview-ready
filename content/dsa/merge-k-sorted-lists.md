---
title: "DSA: Merge k-Sorted Lists"
date: 2024-04-04
draft: false
weight: 81
---

# 🧩 Question: Merge k Sorted Lists (LeetCode 23 - Hard)
You are given an array of `k` linked-lists, each linked-list is sorted in ascending order. Merge all the linked-lists into one sorted linked-list and return it.

## 🎯 What the interviewer is testing
- Multi-way merge logic.
- Using a **Priority Queue (Min-Heap)**.
- Complexity analysis ($O(N \log K)$ vs $O(N \cdot K)$).

---

## 🧠 Deep Explanation

### The Logic (Min-Heap):
1. Put the **First Node** of every list into a Min-Heap.
2. While the heap is not empty:
   - Poll the smallest node `curr`.
   - Add it to our merged result.
   - If `curr.next != null`, push the **next node** from that same list into the heap.

### Complexity:
- Time: $O(N \log K)$ where $N$ is total nodes and $K$ is number of lists. (Each push/poll is $\log K$).
- Space: $O(K)$ effectively, to store the heap.

---

## ✅ Ideal Answer
Merging multiple sorted lists is a multi-way merge problem best handled by a priority queue. By keeping one potential candidate from each list in a min-heap, we ensure that we always pick the globally smallest element next. This approach is highly scalable and maintains a logarithmic time complexity relative to the number of lists, regardless of the individual list lengths.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        if (lists == null || lists.length == 0) return null;
        
        PriorityQueue<ListNode> queue = new PriorityQueue<>((a, b) -> a.val - b.val);
        ListNode dummy = new ListNode(0);
        ListNode tail = dummy;
        
        // Load first nodes
        for (ListNode node : lists) {
            if (node != null) queue.add(node);
        }
        
        while (!queue.isEmpty()) {
            tail.next = queue.poll();
            tail = tail.next;
            
            if (tail.next != null) {
                queue.add(tail.next);
            }
        }
        return dummy.next;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you solve this with "Divide and Conquer"?** (Yes, merge pairs of lists iteratively. Same time complexity $O(N \log K)$.)
2. **What if the lists are stored on different servers?** (Distributed merge sort — requires network stream management.)
3. **Where have you seen this before?** (Database engines merging sorted indices or LSM SS-Tables during compaction.)
