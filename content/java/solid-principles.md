---
author: "sagar ved"
title: "SOLID Principles with Real-World Java"
date: 2024-04-04
draft: false
weight: 12
---

# 🧩 Question: A PaymentService class has 500 lines of code handling Stripe, PayPal, bank transfers, logging, and validation all in one place. Refactor it to follow SOLID principles.

## 🎯 What the interviewer is testing
- SOLID principles with concrete Java examples
- Identifying violations in existing code
- Extensibility without modification (OCP)
- Dependency Inversion for testability

---

## 🧠 Deep Explanation

### 1. Single Responsibility (SRP)

A class should have only ONE reason to change.

**Violation**: `PaymentService` changes when: payment gateway changes, logging format changes, validation rules change, fee calculation changes → 4 reasons to change.

**Fix**: Split into `StripeGateway`, `PaymentLogger`, `PaymentValidator`, `FeeCalculator`.

### 2. Open/Closed Principle (OCP)

Open for extension, closed for modification.

**Violation**: `switch (paymentMethod) { case "STRIPE": ... case "PAYPAL": ... }` — adding PayTM requires modifying this class.

**Fix**: `PaymentGateway` interface — adding PayTM = adding a new class, no modification.

### 3. Liskov Substitution (LSP)

Subtypes must be substitutable for their base types without breaking the program.

**Violation**: `CreditCard extends Card` but `CreditCard.debit()` throws for cards without credit limit — violates LSP.

### 4. Interface Segregation (ISP)

Clients shouldn't be forced to depend on interfaces they don't use.

**Violation**: `UserService` interface with `createUser()`, `deleteUser()`, `sendEmail()`, `generateReport()` — not all clients need all methods.

### 5. Dependency Inversion (DIP)

High-level modules should depend on abstractions, not concrete implementations.

**Violation**: `PaymentService` has `new StripeClient()` inside.

**Fix**: Inject `PaymentGateway` interface via constructor — enables mocking in tests.

---

## 💻 Java Code

```java
// ===== BEFORE: SRP Violation =====
// Bad: 500 line class with 5 concerns
class BadPaymentService {
    public void processPayment(String method, double amount) {
        // Validate
        if (amount <= 0) throw new IllegalArgumentException("Invalid amount");

        // Calculate fees
        double fee = method.equals("STRIPE") ? amount * 0.029 : amount * 0.021;

        // Process via gateway
        if (method.equals("STRIPE")) { /* Stripe API calls */ }
        else if (method.equals("PAYPAL")) { /* PayPal API calls */ }

        // Log
        System.out.println("Processed payment of " + amount);
    }
}

// ===== AFTER: SOLID Compliant =====

// SRP: Each class has ONE responsibility
interface PaymentGateway {  // OCP: extend by adding, not modifying
    PaymentResult charge(double amount, String currency);
    String getName();
}

class StripeGateway implements PaymentGateway {
    private final StripeClient client;

    StripeGateway(StripeClient client) { this.client = client; } // DIP: inject, don't instantiate

    @Override
    public PaymentResult charge(double amount, String currency) {
        return client.charge(amount, currency); // Delegate to real SDK
    }

    @Override
    public String getName() { return "STRIPE"; }
}

class PayPalGateway implements PaymentGateway {
    @Override
    public PaymentResult charge(double amount, String currency) {
        // PayPal integration
        return new PaymentResult(true, "pp_" + System.currentTimeMillis());
    }

    @Override
    public String getName() { return "PAYPAL"; }
}

// ISP: Small, focused interfaces
interface PaymentValidator {
    void validate(PaymentRequest request);
}

interface FeeCalculator {
    double calculateFee(String gateway, double amount);
}

interface PaymentLogger {
    void logSuccess(PaymentRequest req, PaymentResult result);
    void logFailure(PaymentRequest req, Exception ex);
}

// High-level orchestrator — SRP + DIP
class PaymentService {
    private final Map<String, PaymentGateway> gateways; // OCP: registry, not switch
    private final PaymentValidator validator;
    private final FeeCalculator feeCalculator;
    private final PaymentLogger logger;

    // DIP: constructor injection — all dependencies are abstractions
    PaymentService(List<PaymentGateway> gateways, PaymentValidator validator,
                   FeeCalculator feeCalculator, PaymentLogger logger) {
        this.gateways = new HashMap<>();
        gateways.forEach(g -> this.gateways.put(g.getName(), g));
        this.validator = validator;
        this.feeCalculator = feeCalculator;
        this.logger = logger;
    }

    public PaymentResult process(PaymentRequest request) {
        validator.validate(request); // Delegate validation

        PaymentGateway gateway = gateways.get(request.gatewayName());
        if (gateway == null) throw new IllegalArgumentException("Unknown gateway: " + request.gatewayName());

        double totalAmount = request.amount() + feeCalculator.calculateFee(request.gatewayName(), request.amount());

        try {
            PaymentResult result = gateway.charge(totalAmount, request.currency());
            logger.logSuccess(request, result);
            return result;
        } catch (Exception e) {
            logger.logFailure(request, e);
            throw e;
        }
    }
}

// Supporting types
record PaymentRequest(String gatewayName, double amount, String currency) {}
record PaymentResult(boolean success, String transactionId) {}
interface StripeClient { PaymentResult charge(double amount, String currency); }
```

---

## ⚠️ Common Mistakes
- Thinking SOLID means "always create lots of interfaces" — premature abstraction is worse than SRP violation
- Violating LSP in inheritance hierarchies (throw exceptions for operations that don't apply to subclass)
- Not applying DIP in Spring applications (using `new ConcreteService()` instead of `@Autowired Interface`)

---

## 🔄 Follow-up Questions
1. **What is the Dependency Inversion Principle vs IoC vs DI?** (DIP: high depends on abstraction. IoC: framework controls object creation. DI: inject dependencies via constructor/setter/interface. Spring IoC container implements DI to achieve DIP.)
2. **Where do design patterns relate to SOLID?** (Strategy = OCP. Observer = DIP. Factory = DIP. Decorator = OCP + SRP.)
3. **When would you intentionally violate OCP?** (Prototyping, when extension points are unclear, or when the cost of premature abstraction exceeds the benefit.)
