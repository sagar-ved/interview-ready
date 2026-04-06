---
author: "sagar ved"
title: "System Design: Design Twitter (The Feed)"
date: 2024-04-04
draft: false
weight: 26
---

# 🧩 Question: Design the Twitter Timeline. How do you handle "Celebrities" with millions of followers?

## 🎯 What the interviewer is testing
- Fan-out write vs Fan-out read.
- Dealing with skewed data (Hot-shards).
- Hybrid push/pull architectures.

---

## 🧠 Deep Explanation

### 1. The Standard Way (Push Model / Fan-out on Write):
When I tweet, my tweet is copied into the pre-computed "Feed Cache" of all my followers.
- **Benefit**: "Is ready" instantly. Reads are lightning fast.
- **Celebrity Problem**: If Lady Gaga (80M followers) tweets, the system must perform 80M writes. The system lags, and the database dies.

### 2. The Celebrity Way (Pull Model / Fan-out on Read):
Celebrity tweets are NOT pushed. 
- When a user loads their feed, the system:
  1. Grabs their pre-computed feed (from common users).
  2. "Pulls" the latest tweets from the celebrities they follow.
  3. Merges them on-the-fly.

### 3. The Hybrid Model:
Twitter uses both.
- **Most users**: Push model.
- **Celebrities (> 100k followers)**: Pull model.

---

## ✅ Ideal Answer
A social feed at scale is a challenge of data distribution. For the average user, we pre-compute timelines during the write phase to ensure low-latency reads. For high-influence accounts (celebrities), we switch to a pull-based model to avoid the devastating "fan-out" overhead of millions of simultaneous writes. This hybrid approach ensures that the system remains responsive for both creators and consumers, regardless of their social graph complexity.

---

## 🏗️ Architecture
```
[Celebrity Tweet] -> [Master Tweet Store]
[Common Tweet]    -> [In-memory Feed Cache of 100 followers]
```

---

## 🔄 Follow-up Questions
1. **How to define "Celebrity"?** (Usually by follower count, but it can also be "active" vs "inactive" followers.)
2. **Data Consistency?** (Timelines are usually "Eventually Consistent"—it's okay if my friend sees a tweet 5 seconds before I do.)
3. **What is the `In-memory` cache choice?** (Redis is the industry standard for feed caching.)
