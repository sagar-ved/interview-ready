---
title: "Load Balancing and API Gateway"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: Design the load balancing layer for a microservices platform. Compare load balancing algorithms, explain sticky sessions, and describe the role of an API gateway.

## 🎯 What the interviewer is testing
- Load balancing algorithms and their trade-offs
- Layer 4 vs Layer 7 load balancing
- API Gateway responsibilities
- Health checks, circuit breakers, and connection draining

---

## 🧠 Deep Explanation

### 1. Load Balancing Algorithms

| Algorithm | How | Pros | Cons |
|---|---|---|---|
| **Round Robin** | Cycle through servers | Simple, even if equal capacity | Ignores server load |
| **Weighted RR** | Proportion to capacity | Handles heterogeneous servers | Static weight; doesn't adapt |
| **Least Connections** | Send to server with fewest active | Adaptive to slow requests | Requires connection tracking |
| **Least Response Time** | Send to fastest + fewest conn | Best user experience | Complex; TTFB latency measurement |
| **Random** | Pick any server randomly | Simple; statistically even | Not predictable |
| **IP Hash** | `hash(client_IP) % N` | "Sticky" routing by IP | Skewed if many requests from few IPs |
| **Consistent Hashing** | Uses ring; keys stick to servers | Minimal redistribution on scale | More complex |

### 2. Layer 4 vs Layer 7 Load Balancing

**Layer 4 (Transport — TCP/UDP)**:
- Routes based on IP + Port; does NOT inspect packet content
- Very fast (can be done in hardware); lower CPU overhead
- Cannot route by URL path, headers, or cookies
- Examples: AWS NLB, HAProxy TCP mode

**Layer 7 (Application — HTTP/HTTPS)**:
- Inspects HTTP headers, URL, cookies, body
- Can route `/api/v1` to one cluster, `/api/v2` to another
- Can terminate TLS (offloads crypto from backends)
- Can do header rewriting, rate limiting, auth validation
- Examples: Nginx, AWS ALB, Envoy, Traefik

### 3. Sticky Sessions (Session Affinity)

Problem: User logs in on Server-A; next request hits Server-B — user is logged out.

Solutions:
1. **Cookie-based sticky session**: LB sets a cookie (`SRV=server-A`); routes that user to Server-A.
2. **IP Hash**: Client IP hashes to same server.
3. **Stateless sessions**: Store sessions in Redis — any server can serve any user. **(Best practice)**

### 4. API Gateway Responsibilities

An API Gateway sits in front of all backend services:
- **Authentication / Authorization**: Validate JWT, API keys
- **Rate Limiting**: Per user, per API key
- **Request Routing**: Route to appropriate microservice
- **SSL Termination**: Offload HTTPS from backends
- **Request Transformation**: Add/remove headers, rewrite URL
- **Observability**: Add correlation IDs, request logging
- **Circuit Breaking**: Stop forwarding to unhealthy services

---

## ✅ Ideal Answer

- Use **Layer 7 load balancer** (Nginx/Envoy) for HTTP microservices — allows path-based routing, header manipulation, TLS termination.
- Algorithm: **Least Response Time** for latency-sensitive APIs; **Round Robin** for uniform stateless services.
- **Sticky sessions**: Avoid if possible — use Redis for shared session state. If needed: cookie-based sticky is more reliable than IP hash.
- **API Gateway**: Kong, AWS API Gateway, or Envoy — centralize cross-cutting concerns outside services.

---

## 🏗️ Architecture Diagram

```
Internet Traffic
       ↓
 [DNS / Anycast CDN Edge]
       ↓
 [Layer 4 NLB - AWS NLB]  ← High throughput, low latency
       ↓
 [Layer 7 API Gateway]    ← Auth, Rate Limit, Routing, TLS
       ↓
 ┌─────────────────────────┐
 │    Microservices         │
 │  [Service A] [Service B] │
 │  [Service C] [Service D] │
 └─────────────────────────┘
       ↓
 [Service Mesh - Istio / Envoy] ← Sidecar proxy, mTLS, circuit breaking
```

---

## ⚠️ Common Mistakes
- Using IP hash for sticky sessions (single client behind NAT = skewed load)
- Not implementing health checks — LB routes to dead instances
- Not draining connections before removing a backend instance (in-flight requests killed)
- Running business logic in the API gateway (it's for cross-cutting concerns only)

---

## 🔄 Follow-up Questions
1. **What is connection draining / deregistration delay?** (On scale-down, LB stops sending new connections but waits for existing ones to complete — typically 30s. Prevents "connection reset" errors.)
2. **What is a service mesh and how does it differ from an API gateway?** (Service mesh (Istio/Linkerd) handles east-west traffic between services via sidecars; API gateway handles north-south traffic from clients.)
3. **How does Nginx implement load balancing?** (Upstream block with server list; algorithm configured with `least_conn`, `ip_hash`, etc.; upstream keepalive for connection pooling.)
