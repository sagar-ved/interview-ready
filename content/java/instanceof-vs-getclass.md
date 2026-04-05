---
title: "Java: Instanceof vs. GetClass()"
date: 2024-04-04
draft: false
weight: 38
---

# 🧩 Question: Compare `instanceof` and `getClass() == ClassName.class`. Which is better for checking types, and why?

## 🎯 What the interviewer is testing
- Understanding of inheritance and polymorphism.
- Liskov Substitution Principle (LSP).
- Handling `null` safety.

---

## 🧠 Deep Explanation

### 1. `instanceof`:
- **Behavior**: Returns true if the object is an instance of the class **OR** any of its subclasses.
- **Null Safety**: Returns `false` if the object is `null` (no NullPointerException).
- **Usage**: General purpose type checking.

### 2. `getClass() == ...`:
- **Behavior**: Returns true ONLY if the object is **exactly** that class. Subclasses return `false`.
- **Null Safety**: Throws `NullPointerException` if the object is `null`.
- **Usage**: Very strict checking, often used in `equals()` methods to satisfy symmetry rules when inheritance is involved.

---

## ✅ Ideal Answer
`instanceof` respects the hierarchy and allows for polymorphic behavior, making it the standard choice for runtime type detection. `getClass()` is a strict check that ignores inheritance; it is typically reserved for security-critical checks or specific implementations of `equals()` where we must guarantee that two objects have the exact same internal structure before comparison.

---

## 💻 Java Code
```java
Animal dog = new Dog();

dog instanceof Animal;           // true
dog.getClass() == Animal.class; // false (it's a Dog)
```

---

## 🔄 Follow-up Questions
1. **What is Pattern Matching for instanceof (Java 16)?** (Combines the check and the cast: `if (obj instanceof String s) { ... }`)
2. **Why use `instanceof` in `equals()`?** (It allows comparing a `Square` to a `Rectangle` if `Square` extends `Rectangle`, but this can break the "Symmetry" rule of `equals`!)
3. **Difference between `isInstance()` and `instanceof`?** (`isInstance` is the dynamic, reflection-based version of `instanceof`.)
