---
title: "HTTP, HTTPS, and TLS Deep Dive"
date: 2024-04-04
draft: false
weight: 2
---

# 🧩 Question: Walk me through what happens when a browser navigates to https://www.amazon.com — from DNS resolution to TLS handshake to rendering the first byte. Focus on latency at each step.

## 🎯 What the interviewer is testing
- DNS resolution and caching hierarchy
- TCP handshake and TLS negotiation
- HTTP/1.1 vs HTTP/2 vs HTTP/3 differences
- Performance optimization: CDN, preconnect, HSTS

---

## 🧠 Deep Explanation

### 1. Full Journey: URL to First Byte

```
1. Browser Cache → (instant)
2. DNS Lookup → (1-100ms depending on cache level)
3. TCP Connect → (1 RTT = network latency)
4. TLS Handshake → (1-2 RTTs for TLS 1.2; 1 RTT TLS 1.3)
5. HTTP Request → (1 RTT + server processing)
6. HTTP Response → (size / bandwidth)
```

### 2. DNS Resolution Hierarchy

```
Browser DNS cache → (instant)
OS DNS cache (nscd) → (instant)
Router cache → (sub-ms, LAN)
ISP Recursive Resolver → (1-5ms)
Root DNS servers → (30-50ms)
TLD servers (.com) → (20-40ms)
Amazon's Authoritative DNS → (10-20ms)
```

Result held in browser cache for TTL seconds (Amazon sets low TTL ~60s for fast CDN failover).

### 3. TLS 1.2 vs TLS 1.3 Handshake

**TLS 1.2**: 2 RTTs before data
```
Client → Server: ClientHello (supported ciphers, TLS version)
Server → Client: ServerHello + Certificate + ServerKeyExchange + ServerHelloDone
Client → Server: ClientKeyExchange + ChangeCipherSpec + Finished
Server → Client: ChangeCipherSpec + Finished (encrypted)
[DATA STARTS — after 2 RTTs]
```

**TLS 1.3**: 1 RTT (or 0-RTT for resumption)
```
Client → Server: ClientHello + KeyShare (Diffie-Hellman params)
Server → Client: ServerHello + KeyShare + EncryptedExtensions + Certificate + Finished
[Client sends data immediately alongside its Finished]
```

### 4. HTTP Versions Compared

| Feature | HTTP/1.1 | HTTP/2 | HTTP/3 |
|---|---|---|---|
| Transport | TCP | TCP | UDP (QUIC) |
| Multiplexing | No (6 connections) | Yes (1 connection) | Yes (per-stream) |
| HoL Blocking | Yes | Yes (TCP level) | No |
| Header Compression | No | HPACK | QPACK |
| Server Push | No | Yes | Yes |
| 0-RTT | No | No | Yes |

### 5. Performance Optimizations

- **CDN**: Serve static assets from edge nodes within 10ms of the user
- **HSTS (HTTP Strict Transport Security)**: Browser caches "always HTTPS" → avoids HTTP redirect on repeat visits
- **DNS Prefetch**: `<link rel="dns-prefetch" href="//cdn.amazon.com">` — resolves DNS before needed
- **Preconnect**: `<link rel="preconnect" href="//checkout.amazon.com">` — full TCP+TLS warmup before needed
- **Keep-Alive**: Reuse TCP connections across HTTP requests (default in HTTP/1.1+)

---

## ✅ Ideal Answer

Walk through each step mentioning:
1. DNS: check caches first; full resolution is 50-150ms from scratch.
2. TCP: 3-way handshake; 1 RTT cost.
3. TLS 1.3: 1 RTT; TLS 1.2 = 2 RTTs.
4. Total "cold start" cost: >300ms before first byte.
5. "Warm" (cached DNS, existing connection): <20ms.
6. CDN reduces RTT by 80% by getting data from 10ms away instead of 100ms.

---

## 💻 Java Code (HTTPS Client)

```java
import java.net.http.*;
import java.net.*;
import java.time.*;

/**
 * Modern Java HTTP/2 client — connection reuse built in
 */
public class HttpsDemo {

    private static final HttpClient CLIENT = HttpClient.newBuilder()
        .version(HttpClient.Version.HTTP_2)          // Prefer HTTP/2
        .connectTimeout(Duration.ofSeconds(5))
        .followRedirects(HttpClient.Redirect.NORMAL) // Follow 301/302
        .build();

    public static String fetch(String url) throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(url))
            .header("Accept-Encoding", "gzip, br") // Compression
            .timeout(Duration.ofSeconds(10))
            .GET()
            .build();

        HttpResponse<String> response = CLIENT.send(
            request, HttpResponse.BodyHandlers.ofString()
        );

        System.out.printf("Status: %d | Protocol: %s%n",
            response.statusCode(), response.version());
        return response.body();
    }

    // For concurrent requests — shares one connection pool
    public static void fetchAll(List<String> urls) {
        var futures = urls.stream()
            .map(url -> CLIENT.sendAsync(
                HttpRequest.newBuilder().uri(URI.create(url)).GET().build(),
                HttpResponse.BodyHandlers.ofString()
            ))
            .toList();

        futures.forEach(f -> f.thenAccept(r ->
            System.out.printf("Got %d bytes from %s%n",
                r.body().length(), r.uri())));

        futures.forEach(java.util.concurrent.CompletableFuture::join);
    }
}
```

---

## ⚠️ Common Mistakes
- Forgetting TLS handshake cost when estimating cold-start latency
- Not knowing that HTTP/2 over TCP still suffers from HoL blocking (only HTTP/3/QUIC fixes it)
- Thinking HTTPS is significantly slower — with TLS 1.3 + session resumption, overhead is <5ms
- Missing that `301 Moved Permanently` is cached by browsers but `302 Found` is not

---

## 🔄 Follow-up Questions
1. **What is Perfect Forward Secrecy (PFS) and how does TLS 1.3 enforce it?** (PFS: compromising the server's private key doesn't expose past sessions. TLS 1.3 mandates ECDHE — ephemeral Diffie-Hellman — no static RSA key exchange.)
2. **Explain the difference between symmetric and asymmetric encryption in TLS.** (Asymmetric used for key exchange; symmetric for the actual data stream. RSA/ECDSA for auth; AES-GCM for session encryption.)
3. **What is certificate pinning?** (Client hardcodes expected certificate or public key; rejects connections if the certificate changes — protects against CA compromises.)
