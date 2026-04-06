---
author: "sagar ved"
title: "Java: Default Methods and the Diamond Problem"
date: 2024-04-04
draft: false
weight: 39
---

# 🧩 Question: How does Java 8+ handle the Diamond Problem with Default Methods in Interfaces?

## 🎯 What the interviewer is testing
- Multiple inheritance mechanics in Java.
- Conflict resolution rules.
- Evolution of Interface design.

---

## 🧠 Deep Explanation

### 1. The Conflict:
Java allows a class to implement multiple interfaces. If `Interface A` and `Interface B` both define a default method with the **same signature**, a class implementing both has a conflict.

### 2. Resolution Rules:
- **Rule 1: Class Wins**: If the class or a superclass implements a method, it always overrides any interface default method.
- **Rule 2: Sub-interface Wins**: If there is no class-level implementation, the most specific (lowest in the hierarchy) sub-interface wins.
- **Rule 3: Compiler Error (Manual Resolution)**: If there is a tie between two independent interfaces, the compiler forces the user to manually override and choose:
  ```java
  public void sharedMethod() {
      InterfaceA.super.sharedMethod(); // Explicitly choose A
  }
  ```

---

## ✅ Ideal Answer
Java resolves interface method conflicts using clear rules: classes override interfaces, and sub-interfaces override their parents. In the event of a true ambiguity between sibling interfaces, the compiler requires the developer to explicitly override the method and specify which parent's implementation to follow using the `InterfaceName.super` syntax.

---

## 💻 Java Code
```java
interface A {
    default void hello() { System.out.println("Hello from A"); }
}

interface B {
    default void hello() { System.out.println("Hello from B"); }
}

public class DiamondResolver implements A, B {
    // Fails to compile without this override:
    @Override
    public void hello() {
        A.super.hello(); // Or custom logic
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can default methods be final?** (No, they are for extension.)
2. **Why were they added?** (To evolve libraries like Java Streams without breaking existing implementations of interfaces like `List`.)
3. **Difference between `default` methods in Interfaces vs methods in Abstract Classes?** (Abstract classes can have state [fields]; interfaces cannot.)
