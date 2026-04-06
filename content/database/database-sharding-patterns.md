---
author: "sagar ved"
title: "Database: Database Sharding Patterns"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: What are the different ways to shard a database? Compare Hash Sharding, Range Sharding, and Directory Sharding.

## 🎯 What the interviewer is testing
- Strategies for horizontal data scaling.
- Handling "Hotspots".
- Understanding the operational complexity of re-sharding.

---

## 🧠 Deep Explanation

### 1. Hash-based Sharding:
- **Logic**: `shard = hash(key) % N`.
- **Pros**: Uniform data distribution (no hotspots).
- **Cons**: Adding/removing a shard is a nightmare (requires massive data moves). **Consistent Hashing** is a better variant here.

### 2. Range-based Sharding:
- **Logic**: Shard 1: A-M, Shard 2: N-Z.
- **Pros**: Range queries are fast (no need to query all shards).
- **Cons**: Leads to hotspots (e.g., if everyone's name starts with 'S').

### 3. Directory-based (Lookup) Sharding:
- **Logic**: A central service/map stores which `account_id` is on which shard.
- **Pros**: Ultimate flexibility. Any key can be anywhere.
- **Cons**: The lookup service is a SPOF and a performance bottleneck.

---

## ✅ Ideal Answer
Hash sharding is the most common for uniform load but makes scaling hard. Range sharding enables efficient searches but causes hotspots. For complex apps, directory-based sharding provides the most control but adds architectural overhead. Most modern "NewSQL" databases (CockroachDB, TiDB) automate this using range-sharding with automatic splitting.

---

## 🏗️ Re-sharding Strategy:
- **Naive**: Stop world, copy, restart (Downtime).
- **Incremental**: Dual write to old and new shards, migrate data in background, switch.

---

## 🔄 Follow-up Questions
1. **What is a "Celebrity Problem"?** (When one key has so much data/traffic it overwhelms a shard — e.g., Twitter's top accounts.)
2. **Horizontal vs Vertical Partitioning?** (Horizontal = splitting rows across shards; Vertical = splitting columns across shards.)
3. **Explain "Resharding" logic.** (Moving data between shards to balance load.)
