---
author: "sagar ved"
title: "System Design: Design a Web Crawler"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: Design a Web Crawler that can scale to crawl the entire World Wide Web (trillions of pages). Handle politeness, duplicate detection, and distributed execution.

## 🎯 What the interviewer is testing
- Handling large-scale distributed systems.
- Deduplication techniques (Bloom filters, Hash-based checks).
- Scheduling and Politeness constraints.
- Storage of huge metadata.

---

## 🧠 Deep Explanation

### 1. High-Level Workflow:
1. **Seed URLs**: Start with a list of reputable URLs.
2. **URL Frontier**: A queue containing URLs to be crawled.
3. **HTML Downloader**: Fetches pages from the web.
4. **DNS Resolver**: Converts URLs to IP addresses.
5. **Content Parser**: Extracts text and links.
6. **Content/URL Dedup**: Ensures we don't crawl the same content or URL twice.
7. **Storage**: HTML storage and metadata database.

### 2. Scalability & Distributed Nature:
- **URL Frontier**: Distributed queue (Kafka/Redis) sharded by hostname to enforce **politeness** (don't hit the same site too fast).
- **Deduplication**: Billions of URLs cannot fit in a typical Set. Use **Bloom Filters** to check if a URL is potentially seen, then verify against a disk-based KV store (HBase/Cassandra).

### 3. Politeness & Robots.txt:
- Cache `robots.txt` files of hosts.
- Use a dedicated worker pool for each domain or a delay mechanism between requests to the same IP.

---

## ✅ Ideal Answer
A scalable crawler must be distributed across thousands of machines. The **URL Frontier** is the brain, deciding which URL to crawl next based on priority (importance of page) and politeness. Deduplication is performed at two levels: **URL Deduplication** (before adding to queue) and **Content Deduplication** using Fingerprinting (to avoid mirrors or duplicate content on different URLs).

---

## 🏗️ Architecture
```
[Seed URLs] -> [URL Frontier / Distributed Queue]
                     ↓
             [DNS Resolver Cache]
                     ↓
             [HTML Downloader (Parallel Workers)]
                     ↓
             [Parsing & Link Extraction]
                     ↓
             [Content Filter (is binary? is error?)]
                     ↓           ↓
          [URL Dedup]     [Content Dedup (MinHash/SimHash)]
                     ↓           ↓
             [Metadata DB]   [Storage (S3/HDFS)]
```

---

## ⚠️ Common Mistakes
- Ignoring the `robots.txt` or site-level politeness (getting IP-blocked).
- Not handling cycle/traps (infinite dynamic URLs like a calendar).
- Attempting to store billions of URLs in memory.

---

## 🔄 Follow-up Questions
1. **How to prioritize pages?** (PageRank or fresh-ness requirement.)
2. **How to detect "Near-Duplicates"?** (Use SimHash or MinHash.)
3. **What happens if the Frontier crashes?** (Persistent queue state is needed; checkpointing.)
