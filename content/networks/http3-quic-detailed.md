---
title: "Networks: HTTP/3 (QUIC) and HOL Blocking"
date: 2024-04-04
draft: false
weight: 26
---

# 🧩 Question: How does HTTP/3 (QUIC) solve the Head-of-Line (HOL) blocking problem found in HTTP/2?

## 🎯 What the interviewer is testing
- TCP vs UDP performance.
- Protocol evolution history.
- Handling packet loss in multiplexed streams.

---

## 🧠 Deep Explanation

### 1. HTTP/2 HOL Blocking:
HTTP/2 multiplexes many streams over **one TCP connection**. 
- **The Problem**: If ONE packet from Stream A is lost, TCP waits for the retransmission. 
- **Effect**: Stream B and C (which are perfectly fine) are **blocked** behind the missing packet. This is TCP-level HOL blocking.

### 2. HTTP/3 (QUIC) Solution:
QUIC runs on **UDP**, not TCP.
- **Individual Streams**: Each stream in QUIC handles its own reliability. 
- **Effect**: If a packet for Stream A is lost, Stream B and C can still proceed and be processed. No global bottleneck.

### 3. Connection Migration:
If you switch from WiFi to 4G, your IP changes.
- **TCP**: Connection breaks (based on 4-tuple IP/Port).
- **QUIC**: Uses a "Connection ID." The connection continues seamlessly without a new handshake.

---

## ✅ Ideal Answer
HTTP/3 represents a paradigm shift by moving the responsibility for reliability from the transport layer (TCP) to the application layer (QUIC). While HTTP/2's single-stream multiplexing was a step forward, it suffered from severe latency whenever a packet was lost. QUIC's independent stream processing ensures that a single failure doesn't compromise the entire pipe, while its support for connection migration makes it vastly superior for modern mobile environments.

---

## 🏗️ Visual State:
- **HTTP/2**: `[Packets A1, A2(Lost), B1, B2]` -> Total Block until A2 arrives.
- **HTTP/3**: `[Packets A1, A2(Lost), B1, B2]` -> B1/B2 are processed immediately.

---

## 🔄 Follow-up Questions
1. **Wait, UDP is unreliable?** (Raw UDP is, but QUIC builds its own ACK/Retransmission logic ON TOP of UDP.)
2. **0-RTT Handshake?** (QUIC combines the connection and encryption handshake into one, allowing data to be sent on the first byte.)
3. **Is it widely used?** (Yes, YouTube, Facebook, and Google search already serve most traffic over HTTP/3.)
