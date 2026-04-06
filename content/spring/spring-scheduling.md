---
author: "sagar ved"
title: "Spring: Scheduler (@Scheduled)"
date: 2024-04-04
draft: false
weight: 16
---

# 🧩 Question: How does `@Scheduled` work in Spring? What occurs if a task takes longer than the interval?

## 🎯 What the interviewer is testing
- Threading and Task Management basics.
- FixedDelay vs FixedRate.
- Preventing task overlap.

---

## 🧠 Deep Explanation

### 1. Enable Scheduling:
Annotate a config class with `@EnableScheduling`. By default, it uses a **single-threaded** scheduler.

### 2. The Modes:
- **`fixedRate = 5000`**: Run every 5s regardless of when the last one finished.
  - **Risk**: If task takes 10s, you'll have multiple instances running at once (if multi-threaded) or tasks "queuing up."
- **`fixedDelay = 5000`**: Wait 5s AFTER the previous task finishes. (No overlap possible).
- **`cron`**: Unix-style CRON expression for specific times.

### 3. The Overlap Problem:
By default, one `@Scheduled` task won't run multiple times in parallel even with `fixedRate` because the default pool size is 1. If you increase the pool size, you might have overlap.

---

## ✅ Ideal Answer
Spring's scheduling provides a convenient abstraction over Java's `ScheduledExecutorService`. While `fixedRate` is ideal for tasks where total frequency is the priority, `fixedDelay` is the safer choice for complex business jobs where we must prevent the same task from overlapping with itself. For critical background operations, we must configure a dedicated `TaskScheduler` bean to ensure our threads are never starved by other competing asynchronous processes.

---

## 🏗️ Code Tip:
```java
@Bean
public TaskScheduler taskScheduler() {
    ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
    scheduler.setPoolSize(5); // Don't starve the tasks!
    return scheduler;
}
```

---

## 🔄 Follow-up Questions
1. **How to run a task on one instance only in a Horizontal Cluster?** (Standard `@Scheduled` runs on ALL instances. To avoid this, use a distributed scheduler like **ShedLock** or **Quartz**.)
2. **What if the task throws an exception?** (The scheduler catches it, logs it, and continues to the next scheduled interval.)
3. **Async + Scheduled?** (Yes, you can combine them to push the execution to a separate pool immediately.)
