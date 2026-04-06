---
author: "sagar ved"
title: "System Design: Notification System"
date: 2024-04-04
draft: false
weight: 25
---

# 🧩 Question: Design a large-scale Notification System (Push, Email, SMS). How do you handle "Priority" and "Retry" logic?

## 🎯 What the interviewer is testing
- Third-party API integration (Twilio, Firebase).
- Dealing with flaky external dependencies.
- Deduplication and Rate Limiting.

---

## 🧠 Deep Explanation

### 1. Ingestion:
Microservices send "SendNotification" messages to a **Message Queue** (Kafka).

### 2. Workers & Priority:
Use multiple queues:
- **High Priority**: Verification codes (OTP) - MUST be sent in < 2 seconds.
- **Low Priority**: Marketing ads - Can wait 1 hour.
- This prevents a mass marketing campaign from blocking important password resets.

### 3. The Retry Strategy:
External APIs (like Apple Push) can fail.
- **Exponential Backoff**: Try again in 1s, 2s, 4s...
- **Dead Letter Queue (DLQ)**: If it fails 5 times, move it to a DLQ for manual inspection.

### 4. Deduplication:
Avoid sending the same "Order Confirmed" SMS twice. 
- Use a `NotificationID` and a shared cache (Redis) to check `AlreadySent(NotificationID, UserID)` before firing.

---

## ✅ Ideal Answer
A production notification system must balance speed with reliability. We use a multi-queue architecture to isolate critical traffic from marketing volume, ensuring sub-second delivery for time-sensitive events like OTPs. Our workers implement robust retry mechanisms with exponential backoff and localized deduplication to gracefully handle the inherent flakiness of third-party delivery providers.

---

## 🏗️ Architecture
```
[Services] -> [Load Balancer] -> [Notification API]
                                      ↓
[Redis Cache] <--- [Worker] <--- [Priority Queues]
                     ↓
[FCM (Push)] [Twilio (SMS)] [SendGrid (Email)]
```

---

## 🔄 Follow-up Questions
1. **User Preferences?** (Need a `PreferencesService` to check if a user blocked "Marketing SMS" before sending.)
2. **Batching?** (For emails, we might batch 10 notifications into one summary email to avoid spamming.)
3. **Tracking?** (The system must track "Opened" or "Clicked" status via callback webhooks from the providers.)
