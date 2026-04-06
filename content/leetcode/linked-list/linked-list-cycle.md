---
author: "sagar ved"
title: "LeetCode 141 & 142: Linked List Cycle"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 LeetCode 141 & 142: Linked List Cycle (Easy/Medium)
Detect if a linked list has a cycle (141). If yes, find the cycle start (142).

## 🎯 What the interviewer is testing
- Floyd's Cycle Detection (Tortoise and Hare).
- Mathematical proof for finding the cycle entry point.
- $O(1)$ space cycle detection.

---

## 🧠 Deep Explanation

### Floyd's Algorithm — Cycle Detection (LC 141):
- `slow` moves 1 step, `fast` moves 2 steps.
- If they meet → cycle exists.
- If `fast` reaches null → no cycle.

### Finding Cycle Start (LC 142):
Once `slow == fast` (meeting point):
1. Reset `slow` to `head`.
2. Move **both** `slow` and `fast` one step at a time.
3. They meet at the **cycle start**.

**Why does the math work?** Let `L` = distance to cycle start, `C` = cycle length, `k` = intersection offset within cycle. When they first meet: `slow` traveled `L+k`, `fast` traveled `2(L+k)`. Resetting one pointer to head and advancing both at speed 1 makes them converge at `L` steps later — exactly the cycle start.

---

## ✅ Ideal Answer
Floyd's algorithm detects cycles in $O(N)$ time and $O(1)$ space. The mathematical relationship between the meeting point and the cycle entry is elegant — resetting one pointer to the head and advancing both at equal speed reveals the exact start.

---

## 💻 Java Code
```java
public class Solution {
    // LC 141
    public boolean hasCycle(ListNode head) {
        ListNode slow = head, fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next; fast = fast.next.next;
            if (slow == fast) return true;
        }
        return false;
    }

    // LC 142
    public ListNode detectCycle(ListNode head) {
        ListNode slow = head, fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next; fast = fast.next.next;
            if (slow == fast) {
                slow = head;
                while (slow != fast) { slow = slow.next; fast = fast.next; }
                return slow;
            }
        }
        return null;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Find cycle length?** (After detection: keep `fast` fixed, move `slow` one step at a time until it returns to `fast` — count steps.)
2. **Remove the cycle?** (Find the node just before the cycle start and set its `next = null`.)
3. **Multiple cycles?** (Floyd's only handles a single-cycle linear list — a more complex structure isn't represented as a standard linked list.)
