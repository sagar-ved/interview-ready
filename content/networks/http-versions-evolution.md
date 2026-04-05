---
title: "Networks: HTTP 1.1 vs. 2.0 vs. 3.0"
date: 2024-04-04
draft: false
weight: 17
---

# 🧩 Question: What are the primary differences between HTTP 1.1, 2.0, and 3.0?

## 🎯 What the interviewer is testing
- Historical evolution of web performance.
- Solving the "HOL (Head-of-Line) Blocking" problem.
- Impact of the Transport layer (TCP vs UDP).

---

## 🧠 Deep Explanation

### 1. HTTP 1.1 (The persistent one):
- **Feature**: Persistent connections (reusing TCP).
- **Problem**: **HOL Blocking at Application Layer**. One slow image request blocks all subsequent ones on that same connection.
- **Hack**: Browsers open 6-8 parallel connections.

### 2. HTTP 2.0 (The binary one):
- **Feature**: **Multiplexing**. Many streams on ONE TCP connection.
- **Internal**: Binary framing.
- **Problem**: **HOL Blocking at Transport Layer**. Since it uses TCP, if ONE packet is lost, the OS stops ALL streams while waiting for retransmission.

### 3. HTTP 3.0 (The modern one):
- **Feature**: Uses **QUIC over UDP**.
- **Result**: **No HOL Blocking**. If a stream's packet is lost, it only affects that one stream. Others continue.
- **Extra**: Built-in TLS 1.3 and 0-RTT.

---

## ✅ Ideal Answer
Each version of HTTP was designed to solve the bottlenecks of its predecessor. HTTP/2 introduced multiplexing to remove application-level stalls. HTTP/3 moved to UDP-based QUIC to solve the fundamental transport-layer stalls of TCP. This evolution has made the modern web dramatically faster and more resilient, especially on unstable mobile networks.

---

## 🏗️ Protocol Table:
| Version | Transport | Key Feature | Weakness |
|---|---|---|---|
| HTTP 1.1 | TCP | Persistence | App-level HOL |
| HTTP 2.0 | TCP | Multiplexing | TCP-level HOL |
| HTTP 3.0 | QUIC (UDP) | No HOL | Firewall UDP blocks |

---

## 🔄 Follow-up Questions
1. **What is Server Push in HTTP/2?** (Server sends assets before client asks; mostly removed in HTTP/3 due to complexity.)
2. **Is HTTP/3 always faster?** (Not on very stable, high-bandwidth wired connections where TCP's mature congestion control is excellent.)
3. **What is HPACK?** (Header compression in HTTP/2 to save bandwidth on redundant headers.)
