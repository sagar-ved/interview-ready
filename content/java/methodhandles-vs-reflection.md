---
author: "sagar ved"
title: "Java: MethodHandles vs. Reflection"
date: 2024-04-04
draft: false
weight: 49
---

# 🧩 Question: What are `MethodHandles`? Why are they considered a "Modern Reflection" in Java?

## 🎯 What the interviewer is testing
- Higher-performance dynamic code execution.
- Security and Access control at the API level.
- Understanding of invokedynamic (indy) internals.

---

## 🧠 Deep Explanation

### 1. Traditional Reflection (`java.lang.reflect`):
- **Behavior**: Checks permissions and lookups **every single time** you call `.invoke()`.
- **Cost**: Slow. The JVM has trouble optimizing it.

### 2. MethodHandles (Java 7+):
- **Behavior**: Performs the lookup and access checks **once** (when creating the handle).
- **Result**: Once "bound," the JVM can optimize the call almost as effectively as a direct method call.
- **Flexibility**: Can "transform" method signatures (e.g., swapping arguments, binding specific values to parameters).

### 3. Comparison:
Reflection is easier to use for simple "discovery" tasks. `MethodHandles` are designed for language implementers (like Groovy or JRuby on JVM) and framework developers who need maximum throughput for dynamic calls.

---

## ✅ Ideal Answer
`MethodHandles` provide a low-level, high-performance alternative to standard reflection by shifting expensive permission and lookup checks from invocation-time to creation-time. By leveraging the JVM's `invokedynamic` machinery, they allow dynamic calls to be optimized by the JIT compiler, effectively bridging the gap between flexible code and native-quality speed.

---

## 💻 Java Code
```java
// Setup
MethodHandles.Lookup lookup = MethodHandles.lookup();
MethodType mt = MethodType.methodType(String.class, int.class, int.class);

// One-time lookup
MethodHandle mh = lookup.findVirtual(String.class, "substring", mt);

// High-speed invoke
String res = (String) mh.invokeExact("Hello World", 0, 5); // "Hello"
```

---

## 🔄 Follow-up Questions
1. **What is `invokeExact`?** (A call that requires total type matching—faster than `invoke`.)
2. **Lookup security?** (The `Lookup` object captures the permissions of the class that created it; you can't use a MethodHandle to bypass private access unless the lookup itself has permission.)
3. **Role in Lambdas?** (Java 8 lambdas are implemented under the hood using `invokedynamic` and `MethodHandles`.)
