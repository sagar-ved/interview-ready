---
author: "sagar ved"
title: "Linked List: Cycle Detection, Reversal, and Merging"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Given a linked list, detect if there is a cycle and return the cycle entry node. Then, implement reversing the list in K-groups.

## 🎯 What the interviewer is testing
- Floyd's cycle detection (slow/fast pointers)
- Pointer manipulation elegance under pressure
- In-place reversal patterns
- Edge case handling (null nodes, single nodes, k > length)

---

## 🧠 Deep Explanation

### 1. Floyd's Cycle Detection

**Phase 1**: `slow` moves 1 step, `fast` moves 2 steps. If there's a cycle, they will meet inside the cycle.

**Phase 2**: Move one pointer back to head. Move both `slow` and `newPointer` at 1 step. Where they meet is the **cycle entry node**.

**Why?** Math: Let L = distance to cycle start, C = cycle length, K = meeting point from cycle start.
- Slow traveled: L + K
- Fast traveled: L + K + C (one full cycle more)
- Fast = 2*Slow → L + K + C = 2*(L + K) → C - K = L
- So distance from meeting point to head == distance from head to cycle start.

### 2. K-Group Reversal

Reverse each chunk of K nodes, then link chunks together. Use a dummy node for cleaner pointer logic.

---

## ✅ Ideal Answer

- **Cycle detection**: Floyd's two-pointer. Entry detection: reset one pointer to head, advance both at same pace.
- **K-group reverse**: Count K nodes, reverse them in-place, recurse on the rest. Handle tail group (< K nodes) by leaving it unchanged.
- Always handle: empty list, single node, K=1, last group smaller than K.

---

## 💻 Java Code

```java
public class LinkedListProblems {

    static class ListNode {
        int val;
        ListNode next;
        ListNode(int val) { this.val = val; }
    }

    // 1. Detect cycle entry — O(n) time, O(1) space
    public ListNode detectCycle(ListNode head) {
        ListNode slow = head, fast = head;

        // Phase 1: Detect meeting point inside cycle
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if (slow == fast) break;
        }

        if (fast == null || fast.next == null) return null; // No cycle

        // Phase 2: Find entry — reset slow to head, advance both at 1 step
        slow = head;
        while (slow != fast) {
            slow = slow.next;
            fast = fast.next;
        }
        return slow; // Cycle entry node
    }

    // 2. Reverse K-group — O(n) time, O(n/k) stack space for recursion
    public ListNode reverseKGroup(ListNode head, int k) {
        // Check if we have at least k nodes
        ListNode check = head;
        for (int i = 0; i < k; i++) {
            if (check == null) return head; // Less than k nodes: return as-is
            check = check.next;
        }

        // Reverse k nodes in-place
        ListNode prev = null, curr = head;
        for (int i = 0; i < k; i++) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }

        // head is now the tail of reversed group; connect to recursively reversed rest
        head.next = reverseKGroup(curr, k);
        return prev; // prev is the new head of reversed group
    }

    // 3. Merge K sorted linked lists — O(N log K) with Min-Heap
    public ListNode mergeKLists(ListNode[] lists) {
        java.util.PriorityQueue<ListNode> pq = new java.util.PriorityQueue<>(
            java.util.Comparator.comparingInt(n -> n.val)
        );

        for (ListNode node : lists) {
            if (node != null) pq.offer(node);
        }

        ListNode dummy = new ListNode(0), curr = dummy;
        while (!pq.isEmpty()) {
            ListNode smallest = pq.poll();
            curr.next = smallest;
            curr = curr.next;
            if (smallest.next != null) pq.offer(smallest.next);
        }
        return dummy.next;
    }

    // 4. Find middle node — O(n) time, O(1) space
    public ListNode middleNode(ListNode head) {
        ListNode slow = head, fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }
        return slow; // For even length, returns second-middle
    }
}
```

---

## ⚠️ Common Mistakes
- Not checking `fast != null && fast.next != null` before advancing fast pointer (NullPointerException)
- Not handling the case where K > list length in K-group reversal
- Forgetting to link the reversed group's tail to the rest (`head.next = reverseKGroup(curr, k)`)
- Using extra space (ArrayList) when O(1) pointer reversal is expected

---

## 🔄 Follow-up Questions
1. **How do you detect if a LinkedList is a palindrome in O(n) time, O(1) space?** (Find middle, reverse second half, compare; restore second half before returning.)
2. **How does LRU Cache use a doubly-linked list?** (O(1) eviction of LRU node — remove tail; O(1) insertion at head; HashMap gives O(1) access to any node.)
3. **What is the time complexity of merging K sorted lists using the naive approach vs heap?** (Naive: O(NK); Heap: O(N log K) where N = total nodes.)
