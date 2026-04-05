---
title: "Networks: TCP Keep-Alive vs. WebSockets"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: What is the difference between TCP Keep-Alive, HTTP Keep-Alive, and WebSockets?

## 🎯 What the interviewer is testing
- Confusion avoidance between similarly-named features at different layers.
- Persistent connection management.
- Real-time data delivery models.

---

## 🧠 Deep Explanation

### 1. TCP Keep-Alive (Layer 4):
- **Purpose**: To detect if the other side is still there.
- **Mechanism**: After a period of inactivity, the OS sends an empty ACK. If the other side doesn't reply, the connection is closed.
- **Visibility**: Your application code usually never "sees" this.

### 2. HTTP Keep-Alive (Persistent Connections - Layer 7):
- **Purpose**: To reuse one TCP connection for multiple HTTP requests.
- **Mechanism**: The `Connection: keep-alive` header.
- **Context**: Solves the "handshake for every image" problem.

### 3. WebSockets (Layer 7):
- **Purpose**: Full-duplex communication (both sides can send data at any time).
- **Mechanism**: Starts as HTTP, upgrades to the `ws` protocol.
- **Context**: Used for chats, games, and real-time dashboards.

---

## ✅ Ideal Answer
TCP Keep-Alive is a low-level "is the link alive" check. HTTP Keep-Alive allows sequential request reuse of a connection. WebSockets provide a true persistent tunnel for real-time, bi-directional communication. They operate at different levels of the stack and solve different performance/feature needs.

---

## 🏗️ Layer Mismatch:
- **TCP Keep-Alive**: Networking layer level.
- **HTTP/WebSockets**: Application level.

---

## 🔄 Follow-up Questions
1. **How do WebSockets handle heartbeats?** (They have built-in Ping/Pong frames to ensure the connection is alive.)
2. **Does HTTP/2 need HTTP Keep-Alive?** (No, HTTP/2 connections are persistent and multiplexed by default.)
3. **Max number of WebSockets on a server?** (Limited by memory and file descriptors, often 64k per IP, but Millions with tuning.)
