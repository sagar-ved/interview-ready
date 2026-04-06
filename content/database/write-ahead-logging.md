---
author: "sagar ved"
title: "Database: Write-Ahead Logging (WAL) Internals"
date: 2024-04-04
draft: false
weight: 21
---

# 🧩 Question: What is Write-Ahead Logging (WAL)? Why must we write to the log before the database?

## 🎯 What the interviewer is testing
- Database durability (D in ACID).
- Recovery from crashes.
- Optimizing random writes into sequential writes.

---

## 🧠 Deep Explanation

### 1. The Bottleneck:
Updating the actual Data Pages (B-Tree) is **Random I/O**. It's slow. If we did it for every transaction, the DB would crawl.

### 2. The WAL Strategy:
Instead of writing to the data file, we first write the change to a sequential, append-only **Log File**.
- **Efficiency**: Sequential writes are fast.
- **Atomicity**: The transaction is considered "Done" as soon as it is safely recorded in the Log.

### 3. Crash Recovery:
If the power fails before the data was actually put in the B-Tree:
- On restart, the DB reads the WAL.
- It "Replays" all the transactions that were in the log but not yet in the main data file.

---

## ✅ Ideal Answer
Write-Ahead Logging ensures that no transaction is considered committed until it has been safely persisted in a persistent, append-only file. This separates the logical commit from the physical data update, allowing the database to survive sudden crashes and significantly increasing throughput by turning expensive random disk updates into efficient sequential log entries.

---

## 🏗️ Order of Ops:
1. Receive Write.
2. **Append to WAL on Disk**.
3. Update Memtable/B-Tree in RAM.
4. Return "Success" to User.
5. (Later) Background flush of Data to Disk.

---

## 🔄 Follow-up Questions
1. **What is "Checkpointing"?** (Telling the DB "Every log entry before this point is now safely in the main file, so you can delete those logs.")
2. **WAL in Postgres vs MariaDB?** (Same concept; Postgres calls it WAL, MariaDB/MySQL calls it Redo Log.)
3. **Does WAL protect against Disk Failure?** (No, only against crash/reboot. For disk failure, you need Replication.)
