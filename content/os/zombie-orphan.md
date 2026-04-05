---
title: "OS: Zombie vs. Orphan Processes"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: What is the difference between a Zombie and an Orphan process? How do you eliminate each?

## 🎯 What the interviewer is testing
- Unix process lifecycle.
- Monitoring system resources (`top`, `ps`).
- Signal handling (`SIGCHLD`).

---

## 🧠 Deep Explanation

### 1. Zombie Process:
- A process that has **completed execution** but still has an entry in the **process table**.
- **Reason**: The parent hasn't called `wait()` or `waitpid()` to read the exit status of the child.
- **Resource Usage**: No CPU or RAM, but it consumes a PID. If too many exist, no more processes can be created.
- **Fix**: The parent must wait for its children. If the parent is "broken," you must kill the **parent**.

### 2. Orphan Process:
- A process whose **parent has died**.
- **Reason**: The child outlives its parent.
- **Fix**: The OS automatically "re-parents" the orphan to **init (PID 1)**. `init` is responsible for waiting on its adopted children.
- **Resource Usage**: Normal.

---

## ✅ Ideal Answer
A zombie is a dead process waiting for its parent to acknowledge it. An orphan is a line process that lost its parent and was adopted by `init`. You "kill" a zombie by killing its parent (so it gets adopted by `init`). Orphans are a normal part of background execution (daemons).

---

## 💻 Monitoring (Shell)
```bash
# Find zombie processes (Z status)
ps aux | grep 'Z'

# Count zombies
ps -ef | grep defunct | grep -v grep | wc -l
```

---

## ⚠️ Common Mistakes
- Trying to `kill -9` a zombie (you can't kill what's already dead).
- Thinking orphans are a memory leak.
- Describing a zombie as a "background process" (that's a daemon).

---

## 🔄 Follow-up Questions
1. **What is `waitpid()`?** (A system call that stops the parent until a specific child finishes.)
2. **What is a "defunct" process?** (Another name for a zombie.)
3. **What is the init process?** (The first process started by the kernel, responsible for cleaning up orphans.)
