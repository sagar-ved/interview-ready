---
author: "sagar ved"
title: "System Design: Design a Rate Limiter"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: Design a Rate Limiter. Compare Token Bucket, Leaky Bucket, and Sliding Window algorithms.

## 🎯 What the interviewer is testing
- Knowledge of traffic shaping and protection.
- Distributed counter consistency (Redis).
- Trade-offs between "burstiness" and "smoothness".

---

## 🧠 Deep Explanation

### 1. Token Bucket:
- **Concept**: A bucket holds $N$ tokens. Each request takes one. Tokens are added at a constant rate $R$.
- **Pros**: Allows for **bursts** (if the bucket is full, you can handle $N$ requests instantly).
- **Cons**: Simple to implement but might allow slightly higher instantaneous load.

### 2. Leaky Bucket:
- **Concept**: Requests are "poured" into a bucket and "leak" out at a constant rate $R$ to the server.
- **Pros**: Perfectly **smooths** traffic.
- **Cons**: No burst capability; excess traffic is dropped instantly if the bucket is full.

### 3. Sliding Window Log / Counter:
- **Concept**: Track timestamps of requests in a window (e.g. 1 minute). 
- **Pros**: Most accurate. Use Redis sorted sets for the window.
- **Cons**: High memory usage for "Log"; simplified "Counter" has boundary issues.

---

## ✅ Ideal Answer
For most modern web APIs, a Token Bucket is preferred because it handles bursts gracefully while enforcing an average rate over time. In a distributed environment, we use Redis with Lua scripts to ensure that checking and decrementing the token count is an atomic operation, avoiding race conditions between different API nodes.

---

## 🏗️ Architecture
```
[User Request] 
      ↓
[Middleware Rate Limiter] <-> [Redis (key: user_id)]
      ↓ (Allowed)
[Backend API]
```

---

## 🔄 Follow-up Questions
1. **How to handle millions of rules?** (Store rules in a fast cache; partition Redis by UserID).
2. **What is a "Hard Limit" vs "Soft Limit"?** (Hard: Drop request; Soft: Slow down/delay request).
3. **DDoS vs Rate Limiting?** (Rate limiting handles legit user load; DDoS requires specialized network-level scrubbing [WAF/Cloudflare].)
