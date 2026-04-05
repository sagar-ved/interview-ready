---
title: "Java: Final vs. Finally vs. Finalize"
date: 2024-04-04
draft: false
weight: 39
---

# 🧩 Question: Explain the difference between `final`, `finally`, and `finalize()`. When does a `finally` block NOT execute?

## 🎯 What the interviewer is testing
- Core keyword distinction.
- Understanding of exception handling life cycle.
- Awareness of Deprecated features (`finalize`).

---

## 🧠 Deep Explanation

### 1. final (Access Modifier):
- **On Variable**: Constant (cannot be reassigned).
- **On Method**: Cannot be overridden by subclasses.
- **On Class**: Cannot be extended.

### 2. finally (Exception Handling):
- A block of code that **always** executes after a `try-catch`, regardless of whether an exception was thrown. Used for closing resources.
- **Exception**: It won't run if:
  1. `System.exit(0)` is called.
  2. The JVM crashes.
  3. The thread becomes infinite loop or daemon thread is killed by main.

### 3. finalize() (Object lifecycle):
- A method of `java.lang.Object` called by the GC just before the object is reclaimed.
- **Problem**: It is unpredictable and can lead to performance issues and leaks. 
- **Modern alternative**: `AutoCloseable`, `Cleaner`, or `PhantomReference`.

---

## ✅ Ideal Answer
While they sound similar, these three serve completely separate roles. `final` is for immutability and inheritance control; `finally` is for guaranteed resource cleanup; and `finalize` was an old, problematic mechanism for pre-collection logic. In modern Java, `finalize` should be avoided in favor of the Try-With-Resources pattern.

---

## 🔄 Follow-up Questions
1. **Can `finally` block modify a return value?** (Yes, if returning a primitive, but it's very confusing and usually bad practice.)
2. **What is "effectively final"?** (A variable that is never updated after initialization, allowing it to be used in lambdas.)
3. **Why use `final` parameters?** (Documentation and intent — ensures the method doesn't modify the input reference.)
