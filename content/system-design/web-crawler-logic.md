---
author: "sagar ved"
title: "System Design: Design a Web Crawler"
date: 2024-04-04
draft: false
weight: 25
---

# 🧩 Question: Design a high-scale Web Crawler (Googlebot). How do you handle politeness, duplicate detection, and the "URL frontier"?

## 🎯 What the interviewer is testing
- Managing massive distributed state (URLs seen).
- Handling the DNS bottleneck.
- Social/Legal ethics of crawling (Robots.txt).

---

## 🧠 Deep Explanation

### 1. The URL Frontier:
A queue of URLs to crawl. 
- **Politeness**: Ensure you don't overwhelm one server (e.g., `amazon.com`) by hitting it 1000 times a second. 
- **Implementation**: Map `Domain -> Dedicated Queue`. Have workers only pull from a queue if enough time has passed since the last hit on that domain.

### 2. Duplicate Detection:
We must avoid crawling the same page twice.
- **URL Seen**: Use a **Bloom Filter** or a massive **HashSet** (sharded across Redis cluster) to store billions of URLs.
- **Content Duplicate**: Sometimes different URLs show the same content. Use **SimHash** to compare page bodies.

### 3. DNS Resolver:
DNS takes time. Standard libraries are blocking.
- **Optimization**: Use a local DNS cache or a high-performance **Asynchronous DNS Resolver**.

---

## ✅ Ideal Answer
Scaling a crawler is a challenge of volume and etiquette. We use a URL frontier that enforces per-domain rate limiting to remain "polite" to host servers. To process billions of pages, we use optimized lookup structures like Bloom Filters for URL tracking and fuzzy hashing for near-duplicate content detection, ensuring our storage and bandwidth are used efficiently.

---

## 🏗️ Architecture
```
[Frontier] -> [DNS Resolver] -> [Downloader] -> [Parser] -> [Link Extractor]
                                                  ↓             ↓
                                              [Store]    [Seen filter]
```

---

## 🔄 Follow-up Questions
1. **What is "Trapping"?** (Infinite loops in a site like a calendar with "next month" links; solved by limiting crawl depth.)
2. **How to prioritize pages?** (Pagerank or "Freshness" — crawl news sites more often than static blogs.)
3. **How many pages on the web?** (Tens of trillions; you can't crawl them all.)
