---
author: "sagar ved"
title: "System Design: Design a Global Rate Limiter"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: Design a Rate Limiter for an API distributed across multiple regions. How do you handle consistency, high concurrency, and low latency?

## 🎯 What the interviewer is testing
- Algorithm selection (Token Bucket vs Leaky Bucket).
- Distributed state management (Redis, Lua scripts).
- Understanding "Race Conditions" in high-frequency counters.

---

## 🧠 Deep Explanation

### 1. Algorithms:
- **Token Bucket**: Allow a certain amount of "burst" traffic. Tokens added at a rate; consumed on request.
- **Leaky Bucket**: Fixed rate output. Good for traffic shaping.
- **Fixed/Sliding Window**: Count requests in a timestamp window.

### 2. Distributed Challenge:
If we use a simple Redis `INCR`:
- **Atomic Operations**: Needs `INCR` + `EXPIRE` or a **Lua Script** to check and update atomically.
- **Synchronization**: Syncing state across US-West and EU-West clusters is slow.
- **Strategy**: Cache locally (in-memory) for 90% of requests and sync in batches with a central Redis cluster to reduce cross-region latency.

---

## ✅ Ideal Answer
For a scalable API, a sliding window log or counter stored in a distributed cache like Redis is ideal. To prevent race conditions, we use Lua scripts so the "check-and-increment" occurs as a single atomic operation. To handle extreme scale, we deploy local rate-limit counters in each region and synchronize asynchronously or use a "Throttling Service."

---

## 🏗️ Architecture (Token Bucket with Redis)
```
[Client] -> [API Gateway / Proxy] 
                       ↓ (Check Lock)
                [Regional Redis Cache]
                       ↓ (Sync asynchronously)
                [Global Analytics DB]
```

---

## 💻 Java Context: Resilience4j
In a Java application, we use libraries like **Resilience4j** to handle local rate limiting:
```java
RateLimiterConfig config = RateLimiterConfig.custom()
    .limitRefreshPeriod(Duration.ofSeconds(1))
    .limitForPeriod(10)
    .timeoutDuration(Duration.ofMillis(25))
    .build();
```

---

## ⚠️ Common Mistakes
- Only providing a local in-memory solution for a distributed problem.
- Not accounting for network latency between the app and the rate limiter.
- Forgetting to handle "Burst" traffic.

---

## 🔄 Follow-up Questions
1. **Explain the benefits of Lua scripts in Redis.** (Atomic execution without needing client-side locks.)
2. **What if the Rate Limiter is down?** (Fail-open: allow traffic but log an alert.)
3. **How does Amazon S3 handle throttling?** (Partitioning based on key prefixes.)
