---
title: "Spring Security: Filter Chain Internals"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: How does Spring Security work? What is the `DelegatingFilterProxy` and the `FilterChainProxy`?

## 🎯 What the interviewer is testing
- Bridging Servlet container and Spring context.
- Understanding the "Chain of Responsibility" pattern.
- Authentication vs Authorization logic flow.

---

## 🧠 Deep Explanation

### 1. DelegatingFilterProxy (The Bridge):
Spring Security is managed by Spring, but incoming requests come from the **Servlet Container (Tomcat)**. Tomcat doesn't know about Spring beans.
- `DelegatingFilterProxy` is a standard Servlet filter that simply forwards all requests to a real Spring Bean named `springSecurityFilterChain`.

### 2. FilterChainProxy (The Manager):
This bean contains a list of `SecurityFilterChain` objects. 
- It acts as the entries point into the security logic. 
- It decides which "Chain" of specific filters (e.g. `UsernamePasswordAuthenticationFilter`, `FilterSecurityInterceptor`) should handle the request based on the URL.

### 3. The Core Filter Loop:
1. `SecurityContextPersistenceFilter`: Loads the SecurityContext from Session.
2. `LogoutFilter`.
3. `Authentication Filters`: Check credentials, create `Authentication` object, and put it in `SecurityContextHolder`.
4. `ExceptionTranslationFilter`: Catch security exceptions (401/403) and decide what to do.
5. `FilterSecurityInterceptor`: The final guard. Checks if the current authenticated user has the "ROLES" required for the URL.

---

## ✅ Ideal Answer
Spring Security operates as a series of specialized Servlet filters that intercept and validate incoming requests before they reach your controllers. By using the `DelegatingFilterProxy`, Spring seamlessly integrates its complex security beans into the standard web container. For senior developers, the key is understanding the `SecurityContextHolder`—it is a thread-local storage that makes the user's authentication state globally accessible throughout the request lifecycle.

---

## 🔄 Follow-up Questions
1. **What is `SecurityContextPersistenceFilter` role?** (It ensures the user's logged-in status persists across multiple HTTP requests via the HttpSession.)
2. **Stateless (JWT) vs Stateful?** (In JWT, we disable session creation and use a filter to populate the SecurityContext on every single request from the token.)
3. **How to perform Method-Level Security?** (Use `@EnableGlobalMethodSecurity` and `@PreAuthorize`. This uses AOP Proxies rather than Servlet Filters.)
