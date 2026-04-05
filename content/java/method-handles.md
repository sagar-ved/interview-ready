---
title: "Java: Method Handles vs. Reflection"
date: 2024-04-04
draft: false
weight: 30
---

# 🧩 Question: Compare `java.lang.reflect` and `java.lang.invoke.MethodHandle`. Which is faster and why?

## 🎯 What the interviewer is testing
- Advanced knowledge of JVM optimizations.
- Understanding of invokedynamic (indy).
- Performance tuning for frameworks (Spring, Hibernate).

---

## 🧠 Deep Explanation

### 1. Reflection (The Old Way):
- Operates via the `Field`, `Method`, and `Constructor` objects.
- **Security Check**: Performed on EVERY call.
- **Boxing/Unboxing**: Java must convert arguments to `Object[]`.
- **Optimization**: Hard for JIT to inline because the method being called is not known until runtime.

### 2. MethodHandles (The Modern Way - Java 7+):
- Low-level, typed reference to an underlying method.
- **Security Check**: Performed ONCE (when the look-up is created).
- **No Boxing**: Direct invocation.
- **JIT Friendly**: Can be inlined and optimized just like a direct call if the `MethodHandle` is stored in a `static final` field.

### 3. Use Case:
If you need to call a method once, Reflection is easier. If you are a framework (like a JSON mapper) calling a method millions of times, `MethodHandles` (specifically via `invokedynamic`) provide near-native performance.

---

## ✅ Ideal Answer
While Reflection is more feature-rich (can list methods, fields), MethodHandles are designed for high performance. They perform access checks only once and allow the JIT compiler to optimize call sites as if they were direct method calls. This is the foundation of Lambda expressions and dynamic languages on the JVM.

---

## 💻 Java Code
```java
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

public class MHExample {
    public void hello(String name) {
        System.out.println("Hello, " + name);
    }

    public static void main(String[] args) throws Throwable {
        MHExample example = new MHExample();

        // 1. Look up
        MethodType type = MethodType.methodType(void.class, String.class);
        MethodHandle mh = MethodHandles.lookup()
            .findVirtual(MHExample.class, "hello", type);

        // 2. Invoke
        mh.invoke(example, "Antigravity");
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking MethodHandles are always faster (they only shine when reused and potentially inlined).
- Forgetting that Refection can bypass `private` access easy; MH lookups obey access rules unless using `MethodHandles.privateLookupIn`.

---

## 🔄 Follow-up Questions
1. **What is `invokedynamic`?** (A bytecode instruction that allows the dynamic linkage of call sites.)
2. **What is a "Bootstrap Method" (BSM)?** (The method that resolves an indy call site the first time it is reached.)
3. **How does Java Lambda use MethodHandles?** (Lambdas are compiled into indy sites that use Metafactory to create a Lambda call site.)
