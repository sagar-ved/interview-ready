---
title: "Database: Transaction Isolation Levels"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: Explain the 4 SQL Transaction Isolation Levels. What is a "Phantom Read"?

## 🎯 What the interviewer is testing
- Understanding of concurrency issues in databases.
- Balancing Performance vs Consistency.
- Awareness of "MVCC" (Multi-Version Concurrency Control).

---

## 🧠 Deep Explanation

### 1. Read Uncommitted:
A transaction can read data changes from other uncommitted transactions.
- **Risk**: **Dirty Reads** (reading data that gets rolled back later).

### 2. Read Committed:
A transaction only reads committed data.
- **Risk**: **Non-repeatable Reads** (If I read Row X twice, it might be different because someone else committed between my reads).

### 3. Repeatable Read (Default MySQL):
Ensures that if you read Row X now, it will look the same for the rest of your transaction.
- **Risk**: **Phantom Reads** (If I query "All users in NYC," a new user might be inserted by another thread and show up in my second query).

### 4. Serializable:
Full isolation. Transactions occur as if they were strictly one after another.
- **Risk**: Massive performance hit (lock contention).

---

## ✅ Ideal Answer
Isolation levels let us choose how much noise from other transactions we are willing to tolerate. While "Read Committed" avoids the most obvious bugs, many production systems require "Repeatable Read" to ensure consistent snapshot views. "Serializable" is the gold standard for accuracy but is rarely used due to the extreme locking overhead it creates.

---

## 🏗️ The 3 Phenomena:
1. **Dirty Read**: Read uncommitted data.
2. **Non-repeatable Read**: Value of a row changes.
3. **Phantom Read**: Number of rows in a range changes.

---

## 🔄 Follow-up Questions
1. **What is MVCC?** (Instead of locking, the DB keeps multiple versions of a row with timestamps. Readers look at the version that was current when they started.)
2. **Which level does Postgres default to?** (Read Committed).
3. **How does Oracle handle isolation?** (Mostly uses MVCC to provide Read Committed and Serializable-like levels without standard locks.)
