---
title: "Java: Low-latency G1 GC Tuning"
date: 2024-04-04
draft: false
weight: 53
---

# 🧩 Question: How do you tune the G1 Garbage Collector for low-latency? What is the impact of `MaxGCPauseMillis`?

## 🎯 What the interviewer is testing
- JVM performance flags.
- Relationship between Throughput and Latency.
- Understanding of "Stop-the-world" boundaries.

---

## 🧠 Deep Explanation

### 1. The Strategy:
G1 is a "Soft Real-time" collector. You give it a target, and it tries to meet it.

### 2. Tuning Knobs:
- **`-XX:MaxGCPauseMillis=200`**: The most important flag. Tells G1: "Try to keep pauses under 200ms."
  - **Risk**: Setting it too low (e.g. 10ms) will make G1 work too hard, leading to higher CPU usage and potential "Full GCs" because it can't keep up with garbage generation.
- **`-Xms / -Xmx`**: Always set these equal in production to avoid heap resizing pauses.
- **`-XX:ParallelGCThreads`**: Use this to ensure GC doesn't steal cores from your app during heavy load.

### 3. Mixed Collections:
G1 spends most of its time in "Young" GC. Occasionally, it performs "Mixed" GC (Young + some old regions). Tuning the **`G1MixedGCLiveThresholdPercent`** helps decide when to trigger these to avoid a giant Old Gen cleanup later.

---

## ✅ Ideal Answer
Tuning G1 is a balancing act between responsiveness and overall processing power. While the `MaxGCPauseMillis` flag is a powerful directive to the JVM, it must be supported by a correctly sized heap and threads to avoid over-exerting the collector. For low-latency systems, our goal is to maintain a steady stream of small collections and avoid the "Full GC" events that occur when the background marking cycle falls behind the application's allocation rate.

---

## 🏗️ Critical Flags Table:
| Flag | Impact |
|---|---|
| `ParallelGCThreads` | Number of threads for STW pauses. |
| `ConcGCThreads` | Number of background marking threads. |
| `InitiatingHeapOccupancyPercent` | When to start the marking cycle (default 45%). |

---

## 🔄 Follow-up Questions
1. **What is ZGC?** (A newer, truly concurrent collector designed for < 1ms pauses on massive heaps.)
2. **When does G1 fall back to a Full GC?** (If it can't find a free region for a new object, usually due to "Fragmentation" or "Humongous Objects.")
3. **What is a "Humongous Object"?** (In G1, any object > 50% of a region size. They are expensive to move.)
