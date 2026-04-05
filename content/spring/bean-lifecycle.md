---
title: "Spring: Bean Lifecycle"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Explain the Spring Bean Lifecycle. Where exactly do `BeanPostProcessor` and `InitializingBean` fit in?

## 🎯 What the interviewer is testing
- Deep understanding of the `ApplicationContext` container.
- Hooks for custom logic (proxies, initialization).
- Awareness of the sequence of interface vs annotation-driven callbacks.

---

## 🧠 Deep Explanation

### 1. The Core Sequence:
1. **Instantiation**: The bean object is created (Constructor).
2. **Populate Properties**: Dependency Injection happens (@Autowired, setters).
3. **Awareness Interfaces**: `BeanNameAware`, `BeanFactoryAware`, etc.
4. **BeanPostProcessor (Before Initialization)**: `postProcessBeforeInitialization` is called.
5. **Initialization**:
   - `@PostConstruct` (JSR-250 annotation).
   - `afterPropertiesSet()` (InitializingBean interface).
   - `init-method` (XML or @Bean(initMethod)).
6. **BeanPostProcessor (After Initialization)**: `postProcessAfterInitialization`. **Crucial**: This is where **Spring AOP Proxies** are typically created.
7. **Readiness**: Bean is ready for use.
8. **Destruction**: 
   - `@PreDestroy`.
   - `destroy()` (DisposableBean).
   - `destroy-method`.

---

## ✅ Ideal Answer
The Spring bean lifecycle is a multi-stage process managed by the `BeanFactory`. Beyond simple construction and dependency injection, Spring provides powerful hooks like `BeanPostProcessor`, which allow us to wrap beans in proxies (the foundation of AOP and Transactions) or perform custom validation. For senior developers, the key is knowing that `@PostConstruct` runs before `afterPropertiesSet`, and that the `postProcessAfterInitialization` step is where the bean might transition from a raw object to a decorated proxy.

---

## 🏗️ Visual Pipeline:
`CONSTRUCT -> DI -> AWARE -> BPP(Before) -> @PostConstruct -> afterPropertiesSet -> BPP(After/Proxy) -> READY`

---

## 🔄 Follow-up Questions
1. **Can you change a bean's type in a BPP?** (Yes, `postProcessAfterInitialization` allows you to return a totally different object/proxy.)
2. **Difference between `BeanFactory` and `ApplicationContext`?** (`ApplicationContext` is a superset that adds Eager initialization, AOP, and i18n support.)
3. **What happens if a bean is Prototype scoped?** (Only the first half [initialization] is managed; the container does NOT call the destruction methods for prototype beans.)
