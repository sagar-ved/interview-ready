---
author: "sagar ved"
title: "System Design: Design a CDN (Content Delivery Network)"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: Design a Global CDN. How do you handle cache invalidation and routing users to the nearest node?

## 🎯 What the interviewer is testing
- Anycast routing.
- Cache pull vs push models.
- Handling stale data across 1000s of edge nodes.

---

## 🧠 Deep Explanation

### 1. User Routing:
How does a user find the nearest CDN node?
- **Anycast IP**: Multiple nodes share the same IP; BGP routes the user to the topologically nearest node automatically.
- **DNS-based Routing**: The DNS server looks at the User's IP and returns a different CDN IP based on geography.

### 2. Content Injection:
- **Pull Model (Common)**: User requests `image.png` from CDN. CDN doesn't have it. CDN "pulls" it from the Origin Server, saves a copy, and serves the user.
- **Push Model**: The Origin Server explicitly pushes new assets to CDN nodes when they change.

### 3. Cache Invalidation:
- **TTL (Time to Live)**: The resource expires after X minutes.
- **Purge/Eviction**: The app tells the CDN "Delete image.png now" (very hard at scale).
- **Versioning**: Recommended. Use `image_v2.png`. New URL means a fresh cache miss and a fresh pull.

---

## ✅ Ideal Answer
A CDN scales by placing "Edges" near users and using Anycast or specialized DNS for geo-routing. We prioritize pull-based models for simplified scaling and use resource versioning to manage data freshness without the complexity of global cache purging. This effectively shifts the traffic burden away from the origin server and into the hyper-scalable edge network.

---

## 🏗️ Architecture
```
[User] -> [Internet (Anycast)] -> [CDN Edge Node]
                                    ↓ (Cache Miss)
                                  [Origin Server (S3/App)]
```

---

## 🔄 Follow-up Questions
1. **Difference between CDN and Edge Computing?** (CDN is for static assets; Edge Computing handles logic like security headers or A/B testing at the edge [e.g. Cloudflare Workers].)
2. **What is a "Shield" (Origin Shield)?** (An extra layer of caching between many Edges and the One Origin to prevent "Thundering Herd".)
3. **What is "Brotli/Gzip" role here?** (Compression managed by the CDN to reduce transfer time.)
