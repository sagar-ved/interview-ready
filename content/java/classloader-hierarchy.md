---
author: "sagar ved"
title: "Java: ClassLoader Hierarchy"
date: 2024-04-04
draft: false
weight: 39
---

# 🧩 Question: How does the Java ClassLoader work? Explain the "Delegation Model" and the three built-in ClassLoaders.

## 🎯 What the interviewer is testing
- JVM runtime architecture.
- Security and "is-a" identity of classes.
- Solving "ClassCastException" between different loaders.

---

## 🧠 Deep Explanation

### 1. The Three Layers:
1. **Bootstrap ClassLoader**: Loads core Java libraries (`rt.jar`, `java.lang.*`). Written in native code.
2. **Platform ClassLoader**: Loads extension libraries (`javax.*`, etc.).
3. **App (System) ClassLoader**: Loads classes from the `classpath` provided via `-cp`.

### 2. The Delegation Model:
When a ClassLoader is requested to load a class:
1. It first **delegates** the request to its parent.
2. The parent delegates to its parent, all the way to the Bootstrap.
3. If the parent cannot find it, only THEN does the child attempt to load it.
- **Why?**: Security. This prevents a user from providing their own `java.lang.String` class to hijack the system.

### 3. Visibility:
A class loaded by a parent is visible to the child, but a class loaded by a child is **not visible** to the parent.

---

## ✅ Ideal Answer
The Java ClassLoader uses a hierarchical delegation model to ensure that core system classes remain trusted and unique. By always checking with parents first, Java avoids "Class collision" and prevents malicious code from overriding fundamental platform behavior. Understanding this hierarchy is essential for debugging JAR conflicts in complex enterprise applications.

---

## 🔄 Follow-up Questions
1. **How to create a custom ClassLoader?** (Extend `ClassLoader` and override `findClass()`.)
2. **What is a "Parent-Last" ClassLoader?** (Used in some Web Containers [Tomcat] where the child tries to load its own libraries before asking the parent — this allows an app to use a different version of a library than the server.)
3. **What is the `Class.forName()` vs `ClassLoader.loadClass()`?** (`forName` performs static initialization of the class; `loadClass` only loads it.)
