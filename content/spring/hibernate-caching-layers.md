---
author: "sagar ved"
title: "Spring Data JPA: L1 and L2 Caching"
date: 2024-04-04
draft: false
weight: 14
---

# 🧩 Question: How does Hibernate's L1 and L2 caching work? How does Spring Data JPA interact with them?

## 🎯 What the interviewer is testing
- Efficiency of ORM data retrieval.
- Scope of caching (Session vs Process).
- Awareness of stale data risks.

---

## 🧠 Deep Explanation

### 1. First-Level Cache (L1):
- **Scope**: Current Hibernate **Session** (The `@Transactional` boundary).
- **Behavior**: Mandatary. If you fetch User 1 twice in the same transaction, Hibernate only calls the DB once.
- **Clearing**: Happens automatically when the session closes (transaction ends).

### 2. Second-Level Cache (L2):
- **Scope**: **Application/Process Level**. (Shared across all transactions).
- **Behavior**: Optional. Usually implemented via Redis, Ehcache, or Hazelcast.
- **Advantage**: If Transaction A fetches User 1, and Transaction B fetches User 1 later, it's served from L2 cache without hitting the DB.

### 3. Query Cache:
A variation of L2 that stores the RESULTS of specific queries (e.g., `Find all active users`). If those tables are modified, the cache is automatically invalidated.

---

## ✅ Ideal Answer
Hibernate's multi-level cache is a performance double-edged sword. L1 cache ensures intra-transaction consistency but is short-lived. L2 cache provides massive performance boosts by keeping frequently accessed data in RAM across the entire application, significantly reducing the bottleneck of database I/O. For a senior engineer, the challenge is correctly configuring the cache eviction policy—ensuring that the performance gains don't result in users seeing outdated or "stale" data during critical operations.

---

## 🏗️ Visual Summary:
`[Transaction 1] -> [L1 Cache] -> [L2 Cache (Ehcache/Redis)] -> [Database]`

---

## 🔄 Follow-up Questions
1. **What is "Cache Eviction"?** (The process of removing items from the cache when they change in the DB.)
2. **What happens during a `SELECT` vs an `Update`?** (A write usually invalidates both L1 and relevant L2 entries.)
3. **How to enable L2 in Spring?** (Add provider dependency and set `hibernate.cache.use_second_level_cache=true`.)
