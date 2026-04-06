---
author: "sagar ved"
title: "Database Indexing Deep-Dive"
date: 2024-04-04
draft: false
---

# Database Indexing

## 📌 Question
How do B-Trees and LSM Trees differ? Why are they used for SQL and NoSQL respectively?

## 🎯 What is being tested
- Understanding of disk storage (pages, blocks).
- Knowledge of read vs write trade-offs.
- Conflict between memory and disk access time.

## 🧠 Explanation
- **B-Trees**: Highly optimized for random reads and point lookups (SQL). They maintain sorted data on disk.
- **LSM Trees (Log-Structured Merge-Trees)**: Optimized for high-throughput writes (NoSQL - Cassandra, RocksDB). They use an in-memory table (MemTable) and periodically flush to SSTables on disk.

## ✅ Ideal Answer
Focus on the write amplification (B-Tree) vs read amplification (LSM). B-Trees are best for ACID-compliant relational databases where consistency and point lookups are prioritized. LSM Trees are perfect for write-intensive workloads because they turn random writes into sequential writes.

## 💻 Code Example (SQL Indexing)
```sql
-- Composite Indexing: Order matters!
CREATE INDEX idx_user_last_first ON users(last_name, first_name);

-- Explain plan reveals scan types
EXPLAIN SELECT * FROM users WHERE last_name = 'Doe';
```

## ⚠️ Common Mistakes
- Thinking indexes always make queries faster (write penalty).
- Over-indexing small tables.

## 🔄 Follow-ups
- What is a "Covering Index"?
- How do Bloom Filters help with LSM Tree performance?
