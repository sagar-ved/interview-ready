---
author: "sagar ved"
title: "System Design: Design a Ride-Sharing System (Uber/Ola)"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: Design a ride-sharing platform like Uber. Focus on: driver matching, real-time GPS tracking, surge pricing, and the dispatch algorithm.

## 🎯 What the interviewer is testing
- Geospatial data handling (quadtree, S2, geohash)
- Real-time data pipeline design
- Consistent hashing for driver-region assignment
- Surge pricing algorithm design

---

## 🧠 Deep Explanation

### 1. Core Requirements
- Rider requests ride → Match nearest available driver
- Driver updates GPS every 5 seconds
- ETA calculation using map APIs
- Surge pricing in high-demand areas

### 2. Geospatial Indexing

**Geohash**: Encodes lat/lng to a string. Similar geohashes = nearby locations.
- Precision 6 (~1km²): All drivers within `geohash.prefix(6)` of rider
- Limitation: Edge effects (two locations can be adjacent but have different hashes)

**S2 Cells** (Uber uses this): Hierarchical subdivision of Earth's surface.
- Level 12 cells ≈ 1km²
- Clean hierarchy; no edge cases; used by Uber's H3 library

**QuadTree**: Recursively subdivide 2D space. Each node covers a region.
- Efficient for variable-density data (sparse rural vs dense urban)

### 3. Driver Location Service

Drivers emit GPS updates every 5 seconds → Kafka topic `driver-location` → Location Service → Redis GEO or in-memory quadtree.

```
Redis GEO commands:
GEOADD drivers:available <long> <lat> driver123
GEORADIUS drivers:available <long> <lat> 5 km ASC COUNT 10
```

### 4. Dispatch Algorithm

1. Rider requests ride at location (lat, lng).
2. Find all online drivers within radius (default: 5km).
3. Score each driver: `score = distance_weight * dist + acceptance_rate_weight * (1-rate)`.
4. Send ping to top-3 drivers sequentially (highest score first). If driver doesn't accept in 10s → try next.

### 5. Surge Pricing

`surgeMultiplier = f(demand/supply ratio in geohash region)`
- Count ride requests and available drivers in each S2 cell per minute
- If requests/drivers > threshold (e.g., 2x): trigger surge
- Multiplier: calculated by ML model or lookup table
- Displayed to riders pre-confirmation

---

## ✅ Ideal Answer

1. **GPS ingestion**: Drivers → Kafka → Location Service → Redis GEO index.
2. **Matching**: Redis `GEORADIUS` → score → dispatch to top N drivers.
3. **Tracking**: WebSocket / SSE stream to rider showing driver real-time position.
4. **Surge Pricing**: Count supply/demand per S2 cell; apply multiplier when ratio exceeds threshold.
5. **Payment**: After trip, async payment processing — Stripe charge + receipt email.

---

## 🏗️ Architecture

```
Driver App → [GPS Kafka] → Location Service (Redis GEO)
                                   ↓
Rider App → [Trip Request API] → Dispatch Service
                                   ↓ GEORADIUS query
                              [Driver Candidates]
                                   ↓ score + rank
                              [Notification to Top Driver]
                                   ↓ accepted
                              [Trip Started] → Live tracking via WebSocket
                                   ↓ trip ended
                              [Payment Service] → Stripe API
```

---

## ⚠️ Common Mistakes
- Storing driver locations in SQL — too slow for real-time updates at millions of drivers
- Not considering driver "last seen" cutoff — show only drivers active in last 30 seconds
- Using a single global dispatch server (SPOF) — shard by geographic region
- Not handling network partition for driver match — retry with backoff, idempotency key

---

## 🔄 Follow-up Questions
1. **How does Uber use quadtrees vs S2 cells?** (Uber open-sourced H3 — hexagonal hierarchical geospatial indexing based on H3 cells; better than S2 for equal-area cells.)
2. **How would you implement the ETA calculation?** (Call Google Maps/Mapbox Direction API with current traffic; cache results by origin-geohash + destination for similar routes.)
3. **How does Uber handle driver state across millions of concurrent connections?** (Consistent hashing ring maps each driver to a Dispatch cluster node; driver state is local to that node + Kafka for durability.)
