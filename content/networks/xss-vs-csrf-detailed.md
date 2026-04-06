---
author: "sagar ved"
title: "Networks: XSS vs. CSRF"
date: 2024-04-04
draft: false
weight: 23
---

# 🧩 Question: What is the difference between XSS and CSRF? How do `SameSite` cookie settings prevent them?

## 🎯 What the interviewer is testing
- Web application security fundamentals.
- Understanding of Browser-Server trust models.
- Practical mitigation headers.

---

## 🧠 Deep Explanation

### 1. XSS (Cross-Site Scripting):
- **The Attack**: An attacker injects **JavaScript** into your page (via a search box or a malicious profile update).
- **Goal**: Steal the user's data (read cookies, capture keystrokes) while browsing YOUR site.
- **Trust**: User's browser trusts the malicious script because it appears to come from YOUR site.

### 2. CSRF (Cross-Site Request Forgery):
- **The Attack**: An attacker tricks a user into clicking a link on `malicious.com` that sends a POST request to `bank.com/transfer`.
- **Goal**: Perform an **action** on the user's behalf.
- **Trust**: `bank.com` trusts the request because the browser automatically attached the user's session cookies.

### 3. The `SameSite` Defense:
- **SameSite=Strict**: Browser NEVER sends the cookie if the link came from another domain.
- **SameSite=Lax (Default)**: Browser only sends cookie on top-level GET requests (like clicking a link), but NEVER on POST/IFRAME from other sites. This **kills CSRF** immediately.

---

## ✅ Ideal Answer
XSS is an attack against the integrity of your site's code, while CSRF is an attack against the browser's automatic trust of session cookies. To defend against them, we use Content Security Policies (CSP) to block injected scripts and enforce `SameSite=Lax` cookie flags to prevent cross-origin request manipulation. These two defense layers are essential for ensuring that only authorized user actions are executed by the backend.

---

## 🏗️ Protocol Comparison:
| Aspect | XSS | CSRF |
|---|---|---|
| Medium | Injected Script (JS) | Malicious Link / Form |
| Goal | Read Data | Commit Action |
| Fix | CSP / Sanitization | CSRF Tokens / SameSite |

---

## 🔄 Follow-up Questions
1. **Can XSS be stored?** (Yes, "Stored XSS" is when the script is saved in the DB and shown to every user.)
2. **What are CSRF Tokens?** (A random token hidden in a form. The server checks if the incoming POST has a token that matches the session.)
3. **Does SameSite prevent all CSRF?** (Almost all, but old browsers or subdomains can sometimes bypass it if not careful.)
