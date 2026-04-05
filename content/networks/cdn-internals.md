---
title: "Networks: CDN and Edge Side Includes (ESI)"
date: 2024-04-04
draft: false
weight: 13
---

# 🧩 Question: What is a CDN? Explain the difference between Push and Pull CDNs and how Edge Side Includes (ESI) help with dynamic content.

## 🎯 What the interviewer is testing
- Content delivery at the "Edge".
- Caching strategies and TTL.
- Mixing static and dynamic content efficiently.

---

## 🧠 Deep Explanation

### 1. How a CDN Works:
It is a distributed network of proxy servers (POPs) that store content closer to users to reduce latency.

### 2. Push vs Pull CDNs:
- **Pull CDN**: You put nothing on the CDN. When a user requests an asset, the CDN "pulls" it from your server (Origin) and caches it. Simple, automatic.
- **Push CDN**: You actively upload your content to the CDN ahead of time. Best for large, non-changing content (games, updates).

### 3. Edge Side Includes (ESI):
Standard CDN caching is all-or-nothing (full-page).
**Problem**: How to cache a page where the body is the same for everyone but the header says "Welcome, [Username]"?
**Solution**: ESI allows you to mark specific parts of an HTML page as "dynamic fragments". The CDN caches the main template and fetches only the tiny dynamic fragment from the origin, merging them at the **Edge**.

---

## ✅ Ideal Answer
CDNs reduce latency by bringing content geographically closer to the end user. While static assets are easy to pull and cache, dynamic content requires clever approaches like Edge Side Includes (ESI), which allow the CDN to stitch together cached and live components, maximizing speed without sacrificing personalization.

---

## 🏗️ Workflow:
`User -> [Edge Server (Cache Hit!)]`
`User -> [Edge Server (Cache Miss!)] -> [Origin Server] -> [Edge (Cache it!)] -> [User]`

---

## 🔄 Follow-up Questions
1. **What is Cache Invalidation?** (Clearing the CDN cache when content changes; a very hard problem in distributed systems.)
2. **What is TTL (Time To Live)?** (The duration an edge server keeps a file before asking the origin again.)
3. **How does Anycast relate to CDNs?** (Used to route users to the nearest physical Edge server.)
