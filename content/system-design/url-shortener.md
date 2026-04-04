---
title: "URL Shortener Design"
date: 2024-04-04
draft: false
---

# System Design: URL Shortener (TinyURL)

## 📌 Question
How would you design a scalable URL shortening service?

## 🎯 What is being tested
- Choosing between Base62 and Base10+ hashing.
- Understanding of read-heavy systems and caching.
- Conflict resolution in shortened URLs.
- Database scaling (SQL vs NoSQL).

## 🧠 Explanation
A URL shortener converts a long URL into a short, manageable alias. The core components include a generation service, a redirection service, and a storage layer.

**Key tradeoffs**:
- **Hashing (e.g., MD5)**: Fast but leads to collisions.
- **Base62 Encoding**: Convert a unique ID to a 7-character string.

## ✅ Ideal Answer
Start with functional (shorten, redirect) and non-functional (high availability, low latency) requirements. Calculate read/write traffic estimates. Scale by adding a cache (Redis) and partitioning the database (by hash or ID range).

## 💻 Code Example (Base62 Java)
```java
public class Base62 {
    private static final String ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    public String encode(long num) {
        StringBuilder sb = new StringBuilder();
        while (num > 0) {
            sb.append(ALPHABET.charAt((int) (num % 62)));
            num /= 62;
        }
        return sb.reverse().toString();
    }
}
```

## ⚠️ Common Mistakes
- Not mentioning redirects (HTTP 301 vs 302).
- Ignoring read/write traffic mismatch (read-heavy).

## 🔄 Follow-ups
- How to handle analytics (Click tracking)?
- What is the difference between 301 (Permanent) and 302 (Found) redirects?
