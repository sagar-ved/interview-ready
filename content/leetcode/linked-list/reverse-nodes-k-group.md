---
author: "sagar ved"
title: "LeetCode 25: Reverse Nodes in K-Group"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 LeetCode 25: Reverse Nodes in K-Group ⭐ (Hard)
Reverse the nodes of a linked list `k` at a time and return the modified list.

## 🎯 What the interviewer is testing
- Linked list pointer surgery.
- Group-wise processing with boundary checks.
- Recursion vs iteration for elegance.

---

## 🧠 Deep Explanation

### Algorithm (Iterative):
1. Count `k` nodes ahead — if fewer than `k` remain, leave as-is.
2. Reverse the next `k` nodes using standard reversal.
3. Connect the reversed group's tail to the result of `reverseKGroup(next node, k)`.
4. Advance `prevGroupTail` to the tail of the newly reversed group.

### Key Pointers:
- `groupStart`: first node of current group.
- `groupEnd`: k-th node of group (found by walking k steps).
- After reversing, `groupStart` becomes the tail and `groupEnd` becomes the head.

---

## ✅ Ideal Answer
K-group reversal is a clean extension of standard list reversal, applied to fixed-length segments. The challenge is correctly reconnecting each reversed segment to the next one. A dummy head node simplifies handling of the first group's predecessor.

---

## 💻 Java Code
```java
public class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
        ListNode curr = head;
        int count = 0;
        while (curr != null && count < k) { curr = curr.next; count++; }
        if (count < k) return head; // Less than k nodes remain
        
        // Reverse k nodes
        ListNode prev = null, node = head;
        for (int i = 0; i < k; i++) {
            ListNode next = node.next;
            node.next = prev;
            prev = node;
            node = next;
        }
        // head is now the tail of reversed group
        head.next = reverseKGroup(curr, k);
        return prev; // prev is now the head of reversed group
    }
}
```

---

## 🔄 Follow-up Questions
1. **Reverse in groups of 2?** (Same algorithm with `k=2`.)
2. **Constant space iterative?** (Yes, manage multiple pointer variables across iterations — no recursion stack.)
3. **Complexity?** ($O(N)$ time — each node is reversed once; $O(N/k)$ recursion stack.)
