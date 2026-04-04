---
title: "LRU Cache Implementation"
date: 2024-04-04
draft: false
---

# Data Structures: LRU Cache

## 📌 Question
Implement a Least Recently Used (LRU) Cache with `get` and `put` operations in O(1) time complexity.

## 🎯 What is being tested
- HashMaps (O(1) lookup).
- Doubly Linked Lists (O(1) insertion/deletion).
- Managing edge cases (Cache empty, Cache full).

## 🧠 Explanation
An LRU Cache requires fast access by key (`HashMap`) and maintaining an order of access to identify least recently used items (`Doubly Linked List`).

**Operations**:
- `get(key)`: Move accessed node to the head (most recent).
- `put(key, value)`: Insert new node at the head. If full, remove the tail node.

## ✅ Ideal Answer
Start with why a `HashMap` alone isn't enough (it lacks order). Then introduce a `Doubly Linked List` to track the "recency" of items. The implementation should store `Node` objects in a `Map<K, Node>`.

## 💻 Code Example (Java)
```java
import java.util.HashMap;
import java.util.Map;

class LRUCache {
    class Node {
        int key, value;
        Node prev, next;
        Node(int k, int v) { key = k; value = v; }
    }

    private Map<Integer, Node> map = new HashMap<>();
    private int capacity;
    private Node head, tail;

    public LRUCache(int cap) {
        capacity = cap;
        head = new Node(0, 0);
        tail = new Node(0, 0);
        head.next = tail;
        tail.prev = head;
    }

    public int get(int key) {
        if (!map.containsKey(key)) return -1;
        Node node = map.get(key);
        remove(node);
        insert(node);
        return node.value;
    }

    public void put(int key, int value) {
        if (map.containsKey(key)) remove(map.get(key));
        if (map.size() == capacity) remove(tail.prev);
        insert(new Node(key, value));
    }

    private void remove(Node node) {
        map.remove(node.key);
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }

    private void insert(Node node) {
        map.put(node.key, node);
        node.next = head.next;
        node.next.prev = node;
        head.next = node;
        node.prev = head;
    }
}
```

## ⚠️ Common Mistakes
- Forget to update pointer references (NullPointer).
- Not managing capacity during insertion.

## 🔄 Follow-ups
- How to make this thread-safe (`ConcurrentHashMap` + `ReadWriteLock`)?
- What are the differences between LRU and LFU (Least Frequently Used)?
