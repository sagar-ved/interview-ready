---
author: "sagar ved"
title: "Operating Systems: I/O Models (Blocking, Non-Blocking, Async)"
date: 2024-04-04
draft: false
weight: 5
---

# 🧩 Question: Explain the difference between blocking I/O, non-blocking I/O, and asynchronous I/O. How does this relate to Java's NIO, Spring WebFlux, and Node.js's event loop?

## 🎯 What the interviewer is testing
- OS I/O models from the kernel perspective
- Thread-per-request vs event-loop model
- Java NIO internals (Selector, Channel, Buffer)
- Reactive vs Imperative programming trade-offs

---

## 🧠 Deep Explanation

### 1. Five I/O Models (Richard Stevens)

**1. Blocking I/O (BIO)**
- Thread calls `read()` → kernel waits for data → returns to thread
- Thread is suspended during the wait
- Simple model; 1 thread per connection

**2. Non-Blocking I/O**
- `read()` returns immediately with `EAGAIN` if no data
- Thread must poll repeatedly (busy-waiting) — CPU wasteful

**3. I/O Multiplexing (select, poll, epoll)**
- Thread calls `select(fd_set)` → blocks until ONE of many FDs is ready
- `epoll` (Linux): O(1) scaling; used by Nginx, Redis, Node.js
- This is the foundation of the **event loop**

**4. Signal-Driven I/O (SIGIO)**
- Kernel sends signal when I/O is ready; rarely used in practice

**5. Asynchronous I/O (aio_read)**
- Thread makes request, continues; kernel calls back when TRANSFER IS COMPLETE
- True async — no blocking at any point
- Windows IOCP; Linux io_uring (recent)

### 2. Java NIO (I/O Multiplexing)

Java NIO uses `Selector` (wraps `epoll`/`kqueue`):
- **Channel**: Non-blocking I/O source/sink (SocketChannel, FileChannel)
- **Buffer**: Typed byte containers (ByteBuffer)
- **Selector**: Monitors multiple channels for readiness events

### 3. Green Thread / Virtual Thread Model

Java 21 virtual threads make blocking code behave like async code by:
- Running on carrier OS threads
- Unmounting the virtual thread from the carrier when it blocks on I/O
- Mounting back when I/O completes

This eliminates the need for callback hell or reactive programming for most use cases.

---

## ✅ Ideal Answer

- **Blocking**: 1 thread per connection — simple but limits concurrency to thread count.
- **NIO/Event-Loop**: 1 thread handles many connections via `epoll`/`select` — great for many idle connections (WebSocket servers, chat apps).
- **WebFlux**: Spring's reactive stack built on Project Reactor + Netty — uses non-blocking I/O; no blocking allowed inside reactive pipelines.
- **Virtual Threads (Java 21)**: Best of both worlds — blocking code semantics, non-blocking OS behavior.

---

## 💻 Java Code

```java
import java.io.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;
import java.util.*;

/**
 * Non-blocking NIO Server using Selector (epoll-based)
 */
public class NioEchoServer {

    public static void main(String[] args) throws IOException {
        Selector selector = Selector.open();
        ServerSocketChannel serverChannel = ServerSocketChannel.open();
        serverChannel.bind(new InetSocketAddress(8080));
        serverChannel.configureBlocking(false); // Non-blocking mode

        // Register for ACCEPT events
        serverChannel.register(selector, SelectionKey.OP_ACCEPT);
        System.out.println("NIO Server started on port 8080");

        ByteBuffer buffer = ByteBuffer.allocate(1024);

        while (true) {
            selector.select(); // Blocks until at least one channel is ready (epoll_wait)

            Iterator<SelectionKey> keys = selector.selectedKeys().iterator();
            while (keys.hasNext()) {
                SelectionKey key = keys.next();
                keys.remove();

                if (key.isAcceptable()) {
                    // New connection
                    SocketChannel client = serverChannel.accept();
                    client.configureBlocking(false);
                    client.register(selector, SelectionKey.OP_READ);
                    System.out.println("New client: " + client.getRemoteAddress());

                } else if (key.isReadable()) {
                    // Data ready to read
                    SocketChannel client = (SocketChannel) key.channel();
                    buffer.clear();
                    int read = client.read(buffer);
                    if (read == -1) {
                        client.close(); // Client disconnected
                    } else {
                        buffer.flip();
                        client.write(buffer); // Echo back
                    }
                }
            }
        }
    }
}

/**
 * Comparison: Virtual Thread Server (Java 21) — simpler blocking code
 */
class VirtualThreadServer {
    public static void main(String[] args) throws IOException {
        try (var serverSocket = new ServerSocket(8081)) {
            System.out.println("Virtual Thread Server on port 8081");
            while (true) {
                var client = serverSocket.accept(); // Each accept creates a virtual thread
                Thread.ofVirtual().start(() -> handleClient(client));
            }
        }
    }

    static void handleClient(Socket socket) {
        try (socket;
             var in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
             var out = new PrintWriter(socket.getOutputStream(), true)) {
            String line;
            while ((line = in.readLine()) != null) { // Blocking — but virtual thread awaits, not OS thread
                out.println("Echo: " + line);
            }
        } catch (IOException e) { /* handle */ }
    }
}
```

---

## ⚠️ Common Mistakes
- Thinking NIO is async I/O — it's I/O multiplexing (the read/write still happens in the thread)
- Mixing blocking operations inside Spring WebFlux pipelines (blocks the event-loop thread → cascade failure)
- Using `Selector` when simpler thread-per-request (virtual threads) achieves the same throughput with simpler code
- Forgetting to close channels — `SelectionKey.cancel()` and `Channel.close()` must be called explicitly

---

## 🔄 Follow-up Questions
1. **What is `epoll` and why is it O(1) vs `select`'s O(n)?** (`select` scans all registered file descriptors; `epoll` uses a kernel-side event list — only ready FDs returned.)
2. **How does Netty use NIO?** (Boss thread accepts connections; worker threads handle I/O; pipeline of ChannelHandlers — read → decode → process → encode → write.)
3. **What is `io_uring` and why is it faster than `epoll`?** (Shared ring buffer between kernel and user space — zero-copy, zero-syscall-overhead for bulk I/O; used in io_uring-backed file/network access.)
