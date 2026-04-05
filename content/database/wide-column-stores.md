---
title: "Database: NoSQL: Wide-Column Stores (Cassandra Internals)"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: What is a Wide-Column Store (like Cassandra)? Explain the physical storage (LSM Trees) and the concept of "Eventual Consistency".

## 🎯 What the interviewer is testing
- Distributed datastore architectures.
- LSM Tree vs B-Tree tradeoffs.
- Gossip protocols and replication factors.

---

## 🧠 Deep Explanation

### 1. Logical View vs Physical View:
Logically, it looks like a sparse table. Physically, data is stored in columns.
**Partition Key**: Determines which node the set of columns belongs to.

### 2. LSM (Log-Structured Merge-Tree):
Unlike B+ Trees where writes are random updates to disk pages, LSM converts **random writes into sequential writes**.
1. **Memtable**: Write to an in-memory sorted buffer.
2. **Commit Log**: Append-only log for durability.
3. **SSTable**: When Memtable is full, flush to a sorted file on disk.
4. **Compaction**: Periodically merge SSTables, discarding old values/tombstones.

### 3. Eventual Consistency:
Cassandra follows **AP** (Availability and Partition Tolerance).
- **Tunable Consistency**: You can decide how many nodes must ACK a write (ONE, QUORUM, ALL).
- **Anti-Entropy**: Uses **Hinted Handoff** (storing data for a dead node until it wakes up) and **Gossip** to spread data.

---

## ✅ Ideal Answer
Wide-column stores like Cassandra use LSM Trees to provide extreme write performance by turning random updates into sequential log flushes. They achieve horizontal scale through peer-to-peer replication and consistent hashing, trading off strong consistency for high availability across data centers.

---

## 🏗️ LSM Tree Workflow:
`Write -> [In-memory Sorted Map (Memtable)] -> Flush -> [On-disk Sorted String Table (SSTable)]`

---

## ⚠️ Common Mistakes
- Confusing Write-Column with Row-based columnar (like Parquet). Cassandra is a **column-family** store.
- Thinking LSM trees are good for range queries (they are slower than B+ trees for reads because they must check multiple levels).
- Not understanding what a "Tombstone" is in a log-based delete.

---

## 🔄 Follow-up Questions
1. **What is a Bloom Filter in Cassandra?** (Used to quickly check if a key DOES NOT exist in an SSTable, avoiding a disk read.)
2. **What is Quorum?** ($N/2 + 1$).
3. **Secondary Index in Cassandra?** (Very limited; usually better to create another table or use Materialized Views.)
