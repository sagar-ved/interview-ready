---
title: "Java: Shallow vs. Deep Copy"
date: 2024-04-04
draft: false
weight: 38
---

# 🧩 Question: Difference between Shallow Copy and Deep Copy. Why is `Object.clone()` considered problematic?

## 🎯 What the interviewer is testing
- Memory reference awareness.
- Deep vs Shallow object graphs.
- Knowledge of Copy Constructors and Serialization-based cloning.

---

## 🧠 Deep Explanation

### 1. Shallow Copy:
- Copies the field values. If a field is a **reference** to another object (e.g. `List`), it only copies the **memory address**.
- **Impact**: Both the original and the copy point to the SAME underlying List. Changing one affects the other.

### 2. Deep Copy:
- Recursively copies everything. It creates a brand new instance of every object in the graph.
- **Impact**: Completely independent objects.

### 3. The `clone()` Trap:
- It returns `Object`, requiring a cast.
- It is shallow by default.
- It requires implementing a Marker interface (`Cloneable`) and a `try-catch` for `CloneNotSupportedException`.
- **Better ways**: Copy Constructor (`public MyObj(MyObj other)`) or using a JSON library to serialize/deserialize ($O(N)$ for total deep copy).

---

## ✅ Ideal Answer
A shallow copy only duplicates the top-level references, leading to unintended side effects when shared objects are modified. A deep copy creates a completely new mirror of the object graph. In clean Java design, we prefer copy constructors or factory methods over the legacy `clone()` method for better readability and avoidance of casting errors.

---

## 💻 Java Code: Copy Constructor
```java
public class User {
    String name;
    Address address;

    // Copy Constructor (Deep Copy)
    public User(User other) {
        this.name = other.name;
        this.address = new Address(other.address); // Deep copy the reference
    }
}
```

---

## 🔄 Follow-up Questions
1. **How to deep copy a complex graph easily?** (Serialize to JSON/Bytes and deserialize.)
2. **Are String copies shallow?** (Strings are immutable, so a shallow copy of a String reference is perfectly safe.)
3. **Copy-on-Write logic?** (A hybrid approach: share the data until someone tries to modify it.)
