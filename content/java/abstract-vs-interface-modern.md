---
title: "Java: Abstract Classes vs. Interfaces (Post-Java 9)"
date: 2024-04-04
draft: false
weight: 41
---

# 🧩 Question: After Java 8/9, Interfaces can have default and private methods. So, when would you still use an Abstract Class?

## 🎯 What the interviewer is testing
- Modern Java architecture knowledge.
- Understanding of "State" vs "Behavior."
- Ability to identify core OOP differences beyond syntax.

---

## 🧠 Deep Explanation

### 1. The Blurring Lines:
- **Interfaces**: Can now have `default` methods (behavior) and `private` helper methods.
- **Abstract Classes**: Have always had methods and abstract methods.

### 2. The Core Differences:
- **State (The BIG one)**: Abstract classes can have **instance variables** (fields like `int count`). Interfaces can only have `static final` constants.
- **Constructor**: Abstract classes can have constructors. Interfaces cannot.
- **Multiple Inheritance**: A class can implement many interfaces, but can only extend **one** abstract class.
- **Access Modifiers**: Abstract classes can have `protected` and `private` state/methods. Interface `default` methods are always `public`.

### 3. Rule of Thumb:
- Use **Interface**: To define a **Capability** (e.g. `Flyable`, `Serializable`).
- Use **Abstract Class**: To provide a **Template** with shared state (e.g. `BaseDAO` which has a shared `Connection` field).

---

## ✅ Ideal Answer
While interfaces have gained behavioral capability with default methods, they remain stateless "contracts." Abstract classes are still essential for providing "templates" that share physical state and protected implementation details. Use an interface to describe what a class can DO, and an abstract class to describe what a class IS.

---

## 🏗️ Comparison Table:
| Feature | Interface | Abstract Class |
|---|---|---|
| Multiple Inheritance | Yes | No |
| Instance Fields | No | Yes |
| Constructors | No | Yes |
| Default Access | Public | Default (Package) |

---

## 🔄 Follow-up Questions
1. **Can you create an instance of an Abstract class?** (No, but its constructor IS called when you instantiate a subclass.)
2. **What is a "Functional Interface"?** (An interface with exactly one abstract method, suitable for Lambdas.)
3. **What is a "Sealed Interface" (Java 17)?** (An interface that explicitly limits which classes can implement it.)
