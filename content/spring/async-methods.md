---
author: "sagar ved"
title: "Spring: Async Methods (@Async)"
date: 2024-04-04
draft: false
weight: 22
---

# 🧩 Question: How does `@Async` work in Spring? Why is it important to define a custom `TaskExecutor`?

## 🎯 What the interviewer is testing
- Thread-pool management in Java.
- Asynchronous non-blocking calls.
- Avoiding the "Default/Simple" task executor bottleneck.

---

## 🧠 Deep Explanation

### 1. The Proxy Mechanism:
Like `@Transactional`, `@Async` works by proxying. 
- When call `service.asyncMethod()`, the proxy intercepts the call and submits it to a `TaskExecutor` pool.
- It returns a `CompletableFuture` or `void` immediately.

### 2. The Danger (Default Executor):
By default, if you don't define your own executor, Spring uses a `SimpleAsyncTaskExecutor` (which spawns a TOTAL NEW THREAD for every call!) or a very limited default pool.
- **Production Risk**: You can easily run out of system memory if you trigger 10,000 async tasks.

### 3. Custom Pool:
We must define a `ThreadPoolTaskExecutor` to set **Core Pool Size**, **Max Pool Size**, and a **Queue Capacity**.

---

## ✅ Ideal Answer
Spring's `@Async` allows for effortless parallelization by delegating method execution to a background pool. However, relying on the framework's default executor is a high-risk practice for production systems, as it lacks the necessary boundaries for thread and memory management. We mitigate this by defining an explicit `ThreadPoolTaskExecutor`, ensuring that our asynchronous tasks are governed by strict capacity limits that prevent cascading failures under heavy load.

---

## 🏗️ Config Example:
```java
@Bean(name = "myPool")
public Executor taskExecutor() {
    ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
    executor.setCorePoolSize(10);
    executor.setMaxPoolSize(50);
    executor.setQueueCapacity(500);
    executor.initialize();
    return executor;
}
```

---

## 🔄 Follow-up Questions
1. **Self-invocation?** (Will not work; same AOP proxy issue as `@Transactional`.)
2. **Can it return data?** (Yes, it must return `CompletableFuture<T>` or `Future<T>`.)
3. **Exception handling?** (Since the caller doesn't wait, exceptions won't reach the main thread. We need a custom `AsyncUncaughtExceptionHandler` for methods returning `void`.)
