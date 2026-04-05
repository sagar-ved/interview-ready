---
title: "LeetCode 23: Merge K Sorted Lists"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 LeetCode 23: Merge K Sorted Lists ⭐ (Hard)
Merge `k` sorted linked lists and return one sorted linked list.

## 🎯 What the interviewer is testing
- Min-Heap for priority-based merging.
- Divide and Conquer alternative.
- Complexity analysis: naive $O(NK)$ vs heap $O(N \log K)$.

---

## 🧠 Deep Explanation

### Naive: Sequential merge — $O(N \cdot K)$
Merge lists one by one. Each merge takes $O(N)$ and we do it $K-1$ times.

### Min-Heap: $O(N \log K)$
1. Push the **head** of each list into a Min-Heap.
2. Poll the smallest node, add it to result.
3. If the polled node has a `next`, push it into the heap.
4. Repeat until heap is empty.

**Why $O(N \log K)$?** We process $N$ nodes total; each heap operation is $O(\log K)$.

### Divide and Conquer: $O(N \log K)$
Merge lists in pairs, halving the number each round. $\log K$ rounds × $O(N)$ per round.

---

## ✅ Ideal Answer
The Min-Heap approach processes nodes in globally sorted order without pre-sorting. At any moment, the heap holds exactly one candidate from each list, making it highly memory efficient while achieving the theoretically optimal $O(N \log K)$.

---

## 💻 Java Code (Min-Heap)
```java
public class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        PriorityQueue<ListNode> heap = new PriorityQueue<>((a, b) -> a.val - b.val);
        for (ListNode node : lists) if (node != null) heap.offer(node);
        ListNode dummy = new ListNode(0), curr = dummy;
        while (!heap.isEmpty()) {
            curr.next = heap.poll();
            curr = curr.next;
            if (curr.next != null) heap.offer(curr.next);
        }
        return dummy.next;
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if K is very large?** (Min-Heap still works; $O(\log K)$ per node.)
2. **Divide & Conquer code?** (Recursively merge `lists[0..mid]` and `lists[mid+1..end]`.)
3. **Complexity?** ($O(N \log K)$ time, $O(K)$ heap space.)
