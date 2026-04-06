---
author: "sagar ved"
title: "Spring: Application Event Handling"
date: 2024-04-04
draft: false
weight: 29
---

# 🧩 Question: How do you implement Event-Driven logic within a single Spring application? Explain `@EventListener`.

## 🎯 What the interviewer is testing
- Decoupling components.
- Observer pattern in Spring.
- Transaction-aware events (@TransactionalEventListener).

---

## 🧠 Deep Explanation

### 1. The Strategy:
Instead of `OrderService` calling `EmailService` directly (Tight coupling), `OrderService` publishes an `OrderCreatedEvent`.

### 2. The Components:
- **`ApplicationEventPublisher`**: Used to send the event.
- **`@EventListener`**: Put on any method to receive the event.

### 3. The Power of Transactional Events:
If OrderService fails after publishing, you don't want the email sent! 
- **`@TransactionalEventListener(phase = AFTER_COMMIT)`**: The event is only sent IF the original transaction successfully saves to the database.

---

## ✅ Ideal Answer
Application events are a critical tool for maintaining a clean, decoupled architecture within a monolith. By shifting from direct method calls to an event-based approach, we ensure that side-effects like notifications or analytics don't clutter our core business logic. Furthermore, by using Transaction-Aware Listeners, we guarantee system consistency, ensuring that external actions are only triggered once our internal state is safely persisted to the database.

---

## 🔄 Follow-up Questions
1. **Asynchronous Events?** (Add `@Async` to the listener. By default, events are processed synchronously in the same thread.)
2. **What is `ContextRefreshedEvent`?** (A built-in event fired when the ApplicationContext is fully initialized. Great for custom warm-up logic.)
3. **Event Ordering?** (Use `@Order` to decide which listener runs first.)
