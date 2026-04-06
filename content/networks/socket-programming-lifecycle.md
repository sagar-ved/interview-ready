---
author: "sagar ved"
title: "Networks: Socket Programming (TCP/UDP)"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 Question: Explain the low-level lifecycle of a TCP Socket. What do `bind()`, `listen()`, `accept()`, and `connect()` do?

## 🎯 What the interviewer is testing
- Low-level network API flow.
- Port management.
- Difference between "The Listening Socket" and "The Connection Socket."

---

## 🧠 Deep Explanation

### 1. Server Lifecycle:
1. **socket()**: Create a file descriptor for networking.
2. **bind(IP, Port)**: Reserve a specific port with the OS.
3. **listen()**: Tell the OS to keep a "backlog" of incoming connection requests.
4. **accept()**: **Blocks** until a client connects. It returns a **NEW file descriptor** dedicated to this specific client. (This is huge: the listening socket remains free to accept more users).

### 2. Client Lifecycle:
1. **socket()**: Create descriptor.
2. **connect(IP, Port)**: Attempt the 3-way handshake with the server.

### 3. Teardown:
- **close()**: Initiates the 4-way FIN/ACK handshake.

---

## ✅ Ideal Answer
Socket programming is the manual implementation of transport-layer protocols. The core concept is the separation of the "listening socket" (which waits for callers) and the "communication socket" (which is spawned for each individual connection). This allows a single server port to handle thousands of concurrent conversations.

---

## 🏗️ Process Table:
| Call | Role | Blocking? |
|---|---|---|
| `bind` | Server | No |
| `listen` | Server | No |
| `accept` | Server | Yes |
| `connect` | Client | Yes |

---

## 🔄 Follow-up Questions
1. **What is a "Port"?** (A 16-bit number that helps the OS route packets to the correct application/process.)
2. **What happens if two processes try to `bind()` to the same port?** (Second one fails with `EADDRINUSE` unless `SO_REUSEADDR` is set [rarely advisable].)
3. **Difference for UDP?** (No `listen` or `accept`; just `sendto` and `recvfrom`.)
