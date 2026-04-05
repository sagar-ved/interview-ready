---
title: "Spring Boot: Custom Starters"
date: 2024-04-04
draft: false
weight: 15
---

# 🧩 Question: How do you build a Custom Spring Boot Starter? When is it better than a simple Shared Library?

## 🎯 What the interviewer is testing
- Large-scale engineering patterns (Platform Engineering).
- Scaling "Shared Logic" across 100s of microservices.
- Mastery of auto-configuration.

---

## 🧠 Deep Explanation

### 1. The Starter Concept:
A Starter is more than a library; it's a **"Feature Package"** that configures itself.
- **Library**: You add the Jar, then you must manually add `@Bean` or `@ComponentScan` to use it.
- **Starter**: You add the Jar, and its features are **automatically ready**.

### 2. The Components:
1. **Library Module**: The actual logic (e.g., a "Security Audit" service).
2. **Auto-configuration Module**: 
   - A `@Configuration` class.
   - Using `@Conditional` to only activate if needed.
   - A `spring.factories` file to register it.

### 3. Use Case:
Imagine you are at Netflix. You want every team to use the SAME logging format and the SAME security filter. You build a `netflix-logging-starter`, and teams just include it in their `pom.xml`.

---

## ✅ Ideal Answer
Custom starters are the ultimate tool for organizational DRY (Don't Repeat Yourself). While a shared library merely provides code, a starter provides an automated ecosystem—configuring beans, security, and monitoring based on the application's environment. This "plug-and-play" capability ensures that common standards are enforced across hundreds of services with minimal manual intervention, dramatically reducing the time to market for new microservices.

---

## 🔄 Follow-up Questions
1. **What is `spring-configuration-metadata.json`?** (Helps IDEs provide autocomplete for YOUR starter properties in `application.properties`.)
2. **Why separate logic and auto-configure?** (Separation of concerns. You might want to use the logic in a non-Spring app one day.)
3. **What is the "Naming Convention"?** (Spring's own are `spring-boot-starter-NAME`; custom ones should be `NAME-spring-boot-starter`.)
