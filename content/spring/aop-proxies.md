---
title: "Spring: AOP Proxies (JDK vs. CGLIB)"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: How does Spring AOP work? Explain the difference between JDK Dynamic Proxies and CGLIB.

## 🎯 What the interviewer is testing
- Understanding of "Proxying" mechanism.
- Impact of Interfaces on proxy selection.
- Performance and limitation of different proxying strategies.

---

## 🧠 Deep Explanation

### 1. The AOP Concept:
Aspect-Oriented Programming works by "wrapping" your bean in a **Proxy**. When you call a method, you're actually calling the proxy, which executes the "Advice" (e.g. `@Before`, `@Around`) and then calls your real method.

### 2. JDK Dynamic Proxy (Interface-based):
- **Requirement**: The bean MUST implement at least one interface.
- **Mechanism**: Use standard Java `java.lang.reflect.Proxy`. Creates a proxy that implements the same interfaces.
- **Limitation**: Cannot proxy methods not declared in an interface. 

### 3. CGLIB Proxy (Class-based):
- **Requirement**: Does NOT need an interface.
- **Mechanism**: Generates a **Subclass** of your bean at runtime. 
- **Limitation**: Cannot proxy `final` classes or `final` methods (since you can't override them).
- **Default**: Spring Boot 2+ defaults to CGLIB even if interfaces exist.

---

## ✅ Ideal Answer
Spring AOP is essentially a dynamic wrapper system. While JDK proxies are the "natural" Java way, requiring interfaces to function, CGLIB is the "power-user" way, using bytecode generation to create subclasses on the fly. Knowing the difference is critical because many Spring "magic" failures—like `@Transactional` not working on a private or final method—stem directly from the technical limitations of these underlying proxy frameworks.

---

## 🔄 Follow-up Questions
1. **What is a "JoinPoint"?** (A point in the execution of the program, such as the execution of a method.)
2. **What is a "Pointcut"?** (An expression that matches JoinPoints—it defines *where* the advice should apply.)
3. **Can you have an aspect on a private method?** (No, because the proxy can't override/intercept private method calls.)
