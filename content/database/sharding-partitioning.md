---
title: "Sharding vs Partitioning"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: Your MySQL users table has grown to 2 billion rows and queries are slow. Walk me through the difference between partitioning and sharding, and design a solution.

## 🎯 What the interviewer is testing
- Horizontal vs vertical scaling of databases
- Sharding strategies and their trade-offs (hash, range, directory)
- Cross-shard query complexity
- Rebalancing and hotspot problems

---

## 🧠 Deep Explanation

### 1. Vertical Partitioning vs Horizontal Partitioning

- **Vertical Partitioning (Column Split)**: Splitting a wide table into multiple narrower tables. E.g., separating infrequently accessed `user_metadata` columns from `users`.
- **Horizontal Partitioning (Row Split)**: Splitting rows across multiple tables. This is what most people mean by "partitioning" in SQL.

### 2. MySQL Partitioning

MySQL natively supports partitioning — rows are split across multiple internal "partitions" but remain in the **same server**. The query planner does **partition pruning** — skips irrelevant partitions.

```sql
CREATE TABLE orders (
    id BIGINT NOT NULL,
    user_id INT NOT NULL,
    created_at DATE NOT NULL,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE (YEAR(created_at)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pMax VALUES LESS THAN MAXVALUE
);
```

**Limitations**: Still limited to one server's resources.

### 3. Sharding — Distributing Across Servers

Sharding splits data across **multiple physical database servers** (shards).

| Strategy | How | Pros | Cons |
|---|---|---|---|
| **Hash Sharding** | `shard = hash(userID) % N` | Uniform distribution | Rebalancing = full data migration |
| **Range Sharding** | User IDs 0-1M on Shard1, etc. | Simple, supports range queries | Hotspots if IDs are sequential |
| **Directory Sharding** | A lookup service maps key → shard | Flexible, easy rebalancing | Lookup service = SPOF and bottleneck |
| **Geographic Sharding** | India users → Shard-IN, US → Shard-US | Low latency, compliance | Uneven distribution |
| **Consistent Hashing** | Virtual nodes on a hash ring | Minimal data movement on add/remove | More complex |

### 4. Cross-Shard Complexity

- **Joins**: Impossible across shards natively. Requires application-level join or denormalization.
- **Transactions**: No distributed ACID without 2-Phase Commit (expensive).
- **Global Aggregates**: `COUNT(*) of all users` requires querying all shards and summing.

---

## ✅ Ideal Answer

- **Step 1**: Add indexes and query optimization. Defer sharding.
- **Step 2**: MySQL **range partitioning** by `created_at` or `user_id` range — within-server optimization, easy to query.
- **Step 3**: Add **read replicas** for read-heavy load — offload all SELECT queries.
- **Step 4**: Only when single server is saturated: **Shard by userID hash** across 8+ MySQL instances.
- **Mitigate resharding**: Use **consistent hashing** with virtual nodes.
- **Directory service**: Map `user_id range → shard ID` in a lightweight lookup service (Redis or ZooKeeper).

---

## 💻 Application-Level Sharding

```java
/**
 * Application-level shard router using consistent hashing ring
 */
public class ShardRouter {
    private final int totalShards;
    private final Map<Integer, DataSource> shardDataSources;

    public ShardRouter(int totalShards, Map<Integer, DataSource> dataSources) {
        this.totalShards = totalShards;
        this.shardDataSources = dataSources;
    }

    // Simple hash sharding
    public DataSource getShardForUser(long userId) {
        int shardId = (int) (Math.abs(userId) % totalShards);
        return shardDataSources.get(shardId);
    }

    // Range sharding — use when you want sequential access
    public DataSource getShardByRange(long userId) {
        int shardId;
        if (userId < 100_000_000L) shardId = 0;
        else if (userId < 500_000_000L) shardId = 1;
        else shardId = 2;
        return shardDataSources.get(shardId);
    }

    // Query users that span multiple shards
    public List<User> findUsersAcrossShards(List<Long> userIds) {
        Map<Integer, List<Long>> shardToIds = new HashMap<>();
        for (long id : userIds) {
            int shard = (int) (Math.abs(id) % totalShards);
            shardToIds.computeIfAbsent(shard, k -> new ArrayList<>()).add(id);
        }

        List<User> results = new ArrayList<>();
        for (Map.Entry<Integer, List<Long>> entry : shardToIds.entrySet()) {
            DataSource ds = shardDataSources.get(entry.getKey());
            // query each shard in parallel using CompletableFuture for performance
            results.addAll(queryUsersFromShard(ds, entry.getValue()));
        }
        return results;
    }

    private List<User> queryUsersFromShard(DataSource ds, List<Long> ids) {
        // Execute: SELECT * FROM users WHERE id IN (ids)
        return new ArrayList<>(); // Stub
    }
}

record User(long id, String name) {}
interface DataSource {}
```

---

## ⚠️ Common Mistakes
- Sharding too early (premature optimization — try indexes, read replicas, caching first)
- Using sequential IDs for hash sharding (new users = hotspot on last shard)
- Not designing for resharding — adding a new shard requires data migration

---

## 🔄 Follow-up Questions
1. **What is consistent hashing and why does it minimize data movement on resharding?** (Hash ring with virtual nodes — only the data between the new node and its predecessor needs to move.)
2. **How does Cassandra handle sharding natively?** (Consistent hashing — every node owns a range of the token ring; no explicit sharding needed.)
3. **What is a "hot shard" and how do you prevent it?** (One shard receives disproportionate traffic — solve with compound shard keys or "salting" the hash key.)
