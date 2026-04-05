---
title: "Networks: DNS Resolution (Recursive vs. Iterative)"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: Explain the difference between Recursive and Iterative DNS queries. What happens at the OS and DNS server level?

## 🎯 What the interviewer is testing
- Understanding of the distributed "Query and Respond" nature of DNS.
- Role of local and global caches.
- Caching policies (TTL).

---

## 🧠 Deep Explanation

### 1. Recursive Query (The client perspective):
- Your computer (resolver) asks the ISP's DNS server: "What is example.com?".
- The ISP server **must** return the answer (it does the work for you).

### 2. Iterative Query (The server-to-server perspective):
- The ISP DNS server asks the **Root Server**: "Where is .com?".
- Root replies: "I don't know, but here is the IP for the .com Top-Level Domain (TLD) server." 
- The ISP then asks the **TLD Server**: "Where is example.com?".
- TLD replies: "I don't know, but here is the **Authoritative Server** for example.com."
- The ISP asks the Authoritative server and gets the final IP.

### 3. Caching:
- Every level (OS, ISP, Authoritative) caches the result for the duration of its **TTL (Time to Live)**.

---

## ✅ Ideal Answer
DNS uses a hierarchical, distributed lookup mechanism. Clients typically make recursive queries to a local resolver, which in turn performs multiple iterative queries up the tree (Root → TLD → Authoritative) to find the final mapping. This decentralizes the load and allows for massive scalability.

---

## ⚠️ Common Mistakes
- Thinking your computer talks directly to the Authoritative server for every site (it almost always talks to a recursive resolver).
- Confusing TLD with Root.
- Ignoring the impacts of caching.

---

## 🔄 Follow-up Questions
1. **What is a "Negative Cache"?** (Caching the fact that a domain DOES NOT exist, to prevent re-querying.)
2. **What is an A vs CNAME record?** (A: Domain to IP; CNAME: Domain to Domain.)
3. **What is DNSSEC?** (Extends DNS to add cryptographic signatures to prevent spoofing.)
4. **How does Anycast affect DNS?** (Allows 1.1.1.1 to resolve to the geographically nearest server.)
