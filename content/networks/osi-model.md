---
title: "OSI Model and TCP/IP Stack"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Walk me through the OSI layers. At which layer does a TCP SYN happen? What does a load balancer modify, and what does a CDN cache? Explain how data is encapsulated as it travels from application to wire.

## 🎯 What the interviewer is testing
- OSI model layer responsibilities
- Encapsulation: headers added at each layer
- What operates at which layer (L4 vs L7 LB, NAT, firewalls)
- Practical "at which layer" questions

---

## 🧠 Deep Explanation

### 1. OSI Layers (Mnemonic: "Please Do Not Throw Sausage Pizza Away")

| Layer | Name | Protocol Examples | What it does |
|---|---|---|---|
| 7 | Application | HTTP, SMTP, DNS, FTP | User-facing data; application protocols |
| 6 | Presentation | TLS/SSL, gzip, JPEG | Encoding, encryption, compression |
| 5 | Session | NetBIOS, RPC | Session management (rarely mentioned today) |
| 4 | Transport | TCP, UDP, SCTP | End-to-end delivery; ports; flow control |
| 3 | Network | IP, ICMP, OSPF, BGP | Logical addressing; routing (IP headers) |
| 2 | Data Link | Ethernet, Wi-Fi, ARP | MAC addressing; frame delivery on local network |
| 1 | Physical | Fiber, coax, RJ45, wireless | Bits on the wire |

### 2. Encapsulation

Each layer adds its header (and trailer) around the data:

```
[HTTP Data]                                    ← Layer 7
[TLS Header | HTTP Data | TLS Trailer]         ← Layer 6
[TCP Header | TLS+HTTP Data]                   ← Layer 4 (segment)
[IP Header | TCP Segment]                      ← Layer 3 (packet)
[Ethernet Header | IP Packet | Ethernet FCS]   ← Layer 2 (frame)
[Bits on wire]                                 ← Layer 1
```

At the receiver, each layer strips its header and passes data up.

### 3. What Operates at Each Layer

| Device/System | Layer |
|---|---|
| L4 Load Balancer (AWS NLB) | 4 (Transport) — routes on TCP/UDP port |
| L7 Load Balancer (Nginx/ALB) | 7 (Application) — reads HTTP headers, URL |
| Router | 3 (Network) — IP routing |
| Switch | 2 (Data Link) — MAC table lookup |
| Repeater/Hub | 1 (Physical) |
| Firewall (network) | 3-4 (IP/Port based) |
| WAF (Web App Firewall) | 7 (HTTP content) |
| CDN | 7 (HTTP caching) |
| NAT gateway | 3-4 (modifies IP + port) |

### 4. TCP SYN is Layer 4

TCP SYN is a **Transport Layer (Layer 4)** concept. The SYN flag is in the TCP header.

At Layer 3 (IP), the packet just knows source/dest IP. At Layer 4, TCP adds port, sequence numbers, flags (SYN, ACK, FIN, RST).

---

## ✅ Ideal Answer

- TCP SYN: Layer 4 (Transport). The SYN flag is a TCP header field.
- L4 LB: Reads IP + port → routes to backend server; modifies destination IP.
- L7 LB: Reads HTTP headers/URL → routes by content; can modify headers.
- CDN: Layer 7 — caches HTTP responses at edge.
- Encapsulation: data is wrapped with headers at each layer going down; unwrapped going up at receiver.

---

## 💻 Java Code (Reading Network Stack Info)

```java
import java.net.*;
import java.util.*;

public class NetworkStackDemo {

    public static void main(String[] args) throws Exception {

        // Get all network interfaces (Layer 2 — MAC addresses)
        Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
        while (interfaces.hasMoreElements()) {
            NetworkInterface ni = interfaces.nextElement();
            byte[] mac = ni.getHardwareAddress();
            if (mac != null) {
                System.out.printf("Interface: %-15s MAC: %s%n",
                    ni.getName(), formatMAC(mac));
            }

            // Layer 3 — IP addresses
            ni.getInetAddresses().asIterator().forEachRemaining(ip -> {
                System.out.printf("  IP: %s%n", ip.getHostAddress());
            });
        }

        // DNS Resolution (Layer 7 → Layer 3)
        InetAddress host = InetAddress.getByName("google.com");
        System.out.println("\ngoogle.com resolves to: " + host.getHostAddress());

        // TCP connection (Layer 4 + Layer 3 + Layer 2 all used automatically)
        try (Socket socket = new Socket("google.com", 80)) { // TCP SYN happens here
            System.out.println("Connected from local port: " + socket.getLocalPort());
            System.out.println("Connected to remote port: " + socket.getPort());
        }
    }

    private static String formatMAC(byte[] mac) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < mac.length; i++) {
            sb.append(String.format("%02X%s", mac[i], i < mac.length - 1 ? ":" : ""));
        }
        return sb.toString();
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking TLS is Layer 7 (it's Layer 6 — Presentation, though TCP/IP model merges 5+6+7)
- Confusing Layer 2 switching (MAC) with Layer 3 routing (IP)
- Saying "CDN operates at Layer 4" — CDNs cache and route at Layer 7 (HTTP)
- Forgetting that NAT operates at Layers 3 AND 4 (modifies both IP and port)

---

## 🔄 Follow-up Questions
1. **What is ARP and at which layer does it operate?** (Address Resolution Protocol: maps IP → MAC; operates between Layer 2 and 3 — sometimes called Layer 2.5.)
2. **How does VLAN work?** (Virtual LAN: Ethernet frames tagged with VLAN ID (Layer 2); separates broadcast domains on the same physical switch.)
3. **What is the difference between TCP/IP model and OSI model?** (TCP/IP has 4 layers: Application, Transport, Internet, Network Access. OSI has 7 for more granular conceptual clarity.)
