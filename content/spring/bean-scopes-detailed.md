---
author: "sagar ved"
title: "Spring: Bean Scopes"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: What are the different Bean Scopes in Spring? How does a "Singleton" bean handle a "Prototype" dependency?

## 🎯 What the interviewer is testing
- Object lifecycle and memory management.
- Multi-threading safety (Singleton is shared!).
- Solving the "Scope-Leake" problem (Method Injection).

---

## 🧠 Deep Explanation

### 1. The Scopes:
- **Singleton (Default)**: One instance per container.
- **Prototype**: A new instance every time it is requested.
- **Request**: One per HTTP request (Web apps).
- **Session**: One per HTTP session (Web apps).

### 2. The Injection Trap:
If a **Singleton Bean S** depends on a **Prototype Bean P**:
- Spring injects P into S **only once** during initialization.
- Every time you use S, you are using the **exact same** P instance. The "prototypicality" of P is lost!

### 3. The Solution:
- **`@Lookup`**: Annotate a method to return the prototype. Spring overrides the method to call `applicationContext.getBean(P.class)`.
- **ObjectFactory / Provider**: Inject `ObjectFactory<P>` and call `.getObject()`.
- **Proxy Mode**: Use `@Scope(value = "prototype", proxyMode = ScopedProxyMode.TARGET_CLASS)`. Spring injects a proxy that finds a new instance for every method call.

---

## ✅ Ideal Answer
Spring's singleton scope is the backbone of its efficiency, but it requires careful design when interacting with non-singleton dependencies. Because a singleton's state is shared across all threads, any prototype or request-scoped beans injected into it will effectively become singletons themselves if not handled correctly. We resolve this using "Method Injection" or "Scoped Proxies," ensuring that our architectural layers remain both thread-safe and truly representative of their intended lifecycles.

---

## 🔄 Follow-up Questions
1. **Are Singleton beans Thread-Safe?** (No! They are shared. You must not have "mutable shared state" in a singleton bean unless it's synchronized.)
2. **Difference between `prototype` and `new MyObject()`?** (Prototype beans are still managed by Spring—DI, Aware interfaces, and Lifecycle hooks still apply.)
3. **When to use Prototype?** (For stateful objects that carry data specific to a calculation or task that shouldn't be shared.)
