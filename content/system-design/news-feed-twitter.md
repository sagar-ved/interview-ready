---
title: "System Design: Design Twitter/News Feed (HLD)"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Design Twitter's News Feed — when a user logs in, they see a personalized feed of tweets from everyone they follow, ordered by recency. Handle both regular users and celebrities.

## 🎯 What the interviewer is testing
- Fan-out models: push vs pull vs hybrid
- Handling celebrity users (tens of millions of followers)
- Feed ranking and personalization
- Caching feed data at scale

---

## 🧠 Deep Explanation

### 1. The Fan-Out Problem

When Taylor Swift (200M followers) tweets, should we:
- **Push**: Write her tweet to all 200M followers' feeds immediately (fan-out on write)?
- **Pull**: When each follower opens Twitter, fetch tweets from all followed accounts (fan-out on read)?

Neither is perfect alone:
- **Push fan-out**: O(followers) writes per tweet — catastrophic for celebrities
- **Pull fan-out**: O(following) reads per page load — 10ms per followed account × 1000 follows = slow

### 2. Hybrid Approach (Instagram/Twitter style)

- For **regular users** (< 10K followers): **Push fan-out** on write. Pre-populate their followers' feeds immediately.
- For **celebrities** (> 10K/1M followers): **Pull fan-out** on read. Fetch celebrity tweets separately and merge with the push feed at query time.

The split avoids both extremes.

### 3. Feed Database Design

```
fan_out_table:
  user_id (partition key)    -- The receiver's feed
  tweet_id (sort key)        -- Ordered by recency (Snowflake ID)
  tweet_author_id
  created_at
  (Stored in DynamoDB or Cassandra for O(1) per-user lookup)
```

### 4. Ranking and Personalization

Simple reverse-chronological is straightforward. Ranked feed (like Twitter's "For You"):
- ML model scores: engagement probability × recency decay × relationship strength
- Offline job (Spark) scores tweets in batch; online serving uses pre-scored results
- Edge ranking at CDN for low latency

---

## ✅ Ideal Answer

1. **Tweeting**: Write tweet to `tweets` DB + Kafka topic.
2. **Push fan-out (regular)**: Kafka consumer reads new tweet → fetches follower list → writes to each follower's feed in Cassandra/DynamoDB.
3. **Celebrity check**: If author follower count > threshold → skip fan-out. Feed is composed at read time.
4. **Feed retrieval**: Fetch pre-built feed from Cassandra + merge celebrity posts at read time + rank.
5. **Caching**: Top of feed cached in Redis per user.

---

## 🏗️ Architecture Diagram

```
[User Tweets]
     ↓
  Tweets DB + Kafka "new-tweet" topic
     ↓
  Fan-out Service (Consumer)
     ↓  checks follower count
  ┌─────────────────────────────┐
  │ Regular user: push to feed  │ → Cassandra feed table
  │ Celebrity: skip fan-out     │ → Pulled at read time
  └─────────────────────────────┘
  
[User Opens App]
     ↓
  Feed Service
     ↓
  1. Read pre-built feed from Cassandra (paginated by tweet_id)
  2. Fetch recent tweets from followed celebrities (parallel)
  3. Merge + rank
  4. Cache first page in Redis per user
```

---

## ⚠️ Common Mistakes
- Fan-out on write for all users — Twitter itself had to migrate away from this for celebrities
- Not considering the thundering herd when a celebrity's tweet goes viral
- No pagination — loading all tweets in feed at once
- Not indexing by `userId + tweetId` for efficient feed pagination

---

## 🔄 Follow-up Questions
1. **How do you handle a user unfollowing someone?** (Remove their tweets from the fan-out feed retroactively — expensive. Twitter uses "soft delete" and filters at read time for recent unfollows.)
2. **How would you design the "Trending Topics" feature?** (Count hashtag occurrences in a sliding window using Kafka streams + Redis sorted set; refresh every minute.)
3. **How do you handle time zones for "posts from today"?** (Store timestamps in UTC; apply user timezone offset at render time, not storage time.)
