---
title: "DSA: Reverse Nodes in k-Group"
date: 2024-04-04
draft: false
weight: 42
---

# 🧩 Question: Reverse Nodes in k-Group (LeetCode 25)
Given the head of a linked list, reverse the nodes of the list `k` at a time, and return the modified list. `k` is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of `k` then left-out nodes, in the end, should remain as it is.

## 🎯 What the interviewer is testing
- Advanced linked list pointer manipulation.
- Recursive vs. Iterative list processing.
- Handling of group segments and leftovers.

---

## 🧠 Deep Explanation

### The Logic:
1. Find the **kth node**. If there are fewer than k nodes left, return the head as is.
2. Reverse the first k nodes.
3. The original head (now the tail of reversed group) should have its `next` point to the result of `reverseKGroup` on the **rest of the list**.

### Reversing k nodes:
Standard pointer reversals: `next = curr.next`, `curr.next = prev`, `prev = curr`, `curr = next`.

---

## ✅ Ideal Answer
We process the list in blocks of size $K$. For each block, we first check if enough nodes exist. If they do, we reverse the segment and recursively link the new tail to the result of the next block. This maintains the constant space complexity required for an iterative solution (or $O(N/K)$ for recursive).

---

## 💻 Java Code
```java
public class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
        ListNode curr = head;
        int count = 0;
        // 1. Find if we have at least k nodes
        while (count < k && curr != null) {
            curr = curr.next;
            count++;
        }
        
        if (count == k) { // We found k nodes, reverse them
            curr = reverseKGroup(curr, k); // Recurse on remaining
            
            // Standard reverse logic for k nodes
            while (count-- > 0) {
                ListNode tmp = head.next;
                head.next = curr;
                curr = head;
                head = tmp;
            }
            head = curr;
        }
        return head;
    }
}
```

---

## ⚠️ Common Mistakes
- Reversing the tail segment when it has fewer than $K$ nodes.
- Losing the reference to the "rest of the list."
- Pointer assignment order leading to cycles.

---

## 🔄 Follow-up Questions
1. **Can you do it in $O(1)$ extra space iteratively?** (Yes, by maintaining a dummy node and four pointers: prevGroupEdge, currentStart, currentEnd, nextGroupEdge.)
2. **What if the remainder should ALSO be reversed?** (Simply skip the count check.)
3. **Complexity?** ($O(N)$ time, $O(N/K)$ space for recursion stack.)
