---
author: "sagar ved"
title: "Networks: Anycast Routing vs Unicast"
date: 2024-04-04
draft: false
weight: 18
---

# 🧩 Question: What is the difference between Unicast, Multicast, Broadcast, and Anycast? 

## 🎯 What the interviewer is testing
- Fundamental packet routing methodologies.
- Use cases for global traffic management (DNS/CDN).
- Impact on latency.

---

## 🧠 Deep Explanation

### 1. Unicast (1 to 1):
One sender, one receiver. The most common internet communication.

### 2. Broadcast (1 to All):
One sender, everyone on the local subnet receives. (e.g., ARP). Stop at routers.

### 3. Multicast (1 to Many):
One sender, specific group of receivers (e.g., IPTV or video conferencing). Requires IGMP protocol.

### 4. Anycast (1 to Nearest):
One IP is shared by many servers across the globe.
- **The Magic**: Internet routers (BGP) will naturally route your packet to the **physically closest** server sharing that IP.
- **Use case**: Cloudflare (1.1.1.1), Google DNS (8.8.8.8), CDNs.

---

## ✅ Ideal Answer
Anycast is the secret behind global performance. While Unicast routes to a specific machine, Anycast allows a single address to be shared by hundreds of locations, routing the user to the topologically nearest node. This significantly reduces latency and provides built-in DDoS resistance through natural traffic distribution.

---

## 🏗️ Use Case Table:
| Type | Ratio | Key Use Case |
|---|---|---|
| Unicast | 1 : 1 | Web browsing, Email |
| Broadcast | 1 : All | Address Resolution (ARP) |
| Multicast | 1 : Group | Live Streaming |
| Anycast | 1 : Nearest | DNS, CDN |

---

## 🔄 Follow-up Questions
1. **Can you use TCP over Anycast?** (Yes, but it's risky. If a BGP route flips mid-session, your packet hits a DIFFERENT server, and the TCP connection breaks. Usually handled by ensuring very stable routes or using UDP/QUIC.)
2. **How does Anycast protect against DDoS?** (The traffic is naturally "sharded" across many global locations instead of hitting one single pipeline.)
3. **Difference between Anycast and Load Balancing?** (Load balancing is inside a data center; Anycast is global network routing.)
