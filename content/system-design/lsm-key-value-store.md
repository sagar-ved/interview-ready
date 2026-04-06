---
author: "sagar ved"
title: "System Design: Design a Key-Value Store (LSM Trees)"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: How do you design a Key-Value store like LevelDB or RocksDB? Explain the Log-Structured Merge-Tree (LSM) architecture.

## 🎯 What the interviewer is testing
- High-performance storage engine design.
- Turning random writes into sequential ones.
- Compaction and Bloom filter roles.

---

## 🧠 Deep Explanation

### 1. Why not B+ Trees?
B+ Trees require updating data in-place on disk. For billions of small writes, this causes "Random I/O," which is the slowest operation on HDDs and taxing for SSD wear.

### 2. LSM Tree Components:
1. **Memtable**: An in-memory sorted data structure (SkipList or Tree). All writes go here first.
2. **SS-Table (Sorted String Table)**: When Memphis is full, its content is flushed to disk as a sorted file.
3. **Write-Ahead Log (WAL)**: To handle crashes, every write is also appended to a raw log before hitting the Memtable.

### 3. Reading and Compaction:
- **Read**: To find a key, check Memtable → then check SS-Table Files (from newest to oldest). 
- **Bloom Filter**: Each SS-Table file has a Bloom filter to instantly tell the system if a key IS NOT in that file, preventing useless disk seeks.
- **Compaction**: Periodically merge old SS-Table files to discard updated/deleted values and reclaim space.

---

## ✅ Ideal Answer
LSM Trees provide dominant write performance by treating disk storage as a sequence of immutable logs. By appending all changes to memory first and only later flushing them to disk in batches, we maximize the sequential write bandwidth of the storage hardware. This architecture is the backbone of almost all modern NoSQL databases.

---

## 🏗️ Architecture
```
Write -> [WAL (Disk)]
      -> [Memtable (RAM)] -> [SSTable L0 (Disk)] -> [SSTable L1 (Disk)]
```

---

## 🔄 Follow-up Questions
1. **What is a "Tombstone"?** (A marker indicating a key was deleted; actual deletion only happens during compaction.)
2. **What is the "Write Amplification" problem?** (The same piece of data might be written multiple times as it's merged between SSTable levels.)
3. **LevelDB vs RocksDB?** (LevelDB is the original by Google; RocksDB is Facebook's fork optimized for multi-core CPUs and fast SSDs.)
