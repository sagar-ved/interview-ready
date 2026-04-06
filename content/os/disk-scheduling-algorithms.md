---
author: "sagar ved"
title: "OS: Disk Scheduling (SCAN vs. C-SCAN)"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: Explain Disk Scheduling algorithms: FCFS, SSTF, SCAN, and C-SCAN. Which one avoids "Starvation"?

## 🎯 What the interviewer is testing
- Minimizing Disk Seek time (the slow part of HDDs).
- Handling fairness in I/O requests.
- Impact of the "Elevator" approach.

---

## 🧠 Deep Explanation

### 1. FCFS (First Come First Served):
- **Problem**: Wildly inefficient. The motor has to move back and forth across the entire disk platter.

### 2. SSTF (Shortest Seek Time First):
- **Concept**: Always pick the request closest to the current head position.
- **Problem**: **Starvation**. If new requests keep arriving near the head, a request far away might wait forever.

### 3. SCAN (The Elevator):
- **Concept**: The head moves from one end of the disk to the other, servicing all requests in its path, then reverses.
- **Benefit**: More fair. Good for throughput.

### 4. C-SCAN (Circular SCAN):
- **Concept**: The head moves from one end to the other, then **snaps back to the start** without servicing requests on the way back.
- **Benefit**: More uniform waiting time. A request at the start won't have to wait for the head to go all the way to the end AND all the way back.

---

## ✅ Ideal Answer
Disk scheduling prioritizes reducing mechanical movement. While simple greedy approaches like SSTF offer high throughput, they suffer from starvation issues. SCAN and C-SCAN algorithms (known as elevator algorithms) provide a fair, predictable service cycle that ensures all sectors are eventually reached without wasting energy on excessive directional reversals.

---

## 🏗️ Performance Hierarchy:
- **Throughput**: SSTF > SCAN > FCFS
- **Fairness**: FCFS > C-SCAN > SCAN > SSTF

---

## 🔄 Follow-up Questions
1. **Are these algorithms relevant for SSDs?** (No. SSDs have no moving parts and $O(1)$ access time regardless of location. SSD schedulers focus on wear-leveling and write-amplification.)
2. **What is LOOK / C-LOOK?** (A variation of SCAN that reverses as soon as there are no more requests in that direction, rather than going to the very edge of the disk.)
3. **What is Disk "Seek Latency"?** (The time it takes for the mechanical arm to move to the correct track.)
4. **What is Rotational Latency?** (The time it takes for the disk to spin until the correct segment is under the head.)
