---
title: "System Design: Design a Notification System"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: Design a large-scale Notification System (SMS, Email, Push). How do you handle retries, rate limiting, and guaranteed delivery?

## 🎯 What the interviewer is testing
- Decoupling of producers and consumers via message queues.
- Handling of external third-party API dependencies (Twilio, SendGrid).
- Managing "Backpressure" and "Throttling".

---

## 🧠 Deep Explanation

### 1. High-Level Flow:
App Event → **Notification Gateway** (Validation, Rate Limiting) → **Queue** (Kafka/RabbitMQ) → **Workers** → **Third-party Providers**.

### 2. Core Components:
- **Rate Limiter**: Prevent a single user/bug from overwhelming the system.
- **Deduplication**: Use a `request_id` to ensure one event doesn't trigger two emails.
- **Priority Queue**: Urgent notifications (OTP) vs low-priority news.

### 3. Handling Failure (The "Must Have"):
External APIs fail all the time.
- **Retries with Exponential Backoff**: Try again after 1s, 2s, 4s...
- **Dead Letter Queue (DLQ)**: If a message fails after $N$ retries, put it in a separate queue for manual inspection.
- **Circuit Breaker**: If Twilio is down, stop trying for a few seconds to avoid wasting resources.

---

## ✅ Ideal Answer
For a robust notification system, we use an asynchronous architecture with localized workers for each channel (Email, SMS). We implement strict deduplication and a retry mechanism with exponential backoff. Most importantly, we handle third-party provider downtime using circuit breakers and monitor delivery rates via webhooks provided by the vendors.

---

## 🏗️ Architecture
```
[User App] 
     ↓
[Notification API] -> [Rate Limiter] -> [Kafka Topic (OTP/News/Info)]
                                                  ↓
                            [Email Worker]  [SMS Worker]  [Push Worker]
                                  ↓               ↓              ↓
                             [SendGrid]        [Twilio]        [FCM]
```

---

## 🔄 Follow-up Questions
1. **How to ensure "Exactly-once" delivery?** (Impossible over networks, but can achieve "Effectively-once" via idempotency keys at the receiver end.)
2. **How to handle millions of scheduled notifications?** (Use an index in a database or a "delay queue" mechanism.)
3. **Difference between Kafka and RabbitMQ for this?** (Kafka for high-throughput stream; RabbitMQ for complex routing and priority.)
