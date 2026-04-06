---
author: "sagar ved"
title: "DNS: Resolution, Types, and CDN"
date: 2024-04-04
draft: false
weight: 4
---

# 🧩 Question: What is DNS and how does resolution work? Explain different DNS record types. How does a CDN use DNS to route users to the nearest edge server?

## 🎯 What the interviewer is testing
- DNS resolution hierarchy (recursive vs authoritative)
- DNS record types and their purposes
- Anycast routing via DNS
- CDN architecture and edge server selection

---

## 🧠 Deep Explanation

### 1. DNS Resolution Flow

```
Browser → OS Cache → DNS Stub Resolver → ISP Recursive Resolver
    ↓ cache miss at each level
ISP Resolver → Root DNS (.) → TLD DNS (.com) → Authoritative DNS (amazon.com)
    ↓ returns A record (IP address)
Back to browser — connects to IP
```

**TTL**: Each response has a TTL (Time To Live). After TTL expires, resolver re-queries.

### 2. DNS Record Types

| Record | Purpose | Example |
|---|---|---|
| **A** | IPv4 address | api.example.com → 192.168.1.1 |
| **AAAA** | IPv6 address | api.example.com → 2001:db8::1 |
| **CNAME** | Alias to another name | www → example.com |
| **MX** | Mail server | example.com → mail.example.com |
| **NS** | Name server | example.com → ns1.cloudflare.com |
| **TXT** | Arbitrary text | SPF, DKIM, domain verification |
| **SRV** | Service location + port | _http._tcp.example.com |
| **PTR** | Reverse DNS (IP → name) | 1.1.168.192.in-addr.arpa → host |
| **SOA** | Start of Authority | Primary NS + admin email |

### 3. CDN DNS-based Routing

CDNs use **Anycast** + **GeoDNS** to route users to the nearest edge:

1. User resolves `cdn.example.com`
2. Authoritative DNS (e.g., Cloudflare) checks the client's IP via **EDNS Client Subnet**
3. Returns an A record pointing to the **nearest CDN edge PoP** (Point of Presence)
4. User's traffic goes to the local edge, not the origin server

**Anycast**: Same IP advertised from multiple locations; BGP routes to the numerically closest.

### 4. DNS Negative Caching

When a domain doesn't exist, NXDOMAIN response is cached for the SOA's negative TTL. This can cause issues if you just provisioned a new domain and the resolver has cached the NXDOMAIN.

---

## ✅ Ideal Answer

- DNS is a hierarchical, distributed system for translating domain names to IP addresses.
- Recursive resolver does the work; authoritative DNS has the final answer.
- CDNs use GeoDNS + Anycast: return edge IP geographically closest to the client.
- **Short TTL** (30-60s) for CDNs enables fast failover; **long TTL** (3600s) reduces DNS lookups.
- Key records: A (IPv4), CNAME (alias), MX (mail), TXT (verification/SPF).

---

## 💻 Java Code (DNS Lookup)

```java
import java.net.*;
import java.util.*;

/**
 * Programmatic DNS lookups in Java
 */
public class DnsDemo {

    public static void main(String[] args) throws UnknownHostException {
        String hostname = "www.google.com";

        // Simple hostname → IP resolution (uses OS resolver chain)
        InetAddress address = InetAddress.getByName(hostname);
        System.out.println("IP: " + address.getHostAddress());

        // All IP addresses (returns multiple for load-balanced services)
        InetAddress[] allIPs = InetAddress.getAllByName(hostname);
        System.out.println("All IPs for " + hostname + ":");
        for (InetAddress ip : allIPs) {
            System.out.println("  " + ip.getHostAddress());
        }

        // Reverse DNS lookup (IP → hostname)
        InetAddress ip = InetAddress.getByName("8.8.8.8");
        System.out.println("Reverse DNS: " + ip.getHostName());

        // Custom resolver using DNSJAVA library (for SRV, TXT lookups not in JDK)
        // Resolver lookup = new SimpleResolver("8.8.8.8");
        // Lookup l = new Lookup("_http._tcp.example.com", Type.SRV);
        // Record[] records = l.run();
    }
}

/**
 * Service discovery using DNS-SD (DNS Service Discovery)
 * Used in Kubernetes (CoreDNS), Consul, Envoy
 */
class ServiceDiscovery {
    // In Kubernetes: my-service.my-namespace.svc.cluster.local → ClusterIP
    // CoreDNS resolves this within the cluster
    
    public static String buildServiceUrl(String service, String namespace) {
        return String.format("http://%s.%s.svc.cluster.local", service, namespace);
        // Result: http://payment-service.prod.svc.cluster.local
    }
}
```

---

## ⚠️ Common Mistakes
- Not knowing that CNAME cannot coexist with other records at a domain root — use ALIAS/ANAME records (Cloudflare) or A records directly
- Confusing TTL for resolvers vs browsers (browser DNS caches are separate and shorter-lived)
- Setting very long TTLs preventing fast failover during outages
- Not implementing DNS-SF (`rndc flush` equivalent) for test environments — old resolver caches NXDOMAIN

---

## 🔄 Follow-up Questions
1. **What is DNSSEC and why isn't it universally deployed?** (Signs DNS responses cryptographically; prevents DNS cache poisoning. Not universal due to complexity and lack of client validation support historically.)
2. **How does Kubernetes DNS work?** (CoreDNS resolves service names within cluster using DNS rules; Pods query CoreDNS at a known IP; services registered automatically.)
3. **What is DNS over HTTPS (DoH) and why is it controversial?** (Encrypts DNS queries in HTTPS traffic; prevents ISP snooping but bypasses network-level DNS filtering; criticized for centralizing DNS to few resolvers.)
