---
title: "Network Security: REST API Security and Common Attacks"
date: 2024-04-04
draft: false
weight: 7
---

# 🧩 Question: Your APIs are being targeted. Walk me through the most common web attack vectors, how to defend against them, and how to design a secure REST API from the ground up.

## 🎯 What the interviewer is testing
- OWASP Top 10 awareness
- Authentication vs authorization patterns
- SQL injection and XSS prevention
- JWT security and OAuth 2.0 flows

---

## 🧠 Deep Explanation

### 1. OWASP Top 10 (2023) Highlights

| Attack | Defense |
|---|---|
| SQL Injection | Parameterized queries, ORM |
| Broken Authentication | MFA, secure token storage, proper session management |
| Sensitive Data Exposure | Encrypt at rest/transit, mask in logs |
| XML External Entity (XXE) | Disable external entity processing |
| Broken Access Control | RBAC, resource-level permissions |
| Security Misconfiguration | Security headers, disable debug mode |
| XSS (Cross-Site Scripting) | Output encoding, Content-Security-Policy |
| CSRF | SameSite cookies, CSRF tokens |
| Using Vulnerable Dependencies | Keep dependencies updated, SBOM |
| Insufficient Logging | Centralized logging + alerting |

### 2. JWT Security

Common JWT mistakes:
- Algorithm confusion: `alg: none` — verify the algorithm field
- Weak secrets: brute-forceable HMAC-SHA256 secrets
- No expiry: tokens valid forever
- Storing in localStorage — XSS can steal them (use httpOnly cookies instead)

### 3. SQL Injection

`SELECT * FROM users WHERE username = '` + input + `'`

Malicious input: `' OR 1=1 --` → Returns ALL users.

Defense: Always use parameterized queries or ORM.

### 4. Secure API Design Principles

1. **Authentication**: JWT/OAuth 2.0; validate on every request; short expiry (15 min)
2. **Authorization**: Check resource ownership, not just role
3. **Input Validation**: Server-side always; whitelist > blacklist
4. **HTTPS Only**: Enforce with HSTS header
5. **Rate Limiting**: Prevent brute force and DDoS
6. **Audit Logging**: Who did what, when, from where

---

## 💻 Java Code (Spring Security)

```java
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import java.sql.*;

/**
 * Secure API patterns in Java
 */
public class SecurityDemo {

    // ❌ SQL Injection Vulnerability
    public void unsafeQuery(Connection conn, String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = '" + username + "'"; // DANGEROUS
        Statement stmt = conn.createStatement();
        stmt.executeQuery(sql); // username = "admin'--" bypasses password check
    }

    // ✅ Safe: Parameterized Query
    public void safeQuery(Connection conn, String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?"; // Placeholder
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username); // Input treated as data, not SQL
            stmt.executeQuery();
        }
    }

    // ✅ JWT Validation with JJWT
    /*
    public Claims validateJWT(String token, String secret) {
        try {
            return Jwts.parserBuilder()
                .setSigningKey(Keys.hmacShaKeyFor(secret.getBytes()))
                .build()
                .parseClaimsJws(token) // Validates signature + expiry
                .getBody();
        } catch (ExpiredJwtException e) {
            throw new UnauthorizedException("Token expired");
        } catch (JwtException e) {
            throw new UnauthorizedException("Invalid token");
        }
    }
    */

    // ✅ Security headers (Spring Security config)
    /*
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .headers(headers -> headers
                .contentSecurityPolicy("default-src 'self'")     // Prevent XSS
                .frameOptions().deny()                            // Prevent clickjacking
                .httpStrictTransportSecurity()                    // Force HTTPS
                    .includeSubDomains(true)
                    .maxAgeInSeconds(31536000)
            )
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS) // JWT: no sessions
            )
            .csrf(csrf -> csrf.disable()) // Disabled when using JWT (no cookies)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            );
        return http.build();
    }
    */
}

// Resource-level authorization check
class OrderController {
    public Order getOrder(String orderId, String authenticatedUserId) {
        Order order = orderRepository.findById(orderId);

        // ❌ Wrong: only checking authentication (IDOR — Insecure Direct Object Reference)
        // return order;

        // ✅ Right: check ownership too
        if (!order.getCustomerId().equals(authenticatedUserId)) {
            throw new AccessDeniedException("You don't own this order");
        }
        return order;
    }
}
```

---

## ⚠️ Common Mistakes
- Checking role but not resource ownership (IDOR vulnerability)
- Storing JWT in localStorage (XSS can steal it — use httpOnly cookies instead)
- Logging sensitive data (passwords, tokens, PII) — mask in logs
- Using `alg: HS256` with weak secrets — use RS256 (asymmetric) in production

---

## 🔄 Follow-up Questions
1. **What is OAuth 2.0 and how does it differ from OpenID Connect?** (OAuth 2.0: authorization delegation — let Google/GitHub access check who you are. OIDC: adds identity layer on top of OAuth — provides ID token with user info.)
2. **What is CORS and how do you configure it properly?** (Cross-Origin Resource Sharing: browser blocks cross-origin requests unless server permits via `Access-Control-Allow-Origin` headers. Never use `*` for APIs with credentials.)
3. **What is a timing attack and how does it affect password comparison?** (Fixed-time string comparison must be used — `MessageDigest.isEqual(hash1, hash2)` in Java — not `equals()` which short-circuits on first mismatch leaking timing information.)
