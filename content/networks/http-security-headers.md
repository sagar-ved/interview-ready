---
title: "Networks: HTTP Security Headers"
date: 2024-04-04
draft: false
weight: 21
---

# 🧩 Question: Explain the purpose of HSTS, CSP, and X-Frame-Options. Why are they critical for production APIs?

## 🎯 What the interviewer is testing
- Awareness of modern web security standards.
- Preventing Clickjacking and Cross-Site Scripting (XSS).
- Defense-in-depth engineering.

---

## 🧠 Deep Explanation

### 1. HSTS (Strict-Transport-Security):
Tells the browser: "Only communicate with this site over HTTPS." 
- **Benefit**: Prevents **SSL Stripping** attacks where an attacker replaces the HTTPS link with HTTP before it reaches the user.

### 2. CSP (Content-Security-Policy):
Tells the browser which scripts/resources are allowed to execute. 
- **Benefit**: Defeats **XSS**. Even if an attacker injects a `<script>` tag, the browser won't run it if it doesn't come from a "trusted domain" defined in the CSP.

### 3. X-Frame-Options:
Tells the browser whether this site is allowed to be embedded in an `<iframe>`.
- **Benefit**: Prevents **Clickjacking** (where an attacker hides your site inside an invisible frame to trick users into clicking buttons).

---

## ✅ Ideal Answer
Security headers provide a standardized way for servers to instruct the browser's security engine. HSTS ensures encryption is always present, CSP mitigates the impact of successful script injections, and X-Frame-Options protects the user interface from UI redress attacks. Implementing these is mandatory for any production-facing enterprise application.

---

## 🏗️ Example Header Set:
```http
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'; script-src scripts.site.com
X-Frame-Options: DENY
```

---

## 🔄 Follow-up Questions
1. **Can CSP be bypassed?** (Yes, if the policy is too loose [e.g. `unsafe-inline`] or if a trusted domain carries a known exploit/library.)
2. **Difference between `DENY` and `SAMEORIGIN` in X-Frame-Options?** (`DENY` = no one can embed; `SAMEORIGIN` = only you can embed yourself.)
3. **What is `Referrer-Policy`?** (Controls how much info is shared with other sites when a user clicks a link.)
