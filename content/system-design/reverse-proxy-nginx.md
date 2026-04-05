---
title: "System Design: Design Reverse Proxy (Nginx Internals)"
date: 2024-04-04
draft: false
weight: 17
---

# 🧩 Question: How does Nginx work? Explain the "Event-driven" architecture vs. Thread-per-request model and the role of a Reverse Proxy.

## 🎯 What the interviewer is testing
- High-concurrency server patterns.
- Understanding of `epoll/kqueue` mechanisms.
- Load-balancing, caching, and SSL termination roles.

---

## 🧠 Deep Explanation

### 1. Thread-per-request (Apache style):
- Every request gets a dedicated worker thread.
- If $N$ users are waiting on slow database calls, $N$ threads are sitting idle.
- Memory overhead is high (thread stack space); context switching slows it down.

### 2. Event-driven Architecture (Nginx style):
- A small number of **Worker Processes** handle thousands of requests.
- Uses non-blocking I/O. A worker process asks the kernel for a list of "active" connections (via **`epoll`** on Linux).
- It only works on connections that have data ready. No threads sit idle.
- Extremely low memory footprint.

### 3. Role of Reverse Proxy:
- **Load Balancing**: Distribute traffic to backend app servers.
- **SSL Termination**: Handle HTTPS/TLS logic to reduce load on backends.
- **Caching**: Store static assets (images/CSS) locally.
- **Security**: Hide backend topology, prevent direct IP access.

---

## ✅ Ideal Answer
Nginx scales by using an asynchronous, event-driven model that leverages the kernel's ability to monitor thousands of file descriptors efficiently. Instead of creating a new thread for each client, it processes events as they happen across a pool of minimal workers. This makes it a perfect gatekeeper for load balancing and caching in front of heavier application servers like those in Java or Python.

---

## 🏗️ Architecture
```
[Users] -> [Nginx (SSL Termination + Cache)] 
                 ↓ (Active connections list via epoll)
          [App Server A] | [App Server B]
```

---

## 🔄 Follow-up Questions
1. **Explain the difference between a Forward Proxy and a Reverse Proxy.** (Forward proxy shields the client; Reverse proxy shields the server.)
2. **What is "Hot Reloading" in Nginx?** (Changing config and starting new workers while old workers finish their requests without dropping traffic.)
3. **Difference between L4 and L7 load balancing?** (L4: TCP/UDP ports; L7: HTTP headers/content.)
