---
title: "DSA: Copy List with Random Pointer"
date: 2024-04-04
draft: false
weight: 41
---

# 🧩 Question: Copy List with Random Pointer (LeetCode 138)
A linked list of length `n` is given such that each node contains an additional random pointer, which could point to any node in the list, or `null`. Construct a deep copy of the list.

## 🎯 What the interviewer is testing
- Handling non-linear object relationships.
- Mapping old nodes to new nodes.
- Optimizing from $O(N)$ space (Map) to $O(1)$ (Interweaving).

---

## 🧠 Deep Explanation

### 1. HashMap Approach ($O(N)$ space):
1. Loop once: Create all new nodes and store `Map<OldNode, NewNode>`.
2. Loop again: Map the `next` and `random` pointers of new nodes by looking up the map.

### 2. Interweaving Approach ($O(1)$ space):
1. **Duplicate**: Insert a clone of each node between the current node and the next node: `A -> A' -> B -> B'`.
2. **Assign Random**: The `random` for `A'` is simply `A.random.next` (if it exists).
3. **Split**: Separately extract the two interleaved lists to restore the original and get the result.

---

## ✅ Ideal Answer
To handle the random pointer, which might point to a node not yet created, we can either use a HashMap to track the old-to-new mapping or interweave the cloned nodes directly into the original list. Interweaving is more space-efficient as it avoids the need for an external dictionary.

---

## 💻 Java Code: Interweaving
```java
class Node {
    int val; Node next, random;
    Node(int v) { this.val = v; }
}

public class Solution {
    public Node copyRandomList(Node head) {
        if (head == null) return null;

        // 1. Double the list
        Node curr = head;
        while (curr != null) {
            Node next = curr.next;
            Node clone = new Node(curr.val);
            curr.next = clone;
            clone.next = next;
            curr = next;
        }

        // 2. Map random pointers
        curr = head;
        while (curr != null) {
            if (curr.random != null) {
                curr.next.random = curr.random.next;
            }
            curr = curr.next.next;
        }

        // 3. Separate the lists
        curr = head;
        Node dummy = new Node(0);
        Node copyIter = dummy;
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

## ⚠️ Common Mistakes
- Forgetting to Restore the original list (it's often a requirement even if the problem doesn't state it).
- Handling the `null` cases for `random` pointers.
- Not understanding that `head.next.random = head.random.next`.

---

## 🔄 Follow-up Questions
1. **Can you use recursion?** (Yes, similar to DFS/graph cloning, but risks StackOverflow.)
2. **How to handle a cycle in the list?** (Interweaving and Map both handle cycles naturally.)
3. **Deep vs Shallow copy?** (Deep copy creates new objects for all members; shallow only copies references.)
