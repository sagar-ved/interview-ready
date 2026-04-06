---
author: "sagar ved"
title: "System Design: Distributed Scheduler (Cron)"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: How do you design a distributed cron/scheduler system? How do you ensure a job is only run once by a single server?

## 🎯 What the interviewer is testing
- Solving the "Double-run" race condition.
- Using DB-based locking or Zookeeper.
- Concepts of high availability in long-running tasks.

---

## 🧠 Deep Explanation

### 1. The Strategy: Leader Election
Only the "Leader" node checks the schedule and dispatches jobs.
- **Tools**: Zookeeper or Etcd can be used to elect a leader.

### 2. The Strategy: Shared State (DB Locking)
All nodes are equal.
1. All nodes query `JobsTable`: `SELECT * FROM jobs WHERE next_run < NOW AND status = 'IDLE'`.
2. To claim a job, a node must perform an **Optimistic Lock**: `UPDATE jobs SET status = 'RUNNING', worker_id = 'X' WHERE id = 1 AND status = 'IDLE'`.
3. Only the node that successfully updates the row runs the job.

### 3. Large Scale:
At massive scale (e.g., millions of user-defined alerts), use a **Time-Wheel** data structure or a dedicated scheduler like **Quartz** or **JobRunr** (which handles the DB locking for you).

---

## ✅ Ideal Answer
A distributed scheduler depends on shared consensus to prevent duplicate job execution. For simple systems, we use a database-centered locking mechanism where nodes compete to "claim" a task. For high-scale or low-latency scheduling, we use a dedicated leader-follower architecture coordinated by Zookeeper to ensure centralized control and reliable failover.

---

## 🏗️ Schema:
```
Table: scheduled_tasks
  id: Primary Key
  task_name: String
  cron_expression: String
  next_run_time: Timestamp
  last_executed_by: WorkerID
  status: [IDLE, RUNNING, FAILED]
```

---

## 🔄 Follow-up Questions
1. **What is a "Missed Fire"?** (When a job was supposed to run at 2:00, but the server was down until 2:05.)
2. **Job Idempotency?** (Vital! If a job runs twice due to a network glitch, it should have no effect the second time.)
3. **Difference between Cron and a Task Queue?** (Cron is time-based; Task Queue is event-based.)
