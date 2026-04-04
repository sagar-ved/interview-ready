---
title: "TCP vs UDP: Internals, Use Cases, and Trade-offs"
date: 2024-04-04
draft: false
weight: 1
---

# 🧩 Question: Explain why HTTP/3 switched from TCP to UDP (QUIC). What specific TCP limitations does QUIC address, and when should you choose UDP over TCP in your application design?

## 🎯 What the interviewer is testing
- TCP connection lifecycle (3-way handshake, 4-way termination)
- TCP flow control and congestion control
- Head-of-line blocking problem
- QUIC protocol design philosophy

---

## 🧠 Deep Explanation

### 1. TCP vs UDP: Core Comparison

| Feature | TCP | UDP |
|---|---|---|
| Connection | 3-way handshake | Connectionless |
| Delivery | Guaranteed | Best-effort |
| Ordering | In-order delivery | No ordering |
| Flow Control | Yes (sliding window) | No |
| Congestion Control | Yes (AIMD) | No |
| Overhead | ~20 bytes/segment | ~8 bytes/datagram |
| Use Cases | HTTP, SSH, SMTP | DNS, VoIP, Gaming, QUIC |

### 2. TCP's 3-Way Handshake

```
Client → Server: SYN (seq=x)
Server → Client: SYN-ACK (seq=y, ack=x+1)
Client → Server: ACK (ack=y+1)
[Connection Established]
```

**Latency Cost**: 1.5 RTT before first byte of data (or 1 RTT with TLS resumption). For HTTPS that's 3.5 RTT traditionally.

### 3. TCP's Head-of-Line Blocking

TCP guarantees in-order delivery at the transport layer. In HTTP/2:
- Multiplexes multiple streams over one TCP connection (vs HTTP/1.1: one request per connection)
- BUT if one TCP segment is lost, ALL streams blocked waiting for retransmission
- **This is Head-of-Line Blocking at the TCP level** — HTTP/2's killer problem

### 4. QUIC (Quick UDP Internet Connections) — HTTP/3

QUIC is built on UDP and implements its own:
- **Reliable delivery** (per-stream ACKs, not per-connection)
- **Stream multiplexing** without HoL blocking (lost packet only stalls ITS stream)
- **0-RTT connection establishment** (with session resumption)
- **Connection migration** (change IP/port without reconnection — important for mobile)
- **Integrated TLS 1.3** (encryption baked in, not layered on top)

### 5. When to Use UDP in Application Design

| Use Case | Why UDP |
|---|---|
| DNS lookups | Single request-response; retry at app level |
| VoIP / Video calls | Real-time; old frames useless; jitter > latency |
| Online gaming | Fast state updates; latest state > missed state |
| Live streaming | Can skip dropped frames; no point in rebuffering old data |
| TFTP, NTP | Simple protocol; app handles reliability |
| Multicast | TCP doesn't support one-to-many; UDP does |

---

## ✅ Ideal Answer

- **TCP**: Reliable, ordered, connection-oriented. Best for HTTP, email, file transfers where every byte matters.
- **UDP**: Fast, stateless, no ordering. Best for real-time where stale data is worthless.
- **HTTP/3 (QUIC)**: Uses UDP to eliminate TCP's HoL blocking. Each HTTP stream has independent reliability. 0-RTT reduces handshake latency. Encrypted by default.
- **Design consideration**: For custom protocols, use TCP for correctness-critical data; UDP for latency-critical with application-level reliability (like QUIC/WebRTC do).

---

## 💻 Java Code

```java
import java.net.*;
import java.io.*;

/**
 * UDP: Simple time server (no connection overhead)
 */
public class UDPTimeServer {

    public static void startServer(int port) throws IOException {
        try (DatagramSocket socket = new DatagramSocket(port)) {
            byte[] buf = new byte[256];
            System.out.println("UDP Time Server started on port " + port);

            while (true) {
                DatagramPacket request = new DatagramPacket(buf, buf.length);
                socket.receive(request); // Blocking: wait for incoming datagram

                String response = String.valueOf(System.currentTimeMillis());
                byte[] responseBytes = response.getBytes();

                // Send response back to the client's address/port from the packet
                DatagramPacket reply = new DatagramPacket(
                    responseBytes, responseBytes.length,
                    request.getAddress(), request.getPort()
                );
                socket.send(reply); // No ACK, no guarantee
            }
        }
    }

    public static String queryServer(String host, int port) throws IOException {
        try (DatagramSocket socket = new DatagramSocket()) {
            socket.setSoTimeout(2000); // Timeout: application-level reliability
            byte[] buf = "TIME".getBytes();
            DatagramPacket request = new DatagramPacket(buf, buf.length, InetAddress.getByName(host), port);
            socket.send(request);

            byte[] responseBuf = new byte[256];
            DatagramPacket response = new DatagramPacket(responseBuf, responseBuf.length);
            socket.receive(response); // Timeout if no response (app-level retry)
            return new String(response.getData(), 0, response.getLength());
        }
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking UDP means "unreliable" — QUIC/WebRTC add reliability on top of UDP
- Forgetting 3-way handshake cost (TLS 1.3 adds 1 more RTT, so HTTP/2=3.5RTT, HTTP/3=1RTT with 0-RTT resumption)
- Using TCP for real-time games — even with low latency TCP, HoL blocking creates "jitter spikes"
- Not implementing timeout + retry for UDP clients — they'll hang forever waiting

---

## 🔄 Follow-up Questions
1. **What is Nagle's Algorithm in TCP?** (Buffers small packets until ACK received or buffer full — reduces network overhead but adds latency for interactive apps; disable with `TCP_NODELAY`.)
2. **Explain TCP congestion control (AIMD).** (Slow Start: double window each RTT until threshold. Additive Increase: +1 MSS per RTT. Multiplicative Decrease: halve window on packet loss.)
3. **What is SCTP and how does it improve on both TCP and UDP?** (Stream Control Transmission Protocol: reliable, ordered, multi-stream, multi-homing — used in telecom the 5G core.)
