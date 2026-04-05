---
title: "Networks: BGP Hijacking and Anycast Routing"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: What is BGP Hijacking? Explain how Anycast routing works using BGP and its role in CDNs.

## 🎯 What the interviewer is testing
- Global internet routing fundamentals.
- Understanding of "Path-based" trust in BGP.
- Advanced routing techniques used in Cloud infrastructure.

---

## 🧠 Deep Explanation

### 1. BGP (Border Gateway Protocol):
BGP is the protocol that manages how packets are routed across the internet between different Autonomous Systems (AS) (like ISPs, Google, Amazon). It is based on **Implicit Trust**.

### 2. BGP Hijacking:
Occurs when an AS maliciously (or accidentally) "advertises" an IP prefix it DOES NOT own, claiming to be the shortest path to that destination.
- Other routers update their tables.
- Traffic intended for a legit site (e.g., YouTube) is routed to the attacker.
- Outcome: DDoS, wiretapping, or "blackholing" traffic.

### 3. Anycast Routing:
BGP allows multiple physical servers in different locations to **advertise the same IP address**.
- The internet routers will naturally route your packet to the "shortest BGP path" (effectively the closest location).
- **Use Case**: DNS (1.1.1.1 is actually hundreds of locations) and CDNs (Cloudflare).
- **Benefit**: Reduced latency and high availability.

---

## ✅ Ideal Answer
BGP Hijacking is a security flaw where an attacker announces a fake route to redirect global traffic. Anycast is a routing methodology that uses BGP to allow many servers to share one IP. This provides distributed load balancing at the network layer and is a foundational technology for DNS and CDNs.

---

## ⚠️ Common Mistakes
- Thinking BGP is a protocol for internal LAN routers (it's for inter-ISP routing).
- Confusing Anycast with Multicast (Multicast is one-to-many; Anycast is one-to-one-of-many).
- Forgetting that BGP is mostly unauthenticated (though RPKI is fixing this).

---

## 🔄 Follow-up Questions
1. **What is RPKI?** (Resource Public Key Infrastructure: Helps verify that an AS has the right to announce an IP prefix.)
2. **What is an Autonomous System (AS)?** (A collection of IP networks managed by a single entity.)
3. **How does Anycast handle TCP session continuity?** (Tricky; if BGP paths flip, a TCP connection might break because it hits a different server. Usually solved by ensuring stable routes or using QUIC.)
