---
title: "LeetCode 146: LRU Cache"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: LRU Cache (LeetCode 146)
Implement an LRU Cache with `get` and `put` in $O(1)$ time.

## 🎯 What the interviewer is testing
- HashMap for $O(1)$ lookup.
- Doubly Linked List for $O(1)$ insertion/deletion.
- Combining two data structures for a hybrid cache.

---

## 🧠 Deep Explanation

### The Design:
- **HashMap**: `key → Node` for $O(1)$ lookup.
- **Doubly Linked List**: Maintains access order; head = most recent, tail = least recent.

### Operations:
- `get(key)`: Move accessed node to head → return value.
- `put(key, val)`: Insert at head. If full → evict tail node.

---

## ✅ Ideal Answer
A HashMap alone lacks ordering. A DLL alone lacks $O(1)$ lookup. Combined, they give us both: the map finds the node instantly, and the DLL lets us move/remove it in $O(1)$ via pointer rewiring.

---

## 💻 Java Code
```java
class LRUCache {
    class Node { int key, val; Node prev, next; Node(int k, int v) { key=k; val=v; } }
    Map<Integer, Node> map = new HashMap<>();
    int capacity;
    Node head = new Node(0,0), tail = new Node(0,0);

    public LRUCache(int cap) {
        capacity = cap; head.next = tail; tail.prev = head;
    }

    public int get(int key) {
        if (!map.containsKey(key)) return -1;
        Node n = map.get(key); remove(n); insert(n); return n.val;
    }

    public void put(int key, int value) {
        if (map.containsKey(key)) remove(map.get(key));
        if (map.size() == capacity) remove(tail.prev);
        insert(new Node(key, value));
    }

    private void remove(Node n) { map.remove(n.key); n.prev.next = n.next; n.next.prev = n.prev; }
    private void insert(Node n) {
        map.put(n.key, n); n.next = head.next; n.next.prev = n; head.next = n; n.prev = head;
    }
}
```

---

## 🔄 Follow-up Questions
1. **Thread-safe?** (Use `ConcurrentHashMap` + `ReentrantReadWriteLock`, or `LinkedHashMap` with synchronized block.)
2. **LFU (Least Frequently Used)?** (Requires frequency tracking with nested maps — harder to implement in $O(1)$.)
3. **Java built-in?** (`LinkedHashMap` with `accessOrder=true` and `removeEldestEntry` can simulate LRU in a few lines.)
