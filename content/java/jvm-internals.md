---
author: "sagar ved"
title: "JVM Internals & Memory Management"
date: 2024-04-04
draft: false
---

# JVM Internals & Memory Management

## 📌 Question
Explain the JVM architecture and how the Garbage Collection (GC) process works in Java 8+ (specifically G1 GC).

## 🎯 What is being tested
- Understanding of Memory Areas (Heap, Stack, Metaspace).
- Knowledge of GC generations (Young, Old).
- Familiarity with modern collectors like G1.

## 🧠 Explanation
The JVM is divided into several runtime data areas:
1. **Method Area (Metaspace)**: Stores class metadata, static variables, etc. (Previously PermGen).
2. **Heap**: Where all objects are allocated. Divided into Young (Eden, S0, S1) and Old Generation.
3. **Stack**: Stores local variables and partial results for each thread.

**Garbage Collection**:
- Minor GC: Cleans Young Gen.
- Major GC: Cleans Old Gen.
- **G1 GC**: Divides the heap into regions and targets regions with the most "garbage" first to minimize pause times.

## ✅ Ideal Answer
Start with the components of the JVM (Class Loader, Runtime Data Areas, Execution Engine). Focus on the Heap's generational structure and why it exists (Weak Generational Hypothesis). Explain G1 GC as a region-based collector that aims for predictable pause times.

## 💻 Code Example (Java)
```java
// Tip: To see JVM details, use:
// java -Xms512m -Xmx1024m -XX:+UseG1GC MyClass
public class GCTest {
    public static void main(String[] args) {
        Runtime runtime = Runtime.getRuntime();
        System.out.println("Total Memory: " + runtime.totalMemory());
        System.out.println("Free Memory: " + runtime.freeMemory());
    }
}
```

## ⚠️ Common Mistakes
- Confusing Metaspace with Heap.
- Thinking Stack stores objects (it only stores references).
- Not knowing the difference between G1 and CMS.

## 🔄 Follow-ups
- How does ZGC differ from G1?
- What are the common `OutOfMemoryError` types and their causes?
