---
author: "sagar ved"
title: "Java: Functional Interface Internals"
date: 2024-04-04
draft: false
weight: 41
---

# 🧩 Question: What is a Functional Interface? Why does `@FunctionalInterface` exist if it's optional?

## 🎯 What the interviewer is testing
- SAM (Single Abstract Method) principle.
- Compiler-level verification.
- Evolution of Java 8 features.

---

## 🧠 Deep Explanation

### 1. The Rule:
A functional interface is any interface with **exactly one** abstract method (SAM). It can have multiple `default` or `static` methods.

### 2. The Annotation:
`@FunctionalInterface` is like `@Override`. 
- **The Value**: It tells the compiler to THROW AN ERROR if you accidentally add a second method to that interface. 
- IT protects the "contract" for use in Lambda expressions.

### 3. Lambdas and Targets:
You can only assign a Lambda to a variable of a Functional Interface type. 
`Runnable r = () -> System.out.println("Hi");` -> `Runnable` is a functional interface.

---

## ✅ Ideal Answer
Functional interfaces are the structural backbone of Java's lambda expressions, representing a single contract of behavior. While the `@FunctionalInterface` annotation is optional, its use is a critical best practice that ensures your API remains compatible with functional programming patterns. It prevents accidental breaking changes and serves as a clear signal to other developers that the interface is designed as an executable target for lambdas or method references.

---

## 🏢 Common Examples:
- `Predicate<T>` (returns boolean)
- `Function<T, R>` (takes T, returns R)
- `Consumer<T>` (takes T, returns void)
- `Supplier<T>` (takes nothing, returns T)

---

## 🔄 Follow-up Questions
1. **Can it have methods from Object?** (Yes. Overriding `equals` or `toString` doesn't count toward the limit because every implementation will inherit them from `Object` anyway.)
2. **Difference between `Function` and `UnaryOperator`?** (`UnaryOperator` is a Function where Input and Output types are the same.)
3. **Why use them in custom code?** (Decoupling. You can pass logic [lambdas] as arguments instead of just data.)
