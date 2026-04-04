---
title: "Database Replication and Read Replicas"
date: 2024-04-04
draft: false
weight: 6
---

# 🧩 Question: Your read traffic is 10x your write traffic. Walk me through database replication options, replication lag, and the design trade-offs for reading from read replicas vs the primary.

## 🎯 What the interviewer is testing
- Synchronous vs asynchronous replication
- Replication lag and its real-world consequences
- Read-your-own-writes consistency
- Replica lag monitoring and circuit breakers

---

## 🧠 Deep Explanation

### 1. Replication Types

**Single-Leader (Master-Slave)**:
- All writes go to primary; replicas receive changes via replication log
- Simplest; most common (MySQL binlog replication, PostgreSQL WAL streaming)
- **Reads**: Can be served from replicas — latency reduction

**Multi-Leader**:
- Multiple primaries accept writes; sync between primaries
- Used for multi-region deployments
- **Conflict resolution** required (last-write-wins, custom merge)

**Leaderless (Dynamo-style)**:
- Any node accepts writes; quorum reads/writes for consistency
- Cassandra, DynamoDB

### 2. Synchronous vs Asynchronous Replication

**Synchronous**:
- Write acknowledged only after ALL replicas confirm
- **Pros**: No data loss on primary crash
- **Cons**: Write latency = slowest replica latency; availability blocked if replica down

**Asynchronous (default MySQL)**:
- Write acknowledged after primary ensures durability; replicas updated eventually
- **Pros**: Low write latency; replica failure doesn't block writes
- **Cons**: Replication lag; replica crash before sync = data loss

**Semi-synchronous** (MySQL):
- Wait for at least ONE replica to confirm; others async. Balance.

### 3. Replication Lag Issue: Read-Your-Own-Writes

User submits profile update → writes to primary.
User immediately refreshes → reads from a replica that hasn't gotten the update yet → **sees stale data**.

**Solutions**:
1. Read from primary for the user's own profile (route by session)
2. Track the replication offset written; read from replica only if it's past that offset
3. After a write, read from primary for N seconds (sticky period)
4. Client-side cache of the write (optimistic UI update)

---

## ✅ Ideal Answer

- Use async replication for read replicas — low write latency; acceptable for most reads.
- Route reads to read replicas for static content, product catalog.
- Route reads to primary for: user's own data, financial transactions, inventory queries.
- Monitor replication lag with `SHOW SLAVE STATUS` / `pg_stat_replication`.
- Circuit breaker: if replica lag > threshold, fall back to primary reads.

---

## 💻 Java Code (Read-Replica Routing)

```java
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Smart DB routing: reads go to replicas except for "sticky" use cases
 */
public class DatabaseRouter {

    private final DataSource primaryDataSource;
    private final List<DataSource> replicaDataSources;
    private final long maxAcceptableLagMs = 2000; // 2 seconds max lag

    public DatabaseRouter(DataSource primary, List<DataSource> replicas) {
        this.primaryDataSource = primary;
        this.replicaDataSources = replicas;
    }

    // Route reads: sticky = use primary (e.g., right after user write)
    public DataSource getReadDataSource(boolean stickyRead) {
        if (stickyRead) return primaryDataSource; // Post-write reads

        // Random load-balanced replica that isn't lagging too much
        List<DataSource> healthyReplicas = getHealthyReplicas();
        if (healthyReplicas.isEmpty()) {
            return primaryDataSource; // Fall back to primary
        }

        // Random selection for load distribution
        int idx = ThreadLocalRandom.current().nextInt(healthyReplicas.size());
        return healthyReplicas.get(idx);
    }

    public DataSource getWriteDataSource() {
        return primaryDataSource; // Writes always to primary
    }

    // Health check: filter out lagged replicas
    private List<DataSource> getHealthyReplicas() {
        return replicaDataSources.stream()
            .filter(this::isReplicationHealthy)
            .toList();
    }

    private boolean isReplicationHealthy(DataSource replica) {
        // In production: query `SHOW SLAVE STATUS` or metrics from Prometheus
        // Return false if lag > maxAcceptableLagMs
        return true; // Stub
    }
}

// Example: User service with sticky reads after write
class UserService {
    private final DatabaseRouter router;

    UserService(DatabaseRouter router) { this.router = router; }

    public void updateProfile(int userId, String bio) {
        // Write to primary
        router.getWriteDataSource(); // execute UPDATE users SET bio = ?

        // Mark session for sticky reads for next N seconds
        // (in practice: set a cookie or session attribute)
    }

    public User getProfile(int userId, boolean isOwnProfile) {
        // Own profile: sticky read (may still have our update)
        // Others' profiles: can tolerate slight lag
        DataSource ds = router.getReadDataSource(isOwnProfile);
        // execute: SELECT * FROM users WHERE id = ?
        return null; // Stub
    }
}
```

---

## ⚠️ Common Mistakes
- Always reading from replicas without considering read-your-own-writes consistency
- Not monitoring replication lag — silent data staleness
- Over-routing to primary (defeats the purpose of read replicas)
- Deleting a read replica under load without taking it out of rotation first

---

## 🔄 Follow-up Questions
1. **What is circular replication and why is it dangerous?** (A replica is also configured as a primary for another replica — can cause duplicate binlog events and split-brain. Never use in production.)
2. **How do you perform a zero-downtime failover to a read replica?** (Using orchestration tools like Orchestrator or AWS RDS Multi-AZ — automatic promotion of the most up-to-date replica to primary.)
3. **What is "lag amplification" in chained replication?** (Replica A replicates from primary; Replica B replicates from A → lag(B) = lag(A) + lag(A→B). Prefer direct fan-out from primary.)
