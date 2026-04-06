---
author: "sagar ved"
title: "Networks: CORS (Preflight and Simple)"
date: 2024-04-04
draft: false
weight: 20
---

# 🧩 Question: What is CORS? Explain when a "Preflight" request (OPTIONS) is triggered.

## 🎯 What the interviewer is testing
- Browser security model (Same-Origin Policy).
- Handling cross-domain API calls.
- Security vs Performance of different request types.

---

## 🧠 Deep Explanation

### 1. Same-Origin Policy (SOP):
A browser security rule: Script on `siteA.com` cannot read data from `apiB.com` unless `apiB.com` explicitly allows it.

### 2. CORS (Cross-Origin Resource Sharing):
The mechanism to relax SOP. The server sends headers like `Access-Control-Allow-Origin: siteA.com`.

### 3. Preflight Request (OPTIONS):
For "Non-Simple" requests, the browser sends an extra flight check **before** the actual request.
- **Triggers**:
  - Methods other than GET/POST/HEAD.
  - Custom headers (e.g., `X-Auth-Token`).
  - Content-Types other than `text/plain`, `form-data`, or `x-www-form-urlencoded` (e.g., **`application/json`**).

### 4. Simple Requests:
GET/POST with basic headers. These go straight to the server but the browser hides the response if the CORS headers aren't back.

---

## ✅ Ideal Answer
CORS is a developer-controlled relaxation of the brownser's security model. The "Preflight" check is a safety handshake where the browser asks the server if a specific high-risk request (like a JSON post with an auth header) is allowed. This prevents a malicious site from firing potentially destructive cross-site requests that the browser wouldn't otherwise permit.

---

## 🏗️ Preflight Flow:
1. `OPTIONS /api` -> `Allow: POST, Headers: X-Token`? 
2. `200 OK` (Server says yes).
3. `POST /api` (Actual request).

---

## 🔄 Follow-up Questions
1. **How to avoid Preflight?** (Keep headers simple or keep everything on the same domain/subdomain.)
2. **What is `Access-Control-Allow-Credentials`?** (Must be true for the browser to send cookies in a cross-origin request.)
3. **Difference between `*` and a specific domain in CORS?** (`*` is for public APIs like Google Maps; specific domains are for private app security.)
