---
title: "System Design: Design an API Gateway"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: What is an API Gateway? Explain its core responsibilities: Auth, Rate Limiting, Routing, and Aggregation.

## 🎯 What the interviewer is testing
- Consolidating ingress in a Microservices architecture.
- Cross-cutting concerns management (BFF - Backend for Frontend).
- Tradeoffs in latency vs decoupling.

---

## 🧠 Deep Explanation

### 1. Auth & Security:
Instead of every microservice validating JWTs or API keys, the Gateway does it once. 
- **Benefit**: "Zero-trust" inside the VPC, but only one place needs the complex logic.

### 2. Rate Limiting:
The gateway protects the entire cluster from being flooded by a single malicious or buggy client.

### 3. Request Aggregation:
- **Scenario**: A user profile page needs data from `UserService`, `OrderService`, and `ReviewService`.
- **Optimization**: The client sends **one** request to the Gateway. The Gateway calls the 3 services internally, combines the JSON, and sends one response back. This saves massive mobile battery and network overhead (less RTT).

### 4. Routing/Versioning:
Mapping `/v1/orders` to `OrderService-Node-A` and `/v2/orders` to `OrderService-Node-B`.

---

## ✅ Ideal Answer
An API Gateway acts as the single entry point for all clients, decoupling external consumers from the internal complexity of a microservice mesh. By centralizing security, performance throttling, and data transformation, it ensures global consistency while allowing back-end teams to iterate on individual services without breaking the public interface.

---

## 🏗️ Architecture
```
[Client] -> [Load Balancer] -> [API Gateway (Kong/Nginx/Zuul)]
                                    ↓ (Internal RPC)
                        [Svc A]  [Svc B]  [Svc C]
```

---

## 🔄 Follow-up Questions
1. **SPOF Risk?** (The Gateway must be highly available and monitored; if it's down, the entire system is invisible.)
2. **Latency?** (Every hop adds delay; the Gateway must be extremely thin [usually written in C++/Go/Rust or Lua-Nginx].)
3. **BFF (Backend for Frontend)?** (A variation where a specific Gateway is built for Mobile apps and another for Web apps.)
