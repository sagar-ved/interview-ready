---
author: "sagar ved"
title: "Java 17+ Features: Records, Sealed Classes, Pattern Matching"
date: 2024-04-04
draft: false
weight: 14
---

# 🧩 Question: How do Java Records, Sealed Classes, and Pattern Matching for `instanceof` improve domain modeling? Use an order processing system as your example.

## 🎯 What the interviewer is testing
- Modern Java features and their real-world usage
- Sealed class hierarchy for exhaustive modeling
- Record immutability and auto-generated methods
- Pattern matching reducing boilerplate

---

## 🧠 Deep Explanation

### Records (Java 16+)
Concise immutable data carriers. Auto-generates: constructor, getters, `equals()`, `hashCode()`, `toString()`.

### Sealed Classes (Java 17+)
Restrict which classes can extend/implement a class. Enables **exhaustive `switch`** expressions.

### Pattern Matching for `instanceof` (Java 16+)
Eliminates cast boilerplate: `if (shape instanceof Circle c)` — c is automatically bound.

### Switch Expressions + Pattern (Java 21)
Full pattern matching in switch: type patterns, guard patterns, null handling.

---

## 💻 Java Code

```java
// ======= Records: Immutable Domain Objects =======
record Money(double amount, String currency) {
    Money { // Compact constructor for validation
        if (amount < 0) throw new IllegalArgumentException("Amount cannot be negative");
    }

    public Money add(Money other) {
        if (!currency.equals(other.currency)) throw new IllegalArgumentException("Currency mismatch");
        return new Money(amount + other.amount, currency);
    }
}

record Address(String street, String city, String country) {}
record Customer(String id, String name, Address shippingAddress) {}
record OrderItem(String productId, int quantity, Money unitPrice) {
    public Money lineTotal() { return new Money(unitPrice.amount() * quantity, unitPrice.currency()); }
}

// ======= Sealed Classes: Exhaustive Order Status =======
sealed interface OrderStatus permits
    OrderStatus.Pending,
    OrderStatus.PaymentConfirmed,
    OrderStatus.Shipped,
    OrderStatus.Delivered,
    OrderStatus.Cancelled {

    record Pending(String orderId) implements OrderStatus {}
    record PaymentConfirmed(String orderId, String transactionId) implements OrderStatus {}
    record Shipped(String orderId, String trackingNumber, java.time.LocalDate estimatedDelivery) implements OrderStatus {}
    record Delivered(String orderId, java.time.LocalDate deliveredDate) implements OrderStatus {}
    record Cancelled(String orderId, String reason) implements OrderStatus {}
}

// ======= Switch Expression with Pattern Matching =======
public class OrderProcessor {

    public String getStatusMessage(OrderStatus status) {
        return switch (status) {
            case OrderStatus.Pending(var id) -> "Order " + id + " is awaiting payment";
            case OrderStatus.PaymentConfirmed(var id, var txn) ->
                "Payment confirmed (txn: " + txn + ") — processing order " + id;
            case OrderStatus.Shipped(var id, var tracking, var eta) ->
                "Shipping! Track: " + tracking + ". ETA: " + eta;
            case OrderStatus.Delivered(var id, var date) ->
                "Delivered on " + date + ". Enjoy!";
            case OrderStatus.Cancelled(var id, var reason) ->
                "Order " + id + " cancelled: " + reason;
            // Compiler guarantees exhaustiveness — no default needed!
        };
    }

    // Pattern matching instanceof — no cast needed
    public double calculateDiscount(Object eligibility) {
        if (eligibility instanceof Customer customer && customer.id().startsWith("VIP")) {
            return 0.15; // 15% VIP discount
        }
        if (eligibility instanceof String promoCode && promoCode.startsWith("SAVE")) {
            return 0.10;
        }
        return 0.0;
    }

    public static void main(String[] args) {
        OrderProcessor processor = new OrderProcessor();

        OrderStatus status = new OrderStatus.Shipped(
            "ORD-001", "FEDEX123456", java.time.LocalDate.now().plusDays(2)
        );
        System.out.println(processor.getStatusMessage(status));

        // Records: auto-generated equals, hashCode, toString
        Money price1 = new Money(100.0, "INR");
        Money price2 = new Money(100.0, "INR");
        System.out.println(price1.equals(price2)); // true — value equality
        System.out.println(price1); // Money[amount=100.0, currency=INR]
    }
}
```

---

## ⚠️ Common Mistakes
- Records ARE NOT beans: no setters, constructors can't be no-arg by default (breaks Jackson unless configured)
- Sealed classes must be in the same compilation unit (same package or nested)
- Missing `default` in switch on non-sealed types — compiler will warn
- Using `instanceof` pattern with `&&` chaining (guarded patterns require Java 21+ switch syntax in some cases)

---

## 🔄 Follow-up Questions
1. **How do you serialize Java Records with Jackson?** (Works out of the box with Jackson 2.12+. For older: use `@JsonProperty` on compact constructor parameters.)
2. **What is the difference between sealed interface and enum?** (Enum: fixed set of constants; same type. Sealed: fixed set of TYPES, each can have different fields and behavior.)
3. **How does pattern matching relate to functional languages?** (Algebraic Data Types + exhaustive pattern matching are core to Haskell, Scala, Rust — Java is catching up.)
