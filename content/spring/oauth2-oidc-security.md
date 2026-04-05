---
title: "Spring Security: OAuth2 and OIDC"
date: 2024-04-04
draft: false
weight: 30
---

# 🧩 Question: What is the difference between OAuth2 and OpenID Connect (OIDC)? How does Spring Security handle them?

## 🎯 What the interviewer is testing
- Difference between Authorization and Identification.
- Knowledge of JWT and ID Tokens.
- Modern security delegation patterns.

---

## 🧠 Deep Explanation

### 1. OAuth2 (Authorization):
- **Goal**: Give the app permission to access resources on the user's behalf (e.g. "Let this app see my Google Calendar").
- **Key**: **Access Token**.

### 2. OIDC (Identification):
- **Goal**: Prove WHO the user is (Login). It's a layer ON TOP of OAuth2.
- **Key**: **ID Token** (Always a JWT).

### 3. Spring Security Integration:
`@EnableWebSecurity` + `oauth2Login()`.
- Spring handles the "Dance": Redirection to provider (Google/Okta), code exchange, and token validation.
- It exposes the user as `OAuth2User` or `OidcUser` in the SecurityContext.

---

## ✅ Ideal Answer
While OAuth2 handles the permissions for what an application can DO, OIDC defines the standard for identifying WHO a user actually is. Spring Security simplifies this complex negotiation by managing the redirection and token verification logic out-of-the-box. For a modern enterprise architecture, offloading this responsibility to a centralized identity provider via OIDC is the most secure and scalable way to manage user access across multiple platforms.

---

## 🔄 Follow-up Questions
1. **What is the `UserInfo` endpoint?** (A secure URL at the provider where Spring can fetch extra user details [email, name] using the access token.)
2. **Scopes?** (Permissions requested [e.g. `openid`, `profile`, `email`].)
3. **What is "Token Relay"?** (When one microservice passes its Access Token to another service to maintain the user's authority across the network.)
