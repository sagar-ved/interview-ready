---
author: "sagar ved"
title: "Networks: DNS over TLS (DoT) Internals"
date: 2024-04-04
draft: false
weight: 14
---

# 🧩 Question: How does DNS over TLS (DoT) differ from DNS over HTTPS (DoH)? Compare their use cases in enterprise vs. public environments.

## 🎯 What the interviewer is testing
- Protocol-level security knowledge.
- Port-based vs Content-based filtering.
- Modern network privacy stacks.

---

## 🧠 Deep Explanation

### 1. DoT (UDP/TCP 853):
- **Stack**: `DNS → TLS → TCP → IP`.
- **Visibility**: Admins can see "This is DNS traffic" because it's on a dedicated port.
- **Security**: Full encryption, no snooping.

### 2. DoH (TCP 443):
- **Stack**: `DNS → HTTP → TLS → TCP → IP`.
- **Visibility**: Indistinguishable from regular website traffic.
- **Privacy**: Bypasses local network filters.

### 3. Comparison:
- **Enterprise**: Prefers DoT. It provides privacy for users while allowing the IT team to see that DNS requests are happening (for monitoring/security).
- **Public/Censored**: Prefers DoH. Since it looks like regular web traffic, it's almost impossible to block without blocking the entire web.

---

## ✅ Ideal Answer
DoT is a cleaner, more dedicated protocol for DNS security that is easy to manage on corporate networks. DoH is more "stealthy" and browser-focused, allowing users to bypass local censorship or tracking by blending DNS queries with standard web traffic on port 443.

---

## 🏗️ Protocol Table:
| Feature | DNS over TLS (DoT) | DNS over HTTPS (DoH) |
|---|---|---|
| Port | 853 | 443 |
| Stealth | Visible as DNS | Hidden in HTTPS |
| Overhead | Lower | Higher (HTTP layer) |

---

## 🔄 Follow-up Questions
1. **What is the risk of DoH in a secure environment?** (Can be used as a tunnel to exfiltrate data past firewalls.)
2. **How to block DoH?** (Requires IP-level blacklisting of known DoH resolvers like Cloudflare or SNI filtering.)
3. **Which one does Android support?** (Private DNS in Android uses DoT.)
