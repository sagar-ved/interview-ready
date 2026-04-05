---
title: "Java: Class.forName vs. ClassLoader"
date: 2024-04-04
draft: false
weight: 38
---

# 🧩 Question: What is the difference between `Class.forName("Name")` and `ClassLoader.loadClass("Name")`?

## 🎯 What the interviewer is testing
- Deep class-loading lifecycle.
- Understanding of "Initialization" vs "Loading."
- Use cases in JDBC and frameworks.

---

## 🧠 Deep Explanation

### 1. The 3 Phases of Class Loading:
- **Loading**: Binary data is read into memory.
- **Linking**: Verification, status memory allocation, and resolving references.
- **Initialization**: Static blocks (`static { ... }`) and static fields are executed.

### 2. Class.forName() (The Bold One):
- **Behavior**: Loads, links, and **Initializes** the class by default.
- **Why**: This is why it's used in legacy JDBC: `Class.forName("com.mysql.jdbc.Driver")`. The Driver has a static block that registers itself with the `DriverManager`. Without initialization, the registration wouldn't happen.

### 3. ClassLoader.loadClass() (The Lazy One):
- **Behavior**: Only **Loads** the class. It does not initialize it.
- **Why**: Used for performance-sensitive loading (e.g. checking if a class exists without triggering its potentially heavy static side effects).

---

## ✅ Ideal Answer
While both methods retrieve a Class object, they differ in how much of the class lifecycle they trigger. `Class.forName` is eager and triggers static initializers, making it the choice for components that need to register themselves upon loading. `ClassLoader.loadClass` is lazy, making it safer for scanning or resolving dependencies where static side effects could be premature.

---

## 🔄 Follow-up Questions
1. **Is `Class.forName` still needed in Java 8+?** (Mostly no for JDBC, as the `ServiceLoader` API automatically finds drivers in the classpath.)
2. **Can you prevent `forName` from initializing?** (Yes, use the 3-arg overload: `Class.forName(name, false, loader)`.)
3. **How to get the ClassLoader of a class?** (`myObj.getClass().getClassLoader()`)
