---
title: "Networks: gRPC vs. REST"
date: 2024-04-04
draft: false
weight: 8
---

# 🧩 Question: Compare gRPC and REST. When would you use one over the other in a microservices environment?

## 🎯 What the interviewer is testing
- Understanding of modern serialization and transport protocols.
- Latency vs Readability trade-offs.
- Internal vs External API design.

---

## 🧠 Deep Explanation

### 1. Protocols & Payload:
- **REST**: Typically HTTP/1.1; JSON (text).
- **gRPC**: HTTP/2; Protocol Buffers (binary).

### 2. Core Differences:
- **Efficiency**: Binary serialization in gRPC is faster and uses less bandwidth than JSON.
- **Contract**: gRPC is **Contract-First** (`.proto` file). REST is usually document-first or informal.
- **Streaming**: gRPC supports client-side, server-side, and bidirectional streaming out of the box. REST is mostly unary (request-response).
- **Browser Support**: REST is native. gRPC requires a proxy (gRPC-web) as browsers don't expose fine-grained HTTP/2 control.

### 3. Protobuf Internals:
Unlike JSON which stores keys every time (`{"name": "Alice"}`), Protobuf uses **Tags** (integers) to map values. This is significantly smaller and faster to parse.

---

## ✅ Ideal Answer
For internal microservice communication, gRPC is superior due to its performance, strict type safety, and HTTP/2 efficiency. For external-facing APIs where third-party consumers need easy, human-readable access, REST is the industry standard.

---

## 💻 Visual / Config
**Protobuf Definition (`user.proto`):**
```protobuf
message User {
  int32 id = 1;      // Tag 1
  string name = 2;   // Tag 2
}
```

---

## ⚠️ Common Mistakes
- Thinking gRPC only works over HTTP/2 (it does, but that's a frequent "why").
- Ignoring the difficulty of debugging binary vs text.
- Thinking gRPC is "ready-to-go" in a browser.

---

## 🔄 Follow-up Questions
1. **What is Multiplexing in HTTP/2?** (Sending multiple requests/responses over a single TCP connection.)
2. **What is Header Compression (HPACK)?** (Optimizing recurrent HTTP headers.)
3. **When to use JSON over Protobuf?** (When human readability, simple tool integration, or browser compatibility are prioritized.)
