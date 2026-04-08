---
author: "sagar ved"
title: "Design Patterns Interview Questions"
date: 2024-04-08
draft: false
---

# 📝 Comprehensive Design Patterns Interview Questions

This document contains a very detailed list of frequently asked Design Pattern questions along with concise, high-yield answers tailored for SDE-2 interviews.

---

### Creational Patterns

#### 1. How do you implement a thread-safe Singleton in Java? Why is Double-Checked Locking necessary?
**Answer:**
A thread-safe Singleton uses double-checked locking accompanied by the `volatile` keyword.
```java
public class Singleton {
    private static volatile Singleton instance;
    private Singleton() {}
    public static Singleton getInstance() {
        if (instance == null) { // First check (no locking yet)
            synchronized (Singleton.class) {
                if (instance == null) { // Second check (with locking)
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```
`volatile` is critical because it ensures that changes to the `instance` variable are published sequentially to other threads without instruction reordering.

#### 2. What is the difference between a Factory Method and an Abstract Factory?
**Answer:**
- **Factory Method:** Relies on inheritance. A superclass defines an interface for creating an object, but delegates the actual creation to its subclasses. It creates exactly **one** product.
- **Abstract Factory:** Relies on object composition. It provides an interface for creating **families** of related or dependent objects. It creates **multiple** products that belong together (e.g., MacButton and MacCheckbox vs. WinButton and WinCheckbox).

#### 3. When should you use the Builder pattern instead of a Constructor with many parameters (Telescoping Constructor Anti-pattern)?
**Answer:**
When an object requires multiple configurations, using a constructor with many parameters leads to unreadable code where it's easy to mix up parameters of the same type. The Builder pattern extracts object construction code to a separate class, enabling fluent, step-by-step initialization (often seen with Lombok's `@Builder`).

---

### Structural Patterns

#### 4. Can you explain the Decorator Pattern? How does it differ from Inheritance?
**Answer:**
The Decorator pattern allows you to attach new behaviors to objects dynamically by placing them inside special wrapper objects that contain the behaviors.
**Difference from Inheritance:** Inheritance is static and applies to an entire class. A Decorator is applied at runtime to specific instances without altering the underlying class. (Classic example: Java's I/O framework like `new BufferedReader(new FileReader(file))`).

#### 5. How are the Proxy pattern and Facade pattern different?
**Answer:**
- **Proxy:** Intercepts method calls to another object to add functionality like lazy loading, access control, or caching. It perfectly implements the *exact same interface* as the target object.
- **Facade:** Provides a simplified, higher-level interface over a complex subsystem. It does not implement the subsystem's interface; it *wraps* it to make it easier to use (e.g., an API Gateway in microservices).

#### 6. Provide a real-world example of the Adapter pattern.
**Answer:**
The Adapter pattern works like a power adapter; it lets objects with incompatible interfaces collaborate. 
**Real-World Example:** Transitioning a legacy system to a newer analytics API. The legacy system passes data as XML, but the new API requires JSON. You create an `AnalyticsAdapter` that takes XML from the legacy system, converts it to JSON, and passes it to the new analytics service engine.

---

### Behavioral Patterns

#### 7. Compare the Strategy Pattern and the State Pattern. They appear very similar.
**Answer:**
Structurally, they are nearly identical (both rely on composition and delegate work to interchangeable objects).
- **Strategy:** The client entirely dictates the strategy to use. Strategies are independent and usually unaware of each other (e.g., executing payment via PayPal vs. CreditCard).
- **State:** The context object transitions between states automatically. The states are fully aware of each other and dictate the transition rules based on their internal logic (e.g., Vending Machine transitioning from `NoCoinState` to `HasCoinState`).

#### 8. How does the Observer Pattern apply to modern Pub/Sub systems like Kafka?
**Answer:**
The standard GOF Observer pattern attaches Observers directly to a Subject, meaning the Subject manages the list of Observers (coupling). In modern Pub-Sub models (like Kafka or RabbitMQ), an intermediary Message Broker completely decouples the Publishers from the Subscribers. Publishers just push events, and Subscribers pull/receive them independently, making it a scalable, distributed evolution of the classic Observer.

#### 9. What is the Command Pattern? How is it useful for Undo/Redo operations?
**Answer:**
The Command pattern encapsulates a request into a standalone context object containing all information about the request. 
For Undo/Redo functionality, you implement an `undo()` method inside every Command object. As commands are executed, they are stored in a Stack. To undo, you simply pop the last command off the stack and invoke its `undo()` method.

---

### Advanced / Hybrid Topics

#### 10. How do modern Dependency Injection frameworks (like Spring) implement patterns?
**Answer:**
- **Singleton Pattern:** By default, Spring beans are strictly managed as Singletons in the ApplicationContext.
- **Factory Pattern:** `BeanFactory` and `ApplicationContext` apply standard Factory configurations.
- **Proxy Pattern:** Any `@Transactional`, `@Async`, or AOP annotations result in Spring dynamically generating a Proxy class around your object to inject the database transaction/aspect logic at runtime.
