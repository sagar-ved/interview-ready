---
title: "Networks: DNS Resolution (Recursive vs. Iterative)"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: Trace a DNS request for `google.com`. What is the difference between a Recursive and an Iterative query?

## 🎯 What the interviewer is testing
- DNS hierarchy (Root, TLD, Authoritative).
- Offloading work to resolvers.
- Impact on network load.

---

## 🧠 Deep Explanation

1. **The Client (Recursive)**: Asks the ISP/Google Resolver (8.8.8.8): "Give me the IP for google.com. You do all the work and just give me the answer."
2. **The Resolver (Iterative)**:
   - Asks **Root Server**: "Where is .com?" -> Root says "Go ask TLD server X."
   - Asks **TLD Server**: "Where is google.com?" -> TLD says "Go ask Authoritative server Y."
   - Asks **Authoritative Server**: "What is the IP?" -> Auth says "**142.250...**"
3. The Resolver returns the result to the Client and **Caches** it.

### Why Iterative for Servers?
Root and TLD servers handle trillions of requests. They cannot afford to perform recursive searches (managing millions of pending requests). They simply point the way.

---

## ✅ Ideal Answer
DNS functions as a distributed, hierarchical pointer system. Clients typically perform recursive queries to offload the search to a specialized resolver, while high-level servers (like Root and TLD) only perform iterative queries to maintain their own scalability. This separation of duty ensures that no single server is responsible for the entire global search path.

---

## 🏗️ Layer Hierarchy:
- **Client (Stub Resolver)**
- **Recursive Resolver (ISP / Cloudflare)**
- **Root Server (`.`)**
- **TLD Server (`.com`, `.net`)**
- **Authoritative Server**

---

## 🔄 Follow-up Questions
1. **What is "Glue Records"?** (When the nameserver for a domain is INSIDE the domain itself, you need the IP in the TLD record to avoid a chicken-and-egg problem.)
2. **DNS over UDP vs TCP?** (Usually UDP 53; switches to TCP if the response is too large [> 512 bytes].)
3. **What is TTL in DNS?** (How long the record should be cached by recursive resolvers.)
