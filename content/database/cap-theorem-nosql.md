---
author: "sagar ved"
title: "CAP Theorem and NoSQL Database Trade-offs"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: Your startup must choose between Cassandra, MongoDB, and DynamoDB for a global e-commerce product catalog. Walk through the CAP theorem and justify your recommendation with trade-offs.

## 🎯 What the interviewer is testing
- CAP theorem and real-world applicability
- NoSQL database types and their guarantees
- Eventual consistency and its implications in user-facing features
- Tunable consistency (Cassandra) as a practical middle ground

---

## 🧠 Deep Explanation

### 1. CAP Theorem

In a distributed system, you can guarantee at most **two of three**:
- **C - Consistency**: Every read receives the most recent write or an error.
- **A - Availability**: Every request receives a response (not necessarily the most recent write).
- **P - Partition Tolerance**: The system continues operating even if some nodes can't communicate.

**Practical reality**: Partition failures WILL happen in any distributed system (network splits, node crashes). So you always need P. The real choice is **C vs A during a network partition**.

### 2. Where Do Popular Databases Fall?

| Database | Favors | Consistency Model | Use Case |
|---|---|---|---|
| **Cassandra** | AP | Eventual (tunable via Quorum) | Write-heavy, time-series, IoT, catalog |
| **DynamoDB** | AP (by default) | Eventual / Strong (per-request) | Low-latency key-value, auto-scaling |
| **MongoDB** | CP (with replica sets) | Strong (primary reads) | Document store, flexible schema |
| **Zookeeper** | CP | Strong | Distributed coordination, leader election |
| **Redis** (cluster) | AP | Eventual | Cache, ephemeral data |
| **MySQL (InnoDB)** | CA | Strong (ACID) | OLTP, transactions |

### 3. Cassandra's Tunable Consistency

Cassandra's killer feature: you can choose consistency level **per-query**.

```
Consistency Level ONE: Returns after 1 replica responds → Fast, eventual
Consistency Level QUORUM: Returns after majority respond → Balanced
Consistency Level ALL: Returns after all replicas respond → Strong, slow
```

For reads + writes both at `QUORUM`, you get **strong consistency** (if RF >= 3, QUORUM = 2 nodes).

### 4. For E-commerce Product Catalog

- **Read pattern**: Millions of reads/sec; reads can tolerate slightly stale data.
- **Write pattern**: Product updates are infrequent (inventory, price).
- **Global**: Multi-region; low latency everywhere.
- **Schema**: Semi-structured (variable attributes per product category).

**Recommendation**: **Cassandra** for catalog reads + DynamoDB for inventory (requires stronger consistency for stock counts).

---

## ✅ Ideal Answer

- **Cassandra**: For product catalog and product attributes. AP system, tunable consistency. Multi-region replication natively supported. `QUORUM` reads for price display; `ONE` for non-critical data.
- **DynamoDB**: For inventory/stock — enable `Strongly Consistent Reads` to prevent overselling.
- **Redis**: Layer above both for hot product caching.
- **Explain the trade-off**: Cassandra accepts eventual consistency for availability. In practice, replication lag is milliseconds — acceptable for a product description, NOT acceptable for stock quantity.

---

## 💻 Cassandra Data Model

```cql
-- Product Catalog Table
-- Partition Key: category_id (distributes products across nodes)
-- Clustering Key: product_id (sorts products within a partition)
CREATE TABLE product_catalog.products (
    category_id  UUID,
    product_id   UUID,
    name         TEXT,
    description  TEXT,
    price        DECIMAL,
    attributes   MAP<TEXT, TEXT>,  -- Flexible: {"color": "red", "size": "XL"}
    created_at   TIMESTAMP,
    PRIMARY KEY ((category_id), created_at, product_id)
) WITH CLUSTERING ORDER BY (created_at DESC);

-- Query: Get latest 20 products in a category (fast partition read)
SELECT * FROM products 
WHERE category_id = ? 
LIMIT 20;

-- for stock: Use DynamoDB with Strongly Consistent reads
-- DynamoDB SDK (Java)
// GetItemRequest req = GetItemRequest.builder()
//     .tableName("inventory")
//     .key(Map.of("productId", AttributeValue.builder().s(productId).build()))
//     .consistentRead(true)  // Forces strong consistency
//     .build();
```

---

## ⚠️ Common Mistakes
- Treating CAP as a "pick two" menu — in reality, you always need P; the choice is C vs A during partition
- Using Cassandra for features requiring strong consistency without setting `QUORUM`
- Designing Cassandra tables like relational tables (JOINs, ad-hoc queries don't work)
- Choosing MongoDB for high write throughput with multi-document transactions (heavy locking overhead)

---

## 🔄 Follow-up Questions
1. **What is BASE vs ACID?** (BASE: Basically Available, Soft state, Eventual consistency — NoSQL model. The trade-off against ACID's strong guarantees.)
2. **How does DynamoDB achieve single-digit millisecond latency?** (Data partitioned by partition key + in-memory caching via DAX; automatic scaling; SSDs.)
3. **Explain Cassandra's "quorum" with a practical example.** (3 replicas: W QUORUM=2 + R QUORUM=2 → overlap guarantees at least 1 common replica has the latest write.)
