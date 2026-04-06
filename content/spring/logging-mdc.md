---
author: "sagar ved"
title: "Spring Boot: Logging (Logback/MDC)"
date: 2024-04-04
draft: false
weight: 27
---

# 🧩 Question: How do you trace a single request across multiple microservices? What is MDC?

## 🎯 What the interviewer is testing
- Distributed Tracing (TraceID).
- Log correlation.
- Understanding of Thread-Local storage for logging contexts.

---

## 🧠 Deep Explanation

### 1. MDC (Mapped Diagnostic Context):
A map managed by the logging framework (Logback/Log4j2) stored in a **ThreadLocal**.
- Any value you put in MDC is automatically included in every log line for that thread.

### 2. The TraceID Workflow:
1. **Filter**: Intercept incoming request.
2. **Token**: Check if `X-Trace-ID` exists in headers. If not, generate a new UUID.
3. **MDC**: Call `MDC.put("traceId", uuid)`.
4. **Log**: Every log line now says `[TRACE: abc-123] User logged in`.
5. **Propagation**: When calling another service, add the ID back into the header.

### 3. Cleanup:
CRITICAL: You must call `MDC.clear()` in a `finally` block or filter to avoid the ID "leaking" to the next unrelated request when the thread is returned to the pool.

---

## ✅ Ideal Answer
In a microservice mesh, isolated logs are almost useless without correlation. MDC provides the thread-bound storage needed to tag every log line with a unique TraceID, allowing us to reconstruct the exact path of a request through the entire stack. While MDC handles the local logging, tools like **Spring Cloud Sleuth** (now Micrometer Tracing) automate the propagation of these IDs across network boundaries, turning hundreds of log files into a single, cohesive narrative.

---

## 🔄 Follow-up Questions
1. **MDC vs ThreadLocal?** (MDC is built on ThreadLocal but integrated into the Logback pattern layout.)
2. **Trace vs Span?** (Trace is the full journey; Span is a single leg of that journey [e.g. one DB call].)
3. **MDC with @Async?** (ThreadLocal values don't pass to new threads. You need a custom task decorator to "copy" the MDC context to the new thread.)
