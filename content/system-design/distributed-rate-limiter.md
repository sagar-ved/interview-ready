---
title: "System Design: Distributed Rate Limiter"
date: 2024-04-04
draft: false
---

# 🧩 Question: Design a high-performance, distributed Rate Limiter that can handle millions of requests per second.

## 🎯 What the interviewer is testing
*   **Scalability**: Handling millions of RPS across multiple regions.
*   **Algorithms**: Token Bucket, Leaky Bucket, Fixed Window, Sliding Window Log, Sliding Window Counter.
*   **Consistency vs. Availability**: Handling rate limits in a distributed environment (Redis Lua scripts, race conditions).
*   **Fault Tolerance**: What happens when the Rate Limiter service is down?

---

## 🧠 Deep Explanation

### 1. Common Algorithms
-   **Token Bucket (Most Popular)**:
    -   A bucket has a max capacity. Tokens are added at a fixed rate.
    -   Each request takes a token. If no tokens, request is rejected.
    -   **Pros**: Supports bursts of traffic.
-   **Fixed Window Counter**:
    -   Requests are counted within a fixed time window (e.g., 1 min).
    -   **Cons**: Spike at the edges of windows (double the limit allowed in 2 seconds).
-   **Sliding Window Counter (Redis Recommended)**:
    -   Combines fixed window with a weighted count of the previous window to smooth out spikes.

### 2. High-Level Architecture
1.  **Client Tier**: External requests hit a Load Balancer.
2.  **API Gateway**: Rate Limiting logic usually lives here as a middleware.
3.  **Rate Limiter Service**: A dedicated service or a set of Lua scripts in Redis.
4.  **Distributed Cache (Redis)**: Stores the counters/tokens for each `UserID` or `IP`.

### 3. Handling Distributed Challenges
-   **Race Conditions**: Two concurrent requests might read the same counter value and both increment it, exceeding the limit.
    -   **Solution**: Use **Redis Lua scripts** (atomic execution) or **Redis Sorted Sets (`ZSET`)** for sliding windows.
-   **Synchronization Issues**: In a multi-regional setup, syncing Redis across regions introduces latency.
    -   **Solution**: Local Rate Limiting with eventual global synchronization or sticky sessions.

### 4. Failure Modes
-   If the Rate Limiter fails, the system should **Fail Open** (allow requests) to maintain availability, or use a hard-coded fallback.

---

## ✅ Ideal Answer (Structured)

*   **Requirements Clarity**: Define the "What" (Limit per user/IP/API key) and "Where" (API Gateway vs. Middleware).
*   **Algorithm Choice**: Suggest **Token Bucket** for its simplicity and burst support.
*   **Storage**: Use **Redis** as it's an in-memory store with low latency and atomic operations.
*   **Performance**: Use **Lua Scripts** to minimize round-trips between the app and Redis.
*   **Scalability**: Explain how to shard Redis by `UserID` to handle millions of keys.

---

## 💻 Code Example (Redis Lua Script for Token Bucket)

```lua
-- keys: user_id_bucket
-- args: rate, capacity, now, requested_tokens

local bucket = redis.call('HMGET', KEYS[1], 'last_refill_time', 'tokens')
local last_refill_time = tonumber(bucket[1]) or 0
local current_tokens = tonumber(bucket[2]) or tonumber(ARGV[2])

local time_passed = math.max(0, tonumber(ARGV[3]) - last_refill_time)
local new_tokens = math.min(tonumber(ARGV[2]), current_tokens + (time_passed * tonumber(ARGV[1])))

if new_tokens >= tonumber(ARGV[4]) then
    redis.call('HMSET', KEYS[1], 'last_refill_time', ARGV[3], 'tokens', new_tokens - ARGV[4])
    return 1 -- Success
else
    return 0 -- Rejected
end
```

---

## ⚠️ Common Mistakes
*   **Ignoring Latency**: Forgetting the round-trip to Redis. For a high-performance system, a local in-memory cache + Redis sync is often required.
*   **Double Counting**: Not using atomic operations in a distributed environment.
*   **Hard Limits**: Not considering "Soft Limits" or "Throttling" (slowing down requests instead of rejecting them).

---

## 🔄 Follow-up Questions
1.  **How would you implement a "Hard Limit" vs. a "Soft Limit"?** (Answer: Hard limit rejects with 429; Soft limit adds delay or reduces priority).
2.  **How to handle Clock Skew in a distributed system?** (Answer: Don't rely on app server time; use Redis `TIME` command).
3.  **How would you design for Multi-tenancy?** (Answer: Prefix keys in Redis with `TenantID` and use separate buckets per tier).
