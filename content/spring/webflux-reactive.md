---
author: "sagar ved"
title: "Spring WebFlux: Reactive Programming"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: What is Spring WebFlux? How does its "Non-blocking" nature differ from standard Spring MVC?

## 🎯 What the interviewer is testing
- Reactive streams (Mono/Flux).
- Event-loop architecture (Netty).
- Dealing with high-concurrency without thread-starvation.

---

## 🧠 Deep Explanation

### 1. Spring MVC (Blocking/Servlet):
- **Model**: Thread-per-request. 
- **The Limit**: If you have 200 threads, and all are waiting for a slow DB call, the 201st user is blocked. Your CPU is idle but your threads are exhausted.

### 2. WebFlux (Non-blocking):
- **Model**: Event-loop (like Node.js). 
- **The Magic**: A small number of threads (one per CPU core) handle all requests. When a request hits a DB call, the thread **registers a callback** and immediately goes to help someone else.
- **Backpressure**: Prevents the producer from overwhelming the consumer by allowing the consumer to signal how much data it can handle.

---

## ✅ Ideal Answer
WebFlux shifting the execution model from "waiting for data" to "reacting to data." In a high-concurrency environment with slow I/O, WebFlux can handle thousands of concurrent users with just a few threads, providing massive scalability where standard MVC would crumble under thread overhead. However, it requires a fully reactive stack—including reactive database drivers—as even one blocking call in a reactive thread will sabotage the entire event loop.

---

## 🏗️ Visual State:
- **MVC**: `User -> Thread -> [Wait 50ms] -> Result` (Thread is busy doing nothing).
- **WebFlux**: `User -> EventLoop -> [Register DB Callback] -> [Work on next user]` (Thread never waits).

---

## 🔄 Follow-up Questions
1. **Mono vs Flux?** (Mono is for 0-1 items; Flux is for 0-N items.)
2. **Can you use JPA with WebFlux?** (Technically yes, but it blocks threads, which ruins the benefit. Use **R2DBC** instead.)
3. **When NOT to use WebFlux?** (If your system is mostly CPU-bound or if your entire team is not comfortable with the steeper learning curve of reactive functional programming.)
