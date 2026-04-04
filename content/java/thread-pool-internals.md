---
title: "Thread Pools and ExecutorService Internals"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 Question: Your application is handling bursty API traffic. When you submit 1000 tasks to a thread pool with `corePoolSize=10`, `maxPoolSize=50`, and an unbounded queue — only 10 threads are ever used. Why? What changes would you make?

## 🎯 What the interviewer is testing
- Understanding of `ThreadPoolExecutor` internals (core/max/queue relationship)
- Task lifecycle within a thread pool
- RejectedExecutionHandler strategies
- Real-world implications for latency-sensitive services

---

## 🧠 Deep Explanation

### 1. ThreadPoolExecutor Lifecycle Logic

The decision to create threads follows a **strict escalation policy**:

```
Task submitted
  → IF active threads < corePoolSize           → Create a new CORE thread
  → IF active threads == corePoolSize          → Put task in QUEUE
  → IF queue is FULL && threads < maxPoolSize  → Create a new NON-CORE thread
  → IF queue is FULL && threads == maxPoolSize → Trigger RejectedExecutionHandler
```

**Key Insight**: With an **unbounded queue** (`LinkedBlockingQueue`), the queue fills before `maxPoolSize` is ever reached. Non-core threads are **never created** because the queue never fills up.

### 2. Internal Data Structures

- `workers`: A `HashSet<Worker>` holding active threads.
- `workQueue`: A `BlockingQueue<Runnable>` holding pending tasks.
- `ctl`: An `AtomicInteger` that encodes both the thread count AND the pool state (RUNNING, SHUTDOWN, STOP, TERMINATED) in one integer.

### 3. Worker Thread Lifecycle

A `Worker` is a `Runnable` that loops:
```java
while (task != null || (task = getTask()) != null) {
    runTask(task);
}
// If getTask() returns null (timeout or SHUTDOWN), the worker dies
```

`getTask()` calls `workQueue.poll(keepAliveTime)` for non-core threads or `workQueue.take()` (blocks forever) for core threads, which is why core threads never die.

### 4. Real-world Implications
- **High throughput, low latency services** (Uber, Razorpay): Unbounded queues are dangerous! Tasks queue up silently while system memory grows, until OOM.
- **Better Config**: Use a `SynchronousQueue` + large `maxPoolSize`, or a `LinkedBlockingQueue` with a capacity limit.

---

## ✅ Ideal Answer (Structured)

- **Root cause**: Unbounded `LinkedBlockingQueue`. Tasks are enqueued once `corePoolSize` is reached. Since the queue never fills, `maxPoolSize` is never triggered.
- **Fix 1**: Bounded queue — `new LinkedBlockingQueue<>(100)`.
- **Fix 2**: Use `SynchronousQueue` (handoff only, no buffering) so tasks directly trigger new thread creation up to `maxPoolSize`.
- **Fix 3**: Use `Executors.newCachedThreadPool()` for bursty, short-lived tasks (uses `SynchronousQueue` internally, `maxPoolSize = Integer.MAX_VALUE`).
- **Monitoring**: Track `getQueue().size()`, `getActiveCount()`, and `getCompletedTaskCount()` via JMX or Micrometer.

---

## 💻 Java Code

```java
import java.util.concurrent.*;

/**
 * Production-grade ThreadPoolExecutor setup for a bursty REST API handler.
 */
public class OptimizedThreadPool {

    public static ThreadPoolExecutor createPool() {
        int corePoolSize = 10;
        int maxPoolSize = 50;
        long keepAliveTime = 60L;
        // Bounded queue — once full, new threads up to maxPoolSize are spawned
        BlockingQueue<Runnable> workQueue = new LinkedBlockingQueue<>(200);

        ThreadFactory namedFactory = new ThreadFactory() {
            int count = 0;
            @Override
            public Thread newThread(Runnable r) {
                return new Thread(r, "api-worker-" + count++);
            }
        };

        RejectedExecutionHandler handler = new ThreadPoolExecutor.CallerRunsPolicy();
        // CallerRunsPolicy: Calling thread executes the task itself — acts as backpressure

        ThreadPoolExecutor pool = new ThreadPoolExecutor(
            corePoolSize, maxPoolSize, keepAliveTime, TimeUnit.SECONDS,
            workQueue, namedFactory, handler
        );

        // Allow core threads to time out as well (useful for batch processing)
        pool.allowCoreThreadTimeOut(true);
        return pool;
    }

    public static void main(String[] args) {
        ThreadPoolExecutor pool = createPool();

        for (int i = 0; i < 1000; i++) {
            int taskId = i;
            pool.submit(() -> {
                System.out.printf("Task %d running on %s%n", taskId, Thread.currentThread().getName());
                try { Thread.sleep(100); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            });
        }

        pool.shutdown();
    }
}
```

---

## ⚠️ Common Mistakes
- Confusing `Executors.newFixedThreadPool()` internals (it uses an **unbounded** `LinkedBlockingQueue`)
- Thinking that `maxPoolSize` is always the ceiling for active threads
- Using `DiscardPolicy` silently — tasks are dropped with no error
- Not gracefully shutting down; `pool.shutdown()` vs `pool.shutdownNow()` distinction matters (the latter interrupts running tasks)

---

## 🔄 Follow-up Questions
1. **What is `CallerRunsPolicy` and how does it provide backpressure?** (The submitting thread runs the rejected task itself, slowing down the producer organically.)
2. **How does `ForkJoinPool` differ from `ThreadPoolExecutor`?** (Work-stealing — idle threads "steal" from other threads' queues; used by Java's parallel streams and `CompletableFuture`.)
3. **How would you implement a thread pool from scratch?** (BlockingQueue + N Worker threads looping on `queue.take()`.)
4. **How do `CompletableFuture` and virtual threads (Java 21) change the model?** (Virtual threads are cheap and block without pinning OS threads, reducing pool-tuning concerns.)
