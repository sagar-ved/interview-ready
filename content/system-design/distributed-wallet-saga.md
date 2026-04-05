---
title: "System Design: Distributed Wallet (2PC vs. Saga)"
date: 2024-04-04
draft: false
weight: 28
---

# 🧩 Question: Design a Distributed Payment Wallet. How do you handle a transfer from User A (Bank 1) to User B (Bank 2) with absolute consistency?

## 🎯 What the interviewer is testing
- Distributed Transactions.
- Two-Phase Commit (2PC) vs. Saga Pattern (Choreography/Orchestration).
- Idempotency in financial systems.

---

## 🧠 Deep Explanation

### 1. Two-Phase Commit (2PC):
- **Mechanism**: A "Coordinator" asks both banks: "Can you do this?" (Prepare). If both say yes, it says "Do it" (Commit).
- **Pros**: Strong consistency (ACID).
- **Cons**: Blocking and slow. If the coordinator dies during the commit, nodes stay locked. Not suitable for microservices.

### 2. The Saga Pattern (Standard for High Scale):
A sequence of local transactions.
1. Service 1: Deduct from A.
2. Service 2: Add to B.
- **Problem**: What if Step 2 fails (User B's bank is down)?
- **Solution: Compensating Transactions**. The system must trigger a "Refund" to User A.

### 3. Idempotency:
Every transfer request must have a `RequestID`. If the user hits "Send" twice, the system uses the ID to see "I already processed this" and doesn't double-charge.

---

## ✅ Ideal Answer
Managing money in a distributed system requires moving from atomic locks to eventual consistency with verified compensations. While 2PC ensures a "single-unit" transaction, its performance cost is unacceptable for internet-scale wallets. Instead, we use the Saga pattern, breaking the transfer into independent, verifiable steps with associated rollback logic (refunds) to ensure that the system eventually reaches a correct financial state even in the face of partial failures.

---

## 🏗️ Architecture
`[Wallet API] -> [Kafka (Event: Transfer_Started)]`
`[Transfer Svc] -> [Deduct A] -> [Add B] -> [DLQ on Failure]`

---

## 🔄 Follow-up Questions
1. **At-Least-Once Delivery?** (If a message is lost, we might under-charge or skip a payment. We need exactly-once logic using idempotent keys.)
2. **Performance of Sagas?** (Much higher throughput than 2PC because nodes aren't locked during network round-trips.)
3. **Monitoring?** (Need a "Transaction Dashboard" to see pending Sagas that haven't finished.)
