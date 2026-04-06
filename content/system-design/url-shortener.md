---
author: "sagar ved"
title: "System Design: URL Shortener (HLD)"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Design a URL shortener like bit.ly that handles 100 million new URLs per day with sub-millisecond redirect latency. 

## 🎯 What the interviewer is testing
- ID generation strategies (Base62, UUID, hashing)
- Read-heavy vs write-heavy architecture
- Caching strategy for hot links
- Database sharding for scale

---

## 🧠 Deep Explanation

### 1. Scale Estimation

- **Write**: 100M new URLs/day ≈ 1,157 writes/sec
- **Read**: Assume 100:1 read-to-write ratio ≈ 115,700 reads/sec
- **Storage**: 100M * 365 days * 5 years * ~500 bytes ≈ ~90 TB

This is **heavily read-dominated** — caching is critical.

### 2. Short Code Generation

| Method | Pros | Cons |
|---|---|---|
| MD5/SHA256 hash | Deterministic (same URL → same code) | Collisions possible, 16+ hex chars |
| Auto-increment + Base62 | Short, predictable, sequential | Exposes count, guessable |
| Distributed counter (Snowflake) | Unique, roughly sortable, high-throughput | Complex setup |
| Random Base62 | Unpredictable, simple | Must check DB for uniqueness |

**Best for production**: Distributed counter (Snowflake ID or Zookeeper counter) + Base62 encoding.

Base62 alphabet: `[0-9][a-z][A-Z]`. A 7-char code supports 62^7 ≈ 3.5 trillion unique URLs.

### 3. Data Model

```sql
CREATE TABLE urls (
  short_code  VARCHAR(10)   PRIMARY KEY,
  long_url    TEXT          NOT NULL,
  created_at  TIMESTAMP     DEFAULT NOW(),
  expires_at  TIMESTAMP,
  user_id     BIGINT,
  click_count BIGINT        DEFAULT 0
);
```

### 4. Caching Strategy (Read Path)

- **Local cache**: In-memory LRU per app server (hot 1K URLs)
- **Distributed cache**: Redis CLUSTER with `short_code → long_url` mapping
- **Cache TTL**: 24 hours for most URLs; infinite for viral ones
- **Cache eviction**: LRU — evict least recently accessed

### 5. Analytics (Write Path)

- Don't update `click_count` synchronously — too slow at 115K/sec
- Use **Kafka**: each redirect emits a click event → consumed by analytics service → batch updates DB

---

## ✅ Ideal Answer

1. **Shorten**: Generate snowflake ID → encode to Base62 (7 chars) → store in MySQL sharded by `short_code`.
2. **Redirect**: Check Redis → check DB on miss → return 301/302 redirect.
3. **301 vs 302**: 301 is permanent (browser caches → reduces future server load). 302 is temporary (server sees every redirect → better analytics).
4. **Analytics**: Async via Kafka → do NOT write to DB on every redirect.

---

## ⚠️ Common Mistakes
- Using random UUID as the short code (16+ chars, defeats the purpose)
- Synchronous analytics updates — bottleneck at high read volume
- No TTL on expired URLs — DB and cache bloat
- Not considering 301 vs 302 trade-off (most candidates miss this)

---

## 🔄 Follow-up Questions
1. **How would you generate IDs without a centralized counter?** (Snowflake ID: 41-bit timestamp + 10-bit machine ID + 12-bit sequence — monotonically increasing, distributed.)
2. **How do you handle custom aliases (e.g., bit.ly/my-brand)?** (Check alias availability in DB; reserve the namespace; enforce uniqueness constraint.)
3. **How would you prevent malicious URL shortening (phishing)?** (Safe Browsing API integration; ML-based URL classifier; allow-list trusted domains.)
