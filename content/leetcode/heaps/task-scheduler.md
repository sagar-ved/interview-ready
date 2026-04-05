---
title: "LeetCode 621: Task Scheduler"
date: 2024-04-04
draft: false
weight: 3
---

# 🧩 LeetCode 621: Task Scheduler (Medium)
Given tasks and a cooldown `n`, find the minimum CPU intervals needed to execute all tasks (with cooldown between same tasks).

## 🎯 What the interviewer is testing
- Greedy frequency-based scheduling.
- Math formula vs simulation approach.
- Max-Heap for most frequent task tracking.

---

## 🧠 Deep Explanation

### Key Insight: Math Formula
The most frequent task determines the minimum length.
- Let `maxFreq` = frequency of the most frequent task.
- Let `maxCount` = number of tasks with `maxFreq`.
- Formula: `result = max(tasks.length, (maxFreq - 1) * (n + 1) + maxCount)`

**Why?** We create "slots" of size `n+1` around the most frequent task. Each slot can be filled with other tasks or idle. If total tasks > slots needed, we just use `tasks.length`.

### Alternative: Max-Heap Simulation
Use a Max-Heap (by frequency). Each "round" of `n+1` slots:
- Pick the top `n+1` most frequent tasks, reduce their counts.
- Push non-zero counts back.

---

## ✅ Ideal Answer
The mathematical approach is elegant: the most frequent task creates a frame of minimum required intervals. If other tasks and idle slots can fill the gaps, no extra idle time is needed. If tasks overflow the frame, every task executes with no idle time.

---

## 💻 Java Code (Math)
```java
public class Solution {
    public int leastInterval(char[] tasks, int n) {
        int[] freq = new int[26];
        for (char t : tasks) freq[t - 'A']++;
        int maxFreq = 0;
        for (int f : freq) maxFreq = Math.max(maxFreq, f);
        int maxCount = 0;
        for (int f : freq) if (f == maxFreq) maxCount++;
        return Math.max(tasks.length, (maxFreq - 1) * (n + 1) + maxCount);
    }
}
```

---

## 🔄 Follow-up Questions
1. **What if `n=0`?** (No cooldown — result is simply `tasks.length`.)
2. **How many idle slots?** (`result - tasks.length`.)
3. **Order the actual schedule?** (Need the Heap simulation approach to produce the task sequence.)
