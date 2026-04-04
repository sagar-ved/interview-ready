---
title: "System Design: Distributed Cache (Redis Deep Dive)"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Design a distributed caching layer for a high-traffic e-commerce platform. Compare caching strategies, explain Redis data structures, and handle cache stampede.

## 🎯 What the interviewer is testing
- Caching patterns: cache-aside, write-through, write-behind
- Redis data structures and when to use which
- Cache stampede problem and prevention
- Cache invalidation — "one of the two hard problems in CS"

---

## 🧠 Deep Explanation

### 1. Caching Patterns

**Cache-Aside (Lazy Loading)**:
```
Read: App checks cache → miss → read DB → write to cache → return
Write: App writes DB → (optionally) invalidate cache
```
- Resilient: cache failure doesn't break reads
- Stale: short TTL + invalidation on write
- **Best for**: Read-heavy, occasional writes

**Write-Through**:
```
Write: App writes cache → cache writes DB → return
Read: Always cache hit (cache has all data)
```
- No stale reads; extra write latency

**Write-Behind (Write-Back)**:
```
Write: App writes cache → return immediately → async flush to DB
```
- Lowest write latency; risk of data loss on cache crash

### 2. Redis Data Structures

| Structure | Commands | Use Case |
|---|---|---|
| **String** | SET, GET, INCR | Counters, simple cache, rate limiting |
| **Hash** | HSET, HGET | User session, product details |
| **List** | LPUSH, RPOP, LRANGE | Message queue, activity feed |
| **Set** | SADD, SMEMBERS | Unique visitors, tags |
| **Sorted Set** | ZADD, ZRANGE, ZRANK | Leaderboards, rate limiting windows |
| **HyperLogLog** | PFADD, PFCOUNT | Approximate unique count (99.8% accurate, 12KB) |
| **Bitmap** | SETBIT, BITCOUNT | User active days, feature flags |
| **Stream** | XADD, XREAD | Event log, time-series |

### 3. Cache Stampede (Thundering Herd)

When a popular cache key expires, hundreds of concurrent requests all miss the cache simultaneously and all hit the DB → overload.

**Solutions**:
1. **Mutex/Lock**: First miss acquires a lock, fetches from DB, populates cache. Others wait on lock. (Redis `SETNX`)
2. **Probabilistic Early Expiry**: Before TTL expires, randomly pre-fetch. `Math.random() < 0.01` → refresh now.
3. **Background Refresh**: Use stale value while refreshing asynchronously.

### 4. Cache Eviction Policies

- **LRU**: Least Recently Used — good for general-purpose
- **LFU**: Least Frequently Used — good for steady traffic (popular items persist)
- **TTL**: Time-based expiry — mandatory for correctness

---

## ✅ Ideal Answer

- **Strategy**: Cache-Aside + short TTL for product catalog; Write-Through for user cart (correctness critical).
- **Data structures**: Sorted Set for leaderboards; Hash for session; String for counters.
- **Stampede**: Redis `SET key value NX EX 10` (lock) or probabilistic early expiry.
- **Consistency**: Eventual OK for product listings; use write-through for cart/inventory.
- **Cluster**: Redis Cluster (16384 hash slots, sharded automatically).

---

## 💻 Java Code

```java
import java.time.Duration;
import java.util.function.Supplier;

/**
 * Cache-Aside pattern with stampede protection
 * Uses Jedis/Lettuce client (abstracted for readability)
 */
public class CacheService<T> {

    private final RedisClient redis;
    private final Duration defaultTTL = Duration.ofMinutes(5);

    public CacheService(RedisClient redis) { this.redis = redis; }

    // Cache-Aside with mutex-based stampede protection
    public T getWithStampedeProtection(String key, Supplier<T> dbFetcher, Class<T> type) {
        // 1. Try cache
        T cached = redis.get(key, type);
        if (cached != null) return cached;

        // 2. Try to acquire lock (NX = only if not exists, EX = expire in 10s)
        String lockKey = "lock:" + key;
        boolean acquiredLock = redis.setIfAbsent(lockKey, "1", Duration.ofSeconds(10));

        if (acquiredLock) {
            try {
                // Double-check: another thread might have populated cache while we waited
                cached = redis.get(key, type);
                if (cached != null) return cached;

                // 3. Fetch from DB and populate cache
                T freshData = dbFetcher.get();
                redis.set(key, freshData, defaultTTL);
                return freshData;
            } finally {
                redis.delete(lockKey); // Release lock
            }
        } else {
            // Another thread is fetching — wait briefly and retry
            try { Thread.sleep(50); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return getWithStampedeProtection(key, dbFetcher, type); // Retry
        }
    }

    // Cache invalidation on write
    public void updateProduct(String productId, Product product) {
        // Write-through: update DB first, then invalidate cache
        database.save(product);
        redis.delete("product:" + productId); // Invalidate
        // Don't write to cache here — let next read populate it with fresh data
    }
}

// Leaderboard using Sorted Set
class Leaderboard {
    private final RedisClient redis;
    private static final String KEY = "game:leaderboard";

    Leaderboard(RedisClient redis) { this.redis = redis; }

    public void addScore(String playerId, double score) {
        redis.zAdd(KEY, score, playerId); // O(log n)
    }

    public long getRank(String playerId) {
        return redis.zRevRank(KEY, playerId); // 0-indexed rank from top
    }

    public List<String> getTopN(int n) {
        return redis.zRevRange(KEY, 0, n - 1); // O(log n + n)
    }
}

interface RedisClient {
    <T> T get(String key, Class<T> type);
    <T> void set(String key, T value, Duration ttl);
    boolean setIfAbsent(String key, String value, Duration ttl);
    void delete(String key);
    void zAdd(String key, double score, String member);
    Long zRevRank(String key, String member);
    List<String> zRevRange(String key, long start, long end);
}
```

---

## ⚠️ Common Mistakes
- Using `GET + SET` as a non-atomic check-and-set (race condition) — use Lua scripts or `SETNX`
- Setting TTL too long → stale data; too short → frequent cache misses (stampede)
- Caching without TTL — memory fills up; stale forever
- Not considering cold start: cache is empty on deployment → all traffic hits DB simultaneously

---

## 🔄 Follow-up Questions
1. **What is a write-behind (write-back) cache and when is it dangerous?** (Data written to cache only, DB batched async. On Redis crash before flush: data loss. Use for analytics/logging, not financial data.)
2. **How does Redis handle persistence?** (RDB: periodic snapshots; AOF: append-only log of every write command. AOF is safer; RDB is faster to load.)
3. **Difference between Redis CLUSTER and Redis Sentinel?** (Cluster: horizontal sharding across nodes; Sentinel: HA via master-slave failover, no horizontal scaling.)
