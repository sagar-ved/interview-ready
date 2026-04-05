---
title: "Database: MVCC (Multi-Version Concurrency Control)"
date: 2024-04-04
draft: false
weight: 26
---

# 🧩 Question: How does MVCC allow writers and readers to perform concurrently? Why is it better than simple locking?

## 🎯 What the interviewer is testing
- High-concurrency database internals.
- Understanding of "Snapshots."
- Tradeoffs in storage (Vacuuming) vs speed.

---

## 🧠 Deep Explanation

### 1. Simple Locking (Pessimistic):
- If I'm writing to Row 5, anyone who wants to read Row 5 must **WAIT**.
- **Result**: Writers block Readers. Slow throughput.

### 2. MVCC (Optimistic-ish):
- Instead of overwriting Row 5, the DB creates a **New Version** of Row 5 with a timestamp.
- **Readers**: They look at a "Snapshot" of the DB as it was when they started. Even if a writer is currently changing Row 5, the reader sees the **old, valid version**.
- **Result**: Readers NEVER wait for Writers. Writers NEVER wait for Readers. 

### 3. The Cost:
We have multiple copies of rows on disk. We need a background process (**VACUUM** in Postgres) to delete old versions that no one is looking at anymore.

---

## ✅ Ideal Answer
MVCC transforms a database from a locked silo into a multi-temporal history. By preserving old versions of records during an update, we guarantee that readers always see a consistent, point-in-time view of the data without being stalled by active transactions. This architectural shift significantly increases concurrency and is the primary reason databases like PostgreSQL and MySQL (InnoDB) can handle massive overlapping workloads with minimal friction.

---

## 🏢 Terminology:
- **Xmin / Xmax**: Internal columns in Postgres tracking which transaction created/deleted a row version.
- **Snapshot Isolation**: The consistency level provided by MVCC.

---

## 🔄 Follow-up Questions
1. **What is "Write-Write" conflict in MVCC?** (If two people try to update the SAME row version, one must block or fail.)
2. **Impact of long-running transactions?** (They prevent the Vacuum from cleaning up old versions, leading to "Table Bloat.")
3. **Is MVCC the same as Locking?** (No, MVCC uses versions to avoid locks for READS.)
