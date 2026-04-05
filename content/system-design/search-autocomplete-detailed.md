---
title: "System Design: Design a Search Typeahead (Autocomplete)"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: Design a Search Typeahead system (like Google Search). Revisit: Sharding the Trie and handling high search volume.

## 🎯 What the interviewer is testing
- Practical application of Trie data structures.
- Sharding based on prefixes.
- Caching strategies for trending searches.

---

## 🧠 Deep Explanation

### 1. Data Structure: Trie
Each node stores the top 10 most popular terms starting with that prefix. This avoids traversing the whole subtree at query time.

### 2. Sharding the Trie:
A single Trie for the whole internet won't fit on one machine.
- **Option A - Range Sharding**: Shard by first letter ('A' on Server1, 'B' on Server2).
- **Option B - Hash Sharding**: Shard by hash of the prefix (better for uniform load, harder for neighbors).

### 3. Handling Frequent Terms:
Most people search for "weather" or "google".
- Use **Redis** to cache the top results of popular prefixes.
- Update the Trie asynchronously via a **Data Collection Service** (Ingest searches → Aggregate counts → Update Trie periodically).

### 4. Client Side:
- Limit requests using **Debouncing** or **Throttling**.
- Use Browser cache for local results.

---

## ✅ Ideal Answer
To build a massive typeahead system, we use a distributed Trie where each node pre-calculates its most popular completions. We shard the Trie across multiple machines based on the leading characters and use a layered caching system (browser, CDN, Redis) to handle the most frequent queries without hitting the primary Trie storage.

---

## 🏗️ Architecture
```
[User] -> [API Gateway (Throttle)] -> [Redis Cache]
                                             ↓ (miss)
                                    [Trie Service (Sharded)]
                                             ↓
[Data Pipeline] -> [Kafka] -> [Aggregator] -> [Trie Builder]
```

---

## 🔄 Follow-up Questions
1. **How to handle "Trending" searches?** (Increase weight of recent searches in the aggregation pipeline; use Exponential Decay on old weights.)
2. **What if the term contains a typo?** (Use Edit Distance / Levenshtein or phonetic matches like Soundex.)
3. **Difference between Prefix search vs Fuzzy search?** (Prefix is a Trie specialty; Fuzzy requires more complex structures like Suffix Trees or N-gram indexing.)
