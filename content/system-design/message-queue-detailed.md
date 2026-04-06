---
author: "sagar ved"
title: "System Design: Distributed Message Queue (Kafka vs SQS)"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: Design a Distributed Message Queue. Compare a "Pull" model (Kafka) and a "Managed/Direct" model (SQS).

## 🎯 What the interviewer is testing
- Persistence vs Transit.
- Scaling to millions of events per second.
- Ordering guarantees and partition logic.

---

## 🧠 Deep Explanation

### 1. The "Push/Managed" Model (AWS SQS):
- **Role**: A "Mailbox." 
- **Behavior**: Server manages visibility. Once a worker picks a message, it is hidden. If the worker fails, it reappears.
- **Scaling**: Easy, just keep adding messages.
- **Cons**: No native "Rewind" capability. Once deleted, it's gone.

### 2. The "Log/Pull" Model (Kafka):
- **Role**: A "Log" of events. 
- **Behavior**: Data is saved to an immutable, append-only disk file. Consumers manage their own **Offset**.
- **Pros**:
  - **Replayability**: You can reset your offset to "1 hour ago" and re-calculate results.
  - **High Throughput**: Sequential disk I/O.
- **Cons**: Managing offsets and partitions is complex.

---

## ✅ Ideal Answer
Kafka is an event-streaming platform where data is treated as an immutable history, allowing multiple independent consumers to process the same data at their own pace. SQS is a point-to-point messaging queue designed for decoupling specific tasks. While SQS is easier to operate, Kafka is the standard for high-throughput architectures where data durability and the ability to re-process historical events are required.

---

## 🏗️ Architecture
```
[Producer] -> [Partition 1] -> [Consumer A (Offset 100)]
           -> [Partition 2] -> [Consumer B (Offset 22)]
```

---

## 🔄 Follow-up Questions
1. **How does Kafka handle "Zero-Copy"?** (Uses the `sendfile()` system call to send bytes from disk directly to the network socket without copying them to user-space RAM.)
2. **What is a "Consumer Group"?** (A set of consumers working together to share the load of a single topic; each partition is read by exactly one member.)
3. **Message Durability?** (Kafka writes to disk; SQS replicates across 3 AZs automatically.)
