---
author: "sagar ved"
title: "Design Patterns in Java: Builder, Factory, Singleton, Observer"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: Your team needs to build a notification service that currently sends SMS but should support Email, WhatsApp, and Push Notifications in the future. Design this using appropriate patterns, and explain your choices.

## 🎯 What the interviewer is testing
- Applying design patterns to extensible designs
- Open/Closed Principle (OCP) in real systems
- Factory Method vs Abstract Factory
- Singleton for service management

---

## 🧠 Deep Explanation

### 1. Factory Method Pattern

Create objects without specifying the exact class. The factory decides which concrete class to instantiate based on input.

**Use when**: The exact type isn't known at compile time; new types can be added without changing existing code.

### 2. Builder Pattern

Separate construction of complex objects from their representation. 

**Use when**: Objects have many optional parameters (avoids telescoping constructors).

### 3. Observer Pattern

One-to-many dependency: when the subject changes, all observers are notified.

**Use when**: Decoupled event-driven systems (notification systems, event buses).

### 4. Singleton Pattern (Thread-Safe)

Ensure only one instance exists. Use `volatile` + double-checked locking or the Initialization-on-demand holder idiom.

---

## ✅ Ideal Answer

- Use **Factory Pattern** to create the right notification channel (SMS, Email, Push) based on user preference.
- Use **Builder Pattern** for the `Notification` object which has many optional fields (subject, body, priority, metadata).
- Use **Observer Pattern** for the event-driven notification lifecycle (sent, failed, retried).
- Use **Singleton** for the `NotificationService` managing channels and retry queues.

---

## 💻 Java Code

```java
import java.util.*;

// ====== Strategy / Factory ======

public interface NotificationChannel {
    void send(Notification notification);
}

public class EmailChannel implements NotificationChannel {
    @Override
    public void send(Notification n) {
        System.out.printf("Email → %s | Subject: %s%n", n.recipient(), n.subject());
    }
}

public class SMSChannel implements NotificationChannel {
    @Override
    public void send(Notification n) {
        System.out.printf("SMS → %s | Body: %s%n", n.recipient(), n.body());
    }
}

// Factory: creates the right channel type
public class ChannelFactory {
    private static final Map<String, NotificationChannel> registry = new HashMap<>();

    static {
        registry.put("EMAIL", new EmailChannel());
        registry.put("SMS", new SMSChannel());
        // Adding Push doesn't require changing this class if we use a registry
    }

    public static void register(String type, NotificationChannel channel) {
        registry.put(type.toUpperCase(), channel);
    }

    public static NotificationChannel get(String type) {
        NotificationChannel channel = registry.get(type.toUpperCase());
        if (channel == null) throw new IllegalArgumentException("Unknown channel: " + type);
        return channel;
    }
}

// ====== Builder Pattern ======

public class Notification {
    private final String recipient;
    private final String subject;
    private final String body;
    private final int priority;

    private Notification(Builder builder) {
        this.recipient = builder.recipient;
        this.subject = builder.subject;
        this.body = builder.body;
        this.priority = builder.priority;
    }

    public String recipient() { return recipient; }
    public String subject() { return subject; }
    public String body() { return body; }
    public int priority() { return priority; }

    public static class Builder {
        private final String recipient; // Required
        private String subject = "";
        private String body = "";
        private int priority = 5;

        public Builder(String recipient) { this.recipient = recipient; }
        public Builder subject(String s) { this.subject = s; return this; }
        public Builder body(String b) { this.body = b; return this; }
        public Builder priority(int p) { this.priority = p; return this; }
        public Notification build() { return new Notification(this); }
    }
}

// ====== Observer Pattern for events ======

public interface NotificationListener {
    void onSent(Notification n);
    void onFailed(Notification n, Exception e);
}

// ====== Singleton Service ======

public class NotificationService {
    private static volatile NotificationService instance;
    private final List<NotificationListener> listeners = new ArrayList<>();

    private NotificationService() {}

    // Initialization-on-demand holder idiom (thread-safe, no volatile needed)
    private static class Holder {
        static final NotificationService INSTANCE = new NotificationService();
    }

    public static NotificationService getInstance() {
        return Holder.INSTANCE;
    }

    public void addListener(NotificationListener l) { listeners.add(l); }

    public void send(String channelType, Notification notification) {
        try {
            ChannelFactory.get(channelType).send(notification);
            listeners.forEach(l -> l.onSent(notification));
        } catch (Exception e) {
            listeners.forEach(l -> l.onFailed(notification, e));
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Using `Singleton` where dependency injection (Spring `@Component`) is more testable
- Implementing `Singleton` without `volatile` (double-checked locking race condition)
- Hardcoding channel types in a `switch` instead of a registry (violates OCP)
- Forgetting to implement `hashCode + equals` on Builder output classes for testing

---

## 🔄 Follow-up Questions
1. **How would you add retry logic to the notification service?** (Decorator pattern — wrap `NotificationChannel` with a `RetryableChannel` that retries on failure.)
2. **Singleton vs Spring `@Bean` — which do you prefer in production?** (Spring `@Bean`/`@Component` — testable, injectable, lifecycle-managed. Raw Singleton is an anti-pattern in Spring apps.)
3. **How would the Observer pattern differ from an event bus?** (Event bus decouples further — publisher doesn't know observers at all; events are dispatched via a central broker like Guava EventBus or Spring ApplicationEventPublisher.)
