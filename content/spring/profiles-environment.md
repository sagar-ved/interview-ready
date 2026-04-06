---
author: "sagar ved"
title: "Spring: Profiles and Environment Config"
date: 2024-04-04
draft: false
weight: 11
---

# 🧩 Question: How do Spring Profiles allow for environment-specific configurations? What occurs when no profile is active?

## 🎯 What the interviewer is testing
- Separation of concerns between environments (Dev, Test, Prod).
- Bean conditional registration.
- Knowledge of the "Default" profile.

---

## 🧠 Deep Explanation

### 1. The Strategy:
Spring Profiles let you isolate parts of your application configuration and make them available only in certain environments.
- **Properties**: `application-dev.properties`, `application-prod.properties`.
- **Beans**: `@Profile("dev")`.

### 2. Activation:
Profiles can be activated via:
- **Properties**: `spring.profiles.active=dev` in `application.properties`.
- **Env Variables**: `export SPRING_PROFILES_ACTIVE=prod`.
- **System Properties**: `-Dspring.profiles.active=test`.

### 3. The Default Profile:
If no profile is active, Spring uses the profile named **`default`**. Any bean with NO `@Profile` annotation is always active.

---

## ✅ Ideal Answer
Spring Profiles provide a robust way to switch entire application states without changing the code. By tagging specific beans or configuration files with profile names, we can ensure that a production database connection is never accidentally used during local development. For a senior developer, the key is using profiles to manage varying external dependencies while maintaining a single, consistent build artifact for all environments.

---

## 🏗️ Code Example:
```java
@Configuration
@Profile("prod")
public class ProdConfig {
    @Bean
    public DataSource dataSource() {
        // High-performance connection pool
    }
}
```

---

## 🔄 Follow-up Questions
1. **Can you activate multiple profiles?** (Yes, e.g., `dev,swagger,h2`.)
2. **What is `@ActiveProfiles`?** (Used in integration tests to force a specific environment profile for the test context.)
3. **Difference between `YAML` and `.properties` for profiles?** (YAML allows storing multiple profiles in a single file using the `---` separator, making it cleaner for large configs.)
