---
title: "Spring: @ConditionalOnMissingBean"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: How does `@ConditionalOnMissingBean` facilitate developer overrides?

## 🎯 What the interviewer is testing
- Spring Boot's "Opinionated" design.
- Creating extensible frameworks.
- Interaction between User-defined and Auto-configured beans.

---

## 🧠 Deep Explanation

### 1. The Conflict:
A Spring Boot Starter wants to provide a `JSONService`. But a developer might want to use their own `FastJSONService`.

### 2. The Solution:
The Starter annotates its bean with:
`@ConditionalOnMissingBean(JSONService.class)`
- If Spring finds a user-defined bean of type `JSONService`, it **SKIPS** the starter's version.
- This is the foundation of Spring Boot. It provides a default that "steps back" the moment you try to take control.

### 3. Other Conditionals:
- `@ConditionalOnProperty`: Only load if `app.feature.enabled=true`.
- `@ConditionalOnClass`: Only load if `Redisson.class` is found in classpath (proving the library is added).

---

## ✅ Ideal Answer
`@ConditionalOnMissingBean` is the mechanism behind Spring Boot's "Sensible Defaults." It allows the platform to provide comprehensive out-of-the-box functionality while guaranteeing that any developer-defined component takes immediate precedence. This creates a friction-less experience where the framework "gets out of the way" as an application's requirements become more customized and mature.

---

## 🔄 Follow-up Questions
1. **What happens if two beans of the same type are found?** (Spring throws `NoUniqueBeanDefinitionException` unless one is marked `@Primary` or they are filtered by conditionals.)
2. **Difference between `@Conditional` and `@Profile`?** (`@Profile` is just a specialized version of `@Conditional` that looks at the active profile string.)
3. **Can you write a Custom Conditional?** (Yes, implement the `Condition` interface and its `matches()` method.)
