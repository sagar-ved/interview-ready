---
title: "DSA: Task Scheduler"
date: 2024-04-04
draft: false
weight: 19
---

# 🧩 Question: Task Scheduler (LeetCode 621)
Given a characters array `tasks`, representing the tasks a CPU needs to do, where each letter represents a different task. Tasks could be done in any order. Each task is done in one unit of time. For each unit of time, the CPU could complete either one task or just be idle. However, there is a non-negative integer `n` that represents the cooldown period between two **same tasks**. Return the least number of units of time that the CPU will take to finish all the given tasks.

## 🎯 What the interviewer is testing
- Greedy thinking.
- Use of PriorityQueues or Mathematical formulas.
- Handling cooldown constraints.

---

## 🧠 Deep Explanation

### 1. The Greedy Observation:
The tasks with the highest frequency should be scheduled first to avoid being left with many high-frequency tasks that require idles at the end.

### 2. Mathematical Approach (The most efficient):
If the max frequency of any task is `f_max`, we have `f_max - 1` gaps between them. Each gap must have size `n`.
- Total slots based on max frequency: `(f_max - 1) * (n + 1)`.
- We add the count of tasks that have the same `f_max` frequency.
- Final answer is `max(tasks.length, calculation)`.

---

## ✅ Ideal Answer
The optimal time is dictated by the task with the highest occurrences. We arrange these "most frequent" tasks first, separated by `n` slots. We then fill these slots with other tasks. If the calculated slots are fewer than the total tasks, it means we don't need any idle time; otherwise, the sum of tasks and idle time is our answer.

---

## 💻 Java Code
```java
import java.util.*;

public class Solution {
    public int leastInterval(char[] tasks, int n) {
        int[] freq = new int[26];
        int maxFreq = 0;
        for (char t : tasks) {
            freq[t - 'A']++;
            maxFreq = Math.max(maxFreq, freq[t - 'A']);
        }

        int maxFreqCount = 0;
        for (int f : freq) {
            if (f == maxFreq) maxFreqCount++;
        }

        int partCount = maxFreq - 1;
        int partLength = n - (maxFreqCount - 1);
        int emptySlots = partCount * partLength;
        int availableTasks = tasks.length - maxFreq * maxFreqCount;
        int idles = Math.max(0, emptySlots - availableTasks);

        return tasks.length + idles;
    }
}
```

---

## ⚠️ Common Mistakes
- Not considering that multiple tasks might share the maximum frequency.
- Trying a full simulation (though workable with PQ and specialized wait queue, it's slower than the math formula).
- Forgetting that the result can't be smaller than `tasks.length`.

---

## 🔄 Follow-up Questions
1. **How to solve using PriorityQueue?** (Put tasks in PQ, extract `n+1` tasks, add them back after decreasing frequency.)
2. **What if the tasks have dependencies?** (This becomes a Graph problem / DAG Scheduling.)
3. **How to handle large volumes of stream?** (Approximate counts using sketches if exactness isn't required.)
