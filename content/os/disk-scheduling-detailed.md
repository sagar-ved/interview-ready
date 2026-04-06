---
author: "sagar ved"
title: "OS: Disk Scheduling (SCAN vs. C-SCAN)"
date: 2024-04-04
draft: false
weight: 34
---

# 🧩 Question: Compare SCAN (Elevator) and C-SCAN disk scheduling. Why is C-SCAN considered more "Fair"?

## 🎯 What the interviewer is testing
- I/O request management.
- Fairness vs Throughput.
- Limiting the "Arm Movement" of a physical disk.

---

## 🧠 Deep Explanation

### 1. SCAN (Elevator):
The disk arm moves from one end to the other, servicing requests on the way. When it hits the end, it reverses direction.
- **Problem**: Requests just inside the ends wait much longer than requests in the middle. The "ends" are visited half as often as the "center."

### 2. C-SCAN (Circular SCAN):
The arm moves from one end to the other, servicing requests. When it hits the end, it **immediately returns to the start** without servicing anything on the return trip.
- **Why it's Fairer**: It treats the disk tracks as a circle. Every track has an equal waiting time on average.

### 3. Why it Matters:
Reducing seek time is the biggest performance boost for traditional HDDs. While SSDs don't have moving arms, these algorithms are still relevant for "I/O Merge" logic in the OS.

---

## ✅ Ideal Answer
Disk scheduling algorithms aim to minimize the mechanical latency of physical storage. While the SCAN algorithm provides high throughput by sweeping the disk surface, it suffers from a "middle-bias" where central tracks get serviced more frequently. C-SCAN resolves this by providing a uniform wait time for all requests, ensuring that data at the edges of the platter isn't starved of attention while the arm moves back and forth.

---

## 🏗️ Visual Summary:
- **SCAN**: `0 ---> 100 <--- 0`
- **C-SCAN**: `0 ---> 100 (Jump back) 0 ---> 100`

---

## 🔄 Follow-up Questions
1. **What is FCFS scheduling?** (First-Come, First-Served—leads to massive arm movement and "thrashing" of the disk head.)
2. **Do SSDs use this?** (SSDs have no seek time, so they use simpler "Deadline" or "No-op" schedulers to focus on parallelizing requests.)
3. **What is "Shortest Seek Time First"?** (Pick the closest request; very fast but can cause "Starvation" of distant requests.)
