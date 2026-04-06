---
author: "sagar ved"
title: "System Design: Cache Penetration, Breakdown, and Avalanche"
date: 2024-04-04
draft: false
weight: 22
---

# 🧩 Question: What are the risks of using a Cache in production? Explain Cache Penetration, Breakdown, and Avalanche.

## 🎯 What the interviewer is testing
- Real-world production engineering.
- Protecting the Database from "Thundering Herds."
- Robustness of the caching layer.

---

## 🧠 Deep Explanation

### 1. Cache Penetration (The Non-Existent Key):
- **Scenario**: Attacker asks for a UserID that doesn't exist (e.g., `-1`).
- **Effect**: It misses Cache → Hits DB → DB says null. Repeat 1000x... DB dies.
- **Fix**: **Bloom Filters** or **Cache Null Objects** (e.g., store "null" with a 5min TTL).

### 2. Cache Breakdown (The Hot Key):
- **Scenario**: A single "Hot" key (like a celebrity profile) expires.
- **Effect**: Suddenly, thousands of concurrent requests miss the cache and hit the DB simultaneously.
- **Fix**: **Mutex/Locks**. Only the first thread is allowed to hit the DB; others wait for it to fill the cache.

### 3. Cache Avalanche (The Mass Expiry):
- **Scenario**: You restart your cache or 50% of your keys expire at the exact same moment.
- **Effect**: Total system collapse as the DB is overwhelmed.
- **Fix**: **Randomized TTLs**. Instead of 60m, use `60m + random(1m to 10m)`. Distribute the load.

---

## ✅ Ideal Answer
Caching isn't just about speed; it's about system protection. To build a resilient cluster, we must defend against malicious misses with Bloom filters, synchronize hot-key refills via localized locks, and prevent mass-expiry floods by introducing entropy into our TTL values. These defensive patterns ensure that the database remains stable even when the caching layer undergoes churn or targeted load.

---

## 🔄 Follow-up Questions
1. **What is "Cache Warm-up"?** (Pre-loading the cache with popular values before launching or after a restart.)
2. **What is a "Negative Cache"?** (Same as caching null objects; specifically caching the ABSENCE of data.)
3. **Difference between LRU and LFU in this context?** (LRU is standard; LFU protects against "scans" that touch every key once.)
