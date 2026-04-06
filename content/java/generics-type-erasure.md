---
author: "sagar ved"
title: "Java Generics and Type Erasure"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Explain how Java Generics work under the hood. Why can't you do `new T()` or `instanceof T` inside a generic class?

## 🎯 What the interviewer is testing
- Type Erasure and its implications
- Wildcard bounds (`? extends`, `? super`)
- PECS principle (Producer Extends, Consumer Super)
- Bridge methods and their role

---

## 🧠 Deep Explanation

### 1. Type Erasure

Java Generics are a **compile-time feature**. At runtime, all generic type information is **erased**. `List<String>` and `List<Integer>` are both just `List` at the bytecode level.

The compiler inserts **casts** automatically where needed. So:
```java
List<String> list = new ArrayList<>();
String s = list.get(0); // Compiler inserts: (String) list.get(0);
```

This is why:
- `new T()` fails — the JVM doesn't know what `T` is at runtime.
- `instanceof T` fails — same reason.
- `List<String>` and `List<Integer>` are the same class at runtime.

### 2. Why Type Erasure?

Backward compatibility with pre-Generics Java code. A `List<String>` is interoperable with the pre-Java 5 raw `List`.

### 3. Wildcard: `? extends T` vs `? super T`

**PECS: Producer Extends, Consumer Super**

- `List<? extends Number>`: You can READ Numbers from it (it produces Numbers). Cannot add to it (unsafe — you don't know the exact subtype).
- `List<? super Integer>`: You can WRITE Integers to it (it consumes Integers). Reading returns `Object` (unsafe — you don't know what you'll get).

### 4. Bridge Methods

When a generic class is extended and the subclass provides a concrete type, the compiler generates a **bridge method** to maintain polymorphism:
```java
class StringBox extends Box<String> {
    @Override
    public void set(String value) { ... }
    // Compiler generates bridge: public void set(Object value) { set((String) value); }
}
```

---

## ✅ Ideal Answer

- Generics enforce type safety at compile time only. At runtime, there is no type information.
- `new T()` is impossible without reflection because the JVM doesn't know `T`.
- Use a `Class<T>` parameter (type token) to enable `clazz.newInstance()`.
- PECS: Use `? extends T` when you only read; `? super T` when you only write.

---

## 💻 Java Code

```java
import java.lang.reflect.Array;
import java.util.*;

// Demonstrates type token pattern and PECS
public class GenericsDemo {

    // ❌ Cannot do: new T[10] directly
    // ✅ Use Class<T> token
    static <T> T[] createArray(Class<T> clazz, int size) {
        @SuppressWarnings("unchecked")
        T[] array = (T[]) Array.newInstance(clazz, size);
        return array;
    }

    // PECS: read from producer (extends), write to consumer (super)
    static <T> void copy(List<? extends T> source, List<? super T> destination) {
        for (T item : source) {
            destination.add(item);  // Can write to consumer
        }
    }

    // Generic class with bounded type parameter
    static class NumberBox<T extends Number & Comparable<T>> {
        private T value;
        public NumberBox(T value) { this.value = value; }
        public double doubleValue() { return value.doubleValue(); }
        public T get() { return value; }
    }

    public static void main(String[] args) {
        // PECS example
        List<Integer> ints = List.of(1, 2, 3);
        List<Number> numbers = new ArrayList<>();
        copy(ints, numbers); // ints is producer (extends Number), numbers is consumer (super Integer)

        // Type token
        String[] strings = createArray(String.class, 5);
        strings[0] = "Hello";
        System.out.println(strings[0]);
    }
}
```

---

## ⚠️ Common Mistakes
- Trying `instanceof T` in generics — always a compile error
- Over-using raw types (`List` instead of `List<?>`) which defeats type safety
- Using `? extends T` when you need to add elements (not possible)
- Heap pollution: using `@SuppressWarnings("unchecked")` carelessly without understanding the risk

---

## 🔄 Follow-up Questions
1. **What is "heap pollution" in Java Generics?** (When a parameterized type variable refers to an object that is not of that type, causing `ClassCastException` at an unexpected location.)
2. **Can you create a `List<int>`?** (No — Generics don't support primitives. Use `List<Integer>` — autoboxing handles conversion.)
3. **What is `@SafeVarargs` and when do you use it?** (Suppresses heap pollution warnings for varargs generic methods where the caller guarantees safety.)
