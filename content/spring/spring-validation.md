---
author: "sagar ved"
title: "Spring: Validation (@Valid vs. @Validated)"
date: 2024-04-04
draft: false
weight: 13
---

# 🧩 Question: How do you perform data validation in Spring? Compare `@Valid` (Standard) and `@Validated` (Spring-Specific).

## 🎯 What the interviewer is testing
- JSR-303/380 Bean Validation knowledge.
- Validation "Groups" for different scenarios.
- Method-level vs. Controller-level validation.

---

## 🧠 Deep Explanation

### 1. @Valid (Standard Java):
- Part of Jakarta/JSR-303.
- **Use Case**: Used on Controller arguments to trigger validation of an incoming JSON body.
- **Limitation**: Does not support "Groups."

### 2. @Validated (Spring-Specific):
- **Use Case 1 (Groups)**: If you want to require an `ID` for an `UPDATE` but NOT for a `CREATE`, you can define "Validation Groups" and tell Spring to only run specific checks.
- **Use Case 2 (AOP)**: Put on a **Service class** to enable method-level validation of its parameters.

### 3. Handling Errors:
If validation fails, Spring throws `MethodArgumentNotValidException`. Use a `@ControllerAdvice` to catch it and return a clean formatted list of error messages.

---

## ✅ Ideal Answer
Spring's validation system bridges standard Java Bean Validation with its own AOP-driven features. While `@Valid` is sufficient for standard request body checks, `@Validated` provides the advanced capabilities needed for class-level method checks and conditional group-level validation. For high-scale production systems, centralizing these checks prevents corrupted data from ever reaching our domain logic, keeping our architecture clean and secure.

---

## 🏗️ Group Example:
```java
// Controller
public void save(@Validated(CreateGroup.class) UserDto user) { ... }
```

---

## 🔄 Follow-up Questions
1. **How to create a Custom Validator?** (Create an annotation and implement the `ConstraintValidator` interface.)
2. **Does it work on primitive types?** (In Spring 3.x with Method Validation, yes. You can put `@Min(18)` directly on a service method parameter `int age`.)
3. **Difference between `BindingResult` and `ExceptionHandling`?** (`BindingResult` allows you to handle errors manually inside the controller method; `ExceptionAdvice` handles them globally.)
