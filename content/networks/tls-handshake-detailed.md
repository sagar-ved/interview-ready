---
author: "sagar ved"
title: "Networks: TLS 1.3 Handshake (Perfect Forward Secrecy)"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: How does the TLS 1.3 Handshake improve on TLS 1.2? What is "Perfect Forward Secrecy"?

## 🎯 What the interviewer is testing
- Modern encryption lifecycle.
- Protocol latency (Round trips).
- Protecting old data from future leaks.

---

## 🧠 Deep Explanation

### 1. Performance (Round Trips):
- **TLS 1.2**: Requires **2 RTT** (Round Trip Times) before data can be sent.
- **TLS 1.3**: Requires only **1 RTT**. It assumes a key exchange set and sends it in the first message. It also supports **0-RTT** (re-using old keys for absolute speed).

### 2. Security (Removing legacy):
TLS 1.3 removed old, weak ciphers (RC4, SHA-1). 

### 3. Perfect Forward Secrecy (PFS):
- **Old Way (RSA)**: If you steal the server's private key, you can decrypt ALL past traffic you ever recorded.
- **PFS Way (Diffie-Hellman)**: A unique, temporary "session key" is generated for every single conversation. Even if the server's master key is compromised tomorrow, **past conversations remain unreadable** because their unique ephemeral keys are gone.

---

## ✅ Ideal Answer
TLS 1.3 is a massive upgrade in both speed and security. By reducing the number of round-trips needed to start a conversation and mandating ephemeral key exchanges, it provides "Perfect Forward Secrecy." This ensures that a single security breach in the future cannot be used to retrospectively decrypt years of recorded communication.

---

## 🏗️ Handshake Visual:
`TLS 1.2: HELLO -> ACK -> KEY_EXCHANGE -> DONE -> DATA` (Slow)
`TLS 1.3: HELLO+KEY -> DONE -> DATA` (Fast)

---

## 🔄 Follow-up Questions
1. **What is SNI (Server Name Indication)?** (The header telling the server which website you want; encrypted in TLS 1.3 ESNI extension.)
2. **Is Diffie-Hellman better than RSA?** (For session keys, yes. RSA is still used for identifying the server, but not for the actual transport encryption encryption.)
3. **What is Certificate Pinning?** (Hardcoding a specific certificate footprint in an app to prevent Man-in-the-Middle attacks. Becoming less common now.)
