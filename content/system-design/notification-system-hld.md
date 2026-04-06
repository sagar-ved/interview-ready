---
author: "sagar ved"
title: "System Design: Scalable Notification System (HLD)"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: Design a scalable notification system (like WhatsApp/Instagram) that sends Push, SMS, and Email notifications to 100 million users. Some are real-time (chat), others are batch (newsletter).

## 🎯 What the interviewer is testing
- Async, message-queue-driven architecture
- Fan-out problem at scale
- Channel abstraction and extensibility
- Priority queues, rate limiting, deduplication
- Retry, dead-letter queues, and observability

---

## 🧠 Deep Explanation

### 1. Core Requirements

**Functional**:
- Send targeted notifications by user ID and channel (Push, SMS, Email)
- Support scheduled and real-time notifications
- Deduplication (don't send the same notification twice)

**Non-Functional**:
- 100M users; peak: 10M notifications/minute
- P99 delivery latency: < 5 seconds for real-time
- At-least-once delivery with deduplication

### 2. High-Level Architecture

```
Client / Trigger Service
    ↓
Notification API (REST / gRPC)
    ↓
Message Queue (Kafka per channel/priority)
    ↓
Fan-out Workers  ←→ User Preference Service
    ↓               ↓
Channel Workers (Push / SMS / Email Workers)
    ↓
Third-Party Providers (FCM, Twilio, SendGrid)
    ↓
Delivery Status Tracker (Kafka → DB)
```

### 3. Fan-Out Problem

When one action triggers notifications for millions (e.g., a celebrity post), a "push" fan-out sends to all followers' devices — potentially 100M messages.

**Solutions**:
- **Push fan-out at write time**: Precompute and store in each user's notification feed. Good for small follower counts.
- **Pull fan-out at read time**: Users fetch notifications on open. Good for massive follower counts (celebrities).
- **Hybrid**: Pull for celebrities (> 1M followers), push for regular users.

### 4. Priority and Rate Limiting

- Maintain **separate Kafka topics** per priority: `notifications.critical`, `notifications.normal`, `notifications.batch`.
- Rate-limit per user per channel (no more than 5 SMS/day).
- Rate-limit per third-party provider to stay within throttle limits.

### 5. Reliability

- **Retry with exponential backoff**: Failed FCM calls retry after 2s, 4s, 8s...
- **Dead Letter Queue (DLQ)**: After N retries, send to DLQ for manual inspection.
- **Idempotency Key**: Each notification carries a UUID; downstream systems use it to deduplicate re-deliveries.

---

## ✅ Ideal Answer (Structured)

1. **API Layer**: `/notify` endpoint accepts notification events. Validates user preferences.
2. **Queue**: Push to Kafka topic partitioned by `userID` for ordering guarantees.
3. **Fan-out Service**: Reads from Kafka, fetches followers/subscribers, writes to per-channel queues.
4. **Channel Workers**: Independent services for Email, SMS, Push. Each reads from its queue, calls 3rd-party APIs.
5. **Reliability**: Retry + DLQ + idempotency keys.
6. **Deduplication**: Redis SET with TTL — `SETNX notification:{id}` before sending.
7. **User Preferences**: Cached in Redis; DB fallback. Respect Do Not Disturb windows.

---

## 🏗️ Component Diagram

```
┌─────────────────────────────────────────────────────┐
│                  Notification API                   │
│         (Rate Limited, Auth, Dedup Check)           │
└──────────────────────┬──────────────────────────────┘
                       │
              ┌────────▼────────┐
              │   Kafka Topics  │
              │  [critical]     │
              │  [normal]       │
              │  [batch]        │
              └────────┬────────┘
                       │
         ┌─────────────▼─────────────┐
         │       Fan-Out Workers     │
         │  (Check User Preferences) │
         └──┬──────────┬─────────┬───┘
            │          │         │
     ┌──────▼──┐ ┌─────▼──┐ ┌───▼───┐
     │  Push   │ │  SMS   │ │ Email │
     │ Workers │ │Workers │ │Workers│
     └──┬──────┘ └─────┬──┘ └───┬───┘
        │              │         │
      FCM/APNs       Twilio   SendGrid
```

---

## ⚠️ Common Mistakes
- No retry logic — third-party APIs are unreliable
- Single Kafka topic for all notification types — lower priority delays critical ones
- No deduplication — double-sends damage user trust
- Not considering user timezone for Do Not Disturb windows

---

## 🔄 Follow-up Questions
1. **How would you handle 1 billion users with a viral event?** (Lazy fan-out: don't fan-out at write time; use pull-based model with per-celebrity cached feeds.)
2. **How do you ensure ordering of notifications?** (Partition Kafka by `userID` — all messages for a user are in-order within a partition.)
3. **How do you track notification engagement (opened, clicked)?** (Webhook callbacks from FCM/Twilio; store in Cassandra; expose analytics via Spark.)
