---
author: "sagar ved"
title: "Spring Boot: Auto-configuration Internals"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: How does Spring Boot's Auto-configuration work? Explain `@EnableAutoConfiguration` and `spring.factories`.

## 🎯 What the interviewer is testing
- "Magic" behind Spring Boot (Decoupling logic).
- Conditional bean loading.
- Knowledge of the `META-INF/spring.factories` (or new `org.springframework.boot.autoconfigure.AutoConfiguration.imports`) mechanism.

---

## 🧠 Deep Explanation

### 1. The @SpringBootApplication Trigger:
`@SpringBootApplication` is a triad: `@Configuration`, `@ComponentScan`, and **`@EnableAutoConfiguration`**.

### 2. The Discovery Mechanism:
`@EnableAutoConfiguration` uses `AutoConfigurationImportSelector`. 
- It scans the classpath for a file: `META-INF/spring.factories` (Legacy) or `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports` (Spring Boot 3+).
- This file lists all potential configuration classes (e.g., `DataSourceAutoConfiguration`).

### 3. The Filtering (Conditional):
Even if 100 configurations are found, they aren't all loaded. Each uses `@Conditional` annotations:
- **`@ConditionalOnClass`**: Only load if `DataSource.class` is in the classpath.
- **`@ConditionalOnMissingBean`**: Only load if the USER didn't already define their own DataSource.
- **`@ConditionalOnProperty`**: Only load if a specific property is set in `application.properties`.

---

## ✅ Ideal Answer
Spring Boot auto-configuration is a "predictive" bean management system. It doesn't find beans blindly; instead, it looks for specific "Starters" in the classpath and uses the `spring.factories` registry to identify potential configurations. By applying strict `@Conditional` logic, Spring Boot ensures that it only initializes components when their dependencies are present and when the developer hasn't already provided a custom override, adhering to the "Opinionated but Flexible" philosophy.

---

## 🔄 Follow-up Questions
1. **How to exclude an auto-configuration?** (Use `@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})`.)
2. **What is the `spring-boot-starter-parent` role?** (It provides dependency management, pinning versions of common libraries to ensure compatibility.)
3. **Difference between `@Configuration` and `@Component`?** (`@Configuration` classes are proxied [CGLIB] to ensure that multiple calls to `@Bean` methods return the same singleton instance.)
