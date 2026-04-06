---
title: "Java"
date: 2024-04-04
draft: false
---

# Java Interview Prep

Deep dives into Java Core, Advanced, Concurrency, and JVM internals for SDE-2 interviews.

### 📚 Topic Visualization

```mermaid
mindmap
  root((Java Track))
    Core
      Collections Framework
      Generics
      Lambdas & Streams
      Optional
    Concurrency
      Threads & Synchronization
      ReentrantLock
      ExecutorService
      CompletableFuture
    JVM Internals
      ClassLoader
      JIT Compiler
      Garbage Collection
      Memory Model
    Advanced
      Design Patterns
      Reflection
      Annotations
```

### 📚 Topic Master Index

| Topic / Question | Read Document | Difficulty Level |
| :--- | :--- | :--- |
| Abstract Classes vs. Interfaces (Post-Java 9) | [Open ↗](/java/abstract-vs-interface-modern/) | ⭐⭐ Medium |
| Annotation Processors Internals | [Open ↗](/java/annotation-processors/) | ⭐⭐ Medium |
| Arrays.binarySearch() Negative Results | [Open ↗](/java/binarysearch-negatives/) | ⭐ Easy |
| Arrays.parallelSort() Internals | [Open ↗](/java/parallel-sort-internals/) | ⭐⭐ Medium |
| Arrays.sort vs. Collections.sort | [Open ↗](/java/sorting-internals-detailed/) | ⭐ Easy |
| AtomicReferenceFieldUpdater (Expert) | [Open ↗](/java/atomic-field-updaters/) | ⭐⭐ Medium |
| Checked vs. Unchecked Exceptions | [Open ↗](/java/checked-vs-unchecked-exceptions/) | ⭐⭐ Medium |
| Class.forName vs. ClassLoader | [Open ↗](/java/class-forname-vs-loadclass/) | ⭐ Easy |
| ClassLoader Hierarchy | [Open ↗](/java/classloader-hierarchy/) | ⭐⭐⭐ Hard |
| CompletableFuture Internals | [Open ↗](/java/completable-future-internals/) | ⭐⭐ Medium |
| CompletableFuture and Async Programming | [Open ↗](/java/completablefuture-async/) | ⭐⭐ Medium |
| Deadlocks: Detection, Prevention, and Avoidance | [Open ↗](/java/deadlocks/) | ⭐ Easy |
| Deep Dive: ConcurrentHashMap Internals | [Open ↗](/java/concurrenthashmap-internals/) | ⭐⭐⭐ Hard |
| Deep Dive: JVM Memory and GC Tuning | [Open ↗](/java/jvm-memory-and-gc-tuning/) | ⭐⭐⭐ Hard |
| Default Methods and the Diamond Problem | [Open ↗](/java/default-methods-diamond/) | ⭐⭐⭐ Hard |
| Design Patterns in Builder, Factory, Singleton, Observer | [Open ↗](/java/design-patterns/) | ⭐ Easy |
| Enum Internals and Performance | [Open ↗](/java/enum-internals/) | ⭐ Easy |
| EnumMap and EnumSet Performance | [Open ↗](/java/enumset-enummap-performance/) | ⭐⭐⭐ Hard |
| Final vs. Finally vs. Finalize | [Open ↗](/java/final-finally-finalize/) | ⭐ Easy |
| Finalizer vs. Cleaners | [Open ↗](/java/finalizer-cleaners/) | ⭐⭐ Medium |
| ForkJoinPool Internals | [Open ↗](/java/fork-join-pool/) | ⭐⭐ Medium |
| ForkJoinPool vs. ThreadPoolExecutor | [Open ↗](/java/forkjoinpool-vs-threadpool/) | ⭐ Easy |
| Functional Interface Internals | [Open ↗](/java/functional-interfaces-internals/) | ⭐⭐⭐ Hard |
| HashMap Internals and Resizing | [Open ↗](/java/hashmap-internals/) | ⭐⭐ Medium |
| Instanceof vs. GetClass() | [Open ↗](/java/instanceof-vs-getclass/) | ⭐⭐ Medium |
| Internal vs. External Iterators | [Open ↗](/java/internal-vs-external-iterators/) | ⭐⭐⭐ Hard |
| JVM Internals & Memory Management | [Open ↗](/java/jvm-internals/) | ⭐⭐⭐ Hard |
| Java 17+ Features: Records, Sealed Classes, Pattern Matching | [Open ↗](/java/java-modern-features/) | ⭐ Easy |
| Java 8 Stream vs. ParallelStream | [Open ↗](/java/stream-parallelism/) | ⭐⭐ Medium |
| Java ClassLoader and Reflection | [Open ↗](/java/classloader-reflection/) | ⭐⭐ Medium |
| Java Concurrency Basics | [Open ↗](/java/concurrency/) | ⭐⭐⭐ Hard |
| Java Flight Recorder (JFR) Internals | [Open ↗](/java/jfr-flight-recorder-internals/) | ⭐ Easy |
| Java Generics and Type Erasure | [Open ↗](/java/generics-type-erasure/) | ⭐⭐⭐ Hard |
| Java Memory Model (JMM) Happens-Before | [Open ↗](/java/jmm-happens-before/) | ⭐⭐ Medium |
| Java Memory Model and Happens-Before | [Open ↗](/java/java-memory-model/) | ⭐⭐⭐ Hard |
| Java Optional and Null Safety | [Open ↗](/java/java-optional/) | ⭐⭐⭐ Hard |
| Java Streams and Functional Programming | [Open ↗](/java/java-streams/) | ⭐⭐⭐ Hard |
| LongAdder vs. AtomicLong | [Open ↗](/java/longadder-vs-atomiclong/) | ⭐⭐ Medium |
| Low-latency G1 GC Tuning | [Open ↗](/java/g1gc-latency-tuning/) | ⭐ Easy |
| Marker Interfaces vs. Annotations | [Open ↗](/java/marker-interfaces-vs-annotations/) | ⭐⭐⭐ Hard |
| Method Handles vs. Reflection | [Open ↗](/java/method-handles/) | ⭐⭐⭐ Hard |
| MethodHandles vs. Reflection | [Open ↗](/java/methodhandles-vs-reflection/) | ⭐⭐ Medium |
| PhantomReferences (Cleanups) | [Open ↗](/java/phantom-references-detailed/) | ⭐⭐⭐ Hard |
| ProcessBuilder vs. Runtime.exec | [Open ↗](/java/processbuilder-vs-runtime/) | ⭐⭐ Medium |
| Records (Java 16+) | [Open ↗](/java/records-detailed/) | ⭐⭐ Medium |
| ReferenceQueue and Post-mortem Cleanup | [Open ↗](/java/reference-queue/) | ⭐⭐ Medium |
| SOLID Principles with Real-World Java | [Open ↗](/java/solid-principles/) | ⭐⭐ Medium |
| Sealed Classes (Java 17) | [Open ↗](/java/sealed-classes/) | ⭐⭐ Medium |
| SerialVersionUID and Versioning | [Open ↗](/java/serialversionuid-detailed/) | ⭐⭐ Medium |
| Service Provider Interface (SPI) | [Open ↗](/java/spi-internals/) | ⭐⭐⭐ Hard |
| Shallow vs. Deep Copy | [Open ↗](/java/shallow-vs-deep-copy/) | ⭐⭐⭐ Hard |
| Spliterators (Java 8+) | [Open ↗](/java/spliterators-detailed/) | ⭐⭐ Medium |
| StampedLock vs. ReadWriteLock | [Open ↗](/java/stampedlock-optimistic-read/) | ⭐⭐ Medium |
| String Deduplication vs. Interning | [Open ↗](/java/string-deduplication-interning/) | ⭐⭐ Medium |
| The Unsafe Class | [Open ↗](/java/unsafe-and-varhandles/) | ⭐ Easy |
| This vs. Super | [Open ↗](/java/this-vs-super/) | ⭐⭐ Medium |
| Thread Pools and ExecutorService Internals | [Open ↗](/java/thread-pool-internals/) | ⭐⭐ Medium |
| Thread.interrupt() and Cleanup | [Open ↗](/java/thread-interruption/) | ⭐⭐ Medium |
| Thread.onSpinWait() (High Latency) | [Open ↗](/java/thread-onspinwait-optimization/) | ⭐⭐ Medium |
| ThreadLocal Leaks | [Open ↗](/java/threadlocal-leaks/) | ⭐⭐ Medium |
| ThreadLocal vs. InheritableThreadLocal | [Open ↗](/java/inheritable-threadlocal/) | ⭐⭐⭐ Hard |
| ThreadLocalRandom vs. Random | [Open ↗](/java/threadlocalrandom-performance/) | ⭐ Easy |
| Transient vs. Volatile | [Open ↗](/java/transient-vs-volatile/) | ⭐⭐ Medium |
| VarHandle Internals (Expert) | [Open ↗](/java/varhandle-internals/) | ⭐⭐⭐ Hard |
| Virtual Threads (Project Loom) | [Open ↗](/java/virtual-threads-loom/) | ⭐⭐⭐ Hard |
| Volatile vs. Atomic | [Open ↗](/java/volatile-vs-atomic/) | ⭐ Easy |
| Weak, Soft, and Phantom References | [Open ↗](/java/reference-types/) | ⭐ Easy |
| WeakHashMap and GC Internals | [Open ↗](/java/weak-hashmap/) | ⭐⭐⭐ Hard |
| Yield vs. Sleep | [Open ↗](/java/thread-yield-vs-sleep/) | ⭐⭐ Medium |
