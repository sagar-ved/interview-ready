---
title: "Networks: Multipath TCP (MPTCP)"
date: 2024-04-04
draft: false
weight: 27
---

# 🧩 Question: What is Multipath TCP (MPTCP)? How does it allow a phone to use WiFi and 4G simultaneously?

## 🎯 What the interviewer is testing
- Advanced transport layer protocol evolution.
- Resilience and through-put improvement.
- Practical mobile networking.

---

## 🧠 Deep Explanation

### 1. The Standard TCP Limit:
TCP binds to a "4-tuple" (Source IP, Source Port, Dest IP, Dest Port). 
- If you switch from WiFi to 4G, your **Source IP** changes.
- In standard TCP, the connection **breaks** and must be re-established.

### 2. The MPTCP Solution:
MPTCP allows the same connection to use **multiple paths** (subflows).
- It groups several TCP subflows under one "Master" MPTCP session.
- **Throughput**: It can aggregate bandwidth. (e.g. WiFi 10Mbps + 4G 10Mbps = Total 20Mbps).
- **Resilience**: If WiFi dies, the subflow on 4G continues immediately with no interruption to the user.

### 3. Usage:
Used heavily by Apple (Siri/App Store) to prevent "dead spots" in cell coverage.

---

## ✅ Ideal Answer
Multipath TCP evolves the traditional peer-to-peer connection into a multi-interface session. By allowing a single application stream to be distributed across several network paths—like WiFi and Cellular—it provides both a bandwidth boost and seamless failover. This ensures that modern mobile applications can maintain high-quality streaming and connectivity even as the user physically transitions between different network environments.

---

## 🏗️ Relationship:
`[ App Data ] -> [ MPTCP Layer ] -> [ TCP Subflow 1 ] -> [ NIC 1 (WiFi) ]`
`                                 -> [ TCP Subflow 2 ] -> [ NIC 2 (4G) ]`

---

## 🔄 Follow-up Questions
1. **MPTCP vs QUIC?** (MPTCP happens at the Kernel/TCP level; QUIC does it at the App/UDP level. Both solve the "connection migration" problem in different ways.)
2. **Server Support?** (Both the client and the server must support the MPTCP headers for it to work; otherwise, it falls back to standard TCP.)
3. **Impact on Battery?** (Using two radios at once consumes significantly more power.)
