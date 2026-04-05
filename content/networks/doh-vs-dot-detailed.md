---
title: "Networks: DNS over HTTPS vs. DNS over TLS"
date: 2024-04-04
draft: false
weight: 21
---

# 🧩 Question: Compare DoH (DNS over HTTPS) and DoT (DNS over TLS). Why are browsers moving toward DoH?

## 🎯 What the interviewer is testing
- Modern privacy protocol evolution.
- Handling of network censorship.
- Integration at the app-layer vs os-layer.

---

## 🧠 Deep Explanation

### 1. The Common Goal:
Standard DNS (UDP Port 53) is in **Plaintext**. ISPs and hackers can see exactly which sites you are visiting. Both DoH and DoT solve this by encrypting queries.

### 2. DoT (DNS over TLS - Port 853):
- **Role**: System-wide encryption. 
- **Visibility**: Clearly visible to network admins as "DNS traffic" because of the dedicated port.
- **Support**: Native to Windows 11 and Android "Private DNS" setting.

### 3. DoH (DNS over HTTPS - Port 443):
- **Role**: Browser-focused encryption.
- **Stealth**: **Indistinguishable** from regular website traffic. 
- **Advantage**: It cannot be blocked by simple firewall rules without blocking the entire internet. This is why it's excellent for bypassing local censorship.

---

## ✅ Ideal Answer
While DoT provides robust system-wide privacy, DoH has gained mass adoption because it is "stealthy" and operates at the application layer. Moving DNS to port 443 ensures that queries are protected from both eavesdropping and interference by intermediate network operators, providing a seamless privacy upgrade that doesn't require complex OS-level configuration.

---

## 🏗️ Quick Comparison:
| Aspect | DoT | DoH |
|---|---|---|
| Port | 853 | 443 |
| Stealth | Transparent | High (Blends with HTTPS) |
| Performance | Slightly Faster | Slightly Slower (HTTP overhead) |
| Control | OS Level | Application/Browser Level |

---

## 🔄 Follow-up Questions
1. **Is DoH "Zero-Trust"?** (It helps, but you still have to trust the **Resolver** [e.g. Cloudflare] to not log your requests.)
2. **What is ESNI (Encrypted Server Name Indication)?** (The next step: encrypting the 'target domain' in the actual TLS handshake of the website.)
3. **Can enterprise admins block DoH?** (Yes, but they have to use sophisticated IP blacklists or intercept the initial connection attempt.)
