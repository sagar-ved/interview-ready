---
author: "sagar ved"
title: "Networks: QUIC Protocol"
date: 2024-04-04
draft: false
weight: 10
---

# 🧩 Question: What is the QUIC protocol? How does it improve upon TCP, and why is it used as the foundation for HTTP/3?

## 🎯 What the interviewer is testing
- Understanding of the evolution of transport protocols.
- Solving the "Head-of-Line Blocking" problem.
- Modern web performance optimizations.

---

## 🧠 Deep Explanation

### 1. The TCP Problem:
- **Handshake overhead**: TCP (ping-pong) + TLS (ping-pong) = multiple round trips before data flows.
- **Head-of-Line (HoL) Blocking**: If one packet in a TCP sequence is lost, all subsequent packets must wait, even if they were successfully received. This is because TCP is an ordered byte stream.

### 2. Enter QUIC (built over UDP):
- **0-RTT Handshake**: Combines transport and crypto handshakes into one. Frequently visited sites can start sending data instantly.
- **Stream Independence**: QUIC supports multiple independent streams. If an image packet is lost, it doesn't block the CSS file coming in another stream.
- **Connection Migration**: QUIC uses a **Connection ID** instead of IP/Port. If you switch from Wi-Fi to 4G, your session stays alive.

### 3. HTTP/3:
HTTP/3 is simply HTTP semantics mapped over the QUIC transport protocol.

---

## ✅ Ideal Answer
QUIC is a UDP-based transport protocol that eliminates most of the latency bottlenecks of TCP. It integrates TLS encryption by default, reduces handshake round-trips to zero for frequent connections, and prevents Head-of-Line blocking by treating different data streams independently. This makes the modern web significantly faster on mobile and unstable networks.

---

## 🏗️ Protocol Stack Change:
- **Old**: HTTP/2 -> TLS -> TCP -> IP
- **New**: HTTP/3 -> (QUIC + TLS 1.3) -> UDP -> IP

---

## ⚠️ Common Mistakes
- Thinking QUIC replaces UDP (it sits on top of it).
- Underestimating the difficulty of implementing QUIC (it's very complex compared to simple TCP).
- Forgetting that many firewalls block UDP port 443, requiring fallback to TCP.

---

## 🔄 Follow-up Questions
1. **How does QUIC handle Congestion Control?** (It implements its own mechanisms similar to BBR inside the protocol.)
2. **Why build over UDP?** (Because OS kernels and routers are hard-coded for TCP/UDP; getting a new protocol supported is nearly impossible.)
3. **What is TLS 1.3?** (The latest, most secure version of TLS that QUIC mandates.)
