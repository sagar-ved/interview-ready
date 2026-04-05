---
title: "DSA: Reverse Nodes in k-Group"
date: 2024-04-04
draft: false
weight: 82
---

# 🧩 Question: Reverse Nodes in k-Group (LeetCode 25 - Hard)
Given a linked list, reverse the nodes of a linked list `k` at a time and return its modified list.

## 🎯 What the interviewer is testing
- Complex linked list pointer manipulation.
- Recursive sub-problems.
- Handling of "remainder" nodes (not divisible by k).

---

## 🧠 Deep Explanation

### The Logic (Recursive):
1. **Count**: Check if there are at least `k` nodes remaining. If not, return `head` (don't reverse).
2. **Reverse**: Perform a standard reversal for the next `k` nodes.
3. **Connect**: The original `head` (now the tail of this segment) should connect to the result of `reverseKGroup(next_node, k)`.

### Pointer Shuffle:
- `prev`, `curr`, `next` are the standard trio.
- In each loop of $k$, `next = curr.next; curr.next = prev; prev = curr; curr = next;`

---

## ✅ Ideal Answer
This problem is a recursive expansion of the basic "reverse linked list" algorithm. We first confirm that a full group exists; if so, we reverse those specific nodes and then recursively link our new tail to the result of the remaining list. This modular approach ensures that segments are processed independently and remainners are preserved correctly according to the problem constraints.

---

## 💻 Java Code
```java
public class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
        ListNode curr = head;
        int count = 0;
        
        // Find the k+1 node
        while (count < k && curr != null) {
            curr = curr.next;
            count++;
        }
        
        if (count == k) {
            // Reverse first k nodes
            curr = reverseKGroup(curr, k); // Reverse next group first
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

## 🔄 Follow-up Questions
1. **Iterative approach?** (Possible with a "prev_group_tail" anchor, but much more code.)
2. **Complexity?** ($O(N)$ time, $O(N/K)$ space due to recursion stack.)
3. **What if the remainder also needs to be reversed?** (Simply skip the count check.)
