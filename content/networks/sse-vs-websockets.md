---
title: "Networks: WebSockets vs. SSE (Server-Sent Events)"
date: 2024-04-04
draft: false
weight: 24
---

# 🧩 Question: Explain Server-Sent Events (SSE). When would you choose SSE over WebSockets?

## 🎯 What the interviewer is testing
- Uni-directional vs Bi-directional performance.
- Protocol simplicity vs Power.
- Practical use cases (Dashboards/Stock Tickers).

---

## 🧠 Deep Explanation

### 1. SSE (Server-Sent Events):
- **Direction**: One-way (Server → Client).
- **Protocol**: Standard **HTTP**. The server keeps the response open and sends data in `text/event-stream` format.
- **Pros**: 
  - Automatic reconnection logic.
  - No special protocol needed (Firewall friendly).
  - Extremely lightweight.
- **Cons**: Unidirectional only.

### 2. WebSockets:
- **Direction**: Full-Duplex (Both ways).
- **Protocol**: Custom binary protocol (after HTTP upgrade).
- **Pros**: Fast, low-latency, works for 2-way chat/gaming.
- **Cons**: Harder to scale; must manage heartbeats and custom proxies manually.

---

## ✅ Ideal Answer
While WebSockets provide a powerful "any-to-any" communication channel, they introduce significant complexity in state management and load balancing. For apps where data only flows from the server (like stock tickers, news feeds, or status dashboards), SSE is the superior architectural choice. It leverages native HTTP features, including automatic reconnection, while maintaining a significantly lower memory footprint on the server.

---

## 🏗️ Use Case Table:
| Case | Best Choice | Reason |
|---|---|---|
| Chat App | WebSocket | Both sides send messages. |
| Crypto Ticker | SSE | Only price info is pushed. |
| Collaborative Editor | WebSocket | Real-time input synchronization. |
| Progress Bar | SSE | Server sends progress status. |

---

## 🔄 Follow-up Questions
1. **How to handle reconnection in SSE?** (Browsers have a `retry` header built-in; the client automatically connects if the link breaks.)
2. **Browser Limit for SSE?** (Old browsers were limited to 6 connections per domain; HTTP/2 multiplexing removes this limit.)
3. **What is the `Last-Event-ID`?** (In SSE, the client sends this on reconnection so the server can send any missed messages.)
