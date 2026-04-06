---
author: "sagar ved"
title: "System Design: Design TinyURL (Distributed)"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 Question: Design a URL shortening service like TinyURL. Focus on high throughput, ID generation, and redirection latency.

## 🎯 What the interviewer is testing
- Unique ID generation at scale.
- Database sharding and caching strategies.
- Handling of "Custom URLs".

---

## 🧠 Deep Explanation

### 1. Requirements:
- Long URL → Short URL (Base62: a-z, A-Z, 0-9).
- Fast redirection ($O(1)$ amortized).
- High availability.

### 2. ID Generation (The Core):
- **Base62 encoding**: Encodes a numeric ID to a short string (e.g., ID 125 → "Cb").
- How to get unique IDs across servers?
  - **Option A - Range Reservation**: Use Zookeeper to assign a range of IDs (1M to 2M) to Server 1. Server 1 increments locally until the range is done.
  - **Option B - Snowflake ID**: Generate 64-bit unique IDs using timestamp + machine ID + sequence.

### 3. Database:
- Use a **NoSQL KV store** (Cassandra or Dynamodb) if you don't need complex relations.
- Partition by the hash of the short-url.

### 4. Redirect:
When a request comes in:
1. Check **Redis Cache** for the short URL.
2. If miss, check DB.
3. If miss, return 404.
4. If hit, send **302 Redirect** (temporary) or **301** (permanent). Usually 302 is preferred so you can track click analytics.

---

## ✅ Ideal Answer
The bottleneck in TinyURL is generating unique numeric IDs without duplicates or collision. We use a range-based ID generator with Zookeeper to ensure each app server has its own pool of IDs. For redirection, we use a distributed cache to minimize database hits and return a 302 redirect for better analytics.

---

## 🏗️ Schema Example:
```
Table: url_mapping
  id: INT (Primary Key)
  short_url: STRING (Index)
  long_url: STRING
  created_at: TIMESTAMP
```

---

## 🔄 Follow-up Questions
1. **Can we use MD5/SHA hashes for the short-url?** (Yes, but you'll have collisions that must be handled by appending something to the source string.)
2. **Difference between 301 and 302?** (301: Browser caches redirect; one request. 302: Browser asks server every time; good for analytics.)
3. **How to handle custom aliases?** (If provided, check if it's already in the DB; if not, store it.)
