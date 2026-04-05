---
title: "Spring: RestTemplate vs. WebClient vs. Feign"
date: 2024-04-04
draft: false
weight: 17
---

# 🧩 Question: Which HTTP Client should you choose? Compare RestTemplate, WebClient, and OpenFeign.

## 🎯 What the interviewer is testing
- Modern API client evolution.
- Synchronous vs Asynchronous logic.
- Understanding of "Declarative" clients.

---

## 🧠 Deep Explanation

### 1. RestTemplate (Legacy/Deprecated):
- **Model**: Synchronous and Blocking. 
- **Style**: Programmatic (building long URLs manually).
- **Status**: Maintenance mode. Still used in millions of legacy apps.

### 2. WebClient (The Modern Standard):
- **Model**: Reactive and Non-blocking. (Part of WebFlux).
- **Style**: Fluent API. 
- **Pro**: Can do both Synchronous (`.block()`) and Asynchronous calls perfectly.

### 3. OpenFeign (The Declarative one):
- **Style**: Just write an **Interface**! Spring generates the code.
- **Pro**: Extremely clean. Great for Microservices.
- **Cons**: Most standard versions are Blocking (like RestTemplate).

---

## ✅ Ideal Answer
For new, high-scale applications, `WebClient` is the versatile choice, providing the flexibility to handle both modern reactive flows and traditional synchronous calls with a superior, non-blocking architecture. `OpenFeign` remains a favorite for internal microservice communication due to its clear, interface-driven style, though it often sacrifices the raw scalability of a truly reactive client. `RestTemplate`, while familiar, should be phased out in favor of the more performant and feature-rich alternatives.

---

## 🏗️ Visual Cheat-sheet:
- **WebFlux App?** -> Always `WebClient`.
- **Many internal services?** -> `OpenFeign` (Clean code).
- **Legacy maintenance?** -> `RestTemplate`.

---

## 🔄 Follow-up Questions
1. **Can `WebClient` call an MVC (blocking) service?** (Yes, it's just HTTP. The caller's non-blocking nature doesn't care if the receiver is slow.)
2. **What is a "Retry Policy" in WebClient?** (Built-in `.retry(3)` or sophisticated retry patterns with exponential backoff using `Retry` utility.)
3. **Load Balancing?** (Spring Cloud allows all these clients to integrate with **LoadBalancer** to find service IPs automatically via Eureka.)
