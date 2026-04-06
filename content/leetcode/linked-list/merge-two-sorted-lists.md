---
author: "sagar ved"
title: "LeetCode 21: Merge Two Sorted Lists"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 21: Merge Two Sorted Lists (Easy)
Merge two sorted linked lists and return the merged list in sorted order.

## 🎯 What the interviewer is testing
- Dummy node technique.
- Pointer management in linked lists.
- Recursive vs iterative approach.

---

## 🧠 Deep Explanation

### Iterative (Preferred):
Use a `dummy` node as a handle. Maintain a `curr` pointer.
- Compare `l1.val` vs `l2.val`, attach the smaller one to `curr.next`.
- Advance the chosen pointer and `curr`.
- Attach the remaining non-empty list at the end.

### Recursive:
The problem has optimal substructure: `merge(l1, l2) = smaller + merge(rest, other)`.

---

## ✅ Ideal Answer
The dummy node eliminates the special case for head initialization. By always picking the smaller of the two current heads and advancing that pointer, we produce the merged sorted list in a single pass.

---

## 💻 Java Code (Iterative)
```java
public class Solution {
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        ListNode dummy = new ListNode(0), curr = dummy;
        while (l1 != null && l2 != null) {
            if (l1.val <= l2.val) { curr.next = l1; l1 = l1.next; }
            else { curr.next = l2; l2 = l2.next; }
            curr = curr.next;
        }
        curr.next = (l1 != null) ? l1 : l2;
        return dummy.next;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Merge K sorted lists?** (LeetCode 23: Use a Min-Heap or divide & conquer.)
2. **In-place merge?** (Yes, this IS in-place — we reuse existing nodes without allocating new ones.)
3. **Recursive version?** (Elegant but $O(N)$ stack depth — risk of StackOverflow for very large lists.)
