---
title: "Networks: DNS over HTTPS (DoH)"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: What is DNS over HTTPS (DoH)? How does it improve privacy over traditional DNS, and what are its architectural implications?

## 🎯 What the interviewer is testing
- Modern network security trends.
- Encapsulation and protocol layering.
- Privacy vs Network Control trade-offs.

---

## 🧠 Deep Explanation

### 1. Traditional DNS (UDP 53):
- **Unencrypted**: Anyone on the path (ISP, government, local admin) can see exactly which domains you are visiting.
- **Vulnerable**: Susceptible to "DNS Hijacking" / Spoofing.

### 2. DNS over HTTPS (DoH):
- Encapsulates DNS queries inside **HTTPS (TCP 443)** packets.
- **Encryption**: Uses TLS to hide query content and prevent tampering.
- **Privacy**: The ISP only sees that you are talking to a DoH resolver (like 1.1.1.1), not which site you want.

### 3. DNS over TLS (DoT):
- Similar to DoH, but uses a dedicated port (853) instead of port 443.
- More "network-friendly" as admins can block it explicitly.

### 4. Architectural Impacts:
- **CDN performance**: Can bypass the ISP's GeoDNS, potentially sending you to a sub-optimal edge node (solved by EDNS Client Subnet).
- **Security Bypass**: Enterprise firewalls and parental filters based on DNS names are bypassed by DoH.

---

## ✅ Ideal Answer
DoH solves the privacy leak of the traditional unencrypted DNS protocol by wrapping queries in TLS. It makes it harder for ISPs to track or censor browsing history but can complicate network management and enterprise security filtering.

---

## ⚠️ Common Mistakes
- Confusing DoH with DoT.
- Thinking DoH creates a VPN (it only hides DNS, not the actual IP traffic, although encrypted SNI helps further).
- Thinking it's faster (it's actually slightly slower due to TCP/TLS overhead, but amortized with connection reuse).

---

## 🔄 Follow-up Questions
1. **What is ESNI / ECH?** (Encrypted Client Hello — hides the domain name even during the TLS handshake.)
2. **How does Chrome/Firefox implement DoH?** (They have lists of "Trusted Recursive Resolvers".)
3. **What is the downside for ISPs?** (Lose out on data monetization and law-enforcement metadata.)
