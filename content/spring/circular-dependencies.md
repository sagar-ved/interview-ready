---
author: "sagar ved"
title: "Spring: Circular Dependencies"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: How does Spring handle Circular Dependencies between Singleton beans? When does it fail?

## 🎯 What the interviewer is testing
- Internals of the "Three-Level Cache."
- Awareness of "Setter vs Constructor" injection behavior.
- Prototypical bean limitations.

---

## 🧠 Deep Explanation

### 1. The Three-Level Cache:
Spring uses three maps in `DefaultSingletonBeanRegistry` to solve circularity:
1. **singletonObjects (1st Level)**: Fully initialized beans.
2. **earlySingletonObjects (2nd Level)**: Incomplete beans (instantiated but not yet DI-populated).
3. **singletonFactories (3rd Level)**: Object factories to create early references (especially useful for AOP).

### 2. The Flow (A depends on B, B depends on A):
1. **Start A**: Instance created (1st step). Put into 3rd level cache.
2. **Populate A**: Spring sees it needs B.
3. **Start B**: Spring looks for B. Needs A.
4. **Resupply A**: Spring finds the "Early A" in the 3rd level cache, moves it to 2nd level, and gives it to B.
5. **Finish B**: B is fully created and put in 1st level.
6. **Finish A**: A now has the completed B reference and finishes too.

### 3. The Failure Point:
**Constructor Injection**: If A and B both use constructor injection, Spring cannot even complete the "Instantiate" step of either. It throws `BeanCurrentlyInCreationException`.

---

## ✅ Ideal Answer
Spring's three-level cache allows the container to resolve circular dependencies among singletons by exposing an "unpopulated" reference of a bean before its full initialization. This works seamlessly for setter or field injection. However, circularity is fundamentally unresolvable for constructor injection because the container cannot instantiate the object without its dependencies already being present, making setter-based injection a necessary fallback for such edge cases.

---

## 🔄 Follow-up Questions
1. **How to fix constructor circularity?** (Use `@Lazy` on one of the parameters, which tells Spring to inject a proxy instead of the real object.)
2. **What if the beans are Prototype scoped?** (Spring does NOT handle circularity for prototypes because it doesn't cache them. It will throw an exception or cause a StackOverflow.)
3. **Why use Constructor injection if Setter injection solves more problems?** (Constructor injection promotes "Immutable objects" and ensures the bean is never in an invalid half-created state in our own code.)
