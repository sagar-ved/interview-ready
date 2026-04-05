---
title: "Java: CompletableFuture Internals"
date: 2024-04-04
draft: false
weight: 31
---

# 🧩 Question: How does `CompletableFuture` differ from standard `Future`? How do its callbacks (`thenApply`, `thenCompose`) execute internally?

## 🎯 What the interviewer is testing
- Evolution of Asynchronous programming in Java.
- Callback-based non-blocking logic.
- Understanding of the global `ForkJoinPool.commonPool()`.

---

## 🧠 Deep Explanation

### 1. `Future` vs `CompletableFuture`:
- **Future**: Blocking. You must call `.get()` which halts the thread until the result is ready. No way to chain tasks.
- **CompletableFuture**: Functional. You define what happens **when** the result arrives. You can chain, compose, and handle errors asynchronously.

### 2. Internals of Chaining:
When you call `.thenApply()`, you're adding a **Completion Object** to a stack/queue inside the `CompletableFuture`.
- If the first task is already done, the callback executes immediately.
- If not, the task that finishes the `CompletableFuture` will trigger all waiting completions.

### 3. Threading:
- `.thenApply()`: Usually runs in the **same thread** that finished the previous task.
- `.thenApplyAsync()`: Dispatched to `ForkJoinPool.commonPool()` (active-processing pool) or a custom executor.

---

## ✅ Ideal Answer
`CompletableFuture` brought promise-like behavior to Java, allowing for non-blocking asynchronous pipelines. It uses a push-based model where the finishing thread triggers dependent stages. This significantly improves resource utilization because threads aren't left waiting for I/O or computations to finish.

---

## 💻 Java Code
```java
import java.util.concurrent.*;

public class CFDemo {
    public static void main(String[] args) throws Exception {
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
            // Simulated delay
            return "Data";
        });

        CompletableFuture<Integer> lengthFuture = future
            .thenApply(s -> s.length()) // Transformation
            .exceptionally(ex -> -1);    // Error handling

        System.out.println("Result: " + lengthFuture.get());
    }
}
```

---

## ⚠️ Common Mistakes
- Blocking on `.get()` in the middle of a non-blocking sequence.
- Not providing a custom executor for blocking I/O (using the `commonPool` for I/O can starve the entire JVM).
- Thinking `.thenCompose()` and `.thenApply()` are the same (`Compose` is for nested CFs, like `flatMap`).

---

## 🔄 Follow-up Questions
1. **What is the commonPool?** (A JVM-wide ForkJoinPool tuned for CPU-intensive tasks.)
2. **What is `thenCombine`?** (Executes two independent futures and runs a function when both finish.)
3. **Difference between `allOf` and `anyOf`?** (`allOf` waits for everyone; `anyOf` yields once the first one finishes.)
