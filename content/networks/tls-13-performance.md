---
title: "Networks: TLS 1.3 vs. 1.2 Performance"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: How does TLS 1.3 differ from 1.2? Explain why it is significantly faster for mobile connections.

## 🎯 What the interviewer is testing
- Modern security protocol improvements.
- Latency reduction via round-trip optimization (RTT).
- Removal of obsolete crypto.

---

## 🧠 Deep Explanation

### 1. Handshake Round-Trips (RTT):
- **TLS 1.2**: Requires 2 RTTs before encryption keys are established and data can start flowing.
- **TLS 1.3**: Reduces this to **1 RTT**. It makes a "best guess" about what cipher suites the client wants, including the key share in the first Hello.

### 2. Zero-RTT (0-RTT):
- If a client has visited a server before, it can send data **immediately** in its first message using a "Resume" session key. This reduces the wait time to exactly 0 extra round trips.

### 3. Security Cleanup:
- TLS 1.3 removed support for insecure algorithms like MD5, SHA-1, RC4, and DES.
- It enforces **Perfect Forward Secrecy (PFS)** by default.

---

## ✅ Ideal Answer
TLS 1.3 is much faster because it fundamentally changes how handshakes work, eliminating a full round-trip of latency. The ability to use 0-RTT for returning clients is a major boost for mobile users on high-latency networks. Furthermore, by stripping out legacy crypto, it is both faster to process and more secure.

---

## 🏗️ Visual Handshake:
- **1.2**: `ClientHello` → `ServerHello` → `KeyExchange` → `Done`. (2 trips)
- **1.3**: `ClientHello + KeyShare` → `ServerHello + Finished`. (1 trip)

---

## ⚠️ Common Mistakes
- Thinking TLS 1.3 is "only for websites". (It's for all TLS traffic).
- Forgetting that 0-RTT has a **Replay Attack** risk if not handled correctly.
- Confusing TLS with SSL (SSL is the obsolete name).

---

## 🔄 Follow-up Questions
1. **Explain Perfect Forward Secrecy.** (If the server's private key is stolen later, past encrypted sessions still can't be decoded.)
2. **What is a "Middlebox" problem?** (Many corporate firewalls were hard-coded for TLS 1.2 and broke when 1.3 arrived; fixed by making 1.3 look like 1.2 "on the wire.")
3. **What is HTTPS?** (HTTP over TLS.)
