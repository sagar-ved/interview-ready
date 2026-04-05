---
title: "Spring Boot: Actuator and Monitoring"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: What is Spring Boot Actuator? Which endpoints are critical for production health monitoring?

## 🎯 What the interviewer is testing
- Observability and Production-Readiness.
- Security of management endpoints.
- Integration with Prometheus/Grafana.

---

## 🧠 Deep Explanation

### 1. What it does:
Actuator adds HTTP endpoints to your app to see "under the hood" of the JVM.

### 2. Core Endpoints:
- **`/health`**: Is the app up? (Checks DB connectivity, disk space).
- **`/metrics`**: Raw counter/gauge data (Memory, CPU, HTTP request counts).
- **`/info`**: Build version, git commit ID.
- **`/env`**: Current environment variables.
- **`/loggers`**: Change log levels (DEBUG/INFO) at runtime without restarting! (Extremely powerful for debugging).
- **`/threaddump`**: Snapshot of what every thread is doing (detect deadlocks).

### 3. Security:
By default, most are disabled/hidden. 
`management.endpoints.web.exposure.include=health,info,prometheus` 
- **Critical**: You MUST secure these endpoints (usually on a separate port or behind admin-only auth) as they leak sensitive system info.

---

## ✅ Ideal Answer
Spring Boot Actuator turns a black-box application into an observable system. It provides the essential telemetry needed for production stability, from basic health checks for the load balancer to deep-dive thread dumps for debugging performance spikes. For a senior engineer, the priority is not just enabling these tools, but ensuring they are correctly secured and integrated into a central monitoring platform like Prometheus for long-term trend analysis.

---

## 🔄 Follow-up Questions
1. **Liveness vs Readiness?** (Liveness: Is the app dead [reboot it]? Readiness: Is it ready to take traffic [waiting for cache to warm up]?)
2. **How to add a custom health check?** (Implement `HealthIndicator` interface and define your own logic.)
3. **Micrometer?** (The underlying library Actuator uses to send metrics to Prometheus, Datadog, or NewRelic.)
