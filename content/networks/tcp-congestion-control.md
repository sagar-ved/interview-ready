---
author: "sagar ved"
title: "Networks: TCP Congestion Control (Slow Start)"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 Question: Explain how TCP handles Network Congestion. What are the roles of "Slow Start" and "Fast Retransmit"?

## 🎯 What the interviewer is testing
- In-depth understanding of flow control vs congestion control.
- How the internet prevents self-collapse under heavy load.
- Modern improvements like BBR vs Cubic.

---

## 🧠 Deep Explanation

### 1. Congestion Window (cwnd):
A limit on how many bytes can be in-flight before receiving an ACK.

### 2. Slow Start:
- **Concept**: Start small (e.g. 10 packets) and **double** the window size every RTT.
- **Purpose**: Rapidly find the available bandwidth without overwhelming the network immediately.

### 3. Congestion Avoidance:
- Once a threshold is reached, switch from exponential growth to **linear growth** (+1 packet per RTT).

### 4. Fast Retransmit:
If the sender receives **3 duplicate ACKs** for the same packet, it assumes that packet was lost. It immediately re-sends the missing packet without waiting for a full retransmission timer to expire.

---

## ✅ Ideal Answer
TCP congestion control is a "self-governing" mechanism where the sender probe for bandwidth. We start exponentially (Slow Start) to quickly saturate the link and then pull back or slow down (AIMD - Additive Increase Multiplicative Decrease) when loss is detected. This prevents the "congestion collapse" of shared network segments.

---

## 🏗️ Algorithm States:
1. **Slow Start**: `cwnd` doubles every RTT.
2. **Congestion Avoidance**: `cwnd` increases by 1 each RTT.
3. **Fast Recovery**: After loss, don't drop to zero; drop `cwnd` by half and continue.

---

## 🔄 Follow-up Questions
1. **Flow Control vs Congestion Control?** (Flow: Don't overwhelm the receiver; Congestion: Don't overwhelm the network router.)
2. **What is BBR (Bottleneck Bandwidth and Round-trip)?** (Google's modern algorithm that looks at actual link speed rather than packet loss as a signal.)
3. **What is a "Silly Window Syndrome"?** (When the window becomes tiny, leading to inefficiently small packets.)
