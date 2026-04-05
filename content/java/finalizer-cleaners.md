---
title: "Java: Finalizer vs. Cleaners"
date: 2024-04-04
draft: false
weight: 26
---

# 🧩 Question: Why is `finalize()` deprecated? Explain `java.lang.ref.Cleaner` as an alternative for resource cleanup.

## 🎯 What the interviewer is testing
- Knowledge of JVM evolution.
- Understanding of memory-safe resource management.
- Awareness of modern Java API (Java 9+).

---

## 🧠 Deep Explanation

### 1. The Problems with `finalize()`:
- **Unpredictability**: You never know **when** (or if) the GC will run the finalizer.
- **Performance**: Objects with finalizers are moved to a special queue, delaying their reclamation across multiple GC cycles.
- **Security**: A finalizer can "resurrect" an object by assigning `this` to a static field.
- **Exceptions**: Exceptions in `finalize()` are ignored.

### 2. The Solution: `Cleaner` (Java 9+)
- A `Cleaner` uses a separate thread to handle cleanup.
- It is based on **PhantomReferences**.
- The "cleanup action" cannot reference the object itself (to prevent resurrection).

---

## ✅ Ideal Answer
`finalize()` is deprecated because it is slow, unsafe, and provides no guarantees on timing. Modern Java uses `java.lang.ref.Cleaner` or implementation of `AutoCloseable` with try-with-resources. Cleaners are safer because the cleanup logic is decoupled from the object's memory state, avoiding the "resurrection" bug.

---

## 💻 Java Code: Using Cleaner
```java
import java.lang.ref.Cleaner;

public class ResourceHolder implements AutoCloseable {
    private static final Cleaner CLEANER = Cleaner.create();
    
    // Static inner class to ensure we don't accidentally capture 'this'
    private static class State implements Runnable {
        @Override
        public void run() {
            System.out.println("Cleaning up native resources...");
        }
    }

    private final Cleaner.Cleanable cleanable;

    public ResourceHolder() {
        this.cleanable = CLEANER.register(this, new State());
    }

    @Override
    public void close() {
        cleanable.clean(); // Manual trigger
    }
}
```

---

## ⚠️ Common Mistakes
- Referencing the object inside the Cleaner's `Runnable` (capturing `this`), which prevents the object from ever being collected.
- Thinking `Cleaner` is a replacement for `try-with-resources`. (It's a safety net, not the primary method).

---

## 🔄 Follow-up Questions
1. **What is a Shutdown Hook?** (A thread that runs when the JVM stops.)
2. **Difference between `close()` and `clean()`?** (`close()` is the standard pattern; `clean()` is the final fallback for lost references.)
3. **How does `PhantomReference` play a role in Cleaners?** (Cleaners monitor phantom references to detect when an object is phantom-reachable.)
