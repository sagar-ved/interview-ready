---
author: "sagar ved"
title: "Java: Sealed Classes (Java 17)"
date: 2024-04-04
draft: false
weight: 40
---

# 🧩 Question: What are Sealed Classes in Java 17? How do they improve Pattern Matching?

## 🎯 What the interviewer is testing
- Understanding of "Restricted Inheritance."
- Awareness of Algebraic Data Types (ADTs).
- Relationship between compiler knowledge and runtime safety.

---

## 🧠 Deep Explanation

### 1. The Concept:
A `sealed` class or interface allows the developer to explicitly list **which classes** are allowed to extend or implement it. 
`public sealed class Shape permits Circle, Square {}`

### 2. Permitted Classes:
The allowed subclasses must be either `final`, `sealed` (continuing the hierarchy), or `non-sealed` (opening it back up).

### 3. Exhaustiveness in Pattern Matching:
Because the compiler **knows** all possible subclasses of a sealed Type, it can verify that a `switch` statement handles every possible case.
```java
// With sealed classes, no "default" case is needed if all 
// permitted types are covered.
return switch (shape) {
    case Circle c -> ... 
    case Square s -> ...
};
```

---

## ✅ Ideal Answer
Sealed classes allow us to represent "Sum Types" where a variable can be one of a finite, restricted set of types. This provides a bridge between traditional OOP and functional Algebraic Data Types. The main benefit is enhanced compiler safety, specifically in exhaustive switch expressions where the compiler can guarantee that no edge cases are missing.

---

## 💻 Java Code
```java
public sealed interface Payment permits CreditCard, Cash, Crypto {}

public final class Cash implements Payment {}
// ...
```

---

## 🔄 Follow-up Questions
1. **Difference between Final and Sealed?** (Final: No one can extend; Sealed: ONLY specific others can extend.)
2. **Where must subclasses be defined?** (Same module or same package.)
3. **Why use `non-sealed`?** (To intentionally allow a specific branch of your hierarchy to be freely extended by users.)
