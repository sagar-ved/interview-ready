---
title: "LeetCode 138: Copy List with Random Pointer"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Copy List with Random Pointer (LeetCode 138)
A linked list where each node has a `random` pointer to any node or null. Construct a deep copy.

## 🎯 What the interviewer is testing
- Handling non-linear object relationships.
- Mapping old nodes to new nodes.
- Optimizing from $O(N)$ space (Map) to $O(1)$ (Interweaving).

---

## 🧠 Deep Explanation

### 1. HashMap Approach ($O(N)$ space):
- Pass 1: Create all new nodes, store `Map<OldNode, NewNode>`.
- Pass 2: Map `next` and `random` pointers using the map.

### 2. Interweaving Approach ($O(1)$ space):
1. **Duplicate**: Insert clone between each node: `A -> A' -> B -> B'`.
2. **Assign Random**: `A'.random = A.random.next`.
3. **Split**: Detach the two interleaved lists.

---

## ✅ Ideal Answer
Interweaving nodes eliminates the need for an external dictionary by using the structure of the original list itself as the mapping. The key insight is that `A'.random = A.random.next` works because the clone of any node is always immediately after its original.

---

## 💻 Java Code (Interweaving)
```java
public class Solution {
    public Node copyRandomList(Node head) {
        if (head == null) return null;
        Node curr = head;
        // Step 1: Weave clones
        while (curr != null) {
            Node next = curr.next;
            curr.next = new Node(curr.val);
            curr.next.next = next;
            curr = next;
        }
        // Step 2: Set randoms
        curr = head;
        while (curr != null) {
            if (curr.random != null) curr.next.random = curr.random.next;
            curr = curr.next.next;
        }
        // Step 3: Split
        curr = head;
        Node dummy = new Node(0), copyIter = dummy;
        while (curr != null) {
            copyIter.next = curr.next;
            curr.next = curr.next.next;
            copyIter = copyIter.next;
            curr = curr.next;
        }
        return dummy.next;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Cycle in the list?** (Both HashMap and interweaving handle cycles naturally.)
2. **Deep vs Shallow copy?** (Deep = new objects for all members; Shallow = copies references.)
3. **Complexity?** ($O(N)$ time, $O(1)$ space for interweaving.)
