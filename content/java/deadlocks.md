---
author: "sagar ved"
title: "Deadlocks: Detection, Prevention, and Avoidance"
date: 2024-04-04
draft: false
weight: 9
---

# 🧩 Question: Two threads are deadlocked in your production payment service causing transaction processing to hang. Walk me through how you diagnose it and prevent it in the future.

## 🎯 What the interviewer is testing
- Four Conditions for Deadlock (Coffman conditions)
- Deadlock detection using thread dumps
- Prevention strategies: lock ordering, tryLock, timeouts
- Real-world patterns in financial/payment systems

---

## 🧠 Deep Explanation

### 1. The Four Coffman Conditions

For a deadlock to occur, ALL four conditions must hold simultaneously:
1. **Mutual Exclusion**: Resources cannot be shared.
2. **Hold and Wait**: A thread holds one resource and waits for another.
3. **No Preemption**: Resources cannot be forcibly taken from a thread.
4. **Circular Wait**: Thread A waits for Thread B's resource; Thread B waits for Thread A's.

### 2. Deadlock Diagnosis in Production

**Step 1**: Capture a thread dump:
```bash
# Using jstack
jstack <PID> > threaddump.txt

# Or via kill signal (Linux/Mac)
kill -3 <PID>
```

**Step 2**: Look for `BLOCKED` threads and `waiting to lock` patterns in the dump.

**Step 3**: Identify the circular waiting chain.

### 3. Prevention Strategies

| Strategy | How |
|---|---|
| **Lock Ordering** | Always acquire locks in the same order across all threads |
| **tryLock with Timeout** | Attempt lock, back off and retry if timeout exceeded |
| **Lock Coarsening** | Use one coarse-grained lock instead of multiple fine-grained locks |
| **Avoid Nested Locks** | Never acquire a second lock while holding a first |
| **Deadlock Watchdog** | Background thread that detects and breaks deadlocks |

---

## ✅ Ideal Answer

- **Diagnosis**: Capture thread dump, identify `BLOCKED` threads with circular lock dependency.
- **Prevention**: Enforce a global lock ordering (e.g., always lock `accountA` before `accountB` using `accountId` comparison).
- **Fallback**: Use `ReentrantLock.tryLock(timeout)` to fail-fast and retry.
- **Monitoring**: Alert on thread count spikes and transaction timeouts in APM tools (Datadog, New Relic).

---

## 💻 Java Code

```java
import java.util.concurrent.locks.ReentrantLock;
import java.util.*;

/**
 * Transfer funds between accounts without deadlock.
 * Demonstrates lock ordering to prevent circular wait.
 */
public class TransferService {

    static class BankAccount {
        final int id;
        double balance;
        final ReentrantLock lock = new ReentrantLock();

        BankAccount(int id, double balance) {
            this.id = id;
            this.balance = balance;
        }
    }

    /**
     * ❌ DEADLOCK PRONE: Thread A locks account1 then account2.
     *    Thread B locks account2 then account1.
     */
    public void transferUnsafe(BankAccount from, BankAccount to, double amount) {
        synchronized (from) {
            synchronized (to) {  // DEADLOCK if another thread acquired 'to' first
                from.balance -= amount;
                to.balance += amount;
            }
        }
    }

    /**
     * ✅ SAFE: Always lock in consistent order by account ID.
     *    Breaks the circular wait condition.
     */
    public void transferSafe(BankAccount a, BankAccount b, double amount) {
        BankAccount first = a.id < b.id ? a : b;
        BankAccount second = a.id < b.id ? b : a;

        synchronized (first) {
            synchronized (second) {
                if (a == first) {
                    a.balance -= amount;
                    b.balance += amount;
                } else {
                    b.balance -= amount;
                    a.balance += amount;
                }
            }
        }
    }

    /**
     * ✅ EVEN SAFER: tryLock with timeout for high-contention scenarios.
     */
    public boolean transferWithTimeout(BankAccount from, BankAccount to, double amount)
            throws InterruptedException {
        Random random = new Random();
        while (true) {
            if (from.lock.tryLock(50, java.util.concurrent.TimeUnit.MILLISECONDS)) {
                try {
                    if (to.lock.tryLock(50, java.util.concurrent.TimeUnit.MILLISECONDS)) {
                        try {
                            from.balance -= amount;
                            to.balance += amount;
                            return true;
                        } finally {
                            to.lock.unlock();
                        }
                    }
                } finally {
                    from.lock.unlock();
                }
            }
            // Back-off before retry to avoid livelock
            Thread.sleep(random.nextInt(10));
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking deadlocks require exactly 2 threads (can involve any N threads in a cycle)
- Confusing deadlock with livelock (threads keep retrying but make no progress)
- Confusing deadlock with starvation (thread never gets a lock but others do)
- Not always releasing locks in `finally` blocks

---

## 🔄 Follow-up Questions
1. **What is a livelock and how does it differ from a deadlock?** (In a livelock, threads are active but constantly backing off in response to each other, making no progress.)
2. **How does the OS detect and resolve deadlocks?** (Resource Allocation Graph; resource preemption, rollback, or process termination.)
3. **What is the Dining Philosophers problem and how does it model deadlock?** (5 philosophers, 5 forks; each needs 2 forks to eat; pick up left then right → deadlock.)
