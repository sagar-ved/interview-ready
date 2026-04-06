---
author: "sagar ved"
title: "Networks: WebSocket Handshake Internals"
date: 2024-04-04
draft: false
weight: 22
---

# 🧩 Question: How does a WebSocket connection begin? Explain the role of the `Upgrade` header and the `Sec-WebSocket-Key`.

## 🎯 What the interviewer is testing
- Protocol switching mechanics.
- Relationship between HTTP and binary streams.
- Security and "Magic Strings."

---

## 🧠 Deep Explanation

### 1. The Handshake:
WebSockets share port 80/443 with HTTP. They start as a regular HTTP request.
- **Header**: `Upgrade: websocket` 
- **Header**: `Connection: Upgrade`

### 2. The Verification (`Sec-WebSocket-Key`):
The client sends a random Base64 key.
- **Purpose**: NOT for encryption. It's to prove that the server actually understands WebSockets and isn't just a proxy blindly reflecting headers.
- **The Calculation**: The server takes the key, appends a globally unique **"Magic String"** (`258EAFA5-E914-47DA-95CA-C5AB0DC85B11`), hashes it with SHA-1, and sends it back in `Sec-WebSocket-Accept`.

### 3. After the Switch:
The application stops using HTTP verbs and starts sending binary/text **Frames**.

---

## ✅ Ideal Answer
WebSockets are initiated through an HTTP "Upgrade" handshake. This allows a standard web connection to evolve into a full-duplex binary stream. The security keys exchanged during this phase ensure that both the client and server explicitly support the protocol, preventing unintended communication with legacy proxies or misconfigured servers.

---

## 🏗️ Visual Flow:
`Browser: Can we speak WebSocket? (Key: 123) -> Server: Yes! (Accept: SHA1(123+Magic)) -> [Binary Stream Starts]`

---

## 🔄 Follow-up Questions
1. **Does WebSocket use TLS?** (Yes, `wss://` is secure, using standard TLS exactly like HTTPS.)
2. **WebSockets vs gRPC-Web?** (WebSockets are better for arbitrary bi-directional messaging; gRPC-Web is more structured but requires a proxy to translate the browser's restricted HTTP/2 to standard gRPC.)
3. **What is heartbeating/Pings?** (Since the connection is long-lived, intermediate routers might kill "idle" links unless we send periodic small ping frames.)
