---
author: "sagar ved"
title: "CompletableFuture and Async Programming"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Design a parallel data aggregator that fetches user profile, order history, and recommendations concurrently, combines them, and times out after 3 seconds if any call is slow.

## 🎯 What the interviewer is testing
- Composing async operations with `CompletableFuture`
- Timeout handling in async chains
- Error handling and fallbacks
- Thread pool selection for async I/O tasks

---

## 🧠 Deep Explanation

### 1. Why `CompletableFuture` Over `Future`?

`Future` is blocking — `get()` blocks the calling thread. `CompletableFuture` is:
- **Non-blocking composition**: `thenApply`, `thenCompose`, `thenCombine`
- **Exception handling**: `exceptionally`, `handle`
- **Timeouts**: `orTimeout(n, TimeUnit)` (Java 9+)
- **Combinators**: `allOf`, `anyOf`

### 2. The ForkJoinPool Default Trap

By default, `CompletableFuture.supplyAsync()` uses the **common ForkJoinPool**. This shared pool is meant for CPU-bound tasks. For I/O tasks (HTTP calls, DB queries), you should pass a **dedicated I/O thread pool** to avoid starving the FJP.

### 3. Composition Patterns

| Method | Use When |
|---|---|
| `thenApply` | Transform the result (sync) |
| `thenCompose` | Chain another async call (flatMap) |
| `thenCombine` | Combine results of two independent futures |
| `allOf` | Wait for all futures to complete |
| `anyOf` | Complete as soon as the first future finishes |

---

## ✅ Ideal Answer

- Use `CompletableFuture.supplyAsync()` for each remote call with a **dedicated I/O executor**.
- Use `CompletableFuture.allOf()` to wait for all calls.
- Apply `.orTimeout(3, TimeUnit.SECONDS)` to each future.
- Add `.exceptionally()` per call to provide a fallback (empty data) instead of failing the whole request.
- Combine results with `thenApply` after `allOf`.

---

## 💻 Java Code

```java
import java.util.concurrent.*;

public class UserDashboardAggregator {

    // Dedicated I/O pool to avoid blocking ForkJoinPool.commonPool()
    private static final ExecutorService ioPool = Executors.newFixedThreadPool(20);

    public UserDashboard fetchDashboard(String userId) throws Exception {
        // Launch all 3 calls concurrently
        CompletableFuture<UserProfile> profileFuture = CompletableFuture
            .supplyAsync(() -> fetchProfile(userId), ioPool)
            .orTimeout(3, TimeUnit.SECONDS)                          // Timeout per call
            .exceptionally(e -> UserProfile.empty());                // Fallback on timeout/error

        CompletableFuture<OrderHistory> orderFuture = CompletableFuture
            .supplyAsync(() -> fetchOrders(userId), ioPool)
            .orTimeout(3, TimeUnit.SECONDS)
            .exceptionally(e -> OrderHistory.empty());

        CompletableFuture<Recommendations> recFuture = CompletableFuture
            .supplyAsync(() -> fetchRecommendations(userId), ioPool)
            .orTimeout(3, TimeUnit.SECONDS)
            .exceptionally(e -> Recommendations.empty());

        // Wait for all to complete
        CompletableFuture<Void> allFutures = CompletableFuture.allOf(
            profileFuture, orderFuture, recFuture
        );

        // Combine results after all are done
        return allFutures.thenApply(v ->
            new UserDashboard(
                profileFuture.join(),
                orderFuture.join(),
                recFuture.join()
            )
        ).get(5, TimeUnit.SECONDS); // Global timeout on the combined result
    }

    // Stubs simulating remote service calls
    private UserProfile fetchProfile(String userId) {
        try { Thread.sleep(100); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        return new UserProfile(userId, "John Doe");
    }

    private OrderHistory fetchOrders(String userId) {
        try { Thread.sleep(200); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        return new OrderHistory(userId, 15);
    }

    private Recommendations fetchRecommendations(String userId) {
        try { Thread.sleep(150); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        return new Recommendations(userId, 5);
    }

    // Data classes
    record UserProfile(String id, String name) { static UserProfile empty() { return new UserProfile("", ""); } }
    record OrderHistory(String userId, int count) { static OrderHistory empty() { return new OrderHistory("", 0); } }
    record Recommendations(String userId, int count) { static Recommendations empty() { return new Recommendations("", 0); } }
    record UserDashboard(UserProfile profile, OrderHistory orders, Recommendations recs) {}
}
```

---

## ⚠️ Common Mistakes
- Using `CompletableFuture.get()` without a timeout — blocks indefinitely on slow services
- Not handling exceptions per-future — one failed call propagates to fail all combined results
- Using the common `ForkJoinPool` for I/O blocking tasks — starves parallel streams and other FJP users
- Confusing `thenApply` (sync transformation) with `thenCompose` (async chaining — returns `CompletableFuture<T>` not `T`)

---

## 🔄 Follow-up Questions
1. **What's the difference between `thenCompose` and `thenApply`?** (`thenApply` is like `map`; `thenCompose` is `flatMap` for nested `CompletableFuture<CompletableFuture<T>>` scenarios.)  
2. **How do virtual threads (Java 21 Loom) change this pattern?** (With virtual threads, blocking I/O calls don't pin OS threads, so the dedicated pool approach becomes less critical.)
3. **How would you implement a "circuit breaker" pattern here?** (Track failures per-service; if failures exceed threshold, short-circuit with immediate fallback without calling the service.)
