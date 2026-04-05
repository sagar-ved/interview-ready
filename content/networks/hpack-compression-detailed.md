---
title: "Networks: HTTP/2 HPACK (Header Compression)"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: How does HTTP/2 reduce the size of headers? Explain the HPACK algorithm and why it's safer than Gzip.

## 🎯 What the interviewer is testing
- Bandwidth optimization details.
- Security vulnerabilities in compression (CRIME/BREACH).
- State-aware protocol design.

---

## 🧠 Deep Explanation

### 1. The Problem:
An HTTP/2 connection is long-lived and handles many requests. Sending `User-Agent: Mozilla...` and `Cookie: ABC...` in every single request is a massive waste of bandwidth.

### 2. HPACK Logic:
- **Static Table**: A hardcoded list of common headers (e.g., index 2 is `GET`). We only send the ID `2` instead of the string.
- **Dynamic Table**: The request-answer state. If we already sent `Cookie: 123`, the server remembers it. In the next request, we just say "Use the value from the previous index."
- **Huffman Encoding**: Used to compress individual strings that aren't in the tables.

### 3. Why not Gzip? (The Security Part):
Gzip is vulnerable to **CRIME** and **BREACH** attacks. Because Gzip groups similar strings, an attacker can guess a secret cookie by seeing how much the compressed size changes when they inject different strings. HPACK was designed to be "Differential" but safe from these side-channel attacks.

---

## ✅ Ideal Answer
HPACK maximizes web performance by eliminating the redundancy of HTTP headers. By maintaining a shared state between the client and server, we can replace repetitive strings with tiny index identifiers. It was specifically engineered to avoid the security flaws of standard compression algorithms like Gzip, providing a safe, stateful optimization that makes HTTP/2 significantly faster on bandwidth-limited connections.

---

## 🏗️ HPACK Elements:
1. Static Dictionary (61 fixed entries).
2. Dynamic Dictionary (Built during connection).
3. Huffman Encoding (Per-string compression).

---

## 🔄 Follow-up Questions
1. **Can you clear the Dynamic Table?** (It has a size limit; once full, old entries are removed to make room for new ones.)
2. **What is the "Cookie Header" overhead?** (Usually the largest part of any header list; HPACK is extremely effective here.)
3. **Does HTTP/3 use HPACK?** (No, it uses **QPACK**, which is adapted for UDP/QUIC to prevent HOL blocking during header synchronization.)
